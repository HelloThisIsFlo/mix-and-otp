#!/bin/bash

echo "###############################################"
echo "###  This starts the Bucket App on Mac      ###"
echo "###  ---------------------------------      ###"
echo "###                                         ###"
echo "###  Ready to host buckets on this computer ###"
echo "###############################################"

echo "Going in 'apps/kv_distributed'"
cd apps/kv_distributed/

echo "elixir --sname foo --no-halt -S mix"
elixir --sname foo --no-halt -S mix
