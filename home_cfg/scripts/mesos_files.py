#!/usr/bin/env python

import os, sys, glob, operator
from pprint import pprint, pformat

def read_files():
  print "Reading files"
  path = "/var/lib/mesos"

  slaves = os.path.join(path, "slaves")
  if not os.path.isdir(slaves):
    print "The slaves directory (%s) could not be found" % slaves
    sys.exit(-1)

  latest = find_newest_dir(slaves)
  print "The latest directory: %s" % latest
  tmp = os.path.join(slaves, latest, "frameworks")
  latest = find_newest_dir(tmp)
  print "The latest dir: %s" % latest
  tgt = os.path.join(tmp, latest, 'executors/CcdpCommandExecutor/runs/latest')

  print "The Target Dir: %s" % tgt

  if os.path.isdir(tgt):
    print "Found directory, opening files"
    files = ["child.stderr", "child.stdout", "stderr", "stdout"]
    cmd = "/opt/sublime_text/sublime_text -n "
    for name in files:
      cmd += "%s " % os.path.join(tgt, name)

    os.system(cmd)


def find_newest_dir(directory):
    os.chdir(directory)
    dirs = {}
    for dir in glob.glob('*'):
        if os.path.isdir(dir):
            dirs[dir] = os.path.getctime(dir)

    lister = sorted(dirs.iteritems(), key=operator.itemgetter(1))
    return lister[-1][0]




read_files()