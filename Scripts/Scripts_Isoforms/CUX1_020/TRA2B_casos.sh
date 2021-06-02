for sid in $(ls /gpfs/scratch/bsc08/bsc08381/PSI/Salmon_output/T/*/quant.sf)
do
	grep "ENST00000453386" $sid >> /gpfs/scratch/bsc08/bsc08381/PSI/Salmon_output/Isoforms/TRA2B_casos.txt
done
