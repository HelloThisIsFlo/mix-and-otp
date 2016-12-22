defmodule KV.RegistryTest do
  use ExUnit.Case, async: true

  setup context do
    {:ok, registry} = KV.Registry.start_link(context.test)
    {:ok, registry: registry}
  end

  test "error is thrown when no buckets", %{registry: registry} do
    assert :error = KV.Registry.lookup(registry, "not_existing")
  end

  test "create new bucket and look it up", %{registry: registry} do
    bucket_name = "Bucket Name"
    KV.Registry.create registry, bucket_name

    assert {:ok, pid} = KV.Registry.lookup registry, bucket_name
    assert is_pid(pid)
  end

  test "do not create new bucket, if one already existing with same name", %{registry: registry} do
    bucket_name = "HelloBucket"

    KV.Registry.create registry, bucket_name
    {:ok, bucket} = KV.Registry.lookup registry, bucket_name

    KV.Registry.create registry, bucket_name
    {:ok, new_bucket} = KV.Registry.lookup registry, bucket_name

    assert new_bucket == bucket
  end

  test "can use buckets created by the registry", %{registry: registry} do
    KV.Registry.lookup registry, "shopping" == :error

    KV.Registry.create registry, "shopping"
    {:ok, bucket} = KV.Registry.lookup(registry, "shopping")

    # Test if can actually use the bucket
    KV.Bucket.put(bucket, "milk", 1)
    assert KV.Bucket.get(bucket, "milk") == 1
  end

  test "remove buckets on exit", %{registry: registry} do
    KV.Registry.create registry, "shopping"
    {:ok, bucket} = KV.Registry.lookup registry, "shopping"

    Agent.stop bucket

    assert :error == KV.Registry.lookup registry, "shopping"
  end


  test "removes only bucket that crashes", %{registry: registry} do
    KV.Registry.create registry, "shopping"
    KV.Registry.create registry, "to_be_crashed"
    {:ok, to_crash} = KV.Registry.lookup registry, "to_be_crashed"

    Agent.stop to_crash

    assert :error == KV.Registry.lookup registry, "to_be_crashed"
    assert {:ok, _} = KV.Registry.lookup registry, "shopping"
  end

end
