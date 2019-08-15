# Copyright(c) 2019 TenTakano
# All rights reserved.
# See License in the project root for license information.

defmodule Issue do
  defstruct [:index, :status, :title, :add, :finished, :detals, :tags]

  @behaviour Access

  @impl Access
  def fetch(term, key) do
    Access.fetch(Map.from_struct(term), key)
  end

  @impl Access
  def get_and_update(%Issue{} = issue, key, function) do
    {:ok, value} = Map.fetch(issue, key)
    {getValue, {:ok, newValue, _}} = function.(value)
    {getValue, %{issue | key => newValue}}
  end

  @impl Access
  def pop(data, key) do
    {value, data} = Access.pop(Map.from_struct(data), key)
    {value, struct(__MODULE__, data)}
  end

  def toString(issue) do
    # Todo: Implement timezone shift by soft cording
    time = issue[:add] |> DateTime.add(3600 * 9, :second)
                        |> DateTime.to_string
                        |> String.slice(0, 19)
                      
    issue[:title] <> ", " <> time <> ", " <> issue[:status]
  end
end