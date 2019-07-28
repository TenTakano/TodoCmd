# Copyright(c) 2019 TenTakano
# All rights reserved.
# See License in the project root for license information.

defmodule Ticket do
  defstruct [:index, :status, :title, :add, :finished, :detals, :tags]

  @behaviour Access

  @impl Access
  def fetch(term, key) do
    Access.fetch(Map.from_struct(term), key)
  end

  @impl Access
  def get_and_update(%Ticket{} = ticket, key, function) do
    {:ok, value} = Map.fetch(ticket, key)
    {getValue, {:ok, newValue, _}} = function.(value)
    {getValue, %{ticket | key => newValue}}
  end

  @impl Access
  def pop(data, key) do
    {value, data} = Access.pop(Map.from_struct(data), key)
    {value, struct(__MODULE__, data)}
  end

  def toString(ticket) do
    # Todo: Implement timezone shift by soft cording
    time = ticket[:add] |> DateTime.add(3600 * 9, :second)
                        |> DateTime.to_string
                        |> String.slice(0, 19)
                      
    ticket[:title] <> ", " <> time <> ", " <> ticket[:status]
  end
end