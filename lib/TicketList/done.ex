defmodule TicketList.Finished do
  def done(args, tickets), do: exec(args, tickets, "x")

  def exec(args, tickets, command) do
    result = parse_args(args, tickets)
    case result do
      {:error, _} -> result
      index       ->
        item = tickets  |> Enum.filter(&(&1[:status] == " "))
                        |> Enum.at(index - 1)
                        |> (&(%Ticket{&1 | status: command})).()

        cnvtd_index = convert_index(index, tickets, 0)
        List.replace_at(tickets, cnvtd_index, item)
    end
  end

  defp parse_args(args, tickets) do
    length = tickets  |> Enum.filter(&(&1[:status] == " "))
                      |> Enum.count

    case args do
      []                                        -> {:error, :invalid_args}
      [_ | tail] when tail != []                -> {:error, :invalid_args}
      [arg]      when is_integer(arg) == false  -> {:error, :invalid_args}
      [index]    when index < 1                 -> {:error, :index_out_of_range}
      [index]    when index > length            -> {:error, :index_out_of_range}
      [index]                                   -> index
    end
  end

  defp convert_index(index, tickets, current) do
    case {index, Enum.at(tickets, current)} do
      {_, %{status: s}} when s == "x" -> convert_index(index, tickets, current + 1)
      {1, _}                          -> current
      {n, _} when n > 1               -> convert_index(n - 1, tickets, current + 1)
    end
  end
end