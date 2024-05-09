spack load bcftools@1.10.2
spack load vcftools@0.1.14

chr=$1
str=$2
end=$3
nclust=$4

#bash extract_inds_from_vcf.sh ${chr}_${str}_${end} $4

echo "done extract"

if [ $2 == 3 ]; then

vcftools --gzvcf ~/EG2023/structural_variation/backup/filtered_vcf/${chr}_filtered.vcf --weir-fst-pop ${chr}_${str}_${end}_vcf_list_homoq --weir-fst-pop ${chr}_${str}_${end}_vcf_list_homop --out ${chr}_${str}_${end}_fst

else

num_pops=$nclust
declare -a populations

for ((i=0; i<=$num_pops; i++))
do
  populations[$i]=${chr}_${str}_${end}_vcf_list_clust${i}
done

vcftools --vcf ~/EG2023/structural_variation/backup/filtered_vcf/${chr}_filtered.vcf $(for ((i=0; i<=$num_pops; i++)); do echo "--weir-fst-pop ${populations[$i]}"; done)

fi

#python fst_plotting.py $chr $str $end
