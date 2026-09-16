#!/bin/bash

# Log a warning message
logfile="./logging.log"

# Parameters to use for the log message
NOW=`date +'%Y-%m-%d-%H:%M:%S'`
STATUS="Warning"
MSG="This is a warning message in the log file"

# Append to the log file
echo $NOW - $STATUS - $MSG >> logging.log
