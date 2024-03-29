# Copyright(c) 2019 TenTakano
# All rights reserved.
# See License in the project root for license information.

defmodule Todocmd.MixProject do
  use Mix.Project

  def project do
    [
      app: :todocmd,
      version: "0.1.0",
      elixir: "~> 1.8",
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      escript: escript()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger]
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:poison, "~> 3.1"}
    ]
  end

  defp escript do
    [main_module: Todocmd]
  end
end
