import pandas as pd
import matplotlib.pyplot as plt
import numpy as np

import argparse

parser = argparse.ArgumentParser(description="Description of your script")
parser.add_argument("num_rand", type=int, help="Number of times to randomly sample")
parser.add_argument("cat", type=str, help="Genotype to compare to, homop, homoq or hetero")
parser.add_argument("calc_markers", type=bool, help="Whether or not to calculate 12 markers")

args = parser.parse_args()

def contains_pattern(row, pattern):
      return any(pattern in str(cell) for cell in row)
def remove_after_colon(s):
      return s.split(':')[0]

def process_df(filename):
  #read and clean

  q=pd.read_csv(filename,skiprows=911,sep="\t")
  q.drop(columns=["#CHROM","ID","QUAL","FILTER","INFO","FORMAT"],inplace=True)
  col_names=[]
  for c in q.columns:
      if c[0]=="/":
        n=c.split("/")[7]
        s=n.split("_")[1]
        col_names.append(s)
      else:
        col_names.append(c)
  q.columns=col_names

  #only SNP and biallelic
  df_filtered = q[q['REF'].str.len() == 1]
  df_filtered = df_filtered[df_filtered['ALT'].str.len() == 1]

  #take out quality info, leave just genotype
  df_filtered['POS'] = df_filtered['POS'].astype(str)
  df_filtered = df_filtered.applymap(remove_after_colon)

  #remove heterozygotes
  pattern = "0/1"
  df_filtered = df_filtered[~df_filtered.apply(lambda row: contains_pattern(row, pattern), axis=1)]

  #keep rows where everyone is the same
  q=df_filtered[df_filtered[df_filtered.columns[3:]].nunique(axis=1) == 1]

  # Replace "0" with values from "REF" column
  for col in q.columns[3:]:
    q[col] = q.apply(lambda row: row['REF'] if row[col] == '0/0' else row[col], axis=1)
    q[col] = q.apply(lambda row: row['ALT'] if row[col] == '1/1' else row[col], axis=1)

  doneq=q.iloc[:,[0,4]]

  return doneq

mypath='/gpfs1/home/c/p/cpetak/WGS/inversion_results/'
if args.calc_markers:
    q=process_df(mypath+'NW_022145594.1_homoq.vcf')
    q = q.rename(columns={q.columns[1]: 'q'})

    p=process_df(mypath+'NW_022145594.1_homop.vcf')
    p = p.rename(columns={p.columns[1]: 'p'})

    merged_df = pd.merge(q, p, on='POS', how='inner')
    nonuniqe=merged_df[merged_df[merged_df.columns[1:]].nunique(axis=1) != 1]
    df = nonuniqe[~nonuniqe.apply(lambda row: contains_pattern(row, "/"), axis=1)]
    print(df)

#Is my region more heterozygous than a randomly selected region?

#different kind of processing this time
#for each loc, for each inidividual, 0 is homozygote, 1 if heterozygote
def process_df(filename):
  #read and clean

  q=pd.read_csv(filename,skiprows=911,sep="\t")
  q.drop(columns=["#CHROM","ID","QUAL","FILTER","INFO","FORMAT"],inplace=True)
  col_names=[]
  for c in q.columns:
      if c[0]=="/":
        n=c.split("/")[7]
        s=n.split("_")[1]
        col_names.append(s)
      else:
        col_names.append(c)
  q.columns=col_names

  #only SNP and biallelic
  df_filtered = q[q['REF'].str.len() == 1]
  df_filtered = df_filtered[df_filtered['ALT'].str.len() == 1]

  #take out quality info, leave just genotype
  df_filtered['POS'] = df_filtered['POS'].astype(str)
  df_filtered = df_filtered.applymap(remove_after_colon)

  # Replace "1/1" and "0/0" with 0 for homo
  for col in df_filtered.columns[3:]:
    df_filtered[col] = df_filtered.apply(lambda row: 0 if row[col] == '0/0' else row[col], axis=1)
    df_filtered[col] = df_filtered.apply(lambda row: 0 if row[col] == '1/1' else row[col], axis=1)
    df_filtered[col] = df_filtered.apply(lambda row: 1 if row[col] == '0/1' else row[col], axis=1)

  #remove missing data
  mask = df_filtered.apply(lambda col: col.str.contains(r'^\./\.$', na=False)).any(axis=1)
  df_filtered = df_filtered[~mask]
  df_filtered['POS'] = df_filtered['POS'].astype(int)
  df_filtered

  return df_filtered

#grep -Fvxf NW_022145594.1_12702886_16793794_vcf_list_homoq ../local_pca_pipe/vcf_col_ids > output.txt #take out homoq
#grep -Fvxf NW_022145594.1_12702886_16793794_vcf_list_homop output.txt > NW_022145594.1_12702886_16793794_vcf_list_hetero #take out homop
#spack load bcftools@1.10.2
#filtered=/users/c/p/cpetak/EG2023/structural_variation/filtered_bcf_files/NW_022145594.1
#bcftools view -S NW_022145594.1_12702886_16793794_vcf_list_hetero -o NW_022145594.1_hetero.vcf ${filtered}/NW_022145594.1_filtered.vcf

filename=mypath+'NW_022145594.1_' + args.cat + '.vcf'
q=process_df(filename)

#take random region, BP BASED
inv_start=12702886
inv_stop=13424367
inv_distance=inv_stop-inv_start

p_vals=[]
for ind in q.columns[3:]:

    inv_val = q[(q["POS"]>inv_start) & (q["POS"]<inv_stop)][ind]

    avail_pos=np.array(q.POS.to_list())
    last_good_start=avail_pos[-1]-inv_distance
    avail_pos= avail_pos[np.where(avail_pos<=last_good_start)[0]]

    other_lens=[]
    other_hets=[]
    other_means=[]
    for i in range(args.num_rand):
        random_start = np.random.choice(avail_pos)
        random_data = q[(q["POS"]>random_start) & (q["POS"]<random_start+inv_distance)][ind]
        other_lens.append(len(random_data))
        other_hets.append(random_data.sum())
        other_means.append(random_data.mean())
    other_hets = np.array(other_hets)
    other_lens = np.array(other_lens)
    other_means = np.array(other_means)
    less_than_inv_het = len(np.where(other_hets<=inv_val.sum())[0])/args.num_rand
    less_than_inv_len = len(np.where(other_lens<=len(inv_val))[0])/args.num_rand
    less_than_inv_mean = len(np.where(other_means<=inv_val.mean())[0])/args.num_rand

    #print(less_than_inv_len)
    #print(less_than_inv_het)
    #print(less_than_inv_mean)
    p_vals.append(less_than_inv_mean)

plt.hist(p_vals)
plt.xlabel("Proportion of other random regions that have less heterozygotes")
plt.ylabel("Number of individuals")
plt.xlim(0,1)
outfilename=mypath+'NW_022145594.1_' + args.cat + "_" + str(args.num_rand) + ".png"
plt.savefig(outfilename)