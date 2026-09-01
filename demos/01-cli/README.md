# Demo: Working with Files

Here's a brief summary of the commands demonstrated live in class.

## The home directory

```bash
cd ~                        # make sure you're in your home directory
pwd                         # see where you are
ls                          # see regular files and folders
ls -la                      # see all files and folders; hidden files start with a `.`, e.g. `.bashrc` or `.zshrc`
```

Some files are hidden because their names start with a `.`. They often contain configuration for your account or credentials used to log in elsewhere.

## Set up a folder structure for course work

We use the terms *folder* and *directory* interchangeably.

```bash
cd ~                        # make sure you're in your home directory
pwd                         # see where you are
mkdir ds2022-fall-26        # create a new subdirectory for the course
cd ds2022-fall-26           # change into the new directory
pwd                         # print its path
```

**Output on macOS**

```
/Users/mst3k/ds2022-fall-26
```

*mst3k is an example; you'll see your username here.*

**Output on Windows (WSL) or Linux**

```
/home/mst3k/ds2022-fall-26
```

*mst3k is an example; you'll see your username here.*

## Navigating & Exploring

```bash
cd /                        # go to the root of the filesystem
ls -la
cd -                        # return to the previous directory
pwd
ls ../                      # list contents of the parent folder
ls ../../                   # list contents of the parent's parent folder
pwd                         # you're still in the current folder
cd ../                      # move up one folder
ls                          # list contents of the folder you're now in
```

On macOS:

```bash
cd /Users                   # move to the Users folder
ls
```

On WSL or Linux:

```bash
cd /home                    # move to the home directories folder
ls
```

## Creating Files & Directories

```bash
cd ~/ds2022-fall-26
touch file1.txt             # create an empty file
ls
echo "Hello, DS2022"        # output to the terminal
echo "Hello, DS2022" > hello.txt
cat hello.txt
echo "CLI is amazing!" >> hello.txt
cat hello.txt
mkdir subdir1
mkdir subdir2
ls -l                       # note the "d" at the beginning of the directory line
cp hello.txt goodday.txt    # create a copy
mv goodday.txt subdir1/     # move goodday.txt into subdir1
ls subdir1
mv hello.txt ds2022.txt     # rename hello.txt -> ds2022.txt
```

## File permissions

```bash
cp ds2022.txt ds2022.txt.bak             # create a backup copy
ls -l                                    # note the file permissions
chmod 000 ds2022.txt                     # remove all read, write, and execute access
ls -l                                    # note the updated file permissions
echo "more to come..." >> ds2022.txt     # permission denied (expected)
cat ds2022.txt                           # permission denied (expected)
chmod +r ds2022.txt                      # restore read permissions for everyone
ls -l
cat ds2022.txt                           # works again; writes will still be rejected
chmod u+w ds2022.txt                     # restore write permissions for the owner ("u" = user)
echo "more to come..." >> ds2022.txt
cat ds2022.txt
```

## Finding Things

Finding files

```bash
find . -name "*.txt"                    # search for .txt files; * is a wildcard
find . -type d -name "subdir*"          # search for directories that begin with "subdir"
```

Searching file content

```bash
grep -i "hello" ds2022.txt              # search for "hello" in ds2022.txt
grep -iR "hello" .                      # search recursively, case insensitive
grep -iR "hello" . > results.txt        # save search results to a file
```

Finding commands

```bash
which ls                                # path to the ls command
whereis ls                              # path and location of command documentation
man ls                                  # open the command manual
```

## Remote File and System Access

Download a file

```bash
curl https://gist.githubusercontent.com/StevenClontz/4445774/raw/1722a289b665d940495645a5eaaad4da8e3ad4c7/mobydick.txt > mobydick.txt
```

Log in to a remote server. Example: UVA HPC login node (replace `mst3k` with your computing ID).

```bash
ssh mst3k@login.hpc.virginia.edu
```

Check home directory disk usage. Run this on the remote system after you log in:

```bash
du -ah --max-depth=1 ~ | sort -hr | head -5 > largest.txt
exit
```
The exit command takes you back to your local shell.

Copy a file from the remote server

```bash
scp mst3k@login.hpc.virginia.edu:~/largest.txt .
```
