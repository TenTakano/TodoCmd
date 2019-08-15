# Copyright(c) 2019 TenTakano
# All rights reserved.
# See License in the project root for license information.

defmodule IssueList.Finish do
  def done(args, issues), do: exec(args, issues, "x")
  def cancel(args, issues), do: exec(args, issues, "-")

  def exec(args, issues, command) do
    result = parse_args(args, issues)
    case result do
      {:error, _} -> result
      index       ->
        target = issues  |> Enum.filter(&(&1[:status] == " "))
                          |> Enum.at(index - 1)

        targetIndex = Enum.find_index(issues, &(&1 == target))
        List.update_at(issues, targetIndex, &(%Issue{&1 | status: command}))
    end
  end

  defp parse_args(args, issues) do
    length = issues  |> Enum.filter(&(&1[:status] == " "))
                      |> Enum.count

    parse = fn arg ->
      index = Integer.parse(arg)
      case index do
        :error                  -> {:error, :invalid_args}
        {n, ""} when n < 0      -> {:error, :index_out_of_range}
        {n, ""} when n > length -> {:error, :index_out_of_range}
        {n, ""}                 -> n
      end
    end

    case Enum.count(args) do
      1 -> Enum.at(args, 0) |> parse.()
      _ -> {:error, :invalid_args}
    end
  end
end