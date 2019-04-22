#!/bin/bash

TGT_DIR=/projects/users/oegante/7Hills/transfer
DIST_DIR=/nishome/oegante/workspace/ccdp-engine-dist

#if [ ! -d "${TGT_DIR}" ]; then 
#
#  echo "The directory cannot be found, mounting it"
#  sudo  mount -v -t cifs -o username=oganteaume,domain=lgsdirect,iocharset=utf8,sec=ntlm,uid=1000,gid=1000 //lgs-fs15.lgsdirect.com/Home_Folder/oganteaume /media/lgs
#else
#  echo "The Directory is already mounted"
#fi

FNAME=`date +"%m-%d-%y"`_ccdp-engine
echo "Cloning the ccdp-engine as '${TGT_DIR}/$FNAME'"

cd $DIST_DIR
echo "Merging Source into Dist ==> master"
git co master
git pull source master
git push dist master

echo "Merging Source into Dist ==> oeg-dev"
git co oeg-dev
git pull source oeg-dev
git push dist oeg-dev


echo "Clonning repository"
if [ -d ${TGT_DIR}/${FNAME} ] ; then
  echo "Directory ${TGT_DIR}/${FNAME} exists, removing it"
  rm -fR ${TGT_DIR}/${FNAME}
fi

CMD="git clone --mirror git@gitlab.lgsinnovations.com:ccdp/engine-dist ${TGT_DIR}/${FNAME}"

echo "Running ${CMD}"
exec $CMD
