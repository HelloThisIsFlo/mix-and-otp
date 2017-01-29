defmodule KVDistributed.ServiceTest do
  use ExUnit.Case, async: true
  alias KVDistributed.Service

  @moduletag :distributed
  ~S"""
  To run the distributed tags:
  - On one terminal run:
      'iex --sname bar -S mix'

  - On the other terminal run:
      'elixir --sname foo -S mix test --include distributed'

  This assumes the routing table is:
      [{?a..?m, :"foo@COMPUTER_NAME"},
      {?n..?z, :"bar@COMPUTER_NAME"}]
  with COMPUTER_NAME the name of the computer running the tests.
  """

  test "bucket doesn't exist" do
    assert {:error, :bucket_not_found} == Service.put("inexisting", "key", "value")
    assert {:error, :bucket_not_found} == Service.get("inexisting", "key")
    assert {:error, :bucket_not_found} == Service.delete("inexisting", "key")
  end



  ##############################
  ###   Tests on node foo    ###
  ##############################
  test "on foo: key doesn't exist" do
    assert :ok = Service.create("aaaaaa_bucket")
    assert {:error, :key_not_found} = Service.get("aaaaaa_bucket", "key")
    assert :ok = Service.delete("aaaaaa_bucket", "key") # No check on delete
  end
  test "on foo: save and retrieve value" do
    assert :ok = Service.create("bbbbb_bucket")
    assert :ok = Service.put("bbbbb_bucket", "key", 12)
    assert {:ok, 12} = Service.get("bbbbb_bucket", "key")
  end
  test "on foo: save, delete and retrieve value" do
    assert :ok = Service.create("ccccc_bucket")
    assert :ok = Service.put("ccccc_bucket", "key", 12)
    assert :ok = Service.delete("ccccc_bucket", "key")
    assert {:error, :key_not_found} = Service.get("ccccc_bucket", "key")
  end


  ##############################
  ###   Tests on node bar    ###
  ##############################
  # According to the routing table, these nodes will run on bar
  test "on bar: key doesn't exist" do
    assert :ok = Service.create("zzzzz_bucket")
    assert {:error, :key_not_found} = Service.get("zzzzz_bucket", "key")
    assert :ok = Service.delete("zzzzz_bucket", "key") # No check on delete
  end
  test "on bar: save and retrieve value" do
    assert :ok = Service.create("yyyy_bucket")
    assert :ok = Service.put("yyyy_bucket", "key", 12)
    assert {:ok, 12} = Service.get("yyyy_bucket", "key")
  end
  test "on bar: save, delete and retrieve value" do
    assert :ok = Service.create("xxxx_bucket")
    assert :ok = Service.put("xxxx_bucket", "key", 12)
    assert :ok = Service.delete("xxxx_bucket", "key")
    assert {:error, :key_not_found} = Service.get("xxxx_bucket", "key")
  end
end
