#!/bin/bash

set -e

## GOOD
## The script has a proper shebang line and has been
## chmod to 755 so it can be executed.


script = "./detabify.py"
$script


## BETTER
## Find a way to pass variables into the python script
## so that it's not static. The py script uses the same
## name for the output and adds .csv, so only one param
## is needed here. The py script will pull the env variable
## when it is run.

export INPUT="new_mock_data.tsv"
env_script="./detabify-env-vars.py"
$env_script
