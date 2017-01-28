defmodule KVServer do
  @moduledoc """
  Documentation for KVServer.
  """

  def hello(bucket_name, to_save) do
    KV.Registry.create(KV.Registry, bucket_name)
    {:ok, bucket} = KV.Registry.lookup(KV.Registry, bucket_name)

    KV.Bucket.put(bucket, to_save, 23)
    bucket
  end
end
