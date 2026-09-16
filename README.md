# DS2022

Course material for **DS2022 Systems I: Introduction to Computing**

## Fall 2026

Instructors: 
[**Daniel Graham**](https://datascience.virginia.edu/people/daniel-graham)
[**Karsten Siller**](https://datascience.virginia.edu/people/karsten-siller)

Syllabi and course details are in Canvas (single page for all sections):

- [**DS2022 Sections 001 - 003**](https://canvas.its.virginia.edu/)

## Setup

Please read and complete all [setup instructions](setup/GENERAL.md) by the end of week 1.

## Content

- [Schedule](CONTENT.md): Overview of weekly topics
- [Class materials](class/): Hands-on exercises
- [In-class demos](demos/): Documentation of instructor-led live coding demos

## Staying up to date

Course materials change during the semester. Work from **your fork**, and periodically pull new content from the course repository (**upstream**).

- **First time only:** [Initial setup](#initial-setup-do-this-once)
- **Each week (or whenever we update materials):** [Weekly sync](#weekly-sync)
- **When you want to save your own notes or work:** [Push your work to GitHub](#push-your-work-to-github)

### Initial setup (do this once)

1. Log in to GitHub and **fork** this course repository (`ksiller/DS2022`).

2. Clone **your fork** (replace `YOUR_USERNAME`):

```bash
git clone https://github.com/YOUR_USERNAME/DS2022.git
cd DS2022
```

3. Check remotes:

```bash
git remote -v
```

After a fresh clone you should only see `origin` (your fork):

```
origin    https://github.com/YOUR_USERNAME/DS2022.git (fetch)
origin    https://github.com/YOUR_USERNAME/DS2022.git (push)
```

If `upstream` is already listed and points to `https://github.com/ksiller/DS2022.git`, skip to [Weekly sync](#weekly-sync).

4. Add the course repository as **upstream**:

```bash
git remote add upstream https://github.com/ksiller/DS2022.git
```

5. Confirm both remotes:

```bash
git remote -v
```

```
origin    https://github.com/YOUR_USERNAME/DS2022.git (fetch)
origin    https://github.com/YOUR_USERNAME/DS2022.git (push)
upstream  https://github.com/ksiller/DS2022.git (fetch)
upstream  https://github.com/ksiller/DS2022.git (push)
```

- **origin**: your fork on GitHub (you push here)
- **upstream**: the course repository (you pull updates from here)

### Weekly sync

Run these steps in your local `DS2022` folder whenever you want the latest course materials.

1. Save any local work you care about (or confirm there is nothing to save):

```bash
git status
```

If you have changes to keep:

```bash
git add .
git commit -m "Save my local work"
```

If the working tree is clean, skip the commit.

2. Update `main` from the course repository:

```bash
git switch main
git fetch upstream
git merge upstream/main
```

3. (Optional) Update your fork on GitHub so it matches what you just synced:

```bash
git push origin main
```

If Git reports a merge conflict, ask in class or office hours before forcing anything.

### Push your work to GitHub

When you add your own notes or files and want them on your fork:

```bash
git add .
git commit -m "Describe your change"
git push origin main
```

Push to **origin** (your fork), not upstream. You do not have write access to the course repository.
