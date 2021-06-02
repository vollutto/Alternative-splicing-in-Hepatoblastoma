for sid in $(ls /gpfs/scratch/bsc08/bsc08381/PSI/Salmon_output/T/*/quant.sf)
do
	grep "ENST00000310092" $sid >> /gpfs/scratch/bsc08/bsc08381/PSI/Salmon_output/Isoforms/RBM4-1_casos.txt
done
