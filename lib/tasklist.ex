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

defmodule TicketList do
  def to_string(tickets) do
    case Enum.count(tickets) do
      0 -> 
        {:error, :empty_list}
      _ -> 
        addIndex = fn i, str ->
          Integer.to_string(i) <> ", " <> str
        end

        puts = fn 
          [head | []],   _f -> [addIndex.(1, head)]
          [head | tail],  f ->
            newStr = addIndex.(Enum.count(tail) + 1, head)
            [newStr | f.(tail, f)]
        end

        tickets |> Enum.filter(&(&1[:status] == " "))
                |> update_in([Access.all], &Ticket.toString/1)
                |> puts.(puts)
                |> Enum.reverse
    end
  end

  def add(arg, tickets) do
    [title | _] = arg
    [%Ticket{title: title, add: DateTime.utc_now, status: " "} | tickets]
  end

  def done(arg, tickets) do
    [index | _] = arg

    todo = tickets |> Enum.filter(&(&1[:status] == " "))
    num = Enum.count(todo)

    case num do
      n when index > n ->
        IO.puts "Given index value was invalid"
        tickets
      _ ->
        item = todo |> Enum.at(String.to_integer(index) - 1)
                    |> (&(%Ticket{&1 | status: "x"})).()
        List.replace_at(tickets, String.to_integer(index) - 1, item)
    end
  end
end