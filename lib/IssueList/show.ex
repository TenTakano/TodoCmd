# Copyright(c) 2019 TenTakano
# All rights reserved.
# See License in the project root for license information.

defmodule IssueList.Show do
  def exec(args, issues) do
    result = check_args(args)
    case {result, Enum.count(issues)} do
      {{:error, _}, _} -> result
      {:ok, 0} -> {:error, :empty_list}
      {:ok, _} -> create_result(issues)
    end
  end

  def check_args(args) do
    case args do
      []  -> :ok
      _   -> {:error, :invalid_args}
    end
  end

  def create_result(issues) do
    addIndex = &(Integer.to_string(&1) <> ", " <> &2)

    puts = fn
      [head | []],  _f, n -> [addIndex.(n, head)]
      [head | tail], f, n ->
        newHead = addIndex.(n, head)
        [newHead | f.(tail, f, n + 1)]
    end

    mklist = fn sign ->
      type = case sign do
        " " -> "Todo"
        "x" -> "Done"
        "-" -> "Cancel"
      end

      result = []
      result = [type | result]
      result = ["----------" | result]

      target = Enum.filter(issues, &(&1[:status] == sign))
      case Enum.count(target) do
        0 -> []
        _ -> target |> update_in([Access.all], &Issue.toString/1)
                    |> puts.(puts, 1)
                    |> Enum.reduce(result, &([&1 | &2]))
      end
    end

    mklist.("-") ++ mklist.("x") ++ mklist.(" ") |> Enum.reverse
  end
end