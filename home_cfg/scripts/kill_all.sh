#!/bin/bash

if [ "$#" -ne 1 ]; then
  echo ""
  echo "************************************************"
  echo "Kills all the processes matching the given name."
  echo ""
  echo "    Usage: $0 <process name> to find and kill" >&2
  echo "************************************************"
  echo ""
  exit 1
fi


APP=$1
PIDS=`pgrep -f $APP`
array=($PIDS)
size=${#array[@]}
echo "Killing $size processes matching $APP"

for i in `pgrep -f $APP`
do
  echo "Killing Process: $i"
  kill -9 $i
done
