defmodule Rpcs.DirLoad do
  require Logger
  use GenServer

  def start_link(state) do
    GenServer.start(__MODULE__, state, name: __MODULE__)
  end

  def init(_state) do
    cases = Rpcs.Utils.do_read_input_dir()

    good_cases = List.flatten Enum.map(cases, fn
      {:ok, casee} -> [casee]
      _ -> []
    end)

    bad_cases = List.flatten Enum.map(cases, fn
      {:error, casee} -> [casee]
      _ -> []
    end)

    if !Enum.empty?(bad_cases), do: Logger.warn("Can't read of parse some of test requests")

    {:ok, good_cases}
  end

  def handle_call(:cases, _from, state) do
    {:reply, state, state}
  end
end
