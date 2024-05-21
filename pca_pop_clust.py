import pandas as pd
import matplotlib.pyplot as plt
import seaborn as sns
from sklearn.cluster import AgglomerativeClustering
import numpy as np
from tqdm import trange
from collections import Counter
import argparse

parser = argparse.ArgumentParser(description="Description of your script")
parser.add_argument("chrom", type=str, help="Chromosome name")

args = parser.parse_args()
chrom=args.chrom

coords=pd.read_csv("lostruct_results/type_snp_size_1000_chromosome_"+chrom+"/"+chrom+".regions.csv")

df=pd.read_csv("lostruct_results/type_snp_size_1000_chromosome_"+chrom+"/"+chrom+".regions.csv")

pops=df.columns.to_list()[3:]
pops=[i.split("_")[3] for i in pops]
pops=[i.split("/")[1] for i in pops][:int((len(df.columns.to_list())-3)/2)]

def get_agglo(values, k):
  X = np.array(values).reshape(-1, 1)

  agg_clustering = AgglomerativeClustering(n_clusters=k, linkage='ward')

  # Fit the model to the data
  agg_clustering.fit(X)

  labels = agg_clustering.labels_

  return labels

NUM_CLUST=7

vals=[]
max_idx=0
max_val=0
for i in trange(len(df)):
  pcs=df.iloc[i].to_list()[3:]
  p1=np.array(pcs[:140])

  if np.isnan(p1).any():
    vals.append(0)

  else:
    clusts=get_agglo(p1,NUM_CLUST)

    perc=0
    for c in range(NUM_CLUST):
      t=np.where(np.array(clusts) == c)[0]
      c_pops=np.array(pops)[t]
      mc=Counter(c_pops).most_common(1)[0][1]
      perc+=mc/len(c_pops) #what percentage of the cluster is the most common pop, higher better

    vals.append(perc) #max is 7
    
    if perc > max_val:
      max_val = perc
      max_idx = i
      

plt.hist(vals)
plt.savefig(chrom+"_popclust_hist.pdf")

print("Maximum value: ", max_val, " Maximum index: ", max_idx)

