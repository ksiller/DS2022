#!/bin/bash
#SBATCH --account=ds2022
#SBATCH --job-name=pi-mp
#SBATCH --output=pi-mp-%j.out
#SBATCH --time=00:10:00
#SBATCH --partition=standard
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=1
#SBATCH --cpus-per-task=8          # 8 CPU cores for 8 worker processes
#SBATCH --mem-per-cpu=8G           # memory per CPU core: 8 x 8 GB = 64 GB in total

NUM_POINTS=100000000
OUTPUT_FILE=pi-mp.csv

# set up environment
module purge
module load uv

# print the name of the compute node the job runs on
echo "Running on $HOSTNAME"

# Slurm sets $SLURM_CPUS_PER_TASK and $SLURM_MEM_PER_CPU from the directives above
echo "Number of CPU cores assigned to the job: $SLURM_CPUS_PER_TASK"
echo "Amount of memory assigned to each CPU core: $SLURM_MEM_PER_CPU"

# execute command: pass the number of CPU cores, so the script starts one worker process per core
uv run --with pandas python mp_pi.py "$NUM_POINTS" "$OUTPUT_FILE" "$SLURM_CPUS_PER_TASK"
