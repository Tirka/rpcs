defmodule Rpcs.DirLoad do
  require Logger
  use GenServer

  def start_link(state) do
    GenServer.start(__MODULE__, state, name: __MODULE__)
  end

  def init(_state) do
    cases = Rpcs.Utils.do_read_input_dir()
    {:ok, cases}
  end

  def handle_call(:cases, _from, state) do
    {:reply, state, state}
  end
end
