#!/bin/bash
#SBATCH --account=ds2022
#SBATCH --job-name=hello-array
#SBATCH --output=hello-array-%A_%a.out
#SBATCH --time=00:01:00
#SBATCH --partition=interactive
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=1
#SBATCH --cpus-per-task=1
#SBATCH --mem=8G
#SBATCH --array=1-5

# set up environment
module purge
module load uv

# execute command: each task gets its own number in $SLURM_ARRAY_TASK_ID
uv run python my_array.py "$SLURM_ARRAY_TASK_ID"
