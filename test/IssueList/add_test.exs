# Copyright(c) 2019 TenTakano
# All rights reserved.
# See License in the project root for license information.

defmodule IssueList.AddTest do
	use ExUnit.Case

	alias IssueList.Add

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
end