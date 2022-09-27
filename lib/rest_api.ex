defmodule Rpcs.Server do
  import Plug.Conn

  def init(options) do
    options
  end

  def call(conn, _opts) do
    network_url = Application.get_env(:rpcs, :environment).network_url

    cases = GenServer.call(Rpcs.DirLoad, :cases)

    do_test = fn (network_url, %{request: request, response: expected}) ->
      headers = [{"Content-Type", "application/json"}]
      response = HTTPoison.post!(network_url, Jason.encode!(request), headers)
      body = Jason.decode! response.body

      body == expected
    end

    cases = List.flatten Enum.map(cases, fn
      {:ok, casee} -> [casee]
      {:error, _} -> []
    end)

    _results = Enum.map(cases, fn c -> do_test.(network_url, c) end)

    IO.inspect _results

    conn
    |> put_resp_content_type("text/html")
    |> send_resp(200, EEx.eval_file("./eex/index.eex", cases: cases))
  end
end
