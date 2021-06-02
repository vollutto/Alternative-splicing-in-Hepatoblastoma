#Creating all the events in the same file
python /gpfs/scratch/bsc08/bsc08381/PSI/SUPPA/suppa.py diffSplice -m empirical \
-i Events/ensembls_hg19.events.ioe -p Expression/merge/casos_merge_events.psi Expression/merge/controles_merge_events.psi \
-e Expression/merge/casos_merge_tpm_formatted.txt Expression/merge/controles_merge_tpm_formatted.txt \
-a 1000 -l 0.05 -gc -o Expression/merge/diff_merge

