defmodule TucoTuco.Mixfile do
  use Mix.Project

  def project do
    [ app: :tuco_tuco,
      version: "0.2.1",
      elixir: "~> 0.12.3",
      env: [
          dev:  [ deps: deps ++ dev_deps  ],
          test: [ deps: deps ++ test_deps ],
          prod: [ deps: deps ]
        ]
    ]
  end

  # Configuration for the OTP application
  def application do
    [mod: { TucoTuco, [] }, applications: [ :webdriver ]]
  end

  # Returns the list of dependencies in the format:
  # { :foobar, git: "https://github.com/elixir-lang/foobar.git", tag: "0.1" }
  #
  # To specify particular versions, regardless of the tag, do:
  # { :barbat, "~> 0.1", github: "elixir-lang/barbat" }
  defp deps do
    [ {:webdriver, github: "stuart/elixir-webdriver"} ]
  end

  defp test_deps do
    []
  end

  defp dev_deps do
    []
  end
end
