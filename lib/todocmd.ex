defmodule Ticket do
  defstruct [:index, :status, :title, :add, :finished, :detals, :tags]

  @behaviour Access

  @impl Access
  def fetch(term, key) do
    Access.fetch(Map.from_struct(term), key)
  end
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
              {:ok, body} -> Poison.decode!(body, as: [%Ticket{}])
              {:error, reason} -> []
            end

    [subcommand | args] = args
    tasks = case subcommand do
              "add"     -> add(args, tasks)
              "done"    -> IO.puts "done command"
              "cancel"  -> IO.puts "cancel command"
              "mod"     -> IO.puts "mod command"
              "flush"   -> IO.puts "flush command"
              "list"    -> IO.puts "list command"
            end

    result = File.write(targetdir, Poison.encode!(tasks))
    case result do
      :ok               -> show(Enum.count(tasks), tasks)
      {:error, reason}  -> IO.puts(reason)
    end
  end

  def show(index, tasks) do
    case index do
      n when n == 0 ->
        IO.inspect(Enum.at(tasks, index))
      n when n > 0 ->
        show(index - 1, tasks)
        IO.inspect(Enum.at(tasks, index))
    end
  end

  def add(arg, tasks) do
    [title | arg] = arg
    [%Ticket{title: title, add: Time.utc_now} | tasks]
  end
end