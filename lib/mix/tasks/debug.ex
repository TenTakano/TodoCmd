# Copyright(c) 2019 TenTakano
# All rights reserved.
# See License in the project root for license information.

defmodule Mix.Tasks.Debug do
    use Mix.Task

    @shortdoc "Debug run escript app"
    def run(args) do
        Todocmd.main(args)
    end
end