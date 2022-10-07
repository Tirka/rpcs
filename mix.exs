defmodule Rpcs.MixProject do
  use Mix.Project

  def project do
    [
      app: :rpcs,
      version: "0.1.0",
      elixir: "~> 1.13",
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      mod: {Rpcs.Application, []},
      extra_applications: [:logger, :eex]
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:jason, "~> 1.4"},
      {:httpoison, "~> 1.8"},
      {:ok, git: "https://github.com/Tirka/OK.git", branch: "add-methods"},
      {:plug_cowboy, "~> 2.0"},
      {:telemetry, "~> 1.0"},
      {:telemetry_metrics, "~> 0.6.1"},
      {:telemetry_metrics_prometheus, "~> 1.1.0"}
    ]
  end
end
