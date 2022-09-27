import Config

config :rpcs, :environment,
  %{
    network_url: System.get_env("NETWORK_URL"),
    input_dir: System.get_env("INPUT_DIR")
  }
