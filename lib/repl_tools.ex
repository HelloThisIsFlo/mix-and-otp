defmodule ReplTools do

  def create_bucket(bucket_name) do
    KV.Registry.create KV.Registry, bucket_name
  end

  def put_random(bucket_name) do
    {:ok, bucket} = KV.Registry.lookup KV.Registry, bucket_name
    KV.Bucket.put bucket, "milk", 12
  end

  def kill_bucket(bucket_name) do
    {:ok, bucket} = KV.Registry.lookup KV.Registry, bucket_name
    Process.exit(bucket, :kill)
  end

  def kill_bucket_supervisor do
    Process.whereis(KV.Bucket.Supervisor)
    |> Process.exit(:kill)
  end
end
