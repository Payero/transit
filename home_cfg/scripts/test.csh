#!/bin/tcsh

if ( "$?HADOOP_DIST_MODE" ) then
  echo "Running Distributed mode"
else
  echo "NOT Running Distributed mode"
endif
