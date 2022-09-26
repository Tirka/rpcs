defmodule Rpcs.DirLoad do
  require Logger
  use GenServer

  def start_link(state) do
    GenServer.start(__MODULE__, state, name: __MODULE__)
  end

  def init(state) do
    Logger.info("directory loader starting...")

    [input_dir] = state

    files = input_dir
    |> Path.join("*.json")
    |> Path.wildcard

    jsons = files
    |> Enum.map(&File.read!/1)
    |> Enum.map(&Jason.decode!/1)

    IO.inspect Enum.zip(files, jsons)

    Logger.info("directory loader started")
    {:ok, %{}}
  end
end
