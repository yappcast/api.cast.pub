defmodule YappCast.Mixfile do
  use Mix.Project

  def project do
    [app: :yapp_cast,
     version: "0.0.1",
     elixir: "~> 1.0",
     elixirc_paths: ["lib", "web"],
     compilers: [:phoenix] ++ Mix.compilers,
     deps: deps]
  end

  # Configuration for the OTP application
  #
  # Type `mix help compile.app` for more information
  def application do
    [mod: {YappCast, []},
     applications: [:phoenix, :cowboy, :logger, :postgrex, :ecto]]
  end

  # Specifies your project dependencies
  #
  # Type `mix help deps` for examples and options
  defp deps do
    [{:phoenix, "0.5.0"},
     {:cowboy, "~> 1.0"},
     {:postgrex, ">= 0.0.0"},
     {:ecto, "~> 0.2.0"},
     {:vex, "~> 0.5.0"},
     {:canada, "~> 1.0.0"},
     {:poison, "~> 1.2.0"},
     {:cmark, "~> 0.2.0"},
     {:joken, "~> 0.6.0"},
     {:plug_jwt, "~> 0.3.1"},
     {:plug_cors, "~> 0.2.1"},
     {:shouldi, env: :test}]
  end
end
