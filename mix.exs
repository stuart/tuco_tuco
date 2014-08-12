defmodule TucoTuco.Mixfile do
  use Mix.Project

  def project do
    [ app: :tuco_tuco,
      version: "0.5.0",
      elixir: "~> 0.15.1",
      source_url: "https://github.com/stuart/tuco_tuco",
      homepage_url: "http://stuart.github.io/tuco_tuco",
      deps: deps(Mix.env)
    ]
  end

  # Configuration for the OTP application
  def application do
    [ mod: { TucoTuco, [] },
      applications: [ :webdriver ]
    ]
  end

  defp deps do
    [ {:webdriver, github: "stuart/elixir-webdriver", tag: "0.5.0"} ]
  end

  defp deps :test do
    []
  end

  defp deps :dev do
    []
  end
end
