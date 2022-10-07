require OK

# iex(1)> Rpcs.Utils.do_network_test(%{path: "asd", request: %{"method"=>"eth_chainId","params"=>[],"id"=>1,"jsonrpc"=>"2.0"}, response: %{"id" => 1, "jsonrpc" => "2.0", "result" => "0x6a"}})
# iex(1)> Rpcs.Utils.load_case("/home/maksimv/Desktop/rpcs/input_mainnet", ["eth_chainId", "111.json"])

defmodule Rpcs.Utils do
  def load_case(base_path, file_path) do
    request_path  = Path.join([base_path, "request"  | file_path])
    response_path = Path.join([base_path, "response" | file_path])

    OK.for do
      request_bin <- File.read(request_path)
      request <- Jason.decode(request_bin)
      response_bin <- File.read(response_path)
      response <- Jason.decode(response_bin)
    after
      %{
        path: file_path,
        request: request,
        response: response
      }
    end
  end

  def do_read_input_dir do
    input_dir = Path.expand(Application.get_env(:rpcs, :env).input_dir)

    is_template? = fn path ->
      List.last(path) |> String.starts_with?("template")
    end

    {_templates, directs} = input_dir
    |> Path.join("/request/**/**.json")
    |> Path.wildcard
    |> Enum.map(&Path.relative_to(&1, Path.join(input_dir, "request")))
    |> Enum.map(&String.split(&1, ~r[/]))
    |> Enum.split_with(fn r -> is_template?.(r) end)

    Enum.map(directs, &load_case(input_dir, &1))
  end

  def do_network_test(%{path: path, request: request, response: expected}) do
    %{timeous_ms: timeous_ms, network_url: network_url} = Application.get_env(:rpcs, :env)
    headers = [{"Content-Type", "application/json"}]

    OK.for do
      req_start = :os.system_time()
      response <- HTTPoison.post(network_url, Jason.encode!(request), headers)
      req_end = :os.system_time()
      actual <- Jason.decode(response.body)
    after
      %{
        path: path,
        request: request,
        response: %{
          expected: expected,
          actual: actual
        },
        success: expected == actual && (req_end - req_start) < timeous_ms
      }
    end
  end
end
