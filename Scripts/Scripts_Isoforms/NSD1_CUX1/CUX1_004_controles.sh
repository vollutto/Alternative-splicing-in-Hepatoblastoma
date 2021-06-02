for sid in $(ls /gpfs/scratch/bsc08/bsc08381/PSI/Salmon_output/NT/*/quant.sf)
do
	grep "ENST00000292535" $sid >> /gpfs/scratch/bsc08/bsc08381/PSI/Salmon_output/Isoforms/CUX1_004_controles.txt
done
