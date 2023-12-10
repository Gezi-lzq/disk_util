#!/bin/bash

if [ $# -ne 2 ]; then
  echo "Usage: $0 <store_path> <sampling_interval>"
  exit 1
fi

STORE="$1"
SAMPLING_INTERVAL="$2"

device=$(df -P "$STORE" | awk 'NR==2 {gsub("/dev/", "", $1); print $1}')
util=$(iostat -x -d "$device" 1 3 2>/dev/null | awk 'NR==4 {print $NF}')

if [ -z "$util" ]; then
  initial=$(awk -v dev="$device" '$3 == dev {print $13}' /proc/diskstats)

  sleep "$SAMPLING_INTERVAL"

  new=$(awk -v dev="$device" '$3 == dev {print $13}' /proc/diskstats)
  diff=$((new - initial))
  rate=$(awk -v diff="$diff" -v sampling_rate="$SAMPLING_INTERVAL" 'BEGIN { printf "%.2f\n", diff / sampling_rate }')

  if [ $(awk 'BEGIN {print ('"$rate"' > 100)}') ]; then
    rate=100
  fi

  util="$rate"
fi

echo "Disk utilization: $util"