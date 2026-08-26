# -*- coding: utf-8 -*-
"""
Doc ket qua tho tu sap_work/results/{joint_disp,pile_force}_{METHOD}.csv
cho BASE + M1/M2/M3/M6, tinh:
  - U_X_max, U_Y_max (max |U1|,|U2| tren 192 joint dinh coc, envelope BAO KT)
  - M_max, V_max (max sqrt(M2^2+M3^2), sqrt(V2^2+V3^2) tren 178 coc treatment,
    tren moi station, envelope BAO KT)
  - S_R = (|R_max|-|R_min|)/|R_min| * 100%  giua 4 phuong phap (M1/M2/M3/M6)
    (KHONG tinh S_R so voi BASE -- S_R danh gia do nhay GIUA cac phuong phap fixity)
  - cung bao cao % chenh lech tuyet doi so voi BASE cho tham khao

Output: table6_sensitivity_summary.csv (main dir), + governing pile mid data.
"""
import pandas as pd
import numpy as np
import os

BASE_DIR = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
RESULTS_DIR = os.path.join(BASE_DIR, "sap_work", "results")

RUN_ORDER = ["BASE", "M1", "M2", "M3", "M6"]

def load_disp(method):
    path = os.path.join(RESULTS_DIR, f"joint_disp_{method}.csv")
    df = pd.read_csv(path)
    return df

def load_force(method):
    path = os.path.join(RESULTS_DIR, f"pile_force_{method}.csv")
    df = pd.read_csv(path)
    df["M_res"] = np.sqrt(df["M2"]**2 + df["M3"]**2)
    df["V_res"] = np.sqrt(df["V2"]**2 + df["V3"]**2)
    return df

def main():
    rows = []
    per_pile_M = {}
    per_pile_V = {}
    governing_joint = {}

    for method in RUN_ORDER:
        df_d = load_disp(method)
        df_f = load_force(method)

        ux_idx = df_d["U1"].abs().idxmax()
        uy_idx = df_d["U2"].abs().idxmax()
        ux_max = df_d["U1"].abs().max()
        uy_max = df_d["U2"].abs().max()
        governing_joint[method] = {
            "U_X_joint": int(df_d.loc[ux_idx, "joint"]),
            "U_Y_joint": int(df_d.loc[uy_idx, "joint"]),
        }

        # per-pile max resultant M and V (across stations & Max/Min steptype)
        pile_M = df_f.groupby("frame")["M_res"].max()
        pile_V = df_f.groupby("frame")["V_res"].max()
        per_pile_M[method] = pile_M
        per_pile_V[method] = pile_V

        m_max = pile_M.max()
        m_mean = pile_M.mean()
        m_median = pile_M.median()
        gov_pile_M = pile_M.idxmax()

        v_max = pile_V.max()
        v_mean = pile_V.mean()
        v_median = pile_V.median()
        gov_pile_V = pile_V.idxmax()

        rows.append({
            "method": method,
            "U_X_max_m": ux_max, "U_Y_max_m": uy_max,
            "M_max_Tm": m_max, "M_mean_Tm": m_mean, "M_median_Tm": m_median,
            "governing_pile_M": gov_pile_M,
            "V_max_T": v_max, "V_mean_T": v_mean, "V_median_T": v_median,
            "governing_pile_V": gov_pile_V,
        })

    summary = pd.DataFrame(rows).set_index("method")
    print(summary.to_string())
    summary.to_csv(os.path.join(BASE_DIR, "table6_response_summary.csv"))

    # sensitivity S_R among the 4 methods only (exclude BASE)
    m4 = summary.loc[["M1", "M2", "M3", "M6"]]

    def s_r(series):
        vals = series.abs()
        return (vals.max() - vals.min()) / vals.min() * 100.0

    sr = {}
    for col in ["U_X_max_m", "U_Y_max_m", "M_max_Tm", "V_max_T"]:
        sr[col] = s_r(m4[col])
    print("\nSensitivity S_R (%) among M1/M2/M3/M6:")
    for k, v in sr.items():
        print(f"  {k}: {v:.2f}%")

    pd.Series(sr, name="S_R_percent").to_csv(os.path.join(BASE_DIR, "table6_SR_summary.csv"))

    # also % diff vs BASE for reference
    base = summary.loc["BASE"]
    pct_vs_base = {}
    for method in ["M1", "M2", "M3", "M6"]:
        pct_vs_base[method] = {
            col: (abs(summary.loc[method, col]) - abs(base[col])) / abs(base[col]) * 100.0
            for col in ["U_X_max_m", "U_Y_max_m", "M_max_Tm", "V_max_T"]
        }
    pd.DataFrame(pct_vs_base).T.to_csv(os.path.join(BASE_DIR, "table6_pctdiff_vs_BASE.csv"))

    print("\nWrote table6_response_summary.csv, table6_SR_summary.csv, table6_pctdiff_vs_BASE.csv")

if __name__ == "__main__":
    main()
