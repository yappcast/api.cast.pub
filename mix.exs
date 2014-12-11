defmodule CastPub.Mixfile do
  use Mix.Project

  def project do
    [app: :cast_pub,
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
    [
      mod: {CastPub, []},
      applications: [
        :phoenix, :cowboy, :logger, :postgrex, :ecto, 
        :vex, :canada, :poison, :joken, 
        :plug_cors, :plug_jwt, :bcrypt, :timex
      ]
    ]
  end

  # Specifies your project dependencies
  #
  # Type `mix help deps` for examples and options
  defp deps do
    [
      {:phoenix, "0.7.0"},
      {:plug, "0.9.0"},
      {:cowboy, "~> 1.0"},
      {:postgrex, ">= 0.0.0"},
      {:ecto, "~> 0.2.0"},
      {:vex, "~> 0.5.0"},
      {:canada, "~> 1.0.0"},
      {:poison, "~> 1.2.0"},
      {:joken, "~> 0.7.0"},
      {:plug_jwt, "~> 0.4.0"},
      {:plug_cors, "~> 0.3.1"},
      {:bcrypt, github: "opscode/erlang-bcrypt"},
      {:timex, "~> 0.13.1"},
      {:exrm, "~> 0.14.12"}
   ]
  end
end
