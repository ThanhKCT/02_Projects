# -*- coding: utf-8 -*-
"""Test: RunAnalysis + trich JointDispl / FrameForce cho envelope BAO KT."""
import win32com.client
import time

def main():
    helper = win32com.client.Dispatch("SAP2000v1.Helper")
    mySapObject = helper.GetObject("CSI.SAP2000.API.SapObject")
    SapModel = mySapObject.SapModel

    print("Locked before analysis:", SapModel.GetModelIsLocked(), flush=True)

    t0 = time.time()
    ret = SapModel.Analyze.RunAnalysis()
    print(f"RunAnalysis ret={ret}, took {time.time()-t0:.1f}s", flush=True)

    ret = SapModel.Results.Setup.DeselectAllCasesAndCombosForOutput()
    print(f"DeselectAll ret={ret}", flush=True)
    ret = SapModel.Results.Setup.SetComboSelectedForOutput("BAO KT")
    print(f"SetComboSelectedForOutput('BAO KT') ret={ret}", flush=True)

    # Test JointDispl for single joint (top_joint=14, frame 1)
    # refs: NumberResults, Obj, Elm, LoadCase, StepType, StepNum, U1,U2,U3,R1,R2,R3 = 12
    args = (0, [], [], [], [], [], [], [], [], [], [], [])
    try:
        res = SapModel.Results.JointDispl("14", 0, *args)
        print(f"JointDispl('14', ObjectElm) tuple len={len(res)}:", flush=True)
        for i, v in enumerate(res):
            print(f"   [{i}] {v}", flush=True)
    except Exception as e:
        print("JointDispl single FAILED:", e, flush=True)

    # Test JointDispl for whole 'ALL' group
    try:
        t0 = time.time()
        res = SapModel.Results.JointDispl("ALL", 1, *args)
        print(f"JointDispl('ALL', GroupElm) took {time.time()-t0:.1f}s, NumberResults={res[0]}", flush=True)
        print("   ObjNames[:5]=", res[1][:5] if res[1] else res[1], flush=True)
        print("   LoadCase[:5]=", res[5][:5] if res[5] else res[5], flush=True)
        print("   StepType[:5]=", res[6][:5] if res[6] else res[6], flush=True)
        print("   U1[:5]=", res[8][:5] if res[8] else res[8], flush=True)
        print("   ret=", res[-1], flush=True)
    except Exception as e:
        print("JointDispl ALL FAILED:", e, flush=True)

    # Test FrameForce for single frame (frame 1)
    # refs: NumberResults, Obj, ObjSta, Elm, ElmSta, LoadCase, StepType, StepNum, P,V2,V3,T,M2,M3 = 14
    fargs = (0, [], [], [], [], [], [], [], [], [], [], [], [], [])
    try:
        res = SapModel.Results.FrameForce("1", 0, *fargs)
        print(f"FrameForce('1', ObjectElm) NumberResults={res[0]}", flush=True)
        for i, v in enumerate(res):
            print(f"   [{i}] {v}", flush=True)
    except Exception as e:
        print("FrameForce single FAILED:", e, flush=True)

    print("[DONE]", flush=True)

if __name__ == "__main__":
    main()
