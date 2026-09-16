#!/usr/bin/env python
# logging_error.py

import logging

# Create console handler
console_handler = logging.StreamHandler()
console_handler.setLevel(logging.INFO)
console_handler.setFormatter(logging.Formatter('%(message)s'))

# Create file handler
log_file = 'my_app.log'
log_format = '%(asctime)s - %(levelname)s - %(message)s'
date_format = '%Y-%m-%d %H:%M:%S'
file_handler = logging.FileHandler(log_file)
file_handler.setLevel(logging.DEBUG)
file_handler.setFormatter(logging.Formatter(log_format, datefmt=date_format))

# Configure root logger
logging.basicConfig(level=logging.DEBUG, handlers=[console_handler, file_handler])

logging.info("Starting calculations...")

# Example: Warning in an if/then block
value = int(input("Enter a value: "))
logging.debug(f"Value: {value}")
if value > 100:
    logging.warning(f"Value {value} is unusually high, may indicate a problem")

try:
    temp_value = 10 + value
    logging.debug(f"Temporary result: {temp_value}")
    result = temp_value / value
    logging.info(f"Result: {result}")
except ZeroDivisionError:
    logging.error("Division by zero attempted. Result cannot be computed.")
logging.info(f"Done. Logs saved to {log_file}")
