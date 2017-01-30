#!/bin/bash

echo "########################################################"
echo "###  This starts the TCP server                      ###"
echo "###  ------------------------                        ###"
echo "###                                                  ###"
echo "###  Ready to listen to telnet connections on 4040   ###"
echo "########################################################"


echo "elixir --sname server -S mix run  --no-halt"
elixir --sname server -S mix run  --no-halt
