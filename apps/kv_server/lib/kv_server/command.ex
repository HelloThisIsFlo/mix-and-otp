defmodule KVServer.Command do

  @ok {:ok, "OK\r\n"}
  @error {:error, :unknown_error}

  @doc ~S"""
  Parses the given `line` into a command.

  ## Examples

    iex> KVServer.Command.parse "CREATE shopping\r\n"
    {:ok, {:create, "shopping"}}

    iex> KVServer.Command.parse "CREATE  shopping\r\n"
    {:ok, {:create, "shopping"}}

    iex> KVServer.Command.parse "PUT shopping milk 1\r\n"
    {:ok, {:put, "shopping", "milk", "1"}}

    iex> KVServer.Command.parse "GET shopping milk\r\n"
    {:ok, {:get, "shopping", "milk"}}

    iex> KVServer.Command.parse "DELETE shopping eggs\r\n"
    {:ok, {:delete, "shopping", "eggs"}}

  Unknown commands or commands with the wrong number of arguments
  ==> Returns an error

    iex> KVServer.Command.parse "UNKNOWN shopping eggs\r\n"
    {:error, :unknown_command}

    iex> KVServer.Command.parse "GET shopping\r\n"
    {:error, :unknown_command}

  """
  def parse(line) do
    case String.split(line) do
      ["CREATE", bucket] -> {:ok, {:create, bucket}}
      ["PUT", bucket, key, value] -> {:ok, {:put, bucket, key, value}}
      ["GET", bucket, key] -> {:ok, {:get, bucket, key}}
      ["DELETE", bucket, key] -> {:ok, {:delete, bucket, key}}
      _ -> {:error, :unknown_command}
    end
  end


  @doc """
  Runs the given command
  """
  def run(command)
  def run({:create, bucket}) do
    case KV.Service.create(bucket) do
      _ -> @ok
    end
  end
  def run({:put, bucket, key, value}) do
    case KV.Service.put(bucket, key, value) do
      _ -> @ok
    end
  end
  def run({:get, bucket, key}) do
    case KV.Service.get(bucket, key) do
      {:ok, value} ->
        {:ok, "#{value}\r\nOK\r\n"}
      {:error, :key_not_found} ->
        {:ok, "\r\nOK\r\n"}
      {:error, :bucket_not_found} ->
        {:error, :bucket_not_found}
      _ ->
        @error
    end
  end
  def run({:delete, bucket, key}) do
    case KV.Service.delete(bucket, key) do
      _ -> @ok
    end
  end

end
