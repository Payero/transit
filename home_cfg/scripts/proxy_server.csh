#!/bin/tcsh

#
# To connect to a server through a proxy server using ~/.ssh/config
#   ProxyCommand ssh <proxy> "/bin/bash -c 'exec 3<>/dev/tcp/%h/22; cat <&3 & cat >&3; kill \$!'"
#

set wait_time=10
set loc_port=5907
set rem_port=5907
set server=""
set proxy=""

set TEMP=(`getopt -s tcsh -o hw:l:s:r:p:t: --longoptions help,wait-time:,local-port:,server-name:,remote-port:,proxy-server: -n "$0" -- "$argv"`)

while( 1 )
  switch ($1)
    case -h:
    case --help:
      goto HELP;
      breaksw;
    case -w:
    case --wait-time:
      set wait_time=$2; shift; shift ; breaksw
    case -l:
    case --local-port:
      set loc_port=$2; shift; shift ; breaksw      
    case -r:
    case --remote-port:
      set rem_port=$2; shift; shift ; breaksw            
    case -p:
    case --proxy-server:
      set proxy=$2; shift; shift ; breaksw            
    case -s:
    case --server-name:
      set server=$2; shift; shift ; breaksw            
    default:
      break;
  endsw
end

if ( ${server} == "" ) then
  echo ""
  echo "ERROR:   Server was not set"
  echo ""
  goto HELP
endif

if ( ! ${HOSTNAME} ) then
  setenv HOSTNAME `hostname`
endif

# Want to make sure the sleep timem is relative to the wait time
@ sleep_time = $wait_time * 4

xterm -e "echo 'Waiting for ${wait_time} secods before connecting'; sleep ${sleep_time}; vncviewer -Shared :${loc_port}" &

if ( $proxy == "" ) then
  echo "NOTE: Not using proxy server"
  ssh -L ${loc_port}:localhost:${rem_port} ${server}
else
  echo "NOTE: Using proxy server"
  ssh -t ${proxy} "ssh -f -R ${loc_port}:localhost:5${loc_port} ${HOSTNAME} sleep $sleep_time; ssh -L 5${loc_port}:localhost:${rem_port} ${server}"
  ssh -L ${loc_port}:localhost:${rem_port} ${server}
endif

goto END

HELP:
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
  exit

END:
  echo "Good bye!"

