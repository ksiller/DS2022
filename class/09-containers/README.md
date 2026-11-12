# Containers

A **container image** packages a program together with everything it needs to run: the files of a small Linux system, Python, the packages, and the code. A **container** is one running instance of an image. The same image runs on your laptop with **Docker**, and on the HPC cluster with **Apptainer**.

In class you watched the demos, [Apptainer](../../demos/12-apptainer/README.md) and [Docker](../../demos/12-docker/README.md). Here you retrace them yourself, in the same order: first Apptainer on the HPC cluster, then Docker on your computer, where you change the demo image and build a new version of it. In **Lab 09** you then package the Lab 07 book analysis as an image of your own.

## Learning objectives

- Explain images and containers, and why HPC uses Apptainer instead of Docker
- Manage the container life cycle: `docker run`, `docker ps`, `docker stop`, `docker rm`
- Manage the image life cycle: `docker build`, `docker images`, `docker tag`, `docker push`, `docker pull`, `docker inspect`, `docker rmi`
- Understand the purpose and general structure of a `Dockerfile` as the build instructions for a Docker image
- Pass arguments, ports, and directories to a container
- Run a Docker image with Apptainer in a Slurm job array

**Where you work.**

- **Terminal on HPC** (Part 1, and two of the optional topics in Part 3): a Code Server session in Open OnDemand, as in [class 08](../08-hpc/README.md).
- **Terminal on your computer** (Parts 2 and 3): Mac Terminal or WSL shell, with **Rancher Desktop** (or Docker Desktop) running. All `docker` commands run here.
- **Shell in a container**: after `docker run -it ...`, the prompt changes. Type `exit` to return.

## In-class exercises

| Part | Activity |
| ---- | -------- |
| 1 | Apptainer on HPC: run a Docker image in a Slurm job array |
| 2 | Docker on your computer: run images, build `my_image`, add a Python script, build a new version, pass it arguments, and mount a directory into a container |
| 3 | Optional advanced topics: a chat model, Docker Compose, pushing to `ghcr.io`, multi-platform builds, a GPU container on HPC, and more |

How the parts prepare you for Lab 09:

| In Lab 09 you ... | Practiced in |
| --- | --- |
| write a `Dockerfile` with one `FROM` line: `FROM`, `RUN`, `COPY`, `WORKDIR`, `ENTRYPOINT`, `CMD` | Parts 2.2, 2.3 |
| give each new image a new tag (version name) | Part 2.3 |
| pass arguments after the image name, and mount a directory with `-v` | Parts 2.3, 2.4 |
| run containers, and stop and remove them | Part 2.1 |
| *optional:* push the image to the GitHub Container Registry | Part 3 |

New in Lab 09: installing a Python uv project in an image, the build cache, running the program as an ordinary user, and giving the container your AWS and Atlas credentials at run time.

## Part 1: Apptainer on HPC

**Why not Docker on HPC?** Docker, which you use in Part 2, needs root rights on the machine. On a cluster shared by hundreds of users that would be a security risk. **Apptainer** pulls Docker images, converts them into its own image files (`.sif`), and runs them as your own user: as the [Apptainer demo](../../demos/12-apptainer/README.md) showed, `whoami` in an Apptainer container prints your computing ID. Here you run a container in every task of a Slurm job array.

### Before you start

Open <https://ood.hpc.virginia.edu> (off Grounds: UVA VPN first), start a **Code Server** session with allocation `ds2022` and partition `interactive`, then **Connect to VSCode** and open a terminal (☰ → Terminal → New Terminal). In that **terminal on HPC**:

```bash
mkdir -p ~/ds2022-fall-2026/containers
```

```bash
cd ~/ds2022-fall-2026/containers
```

Copy the job scripts `lolcow.slurm` and `pytorch.slurm`, and `train.py` for the optional GPU example in Part 3, from the course directory into the current directory:

```bash
cp /standard/siller/ds2022/*.{slurm,py} .
```

### 1.1 Run containers in a Slurm job array

Look at the job script:

```bash
cat lolcow.slurm
```

`--array=1-5` creates 5 tasks. Each task loads the Apptainer module and runs `apptainer run` on the image `lolcow.sif`, in its own container, on whichever node Slurm assigns: a cow says a random quote. The script uses `lolcow.sif` from the current directory if it is there, and otherwise the course's copy of the image, `/standard/siller/ds2022/lolcow-latest.sif`, which Apptainer pulled from Docker Hub (`docker://godlovedc/lolcow`). Submit the job with `sbatch`:

```bash
sbatch lolcow.slurm
```

> [!TIP]
> You do not have to wait for the job. If its tasks wait in the queue (state `PD` in `squeue --me`), move on to Part 2 on your computer, and come back to the terminal on HPC from time to time to check on the job.

`squeue --me` lists your tasks that are still waiting (`PD`) or running (`R`). Run it again until none is listed:

```bash
squeue --me
```

Each task writes its output into its own file, `lolcow_<job ID>_<task ID>.out` (the `-o` option in the job script). Print all of them:

```bash
cat lolcow_*.out
```

Every task ran the same image, on whichever node Slurm picked, and printed its own quote.

## Part 2: Docker on your computer

**How Docker works.** The `docker` command you type is a client: it sends each request to the **Docker engine**, a background service that Rancher Desktop runs for you. The engine downloads images, builds new ones, and starts and stops containers. An **image** is a template: the files and settings a program needs. A **container** is one running copy of an image, with its own file system, processes, and network. You can start many containers from one image, and removing a container leaves the image untouched.

### Before you start

You installed **Rancher Desktop** with the **dockerd (moby)** engine in the [setup](../../setup/GENERAL.md). Open Rancher Desktop (or Docker Desktop) and wait until it reports that it is running. Then, in the **terminal on your computer**:

`docker info` asks the engine for a summary of itself: how many containers and images it has, and where it keeps them. It is a quick way to check that the client can reach the engine:

```bash
docker info
```

If the output ends with an error such as `Cannot connect to the Docker daemon`, Rancher Desktop is not running yet, or it uses `containerd` instead of `dockerd (moby)` (**Preferences → Container Engine**). No working Docker at all? See [Docker on an EC2 instance](#docker-on-an-ec2-instance) in Part 3.

Create a working directory for this class (`-p` also creates `~/ds2022-fall-2026` if needed):

```bash
mkdir -p ~/ds2022-fall-2026/containers
```

```bash
cd ~/ds2022-fall-2026/containers
```

Download the three demo files, `Dockerfile`, `script.sh`, and `compose.yaml`, into this directory (`-O` saves each file under its own name):

```bash
curl -O https://raw.githubusercontent.com/ksiller/DS2022/main/demos/12-docker/Dockerfile
curl -O https://raw.githubusercontent.com/ksiller/DS2022/main/demos/12-docker/script.sh
curl -O https://raw.githubusercontent.com/ksiller/DS2022/main/demos/12-docker/compose.yaml
```

### 2.1 Pull and run images; stop and remove containers

`docker pull` downloads an image from a registry without starting it. `docker run` would do this by itself, but pulling first lets you get large images ready in advance. Download the Ubuntu image from Docker Hub, the default registry:

```bash
docker pull ubuntu:latest
```

Start a container from it, and work inside it with a shell. `-i` keeps the input open and `-t` gives you a terminal, so you can type commands in the container; `--rm` removes the container when you leave it, so no stopped container is left behind:

```bash
docker run -it --rm ubuntu:latest /bin/bash
```

The prompt changes to `root@<container-id>:/#`: you are now in a shell inside the container, in Ubuntu, whatever system your computer runs; a container brings its own operating system files. Check your user name, and whether Python is installed:

```bash
whoami
```

```bash
which python3
```

You are `root`, in an Ubuntu system, and `which python3` prints nothing: the image has only what its creator put in, and Ubuntu's base image has no Python. In an Apptainer container, `whoami` prints your computing ID (Part 1); in a Docker container you are `root` by default. That is why the HPC cluster offers Apptainer, not Docker. `exit` ends the shell, which ends the container; `--rm` then removes it:

```bash
exit
```

**A web server.** Most containers in practice run services, such as web servers or databases, that keep running in the background. Start the web server `nginx`. `docker run` downloads the image if it is not on your computer yet, creates a container from it, and starts the program in it:

```bash
docker run -d --name web -p 8080:80 nginx
```

| Option | What it does | Why it is useful |
| --- | --- | --- |
| `-d` | runs the container in the background (**detached**) and prints its ID | a server runs until you stop it; without `-d`, it would occupy your terminal the whole time |
| `--name web` | gives the container a name you choose | later commands (`docker logs`, `docker stop`, `docker rm`) can use this name, instead of the long ID or a random name that Docker makes up |
| `-p 8080:80` | connects port 8080 on your computer to port 80 in the container, where `nginx` listens: `-p HOST_PORT:CONTAINER_PORT` | a container has its own network, so your browser cannot reach the server without it |

Open <http://localhost:8080>: "Welcome to nginx!". `docker ps` lists the running containers, so you can see what is running, from which image, and on which ports:

```bash
docker ps
```

The output looks like this (your IDs and times differ):

```text
CONTAINER ID   IMAGE     COMMAND                  CREATED          STATUS         PORTS                  NAMES
98aabf5641f6   nginx     "/docker-entrypoint.…"   10 seconds ago   Up 9 seconds   0.0.0.0:8080->80/tcp   web
```

| Column | Meaning |
| --- | --- |
| `CONTAINER ID` | the start of the container's unique ID; the first few characters are enough in commands, for example `docker stop 98aa` |
| `IMAGE` | the image the container was started from |
| `COMMAND` | the program running in the container, shortened |
| `CREATED` | when the container was created |
| `STATUS` | its state: `Up ...` while it runs, `Exited (code) ...` after it ended |
| `PORTS` | which port on your computer is connected to which port in the container (`HOST->CONTAINER`) |
| `NAMES` | the container's name, from `--name`, or a random one that Docker chose |

A detached container does not print to your terminal; Docker keeps its output, and `docker logs` shows it. When a containerized service misbehaves, its logs are the first place to look. See what `web` printed, here one line per page request:

```bash
docker logs web
```

`docker stop` ends the program in the container, as you would shut down a server. Stop `web`, and refresh the page: it fails now.

```bash
docker stop web
```

```bash
docker ps
```

`web` is no longer listed: `docker ps` shows only running containers. The stopped container still exists, and `docker start web` would start it again. `-a` lists all containers, also stopped ones:

```bash
docker ps -a
```

```text
CONTAINER ID   IMAGE     COMMAND                  CREATED         STATUS                     PORTS     NAMES
98aabf5641f6   nginx     "/docker-entrypoint.…"   2 minutes ago   Exited (0) 5 seconds ago             web
```

`web` has the status `Exited (0)`: its program ended, with exit code `0`, and it no longer has ports. A stopped container still takes disk space and keeps its name. `docker rm` deletes the container and everything it wrote inside itself; the image stays, so you can start new containers from it at any time:

```bash
docker rm web
```

Images are what you keep; containers come and go. `docker image ls`, or its short form `docker images`, lists the images on your computer, with their tags, IDs, and sizes: `ubuntu` and `nginx`:

```bash
docker images
```

With a recent version of Docker, the output looks like this:

```text
IMAGE           ID             DISK USAGE   CONTENT SIZE   EXTRA
nginx:latest    165ddde8751e        261MB         65.1MB
ubuntu:latest   6a06111c3b0a        181MB         44.9MB
```

| Column | Meaning |
| --- | --- |
| `IMAGE` | the image's name and tag (`name:tag`) |
| `ID` | the start of the image's ID, a checksum of its contents; two names with the same ID are the same image |
| `DISK USAGE` | the space the image takes on your computer, unpacked |
| `CONTENT SIZE` | the size of the image's compressed contents, about what a download from a registry transfers |
| `EXTRA` | `U` (in use) when a container, running or stopped, exists that was created from this image; empty here, because you removed `web` |

Older versions of Docker show the columns `REPOSITORY` (the name), `TAG`, `IMAGE ID`, `CREATED`, and `SIZE` instead.

### 2.2 Build your own image: `my_image:1.0.0`

So far you ran images that others built. To package your own program, you write a `Dockerfile`: the build instructions for an image, one instruction per line, run from top to bottom. Look at the demo's:

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
| `FROM` | the **base image** the new image starts from: an existing image whose files your instructions add to. It can be a plain operating system, such as `ubuntu:26.04`, or an operating system with software already installed, such as `python:3.13-slim` (a small Debian Linux with Python) or `nginx` (Linux with a web server). Pick the base image that already has most of what your program needs |
| `COPY` | copies a file from the **build context** (the directory you build in) into the image: `COPY SOURCE DESTINATION` |
| `RUN` | runs a command **during the build**, and saves its result in the image; here, `apt-get update` refreshes Ubuntu's package lists, and `apt-get install -y` installs three programs (`-y` answers yes to its questions) |
| `CMD` | the command a container runs when it starts, unless you give another command after the image name in `docker run` |

`script.sh` only prints a greeting:

```bash
cat script.sh
```

`docker build` reads the `Dockerfile`, runs its instructions one by one, and saves the result as a new image. `-t name:tag` names the image, so you can run it by name; without `-t`, the image has only its ID. The `.` at the end is the **build context**, the directory whose files `COPY` can use; here, the current directory. Do not leave it out:

```bash
docker build -t my_image:1.0.0 .
```

Start a container from your image. It runs `CMD`, prints its greeting, and ends; `--rm` removes the container right away:

```bash
docker run --rm my_image:1.0.0
```

It prints `Hello, DS2022`.

### 2.3 Version `2.0.0`: Python, arguments, and a working directory

Change `my_image` so that it also runs a Python script, and greets the name you give after the image name in `docker run`. Make three changes, in your editor, in `~/ds2022-fall-2026/containers`:

1. Create a file `hello.py`:

   ```python
   import platform

   print(f"Hello from Python {platform.python_version()} in a container")
   ```

2. Replace the contents of `script.sh`. It greets the first argument (`$1`), and runs `hello.py` with `python3`, by its full path in the image:

   ```bash
   #!/bin/bash

   echo "Hello, $1"
   python3 /app/hello.py
   ```

3. Replace the build instructions in `Dockerfile`:

   ```dockerfile
   FROM ubuntu:26.04

   RUN apt-get update && \
       apt-get install -y \
       awscli \
       curl \
       jq \
       python3

   WORKDIR /app
   COPY script.sh ./
   COPY hello.py ./

   ENTRYPOINT ["sh", "/app/script.sh"]
   CMD ["DS2022"]
   ```

| Change | Why |
| --- | --- |
| `FROM ubuntu:26.04` instead of `ubuntu:latest` | `latest` moves to each new Ubuntu release, so the same `Dockerfile` could build a different image next year; a fixed version does not |
| `python3` in the `RUN apt-get install` instruction | `hello.py` needs Python. `awscli` happens to install `python3` too, but list every program your image uses directly: if someone removes `awscli` later, your script still works |
| `RUN` before the `COPY` instructions | when you change only your files, Docker can reuse the slow install step from its build cache; Lab 09 explains how |
| `WORKDIR /app` | creates the directory `/app` in the image, and makes it the current directory for the next instructions and for the container; `./` in `COPY` now means `/app/` |
| `ENTRYPOINT` | the command the container always runs when it starts; arguments after the image name are added to it |
| `CMD` | the **default arguments** for `ENTRYPOINT`; whatever you type after the image name replaces them |

You changed what the image does, so it is a **new version**. Build it under a new tag; `1.0.0` stays as it was:

```bash
docker build -t my_image:2.0.0 .
```

Run it without arguments: the container runs `ENTRYPOINT` with the default argument from `CMD`:

```bash
docker run --rm my_image:2.0.0
```

It prints `Hello, DS2022` and the Python version. Now give it your own argument, after the image name:

```bash
docker run --rm my_image:2.0.0 Alice
```

It prints `Hello, Alice`: `Alice` replaced `CMD`. Both settings are stored in the image. `docker inspect` shows the settings of an image, or of a container; `--format` picks two of them:

```bash
docker inspect my_image:2.0.0 --format '{{.Config.Entrypoint}} {{.Config.Cmd}}'
```

It prints `[sh /app/script.sh] [DS2022]`. Run the old version too:

```bash
docker run --rm my_image:1.0.0
```

It still prints only `Hello, DS2022`: building `2.0.0` did not change `1.0.0`. List both; `docker images my_image` shows only the images named `my_image`:

```bash
docker images my_image
```

Two tags, two different image IDs. The **image ID** is a checksum of the image's contents; the **tag** is only a name that points to one image. If you had built again with `-t my_image:1.0.0`, the tag would have moved to the new image, and anyone who uses `1.0.0` would suddenly get different software. So: **once you share an image, a new image gets a new tag.**

### 2.4 Folders

A container sees none of the files on your computer. `-v HOST_DIRECTORY:CONTAINER_DIRECTORY` **mounts** a directory of your computer into the container. Mount the current directory as `/data`, and write a file into it from the container. `sh -c '...'` runs the quoted command line inside the container, so that `>` writes the file there, into `/data`:

```bash
docker run --rm -v "$PWD":/data ubuntu:26.04 sh -c 'echo "hello from a container" > /data/hello.txt'
```

```bash
cat hello.txt
```

The file is on your computer: the container wrote it into the mounted directory. Everything else a container writes is gone when the container is removed, so keep data in a mounted directory, in S3, or in a database. With `:ro` at the end, the mount is **read-only**, and the container cannot change your files:

```bash
docker run --rm -v "$PWD":/data:ro ubuntu:26.04 sh -c 'echo "hello again" > /data/hello.txt'
```

It fails with `Read-only file system`. Remove the file:

```bash
rm hello.txt
```

Lab 09 uses `ENTRYPOINT`, `CMD`, and a read-only mount for your book analysis.

### 2.5 Clean up

This is the end of the class exercises. If you go on to the optional Part 3, skip this step for now, and come back to it when you are done: Part 3 uses `my_image:2.0.0`.

Check that no container of this class is left, running or stopped:

```bash
docker ps -a
```

Images use a lot of disk space, and they stay until you remove them. `docker system df` shows how much space images, containers, and volumes take:

```bash
docker system df
```

`docker rmi` removes images. Remove the images of this class:

```bash
docker rmi my_image:1.0.0 my_image:2.0.0
```

```bash
docker rmi nginx ubuntu:latest ubuntu:26.04
```

If you worked through Part 3, also remove its images:

```bash
docker rmi ghcr.io/<github-user>/my_image:2.0.0 ghcr.io/<github-user>/my_image:2.0.1 alpine
```

`docker system prune` removes all stopped containers, unused networks, images without a name, and the build cache in one step; it asks before it deletes anything.

## Part 3: Advanced topics (optional)

### Run a chat model

A container can run a complete application, with all its software inside. Start a small language model with a chat web page, as in the demo. The image is large (about 300 MB to download), and the server then downloads the model (about 100 MB):

```bash
docker run -d --name smol-llm2 -p 127.0.0.1:9090:9090 -v llm-cache:/models -e LLAMA_CACHE=/models \
  ghcr.io/ggml-org/llama.cpp:server -hf unsloth/SmolLM2-135M-Instruct-GGUF:Q4_K_M \
  --host 0.0.0.0 --port 9090 -c 2048 --parallel 1
```

`-d` and `--name` work as for `web` in Part 2.1. The other options:

| Option | What it does | Why it is useful |
| --- | --- | --- |
| `-p 127.0.0.1:9090:9090` | connects port 9090 on your computer to port 9090 in the container | `127.0.0.1` allows connections only from your own computer, not from others on your network |
| `-v llm-cache:/models` | mounts a **named volume**: storage that Docker manages, and keeps after the container is removed | the model is downloaded once; the next container that mounts `llm-cache` finds it there |
| `-e LLAMA_CACHE=/models` | sets an environment variable in the container | configures the program without changing the image: here, it tells the server to save the model in the volume |
| `ghcr.io/ggml-org/llama.cpp:server` | the image: registry `ghcr.io`, repository `ggml-org`, image name `llama.cpp`, tag `server` | |
| everything after the image name | arguments for the program in the container | which model to load, and on which port to listen |

`-f` (follow) makes `docker logs` keep showing new lines. Watch the server download the model and start, until it says `listening on http://0.0.0.0:9090`; `Ctrl+C` stops following, not the container:

```bash
docker logs -f smol-llm2
```

Open <http://localhost:9090> and ask it something, for example `explain Docker containers in the style of Shakespeare`. A 135-million-parameter model gets a lot wrong; the point is that one command gave you a working server. When you are done, stop and remove the container, its image, and the volume with the model:

```bash
docker stop smol-llm2
```

```bash
docker rm smol-llm2
```

```bash
docker rmi ghcr.io/ggml-org/llama.cpp:server
```

```bash
docker volume rm llm-cache
```

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
ghcr.io/<github-user>/my_image:2.0.0
└──┬──┘ └─────┬─────┘ └──┬───┘ └─┬─┘
registry repository image name  tag
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
docker tag my_image:2.0.0 ghcr.io/<github-user>/my_image:2.0.0
```

```bash
docker push ghcr.io/<github-user>/my_image:2.0.0
```

The package `my_image` appears at `https://github.com/<github-user>?tab=packages`, **private**, the default for new packages. Keep it private: a package that was made public cannot be made private again. Lab 09, Step 5 does the same with your own image, and explains each step.

### Multi-platform builds

`.Architecture` in the output of `docker inspect` is the CPU type the image was built for:

```bash
docker inspect my_image:2.0.0 --format '{{.Architecture}}'
```

On a Mac with an Apple chip, the answer is `arm64`. EC2 instances like those of Lab 07 and the HPC cluster are `amd64`, and an `arm64` image fails there with `exec format error`. Build one image for both platforms, under one name and a new tag, since it is a new image ([Docker docs: Multi-platform builds](https://docs.docker.com/build/building/multi-platform/)), and push it:

```bash
docker build --platform linux/amd64,linux/arm64 -t ghcr.io/<github-user>/my_image:2.0.1 .
```

```bash
docker push ghcr.io/<github-user>/my_image:2.0.1
```

The build for the other CPU type runs in an emulator and takes a few minutes. Every computer that pulls the image gets the variant it can run.

### Run your own image on HPC

On HPC, pull the multi-platform image from the previous section. It is private, so Apptainer needs your GitHub login: `--docker-login` asks for your user name and the token (paste it; it is not shown):

```bash
module load apptainer
```

```bash
apptainer pull --docker-login my_image.sif docker://ghcr.io/<github-user>/my_image:2.0.1
```

```bash
apptainer run my_image.sif Alice
```

`apptainer run` runs the image's `ENTRYPOINT` with your argument, and prints the greeting and the Python version, as on your computer. `script.sh` calls `/app/hello.py` by its full path, because Apptainer starts the container in your current directory on HPC, not in the image's `WORKDIR`. In a Slurm job script, `apptainer run my_image.sif ...` is a command like any other.

### Run a container on a GPU with Apptainer

Work on HPC, in `~/ds2022-fall-2026/containers` from Part 1, after `module load apptainer`. Download the PyTorch image (about 4 GB, several minutes), or copy the course's copy:

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

Read the job's output file:

```bash
cat pytorch_*.out
```

It says `device: cuda`: Python, PyTorch, and CUDA came with the image, without any `module load` or `uv sync`.

Remove the image file and Apptainer's cache when you are done:

```bash
rm -f pytorch.sif
```

```bash
apptainer cache clean
```

### Alpine images

`alpine` is a 6 MB base image. It uses `apk` instead of `apt-get`, and `sh` instead of `bash`:

```bash
docker run -it --rm alpine /bin/sh
```

```bash
apk add jq
```

```bash
echo '{"course": "DS2022"}' | jq .course
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

[launch-ec2-docker.sh](launch-ec2-docker.sh) runs `aws ec2 run-instances` as in class 07, with the role `LabRole` (`LabInstanceProfile`), a metadata hop limit of 2 so that containers get the role's credentials, and a 20 GB disk. Connect with the `ssh` command it prints, wait for the install with `cloud-init status --wait`, and check with `docker info`. Then follow Part 2 in the **shell on the instance**, with these differences:

- `localhost:8080` is on the instance, not on your computer: test web servers with `curl -s localhost:8080 | head -n 5`.
- The instance is `amd64`, the CPU type of EC2 and HPC.
- `docker login` stores the token **unencrypted** in `~/.docker/config.json` on the instance: run `docker logout ghcr.io` when you are done.

Terminate the instance with the command the launch script printed. Terminating is permanent: the instance, its images, and its disk are deleted.

### Clean up after Part 3

Go back to [2.5 Clean up](#25-clean-up), and remove the Part 3 images there too.

## Troubleshooting

| Error | Cause and fix |
| --- | --- |
| `Cannot connect to the Docker daemon` | Rancher Desktop is not running, or it uses `containerd`. Start it; **Preferences → Container Engine → dockerd (moby)**. |
| `Bind for 0.0.0.0:8080 failed: port is already allocated` | Another container or program uses port 8080 on your computer. `docker ps` shows which container: stop it with `docker stop`, or use another port: `-p 8081:80`. |
| `Conflict. The container name "/web" is already in use` | A stopped container has that name. Remove it with `docker rm web`, then run `docker run` again. |
| `conflict: unable to remove repository reference ... container ... is using its referenced image` | A container, also a stopped one, was created from the image. Find it with `docker ps -a`, remove it with `docker rm`, then run `docker rmi` again. |
| `'docker buildx build' requires 1 argument` | The build context is missing: add `.` at the end of `docker build -t my_image:2.0.0 .`. |
| `python3: can't open file '//hello.py'` or `'/app/hello.py'` | `hello.py` is not in the image, or not where `script.sh` looks for it: check the `COPY` instructions in `Dockerfile` (Part 2.3), and run `docker build` again. |
| `apptainer: command not found` | Run `module load apptainer` first. |
| `toomanyrequests` or a hanging `apptainer pull` | Docker Hub refuses more downloads from the cluster for now. Copy the course's copy from `/standard/siller/ds2022/` instead. |
| `Read-only file system` | The directory is mounted with `:ro`, as intended in Part 2.4. Leave out `:ro` when the container must write to it. |
| `denied` or `unauthorized` on `docker push` | Not logged in to `ghcr.io`, the token lacks `write:packages`, or the repository is not your user name. Log in again. |
| `invalid reference format: repository name must be lowercase` | Write the image name in lowercase, also your GitHub user name. |
| `exec format error` on EC2 or HPC | The image was built for `arm64` only. Build with `--platform linux/amd64,linux/arm64` and push again. |

## Resources

- The class demos: [Apptainer](../../demos/12-apptainer/README.md) and [Docker](../../demos/12-docker/README.md)
- [How To - Docker Walkthroughs](https://www.youtube.com/watch?v=HMxDaM3-c1U) (video, Neal Magee, UVA, 8 min)
- [UVA container basics: advanced commands](https://uvads.github.io/container-basics/docs/advanced-commands/): another walk through building and versioning an image
- [Docker: Get started](https://docs.docker.com/get-started/)
- [Docker CLI reference](https://docs.docker.com/reference/cli/docker/) and [Dockerfile reference](https://docs.docker.com/reference/dockerfile/), with [`ENTRYPOINT` and `CMD`](https://docs.docker.com/reference/dockerfile/#understand-how-cmd-and-entrypoint-interact) and [bind mounts](https://docs.docker.com/engine/storage/bind-mounts/)
- [Docker: Building best practices](https://docs.docker.com/build/building/best-practices/), [the build cache](https://docs.docker.com/build/cache/), and [multi-platform builds](https://docs.docker.com/build/building/multi-platform/)
- [Docker Compose](https://docs.docker.com/compose/)
- [GitHub: Working with the Container registry](https://docs.github.com/en/packages/working-with-a-github-packages-registry/working-with-the-container-registry)
- [Rancher Desktop documentation](https://docs.rancherdesktop.io/)
- [Apptainer user guide](https://apptainer.org/docs/user/main/)
- [ds2002-course: Containers practice](https://github.com/ksiller/ds2002-course/tree/main/practice/11-containers): more examples (`whalesay`, `convert`, FastAPI)
