for sid in $(ls /gpfs/scratch/bsc08/bsc08381/PSI/Salmon_output/NT/*/quant.sf)
do
	grep "ENST00000492112" $sid >> /gpfs/scratch/bsc08/bsc08381/PSI/Salmon_output/Isoforms/SRSF10_controles.txt
done
