chr=$1
str=$2
end=$3

bash subset_bcf.sh $chr $str $end

Rscript vcf2gds.R ${chr}_${str}_${end}.vcf ${chr}_${str}_${end}

Rscript do_pca.R ${chr}_${str}_${end}.gds

python genotype_by_PCA.py ${chr}_${str}_${end}_dim1.csv ${chr}_${str}_${end}_dim2.csv $4  ${chr}_${str}_${end}_perc_explained.csv 
