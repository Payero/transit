#!/bin/bash

#
# To connect to a server through a proxy server using ~/.ssh/config
#   ProxyCommand ssh <proxy> "/bin/bash -c 'exec 3<>/dev/tcp/%h/22; cat <&3 & cat >&3; kill \$!'"
#
#TEMP=`getopt -o hc:f:j:d:t:r: --longoptions help,config-file:,file:,jobs:dest:,kill-task:,reply-to: -n $0 -- "$@"`
TEMP=`getopt -s tcsh -o hw:l:s:r:p:t: --longoptions help,wait-time:,local-port:,server-name:,remote-port:,proxy-server: -n "$0" -- "$argv"`

# Prints the Usage
usage()
{
  echo ''
  echo "####################################################################"
  echo "#"
  echo "#   Usage:  $0 [Options]"
  echo "#"
  echo "#       -w, --wait-time       How long to wait before running vncviewer"
  echo "#       -l, --local-port      The port used at the local host"
  echo "#       -r, --remote-port     The VNC port opened by the remote server"
  echo "#       -p, --proxy-server    The name of the proxy server to use"
  echo "#       -s, --server-name     The name of the remote server"
  echo "#       -h, --help            Displays this message and exits"
  echo "#"
  echo "####################################################################"
  echo ''
  exit 0
}

WAIT_TIME=10
LOCAL_PORT=5917
REM_PORT=5907
SERVER="rfims02"
PROXY_SRV="proxy"

eval set -- "$TEMP"
while true ; do
  case "$1" in
  -h | --help ) usage ; break ;;
  -l | --local-port ) LOCAL_PORT=$2 ; shift 2 ;;
  -r | --remote-port ) REM_PORT=$2 ; shift 2 ;;
  -p | --proxy-server ) PROXY_SRV=$2 ; shift 2 ;;
  -s | --server-name ) SERVER=$2 ; shift 2 ;;
  -w | --wait-time ) WAIT_TIME=$2 ; shift 2 ;;
    * ) break ;;
  esac
done

if [ -z "$SERVER" ] ; then
  echo "The server name ($SERVER) is required and was not provided"
  usage
fi


if [ -z ${HOSTNAME} ]; then
  export HOSTNAME=`hostname`
fi

# Want to make sure the sleep timem is relative to the wait time
@ SLEEP_TIME = $WAIT_TIME * 4

xterm -e "echo 'Waiting for ${WAIT_TIME} secods before connecting'; sleep ${SLEEP_TIME}; vncviewer -Shared :${LOCAL_PORT}" &

if [ -z "$PROXY" ]; then
  echo "NOTE: Not using proxy server"
  ssh -L ${LOCAL_PORT}:localhost:${REM_PORT} ${SERVER}
else
  echo "NOTE: Using proxy server"
  ssh -t ${PROXY} "ssh -f -R ${LOCAL_PORT}:localhost:5${LOCAL_PORT} ${HOSTNAME} sleep $SLEEP_TIME; ssh -L 5${LOCAL_PORT}:localhost:${REM_PORT} ${SERVER}"
  ssh -L ${LOCAL_PORT}:localhost:${REM_PORT} ${SERVER}
fi
