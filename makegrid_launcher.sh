#!/bin/sh

#Specify a partition
#SBATCH --partition=short
# Request nodes
#SBATCH --nodes=1
# Request some processor cores
#SBATCH --ntasks=10
# Request memory
#SBATCH --mem=40G
# Run for five minutes
#SBATCH --time=02:00:00
# Name job
#SBATCH --job-name=SbatchJob
# Name output file
#SBATCH --output=%x_%j.out
#SBATCH --array=1-200

# change to the directory where you submitted this script
cd ${SLURM_SUBMIT_DIR}

# Executable section: echoing some Slurm data
echo "Starting sbatch script myscript.sh at:`date`"

cd /users/c/p/cpetak/WGS/local_pca_pipe

Rscript makegrid.R ${SLURM_ARRAY_TASK_ID} 200 ~/EG2023/structural_variation/backup/$1 $2