#!/usr/bin/env python


import logging

# Configure the logger to output to the console
# 
# LOG LEVEL OPTIONS (from lowest to highest severity):
# - logging.DEBUG: Detailed diagnostic information, typically of interest only when diagnosing problems
# - logging.INFO: Confirmation that things are working as expected
# - logging.WARNING: An indication that something unexpected happened, but the software is still working
# - logging.ERROR: A more serious problem, the software has not been able to perform some function
# - logging.CRITICAL: A serious error, indicating that the program itself may be unable to continue running
#
# HOW LOG LEVEL AFFECTS OUTPUT:
# The level you set determines the minimum severity of messages that will be displayed.
# Messages at or above the set level will be shown; messages below will be filtered out.
# For example, if level=logging.INFO:
#   - DEBUG messages will NOT be shown (below INFO)
#   - INFO, WARNING, ERROR, and CRITICAL messages WILL be shown (at or above INFO)
#
# SETTING A LOG FILE:
# To write logs to a file instead of (or in addition to) the console, add the 'filename' parameter:
#   logging.basicConfig(level=logging.INFO, filename='app.log')
# To write to both console and file, you'll need to configure handlers separately (more advanced)
logging.basicConfig(level=logging.INFO)

logging.info("This is an info message")
logging.warning("This is a warning message")
logging.error("This is an error message")
logging.critical("This is a critical message")