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
              {:ok, body} -> Poison.decode!(body, as: [%Ticket{}])
              {:error, reason} -> []
            end

    [subcommand | args] = args
    tasks = case subcommand do
              "add"     -> TaskList.add(args, tasks)
              "done"    -> IO.puts "done command"
              "cancel"  -> IO.puts "cancel command"
              "mod"     -> IO.puts "mod command"
              "flush"   -> IO.puts "flush command"
              "list"    -> IO.puts "list command"
            end

    result = File.write(targetdir, Poison.encode!(tasks))
    case result do
      :ok               -> TaskList.show(Enum.count(tasks), tasks)
      {:error, reason}  -> IO.puts(reason)
    end
  end
end