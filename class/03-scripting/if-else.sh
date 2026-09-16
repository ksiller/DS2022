#!/bin/bash

set -e

echo -n "Enter a number: "
read VAR

if [[ $VAR -gt 10 ]]
then
  echo "That number is greater than 10."
else
  echo "Your number is less than 10!"
  exit 0;
fi
