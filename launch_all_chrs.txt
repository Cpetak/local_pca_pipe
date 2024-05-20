#!/bin/sh

#Specify a partition
#SBATCH --partition=bluemoon
# Request nodes
#SBATCH --nodes=1
# Request some processor cores
#SBATCH --ntasks=1
# Request memory
#SBATCH --mem=14G
# Run for five minutes
#SBATCH --time=30:00:00
# Name job
#SBATCH --job-name=SbatchJob
# Name output file
#SBATCH --output=%x_%j.out

# change to the directory where you submitted this script
cd ${SLURM_SUBMIT_DIR}

# Executable section: echoing some Slurm data
echo "Starting sbatch script myscript.sh at:`date`"

#spack load bcftools@1.10.2

#ref="/users/c/p/cpetak/WGS/reference_genome/GCF_000002235.5_Spur_5.0_genomic.fna"

cd /users/c/p/cpetak/WGS/local_pca_pipe

Rscript ~/WGS/local_pca_pipe/run_lostruct.R -i ~/EG2023/structural_variation/backup/filtered_bcf_index_noouts/all_together -t snp -s 100000 -I ~/WGS/local_pca_pipe/sample_info_noouts.tsv -o ~/WGS/local_pca_pipe/lostruct_results_noouts/type_snp_size_${snp}_all_chromosomes
