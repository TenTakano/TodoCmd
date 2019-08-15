# Copyright(c) 2019 TenTakano
# All rights reserved.
# See License in the project root for license information.

defmodule IssueList.FinishTest do
	use ExUnit.Case

  alias IssueList.Finish
  alias TestHelper, as: Helper

  defp callFinishFunc(sign, f) do
    # test invalid cases
    {_, list} = Helper.makeSample()
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

    {_, list} = Helper.makeSample()
    expected = replace.(0, list)
    list = f.(["1"], list)
    assert expected == list

    list = expected
    expected = replace.(2, list)
    list = f.(["1"], list)
    assert expected == list
	end
	
  test "test of done command" do
    callFinishFunc("x", &Finish.done/2)
  end

  test "test of cancel command" do
    callFinishFunc("-", &Finish.cancel/2)
  end	
end