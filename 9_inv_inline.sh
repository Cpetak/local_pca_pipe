#did below automatized, in excel
chr=NW_022145594.1 start=11884704 stop=17611976 actustart=12702886 actustop=16793794
chr=NW_022145594.1 start=38826129 stop=43049305 actustart=39429440 actustop=42445994
chr=NW_022145597.1 start=14203516 stop=14314359 actustart=14219351 actustop=14298524
chr=NW_022145600.1 start=33694860 stop=34730460 actustart=33842803 actustop=34582517
chr=NW_022145601.1 start=28827224 stop=29689418 actustart=28950395 actustop=29566247
chr=NW_022145603.1 start=8130688 stop=9254692 actustart=8291260 actustop=9094120
chr=NW_022145606.1 start=16585555 stop=16762970 actustart=16610900 actustop=16737625
chr=NW_022145609.1 start=29358050 stop=29845887 actustart=29427741 actustop=29776196
chr=NW_022145610.1 start=30642801 stop=31597195 actustart=30779143 actustop=31460853

#All individuals

bash subset_bcf.sh $chr $start $stop
Rscript vcf2gds.R ${chr}_${start}_${stop}.vcf ${chr}_${start}_${stop}
Rscript LD_get_num_windows.R ${chr}_${start}_${stop}.gds 30000 #190 windows is good - more complex than that, small window size = lots of dead space on plot. 
# 30k good for inversion 1). could change by inversion. eg with inversion 3) there are only 3 comparisions with 30k window size
window_size=30000
mkdir makegrid_${chr}_${window_size}
sbatch makegrid_launcher.sh ~/WGS/local_pca_pipe/${chr}_${start}_${stop}.gds ${window_size}
Rscript gather_results.R ${chr} ${window_size}
Rscript plot_LD.R ${chr} ${window_size} "all"

#Only homozygotes to major allele
#had already the vcf_homo_list from Fst

#spack load bcftools@1.10.2
bcftools view -S ${chr}_${actustart}_${actustop}_vcf_list_homop -o ${chr}_${start}_${stop}_homoponly.vcf ${chr}_${start}_${stop}.vcf

Rscript vcf2gds.R ${chr}_${start}_${stop}_homoponly.vcf ${chr}_${start}_${stop}_homoponly
Rscript LD_get_num_windows.R ${chr}_${start}_${stop}_homoponly.gds 30000 
window_size=30000
#WARNING RENAME OTHER MAKEGRID DIR FIRST
mkdir makegrid_${chr}_${window_size}
sbatch makegrid_launcher.sh ~/WGS/local_pca_pipe/${chr}_${start}_${stop}_homoponly.gds ${window_size}
Rscript gather_results.R ${chr} ${window_size}
Rscript plot_LD.R ${chr} ${window_size} "homop"