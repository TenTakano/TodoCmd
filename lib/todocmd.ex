# Copyright(c) 2019 TenTakano
# All rights reserved.
# See License in the project root for license information.

defmodule Todocmd do
  alias TicketList.{Show, Add, Finished}

  @dirname  ".todocmd"
  @filename "list.json"
  defp filePath, do: System.user_home <> "/" <> @dirname
  defp fullPath, do: filePath() <> "/" <> @filename

  def main(args) do
    args = case args do
      [] -> ["show"]
      _  -> args
    end
    
    tickets = case File.read(fullPath()) do
      {:error, :enoent} ->
        File.mkdir!(filePath())
        []
      {:error, reason} ->
        IO.puts reason
      {:ok, body} -> 
        body  |> Poison.decode!(as: [%Ticket{}])
              |> update_in([Access.all, :add], &DateTime.from_iso8601/1)
    end

    [subcommand | args] = args
    case subcommand do
      "show"    -> Show.exec(args, tickets) |> Enum.each(&(IO.puts &1))
      "add"     -> exec_subcommand(args, tickets, &Add.exec/2)
      "done"    -> exec_subcommand(args, tickets, &Finished.done/2)
      "cancel"  -> exec_subcommand(args, tickets, &Finished.cancel/2)
      "mod"     -> IO.puts "mod command"
      "flush"   -> IO.puts "flush command"
      "list"    -> IO.puts "list command"
    end
  end

  def exec_subcommand(args, tickets, f) do
    tickets = f.(args, tickets)

    result = File.write(fullPath(), Poison.encode!(tickets))
    case result do
      :ok               -> TicketList.Show.exec([], tickets) |> Enum.each(&(IO.puts &1))
      {:error, reason}  -> IO.puts(reason)
    end
  end
end