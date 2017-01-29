defmodule KVDistributed.RouterTest do
  use ExUnit.Case, async: true

  @tag :distributed
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
  test "route requests accross nodes" do
    assert KVDistributed.Router.route_and_apply("aaaa", Kernel, :node, []) == String.to_atom("foo@" <> computer_name())
    assert KVDistributed.Router.route_and_apply("zzzz", Kernel, :node, []) == String.to_atom("bar@" <> computer_name())
  end

  defp computer_name, do: "shockn745-linux-desktop"

  test "raises on unknown entries" do
    assert_raise RuntimeError, ~r/Could not find entry/, fn ->
      KVDistributed.Router.route_and_apply(<<0>>, Kernel, :node, [])
    end
  end

end
