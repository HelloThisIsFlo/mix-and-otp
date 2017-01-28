defmodule KVServerTest do
  use ExUnit.Case
  doctest KVServer

  test "the truth" do
    assert 1 + 1 == 2
    IO.puts "Test in kv_server"
  end
end
