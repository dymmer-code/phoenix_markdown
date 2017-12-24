defmodule PhoenixMarkdown.Mixfile do
  use Mix.Project

  @version "1.0.0-rc"
  @github "https://github.com/boydm/phoenix_markdown"
#  @tutorial "https://medium.com/@boydm/policy-wonk-the-tutorial-6d2b6e435c46#.dz7utkmgb"

  def project do
    [
      app: :phoenix_markdown,
      version: @version,
      elixir: "~> 1.1",
      deps: deps(),
      package: [
        contributors: ["Boyd Multerer"],
        maintainers: ["Boyd Multerer"],
        licenses: ["MIT"],
        links: %{github: @github}
      ],

      name: "phoenix_markdown",
      source_url: @github,
      docs: docs(),
      description: """
      Markdown Template Engine for Phoenix. Uses Earmark to render.
      """
    ]
  end

  def application do
    [applications: [:phoenix]]
  end

  defp deps do
    [
      {:phoenix, ">= 1.1.0"},
      {:ex_doc, ">= 0.0.0", only: :dev, runtime: false},
      {:phoenix_html, ">= 2.3.0"},
      {:earmark, "~> 1.2"},         # Markdown interpreter
    ]
  end

  defp docs do
    [
      extras: ["README.md"],
      source_ref: "v#{@version}",
      main: "PhoenixMarkdown"
    ]
  end

end
