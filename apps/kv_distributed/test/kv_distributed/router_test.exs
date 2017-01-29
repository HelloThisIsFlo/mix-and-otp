defmodule KVDistributed.RouterTest do
  use ExUnit.Case, async: true

  @tag :distributed
  test "route requests accross nodes" do
    assert KVDistributed.Router.route_and_apply("aaaa", Kernel, :node, []) == :"foo@shockn745-linux-desktop"
    assert KVDistributed.Router.route_and_apply("zzzz", Kernel, :node, []) == :"bar@shockn745-linux-desktop"
  end

  test "raises on unknown entries" do
    assert_raise RuntimeError, ~r/Could not find entry/, fn ->
      KVDistributed.Router.route_and_apply(<<0>>, Kernel, :node, [])
    end
  end

end
