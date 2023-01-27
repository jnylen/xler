defmodule Xler.MixProject do
  use Mix.Project

  @version "0.6.0"

  def project do
    [
      app: :xler,
      version: @version,
      elixir: "~> 1.8",
      start_permanent: Mix.env() == :prod,
      description: description(),
      package: package(),
      rustler_crates: rustler_crates(),
      deps: deps(),
      docs: docs()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application() do
    [
      extra_applications: [:logger]
    ]
  end

  defp rustler_crates do
    [
      xler_native: [
        path: "native/xler_native",
        mode: :release
      ]
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps() do
    [
      # TODO: upgrade rustler
      # TODO: fix deprecations
      # TODO: compile everything with the latest versions of elixir and rust
      {:rustler, "~> 0.27.0"},
      {:rustler_precompiled, "~> 0.6.0"},
      {:ex_doc, "~> 0.29", only: :dev, runtime: false}
    ]
  end

  defp docs do
    [
      source_ref: "master",
      main: "Xler",
      canonical: "http://hexdocs.pm/xler",
      source_url: "https://github.com/jnylen/xler",
      extras: [
        "README.md"
      ]
    ]
  end

  defp description() do
    "A rust-based Excel parser."
  end

  defp package() do
    [
      files: ~w(lib .formatter.exs mix.exs README* LICENSE*
                native),
      licenses: ["MIT"],
      links: %{"Github" => "https://github.com/jnylen/xler"}
    ]
  end
end
