# 02_System_Architecture.md

# SYSTEM ARCHITECTURE v1.0

## So sánh PSO và SFOA cho bài toán tối ưu khối lượng khung thép 2 tầng theo TCVN 5575:2024

------------------------------------------------------------------------

# 1. Mục tiêu hệ thống

Xây dựng framework tối ưu gồm 8 module độc lập để:

-   Sử dụng SAP2000 làm FEA.
-   MATLAB thực hiện Objective + Constraint theo TCVN 5575:2024.
-   So sánh hai thuật toán PSO và SFOA trên cùng một bài toán.

Nguyên tắc:

-   Không dùng SAP Design.
-   Không tự lập trình FEM.
-   Chỉ thay đổi tiết diện.
-   Hình học, tải trọng và vật liệu được cố định.

------------------------------------------------------------------------

# 2. Kiến trúc tổng thể

``` text
                 M1
        SAP Master Model
               │
               ▼
                 M2
         Python Connector
               │
               ▼
             SAP2000
               │
               ▼
                 M3
       Evaluation Engine
               │
               ▼
                 M4
     Design Evaluation Engine
(Objective + Constraint + Penalty + Fitness)
               │
        ┌──────┴──────┐
        ▼             ▼
       M5            M6
      PSO           SFOA
        └──────┬──────┘
               ▼
               M7
          Experiment
               ▼
               M8
        Thesis / Paper
```

------------------------------------------------------------------------

# 3. Luồng dữ liệu

``` text
Design Variables (8)

        │

        ▼

Python Connector

        │

        ▼

SAP2000

        │

        ▼

SAPRawData

        │

        ▼

EvaluationData

        │

        ▼

FitnessResult

        │

        ▼

PSO / SFOA
```

------------------------------------------------------------------------

# 4. Interface giữa các Module

## Interface 1

Input:

-   DesignVariables

Output:

-   SAPRawData

M2 chịu trách nhiệm.

------------------------------------------------------------------------

## Interface 2

Input:

-   SAPRawData

Output:

-   EvaluationData

M3 chịu trách nhiệm.

------------------------------------------------------------------------

## Interface 3

Input:

-   EvaluationData

Output:

-   FitnessResult

M4 chịu trách nhiệm.

------------------------------------------------------------------------

## Interface 4

Input:

-   FitnessResult

Output:

-   DesignVariables mới

M5 hoặc M6 chịu trách nhiệm.

------------------------------------------------------------------------

# 5. Chi tiết từng Module

## M1 -- SAP Master Model

### Mục tiêu

Chuẩn hóa mô hình SAP.

### Input

Không có.

### Output

MasterModel.sdb

### Thành phần cố định

-   Geometry
-   Material
-   Load
-   Load Combination
-   Boundary

### Thành phần thay đổi

-   Column Section
-   Beam Section

------------------------------------------------------------------------

## M2 -- Python Connector

### Mục tiêu

Điều khiển SAP2000 thông qua COM API.

### Workflow

1.  Unlock
2.  Update Section
3.  Run Analysis
4.  Read Result
5.  Return SAPRawData

### Output

SAPRawData

### Không thực hiện

-   Tính Weight
-   Kiểm tra TCVN
-   Tính Fitness

------------------------------------------------------------------------

## M3 -- Evaluation Engine

### Mục tiêu

Chuẩn hóa dữ liệu từ SAP.

### Input

SAPRawData

### Output

EvaluationData

### Đọc dữ liệu

-   Internal Forces
-   Joint Displacement
-   Geometry
-   Section

### Không thực hiện

-   Objective
-   Constraint
-   Penalty

------------------------------------------------------------------------

## M4 -- Design Evaluation

### Input

EvaluationData

### Workflow

Objective

↓

Constraint

↓

Penalty

↓

Fitness

### Output

FitnessResult

### Thành phần

-   Objective Engine
-   Constraint Engine
-   Penalty Engine
-   Fitness Engine

------------------------------------------------------------------------

## M5 -- PSO

### Input

FitnessResult

### Output

Best DesignVariables

### Workflow

Initialize

↓

Evaluate

↓

Update PBest

↓

Update GBest

↓

Velocity Update

↓

Position Update

↓

History

------------------------------------------------------------------------

## M6 -- SFOA

### Input

FitnessResult

### Output

Best DesignVariables

### Workflow

Initialize

↓

Evaluate

↓

Update Best

↓

SFOA Update Rule

↓

History

Khác M5 duy nhất ở Update Rule.

------------------------------------------------------------------------

## M7 -- Experiment

### Mục tiêu

So sánh PSO và SFOA.

### Thực hiện

-   30 lần PSO
-   30 lần SFOA

### Sinh kết quả

-   Summary
-   Statistics
-   Figures
-   Excel

------------------------------------------------------------------------

## M8 -- Paper

### Input

-   Tables
-   Figures
-   Statistics

### Output

-   Thesis
-   Paper

------------------------------------------------------------------------

# 6. Nguyên tắc kiến trúc

1.  MATLAB không biết SAP.
2.  Python không biết PSO/SFOA.
3.  SAP chỉ làm FEA.
4.  M3 chỉ chuẩn hóa dữ liệu.
5.  M4 chỉ đánh giá thiết kế.
6.  PSO và SFOA chỉ gọi evaluate(x).
7.  M7 chỉ điều phối thực nghiệm.
8.  M8 chỉ tổng hợp và trình bày kết quả.

------------------------------------------------------------------------

# 7. Trạng thái dự án

  Module   Status
  -------- ------------------
  M1       Completed
  M2       Design Completed
  M3       Design Completed
  M4       Design Completed
  M5       Design Completed
  M6       Design Completed
  M7       Design Completed
  M8       Design Completed

------------------------------------------------------------------------

# 8. Chuyển sang Implementation

Coding sẽ thực hiện theo thứ tự:

1.  Python (M2 + M3)
2.  MATLAB (M4 + M5 + M6)
3.  Experiment (M7)
4.  Thesis & Paper (M8)

Thiết kế được xem là đã đóng băng (Design Freeze v1.0).
