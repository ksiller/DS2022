#!/bin/bash
#SBATCH --account=ds2022
#SBATCH --job-name=hello-gpu
#SBATCH --output=hello-gpu-%j.out
#SBATCH --time=00:01:00
#SBATCH --partition=gpu-mig
#SBATCH --gres=gpu:1
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=1
#SBATCH --cpus-per-task=1
#SBATCH --mem=8G

# set up environment
module purge

# print the name of the compute node the job runs on
echo "Running on $HOSTNAME"

# execute command: list the GPU and the MIG slice this job got
nvidia-smi -L
