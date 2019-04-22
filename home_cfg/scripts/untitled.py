#!/usr/bin/env python

import os, sys, json, time
from pprint import pprint, pformat
from string import Template


def run_config(zk, mesos_type):
  """
  Attempts to set all the running configuration for Mesos.  This is needed so it can be executed
  after a new Image is deployed.  It alters the network configuration files as well as any other
  Mesos related file.  The IP Address is obtained from the metadata service.

  """
  print "Configuring Mesos Environment"

  config = {'privateIp': '10.0.2.140'}

  set_mesos( zk, config['privateIp'] )

 

def set_mesos( zk, ip ):
  """
  Sets the /etc/mesos/zk file properly by making sure there is no reference
  to localhost or 127.0.0.1.  It also adds the host's IP Address if missing

    ip:   The IP address to use

  """
  print "Settting Up Mesos"

  #cmd = "cp -f /etc/mesos/zk /etc/mesos/zk_ORIG"
  #os.system(cmd)

  indx = zk.rfind(':')
  if indx > 0:

    start_port = zk[:indx]
    tst = zk.rfind('/')
    print "Start %s, Tst %s" % (start_port, tst)

    port = zk[ len(start_port) + 1 :tst ]
    print "Port %s" % port
    start = zk[:tst]
    end = zk[tst:]
    mod = "%s,%s:%s%s" % (start, ip, port, end)
    print mod
  # os.system("rm -f /etc/mesos/zk")
  # cmd = "echo %s >> /etc/mesos/zk" % mod
  # print "Executing: %s" % cmd
  # os.system(cmd)

def set_mesos( zk, ip ):
  """
  Sets the /etc/mesos/zk file properly by making sure there is no reference
  to localhost or 127.0.0.1.  It also adds the host's IP Address if missing

    ip:   The IP address to use

  """
  print "Settting Up Mesos"

  cmd = "cp -f /etc/mesos/zk /etc/mesos/zk_ORIG"
  os.system(cmd)

  obj = open('/etc/mesos/zk', 'r')
  lines = obj.readlines()

  # Go trhough all the lines
  for line in lines:
    if line.startswith("zk://"):
      line = line.strip()
      # Need to remove localhost and/or 127.0.0.1
      tst = line.find('localhost')
      if tst <= 0:
        tst = line.find('127.0.0.1')
        if tst >= 0:
          start = line[:tst]
          end = line[ (tst + len('127.0.0.1') + 1 ):]
          line = start + end
      else:
        start = line[:tst]
        end = line[ (tst + len('localhost') + 1 ):]
        line = start + end

      # It does not have the IP Address
      if line.find(ip) <= 0:
        start_port = zk[:indx]
        tst = zk.rfind('/')
        print "Start %s, Tst %s" % (start_port, tst)

        port = zk[ len(start_port) + 1 :tst ]
        print "Port %s" % port
        start = zk[:tst]
        end = zk[tst:]
        mod = "%s,%s:%s%s" % (start, ip, port, end)
        print mod
      else:
        mod = line

      os.system("rm -f /etc/mesos/zk")
      cmd = "echo %s >> /etc/mesos/zk" % mod
      print "Executing: %s" % cmd
      os.system(cmd)


def set_network( ip ):
  """
  Because it starts from an image, the /etc/hosts file has the original 
  IP Address rather than the one from this VM.  The same applies for
  the /etc/hostname file.  This method makes a copy of the files and replaces
  their contents with the appropriate entries

    ip: The IP Address to use
    
  """
  print "Setting Network Environment"
  cmd = "mv -f /etc/hostname /etc/hostname_ORIG"
  print "Executing cmd"
  os.system(cmd)
  cmd = 'echo "%s" >> /etc/hostname' % ip
  os.system(cmd)

  cmd = "mv -f /etc/hosts /etc/hosts_ORIG"
  print "Executing cmd"
  os.system(cmd)

  txt = """
        127.0.0.1  localhost
        127.0.0.1  %s

        # The following lines are desirable for IPv6 capable hosts
        ::1 ip6-localhost ip6-loopback
        fe00::0 ip6-localnet
        ff00::0 ip6-mcastprefix
        ff02::1 ip6-allnodes
        ff02::2 ip6-allrouters
        ff02::3 ip6-allhosts
        """ % ip

  cmd = 'echo "%s" >> /etc/hosts' % txt
  print "Executing: %s" % cmd
  os.system(cmd)
  os.system("hostname %s" % ip )




if __name__ == '__main__':
  args = sys.argv[1:]
  sz = len(args)

  _DATA = None

  print args
  if sz == 1:
    print "The Configuration: %s" % args[0]
    _DATA = json.loads(args[0])

  else:
    print "ERROR: Need to pass the configuration parameters such as:"
    print "       mesos-type: Either SLAVE or MASTER"
    print "    If setting up as master:"
    print "       server-id: The server number (1 - 255)"
    print "       masters:   a list of dictionaries"
    print "                  [{'id': 1, 'url': '10.0.2.1:2888:3888'}]"
    print ""
    print "Make sure the fields inside the JSON uses double-quote and the"
    print "outer quotes are single, otherwise an error is thrown"
    sys.exit(-1)

  file_in = open('ZOO_CFG')
  src = Template( file_in.read() )
  res = src.substitute( {'ZOO_SERVERS': "server.1=1.1.1.1:2888:3888\nserver.1=1.1.1.1:2888:3888"})
  print res