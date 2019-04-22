#!/usr/bin/env python

import pymongo


def run_db_test():
  try:
    cl = pymongo.MongoClient()
    print "Connected Successfully"
  except pymongo.errors.ConnectionFailure, e:
    print "Could not connect"

  dbs = cl.database_names()
  print "Available Databases: %s" % str(dbs)

  for db in dbs:
    colls = cl[db].collection_names()
    print "DB: %s has %s " % (db, colls)

  rest = cl['brecky']['bagels']
  print rest.find_one()

if __name__ == '__main__':
  print "Running Mongo"
  run_db_test()