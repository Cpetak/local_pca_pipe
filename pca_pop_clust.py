import pandas as pd
import matplotlib.pyplot as plt
import seaborn as sns
from sklearn.cluster import AgglomerativeClustering
import numpy as np
from tqdm import trange
from collections import Counter
import argparse
from scipy import stats

parser = argparse.ArgumentParser(description="Description of your script")
parser.add_argument("chrom", type=str, help="Chromosome name")

args = parser.parse_args()
chrom=args.chrom

coords=pd.read_csv("lostruct_results/type_snp_size_1000_chromosome_"+chrom+"/"+chrom+".regions.csv")

df=pd.read_csv("lostruct_results/type_snp_size_1000_chromosome_"+chrom+"/"+chrom+".pca.csv")

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
max_pval=0
for i in trange(len(df)):
  pcs=df.iloc[i].to_list()[3:]
  p1=pcs[:140]
  p2=pcs[140:]

  if np.isnan(p1).any() == False:

    tdf=pd.DataFrame()
    tdf["p1"] = p1
    tdf["p2"] = p2
    tdf["pops"] = pops
    tdf["geo"] = np.repeat([4, 6, 7, 5, 2, 1, 3],20)

    corr_coeff, p_value = stats.pearsonr(tdf['geo'], tdf['p1'])
  
    if abs(corr_coeff) > abs(max_val):
      max_val = corr_coeff
      max_idx = i
      max_pval = p_value


#plt.savefig(chrom+"_popclust_hist.pdf")

print("Maximum value: ", max_val, " Maximum index: ", max_idx, " p_value: ", max_pval)

