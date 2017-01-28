defmodule KV.BucketTest do
  use ExUnit.Case

  setup do
    {:ok, bucket} = KV.Bucket.start_link
    {:ok, bucket: bucket}
  end

  test "stores values by key", %{bucket: bucket} do
    assert KV.Bucket.get(bucket, "milk") == nil

    KV.Bucket.put(bucket, "milk", 3)
    assert KV.Bucket.get(bucket, "milk") == 3
  end

  test "deletes stored value", %{bucket: bucket} do
    KV.Bucket.put(bucket, "milk", 4)
    assert KV.Bucket.get(bucket, "milk") == 4

    deleted = KV.Bucket.delete(bucket, "milk")
    assert deleted == 4
    assert KV.Bucket.get(bucket, "milk") == nil
  end

  test "register process with a name", %{bucket: bucket} do
    KV.Bucket.put(bucket, "keyboard", 12)
    assert KV.Bucket.get(bucket, "keyboard") == 12

    Process.register(bucket, :shopping)
    assert KV.Bucket.get(:shopping, "keyboard") == 12
  end

end
