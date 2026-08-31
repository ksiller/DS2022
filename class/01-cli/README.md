# Working with the Command Line

This module introduces the Linux command line. During class, we walk through a live demo; those commands are collected in [`demos/01-cli/README.md`](../../demos/01-cli/README.md) for reference.

1. Work through the sections below for hands-on practice on your own machine.
2. When you finish, complete **Lab 01** in Canvas for your graded assignment (link and due date are posted there).

## Open a terminal

- **macOS:** Press Command-Space, type `Terminal`, and press Return. You may want to add Terminal to your Dock.
- **Windows:** Start WSL and open your Linux shell.

## Set up your course directory

**Do this first.** Create a dedicated folder for DS2022 work in your home directory. You will use this folder throughout the course.

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

## Explore your home directory

If you started a new shell, you're likely already in your home directory.

The `cd` command lets you change your location in the file system. The shortcut `cd ~` takes you to your home directory.

Try it in your terminal:

```bash
cd ~
```

Another way to get there is to use the environment variable `$HOME`:

```bash
cd $HOME
```

Use `pwd` to learn your current location. `pwd` is short for "present working directory".

```bash
pwd
```

This prints your current working directory.

List the contents of your home directory with `ls`. If you're in a Codespace, your home directory may appear empty at first.

```bash
ls
```

List contents in a more detailed view:

```bash
ls -l
```

List all contents, including hidden files and directories:

```bash
ls -al
```

> **Note:** Hidden files and directories start with a `.`, such as `.ssh` or `.bashrc`.

The `-al` flags (options) do not have to be in any particular order, so this works too:

```bash
ls -la
```

## Work with files in your course directory

Change into your course directory before the exercises below:

```bash
cd ~/ds2022-fall-26
```

Create two empty files using the `touch` command:

```bash
touch file1
touch file2
```

List the directory contents again to see the files listed.

Next, try creating two more files within the same command:

```bash
touch file3 file4
```

You can create multiple files with a single command in `bash`. This command will create 10 new files with unique numeric names:

```bash
touch file-{11..20}.txt
```

You can even create numerous files based on a specific interval. This command creates files from 2 to 20 using only even numbers in the filenames:

```bash
for i in {02..20..2}; do touch file$i; done
```

The `echo` command prints text to the terminal output.

```bash
echo "Today is Friday"
echo "A man a plan a canal Panama"
```

You can also use it to add text to a file:

```bash
echo "Hi there everybody, my name is <YOUR NAME>" > file1
```

If you're in a GitHub Codespace, you can try:

```bash
echo "I'm in the cloud." > README-cloudshell.txt
```

This command uses a redirect (`>`) to send the output of `echo` into `file1`.

View the contents of your file with `cat`. `cat` is short for *concatenate*, since it can join files together, but it is often used to display a single file.

```bash
cat file1
```

You should see the text you echoed into it earlier. You can `cat` other files as well:

```bash
cat .bashrc
```

```bash
cat README-cloudshell.txt
```

Whenever you are in a directory you can read, edit, or list a file easily using its short
name, like this:

```bash
cat .bashrc
```

But every file or folder can also be referred to by its full path. Run `whoami` if you need your username:

```bash
whoami
```

For example, if your username is `mst3k`, you could run:

```bash
cat ~/.bashrc
cat ~/file1
```

On Linux or WSL, the full path might look like `/home/mst3k/file1`. On macOS, it might look like `/Users/mst3k/file1`.

This is extremely useful since it means *you do not have to change into a directory just to
work with its contents*.

## Move Up and Down Directories

Try changing to the "parent" directory with the `cd` command and the parent directory shortcut `..`:

```bash
cd ..
```

> **Note:** `../` refers to the parent directory (one level up), while `./` refers to the current directory. These are examples of relative paths that help you navigate the filesystem without typing full paths.  

From your home directory you are now one level up—for example, in `/home` on Linux or WSL, or in `/Users` on macOS. Verify that with `pwd`.

You can change back to your home directory in several ways. From one level above your home directory, try:

```bash
cd ~                        # shortcut to home
cd                          # also returns to home in most shells
cd "$(whoami)"              # relative path using your username
```

The first two options work from anywhere. The third uses a relative path from a parent directory such as `/home` (Linux/WSL) or `/Users` (macOS).

To go back to the last directory you can run `cd -`. Try this:
```bash
cd ..
pwd
cd -
pwd
```

## Working with Folders (Directories)

### Create a subdirectory

From within your course directory (`~/ds2022-fall-26`), create a new directory using the `mkdir` (make directory) command:

```bash
mkdir mynewdir
```

List the contents of your home directory and you should see the new subdirectory appear:

```bash
ls -al
```

Can you already guess the full path of the new subdirectory you created? If not, `cd` into
it and then issue the `pwd` command to find out.

### Copy a file or directory 

If you have a file or folder you would like to copy, use the `cp` command like this:

For a file:
```bash
cp file1 file2
```

For a directory we need the `-r` flag to indicate a recursive copy. First, create a directory to copy:
```bash
mkdir dir1
cp -r dir1 dir2
```

> **Note:** It is a good practice to leave the trailing `/` off of directory names.

### Renaming, Moving, Deleting Files and Directories

What if you want to rename a directory? Use the `mv` command:

```bash
mv mynewdir another-newdir
```

To delete a directory, use the `rm` command with the `-r` (Recursive) option. Recursive means you want to delete the directory AND anything within it.

```bash
rm -r another-newdir
```

You can delete multiple objects with a filter in your command. For instance, run this command in a directory:
```bash
touch z{81..90}.txt
```

You could delete all files that begin with `z` with this:

```bash
rm z*
```

You could delete all `.txt` files that contain the number `8` in them with this:

```bash
rm *8*.txt
```

You could delete ALL text files in the directory with:

```bash
rm *.txt
```

Create a deeper nested directory structures in one swoop. Try this:
 
```bash
mkdir -p timestamps/2026-01-01
```

Then `ls` and `cd` into `timestamps/2026-01-01`. 
Confirm your location with `pwd`.
Change back to where you came from with `cd -`. Alternatively, you could have run `cd ../..`. 

## Working with Text Files

A simple, built-in text editor is called `nano`. To open `nano` with an empty, blank document
simply invoke the `nano` program:

```bash
nano
```

Within the page you see blank space where you will write contents, and a series of possible commands at the bottom marked with the `^` character. This stands for the CONTROL key. If you open a blank document, try writing several lines of text, complete with paragraph breaks and punctuation. When you're done, press `^X` to exit. Upper/lower case does not matter.

This will give you the following prompt:

```bash
Save modified buffer (ANSWERING "No" WILL DESTROY CHANGES) ? 
```

To save your buffer (your open document) just press the `Y` key. This will give you a final prompt:

```bash
File Name to write : 
```

Here you can name your file anything you want. It will be saved to the directory you were in
when you opened up `nano`.

Confirm the content by running  `cat` on the new file you just edited.

Now rename the file you just created by using the `mv` command. The syntax is:

```bash
mv <ORIGINAL-NAME> <NEW-NAME>
```

So if I just created `hello.txt` in `nano` earlier, I could rename it by moving it:

```bash
mv hello.txt hello
```
You can always move a file to a completely different location by using a full path reference. That path may be absolute (with leading `/`) or relative (no leading `/`, relative to current location).

```bash
mv file1 timestamps/2026-01-01
ls 
```

Now check `timestamps/2026-01-01`:
```bash
ls timestamps/2026-01-01
```
Do you see file1?

**Understanding `mv` behavior:**

The `mv` command behaves differently depending on what the destination is:

1. **If the destination is an existing directory:** The file is moved into that directory, keeping its original name. If a file with the same name already exists in that directory, it will be overwritten.
   ```bash
   mv file.txt existing_dir/    # file.txt is moved into existing_dir/
   ```

2. **If the destination is a path to a non-existing file in an existing directory:** The file is moved and renamed to the new name.
   ```bash
   mv file.txt existing_dir/newfile.txt    # file.txt is moved to existing_dir/ and renamed to newfile.txt
   ```

3. **If the destination is a path to an existing file:** The source file overwrites the destination file (the original destination file is replaced).
   ```bash
   mv file.txt existing_file.txt    # file.txt replaces existing_file.txt (existing_file.txt is lost)
   ```

## Pipe one command into another using the `|` character.

Above you saw how a `cat` command could be redirected into a file. There is also the `|` "pipe"
command when you want to couple the text output of one command and process it using a second (or more)
command. 

Since you know `cat` prints out the contents of a file, let's join it with the `wc` (word count)
command:

```bash
cat hello | wc
```

This will print three numbers:

```
  171   812  4522
```
This means the file is 171 lines long, contains 812 words, and is 4522 characters long.

You can always request one of these values at a time by using option flags with the `wc` command. If you would like a line count only, use `-l`:

```bash
cat hello | wc -l
```
For a word count only, use `-w`

```bash
cat hello | wc -w
```

## Inspecting and Searching File Content

One of the simplest search tools is called `grep` which prints out results based on
"regular expressions" - these are filters, in a way, to help you find things.

Let's fetch a large text file from a remote source so that we can search through it. From your course directory, run:

```bash
curl https://gist.githubusercontent.com/StevenClontz/4445774/raw/1722a289b665d940495645a5eaaad4da8e3ad4c7/mobydick.txt > mobydick.txt
```
You should now have a local file named `mobydick.txt`. Let's search through it using
`grep`, which we will pipe after a `cat` command. `cat` will echo out the text contents into
`grep` which will filter and print ONLY lines where the search term appears.

Take a look at the top 20 lines with
```bash
head -20 mobydick.txt 
```

Or the last 15 lines with
```bash
tail -15 mobydick.txt 
```

Let's find the `Captain`:
```bash
cat mobydick.txt | grep "Captain"
```

This prints out a lot of results. What if we wanted to count how many lines the word
"Captain" appears? We can pipe on another command to count lines, like this:

```bash
cat mobydick.txt | grep "Captain" | wc -l
```

How many lines contain "Captain" in this text?

What if we wanted to search across many files for a word? `grep` is still useful here. From your course directory, run:

```bash
grep -r "Captain" ./*
```

The `./` at the end of the command specifies what files to search, in this case all files in the current directory.

The output will contain both the file name where the search term appears and the relevant line itself

```bash
./mobydick.txt:person, yet for Captain Ahab to have a boat actually 
./mobydick.txt:above all, for Captain Ahab to be supplied with five extra 
./mobydick.txt:about to be narrated, never reached the ears of Captain 
./mobydick.txt:handspikes, my hearties. Captain, by God, look to 
./mobydick.txt:Captain Colnett, a post-captain in the English navy, 
```

(Notice that `grep` is case-sensitive, so searching for `captain` will give different results.)

## Finding Files and Directories

So far we inspected and searched content inside of files. Let's explore how we can find by file name. Use the `find` command for this. The syntax is:

```bash
find . -name "mobydick.txt"
```

This issues the find command, searching the present directory (signified by the `.`)
with the name `"mobydick.txt"`. Note that the filename must be an exact match.

To search across all home directories, for example, you would change the path option

```bash
find /home -name "filename.txt"
```

### Find files matching a pattern

Use the wildcard `*` character at the beginning, middle, or end of a term to extend
matching. For example, if you only knew that `moby` was in the name of the file and
nothing more, this command would work:

```bash
find . -name '*moby*'
```

Or if you wanted to find all text files by suffix in a directory

```bash
find . -name '*.txt'
```

Search for *directories* that contain "2026" in their name:
```bash
find . -type d -name '*2026*'
```

Search for *files* that contain "2026" in their name:
```bash
find . -type f -name '*2026*'
```

### General Use of Wildcards

The wildcard `*` is useful in many contexts:

List all files ending with `.txt`

```bash
ls -al *.txt
```

Delete all files containing "zero" in the name (first create some test files if needed):

```bash
touch zero.txt zero_file.txt file_zero.txt
rm *zero*
```

## File Permissions

1. Touch a file named `permission_test` and echo some content into it:

```bash
touch permission_test
echo "This is a test file" > permission_test
``` 

2. Next use `ls -al` to see it listed in your directory.

3. Now change its permissions to `000` like this:

```bash
chmod 000 permission_test
```

Try to `cat` the contents of the file. You should get a permission denied message.

4. Now change its permissions so that only you can read and write the file:

```bash
chmod 600 permission_test
```

Again, `ls` the directory so you can see the permission bits for the file.

5. Finally, let's grant other members of your group read access, along with the access
we already gave you:

```bash
chmod 640 permission_test
```

List the directory contents once more and notice the permission bits for the file.

Notice the full set of characters in the far left column:

```bash
-rw-r-----   1 nmagee  staff     0B Jan 16 09:27 permission_test
```

The first character represents what type of object it is, i.e. file (`-`), directory (`d`), link (`s`), etc.

The next 9 characters represent permissions for the USER (i.e. the owner), GROUP, and OTHER machine users.

Each of those entities can have any combination of `rwx` permissions, which stands for READ, WRITE, and EXECUTE. This applies both to files and directories.

So to see `rwxrwxrwx` means the user, group, and other users all have full permissions to read, write, and execute the file/folder. <a href="https://www.redhat.com/en/blog/linux-file-permissions-explained" target="_blank" rel="noopener noreferrer"><strong>Read more here</strong></a> about POSIX permissions.

As practice, you should now determine what command is required to allow the USER and GROUP read/write permissions to a file, but no access to OTHER users.


## Utility Commands

These commands are used a bit less frequently but can help with basic tasks.

### `top`

`top` or `htop` shows you current processes, memory and CPU usage. They allow you
to see the `pid` (process ID) for any process, so that you can monitor it or stop (kill) it.

### `w`

`w` (who) shows you current users of your system. Typically if you are on a laptop
or desktop computer you own, you will be the only user. But large HPC computers may
have hundreds of users logged in concurrently.

### `which`

`which` shows you the path to a specific application. For instance, let's find Python3
on the local system:

```bash
$ which python3
/usr/bin/python3
```

The binary code for Python3 lives within `/usr/bin` - a very normal place for it to be. If you're in Codespace you may see a different location. In such case, replace `/usr/bin` in the next command with the output you've received.

You may want to list the contents of the `/usr/bin` directory to get a sense for all the 
built-in commands within the Linux kernel and `bash` shell.

```bash
ls -al /usr/bin
```

### `zip` and `tar`

- - -

**NOTE**: Windows users with `git-bash` have `unzip` available but not `zip`. I suggest you work
with `tar` instead.

- - -

Compressing or decompressing archives like zips or tarballs is not too difficult:

To create a zip bundle, assuming we are in a directory with `file1` and `file2` we want to zip up:


```bash
zip archive.zip file1 file2
```

This creates a zip file named `archive.zip` containing the two files. To unzip, the command is
quite simple:

```bash
unzip archive.zip
```

To create a tarball (the common nickname for a tar compressed archive) we often use it in conjunction with the `gzip` and `gunzip` options to keep the archive as small as possible. Again assuming we have two files in the current directory named `file1` and `file2` we want to put in the bundle:

```bash
tar -czvf archive.tar.gz file1 file2
```

The `-czvf` options mean: `-c` for CREATE an archive, `-z` for `gzip` the archive,
`-v` for verbose output, and `-f` for write the archive to a file.

To decompress the same archive:

```bash
tar -xzvf archive.tar.gz
```
The only difference in options is the use of `-x` which means "expand"

NOTE: It's extremely useful to know that in the world of the command line you can always add or remove files from archives without re-creating them! They are editable objects
when using either the `zip` or `tar` commands.

### `history`

Displays your history of commands in `bash`. Often this is limited to 1000 but that can
be changed in your `.bashrc` file.

When viewing your history, notice the line number with each command. To repeat an item
in your history, prefix that number with `!`.

```bash
!35
```

## Environment `env` variables

To view your system `env` variables, issue that command:

```bash
env
```

Take a moment to look through them. These are set by the system for each interactive user session. Some variables are common no matter what system you are on, such as: `HOME`, `USER` (or `USERNAME`), `EDITOR`, `PWD`, or `SHELL`.

Each environment variable is made of a `KEY` and a `VALUE`. You can fetch any value by calling it by key name:

```bash
echo $HOME
```

You can also set your own `env` variables. To do this temporarily within your current session:

```bash
FNAME="Waldo"
```

You can now retrieve that value interactively from your current `bash` session. However, if you had software running it would be unable to find this variable.

To make an `env` variable available to other processes, it must be exported. This is how you export:

```bash
export FNAME="Waldo"
```

This way some code or a script that is running outside of your current session can fetch `$FNAME`.

However, if you were to restart the computer, this `env` variable would not persist. It would be erased upon reboot.

To make an environment variable persist in your account, you can store it in a text file.

For your user account, assuming that `bash` is your default shell, you can edit a hidden file in your home directory, `.bashrc` and insert the same export command:

```bash
export FNAME="Waldo"
```
Upon your next login, that variable will be available.

If you can become `root` or use the `sudo` command, there is also a system-wide file for these exports. Simply insert your KEY=VALUE environment variable there (no `export` needed). That file can be found at:

```bash
/etc/environment
```

## Networking / Internet

The Linux OS has several built-in tools for helping check networking, or interacting with remote resources on the Internet.

### `curl`

`curl` is a basic tool for fetching something from the Internet - a file, web page, zip or tar bundle, CSV or JSON datafile, etc. You used `curl` above to fetch the Moby Dick text. Try it yourself with this list of songs:

```bash
curl http://nem2p-dp1-api.pods.uvarc.io/songs
```

By default, `curl` displays the contents of what was retrieved. In the case above, you can see the JSON values of a song list. If you wanted to "capture" the data file, you could redirect this command to a file, or use the `-O` flag (Oh, not zero) to save the file.

Note that you cannot use `curl` to fetch password-restricted resources (i.e. from Canvas, or Gmail, etc.)

Another useful trick with `curl` is to find your public IP address:

```bash
curl ifconfig.me
```

Example output:

```
199.111.240.7
```


```bash
curl -I https://google.com
```

The `-I` flag sends a HEAD request to retrieve only the HTTP headers from the server without downloading the page content.

### `ping`

`ping` is a simple tool that, like its submarine counterpart, simply bounces a message off of a remote host and tells you if it is reachable:

```bash
$ ping google.com
PING google.com (142.251.167.138): 56 data bytes
64 bytes from 142.251.167.138: icmp_seq=0 ttl=57 time=6.479 ms
64 bytes from 142.251.167.138: icmp_seq=1 ttl=57 time=4.430 ms
64 bytes from 142.251.167.138: icmp_seq=2 ttl=57 time=4.407 ms
64 bytes from 142.251.167.138: icmp_seq=3 ttl=57 time=4.518 ms
```

Press Ctrl+C to stop the `ping`s. Be aware that `ping` just verified two things for us:

1. The host `google.com` is alive and well; and
2. Our current host has an active Internet connection.

>Note: Codespace may restrict the ping command from reaching outside servers for security reasons. Use the `curl -I google.com` command instead.

### `ssh`

`ssh` is the Secure Shell, a method for making secure connections into the terminal of another computer. This might be a computing instance running in the cloud, a supercomputer, or another machine.

SSH connections look very similar to email addresses, in the form of USER @ HOST. (This is no coincidence since email and shell connections are very early Internet tools.)

Try a connection using a password, replace `mst3k` with your UVA computing ID:

```bash
ssh mst3k@login.hpc.virginia.edu
```

Try some of the commands you practiced on your own computer.

Type `exit` to leave the SSH session on the HPC login node and return to your local shell.
