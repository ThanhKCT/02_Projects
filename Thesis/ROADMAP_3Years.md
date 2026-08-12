# MASTER RESEARCH ROADMAP — 36 THÁNG

## Phát triển thuật toán metaheuristic cho tối ưu đa mục tiêu kết cấu cảng biển

**Phiên bản:** 3.0  
**Thời gian tổng thể:** 36 tháng  
**Trạng thái:** 18 tháng đầu đã hoàn thành; 18 tháng cuối là kế hoạch tiếp theo  
**Sản phẩm nghiên cứu chính:** MOSFOAV2 — hoàn thành, chờ đăng

---

# 1. TƯ TƯỞNG CHỦ ĐẠO

Đề tài gồm hai giai đoạn:

```text
GIAI ĐOẠN I — 18 THÁNG ĐẦU
Hình thành nền tảng + tạo sản phẩm nghiên cứu chính
        ↓
SFOA → MOO → MOSFOA → B/E-MOSFOA
        ↓
Benchmark → Kết cấu cảng biển
        ↓
MOSFOAV2
        ↓
SẢN PHẨM CHÍNH — ĐÃ HOÀN THÀNH


GIAI ĐOẠN II — 18 THÁNG CUỐI
Khai thác nền tảng + tạo sản phẩm còn thiếu
        ↓
SAP2000 3D + Structural baseline
        ↓
Structural optimization
        ↓
Structural MOO
        ↓
Research gap mới
        ↓
A-MOSFOA / B-MOSFOA
        ↓
Benchmark + Ablation
        ↓
Real Port Structure
        ↓
Engineering Decision
        ↓
Các bài báo tiếp theo + LUẬN ÁN
```

**Nguyên tắc:** Không coi MOSFOAV2 là nhiệm vụ tương lai. Đây là sản phẩm đã hoàn thành và là nền tảng cho giai đoạn tiếp theo.

---

# 2. GIAI ĐOẠN I — 18 THÁNG ĐẦU

## Hình thành nền tảng + sản phẩm nghiên cứu chính

### Mục tiêu

- Nắm nền tảng optimization và metaheuristic.
- Nghiên cứu và triển khai SFOA.
- Nắm multi-objective optimization và Pareto optimization.
- Phát triển MOSFOA.
- Phát triển B-MOSFOA / E-MOSFOA.
- Kiểm chứng benchmark.
- Áp dụng vào kết cấu cảng biển.
- Hoàn thành MOSFOAV2.
- Hình thành năng lực nghiên cứu độc lập.

## M1–3 — Nền tảng nghiên cứu

Học:

- Optimization fundamentals
- Metaheuristic fundamentals
- Single/Multi-objective optimization
- Pareto dominance/front
- Exploration/Exploitation
- Convergence/Diversity

Kết quả: có khả năng đọc một paper theo chuỗi:

```text
Problem → Algorithm → Mechanism → Experiment → Conclusion
```

Artifacts:

```text
Research_Context.md
Literature_Map.md
Optimization_Notes.md
Metaheuristic_Notes.md
```

## M4–6 — SFOA Baseline

```text
SFOA paper
    ↓
Mathematical formulation
    ↓
Pseudocode
    ↓
Implementation
    ↓
Unit test
    ↓
Benchmark
```

Output:

- SFOA implementation
- SFOA benchmark
- SFOA research note

## M7–9 — Multi-objective SFOA

Chuyển:

\[
\min f(x)
\]

sang:

\[
\min F(x)=[f_1(x),f_2(x),...,f_m(x)]
\]

Nghiên cứu:

- Pareto dominance
- Non-dominated sorting
- Archive
- Diversity
- Leader selection
- Pareto metrics

Kiến trúc:

```text
SFOA
 ↓
Pareto evaluation
 ↓
Archive
 ↓
Leader
 ↓
Population update
```

## M10–12 — Enhanced MOSFOA

Phát triển:

- adaptive phase;
- mutation;
- refinement;
- diversity control;
- leader mechanism.

Hình thành:

```text
B-MOSFOA
     ↓
E-MOSFOA
```

Kiểm chứng:

- benchmark;
- convergence;
- diversity;
- IGD;
- ε;
- Δ;
- MS;
- independent runs.

## M13–15 — Marine Structural Application

```text
MOSFOA
   ↓
Structural model
   ↓
SAP2000
   ↓
Structural response
   ↓
Objectives
   ↓
Constraints
```

Case study:

- Berthing Dolphin;
- Mooring Dolphin;
- Main Jetty Platform.

Mục tiêu: chứng minh MOSFOA có thể áp dụng cho tối ưu kết cấu cảng biển thực.

## M16–18 — MOSFOAV2

**Sản phẩm chính: MOSFOAV2**

Bao gồm:

- B-MOSFOA;
- E-MOSFOA;
- benchmark;
- marine structure;
- SAP2000/MATLAB;
- Pareto optimization;
- cost/displacement trade-off.

**Trạng thái: ĐÃ HOÀN THÀNH — CHỜ ĐĂNG.**

Không đưa MOSFOAV2 trở lại danh sách công việc 18 tháng cuối.

---

# 3. MỐC CHUYỂN GIAI ĐOẠN — THÁNG 18

```text
MOSFOAV2
✓ Algorithm
✓ Benchmark
✓ Marine case
✓ Paper
        ↓
KẾ THỪA
        ↓
Structural optimization gap
        ↓
Structural MOO
        ↓
A/B-MOSFOA
```

Câu hỏi chuyển tiếp:

> MOSFOAV2 đã giải quyết MOO ở cấp độ thuật toán và có ứng dụng cảng biển; còn thiếu gì khi bài toán được đặt trong framework tối ưu kết cấu 3D với biến rời rạc, ràng buộc kỹ thuật và FEA/SAP2000 có chi phí tính toán cao?

---

# 4. GIAI ĐOẠN II — 18 THÁNG CUỐI

## Khai thác nền tảng + tạo đóng góp mới + hoàn thiện luận án

| Thời gian | Trọng tâm |
|---|---|
| M19–21 | SAP2000 3D + Structural Baseline |
| M22–24 | Structural Single-objective Optimization |
| M25–27 | Structural Multi-objective Framework |
| M28–30 | A-MOSFOA / B-MOSFOA |
| M31–33 | Benchmark + Real Port Structure |
| M34–36 | Papers + Thesis + Defense |

---

# 5. PHASE II-A — M19–21
## SAP2000 3D + Structural Baseline

### Mục tiêu

Xây dựng mô hình 3D đủ tin cậy để thuật toán có thể gọi:

```text
evaluate(x)
```

Pipeline:

```text
Design vector x
      ↓
SAP2000 3D
      ↓
Analysis
      ↓
Result extraction
      ↓
Structural evaluation
```

### Công việc

**Master Model**

- Geometry
- Material
- Section
- Loads
- Load combinations
- Supports
- Design settings

**Verification**

- phản lực;
- chuyển vị;
- nội lực;
- trọng lượng;
- kiểm tra thiết kế.

**Automation**

```text
Python
 ↓
SAP2000
 ↓
Update model
 ↓
Run analysis
 ↓
Extract results
 ↓
Return evaluation
```

**Single Evaluation Test**

\[
x=[x_1,x_2,\ldots,x_n]
\]

phải chạy hoàn chỉnh:

\[
xightarrow SAP2000ightarrow FEAightarrow Resultsightarrow Evaluation
\]

### Output M21

```text
MasterModel.sdb
SAP Session Manager
Section Updater
Analysis Runner
Result Extractor
Structural Evaluator
Verification Report
```

### Gate

> Chưa hoàn thành single evaluation thì chưa sang optimization.

---

# 6. PHASE II-B — M22–24
## Structural Single-objective Optimization

Đây là bước khóa nền tảng, không phải đóng góp mới chính.

Ví dụ:

\[
\min W(x)
\]

subject to:

\[
g_i(x)\leq0
\]

với:

\[
x_i\in\{x_{i1},x_{i2},...,x_{ik}\}
\]

So sánh:

\[
SFOA \quad vs \quad PSO
\]

Cùng:

- model;
- variables;
- constraints;
- evaluation budget;
- stopping criteria;
- number of runs.

Mục tiêu: xác nhận framework tối ưu kết cấu + SAP2000 3D + SFOA/PSO hoạt động ổn định và tái lập được.

**Sản phẩm:** Structural Optimization Baseline / Paper tiếp theo.

---

# 7. PHASE II-C — M25–27
## Structural Multi-objective Framework

Đây là cửa chuyển sang nghiên cứu mới.

Xây dựng:

\[
\min F(x)=[f_1(x),f_2(x),...,f_m(x)]
\]

với:

- design variables;
- structural constraints;
- discrete sections;
- SAP2000 response.

Pipeline:

```text
Design
 ↓
SAP2000
 ↓
FEA
 ↓
Structural response
 ↓
Objective evaluation
 ↓
Constraint evaluation
 ↓
Pareto evaluation
 ↓
Archive
 ↓
Optimizer
```

### Nhiệm vụ bắt buộc

Thực hiện gap analysis trước khi khóa A-MOSFOA/B-MOSFOA:

```text
MOSFOAV2
   ↓
Structural MOO literature
   ↓
Identify limitations
   ↓
Research gap
   ↓
Research hypothesis
   ↓
Candidate mechanism
```

---

# 8. PHASE II-D — M28–30
## A-MOSFOA / B-MOSFOA

Đây là trọng tâm đóng góp mới.

Không phát triển thuật toán mới chỉ bằng cách cộng nhiều operator có sẵn.

Quy trình:

```text
MOSFOAV2
     ↓
Failure analysis
     ↓
Research gap
     ↓
Hypothesis
     ↓
New mechanism
     ↓
A-MOSFOA
     ↓
Ablation
     ↓
B-MOSFOA
     ↓
Ablation
     ↓
Final algorithm
```

---

# 9. CÁC HƯỚNG ĐÓNG GÓP MỚI DỰ KIẾN

## C1 — Structural-aware search

Thuật toán nhận biết:

- biến rời rạc;
- vùng khả thi;
- constraint violation;
- structural utilization;
- FEA response.

## C2 — Adaptive search

Nghiên cứu điều chỉnh:

\[
Exploration\leftrightarrow Exploitation
\]

dựa trên trạng thái thực của quá trình tìm kiếm thay vì chỉ dựa vào iteration.

Một dạng trạng thái có thể nghiên cứu:

\[
State(t)=[Diversity,Convergence,Improvement,Feasibility]
\]

sau đó:

\[
State(t)ightarrow Search\ Control
\]

Đây là ứng viên novelty mạnh, nhưng phải kiểm chứng literature trước khi tuyên bố mới.

## C3 — Constraint-aware Pareto search

Thay vì chỉ:

\[
F=f+Penalty
\]

nghiên cứu cách sử dụng:

- feasibility;
- degree of violation;
- structural utilization;
- Pareto quality

để định hướng search.

## C4 — Expensive-FEA-aware optimization

Mỗi evaluation:

\[
xightarrow SAP2000ightarrow FEA
\]

có chi phí.

Nghiên cứu:

\[
\min N_{FEA}
\]

trong khi vẫn duy trì:

\[
HV,\ IGD,\ Diversity
\]

ở mức chấp nhận được.

Có thể nghiên cứu:

- duplicate avoidance;
- evaluation cache;
- intelligent candidate selection;
- failure recovery;
- evaluation management.

**Novelty chỉ được tuyên bố sau khi chứng minh bằng thực nghiệm.**

---

# 10. PHASE II-E — M31–33
## Benchmark + Real Port Structure

### Tầng 1 — Benchmark

So sánh:

```text
SFOA
MOSFOAV2
MOPSO / baseline
A-MOSFOA
B-MOSFOA
```

Metrics:

- HV;
- IGD;
- convergence;
- diversity;
- runtime;
- number of FEA evaluations;
- robustness;
- statistical significance.

### Tầng 2 — Structural benchmark

Kiểm tra:

- discrete variables;
- constraints;
- different structural sizes;
- different loading conditions.

### Tầng 3 — Real port structure

```text
A/B-MOSFOA
      ↓
SAP2000 3D
      ↓
Real port structure
      ↓
Pareto solutions
      ↓
Engineering interpretation
```

---

# 11. PHASE II-F — M34–36
## Publication + Thesis + Defense

Không để đến tháng 34 mới bắt đầu viết.

### M34

Hoàn thiện:

- paper thuật toán;
- paper ứng dụng;
- response/revision nếu có;
- Research gap;
- Research questions;
- Contributions;
- methodology.

### M35 — Luận án

```text
Chapter 1 — Introduction
Chapter 2 — Literature Review
Chapter 3 — SFOA and MOSFOAV2 Foundation
Chapter 4 — Structural Optimization Framework
Chapter 5 — Multi-objective Structural Optimization
Chapter 6 — A-MOSFOA / B-MOSFOA
Chapter 7 — Benchmark and Ablation
Chapter 8 — Real Port Structure
Chapter 9 — Engineering Decision
Chapter 10 — Conclusions
```

### M36

- thesis;
- papers;
- figures;
- datasets;
- source code;
- reproducibility package;
- defense presentation.

---

# 12. BẢNG ROADMAP 36 THÁNG

| Thời gian | Giai đoạn | Trọng tâm | Sản phẩm |
|---|---|---|---|
| M1–3 | I-A | Optimization + Metaheuristic | Research foundation |
| M4–6 | I-B | SFOA | SFOA baseline |
| M7–9 | I-C | MOO + MOSFOA | MOSFOA |
| M10–12 | I-D | Enhanced MOSFOA | B/E-MOSFOA |
| M13–15 | I-E | Marine structural application | Marine case |
| M16–18 | I-F | **MOSFOAV2** | **Main Paper ✓** |
| | | **MỐC CHUYỂN GIAI ĐOẠN** | |
| M19–21 | II-A | **SAP2000 3D** | Verified FE framework |
| M22–24 | II-B | Structural SOO | Structural baseline paper |
| M25–27 | II-C | Structural MOO | MOO framework |
| M28–30 | II-D | **A/B-MOSFOA** | **New algorithm** |
| M31–33 | II-E | Benchmark + Port 3D | Validation + application paper |
| M34–36 | II-F | Thesis + publications | **Luận án** |

---

# 13. SẢN PHẨM NGHIÊN CỨU CUỐI CÙNG

## PRODUCT 0 — ĐÃ CÓ

### MOSFOAV2

Multi-objective SFOA + benchmark + marine structure.

**Status: COMPLETED / WAITING PUBLICATION**

## PRODUCT 1 — NỀN TẢNG KẾT CẤU

### SFOA/PSO Structural Optimization

Single-objective + discrete design + structural constraints + SAP2000 3D.

## PRODUCT 2 — FRAMEWORK

### Multi-objective Structural Optimization Framework

Pareto + SAP2000 + structural constraints + discrete variables.

## PRODUCT 3 — ĐÓNG GÓP KHOA HỌC CHÍNH

### A-MOSFOA / B-MOSFOA

Structural-aware adaptive multi-objective SFOA.

## PRODUCT 4 — ENGINEERING APPLICATION

### Real-world Port Structural MOO

A/B-MOSFOA + SAP2000 3D + Pareto engineering decision.

## PRODUCT 5 — LUẬN ÁN

\[
Algorithm+Framework+Validation+Engineering
\]

---

# 14. ĐÓNG GÓP MỚI CỦA ĐỀ TÀI

Phân biệt rõ đóng góp đã có và đóng góp sẽ tạo ra.

## Đã có — MOSFOAV2

### Contribution P0

> Phát triển và kiểm chứng B-MOSFOA/E-MOSFOA cho tối ưu đa mục tiêu dựa trên SFOA, kết hợp Pareto archive, diversity control, leader selection và các cơ chế tăng cường tìm kiếm, đồng thời chứng minh khả năng áp dụng cho kết cấu cảng biển.

**Status: DONE.**

## Đóng góp mới của 18 tháng cuối

### C1 — Structural-aware MOO

> Phát triển một framework tối ưu đa mục tiêu dựa trên SFOA được thiết kế cho đặc thù bài toán kết cấu, trong đó đồng thời xét biến thiết kế rời rạc, ràng buộc kỹ thuật và phản ứng kết cấu từ phân tích phần tử hữu hạn.

### C2 — Adaptive search mechanism

> Phát triển cơ chế điều khiển quá trình tìm kiếm dựa trên trạng thái hội tụ, đa dạng, cải thiện nghiệm và khả năng khả thi của quần thể, nhằm thích nghi giữa exploration và exploitation.

**Đây là ứng viên novelty thuật toán mạnh nhất hiện tại.**

### C3 — Constraint-aware Pareto optimization

> Phát triển cơ chế định hướng tìm kiếm và lựa chọn nghiệm Pareto có xét mức độ khả thi của thiết kế kết cấu, thay vì phụ thuộc hoàn toàn vào hàm phạt.

### C4 — Expensive-FEA-aware optimization

> Phát triển cơ chế giảm chi phí đánh giá khi mỗi nghiệm phải thông qua phân tích SAP2000/FEA, đồng thời duy trì chất lượng Pareto và độ tin cậy của kết quả.

### C5 — 3D structural optimization framework

> Xây dựng framework tự động hóa khép kín giữa thuật toán tối ưu và SAP2000 3D, từ sinh biến thiết kế, cập nhật mô hình, phân tích, trích xuất kết quả, kiểm tra ràng buộc đến cập nhật Pareto population.

### C6 — Engineering contribution

> Xây dựng phương pháp chuyển Pareto solutions thành các phương án thiết kế kết cấu cảng biển có ý nghĩa kỹ thuật, hỗ trợ lựa chọn giữa các mục tiêu xung đột như chi phí/khối lượng và hiệu năng kết cấu.

---

# 15. NGUYÊN TẮC XÁC NHẬN NOVELTY

C1–C6 hiện tại là **đóng góp mục tiêu/dự kiến**, chưa phải tất cả đều được phép ghi là novelty chính thức.

Quy trình bắt buộc:

\[
Research\ Gap
ightarrow
Hypothesis
ightarrow
Mechanism
ightarrow
Algorithm
ightarrow
Ablation
ightarrow
Benchmark
ightarrow
Structural\ Validation
ightarrow
Novelty
\]

Nếu một cơ chế đã được công bố trước đó, không gọi nó là mới.

---

# 16. CÂU HỎI NGHIÊN CỨU CỦA LUẬN ÁN

## RQ1

SFOA có hiệu quả như thế nào trong tối ưu kết cấu có biến rời rạc và ràng buộc thực?

## RQ2

Các cơ chế MOO dựa trên SFOA có thể được chuyển hóa như thế nào để phù hợp với bài toán kết cấu thực?

## RQ3

Những hạn chế nào xuất hiện khi áp dụng MOSFOA cho structural MOO với FEA đắt đỏ, biến rời rạc và ràng buộc kỹ thuật?

## RQ4

Một cơ chế adaptive/structural-aware mới có cải thiện hiệu quả tìm kiếm Pareto hay không?

## RQ5

Thuật toán mới có tạo ra lợi ích thực sự trên kết cấu cảng biển 3D hay không?

---

# 17. CÁC MỐC GATE BẮT BUỘC

## Gate 1 — M21

Phải có:

- SAP2000 3D;
- Python ↔ SAP;
- structural evaluator;
- verified model;
- single evaluation.

**Chưa đạt → không sang optimization.**

## Gate 2 — M24

Phải có:

- SFOA;
- PSO;
- structural optimization;
- independent runs;
- statistical analysis;
- baseline results.

**Chưa đạt → không khóa thuật toán mới.**

## Gate 3 — M30

Phải có:

- structural MOO;
- A-MOSFOA;
- B-MOSFOA;
- benchmark;
- ablation;
- statistical significance.

**Chưa đạt → không chạy full port case.**

## Gate 4 — M33

Phải có:

- real 3D port model;
- MOO;
- A/B-MOSFOA;
- baseline algorithms;
- Pareto front;
- engineering interpretation.

Sau đó 3 tháng cuối tập trung vào:

```text
Papers
+
Thesis
+
Defense
```

---

# 18. NGUYÊN TẮC LÀM VIỆC TỪ NAY

1. Không quay lại học SFOA từ đầu.
2. Không làm lại MOSFOAV2.
3. Không vội code A-MOSFOA/B-MOSFOA trước khi có structural baseline.
4. Học kiến thức khi nó phục vụ trực tiếp một thí nghiệm hoặc sản phẩm.
5. Mỗi phase phải tạo artifact cụ thể.
6. Mọi novelty phải đi qua literature gap → hypothesis → mechanism → ablation → validation.
7. Không gọi một cải tiến nhỏ hoặc việc ghép các operator có sẵn là “thuật toán mới”.
8. SAP2000 là FEA engine, không phải nơi chứa logic optimization.
9. Mọi kết quả quan trọng phải có khả năng tái lập.
10. Ưu tiên các bài báo có câu chuyện khoa học rõ ràng hơn nhiều bài rời rạc.
11. Không mở rộng sang ML, RL, surrogate, uncertainty hoặc dynamic loading nếu chưa phục vụ trực tiếp research question chính.
12. Mục tiêu cuối cùng:

\[
oxed{
New\ Algorithm
+
Scientific\ Evidence
+
3D\ Structural\ Application
+
Engineering\ Value
}
\]

---

# 19. ĐIỂM BẮT ĐẦU NGAY BÂY GIỜ

Với trạng thái hiện tại:

\[
oxed{
SAP2000\ 3D\ Baseline
ightarrow
Structural\ Evaluation
ightarrow
SFOA/PSO\ Structural\ Baseline
}
\]

Sau khi baseline sạch:

\[
oxed{
Structural\ MOO
ightarrow
Gap\ Analysis
ightarrow
A	ext{-}MOSFOA/B	ext{-}MOSFOA
}
\]

Đây là roadmap 36 tháng chính thức:

- **18 tháng đầu:** hình thành nền tảng + MOSFOAV2 đã hoàn thành.
- **18 tháng cuối:** khai thác nền tảng + tạo đóng góp mới + sản phẩm tiếp theo + hoàn thiện luận án.
