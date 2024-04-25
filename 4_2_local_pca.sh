spack load bcftools@1.10.2
spack load vcftools@0.1.14

chr=$1
str=$2
end=$3

bash extract_inds_from_vcf.sh ${chr}_${str}_${end}

vcftools --gzvcf ~/EG2023/structural_variation/backup/filtered_vcf/${chr}_filtered.vcf --weir-fst-pop ${chr}_${str}_${end}_vcf_list_homoq --weir-fst-pop ${chr}_${str}_${end}_vcf_list_homop --out ${chr}_${str}_${end}_fst

