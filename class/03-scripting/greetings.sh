#!/bin/bash

# $0: the name of the script
# $1: the first argument
# $2: the second argument
# $#: the number of arguments
# $*: all the arguments

NAME=$1

echo "Running script $0"
echo "The script was called with $# arguments: $*"
echo “Good morning, $NAME!”