#!/usr/bin/env python
# encoding: utf-8

from optparse import OptionParser
import logging
from pprint import pformat
import os, sys, traceback
from datetime import datetime, timedelta
import subprocess


class CleanImages:
  
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
    
    
  def __init__(self, cli_args):
    self.__logger = self.__getLogger(level=cli_args.verb_level)
    self.__logger.debug("Logging Done")
    
    if os.geteuid() != 0:
      exit("\n\tERROR:  You need to be root to run this script.\n")

    self.__cleanImages(cli_args)

  def __cleanImages(self, args):
    self.__logger.debug("Cleaning Images")
    

    cli_kernel = args.kernel_version
    kernel = {}
    if cli_kernel == None:
      self.__logger.info("Getting Kernel version")
      name = subprocess.check_output(['uname', '-r'])
      name = name.strip()
      kernel['name'] = name

    if name != None and name.endswith('-generic'):
      kernel['version'] = name[:-(len('-generic'))]


    self.__logger.info("Using Kernel %s" % kernel)

    items = subprocess.check_output(['dpkg', '--list'])
    items = items.split("\n")
    images = []

    for item in items:
      if item.find('linux-image') > 0:
        img = {}
        vars = item.split()
        if len(vars) > 3:
          img['name'] = vars[1]
          img['version'] = vars[2]
          images.append(img)

    keeping = []
    removing = []

    for img in images:
      version = img['version']
      if kernel['version'] > version:
        removing.append(img)
      else:
        keeping.append(img)
    

    if args.action == 'show':
      self.__show_results( removing, keeping)
    else:
      msg = "\nCurrent Version: %s\n" % kernel['name']

      msg += "\n\tWARNING: Will remove the following Images: \n\n"
      for img in removing:
        msg += "\t\t%s\n" % img['name']

      msg += "\nAre you sure? [N/y] "
      resp = raw_input(msg)
      if resp == 'y' or resp == 'Y':
        self.__logger.warning("Removing Images")
        for img in removing:
          cmd = 'sudo apt-get purge %s' % img['name']
          self.__logger.info("Running %s" % cmd)
          self.__logger.info("Exit Code: %d" % subprocess.call(cmd.split(' ')) )

        self.__logger.info("Done removing images, now cleaning up")
        cmd = 'sudo update-grub2'
        self.__logger.info("Running %s" % cmd)
        self.__logger.info("Exit Code: %d" % subprocess.call(cmd.split(' ')) )




  def __show_results(self, removing=[], keeping=[] ):     
    if len(removing) == 0:
      print"\n"
      self.__logger.info("No Images to remove")
    else:     
      self.__logger.info("******************************************************")
      self.__logger.info("**********          Removing Images         **********")
      self.__logger.info("******************************************************")
      for img in removing:
        self.__logger.info(img['name'])
      self.__logger.info("------------------------------------------------------")

    print "\n"

    if len( keeping ) == 0:
      self.__logger.error("No images to keep, that is a BIG problem")
    else:
      self.__logger.info("******************************************************")
      self.__logger.info("**********          Keeping Images          **********")
      self.__logger.info("******************************************************")
      for img in keeping:
        self.__logger.info(img['name'])
      self.__logger.info("------------------------------------------------------")



"""
  Runs the application by instantiating a new Test object and passing all the
  command line arguments
"""  
if __name__ == '__main__':
  
    
  desc = "Removes all the old images from the hard-drive.\n"
  desc += "First it finds the current version and removes all previous\n"
  desc += "installs releasing unused hard-drive space.  The script can be\n"
  desc += "used to either show what would happen or to actually execute it"
  parser = OptionParser(usage="usage: %prog [options] args",
                        version="%prog 1.0",
                        description=desc)
  
  parser.add_option('-v', '--verbosity-level',
                    type='choice',
                    action='store',
                    dest='verb_level',
                    choices=['debug', 'info', 'warning','error',],
                    default='debug',
                    help='The verbosity level of the logging',)

  parser.add_option('-a', '--action', 
                    type='choice',
                    action='store',
                    dest='action',
                    choices=['show', 'clean'],
                    default='show', 
                    help="The action to perform either show or clean",)
  
  parser.add_option('-k', '--kernel-version', 
                    dest="kernel_version",
                    default=None, 
                    help="The kernel version",)

  (options, args) = parser.parse_args()
  
  test = CleanImages(options)
      