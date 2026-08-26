# -*- coding: utf-8 -*-
"""Hinh 3: Boxplot l_tt theo 4 phuong phap (M1,M2,M3,M6), voi dai tham chieu chieu dai FEM goc."""
import pandas as pd
import matplotlib
matplotlib.use("Agg")
import matplotlib.pyplot as plt
import matplotlib.font_manager as fm
import os

BASE = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
df = pd.read_csv(os.path.join(BASE, "pile_hz_ltt_results_ALL.csv"))

plt.rcParams["font.family"] = "Times New Roman"
plt.rcParams["font.size"] = 10

methods = ["M1", "M2", "M3", "M6"]
labels = ["M1\n(22TCN 207-92)", "M2\n(20TCN21-86/\nTCXD 205-1998)", "M3\n(TCVN 10304:2014)", "M6\n(Nhật Bản, 2002)"]
data = [df[f"l_tt_{m}"].values for m in methods]

fig, ax = plt.subplots(figsize=(6.0, 4.2), dpi=300)

# reference band: FEM original length range
fem_min, fem_max = df["fem_length_m"].min(), df["fem_length_m"].max()
fem_mean = df["fem_length_m"].mean()
ax.axhspan(fem_min, fem_max, color="0.85", zorder=0, label="Dải chiều dài FEM gốc")
ax.axhline(fem_mean, color="0.5", linestyle="--", linewidth=1.0, zorder=1)

bp = ax.boxplot(data, tick_labels=labels, widths=0.55, patch_artist=True,
                 medianprops=dict(color="black", linewidth=1.3),
                 boxprops=dict(facecolor="white", edgecolor="black", linewidth=1.0),
                 whiskerprops=dict(color="black", linewidth=1.0),
                 capprops=dict(color="black", linewidth=1.0),
                 flierprops=dict(marker="o", markersize=3, markerfacecolor="black", markeredgecolor="none"))

ax.set_ylabel("Chiều dài tính toán $l_{tt}$ (m)")
ax.set_ylim(0, 32)
ax.text(0.5, fem_mean + 0.6, "Trung bình chiều dài FEM gốc (24,54 m)", fontsize=8, color="0.35",
        transform=ax.get_yaxis_transform(), ha="left")
ax.legend(loc="lower right", frameon=False, fontsize=8)
ax.grid(axis="y", linestyle=":", linewidth=0.5, color="0.8", zorder=0)
ax.set_axisbelow(True)

plt.tight_layout()
out = os.path.join(BASE, "figures", "Fig3_boxplot_ltt.png")
os.makedirs(os.path.dirname(out), exist_ok=True)
plt.savefig(out, bbox_inches="tight")
print("Saved:", out)
