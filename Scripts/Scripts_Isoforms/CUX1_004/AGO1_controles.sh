for sid in $(ls /gpfs/scratch/bsc08/bsc08381/PSI/Salmon_output/NT/*/quant.sf)
do
	grep "ENST00000373204" $sid >> /gpfs/scratch/bsc08/bsc08381/PSI/Salmon_output/Isoforms/AGO1_controles.txt
done
