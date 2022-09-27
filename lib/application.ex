require Logger

defmodule Rpcs.Application do
  use Application

  @impl true
  def start(_type, _args) do
    Logger.info("app starting...")

    children = [
      {Plug.Cowboy, scheme: :http, plug: Rpcs.Server, options: [port: 6868]},
      {Rpcs.DirLoad, []}
    ]

    Supervisor.start_link(children, [strategy: :one_for_one])
  end
end
