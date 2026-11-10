# Claude & Cursor/VS Code

This guide shows you how to use **Claude Code**, Anthropic's coding agent, inside **Cursor** or **VS Code**. Claude Code can read your project, run terminal commands, and edit files. It always shows you what it wants to do before it does it.

You will:

1. [Install Claude Code](#1-install-claude-code)
2. [Sign in with your Claude account](#2-sign-in)
3. [Connect Claude Code to your IDE](#3-connect-claude-code-to-cursor-or-vs-code)
4. [Learn the everyday commands](#4-common-slash-commands-and-shortcuts)
5. [Use Claude Code to check or complete the course setup checklist](#5-example-run-or-dry-run-the-setup-checklist)

> **You already have a Claude account for this course.** The free claude.ai plan does *not* include Claude Code, so sign in with the account the course gave you, not a personal free account.

---

## 1. Install Claude Code

Claude Code comes in two parts. You can use either one, or both:

| Part | What it is | Where you use it |
|---|---|---|
| **IDE extension** | A Claude panel inside Cursor or VS Code | The editor window |
| **CLI** (`claude`) | Claude Code in a terminal | Terminal, Ubuntu/WSL, or the IDE's built-in terminal |

### 1a. The extension (Cursor or VS Code)

1. Open Cursor (or VS Code).
2. Open the Extensions view: **Cmd+Shift+X** (Mac) or **Ctrl+Shift+X** (Windows/Linux).
3. Search for **Claude Code**, check that the publisher is **Anthropic**, and click **Install**.
4. If the extension doesn't appear, open the Command Palette (**Cmd/Ctrl+Shift+P**) and run **Developer: Reload Window**.

VS Code needs version 1.94.0 or later.

### 1b. The CLI

Open a terminal and run the command for your system.

**Mac, Linux, or WSL (Ubuntu):**

```bash
curl -fsSL https://claude.ai/install.sh | bash
```

**Windows PowerShell** (only if you are *not* working in WSL):

```powershell
irm https://claude.ai/install.ps1 | iex
```

The installer shows no progress while it downloads. When it finishes, **open a new terminal window** and check the install:

```bash
claude --version
```

You should see a version number, such as `2.1.xxx (Claude Code)`. If you get `command not found`, see [Troubleshooting](#troubleshooting).

> **Windows users:** the course develops inside **WSL**. Run the Mac/Linux command **inside your Ubuntu window**, and start `claude` from Ubuntu, not from PowerShell.

---

## 2. Sign in

**In the extension:** click the Claude icon (a spark) to open the panel. The first time, a sign-in screen appears. Click **Sign in** and finish signing in in your browser.

**In the CLI:** run

```bash
claude
```

and follow the prompts. A browser window opens. Sign in with your course Claude account, approve access, and go back to the terminal. If no browser opens, copy the URL that the terminal prints and paste it into your browser.

Useful later:

- `/login` signs in again or switches accounts.
- `/logout` signs out.
- `/status` shows which account and model you are using.

> Never paste passwords, API keys, or tokens into a Claude conversation.

---

## 3. Connect Claude Code to Cursor or VS Code

Once Claude Code is connected to your IDE, it sees the file you have open and your selected text, and it shows proposed edits as side-by-side diffs that you can accept or reject.

### Option A: use the panel (easiest)

Open a project folder in Cursor (**File → Open Folder…**), then open Claude Code in any of these ways:

- Click the **spark icon** in the top-right corner of the editor. It only appears while a file is open.
- Click the **spark icon** in the left sidebar.
- Click **✻ Claude Code** in the status bar in the bottom-right corner.
- Open the Command Palette (**Cmd/Ctrl+Shift+P**), type `Claude Code`, and choose an option, such as **Open in New Tab**.

Claude works in the folder you opened, so always open the project folder, not just a single file.

> **Cursor tip:** Cursor has an *Agents* window and an *IDE* window. Use the **IDE** window. If the **File** menu shows **Open IDE**, click it first.

### Option B: run the CLI in the IDE's terminal

1. Open the built-in terminal: **Ctrl+`** (backtick).
2. Run `claude`.

When the extension is installed, the CLI connects to the IDE automatically.

If you run `claude` in a separate terminal app instead, type `/ide` inside Claude Code and pick Cursor or VS Code from the list. If you see "No available IDEs detected," install the extension first (step 1a).

### Keyboard shortcuts in the IDE

| Action | Mac | Windows/Linux |
|---|---|---|
| Switch focus between editor and Claude | `Cmd+Esc` | `Ctrl+Esc` |
| Open Claude in a new tab | `Cmd+Shift+Esc` | `Ctrl+Shift+Esc` |
| Insert a reference to the current file or selection (e.g. `@file.py#5-10`) | `Option+K` | `Alt+K` |

On recent macOS versions, `Cmd+Esc` may already be used by the system. If it does nothing, use the spark icon instead.

---

## 4. Common slash commands and shortcuts

Type `/` at the start of a message to see every command, or type `/` followed by a few letters to filter the list.

| Command | What it does |
|---|---|
| `/help` | Show help and the available commands |
| `/login`, `/logout` | Sign in or out of your Anthropic account |
| `/status` | Show version, model, account, and connection status |
| `/init` | Create a `CLAUDE.md` file that describes your project, so Claude understands it in future sessions |
| `/clear` | Start a new conversation with empty context. Do this when you switch tasks. |
| `/compact` | Summarize the conversation so far, to free up space in a long session |
| `/context` | Show how much of Claude's context (memory for this conversation) is used |
| `/model` | Switch the model |
| `/plan` | Enter **plan mode**: Claude researches and proposes, but changes nothing |
| `/permissions` | Choose which commands Claude may run without asking |
| `/diff` | Review all the changes Claude has made |
| `/rewind` | Undo: go back to an earlier point in the conversation and/or the code |
| `/resume` | Reopen an earlier conversation |
| `/ide` | Connect to Cursor or VS Code and show the connection status |
| `/usage` | Show your usage and plan limits |
| `/doctor` | Check your Claude Code installation and settings |
| `/exit` | Leave Claude Code (or press `Ctrl+C` twice) |

Other things you can type at the prompt:

| Type | Effect |
|---|---|
| `@` + a file name | Point Claude at a specific file, e.g. `explain @setup/GENERAL.md` |
| `!` + a command | Run a shell command yourself, e.g. `! python3 -V`. Claude sees the output. |
| **Shift+Tab** | Cycle permission modes, e.g. manual (asks before edits and commands) → accept edits → plan mode. The current mode is shown below the prompt. |
| **Esc** | Stop Claude in the middle of a response |
| **Esc Esc** | Jump back to an earlier message and edit it |

### Approving actions

Before Claude runs a command or edits a file, it asks you. Read the request, then choose:

- **Yes** to allow this one action.
- **Yes, and don't ask again** to allow this kind of action for the rest of the session or project. Use this only for commands you understand, such as `brew install`.
- **No** to refuse. Then tell Claude what to do instead.

You are responsible for what runs on your laptop. If you don't understand a command, ask Claude: *"What does this command do, and why do you need it?"*

---

## 5. Example: run or dry-run the setup checklist

The course checklist is in this repository at [`setup/GENERAL.md`](GENERAL.md). Claude Code can check your laptop against it and install the command-line tools you're missing.

**Before you start:** open the course repository folder in Cursor (**File → Open Folder…** and pick your `DS2022` folder). If you haven't cloned the repository, that's fine: Claude can read the checklist from its URL instead (see the second prompt below).

### Dry run first (recommended)

A dry run only *checks* your laptop and tells you what it would do. It installs nothing.

1. Open Claude Code (panel or `claude` in the terminal).
2. Turn on **plan mode**: press **Shift+Tab** until the mode indicator shows plan mode, or type `/plan`. In plan mode, Claude can only read and check things; it cannot change anything.
3. Paste this prompt:

```text
Read @setup/GENERAL.md and check this laptop against every step.
DRY RUN: do not install, change, or log in to anything. Only run read-only
checks, such as version commands and looking for installed apps.
For each step, tell me: what you checked, the result, and what you would do
to finish it. Mark the steps that only I can do: creating or signing in to an
account, running a graphical installer, enabling 2FA, or typing a password.
Never show passwords, tokens, or keys; if a file may contain them, report only
whether it exists.
End with a checklist of what is done and what is still missing.
```

If you haven't cloned the repository, replace the first line with:

```text
Read https://raw.githubusercontent.com/ksiller/DS2022/refs/heads/main/setup/GENERAL.md
and check this laptop against every step.
```

### Real run

When the dry run looks right, press **Shift+Tab** to leave plan mode (or start a fresh conversation with `/clear`) and paste:

```text
Read @setup/GENERAL.md and walk me through completing every step on this
laptop. Install the command-line tools that are missing (for example with
Homebrew on Mac, or apt in WSL). Only stop when I personally have to do
something: create or sign in to an account, run a graphical installer,
enable 2FA, or type a password. When you stop, tell me exactly what to do,
then continue when I type done. Never show passwords, tokens, or keys.
Finish with a checklist of what is done and what I still need to do myself.
```

Claude asks your permission before each install command. Read each one before you approve it. When Claude reaches a step that needs you, such as `docker login` or `sudo` asking for your password, run it yourself in the terminal by typing `!` in front of it (e.g. `! docker login`), or run it in a separate terminal window, then type `done`.

---

## Troubleshooting

**`claude: command not found` after installing.** Close and reopen the terminal. If it still fails, add the install folder to your PATH:

```bash
# Mac (zsh)
echo 'export PATH="$HOME/.local/bin:$PATH"' >> ~/.zshrc && source ~/.zshrc

# WSL / Ubuntu (bash)
echo 'export PATH="$HOME/.local/bin:$PATH"' >> ~/.bashrc && source ~/.bashrc
```

**Sign-in says your plan doesn't include Claude Code.** You're signed in with a personal free account. Run `/logout`, then `/login` with your course account.

**`/ide` says "No available IDEs detected".** Install the Claude Code extension in Cursor or VS Code (step 1a), reload the window, and try again.

**The spark icon isn't visible.** Open a file first, or use the **✻ Claude Code** button in the status bar.

**Something else is wrong.** Run `claude doctor` in a terminal, or ask Claude itself: *"/doctor"*.

Official documentation:

- Claude Code cheatsheet (commands, shortcuts, glossary): <https://support.claude.com/en/articles/14553413-claude-code-cheatsheet>
- Claude Code in VS Code and Cursor: <https://code.claude.com/docs/en/vs-code>
- Installation and sign-in: <https://code.claude.com/docs/en/setup>
- All commands: <https://code.claude.com/docs/en/commands>
