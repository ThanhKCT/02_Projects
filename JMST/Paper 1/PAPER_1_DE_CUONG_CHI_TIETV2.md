# PAPER 1 — ĐỀ CƯƠNG CHI TIẾT

## Tên bài báo làm việc

**Ảnh hưởng của phương pháp xác định điểm ngàm tương đương của cọc đến chiều dài tính toán và đáp ứng kết cấu bến cảng trên nền cọc: nghiên cứu số bằng mô hình SAP2000 3D**

> Tên tiếng Anh làm việc:
>
> **Effects of Equivalent Pile Fixity Determination Methods on Effective Buckling Length and Structural Response of a Piled Wharf: A Three-Dimensional SAP2000 Numerical Study**

---

# 0. TRẠNG THÁI THIẾT KẾ BÀI BÁO

## 0.1. Vai trò trong chương trình nghiên cứu

Paper 1 là bài báo nền tảng của chuỗi nghiên cứu.

Mục tiêu chính:

- xây dựng baseline 3D cho một bến cảng thực;
- xác định điểm ngàm tương đương của cọc theo 6 phương pháp;
- lượng hóa sự khác biệt về `h_z` và `l_tt`;
- kiểm tra mức độ ảnh hưởng của sự khác biệt đó đến đáp ứng kết cấu;
- tạo cơ sở phương pháp luận cho các nghiên cứu tối ưu hóa kết cấu ở các paper tiếp theo.

## 0.2. Không thuộc phạm vi Paper 1

Không nghiên cứu:

- tối ưu hóa;
- PSO/SFOA/MOSFOA;
- tối ưu đa mục tiêu;
- tối ưu hình học kết cấu;
- tối ưu chi phí;
- đề xuất một phương pháp xác định điểm ngàm mới;
- thay đổi tải trọng giữa các mô hình sensitivity;
- thay đổi hình học giữa các mô hình sensitivity.

---

# 1. TITLE

## Tên tiếng Việt đề xuất

**Ảnh hưởng của phương pháp xác định điểm ngàm tương đương của cọc đến chiều dài tính toán và đáp ứng kết cấu bến cảng trên nền cọc: nghiên cứu số bằng mô hình SAP2000 3D**

## Tên tiếng Anh đề xuất

**Effects of Equivalent Pile Fixity Determination Methods on Effective Buckling Length and Structural Response of a Piled Wharf: A Three-Dimensional SAP2000 Numerical Study**

> Tên bài sẽ được rà soát lần cuối sau khi có kết quả thực nghiệm số.

---

# 2. ABSTRACT

## 2.1. Background

Nêu vấn đề:

- cọc của bến cảng trên nền cọc thường được mô hình hóa với một điểm ngàm tương đương;
- vị trí điểm ngàm ảnh hưởng đến chiều dài tính toán của cọc;
- các tiêu chuẩn/tài liệu khác nhau có thể cho các giá trị khác nhau;
- chưa rõ mức độ khác biệt đó truyền vào đáp ứng kết cấu tổng thể và nội lực cọc đến mức nào.

## 2.2. Objective

Nêu rõ hai mục tiêu:

1. So sánh vị trí điểm ngàm tương đương và chiều dài tính toán của cọc theo 6 phương pháp.
2. Định lượng ảnh hưởng của sự khác biệt này đến chuyển vị kết cấu và nội lực cọc trong mô hình bến cảng 3D.

## 2.3. Method

- mô hình SAP2000 3D của bến 100.000 DWT;
- 192 cọc;
- 178 cọc được sử dụng cho sensitivity study;
- 14 cọc giữ nguyên điều kiện biên làm nhóm kiểm soát;
- sáu phương pháp xác định điểm ngàm;
- giữ nguyên geometry, material, load cases và load combinations;
- chỉ thay đổi vị trí fixity của nhóm 178 cọc.

## 2.4. Results

Sau khi có kết quả, báo cáo:

- phạm vi biến thiên `h_z`;
- phạm vi biến thiên `l_tt`;
- mức biến thiên chuyển vị;
- mức biến thiên nội lực cọc;
- chỉ số sensitivity.

## 2.5. Conclusion

Kết luận:

- mức độ khác biệt giữa các phương pháp;
- response nào nhạy nhất;
- response nào ít nhạy;
- ý nghĩa đối với mô hình hóa bến cảng trên nền cọc.

---

# 3. KEYWORDS

Dự kiến:

- piled wharf;
- pile fixity;
- equivalent fixity depth;
- effective length;
- pile-soil interaction;
- structural sensitivity;
- SAP2000;
- numerical analysis.

---

# 4. 1. INTRODUCTION

## 4.1. Bối cảnh nghiên cứu

Trình bày:

- vai trò của bến cảng trên nền cọc;
- đặc điểm chịu lực của hệ kết cấu bến;
- cọc vừa chịu tải đứng vừa chịu tải ngang và mô men;
- ứng xử của cọc phụ thuộc đáng kể vào điều kiện liên kết với nền đất.

## 4.2. Vấn đề mô hình hóa điểm ngàm

Giải thích:

- mô hình 3D kết cấu thực tế cần biểu diễn ảnh hưởng của nền đất;
- một cách tiếp cận thực dụng là thay thế tương tác đất–cọc bằng điểm ngàm tương đương;
- vị trí điểm ngàm quyết định chiều dài phần cọc tham gia tính toán;
- thay đổi điểm ngàm có thể làm thay đổi độ cứng và nội lực của hệ.

## 4.3. Sự khác biệt giữa các phương pháp

Giới thiệu ngắn:

- 22TCN 207-92;
- 20TCN21-86 / TCXD 205-1998;
- TCVN 10304:2014;
- phương pháp Nga;
- Budin–Demina;
- phương pháp Nhật Bản.

Không đi sâu công thức ở Introduction.

## 4.4. Research gap

Khoảng trống cần khóa:

> Các phương pháp xác định điểm ngàm có thể cho các giá trị khác nhau, nhưng cần lượng hóa một cách có kiểm soát xem sự khác biệt về điểm ngàm và chiều dài tính toán có thực sự tạo ra sai khác đáng kể trong đáp ứng của một hệ bến cảng 3D thực tế hay không.

## 4.5. Research questions

### RQ1

Các phương pháp xác định điểm ngàm khác nhau tạo ra mức độ khác biệt như thế nào về `h_z` và `l_tt`?

### RQ2

Sự khác biệt đó ảnh hưởng như thế nào đến:

- chuyển vị ngang của hệ;
- mô men cọc;
- lực cắt cọc?

### RQ3

Đại lượng đáp ứng nào nhạy nhất với giả thiết điểm ngàm?

## 4.6. Objectives

### Objective 1

Định lượng sự khác biệt về:

`h_z` và `l_tt`

giữa sáu phương pháp.

### Objective 2

Định lượng ảnh hưởng của sự khác biệt đó đến:

`U_X`, `U_Y`, `M_max`, `V_max`.

## 4.7. Contributions

Bài báo đóng góp:

1. Xây dựng một thí nghiệm số có kiểm soát trên mô hình bến cảng 3D thực tế.
2. So sánh thống nhất sáu phương pháp xác định điểm ngàm trong cùng một mô hình.
3. Tách riêng ảnh hưởng của giả thiết fixity khỏi ảnh hưởng của hình học và tải trọng.
4. Định lượng mối liên hệ:

   `Method → h_z → l_tt → Structural response`.
5. Cung cấp cơ sở định lượng cho việc lựa chọn giả thiết điểm ngàm trong mô hình số bến cảng.

---

# 5. 2. CASE STUDY AND NUMERICAL MODEL

## 5.1. Mô tả công trình

Giới thiệu:

- bến 100.000 DWT;
- hệ kết cấu bến;
- kích thước chính;
- bố trí cọc;
- điều kiện địa chất có liên quan.

Chỉ đưa thông tin cần thiết để tái lập nghiên cứu.

## 5.2. Hệ cọc

Khóa các thông tin:

- tổng số cọc: 192;
- cọc PHC D800: 132;
- cọc thép D1016: 60;
- 14 cọc giữ nguyên điều kiện biên;
- 178 cọc thuộc sensitivity study.

## 5.3. Mô hình SAP2000 3D

Trình bày:

- mô hình hình học;
- hệ tọa độ;
- frame elements;
- pile elements;
- connection;
- diaphragm/constraint nếu có;
- vật liệu;
- tiết diện.

## 5.4. Load cases

Mô tả các tải trọng sử dụng trong Master model.

Không thay đổi load cases giữa các sensitivity models.

## 5.5. Load combinations

Liệt kê các nhóm combination có trong mô hình.

Đặc biệt xác định:

`BAO KT`

là governing load envelope được sử dụng để đánh giá sensitivity.

## 5.6. Kiểm tra baseline model

Kiểm tra:

- geometry;
- số lượng cọc;
- vật liệu;
- tiết diện;
- tải trọng;
- reaction;
- nội lực.

Mục tiêu là chứng minh Master model là cơ sở chung cho tất cả sensitivity models.

---

# 6. 3. METHODS FOR DETERMINING EQUIVALENT PILE FIXITY

## 6.1. Khái niệm điểm ngàm tương đương

Định nghĩa:

- `h_z`: độ sâu điểm ngàm tương đương;
- `l_tt`: chiều dài tính toán tương ứng.

Sơ đồ:

`ground level → equivalent fixity point → pile tip`

## 6.2. Method M1 — 22TCN 207-92

Trình bày:

- cơ sở phương pháp;
- dữ liệu đầu vào;
- công thức;
- cách xác định `h_z`;
- cách xác định `l_tt`;
- phạm vi áp dụng.

## 6.3. Method M2 — 20TCN21-86 / TCXD 205-1998

Trình bày tương tự M1.

## 6.4. Method M3 — TCVN 10304:2014

Trình bày tương tự.

## 6.5. Method M4 — phương pháp Nga

Trình bày:

- cơ sở lý thuyết;
- biến đầu vào;
- công thức;
- `h_z`;
- `l_tt`.

## 6.6. Method M5 — Budin–Demina

Trình bày tương tự.

## 6.7. Method M6 — phương pháp Nhật Bản

Trình bày tương tự.

## 6.8. Chuẩn hóa đầu vào

Tất cả phương pháp phải sử dụng cùng:

- geometry;
- soil parameters;
- pile properties;
- ground elevation;
- reference elevation.

Mục tiêu:

> Chỉ phương pháp xác định fixity được phép thay đổi.

---

# 7. 4. NUMERICAL EXPERIMENT DESIGN

## 7.1. Triết lý controlled experiment

Sơ đồ:

`MASTER`

↓

`Six alternative fixity definitions`

↓

`Six sensitivity models`

Các yếu tố khác giữ nguyên.

## 7.2. Master model

BASE model chứa:

- geometry;
- material;
- loads;
- original boundary conditions.

## 7.3. Six sensitivity models

| Model | Method |
|---|---|
| M1 | 22TCN 207-92 |
| M2 | 20TCN21-86 / TCXD 205-1998 |
| M3 | TCVN 10304:2014 |
| M4 | Russian method |
| M5 | Budin–Demina |
| M6 | Japanese method |

## 7.4. Control group

14 cọc được giữ nguyên điều kiện biên trong cả sáu sensitivity models.

Mục đích:

- kiểm soát sự thay đổi mô hình;
- bảo đảm sensitivity không bị nhầm với thay đổi toàn bộ hệ kết cấu.

## 7.5. Treatment group

178 cọc được cập nhật fixity theo từng phương pháp.

## 7.6. Governing load envelope

Sử dụng:

`BAO KT`

với hai trạng thái:

- Max;
- Min.

Phân tích đáp ứng theo X/Y từ cùng envelope.

Không tạo ra các combination nhân tạo chỉ để phục vụ sensitivity.

## 7.7. Response indicators

### Global response

`U_X`

`U_Y`

### Pile response

`M_max`

`V_max`

Có thể báo cáo `N` như response phụ nếu cần.

## 7.8. Sensitivity metric

Sử dụng:

`S_R = (R_max - R_min) / R_min × 100%`

Trong đó `R` là response cần đánh giá.

Có thể bổ sung:

- absolute difference;
- normalized difference;
- coefficient of variation.

Chỉ bổ sung nếu thực sự cần sau khi xem dữ liệu.

---

# 8. 5. RESULTS AND DISCUSSION

## 8.1. Variation of equivalent fixity depth

### Mục tiêu

So sánh `h_z` của sáu phương pháp.

### Kết quả cần báo cáo

Cho 178 cọc:

- min;
- max;
- mean;
- median;
- SD;
- percentile nếu cần.

### Hình

**Fig. 4 — Distribution of equivalent fixity depth for 178 sensitivity piles.**

### Discussion

Trả lời:

- phương pháp nào tạo `h_z` lớn hơn;
- phương pháp nào nhỏ hơn;
- độ phân tán;
- sự khác biệt có mang tính hệ thống hay không.

---

# 9. 5.2. Variation of effective calculation length

So sánh:

`l_tt = f(h_z)`

cho sáu phương pháp.

### Kết quả

Bảng:

| Method | min | max | mean | median | SD |
|---|---:|---:|---:|---:|---:|

### Discussion

Làm rõ:

> khác biệt trong `h_z` chuyển thành khác biệt như thế nào trong chiều dài tính toán.

---

# 10. 5.3. Global displacement sensitivity

So sánh:

`U_X`

`U_Y`

giữa:

- BASE;
- M1;
- M2;
- M3;
- M4;
- M5;
- M6.

### Hình

**Fig. 5 — Comparison of global displacement responses.**

### Phân tích

- absolute response;
- percentage difference;
- sensitivity index.

### Câu hỏi

Các phương pháp fixity có làm thay đổi đáng kể chuyển vị toàn hệ không?

---

# 11. 5.4. Pile bending-moment sensitivity

Đánh giá:

`M_max`

cho 178 cọc.

### Báo cáo

- maximum;
- mean;
- median;
- distribution;
- governing pile.

### Hình

**Fig. 6 — Comparison of maximum pile bending moment.**

### Discussion

Xác định:

- method gây `M_max` lớn nhất;
- method gây `M_max` nhỏ nhất;
- vị trí cọc nhạy;
- mức sensitivity.

---

# 12. 5.5. Pile shear-force sensitivity

Đánh giá:

`V_max`

tương tự mô men.

Nếu dữ liệu cho thấy V rất nhỏ hoặc không có ý nghĩa so sánh, chuyển thành response phụ.

---

# 13. 5.6. Spatial distribution of sensitivity

Không chỉ so sánh giá trị tổng hợp.

Phân tích:

- vùng cọc nhạy;
- vùng cọc ít nhạy;
- vị trí theo mặt bằng;
- nhóm cọc theo hướng;
- nhóm cọc theo loại tiết diện.

Mục tiêu:

> xác định sensitivity có mang tính cục bộ hay toàn hệ.

---

# 14. 5.7. From fixity assumption to structural response

Đây là phần quan trọng nhất về mặt khoa học.

Xây dựng chuỗi:

`Method`

↓

`h_z`

↓

`l_tt`

↓

`U_X / U_Y`

↓

`M_max / V_max`

Có thể sử dụng scatter plot nếu dữ liệu đủ tốt.

Phân tích tương quan:

- `h_z` vs `U`;
- `h_z` vs `M`;
- `l_tt` vs `M`;
- `l_tt` vs `V`.

Không ép hồi quy nếu dữ liệu không thể hiện quan hệ rõ.

---

# 15. 5.8. Sensitivity ranking

Xếp hạng response:

1. `U_X`
2. `U_Y`
3. `M_max`
4. `V_max`

hoặc thứ tự thực tế theo kết quả.

Bảng:

| Response | R_min | R_max | ΔR | S_R |
|---|---:|---:|---:|---:|

Mục tiêu:

> xác định đại lượng nào nhạy nhất với giả thiết điểm ngàm.

---

# 16. 5.9. Engineering implications

Thảo luận:

- lựa chọn điểm ngàm có thể ảnh hưởng đáng kể hay không;
- khi nào có thể dùng phương pháp đơn giản;
- khi nào cần kiểm tra nhiều phương pháp;
- nguy cơ đánh giá sai độ cứng hoặc nội lực;
- ý nghĩa đối với mô hình hóa bến cảng 3D.

Không đưa ra khuyến nghị vượt quá dữ liệu.

---

# 17. 6. CONCLUSIONS

Dự kiến 4–6 kết luận.

## C1 — Fixity depth

Sáu phương pháp tạo ra mức độ khác biệt về `h_z` như thế nào.

## C2 — Effective length

Mức khác biệt về `l_tt`.

## C3 — Global response

Ảnh hưởng đến `U_X`, `U_Y`.

## C4 — Pile response

Ảnh hưởng đến `M_max`, `V_max`.

## C5 — Sensitivity

Response nào nhạy nhất.

## C6 — Engineering implication

Hàm ý cho mô hình hóa bến cảng trên nền cọc.

> Chỉ đưa số liệu cụ thể sau khi hoàn thành sáu sensitivity runs.

---

# 18. FIGURES — BỘ HÌNH KHÓA

## Figure 1

**3D SAP2000 model of the 100,000-DWT piled wharf.**

Nội dung:

- toàn bộ mô hình;
- bố trí cọc;
- hệ kết cấu chính.

## Figure 2

**Pile-soil system and equivalent fixity concept.**

Nội dung:

- mặt đất;
- cọc;
- đất;
- `h_z`;
- `l_tt`;
- điểm ngàm tương đương.

## Figure 3

**Comparison of six equivalent pile-fixity determination approaches.**

Không nhồi toàn bộ công thức nếu quá khó đọc.

## Figure 4

**Distribution of equivalent fixity depth for 178 sensitivity piles.**

## Figure 5

**Global displacement response under the governing load envelope.**

## Figure 6

**Pile internal-force response under the governing load envelope.**

---

# 19. TABLES — BỘ BẢNG KHÓA

## Table 1

**Main characteristics of the case-study wharf and numerical model.**

## Table 2

**Soil and pile parameters used in the fixity calculations.**

## Table 3

**Summary of the six equivalent pile-fixity determination methods.**

Các cột:

- Method;
- Reference;
- Input parameters;
- `h_z`;
- `l_tt`.

## Table 4

**Controlled numerical experiment matrix.**

Các cột:

- Model;
- Fixity method;
- Number of treated piles;
- Number of control piles;
- Load model;
- Geometry;
- Material.

## Table 5

**Statistics of equivalent fixity depth and effective calculation length.**

## Table 6

**Sensitivity of global and pile responses to the fixity method.**

---

# 20. DATA PIPELINE

## Step 1

Master model:

`Ben 100.000DWT KT nl coc.s2k`

## Step 2

Extract:

- geometry;
- pile coordinates;
- pile type;
- pile length;
- soil information.

## Step 3

Calculate:

`h_z(M1...M6)`

cho 178 cọc.

## Step 4

Calculate:

`l_tt(M1...M6)`

## Step 5

Create six SAP2000 models.

## Step 6

Update only pile fixity.

## Step 7

Run analysis.

## Step 8

Extract:

- displacement;
- pile P;
- pile V;
- pile M;
- reactions if needed.

## Step 9

Build unified result database.

## Step 10

Calculate sensitivity.

## Step 11

Generate figures/tables.

## Step 12

Write Results & Discussion.

## Step 13

Finalize Abstract and Conclusions.

---

# 21. DATA VALIDATION CHECKLIST

Trước khi chạy sensitivity:

- [ ] 192 piles đúng.
- [ ] 178 piles đúng treatment group.
- [ ] 14 piles đúng control group.
- [ ] Geometry không thay đổi.
- [ ] Material không thay đổi.
- [ ] Section không thay đổi.
- [ ] Loads không thay đổi.
- [ ] Load combinations không thay đổi.
- [ ] Chỉ fixity thay đổi.
- [ ] `BAO KT` tồn tại trong cả 7 models.
- [ ] Units thống nhất.
- [ ] SAP2000 version thống nhất.

Sau khi chạy:

- [ ] model converged;
- [ ] no unintended missing elements;
- [ ] reaction balance;
- [ ] displacement available;
- [ ] pile forces available;
- [ ] governing pile identified.

---

# 22. LOGIC CỦA PAPER — PHẢI GIỮ XUYÊN SUỐT

Bài báo phải luôn trả lời một câu hỏi duy nhất:

> **Nếu cùng một bến cảng, cùng hình học, cùng vật liệu và cùng tải trọng, nhưng thay đổi phương pháp xác định điểm ngàm tương đương của cọc, thì đáp ứng kết cấu thay đổi bao nhiêu?**

Chuỗi logic:

```text
Six fixity methods
        ↓
Different h_z
        ↓
Different l_tt
        ↓
Different pile stiffness / boundary condition
        ↓
Different structural response
        ↓
Quantified sensitivity
        ↓
Engineering implication
```

Không được để bài chuyển thành bài:

- so sánh tiêu chuẩn;
- nghiên cứu đất;
- nghiên cứu tải trọng;
- tối ưu kết cấu;
- nghiên cứu thuật toán.

---

# 23. NOVELTY STATEMENT — BẢN KHÓA

> This study provides a controlled three-dimensional numerical assessment of how alternative code- and literature-based methods for determining equivalent pile fixity affect the effective calculation length and structural response of a real-world piled wharf. By keeping geometry, material properties, loading, and analysis settings unchanged while varying only the pile fixity assumption, the study isolates and quantifies the structural sensitivity associated with equivalent fixity determination.

---

# 24. PAPER POSITION TRONG CHUỖI NGHIÊN CỨU

```text
PAPER 1
Fixity sensitivity
        ↓
PAPER 2
Single-objective optimization
        ↓
PAPER 3
Multi-objective optimization
        ↓
MOSFOA / broader optimization framework
```

Paper 1 phải hoàn thành trước khi khóa các giả thiết nền tảng cho Paper 2.

---

# 25. TRẠNG THÁI HIỆN TẠI

## Đã khóa

- [x] Research question
- [x] Objectives
- [x] Case study
- [x] 3D SAP2000 baseline
- [x] 192 piles
- [x] 178 treatment piles
- [x] 14 control piles
- [x] Six fixity methods
- [x] Controlled experiment
- [x] Governing envelope: BAO KT
- [x] Response variables
- [x] Sensitivity metric
- [x] Paper structure
- [x] Figure plan
- [x] Table plan
- [x] Novelty direction

## Chưa thực hiện

- [ ] Calculate `h_z` for M1–M6
- [ ] Calculate `l_tt` for M1–M6
- [ ] Build six sensitivity models
- [ ] Run six analyses
- [ ] Extract results
- [ ] Perform sensitivity analysis
- [ ] Generate figures
- [ ] Generate tables
- [ ] Write final Results
- [ ] Write final Abstract
- [ ] Write final Conclusions

---

# 26. NGUYÊN TẮC KHÓA TỪ ĐÂY

1. Không thay đổi research question nếu chưa có bằng chứng từ numerical results.
2. Không thêm objective thứ ba.
3. Không đưa optimization vào Paper 1.
4. Không thay đổi load model giữa các sensitivity cases.
5. Không thay đổi geometry giữa các sensitivity cases.
6. Không thay đổi material giữa các sensitivity cases.
7. Chỉ thay đổi pile fixity của 178 treatment piles.
8. 14 control piles giữ nguyên.
9. `BAO KT` là governing load envelope cho sensitivity experiment.
10. Không gọi `BAO KT` là governing displacement case nếu chưa kiểm chứng displacement.
11. Không kết luận phương pháp nào "tốt nhất" nếu không có tiêu chí đánh giá tương ứng.
12. Không overclaim novelty.
13. Chỉ viết kết luận định lượng sau khi có kết quả chạy SAP.
