chr=$1
start=$2
stop=$3

awk -v mychr=$chr '$1 = "mychr"' supp_files/genomic.gff | awk -v mystart=$start '$5 >= mystart {print}' | awk -v mystop=$stop '$4 <= mystop {print}' | grep -o 'gene=LOC[0-9]\+' | awk -F= '{print $2}' | sort | uniq > ${1}_${2}_${3}_locs1.txt

awk -v mychr=$chr '$1 = "mychr"' supp_files/genomic.gff | awk -v mystart=$start '$4 >= mystart {print}' | awk -v mystop=$stop '$5 <= mystop {print}' | grep -o 'gene=LOC[0-9]\+' | awk -F= '{print $2}' | sort | uniq > ${1}_${2}_${3}_locs2.txt

awk -v mychr=$chr '$1 = "mychr"' supp_files/genomic.gff | awk -v mystart=$start '$5 >= mystart {print}' | awk -v mystart=$start '$4 <= mystart {print}' | grep -o 'gene=LOC[0-9]\+' | awk -F= '{print $2}' | sort | uniq > ${1}_${2}_${3}_locs3_1.txt

awk -v mychr=$chr '$1 = "mychr"' supp_files/genomic.gff | awk -v mystop=$stop '$5 >= mystop {print}' | awk -v mystop=$stop '$4 <= mystop {print}' | grep -o 'gene=LOC[0-9]\+' | awk -F= '{print $2}' | sort | uniq > ${1}_${2}_${3}_locs3_2.txt

cat ${1}_${2}_${3}_locs3_1.txt ${1}_${2}_${3}_locs3_2.txt | sort | uniq > ${1}_${2}_${3}_locs3.txt

join -t, -1 1 -2 1 -o 1.1,2.2 ${1}_${2}_${3}_locs1.txt supp_files/all_locs_to_uniprotIDs.txt | awk -F, '{print $2}' > ${1}_${2}_${3}_uniprot1.txt
join -t, -1 1 -2 1 -o 1.1,2.2 ${1}_${2}_${3}_locs2.txt supp_files/all_locs_to_uniprotIDs.txt | awk -F, '{print $2}' > ${1}_${2}_${3}_uniprot2.txt
join -t, -1 1 -2 1 -o 1.1,2.2 ${1}_${2}_${3}_locs3.txt supp_files/all_locs_to_uniprotIDs.txt | awk -F, '{print $2}' > ${1}_${2}_${3}_uniprot3.txt

Rscript go_enrichment.R $chr $start $stop
