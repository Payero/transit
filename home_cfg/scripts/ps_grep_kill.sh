#!/bin/bash

if [ "$#" -ne 1 ]; then
  echo ""
  echo "************************************************"
  echo "Finds all the processes matching the given name."
  echo ""
  echo "    Usage: $0 <process name> to find " >&2
  echo "************************************************"
  echo ""
  exit 1
fi

# first let's get the process(es) pid(s)
PIDS=`ps -eaf | grep -v grep | grep -i $1 | awk '{print $2}'`

# for each one of them, get the name to show and kill the sucker
if [ ! -z "${PIDS}" ]; then
  for PID in $PIDS; do
    NAME=`ps -eaf | grep -v grep | grep -i $PID | awk '{print $8}'`
    echo "Killing process $PID (${NAME})"
    kill -9 $PID
  done
else
  echo "Could not find process $1"
fi


