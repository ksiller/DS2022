#!/usr/bin/env python3

import sys
from datetime import datetime

scriptname = sys.argv[0]
t = datetime.now()
print(f"Executing {scriptname} at {t}")
