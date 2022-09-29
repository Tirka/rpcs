defmodule Rpcs.UI do
  import Plug.Conn

  def init(options) do
    options
  end

  def call(conn, _opts) do
    network_url = Application.get_env(:rpcs, :env).network_url

    cases = GenServer.call(Rpcs.DirLoad, :cases)

    do_test = fn (network_url, %{path: path, request: request, response: expected}) ->
      headers = [{"Content-Type", "application/json"}]
      response = HTTPoison.post!(network_url, Jason.encode!(request), headers)
      actual = Jason.decode! response.body

      %{
        path: path,
        request: request,
        response: %{
          expected: expected,
          actual: actual
        },
        success: expected == actual
      }
    end

    cases = List.flatten Enum.map(cases, fn
      {:ok, casee} -> [casee]
      {:error, _} -> []
    end)

    cases = Enum.map(cases, fn c -> do_test.(network_url, c) end)

    conn
    |> put_resp_content_type("text/html")
    |> send_resp(200, EEx.eval_file("./html/index.heex", cases: cases))
  end
end