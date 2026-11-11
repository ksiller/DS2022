# Troubleshooting Docker setup

Use this if `docker` does not work after the install in [GENERAL.md](GENERAL.md).

**Mac:** use Terminal. **Windows:** use Ubuntu (WSL), not PowerShell. **Windows on ARM** (Snapdragon and similar): skip to [Windows on ARM](#windows-on-arm). Rancher Desktop has no Windows ARM build.

## The usual fix

Rancher Desktop must be running. Open it and click the gear icon (**Preferences**):

1. **Container Engine:** select **dockerd (moby)**.
2. **Kubernetes:** uncheck **Enable Kubernetes**.
3. **Windows only:** **WSL → Integrations** → check **Ubuntu**.

Click **Apply**. Close the terminal and open a new one (Mac: Terminal; Windows: Ubuntu):

```bash
docker run --rm hello-world
```

You should see `Hello from Docker!`.

Do not install a second Docker Engine (`docker-ce` or `docker.io`) in Ubuntu while Rancher Desktop or Docker Desktop is in use.

## Windows on ARM

Rancher Desktop publishes Windows installers for Intel and AMD only. On a Windows laptop with an ARM processor, install [Docker Desktop for Windows on Arm](https://docs.docker.com/desktop/setup/install/windows-install/) instead. Sign in with the Docker account from [GENERAL.md](GENERAL.md).

In Docker Desktop:

1. Use the **WSL 2** backend (the installer default).
2. **Settings → Resources → WSL integration:** turn on **Ubuntu**.
3. Leave **Kubernetes** off.

Open a new Ubuntu terminal and run `docker run --rm hello-world`.

Do not run Rancher Desktop and Docker Desktop at the same time.

## If it still fails

| What you see | What to do |
|---|---|
| `docker: command not found` | Open a new terminal. On Windows, if the app was installed while Ubuntu was open, run `wsl --shutdown` in PowerShell, wait until the app is running again, then open Ubuntu. |
| `Cannot connect to the Docker daemon` | Start Rancher Desktop or Docker Desktop, then open a new terminal. On Windows, confirm Ubuntu is turned on under Rancher Desktop **WSL → Integrations**, or under Docker Desktop **WSL integration**. |
| Ubuntu is not listed | In PowerShell, `wsl -l -v` must show Ubuntu as version `2`. If it shows `1`, run `wsl --set-version Ubuntu 2`. |

## Ask Claude or Cursor for help

Paste this into Claude or a Cursor agent on your own laptop, so it can see your files. It diagnoses first and changes nothing until you say yes. **Claude installation instructions are posted on Canvas if you need them.**

```text
Check whether Docker works on my laptop; it may already be fine. Don't change anything that works.

Course setup: Rancher Desktop with dockerd (moby) and Kubernetes off. On Windows, commands run in Ubuntu (WSL) with Ubuntu integration on. On Windows on ARM, use Docker Desktop instead (WSL 2, Ubuntu on, Kubernetes off). Never run both apps or install Docker Engine in Ubuntu.

1. Summarize what's working and find out what is wrong. Do not change anything yet.
2. Tell me what you would change, then stop.
3. Ask me before you change anything.
4. If I say yes, make only those changes. If I say no, stop.
5. Tell me what you changed, and have me run docker run --rm hello-world in a new terminal.