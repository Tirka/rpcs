import Rpcs.Utils

defmodule Rpcs.UI do
  import Plug.Conn

  def init(options) do
    options
  end

  def call(conn, _opts) do
    cases = GenServer.call(Rpcs.DirLoad, :cases)

    cases = Enum.map(cases, &do_network_test/1)

    cases = List.flatten Enum.map(cases, fn
      {:ok, casee} -> [casee]
      _ -> []
    end)

    _page = %{

    }

    conn
    |> put_resp_content_type("text/html")
    |> send_resp(200, EEx.eval_file("./html/index.heex", cases: cases))
  end
end
