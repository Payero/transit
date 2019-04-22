#!/usr/bin/env python

import pymongo, os, sys, json, traceback
from pprint import pprint, pformat
from bson.objectid import ObjectId

def insert_data():
  print("Inserting data from a file")
  myclient = pymongo.MongoClient("mongodb://ax-ccdp.com:27017/")
  mydb = myclient["RFIMS"]
  mycol = mydb["Interferences"]

  fname = "/media/lgs/interference.json"
  if not os.path.isfile(fname):
    print("ERROR:  The file (%s) could not be found" % fname)
    sys.exit(-1)

  try:
    raw_data = open(fname, 'r').read()
    data = json.loads(raw_data)
    # for n in range(0,2):
    #   x = pymongo.ObjectId()
    #   mycol.insert_one(data)

    records = []
    for n in range(0, 2):
      recId = ObjectId()
      data['_id'] = recId
      x = records.append(data)

    pprint(records)
    mycol.insert_many(records)
    print("All the Records inserted: " % pformat(x.inserted_ids))
  except:
    traceback.print_exc()




if __name__ == '__main__':
  insert_data()