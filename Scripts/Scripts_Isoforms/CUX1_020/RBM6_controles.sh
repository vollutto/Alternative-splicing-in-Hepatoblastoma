for sid in $(ls /gpfs/scratch/bsc08/bsc08381/PSI/Salmon_output/NT/*/quant.sf)
do
	grep "ENST00000266022" $sid >> /gpfs/scratch/bsc08/bsc08381/PSI/Salmon_output/Isoforms/RBM6_controles.txt
done
