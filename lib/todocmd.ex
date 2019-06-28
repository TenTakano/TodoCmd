defmodule Task do
  defstruct status: "", title: "", add: "", finished: "", details: [], tags: []
end

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
    %{"targetdir" => targetdir} = "./config.json" |> File.read!
                                                  |> Poison.decode!

    tasks = case File.read(targetdir) do
              {:ok, body} -> Poison.decode!(body)
              {:error, reason} -> [] 
            end

    [subcommand | args] = args
    tasks = case subcommand do
              "add"     -> IO.puts "add command"
              "done"    -> IO.puts "done command"
              "cancel"  -> IO.puts "cancel command"
              "mod"     -> IO.puts "mod command"
              "flush"   -> IO.puts "flush command"
              "list"    -> IO.puts "list command"
            end
  end
end