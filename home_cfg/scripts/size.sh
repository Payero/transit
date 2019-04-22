#!/bin/bash

if [ -f /tmp/out_dirs.txt ]; then
  rm -f /tmp/out_dirs.txt
fi

TGT=`echo $PWD`
DEPTH=1

if [ $# == 1 ]; then
  TGT=$1
elif [ $# == 2 ]; then
  TGT=$1
  DEPTH=$2
fi

echo "Checking size on: ${TGT}"


DU_CMD="/usr/bin/du -csh "
FNAME=/tmp/out_dirs.txt

touch ${FNAME}

for d in $( find ${TGT} -maxdepth ${DEPTH} -type d ); do
 
 ${DU_CMD} $d | grep $d >> ${FNAME}
done

sort -h ${FNAME}
