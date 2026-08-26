# -*- coding: utf-8 -*-
"""Hinh 2: So do nguyen ly diem ngam tuong duong cua coc (H0, h_gd, h_z, l_tt, mai doc, huong luc)."""
import matplotlib
matplotlib.use("Agg")
import matplotlib.pyplot as plt
import matplotlib.patches as patches
import numpy as np
import os

BASE = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
plt.rcParams["font.family"] = "Times New Roman"
plt.rcParams["font.size"] = 10.5

fig, ax = plt.subplots(figsize=(5.6, 6.6), dpi=300)

x_pile = 0.0
top_y = 0.0          # dinh coc (cao trinh dinh ben)
slope_y_at_pile = -2.0   # giao diem mai doc - tim coc (H0 duoi dinh)
h_gd = 1.1               # hieu chinh mat phang gia dinh
assumed_ground_y = slope_y_at_pile - h_gd
h_z = 2.6
fixity_y = assumed_ground_y - h_z
pile_bottom_y = fixity_y - 1.3

# --- deck / pile cap block ---
ax.add_patch(patches.Rectangle((x_pile - 1.1, top_y), 2.2, 0.5, facecolor="0.75",
                                edgecolor="black", linewidth=1.0, zorder=3))
ax.text(0, top_y + 0.25, "Đài cọc / đỉnh bến", ha="center", va="center", fontsize=9)

# --- pile (thick vertical line) ---
ax.plot([x_pile, x_pile], [top_y, pile_bottom_y], color="black", linewidth=3.5, zorder=2,
        solid_capstyle="butt")

# --- sloped mudline (mai doc) ---
xs = np.linspace(-2.6, 2.6, 10)
ys = slope_y_at_pile + 0.30 * (xs - x_pile)  # nghieng
ax.plot(xs, ys, color="0.35", linewidth=1.3, zorder=1)
ax.fill_between(xs, ys, ys.min() - 1.0, color="0.90", zorder=0)
ax.text(2.15, slope_y_at_pile + 0.30 * (2.15) + 0.12, "Mái dốc", fontsize=9, color="0.3")

# --- assumed horizontal plane (mat phang gia dinh) ---
ax.plot([-2.6, 2.6], [assumed_ground_y, assumed_ground_y], color="0.45", linestyle="--", linewidth=1.0, zorder=1)
ax.text(1.55, assumed_ground_y + 0.10, "Mặt phẳng giả định", fontsize=8.5, color="0.35", ha="left")

# --- equivalent fixity point (fixed support hatch) ---
ax.plot(x_pile, fixity_y, marker="o", markersize=6, markerfacecolor="black",
        markeredgecolor="black", zorder=4)
hatch_w = 0.5
for k in range(5):
    xx = x_pile - hatch_w / 2 + k * (hatch_w / 4)
    ax.plot([xx, xx - 0.15], [fixity_y - 0.02, fixity_y - 0.22], color="black", linewidth=0.8, zorder=4)
ax.plot([x_pile - hatch_w / 2, x_pile + hatch_w / 2], [fixity_y, fixity_y], color="black", linewidth=1.2, zorder=4)

# --- lateral force P at pile top ---
ax.annotate("", xy=(x_pile + 1.4, top_y + 0.25), xytext=(x_pile + 0.35, top_y + 0.25),
            arrowprops=dict(arrowstyle="->", linewidth=1.6, color="black"), zorder=5)
ax.text(x_pile + 1.5, top_y + 0.25, "$P$", fontsize=12, va="center")

# --- dimension lines (offset to the left) ---
dim_x = -3.5

def dim(y0, y1, label, xoff=dim_x):
    ax.annotate("", xy=(xoff, y1), xytext=(xoff, y0),
                arrowprops=dict(arrowstyle="<->", linewidth=0.9, color="black"))
    ax.text(xoff - 0.15, (y0 + y1) / 2, label, ha="right", va="center", fontsize=10)

dim(top_y, slope_y_at_pile, "$H_0$", xoff=-3.5)
dim(slope_y_at_pile, assumed_ground_y, "$h_{gđ}$", xoff=-2.55)
dim(assumed_ground_y, fixity_y, "$h_z$", xoff=-1.75)

# overall l_tt bracket (right side)
dim(top_y, fixity_y, "$l_{tt}$", xoff=4.3)

# labels for key points
ax.plot(x_pile, top_y, marker="o", markersize=4, color="black", zorder=5)
ax.text(0.15, top_y - 0.05, "Đỉnh cọc", fontsize=8.5, va="top")
ax.text(0.15, slope_y_at_pile - 0.05, "Giao điểm mái dốc–tim cọc", fontsize=8.5, va="top")
ax.text(0.35, fixity_y - 0.05, "Điểm ngàm tương đương", fontsize=9, va="top", fontweight="bold")

ax.set_xlim(-4.3, 5.4)
ax.set_ylim(pile_bottom_y - 0.4, top_y + 1.0)
ax.axis("off")

plt.tight_layout()
out = os.path.join(BASE, "figures", "Fig2_fixity_concept.png")
os.makedirs(os.path.dirname(out), exist_ok=True)
plt.savefig(out, bbox_inches="tight")
print("Saved:", out)
