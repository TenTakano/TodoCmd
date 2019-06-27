defmodule Mix.Tasks.Debug do
    use Mix.Task

    @shortdoc "Debug run escript app"
    def run(args) do
        Todocmd.main(args)
    end
end