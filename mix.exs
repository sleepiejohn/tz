defmodule Tz.MixProject do
  use Mix.Project

  def project do
    [
      app: :tz,
      version: "0.1.0",
      elixir: "~> 1.7",
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger],
      mod: {Tz.Application, []}
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:exsync, "~> 0.2", only: :dev},
      {:plug, "~> 1.7"},
      {:cowboy, "~> 2.6"},
      {:plug_cowboy, "~> 2.0"},
      {:jason, "~> 1.1"},
      {:timex, "~> 3.4"},
      {:distillery, "~> 2.0"}
    ]
  end
end
