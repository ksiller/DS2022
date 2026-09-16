# Version Control & Collaboration with Git & GitHub

This module introduces **Git** (the version control tool) and **GitHub** (a website that stores repositories in the cloud so you can share them). During class we walk through live demos; those commands are in [demos/02-git](../../demos/02-git/README.md) for reference.

The notes are in three parts:

1. [Part I](#part-i-your-own-repository): a repository you own (clone, add, commit, push).
2. [Part II](#part-ii-collaboration-on-a-shared-repository): contribute as a **collaborator** on one shared repository (push, pull, and merge conflicts).
3. [Part III](#part-iii-contributing-to-someone-elses-repository): contribute to someone else's repository *without* write access (fork and pull request). That is the usual open-source workflow.

Work through the sections below on your own machine. When you finish, complete **Lab 02** in Canvas (link and due date are posted there).

## Setup

You need Git, a GitHub account, and a Personal Access Token. Follow [setup/git.md](../../setup/git.md). Work in `~/ds2022-fall-26`. Do **not** clone inside another Git repository.

## Part I: Your Own Repository

First you will create a GitHub repository, clone it, save a file, and push. That is the basic loop on a repo you control.

### Step 1: Create a New Repository on GitHub

1. Sign in at [https://github.com](https://github.com) and click **New** (or **+** → **New repository**).
2. Choose a name, for example `ds2022-git-practice`.
3. Adding a README is optional. If you check that box, GitHub creates a `main` branch for you. If you skip it, the repo is empty until your first push.
4. Leave the repository **public** so a classmate can fork it later.
5. Click **Create repository**.
6. On the repository page, click **Code** → **HTTPS** and copy the URL. It looks like `https://github.com/YOUR_USERNAME/ds2022-git-practice.git`.

### Step 2: Clone the Repository

```bash
mkdir -p ~/ds2022-fall-26
cd ~/ds2022-fall-26
git clone https://github.com/YOUR_USERNAME/ds2022-git-practice.git
cd ds2022-git-practice
ls -la
```

Replace the URL with yours. `ls -la` always shows the hidden `.git` directory. If you added a README, that file is there too.

If Git asks for a password, paste your Personal Access Token, not your GitHub password.

```bash
git remote -v
git status
```

`origin` is a nickname for the GitHub URL you cloned from. If you created the repository with a README, you should be on `main` and "working tree clean" (nothing has changed since the last snapshot). If you skipped the README, Git will report that you have no commits yet.

### Step 3: Add a File, Commit, and Push

Create a simple Python script, `hello.py`:

```bash
echo 'print("Hello")' > hello.py
git status
```

`hello.py` is **untracked**. Git sees the file in your folder but is not recording it yet.

To make Git aware of it and include it in the next snapshot, add it (this **stages** the file):

```bash
git add hello.py
git status
```

`hello.py` now appears under "Changes to be committed."

Create a second file, `README.md`:

```bash
echo "A simple Python script" > README.md
git status
```

If you skipped a README when you created the GitHub repo, `README.md` is untracked. If GitHub already created one, status shows it as modified (this command overwrites that file).

`git add -A` is shorthand for "stage everything": new files, edits, and deletions. Git still skips files listed in `.gitignore` (you do not have one yet, so both `hello.py` and `README.md` get added):

```bash
git add -A
git status
```

Commit the snapshot. This is still only on your laptop:

```bash
git commit -m "Add hello.py and README.md"
```

Refresh your repository on GitHub. The new commit is not there yet.

```bash
git push -u origin main
```

`-u` is only needed the first time you push `main`: it tells Git that your local `main` belongs with the `main` on GitHub, so later you can type just `git push`. Either way, `git push origin main` always works. Refresh the GitHub page. You should see `hello.py` and `README.md`. A **commit** is a snapshot on your laptop; **push** publishes that snapshot to GitHub.

## Part II: Collaboration on a Shared Repository

Part I was a repository you own. Here the owner **adds everyone as collaborators**, so you all clone the *same* GitHub repository and push to the same `origin`. There is no fork and no pull request: you write directly to the shared `main` branch. Forks and pull requests are [Part III](#part-iii-contributing-to-someone-elses-repository), for when you do *not* have write access.

Everyone works on their own copy of the project, and Git combines those copies. When two people change the same file, Git cannot guess which version you meant to keep, so it stops and asks you. That is a **merge conflict**, and resolving one is the main skill in this part: you read both versions, keep the work that belongs together, and save the combined result.

We will start with changes that cannot collide (each person adds a file with a different name, so Git merges them for you), then create a collision on purpose and fix it as a team.

**At your table, split into teams of two or three.** Select one person to set up a new repository on GitHub. Work through these steps:

### Step 1: Repository Setup

- One person (the "creator") in your group sets up a new repository on GitHub:
  1. Click **New** (or **+** → **New repository**).
  2. Choose a repository name.
  3. Check **Add a README file**. GitHub creates an empty (or nearly empty) `README.md` and the first commit on `main`. Do **not** skip this. An empty GitHub repo with no README leads to "unrelated histories" if people start committing separately.
  4. Leave the repository **public** and click **Create repository**.
- The creator adds all group members as collaborators to the new repository on GitHub:
  - Go to **Settings** → **Collaborators** (under **Access** in the left sidebar) → **Add people**.
  - Search for each teammate by GitHub username and click **Add [username] to [repository]**. Each invited teammate must accept the invitation (email, GitHub notification, or the banner on the repository page) before they can clone and push.

### Step 2: Clone the Repository

- Open a terminal window.
- Using the command line, **all** group members clone the new repository onto their own laptop. Make sure you are **not** inside an existing Git repository (you don't want one Git repository inside another). Do **not** run `git init` yourself; clone the repo the creator just made.
- Change to `~/ds2022-fall-26` first (we created that directory last week; `mkdir -p` is safe to re-run if it is missing):

```bash
mkdir -p ~/ds2022-fall-26
cd ~/ds2022-fall-26
git clone https://github.com/CREATOR_USERNAME/REPO_NAME.git
cd REPO_NAME
ls -la
```

Replace `CREATOR_USERNAME` and `REPO_NAME` with the actual GitHub username and repository name. `ls -la` should show `README.md` plus the hidden `.git` directory.

### Step 3: Open the Cloned Repository as a Project in Cursor

- In Cursor, switch to the **IDE Window** if you are not already there (**File → Open IDE**, or confirm the File menu shows **Switch to Agent Windows**).
- Go to **File → New Window**. Then **File → Open Folder...** and navigate to `ds2022-fall-26` → `REPO_NAME` (`REPO_NAME` is a placeholder for your cloned repository).
- Go to **View → Explorer**. This will open the folder/file explorer in the Cursor sidebar.

### Step 4: Create Unique Files

Each group member should create a new text file in their local repository. Use unique filenames so Git can merge everyone's work automatically in the next step (for example, `alice.txt`, `bob.txt`).

Since we learned about the CLI, let's practice our skills. If your Cursor window doesn't show a terminal, go to **Terminal → New Terminal**. By default, you should be in the top-level directory of the cloned repository. Confirm with `pwd` and then use `echo` with redirect to create the new file (replace `alice.txt` and the message with your own name):

```bash
pwd
echo "Hello from Alice" > alice.txt
```

The new file should show up in your project's **Explorer** sidebar. As an alternative to the command line, you can also create new files in the Cursor GUI: in the **Explorer** sidebar, right-click (on Mac: Control-click, or a two-finger tap) and select **New File**. Then use the editor to update the file's content.

### Step 5: Add, Commit, and Push Local Changes

Unique filenames avoid *file* collisions, but two people still cannot push new commits to `main` at the same time. Go **one person at a time**, clockwise from the creator. Each person (using their own filename):

```bash
git add alice.txt
git commit -m "Add alice.txt"
git push origin main
```

If `git push` is rejected because a teammate pushed first, you may see an error message like this (**Hint:** use the Cursor **Agents Window** if you'd like a deeper explanation of the error):

```text
! [rejected]        main -> main (fetch first)
error: failed to push some refs to 'https://github.com/CREATOR_USERNAME/REPO_NAME.git'
hint: Updates were rejected because the remote contains work that you do
hint: not have locally. This is usually caused by another repository pushing
hint: to the same ref. You may want to first integrate the remote changes
hint: (e.g., 'git pull ...') before pushing again.
```

Pull from `origin` (the copy on GitHub) to bring in their work, then push again:

```bash
git pull origin main --no-rebase
```

(`--no-rebase` tells Git to combine the two versions of the history with a merge commit, instead of rewriting your commits on top of the remote ones. Newer versions of Git may print a warning if you leave the strategy unspecified.)

Because everyone picked a different filename, Git can combine the work on its own, so there is no conflict to resolve. Your editor may still open with a default merge-commit message; save and close that file to finish the merge. Then push:

```bash
git push origin main
```

Repeat until everyone has pushed their file.

### Step 6: Verify on GitHub

Everyone: visit the repository page on GitHub and check that all the new files are there.

### Step 7: Pull Latest Changes

Everyone: run the following command so every local copy has every teammate's unique file:

```bash
git pull origin main --no-rebase
```

**So far, so good. Let's take it to the next level!**

### Step 8: Create Collision File

When you collaborate, two people often edit their own copy of the *same* file at the same time. Their copies then disagree, and somebody has to decide what the file should look like. Let's create that situation on purpose.

Everyone: create a new file `collision.txt` in your local repository. The file should contain a single line with your first name and favorite animal. Add, commit, and push it to the remote repository on GitHub:

```bash
echo "Alice, cat" > collision.txt
git add collision.txt
git commit -m "Add collision.txt"
git push origin main
```

### Step 9: Resolve Merge Conflicts

**The early bird gets the worm:** If you are the first person to push the `collision.txt` file, you're in luck: the push should go through without a hitch. The others will see the same rejected-push error as in Step 5:

```text
! [rejected]        main -> main (fetch first)
error: failed to push some refs to 'https://github.com/CREATOR_USERNAME/REPO_NAME.git'
hint: Updates were rejected because the remote contains work that you do
hint: not have locally. This is usually caused by another repository pushing
hint: to the same ref. You may want to first integrate the remote changes
hint: (e.g., 'git pull ...') before pushing again.
```

This time the rejection is only the start. After you pull, Git will also report a **merge conflict**, because you and your teammate both edited `collision.txt`.

**To resolve the conflict:**

Starting with the group member next to the first person who successfully pushed, go clockwise and perform the following steps *one person at a time*:

1. Pull your teammate's version so Git can try to combine it with yours:

```bash
git pull origin main --no-rebase
```

(`--no-rebase` tells Git to combine the two versions of the history with a merge commit, instead of rewriting your commits on top of the remote ones. Newer versions of Git may print a warning if you leave the strategy unspecified.)

Git starts the merge and then pauses, because it found a conflict. The merge stays unfinished until you fix the file yourself.

2. Cursor will highlight the conflicting lines in `collision.txt`. Git writes both versions into the file with conflict markers. If Alice pushed first (`Alice, cat`) and Bob then pulled, Bob's file looks like this:

```text
<<<<<<< HEAD
Bob, dog
=======
Alice, cat
>>>>>>> origin/main
```

- The block between `<<<<<<< HEAD` and `=======` is **your local version** (what you committed before the pull). Cursor labels this **Current Change**.
- The block between `=======` and `>>>>>>> origin/main` is the **remote version** (what you just pulled from GitHub). Cursor labels this **Incoming Change**.

3. **Resolve the conflict:** Keep both entries instead of picking one, so nobody's line is lost. Delete the three marker lines (`<<<<<<<`, `=======`, `>>>>>>>`); Git added them to show you the two versions, and they are not part of your content. The file should end up with every group member's entry, one per line:

```text
Alice, cat
Bob, dog
Carol, bird
```

4. After resolving the conflict, stage the resolved file:

```bash
git add collision.txt
```

5. Complete the merge. Git will open a commit message in the editor (a default merge message is fine). Save and close that file to finish:

```bash
git commit -m "merged"
```

This creates the merge commit.

6. Push your changes:

```bash
git push origin main
```

7. The next person in the group repeats steps 1-6. Continue until everyone has pushed their entry and the `collision.txt` file on GitHub holds all of them.

**Congratulations, you did it!**


## Part III: Contributing to Someone Else's Repository

Part I was a repository you own. [Part II](#part-ii-collaboration-on-a-shared-repository) was a shared repository where the owner added you as a collaborator. To change a repository you do *not* own, cloning is not enough: anyone can clone a public repository, but that does not give you permission to push to it, so `git push` will be refused.

There are two different ways to contribute:

- **Shared repository** ([Part II](#part-ii-collaboration-on-a-shared-repository)): the owner adds you as a collaborator, and everyone pushes to the same `origin`. You already practiced that, including merge conflicts.
- **Fork and pull request** (this part): you copy the repo under your account, push there, and ask the owner to take your change. You are not a collaborator.

A **fork** is a copy of someone else's GitHub repository under *your* account. Because you own that copy, you are allowed to push to it. GitHub's documentation: [Fork a repository](https://docs.github.com/en/pull-requests/how-tos/work-with-forks/fork-a-repo).

### Fork a classmate's repository

1. Ask a classmate for the GitHub URL of the repository they created in Part I (for example `https://github.com/CLASSMATE_USERNAME/ds2022-git-practice`). Open it in the browser.
2. Click **Fork**, then **Create fork**. If GitHub says you already have a repository with that name, give the fork a different name (for example `ds2022-git-practice-fork`).
3. Clone **your fork**, not the original. Work in `~/ds2022-fall-26` (do not clone inside another Git repository):

```bash
cd ~/ds2022-fall-26
git clone https://github.com/YOUR_USERNAME/FORK_NAME.git
cd FORK_NAME
```

Replace `FORK_NAME` with the name GitHub showed *after you forked*.

4. Add a file, commit, and push. This should succeed, because `origin` is *your* fork:

```bash
echo "Hello from a fork" > fork-hello.txt
git add fork-hello.txt
git commit -m "Add fork-hello.txt"
git push origin main
```

5. Refresh **your** fork on GitHub. You should see `fork-hello.txt`. Your classmate's original repository is unchanged.

### Open a pull request

6. A **pull request** asks the original owner to take your change. On your fork's GitHub page, click **Contribute** → **Open pull request** (or the **Compare & pull request** banner if GitHub shows one). Confirm that the **base** repository is your classmate's original and the **head** is your fork, then click **Create pull request**.

7. Your classmate opens **Pull requests** on their repository, reviews `fork-hello.txt`, and clicks **Merge pull request**. After they refresh, the original repo has your file. That is the full loop: fork → change → push → pull request → merge.

## Advanced Topics

### Rolling back

A **commit** is a snapshot. `git log` lists those snapshots, newest first. Each line starts with a **commit hash**, a unique ID Git assigned to that snapshot (you only need the first 7 characters):

```bash
cd ~/ds2022-fall-26/ds2022-git-practice
git log --oneline
```

The output looks something like this:

```text
9f2c1ab (HEAD -> main, origin/main) Add hello.py and README.md
3d7e4c0 Initial commit
```

The newest commit is on top. Here `9f2c1ab` is the snapshot you pushed in Part I, and `3d7e4c0` is the commit GitHub created with your README (if you skipped the README, you may only have one commit). Your hashes will be different from these, because Git calculates them from the contents of each commit.

The `(HEAD -> main, origin/main)` part tells you where things stand: your local `main` branch is at that commit, and so is GitHub's copy of `main` (origin/main).

To look at an earlier snapshot **on your laptop only**, check it out by hash. Replace `HASH` with a value from your own `git log` output:

```bash
git checkout HASH
ls
```

The files in your folder now match that older commit. Git also prints a warning about a **detached HEAD**. That means your working copy points at one specific commit instead of at the name `main`. Your newer commits are all still there, and nothing on GitHub changed. **A commit you make in this state would not belong to any branch, so look around but do not commit.**

Go back to the newest commit on `main`:

```bash
git switch main
ls
```

`git checkout` only changes which snapshot you are looking at; it never deletes commits. If you want to edit files and keep those edits, do it on a branch instead (next section).

### Branches

So far you have been working on one line of history called `main`. A **branch** is just a named copy of that line of history. You can create another branch, edit files there, and switch back to `main` without losing anything. That is how you can add a new feature or work on bug fixes while leaving `main` alone.

A new GitHub repository starts with a single branch. GitHub names it `main` by default. That first branch is the **default branch**: it is what you see on the GitHub website, and it is the branch Git puts you on when you clone. New pull requests usually merge into `main` unless you pick a different target.

**Try it on the repo from Part I** (`~/ds2022-fall-26/ds2022-git-practice`):

```bash
cd ~/ds2022-fall-26/ds2022-git-practice
git switch -c development
git branch -a
```

The output of `git branch -a` lists every branch in the repository. The `*` marks the branch you are on right now.

```bash
echo "only on this branch" > new_feature.txt
git add new_feature.txt
git commit -m "Add new_feature.txt"
```

```bash
git switch main
git branch -a
ls
git switch development
ls
```

`new_feature.txt` appears only on `development`. `git switch -c NAME` creates a new branch and moves you to it; `git switch NAME` moves you to a branch that already exists.

Optional: publish the branch with `git push -u origin development`. On GitHub you can open a pull request from `development` into `main` (same idea as Part III, but both sides are your repo). This will merge the content of `development` into the `main` branch.

## Resources

- <a href="https://uvads.github.io/git-basics/" target="_blank" rel="noopener noreferrer">git in Data Science</a> - Brief introduction to Git
- <a href="https://skills.github.com/" target="_blank" rel="noopener noreferrer">GitHub Skills</a>
- <a href="https://docs.github.com/en/pull-requests/reference/branches?versionId=free-pro-team%40latest&productId=pull-requests&restPage=how-tos%2Cwork-with-forks%2Cfork-a-repo" target="_blank" rel="noopener noreferrer">Git Branches</a>