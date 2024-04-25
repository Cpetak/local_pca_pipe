#install.packages('HardyWeinberg')
#library(HardyWeinberg)

dfp <- read.table("NW_022145594.1_12670717_16440127homop_nums.txt", header = FALSE)
dfq <- read.table("NW_022145594.1_12670717_16440127homoq_nums.txt", header = FALSE)
print(nrow(dfp))
print(nrow(dfq))

#Hardy-W
homoq<-nrow(dfq)#length(dim1[dim1< -0.1])
het<-140-nrow(dfp)-nrow(dfq)#length(dim1[(dim1> -0.1) & (dim1< 0.05)])
homop<-nrow(dfp)#length(dim1[dim1 > 0.05])

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

v<-c(homoq, het, homop)
HWExact(v, verbose=TRUE, alternative="greater") #p-value =  0.0068
HWExact(v, verbose=TRUE, alternative="less") #p-value = 0.9976444
HWExact(v, verbose=TRUE) #p-value = 0.00935
#EXCESS OF HETERO
#two.sided (default) will perform a two-sided test where both an excess and a dearth of heterozygotes count as evidence against HWE.
#less is a one-sided test where only dearth of heterozygotes counts a evidence against HWE,
#greater is a one-sided test where only excess of heterozygotes counts as evidence against HWE.