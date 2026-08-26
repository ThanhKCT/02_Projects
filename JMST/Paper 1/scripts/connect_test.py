# -*- coding: utf-8 -*-
"""
Test ket noi SAP2000 OAPI: mo file model goc 1 lan, kiem tra thong tin co ban,
kiem tra cach doc toa do / spring / restraint cua 1 joint mau, TRUOC KHI chay
vong lap sensitivity day du. KHONG dong SAP2000 o cuoi (de tiep tuc dung trong
script chinh cung phien) -- in ra PID de biet con song.
"""
import win32com.client
import time
import sys

MODEL_PATH = r"I:\My Drive\Thanh Quang Do\Cau 1 2 _Lach Huyen\Sap\Ben 100.000DWT KT.sdb"
Ton_m_C = 12

def main():
    print("[1] Creating Helper...", flush=True)
    helper = win32com.client.Dispatch("SAP2000v1.Helper")

    print("[2] CreateObjectProgID...", flush=True)
    t0 = time.time()
    mySapObject = helper.CreateObjectProgID("CSI.SAP2000.API.SapObject")
    print(f"    done in {time.time()-t0:.1f}s", flush=True)

    print("[3] ApplicationStart...", flush=True)
    t0 = time.time()
    ret = mySapObject.ApplicationStart(Ton_m_C, True, "")
    print(f"    ApplicationStart ret={ret}, took {time.time()-t0:.1f}s", flush=True)

    SapModel = mySapObject.SapModel

    print("[4] Opening model file (this may take a while for large files)...", flush=True)
    t0 = time.time()
    ret = SapModel.File.OpenFile(MODEL_PATH)
    dt = time.time() - t0
    print(f"    OpenFile ret={ret}, took {dt:.1f}s ({dt/60:.1f} min)", flush=True)

    if ret != 0:
        print("!!! OpenFile failed, aborting test.", flush=True)
        sys.exit(1)

    # Basic counts
    npt = SapModel.PointObj.Count()
    nframe = SapModel.FrameObj.Count()
    print(f"[5] PointObj.Count()={npt}, FrameObj.Count()={nframe}", flush=True)

    # Combo list
    try:
        res = SapModel.RespCombo.GetNameList(0, [])
        print(f"[6] RespCombo.GetNameList raw tuple len={len(res)}: {res}", flush=True)
    except Exception as e:
        print(f"[6] RespCombo.GetNameList FAILED: {e}", flush=True)

    # Lock status
    try:
        locked = SapModel.GetModelIsLocked()
        print(f"[7] GetModelIsLocked() = {locked}", flush=True)
    except Exception as e:
        print(f"[7] GetModelIsLocked FAILED: {e}", flush=True)

    # Sample joint: frame=1 bottom_joint=3 (from pile_master_table.csv)
    test_joint = "3"
    try:
        res = SapModel.PointObj.GetCoordCartesian(test_joint, 0, 0, 0)
        print(f"[8] GetCoordCartesian('{test_joint}') = {res}", flush=True)
    except Exception as e:
        print(f"[8] GetCoordCartesian FAILED: {e}", flush=True)

    try:
        res = SapModel.PointObj.GetRestraint(test_joint, [False]*6)
        print(f"[9] GetRestraint('{test_joint}') = {res}", flush=True)
    except Exception as e:
        print(f"[9] GetRestraint FAILED: {e}", flush=True)

    try:
        res = SapModel.PointObj.GetSpring(test_joint, [0.0]*6)
        print(f"[10] GetSpring('{test_joint}') = {res}", flush=True)
    except Exception as e:
        print(f"[10] GetSpring FAILED: {e}", flush=True)

    print("[DONE] Test script finished. SAP2000 left open for reuse.", flush=True)
    print(f"NOTE: this test itself counts as the single OAPI open of the session.", flush=True)

if __name__ == "__main__":
    main()
