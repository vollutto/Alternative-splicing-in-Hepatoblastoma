for sid in $(ls /gpfs/scratch/bsc08/bsc08381/PSI/Salmon_output/T/*/quant.sf)
do
	grep "ENST00000546463" $sid >> /gpfs/scratch/bsc08/bsc08381/PSI/Salmon_output/Isoforms/PCBP2_casos.txt
done