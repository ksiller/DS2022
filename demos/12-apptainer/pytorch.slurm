#!/bin/bash
#SBATCH -A ds2022
#SBATCH -p gpu-mig
#SBATCH --gres=gpu:1
#SBATCH -c 1
#SBATCH -t 00:10:00
#SBATCH -o pytorch_%j.out

module purge
module load apptainer

nvidia-smi -L
apptainer exec --nv pytorch.sif python train.py
