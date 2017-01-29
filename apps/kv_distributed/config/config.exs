# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
use Mix.Config

# On the desktop
config :kv_distributed, :routing_table,
  [{?a..?m, :"foo@shockn745-mac-laptop"},
   {?n..?z, :"bar@shockn745-linux-desktop"}]


# On the mac: Uncomment if on mac
# config :kv_distributed, :routing_table,
#   [{?a..?z, :"foo@shockn745-mac-laptop"}]

