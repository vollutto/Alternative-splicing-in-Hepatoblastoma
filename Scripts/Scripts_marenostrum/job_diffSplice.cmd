#!/bin/bash
#SBATCH --job-name="diff_merge"
#SBATCH --workdir=.
#SBATCH --output=%j.out
#SBATCH --error=%j.err
#SBATCH --cpus-per-task=48
#SBATCH --ntasks=1
#SBATCH --time=48:00:00

module load python/3.7.4

bash script_diffSplice_merge.sh
