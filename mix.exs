defmodule SGP40.MixProject do
  use Mix.Project

  @version "0.1.4"
  @source_url "https://github.com/mnishiguchi/sgp40"

  def project do
    [
      app: :sgp40,
      version: @version,
      description: "Use Sensirion SGP40 air quality sensor in Elixir",
      elixir: "~> 1.11",
      make_clean: ["clean"],
      make_targets: ["all"],
      compilers: [:elixir_make | Mix.compilers()],
      build_embedded: true,
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      elixirc_paths: elixirc_paths(Mix.env()),
      package: package(),
      aliases: [],
      dialyzer: dialyzer(),
      docs: docs()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger],
      mod: {SGP40.Application, []}
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:circuits_i2c, "~> 1.0 or ~> 0.3"},
      {:credo, "~> 1.6", only: [:dev, :test], runtime: false},
      {:dialyxir, "~> 1.1", only: [:dev, :test], runtime: false},
      {:elixir_make, "~> 0.6", runtime: false},
      {:ex_doc, "~> 0.29", only: [:dev], runtime: false},
      {:mix_test_watch, "~> 1.1", only: :dev, runtime: false},
      {:mox, "~> 1.0", only: :test}
    ]
  end

  defp elixirc_paths(:test), do: ["test/support", "lib"]
  defp elixirc_paths(_), do: ["lib"]

  defp dialyzer() do
    [
      flags: [:race_conditions, :unmatched_returns, :error_handling, :underspecs]
    ]
  end

  defp docs do
    [
      main: "readme",
      extras: ["README.md"],
      source_ref: "v#{@version}",
      source_url: @source_url
    ]
  end

  defp package do
    %{
      files: [
        "lib",
        "src/*.[ch]",
        "mix.exs",
        "README.md",
        "LICENSE*",
        "CHANGELOG*",
        "Makefile"
      ],
      licenses: ["MIT"],
      links: %{
        "GitHub" => @source_url,
        "SGP40 - data sheet" =>
          "https://cdn-learn.adafruit.com/assets/assets/000/097/511/original/Sensirion_Gas-Sensors_SGP40_Datasheet.pdf",
        "SGP40 - VOC index for experts" =>
          "https://cdn.sparkfun.com/assets/e/9/3/f/e/GAS_AN_SGP40_VOC_Index_for_Experts_D1.pdf"
      }
    }
  end
end
