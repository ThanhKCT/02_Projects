# -*- coding: utf-8 -*-
"""
Script chinh: attach vao SAP2000 dang mo (model working copy da Save As),
lan luot chay BASE + M1 + M2 + M3 + M6, moi lan:
  - (tru BASE) di chuyen 178 bottom_joint toi vi tri moi theo phuong phap
  - RunAnalysis
  - trich JointDispl cho 192 pile-top joints (U_X, U_Y, envelope BAO KT)
  - trich FrameForce cho 178 treatment pile frames (M2,M3,V2,V3, envelope BAO KT)
  - luu ket qua tho + tom tat vao sap_work/results/
  - (tru BASE) restore 178 bottom_joint ve vi tri goc truoc khi qua phuong phap ke

KHONG dong SAP2000 giua cac buoc. Dong 1 lan duy nhat o cuoi (khong save).
"""
import win32com.client
import pandas as pd
import numpy as np
import os
import time
import json

BASE_DIR = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
RESULTS_DIR = os.path.join(BASE_DIR, "sap_work", "results")
os.makedirs(RESULTS_DIR, exist_ok=True)

METHODS = ["M1", "M2", "M3", "M6"]
RUN_ORDER = ["BASE"] + METHODS

def log(msg):
    print(f"[{time.strftime('%H:%M:%S')}] {msg}", flush=True)

def attach():
    helper = win32com.client.Dispatch("SAP2000v1.Helper")
    mySapObject = helper.GetObject("CSI.SAP2000.API.SapObject")
    return mySapObject, mySapObject.SapModel

def move_points(SapModel, moves):
    """moves: list of (joint_name, dx, dy, dz) - moi joint di chuyen rieng le."""
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
    """Tra ve DataFrame: joint, load_case, step_type, U1,U2,U3,R1,R2,R3"""
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
    """Tra ve DataFrame: frame, station, load_case, step_type, P,V2,V3,T,M2,M3"""
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
    log("Attaching to running SAP2000 instance...")
    mySapObject, SapModel = attach()

    log("Loading input data...")
    master = pd.read_csv(os.path.join(BASE_DIR, "pile_master_table.csv"))
    master.columns = [c.strip() for c in master.columns]
    new_coords = pd.read_csv(os.path.join(BASE_DIR, "new_bottom_coords.csv"))

    all_top_joints = sorted(master["top_joint"].unique().tolist())
    treatment_frames = sorted(new_coords["frame"].unique().tolist())
    log(f"192-pile top joints: {len(all_top_joints)} unique. Treatment frames: {len(treatment_frames)}.")

    # map frame -> bottom_joint, orig coords (for restore)
    orig_map = master.set_index("frame")[["bottom_joint", "bot_X", "bot_Y", "bot_Z"]]

    ret_setup1 = SapModel.Results.Setup.DeselectAllCasesAndCombosForOutput()
    ret_setup2 = SapModel.Results.Setup.SetComboSelectedForOutput("BAO KT")
    log(f"Results.Setup configured for BAO KT (ret={ret_setup1},{ret_setup2})")

    summary = {}
    npt0 = SapModel.PointObj.Count()
    nfr0 = SapModel.FrameObj.Count()
    log(f"Baseline counts: PointObj={npt0}, FrameObj={nfr0} (must stay constant throughout)")

    for method in RUN_ORDER:
        log(f"=== METHOD {method} ===")

        if method != "BASE":
            # unlock + move 178 bottom joints to new position (delta from ORIGINAL, since
            # model should currently be at original position before this block)
            ret = SapModel.SetModelIsLocked(False)
            log(f"  Unlocked (ret={ret}). Moving {treatment_frames.__len__()} bottom joints -> {method}...")
            sub = new_coords[new_coords["method"] == method]
            moves = []
            for _, r in sub.iterrows():
                dx = r["new_X"] - r["orig_bot_X"]
                dy = r["new_Y"] - r["orig_bot_Y"]
                dz = r["new_Z"] - r["orig_bot_Z"]
                moves.append((int(r["bottom_joint"]), dx, dy, dz))
            t0 = time.time()
            move_points(SapModel, moves)
            log(f"  Moved {len(moves)} joints in {time.time()-t0:.1f}s")

            npt = SapModel.PointObj.Count()
            nfr = SapModel.FrameObj.Count()
            if npt != npt0 or nfr != nfr0:
                raise RuntimeError(
                    f"COUNT MISMATCH after moving joints for {method}: "
                    f"PointObj {npt0}->{npt}, FrameObj {nfr0}->{nfr}. "
                    f"Possible accidental merge -- ABORTING before analysis."
                )
            log(f"  Count check OK (PointObj={npt}, FrameObj={nfr})")

            t0 = time.time()
            ret = SapModel.Analyze.RunAnalysis()
            log(f"  RunAnalysis ret={ret}, took {time.time()-t0:.1f}s")
            if ret != 0:
                raise RuntimeError(f"RunAnalysis failed for {method}, ret={ret}")
        else:
            locked = SapModel.GetModelIsLocked()
            if not locked:
                log("  Model not yet analyzed for BASE -- running analysis now.")
                t0 = time.time()
                ret = SapModel.Analyze.RunAnalysis()
                log(f"  RunAnalysis ret={ret}, took {time.time()-t0:.1f}s")
            else:
                log("  Model already analyzed (BASE state) -- reusing current results.")

        # re-assert results setup (safe no-op if already set)
        SapModel.Results.Setup.DeselectAllCasesAndCombosForOutput()
        SapModel.Results.Setup.SetComboSelectedForOutput("BAO KT")

        log("  Extracting JointDispl for 192 top joints...")
        t0 = time.time()
        df_disp = extract_joint_displ(SapModel, all_top_joints)
        log(f"    -> {len(df_disp)} rows in {time.time()-t0:.1f}s")
        df_disp.to_csv(os.path.join(RESULTS_DIR, f"joint_disp_{method}.csv"), index=False)

        log("  Extracting FrameForce for 178 treatment pile frames...")
        t0 = time.time()
        df_force = extract_frame_force(SapModel, treatment_frames)
        log(f"    -> {len(df_force)} rows in {time.time()-t0:.1f}s")
        df_force.to_csv(os.path.join(RESULTS_DIR, f"pile_force_{method}.csv"), index=False)

        # quick summary
        if len(df_disp):
            ux_max = df_disp["U1"].abs().max()
            uy_max = df_disp["U2"].abs().max()
        else:
            ux_max = uy_max = None
        if len(df_force):
            df_force["M_res"] = np.sqrt(df_force["M2"]**2 + df_force["M3"]**2)
            df_force["V_res"] = np.sqrt(df_force["V2"]**2 + df_force["V3"]**2)
            m_max = df_force["M_res"].max()
            v_max = df_force["V_res"].max()
        else:
            m_max = v_max = None
        summary[method] = {"U_X_max": ux_max, "U_Y_max": uy_max, "M_max": m_max, "V_max": v_max}
        log(f"  Summary {method}: U_X_max={ux_max}, U_Y_max={uy_max}, M_max={m_max}, V_max={v_max}")

        # save running summary after every method (checkpoint)
        with open(os.path.join(RESULTS_DIR, "summary_running.json"), "w") as fh:
            json.dump(summary, fh, indent=2)

        if method != "BASE":
            log(f"  Restoring {len(moves)} bottom joints to original coordinates...")
            ret = SapModel.SetModelIsLocked(False)
            restore_moves = [(j, -dx, -dy, -dz) for (j, dx, dy, dz) in moves]
            move_points(SapModel, restore_moves)
            npt = SapModel.PointObj.Count()
            nfr = SapModel.FrameObj.Count()
            if npt != npt0 or nfr != nfr0:
                raise RuntimeError(
                    f"COUNT MISMATCH after restoring joints for {method}: "
                    f"PointObj {npt0}->{npt}, FrameObj {nfr0}->{nfr}."
                )
            # spot-check a couple of restored coordinates against master table
            spot = sub.iloc[0]
            chk = SapModel.PointObj.GetCoordCartesian(str(int(spot["bottom_joint"])), 0, 0, 0)
            if (abs(chk[1]-spot["orig_bot_X"])>1e-6 or abs(chk[2]-spot["orig_bot_Y"])>1e-6
                    or abs(chk[3]-spot["orig_bot_Z"])>1e-6):
                raise RuntimeError(f"Restore spot-check FAILED for joint {spot['bottom_joint']}: {chk} vs orig {spot['orig_bot_X'],spot['orig_bot_Y'],spot['orig_bot_Z']}")
            log("  Restored and spot-checked OK.")

    log("All methods done. Writing final summary.")
    with open(os.path.join(RESULTS_DIR, "summary_final.json"), "w") as fh:
        json.dump(summary, fh, indent=2)

    log("Closing SAP2000 (no save)...")
    mySapObject.ApplicationExit(False)
    log("[ALL DONE]")

if __name__ == "__main__":
    main()
