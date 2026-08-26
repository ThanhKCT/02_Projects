# -*- coding: utf-8 -*-
"""
Hinh 4 (4 panel): (a) mat bang 178 coc treatment + 14 coc control, danh dau coc 140;
(b) l_tt trung binh (4 phuong phap) theo vi tri Y cua coc;
(c) M_max (max qua 4 phuong phap) theo vi tri Y cua coc;
(d) V_max (max qua 4 phuong phap) theo vi tri Y cua coc.
"""
import pandas as pd
import numpy as np
import matplotlib
matplotlib.use("Agg")
import matplotlib.pyplot as plt
import os

BASE = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
RESULTS_DIR = os.path.join(BASE, "sap_work", "results")

plt.rcParams["font.family"] = "Times New Roman"
plt.rcParams["font.size"] = 10

master = pd.read_csv(os.path.join(BASE, "pile_master_table.csv"))
master.columns = [c.strip() for c in master.columns]
ltt = pd.read_csv(os.path.join(BASE, "pile_hz_ltt_results_ALL.csv"))

METHODS = ["M1", "M2", "M3", "M6"]
GOV_PILE = 140

# --- per-pile max M_res / V_res across the 4 methods ---
per_method_M = {}
per_method_V = {}
for m in METHODS:
    df = pd.read_csv(os.path.join(RESULTS_DIR, f"pile_force_{m}.csv"))
    df["M_res"] = np.sqrt(df["M2"]**2 + df["M3"]**2)
    df["V_res"] = np.sqrt(df["V2"]**2 + df["V3"]**2)
    per_method_M[m] = df.groupby("frame")["M_res"].max()
    per_method_V[m] = df.groupby("frame")["V_res"].max()

M_df = pd.DataFrame(per_method_M)
V_df = pd.DataFrame(per_method_V)
M_df["M_max_across4"] = M_df.max(axis=1)
V_df["V_max_across4"] = V_df.max(axis=1)

ltt["l_tt_mean4"] = ltt[[f"l_tt_{m}" for m in METHODS]].mean(axis=1)

# merge everything on frame
plot_df = ltt[["frame", "l_tt_mean4"]].merge(
    M_df[["M_max_across4"]].reset_index(), on="frame", how="left"
).merge(
    V_df[["V_max_across4"]].reset_index(), on="frame", how="left"
).merge(
    master[["frame", "top_X", "top_Y", "pile_type", "status"]], on="frame", how="left"
)

control = master[master["status"] != "treatment_spring"]

fig, axes = plt.subplots(2, 2, figsize=(7.5, 6.6), dpi=300)
ax_a, ax_b, ax_c, ax_d = axes[0, 0], axes[0, 1], axes[1, 0], axes[1, 1]

# --- Panel (a): plan view ---
ax_a.scatter(plot_df["top_X"], plot_df["top_Y"], s=14, facecolor="0.6", edgecolor="0.3",
             linewidth=0.4, label="178 cọc treatment", zorder=2)
ax_a.scatter(control["top_X"], control["top_Y"], s=22, marker="^", facecolor="black",
             edgecolor="black", label="14 cọc control", zorder=2)
gov = plot_df[plot_df["frame"] == GOV_PILE]
ax_a.scatter(gov["top_X"], gov["top_Y"], s=90, marker="*", facecolor="none",
             edgecolor="black", linewidth=1.3, label=f"Cọc {GOV_PILE} (governing)", zorder=3)
ax_a.set_xlabel("Tọa độ X (m)")
ax_a.set_ylabel("Tọa độ Y (m)")
ax_a.set_title("(a) Mặt bằng bố trí cọc", fontsize=10)
ax_a.legend(loc="upper center", bbox_to_anchor=(0.5, -0.18), ncol=1, frameon=False, fontsize=8)
ax_a.set_aspect("auto")
ax_a.grid(linestyle=":", linewidth=0.5, color="0.85")

def scatter_by_Y(ax, ycol, ylabel, title, fmt="{:.1f}"):
    ax.scatter(plot_df["top_Y"], plot_df[ycol], s=14, facecolor="0.6", edgecolor="0.3",
               linewidth=0.4, zorder=2)
    g = plot_df[plot_df["frame"] == GOV_PILE]
    ax.scatter(g["top_Y"], g[ycol], s=90, marker="*", facecolor="none",
               edgecolor="black", linewidth=1.3, zorder=3)
    ax.annotate(f"Cọc {GOV_PILE}", (g["top_Y"].values[0], g[ycol].values[0]),
                textcoords="offset points", xytext=(6, 6), fontsize=8)
    ax.set_xlabel("Tọa độ Y của cọc (m)")
    ax.set_ylabel(ylabel)
    ax.set_title(title, fontsize=10)
    ax.grid(linestyle=":", linewidth=0.5, color="0.85")

scatter_by_Y(ax_b, "l_tt_mean4", "$l_{tt}$ trung bình 4 PP (m)", "(b) Chiều dài tính toán theo vị trí cọc")
scatter_by_Y(ax_c, "M_max_across4", "$M_{max}$ (T.m)", "(c) Mô men lớn nhất theo vị trí cọc (max 4 PP)")
scatter_by_Y(ax_d, "V_max_across4", "$V_{max}$ (T)", "(d) Lực cắt lớn nhất theo vị trí cọc (max 4 PP)")

plt.tight_layout()
out = os.path.join(BASE, "figures", "Fig4_spatial_sensitivity.png")
os.makedirs(os.path.dirname(out), exist_ok=True)
plt.savefig(out, bbox_inches="tight")
print("Saved:", out)
print(plot_df.sort_values("M_max_across4", ascending=False).head(8)[["frame","top_X","top_Y","l_tt_mean4","M_max_across4","V_max_across4"]])
