for sid in $(ls /gpfs/scratch/bsc08/bsc08381/PSI/Salmon_output/T/*/quant.sf)
do
	grep "ENST00000310137" $sid >> /gpfs/scratch/bsc08/bsc08381/PSI/Salmon_output/Isoforms/RBM14_casos.txt
done
