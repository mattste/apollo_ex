defmodule ApolloEx.MixProject do
  use Mix.Project

  def project do
    [
      app: :apollo_ex,
      version: "0.1.0",
      elixir: "~> 1.14",
      preferred_cli_env: [
        dialyzer: :test
      ],
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      dialyzer: [
        plt_core_path: "priv/plts",
        plt_add_apps: [:mix, :ex_unit]
      ]
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger]
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:absinthe, "~> 1.7.1"},
      {:absinthe_plug, "~> 1.5.8"},
      {:dialyxir, "~> 1.3", only: [:dev, :test], runtime: false},
      {:google_protos, "~> 0.3.0"},
      {:jason, "~> 1.4"},
      {:plug_cowboy, "~> 2.5"},
      {:protobuf, "~> 0.12.0"}
    ]
  end
end
