defmodule TicketList.Show do
  def exec(args, tickets) do
    result = check_args(args)
    case {result, Enum.count(tickets)} do
      {{:error, _}, _} -> result
      {:ok, 0} -> {:error, :empty_list}
      {:ok, _} ->
        addIndex = &(Integer.to_string(&1) <> ", " <> &2)
        
        puts = fn
          [head | []],  _f -> [addIndex.(1, head)]
          [head | tail], f ->
            newStr = addIndex.(Enum.count(tail) + 1, head)
            [newStr | f.(tail, f)]
        end

        tickets |> Enum.filter(&(&1[:status] == " "))
                |> update_in([Access.all], &Ticket.toString/1)
                |> puts.(puts)
                |> Enum.reverse
    end
  end

  def check_args(args) do
    case args do
      []  -> :ok
      _   -> {:error, :invalid_args}
    end
  end
end