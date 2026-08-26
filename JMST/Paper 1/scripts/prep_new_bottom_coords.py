# -*- coding: utf-8 -*-
"""
Tinh toa do 3D moi cua chan coc (bottom_joint) cho 178 coc treatment,
theo tung phuong phap M1/M2/M3/M6, dua tren l_tt da tinh san.

new_bottom = top + l_tt * unit_vector(bottom_orig - top)

Input:
  pile_master_table.csv        (192 coc, top/bot coords goc, bottom_joint id)
  pile_hz_ltt_results_ALL.csv  (178 coc treatment, l_tt_M1..M6)

Output:
  new_bottom_coords.csv  (178 dong x [frame, bottom_joint, top_joint,
                           orig_bot_X/Y/Z, method, new_X, new_Y, new_Z, l_tt])
"""
import pandas as pd
import numpy as np
import os

BASE = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))

master = pd.read_csv(os.path.join(BASE, "pile_master_table.csv"))
ltt = pd.read_csv(os.path.join(BASE, "pile_hz_ltt_results_ALL.csv"))

master.columns = [c.strip() for c in master.columns]
ltt.columns = [c.strip() for c in ltt.columns]

methods = ["M1", "M2", "M3", "M6"]

# merge tren frame id
df = ltt[["frame", "l_tt_M1", "l_tt_M2", "l_tt_M3", "l_tt_M6"]].merge(
    master[["frame", "top_joint", "bottom_joint", "top_X", "top_Y", "top_Z",
             "bot_X", "bot_Y", "bot_Z", "status"]],
    on="frame", how="left"
)

assert len(df) == 178, f"Expected 178 treatment piles, got {len(df)}"
assert df["bottom_joint"].notna().all(), "Missing bottom_joint for some treatment piles"
assert (df["status"] == "treatment_spring").all(), "Non-treatment pile leaked into ltt table"

rows = []
for _, r in df.iterrows():
    top = np.array([r.top_X, r.top_Y, r.top_Z], dtype=float)
    bot0 = np.array([r.bot_X, r.bot_Y, r.bot_Z], dtype=float)
    axis_vec = bot0 - top
    L = np.linalg.norm(axis_vec)
    u = axis_vec / L
    for m in methods:
        l_tt = r[f"l_tt_{m}"]
        new_pt = top + l_tt * u
        rows.append({
            "frame": int(r.frame),
            "top_joint": int(r.top_joint),
            "bottom_joint": int(r.bottom_joint),
            "orig_bot_X": r.bot_X, "orig_bot_Y": r.bot_Y, "orig_bot_Z": r.bot_Z,
            "fem_length_m": L,
            "method": m,
            "l_tt": l_tt,
            "new_X": new_pt[0], "new_Y": new_pt[1], "new_Z": new_pt[2],
        })

out = pd.DataFrame(rows)

# sanity: l_tt phai nho hon fem_length (diem ngam nam giua doan coc mo hinh)
bad = out[out["l_tt"] >= out["fem_length_m"]]
if len(bad):
    print(f"[WARN] {len(bad)} dong co l_tt >= fem_length_m (diem ngam vuot qua mui coc):")
    print(bad[["frame", "method", "l_tt", "fem_length_m"]])

out_path = os.path.join(BASE, "new_bottom_coords.csv")
out.to_csv(out_path, index=False)
print(f"Wrote {len(out)} rows ({len(df)} piles x {len(methods)} methods) -> {out_path}")
print(out.groupby("method")["l_tt"].describe())
