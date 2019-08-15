# Copyright(c) 2019 TenTakano
# All rights reserved.
# See License in the project root for license information.

defmodule IssueList.Add do
  def exec(args, issues) do
    result = parse_args(args)
    case result do
      {:error, _} -> result
      title       -> issues ++ [%Issue{title: title, add: DateTime.utc_now, status: " "}]
    end
  end

  defp parse_args(args) do
    case args do
      []                            -> {:error, :invalid_args}
      [_ | tail]    when tail != [] -> {:error, :invalid_args}
      [head | _]                    -> head
    end
  end
end