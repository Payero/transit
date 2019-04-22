#!/usr/bin/env python
# encoding: utf-8

import logging
from pprint import pformat
import os, sys, traceback


class Test:

  __LEVELS = {"debug": logging.DEBUG, 
              "info": logging.INFO, 
              "warning": logging.WARN,
              "error": logging.ERROR}
  
  
  def __getLogger(self, name='Tester', level='debug'):
    logger = logging.getLogger(name)
    handler = logging.StreamHandler()
    formatter = logging.Formatter(
            '%(asctime)s %(name)-12s %(lineno)d %(levelname)-8s %(message)s')
    handler.setFormatter(formatter)
    logger.addHandler(handler)
    
    # Setting root level to warning and THEN set the level for this module
    logger.setLevel(self.__LEVELS[level.lower()])
    logging.getLogger(name).setLevel(self.__LEVELS[level.lower()])
    return logger
    
    
  def __init__(self):
    self.__logger = self.__getLogger(level='debug')
    self.__logger.debug("Logging Done")
    
    self.__runTest()


  def __runTest(self):
    self.__logger.info("Running the test")
    fname = 'test.txt'
    handle = open(fname, 'r')
    lines = handle.readlines()
    total = 0

    mult = {'K': 1024, 'M': 1048576, 'G': 1073741824 }
    for line in lines:
      line = line.strip()
      n = float(line[:-1])
      m = line[-1:]
      self.__logger.debug("Processing line %s, Number = %d and Size: %s " % (line, n, m))
      val = n * mult[m]
      self.__logger.debug("The Value = %f" % val)
      total += val

    self.__logger.info("Total: %f " % ( float(total) / int(mult['G']) ) )


    
"""
  Runs the application by instantiating a new Test object and passing all the
  command line arguments
"""  
if __name__ == '__main__':
   
  test = Test()
      