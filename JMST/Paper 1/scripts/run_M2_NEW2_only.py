# -*- coding: utf-8 -*-
"""
Chay rieng phuong phap M2_NEW2 (TCVN 10304:2025, K=1350 kN/m4 -- gia tri bien tai IL=1.0
cua Bang A.1 muc 4, vi do sệt B thuc do cua Lop 2 = 1.19 (Thuyet minh 06.12.doc,
Bang tong hop chi tieu co ly) vuot qua can tren 1.0 cua bang) tren working model
sap_work/Ben100kDWT_sensitivity.sdb.

BASE/M1/M3(=cu M6, khong doi cong thuc) da co ket qua san trong sap_work/results/,
KHONG chay lai. Script nay CHI:
  - Mo model (working copy)
  - Di chuyen 178 bottom_joint toi vi tri moi theo M2_NEW2
  - RunAnalysis
  - Trich JointDispl (192 pile-top joints) + FrameForce (178 treatment frames), envelope BAO KT
  - Luu sap_work/results/joint_disp_M2_NEW2.csv, pile_force_M2_NEW2.csv
  - Restore 178 bottom_joint ve toa do goc
  - Dong SAP2000 (khong save)
"""
import win32com.client
import pandas as pd
import numpy as np
import os
import time

BASE_DIR = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
RESULTS_DIR = os.path.join(BASE_DIR, "sap_work", "results")
MODEL_PATH = os.path.join(BASE_DIR, "sap_work", "Ben100kDWT_sensitivity.sdb")
os.makedirs(RESULTS_DIR, exist_ok=True)


def log(msg):
    print(f"[{time.strftime('%H:%M:%S')}] {msg}", flush=True)


def move_points(SapModel, moves):
    for joint, dx, dy, dz in moves:
        SapModel.SelectObj.ClearSelection()
        ret = SapModel.PointObj.SetSelected(joint, True)
        if ret != 0:
            raise RuntimeError(f"SetSelected failed for joint {joint}, ret={ret}")
        ret = SapModel.EditGeneral.Move(dx, dy, dz)
        if ret != 0:
            raise RuntimeError(f"Move failed for joint {joint}, ret={ret}")
    SapModel.SelectObj.ClearSelection()


def extract_joint_displ(SapModel, joint_ids):
    rows = []
    args = (0, [], [], [], [], [], [], [], [], [], [], [])
    for j in joint_ids:
        res = SapModel.Results.JointDispl(str(j), 0, *args)
        ret = res[0]
        n = res[1]
        if ret != 0 or n == 0:
            continue
        Obj, Elm, LoadCase, StepType, StepNum, U1, U2, U3, R1, R2, R3 = res[2:13]
        for i in range(n):
            rows.append({
                "joint": j, "load_case": LoadCase[i], "step_type": StepType[i],
                "U1": U1[i], "U2": U2[i], "U3": U3[i],
                "R1": R1[i], "R2": R2[i], "R3": R3[i],
            })
    return pd.DataFrame(rows)


def extract_frame_force(SapModel, frame_ids):
    rows = []
    fargs = (0, [], [], [], [], [], [], [], [], [], [], [], [], [])
    for f in frame_ids:
        res = SapModel.Results.FrameForce(str(f), 0, *fargs)
        ret = res[0]
        n = res[1]
        if ret != 0 or n == 0:
            continue
        Obj, ObjSta, Elm, ElmSta, LoadCase, StepType, StepNum, P, V2, V3, T, M2, M3 = res[2:15]
        for i in range(n):
            rows.append({
                "frame": f, "station": ObjSta[i], "load_case": LoadCase[i],
                "step_type": StepType[i],
                "P": P[i], "V2": V2[i], "V3": V3[i], "T": T[i], "M2": M2[i], "M3": M3[i],
            })
    return pd.DataFrame(rows)


def main():
    log("Creating Helper / starting SAP2000...")
    helper = win32com.client.Dispatch("SAP2000v1.Helper")
    mySapObject = helper.CreateObjectProgID("CSI.SAP2000.API.SapObject")
    ret = mySapObject.ApplicationStart(12, True, "")  # 12 = Tonf-m-C per connect_test.py
    log(f"ApplicationStart ret={ret}")
    SapModel = mySapObject.SapModel

    log(f"Opening working model: {MODEL_PATH}")
    t0 = time.time()
    ret = SapModel.File.OpenFile(MODEL_PATH)
    log(f"OpenFile ret={ret}, took {time.time()-t0:.1f}s")
    if ret != 0:
        raise RuntimeError("OpenFile failed")

    npt0 = SapModel.PointObj.Count()
    nfr0 = SapModel.FrameObj.Count()
    log(f"Baseline counts: PointObj={npt0}, FrameObj={nfr0}")

    master = pd.read_csv(os.path.join(BASE_DIR, "pile_master_table.csv"))
    master.columns = [c.strip() for c in master.columns]
    new_coords = pd.read_csv(os.path.join(BASE_DIR, "new_bottom_coords_M2NEW2.csv"))

    all_top_joints = sorted(master["top_joint"].unique().tolist())
    treatment_frames = sorted(new_coords["frame"].unique().tolist())
    log(f"192-pile top joints: {len(all_top_joints)}. Treatment frames: {len(treatment_frames)}.")

    log("Unlocking + moving 178 bottom joints -> M2_NEW2 positions...")
    ret = SapModel.SetModelIsLocked(False)
    moves = []
    for _, r in new_coords.iterrows():
        dx = r["new_X"] - r["orig_bot_X"]
        dy = r["new_Y"] - r["orig_bot_Y"]
        dz = r["new_Z"] - r["orig_bot_Z"]
        moves.append((int(r["bottom_joint"]), dx, dy, dz))
    t0 = time.time()
    move_points(SapModel, moves)
    log(f"Moved {len(moves)} joints in {time.time()-t0:.1f}s")

    npt = SapModel.PointObj.Count()
    nfr = SapModel.FrameObj.Count()
    if npt != npt0 or nfr != nfr0:
        raise RuntimeError(f"COUNT MISMATCH after moving joints: PointObj {npt0}->{npt}, FrameObj {nfr0}->{nfr}")
    log(f"Count check OK (PointObj={npt}, FrameObj={nfr})")

    log("Setting Results.Setup for BAO KT combo...")
    SapModel.Results.Setup.DeselectAllCasesAndCombosForOutput()
    SapModel.Results.Setup.SetComboSelectedForOutput("BAO KT")

    t0 = time.time()
    ret = SapModel.Analyze.RunAnalysis()
    log(f"RunAnalysis ret={ret}, took {time.time()-t0:.1f}s")
    if ret != 0:
        raise RuntimeError(f"RunAnalysis failed, ret={ret}")

    SapModel.Results.Setup.DeselectAllCasesAndCombosForOutput()
    SapModel.Results.Setup.SetComboSelectedForOutput("BAO KT")

    log("Extracting JointDispl for 192 top joints...")
    t0 = time.time()
    df_disp = extract_joint_displ(SapModel, all_top_joints)
    log(f"  -> {len(df_disp)} rows in {time.time()-t0:.1f}s")
    df_disp.to_csv(os.path.join(RESULTS_DIR, "joint_disp_M2_NEW2.csv"), index=False)

    log("Extracting FrameForce for 178 treatment frames...")
    t0 = time.time()
    df_force = extract_frame_force(SapModel, treatment_frames)
    log(f"  -> {len(df_force)} rows in {time.time()-t0:.1f}s")
    df_force.to_csv(os.path.join(RESULTS_DIR, "pile_force_M2_NEW2.csv"), index=False)

    if len(df_disp):
        log(f"  Summary: U_X_max={df_disp['U1'].abs().max():.4f}, U_Y_max={df_disp['U2'].abs().max():.4f}")
    if len(df_force):
        df_force["M_res"] = np.sqrt(df_force["M2"] ** 2 + df_force["M3"] ** 2)
        df_force["V_res"] = np.sqrt(df_force["V2"] ** 2 + df_force["V3"] ** 2)
        log(f"  Summary: M_max={df_force['M_res'].max():.4f}, V_max={df_force['V_res'].max():.4f}")

    log("Restoring 178 bottom joints to original coordinates...")
    ret = SapModel.SetModelIsLocked(False)
    restore_moves = [(j, -dx, -dy, -dz) for (j, dx, dy, dz) in moves]
    move_points(SapModel, restore_moves)
    npt = SapModel.PointObj.Count()
    nfr = SapModel.FrameObj.Count()
    if npt != npt0 or nfr != nfr0:
        raise RuntimeError(f"COUNT MISMATCH after restoring joints: PointObj {npt0}->{npt}, FrameObj {nfr0}->{nfr}")
    spot = new_coords.iloc[0]
    chk = SapModel.PointObj.GetCoordCartesian(str(int(spot["bottom_joint"])), 0, 0, 0)
    if (abs(chk[1] - spot["orig_bot_X"]) > 1e-6 or abs(chk[2] - spot["orig_bot_Y"]) > 1e-6
            or abs(chk[3] - spot["orig_bot_Z"]) > 1e-6):
        raise RuntimeError(f"Restore spot-check FAILED: {chk} vs orig {spot['orig_bot_X'], spot['orig_bot_Y'], spot['orig_bot_Z']}")
    log("Restored and spot-checked OK.")

    log("Closing SAP2000 (no save)...")
    mySapObject.ApplicationExit(False)
    log("[ALL DONE]")


if __name__ == "__main__":
    main()
