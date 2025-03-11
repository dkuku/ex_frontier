defmodule ExFrontier.MixProject do
  use Mix.Project

  @version "0.1.0"
  @source_url "https://github.com/dkuku/ex_frontier"
  def project do
    [
      app: :ex_frontier,
      version: @version,
      elixir: "~> 1.0",
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      docs: docs(),
      description: description(),
      package: package(),
      deps: deps(),
      elixirc_paths: elixirc_paths(Mix.env()),
      name: "ex_frontier",
      source_url: @source_url
    ]
  end

  def application do
    [
      extra_applications: [:logger]
    ]
  end

  defp description() do
    """
    Helper library to connect to Frontier radios
    Also known under the name Frontier Silicon
    """
  end

  defp package() do
    [
      files: ~w(lib .formatter.exs mix.exs README* CHANGELOG*),
      licenses: ["Apache-2.0"],
      links: %{
        "GitHub" => @source_url,
        "Changelog" => "#{@source_url}/blob/master/CHANGELOG.md"
      }
    ]
  end

  defp elixirc_paths(:test), do: ["lib", "test/support"]
  defp elixirc_paths(_), do: ["lib"]

  defp deps do
    [
      {:telemetry_metrics, "~> 1.0"},
      {:telemetry_poller, "~> 1.0"},
      {:tesla, "~> 1.4"},
      {:hackney, "~> 1.17"},
      {:sweet_xml, "~> 0.7"},
      {:dialyxir, "~> 1.0", only: [:dev], runtime: false},
      {:credo, "~> 1.5", only: [:dev, :test], runtime: false},
      {:ex_doc, ">= 0.0.0", only: :dev, runtime: false},
      {:assert_value, ">= 0.0.0", only: [:dev, :test]},
      {:hammox, "~> 0.5", only: :test}
    ]
  end

  defp docs do
    [
      main: "readme",
      source_url: @source_url,
      source_ref: "v#{@version}",
      extras: [
        "README.md",
        "FSAPI.md"
      ]
    ]
  end
end
