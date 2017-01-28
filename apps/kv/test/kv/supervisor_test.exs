defmodule KV.SupervisorTest do
  use ExUnit.Case

  # The reason for this is: There is no point keeping the bucket supervisors if they're not accessible anymore
  # through the Registry
  test "KV.Registry crash makes KV.Bucket.Supervisor crash" do
    # Ensure KV.Registry is started
    assert :ok == KV.Registry.create(KV.Registry, "shopping")

    registry_pid = Process.whereis(KV.Registry)
    bucket_sup_ref = Process.monitor(KV.Bucket.Supervisor)

    Process.exit(registry_pid, :shutdown)

    assert_receive {:DOWN, ^bucket_sup_ref, _, _, _}
  end

end
