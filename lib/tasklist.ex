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

  def toString(task) do
    # Todo: Implement timezone shift by soft cording
    time = task[:add] |> DateTime.add(3600 * 9, :second)
                      |> DateTime.to_string
                      |> String.slice(0, 19)
                      
    task[:title] <> ", " <> time <> ", " <> task[:status]
  end
end

defmodule TicketList do
  def show(tasks) do
    addIndex = fn i, str ->
      Integer.to_string(i) <> ", " <> str
    end

    puts = fn 
      [head | []],   _f -> [addIndex.(1, head)]
      [head | tail],  f ->
        newStr = addIndex.(Enum.count(tail) + 1, head)
        [newStr | f.(tail, f)]
    end

    list = tasks |> Enum.filter(&(&1[:status] == " "))
                 |> update_in([Access.all], &Ticket.toString/1)
                 |> puts.(puts)
                 |> Enum.reverse
                 |> Enum.each(fn line -> IO.puts line end)
  end

  def add(arg, tasks) do
    [title | arg] = arg
    [%Ticket{title: title, add: DateTime.utc_now, status: " "} | tasks]
  end

  def done(arg, tasks) do
    [index | arg] = arg

    num = tasks |> Enum.filter(&(&1[:status] == " "))
                |> Enum.count

    case num do
      n when index > num ->
        IO.puts "Given index value was invalid"
        tasks
      n ->
        item = tasks |> Enum.filter(&(&1[:status] == " ")) 
                    |> Enum.at(String.to_integer(index) - 1)
        item = %Ticket{item | status: "x"}
        List.replace_at(tasks, String.to_integer(index) - 1, item)
    end
  end
end