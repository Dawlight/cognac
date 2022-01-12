defmodule Cognac.MixProject do
  use Mix.Project

  @version "0.4.0"
  @source_url "https://github.com/Dawlight/cognac"

  def project do
    [
      app: :cognac,
      version: @version,
      elixir: "~> 1.12",
      deps: deps(),
      name: "Cognac",
      description: description(),
      source_url: @source_url,
      docs: [source_ref: "v#{@version}", main: "readme", extras: ["README.md"]],
      package: package()
    ]
  end

  def application do
    []
  end

  def description() do
    "Build queries for GraphQL using native Elixir terms. Pairs well with Absinthe."
  end

  defp deps do
    [
      {:ex_doc, ">= 0.0.0", only: :dev, runtime: false}
    ]
  end

  defp package() do
    [
      maintainers: ["Johan Eriksson"],
      licenses: ["Apache-2.0"],
      links: %{"GitHub" => @source_url}
    ]
  end
end
