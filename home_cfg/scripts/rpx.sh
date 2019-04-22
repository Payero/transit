#!/bin/bash

path=$PWD

if [ $# == 1 ]; then
  name=$1
elif [ $# == 2 ]; then
  name=$1
  path=$2
else
  echo ""
  echo "  USAGE:  $0 <rpm file> [path]"
  echo ""
  exit 0
fi

echo "Extracting RPM ${name} in ${path}"
echo ""

if [ ! -d $path ]; then
  mkdir -p $path
fi

cp $name $path/.

cd $path && rpm2cpio $name | cpio -id && rm -f $name
