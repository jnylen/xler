defmodule Xler.MixProject do
  use Mix.Project

  def project do
    [
      app: :xler,
      version: "0.2.1",
      elixir: "~> 1.8",
      start_permanent: Mix.env() == :prod,
      compilers: [:rustler] ++ Mix.compilers(),
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
      {:rustler, "~> 0.20.0"},
      {:ex_doc, ">= 0.0.0", only: :dev}
    ]
  end

  defp docs do
    [
      source_ref: "master",
      main: "Xler",
      canonical: "http://hexdocs.pm/xler",
      source_url: "https://gitlab.com/jnylen/xler",
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
      links: %{"GitLab" => "https://gitlab.com/jnylen/xler"}
    ]
  end
end
