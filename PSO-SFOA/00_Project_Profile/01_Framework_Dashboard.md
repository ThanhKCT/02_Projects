# 01_Framework_Dashboard.md

# FRAMEWORK DASHBOARD v1.0

## Dự án: So sánh PSO và SFOA cho bài toán tối ưu khối lượng khung thép 2 tầng theo TCVN 5575:2024

------------------------------------------------------------------------

# Mục tiêu dự án

-   FEA: SAP2000
-   Điều khiển: Python COM API
-   Đánh giá theo TCVN 5575:2024: MATLAB
-   Thuật toán: PSO và SFOA
-   Kết quả: Luận văn + Bài báo

------------------------------------------------------------------------

# Dashboard tổng thể

    M1 ──► M2 ──► M3 ──► M4 ──► M5
                                    │
                                    ▼
                                   M6
                                    │
                                    ▼
                                   M7
                                    │
                                    ▼
                                   M8

------------------------------------------------------------------------

# Trạng thái Module

  Module   Tên                  Thiết kế   Lập trình   Kiểm thử
  -------- ------------------- ---------- ----------- ----------
  M1       SAP Master Model        ✅         ✅          ✅
  M2       Python Connector        ✅          ☐          ☐
  M3       Evaluation Engine       ✅          ☐          ☐
  M4       Design Evaluation       ✅          ☐          ☐
  M5       PSO                     ✅          ☐          ☐
  M6       SFOA                    ✅          ☐          ☐
  M7       Experiment              ✅          ☐          ☐
  M8       Paper                   ✅          ☐          ☐

------------------------------------------------------------------------

# Kiến trúc dữ liệu

    DesignVariables (8)
            │
            ▼
    Python Connector (M2)
            │
            ▼
    SAP2000
            │
            ▼
    SAPRawData
            │
            ▼
    EvaluationData (M3)
            │
            ▼
    FitnessResult (M4)
            │
       ┌────┴────┐
       ▼         ▼
     PSO(M5)   SFOA(M6)
          │
          ▼
     Experiment (M7)
          ▼
     Thesis/Paper (M8)

------------------------------------------------------------------------

# Interface đã khóa

  Interface         Producer   Consumer
  ----------------- ---------- ----------
  DesignVariables   M5/M6      M2
  SAPRawData        M2         M3
  EvaluationData    M3         M4
  FitnessResult     M4         M5/M6

**Design Freeze v1.0:** Không thay đổi các interface trên.

------------------------------------------------------------------------

# Quy tắc vàng

1.  MATLAB không biết SAP.
2.  Python không biết PSO/SFOA.
3.  SAP chỉ thực hiện FEA.
4.  M3 chỉ chuẩn hóa dữ liệu.
5.  M4 chỉ tính Weight + Constraint + Penalty + Fitness.
6.  PSO và SFOA chỉ gọi `evaluate(x)`.
7.  M7 chỉ thực nghiệm.
8.  M8 chỉ tổng hợp kết quả.

------------------------------------------------------------------------

# Hôm nay đang làm gì?

## Giai đoạn hiện tại

**IMPLEMENTATION**

## Module hiện tại

**M2 -- Python Connector**

## File tiếp theo

    python/
    └── connector/
        └── sap_session.py

------------------------------------------------------------------------

# Milestone

  Mốc   Điều kiện
  ----- -----------------------------
  A     Environment hoàn chỉnh
  B     M2 + M3 chạy được
  C     evaluate(x) hoạt động
  D     PSO & SFOA chạy được
  E     Thực nghiệm hoàn tất
  F     Luận văn & bài báo hoàn tất

------------------------------------------------------------------------

# Checklist hằng ngày

-   [ ] Mở Dashboard
-   [ ] Chọn đúng file theo Implementation Plan
-   [ ] Hoàn thành 01 file
-   [ ] Kiểm thử
-   [ ] Cập nhật trạng thái
-   [ ] Commit/Ghi chú

------------------------------------------------------------------------

# Bộ tài liệu dự án

    docs/
    ├── 01_Framework_Dashboard.md   ← MỞ MỖI NGÀY
    ├── 02_System_Architecture.md
    ├── 03_Implementation_Plan.md
    └── 04_Project_FileTree.md

------------------------------------------------------------------------

# Nguyên tắc làm việc

**Một phiên làm việc = Một file = Thiết kế (nếu cần) + Lập trình + Kiểm
thử + Khóa file.**

Không thay đổi kiến trúc trong giai đoạn Implementation nếu không phát
hiện lỗi thiết kế.
