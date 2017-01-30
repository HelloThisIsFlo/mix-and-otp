#!/bin/bash

echo "###############################################"
echo "###  This starts the Bucket App on Desktop  ###"
echo "###  -------------------------------------  ###"
echo "###                                         ###"
echo "###  Ready to host buckets on this computer ###"
echo "###############################################"

echo "Going in 'apps/kv_distributed'"
cd apps/kv_distributed/

echo "elixir --sname bar --no-halt -S mix"
elixir --sname bar --no-halt -S mix
