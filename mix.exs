defmodule Fox.Mixfile do
  use Mix.Project

  def project do
    [app: :fox,
     version: "0.1.9",
     elixir: "~> 1.0",
     description: description,
     name: "fox",
     source_url: "https://github.com/foxnewsnetwork/fox",
     package: package,
     build_embedded: Mix.env == :prod,
     start_permanent: Mix.env == :prod,
     deps: deps]
  end

  # Configuration for the OTP application
  #
  # Type `mix help compile.app` for more information
  def application do
    [applications: [:logger, :timex, :ecto]]
  end

  defp package do
    [maintainers: ["Thomas Chen - (foxnewsnetwork)"],
     licenses: ["MIT"],
     links: %{github: "https://github.com/foxnewsnetwork/fox"}]
  end

  defp description do
    """
    Collection of support utility functions and extensions for day-to-day web development with Elixir.

    Includes utility extension to strings, uri, dicts, integers, functions, parallel, records, random, and time
    """
  end

  # Dependencies can be Hex packages:
  #
  #   {:mydep, "~> 0.3.0"}
  #
  # Or git/path repositories:
  #
  #   {:mydep, git: "https://github.com/elixir-lang/mydep.git", tag: "0.1.0"}
  #
  # Type `mix help deps` for more examples and options
  defp deps do
    [{:ecto, ">= 0.14.0"},
     {:timex, ">= 0.14.0"},
     {:earmark, "~> 0.1", only: :dev},
     {:ex_doc, "~> 0.7", only: :dev},
     {:inch_ex, "~> 0.2", only: :dev}]
  end
end
