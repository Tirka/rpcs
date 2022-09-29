require Logger

defmodule Rpcs.Application do
  use Application

  @impl true
  def start(_type, _args) do
    Logger.info("app starting...")

    children = [
      {Rpcs.DirLoad, []},
      {Rpcs.Telemetry, []},
      {Plug.Cowboy, scheme: :http, plug: Rpcs.UI, options: [port: 6868]}
    ]

    Supervisor.start_link(children, [strategy: :one_for_one])
  end
end
