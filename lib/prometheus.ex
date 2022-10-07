defmodule Rpcs.Metrics do
  def emit_health_ok() do
    :telemetry.execute([:network], %{health: 1})
    :telemetry.execute([:network, :health, :timestamp], %{seconds: now()})
  end

  def emit_health_down() do
    :telemetry.execute([:network], %{health: 0})
    :telemetry.execute([:network, :health, :timestamp], %{seconds: now()})
    :telemetry.execute([:network, :alarms], %{total: 1})
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
      counter("network.alarms.total", description: "Total amount of unsuccessful RPC check runs"),
      last_value("network.health.timestamp.seconds", description: "Last time RPC health check run"),
      last_value("network.health", description: "Last result of RPC health check")
    ]

    children = [
      {TelemetryMetricsPrometheus, metrics: metrics}
    ]

    Supervisor.init(children, strategy: :one_for_one)
  end
end
