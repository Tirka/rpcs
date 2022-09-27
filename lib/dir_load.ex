defmodule Rpcs.DirLoad do
  require Logger
  use GenServer

  def start_link(state) do
    GenServer.start(__MODULE__, state, name: __MODULE__)
  end

  def init(state) do
    Logger.info("directory loader starting...")

    [network_url, input_dir] = state

    input_dir_abs_path = Path.expand(input_dir)

    template_distinguisher = fn path ->
      List.last(path) |> String.starts_with?("template")
    end

    concat_read_decode = fn (base, type, tail) ->
      Path.join([base, type | tail])
      |> File.read!
      |> Jason.decode!
    end

    case_reader = fn path ->
      request = concat_read_decode.(input_dir_abs_path, "request", path)
      response = concat_read_decode.(input_dir_abs_path, "response", path)

      %{
        path: path,
        request: request,
        response: response
      }
    end

    {_templates, directs} = input_dir_abs_path
    |> Path.join("/request/**/**.json")
    |> Path.wildcard
    |> Enum.map(&Path.relative_to(&1, Path.join(input_dir_abs_path, "request")))
    |> Enum.map(&String.split(&1, ~r[/]))
    |> Enum.split_with(fn r -> template_distinguisher.(r) end)

    cases = Enum.map(directs, fn d -> case_reader.(d) end)

    test_case = fn (network_url, casee) ->
      actual_response = HTTPoison.post!(network_url, Jason.encode!(casee.request), [{"Content-Type", "application/json"}])
      IO.inspect Jason.decode!(actual_response.body)
      IO.inspect casee.response
      Jason.decode!(actual_response.body) == casee.response
    end

    results = Enum.map(cases, fn c -> test_case.(network_url, c) end)

    IO.inspect results

    Logger.info("directory loader started")

    {:ok, cases}
  end
end
