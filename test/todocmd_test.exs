defmodule TodocmdTest do
  use ExUnit.Case
  doctest Todocmd

  alias TicketList.{Show, Add, Finished}

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

  defp callFinishedFunc(sign, f) do
    {_, list} = makeSample()
    length = list |> Enum.filter(&(&1[:status] == " "))
                  |> Enum.count

    invalids = [
      %{test_arg: [], result: {:error, :invalid_args}},
      %{test_arg: ["text"], result: {:error, :invalid_args}},
      %{test_arg: [Integer.to_string(length + 1)], result: {:error, :index_out_of_range}},
      %{test_arg: [Integer.to_string(-1)], result: {:error, :index_out_of_range}}
    ]

    Enum.each(invalids, fn item ->
      assert item[:result] == f.(item[:test_arg], list)
    end)

    replace = fn index, list ->
      item = list |> Enum.at(index)
                  |> (&(%Ticket{&1 | status: sign})).()
      List.replace_at(list, index, item)
    end

    {_, list} = makeSample()
    expected = replace.(0, list)
    list = f.(["1"], list)
    assert expected == list

    list = expected
    expected = replace.(2, list)
    list = f.(["1"], list)
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

  test "test of show command" do
    assert Show.exec([], []) == {:error, :empty_list}
    assert Show.exec(["arg"], []) == {:error, :invalid_args}
  end

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
    callFinishedFunc("x", &Finished.done/2)
  end

  test "test of cancel command" do
    callFinishedFunc("-", &Finished.cancel/2)
  end
end
