#Runing quantification
function merge()
{
  id=$(basename ${sid})
  local nfiles=$(ls ${sid}_*$1* | wc -l)
  if [[ $nfiles -ge 2 ]]
  then
    local fname=${id}_$1.fastq.gz
    cat ${sid}_*$1* > Samples_merge/$fname
  else
    local fname=$(ls ${sid}_*$1*)
    cat $fname > "Samples_merge/"$(basename $fname)
  fi
  echo $fname
}
for sid in $(ls /gpfs/projects/bsc82/shared_projects/iPC/IGTP/data/RNA-seq/HB/*.fastq.gz | cut -d"_" -f1,2,3 | sort | uniq)
do
 R1=$(merge "R1")
 R2=$(merge "R2")
done
