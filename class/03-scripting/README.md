# Scripts

## Best Practices

All scripts should be written in a way that takes into account several factors:

1. Use the shebang / make the script executable
2. Error out gracefully --> set -e / error codes --> || exit 1;
3. Use input parameters
4. Conditional logic
5. Environment / full paths / env variables
6. Logging
7. Use comments

## bash

### shebang
A well-formatted `bash` script begins with a "shebang" line:
```
#!/bin/bash
```
that points to the full path of the `bash` shell. This may differ from one environment
to the next.

To make any bit of code executable, use `chmod 755` against it.

### Use full paths

Any binary executables used in a shell script should be invoked using their full
paths. This is to avoid any ambiguity and preempt any errors of a shell not being
able to find the command.

For example, when invoking the `aws` command-line in a script you would normally call
```
/usr/local/bin/aws
```
To determine the full path of an executable in a given system, use the `which` command:
```
which aws
```

### Graceful Errors

Near the top of most `bash` scripts, put:

```bash
set -euo pipefail
```

- `-e` — stop the script as soon as any command fails. Continuing past an error can produce bad results or unintended side effects.
- `-u` — stop if the script uses a variable that was never set (typos and missing arguments show up immediately).
- `-o pipefail` — a pipeline fails if **any** command in it fails. Without this, only the last command's exit status counts, so an early failure can be hidden.

See `strict-mode.sh` for a short example. Try:

```bash
chmod 755 strict-mode.sh
./strict-mode.sh /etc/hosts
./strict-mode.sh no-such-file.txt
```

Another option is a conditional so that when a specific line fails, the script `exit`s with a non-zero code. That can be useful when debugging.

### Sleep

If you need a deliberate pause in the middle of a script, simply `sleep 5` for a 5-second
pause, etc. This may be especially useful in the midst of `try` logic.

### Input parameters

Remember that `$0`, `$1`, `$2`, etc. are reserved parameters `bash` understands as positional
arguments when invoking from the command-line:

- `$0` is the invoking script itself
- `$1` is the first parameter after the script name
- `$2` is the second parameter ...
- . . .

`positional-args.sh`
```
#!/bin/bash

echo "$0 <-- invoking script"
echo "$1 <-- first parameter"
echo "$2 <-- second parameter"
```
returns the following output:

```
$ ./positional-args.sh bananas blueberries

./positional-args.sh <-- invoking script
bananas <-- first parameter
blueberries <-- second parameter
```


### If/Else conditional logic:

Start your `if` with a comparison, end with `fi`.

```bash
if [[ $VAR -gt 10 ]]
then
  echo "That number is greater than 10."
else
  echo "Your number is pretty small!"
  exit 0;
fi
```

### Environment

`env` gives you all environment variables for your session. This may vary
for an unattended script (without you around).

Add environment variables in `bash`:
```
export VARIABLE=value-of-variable
```

Use full paths to your binaries to avoid your unattended script being unable
to locate a binary. Just because you can run it by hand does not mean it can
run without you around.

### Logging

A simple-yet-valuable step in your scripting is to log. You can log every action
taken by the script, or limit logging to successes or failures.

A common format for logging might be a snippet like this:

```
# First establish the datetime:
NOW=$(date +"%m-%d-%Y-%H:%M:%SEDT")
echo $DATE " OK - Successfully processed " $FILENAME >> /var/log/output.log
```
The result would be a single file building with each row as it is logged.
Note the `>>` to append to a file instead of overwriting it!

### Comment

One of the most useful habits you can develop as a programmer is adding comments
to your code. This explains each chunk of code but might also justify why a particular
choice has been made. This will be invaluable to you, when you come back to the code
two years later, or when your code is shared with others.

## Python3

Scripting in `python` is fairly similar, but it has many a lot more functionality in 
terms of libraries, classes, functions, etc. A few things to note:

- Unlike `bash` it is not as easy to pass `$1`, `$2` parameters in the command-line.
[Refer to this](https://stackabuse.com/command-line-arguments-in-python/) for a basic tutorial.
- Python can invoke shell scripts in other languages.
- Python has many better options for conditional logic, error handling, and logging.
- Whereas `bash` and other low-level tools (`grep`, `sed`, `awk`, `tr`, `perl`, etc.) can parse 
plain-text "flat" files fairly efficiently, Python can ingest a data file and load it 
into memory for much more complex transformations. A library like `pandas` can use 
dataframes like a staging database for you to query, scan, count, etc. [Here's a great
tutorial](https://www.kaggle.com/sohier/tutorial-accessing-data-with-pandas) on Kaggle.

## Hands-On Practice

1. Write a primary script in `bash` that does two things:
  - Invokes a `bash` script to retrieve the log file found in `retrieve_file.sh`.
  - Invokes a `python3` script to parse that file and write the output

2. Want a more challenging assignment? Write a `python` script that does both tasks.