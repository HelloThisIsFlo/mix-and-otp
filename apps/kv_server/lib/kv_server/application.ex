defmodule KVServer.Application do
  @moduledoc false

  use Application

  def start(_type, _args) do
    import Supervisor.Spec, warn: false


    # Define workers and child supervisors to be supervised
    children = [
      # Starts a worker by calling: KVServer.Worker.start_link(arg1, arg2, arg3)
      # worker(KVServer.Worker, [arg1, arg2, arg3]),
      supervisor(Task.Supervisor, [[name: KVServer.TaskSupervisor]]),
      worker(Task, [KVServer, :accept, [port()]]),
      supervisor(Task.Supervisor, [[name: KVServer.RouterTasks]], id: KVServer.RouterTasks)
    ]

    opts = [strategy: :one_for_one, name: KVServer.Supervisor]
    Supervisor.start_link(children, opts)
  end

  defp port do
    if Mix.env == :test do
      1234
    else
      4040
    end
  end
end
