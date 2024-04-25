#!/bin/bash

#NW_022145594.1_12670717_16440127_homop_nums.txt

file_path="vcf_col_ids"

file_homop="${1}_homop_nums.txt"
file_homoq="${1}_homoq_nums.txt"

homop=()
while IFS= read -r line; do
  homop+=("$line")
done < $file_homop

homoq=()
while IFS= read -r line; do
      homoq+=("$line")
    done < $file_homoq

for row_number in "${homop[@]}"; do
  sed -n "${row_number}p" "$file_path" >> "${1}_vcf_list_homop"
done

for row_number in "${homoq[@]}"; do
    sed -n "${row_number}p" "$file_path" >> "${1}_vcf_list_homoq"
  done
