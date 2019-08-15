# Copyright(c) 2019 TenTakano
# All rights reserved.
# See License in the project root for license information.

defmodule IssueList.FinishedTest do
	use ExUnit.Case

	alias IssueList.Finished

  defp makeSample do
    sampleTime =  %DateTime{year: 2019, month: 7, day: 7,
                        hour: 18, minute: 50, second: 7, microsecond: {0, 0},
                        utc_offset: 0, std_offset: 0,
                        time_zone: "Etc/GMT", zone_abbr: "UTC"}
    
    sampleList = [
      %Issue{status: " ", title: "Test1", add: sampleTime},
      %Issue{status: "x", title: "Test2", add: sampleTime},
      %Issue{status: " ", title: "Test3", add: sampleTime}
    ]

    {sampleTime, sampleList}
  end

  defp callFinishedFunc(sign, f) do
    # test invalid cases
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

    # test valid cases
    replace = fn index, list ->
      item = list |> Enum.at(index)
                  |> (&(%Issue{&1 | status: sign})).()
      List.replace_at(list, index, item)
    end

    {_, list} = makeSample()
    expected = replace.(0, list)
    list = f.(["1"], list)
    assert expected == list

    list = expected
    expected = replace.(2, list)
    list = f.(["1"], list)
    assert expected == list
	end
	
  test "test of done command" do
    callFinishedFunc("x", &Finished.done/2)
  end

  test "test of cancel command" do
    callFinishedFunc("-", &Finished.cancel/2)
  end	
end