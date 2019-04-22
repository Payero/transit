

# I found that the wmctrl application will allow me to change workspaces from 
# the CLI, but there is a time lag. If the target application (I'll use gedit 
# as an example) is not running I need to:
#
# 1. Change the to the target Workspace
# 2. Launch the target application
# 3. Wait for that application to actually launch
# 4. Switch back to the original Workspace

TEMP=`getopt -o hw:a: --longoptions help,workspace:,application: -n $0 -- "$@"`

# Prints the Usage
usage()
{
  echo ''
  echo 'Sends an applicatin to start on a specific workspace'
  echo ''
  echo 'usage: $0 <options>'
  echo '   -w, --workspace  <arg>   The workspace number to use.'
  echo '   -a,--application <arg>   The application to launch'
  echo ''
  exit 0
}

APP_NAME=""
WSPC_NUMBER=""

eval set -- "$TEMP"
while true ; do
  case "$1" in
  -h | --help ) usage ; break ;;
  -w | --workspace   ) WSPC_NUMBER=$2 ; shift 2 ;;
  -a | --application ) APP_NAME=$2 ; shift 2 ;;
    * ) break ;;
  esac
done

if [ -z "$WSPC_NUMBER" ] ; then
  WSPC_NUMBER=1
fi

if [ -z "$APP_NAME" ] ; then
  echo " ERROR: The application needs to be provided"
  usage
fi


CurrentWS=`wmctrl  -d | grep "*" | cut -f 1 -d " "`
#Application="gedit"
#Application="/opt/Citrix/ICAClient/selfservice --icaroot /opt/Citrix/ICAClient"

wmctrl  -s $WSPC_NUMBER 
$APP_NAME  &
# Wait up to ten seconds for the Application to load
for i in `seq 1 10`
do
  sleep 1s
  Process=`pgrep -f "$APP_NAME"`
  WindowID=`wmctrl -l -p | grep $Process | cut -f 1 -d " "`
  if  [[ "$WindowID" != "" ]]
  then
    break
  fi
done
wmctrl -s $CurrentWS

# However if the Application is already running, you can use wmctrl to move 
# that app to the desired Workspace.

Process=`pgrep -f "$APP_NAME"`
WindowID=`wmctrl -l -p | grep $Process | cut -f 1 -d " "`
WindowID=${WindowID#0x}

wmctrl  -r $WindowID -t $WSPC_NUMBER

