require Logger

defmodule Rpcs.Application do
  use Application

  @impl true
  def start(_type, _args) do
    Logger.info("app starting...")

    environment = Application.get_env(:rpcs, :environment)

    children = [
      {Rpcs.DirLoad, [environment.network_url, environment.input_dir]}
    ]

    Supervisor.start_link(children, [strategy: :one_for_one])
  end
end
