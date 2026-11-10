# Demo: Docker Containers

Commands from the live demo in class. Run each command on its own.

Files in this folder:

| File | Used for |
| --- | --- |
| [script.sh](script.sh) | the app inside `my_image` |
| [Dockerfile](Dockerfile) | the recipe for `my_image` |
| [compose.yaml](compose.yaml) | Docker Compose: nginx web server and PostgreSQL database |

## On your computer

Setup: [GENERAL.md](../../setup/GENERAL.md) (Rancher Desktop with the `dockerd (moby)` engine) and [AI-Installation.md](../../setup/AI-Installation.md). Mac: Terminal. Windows: Ubuntu (WSL).

### Set up

Create a working folder for this activity (`-p` also creates `~/ds2022-fall-2026` if needed):
```bash
mkdir -p ~/ds2022-fall-2026/containers
```

Change into it:
```bash
cd ~/ds2022-fall-2026/containers
```

Download the demo files from the course repo into this folder (`-O` keeps each file's name):
```bash
curl -O https://raw.githubusercontent.com/ksiller/DS2022/main/demos/12-docker/Dockerfile
curl -O https://raw.githubusercontent.com/ksiller/DS2022/main/demos/12-docker/script.sh
curl -O https://raw.githubusercontent.com/ksiller/DS2022/main/demos/12-docker/compose.yaml
```

### Check Docker

Log in to Docker Hub (skip today; only needed to push images):
```bash
docker login
```

Check that Docker is running:
```bash
docker info
```

### Run a chat model

Start a small language model with a chat web app in the background:
```bash
docker run -d --name smol-llm2 -p 127.0.0.1:9090:9090 -v llm-cache:/models -e LLAMA_CACHE=/models \
  ghcr.io/ggml-org/llama.cpp:server -hf unsloth/SmolLM2-135M-Instruct-GGUF:Q4_K_M \
  --host 0.0.0.0 --port 9090 -c 2048 --parallel 1
```

Follow the log until it says `listening on http://0.0.0.0:9090`:
```bash
docker logs -f smol-llm2
```
Press Ctrl+C to get out of the log.

Then open <http://localhost:9090> in a browser.

**Try a prompt (in chat window):**
```text
what is the university of virginia
```

Leave it running; we clean up at the end.

### Build your own image (in terminal)

In `~/ds2022-fall-2026/containers`, build an image from `Dockerfile` and `script.sh` (the trailing `.` means this folder; don't leave it out):
```bash
docker build -t my_image:1.0.0 .
```

Start a container from your image; it runs the image's default command:
```bash
docker run my_image:1.0.0
```

### Optional: push to Docker Hub

Log in first (`docker login`, see above). Give the image a name that includes your account (replace `my_repo` with your Docker Hub username), then upload it:
```bash
docker tag my_image:1.0.0 my_repo/my_image:1.0.0
```
```bash
docker push my_repo/my_image:1.0.0
```
(If this fails, don't worry about it. Just move on, we can troubleshoot later.)

### Pull and run images

Download an image from Docker Hub:
```bash
docker pull ubuntu:latest
```

Open a shell in a new container:
```bash
docker run -it ubuntu:latest /bin/bash
```
Try a command:
```bash
which python
```
It comes up empty. Can you think why?

Type `exit` to leave the shell; the container stops.

Run a web server in the background:
```bash
docker run -d -p 8080:80 nginx
```
Then open <http://localhost:8080>.

Back in the terminal, list the running containers:
```bash
docker ps
```

List the images on your computer:
```bash
docker image ls # or docker images
```

### Stop and delete containers

Stop a container (name or ID from `docker ps`):
```bash
docker stop <container>
```
Stop the nginx container (its name is in the `NAMES` column of `docker ps`) and refresh <http://localhost:8080>. It should fail now.

Delete a stopped container; the image stays:
```bash
docker rm <container>
```

List all containers, stopped ones too:
```bash
docker ps -a
```

Delete stopped containers, unused networks, dangling (unnamed) images and build cache. Docker asks you to confirm:
```bash
docker system prune
```

Check again; the stopped ubuntu container is gone too:
```bash
docker ps -a
```

### Docker Compose

In `~/ds2022-fall-2026/containers`, start the containers described in `compose.yaml` in the background (-d means detached):
```bash
docker compose up -d
```

List the Compose containers:
```bash
docker compose ps
```

Stop and delete the Compose containers:
```bash
docker compose down
```

### Clean up everything

List all containers; only `smol-llm2` should be left:
```bash
docker ps -a
```

Stop the chat model:
```bash
docker stop smol-llm2
```

Delete its container:
```bash
docker rm smol-llm2
```

In `~/ds2022-fall-2026/containers`, delete the Compose containers and their `db-data` volume (`-v`):
```bash
docker compose down -v
```

List your images:
```bash
docker images
```

Delete the demo images (if you pushed, also delete `my_repo/my_image:1.0.0`):
```bash
docker rmi my_image:1.0.0 ghcr.io/ggml-org/llama.cpp:server nginx ubuntu postgres:17
```

Delete the volume with the downloaded model:
```bash
docker volume rm llm-cache
```

List your images again; the demo images are gone:
```bash
docker images
```
