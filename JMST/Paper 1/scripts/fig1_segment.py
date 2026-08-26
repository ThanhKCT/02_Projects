# -*- coding: utf-8 -*-
"""Hinh 1: So do phan doan ben 75m trong tuyen ben 750m (10 phan doan)."""
import matplotlib
matplotlib.use("Agg")
import matplotlib.pyplot as plt
import matplotlib.patches as patches
import os

BASE = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
plt.rcParams["font.family"] = "Times New Roman"
plt.rcParams["font.size"] = 10

fig, ax = plt.subplots(figsize=(7.2, 2.6), dpi=300)

n_seg = 10
seg_w = 1.0
study_idx = 4  # highlighted segment (0-based)

for i in range(n_seg):
    color = "0.55" if i == study_idx else "white"
    rect = patches.Rectangle((i * seg_w, 0), seg_w, 1.0, facecolor=color,
                              edgecolor="black", linewidth=1.0)
    ax.add_patch(rect)
    ax.text(i * seg_w + seg_w / 2, 0.5, f"{i+1}", ha="center", va="center",
             fontsize=9, color="white" if i == study_idx else "black")

# overall dimension line
y_dim = 1.35
ax.annotate("", xy=(n_seg * seg_w, y_dim), xytext=(0, y_dim),
            arrowprops=dict(arrowstyle="<->", linewidth=0.9))
ax.text(n_seg * seg_w / 2, y_dim + 0.10, "Tuyến bến 750 m (10 phân đoạn)",
        ha="center", va="bottom", fontsize=9.5)

# highlighted segment callout
ax.annotate("Phân đoạn tiêu chuẩn\n~75 m — mô hình 3D\ncủa nghiên cứu này",
            xy=(study_idx * seg_w + seg_w / 2, 0), xytext=(study_idx * seg_w + seg_w / 2, -0.95),
            ha="center", va="top", fontsize=9,
            arrowprops=dict(arrowstyle="->", linewidth=0.9))

ax.set_xlim(-0.3, n_seg * seg_w + 0.3)
ax.set_ylim(-1.6, 1.7)
ax.axis("off")

plt.tight_layout()
out = os.path.join(BASE, "figures", "Fig1_segment_scope.png")
os.makedirs(os.path.dirname(out), exist_ok=True)
plt.savefig(out, bbox_inches="tight")
print("Saved:", out)
