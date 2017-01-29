defmodule KVDistributed.Service do
  alias KVDistributed.Router

  def create(bucket_name) do
    Router.route_and_apply(bucket_name, KV.Service, :create, [bucket_name])
  end

  def put(bucket_name, key, value) do
    Router.route_and_apply(bucket_name, KV.Service, :put, [bucket_name, key, value])
  end

  def get(bucket_name, key) do
    Router.route_and_apply(bucket_name, KV.Service, :get, [bucket_name, key])
  end

  def delete(bucket_name, key) do
    Router.route_and_apply(bucket_name, KV.Service, :delete, [bucket_name, key])
  end

end
