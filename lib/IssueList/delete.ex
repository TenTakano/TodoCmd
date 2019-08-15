# Copyright(c) 2019 TenTakano
# All rights reserved.
# See License in the project root for license information.

defmodule IssueList.Delete do
  def exec(args, issues) do
    result = parse_args(args)
    case result do
      {:error, _} -> result
      :ok         ->
        Enum.filter(issues, &(&1[:status] == " "))
    end
  end

  defp parse_args(args) do
    case args do
      []  -> :ok
      _   -> {:error, :invalid_args}
    end
  end
end