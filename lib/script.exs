require Jason

input_dir = "./input"
# # input_dir = "/home/maksimv/Desktop/rpcs/input"

input_dir_abs_path = Path.expand(input_dir)

template_distinguisher = fn path ->
  List.last(path) |> String.starts_with?("template")
end

concat_path = fn (base, type, tail) ->
  Path.join([base, type | tail])
end

case_reader = fn path ->
  request = concat_path.(input_dir_abs_path, "request", path)
  |> File.read!
  |> Jason.decode!

  response = concat_path.(input_dir_abs_path, "response", path)
  |> File.read!
  |> Jason.decode!

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

IO.inspect(cases)
