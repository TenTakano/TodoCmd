defmodule TodocmdTest do
  use ExUnit.Case
  doctest Todocmd

  defp makeSample do
    sampleTime =  %DateTime{year: 2019, month: 7, day: 7,
                        hour: 18, minute: 50, second: 7, microsecond: {0, 0},
                        utc_offset: 0, std_offset: 0,
                        time_zone: "Etc/GMT", zone_abbr: "UTC"}
    
    sampleList = [
      %Ticket{status: " ", title: "Test1", add: sampleTime},
      %Ticket{status: "x", title: "Test2", add: sampleTime},
      %Ticket{status: " ", title: "Test3", add: sampleTime}
    ]

    {sampleTime, sampleList}
  end

  test "Todo.to_string should warn if empty list is given" do
    assert {:error, :empty_list} == TicketList.to_string([])
  end

  # Todo: uncomment when timezone issue is resolved
  # test "Todo.to_string function" do
  #   {time, list} = makeSample
  #   time = time |> DateTime.to_string
  #               |> String.slice(0, 19)

  #   expected = [
  #     "1, Test1, " <> time <> ",  ",
  #     "2, Test2, " <> time <> ", x",
  #     "3, Test3, " <> time <> ",  "
  #   ]

  #   assert TicketList.to_string(list) == expected
  # end

  test "Todo.add should return error if called with empty args" do
    assert {:error, :invalid_args} == TicketList.add([], [])
  end

  test "Todo.add returns new task list" do
    title = "Title1"
    output = TicketList.add([title], []) 
                |> Enum.at(0)

    assert output[:title] == title
    assert output[:status] == " "
  end
end
