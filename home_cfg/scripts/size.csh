#!/bin/tcsh

set TGT=`pwd`
set DEPTH=1

if ($#argv == 1 ) then
  set TGT=$1
else if ($#argv == 1 ) then
  set TGT=$1
  DEPTH=$2
endif


echo "Checking size on: $TGT up to $DEPTH levels"

set DU_CMD="/usr/bin/du -csh "
set FNAME=/tmp/out_dirs.txt
rm -f ${FNAME}

foreach d (`find ${TGT} -maxdepth ${DEPTH} -type d`)
  #echo "looking at directory $d"
  ${DU_CMD} $d | grep $d >> ${FNAME}
end

sort -f ${FNAME}

