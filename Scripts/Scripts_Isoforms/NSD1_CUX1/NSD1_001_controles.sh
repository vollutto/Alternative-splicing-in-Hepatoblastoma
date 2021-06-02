for sid in $(ls /gpfs/scratch/bsc08/bsc08381/PSI/Salmon_output/NT/*/quant.sf)
do
	grep "ENST00000439151" $sid >> /gpfs/scratch/bsc08/bsc08381/PSI/Salmon_output/Isoforms/NSD1_001_controles.txt
done
