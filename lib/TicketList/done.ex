# Copyright(c) 2019 TenTakano
# All rights reserved.
# See License in the project root for license information.

defmodule TicketList.Finished do
  def done(args, tickets), do: exec(args, tickets, "x")
  def cancel(args, tickets), do: exec(args, tickets, "-")

  def exec(args, tickets, command) do
    result = parse_args(args, tickets)
    case result do
      {:error, _} -> result
      index       ->
        target = tickets  |> Enum.filter(&(&1[:status] == " "))
                          |> Enum.at(index - 1)

        targetIndex = Enum.find_index(tickets, &(&1 == target))
        List.update_at(tickets, targetIndex, &(%Ticket{&1 | status: command}))
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
end