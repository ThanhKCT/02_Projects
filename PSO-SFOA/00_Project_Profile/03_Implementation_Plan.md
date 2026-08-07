# 03_Implementation_Plan.md

# IMPLEMENTATION PLAN v1.0

## Framework: PSO vs SFOA for Steel Frame Optimization

------------------------------------------------------------------------

# Mục tiêu

Triển khai toàn bộ framework đã thiết kế (M1→M8) theo từng file nhỏ, có
kiểm thử và nghiệm thu.

Nguyên tắc:

-   Một file → Một nhiệm vụ.
-   Hoàn thành → Kiểm thử → Khóa file.
-   Không viết nhiều file cùng lúc.

------------------------------------------------------------------------

# Tổng lộ trình

    Phase 1  Environment
          ↓
    Phase 2  Python (M2 + M3)
          ↓
    Phase 3  MATLAB (M4)
          ↓
    Phase 4  MATLAB (M5 + M6)
          ↓
    Phase 5  Experiment (M7)
          ↓
    Phase 6  Thesis & Paper (M8)

------------------------------------------------------------------------

# Phase 1 -- Environment

  ID     File / Task                    Status
  ------ ------------------------------ --------
  P1.1   Tạo cấu trúc thư mục project   ☐
  P1.2   Cấu hình Python 3.11           ☐
  P1.3   Cấu hình MATLAB R2023b         ☐
  P1.4   Kết nối SAP2000 COM API        ☐
  P1.5   Kiểm tra MasterModel.sdb       ☐

**Milestone A:** Môi trường sẵn sàng.

------------------------------------------------------------------------

# Phase 2 -- Python (M2 + M3)

## M2 -- Python Connector

  ID     File                 Status
  ------ -------------------- --------
  P2.1   sap_session.py       ☐
  P2.2   section_manager.py   ☐
  P2.3   analysis_runner.py   ☐
  P2.4   result_reader.py     ☐
  P2.5   connector_test.py    ☐

## M3 -- Evaluation Engine

  ID      File                     Status
  ------- ------------------------ --------
  P2.6    evaluation_data.py       ☐
  P2.7    force_parser.py          ☐
  P2.8    displacement_parser.py   ☐
  P2.9    evaluation_builder.py    ☐
  P2.10   evaluation_test.py       ☐

**Milestone B:** MATLAB gọi evaluate(x) và nhận EvaluationData.

------------------------------------------------------------------------

# Phase 3 -- MATLAB (M4)

## Objective

  ID     File              Status
  ------ ----------------- --------
  P3.1   weight_engine.m   ☐

## Constraint

  ID     File                     Status
  ------ ------------------------ --------
  P3.2   constraint_engine.m      ☐
  P3.3   check_geometry.m         ☐
  P3.4   check_beam.m             ☐
  P3.5   check_column.m           ☐
  P3.6   check_serviceability.m   ☐

## Penalty & Fitness

  ID     File               Status
  ------ ------------------ --------
  P3.7   penalty_engine.m   ☐
  P3.8   fitness_engine.m   ☐
  P3.9   evaluate.m         ☐

**Milestone C:** evaluate(x) trả về FitnessResult.

------------------------------------------------------------------------

# Phase 4 -- MATLAB (M5 + M6)

## PSO

  ID     File                 Status
  ------ -------------------- --------
  P4.1   pso_main.m           ☐
  P4.2   initialize_swarm.m   ☐
  P4.3   update_velocity.m    ☐
  P4.4   update_position.m    ☐
  P4.5   update_pbest.m       ☐
  P4.6   update_gbest.m       ☐

## SFOA

  ID      File                      Status
  ------- ------------------------- --------
  P4.7    sfoa_main.m               ☐
  P4.8    initialize_population.m   ☐
  P4.9    update_position_sfoa.m    ☐
  P4.10   update_best.m             ☐

**Milestone D:** PSO và SFOA chạy trên cùng evaluate(x).

------------------------------------------------------------------------

# Phase 5 -- Experiment (M7)

  ID     File                  Status
  ------ --------------------- --------
  P5.1   experiment_config.m   ☐
  P5.2   batch_runner.m        ☐
  P5.3   result_collector.m    ☐
  P5.4   statistics.m          ☐
  P5.5   visualization.m       ☐
  P5.6   export_results.m      ☐

**Milestone E:** Có bảng thống kê và biểu đồ.

------------------------------------------------------------------------

# Phase 6 -- Thesis & Paper (M8)

  ID     Task                    Status
  ------ ----------------------- --------
  P6.1   Chuẩn bị bảng           ☐
  P6.2   Chuẩn bị hình           ☐
  P6.3   Viết Methodology        ☐
  P6.4   Viết Experiment         ☐
  P6.5   Viết Discussion         ☐
  P6.6   Hoàn thiện Conclusion   ☐

**Milestone F:** Hoàn thành luận văn và bài báo.

------------------------------------------------------------------------

# Quy trình làm việc

Mỗi phiên làm việc chỉ xử lý:

1.  Chọn 01 file.
2.  Thiết kế chi tiết.
3.  Lập trình.
4.  Kiểm thử.
5.  Nghiệm thu.
6.  Khóa file.
7.  Chuyển sang file tiếp theo.

------------------------------------------------------------------------

# Điều kiện hoàn thành dự án

-   [ ] M2 hoàn thành
-   [ ] M3 hoàn thành
-   [ ] M4 hoàn thành
-   [ ] M5 hoàn thành
-   [ ] M6 hoàn thành
-   [ ] M7 hoàn thành
-   [ ] M8 hoàn thành

------------------------------------------------------------------------

# Design Freeze

Kiến trúc M1→M8 đã được chốt.

Trong giai đoạn Implementation:

-   Không thay đổi Interface.
-   Không thay đổi luồng dữ liệu.
-   Chỉ sửa khi phát hiện lỗi thiết kế.
