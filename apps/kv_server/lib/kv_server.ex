defmodule KVServer do
  require Logger

  #############################
  ###   Accept connections  ###
  #############################
  def accept(port) do
    # The options below mean:
    #
    # 1. ':binary' - receives data as binaries (instead of lists)
    # 2. 'packet: :line' - receives data line by line
    # 3. 'active: false' - blocks on ':gen_tcp.recv/2' until data is available
    # 4. 'reuseaddr: true' - allows us to reuse the address if the listener crashes
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
    # Otherwise the process that accepted (this one) would be responsible ... and if it crashes ... all socket crash
    :ok = :gen_tcp.controlling_process(client, pid)
    loop_acceptor(socket)
  end



  ###########################
  ###   Serve client    #####
  ###########################
  defp serve(socket) do
    msg =
      with {:ok, data} <- read_line(socket),
           {:ok, command} <- KVServer.Command.parse(data),
           do: KVServer.Command.run(command)

    write_line(socket, msg)

    serve(socket)
  end

  defp read_line(socket), do: :gen_tcp.recv(socket, 0)
  defp write_line(socket, {:ok, text}), do: :gen_tcp.send(socket, text)
  defp write_line(socket, {:error, :unknown_command}), do: :gen_tcp.send(socket, "UNKNOWN COMMAND\r\n")
  defp write_line(socket, {:error, :bucket_not_found}), do: :gen_tcp.send(socket, "NOT FOUND\r\n")
  defp write_line(socket, {:error, :closed}), do: exit(:shutdown)
  defp write_line(socket, {:error, error}) do
    #Unknown error, write to client and exit
    :gen_tcp.send(socket, "ERROR\r\n")
    exit(error)
  end


end
