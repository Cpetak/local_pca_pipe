#1 is chromosome,
#2 is start,
#3 is stop

#bash subset_bcf.sh $1 $2 $3

#Rscript vcf2gds.R ${1}_${2}_${3}.vcf ${1}_${2}_${3}

#Rscript do_pca.R ${1}_${2}_${3}.gds

python genotype_by_PCA.py ${1}_${2}_${3}_dim1.csv ${1}_${2}_${3}_dim2.csv 3 ${1}_${2}_${3}_perc_explained.csv
