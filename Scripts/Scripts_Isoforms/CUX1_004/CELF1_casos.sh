for sid in $(ls /gpfs/scratch/bsc08/bsc08381/PSI/Salmon_output/T/*/quant.sf)
do
	grep "ENST00000395292" $sid >> /gpfs/scratch/bsc08/bsc08381/PSI/Salmon_output/Isoforms/CELF1_casos.txt
done
