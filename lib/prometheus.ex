defmodule Rpcs.Metrics do
  def emit_health_ok() do
    :telemetry.execute([:network], %{health: 1})
    :telemetry.execute([:network, :health, :timestamp], %{seconds: now()})
  end

  def emit_health_down() do
    :telemetry.execute([:network], %{health: 0})
    :telemetry.execute([:network, :health, :timestamp], %{seconds: now()})
  end

  defp now, do: :os.system_time(:seconds)
end

defmodule Rpcs.Telemetry do
  use Supervisor
  import Telemetry.Metrics

  def start_link(arg) do
    Supervisor.start_link(__MODULE__, arg, name: __MODULE__)
  end

  def init(_arg) do
    metrics = [
      last_value("network.health"),
      last_value("network.health.timestamp.seconds")
    ]

    children = [
      {TelemetryMetricsPrometheus, metrics: metrics}
    ]

    Supervisor.init(children, strategy: :one_for_one)
  end
end
