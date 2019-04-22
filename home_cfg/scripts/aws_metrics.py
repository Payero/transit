#!/usr/bin/env python
# encoding: utf-8

from optparse import OptionParser
import logging
import boto3, random, time
from pprint import pformat

class AWSMetrics:

  __METADATA_URL = 'http://169.254.169.254/latest/meta-data/instance-id'
  
  __LEVELS = {"debug": logging.DEBUG, 
              "info": logging.INFO, 
              "warning": logging.WARN,
              "error": logging.ERROR}
  
  def __getLogger(self, name='AWSMetrics', level='debug'):
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
    
    self.__run(cli_args)


  def __run(self, args):
    self.__logger.info("Running the Metrics")
    cloudwatch = boto3.client('cloudwatch')
    while True:
      metric = {}
      metric['MetricName'] = 'Tasks'
      metric['Value'] = random.randint(0,5)
      metric['Unit'] = 'Count'
      dims = []
      dims.append( {'Name': 'InstanceId','Value': 'i-0fa470f3da73d8ac0'} )
      dims.append( {'Name': 'PrivateIp', 'Value': '172.31.20.84'} )
      dims.append( {'Name': 'PublicIp','Value': '52.205.26.225'} )
      metric['Dimensions'] = dims

      resp = cloudwatch.put_metric_data(Namespace='TaskMetrics', 
                                        MetricData=[metric])

      stat = resp['ResponseMetadata']['HTTPStatusCode']
      if stat == 200:
        stat = 'OK'
      else:
        stat = 'ERROR'
      sent = resp['ResponseMetadata']['HTTPHeaders']['date']
      self.__logger.info("Metric sent on '%s' has a status of '%s'" % (sent, stat)  )
      time.sleep(60)


    




"""
  Runs the application by instantiating a new Test object and passing all the
  command line arguments
"""  
if __name__ == '__main__':
  
    
  desc = "Sets the environment for a new machine so it can run CCDP.\n"
  desc += "The settings are stored in a S3 bucket and are retrieved\n"
  desc += "during the execution of the program."
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
  
  
  (options, args) = parser.parse_args()
  
  metrics = AWSMetrics(options)
      