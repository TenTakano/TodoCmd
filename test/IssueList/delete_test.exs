# Copyright(c) 2019 TenTakano
# All rights reserved.
# See License in the project root for license information.

defmodule IssueList.DeleteTest do
  use ExUnit.Case

  alias IssueList.Delete
  alias TestHelper, as: Helper

  test "test of delete command" do
    {_, sample} = Helper.makeSample()

    expected = Enum.filter(sample, &(&1[:status] == " "))
    assert expected == Delete.exec([], sample)
    assert expected == Delete.exec([], expected)

    finished = Enum.filter(sample, &(&1[:status] != " "))
    assert [] == Delete.exec([], finished)
  end
end