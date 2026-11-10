# Demo: Apptainer Containers

Commands from the live demo in class. Run each command on its own.

Files in this folder:

| File | Used for |
| --- | --- |
| [lolcow.slurm](lolcow.slurm) | Slurm job array that runs lolcow in 5 containers |
| [train.py](train.py) | small PyTorch training run for the GPU example |
| [pytorch.slurm](pytorch.slurm) | Slurm GPU job that runs `train.py` in the PyTorch container |

## On UVA's HPC system

Setup: [hpc.md](../../setup/hpc.md). Open <https://ood.hpc.virginia.edu> (off Grounds: UVA VPN first), start a **Code Server** session with allocation `ds2022` and partition `interactive`, then **Connect to VSCode** and open a terminal (☰ → Terminal → New Terminal).

### Set up

Create a folder for this activity (`-p` also creates `~/ds2022-fall-2026` if needed):
```bash
mkdir -p ~/ds2022-fall-2026/containers
```

Change into it:
```bash
cd ~/ds2022-fall-2026/containers
```

Copy the job scripts and `train.py` from the course folder:
```bash
cp /standard/siller/ds2022/*.{slurm,py} .
```

Outside class, download them from this folder instead:
```bash
wget https://raw.githubusercontent.com/ksiller/DS2022/main/demos/12-apptainer/lolcow.slurm https://raw.githubusercontent.com/ksiller/DS2022/main/demos/12-apptainer/pytorch.slurm https://raw.githubusercontent.com/ksiller/DS2022/main/demos/12-apptainer/train.py
```

Load Apptainer (once per terminal):
```bash
module load apptainer
```

### Get and run an image

Download the Docker Hub image and save it as one file, `lolcow.sif`:
```bash
apptainer pull lolcow.sif docker://godlovedc/lolcow
```

Pull hangs? Copy the same image from the course folder instead:
```bash
cp /standard/siller/ds2022/lolcow-latest.sif lolcow.sif
```

Run the image's default command (a cow says a random quote):
```bash
apptainer run lolcow.sif
```

Run a command you choose:
```bash
apptainer exec lolcow.sif cowsay "Hello DS2022"
```

Open a shell inside the container; type `exit` to leave:
```bash
apptainer shell lolcow.sif
```

### Run containers in a Slurm job

Submit the job (5 tasks, each runs lolcow in its own container):
```bash
sbatch lolcow.slurm
```

Watch the tasks until they finish:
```bash
squeue --me
```

Read the output, one file per task:
```bash
cat lolcow_*.out
```

Cancel a job (job ID from `squeue`):
```bash
scancel <jobid>
```

### Run a container on a GPU

Download the PyTorch image (about 4 GB, takes several minutes):
```bash
apptainer pull pytorch.sif docker://pytorch/pytorch:2.14.1-cuda12.6-cudnn9-runtime
```

Pull hangs? Copy the same image from the course folder instead:
```bash
cp /standard/siller/ds2022/pytorch.sif pytorch.sif
```

Submit the job (partition `gpu-mig`, one GPU slice):
```bash
sbatch pytorch.slurm
```

Watch the job until it finishes:
```bash
squeue --me
```

Read the output; it should say `device: cuda`:
```bash
cat pytorch_*.out
```

### Clean up

Delete the image files:
```bash
rm lolcow.sif pytorch.sif
```

Delete the layers that `apptainer pull` cached in your home folder:
```bash
apptainer cache clean
```
