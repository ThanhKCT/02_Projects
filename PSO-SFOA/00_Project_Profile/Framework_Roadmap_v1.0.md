# FRAMEWORK ROADMAP v1.0

## So sánh PSO và SFOA cho tối ưu khung thép 2 tầng theo TCVN 5575:2024

## Mục tiêu

-   Tối ưu khối lượng khung thép 2 tầng.
-   FEA: SAP2000.
-   TCVN 5575:2024: MATLAB.
-   Thuật toán: PSO và SFOA.

------------------------------------------------------------------------

# Kiến trúc tổng thể

    Design Variables (8 biến)
            │
            ▼
    M2 - Python Connector
            │
            ▼
    SAP2000 (FEA)
            │
            ▼
    M3 - Evaluation Engine
            │
            ▼
    M4 - Design Evaluation
    (Objective + Constraint + Penalty + Fitness)
            │
            ▼
    M5 PSO      M6 SFOA
            │
            └──────────────┐
                           ▼
                   M7 Experiment
                           ▼
                      M8 Paper

------------------------------------------------------------------------

# Module Overview

## M1 -- SAP Master Model ✅

-   Geometry
-   Material
-   Load
-   Boundary
-   Load Combination
-   Chỉ thay Section

Output: - MasterModel.sdb

------------------------------------------------------------------------

## M2 -- Python Connector ✅

Input: - x = \[x1...x8\]

Workflow: 1. Unlock 2. Update Section 3. Run Analysis 4. Read Results 5.
Return

Output: - SAPRawData

------------------------------------------------------------------------

## M3 -- Evaluation Engine ✅

Input: - SAPRawData

Output: - EvaluationData

Chỉ đọc: - Internal Forces - Displacements - Geometry - Section

Không kiểm tra TCVN.

------------------------------------------------------------------------

## M4 -- Design Evaluation ✅

EvaluationData → Objective → Constraint → Penalty → Fitness

Output: - FitnessResult

------------------------------------------------------------------------

## M5 -- PSO ✅

Workflow: Initialize → Evaluate → Update PBest → Update GBest → Update
Velocity → Update Position → History

PSO chỉ gọi: evaluate(x)

------------------------------------------------------------------------

## M6 -- SFOA ✅

Giống M5.

Khác duy nhất: - Update Rule.

Không sửa M2, M3, M4.

------------------------------------------------------------------------

## M7 -- Experiment ✅

-   30 lần PSO
-   30 lần SFOA

Xuất: - Summary - Statistics - Figures

------------------------------------------------------------------------

## M8 -- Paper ✅

Input: - Tables - Figures - Statistics

Output: - Thesis - Paper

------------------------------------------------------------------------

# Interface giữa các Module

    DesignVariables
            │
            ▼
    SAPRawData
            │
            ▼
    EvaluationData
            │
            ▼
    FitnessResult

------------------------------------------------------------------------

# Quy tắc vàng

1.  MATLAB không biết SAP.
2.  Python không biết PSO/SFOA.
3.  SAP chỉ làm FEA.
4.  MATLAB kiểm tra TCVN.
5.  PSO và SFOA chỉ gọi evaluate(x).
6.  M7 chỉ làm thực nghiệm.
7.  M8 chỉ viết luận văn/bài báo.

------------------------------------------------------------------------

# Trạng thái

  Module   Status
  -------- -----------------
  M1       DONE
  M2       DESIGN COMPLETE
  M3       DESIGN COMPLETE
  M4       DESIGN COMPLETE
  M5       DESIGN COMPLETE
  M6       DESIGN COMPLETE
  M7       DESIGN COMPLETE
  M8       DESIGN COMPLETE

------------------------------------------------------------------------

# Giai đoạn tiếp theo

IMPLEMENTATION

Phase 1: Python (M2+M3) Phase 2: MATLAB (M4+M5+M6) Phase 3: Experiment
(M7) Phase 4: Thesis & Paper (M8)
