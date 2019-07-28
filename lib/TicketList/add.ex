# Copyright(c) 2019 TenTakano
# All rights reserved.
# See License in the project root for license information.

defmodule TicketList.Add do
  def exec(args, tickets) do
    result = parse_args(args)
    case result do
      {:error, _} -> result
      title       -> tickets ++ [%Ticket{title: title, add: DateTime.utc_now, status: " "}]
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