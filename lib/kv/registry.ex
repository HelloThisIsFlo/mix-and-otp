defmodule KV.Registry do
  use GenServer

  ##################################
  #####      Public API    #########
  ##################################

  @doc """
  Starts the registry with the given 'name'
  """
  def start_link(name) do
    GenServer.start_link(__MODULE__, :ok, name: name)
  end

  @doc """
  Looks up the bucket pid for 'name' stored in 'server'.

  Returns '{:ok, pid}' if the bucket exists, ':error' otherwise
  """
  def lookup(server, bucket_name) do
    GenServer.call(server, {:lookup, bucket_name})
  end

  @doc """
  Ensures there is a bucket associated with the given 'name' in 'server'
  """
  def create(server, bucket_name) do
    # Actually better to use as call here. A cast is never guaranteed to arrive at the target server !!
    GenServer.cast(server, {:create, bucket_name})
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

  def init(:ok) do
    names = %{}
    refs = %{}
    {:ok, {names, refs}}
  end

  def handle_call({:lookup, bucket_name}, _sender, {names, _refs} = state) do
    {:reply, Map.fetch(names, bucket_name), state}
  end

  def handle_cast({:create, bucket_name}, {names, refs} = state) do
    if Map.has_key? names, bucket_name do
      {:noreply, state}
    else
      {:ok, bucket} = KV.Bucket.Supervisor.start_bucket
      ref = Process.monitor(bucket)
      refs = Map.put refs, ref, bucket_name
      names = Map.put names, bucket_name, bucket
      {:noreply, {names, refs}}
    end
  end

  def handle_info({:DOWN, ref, :process, _pid, _cause}, {names, refs} = _state) do
    {bucket_to_remove, refs} = Map.pop refs, ref
    names = Map.delete names, bucket_to_remove
    {:noreply, {names, refs}}
  end
  def handle_info(_, state), do: {:noreply, state}

end
