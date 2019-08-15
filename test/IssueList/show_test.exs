# Copyright(c) 2019 TenTakano
# All rights reserved.
# See License in the project root for license information.

defmodule IssueList.ShowTest do
  use ExUnit.Case

  alias IssueList.Show

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

  #   assert IssueList.to_string(list) == expected
  # end

  test "test of show command" do
    assert Show.exec([], []) == {:error, :empty_list}
    assert Show.exec(["arg"], []) == {:error, :invalid_args}
  end
end