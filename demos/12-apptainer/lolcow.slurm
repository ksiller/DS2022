#!/bin/bash
#SBATCH -A ds2022
#SBATCH -p interactive
#SBATCH -c 1
#SBATCH -t 00:05:00
#SBATCH --array=1-5
#SBATCH -o lolcow_%A_%a.out

module purge
module load apptainer

COURSE_DIR=/standard/siller/ds2022
IMAGE=lolcow.sif
# no lolcow.sif here? use the course copy
[ -f "$IMAGE" ] || IMAGE=$COURSE_DIR/lolcow-latest.sif

echo "Telling joke #${SLURM_ARRAY_TASK_ID} on $(hostname)"
apptainer run "$IMAGE"
