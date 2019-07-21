defmodule TicketList.Show do
  def exec(args, tickets) do
    result = check_args(args)
    case {result, Enum.count(tickets)} do
      {{:error, _}, _} -> result
      {:ok, 0} -> {:error, :empty_list}
      {:ok, _} -> create_result(tickets)
    end
  end

  def check_args(args) do
    case args do
      []  -> :ok
      _   -> {:error, :invalid_args}
    end
  end

  def create_result(tickets) do
    addIndex = &(Integer.to_string(&1) <> ", " <> &2)

    append = &([&1 | &2])
    
    puts = fn
      [head | []],  _f -> [addIndex.(1, head)]
      [head | tail], f ->
        newStr = addIndex.(Enum.count(tail) + 1, head)
        [newStr | f.(tail, f)]
    end

    mklist = fn sign ->
      type = case sign do
        " " -> "Todo"
        "x" -> "Done"
        "-" -> "Cancel"
      end

      result = []
      result = append.(type, result)
      result = append.("----------", result)

      target = Enum.filter(tickets, &(&1[:status] == sign))
      case Enum.count(target) do
        0 -> []
        _ -> target |> update_in([Access.all], &Ticket.toString/1)
                    |> puts.(puts)
                    |> Enum.reverse
                    |> Enum.reduce(result, &(append.(&1, &2)))
      end
    end

    mklist.("-") ++ mklist.("x") ++ mklist.(" ") |> Enum.reverse
  end
end