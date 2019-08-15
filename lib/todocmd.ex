# Copyright(c) 2019 TenTakano
# All rights reserved.
# See License in the project root for license information.

defmodule Todocmd do
  alias IssueList.{Show, Add, Finish, Delete}

  @dirname  ".todocmd"
  @filename "list.json"
  defp filePath, do: System.user_home <> "/" <> @dirname
  defp fullPath, do: filePath() <> "/" <> @filename

  def main(args) do
    args = case args do
      [] -> ["show"]
      _  -> args
    end
    
    issues = case File.read(fullPath()) do
      {:error, :enoent} ->
        File.mkdir!(filePath())
        []
      {:error, reason} ->
        IO.puts reason
      {:ok, body} -> 
        body  |> Poison.decode!(as: [%Issue{}])
              |> update_in([Access.all, :add], &DateTime.from_iso8601/1)
    end

    [subcommand | args] = args
    case subcommand do
      "show"    -> Show.exec(args, issues) |> Enum.each(&(IO.puts &1))
      "add"     -> exec_subcommand(args, issues, &Add.exec/2)
      "done"    -> exec_subcommand(args, issues, &Finish.done/2)
      "cancel"  -> exec_subcommand(args, issues, &Finish.cancel/2)
      "delete"  -> exec_subcommand(args, issues, &Delete.exec/2)
      "mod"     -> IO.puts "mod command"
      "flush"   -> IO.puts "flush command"
      "list"    -> IO.puts "list command"
    end
  end

  def exec_subcommand(args, issues, f) do
    issues = f.(args, issues)

    result = File.write(fullPath(), Poison.encode!(issues))
    case result do
      :ok               -> IssueList.Show.exec([], issues) |> Enum.each(&(IO.puts &1))
      {:error, reason}  -> IO.puts(reason)
    end
  end
end