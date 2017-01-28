defmodule KVServer do
  require Logger

  def accept(port) do
    # The options below mean:
    #
    # 1. ':binary' - receives data as binaries (instead of lists)
    # 2. 'packet: :line' - receives data line by line
    # 3. 'active: false' - blocks on ':gen_tcp.recv/2' until data is available
    # 4. 'reuseaddr: true' - allows us to reuse the address if the listener crashes
    #

    {:ok, socket} = :gen_tcp.listen(
      port,
      [:binary, packet: :line, active: false, reuseaddr: true]
    )
    Logger.info "Accepting connections on port #{port}"
    loop_acceptor(socket)
  end

  defp loop_acceptor(socket) do
    {:ok, client} = :gen_tcp.accept(socket)
    {:ok, pid} = Task.Supervisor.start_child(
      KVServer.TaskSupervisor,
      fn -> serve(client) end
    )
    # Delegate the resposability of the socket to the process with 'pid'
    # Otherwise the process that accepted (this one) would be responsible ... and if it crashes ... all socket crashjkk
    :ok = :gen_tcp.controlling_process(client, pid)
    loop_acceptor(socket)
  end

  defp serve(socket) do
    socket
    |> read_line()
    |> write_line(socket)

    serve(socket)
  end

  defp read_line(socket) do
    {:ok, data} = :gen_tcp.recv(socket, 0)
    Logger.info "Reading line: #{data}"
    data
  end

  defp write_line(line, socket), do: :gen_tcp.send(socket, line)

end
