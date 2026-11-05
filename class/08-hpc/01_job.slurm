#!/bin/bash
#SBATCH --account=ds2022
#SBATCH --job-name=hello
#SBATCH --output=hello-%j.out
#SBATCH --time=00:01:00
#SBATCH --partition=interactive
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=1
#SBATCH --cpus-per-task=1
#SBATCH --mem=8G

# set up environment
module purge
module load uv

# execute commands
echo "Running on $HOSTNAME"

uv run python my_script.py
