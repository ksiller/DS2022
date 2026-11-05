#!/bin/bash
#SBATCH --account=ds2022
#SBATCH --job-name=pytorch-mnist
#SBATCH --output=pytorch-mnist-%j.out
#SBATCH --time=00:10:00
#SBATCH --partition=gpu-mig        # GPU partition: one slice of a GPU
#SBATCH --gres=gpu:1               # needed to get the GPU slice
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=1
#SBATCH --cpus-per-task=4          # at most 4 on gpu-mig
#SBATCH --mem=32G

# set up environment: the pytorch module sets $CONTAINERDIR, the directory of the container images
module purge
module load apptainer
module load pytorch

# print the name of the compute node the job runs on
echo "Running on $HOSTNAME"

# execute command inside the PyTorch container; --nv gives it access to the GPU
apptainer run --nv "$CONTAINERDIR/pytorch-2.9.0.sif" pytorch_mnist.py
