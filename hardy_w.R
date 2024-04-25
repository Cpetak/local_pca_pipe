#setwd("~/WGS")
library("SNPRelate")
library(ggplot2)

#vcf.fn<-"orange_inv_padded_whead.vcf"
#snpgdsVCF2GDS(vcf.fn, "ccm.gds",  method="biallelic.only")
args <- commandArgs(trailingOnly = TRUE)
filename <- args[1]
genofile <- snpgdsOpen(filename)

ccm_pca<-snpgdsPCA(genofile, autosome.only=FALSE)
dim1<-ccm_pca$eigenvect[,1]
dim2<-ccm_pca$eigenvect[,2]
#col<-as.numeric(substr(ccm_pca$sample, 1,3) == 'CCM')+3

print(dim1)
print(dim2)

plot(dim1, dim2) #ylim = c(-0.2, 0.4)) #,col=col, pch=2)

#Hardy-W
homoq<-length(dim1[dim1< -0.1])
het<-length(dim1[(dim1> -0.1) & (dim1< 0.05)])
homop<-length(dim1[dim1 > 0.05])

p<- (homop*2 + het)/280
q<- (homoq*2 + het)/280

#Would expect
ehomoq <- q*q*140 #24, actual 16
ehomop <- p*p*140 #49, actual 41
ehete <- 2*q*p*140 #68, actual 83

#There are less of the minor allele than expected! also more of the hetero!
print(ehomoq/homoq) #expected minor is 1.5 more
print(ehomop/homop) #expected major is 1.2 more
print(het/ehete) #actual hete is 1.2 more

y = c(ehomoq,ehomop,ehete,homoq,homop,het)
y.matrix = matrix(data = y, ncol = 2, byrow = FALSE)
y.df = as.data.frame(y.matrix)

#install.packages('HardyWeinberg')
library(HardyWeinberg)
v<-c(homoq, het, homop)
HWExact(v, verbose=TRUE, alternative="greater") #p-value =  0.0068
HWExact(v, verbose=TRUE, alternative="less") #p-value = 0.9976444
HWExact(v, verbose=TRUE) #p-value = 0.00935
#EXCESS OF HETERO
#two.sided (default) will perform a two-sided test where both an excess and a dearth of heterozygotes count as evidence against HWE. 
#less is a one-sided test where only dearth of heterozygotes counts a evidence against HWE, 
#greater is a one-sided test where only excess of heterozygotes counts as evidence against HWE.

# GOUPS
pops<-c("BOD", "CAP", "FOG", "KIB", "LOM", "SAN", "TER")
pops<-rep(pops, each=20)
ids<-seq(1,140)
pids<-paste0(pops,ids)

#homoq_pids group matches the local pca left group for peak 1 in terms of 
#3 BODs, 1 CAPs, 3 FOGs etc
homoq_pids<-ids[dim1 < -0.1]
homop_pids<-ids[dim1 > 0.05]
hete_pids<-pids[(dim1> -0.1) & (dim1< 0.05)]

print(homoq_pids)

plot(dim1, dim2)
abline(v=-0.1)
abline(v=0.05)



