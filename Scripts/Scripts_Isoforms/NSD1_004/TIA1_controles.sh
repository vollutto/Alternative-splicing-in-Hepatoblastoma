for sid in $(ls /gpfs/scratch/bsc08/bsc08381/PSI/Salmon_output/NT/*/quant.sf)
do
	grep "ENST00000415783" $sid >> /gpfs/scratch/bsc08/bsc08381/PSI/Salmon_output/Isoforms/TIA1_controles.txt
done
