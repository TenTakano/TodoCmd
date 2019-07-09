defmodule Todocmd do
  def main(args) do
    %{"targetdir" => targetdir} = "./config.json" |> File.read!
                                                  |> Poison.decode!

    tickets = case File.read(targetdir) do
              {:error, _} -> []
              {:ok, body} -> body |> Poison.decode!(as: [%Ticket{}])
                                  |> update_in([Access.all, :add], &DateTime.from_iso8601/1)
            end

    [subcommand | args] = args
    tickets = case subcommand do
              "add"     -> TicketList.Add.exec(args, tickets)
              "done"    -> TicketList.done(args, tickets)
              "cancel"  -> IO.puts "cancel command"
              "mod"     -> IO.puts "mod command"
              "flush"   -> IO.puts "flush command"
              "list"    -> IO.puts "list command"
            end

    result = File.write(targetdir, Poison.encode!(tickets))
    case result do
      {:error, reason}  -> IO.puts(reason)
      :ok               -> TicketList.Show.exec(args, tickets) |> Enum.each(&(IO.puts &1))
    end
  end
end