defmodule KV.ServiceTest do
  use ExUnit.Case, async: true
  alias KV.Service

  setup(context) do
    {:ok, bucket_name: context.test}
  end

  test "bucket doesn't exist" do
    assert {:error, :bucket_not_found} == Service.put("inexisting", "key", "value")
    assert {:error, :bucket_not_found} == Service.get("inexisting", "key")
    assert {:error, :bucket_not_found} == Service.delete("inexisting", "key")
  end

  test "key doesn't exist", %{bucket_name: bucket_name} do
    assert :ok = Service.create(bucket_name)
    assert {:error, :key_not_found} = Service.get(bucket_name, "key")
    assert :ok = Service.delete(bucket_name, "key") # No check on delete
  end

  test "save and retrieve value", %{bucket_name: bucket_name} do
    assert :ok = Service.create(bucket_name)
    assert :ok = Service.put(bucket_name, "key", 12)
    assert {:ok, 12} = Service.get(bucket_name, "key")
  end

  test "save, delete and retrieve value", %{bucket_name: bucket_name} do
    assert :ok = Service.create(bucket_name)
    assert :ok = Service.put(bucket_name, "key", 12)
    assert :ok = Service.delete(bucket_name, "key")
    assert {:error, :key_not_found} = Service.get(bucket_name, "key")
  end

end
