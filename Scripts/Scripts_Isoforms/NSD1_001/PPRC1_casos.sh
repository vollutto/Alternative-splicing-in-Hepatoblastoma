for sid in $(ls /gpfs/scratch/bsc08/bsc08381/PSI/Salmon_output/T/*/quant.sf)
do
	grep "ENST00000278070" $sid >> /gpfs/scratch/bsc08/bsc08381/PSI/Salmon_output/Isoforms/PPRC1_casos.txt
done
