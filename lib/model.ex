defmodule Rpcs.Model do
  def read_input(_input_dir) do
    input_dir = "/home/maksimv/Desktop/rpcs/input"

    # or /request/**/**.json
    requests = Path.wildcard Path.join(input_dir, "/request/**/**.json")

    resq = hd(requests)
    # Enum.map(requests, fn r -> end)

    IO.inspect requests

    # jsons = requests
    # |> Enum.map(&File.read!/1)
    # |> Enum.map(&Jason.decode!/1)
  end
end
