defmodule KV.Bucket do
  use GenServer

  def start_link do
    Agent.start_link fn -> [] end
  end

  def get(pid, key_to_find) do
    Agent.get pid, fn(store) ->
      Enum.filter(store, fn({key, _value}) -> key == key_to_find end)
      |> first_or_nil
      |> get_value
    end
  end

  def put(pid, key, value) do
    Agent.update pid, fn(store) ->
      [{key, value} |  store]
    end
  end


  defp get_value({_key, value}), do: value
  defp get_value(nil), do: nil

  defp first_or_nil([]), do: nil
  defp first_or_nil(list) when is_list(list) do
    List.first list
  end

end
