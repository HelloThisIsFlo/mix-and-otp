# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
use Mix.Config

# By default, the umbrella project as well as each child
# application will require this configuration file, ensuring
# they all use the same configuration. While one could
# configure all applications here, we prefer to delegate
# back to each application for organization purposes.
import_config "../apps/*/config/config.exs"
config :iex, default_prompt: ">c>u>s>t>o>m>"





# On the desktop
config :kv_distributed, :routing_table,
  [{?a..?m, :"foo@shockn745-mac-laptop"},
   {?n..?z, :"bar@shockn745-linux-desktop"}]


# On the mac: Uncomment if on mac
# config :kv_distributed, :routing_table,
#   [{?a..?z, :"foo@shockn745-mac-laptop"}]



