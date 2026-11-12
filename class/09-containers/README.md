# Containers

> [!CAUTION]
> **Do NOT click Reset in the AWS Academy Learner Lab unless your instructor tells you to.**
> Reset permanently deletes everything in your lab account (S3 buckets, EC2 instances, Lambda functions, ...) and cannot be undone. To pause, click **End Lab**: your resources stay and are back with the next **Start Lab**.

A **container image** packages a program together with everything it needs to run: the files of a small Linux system, Python, the packages, and the code. A **container** is one running instance of an image. The same image runs on your laptop with **Docker**, and on the HPC cluster with **Apptainer**.

In class you watched two demos, [Docker](../../demos/12-docker/README.md) and [Apptainer](../../demos/12-apptainer/README.md). Here you retrace them yourself, change the demo image and build new versions of it, and then package a small Python project the way you package the Lab 07 book analysis in **Lab 09**.

**Where you work.**

- **Terminal on your computer** (Parts 1, 3, and 4): Mac Terminal or WSL shell, with **Rancher Desktop** running. All `docker` commands run here.
- **Terminal on HPC** (Part 2): a Code Server session in Open OnDemand, as in [class 08](../08-hpc/README.md).
- **Shell in a container**: after `docker run -it ...` or `apptainer shell ...`, the prompt changes. Type `exit` to return.

## In-class exercises

| Part | Activity |
| ---- | -------- |
| 1 | Docker on your computer: run images, build `my_image`, add a Python script, and build new versions |
| 2 | Apptainer on HPC: run a Docker image as yourself, also in a Slurm job array |
| 3 | Package a Python project: `wordcount`, the model for Lab 09 |
| 4 | Advanced topics: Docker Compose, pushing to `ghcr.io`, multi-platform builds, and more |

How the parts prepare you for Lab 09:

| In Lab 09 you ... | Practiced in |
| --- | --- |
| write a `Dockerfile`: `FROM`, `RUN`, `COPY`, `ENV`, `USER`, `ENTRYPOINT`, `CMD` | Parts 1.3, 1.4, 3 |
| order the instructions so that a code change does not reinstall the packages | Parts 1.5, 3 |
| build in two stages for a Python uv project | Part 3 |
| build, list, and inspect images; tell a tag from an image ID | Parts 1.3, 1.4, 3 |
| run, follow, stop, and remove containers | Parts 1.1, 1.2 |
| give the container AWS and Atlas credentials at run time, not in the image | Parts 1.6, 3 |
| *optional:* push the image to the GitHub Container Registry | Part 4 |

## Part 1: Docker on your computer

### Before you start

You installed **Rancher Desktop** with the **dockerd (moby)** engine in the [setup](../../setup/GENERAL.md). Open Rancher Desktop and wait until it reports that it is running. Then, in the **terminal on your computer**:

```bash
docker info
```

If the output ends with an error such as `Cannot connect to the Docker daemon`, Rancher Desktop is not running yet, or it uses `containerd` instead of `dockerd (moby)` (**Preferences → Container Engine**). No working Docker at all? See [Docker on an EC2 instance](#docker-on-an-ec2-instance) in Part 4.

Create a working directory for this class (`-p` also creates `~/ds2022-fall-2026` if needed):

```bash
mkdir -p ~/ds2022-fall-2026/containers
```

```bash
cd ~/ds2022-fall-2026/containers
```

Download the demo files (`-O` keeps each file's name):

```bash
curl -O https://raw.githubusercontent.com/ksiller/DS2022/main/demos/12-docker/Dockerfile
curl -O https://raw.githubusercontent.com/ksiller/DS2022/main/demos/12-docker/script.sh
curl -O https://raw.githubusercontent.com/ksiller/DS2022/main/demos/12-docker/compose.yaml
```

### 1.1 Run a chat model

Start a small language model with a chat web page, as in the demo:

```bash
docker run -d --name smol-llm2 -p 127.0.0.1:9090:9090 -v llm-cache:/models -e LLAMA_CACHE=/models \
  ghcr.io/ggml-org/llama.cpp:server -hf unsloth/SmolLM2-135M-Instruct-GGUF:Q4_K_M \
  --host 0.0.0.0 --port 9090 -c 2048 --parallel 1
```

| Option | What it does |
| --- | --- |
| `-d` | runs the container in the background (**detached**) and prints its ID |
| `--name smol-llm2` | a name you choose, instead of one Docker makes up |
| `-p 127.0.0.1:9090:9090` | connects port 9090 on your computer (only for your computer, `127.0.0.1`) to port 9090 in the container: `-p HOST_PORT:CONTAINER_PORT` |
| `-v llm-cache:/models` | mounts a **named volume**, storage that Docker keeps after the container is gone, so the model is downloaded only once |
| `-e LLAMA_CACHE=/models` | sets an environment variable in the container: the server saves the model in the volume |
| `ghcr.io/ggml-org/llama.cpp:server` | the image: registry `ghcr.io`, repository `ggml-org`, image name `llama.cpp`, tag `server` |
| everything after the image name | arguments for the program in the container: which model to load, and on which port to listen |

Follow what the container prints until it says `listening on http://0.0.0.0:9090`; `Ctrl+C` stops following, not the container:

```bash
docker logs -f smol-llm2
```

Open <http://localhost:9090> and ask it something, for example `what is the university of virginia`. A 135-million-parameter model gets a lot wrong; the point is that one command gave you a working server. Leave it running; you stop it in [Clean up](#clean-up).

### 1.2 Pull and run images; list, stop, and remove containers

Download the Ubuntu image from Docker Hub, the default registry:

```bash
docker pull ubuntu:latest
```

Start a container from it, with a shell (`-i` keeps input open, `-t` gives you a terminal):

```bash
docker run -it ubuntu:latest /bin/bash
```

The prompt changes to `root@<container-id>:/#`. Look around:

```bash
cat /etc/os-release
```

```bash
whoami
```

```bash
which python3
```

You are `root`, in an Ubuntu system, and `which python3` prints nothing: the image has only what its creator put in, and Ubuntu's base image has no Python. Remember `whoami`: you compare it with Apptainer in Part 2. Leave the container:

```bash
exit
```

The container stopped when its shell ended, but it still exists:

```bash
docker ps
```

```bash
docker ps -a
```

`docker ps` lists running containers only (here `smol-llm2`); `docker ps -a` also lists stopped ones, with the name Docker gave each one. Remove the Ubuntu container by its name or the first characters of its ID:

```bash
docker rm <name-or-id>
```

`--rm` removes a container as soon as it ends, so stopped containers do not pile up:

```bash
docker run --rm ubuntu:latest pwd
```

The container starts in `/`, in its own file system: it does not see your files.

**A web server.** Start `nginx` in the background and connect port 8080 on your computer to port 80 in the container:

```bash
docker run -d --name web -p 8080:80 nginx
```

Open <http://localhost:8080>: "Welcome to nginx!". Then:

```bash
docker logs web
```

`docker logs` shows what the container printed, here one line per page request. Stop the container, and refresh the page: it fails now.

```bash
docker stop web
```

The stopped container still exists, and `docker start web` would start it again. Remove it; the image stays:

```bash
docker rm web
```

```bash
docker images
```

### 1.3 Build your own image: `my_image:1.0.0`

A `Dockerfile` is the recipe for an image. Look at the demo's:

```bash
cat Dockerfile
```

```dockerfile
FROM ubuntu:latest

COPY script.sh script.sh

RUN apt-get update && \
    apt-get install -y \
    awscli \
    curl \
    jq

CMD ["sh", "script.sh"]
```

| Instruction | What it does |
| --- | --- |
| `FROM` | the base image the new image starts from |
| `COPY` | copies a file from your directory (the **build context**) into the image |
| `RUN` | runs a command **during the build**; here it installs three programs with Ubuntu's package manager |
| `CMD` | the command a container runs when it starts, unless you name another one |

`script.sh` only prints a greeting:

```bash
cat script.sh
```

Build the image. `-t name:tag` names it; the `.` at the end is the build context, this directory. Do not leave it out:

```bash
docker build -t my_image:1.0.0 .
```

```bash
docker run --rm my_image:1.0.0
```

It prints `Hello, DS2022`.

### 1.4 Add a Python script, and build version `1.1.0`

You want the image to run a Python script too. First check: does `my_image` have Python?

```bash
docker run --rm my_image:1.0.0 python3 --version
```

It does, although the `Dockerfile` never asks for it: `awscli` is written in Python, so `apt-get` installed `python3` as one of its dependencies. Do not rely on that. If someone removes `awscli` from the list later, your script breaks. **List every program your image uses directly.**

Make three changes, in your editor, in `~/ds2022-fall-2026/containers`:

1. Create a file `hello.py`:

   ```python
   import platform

   print(f"Hello from Python {platform.python_version()} in a container")
   ```

2. Add a line at the end of `script.sh`, so it runs the Python script after the greeting:

   ```bash
   python3 hello.py
   ```

3. In `Dockerfile`, copy `hello.py` into the image, and add `python3` to the packages:

   ```dockerfile
   FROM ubuntu:latest

   COPY script.sh script.sh
   COPY hello.py hello.py

   RUN apt-get update && \
       apt-get install -y \
       awscli \
       curl \
       jq \
       python3

   CMD ["sh", "script.sh"]
   ```

You changed what the image does, so it is a **new version**. Build it under a new tag; `1.0.0` stays as it was:

```bash
docker build -t my_image:1.1.0 .
```

```bash
docker run --rm my_image:1.1.0
```

Run the old version too:

```bash
docker run --rm my_image:1.0.0
```

It still prints only the greeting. List both:

```bash
docker images my_image
```

Two tags, two different image IDs. The **image ID** is a checksum of the image's contents; the **tag** is only a name that points to one image. If you had built again with `-t my_image:1.0.0`, the tag would have moved to the new image, and anyone who uses `1.0.0` would suddenly get different software. So: **a new image gets a new tag.**

### 1.5 Make rebuilds fast: instruction order and the build cache

Change the text in `hello.py`, for example `in a container` to `in my container`. Build again, as version `1.1.1`, and time it:

```bash
time docker build -t my_image:1.1.1 .
```

The `apt-get` step ran again, which takes about half a minute, although you changed only a Python file. Docker **caches** the result of each build step, and reuses it when the instruction and its files are unchanged **and every step before it** came from the cache. `COPY hello.py` copied a changed file, so every instruction after it ran again, including `apt-get`.

Fix the `Dockerfile`: install the packages first, and copy your own files, which change often, last. While you are at it, replace `ubuntu:latest` with a fixed version: `latest` moves to each new Ubuntu release, so the same `Dockerfile` could build a different image next year.

```dockerfile
FROM ubuntu:26.04

RUN apt-get update && \
    apt-get install -y \
    awscli \
    curl \
    jq \
    python3

COPY script.sh script.sh
COPY hello.py hello.py

CMD ["sh", "script.sh"]
```

```bash
time docker build -t my_image:1.1.2 .
```

This build installs the packages once more: the base image and the order changed. Now change `hello.py` once more, and build:

```bash
time docker build -t my_image:1.1.3 .
```

```bash
docker run --rm my_image:1.1.3
```

The `RUN apt-get` step says `CACHED`, and the build takes about a second. Lab 09 asks you to order your `Dockerfile` the same way.

### 1.6 Folders and environment variables

A container sees none of your files, and none of your environment variables. You give it both when it starts. Part 3 and Lab 09 use this to give a container your credentials.

**Folders.** `-v HOST_DIR:CONTAINER_DIR` mounts a directory of your computer into the container. Mount the current directory at `/data`:

```bash
docker run -it --rm -v "$PWD":/data ubuntu:26.04 /bin/bash
```

```bash
ls /data
```

```bash
echo "hello from the container" > /data/hello.txt
```

```bash
exit
```

```bash
cat hello.txt
```

The file is on your computer: it was written to the mounted directory. Everything else the container wrote is gone with it. Containers are **disposable**: keep data in mounted directories, S3, or a database. Add `:ro` (`-v "$PWD":/data:ro`) to mount a directory **read-only**. Remove the file:

```bash
rm hello.txt
```

**Environment variables.** `-e NAME=value` sets a variable in the container:

```bash
docker run --rm -e MYVAR="mst3k-was-here" ubuntu:26.04 env
```

With `-e NAME` and **no value**, Docker copies the value of `NAME` from your terminal. The value then appears neither in the command nor in your shell history, which is how you pass a password:

```bash
export MYVAR="set in my terminal"
```

```bash
docker run --rm -e MYVAR ubuntu:26.04 env
```

## Part 2: Apptainer on HPC

**Why not Docker on HPC?** Docker needs root rights on the machine. On a cluster shared by hundreds of users that would be a security risk. **Apptainer** can pull Docker images, convert them and run them as your own user. You saw this in the [Apptainer demo](../../demos/12-apptainer/README.md); now run it yourself.

### Before you start

Open <https://ood.hpc.virginia.edu> (off Grounds: UVA VPN first), start a **Code Server** session with allocation `ds2022` and partition `interactive`, then **Connect to VSCode** and open a terminal (☰ → Terminal → New Terminal). In that **terminal on HPC**:

```bash
mkdir -p ~/ds2022-fall-2026/containers
```

```bash
cd ~/ds2022-fall-2026/containers
```

Copy the job scripts and `train.py` from the course directory:

```bash
cp /standard/siller/ds2022/*.{slurm,py} .
```

Load Apptainer (once per terminal):

```bash
module load apptainer
```

### 2.1 Pull and run an image

Download the image `godlovedc/lolcow` from Docker Hub, and save it as one file, `lolcow.sif`:

```bash
apptainer pull lolcow.sif docker://godlovedc/lolcow
```

`docker://` means: from a Docker registry. Apptainer converts the image into **one file**, which you can copy, and which every node of the cluster can read. 

> [!TIP]
>If the pull hangs or fails with `toomanyrequests`, Docker Hub has refused more downloads from the cluster for now. Press `Ctrl+C` to abort the apptainer pull command. Copy the course's copy of the same image instead:

```bash
cp /standard/siller/ds2022/lolcow-latest.sif lolcow.sif
```

Run the image's default command, its **runscript** (Docker's `CMD`): a cow says a random quote.

```bash
apptainer run lolcow.sif
```

Run a command you choose (Docker's `docker run IMAGE COMMAND`):

```bash
apptainer exec lolcow.sif cowsay "Hello DS2022"
```

### 2.2 Who are you in the container?

```bash
apptainer exec lolcow.sif whoami
```

It prints **your computing ID**, not `root` as in Docker (Part 1.2). In Apptainer you are yourself, with your own rights, also inside the container: you can do nothing there that you could not do on the cluster anyway. That is why the cluster can offer it.

Apptainer also mounts your home directory and the current directory into the container, so the container sees your files without `-v`:

```bash
apptainer exec lolcow.sif ls
```

Open a shell in the container; the prompt changes to `Apptainer>`:

```bash
apptainer shell lolcow.sif
```

```bash
cat /etc/os-release
```

The container runs Ubuntu; the cluster runs Rocky Linux. This demonstrates the versatility and isolation of containers from the host environment.

To exit the container shell execute:
```bash
exit
```
You're back in the shell on the host.


### 2.3 Run containers in a Slurm job array

Look at the job script:

```bash
cat lolcow.slurm
```

Each of its 5 array tasks loads Apptainer and runs `lolcow.sif` in its own container. Submit it:

```bash
sbatch lolcow.slurm
```

Watch the tasks until none is listed:

```bash
squeue --me
```

Read the output, one file per task:

```bash
cat lolcow_*.out
```

Every task ran the same image, on whichever node Slurm picked.

### 2.4 Optional: run a container on a GPU

Download the PyTorch image (about 4 GB, several minutes), or copy the course's copy:

```bash
apptainer pull pytorch.sif docker://pytorch/pytorch:2.14.1-cuda12.6-cudnn9-runtime
```

```bash
cp /standard/siller/ds2022/pytorch.sif pytorch.sif
```

`pytorch.slurm` runs `train.py` in the container on a GPU slice; `--nv` makes the GPU visible in the container:

```bash
sbatch pytorch.slurm
```

```bash
squeue --me
```

```bash
cat pytorch_*.out
```

It says `device: cuda`: Python, PyTorch, and CUDA came with the image, without any `module load` or `uv sync`.

### 2.5 Clean up on HPC

```bash
rm -f lolcow.sif pytorch.sif
```

Apptainer keeps the downloaded image data in a cache in your home directory. Remove it:

```bash
apptainer cache clean
```

## Part 3: Package a Python project: `wordcount`

This part is the model for Lab 09. [wordcount/](wordcount/) is a small uv project with the same structure as Lab 07: `wordcount.py` counts the words of one Project Gutenberg book, from a local file or from S3, as `analyze.py` does for every book in your bucket.

Back in the **terminal on your computer**, in `~/ds2022-fall-2026/containers`, download the project into a directory `wordcount`:

```bash
mkdir -p ~/ds2022-fall-2026/containers/wordcount
```

Copy the example files to your computer:
```bash
for f in Dockerfile .dockerignore pyproject.toml uv.lock wordcount.py; do curl -o wordcount/$f https://raw.githubusercontent.com/ksiller/DS2022/main/class/09-containers/wordcount/$f; done
```

```text
wordcount/
├── Dockerfile
├── .dockerignore     # files that are never sent to the build
├── pyproject.toml    # the dependency: boto3
├── uv.lock           # the exact package versions
└── wordcount.py
```

### 3.1 A two-stage `Dockerfile`

Open `wordcount/Dockerfile`. It has two **stages**:

```dockerfile
# Stage 1 (builder): install the Python packages from uv.lock into /app/.venv
FROM python:3.13-slim AS builder
COPY --from=ghcr.io/astral-sh/uv:0.12.18 /uv /bin/uv
WORKDIR /app
ENV UV_COMPILE_BYTECODE=1 UV_LINK_MODE=copy
# Copy only the dependency files first: this step runs again only when they change
COPY pyproject.toml uv.lock ./
RUN uv sync --frozen --no-dev --no-install-project

# Stage 2 (final image): Python, the .venv from stage 1, and the script; no uv
FROM python:3.13-slim
LABEL org.opencontainers.image.title="wordcount" \
      org.opencontainers.image.description="Count the words of a Project Gutenberg book (DS2022 class 09)" \
      org.opencontainers.image.source="https://github.com/ksiller/DS2022"
RUN useradd --create-home app
WORKDIR /app
COPY --from=builder /app/.venv /app/.venv
COPY wordcount.py ./
ENV PATH=/app/.venv/bin:${PATH}
USER app
ENTRYPOINT ["python", "/app/wordcount.py"]
CMD ["--help"]
```

| Line | Why |
| --- | --- |
| `FROM python:3.13-slim` | an official, small Debian image with Python, instead of Ubuntu plus `apt-get install python3` |
| `COPY --from=ghcr.io/astral-sh/uv:0.12.18 ...` | copies the `uv` program from the official uv image, in a fixed version |
| `WORKDIR /app` | the directory the next instructions, and the container, work in |
| `COPY pyproject.toml uv.lock ./` before the code | the lesson of Part 1.5: the slow install runs again only when the dependencies change, not when the code does |
| `uv sync --frozen --no-dev --no-install-project` | installs exactly the versions in `uv.lock` into `/app/.venv` (`--frozen`: fail instead of changing the lock file), without development tools and without the project itself |
| second `FROM` | the final image gets only the `.venv` and the script, not `uv` and the build files |
| `LABEL org.opencontainers.image.*` | standard metadata; on `ghcr.io`, `source` links the image to its GitHub repository (Part 4) |
| `useradd` and `USER app` | the program runs as an ordinary user, not as `root` |
| `ENV PATH=/app/.venv/bin:...` | `python` is the one in the `.venv`, with the packages |
| `ENTRYPOINT` and `CMD` | `ENTRYPOINT` is the program; `CMD` holds its **default arguments**, replaced by whatever you type after the image name |

`.dockerignore` keeps `.venv/`, `.env`, `.aws/`, `.git/`, and book files out of the build context, so a `COPY` can never take them in by mistake.

### 3.2 Build and run

Build the image; name it `wordcount`, with the version from `pyproject.toml` as its tag. The last argument is the build context, the directory `wordcount`:

```bash
docker build -t wordcount:0.1.0 wordcount
```

Run it without arguments: the container runs `ENTRYPOINT` with `CMD`, so it prints the help:

```bash
docker run --rm wordcount:0.1.0
```

Arguments after the image name replace `CMD`. Download a book, and count its words; the container reads it from the mounted directory `/data`:

```bash
curl -o pg11.txt https://www.gutenberg.org/cache/epub/11/pg11.txt
```

```bash
docker run --rm -v "$PWD":/data:ro wordcount:0.1.0 /data/pg11.txt --top 3
```

`host` in the output is the **container ID**: every container has its own host name. In Lab 09, this is what `analyze.py` writes into `runs.host`.

The final image has no `uv`: `uv sync` ran in the builder stage, which is not part of the final image. Check who runs the program; `--entrypoint` replaces `ENTRYPOINT` for one run:

```bash
docker run --rm --entrypoint whoami wordcount:0.1.0
```

It prints `app`.

**Watch the cache.** Edit `wordcount/wordcount.py`, for example change the default of `--top` from `5` to `10`. It is a new version, so build it under a new tag:

```bash
docker build -t wordcount:0.1.1 wordcount
```

The steps up to `uv sync` print `CACHED`; only `COPY wordcount.py` and the steps after it run again.

### 3.3 Credentials at run time

`wordcount.py` can read a book from S3, and `analyze.py` in Lab 09 also needs MongoDB Atlas. A container has no credentials for either.

> [!WARNING]
> **Never put credentials into an image.** Do not `COPY` your `~/.aws` directory or a `.env` file, and do not write them into `ENV`, `ARG`, or `LABEL` lines. Anyone who can pull the image can recover every file that an instruction copied into it, even if a later instruction deleted the file, and can read every `ENV`, `ARG`, and `LABEL` value. Give credentials to the **container**, when it starts.

**AWS: mount your credentials directory read-only.** Start the Learner Lab, and copy the credentials from **AWS Details** into `~/.aws/credentials` as in [class 07](../07-ec2/README.md#before-you-start). Mount `~/.aws` into the home directory of the user `app`, read-only. **Replace `public-mst3k`** with your bucket from Lab 06:

```bash
docker run --rm -v ~/.aws:/home/app/.aws:ro wordcount:0.1.1 s3://public-mst3k/pg11.txt --top 3
```

The container reads the book from S3 with your Learner Lab credentials. `ExpiredToken` means your Learner Lab session ended: start it again and copy the new credentials.

**Atlas: pass the environment variables by name**, as in Part 1.6, so the password appears neither in the command nor in your history. `wordcount.py` does not use them; check only that they arrive. `grep -c` counts the lines, so nothing is printed:

```bash
docker run --rm -e MONGODB_ATLAS_URL -e MONGODB_ATLAS_USER -e MONGODB_ATLAS_PWD --entrypoint env wordcount:0.1.1 | grep -c MONGODB_ATLAS
```

The output is `3`. In Lab 09 you combine both in one `docker run`: `-v ~/.aws:/home/app/.aws:ro` and the three `-e` options.

### Clean up

Stop and remove the chat model from Part 1.1:

```bash
docker stop smol-llm2
```

```bash
docker rm smol-llm2
```

Only stopped containers you no longer need should be left:

```bash
docker ps -a
```

Images use a lot of disk space. See how much:

```bash
docker system df
```

Remove the images of this class (add any `my_image` tags you built in addition):

```bash
docker rmi my_image:1.0.0 my_image:1.1.0 my_image:1.1.1 my_image:1.1.2 my_image:1.1.3 wordcount:0.1.0 wordcount:0.1.1
```

```bash
docker rmi ghcr.io/ggml-org/llama.cpp:server nginx ubuntu:latest ubuntu:26.04
```

Remove the volume with the downloaded model:

```bash
docker volume rm llm-cache
```

`docker system prune` removes all stopped containers, unused networks, images without a name, and the build cache in one step; it asks before it deletes anything. Remove the book:

```bash
rm pg11.txt
```

## Part 4: Advanced topics

### Docker Compose

An app often needs several containers, for example a web server and a database. **Docker Compose** starts them together, from one file. Look at the demo's `compose.yaml`:

```bash
cat compose.yaml
```

It describes two services: `web` (nginx, on port 8000 of your computer) and `db` (PostgreSQL 17, with its data in the named volume `db-data`). In `~/ds2022-fall-2026/containers`, start both in the background:

```bash
docker compose up -d
```

```bash
docker compose ps
```

Open <http://localhost:8000>. Stop and remove both containers, and with `-v` also the volume `db-data`:

```bash
docker compose down -v
```

`POSTGRES_PASSWORD: example` is fine for a demo on your computer; a real `compose.yaml` takes passwords from the environment or from a secrets file that is not in git.

### Tag and push to the GitHub Container Registry

An image on your laptop is useful only to you. A **registry** stores images so that other computers can pull them: EC2, the HPC cluster, a teammate. The image name says where it goes:

```text
ghcr.io/<github-user>/wordcount:0.1.1
└──┬──┘ └─────┬─────┘ └───┬───┘ └─┬─┘
registry repository  image name  tag
```

Without a registry part, Docker uses Docker Hub (`docker.io`). Names on `ghcr.io` must be **lowercase**: write your GitHub user name in lowercase.

**Create a token.** `ghcr.io` accepts a **personal access token (classic)** as the password ([GitHub docs](https://docs.github.com/en/packages/working-with-a-github-packages-registry/working-with-the-container-registry#authenticating-with-a-personal-access-token-classic)). On GitHub: profile picture → **Settings** → **Developer settings** → **Personal access tokens** → **Tokens (classic)** → **Generate new token (classic)**; **Note** `ds2022 ghcr`, **Expiration** the end of the semester or sooner, **Scopes** `write:packages`. Copy the token: GitHub shows it only once.

**Log in.** `read -s` reads what you paste without showing it, and it does not go into your shell history. Paste the token and press Enter:

```bash
read -s CR_PAT
```

```bash
echo "$CR_PAT" | docker login ghcr.io -u <github-user> --password-stdin
```

The output ends with `Login Succeeded`. A token is a password: never paste it into a file in a repository, a chat, or an AI assistant.

**Tag and push.** `docker tag` gives the image a second name; nothing is copied:

```bash
docker tag wordcount:0.1.1 ghcr.io/<github-user>/wordcount:0.1.1
```

```bash
docker push ghcr.io/<github-user>/wordcount:0.1.1
```

The output ends with the image's **digest**, `sha256:...`. A tag can later be moved to another image; the digest always names exactly this one.

**Find it on GitHub.** Open `https://github.com/<github-user>?tab=packages`. The package `wordcount` is **private**, the default for new packages. Keep it private: a package that was made public cannot be made private again ([GitHub docs: Configuring visibility](https://docs.github.com/en/packages/learn-github-packages/configuring-a-packages-access-control-and-visibility#configuring-visibility-of-packages-for-your-personal-account)).

**Versions.** For a new version, change the code, raise `version` in `pyproject.toml`, and build and push with the new tag. Never push a different image under a tag you already pushed: whoever pulled `0.1.1` expects the same image every time.

### Multi-platform builds

Check which CPU type your image is for:

```bash
docker image inspect wordcount:0.1.1 --format '{{.Architecture}}'
```

On a Mac with an Apple chip, the answer is `arm64`. EC2 instances like those of Lab 07 and the HPC cluster are `amd64`, and an `arm64` image fails there with `exec format error`. Build one image for both platforms, under one name ([Docker docs: Multi-platform builds](https://docs.docker.com/build/building/multi-platform/)), and push it:

```bash
docker build --platform linux/amd64,linux/arm64 -t ghcr.io/<github-user>/wordcount:0.1.2 wordcount
```

```bash
docker push ghcr.io/<github-user>/wordcount:0.1.2
```

Every computer that pulls it gets the variant it can run.

### Run your own image on HPC

On HPC, pull the multi-platform image from the previous section. It is private, so Apptainer needs your GitHub login: `--docker-login` asks for your user name and the token (paste it; it is not shown):

```bash
module load apptainer
```

```bash
apptainer pull --docker-login wordcount.sif docker://ghcr.io/<github-user>/wordcount:0.1.2
```

```bash
curl -o pg11.txt https://www.gutenberg.org/cache/epub/11/pg11.txt
```

```bash
apptainer run wordcount.sif pg11.txt --top 3
```

The book is found without `-v`, because Apptainer mounts the current directory. In a Slurm job script, `apptainer run wordcount.sif ...` is a command like any other.

### Alpine images

`alpine` is a 6 MB base image. It uses `apk` instead of `apt-get`, and `sh` instead of `bash`:

```bash
docker run -it --rm alpine /bin/sh
```

```bash
apk add jq
```

```bash
echo '{"book": "pg11.txt"}' | jq .book
```

```bash
exit
```

For Python projects, `python:3.13-slim` (Debian) is usually the better choice: most Python packages ship ready-built for Debian, but many must be compiled for Alpine.

### Pin the base image by digest

`ubuntu:26.04` and `python:3.13-slim` are tags: the image behind them changes with every security update or Python patch release. For a build that gives the same result next year, pin the base image by its digest, `FROM python:3.13-slim@sha256:...`. `docker buildx imagetools inspect python:3.13-slim` shows the digest; tools such as Dependabot then propose updates.

### Docker on an EC2 instance

No working Docker on your computer? Build and run on an EC2 instance instead. As in [class 07](../07-ec2/README.md), a **user data** script sets up the instance at its first boot: [user_data_docker.sh](user_data_docker.sh) installs Docker Engine from Docker's apt repository, following [Docker's install guide for Ubuntu](https://docs.docker.com/engine/install/ubuntu/). Start the Learner Lab and update `~/.aws/credentials`. Then, in the **terminal on your computer**, in a clone of the course repository (or after downloading the two files):

```bash
bash launch-ec2-docker.sh
```

[launch-ec2-docker.sh](launch-ec2-docker.sh) runs `aws ec2 run-instances` as in class 07, with the role `LabRole` (`LabInstanceProfile`), a metadata hop limit of 2 so that containers get the role's credentials, and a 20 GB disk. Connect with the `ssh` command it prints, wait for the install with `cloud-init status --wait`, and check with `docker version`. Then follow Parts 1 and 3 in the **shell on the instance**, with these differences:

- `localhost:8080` is on the instance, not on your computer: test web servers with `curl -s localhost:8080 | head -n 5`.
- Leave out `-v ~/.aws:/home/app/.aws:ro`: a container on the instance gets the credentials of `LabRole` by itself. The `MONGODB_ATLAS_*` variables are not set on the instance.
- The instance is `amd64`, the CPU type of EC2 and HPC.
- `docker login` stores the token **unencrypted** in `~/.docker/config.json` on the instance: run `docker logout ghcr.io` when you are done.

Terminate the instance with the command the launch script printed. Terminating is permanent: the instance, its images, and its disk are deleted.

## Troubleshooting

| Error | Cause and fix |
| --- | --- |
| `Cannot connect to the Docker daemon` | Rancher Desktop is not running, or it uses `containerd`. Start it; **Preferences → Container Engine → dockerd (moby)**. |
| `Bind for 0.0.0.0:8080 failed: port is already allocated` | Another container or program uses the port. `docker ps`, then stop it, or use another port: `-p 8081:80`. |
| `Conflict. The container name "/web" is already in use` | A stopped container has that name. `docker rm web`. |
| `conflict: unable to remove repository reference ... container ... is using its referenced image` | A container, also a stopped one, uses the image. `docker ps -a`, `docker rm` it, then `docker rmi`. |
| `'docker buildx build' requires 1 argument` | The build context is missing: add `.` at the end of `docker build -t my_image:1.1.0 .`. |
| `python3: can't open file '//hello.py'` | `hello.py` is not in the image: add `COPY hello.py hello.py` to the `Dockerfile`, and build again. |
| `apptainer: command not found` | Run `module load apptainer` first. |
| `toomanyrequests` or a hanging `apptainer pull` | Docker Hub refuses more downloads from the cluster for now. Copy the course's copy from `/standard/siller/ds2022/` (Part 2.1). |
| `No such file or directory` for `/data/pg11.txt` | The directory is not mounted, or the book is in another directory. Run from the directory with the book, with `-v "$PWD":/data:ro`. |
| `NoCredentialsError` or `ExpiredToken` | No AWS credentials in the container, or the Learner Lab session ended. Mount `-v ~/.aws:/home/app/.aws:ro`; copy fresh credentials from **AWS Details**. |
| `denied` or `unauthorized` on `docker push` | Not logged in to `ghcr.io`, the token lacks `write:packages`, or the repository is not your user name. Log in again. |
| `invalid reference format: repository name must be lowercase` | Write the image name in lowercase, also your GitHub user name. |
| `exec format error` on EC2 or HPC | The image was built for `arm64` only. Build with `--platform linux/amd64,linux/arm64` and push again. |

## Resources

- The class demos: [Docker](../../demos/12-docker/README.md) and [Apptainer](../../demos/12-apptainer/README.md)
- [How To - Docker Walkthroughs](https://www.youtube.com/watch?v=HMxDaM3-c1U) (video, Neal Magee, UVA, 8 min)
- [UVA container basics: advanced commands](https://uvads.github.io/container-basics/docs/advanced-commands/): another walk through building and versioning an image
- [Docker: Get started](https://docs.docker.com/get-started/)
- [Docker CLI reference](https://docs.docker.com/reference/cli/docker/) and [Dockerfile reference](https://docs.docker.com/reference/dockerfile/)
- [Docker: Building best practices](https://docs.docker.com/build/building/best-practices/), [the build cache](https://docs.docker.com/build/cache/), [multi-stage builds](https://docs.docker.com/build/building/multi-stage/), and [multi-platform builds](https://docs.docker.com/build/building/multi-platform/)
- [Docker Compose](https://docs.docker.com/compose/)
- [uv: Using uv in Docker](https://docs.astral.sh/uv/guides/integration/docker/)
- [GitHub: Working with the Container registry](https://docs.github.com/en/packages/working-with-a-github-packages-registry/working-with-the-container-registry)
- [OCI image annotations](https://github.com/opencontainers/image-spec/blob/main/annotations.md): the `org.opencontainers.image.*` labels
- [Rancher Desktop documentation](https://docs.rancherdesktop.io/)
- [Apptainer user guide](https://apptainer.org/docs/user/main/)
- [ds2002-course: Containers practice](https://github.com/ksiller/ds2002-course/tree/main/practice/11-containers): more examples (`whalesay`, `convert`, FastAPI)
