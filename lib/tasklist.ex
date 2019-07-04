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
    {get_value, {:ok, new_value, _}} = function.(value)
    {get_value, %{ticket | key => new_value}}
  end

  @impl Access
  def pop(data, key) do
    {value, data} = Access.pop(Map.from_struct(data), key)
    {value, struct(__MODULE__, data)}
  end

  def toString(task) do
    # Todo: Implement timezone shift by soft cording
    time = task[:add] |> DateTime.add(3600 * 9, :second)
                      |> DateTime.to_string
                      |> String.slice(0, 19)
                      
    task[:title] <> ", " <> time
  end
end

defmodule TaskList do
  def show(index, tasks) when index == 0 do
    Enum.at(tasks, index) |> Ticket.toString |> IO.puts
  end

  def show(index, tasks) when index > 0 do
    show(index - 1, tasks)
    Enum.at(tasks, index) |> Ticket.toString |> IO.puts
  end

  def add(arg, tasks) do
    [title | arg] = arg
    [%Ticket{title: title, add: DateTime.utc_now} | tasks]
  end
end