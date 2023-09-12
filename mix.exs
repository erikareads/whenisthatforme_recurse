defmodule WhenisthatformeRecurse.MixProject do
  use Mix.Project

  def project do
    [
      app: :whenisthatforme_recurse,
      version: "0.1.0",
      elixir: "~> 1.14",
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger],
      mod: {WhenisthatformeRecurse.Application, []}
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:bandit, "~> 0.6"},
      {:tz, "~> 0.26.2"},
      {:castore, "~> 0.1"},
      {:mint, "~> 1.4"},
       {:opentelemetry_api, "~> 1.1"},
      {:opentelemetry_semantic_conventions, "~> 0.2"},
  {:opentelemetry_exporter, "~> 1.6"},
  {:opentelemetry, "~> 1.3"},
  {:jason, ">= 0.0.0"},
    {:teleplug, "~> 1.1.3"}

    ]
  end
end
