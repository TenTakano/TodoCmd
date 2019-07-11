defmodule TicketList.Finished do
  def done(args, tickets), do: exec(args, tickets, "x")
  def cancel(args, tickets), do: exec(args, tickets, "-")

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

  defp convert_index(index, tickets, current) do
    case {index, Enum.at(tickets, current)} do
      {_, %{status: s}} when s == "x" -> convert_index(index, tickets, current + 1)
      {1, _}                          -> current
      {n, _} when n > 1               -> convert_index(n - 1, tickets, current + 1)
    end
  end
end