### librareis
library(ggplot2)
library(data.table)
library(viridis)

### load data
#load("~/WGS/LD_chr/makegrid_outs/job1_50000_10000.Rdata")

args <- commandArgs(trailingOnly=TRUE)
file <- paste("~/WGS/inversion_results/", "combined_", args[1], "_", args[2],".Rdata", sep = "")
outfile <- paste(args[1], "_", args[2], "_LD.pdf", sep="")

load(file)

### pad empty spaces
grid <- data.table(expand.grid(1:max(c(o$win1, o$win2)), 1:max(c(o$win1, o$win2))))
setnames(grid, names(grid), c("win1", "win2"))

grid <- grid[win1<win2]
setkey(o, win1, win2)
setkey(grid, win1, win2)

#o2 <- merge(o[poolOnly==T][rnp.thr==1], grid, all=T)
#o2[is.na(meanR2), meanR2:=-.01]

table(o$win1>o$win2)
#table(o2$win1>o2$win2)

### plot
p1 <- ggplot(data=o[abs(win1-win2)>0][meanR2>0], aes(x=win1, y=win2, fill=meanR2)) +
  geom_raster() + scale_fill_viridis(option="H") +
  geom_raster(data=o[win1!=win2][meanR2<0], aes(x=win1, y=win2), fill="grey39", alpha=.95) +
  theme_minimal() + coord_fixed(ratio = 1)

ggsave(outfile, plot = p1)

#ggplot(data=o[win1!=win2], aes(x=win1, y=win2, fill=meanR2)) + geom_tile() + scale_fill_viridis(option="F")


#g2 <- ggplot(data=o[meanR2>0], aes(x=log10(abs(mid1-mid2)), y=meanR2), alpha=.5, size=.5) + geom_point()
#ggsave(g2, file="~/pairwise.jpg", h=8, w=8)

#o[,lDist:=log10(abs(mid1-mid2)+1)]
#t1 <- lm(meanR2~lDist, data=o[meanR2>0])
#o[meanR2>0,pred:=predict(t1)]
#o[,resid:=meanR2-pred]


#p1 <- ggplot(data=o[meanR2>0], aes(x=win1, y=win2, fill=resid)) +
  #geom_raster() + scale_fill_viridis(option="H") +
  #geom_raster(data=o[win1!=win2][meanR2<0], aes(x=win1, y=win2), fill="grey39", alpha=.95) +
  #theme_minimal()
#p1

#ggsave(p1, file="~/ld_mat_r.jpg", h=8, w=10)
