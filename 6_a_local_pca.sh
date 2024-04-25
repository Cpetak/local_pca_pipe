chr=$1
winsize=$2

sbatch makegrid_launcher.sh ~/EG2023/structural_variation/backup/filtered_gds/${chr}_filtered.gds $2

Rscript gather_results.R $1 $2

#rm -rf ~/WGS/local_pca_pipe/makegrid_${1}_${2}
#rm ~/WGS/local_pca_pipe/Sbatch*

Rscript plot_LD.R $1 $2
