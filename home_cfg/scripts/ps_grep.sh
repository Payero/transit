#!/bin/bash

APP_NAME=$1

if [ "${APP_NAME}" == "" ]; then
  echo ""
  echo "************************************************"
  echo "Finds all the processes matching the given name."
  echo ""
  echo "    Usage: $0 <process name> to find " >&2
  echo ""
  echo "************************************************"
  echo ""
  exit 1
fi

echo "Looking for ${APP_NAME}"
ps -eaf | grep -v grep | grep -i ${APP_NAME}
