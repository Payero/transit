#!/bin/bash

if ! command -v fortune >/dev/null 2>&1; then
  echo "fortune is not installed"
  exit -1
  if ! command -v cowsay >/dev/null 2>&1; then
    echo "cowsay is not installed"
    exit -1
  fi
fi

IMAGE="whale"

if [ "$#" -eq 1 ]; then
  IMAGE=$1
fi

dbname=softeng
now=`date +%s`

if [ $((now%2)) -eq 0 ] ; then
  dbname=softeng
else
  dbname=oneliners
fi


 
if [[ "$IMAGE" == "names" ]]; then
  cd /usr/share/cowsay
  ls *.cow
else
  fortune ${dbname} | cowsay -f ${IMAGE}
fi
