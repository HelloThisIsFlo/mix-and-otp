defmodule KV.Router do

  def table do
    [{?a..?m, :"foo@shockn745-linux-desktop"},
      {?n..?z, :"bar@shockn745-linux-desktop"}]
  end

  @doc """
  Dispatch the given `mod`, `fun`, `args` request
  to the appropriate node based on the `bucket` first letter.
  """
  def route_and_apply(bucket_name, module, function, args) do
    first = first_letter(bucket_name)

    case find_node(first) do
      {:error, :not_found} ->
        no_entry_error(bucket_name)
      {:ok, node} ->
        if node == node() do
          apply(module, function, args)
        else
          {KV.RouterTasks, node}
          |> Task.Supervisor.async(KV.Router, :route, [bucket_name, module, function, args])
          |> Task.await
        end
    end
  end

  defp first_letter(word), do: word |> String.to_charlist |> List.first

  defp find_node(first_letter) do
    case Enum.find(table(), fn({enum, _node}) -> first_letter in enum end) do
      {_, node} ->
        {:ok, node}
      _ ->
        {:error, :not_found}
    end
  end

  defp no_entry_error(bucket_name),
    do: raise "Could not find entry for #{inspect bucket_name} in table #{inspect table()}"
end

