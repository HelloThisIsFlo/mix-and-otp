defmodule KV.Registry do
  use GenServer

  ##################################
  #####      Public API    #########
  ##################################

  @doc """
  Starts the registry with the given 'name'
  """
  def start_link(name) do
    GenServer.start_link(__MODULE__, name, name: name)
  end

  @doc """
  Looks up the bucket pid for 'name' stored in 'server'.

  Returns '{:ok, pid}' if the bucket exists, ':error' otherwise
  """
  def lookup(server, bucket_name) do
    case lookup_bucket(server, bucket_name) do
      [] -> :error
      [{_, result}] -> {:ok, result}
    end
  end

  @doc """
  Ensures there is a bucket associated with the given 'name' in 'server'
  """
  def create(server, bucket_name) do
    # Actually better to use as call here. A cast is never guaranteed to arrive at the target server !!
    GenServer.call(server, {:create, bucket_name})
    :ok
  end

  @doc """
  Stops the registry
  """
  def stop(server) do
    GenServer.stop server
  end

  ###################################
  ######   Genserver callbacks    ###
  ###################################

  def init(table_name) do
    names = :ets.new(table_name, [:named_table, :protected, read_concurrency: true])
    refs = %{}
    {:ok, {names, refs}}
  end

  def handle_call({:create, bucket_name}, _from,  {names, refs} = state) do
    case lookup(names, bucket_name) do
      {:ok, bucket} ->
        {:reply, bucket, state}
      :error ->
        {:ok, bucket} = KV.Bucket.Supervisor.start_bucket
        ref = Process.monitor(bucket)
        refs = Map.put refs, ref, bucket_name
        add_bucket(names, bucket_name, bucket)
        {:reply, bucket, {names, refs}}
    end
  end

  defp has_key?(table, bucket_name), do: Enum.count(:ets.lookup(table, bucket_name)) != 0
  defp add_bucket(table, bucket_name, bucket), do: :ets.insert(table, {bucket_name, bucket})
  defp remove_bucket(table, bucket_name), do: :ets.delete(table, bucket_name)
  defp lookup_bucket(table, bucket_name), do: :ets.lookup(table, bucket_name)

  def handle_info({:DOWN, ref, :process, _pid, _cause}, {names, refs} = _state) do
    {bucket_to_remove, refs} = Map.pop refs, ref
    remove_bucket(names, bucket_to_remove)
    {:noreply, {names, refs}}
  end
  def handle_info(_, state), do: {:noreply, state}

end
