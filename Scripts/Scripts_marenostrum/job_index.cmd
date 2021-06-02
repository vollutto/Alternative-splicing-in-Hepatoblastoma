#!/bin/bash
#SBATCH --job-name="salmon_index"
#SBATCH --workdir=.
#SBATCH --output=%j.out
#SBATCH --error=%j.err
#SBATCH --cpus-per-task=24
#SBATCH --ntasks=1
#SBATCH --time=01:00:00
#SBATCH --qos=debug

module load SALMON

export LD_LIBRARY_PATH=~/PSI/salmon/lib:$LD_LIBRARY_PATH
salmon index -t /gpfs/scratch/bsc08/bsc08381/PSI/hg19_EnsenmblGenes_sequence_ensenmbl.fasta -i /gpfs/scratch/bsc08/bsc08381/PSI/Ensembl_hg19_salmon_index
