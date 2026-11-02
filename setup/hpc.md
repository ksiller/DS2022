# HPC Access

The UVA High Performance Computing (HPC) systems (Rivanna and Afton) are accessible through a web portal, secure shell terminals, or a remote desktop environment. See the [official documentation](https://www.rc.virginia.edu/userinfo/hpc/login/).

> [!IMPORTANT]
> **Service Unit Allocation:** This course uses the `ds2022` allocation. Select `ds2022` in the **Allocation** field whenever you request an interactive Open OnDemand session (Code Server (VSCode), JupyterLab, Desktop), and use it for every compute job you submit (`#SBATCH --account=ds2022` in your Slurm scripts, Lab 08).
>
> - If you have taken other courses that use HPC, the Allocation drop-down may list more than one allocation. Always choose `ds2022` for this course.
> - If `ds2022` is not in the drop-down, you have not been added to the allocation yet. Contact the instructor; do not use another allocation instead.

**Off Grounds:** connect to the [UVA VPN](https://in.virginia.edu/vpn) first, for both the web portal and `ssh`.

## Login via SSH

From a terminal on your computer (Mac Terminal, WSL, or Linux), log in to an HPC login node with your computing ID (same pattern as [Lab 01](https://github.com/ksiller/lab-01-cli), Part 2):

```bash
ssh mst3k@login.hpc.virginia.edu
```

Replace `mst3k` with your UVA computing ID. Enter your NetBadge password when prompted (nothing appears as you type; that is normal). The first time you connect, confirm the host key fingerprint with `yes`.

**Off Grounds:** connect to the [UVA VPN](https://in.virginia.edu/vpn) first, or the connection will time out.

To log in without typing your password every time, set up an SSH key (Lab 01, Optional: SSH keys).

Type `exit` to leave the login node and return to your local shell.

Login nodes are shared. Use them for editing files, `git`, `module load`, `uv sync`, and submitting jobs (`sbatch`). Do **not** run long computations there; those belong in interactive Open OnDemand sessions or Slurm batch jobs with `#SBATCH --account=ds2022`. The allocation is not required just to SSH in; it is required when you request compute resources.

## Login via Web Browser

Open OnDemand is a graphical user interface that allows access to HPC via a web browser. The Open OnDemand access point is [ood.hpc.virginia.edu](https://ood.hpc.virginia.edu). Within the Open OnDemand environment users have access to a file explorer; interactive applications like JupyterLab, RStudio Server; a command line interface; and a job composer and job monitor to submit jobs to the Rivanna and Afton clusters. Detailed instructions can be found on the [Open OnDemand documentation page](https://www.rc.virginia.edu/userinfo/hpc/ood/).

### Step 1: Start Open OnDemand

To start the Open OnDemand web client, go to [https://ood.hpc.virginia.edu](https://ood.hpc.virginia.edu). Your login is your UVA computing ID and your password is your NetBadge password.

![Open OnDemand portal](../docs/images/ood.png)

Proceed with one of these options:

[Step 2a: VSCode](#step-2a-vscode)

[Step 2b: JupyterLab](#step-2b-jupyterlab)

[Step 2c: Linux Desktop](#step-2c-linux-desktop)

### Step 2a: VSCode

1. In the menu bar of the Open OnDemand dashboard, click on `Interactive Apps`.
2. In the drop-down box, click on `Code Server` (that's VSCode).

**Select** `ds2022` **in the Allocation field.**

The form should look like this:

![OOD VSCode request](../docs/images/ood-vscode-request.png)

After you click `Launch` it may take a few minutes to start up. This is expected as we are sharing the cluster with hundreds of other users.

When ready, click the `Connect to VSCode` button.

#### Clone your repository

1. Set up a new working directory on the cluster. Open a terminal in VSCode (`Terminal` > `New Terminal`) and create it:

```bash
mkdir -p ~/ds2022-fall26
```

Then run
```bash
cd ~/ds2022-fall26
pwd
```

It should report back `/home/<your_computing_id>/ds2022-fall26`.

2. In VSCode, click `Clone Git Repository` in the Welcome window and follow the instructions. 

![Welcome to VSCode](../docs/images/ood-vscode.png)

Use the URL of **your fork of the lab repository** (for example `https://github.com/<your_gh_username>/lab-08-hpc.git`), and authorize the connection to GitHub. When asked for a destination, choose `/home/YOUR_COMPUTING_ID/ds2022-fall26`.

**If your VSCode welcome screen does not show the `Clone Git Repository` option, clone the lab repository from the command line using these commands:**
```bash
cd ~/ds2022-fal2026
git clone https://github.com/<your_gh_username>/lab-08-hpc.git
```

#### Python Setup

The course uses `uv` for Python projects on HPC, just like on your computer. `uv` is provided as a module on HPC; you do not need to install it.

1. In VSCode, open the top-level folder of your cloned repository (`File` > `Open Folder`), for example `~/ds2022-fall26/lab-08-hpc`.
2. Open a terminal in VSCode. Confirm with `pwd` that you are at the top level of your Git repo.
3. Load `uv` and create the project environment from `pyproject.toml` and `uv.lock`:
  ```bash
   module load uv
   uv sync
  ```
   This creates a `.venv/` folder in the repository that matches the project's exact package versions. It is isolated from other Python installations on the cluster.

**Note: In every new terminal (and in every Slurm job script), add `module load uv` before you use `uv`**

For example:
```bash
module load uv
uv run python <your script>
```



### Step 2b: JupyterLab

Follow the [Open OnDemand JupyterLab](https://www.rc.virginia.edu/userinfo/hpc/software/jupyterlab/) instructions.

**Select** `ds2022` **in the Allocation field.**

The form should look like this:

![JupyterLab request](../docs/images/ood-request.png)

After you click `Launch` it may take a few minutes to start up. This is expected as we are sharing the cluster with hundreds of other users.

![](../docs/images/ood-jlab.png)

- When JupyterLab starts you will see a list of files (if any) in your home directory and a set of tiles for underlying applications (e.g. Python, R, TensorFlow).

- You may see a slightly different set of tiles in your account; the screenshot shows some customized tiles in the instructor's account that you may not have (or need for this course).

### Step 2c: Linux Desktop

Follow the [Open OnDemand Desktop](https://www.rc.virginia.edu/userinfo/hpc/ood/desktop/) instructions.

**Select** `ds2022` **in the Allocation field.**

![OOD Desktop request](../docs/images/ood-request.png)

After you click `Launch` it may take a few minutes to start up. This is expected as we are sharing the cluster with hundreds of other users.

![OOD Desktop](../docs/images/ood-desktop.png)


## MongoDB Atlas from HPC

To reach your MongoDB Atlas cluster from HPC, the Atlas IP access list must allow UVA addresses. See [Update the IP access list](mongodb.md#2-update-the-ip-access-list).