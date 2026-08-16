# ĐỀ CƯƠNG CHI TIẾT — CHUYÊN ĐỀ TIẾN SĨ SỐ 3
## Tài liệu độc lập để triển khai viết chi tiết (phiên làm việc riêng)

> **Cách dùng file này**: brief tự thân, đã nhúng sẵn toàn bộ số liệu kỹ
> thuật, bảng thiết kế, kết quả tối ưu trích từ bài báo Q3 (MOSFOA) —
> không cần mở lại file `.docx` gốc để viết chương này. Cần tra cứu sâu
> hơn → xem mục 9 cuối file.

---

## 0. Bối cảnh đề tài

**Đề tài luận án:**
> NGHIÊN CỨU PHÁT TRIỂN THUẬT TOÁN TỐI ƯU METAHEURISTIC CHO KẾT CẤU HẠ TẦNG CẢNG BIỂN

**Tên Chuyên đề 3 (đã chốt):**
> **ỨNG DỤNG VÀ KIỂM CHỨNG THUẬT TOÁN MOSFOA CHO TỐI ƯU ĐA MỤC TIÊU KẾT CẤU HẠ TẦNG CẢNG BIỂN**

**Vai trò trong tổng thể**: CĐ3 chứng minh **"DOES IT WORK IN
ENGINEERING"** — đóng góp ứng dụng, tách từ bài báo Q3 (phần case study
kỹ thuật), tích hợp MATLAB–SAP2000, áp dụng MOSFOA (đã phát triển ở CĐ2)
cho ba hệ kết cấu thực tế **BD/MD/MJP** của dự án Hải Linh.

**Đóng góp khoa học tương ứng (Tầng 3/4)**: *"Xây dựng quy trình tích
hợp MATLAB–SAP2000 vận hành được trên bài toán kỹ thuật thực (dữ liệu
dự án Hải Linh), tạo ra các tập Pareto cost–displacement khả thi 100%
theo tiêu chuẩn (TCVN 7888:2014, TCVN 10304:2014) cho ba hệ kết cấu
BD/MD/MJP, có so sánh định lượng với thiết kế hiện trạng."*

**Nguồn**: toàn bộ nội dung khoa học dựa trên bài báo Q3, mục 4 (Case
Study: Liquid Bulk Jetty). Dữ liệu đã trích sẵn ở mục 5–7 dưới.

---

## 1. Quy cách trình bày bắt buộc

A4, Times New Roman 14, giãn dòng 1,5, **không quá 80 trang** không kể
phụ lục, **đúng 3 chương**, kết cấu Mở đầu → Chương 1/2/3 → Kết luận
(bàn luận) và kiến nghị → Tài liệu tham khảo → Phụ lục.

---

## 2. Quy tắc "giá trị gia tăng" áp dụng cho CĐ3

- **Mở rộng phân tích**: đào sâu ý nghĩa kỹ thuật của từng bảng kết quả
  (ví dụ: utilization ratio 0.9971 có ý nghĩa gì với kỹ sư thiết kế thực
  tế — biên an toàn còn lại rất mỏng, cần lưu ý gì khi áp dụng).
- **Mở rộng phạm vi (giá trị gia tăng lớn nhất của CĐ3)**: mục 3.3.x —
  kiểm chứng bổ sung trên **một dự án bến bệ cọc cao độc lập với Hải
  Linh** (từ công bố Track B #4) — đây là bằng chứng tổng quát hóa
  **chính thức**, không có trong bài báo Q3.
- **Mở rộng đối chứng**: mục 3.9.x — thảo luận tổng quát hóa qua các
  công bố Track B khác (#1 dây neo phao, #2 tường chắn, #5 khung thép).

---

## 3. Cấu trúc 3 chương bắt buộc (dàn ý chi tiết)

### CHƯƠNG 1 — MÔ HÌNH BÀI TOÁN TỐI ƯU KẾT CẤU CẢNG BIỂN

- **1.1. Mở đầu**
- **1.2. Đối tượng nghiên cứu**: 1.2.1 Berthing Dolphin (BD); 1.2.2
  Mooring Dolphin (MD); 1.2.3 Main Jetty Platform (MJP) — mô tả kết cấu
  ở mục 5.1 dưới
- **1.3. Mô hình kết cấu**: geometry, material, pile system, cap/deck
  system, soil representation (mục 5.2, 5.4 dưới)
- **1.4. Tải trọng và tổ hợp tải trọng**: DL, BL, ML, LL, load
  combinations (Bảng 6, 8 — mục 5.3 dưới)
- **1.5. Biến thiết kế**: pile diameter, wall thickness, rake, length,
  MJP beam variables (Bảng 7 — mục 6.1 dưới)
- **1.6. Hàm mục tiêu**: construction cost, maximum displacement, Pareto
  formulation (Eqs. 14–15 — mục 6.2 dưới)
- **1.7. Ràng buộc**: geometric, structural strength, pile compression,
  uplift, bending, geotechnical, feasibility (Eqs. 16–23 — mục 6.3 dưới)
- **1.8. Kết luận Chương 1**

### CHƯƠNG 2 — TÍCH HỢP MOSFOA–MATLAB–SAP2000 VÀ THỰC NGHIỆM

- **2.1. Kiến trúc hệ thống**: vòng lặp MOSFOA → design variables →
  MATLAB → SAP2000 → structural response → constraint evaluation →
  objectives → Pareto archive → MOSFOA
- **2.2. Mô hình FEM**: BD model, MD model, MJP model (mục 5.1 dưới)
- **2.3. Mô hình địa kỹ thuật**: soil layers, axial/uplift capacity,
  lateral restraint, equivalent support model (Bảng 9, mục 6.4 dưới)
- **2.4. Constraint handling**: pre-analysis hard constraints, SAP2000
  analysis, resistance checks, penalty, final feasibility audit (mục
  6.3 dưới)
- **2.5. Thiết lập tối ưu**: population=100, iterations=300, archive=100,
  grid=10 divisions, $GP_0=0.5$ → 30,100 FEs/cặp thuật toán-case; 25
  instances SAP2000 song song; workstation Intel Xeon E5-2667 v2, 16
  physical cores, 32 logical processors, 64GB RAM
- **2.6. Thiết kế sáu bài toán kỹ thuật**: BD×B-MOSFOA, BD×E-MOSFOA,
  MD×B-MOSFOA, MD×E-MOSFOA, MJP×B-MOSFOA, MJP×E-MOSFOA
- **2.7. Kiểm chứng quy trình**: model/load/constraint consistency,
  reanalysis selected Pareto solutions
- **2.8. Kết luận Chương 2**

### CHƯƠNG 3 — KẾT QUẢ TỐI ƯU VÀ Ý NGHĨA KỸ THUẬT

- **3.1. Kết quả BD** (Bảng 10, mục 7.1 dưới)
- **3.2. Kết quả MD** (Bảng 11, mục 7.2 dưới)
- **3.3. Kết quả MJP** (Bảng 12, mục 7.3 dưới)
- **3.3.x (MỚI — giá trị gia tăng, dùng công bố Track B #4) Kiểm chứng
  bổ sung trên dự án độc lập** — trình bày tóm tắt kết quả bài báo #4
  (JMST), áp dụng MOSFOA cho một công trình bến bệ cọc cao thuộc **dự án
  khác Hải Linh**. Vì dữ liệu độc lập với BD/MD/MJP, mục này là **bằng
  chứng tổng quát hóa chính thức** (không chỉ thảo luận), tăng sức
  thuyết phục về khả năng áp dụng rộng của MOSFOA.
- **3.4. So sánh B-MOSFOA và E-MOSFOA trong bài toán kỹ thuật** (Bảng 13,
  mục 7.4 dưới)
- **3.5. Phân tích Pareto**: cost–displacement trade-off, ideal point,
  compromise solution, engineering meaning
- **3.6. Kiểm chứng tính khả thi**: strength/geotechnical/uplift/
  geometric utilization, archive-wide feasibility (Bảng 13)
- **3.7. Hiệu quả kinh tế–kỹ thuật**: cost reduction, displacement
  reduction, so sánh với thiết kế hiện trạng (số liệu mục 7.1–7.3)
- **3.8. Quy tắc lựa chọn nghiệm Pareto**: minimum cost, minimum
  displacement, compromise, decision map, khuyến nghị cho kỹ sư
- **3.9. Phân tích giới hạn và khả năng mở rộng** (mục 8 dưới)
  - **3.9.x (MỚI) Thảo luận tổng quát hóa qua Track B** — liên hệ ngắn
    gọn với các hạng mục kết cấu cảng khác (#1 dây neo phao, #2 tường
    chắn trọng lực, #5 khung thép nhà điều hành cảng) mà NCS đã tối ưu ở
    các bài báo khác, lập luận khả năng mở rộng phương pháp ngoài
    BD/MD/MJP — "future work" có bằng chứng đi kèm.
- **3.10. Đóng góp của Chuyên đề 3**
- **3.11. Kết luận Chuyên đề 3**

---

## 4. Bảy câu hỏi nghiên cứu của CĐ3 (dùng cho Mở đầu)

1. MOSFOA có giải được bài toán kết cấu cảng thực tế không?
2. Quy trình MATLAB–SAP2000 hoạt động như thế nào?
3. Pareto cost–displacement có ý nghĩa kỹ thuật không?
4. Các nghiệm Pareto có thực sự khả thi theo tiêu chuẩn không?
5. MOSFOA tạo ra lợi ích gì so với thiết kế hiện trạng?
6. Có thể chuyển kết quả thành quy trình hỗ trợ kỹ sư thiết kế không?
7. Những giới hạn nào còn tồn tại và đâu là hướng phát triển luận án?

---

## 5. Mô tả kết cấu và tải trọng (dữ liệu cho Chương 1/2 — trích bài báo Q3, mục 4.1)

### 5.1. Ba hệ kết cấu — dự án bến cảng lỏng-rời Hải Linh

- **BD (Berthing Dolphin)**: 19 cọc BTCT dự ứng lực D600, chiều dài danh
  nghĩa 39m: 9 cọc thẳng đứng, 6 cọc xiên trong mặt phẳng độ dốc 1:6, 4
  cọc xiên không gian cùng độ dốc, góc bố trí mặt bằng 30°/60°. Bệ cọc
  đổ tại chỗ BTCT C40/50 kích thước 8.4×9.6m, chiều sâu 2.0–3.0m (vùng
  gắn đệm va dày hơn để tăng khả năng chịu uốn/cắt).
- **MD (Mooring Dolphin)**: 9 cọc BTCT dự ứng lực D600: 1 cọc thẳng
  đứng, 4 cọc xiên trong mặt phẳng độ dốc 1:6, 4 cọc xiên không gian
  cùng độ dốc, góc bố trí 45°. Bệ cọc BTCT C40/50 kích thước
  4.5×4.5×2.0m.
- **MJP (Main Jetty Platform)**: kết cấu bản/dầm BTCT dự ứng lực trên hệ
  cọc thẳng đứng, gồm dầm ngang, dầm dọc, bản mặt cầu đổ tại chỗ. Không
  chịu tải va trực tiếp; tải trọng chính là DL và LL (thiết bị, người).
  Baseline hiện trạng dùng cọc thẳng đứng D500, chiều dài danh nghĩa 38m.

### 5.2. Tổ hợp tải trọng (Bảng 6 gốc)

| Kết cấu | Tải trọng | COMB1 | COMB2 | COMB3 |
|---|---|---|---|---|
| BD | DL / BL / ML | 1.0/--/-- | 1.0/1.0/-- | 1.0/--/1.0 |
| MD | DL / ML | 1.0/-- | 1.0/1.0 | -- |
| MJP | DL / LL | 1.0/-- | 1.0/1.0 | -- |

EV-COMB (envelope combination) áp dụng cho mọi trường hợp trên — lấy
bao (max/min) chứ không phải tổ hợp tuyến tính.

### 5.3. Giá trị tải trọng (Bảng 8 gốc)

| Tải trọng | X (kN) | Y (kN) | Z |
|---|---|---|---|
| DL | — | — | tính nội bộ bởi SAP2000 |
| BL (va tàu) | 222.42 | 444.83 | 0 |
| ML (neo tàu) | 99.05 | 118.07 | 71.2 kN |
| LL (MJP) | 0 | 0 | 9.81 kN/m² |

### 5.4. Địa chất (Bảng 9 gốc — 6 lớp đất)

| Lớp | Loại đất | Trạng thái | Chiều dày (m) | $I_L$ |
|---|---|---|---|---|
| 1 | Sét | Rất mềm–mềm | 4.8 | 0.76 |
| 2 | Sét | Cứng–rất cứng | 5.3 | 0.31 |
| 3 | Sét | Mềm | 9.6 | 0.63 |
| 4 | Sét | Cứng–rất cứng | 1.7 | 0.35 |
| 5 | Sét | Mềm | 4.9 | 0.67 |
| 6 | Cát | Hạt trung | 2.3 | 0.20 |

Mô hình hóa: sức chịu tải dọc trục và nhổ theo toàn bộ chiều dài cọc
(TCVN 10304:2014); khống chế ngang bằng mô hình gối tựa tương đương tại
chiều sâu ngàm tính toán $l_u = 2/\alpha_e$ (xem Eqs. ở mục 6.3).

### 5.5. Đơn giá tham chiếu (2025, Hải Phòng)

Tỷ giá tính toán: 1 USD = 24.500 VND. $P_{cr}=46.25$ USD/m³ (bê tông),
$P_{st}=0.57$ USD/kg (cốt thép). Đơn giá cọc theo loại/đường kính lấy
theo công bố giá Hải Phòng 2025 + danh mục nhà cung cấp công khai (dùng
để so sánh kết quả tối ưu, không thay thế báo giá dự án cụ thể).

---

## 6. Biến thiết kế, hàm mục tiêu, ràng buộc (dữ liệu cho Chương 1/2 — Eqs. 14–23)

### 6.1. Bảng 7 — Biến thiết kế

| Kết cấu | Biến | Mô tả | Loại | Miền giá trị |
|---|---|---|---|---|
| BD, MD | $X_1$ | $D_p$ — đường kính ngoài cọc (m) | Rời rạc | theo TCVN 7888:2014 |
| | $X_2$ | $t_p$ — chiều dày thành cọc (m) | Rời rạc | theo TCVN 7888:2014 |
| | $X_3$ | $n_\theta$ — độ xiên cọc, tỷ lệ $1{:}n_\theta$ | Rời rạc | [6, 7, 8] |
| | $X_4$ | $L_p$ — chiều dài cọc (m) | Rời rạc | [1:0.1:40] |
| MJP | $X_1, X_2$ | $D_p, t_p$ | Rời rạc | theo TCVN 7888:2014 |
| | $X_3$ | $L_p$ (m) | Rời rạc | [1–40] |
| | $X_4, X_5$ | $l_1, l_2$ — nhịp dầm dọc/ngang (m) | Rời rạc | [3–6] |
| | $X_6, X_7$ | $b, h$ — bề rộng/chiều cao dầm (m) | Rời rạc | [0.5–2] |

*(Lưu ý: đường kính và chiều dày cọc được mã hóa chung thành 1 biến
"loại cọc" trong triển khai thực tế — MJP có 6 biến mã hóa dù báo cáo
tách 7 mục.)*

### 6.2. Hàm mục tiêu (Eqs. 14–15)

$$\min_{\mathbf{X}} \mathbf{F}(\mathbf{X}) = \{f_1(\mathbf{X}), f_2(\mathbf{X})\}$$

$$f_1(\mathbf{X}) = \sum_{i=1}^{n_p} L_{p,i} P_p \quad \text{(BD, MD)}$$
$$f_1(\mathbf{X}) = \sum_{i=1}^{n_p} L_{p,i} P_p + \sum V_{beam,i}P_{cr} + \sum M_{s,i}P_{st} \quad \text{(MJP)}$$

$f_2(\mathbf{X})$ = chuyển vị lớn nhất (maximum displacement) trả về từ
SAP2000. $n_p$ — số cọc; $L_{p,i}$ — chiều dài cọc $i$; $P_p$ — đơn giá
cọc/m; $V_{beam,i}, M_{s,i}$ — thể tích bê tông và khối lượng cốt thép
dầm $i$ (MJP, thiết kế theo CSA A23.3-14 qua SAP2000).

### 6.3. Ràng buộc (Eqs. 16–23)

$$g_{ax}(\mathbf{X}) = \sum_{j=1}^{n_p} \max(|R_{z,j}^{FEA}| - N_{c,d}, 0)$$
$$g_{M,k}(\mathbf{X}) = \max(|M_k^{FEA}| - M_{c,r}, 0), \quad k\in\{2,3\}$$
$$g_{up}(\mathbf{X}) = \max(U_d - U_r, 0), \quad U_r = R_{DL}^{FEA} + n_p N_{u,d}$$
$$N_{u,d} = \frac{\gamma_0\gamma_{ck}}{\gamma_n\gamma_k}\, u\sum_i \gamma_{cf}f_i l_i, \quad N_{c,d} = \frac{\gamma_0\gamma_c}{\gamma_n\gamma_k}\left(\gamma_{cq}q_bA_b + u\sum_i \gamma_{cf}f_il_i\right)$$

Hệ số: $\gamma_0=1.15$ (điều kiện làm việc nền), $\gamma_n=1.15$ (tầm
quan trọng công trình), $\gamma_k=1.55$ (độ tin cậy sức chịu tải cọc),
$\gamma_c=1.00$ (nén)/$\gamma_{ck}=0.80$ (nhổ), $\gamma_{cq}=1.00$ (mũi
cọc)/$\gamma_{cf}=0.80$ (thân cọc). Ràng buộc nhổ ($g_{up}$) chỉ áp dụng
cho BD/MD, MJP = 0.

**Hàm phạt (Eqs. 22–23)**:
$$\mathbf{F}^p(\mathbf{X}) = [f_1(\mathbf{X})+P(\mathbf{X}),\ f_2(\mathbf{X})+P(\mathbf{X})]$$
$$P(\mathbf{X}) = \alpha[g_{M,2}+g_{M,3}+g_{ax}+g_{up}], \quad \alpha=10^9$$

**Điều kiện tiền phân tích (pre-analysis, bắt buộc trước khi chạy
SAP2000)**: $L_p \ge l_u$ (chiều dài cọc ≥ chiều sâu ngàm tính toán);
$I_{L,tip} < 0.40$ (mũi cọc trong lớp đất đủ tốt); $h_{bearing} \ge
2.0$m (chiều dày lớp chịu lực đủ); MJP thêm điều kiện tương thích
$B_{beam} \ge D_p + 0.20$m. Vi phạm bất kỳ điều kiện nào → cả hai mục
tiêu gán $10^9$, bỏ qua phân tích SAP2000.

### 6.4. Mô hình địa kỹ thuật — khống chế ngang

$$\alpha_e = \left[\frac{b_p k_{eq}}{\gamma_c E_0 I}\right]^{1/5}, \quad l_u = \frac{2}{\alpha_e}$$

Trong SAP2000: thay hiệu ứng đất bằng gối tựa dẫn hướng (guided support)
đặt tại chiều sâu $l_u$ trong nền, cộng gối con lăn tại mũi cọc. Chiều
dài vật lý cọc vẫn dùng để kiểm tra sức chịu tải và mũi cọc.

---

## 7. Kết quả tối ưu (dữ liệu cho Chương 3 — Bảng 10–13, trích nguyên bài báo Q3)

### 7.1. Bảng 10 — Kết quả BD (thiết kế đại diện)

| Thuật toán | Thiết kế | Loại cọc ($D_p{\times}t_p$; giá USD/m) | $n_\theta$ | $L_p$ (m) | $f_1$ (USD) | $f_2$ (m) |
|---|---|---|---|---|---|---|
| B-MOSFOA | A | 700-A (0.70×0.10; 32.16) | 6 | 16.9 | 10,164.82 | 0.01941 |
| | B | 1000-A (1.00×0.13; 63.88) | 6 | 16.1 | 19,221.93 | 0.006097 |
| | C | 1200-AB (1.20×0.15; 132.05) | 6 | 16.8 | 41,491.17 | 0.003496 |
| E-MOSFOA | I | 700-A (giống A) | 6 | 16.9 | 10,164.82 | 0.01941 |
| | II | 1000-A (giống B) | 6 | 16.1 | 19,221.93 | 0.006097 |
| | III | 1200-C (1.20×0.15; 190.72) | 6 | 16.8 | 59,924.15 | 0.003496 |
| Hiện trạng | — | 600-C (0.60×0.10; 39) | 6 | 39.0 | 31,640.22 | 0.03329 |

**Nhận định**: A/I giảm 67.9% chi phí, 41.7% chuyển vị so với hiện trạng
(cải thiện đồng thời cả hai mục tiêu → thiết kế hiện trạng bị trội). B/II
giảm 39.2% chi phí, 81.7% chuyển vị. C/III cùng giảm 89.5% chuyển vị,
nhưng C rẻ hơn III 30.8% ở cùng mức chuyển vị (0.003496m) → B-MOSFOA cho
nghiệm kinh tế hơn ở đầu mút chuyển vị nhỏ nhất.

### 7.2. Bảng 11 — Kết quả MD

| Thuật toán | Thiết kế | Loại cọc | $n_\theta$ | $L$ (m) | $f_1$ (USD) | $f_2$ (m) |
|---|---|---|---|---|---|---|
| B-MOSFOA | A | 450-A (0.45×0.07; 16.82) | 7 | 16.0 | 2,422.23 | 0.02459 |
| | B | 700-A (0.70×0.10; 32.16) | 6 | 16.0 | 4,630.61 | 0.004941 |
| | C | 1200-A (1.20×0.15; 100.95) | 6 | 16.8 | 15,263.70 | 0.001003 |
| E-MOSFOA | I | 450-A (giống A) | 7 | 16.0 | 2,422.23 | 0.02459 |
| | II | 800-A (0.80×0.11; 40.42) | 6 | 16.0 | 5,821.09 | 0.003261 |
| | III | 1200-C (1.20×0.15; 190.72) | 6 | 16.8 | 28,836.83 | 0.001003 |
| Hiện trạng | — | 600-B (0.60×0.09; 38) | 6 | 39.0 | 13,121.12 | 0.04268 |

**Nhận định (cải thiện lớn nhất toàn bộ nghiên cứu)**: A/I giảm **81.5%
chi phí, 42.4% chuyển vị**. B giảm 64.7%/88.4%; II giảm 55.6%/92.4%
(E-MOSFOA ưu tiên độ cứng hơn ở vùng thỏa hiệp). C/III cùng giảm 97.6%
chuyển vị, C rẻ hơn III 47.1%.

### 7.3. Bảng 12 — Kết quả MJP

| Thuật toán | Thiết kế | Loại cọc | $L_p$ (m) | $l_1$ | $l_2$ | $b{\times}h$ | $f_1$ (USD) | $f_2$ (m) |
|---|---|---|---|---|---|---|---|---|
| B-MOSFOA | A | 300-A (0.30×0.06; 8.12) | 38.7 | 5.3 | 5.6 | 0.5×0.5 | 5,350.32 | 0.001019 |
| | B | 300-A (0.30×0.06; 8.12) | 19.9 | 3.0 | 3.0 | 0.8×0.5 | 11,539.33 | 0.00007103 |
| | C | 1200-B (1.20×0.15; 163.16) | 16.8 | 3.0 | 3.0 | 1.4×2.0 | 126,865.66 | 0.00003877 |
| E-MOSFOA | I | 300-A (0.30×0.06; 8.12) | 37.4 | 5.3 | 3.7 | 0.5×0.5 | 6,935.46 | 0.0005024 |
| | II | 300-B (0.30×0.06; 10.56) | 19.8 | 3.0 | 3.0 | 0.8×0.5 | 12,866.98 | 0.00007101 |
| | III | 1200-C (1.20×0.15; 190.72) | 16.8 | 3.0 | 3.0 | 1.4×2.0 | 139,831.48 | 0.00003877 |
| Hiện trạng | — | 500-B (0.50×0.08; 27.26) | 38.0 | 4.2 | 4.5 | 0.7×1.0 | 25,708.94 | 0.0002244 |

**Nhận định**: A/I rẻ nhất nhưng chuyển vị **lớn hơn** hiện trạng (đánh
đổi độ cứng lấy chi phí — thiết kế "cost-oriented"). B/II cải thiện
**cả hai** mục tiêu: −55.1%/−68.3% (B), −50.0%/−68.4% (II) — thiết kế
"balanced". C/III chuyển vị nhỏ nhất (−82.7%) nhưng chi phí gấp 4.93–5.44
lần hiện trạng ("stiffness-oriented"); C rẻ hơn III 9.3% ở cùng chuyển
vị.

### 7.4. Bảng 13 — Chi phí tính toán, chất lượng Pareto, tính khả thi toàn archive

| Case | Thuật toán | FEs | Thời gian (h) | Feasible/$A_f$ | $HV$ | $\eta_{M,max}$ | $\eta_{N,max}$ | $\eta_{U,max}$ |
|---|---|---|---|---|---|---|---|---|
| BD | B-MOSFOA | 30,100 | 12.92 | 7/7 | 1.0833 | 0.7854 | 0.9908 | 0.0108 |
| | E-MOSFOA | 30,100 | 12.87 | 9/9 | 1.0833 | 0.7854 | 0.9908 | 0.0108 |
| MD | B-MOSFOA | 30,100 | 6.91 | 9/9 | 1.1450 | 0.9971 | 0.9486 | 0.0495 |
| | E-MOSFOA | 30,100 | 6.73 | 10/10 | 1.1450 | 0.9971 | 0.9486 | 0.0495 |
| MJP | B-MOSFOA | 30,100 | 4.32 | 80/80 | 1.1836 | 0.9930 | 0.9955 | — |
| | E-MOSFOA | 30,100 | 5.09 | 100/100 | 1.1735 | 0.9795 | 0.9955 | — |

**Kết luận bắt buộc giữ nguyên tinh thần**: *"Toàn bộ 6 archive cuối đều
thỏa mãn các điều kiện cứng và giới hạn sức chịu tải đã triển khai; tỷ
số khống chế tiệm cận nhưng không vượt quá 1.0 — utilization lớn nhất là
0.9971 (uốn cọc, MD)."* Vì mỗi cặp thuật toán-case chỉ có 1 lần chạy kỹ
thuật đầy đủ, thời gian và HV mang tính **mô tả**, không phải bằng
chứng vượt trội thống kê.

---

## 8. Giới hạn và hướng phát triển (dữ liệu cho mục 3.9 — trích nguyên bài báo Q3, Kết luận)

**Giới hạn 1**: sức chịu tải và khống chế ngang của cọc vẫn dùng mô hình
code-based/equivalent-support (gối tựa tương đương) — chưa mô tả đầy đủ
tương tác đất–cọc phi tuyến hay hiệu ứng nhóm cọc qua nền.

**Giới hạn 2**: đánh giá mọi ứng viên bằng SAP2000 có chi phí tính toán
lớn (BD: 12.9h, MD: 6.8h, MJP: 4.3–5.1h cho 30,100 FEs).

**Hướng phát triển** (đã nêu trong bài báo): mô hình tương tác đất–cọc
độ trung thực cao hơn; giảm số lần đánh giá SAP2000 đầy đủ bằng surrogate
model/adaptive sampling; đơn giá tham chiếu cần thay bằng báo giá thực
tế theo dự án/thời điểm khi áp dụng thực hành.

---

## 9. Những gì không nên làm (áp dụng riêng cho CĐ3)

- Không biến CĐ3 thành "case study" vài trang — phải đầy đủ chuỗi: MOSFOA
  → bài toán thực → FEM → tiêu chuẩn → Pareto → quyết định thiết kế.
- Không đưa tất cả kết cấu cảng vào phạm vi luận án — BD/MD/MJP là bộ
  case chính; các đối tượng khác (kể cả Track B) chỉ là thảo luận mở
  rộng (mục 3.9.x), không phải kết quả chính.
- Không để mục 3.3.x (bài #4, dự án độc lập) và 3.9.x (Track B khác)
  lấn át 3 mục kết quả chính (3.1–3.3) — giữ tỷ trọng hợp lý.
- Không làm tròn/phóng đại số liệu — dùng đúng các con số ở mục 7.

---

## 10. Checklist tự kiểm tra trước khi hoàn thành bản thảo

- [ ] Không quá 80 trang, đủ 03 chương.
- [ ] Đầy đủ Bảng 6–13 (hoặc bảng mở rộng tương đương) — mục 5–7.
- [ ] Có mục 3.3.x (kiểm chứng dự án độc lập, bài #4) và 3.9.x (thảo
      luận Track B #1/#2/#5).
- [ ] Bảy câu hỏi nghiên cứu (mục 4) đều được trả lời trong Kết luận.
- [ ] Giữ đúng tinh thần "utilization tiệm cận nhưng không vượt 1.0",
      không phóng đại thành "luôn an toàn tuyệt đối".
- [ ] Có Mở đầu, Kết luận (bàn luận) và kiến nghị, Tài liệu tham khảo.

---

## 11. Nguồn tham chiếu (chỉ cần khi cần tra cứu sâu hơn)

- `02_MOSFOA__VN.docx` — bài báo Q3 gốc; dùng nếu cần Hình 8–10 (ảnh mô
  hình FEM, mặt cắt kết cấu, biểu đồ HV/Pareto) hoặc Appendix (workflow
  tổng thể, bảng độ nhạy tham số chi tiết).
- `De_cuong_4_san_pham_xuyen_suot_luan_an_MOSFOA.md` — đề cương tổng thể
  đã chốt (Phần I là nguồn gốc của file này).
