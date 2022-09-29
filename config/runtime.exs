import Config

config :rpcs, :env,
  %{
    network_url: System.get_env("NETWORK_URL") ||
      raise(ArgumentError, "Provide `NETWORK_URL` environment variable"),

    input_dir: System.get_env("INPUT_DIR") ||
      raise(ArgumentError, "Provide `INPUT_DIR` environment variable")
  }
