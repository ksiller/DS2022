#!/bin/bash
# Demonstrates: set -euo pipefail
#
#   -e           exit immediately if any command fails (non-zero status)
#   -u           exit if you use a variable that was never set
#   -o pipefail  a pipeline fails if ANY command in it fails
#                (without this, only the last command's exit status counts)

set -euo pipefail

# ${1:?...} needs a filename argument and prints a clear message if it is missing.
# With -u alone, using $1 when unset would also stop the script, but with a vaguer error.
FILE=${1:?Usage: $0 FILE}

# Try this with a real file, then with a name that does not exist:
#   ./strict-mode.sh /etc/hosts
#   ./strict-mode.sh no-such-file.txt
#
# Without pipefail, `cat` can fail and `wc -l` still succeeds on empty input,
# so the whole pipeline can look successful. With pipefail + -e, the script stops.
LINES=$(cat "$FILE" | wc -l)

echo "$FILE has ${LINES} lines"
