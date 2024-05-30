
file="outlier_regions"

while IFS=, read -r col1 col2 col3; do
    # Store the values in variables
    #chr=$col1
    chr="${col1#\"}"
    chr="${chr%\"}"
    start=$col2
    stop=$col3

    col1="all"
    col2="53"
    col3="outliers"

    echo $chr

    awk -v mychr=$chr '$1 == mychr' ~/WGS/local_pca_pipe/supp_files/genomic.gff | awk -v mystart=$start '$5 >= mystart {print}' | awk -v mystop=$stop '$4 <= mystop {print}' | grep -o 'gene=LOC[0-9]\+' | awk -F= '{print $2}' | sort | uniq >> ${col1}_${col2}_${col3}_locs1.txt

    awk -v mychr=$chr '$1 == mychr' ~/WGS/local_pca_pipe/supp_files/genomic.gff | awk -v mystart=$start '$4 >= mystart {print}' | awk -v mystop=$stop '$5 <= mystop {print}' | grep -o 'gene=LOC[0-9]\+' | awk -F= '{print $2}' | sort | uniq >> ${col1}_${col2}_${col3}_locs2.txt

    awk -v mychr=$chr '$1 == mychr' ~/WGS/local_pca_pipe/supp_files/genomic.gff | awk -v mystart=$start '$5 >= mystart {print}' | awk -v mystart=$start '$4 <= mystart {print}' | grep -o 'gene=LOC[0-9]\+' | awk -F= '{print $2}' | sort | uniq >> ${col1}_${col2}_${col3}_locs3_1.txt

    awk -v mychr=$chr '$1 == mychr' ~/WGS/local_pca_pipe/supp_files/genomic.gff | awk -v mystop=$stop '$5 >= mystop {print}' | awk -v mystop=$stop '$4 <= mystop {print}' | grep -o 'gene=LOC[0-9]\+' | awk -F= '{print $2}' | sort | uniq >> ${col1}_${col2}_${col3}_locs3_2.txt

    cat ${col1}_${col2}_${col3}_locs3_1.txt ${col1}_${col2}_${col3}_locs3_2.txt | sort | uniq >> ${col1}_${col2}_${col3}_locs3.txt

done < "$file"
    
join -t, -1 1 -2 1 -o 1.1,2.2 ${col1}_${col2}_${col3}_locs1.txt ~/WGS/local_pca_pipe/supp_files/all_locs_to_uniprotIDs.txt | awk -F, '{print $2}' > ${col1}_${col2}_${col3}_uniprot1.txt
join -t, -1 1 -2 1 -o 1.1,2.2 ${col1}_${col2}_${col3}_locs2.txt ~/WGS/local_pca_pipe/supp_files/all_locs_to_uniprotIDs.txt | awk -F, '{print $2}' > ${col1}_${col2}_${col3}_uniprot2.txt
join -t, -1 1 -2 1 -o 1.1,2.2 ${col1}_${col2}_${col3}_locs3.txt ~/WGS/local_pca_pipe/supp_files/all_locs_to_uniprotIDs.txt | awk -F, '{print $2}' > ${col1}_${col2}_${col3}_uniprot3.txt

#Rscript ~/WGS/local_pca_pipe/go_enrichment.R $chr $start $stop
