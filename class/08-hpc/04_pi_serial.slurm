#!/bin/bash
#SBATCH --account=ds2022
#SBATCH --job-name=pi-serial
#SBATCH --output=pi-serial-%j.out
#SBATCH --time=00:10:00
#SBATCH --partition=standard
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=1
#SBATCH --cpus-per-task=1
#SBATCH --mem=8G

NUM_POINTS=100000000
OUTPUT_FILE=pi-serial.csv

# set up environment
module purge
module load uv

# print the name of the compute node the job runs on
echo "Running on $HOSTNAME"

# execute command: one process on one CPU core
uv run --with pandas python serial_pi.py "$NUM_POINTS" "$OUTPUT_FILE"
