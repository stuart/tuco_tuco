defmodule TucoTuco.Mixfile do
  use Mix.Project

  def project do
    [ app: :tuco_tuco,
      version: "0.5.1",
      elixir: "~> 0.15.1",
      description: "Testing tool for web applications",
      source_url: "https://github.com/stuart/tuco_tuco",
      homepage_url: "http://stuart.github.io/tuco_tuco",
      package: package,
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
    [ {:webdriver, "~>0.5.2"} ]
  end

  defp deps :test do
    deps ++ []
  end

  defp deps _ do
    deps
  end

  defp package do
    [contributors: ["Stuart Coyle"],
     licenses: ["MIT License"],
     links: %{"Github" => "https://github.com/stuart/tuco-tuco"}]
  end
end
