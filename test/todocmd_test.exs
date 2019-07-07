defmodule TodocmdTest do
  use ExUnit.Case
  doctest Todocmd

  alias TicketList.{Add, Done}

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

  test "test of add command" do
    invalids = [
      %{test_arg: [], result: {:error, :invalid_args}},
      %{test_arg: ["arg1", "arg2"], result: {:error, :invalid_args}}
    ]
    Enum.each(invalids, fn pair ->
      assert Add.exec(pair[:test_arg], []) == pair[:result]
    end)

    arg = "arg1"
    sample = [arg]  |> Add.exec([])
                    |> Enum.at(0)

    assert sample[:title] == arg
    assert sample[:status] == " "
  end

  test "test of done command" do
    {_, list} = makeSample()
    length = list |> Enum.filter(&(&1[:status] == " "))
                  |> Enum.count

    invalids = [
      %{test_arg: [], result: {:error, :invalid_args}},
      %{test_arg: ["text"], result: {:error, :invalid_args}},
      %{test_arg: [length + 1], result: {:error, :index_out_of_range}},
      %{test_arg: [-1], result: {:error, :index_out_of_range}}
    ]

    Enum.each(invalids, fn item ->
      assert item[:result] == Done.exec(item[:test_arg], list)
    end)

    replace = fn index, list ->
      item = list |> Enum.at(index)
                  |> (&(%Ticket{&1 | status: "x"})).()
      List.replace_at(list, index, item)
    end

    {_, list} = makeSample()
    expected = replace.(0, list)
    list = Done.exec([1], list)
    assert expected == list

    list = expected
    expected = replace.(2, list)
    list = Done.exec([1], list)
    assert expected == list

    IO.inspect expected
  end
end
