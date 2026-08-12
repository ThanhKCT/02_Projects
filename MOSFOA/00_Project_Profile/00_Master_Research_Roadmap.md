# MASTER RESEARCH & IMPLEMENTATION ROADMAP
## SFOA → Structural SFOA → SMOSFOA → Real-World Container Wharf

**Version:** 1.0  
**Status:** WORKING MASTER PLAN  
**Purpose:** Shared execution context for ChatGPT + Claude Pro  
**Primary language:** Vietnamese  
**Project domain:** Structural optimization / steel-concrete port structure / SAP2000 / metaheuristic optimization

---

# 00. PURPOSE OF THIS FILE

Đây là file **Master Roadmap** dùng làm ngữ cảnh chung khi làm việc với ChatGPT và Claude Pro.

Mục tiêu của file:

1. Giữ thống nhất research direction.
2. Tránh hai AI đề xuất hai kiến trúc khác nhau.
3. Phân biệt rõ:
   - việc đã khóa;
   - việc đang triển khai;
   - việc chưa được phép làm;
   - ý tưởng nghiên cứu tương lai.
4. Cho phép mở phiên chat mới mà không mất research context.
5. Làm cơ sở để xây dựng code, test, benchmark, paper và thesis theo cùng một lộ trình.
6. Không để việc đọc một paper mới làm thay đổi architecture đã freeze nếu chưa có quyết định chính thức.

---

# 01. RESEARCH NORTH STAR

## 1.1. Câu hỏi nghiên cứu tổng quát

> Làm thế nào để phát triển một framework tối ưu kết cấu dựa trên SFOA có khả năng xử lý hiệu quả bài toán kết cấu thực tế với:
>
> - ràng buộc kỹ thuật;
> - biến thiết kế rời rạc;
> - phân tích FEA/SAP2000 tốn chi phí;
> - nhiều mục tiêu;
> - và nhu cầu lựa chọn phương án kỹ thuật từ Pareto front?

## 1.2. Research story

```text
SFOA gốc
   ↓
Structural SFOA
   ↓
Real-world structural optimization + SAP2000
   ↓
Structural Multi-Objective SFOA
   ↓
Constraint-aware + discrete + expensive FEA
   ↓
Real-world multi-objective container wharf
   ↓
Pareto decision making
```

## 1.3. Không đặt mục tiêu

Không đặt mục tiêu:

- phát minh lại SFOA;
- chỉ sao chép MOSFOA;
- chỉ thêm chaos / Levy / mutation / RL một cách cơ học;
- chỉ chứng minh thuật toán thắng trên benchmark mà không có engineering contribution;
- tuyên bố novelty khi chưa hoàn tất literature gap analysis.

---

# 02. LITERATURE BASELINE — CÁC BÀI PHẢI PHÂN BIỆT

## 2.1. SFOA gốc

SFOA là baseline algorithm.

Cần giữ nguyên:

- exploration;
- exploitation;
- predation;
- regeneration;
- cơ chế update gốc.

**Không tự ý sửa thuật toán gốc trong baseline implementation.**

Mục đích:

> Có một implementation SFOA sạch, reproducible và có thể dùng làm baseline cho toàn bộ nghiên cứu.

---

## 2.2. MOSFOA paper — baseline literature quan trọng

Paper đã cung cấp một multi-objective extension của SFOA bằng:

- Non-Dominated Sorting (NDS);
- Crowding Distance (CD);
- elitist selection.

Quy trình chính:

```text
Initialize population
        ↓
Evaluate objectives
        ↓
NDS / ranking
        ↓
Crowding Distance
        ↓
Population update
        ↓
Merge parent + offspring
        ↓
Elitist selection
        ↓
Next generation
```

Paper cũng sử dụng:

- ZDT / DTLZ;
- constrained engineering benchmarks;
- engineering applications;
- IEEE 30-bus OPF;
- speed reducer;
- IGD;
- HV;
- KKTPM;
- Wilcoxon;
- Friedman;
- boxplots;
- repeated independent runs.

### Nguyên tắc

MOSFOA paper là:

> **literature baseline / reference architecture**

chứ không phải target để copy.

---

# 03. RESEARCH GAP WORKING HYPOTHESIS

## 3.1. MOSFOA generic

Có thể khái quát:

```text
SFOA
 + NDS
 + Crowding Distance
 → MOSFOA
```

Trọng tâm:

- generic MOO;
- benchmark;
- engineering benchmark;
- OPF;
- speed reducer.

## 3.2. Hướng nghiên cứu của dự án

```text
SFOA
 + Pareto mechanism
 + structural constraint handling
 + discrete structural variables
 + expensive FEA handling
 + SAP2000 coupling
 + real-world structural engineering
 → SMOSFOA
```

## 3.3. Working research gap

Cần kiểm chứng bằng literature review trước khi dùng trong paper:

> Existing MOSFOA demonstrates general-purpose multi-objective capability, while this project investigates how SFOA-based multi-objective optimization should be adapted for constrained, discrete, computationally expensive structural design coupled with SAP2000 and a real-world container-wharf case.

**Lưu ý:** đây là working hypothesis, chưa phải final novelty claim.

---

# 04. FOUR-STAGE RESEARCH PROGRAM

---

## STAGE P1 — STRUCTURAL SFOA

### Research question

> SFOA có phù hợp với bài toán tối ưu kết cấu có ràng buộc và biến thiết kế rời rạc hay không?

### Mục tiêu

- kiểm chứng SFOA;
- xây structural encoding;
- xây constraint handling;
- kiểm tra discrete design;
- so sánh với PSO;
- tạo baseline reproducible.

### Candidate benchmark

Ưu tiên:

1. 10-bar truss;
2. 25-bar truss;
3. 52-bar truss;
4. 72-bar truss;
5. 3D truss;
6. steel frame / structural benchmark phù hợp.

Không bắt buộc triển khai toàn bộ ngay từ đầu.

### Comparison

```text
PSO
vs
SFOA
```

### Metrics

- Best;
- Mean;
- Median;
- Worst;
- Standard deviation;
- COV;
- convergence curve;
- function evaluations;
- runtime.

### Statistical validation

Ưu tiên:

- Wilcoxon;
- Friedman nếu có nhiều hơn 2 algorithms.

### Deliverable P1

```text
P1-01 SFOA baseline implementation
P1-02 PSO baseline implementation
P1-03 Structural benchmark suite
P1-04 Constraint handler
P1-05 Discrete variable handler
P1-06 Reproducibility protocol
P1-07 Benchmark results
P1-08 Draft Paper 1
```

### Gate P1

Chỉ chuyển P2 khi:

- SFOA baseline pass;
- PSO baseline pass;
- benchmark deterministic/reproducible;
- constraint tests pass;
- discrete tests pass;
- independent runs complete;
- result tables generated automatically.

---

# STAGE P2 — REAL-WORLD STRUCTURAL OPTIMIZATION

## Research question

> SFOA có thể tối ưu một công trình thực tế thông qua SAP2000 trong điều kiện phân tích FEA tốn chi phí hay không?

## Target

**Real-world container wharf / port structural system**

### Optimization concept

Giai đoạn đầu ưu tiên single-objective:

```text
Minimize structural material / weight / cost
```

subject to:

- ULS;
- SLS;
- displacement;
- crack/serviceability nếu applicable;
- reinforcement constraints;
- foundation/pile constraints nếu nằm trong model scope.

### Core loop

```text
SFOA
  ↓
Generate design vector
  ↓
Discrete/design decoding
  ↓
Update SAP2000 model
  ↓
Run analysis
  ↓
Extract results
  ↓
Structural checks
  ↓
Constraint evaluation
  ↓
Objective
  ↓
Fitness
  ↓
SFOA update
```

### Comparison

```text
PSO + SAP2000
vs
SFOA + SAP2000
```

### Critical engineering principle

Không để optimizer trực tiếp "hiểu" SAP2000.

Tách:

```text
Optimizer
   │
   ▼
Design Vector
   │
   ▼
Structural Model Interface
   │
   ▼
SAP2000
   │
   ▼
Results
   │
   ▼
Structural Evaluation
```

### Deliverable P2

```text
P2-01 SAP2000 master model
P2-02 SAP2000 automation interface
P2-03 Design-variable mapping
P2-04 Result extraction
P2-05 Structural evaluator
P2-06 SFOA-SAP2000 coupling
P2-07 PSO-SAP2000 coupling
P2-08 Validation against manual/reference design
P2-09 Optimization results
P2-10 Draft Paper 2
```

### Gate P2

Không chuyển P3 nếu:

- SAP2000 model chưa verified;
- extraction chưa verified;
- design vector mapping chưa verified;
- structural checks chưa independently checked;
- optimizer chưa tái lập được kết quả;
- chưa có logging/audit trail.

---

# STAGE P3 — SMOSFOA

## Research question

> Làm thế nào để mở rộng SFOA thành một multi-objective structural optimizer có khả năng xử lý constraint, discrete design và expensive FEA?

## Baseline

```text
MOSFOA literature
=
SFOA + NDS + CD
```

## Proposed direction

```text
SFOA
  ↓
Pareto ranking
  ↓
Structural constraint handling
  ↓
Discrete design handling
  ↓
Expensive FEA handling
  ↓
Archive / diversity
  ↓
SMOSFOA
```

---

# 05. PROPOSED SMOSFOA MODULES

## M1 — SFOA Core

Trách nhiệm:

- population;
- initialization;
- exploration;
- exploitation;
- predation;
- regeneration;
- update.

Không chứa structural-specific logic.

---

## M2 — Design Variable Manager

Trách nhiệm:

- continuous variables;
- integer variables;
- discrete catalog variables;
- bounds;
- decoding;
- repair;
- validity.

Ví dụ:

```text
Continuous:
x = 0.0 ... 1.0

Integer:
n = 4 ... 20

Discrete:
section ∈ catalog
rebar ∈ catalog
thickness ∈ catalog
```

---

## M3 — Structural Constraint Handler

Trách nhiệm:

```text
ULS
SLS
Deflection
Crack
Buckling
Reinforcement
Geometry
Foundation
```

Tùy scope thực tế.

Concept:

```text
Feasible
   >
Infeasible
```

và constraint violation:

```text
CV(x) = Σ w_i max(0, g_i(x))
```

Công thức cuối cùng phải được khóa sau khi hoàn thiện formulation.

---

## M4 — Multi-Objective Engine

Trách nhiệm:

- objective vector;
- Pareto dominance;
- NDS;
- rank;
- crowding distance;
- archive;
- truncation.

---

## M5 — Expensive Evaluation Manager

Trách nhiệm:

- duplicate detection;
- cache;
- evaluation queue;
- failure handling;
- early rejection;
- evaluation logging;
- optional parallel evaluation.

Không đưa surrogate model vào core nếu chưa có nghiên cứu riêng.

---

## M6 — SAP2000 Interface

Trách nhiệm:

```text
Design vector
→ SAP2000 model
→ analysis
→ result extraction
```

Không chứa thuật toán SFOA.

---

## M7 — Structural Evaluation Engine

Trách nhiệm:

```text
SAP response
→ engineering quantities
→ TCVN checks
→ utilization ratios
→ constraint violations
```

---

## M8 — Pareto Archive

Lưu:

- design vector;
- objective vector;
- constraint vector;
- feasibility;
- rank;
- crowding;
- SAP run ID;
- timestamp;
- model version;
- software/version metadata.

---

## M9 — Decision Support

Sau khi Pareto set ổn định:

```text
Pareto set
   ↓
Normalization
   ↓
Ideal point / preference
   ↓
Engineering decision
```

Có thể nghiên cứu:

- fuzzy decision;
- distance-to-ideal;
- preference-weighted selection.

Không khóa phương pháp decision-making trước khi literature review.

---

# 06. MULTI-OBJECTIVE FORMULATION

## Initial candidate

### Objective 1

```text
f1 = structural material / mass
```

### Objective 2

```text
f2 = reinforcement/material cost
```

### Objective 3

```text
f3 = maximum displacement
```

Đây chỉ là **candidate formulation**.

Final objective set phải được quyết định sau khi:

1. xác định hệ kết cấu;
2. xác định available SAP2000 outputs;
3. xác định TCVN design checks;
4. xác định dữ liệu vật liệu;
5. kiểm tra literature gap.

---

# 07. P4 — FLAGSHIP REAL-WORLD MOO

## Research question

> SMOSFOA có tạo ra Pareto solutions có chất lượng và có ý nghĩa kỹ thuật cho tối ưu đa mục tiêu công trình cảng thực tế hay không?

## Framework

```text
SMOSFOA
   ↓
Container Wharf
   ↓
SAP2000
   ↓
Structural checks
   ↓
Pareto archive
   ↓
IGD / HV / KKTPM
   ↓
Engineering decision
   ↓
Recommended design
```

## Comparison

Tối thiểu:

```text
MOPSO
MOSFOA
SMOSFOA
```

Có thể thêm NSGA-II hoặc algorithm phù hợp sau literature review.

Không tự động mở rộng danh sách algorithm nếu chưa có lý do khoa học.

---

# 08. EXPERIMENTAL DESIGN

## 8.1. Independent runs

Baseline target:

```text
≥ 30 independent runs
```

Nếu computational cost quá lớn:

- benchmark: 30 runs;
- SAP2000: số runs được quyết định theo budget nhưng phải thống kê rõ.

## 8.2. Reproducibility

Mỗi run phải lưu:

```text
seed
algorithm
population size
max iterations
initial population
design variables
objective values
constraint values
feasibility
best solution
archive
runtime
function evaluations
SAP evaluations
```

---

# 09. PERFORMANCE METRICS

## Single-objective

- Best;
- Mean;
- Median;
- Worst;
- Std;
- COV;
- convergence;
- runtime;
- function evaluations.

## Multi-objective

### Primary

- HV;
- IGD.

### Secondary

- KKTPM nếu feasible;
- spacing / diversity metric;
- number of nondominated solutions;
- feasible Pareto ratio.

### Statistical

- Wilcoxon;
- Friedman.

### Engineering

- material saving;
- cost saving;
- maximum utilization;
- displacement;
- reinforcement ratio;
- safety margin;
- SAP analysis count;
- computational time.

---

# 10. FAIR COMPARISON PROTOCOL

PSO / MOSFOA / SMOSFOA phải dùng:

- same population size;
- same maximum evaluations nếu có thể;
- same variable bounds;
- same constraints;
- same SAP model;
- same evaluation function;
- same seeds where appropriate;
- same termination criteria;
- same computational environment.

Không so sánh một algorithm bằng iteration count và algorithm khác bằng function evaluations nếu chưa quy đổi.

---

# 11. SAP2000 VALIDATION LADDER

## Level 0 — Model integrity

Kiểm tra:

- geometry;
- supports;
- materials;
- sections;
- load patterns;
- load combinations;
- mass;
- boundary conditions.

## Level 1 — Analysis integrity

So sánh:

- reactions;
- selected internal forces;
- displacement;
- modal quantities nếu relevant.

## Level 2 — Design/check integrity

So sánh:

- utilization;
- governing combinations;
- design ratios;
- reinforcement.

## Level 3 — Automation integrity

```text
manual input
≈
automated input
```

## Level 4 — Optimization integrity

Một design vector cố định phải cho:

```text
same design
→ same SAP model
→ same response
→ same objective
→ same constraint vector
```

---

# 12. CODE ARCHITECTURE PRINCIPLE

Không gộp tất cả vào một script.

Kiến trúc logic:

```text
core/
├── optimizer/
│   ├── sfoa/
│   ├── pso/
│   └── multiobjective/
│
├── problem/
│   ├── design_variables/
│   ├── constraints/
│   └── objectives/
│
├── structural/
│   ├── evaluator/
│   ├── tcvn/
│   └── checks/
│
├── sap2000/
│   ├── model/
│   ├── runner/
│   └── extractor/
│
├── experiments/
│   ├── benchmark/
│   ├── single_objective/
│   └── multi_objective/
│
└── reporting/
    ├── tables/
    ├── figures/
    └── statistics/
```

Nếu project hiện tại đã có architecture/design freeze riêng, **architecture hiện hành được ưu tiên**. File này chỉ định hướng research, không tự động thay đổi implementation architecture đã khóa.

---

# 13. RESEARCH DATA MODEL

Mỗi evaluation nên có record:

```text
Run ID
Algorithm
Seed
Iteration
Individual ID
Design Vector
Decoded Design
Objective Vector
Constraint Vector
Feasible
Constraint Violation
SAP Model Version
SAP Run ID
Analysis Status
Runtime
```

Điều này cực kỳ quan trọng để sau này:

- audit;
- debug;
- statistical analysis;
- reproduce;
- viết paper.

---

# 14. PROJECT GATES

## GATE A — Literature

Pass khi:

- SFOA literature map complete;
- MOSFOA literature map complete;
- structural MOO literature map complete;
- SAP2000 optimization literature map complete;
- novelty matrix complete.

## GATE B — Algorithm

Pass khi:

- SFOA baseline verified;
- PSO baseline verified;
- unit tests pass;
- benchmark reproducible.

## GATE C — Structural

Pass khi:

- formulation verified;
- constraints verified;
- TCVN checks verified;
- design variables verified.

## GATE D — SAP2000

Pass khi:

- model verified;
- automation verified;
- result extraction verified.

## GATE E — Optimization

Pass khi:

- optimizer-SAP loop verified;
- failure handling verified;
- cache verified;
- logging verified.

## GATE F — Publication

Pass khi:

- experiments complete;
- statistics complete;
- figures reproducible;
- tables generated from raw results;
- claims traceable to evidence.

---

# 15. PAPER STRATEGY

## PAPER 1

### Working title

**Structural Optimization Using the Starfish Optimization Algorithm: Performance Assessment for Constrained and Discrete Design Problems**

### Contribution

- structural application of SFOA;
- discrete handling;
- constraint handling;
- PSO comparison;
- statistical validation.

---

## PAPER 2

### Working title

**Single-Objective Optimization of a Real-World Container Wharf Using the Starfish Optimization Algorithm and SAP2000**

### Contribution

- SAP2000 coupling;
- real-world structure;
- expensive FEA optimization;
- engineering constraints;
- PSO vs SFOA.

---

## PAPER 3

### Working title

**A Structural Multi-Objective Starfish Optimization Framework for Constrained and Discrete Structural Design**

### Contribution

- SMOSFOA;
- structural constraint-aware Pareto selection;
- discrete design;
- expensive evaluation handling;
- systematic comparison with generic MOSFOA/MOPSO/etc.

---

## PAPER 4

### Working title

**Multi-Objective Optimization of a Real-World Container Wharf Using a Structural Multi-Objective Starfish Optimization Algorithm**

### Contribution

- real-world MOO;
- Pareto structural alternatives;
- engineering trade-offs;
- decision support;
- practical recommended design.

---

# 16. WORKING RELATIONSHIP: CHATGPT VS CLAUDE PRO

## ChatGPT — preferred roles

Use ChatGPT for:

- research architecture;
- literature synthesis;
- research gap;
- algorithm formulation;
- experiment design;
- mathematical formulation;
- paper structure;
- review of results;
- cross-module consistency;
- final integration decisions.

## Claude Pro — preferred roles

Use Claude Pro for:

- repository-scale code inspection;
- implementation work;
- refactoring;
- test generation;
- static consistency checks;
- reviewing large codebases;
- implementation documentation;
- repetitive code changes.

## Critical rule

Neither AI is allowed to silently change:

- research objective;
- architecture;
- module interface;
- workflow;
- design freeze;
- variable definitions;
- data schema.

Any proposed change must be recorded as:

```text
CHANGE PROPOSAL
Reason
Impact
Files affected
Tests required
Decision
```

---

# 17. HANDOFF PROTOCOL BETWEEN CHATGPT AND CLAUDE

Every major task should end with a handoff block:

```text
TASK ID:
TASK NAME:

OBJECTIVE:
INPUTS:
EXPECTED OUTPUT:

FILES TO MODIFY:
FILES NOT TO MODIFY:

INTERFACES:
CONSTRAINTS:

ACCEPTANCE CRITERIA:

TESTS REQUIRED:

DO NOT:
```

Claude returns:

```text
IMPLEMENTED:
FILES CHANGED:
TESTS:
RESULT:
KNOWN ISSUES:
NEXT ACTION:
```

ChatGPT then reviews against the research specification.

---

# 18. VERSION CONTROL RULE

Use:

```text
MASTER PLAN
DESIGN FREEZE
IMPLEMENTATION
EXPERIMENT
RESULTS
PAPER
```

as separate conceptual layers.

Không trộn:

```text
research idea
```

với:

```text
implemented feature
```

---

# 19. CHANGE CONTROL

Mọi thay đổi architecture phải có:

```text
Change ID
Date
Reason
Old design
New design
Impact
Decision
```

Ví dụ:

```text
CHG-001
Reason: expensive SAP2000 evaluations
Proposal: add evaluation cache
Impact: M5 only
Status: APPROVED
```

---

# 20. CURRENT DESIGN FREEZE

## Research direction

LOCKED:

```text
SFOA
→ Structural SFOA
→ Real-world SAP2000
→ SMOSFOA
→ Real-world MOO
```

## Main real-world case

LOCKED TARGET:

> Container wharf / port structural system

## Main baseline comparison

LOCKED INITIAL:

```text
PSO vs SFOA
```

## Multi-objective baseline

Candidate:

```text
MOPSO
MOSFOA
SMOSFOA
```

Final list requires literature/experiment justification.

## Programming direction

Primary implementation direction:

> Python-centered framework with SAP2000 integration.

MATLAB may be retained only where needed for reference/baseline/verification.

---

# 21. WHAT MUST NOT HAPPEN

Không:

1. tự ý đổi SFOA core;
2. tự ý gọi một cải tiến nhỏ là "new algorithm";
3. copy MOSFOA rồi đổi tên;
4. thêm 10 kỹ thuật metaheuristic vào cùng một algorithm;
5. chạy benchmark mà không có statistical protocol;
6. tối ưu SAP2000 trước khi model verification;
7. để objective function chứa trực tiếp toàn bộ SAP automation;
8. để AI tự ý đổi interface;
9. thay đổi design freeze chỉ vì một lỗi implementation;
10. tuyên bố paper novelty trước literature verification.

---

# 22. IMMEDIATE EXECUTION PLAN

## Phase 0 — Literature freeze

### Tasks

- [ ] Đọc SFOA original paper.
- [ ] Đọc MOSFOA paper.
- [ ] Lập comparison matrix.
- [ ] Lập novelty matrix.
- [ ] Xác định structural optimization literature.
- [ ] Xác định SAP2000 optimization literature.
- [ ] Xác định TCVN design/check scope.

### Output

```text
Literature_Map.md
Novelty_Matrix.md
Algorithm_Baseline.md
```

---

## Phase 1 — SFOA baseline

- [ ] Implement SFOA independently.
- [ ] Unit test each operator.
- [ ] Reproduce selected known benchmark.
- [ ] Fix random seed protocol.
- [ ] Implement PSO baseline.
- [ ] Establish experiment runner.

### Output

```text
SFOA baseline
PSO baseline
Experiment runner
Benchmark results
```

---

## Phase 2 — Structural benchmark

- [ ] 10-bar truss.
- [ ] Additional structural benchmark.
- [ ] Constraint handler.
- [ ] Discrete variable handler.
- [ ] 30 independent runs.
- [ ] Statistical analysis.

### Output

```text
P1 dataset
P1 tables
P1 figures
Paper 1 draft
```

---

## Phase 3 — SAP2000 integration

- [ ] MasterModel.sdb verification.
- [ ] SAP session manager.
- [ ] Model update.
- [ ] Analysis runner.
- [ ] Result extraction.
- [ ] Structural evaluator.
- [ ] Objective calculator.
- [ ] Constraint calculator.
- [ ] End-to-end single evaluation test.

### Output

```text
Verified SAP2000 pipeline
```

---

## Phase 4 — Real-world single-objective optimization

- [ ] SFOA + SAP2000.
- [ ] PSO + SAP2000.
- [ ] evaluation cache.
- [ ] failure recovery.
- [ ] experiment logging.
- [ ] independent runs.
- [ ] statistical comparison.

### Output

```text
Paper 2 dataset
Paper 2 figures
Paper 2 draft
```

---

## Phase 5 — SMOSFOA

- [ ] Pareto engine.
- [ ] archive.
- [ ] NDS.
- [ ] CD.
- [ ] structural constraint ranking.
- [ ] discrete handling.
- [ ] expensive evaluation manager.
- [ ] unit tests.
- [ ] benchmark tests.
- [ ] comparison with MOSFOA.

### Output

```text
SMOSFOA v1
```

---

## Phase 6 — Real-world MOO

- [ ] finalize objectives;
- [ ] finalize constraints;
- [ ] run MOPSO;
- [ ] run MOSFOA;
- [ ] run SMOSFOA;
- [ ] calculate HV;
- [ ] calculate IGD;
- [ ] calculate KKTPM if feasible;
- [ ] statistical analysis;
- [ ] Pareto visualization;
- [ ] engineering decision.

### Output

```text
Paper 4 dataset
Paper 4 figures
Paper 4 draft
```

---

# 23. DEFINITION OF DONE

Một module chỉ được coi là DONE khi:

```text
Code exists
+
Interface documented
+
Unit tests pass
+
Integration test pass
+
Input/output verified
+
Logging exists
+
Reproducibility verified
+
No unexplained warnings
```

Một research stage chỉ DONE khi:

```text
Implementation
+
Validation
+
Experiment
+
Statistics
+
Figures
+
Tables
+
Interpretation
```

---

# 24. FIRST PRIORITY

Từ thời điểm tạo file này, ưu tiên công việc theo thứ tự:

```text
1. Literature / novelty freeze
2. SFOA baseline
3. PSO baseline
4. Structural benchmark
5. SAP2000 verified pipeline
6. SFOA + SAP2000
7. Paper 1
8. Paper 2
9. SMOSFOA
10. Real-world MOO
11. Paper 3
12. Paper 4
```

Không nhảy trực tiếp sang SMOSFOA khi P1/P2 chưa có baseline đủ sạch.

---

# 25. MASTER RESEARCH PRINCIPLE

> **First reproduce. Then validate. Then integrate. Then extend. Then optimize. Then generalize.**

Hay cụ thể hơn:

```text
REPRODUCE
   ↓
VALIDATE
   ↓
STRUCTURALIZE
   ↓
INTEGRATE SAP2000
   ↓
EXTEND TO MOO
   ↓
VALIDATE AGAINST BASELINES
   ↓
REAL-WORLD APPLICATION
   ↓
ENGINEERING DECISION
```

Đây là nguyên tắc xuyên suốt toàn bộ dự án.

---

# 26. SOURCE BASIS

Primary source used to shape this roadmap:

- `MOSFOA.pdf`
- Scientific Reports (2026), paper describing MOSFOA as an extension of SFOA using NDS and Crowding Distance, with benchmark, constrained engineering, OPF and speed-reducer evaluations.

Important source-derived points incorporated into this roadmap:

- MOSFOA extends SFOA with NDS/CD.
- MOSFOA evaluates ZDT/DTLZ and constrained engineering problems.
- MOSFOA uses IGD/HV and additionally KKTPM.
- Statistical evaluation includes Wilcoxon/Friedman.
- MOSFOA uses repeated independent runs.
- The paper includes real-world engineering applications but is not a SAP2000/container-wharf structural optimization study.

These points are treated as **literature baseline**, not as claims that the proposed SMOSFOA is already novel. Novelty must be verified against a broader literature review before publication.

---

# 27. MASTER STATUS BOARD

## Research

- [ ] Literature freeze
- [ ] Novelty matrix
- [ ] P1
- [ ] P2
- [ ] P3
- [ ] P4

## Software

- [ ] SFOA
- [ ] PSO
- [ ] Structural evaluator
- [ ] SAP interface
- [ ] Experiment runner
- [ ] Multi-objective engine
- [ ] SMOSFOA
- [ ] Decision support

## Validation

- [ ] Benchmark
- [ ] Structural checks
- [ ] SAP model
- [ ] SAP automation
- [ ] Statistical protocol
- [ ] Reproducibility

## Publications

- [ ] Paper 1
- [ ] Paper 2
- [ ] Paper 3
- [ ] Paper 4

---

# 28. SESSION START TEMPLATE

Khi mở chat mới với ChatGPT hoặc Claude Pro, dùng:

```text
Đây là MASTER RESEARCH ROADMAP của dự án.

Hãy đọc file này trước khi làm việc.

Vai trò của bạn trong phiên này:
[ghi nhiệm vụ]

Stage hiện tại:
[ghi P1/P2/P3/P4]

Task ID:
[ghi ID]

Files liên quan:
[ghi files]

Design Freeze:
Không tự ý thay đổi architecture/interface/workflow.
Nếu thấy cần thay đổi, chỉ tạo CHANGE PROPOSAL.

Expected output:
[ghi output]

Acceptance criteria:
[ghi tiêu chí]
```

---

# END OF MASTER ROADMAP
