for sid in $(ls /gpfs/scratch/bsc08/bsc08381/PSI/Salmon_output/NT/*/quant.sf)
do
	grep "ENST00000453386" $sid >> /gpfs/scratch/bsc08/bsc08381/PSI/Salmon_output/Isoforms/TRA2B_controles.txt
done
