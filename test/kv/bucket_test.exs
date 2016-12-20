defmodule KV.BucketTest do
  use ExUnit.Case

  setup do
    {:ok, bucket} = KV.Bucket.start_link
    {:ok, bucket: bucket}
  end

  test "Stores values by key", %{bucket: bucket} do
    assert KV.Bucket.get(bucket, "milk") == nil

    KV.Bucket.put(bucket, "milk", 3)
    assert KV.Bucket.get(bucket, "milk") == 3
  end

  test "Deletes stored value", %{bucket: bucket} do
    KV.Bucket.put(bucket, "milk", 4)
    assert KV.Bucket.get(bucket, "milk") == 4

    deleted = KV.Bucket.delete(bucket, "milk")
    assert deleted == 4
    assert KV.Bucket.get(bucket, "milk") == nil
  end

end
