import Config

config :rpcs, :network_url,
  System.get_env("NETWORK_URL")

config :rpcs, :input_dir,
  System.get_env("INPUT_DIR")
