#!/bin/bash

declare -a Spinner

Spinner=(/ - \\ \| / - \\ \| )
Spinnerpos=0

update_spinner()
{
  printf "\b"${Spinner[$Spinnerpos]} " "
  (( Spinnerpos=(Spinnerpos +1)%8 ))
}

path=$PWD

if [ $# == 1 ]; then
  name=$1
elif [ $# == 2 ]; then
  name=$1
  path=$2
else
  echo ""
  echo "  USAGE:  jfind.sh <name> [path]"
  echo ""
  exit 0
fi

echo "Looking for ${name} in ${path}"
echo ""

for f in `/usr/bin/find ${path} -name "*.jar"`; do
  
  result=`${JAVA_HOME}/bin/jar -tvf $f | /bin/grep ${name} `
  if [ -z "${result}" ]; then
    update_spinner
  else
    echo ""
    echo "${f} ==> ${result}"
    echo ""
  fi
done

echo ""