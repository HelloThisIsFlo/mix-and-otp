# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
use Mix.Config

# Do mix clean after changing this value
config :kv_server,
  service: KVDistributed.Service

import_config "#{Mix.env}.exs"
