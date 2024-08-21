chr=$1
start=$2
stop=$3

#Most inclusive, includes genes that start before the end of the region (stop) and ends after the start of the region (start). So, it includes genes that span the entire region, the genes that start before the start of the region and end somewhere in the middle, genes that start somewhere in the middle and end outside of the region, and genes that are entirely included.
awk -v mychr=$chr '$1 == mychr' ~/WGS/local_pca_pipe/supp_files/genomic.gff | awk -v mystart=$start '$5 >= mystart {print}' | awk -v mystop=$stop '$4 <= mystop {print}' | awk -v myname='gene' '$3 == myname {print}' | grep -o 'gene=LOC[0-9]\+' | awk -F= '{print $2}' | sort | uniq > ${1}_${2}_${3}_locs1.txt

#More conservative, subset of the first locs list. Only includes genes that start and end within the region.
awk -v mychr=$chr '$1 == mychr' ~/WGS/local_pca_pipe/supp_files/genomic.gff | awk -v mystart=$start '$4 >= mystart {print}' | awk -v mystop=$stop '$5 <= mystop {print}' | awk -v myname='gene' '$3 == myname {print}' | grep -o 'gene=LOC[0-9]\+' | awk -F= '{print $2}' | sort | uniq > ${1}_${2}_${3}_locs2.txt

#Only includes genes that start before the start and end after the start. Includes genes that span entire region. It is a subset of the first locs list. The point is that it lists genes the left breakpoint disrupts. 
awk -v mychr=$chr '$1 == mychr' ~/WGS/local_pca_pipe/supp_files/genomic.gff | awk -v mystart=$start '$5 >= mystart {print}' | awk -v mystart=$start '$4 <= mystart {print}' | awk -v myname='gene' '$3 == myname {print}' | grep -o 'gene=LOC[0-9]\+' | awk -F= '{print $2}' | sort | uniq > ${1}_${2}_${3}_locs3_1.txt

#Only includes genes that start before the end and end after the end. Includes genes that span entire region. It is a subset of the first locs list. The point is that it lists genes the right breakpoint disrupts.
awk -v mychr=$chr '$1 == mychr' ~/WGS/local_pca_pipe/supp_files/genomic.gff | awk -v mystop=$stop '$5 >= mystop {print}' | awk -v mystop=$stop '$4 <= mystop {print}' | awk -v myname='gene' '$3 == myname {print}' | grep -o 'gene=LOC[0-9]\+' | awk -F= '{print $2}' | sort | uniq > ${1}_${2}_${3}_locs3_2.txt

#Subset of first locs list, doesn't include genes that are inside the region, not crossing the breakpoints (second locs list). So this set is A - B, where A is all the genes (first locs list), B is only genes in the middle of the region (second locs list)
cat ${1}_${2}_${3}_locs3_1.txt ${1}_${2}_${3}_locs3_2.txt | sort | uniq > ${1}_${2}_${3}_locs3.txt

join -t, -1 1 -2 1 -o 1.1,2.2 ${1}_${2}_${3}_locs1.txt ~/WGS/local_pca_pipe/supp_files/all_locs_to_uniprotIDs.txt | awk -F, '{print $2}' > ${1}_${2}_${3}_uniprot1.txt
join -t, -1 1 -2 1 -o 1.1,2.2 ${1}_${2}_${3}_locs2.txt ~/WGS/local_pca_pipe/supp_files/all_locs_to_uniprotIDs.txt | awk -F, '{print $2}' > ${1}_${2}_${3}_uniprot2.txt
join -t, -1 1 -2 1 -o 1.1,2.2 ${1}_${2}_${3}_locs3.txt ~/WGS/local_pca_pipe/supp_files/all_locs_to_uniprotIDs.txt | awk -F, '{print $2}' > ${1}_${2}_${3}_uniprot3.txt

#Rscript ~/WGS/local_pca_pipe/go_enrichment.R $chr $start $stop
