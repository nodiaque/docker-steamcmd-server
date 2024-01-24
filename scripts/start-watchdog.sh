#!/bin/bash
killpid="$(pidof enshrouded_server.exe)"
while true
do
  tail --pid=$killpid -f /dev/null
  kill "$(pidof tail)"
  exit 0
done
