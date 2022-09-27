defmodule Rpcs.DirLoad do
  require Logger
  use GenServer

  def start_link(state) do
    GenServer.start(__MODULE__, state, name: __MODULE__)
  end

  def init(_state) do
    Logger.info("directory loader starting...")

    input_dir = Application.get_env(:rpcs, :environment).input_dir

    input_dir_abs_path = Path.expand(input_dir)

    template_distinguisher = fn path ->
      List.last(path) |> String.starts_with?("template")
    end

    load_case = fn (base_path, file_path) ->
      request_path  = Path.join([base_path, "request"  | file_path])
      response_path = Path.join([base_path, "response" | file_path])
      with {:ok, request_bin}  <- File.read(request_path),
           {:ok, request}      <- Jason.decode(request_bin),
           {:ok, response_bin} <- File.read(response_path),
           {:ok, response}     <- Jason.decode(response_bin)
      do
        {
          :ok, %{
            path: file_path,
            request: request,
            response: response
          }
        }
      else
        {:error, reason} -> {
          :error, %{
            path: file_path,
            reason: reason
          }
        }
      end
    end

    {_templates, directs} = input_dir_abs_path
    |> Path.join("/request/**/**.json")
    |> Path.wildcard
    |> Enum.map(&Path.relative_to(&1, Path.join(input_dir_abs_path, "request")))
    |> Enum.map(&String.split(&1, ~r[/]))
    |> Enum.split_with(fn r -> template_distinguisher.(r) end)

    cases = Enum.map(directs, fn casee -> load_case.(input_dir_abs_path, casee) end)

    Logger.info("directory loader started")

    {:ok, cases}
  end

  def handle_call(:cases, _from, state) do
    {:reply, state, state}
  end
end
