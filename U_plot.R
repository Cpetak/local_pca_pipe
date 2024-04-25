library(ggplot2)
load("~/WGS/local_pca_pipe/combined_30k_job.Rdata")

#Get rid of NAs
o <- na.omit(o)

#All window average r2 
ggplot(data=o, aes(x=abs(mid1-mid2), y=meanR2), alpha=.5, size=.5) +
  geom_point()

#Sub-sampled
num_sample <- 10000
rdf <- o[sample(nrow(o), num_sample), ]

ggplot(data=rdf, aes(x=abs(mid1-mid2), y=meanR2), alpha=.5, size=.5) +
  geom_point()

#Orange break points

obreak1_1<-12670717
obreak1_2<-13270717
obreak2_1<-15390127
obreak2_2<-16440127

#Get rows where any two of the windows that we are comparing (undirectional)
#have a midpoint that falls within one of the two break-point regions
sdf<-o

ndf1 <-sdf[sdf$mid1 >= obreak1_1 & sdf$mid1 <= obreak1_2,]
ndf2 <-sdf[sdf$mid2 >= obreak1_1 & sdf$mid2 <= obreak1_2,]
left<-rbind(ndf1,ndf2)
uleft<-unique(left) #there could be duplication if both mid1 and mid2 is inside

ndf1 <-sdf[sdf$mid1 >= obreak2_1 & sdf$mid1 <= obreak2_2,]
ndf2 <-sdf[sdf$mid2 >= obreak2_1 & sdf$mid2 <= obreak2_2,]
right<-rbind(ndf1,ndf2)
uright<-unique(right)

breaks<-rbind(uleft,uright)
ubreaks<-unique(breaks) #there could be duplication for cases where both mid inside, in separate breakpoints
write.csv(ubreaks, "u_plot_orange.csv", row.names=FALSE)

break_dist<-obreak2_1-obreak1_2
sbreak_dist<-formatC(break_dist, format = "e", digits = 2)

ggplot(data=ubreaks, aes(x=abs(mid1-mid2), y=meanR2), alpha=.5, size=.5) +
  geom_point(aes(colour="orange")) + 
  geom_text(x=obreak2_2, y=0.03, label=sbreak_dist) +
  xlim(0, break_dist+10000000)

#Blue region
#No equivalent "break-points", one big LD block
bregion1<-39517035
bregion2<-42617035
#Only comparing within blue region, so both mid1 and mid2 fall in this region
bdf1 <-sdf[sdf$mid1 >= bregion1 & sdf$mid1 <= bregion2 & sdf$mid2 >= bregion1 & sdf$mid2 <= bregion2,]

ggplot(data=bdf1, aes(x=abs(mid1-mid2), y=meanR2), alpha=.5, size=.5) +
  geom_point(aes(colour="blue")) #+ 
  #geom_text(x=obreak2_2, y=0.03, label=sbreak_dist) +
  #xlim(0, break_dist+10000000)

#Putting it together
ggplot() +
  geom_point(data=o, aes(x=abs(mid1-mid2), y=meanR2), alpha=.5, size=.5) +
  geom_point(data=ubreaks, aes(x=abs(mid1-mid2), y=meanR2), alpha=.5, size=.5, color="orange") +
  geom_point(data=bdf1, aes(x=abs(mid1-mid2), y=meanR2), alpha=.5, size=.5, color="blue") +
  xlim(0, break_dist+5000000)+
  geom_vline(xintercept = break_dist,color="orange")+
  geom_vline(xintercept = (bregion2-bregion1),color="blue")
