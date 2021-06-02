for sid in $(ls /gpfs/scratch/bsc08/bsc08381/PSI/Salmon_output/T/*/quant.sf)
do
	grep "ENST00000321358" $sid >> /gpfs/scratch/bsc08/bsc08381/PSI/Salmon_output/Isoforms/YBX1_casos.txt
done
