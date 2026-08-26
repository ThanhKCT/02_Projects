# -*- coding: utf-8 -*-
"""Test attach + di chuyen 1 joint bang SelectObj.ClearSelection + PointObj.SetSelected + EditGeneral.Move."""
import win32com.client
import sys

def main():
    helper = win32com.client.Dispatch("SAP2000v1.Helper")
    mySapObject = helper.GetObject("CSI.SAP2000.API.SapObject")
    print("[OK] Attached.", flush=True)

    SapModel = mySapObject.SapModel
    test_joint = "3"

    orig = SapModel.PointObj.GetCoordCartesian(test_joint, 0, 0, 0)
    print(f"Before: {orig}", flush=True)
    ox, oy, oz = orig[0], orig[1], orig[2]

    ret = SapModel.SetModelIsLocked(False)
    print(f"SetModelIsLocked(False) ret={ret}", flush=True)

    ret = SapModel.SelectObj.ClearSelection()
    print(f"ClearSelection ret={ret}", flush=True)

    ret = SapModel.PointObj.SetSelected(test_joint, True)
    print(f"PointObj.SetSelected('{test_joint}', True) ret={ret}", flush=True)

    dz = -0.5
    ret = SapModel.EditGeneral.Move(0, 0, dz)
    print(f"EditGeneral.Move(0,0,{dz}) ret={ret}", flush=True)

    moved = SapModel.PointObj.GetCoordCartesian(test_joint, 0, 0, 0)
    print(f"After move: {moved}", flush=True)

    rest = SapModel.PointObj.GetRestraint(test_joint, [False]*6)
    spring = SapModel.PointObj.GetSpring(test_joint, [0.0]*6)
    print(f"Restraint after move: {rest}", flush=True)
    print(f"Spring after move: {spring}", flush=True)

    # restore: move back by +0.5
    ret = SapModel.SelectObj.ClearSelection()
    ret = SapModel.PointObj.SetSelected(test_joint, True)
    ret = SapModel.EditGeneral.Move(0, 0, -dz)
    print(f"Restore move ret={ret}", flush=True)
    restored = SapModel.PointObj.GetCoordCartesian(test_joint, 0, 0, 0)
    print(f"After restore: {restored}", flush=True)
    SapModel.SelectObj.ClearSelection()

    print("[DONE]", flush=True)

if __name__ == "__main__":
    main()
