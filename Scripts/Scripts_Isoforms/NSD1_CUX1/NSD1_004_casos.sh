for sid in $(ls /gpfs/scratch/bsc08/bsc08381/PSI/Salmon_output/T/*/quant.sf)
do
	grep "ENST00000508896" $sid >> /gpfs/scratch/bsc08/bsc08381/PSI/Salmon_output/Isoforms/NSD1_004_casos.txt
done