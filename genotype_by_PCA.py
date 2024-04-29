from collections import Counter
import matplotlib.pyplot as plt
from collections import defaultdict
import numpy as np
import pandas as pd
import argparse

from sklearn.cluster import KMeans
from sklearn.cluster import AgglomerativeClustering
from mpl_toolkits.basemap import Basemap as Basemap

def get_KMeans(values, k):
    # Convert the list to a numpy array
    X = np.array(values).reshape(-1, 1)

    # Perform K-means clustering
    kmeans = KMeans(n_clusters=k,n_init="auto",random_state=42)
    kmeans.fit(X)

    # Get the cluster labels
    cluster_labels = kmeans.labels_

    # Initialize lists for each cluster
    clusters = [[] for _ in range(k)]

    # Assign each value to its corresponding cluster
    for value, label in zip(values, cluster_labels):
        clusters[label].append(value)

    return sorted(clusters, key=lambda x: x[0])

def get_agglo(values, k):
  X = np.array(values).reshape(-1, 1)

  agg_clustering = AgglomerativeClustering(n_clusters=k, linkage='ward')

  # Fit the model to the data
  agg_clustering.fit(X)

  labels = agg_clustering.labels_

  return labels

parser = argparse.ArgumentParser(description="Description of your script")
parser.add_argument("df1", type=str, help="PC1 csv")
parser.add_argument("df2", type=str, help="PC2 csv")

args = parser.parse_args()

df1=pd.read_csv(args.df1)
df2=pd.read_csv(args.df2)
dim1=df1["dim1"].tolist()
dim2=df2["dim2"].tolist()

print("read files")
print(dim1)

#dim1=[0.0308274655,-0.0742644073,-0.0841431900,-0.0230878107,0.0051481365,-0.0222673662,-0.0462810026,-0.1579021258,-0.0534418859,0.0280474770,0.1189032953,-0.0441213181,0.1136986249,0.0338264344,0.0877064435,-0.0231341076,-0.0394171843,-0.1686714473,-0.0798707327,-0.1367571348,0.1286131939,-0.0533081833,0.1095484047,0.1008488817,0.1001261509,0.0038175419,-0.0306690960,-0.0278488554,0.1196000749,0.1206880095,-0.0412988845,-0.0754539423,-0.1123966722,0.1370624924,0.1002326251,0.1169870726,0.1175301875,-0.0513575280,-0.0223235089,-0.0363315326,0.1192746608,-0.0448558344,0.1222510921,-0.1295125287,-0.0538977390,-0.1375651303,0.1243948157,0.0453700192,0.1045921845,0.1114159200,-0.0269059823,0.0175816539,-0.0237033074,0.0906306892,0.0900273952,0.0315139854,0.0077117475,-0.0364871133,-0.0667160681,-0.1283989590,-0.0454611159,0.1126133887,0.1288353012,-0.1978691783,-0.0637048899,0.0804189579,0.0020725820,-0.0220800778,0.0110230278,0.1039589290,0.1053247372,-0.1473032736,-0.0295920584,0.1286936595,-0.0305937602,0.0950735555,0.0106090095,0.0841424840,0.0003336198,0.1133245891,0.1162175063,-0.0282357814,0.0886240007,-0.0474919529,-0.0286162214,0.1049732751,-0.0181211567,-0.0132877080,0.1097530215,0.1003006150,0.1355071177,-0.0028997827,-0.0786361695,-0.1718005632,-0.0308471229,-0.0236710914,-0.0443988720,-0.0392026573,0.1358215616,-0.0920340537,-0.0159582674,-0.1501897309,-0.0618426474,-0.0667628246,-0.0322885865,0.0642541604,-0.0623986182,-0.0039294146,-0.0700598995,-0.0171876998,-0.0688415551,-0.0433916483,-0.1494014363,0.0759806041,0.0003025549,-0.0190382415,0.1245743900,-0.0606756223,-0.1295361682,-0.0203216004,-0.0070910435,-0.0539460450,-0.0060129761,-0.1337812565,-0.0036546138,-0.0271846005,-0.0231644812,-0.1377946642,0.0160659372,-0.0308258664,0.0322492751,-0.0341640641,-0.1464821674,-0.0165122691,0.1446534864,0.1002721905,-0.0140568861,-0.0272512114,0.1118920355,-0.0338580763]
#dim2=[0.016331135,-0.102386195,-0.035203571,0.020336268,0.023677748,-0.173174677,-0.159070541,-0.091477809,0.084474976,0.046821915,-0.010357577,-0.118934130,0.006876004,-0.016645478,0.009521637,0.147628699,-0.149174677,-0.010058456,-0.037936939,0.115391379,-0.013344690,-0.237680413,-0.028900158,-0.008601118,-0.011716086,0.089740755,0.126043320,0.072036296,-0.001823734,-0.016094808,-0.018788767,0.087574990,0.141573337,-0.015010048,-0.017327881,0.003492040,-0.026539033,0.084434400,0.102231567,-0.135452917,-0.017651754,0.109429222,-0.050801582,0.153550125,-0.073438446,0.173973642,-0.005394310,0.001871797,0.005009904,-0.030162632,-0.181410552,0.035032340,0.152864255,0.004475124,-0.039508864,0.032491663,0.078378419,0.061691686,-0.078319407,-0.067121789,-0.065415770,-0.095536331,0.005861760,-0.145645121,-0.095318157,0.009601629,0.017369874,-0.080315859,0.055384766,-0.004536163,0.005150249,-0.113863343,0.013959918,-0.023621438,0.092389241,-0.009109664,0.006246789,-0.013921736,0.023431474,-0.034317920,0.015707013,-0.027360696,0.006796463,0.113534040,0.112441575,0.002218334,0.044795431,0.131423486,-0.008929001,0.009976747,-0.001044495,-0.102997302,0.123878031,-0.110037332,-0.060465875,-0.146564957,0.046511315,0.066739416,-0.049916284,-0.087243196,0.051867374,-0.231983031,-0.084934497,-0.067895356,-0.079336358,-0.005820823,0.103436627,0.022125491,0.112355400,0.097337134,-0.037991693,0.127510160,-0.009217690,-0.014430765,-0.126132599,0.053865160,-0.025384762,-0.086288877,0.210119881,0.055262328,-0.093345329,-0.179818429,0.058279259,-0.105762638,0.084121487,0.060473225,0.097692507,-0.035854080,0.034669170,0.088971685,0.027555739,0.151048893,0.028008448,0.092719970,-0.028756404,0.007141951,0.025467128,0.062145223,-0.015234162,-0.058689265]

dim=np.array(list(zip(dim1,dim2)))

pops=["BOD", "CAP", "FOG", "KIB", "LOM", "SAN", "TER"]
pops=np.array([item for item in pops for _ in range(20)])
ind_id=np.array(list(range(1,len(pops)+1)))

#clusts=get_KMeans(dim1, 3) #16 left group, 82 middle, 42 right.
#groups=[]
#for g in range(3):
  #sel=np.where(np.in1d(np.array(dim1), clusts[g]))[0]
  #groups.append(dim[sel])
#for g in groups:
  #x=[i[0] for i in g]
  #y=[i[1] for i in g]
  #plt.plot(x,y,".")

clusts=get_agglo(dim1, 3) #16 left group, 82 middle, 42 right.

colors=["purple","green","yellow"]

pop_dic={}
id_dic={}
for c in range(3):
  t=np.where(np.array(clusts) == c)[0]
  print(len(t))
  x=[i[0] for i in dim[t]]
  y=[i[1] for i in dim[t]]
  plt.scatter(x,y,c=colors[c],edgecolors="black")
  avx=sum(x)/len(x)
  ids=pops[t]
  pop_dic[c]=[avx,ids]
  id_dic[c]=[avx,ind_id[t]]
plt.ylabel("PC 2",fontsize=18)
plt.xlabel("PC 1",fontsize=18)
print("made first figure")
plt.savefig(args.df1[:-9]+"_PCA.pdf")

sorted_values = sorted(pop_dic.values(), key=lambda x: x[0]) #sort based on average value along PC1
sorted_values2 = sorted(id_dic.values(), key=lambda x: x[0])

thomoq=sorted_values[0][1]
hetero=sorted_values[1][1]
thomop=sorted_values[2][1]

thomoq2=sorted_values2[0][1]
hetero2=sorted_values2[1][1]
thomop2=sorted_values2[2][1]

if len(thomop) > len(thomoq): #making sure q is assigned to minor allele
  homop=thomop
  homoq=thomoq
  homop2=thomop2
  homoq2=thomoq2
else:
  homoq=thomop
  homop=thomoq
  homoq2=thomop2
  homop2=thomoq2

print("saving homozygote ids")
np.savetxt(args.df1[:-9]+"_homoq_nums.txt",homoq2,fmt="%d")
np.savetxt(args.df1[:-9]+"_homop_nums.txt",homop2,fmt="%d")
#arr = np.loadtxt("test.txt", dtype=int)

#homoq=["BOD","BOD","BOD","CAP","FOG","FOG","FOG","KIB","KIB","LOM","SAN","SAN","SAN","TER","TER","TER"]
#homop=["BOD","BOD","BOD","CAP","CAP","CAP","CAP","CAP","CAP","CAP","CAP","CAP","CAP","FOG","FOG","FOG","FOG","FOG","FOG","FOG","KIB","KIB","KIB","KIB","KIB","KIB","KIB","KIB","KIB","LOM","LOM","LOM","LOM","LOM","LOM","LOM","SAN","SAN","SAN","TER","TER","TER"]
q_dic=Counter(homoq)
p_dic=Counter(homop)
pq_dic={}
pops=["FOG","CAP","KIB","BOD","TER","LOM","SAN"]
per_pops=defaultdict(dict)
for pop in pops:
  one=q_dic[pop]
  two=p_dic[pop]
  three=20-(one+two)
  pq_dic[pop]=three
  per_pops[pop]["one"]= one
  per_pops[pop]["two"]= two
  per_pops[pop]["three"]= three

# Data to plot

f, axs = plt.subplots(1, 7, sharey=True, figsize=(12, 3), subplot_kw=dict(aspect="equal"))

colors=["yellow","green","purple"]

for i,k in enumerate(per_pops.keys()):
  labels = []
  sizes = []
  for x, y in per_pops[k].items():
      labels.append(x)
      sizes.append(y)
  # Plot
  axs[i].pie(sizes, autopct='%1.0f%%', colors=colors)
  axs[i].title.set_text(pops[i])

plt.legend(["Homozygote 1", "Homozygote 2", "Heterozygote"], loc="upper center", ncol=4, bbox_to_anchor=(-3, -0.5, 0.5, 0.5))
plt.savefig(args.df1[:-9]+"_pies.pdf")

from os import P_PGID
llcrnrlon=-130 #lower left corner westness
llcrnrlat=30 #lower left corner northernness
urcrnrlon=-110 #upper right corner westness
urcrnrlat=50 #upper right corner northernness

plt.figure(figsize=(8,8))

p_colors=["yellow","green","purple"]

m = Basemap(
        projection='cyl',
        llcrnrlon=llcrnrlon,
        llcrnrlat=llcrnrlat,
        urcrnrlon=urcrnrlon,
        urcrnrlat=urcrnrlat,
        resolution='l')

m.drawcountries()
m.drawcoastlines()


#pops=["FOG","CAP","KIB","BOD","TER","LOM","SAN"]
pop_coords=[(-124,44.8),(-124.5,42.8),(-123.8,39.6),(-123,38.3),(-122,36.9),(-120.6,34.7),(-117.25,32.6)]

for i,k in enumerate(per_pops.keys()):
  labels = []
  sizes = []
  for x, y in per_pops[k].items():
      labels.append(x)
      sizes.append(y)
  # Plot
  plt.pie(sizes, center=(m(pop_coords[i][0],pop_coords[i][1])), radius=0.8, colors=p_colors,textprops={'fontsize': 8},startangle = -90,wedgeprops={"edgecolor":"k"})#,autopct='%1.0f%%')

  #plt.title(pops[i])

from matplotlib.patches import Patch
legend_elements = [Patch(facecolor=p_colors[0], edgecolor="black",
                         label='Homozygote 1'), Patch(facecolor=p_colors[1], edgecolor="black",
                         label='Homozygote 2'), Patch(facecolor=p_colors[2], edgecolor="black",
                         label='Heterozygote')]
plt.legend(handles=legend_elements, fontsize="12",loc='center',bbox_to_anchor=(0.85,0.85))
#plt.legend(["Homozygote 1", "Homozygote 2", "Heterozygote"], loc="upper center")# ncol=4, bbox_to_anchor=(-3, -0.5, 0.5, 0.5))

#plt.figure(figsize=(10,6))
axis = plt.gca()
axis.set_xlim([llcrnrlon, urcrnrlon])
axis.set_ylim([llcrnrlat, urcrnrlat])
plt.savefig(args.df1[:-9]+"_map.pdf")

from scipy.stats import chisquare

observed_counts = [len(homoq), len(hetero), len(homop)]

p=(len(homop)*2 + len(hetero))/280
q=(len(homoq)*2 + len(hetero))/280
ehomoq = q*q*140 #24, actual 16
ehomop = p*p*140 #49, actual 41
ehete = 2*q*p*140 #68, actual 83

print(ehomoq/len(homoq)) #expected minor is 1.5 more
print(ehomop/len(homop)) #expected major is 1.2 more
print(ehete/len(hetero)) #actual hete is 1.2 more

result = chisquare(f_obs=observed_counts, f_exp=[ehomoq,ehete,ehomop])
print(result)

with open(args.df1[:-9]+"_chi2.txt", "w") as file:
    # Write the variable to the file
    file.write(str(result.pvalue) + "\n")
    file.write(str(ehomoq/len(homoq)) + "\n")
    file.write(str(ehomop/len(homop)) + "\n")
    file.write(str(ehete/len(hetero)) + "\n")

