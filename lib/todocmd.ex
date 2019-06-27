defmodule Todocmd do
  @moduledoc """
  Documentation for Todocmd.
  """

  @doc """
  Hello world.

  ## Examples

      iex> Todocmd.hello()
      :world

  """
  def main(args) do
    [subcommand | args] = args
    case subcommand do
      "add"     -> IO.puts "add command"
      "done"    -> IO.puts "done command"
      "cancel"  -> IO.puts "cancel command"
      "mod"     -> IO.puts "mod command"
      "flush"   -> IO.puts "flush command"
      "list"    -> IO.puts "list command"
    end
  end
end
