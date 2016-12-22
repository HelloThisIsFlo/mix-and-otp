defmodule KV.Bucket.SupervisorTest do
  use ExUnit.Case

  test "crashing the bucket supervisor -> crashes all the supervised buckets" do
    {:ok, bucket1} = KV.Bucket.Supervisor.start_bucket
    {:ok, bucket2} = KV.Bucket.Supervisor.start_bucket

    assert bucket1 != bucket2
    ref1 = Process.monitor(bucket1)
    ref2 = Process.monitor(bucket2)

    Process.whereis(KV.Bucket.Supervisor)
    |> Process.exit(:kill)

    # receive do
    #   {:DOWN, ^ref1, _, _, _} = mess -> IO.inspect mess
    # end
    assert_receive {:DOWN, ^ref1, _, _, _}
    assert_receive {:DOWN, ^ref2, _, _, _}
  end

end
