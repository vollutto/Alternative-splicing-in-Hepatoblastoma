#Running the suppa quantification
python /gpfs/scratch/bsc08/bsc08381/PSI/SUPPA/multipleFieldSelection.py -i /gpfs/scratch/bsc08/bsc08381/PSI/Salmon_output/controles_2/*/quant.sf \
-k 1 -f 4 -o /gpfs/scratch/bsc08/bsc08381/PSI/Expression/merge/controles_merge_tpm.txt

#Running R : changing the ids of the expression file
Rscript /gpfs/scratch/bsc08/bsc08381/PSI/SUPPA/scripts/format_Ensembl_ids_controles.R Expression/merge/controles_merge_tpm.txt

#Creating all the events in the same file
python /gpfs/scratch/bsc08/bsc08381/PSI/SUPPA/suppa.py psiPerEvent -i Events/ensembls_hg19.events.ioe -e Expression/merge/controles_merge_tpm_formatted.txt -o Expression/merge/controles_merge_events
