#!/bin/bash

set -e

while read line; do
  echo $line;
  # sleep 1;
done < guids.list
