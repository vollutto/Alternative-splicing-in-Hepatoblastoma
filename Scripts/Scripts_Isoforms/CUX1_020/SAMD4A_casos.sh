for sid in $(ls /gpfs/scratch/bsc08/bsc08381/PSI/Salmon_output/T/*/quant.sf)
do
	grep "ENST00000554335" $sid >> /gpfs/scratch/bsc08/bsc08381/PSI/Salmon_output/Isoforms/SAMD4A_casos.txt
done
