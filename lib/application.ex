require Logger

defmodule Rpcs.Application do
  use Application

  @impl true
  def start(_type, _args) do
    Logger.info("app starting...")

    children = [
      {Rpcs.DirLoad, [Application.get_env(:rpcs, :input_dir)]}
    ]

    Supervisor.start_link(children, [strategy: :one_for_one])
  end
end
