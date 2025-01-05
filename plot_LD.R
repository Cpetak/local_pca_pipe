### librareis
library(ggplot2)
library(data.table)
library(viridis)

### load data
#load("~/WGS/LD_chr/makegrid_outs/job1_50000_10000.Rdata")

args <- commandArgs(trailingOnly=TRUE)

if (interactive()) {
  # Define defaults for interactive mode
  args <- c("NW_022145597.1", "500","all")
}

file <- paste("~/WGS/local_pca_pipe/makegrid_",args[1],"_",args[2],"_all1", "/combined_", args[1], "_", args[2],".Rdata", sep = "")
print(file)
outfile <- paste(args[1], "_", args[2], "_LD_", args[3], ".pdf", sep="")

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

#mstart<-14219351
#mstop<-14298524
#line1 <- o[o$start1 <= mstart & o$stop1 >= mstart, ]$win1[1]
#line2 <- o[o$start1 <= mstop & o$stop1 >= mstop, ]$win1[1]
#line3 <- o[o$start2 <= mstop & o$stop2 >= mstop, ]$win2[1]

new_o <- o#[o$stop1 < upper & o$stop2 < upper, ]
#new_o <- new_o[new_o$stop1 > lower & new_o$stop2 > lower]

#testing
#abs(win1-win2)>0 makes it so that the diagonal is not shown. 
#this changes the r2 ranges shown because the diagonal will have high values

p1 <- ggplot(data=new_o[abs(win1-win2)>0][meanR2>0], aes(x=win1, y=win2, fill=meanR2)) +
  geom_tile() + 
  theme_minimal() + coord_fixed(ratio = 1)+
  #geom_tile(data=new_o[!complete.cases(new_o), ], aes(x=win1, y=win2), fill="black", alpha=0.4) +
  #scale_fill_gradient2(low = "blue", mid = "white", high = "red")+
  scale_fill_viridis(option="H") #limits = c(0, 0.2), trans = "sqrt")
  #theme(
    #panel.background = element_rect(fill = "lightblue")  # change panel background
  #)
  #geom_hline(yintercept = line3, color = "red", linetype = "dashed", size = 1) +
  #geom_vline(xintercept = line2, color = "red", linetype = "dashed", size = 1)

p1

ggsave(outfile, plot = p1, width = 7, height = 5)



### plot
#p1 <- ggplot(data=new_o[abs(win1-win2)>0][meanR2>0], aes(x=win1, y=win2, fill=meanR2)) +
  #geom_tile() + scale_fill_viridis(option="H") +
  #geom_tile(data=new_o[win1!=win2][meanR2<0], aes(x=win1, y=win2), fill="grey39", alpha=.95) +
  #theme_minimal() + coord_fixed(ratio = 1)

#p1

#p1 <- ggplot(data=new_o[abs(win1-win2)>0][meanR2>0], aes(x=win1, y=win2, fill=meanR2)) +
  #geom_tile() + scale_fill_gradient2(low = "blue", mid = "white", high = "red") +
  #coord_fixed(ratio = 1)
  #geom_tile(data=new_o[win1!=win2][meanR2<0], aes(x=win1, y=win2), fill="grey39", alpha=.95) +
  #theme_minimal() 

#p1

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
