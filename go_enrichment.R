library(topGO)

args <- commandArgs(trailingOnly=TRUE)
filename <- args[1]


geneID2GO <- readMappings("supp_files/GO_mapping_topGO") # uniprot to GO mapping
geneNames <- names(geneID2GO)

myInterestingGenes <- read.csv(filename, header = FALSE) # list of interesting genes, output of LOC to uniprot mapping
intgenes <- myInterestingGenes[, "V1"]
geneList <- factor(as.integer(geneNames %in% intgenes)) # mask of 0 and 1 if geneName is interesting
names(geneList) <- geneNames # geneList but annotated with the gene names

GOdata <- new("topGOdata", 
              ontology = "BP", # ontology of interest (BP, MF or CC)
              allGenes = geneList,
              annot = annFUN.gene2GO, 
              gene2GO = geneID2GO)

resultFisher <- runTest(GOdata, algorithm = "classic", statistic = "fisher") 

print(resultFisher)

num_sig<-length(resultFisher@score[resultFisher@score < 0.01])

allRes <- GenTable(GOdata, classicFisher = resultFisher, topNodes = num_sig)

print(allRes)

#showSigOfNodes(GOdata, score(resultFisher), firstSigNodes = 10, useInfo = 'all') 

