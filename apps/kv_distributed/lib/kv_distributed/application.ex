defmodule KVDistributed.Application do
  @moduledoc false

  use Application

  def start(_type, _args) do
    import Supervisor.Spec, warn: false

    children = [
      supervisor(Task.Supervisor, [[name: KVDistributed.RouterTasks]])
    ]
    opts = [strategy: :one_for_one, name: KVDistributed.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
