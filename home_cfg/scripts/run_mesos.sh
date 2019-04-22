#!/bin/bash

is_root=1
if [[ $EUID -ne 0 ]]; then
  is_root=0  
fi

sz=$#
ACTION=""

if [ ${sz} -gt 0  ]; then
  ACTION=$1
fi

if [ "x${ACTION}" == "x" ]; then
  echo "The action was not provided"
  exit 2
fi


echo "****** Starting Mesos-Master  *****"
if [ $is_root -eq 1 ]; then
  /usr/sbin/service mesos-master ${ACTION}
else
  sudo  /usr/sbin/service mesos-master ${ACTION}
fi
sleep 1

echo "****** Starting Mesos-Slave  *****"
if [ $is_root -eq 1 ]; then
   /usr/sbin/service mesos-slave ${ACTION}
else
  sudo  /usr/sbin/service mesos-slave ${ACTION}
fi
sleep 1

echo "****** Starting ZooKeeper  *****"
/opt/zookeeper/bin/zkServer.sh ${ACTION}
sleep 1

