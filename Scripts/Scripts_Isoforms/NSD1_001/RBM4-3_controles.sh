for sid in $(ls /gpfs/scratch/bsc08/bsc08381/PSI/Salmon_output/NT/*/quant.sf)
do
	grep "ENST00000409406" $sid >> /gpfs/scratch/bsc08/bsc08381/PSI/Salmon_output/Isoforms/RBM4-3_controles.txt
done
