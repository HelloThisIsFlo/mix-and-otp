defmodule KV.Service do

  def create(bucket_name) do
    KV.Registry.create(KV.Registry, bucket_name)
  end

  def put(bucket_name, key, value) do
    lookup bucket_name, fn(bucket) ->
      KV.Bucket.put(bucket, key, value)
    end
  end

  def get(bucket_name, key) do
    lookup bucket_name, fn(bucket) ->
      case KV.Bucket.get(bucket, key) do
        nil -> {:error, :key_not_found}
        val -> {:ok, val}
      end
    end
  end

  def delete(bucket_name, key) do
    lookup bucket_name, fn(bucket) ->
      KV.Bucket.delete(bucket, key)
      :ok
    end
  end

  defp lookup(bucket_name, callback) do
    case KV.Registry.lookup(KV.Registry, bucket_name) do
      {:ok, pid} ->
        callback.(pid)
      :error ->
        {:error, :bucket_not_found}
    end
  end


end
