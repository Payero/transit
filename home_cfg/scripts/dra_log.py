#!/usr/bin/env python
import os, sys
from pprint import pprint

def run(path, out):

  print "Looking for %s starting from %s" % (out, path)

  dirs = getSortedDirs(path)
  latest = dirs[len(dirs) - 1]
  fmwks = os.path.join(latest, "frameworks")
  print "Framworks: " + fmwks

  dirs = getSortedDirs(fmwks)
  latest = dirs[len(dirs) - 1]  
  print "Latest: %s" % latest
  execs = os.path.join(latest, "executors")
  
  dirs = getSortedDirs(execs)
  latest = dirs[len(dirs) - 1]  
  print "Executors: %s" % latest
  runs = os.path.join(latest, "runs/latest/")  
  print "Runs: " + runs

  fname = os.path.join(runs, out)
  if os.path.isfile(fname):
    print "Printing contents of ", fname
    obj = open(fname, 'r')
    lines = obj.readlines()
    for line in lines:
      print line
  else:
    print "ERROR: Could not find file: %s" % out

def getSortedDirs(path):
  dirs = os.listdir(path)
  for item, i in zip(dirs, range(0, len(dirs))):
    dirs[i] = os.path.join(path, dirs[i])

  return sorted(dirs, cmp=compareDirs)

def compareDirs(a, b):
  obja = os.path.getmtime(a)
  objb = os.path.getmtime(b)

  if obja < objb:
    return -1
  elif obja == objb:
    return 0
  else:
    return 1

if __name__ == '__main__':
  args = sys.argv[1:]

  print "Got %d arguments %s" % (len(args), str(args))
  sz = len(args)
  out = "stdout"

  if os.getenv('SLAVES'):
    path = os.getenv('SLAVES')
  
  if sz == 1:
    path = args[0]
  elif sz == 2:
    path = args[0]
    out = args[1]

  if not os.path.isdir(path):
    print "ERROR: The path (%s) is invalid" % path
    sys.exit()

  run(path, out)

