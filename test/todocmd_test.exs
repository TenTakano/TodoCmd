defmodule TodocmdTest do
  use ExUnit.Case
  doctest Todocmd

  test "greets the world" do
    assert Todocmd.hello() == :world
  end
end
