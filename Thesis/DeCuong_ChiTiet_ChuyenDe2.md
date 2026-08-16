# ĐỀ CƯƠNG CHI TIẾT — CHUYÊN ĐỀ TIẾN SĨ SỐ 2
## Tài liệu độc lập để triển khai viết chi tiết (phiên làm việc riêng)

> **Cách dùng file này**: brief tự thân, đã nhúng sẵn toàn bộ số liệu,
> công thức, bảng biểu cần thiết trích từ bài báo Q3 (MOSFOA) — không
> cần mở lại file `.docx` gốc để viết chương này. Cần tra cứu sâu hơn →
> xem mục 8 cuối file.

---

## 0. Bối cảnh đề tài

**Đề tài luận án:**
> NGHIÊN CỨU PHÁT TRIỂN THUẬT TOÁN TỐI ƯU METAHEURISTIC CHO KẾT CẤU HẠ TẦNG CẢNG BIỂN

**Tên Chuyên đề 2 (đã chốt):**
> **PHÁT TRIỂN VÀ KIỂM CHỨNG THUẬT TOÁN TỐI ƯU ĐA MỤC TIÊU MOSFOA**

**Vai trò trong tổng thể**: CĐ2 chứng minh **"HOW TO SOLVE"** — đây là
phần **đóng góp thuật toán** thuần túy, tách từ bài báo Q3 (phần thuật
toán + benchmark), **không chứa** nội dung kỹ thuật BD/MD/MJP (thuộc
CĐ3).

**Đóng góp khoa học tương ứng (Tầng 2/4)**: *"Đề xuất B-MOSFOA và
E-MOSFOA — hai biến thể đa mục tiêu của SFOA, với cơ chế archive-grid,
leader selection, và (ở E-MOSFOA) LHS + cosine-phase control + DE
mutation + Gaussian refinement — được kiểm chứng thống kê nghiêm ngặt
(Wilcoxon-Holm, 30 lần lặp độc lập) trên 26 bài toán chuẩn, cho kết quả
cạnh tranh nhưng không tuyên bố vượt trội tuyệt đối."*

**Nguồn**: toàn bộ nội dung khoa học của CĐ2 dựa trên bài báo Q3 *"Multi-
objective Optimization Design of Marine Structures Based on An Enhanced
Starfish Algorithm"* — phần Methodology (mục 2) và Experimental
Setup/Benchmark (mục 3). Dữ liệu đã được trích sẵn ở mục 5–7 dưới.

---

## 1. Quy cách trình bày bắt buộc

Giống toàn bộ Chuyên đề: A4, Times New Roman 14, giãn dòng 1,5, **không
quá 80 trang** không kể phụ lục, **đúng 3 chương**, kết cấu Mở đầu →
Chương 1/2/3 → Kết luận (bàn luận) và kiến nghị → Tài liệu tham khảo →
Phụ lục.

---

## 2. Quy tắc "giá trị gia tăng" áp dụng cho CĐ2 (bắt buộc — không được chỉ dịch lại bài báo)

CĐ2 phải vượt khỏi nội dung đã công bố theo ít nhất 2 trong các hướng
sau:

- **Mở rộng lý thuyết**: trình bày đầy đủ, có suy luận từng bước cho
  từng cơ chế (Eqs. 2–13) — bài báo chỉ nêu công thức và giải thích
  ngắn gọn do giới hạn số trang tạp chí; CĐ2 nên giảng giải rõ *tại sao*
  từng cơ chế được thiết kế như vậy (ví dụ: tại sao cosine-phase control
  thay vì tuyến tính giảm dần; tại sao $\lambda = 0.3$; tại sao Gaussian
  refinement chỉ áp dụng ở 20% cuối).
- **Mở rộng đối chứng**: thêm mục 3.6 đối chiếu định tính với thuật toán
  SOO/MOO khác mà NCS đã thử ở Track B (không chạy lại benchmark, chỉ
  thảo luận nhất quán).
- **Mở rộng phân tích**: đào sâu hơn phần "phân tích vai trò của từng cơ
  chế cải tiến" (ablation-style discussion) — bài báo có nhắc nhưng
  không tách riêng thành phân tích ablation chi tiết.

---

## 3. Cấu trúc 3 chương bắt buộc (dàn ý chi tiết)

### CHƯƠNG 1 — CƠ SỞ PHÁT TRIỂN MOSFOA

- **1.1. Mở đầu**
- **1.2. SFOA đơn mục tiêu**: 1.2.1 Nguyên lý SFOA; 1.2.2 Biểu diễn
  nghiệm; 1.2.3 Hàm fitness; 1.2.4 Exploration; 1.2.5 Exploitation;
  1.2.6 Regeneration; 1.2.7 Hạn chế của SFOA đối với MOO (dùng đúng nội
  dung đã có sẵn ở mục 5 dưới)
- **1.3. Yêu cầu chuyển SFOA sang MOO**: 1.3.1 Pareto dominance; 1.3.2
  External archive; 1.3.3 Diversity preservation; 1.3.4 Leader
  selection; 1.3.5 Constraint handling; 1.3.6 Discrete variables
- **1.4. Cơ sở xây dựng B-MOSFOA**
- **1.5. Cơ sở xây dựng E-MOSFOA**
- **1.6. Giả thuyết và câu hỏi nghiên cứu** (6 câu hỏi ở mục 4 dưới)
- **1.7. Kết luận Chương 1**

### CHƯƠNG 2 — PHÁT TRIỂN THUẬT TOÁN B-MOSFOA VÀ E-MOSFOA

- **2.1. Kiến trúc tổng thể MOSFOA**
- **2.2. B-MOSFOA**: 2.2.1 Pareto dominance; 2.2.2 External archive;
  2.2.3 Adaptive grid; 2.2.4 Crowding-distance truncation; 2.2.5
  Archive-based leader selection; 2.2.6 Boundary handling; 2.2.7 Cập
  nhật vị trí theo SFOA (Eqs. 2–6, mục 5 dưới)
- **2.3. E-MOSFOA**: 2.3.1 Latin Hypercube Sampling; 2.3.2 Cosine phase
  control (Eq. 8); 2.3.3 Leader-guided mutation; 2.3.4 Differential
  Evolution mutation (Eqs. 9–10); 2.3.5 Binomial crossover (Eq. 11);
  2.3.6 Gaussian perturbation (Eqs. 12–13); 2.3.7 Archive-guided
  refinement
- **2.4. Cấu trúc xử lý ràng buộc**: 2.4.1 Hard constraints; 2.4.2
  Penalty; 2.4.3 Feasibility handling; 2.4.4 Archive feasibility
  verification
- **2.5. Pseudocode MOSFOA** (dùng nguyên Algorithm 1, mục 6 dưới)
- **2.6. Phân tích độ phức tạp tính toán** (mục 6 dưới)
- **2.7. Phân tích vai trò của từng cơ chế cải tiến** — đây là chỗ để
  triển khai "giá trị gia tăng" (mục 2 ở trên)
- **2.8. Khung triển khai MATLAB**
- **2.9. Kết luận Chương 2**

### CHƯƠNG 3 — KIỂM CHỨNG VÀ ĐÁNH GIÁ MOSFOA

- **3.1. Thiết kế thực nghiệm** (Bảng benchmark suites, mục 7.1 dưới)
- **3.2. Chỉ tiêu đánh giá** (IGD, ε, Δ, MS — mục 7.2 dưới)
- **3.3. Kiểm định thống kê** (Wilcoxon rank-sum, Holm, W/D/L)
- **3.4. So sánh B-MOSFOA và E-MOSFOA**
- **3.5. So sánh với MOMSA / NS-MFO / MOGNDO** (mục 7.3 dưới — Bảng 4)
- **3.6. (MỚI — giá trị gia tăng) Đối chiếu định tính với Track B** — xem
  mục 2 ở trên
- **3.7. Phân tích độ nhạy tham số** (mục 7.4 dưới — Bảng 5)
- **3.8. Phân tích chi phí tính toán** (mục 7.3 dưới — Bảng 3)
- **3.9. Tổng hợp kết quả**
- **3.10. Đóng góp của Chuyên đề 2**
- **3.11. Kết luận Chuyên đề 2**

---

## 4. Sáu câu hỏi nghiên cứu của CĐ2 (dùng cho mục 1.6)

1. SFOA đơn mục tiêu thiếu gì khi chuyển sang MOO?
2. Làm thế nào xây dựng B-MOSFOA?
3. E-MOSFOA cải tiến B-MOSFOA ở điểm nào?
4. Các cải tiến có thực sự tạo ra hiệu quả không?
5. MOSFOA có cạnh tranh với các thuật toán MOO hiện có không?
6. Hiệu quả có ổn định trên nhiều loại bài toán không?

---

## 5. SFOA gốc và hạn chế (dữ liệu cho Chương 1 — trích nguyên bài báo Q3, mục 1 Introduction)

**SFOA (Starfish Optimization Algorithm)** là thuật toán đơn mục tiêu
dựa trên hành vi tìm kiếm của sao biển. Áp dụng trực tiếp cho bài toán
đa mục tiêu bị hạn chế vì **thiếu**:
- một kho lưu trữ (repository) các nghiệm không bị trội;
- một cơ chế duy trì mặt Pareto phân bố tốt (well-spread);
- một quy tắc chọn "leader" tìm kiếm từ các ứng viên chất lượng cao.

**B-MOSFOA** thiết lập cấu trúc đa mục tiêu cơ bản bằng cách tích hợp:
Pareto dominance, external archive, grid-based diversity management, và
archive-derived leader selection.

**E-MOSFOA** xây dựng tiếp trên B-MOSFOA bằng: Latin hypercube sampling
ở giai đoạn khởi tạo, cosine-regulated search phases, leader-guided
mutation, crossover, và archive-based refinement gần cuối quá trình tối
ưu.

---

## 6. Công thức, pseudocode, độ phức tạp (dữ liệu cho Chương 2 — trích nguyên bài báo Q3, mục 2)

### 6.1. Các phương trình chính (B-MOSFOA — Eqs. 2–7)

- **Eq. (2)–(3)** — vị trí thử nghiệm khai thác (exploration trial
  positions):
  $$\mathbf{Y}_i = \mathbf{X}_i + a_1(X_{leader} - X_i)\cdot\{\cos(\theta)\ (r\le0.5);\ \sin(\theta)\ (r>0.5)\}$$
  $$\mathbf{Y}_i = E\cdot\mathbf{X}_i + A_1(\mathbf{X}_{k_1}-\mathbf{X}_i) + A_2(\mathbf{X}_{k_2}-\mathbf{X}_i)$$
- **Eq. (4)–(5)** — di chuyển theo cá thể lân cận và leader (khai thác):
  $$\mathbf{Y}_i = \mathbf{X}_i + r_1 d_{m1} + r_2 d_{m2}, \quad d_m = \mathbf{X}_{leader} - \mathbf{X}_m\ (m=1,...,5)$$
- **Eq. (6)** — quy tắc regeneration cho cá thể cuối:
  $$\mathbf{Y}_N = e^{(-it\times N/Max\_it)}\mathbf{X}_N$$
- **Eq. (7)** — xác suất chọn leader theo mật độ ô lưới (nghịch đảo mật độ):
  $$P_i = c/N_i$$ ($N_i$: số nghiệm trong ô lưới $i$; $c$: hằng số chuẩn hóa)

Ý nghĩa các ký hiệu: $\mathbf{X}_i, \mathbf{Y}_i$ — vị trí hiện tại/thử
nghiệm của cá thể $i$; $\mathbf{X}_{leader}$ — leader chọn từ archive;
$a_1, E, A_1, A_2$ — hệ số chuyển động SFOA; $\theta$ — tham số góc;
$r, r_1, r_2$ — số ngẫu nhiên; $N$ — kích thước quần thể; $it/Max\_it$ —
tiến trình chạy.

### 6.2. Các phương trình E-MOSFOA (Eqs. 8–13)

- **Eq. (8)** — cosine phase control cho xác suất khám phá $GP$:
  $$GP = \frac{GP_0}{2}\left(1+\cos\left(\pi\cdot\frac{it}{Max\_it}\right)\right)$$
- **Eq. (9)–(11)** — DE mutation + binomial crossover (leader-guided):
  $$mutant_i = \mathbf{X}_{r1} + F\cdot(\mathbf{X}_{r2}-\mathbf{X}_{r3}) + \lambda\cdot(\mathbf{X}_{leader}-\mathbf{X}_{r1})$$
  $$F = 0.5(1 - it/Max\_it), \quad \lambda = 0.3$$
  $$Y_{i,j} = mutant_{i,j}\ \text{if}\ r_{i,j}<CR\ \text{else}\ X_{i,j}, \quad CR=0.5$$
- **Eq. (12)–(13)** — archive-guided refinement (Gaussian, 20% cuối,
  xác suất kích hoạt 0.1, σ = 1% biên độ mỗi biến):
  $$\mathbf{X}^* = \arg\min\left(\sum_{j=1}^{M} f_{i,j}\right), \quad \mathbf{Y}_i = \mathbf{X}^* + \sigma\cdot N(0,\sigma^2)$$

### 6.3. Pseudocode (Algorithm 1 — tóm tắt cấu trúc, viết lại chi tiết khi triển khai)

```text
Input: F(X), P(X) (penalty, Eq. 23), bounds, N, Max_it, Nr, n_grid, GP0
Output: Final archive Af

Khởi tạo Pop (B-MOSFOA: uniform random; E-MOSFOA: LHS)
Đánh giá F(Xi), P(Xi) cho mọi Xi
Khởi tạo archive A (Pareto dominance + constraint handling)
Xây adaptive-grid + crowding-distance cho A

for it = 1..Max_it:
    Đặt GP (B-MOSFOA: GP0 cố định; E-MOSFOA: Eq. 8)
    Chọn X_leader từ vùng thưa/crowding của A
    for mỗi Xi trong Pop:
        if rand < GP:                      # exploration
            Sinh Yi theo Eqs. (2)-(3)
            if E-MOSFOA: áp dụng DE mutation + crossover (Eqs. 9-11)
        else:                               # exploitation
            Sinh Yi theo Eqs. (4)-(6)
            if E-MOSFOA: Gaussian perturbation thích nghi
        Xử lý biên (boundary handling)
    Đánh giá F(Xi), P(Xi) cho Pop mới
    Merge Pop + A → cập nhật A (dominance, crowding-distance
        truncation, adaptive-grid, Eq. 7)
    if E-MOSFOA and it >= 0.8*Max_it:
        Chọn X* theo Eq. (12); refine theo Eq. (13); cập nhật A
return A
```

### 6.4. Độ phức tạp tính toán

Với quần thể $N$, số chiều biến $D$, số mục tiêu $M$, dung lượng archive
$N_r$, chi phí đánh giá mục tiêu $C_f$: các phép toán chủ đạo là
$O(ND)$ (cập nhật quần thể), $O(NC_f)$ (đánh giá mục tiêu),
$O((N+N_r)2M)$ (cập nhật archive/dominance), $O(MN_r\log N_r)$ (sắp xếp
truncation). Các toán tử thích nghi của E-MOSFOA chỉ thêm phép toán bậc
tuyến tính theo quần thể mỗi vòng lặp — **không** đổi bậc tiệm cận so
với B-MOSFOA.

---

## 7. Dữ liệu thực nghiệm (dữ liệu cho Chương 3 — trích nguyên bài báo Q3, mục 3)

### 7.1. Bảng benchmark suites (Bảng 1 gốc)

| Nhóm | Số mục tiêu (M) | Số biến (D) | Miền giá trị |
|---|---|---|---|
| IMOP1-3 | 2 | 30 | $x_i\in[0,1]$ |
| IMOP4-8 | 3 | 10 | $x_i\in[0,1]$ |
| UF1,2 | 2 | 30 | $x_i\in[-1,1]$ |
| UF3 | 2 | 30 | $x_i\in[0,1]$ |
| UF4 | 2 | 30 | $x_1\in[0,1]$, $x_{2..D}\in[-2,2]$ |
| UF5-7 | 2 | 30 | $x_1\in[0,1]$, $x_{2..D}\in[-1,1]$ |
| UF8-9 | 3 | 30 | $x_{1,2}\in[0,1]$, $x_{3..D}\in[-2,2]$ |
| RM-MEDA-P1,2,3,5,6,7 | 2 | 10 | theo tài liệu gốc |
| RM-MEDA-P9 | 2 | 10 | $x_1\in[0,1]$, $x_{2..D}\in[0,10]$ |
| RM-MEDA-P4,8 | 3 | 10 | theo tài liệu gốc |

Tổng cộng: 26 bài toán chuẩn (8 IMOP + 9 UF + 9 RM-MEDA — khớp "26
problem-indicator combinations" nói ở Kết luận bài báo).

### 7.2. Chỉ tiêu đánh giá (Bảng 2 gốc)

| Chỉ tiêu | Đo lường | Mục đích | Hướng ưu tiên |
|---|---|---|---|
| $\varepsilon$ | Độ dịch chuyển tối thiểu để trội mặt tham chiếu | Hội tụ | Thấp |
| $IGD$ | Khoảng cách trung bình từ mặt tham chiếu đến xấp xỉ | Hội tụ + đa dạng | Thấp |
| $\Delta$ | Độ đều khoảng cách giữa các nghiệm liên tiếp | Phân bố | Thấp |
| $MS$ | Độ phủ tối đa trong không gian mục tiêu | Đa dạng | Cao |

Thiết lập chung: population = 100, iterations = 500, 30 lần chạy độc
lập/bài toán; archive $N_r=200$; $n_{grid}=10$; $GP_0=0.5$. Kiểm định
Wilcoxon rank-sum hai phía + hiệu chỉnh Holm, $\alpha=0.05$.

### 7.3. Bảng 3 — Chi phí tính toán tổng hợp (rút gọn, dòng "Overall")

| Thuật toán | FEs/run | Runtime/run (s) | Archive size TB |
|---|---|---|---|
| MOMSA | 60,100 | 29.7 | 158 |
| NS-MFO | 150,100 | 65.8 | 157 |
| MOGNDO | 100,100 | 143 | 120 |
| **B-MOSFOA** | **50,100** | **28.3** | 144 |
| **E-MOSFOA** | **50,100** | **33.9** | 166 |

### 7.4. Bảng 4 — Rank tổng thể và Wilcoxon-Holm (dòng "Overall", so với E-MOSFOA)

| Thuật toán | W/D/L (vs E-MOSFOA) | Avg. rank | Rank-1 | Top-2 |
|---|---|---|---|---|
| MOMSA | 38/18/48 | **2.52** | 31 | 55 |
| NS-MFO | 32/10/59 | 3.34 | 12 | 28 |
| MOGNDO | 19/18/65 | 3.81 | 8 | 20 |
| B-MOSFOA | 33/16/51 | **2.75** | 22 | 50 |
| E-MOSFOA | Ref. | **2.58** | 31 | 52 |

**Theo suite riêng**: B-MOSFOA tốt nhất trên IMOP (avg. rank 2.28, 21
top-2/32). E-MOSFOA có nhiều rank-1 hơn trên IMOP nhưng rank trung bình
thấp hơn B-MOSFOA ở suite này. Trên UF và RM-MEDA, MOMSA dẫn đầu avg.
rank, E-MOSFOA là biến thể MOSFOA tốt hơn B-MOSFOA.

**Kết luận bắt buộc phải giữ nguyên tinh thần khi viết Chương 3**:
*"Không có thuật toán nào vượt trội tuyệt đối trên mọi suite/chỉ tiêu.
MOMSA có avg. rank tổng thể tốt nhất (2.52), E-MOSFOA thứ hai (2.58),
B-MOSFOA thứ ba (2.75); B-MOSFOA tốt nhất riêng trên IMOP (2.28).
MOSFOA cạnh tranh (competitive) và có ưu thế theo từng lớp bài toán,
KHÔNG phải universal superiority."* — **Không được** viết thành "MOSFOA/
E-MOSFOA tốt nhất".

### 7.5. Bảng 5 — Độ nhạy tham số (rút gọn)

Baseline: $GP_0=0.5$, $N_r=200$, $n_{grid}=10$. One-factor-at-a-time,
6 bài toán đại diện × 4 chỉ tiêu = 24 phép so sánh/cấu hình.

- **B-MOSFOA**: $GP_0=0.3$ cho mean rank tốt nhất (3.25, 6/24 rank-1)
  nhưng khác biệt không có ý nghĩa thống kê so với baseline (0/24
  Wilcoxon-Holm có ý nghĩa). $N_r=100$ cho runtime thấp nhất (16.32s).
- **E-MOSFOA**: $GP_0=0.7$ cho mean rank tốt nhất (3.50); $GP_0=0.3$ kém
  nhất (5.13). $N_r=300$ tăng runtime lên 50.84s mà không cải thiện rank
  ổn định.
- **Kết luận chung**: 121/144 (B-MOSFOA) và 111/144 (E-MOSFOA) so sánh
  Wilcoxon-Holm không khác biệt có ý nghĩa so với baseline → baseline
  được giữ làm cấu hình chính vì tính ổn định, không cực đoan.

---

## 8. Những gì không nên làm (áp dụng riêng cho CĐ2)

- Không tuyên bố "E-MOSFOA/MOSFOA tốt nhất" — luôn dùng đúng ngôn ngữ ở
  mục 7.4.
- Không lặp lại toàn bộ lý thuyết MOO/Pareto/NFL trong CĐ2 — đã có ở CĐ1.
- Không đưa bất kỳ nội dung/kết quả BD/MD/MJP nào vào CĐ2 — thuộc CĐ3.
- Không biến mục 3.6 (Track B) thành nội dung chính — chỉ là đối chiếu
  định tính ngắn.

---

## 9. Checklist tự kiểm tra trước khi hoàn thành bản thảo

- [ ] Không quá 80 trang, đủ 03 chương.
- [ ] Có mục 3.6 đối chiếu định tính với Track B.
- [ ] Không tuyên bố universal superiority (mục 7.4).
- [ ] Đầy đủ Eqs. (2)–(13), pseudocode, phân tích độ phức tạp (mục 6).
- [ ] Đầy đủ Bảng 1–5 hoặc phiên bản mở rộng của chúng (mục 7).
- [ ] Sáu câu hỏi nghiên cứu đều được trả lời rõ ràng trong Kết luận
      Chương 3 / Kết luận Chuyên đề.
- [ ] Có Mở đầu, Kết luận (bàn luận) và kiến nghị, Tài liệu tham khảo.

---

## 10. Nguồn tham chiếu (chỉ cần khi cần tra cứu sâu hơn số liệu chi tiết)

- `02_MOSFOA__VN.docx` — bài báo Q3 gốc; dùng nếu cần bảng chi tiết đầy
  đủ (Appendix Table A1–A4: kết quả từng bài toán, từng chỉ tiêu) mà
  mục 7 ở trên chỉ trích bản rút gọn "Overall".
- `De_cuong_4_san_pham_xuyen_suot_luan_an_MOSFOA.md` — đề cương tổng thể
  đã chốt (Phần H là nguồn gốc của file này).
