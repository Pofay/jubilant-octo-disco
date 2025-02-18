defmodule SnifflingBot.MixProject do
  use Mix.Project

  def project do
    [
      app: :sniffling_bot,
      version: "0.1.0",
      elixir: "~> 1.18",
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger],
      mod: {SnifflingBot.Application, []}
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:nostrum, "~> 0.10"},
      {:poison, "~> 4.0"},
      {:httpoison, "~> 1.8"},
      {:jason, "~> 1.2"},
      {:timex, "~> 3.7"},
      {:ex_doc, "~> 0.24", only: :dev},
      {:credo, "~> 1.5", only: [:dev, :test]},
      {:excoveralls, "~> 0.14", only: :test},
      {:tentacat, "~> 2.0"}
      # {:dep_from_hexpm, "~> 0.3.0"},
      # {:dep_from_git, git: "https://github.com/elixir-lang/my_dep.git", tag: "0.1.0"}
    ]
  end
end
