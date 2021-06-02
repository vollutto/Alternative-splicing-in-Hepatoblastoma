for sid in $(ls /gpfs/scratch/bsc08/bsc08381/PSI/Salmon_output/T/*/quant.sf)
do
	grep "ENST00000359655" $sid >> /gpfs/scratch/bsc08/bsc08381/PSI/Salmon_output/Isoforms/SUPV3L1_casos.txt
done
