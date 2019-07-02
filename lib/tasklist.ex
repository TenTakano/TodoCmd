defmodule Ticket do
  defstruct [:index, :status, :title, :add, :finished, :detals, :tags]

  @behaviour Access

  @impl Access
  def fetch(term, key) do
    Access.fetch(Map.from_struct(term), key)
  end
end

defmodule TaskList do
  def show(index, tasks) do
    case index do
      n when n == 0 ->
        IO.inspect(Enum.at(tasks, index))
      n when n > 0 ->
        show(index - 1, tasks)
        IO.inspect(Enum.at(tasks, index))
    end
  end

  def add(arg, tasks) do
    [title | arg] = arg
    [%Ticket{title: title, add: Time.utc_now} | tasks]
  end
end