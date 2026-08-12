# 00_RESEARCH_CONTEXT_P1_to_MOSFOA.md

# BỐI CẢNH NGHIÊN CỨU DÀI HẠN
## Tối ưu kết cấu BTCT bến cảng thực tế bằng SFOA → phát triển MOSFOA

**Phiên bản:** 1.0  
**Ngày khóa:** 2026-08-10  
**Ngôn ngữ nghiên cứu:** Tiếng Việt  
**Định hướng:** Bài báo tạp chí trong nước → phát triển thuật toán MOSFOA → áp dụng lại trên chính kết cấu bến thực tế.

---

# 01. MỤC TIÊU TỔNG THỂ

Mục tiêu dài hạn của nghiên cứu là:

1. Dựng lại chính xác mô hình **3D SAP2000** của kết cấu bến BTCT thực tế theo bản vẽ/hồ sơ đã cung cấp.
2. Sử dụng mô hình này làm **baseline thực tế** để đối chứng.
3. Vận dụng thuật toán **SFOA (Starfish Optimization Algorithm)** hiện có cho bài toán tối ưu đơn mục tiêu.
4. Sử dụng **PSO** làm thuật toán đối chứng.
5. Hoàn thành **Paper 1** về khả năng vận dụng SFOA cho bài toán tối ưu kết cấu bến BTCT thực tế.
6. Sau Paper 1, nghiên cứu sâu SFOA và các biến thể đa mục tiêu đã có.
7. Xác định khoảng trống để phát triển một biến thể **MOSFOA của riêng nghiên cứu**.
8. Kiểm chứng MOSFOA trên benchmark cần thiết.
9. Cuối cùng triển khai MOSFOA trên **chính kết cấu bến theo bản vẽ thực tế**.
10. Hình thành chuỗi bài báo liên tục: ứng dụng → phân tích hạn chế → phát triển thuật toán → ứng dụng kỹ thuật thực tế.

---

# 02. NGUYÊN TẮC NGHIÊN CỨU ĐÃ KHÓA

## 2.1. Mô hình kết cấu

SAP2000 phải là:

> **Kết cấu bến BTCT thực tế theo bản vẽ/hồ sơ đã cung cấp.**

Không thay bằng:

- khung 2D giả định;
- benchmark kết cấu đơn giản;
- khung BTCT mẫu;
- mô hình thuận tiện cho thuật toán.

## 2.2. Mô hình SAP

Phải dựng **3D**.

Không dựng 2D rồi chuyển sang 3D.

Mô hình 3D phải thể hiện đúng hệ:

- cọc;
- dầm ngang;
- dầm dọc;
- dầm cần trục;
- sàn;
- liên kết;
- điều kiện biên/nền cọc phù hợp hồ sơ.

## 2.3. Baseline

Mô hình và thiết kế ban đầu theo hồ sơ là:

> **BASELINE**

Baseline dùng để:

- kiểm chứng mô hình SAP;
- đối chứng nội lực/chuyển vị;
- đối chứng thiết kế;
- so sánh với nghiệm tối ưu.

## 2.4. SFOA

Không tuyên bố:

> “SFOA là thuật toán mới.”

P1 chỉ:

> **vận dụng SFOA hiện có vào bài toán tối ưu kết cấu bến BTCT thực tế.**

## 2.5. PSO

PSO là:

> **thuật toán đối chứng**.

Không ép kết quả để SFOA phải thắng PSO.

## 2.6. MOSFOA

MOSFOA là mục tiêu phát triển thuật toán ở giai đoạn sau.

MOSFOA phải:

> **khác biệt có cơ sở so với các biến thể multi-objective SFOA đã công bố.**

Không chỉ đổi tên SFOA thành MOSFOA.

---

# 03. CÔNG TRÌNH NGHIÊN CỨU

Đối tượng là:

> **Kết cấu bến số 5, số 6 – Khu Bến cảng Lạch Huyện, Hải Phòng**

Theo hồ sơ đã cung cấp.

Phạm vi trọng tâm hiện tại:

> **Giai đoạn 4 — Vận hành và khai thác**

Hệ kết cấu:

> **dầm – bản trên nền cọc**

Các nhóm cấu kiện chính theo hồ sơ:

- cọc PHC;
- dầm cần trục;
- dầm ngang;
- dầm dọc;
- sàn BTCT.

---

# 04. CÁC SỐ LIỆU CƠ SỞ ĐÃ ĐỌC TỪ HỒ SƠ

## 4.1. Kích thước tổng thể dùng trong hồ sơ

- Chiều dài bến: **300 m**
- Chiều rộng bến: **50 m**
- Cao độ mặt bến: khoảng **+5,50 m CD**
- Cao độ nạo vét: **−18,40 m CD**

**Lưu ý:** 300 × 50 m không được tự chia thành lưới SAP. Lưới trục/cọc phải lấy từ bản vẽ kết cấu.

## 4.2. Cọc PHC

- Đường kính: **D = 800 mm**
- Chiều dày thành cọc: **140 mm**
- Bê tông: **fck = 80 MPa**

## 4.3. Dầm cần trục

- B = **1500 mm**
- H = **1800 mm**
- fck = **35 MPa**

## 4.4. Dầm ngang

- B = **1500 mm**
- H = **1800 mm**
- fck = **35 MPa**

## 4.5. Dầm dọc 1

- B = **1500 mm**
- H = **1800 mm**
- fck = **35 MPa**

## 4.6. Dầm dọc 2

- B = **1000 mm**
- H = **1400 mm**
- fck = **35 MPa**

## 4.7. Sàn

- chiều dày: **400 mm**
- fck = **35 MPa**

## 4.8. Khối lượng riêng

- BTCT: **25 kN/m³**
- bê tông không cốt thép: **24 kN/m³**
- thép: **78,5 kN/m³**

---

# 05. CÁC NHÓM TẢI CHÍNH

Mô hình SAP phải kế thừa hệ tải từ hồ sơ, không tự thay bằng benchmark.

Các nhóm chính:

- Self Weight
- Finish
- Cargo / Live Load
- STS Crane
- Berthing
- Mooring
- Wind
- Wave
- Current
- Temperature
- các tải thi công/liên quan nếu thuộc trạng thái được xét.

Tải hàng hóa khai thác trong hồ sơ có giá trị:

\[
q = 40\;kN/m^2
\]

Hồ sơ có nhiều sơ đồ LL1–LL11, phải dựng đúng phân bố theo các hình trong hồ sơ.

---

# 06. CẦN TRỤC STS

Thông số cơ sở:

- khẩu độ ray: **30,48 m**
- trọng lượng bản thân cẩu: **1652 t**
- số chân: **4**
- số bánh/chân: **8**
- khoảng cách bánh: **1,2 m**
- khoảng cách tim hai chân: **15 m**
- tải bánh phía biển – khai thác: **101 t/bánh**
- tải bánh phía bờ – khai thác: **63 t/bánh**
- tải bánh phía biển – cực hạn: **84 t/bánh**
- tải bánh phía bờ – cực hạn: **106 t/bánh**

Tải ngang cần trục:

\[
H=0,10V
\]

Cần trục phải được mô hình theo không gian và vị trí bánh/ray phù hợp, không quy đổi tùy tiện thành một UDL.

---

# 07. TẢI MÔI TRƯỜNG

## Gió

- Operation: **20,70 m/s**
- Extreme: **38,61 m/s**

## Sóng

- Operation: **Hs = 0,50 m**
- Extreme: **Hs = 1,37 m**

## Dòng chảy

- phương dọc: khoảng **1,55 m/s**
- phương ngang: khoảng **0,50 m/s**

## Nhiệt độ

- \(\Delta T = -9,8^\circ C\)
- \(\Delta T = +14,8^\circ C\)

## Tải va tàu và neo tàu

Phải đặt đúng vị trí, phương và cơ chế truyền lực theo hồ sơ/bản vẽ; không tự phân phối lực đều cho cọc.

---

# 08. TỔ HỢP TẢI

Hồ sơ có các nhóm:

- QP
- SLS
- ULS-B
- ULS-C

Phải lấy hệ số và thành phần từ bảng tổ hợp trong hồ sơ.

Không tự suy diễn hệ số tổ hợp khi chưa kiểm tra bảng gốc.

---

# 09. LỘ TRÌNH PAPER 1

# PAPER 1

## Tên làm việc

> **Nghiên cứu ứng dụng thuật toán Starfish Optimization Algorithm trong tối ưu đơn mục tiêu kết cấu bê tông cốt thép của công trình bến cảng thực tế bằng mô hình SAP2000 điều khiển bởi MATLAB**

Tên chính thức sẽ chỉnh sau khi có kết quả.

---

# 10. MỤC TIÊU PAPER 1

Mục tiêu:

> Đánh giá khả năng vận dụng SFOA hiện có cho bài toán tối ưu đơn mục tiêu của kết cấu BTCT bến cảng thực tế thông qua MATLAB–SAP2000, với PSO làm đối chứng.

Không đặt mục tiêu:

> chứng minh SFOA là thuật toán mới.

Không đặt mục tiêu:

> chứng minh SFOA luôn tốt hơn PSO.

---

# 11. CÂU HỎI NGHIÊN CỨU P1

### RQ1

SFOA có thể giải hiệu quả bài toán tối ưu đơn mục tiêu kết cấu BTCT bến cảng thực tế thông qua SAP2000 hay không?

### RQ2

SFOA có thể tìm được thiết kế rời rạc có lượng vật liệu thấp nhưng vẫn thỏa mãn các điều kiện thiết kế hay không?

### RQ3

SFOA và PSO khác nhau thế nào về:

- chất lượng nghiệm;
- độ ổn định;
- khả năng tìm nghiệm khả thi;
- số lần phân tích SAP2000;
- thời gian tính toán;
- tốc độ hội tụ?

### RQ4

Những điều kiện thiết kế nào chi phối nghiệm tối ưu?

---

# 12. TÍNH MỚI P1 ĐÃ KHÓA

Không claim:

- SFOA mới;
- MATLAB–SAP2000 mới;
- PSO mới;
- tối ưu trọng lượng mới;
- metaheuristic mới.

Novelty của P1 là ở **sự kết hợp và kiểm chứng trên bài toán thực tế**:

> **Tối ưu đơn mục tiêu kết cấu BTCT bến cảng thực tế, có biến thiết kế rời rạc và nhiều ràng buộc, sử dụng SFOA trong vòng lặp phân tích SAP2000 được điều khiển bởi MATLAB, với thiết kế hồ sơ làm baseline và PSO làm đối chứng.**

Điểm nhấn:

```text
REAL PORT STRUCTURE
        +
3D SAP2000 MODEL
        +
DISCRETE RC DESIGN
        +
REALISTIC LOAD MODEL
        +
SFOA
        +
PSO COMPARATOR
        +
ENGINEERING INTERPRETATION
```

---

# 13. ĐỀ CƯƠNG PAPER 1

## 1. MỞ ĐẦU

### 1.1. Bối cảnh

- nhu cầu tối ưu kết cấu;
- kết cấu cảng có tải trọng và điều kiện khai thác phức tạp;
- FEA-based optimization có chi phí tính toán cao.

### 1.2. Tổng quan nghiên cứu

- structural optimization;
- PSO;
- SFOA;
- MATLAB–SAP2000;
- tối ưu BTCT;
- các nghiên cứu SFOA trong engineering.

### 1.3. Khoảng trống

Chỉ ra:

- SFOA đã có;
- MATLAB–SAP2000 đã có;
- PSO đã có;
- nhưng bài toán cụ thể của nghiên cứu là kết cấu bến BTCT thực tế, mô hình 3D, thiết kế rời rạc và hệ tải/ràng buộc thực.

### 1.4. Mục tiêu

Đánh giá SFOA trên bài toán thực.

### 1.5. Đóng góp

1. Xây dựng bài toán tối ưu từ kết cấu bến thực.
2. Dựng và kiểm chứng mô hình SAP2000 3D.
3. Tích hợp MATLAB–SAP2000 với SFOA.
4. So sánh công bằng với PSO.
5. Phân tích kết quả dưới góc độ kỹ thuật kết cấu.

---

# 14. CHƯƠNG 2 — CƠ SỞ LÝ THUYẾT

## 2.1. Tối ưu kết cấu

\[
\min W(x)
\]

subject to:

\[
g_j(x)\le0
\]

## 2.2. SFOA

- nguyên lý;
- biểu diễn quần thể;
- cơ chế cập nhật;
- exploration;
- exploitation;
- tham số.

**Không tuyên bố SFOA mới.**

## 2.3. PSO

- nguyên lý;
- cập nhật vận tốc;
- cập nhật vị trí;
- tham số.

## 2.4. Xử lý biến rời rạc

- đường kính;
- số thanh;
- bước thép;
- các giá trị section hợp lệ.

---

# 15. CHƯƠNG 3 — MÔ HÌNH KẾT CẤU BẾN

## 3.1. Giới thiệu công trình

- vị trí;
- quy mô;
- phạm vi nghiên cứu.

## 3.2. Hệ kết cấu

- cọc PHC;
- dầm;
- sàn;
- ray cần trục;
- liên kết.

## 3.3. Mô hình SAP2000 3D

- grid;
- geometry;
- materials;
- sections;
- supports;
- pile;
- shell;
- frame.

## 3.4. Tải trọng

- self weight;
- cargo;
- crane;
- wind;
- wave;
- current;
- berthing;
- mooring;
- temperature.

## 3.5. Tổ hợp tải

- QP;
- SLS;
- ULS-B;
- ULS-C.

## 3.6. Kiểm chứng baseline

So sánh:

- chuyển vị;
- nội lực;
- phản lực;
- thiết kế BTCT;
- các giá trị có trong hồ sơ.

**Chỉ khi baseline đạt mới chuyển sang tối ưu.**

---

# 16. CHƯƠNG 4 — XÂY DỰNG BÀI TOÁN TỐI ƯU

## 4.1. Biến thiết kế

Chỉ xác định sau khi audit model.

Có thể gồm:

- kích thước section;
- đường kính thép;
- số lượng thanh;
- cốt đai;
- bước đai;
- các biến cấu tạo phù hợp.

Không tự khóa trước khi xem model thực.

## 4.2. Objective

\[
\boxed{\min W(x)}
\]

## 4.3. Constraints

Nhóm:

- ULS;
- uốn;
- cắt;
- nứt;
- chuyển vị;
- cốt thép tối thiểu;
- cốt thép tối đa;
- cấu tạo.

## 4.4. Discrete decoder

\[
z\rightarrow x_{discrete}
\]

Dùng giống nhau cho SFOA và PSO.

## 4.5. Feasibility

Feasible > infeasible.

Trong nhóm feasible:

\[
W_{min}
\]

---

# 17. CHƯƠNG 5 — THIẾT KẾ THỰC NGHIỆM

## 5.1. SFOA

- population;
- parameters;
- stopping;
- FE budget.

## 5.2. PSO

Cấu hình tương đương về:

- population;
- FE budget;
- stopping;
- design domain.

## 5.3. Independent runs

Mục tiêu dự kiến:

> **30 independent runs**

Số lượng chính thức sẽ khóa trong protocol thực nghiệm.

## 5.4. Chỉ tiêu

- Best;
- Worst;
- Mean;
- Std;
- COV;
- feasibility rate;
- FE;
- SAP2000 calls;
- runtime;
- convergence.

## 5.5. Statistical analysis

So sánh SFOA và PSO bằng phương pháp thống kê phù hợp dữ liệu.

---

# 18. CHƯƠNG 6 — KẾT QUẢ

## 6.1. Baseline

\[
W_0
\]

## 6.2. SFOA

\[
W_{SFOA}
\]

## 6.3. PSO

\[
W_{PSO}
\]

## 6.4. Saving

\[
Saving=
\frac{W_0-W^*}{W_0}\times100\%
\]

## 6.5. Convergence

So sánh theo:

\[
Best(FE)
\]

## 6.6. Feasibility

Tỷ lệ nghiệm khả thi.

## 6.7. Statistical comparison

Best/mean/std/COV và kiểm định.

---

# 19. CHƯƠNG 7 — PHÂN TÍCH KỸ THUẬT

Đây là phần rất quan trọng.

Không chỉ nói:

> SFOA nhẹ hơn PSO.

Mà phân tích:

- constraint nào chi phối;
- utilization nào gần 1;
- crack;
- shear;
- displacement;
- reinforcement demand;
- thay đổi so với baseline.

Mục tiêu:

> biến kết quả thuật toán thành **insight kỹ thuật kết cấu**.

---

# 20. CHƯƠNG 8 — KẾT LUẬN

Trả lời RQ1–RQ4.

Không tuyên bố vượt quá kết quả.

Nếu PSO tốt hơn ở một số chỉ tiêu, phải ghi nhận.

Nếu SFOA tốt hơn, chỉ kết luận trong phạm vi bài toán và protocol đã xét.

---

# 21. PIPELINE PAPER 1

```text
BẢN VẼ + HỒ SƠ
        ↓
DỰNG SAP2000 3D
        ↓
BASELINE VERIFICATION
        ↓
FREEZE MODEL
        ↓
XÁC ĐỊNH DESIGN VARIABLES
        ↓
XÂY EVALUATOR
        ↓
SFOA ───────── PSO
  │               │
  └──────┬────────┘
         ↓
    CÙNG SAP MODEL
         ↓
    CÙNG LOAD MODEL
         ↓
    CÙNG CONSTRAINTS
         ↓
   THỰC NGHIỆM 30 RUNS
         ↓
 STATISTICS + ENGINEERING
         ↓
       PAPER 1
```

---

# 22. PHASE 0 — DỰNG BASELINE SAP2000

**Trạng thái:** ĐANG THỰC HIỆN

### Việc cần làm

1. Đọc bản vẽ kết cấu.
2. Xác định grid 3D.
3. Xác định tọa độ cọc.
4. Xác định cao độ.
5. Dựng cọc.
6. Dựng dầm dọc.
7. Dựng dầm ngang.
8. Dựng dầm cần trục.
9. Dựng sàn.
10. Gán vật liệu.
11. Gán section.
12. Gán boundary/pile model.
13. Gán self weight.
14. Gán tải khai thác.
15. Gán tải cần trục.
16. Gán tải môi trường.
17. Gán tải neo/va.
18. Tạo combinations.
19. Chạy analysis.
20. So sánh với hồ sơ.

**Chưa tối ưu.**

---

# 23. PHASE 1 — PAPER 1 / SFOA

## P1.1

Baseline SAP2000 3D.

## P1.2

MATLAB đọc/điều khiển SAP2000.

## P1.3

Xác định design variables từ model thực.

## P1.4

Xây evaluator:

\[
Evaluate(x)
\]

## P1.5

Verification.

## P1.6

SFOA.

## P1.7

PSO.

## P1.8

30 independent runs.

## P1.9

Statistical analysis.

## P1.10

Engineering interpretation.

## P1.11

Viết Paper 1.

---

# 24. PHASE 2 — NGHIÊN CỨU SFOA SÂU

Sau khi P1 hoàn thành:

1. Phân tích cơ chế SFOA.
2. Phân tích exploration/exploitation.
3. Phân tích hội tụ.
4. Phân tích nhạy tham số.
5. Benchmark.
6. Tổng hợp các biến thể SFOA đã công bố.
7. Đặc biệt rà soát các biến thể multi-objective SFOA.

Mục tiêu:

> tìm ra **hạn chế thực sự** cần giải quyết, không tạo biến thể chỉ để tạo biến thể.

---

# 25. PHASE 3 — PHÁT TRIỂN MOSFOA

## 25.1. Xác định gap

\[
SFOA
\rightarrow
limitation
\rightarrow
research gap
\]

## 25.2. Thiết kế MOSFOA

Có thể nghiên cứu các thành phần như:

- archive;
- non-dominated sorting;
- diversity preservation;
- adaptive search;
- leader selection;
- constraint handling;
- hoặc cơ chế mới phù hợp với SFOA.

**Không khóa trước cơ chế nào.**

Phải xuất phát từ gap được chứng minh.

## 25.3. MOSFOA phải khác literature

Trước khi đặt tên/claim:

> lập bảng so sánh MOSFOA với các biến thể SFOA đa mục tiêu đã công bố.

---

# 26. PHASE 4 — VALIDATION MOSFOA

MOSFOA phải được kiểm chứng theo nhiều tầng:

### Tầng 1

Benchmark functions.

### Tầng 2

Benchmark multi-objective chuẩn.

### Tầng 3

Engineering benchmark.

### Tầng 4

Bài toán kết cấu thực.

Mục tiêu:

> chứng minh thuật toán trước khi áp dụng vào công trình bến.

---

# 27. PHASE 5 — MOSFOA TRÊN KẾT CẤU BẾN

Giữ lại:

> **chính mô hình SAP2000 3D của công trình bến.**

Thay:

```text
SFOA
```

bằng:

```text
MOSFOA
```

và chuyển từ:

\[
\min W
\]

sang bài toán đa mục tiêu, ví dụ có thể gồm:

\[
\min W(x)
\]

\[
\min Cost(x)
\]

hoặc các objective kỹ thuật phù hợp.

**Objective chính thức chưa khóa.**

---

# 28. CHUỖI PAPER DỰ KIẾN

## Paper 1

### SFOA + PSO + kết cấu bến thực tế

Mục tiêu:

> đánh giá SFOA trên bài toán thực.

---

## Paper 2

### Phát triển MOSFOA

Mục tiêu:

> thuật toán multi-objective mới dựa trên hạn chế/gap được chứng minh.

Trọng tâm:

- algorithmic novelty;
- mathematical formulation;
- benchmark;
- comparison với các MOO algorithms;
- ablation/sensitivity.

---

## Paper 3

### Ứng dụng MOSFOA cho kết cấu bến thực tế

Mục tiêu:

> giải bài toán multi-objective trên chính mô hình bến.

Ví dụ:

```text
Mass
Cost
Performance
```

Objective chính thức sẽ quyết định sau.

---

# 29. QUAN HỆ GIỮA CÁC PAPER

```text
                 REAL PORT STRUCTURE
                         │
                         ▼
                  3D SAP2000 MODEL
                         │
                         ▼
                   BASELINE DATA
                         │
                         ▼
        ┌────────────────┴────────────────┐
        │                                 │
        ▼                                 ▼
      PSO                              SFOA
        │                                 │
        └──────────────┬──────────────────┘
                       ▼
                    PAPER 1
                       │
                       ▼
              SFOA limitation analysis
                       │
                       ▼
                 Research gap
                       │
                       ▼
                  MOSFOA
                       │
                       ▼
                    PAPER 2
                       │
                       ▼
              MOSFOA validation
                       │
                       ▼
          SAME REAL PORT STRUCTURE
                       │
                       ▼
                    PAPER 3
```

---

# 30. NGUYÊN TẮC QUẢN LÝ CODE

Kiến trúc code dài hạn phải tách:

```text
Optimizer
    ↓
Problem
    ↓
Evaluator
    ↓
SAP2000
```

SFOA không được chứa code SAP2000.

PSO không được chứa code SAP2000.

MOSFOA sau này cũng không được chứa code SAP2000.

Tất cả gọi chung:

```text
evaluate(x)
```

Như vậy khi chuyển:

```text
SFOA → MOSFOA
```

mô hình kết cấu không phải viết lại.

---

# 31. NGUYÊN TẮC QUẢN LÝ MÔ HÌNH

Có ba trạng thái:

## MASTER MODEL

Mô hình SAP2000 gốc được kiểm chứng.

## OPTIMIZATION COPY

Bản sao dùng cho optimizer.

## RESULT MODEL

Lưu nghiệm tối ưu để hậu kiểm.

Không để optimizer phá hỏng MASTER MODEL.

---

# 32. BASELINE CONTROL

Baseline phải lưu:

- geometry;
- sections;
- materials;
- reinforcement;
- load cases;
- combinations;
- analysis settings;
- design settings;
- kết quả tham chiếu.

Mọi kết quả tối ưu đều phải so với baseline.

---

# 33. CÁC GATE BẮT BUỘC

## Gate 1

3D SAP model dựng đúng.

## Gate 2

Baseline analysis chạy được.

## Gate 3

Baseline phù hợp hồ sơ.

## Gate 4

MATLAB điều khiển SAP được.

## Gate 5

Một `evaluate(x)` chạy đúng.

## Gate 6

Một biến thiết kế thay đổi được và SAP phản ánh đúng.

## Gate 7

SFOA chạy được.

## Gate 8

PSO chạy được.

## Gate 9

30 runs ổn định.

## Gate 10

Paper 1 hoàn chỉnh.

Chỉ sau Gate 10 mới bước sang phát triển MOSFOA.

---

# 34. NHỮNG ĐIỀU KHÔNG ĐƯỢC TỰ Ý THAY ĐỔI

1. Không đổi từ 3D sang 2D.
2. Không đổi sang benchmark giả lập.
3. Không bỏ baseline thực tế.
4. Không tự chọn cấu kiện tối ưu trước khi kiểm tra model.
5. Không tự chọn design variables trước khi audit model.
6. Không tuyên bố SFOA mới.
7. Không ép SFOA thắng PSO.
8. Không phát triển MOSFOA trước khi phân tích gap.
9. Không gọi một biến thể nhỏ là “mới” nếu chưa so sánh literature.
10. Không chạy optimization trước khi baseline verification đạt.

---

# 35. TRẠNG THÁI HIỆN TẠI

### Đã khóa

- [x] Đối tượng: kết cấu BTCT bến cảng thực tế.
- [x] SAP2000: mô hình 3D.
- [x] Baseline: theo hồ sơ/bản vẽ.
- [x] P1: SFOA.
- [x] PSO: comparator.
- [x] P1: single-objective.
- [x] MATLAB điều khiển SAP2000.
- [x] Không claim SFOA mới.
- [x] Sau P1: phát triển MOSFOA.
- [x] MOSFOA phải có khác biệt với literature.
- [x] Sau đó áp dụng MOSFOA trên chính kết cấu bến.
- [x] P1 phải có engineering interpretation.

### Đang thực hiện

- [ ] Dựng SAP2000 3D.
- [ ] Xác định chính xác grid từ bản vẽ.
- [ ] Dựng geometry.
- [ ] Gán materials/sections.
- [ ] Gán loads.
- [ ] Gán combinations.
- [ ] Baseline analysis.

### Chưa được khóa

- [ ] Cấu kiện tối ưu cụ thể.
- [ ] Design variables cuối cùng.
- [ ] LB/UB.
- [ ] Objective chi tiết theo phạm vi cấu kiện.
- [ ] Constraint equations chi tiết.
- [ ] FE budget.
- [ ] thông số SFOA cuối cùng cho bài toán.
- [ ] thông số PSO cuối cùng.
- [ ] Objective của MOSFOA.
- [ ] cơ chế MOSFOA.

---

# 36. NEXT ACTION — NGAY BÂY GIỜ

Không viết thêm optimizer.

Không viết MOSFOA.

Không tối ưu.

Làm:

> **DỰNG MASTER SAP2000 3D THEO BẢN VẼ.**

Thứ tự:

```text
01. Grid
02. Coordinates
03. Piles
04. Longitudinal beams
05. Transverse beams
06. Crane beams
07. Slab
08. Materials
09. Sections
10. Supports / pile model
11. Self weight
12. Finish
13. LL1–LL11
14. Crane
15. Berthing
16. Mooring
17. Wind
18. Wave
19. Current
20. Temperature
21. Load combinations
22. Analysis
23. Baseline verification
```

Sau khi baseline đạt:

```text
BASELINE
   ↓
MATLAB–SAP2000
   ↓
evaluate(x)
   ↓
SFOA / PSO
```

---

# 37. NGUYÊN TẮC KHI LÀM VIỆC VỚI CHATGPT / CLAUDE

File này là **nguồn ngữ cảnh chung**.

Khi mở phiên mới:

1. Cung cấp file này.
2. Nói rõ đang ở phase nào.
3. Không yêu cầu assistant suy đoán những phần chưa khóa.
4. Assistant phải giữ các decision freeze trong file.
5. Nếu muốn thay đổi kiến trúc nghiên cứu, phải tạo Change Proposal trước.
6. Các giá trị lấy từ hồ sơ phải ghi nguồn.
7. Các giả định mới phải ghi rõ là ASSUMPTION.
8. Không biến một giả định thành dữ liệu hồ sơ.

---

# END OF LONG-TERM RESEARCH CONTEXT
