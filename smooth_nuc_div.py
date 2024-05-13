import pandas as pd
import numpy as np
from numba import njit, prange
import matplotlib.pyplot as plt
import argparse

parser = argparse.ArgumentParser(description="Description of your script")
parser.add_argument("chr", type=str, help="Chromosome name")
parser.add_argument("--start", type=int, default=0, help="start of region of interest")
parser.add_argument("--stop", type=int, default=0, help="stop of region of interest")
parser.add_argument("--calc", type=bool, default=True, help="whether to calculate smooth or load")
args = parser.parse_args()

fname="~/EG2023/structural_variation/backup/filtered_vcf/nuc_div"+args.chr+"_filtered_nuc_div.sites.pi"

df = pd.read_csv(fname, sep="\t")
xs = df["POS"].values.astype(np.float64)
ys = df["PI"].values.astype(np.float64)
sigma = 40_000.0

ixs = np.argsort(xs)
xs = xs[ixs]
ys = ys[ixs]

def norm01(xs):
    m, M = xs.min(), xs.max()
    return (xs - m) / (M - m)


@njit("f8(f8, f8, f8)")
def gauss_single(x, mu, sigma=1.0):
    c = 1 / (sigma * np.sqrt(2 * np.pi))
    return c * np.exp(-0.5 * (((x - mu) / sigma) ** 2))


@njit("f8[:](f8[:], f8, f8)")
def gauss_ker(xs, mu, sigma=1.0):
    c = 1 / (sigma * np.sqrt(2 * np.pi))
    return c * np.exp(-0.5 * (((xs - mu) / sigma) ** 2))


@njit("f8[:](f8[:], f8[:], f8)", parallel=True)
def gauss_dumb(xs, ys, sigma=1.0):
    smoothed = np.empty_like(xs)
    for i in prange(len(xs)):
        smoothed[i] = np.mean(ys * gauss_ker(xs, xs[i], sigma=sigma))
    return smoothed


@njit("f8[:](f8[:], f8[:], f8, f8)", parallel=True)
def gauss_smart(xs, ys, sigma=1.0, th=1e-8):
    smoothed = np.empty_like(ys)
    N = xs.shape[0]
    for i in prange(N):
        mu = xs[i]
        acc = 0.0
        npoints = 0
        # to the right
        for j in range(i, N):
            g = gauss_single(x=xs[j], mu=mu, sigma=sigma)
            acc += ys[j] * g
            npoints += 1
            if g < th:
                break
        # to the left
        for j in range(i - 1, -1, -1):
            g = gauss_single(x=xs[j], mu=mu, sigma=sigma)
            acc += ys[j] * g
            npoints += 1
            if g < th:
                break
        smoothed[i] = acc / N
    return smoothed


plt.figure(figsize=(14, 6))

if args.calc:
    smooth = gauss_smart(xs, ys, sigma, 1e-8)
    np.save(fname + "_smooth.npy", smooth)
else:
    smooth=np.load(fname + "_smooth.npy")

plt.plot(xs, smooth, label=f"{sigma}", color="black")

plt.tight_layout()
plt.savefig(fname + "_nuc_plot.pdf")

if args.stop == 0 and args.start == 0:
    print("No specific region highlighted")
else:
    smooth = np.load(fname + "_smooth.npy")

    plt.figure(figsize=(14, 6))
    plt.plot(xs, smooth, ",", label=f"{sigma}", color="black")
    a, b = args.start, args.stop

    v1 = smooth[np.where((xs < a))]
    v2 = smooth[np.where((a < xs) & (xs < b))]
    v3 = smooth[np.where((b < xs))]

    m = np.min([v1.mean(), v2.mean(), v3.mean()])
    M = np.max([v1.mean(), v2.mean(), v3.mean()])

    plt.plot(
        np.linspace(0, a, len(v1)),
        np.ones(len(v1)) * v1.mean(),
        color="red",
    )
    plt.plot(
        np.linspace(a, b, len(v2)),
        np.ones(len(v2)) * v2.mean(),
        color="red",
    )
    plt.plot(
        np.linspace(b, c, len(v3)),
        np.ones(len(v3)) * v3.mean(),
        color="red",
    )
    plt.plot(
        np.linspace(c, d, len(v4)),
        np.ones(len(v4)) * v4.mean(),
        color="red",
    )
    plt.plot(
        np.linspace(d, xs.max(), len(v5)),
        np.ones(len(v5)) * v5.mean(),
        color="red",
    )
    plt.axvline(a, color="orange")
    plt.axvline(b, color="orange")
    plt.axvline(c, color="blue")
    plt.axvline(d, color="blue")
    plt.ylim(m / 2, M * 2)
    plt.xlim(0, xs.max())
    plt.tight_layout()
    plt.savefig(fname + "_nuc_plot_wregion.pdf")

