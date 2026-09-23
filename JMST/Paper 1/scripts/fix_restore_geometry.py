# -*- coding: utf-8 -*-
"""
Corrective script: the previous run (run_M2_NEW_only.py) crashed during the
restore step (spot-check failed), and SAP2000's RunAnalysis appears to have
auto-saved the working file WITH the 178 bottom joints still at their M2_NEW
positions. This script re-opens that file, force-restores all 178 treatment
bottom joints to their TRUE original coordinates (from pile_master_table.csv,
the authoritative source used throughout this project), verifies every one
of them individually (not just a spot check), saves, and closes cleanly.
"""
import win32com.client
import pandas as pd
import numpy as np
import os
import time

BASE_DIR = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
MODEL_PATH = os.path.join(BASE_DIR, "sap_work", "Ben100kDWT_sensitivity.sdb")


def log(msg):
    print(f"[{time.strftime('%H:%M:%S')}] {msg}", flush=True)


def main():
    log("Starting SAP2000...")
    helper = win32com.client.Dispatch("SAP2000v1.Helper")
    mySapObject = helper.CreateObjectProgID("CSI.SAP2000.API.SapObject")
    ret = mySapObject.ApplicationStart(12, True, "")
    log(f"ApplicationStart ret={ret}")
    SapModel = mySapObject.SapModel

    log(f"Opening: {MODEL_PATH}")
    ret = SapModel.File.OpenFile(MODEL_PATH)
    log(f"OpenFile ret={ret}")
    if ret != 0:
        raise RuntimeError("OpenFile failed")

    npt0 = SapModel.PointObj.Count()
    nfr0 = SapModel.FrameObj.Count()
    log(f"Counts: PointObj={npt0}, FrameObj={nfr0}")

    master = pd.read_csv(os.path.join(BASE_DIR, "pile_master_table.csv"))
    master.columns = [c.strip() for c in master.columns]
    treatment = master[master["status"] == "treatment_spring"].copy()
    log(f"Treatment piles (should be 178): {len(treatment)}")

    ret = SapModel.SetModelIsLocked(False)
    log(f"Unlocked (ret={ret})")

    mismatches_before = []
    moves = []
    for _, r in treatment.iterrows():
        joint = str(int(r["bottom_joint"]))
        cur = SapModel.PointObj.GetCoordCartesian(joint, 0, 0, 0)
        cur_xyz = np.array([cur[1], cur[2], cur[3]])
        true_orig = np.array([r["bot_X"], r["bot_Y"], r["bot_Z"]])
        if np.linalg.norm(cur_xyz - true_orig) > 1e-6:
            mismatches_before.append(int(r["frame"]))
            dx, dy, dz = (true_orig - cur_xyz)
            moves.append((joint, dx, dy, dz))

    log(f"Joints needing correction: {len(mismatches_before)} of {len(treatment)}")
    if mismatches_before:
        log(f"  frames: {mismatches_before[:10]}{'...' if len(mismatches_before) > 10 else ''}")

    for joint, dx, dy, dz in moves:
        SapModel.SelectObj.ClearSelection()
        ret = SapModel.PointObj.SetSelected(joint, True)
        if ret != 0:
            raise RuntimeError(f"SetSelected failed for {joint}")
        ret = SapModel.EditGeneral.Move(dx, dy, dz)
        if ret != 0:
            raise RuntimeError(f"Move failed for {joint}")
    SapModel.SelectObj.ClearSelection()
    log(f"Applied correction moves to {len(moves)} joints.")

    npt = SapModel.PointObj.Count()
    nfr = SapModel.FrameObj.Count()
    if npt != npt0 or nfr != nfr0:
        raise RuntimeError(f"COUNT MISMATCH: PointObj {npt0}->{npt}, FrameObj {nfr0}->{nfr}")
    log(f"Count check OK (PointObj={npt}, FrameObj={nfr})")

    # verify EVERY treatment joint now matches true original (not just a spot check)
    bad = []
    for _, r in treatment.iterrows():
        joint = str(int(r["bottom_joint"]))
        cur = SapModel.PointObj.GetCoordCartesian(joint, 0, 0, 0)
        cur_xyz = np.array([cur[1], cur[2], cur[3]])
        true_orig = np.array([r["bot_X"], r["bot_Y"], r["bot_Z"]])
        if np.linalg.norm(cur_xyz - true_orig) > 1e-6:
            bad.append((int(r["frame"]), cur_xyz.tolist(), true_orig.tolist()))

    if bad:
        log(f"[FAIL] {len(bad)} joints still do not match original after correction:")
        for f, cur, orig in bad[:10]:
            log(f"  frame {f}: current={cur} vs orig={orig}")
        raise RuntimeError("Full verification FAILED -- not saving.")

    log("[OK] All 178 treatment bottom joints verified back at TRUE original coordinates.")

    log("Saving model...")
    ret = SapModel.File.Save(MODEL_PATH)
    log(f"Save ret={ret}")

    log("Closing SAP2000...")
    mySapObject.ApplicationExit(False)
    log("[ALL DONE]")


if __name__ == "__main__":
    main()
