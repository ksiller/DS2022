# Setting Up Your Laptop with the Cursor CLI

## Quick start (two commands)

### Open a terminal

**Mac:** press **`Cmd + Space`**, type `Terminal`, press **Return**.

**Windows:** the course uses **WSL (Ubuntu)**. If you have never installed it, do this one-time step first:

1. Press **`Win + X`**, then press **`A`** (opens *Terminal (Admin)* / *PowerShell (Admin)*). Click **Yes** if Windows asks for permission.
2. Run:

   ```powershell
   wsl --install
   ```

3. **Restart your computer.** After the restart, an *Ubuntu* window opens and asks you to create a Linux username and password (they do not have to match your Windows login). Nothing appears while you type the password — that is normal.

From then on, open Ubuntu with: press **`Win`**, type `Ubuntu`, press **Enter** (or press **`Win + R`**, type `wsl`, press **Enter**). **Run the two commands below inside that Ubuntu window, not in PowerShell.**

### Run the two commands

**1. Install the Cursor CLI**, then **close and reopen the terminal**:

```bash
curl https://cursor.com/install -fsS | bash
```

Once the cursor cli completes running. It will output a command that you need to run add cursor to your path. **RUN THIS COMMAND**. 

**2. Start the agent and point it at the course setup instructions:**

```bash
agent --force "Read https://raw.githubusercontent.com/ksiller/DS2022/refs/heads/main/setup/GENERAL.md and walk me through completing every step on this laptop. Install whatever you can without asking me for approval. Only stop when I personally have to do something: create or sign in to an account, run a graphical installer, enable 2FA, or type a password. When you stop, tell me exactly what to do, then continue when I type done. Finish with a checklist of what is done and what I still need to do myself."
```

The first time, the agent asks you to sign in to Cursor — a browser window opens; sign in with your free *Hobby* account and return to the terminal. (If no browser opens, run `agent login` first, then repeat command 2.)

That is it. Follow the agent's instructions until it prints the final checklist. The rest of this page explains each step in more detail, with screenshots, and has a troubleshooting section if something goes wrong.

---

## Detailed walkthrough

This guide walks you through installing the **Cursor CLI** (a coding agent that runs in your terminal) and then using it to work through the course [Getting Started checklist](GENERAL.md). Instead of installing every tool by hand, you will let the agent check what is already on your machine, install the missing command-line tools, and confirm everything works.

**Complete this before the end of week 1.** Budget about 45–60 minutes. Visit office hours if you get stuck.

> **Note:** Some steps may throw errors or need extra configuration. That is normal. Google, Stack Overflow, and your classmates are good resources; the instructional staff cannot provide desktop support.

---

## Contents

0. [Quick start (two commands)](#quick-start-two-commands)
1. [Before you start](#1-before-you-start)
2. [Install the Cursor CLI](#2-install-the-cursor-cli)
   - [macOS](#macos)
   - [Windows (WSL — recommended)](#windows-wsl--recommended)
   - [Windows (PowerShell — alternative)](#windows-powershell--alternative)
3. [Log in](#3-log-in)
4. [Run the setup with the agent](#4-run-the-setup-with-the-agent)
5. [Verify your setup](#5-verify-your-setup)
6. [Troubleshooting](#6-troubleshooting)
7. [Quick reference](#7-quick-reference)

---

## 1. Before you start

You need three things before installing the CLI:

| | What | Why |
|---|---|---|
| ☐ | A **Cursor account** on the free *Hobby* tier — sign up at <https://cursor.com> | The CLI logs in with this account. |
| ☐ | **macOS:** the **Terminal** app (Applications → Utilities). Consider adding it to your Dock. | You will type all commands here. |
| ☐ | **Windows:** **WSL (Windows Subsystem for Linux)** installed — see [Microsoft's WSL install guide](https://learn.microsoft.com/en-us/windows/wsl/install). The default install gives you Ubuntu. | The course develops inside WSL, so the CLI should live there too. **Finish WSL before continuing.** |

**Windows users — what WSL setup looks like.** In PowerShell you run `wsl --install`, restart, and then Ubuntu opens and asks you to create a Linux username and password (they do not need to match your Windows login):

![Running wsl --install in Windows PowerShell](https://learn.microsoft.com/en-us/windows/wsl/media/wsl-install.png)

![Ubuntu first run asking for a new UNIX username](https://learn.microsoft.com/en-us/windows/wsl/media/ubuntuinstall.png)

*Screenshots: Microsoft Learn, [Set up a WSL development environment](https://learn.microsoft.com/en-us/windows/wsl/setup/environment).*

If you already have the Cursor IDE installed, great — the CLI is a separate, small install and does not change the IDE.

---

## 2. Install the Cursor CLI

Pick **one** of the sections below for your operating system.

### macOS

1. Open **Terminal** (press `Cmd + Space`, type `Terminal`, press Return). A Terminal window looks like this — the line ending in `%` is where you type:

   ![The macOS Terminal window with a shell prompt](https://help.apple.com/assets/67DB80CC8ED20D93270BDBE5/67DB80CD888B30021203ACDC/en_US/08b5aaad211dbab5656113d16eb5301a.png)

   *Screenshot: Apple, [Terminal User Guide](https://support.apple.com/guide/terminal/get-started-pht23b129fed/mac).*

2. Paste this command and press Return:

   ```bash
   curl https://cursor.com/install -fsS | bash
   ```

   The installer downloads the CLI into `~/.local/bin` and adds that folder to your PATH. It takes about 10–30 seconds.

3. **Close Terminal completely and open it again** (`Cmd + Q`, then relaunch). This is required so your shell picks up the new PATH.

4. Confirm it worked:

   ```bash
   agent --version
   ```

   You should see a version number such as `2026.08.xx-xxxxxxx`.

   If you see `command not found: agent`, jump to [Troubleshooting → "agent: command not found"](#agent-command-not-found).

### Windows (WSL — recommended)

Install the CLI **inside WSL (Ubuntu)**, not in PowerShell. This matches where you will do all your course work.

1. Open your Ubuntu terminal: press the **Windows key**, type `Ubuntu`, and press Enter. (You can also open **Windows Terminal** and choose the *Ubuntu* tab from the dropdown, as in the screenshot below — the pane with the `$` prompt is Ubuntu.)

   ![Windows Terminal with an Ubuntu tab open](https://learn.microsoft.com/en-us/windows/wsl/media/terminal.png)

   *Screenshot: Microsoft Learn, [Set up a WSL development environment](https://learn.microsoft.com/en-us/windows/wsl/setup/environment).*

2. Make sure `curl` is available (it usually is; this is harmless if it already exists):

   ```bash
   sudo apt update && sudo apt install -y curl
   ```

   Type your **WSL password** when prompted. Nothing appears as you type — that is normal. Press Enter.

3. Paste the installer command and press Enter:

   ```bash
   curl https://cursor.com/install -fsS | bash
   ```

4. **Close the Ubuntu window and open it again** so your PATH updates.

5. Confirm it worked:

   ```bash
   agent --version
   ```

   If you see `agent: command not found`, jump to [Troubleshooting](#agent-command-not-found).

### Windows (PowerShell — alternative)

Only use this if you cannot get WSL working. You will need to install the Windows versions of `git`, `jq`, and Python later, and some course commands will not work the same way.

1. Press the **Windows key**, type `PowerShell`, and open **Windows PowerShell**.

   ![Windows Start menu search showing PowerShell](https://learn.microsoft.com/en-us/powershell/docs-conceptual/install/media/install-powershell-on-windows/powershell-start-menu.png)

   *Screenshot: Microsoft Learn, [Installing PowerShell on Windows](https://learn.microsoft.com/en-us/powershell/scripting/install/installing-powershell-on-windows).*

2. Paste and press Enter:

   ```powershell
   irm 'https://cursor.com/install?win32=true' | iex
   ```

3. **Close PowerShell and open it again.**

4. Confirm:

   ```powershell
   agent --version
   ```

---

## 3. Log in

The CLI needs to be connected to your Cursor account.

1. In your terminal (Terminal on Mac, Ubuntu on Windows), run:

   ```bash
   agent login
   ```

2. Your web browser opens to a Cursor sign-in page. Sign in with the same account you created in [Step 1](#1-before-you-start) and click **Authorize** (or the equivalent button) when asked.

   > **WSL users:** the browser should open on the Windows side automatically. If it does not, the terminal prints a URL — copy it into any browser on your laptop.

3. Go back to the terminal. It should say you are logged in. Double-check with:

   ```bash
   agent status
   ```

   It prints the email address of the account you are logged in with.

---

## 4. Run the setup with the agent

Now you will hand the [Getting Started checklist](GENERAL.md) to the agent and let it help you through it.

**What the agent can and cannot do:**

| The agent **can** | The agent **cannot** |
|---|---|
| Check whether `git`, `jq`, `python3`, `docker`, etc. are installed and which versions | Create accounts for you (GitHub, AWS, Docker) |
| Install command-line tools automatically (Homebrew, git, jq, Python) | Click through graphical installers (Rancher Desktop, Cursor IDE, Python.org installer) |
| Explain any error message you hit | Enable 2FA or verify GitHub Education |
| Tell you exactly which manual steps are still left | Install Windows-side programs from inside WSL |

So expect a mix: the agent does the terminal work, and it will tell you when to go do something in a browser or installer yourself.

### 4.1 Create a working folder

Keep course work in one place. In your terminal:

```bash
mkdir -p ~/ds2022 && cd ~/ds2022
```

### 4.2 Start the agent in auto-run mode

Start the agent with the `--force` flag so it runs commands **without asking you to approve each one**. It will only stop when it needs *you* — for example to create an account in your browser, click through a graphical installer, or type your password.

```bash
agent --force
```

> **What `--force` does:** the agent runs shell commands automatically instead of pausing for a `y/n` on every one. A short deny-list (below) still blocks a few destructive commands. If you would rather approve each command yourself, run `agent` without the flag.

**Optional safety net (recommended, one-time):** create a small config file that forbids a few destructive commands even in auto-run mode. Paste this whole block into your terminal:

```bash
mkdir -p ~/.cursor && cat > ~/.cursor/cli-config.json <<'EOF'
{
  "permissions": {
    "allow": ["Shell(*)", "Read(**)", "Write(**)", "WebFetch(*)"],
    "deny": ["Shell(rm)", "Shell(rmdir)", "Shell(dd)", "Shell(mkfs)", "Shell(shutdown)", "Shell(reboot)"]
  }
}
EOF
```

Deny rules always win over allow rules, so these commands are blocked even with `--force`.

The first time you run the agent in a folder, it may ask whether you trust this workspace — answer **yes**. You will then see a prompt where you can type instructions. It looks like this (the folder name and branch will be yours):

![The Cursor Agent CLI prompt in a terminal window](https://ptht05hbb1ssoooe.public.blob.vercel-storage.com/assets/blog/og/cli-og.png)

*Screenshot: Cursor, [Cursor CLI announcement](https://cursor.com/blog/cli).*

### 4.3 Give the agent the checklist

Copy the whole block below, paste it into the agent prompt, and press Enter:

```text
I am a student setting up my laptop for the DS2022 course. Please read the
setup checklist at this URL and help me complete it:

https://raw.githubusercontent.com/ksiller/DS2022/refs/heads/main/setup/GENERAL.md

Work through the "Software" and "Python" sections step by step:
1. First, detect my operating system and shell, and tell me which items you
   can do from this terminal and which I must do myself (accounts, graphical
   installers).
2. For each command-line tool (git, jq, python3, pip, and Homebrew on Mac),
   check whether it is already installed and report the version. Install
   whatever is missing. Do NOT stop to ask for approval on commands — just
   run them and tell me what you did.
3. Only pause and wait for me when something genuinely requires me: creating
   or signing in to an account (GitHub, AWS, Docker, Cursor), running a
   graphical installer (Rancher Desktop, Cursor IDE, Python.org installer),
   enabling 2FA, or typing a password. When you pause, tell me exactly what
   to do and say "type done when finished."
4. Confirm the versions meet the checklist's requirements (e.g. Python 3.9+).
5. At the end, print a checklist showing what is DONE, what you INSTALLED,
   and what I still need to do MANUALLY, with the link for each manual item.

Explain each step briefly in plain language — I am new to the terminal.
```

### 4.4 What to expect while it runs

Because you started with `--force`, the agent installs tools on its own and narrates what it is doing — each step it takes shows up as a line in the terminal, like this:

![The Cursor Agent CLI showing completed steps and a prompt](https://ptht05hbb1ssoooe.public.blob.vercel-storage.com/assets/features/cli-og-image-2.png)

*Screenshot: Cursor, [cursor.com/cli](https://cursor.com/cli).*

You will only be interrupted for things the agent cannot do for you:

- **Password prompts.** On WSL, `sudo` asks for your **WSL password**. On Mac, installing Homebrew asks for your **Mac login password**. Nothing appears as you type — press Enter when done.
- **"Go do this, then type done."** For accounts, 2FA, and graphical installers the agent stops and tells you what to do in your browser or installer. Do it, then type `done` and press Enter.

> **Mac users:** if Homebrew is missing, the agent will install it. That is the standard macOS package manager and it is what the checklist recommends. Homebrew's own installer looks like this and will ask for your password once:
>
> ![Homebrew install running in Terminal](https://brew.sh/assets/img/brew-install.gif)
>
> *Animation: [brew.sh](https://brew.sh).*

> **Watch the output.** Auto-run mode is convenient, but you are still responsible for your laptop. If the agent does something surprising, press `Ctrl + C` to stop it and ask it to explain.

### 4.5 Finish the manual items

When the agent prints its final checklist, do the **MANUAL** items in your browser or with the graphical installers. As of this writing those are:

- [ ] GitHub account → [enable 2FA](https://github.com/settings/security) → [GitHub Education](https://education.github.com/discount_requests/application)

  ![GitHub two-factor authentication setup screen](https://docs.github.com/assets/cb-23826/images/help/2fa/ghes-3.8-and-higher-2fa-wizard-app-click-code.png)

  *Screenshot: [GitHub Docs](https://docs.github.com/en/authentication/securing-your-account-with-two-factor-authentication-2fa/configuring-two-factor-authentication).*

- [ ] [AWS Free Tier](https://aws.amazon.com/free/) account
- [ ] [Docker account](https://app.docker.com/signup)
- [ ] [Rancher Desktop](https://docs.rancherdesktop.io/getting-started/installation/) — after installing, open **Preferences → Container Engine** and choose **dockerd (moby)**, then sign in with your Docker account.

  ![Rancher Desktop preferences with dockerd (moby) selected on macOS](https://suse-rancher-media.s3.amazonaws.com/desktop/v1.24/preferences/macOS_containerEngine_tabGeneral.png)

  *Screenshot: [Rancher Desktop docs](https://docs.rancherdesktop.io/ui/preferences/container-engine/general/). The Windows version has an extra **WSL** tab on the left.*

- [ ] [Cursor IDE](https://cursor.com) on your **primary OS** (Windows users: the Windows side, not WSL)
- [ ] The **UVA Data Science Extension Pack** inside Cursor — follow the VSIX steps in [GENERAL.md](GENERAL.md)

You can come back to the agent any time (`agent --force`) and ask, for example, *"I just installed Rancher Desktop — check that docker works."*

To leave the agent, type `/exit` or press `Ctrl + C`.

---

## 5. Verify your setup

Run these in a **fresh** terminal (Mac: Terminal; Windows: Ubuntu). Each should print a version, not an error.

```bash
agent --version
git --version
jq --version
python3 -V
docker --version      # only after Rancher Desktop is installed and running
```

Expected output looks roughly like this (your numbers will differ):

```text
$ git --version
git version 2.4x.x
$ jq --version
jq-1.7.x
$ python3 -V
Python 3.12.x
$ docker --version
Docker version 2x.x.x, build xxxxxxx
```

If anything errors, start the agent again (`agent --force`) and paste the exact error message — ask it to diagnose.

---

## 6. Troubleshooting

### `agent: command not found`

Your shell has not picked up the new PATH.

1. First, simply **close and reopen your terminal**. This fixes it most of the time.
2. If it still fails, add the install folder to your PATH manually.

   **Mac (zsh — the default):**
   ```bash
   echo 'export PATH="$HOME/.local/bin:$PATH"' >> ~/.zshrc
   source ~/.zshrc
   ```

   **WSL / Ubuntu (bash — the default):**
   ```bash
   echo 'export PATH="$HOME/.local/bin:$PATH"' >> ~/.bashrc
   source ~/.bashrc
   ```

3. Run `agent --version` again.

### `curl: command not found` (WSL)

```bash
sudo apt update && sudo apt install -y curl
```
Then re-run the installer.

### The installer says "permission denied"

Do **not** run the installer with `sudo`. Make sure you copied the command exactly, including the `| bash` at the end.

### `agent login` does not open a browser

The terminal prints a URL. Copy it and paste it into Chrome/Safari/Edge on your laptop, sign in, and return to the terminal.

### The agent says it cannot fetch the checklist URL

Paste the checklist text directly instead: open <https://raw.githubusercontent.com/ksiller/DS2022/refs/heads/main/setup/GENERAL.md> in your browser, select all, copy, and paste it into the agent after your instructions.

### Windows: `wsl` is not installed / Ubuntu does not open

Finish the [WSL installation](https://learn.microsoft.com/en-us/windows/wsl/install) first (you may need to restart Windows), then return to [Step 2](#windows-wsl--recommended).

### `docker: command not found` after installing Rancher Desktop

Make sure Rancher Desktop is **running** (it lives in your menu bar / system tray) and that the container runtime is set to **dockerd (moby)** in *Preferences → Container Engine*. On Windows, also enable WSL integration for your Ubuntu distro in *Preferences → WSL* (see below). Then open a **new** terminal.

![Rancher Desktop preferences on Windows showing the WSL tab and dockerd (moby)](https://suse-rancher-media.s3.amazonaws.com/desktop/v1.24/preferences/Windows_containerEngine_tabGeneral.png)

*Screenshot: [Rancher Desktop docs](https://docs.rancherdesktop.io/ui/preferences/container-engine/general/).*

### Updating the CLI later

```bash
agent update
```

---

## 7. Quick reference

| Task | Command |
|---|---|
| Install (Mac / WSL) | `curl https://cursor.com/install -fsS \| bash` |
| Install (Windows PowerShell) | `irm 'https://cursor.com/install?win32=true' \| iex` |
| Check version | `agent --version` |
| Log in | `agent login` |
| Check login | `agent status` |
| Start interactive session (approve each command) | `agent` |
| Start in auto-run mode (no approval prompts) | `agent --force` (alias: `agent --yolo`) |
| Permissions config (deny/allow lists) | `~/.cursor/cli-config.json` |
| One-off question | `agent -p "what version of python do I have?"` |
| Update | `agent update` |
| Log out | `agent logout` |
| Leave a session | `/exit` or `Ctrl + C` |

Official docs: <https://cursor.com/docs/cli>

---

*Screenshots in this guide are hot-linked from the official documentation of Apple, Microsoft, Cursor, SUSE (Rancher Desktop), GitHub, and Homebrew, and are credited under each image. Their appearance may differ slightly from your screen.*

<!--
Staff note — image sources (all verified live 2026-08-26). If one breaks,
re-scrape the linked page for the current asset URL:
  Apple Terminal window ........ https://support.apple.com/guide/terminal/get-started-pht23b129fed/mac
  WSL install / Ubuntu / Terminal https://learn.microsoft.com/en-us/windows/wsl/setup/environment
  PowerShell Start menu ........ https://learn.microsoft.com/en-us/powershell/scripting/install/installing-powershell-on-windows
  Cursor CLI prompt ............ https://cursor.com/blog/cli   (OG image)
  Cursor CLI in progress ....... https://cursor.com/cli        (features/cli-og-image-2.png)
  Homebrew install gif ......... https://brew.sh
  GitHub 2FA ................... https://docs.github.com/en/authentication/securing-your-account-with-two-factor-authentication-2fa/configuring-two-factor-authentication
  Rancher Desktop prefs ........ https://docs.rancherdesktop.io/ui/preferences/container-engine/general/
The Apple asset URL contains a version hash and is the most likely to rotate.
-->
