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
      "add"     -> exec_subcommand(args, issues, &Add.exec/2)
      "done"    -> exec_subcommand(args, issues, &Finish.done/2)
      "cancel"  -> exec_subcommand(args, issues, &Finish.cancel/2)
      "delete"  -> exec_subcommand(args, issues, &Delete.exec/2)
      "show"    -> puts_list(issues)
    end
  end

  defp exec_subcommand(args, issues, f) do
    issues = f.(args, issues)

    result = File.write(fullPath(), Poison.encode!(issues))
    case result do
      :ok               -> puts_list(issues)
      {:error, reason}  -> IO.puts(reason)
    end
  end

  defp puts_list(issues) do
    result = Show.exec([], issues)
    case result do
      [_ | _]               -> Enum.each(result, &(IO.puts &1))
      {:error, :empty_list} -> IO.puts "There is no tasks"
      {:error, reason}      -> IO.inspect reason
    end
  end
end