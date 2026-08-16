# GIÁO TRÌNH TỰ HỌC: TỐI ƯU HÓA ĐƠN MỤC TIÊU (SOO) VÀ ĐA MỤC TIÊU (MOO)
### Dựa trên hai bài báo: SFOA (Zhong et al., 2024) và MOSFOA (Multi-objective Optimization Design of Marine Structures Based on An Enhanced Starfish Algorithm)

> Tài liệu nguồn:
> - **[SFOA]** Zhong, C., Li, G., Meng, Z., Li, H., Yildiz, A.R., Mirjalili, S. (2024). *Starfish optimization algorithm (SFOA): a bio-inspired metaheuristic algorithm for global optimization compared with 100 optimizers.* Neural Computing and Applications, 37, 3641–3683. — file [paper/SFOA.pdf](../paper/SFOA.pdf)
> - **[MOSFOA]** *Multi-objective Optimization Design of Marine Structures Based on An Enhanced Starfish Algorithm* — file [paper/MOSFOAV.pdf](../paper/MOSFOAV.pdf)
>
> Giáo trình này được biên soạn lại theo dạng tự học, đi từ nền tảng toán học của tối ưu hóa, đến metaheuristic nói chung, đến chi tiết thuật toán SFOA (đơn mục tiêu), rồi mở rộng sang lý thuyết Pareto/MOO và hai biến thể B-MOSFOA / E-MOSFOA (đa mục tiêu), kết thúc bằng một case study kỹ thuật thực tế (bến cảng — marine jetty) đúng như bài báo thứ hai đã trình bày.

---

## MỤC LỤC

- [Cách dùng giáo trình này](#cách-dùng-giáo-trình-này)
- **PHẦN 0 — Nền tảng**
  - [0.1. Bài toán tối ưu hóa là gì](#01-bài-toán-tối-ưu-hóa-là-gì)
  - [0.2. Vì sao cần metaheuristic](#02-vì-sao-cần-metaheuristic)
  - [0.3. Exploration vs Exploitation và định lý No Free Lunch](#03-exploration-vs-exploitation-và-định-lý-no-free-lunch)
  - [0.4. Bản đồ họ thuật toán metaheuristic](#04-bản-đồ-họ-thuật-toán-metaheuristic)
- **PHẦN 1 — Tối ưu hóa đơn mục tiêu (SOO) qua SFOA**
  - [1.1. Cảm hứng sinh học của SFOA](#11-cảm-hứng-sinh-học-của-sfoa)
  - [1.2. Khởi tạo quần thể](#12-khởi-tạo-quần-thể)
  - [1.3. Pha Khám phá (Exploration)](#13-pha-khám-phá-exploration)
  - [1.4. Pha Khai thác (Exploitation)](#14-pha-khai-thác-exploitation)
  - [1.5. Xử lý biên và tham số điều khiển GP](#15-xử-lý-biên-và-tham-số-điều-khiển-gp)
  - [1.6. Quy trình đầy đủ và độ phức tạp tính toán](#16-quy-trình-đầy-đủ-và-độ-phức-tạp-tính-toán)
  - [1.7. So sánh SFOA với các thuật toán khác (PSO, GWO, MPA, DE)](#17-so-sánh-sfoa-với-các-thuật-toán-khác-pso-gwo-mpa-de)
  - [1.8. Benchmark, chỉ số thống kê và phương pháp so sánh 100 thuật toán](#18-benchmark-chỉ-số-thống-kê-và-phương-pháp-so-sánh-100-thuật-toán)
  - [1.9. Bài toán kỹ thuật thực tế (Engineering case studies)](#19-bài-toán-kỹ-thuật-thực-tế-engineering-case-studies)
  - [1.10. Bài tập thực hành Phần 1](#110-bài-tập-thực-hành-phần-1)
- **PHẦN 2 — Tối ưu hóa đa mục tiêu (MOO)**
  - [2.1. Vì sao một mục tiêu là không đủ](#21-vì-sao-một-mục-tiêu-là-không-đủ)
  - [2.2. Pareto dominance, Pareto Set và Pareto Front](#22-pareto-dominance-pareto-set-và-pareto-front)
  - [2.3. Các phương pháp quy về đơn mục tiêu (weighted-sum, ε-constraint)](#23-các-phương-pháp-quy-về-đơn-mục-tiêu-weighted-sum-ε-constraint)
  - [2.4. Metaheuristic đa mục tiêu quần thể: NSGA-II, SPEA2, PAES, MOPSO](#24-metaheuristic-đa-mục-tiêu-quần-thể-nsga-ii-spea2-paes-mopso)
  - [2.5. Bốn chỉ số đánh giá chất lượng Pareto Front: IGD, ε, Δ, MS](#25-bốn-chỉ-số-đánh-giá-chất-lượng-pareto-front-igd-ε-δ-ms)
  - [2.6. Bộ benchmark IMOP, UF, RM-MEDA](#26-bộ-benchmark-imop-uf-rm-meda)
  - [2.7. Bài tập thực hành Phần 2](#27-bài-tập-thực-hành-phần-2)
- **PHẦN 3 — Từ SFOA đến MOSFOA**
  - [3.1. Vì sao SFOA gốc không dùng trực tiếp được cho MOO](#31-vì-sao-sfoa-gốc-không-dùng-trực-tiếp-được-cho-moo)
  - [3.2. B-MOSFOA: phiên bản nền tảng](#32-b-mosfoa-phiên-bản-nền-tảng)
  - [3.3. E-MOSFOA: phiên bản nâng cao](#33-e-mosfoa-phiên-bản-nâng-cao)
  - [3.4. Đọc hiểu pseudo-code Algorithm 1](#34-đọc-hiểu-pseudo-code-algorithm-1)
  - [3.5. Kết quả thực nghiệm và cách diễn giải bảng số](#35-kết-quả-thực-nghiệm-và-cách-diễn-giải-bảng-số)
  - [3.6. Bài tập thực hành Phần 3](#36-bài-tập-thực-hành-phần-3)
- **PHẦN 4 — Case Study kỹ thuật: Bến cảng hàng lỏng (Liquid Bulk Jetty)**
  - [4.1. Ba hệ kết cấu: BD, MD, MJP](#41-ba-hệ-kết-cấu-bd-md-mjp)
  - [4.2. Biến thiết kế, hàm mục tiêu, ràng buộc](#42-biến-thiết-kế-hàm-mục-tiêu-ràng-buộc)
  - [4.3. Xử lý ràng buộc bằng hàm phạt (penalty method)](#43-xử-lý-ràng-buộc-bằng-hàm-phạt-penalty-method)
  - [4.4. Kết nối FEM (SAP2000) với vòng lặp tối ưu (MATLAB)](#44-kết-nối-fem-sap2000-với-vòng-lặp-tối-ưu-matlab)
  - [4.5. Đọc hiểu kết quả Pareto Front thực tế](#45-đọc-hiểu-kết-quả-pareto-front-thực-tế)
  - [4.6. Bài tập thực hành Phần 4](#46-bài-tập-thực-hành-phần-4)
- **PHẦN 5 — Lộ trình tự học đề xuất & phụ lục**
  - [5.1. Lộ trình 6 tuần](#51-lộ-trình-6-tuần)
  - [5.2. Bảng thuật ngữ đối chiếu Anh–Việt](#52-bảng-thuật-ngữ-đối-chiếu-anh–việt)
  - [5.3. Sổ tay công thức nhanh (cheat-sheet)](#53-sổ-tay-công-thức-nhanh-cheat-sheet)
  - [5.4. Tài liệu tham khảo mở rộng](#54-tài-liệu-tham-khảo-mở-rộng)

---

## Cách dùng giáo trình này

Giáo trình chia làm 4 phần chính + phụ lục, đọc **tuần tự**, không nên nhảy cóc sang Phần 2 khi chưa nắm Phần 1, vì MOSFOA (Phần 3) chỉ là "SFOA + cơ chế Pareto", nên toàn bộ phần cơ học tìm kiếm (search mechanism) của MOSFOA **thừa hưởng nguyên vẹn** từ SFOA.

Ký hiệu dùng trong giáo trình:
- 🔹 = khái niệm nền tảng, cần nắm chắc trước khi đọc tiếp.
- 📐 = công thức toán học quan trọng (số hiệu tương ứng với số phương trình gốc trong bài báo, ghi kèm để tiện tra ngược).
- 💻 = gợi ý lập trình / pseudo-code.
- ✍️ = bài tập tự kiểm tra.
- ⚠️ = điểm dễ hiểu sai.

---

# PHẦN 0 — NỀN TẢNG

## 0.1. Bài toán tối ưu hóa là gì

🔹 Một bài toán tối ưu hóa (đơn mục tiêu) tổng quát có 3 thành phần bắt buộc [SFOA, §1]:

1. **Hàm mục tiêu** (objective function) — đại lượng cần cực tiểu hoá hoặc cực đại hoá.
2. **Biến thiết kế** (design variables) — các đại lượng được phép thay đổi.
3. **Ràng buộc** (constraints) — điều kiện mà nghiệm phải thỏa mãn (bất đẳng thức, đẳng thức, hoặc biên trên/dưới).

Dạng tổng quát (theo MOSFOA §2, Eq. 1, viết cho trường hợp M hàm mục tiêu — khi M = 1 chính là bài toán SOO):

📐 **Eq. (1) [MOSFOA]:**
```
minimize  F(X) = { f1(X), f2(X), ..., fM(X) }
subject to   gi(X) ≤ 0      (ràng buộc bất đẳng thức)
             hj(X) = 0      (ràng buộc đẳng thức)
             X ∈ [lb, ub]   (biên trên/dưới của biến thiết kế)
```

Khi **M = 1**, đây chính là bài toán mà SFOA (Phần 1) giải quyết. Khi **M ≥ 2**, đây là bài toán MOO mà MOSFOA (Phần 2–3) giải quyết.

**Trước thời đại metaheuristic**, các thuật toán tối ưu tất định (deterministic) như gradient descent, Newton, quy hoạch tuyến tính... là lựa chọn duy nhất. Nhược điểm của chúng [SFOA §1]:
- Dễ kẹt cực trị địa phương (local optimum) với bài toán phi tuyến mạnh, không có yếu tố ngẫu nhiên để "nhảy thoát".
- Thường đòi hỏi thông tin đạo hàm (gradient) của hàm mục tiêu và ràng buộc — nhiều bài toán kỹ thuật thực tế (ví dụ chạy FEM/SAP2000 để lấy chuyển vị) không có công thức đạo hàm tường minh, chỉ có kiểu "hộp đen" (black-box: đưa input → nhận output).

## 0.2. Vì sao cần metaheuristic

🔹 **Metaheuristic** = thuật toán tối ưu ngẫu nhiên (stochastic), lấy cảm hứng từ hiện tượng tự nhiên (sinh học, vật lý, hóa học, hành vi xã hội con người), có các đặc điểm [SFOA §1]:

- Dựa trên **quần thể** (population-based): nhiều nghiệm ứng viên cùng tìm kiếm song song, chứ không chỉ 1 điểm như gradient descent.
- **Không cần đạo hàm** — chỉ cần tính được giá trị hàm mục tiêu tại một điểm (black-box).
- **Dễ triển khai**, linh hoạt áp dụng cho nhiều loại bài toán khác nhau (liên tục, rời rạc, có ràng buộc).
- Không đảm bảo tìm được nghiệm tối ưu toàn cục tuyệt đối, nhưng thực nghiệm cho thấy hiệu quả rất tốt trên diện rộng bài toán.

## 0.3. Exploration vs Exploitation và định lý No Free Lunch

🔹 Đây là **hai khái niệm quan trọng nhất** để hiểu bất kỳ metaheuristic nào, bao gồm SFOA:

| Khái niệm | Ý nghĩa | Vai trò |
|---|---|---|
| **Exploration** (Khám phá / thăm dò) | Khả năng tìm kiếm **toàn cục** — quét rộng không gian thiết kế, tránh bỏ sót vùng chứa nghiệm tốt | Tránh kẹt cực trị địa phương |
| **Exploitation** (Khai thác) | Khả năng tìm kiếm **cục bộ**, tinh chỉnh quanh nghiệm tốt đã tìm được | Đẩy nhanh hội tụ, tăng độ chính xác |

⚠️ Nếu một thuật toán nghiêng hẳn về Exploration → hội tụ chậm, tốn tài nguyên. Nếu nghiêng hẳn về Exploitation → dễ kẹt cực trị địa phương (premature convergence). **Cân bằng đúng giữa hai pha này là "linh hồn" của thiết kế thuật toán metaheuristic** [SFOA §1].

🔹 **Định lý No Free Lunch (NFL)** [Wolpert & Macready, 1997 — trích trong SFOA §1 và MOSFOA §1]:

> Không có thuật toán tối ưu nào là tốt nhất cho **mọi** bài toán. Một thuật toán vượt trội trên tập bài toán này có thể kém hơn thuật toán khác trên tập bài toán khác.

Hệ quả trực tiếp: việc phát triển liên tục các thuật toán mới (SFOA, rồi MOSFOA) không phải là "thừa" mà có cơ sở lý thuyết — không thuật toán nào vượt trội tuyệt đối, nên nghiên cứu thuật toán mới/thuật toán chuyên biệt cho lớp bài toán riêng (ví dụ: tối ưu kết cấu công trình biển) vẫn có giá trị khoa học.

## 0.4. Bản đồ họ thuật toán metaheuristic

SFOA (§2, Fig. 1) phân loại metaheuristic hiện có thành **4 nhóm cảm hứng chính**:

```
                     Metaheuristic Algorithm
                              │
        ┌──────────────┬──────┴───────┬───────────────┐
   Swarm Intelligence  Evolutionary   Physics/Chemistry  Human-Based
   (bầy đàn)           Algorithm      -Based Algorithm   Algorithm
        │                  │               │                 │
   PSO, ACO, GWO,      GA, DE, ES,     SA, GSA, WCA,      HS, TLBO,
   ABC, MPA, SSA,      EP, GP, BBO     MVO, EO, CBO       ICA, BSO,
   HHO, SFOA (mới)                                        JAYA, YYPO
```

- **Swarm Intelligence** (trí tuệ bầy đàn): mô phỏng hành vi kiếm ăn/săn mồi/di chuyển theo bầy (PSO — đàn cá/chim, GWO — sói xám, MPA — sinh vật biển, và **SFOA — sao biển**, chính là thuật toán ta học ở Phần 1).
- **Evolutionary Algorithm** (thuật toán tiến hóa): mô phỏng chọn lọc tự nhiên, lai ghép, đột biến (GA, DE — Differential Evolution sẽ dùng lại trong E-MOSFOA §3.3).
- **Physics/Chemistry-based**: mô phỏng định luật vật lý/hóa học (SA — luyện kim mô phỏng, GSA — lực hấp dẫn).
- **Human-based**: mô phỏng hành vi xã hội con người (TLBO — dạy và học, HS — ứng tác âm nhạc).

✍️ *Tự kiểm tra:* SFOA thuộc nhóm nào trong 4 nhóm trên? Vì sao? (Gợi ý: xem lại "Inspiration" §3.1 của SFOA.)

---

# PHẦN 1 — TỐI ƯU HÓA ĐƠN MỤC TIÊU (SOO) QUA SFOA

## 1.1. Cảm hứng sinh học của SFOA

SFOA lấy cảm hứng từ hành vi của **sao biển** (starfish, lớp Asteroidea) — SFOA §3.1 mô tả rất chi tiết 4 hành vi sinh học, mỗi hành vi ánh xạ sang một cơ chế toán học:

| Hành vi sinh học thật | Mô tả sinh học | Cơ chế toán học tương ứng |
|---|---|---|
| **Cấu trúc 5 cánh tay + mắt ở đầu cánh** | Sao biển có 5 cánh tay (đa số loài), mắt cảm nhận ánh sáng nằm ở đầu mỗi cánh | Pha Khám phá: cập nhật đồng thời **5 chiều** ngẫu nhiên khi D > 5 |
| **Di chuyển bằng chân ống, không có não/tim** | Chuyển động "tự phát", không có trung tâm điều khiển | Mỗi cá thể cập nhật độc lập, ngẫu nhiên |
| **Săn mồi (Prey)**: cánh tay bao vây, dạ dày lộn ra tiêu hóa con mồi, sao biển tụ tập & chia sẻ thông tin | Hành vi hợp tác nhóm khi săn mồi | Pha Khai thác — chiến lược tìm kiếm hai hướng song song (parallel two-directional search) dựa trên vị trí best & các cá thể khác |
| **Tái sinh (Regeneration)**: mất cánh tay khi bị đe dọa, rồi mọc lại; quá trình rất chậm | Cơ chế sinh tồn đặc biệt, tốc độ chậm | Pha Khai thác — công thức tái sinh chỉ áp dụng cho **1 cá thể cuối** quần thể (i = N), hệ số suy giảm theo hàm mũ |

⚠️ Điểm hay của bài báo: **ngưỡng "5"** không phải một con số tùy tiện — nó bắt nguồn trực tiếp từ số cánh tay thật của sao biển. Đây là ví dụ tốt về cách một ẩn dụ sinh học được "dịch" thành một tham số thuật toán có ý nghĩa.

## 1.2. Khởi tạo quần thể

📐 **Eq. (1)–(3) [SFOA]:**

Ma trận vị trí quần thể X có kích thước N×D (N cá thể, D chiều):

```
X = [ X11  X12 ... X1D ]
    [ X21  X22 ... X2D ]
    [ ...  ...  ... ... ]
    [ XN1  XN2 ... XND ]
```

Mỗi phần tử khởi tạo ngẫu nhiên đều trong biên:

```
Xij = lj + r·(uj − lj),   i = 1..N,  j = 1..D
```

trong đó `r ∈ (0,1)` ngẫu nhiên đều, `lj`, `uj` là biên dưới/trên của biến thứ j.

Sau khi khởi tạo, tính vector độ thích nghi (fitness) `F = [F(X1), F(X2), ..., F(XN)]ᵀ` bằng cách gọi hàm mục tiêu cho từng cá thể.

💻 *Pseudo-code khởi tạo (Python/MATLAB-style):*
```python
X = lb + np.random.rand(N, D) * (ub - lb)
F = np.array([objective(X[i]) for i in range(N)])
best_idx = np.argmin(F)
X_best = X[best_idx].copy()
```

## 1.3. Pha Khám phá (Exploration)

🔹 Đây là điểm **sáng tạo cốt lõi** của SFOA: kết hợp lai (hybrid) giữa hai kiểu tìm kiếm tùy theo **số chiều D** của bài toán:

### 1.3a. Trường hợp D > 5: tìm kiếm 5 chiều ("arm-twist")

Ý tưởng: khi không gian tìm kiếm lớn (D > 5), sao biển "vươn" cả 5 cánh tay để dò xét môi trường xung quanh, nghĩa là **chỉ cập nhật 5 chiều được chọn ngẫu nhiên** trong D chiều (chứ không phải toàn bộ D chiều như hầu hết thuật toán khác — đây gọi là **vectorial search pattern** truyền thống).

📐 **Eq. (4)–(6) [SFOA]:**
```
Y(i,p) = X(i,p) + a1·(X(best,p) − X(i,p))·cos(θ),   nếu r ≤ 0.5
Y(i,p) = X(i,p) − a1·(X(best,p) − X(i,p))·sin(θ),   nếu r > 0.5

a1 = (2r − 1)·π
θ  = (π/2) · (T / Tmax)
```
- `p`: một trong 5 chiều được chọn ngẫu nhiên trong D chiều.
- `T`, `Tmax`: vòng lặp hiện tại và vòng lặp tối đa.
- **Ý nghĩa vật lý**: số hạng sin/cos mô phỏng việc cánh tay "vặn xoắn trái/phải" (twist left/right) để tiếp cận thức ăn với xác suất như nhau. `θ` tăng dần từ 0 → π/2 theo tiến trình vòng lặp — đây là cơ chế **thích nghi theo thời gian** (time-varying), khiến biên độ dao động sin/cos thay đổi dần trong quá trình tối ưu.
- Nếu vị trí mới `Y` vượt biên → cá thể **giữ nguyên vị trí cũ** (Eq. 7), không kẹp về biên như nhiều thuật toán khác. Đây là lựa chọn thiết kế đáng chú ý: tránh việc các cá thể bị "dồn cục" ở biên.

### 1.3b. Trường hợp D ≤ 5: tìm kiếm một chiều ("energy-step")

Khi không gian nhỏ (D ≤ 5), chỉ 1 "cánh tay" (1 chiều) cập nhật, dùng thông tin từ 2 cá thể khác được chọn ngẫu nhiên:

📐 **Eq. (8)–(9) [SFOA]:**
```
Y(i,q) = Et·X(i,p) + A1·(X(k1,p) − X(i,p)) + A2·(X(k2,p) − X(i,p))

Et = ((Tmax − T) / Tmax) · cos(θ)
```
- `A1, A2 ∈ (−1, 1)` ngẫu nhiên; `Et` là "năng lượng" của sao biển, **giảm dần tuyến tính** theo số vòng lặp (mô phỏng sao biển "mệt dần") nhân thêm hệ số cos(θ) dao động.
- k1, k2: chỉ số 2 cá thể ngẫu nhiên khác (không phải cá thể tốt nhất) — cho phép trao đổi thông tin phi tập trung giữa các cá thể (không nhất thiết phải "học theo" best).

⚠️ **Điểm dễ nhầm**: ngưỡng D > 5 hay D ≤ 5 không phải là "chọn 1 trong 2 mãi mãi cho cả bài toán" — nó được xác định **một lần duy nhất khi bắt đầu** dựa trên số chiều cố định của bài toán, áp dụng xuyên suốt toàn bộ vòng lặp. Ví dụ: bài toán 30 chiều (D=30) luôn dùng công thức (4)-(7); bài toán tension spring design (D=3, xem §1.9) luôn dùng công thức (8)-(9).

💻 So sánh trực quan hai kiểu tìm kiếm:

```python
if D > 5:
    dims = np.random.choice(D, 5, replace=False)
    for p in dims:
        a1 = (2*np.random.rand() - 1) * np.pi
        if np.random.rand() <= 0.5:
            Y[p] = X[i,p] + a1*(X_best[p]-X[i,p])*np.cos(theta)
        else:
            Y[p] = X[i,p] - a1*(X_best[p]-X[i,p])*np.sin(theta)
else:
    p = np.random.randint(D)
    k1, k2 = np.random.choice(N, 2, replace=False)
    A1, A2 = np.random.uniform(-1,1,2)
    Y[p] = Et*X[i,p] + A1*(X[k1,p]-X[i,p]) + A2*(X[k2,p]-X[i,p])
```

## 1.4. Pha Khai thác (Exploitation)

Pha này mô phỏng **hai** hành vi: săn mồi (preying) và tái sinh (regeneration).

### 1.4a. Săn mồi — chiến lược tìm kiếm hai hướng song song

📐 **Eq. (10)–(11) [SFOA]:**
```
dm = X(best) − X(mp),     m = 1..5   (5 khoảng cách ngẫu nhiên)
Y(i) = X(i) + r1·dm1 + r2·dm2
```
- Tính 5 khoảng cách giữa nghiệm tốt nhất hiện tại và 5 cá thể ngẫu nhiên khác, rồi **chọn ngẫu nhiên 2 trong 5 khoảng cách đó** (`dm1`, `dm2`) để cập nhật vị trí — đây là **"parallel two-directional search"**: vì `r1, r2 ∈ (0,1)` dương, nên một số cá thể tiến **về phía** nghiệm tốt (di chuyển thuận theo hướng dm), số khác tiến **ra xa** (nếu dm mang giá trị âm ở một số chiều) trong cùng một vòng lặp — giúp quần thể vừa hội tụ vừa duy trì đa dạng, tránh kẹt cực trị địa phương.

### 1.4b. Tái sinh — chỉ áp dụng cho cá thể cuối cùng (i = N)

📐 **Eq. (12) [SFOA]:**
```
Y(N) = exp(−T·N / Tmax) · X(N)
```
- Chỉ **một cá thể duy nhất** trong quần thể (quy ước i = N, tức "cá thể cuối" theo chỉ số) thực hiện bước này mỗi vòng lặp — chi phí tính toán cực nhỏ (chỉ 1 phép tính hàm mục tiêu thêm mỗi vòng lặp) nhưng đóng vai trò "bơm" đa dạng và tránh hội tụ sớm (SFOA §3.2.3: "mặc dù pha tái sinh có số lần đánh giá hàm mục tiêu rất nhỏ ... nhưng vẫn cần thiết để tránh nghiệm cục bộ").
- Ý nghĩa sinh học: tái sinh là quá trình **chậm** trong tự nhiên (vài tháng đến vài năm) → hệ số mũ suy giảm theo T mô phỏng "tốc độ chậm" này.

## 1.5. Xử lý biên và tham số điều khiển GP

📐 **Eq. (13) [SFOA]** — xử lý biên cho pha khai thác (khác với pha khám phá, ở đây **kẹp** về biên thay vì giữ nguyên):
```
X(i)^(T+1) = { Y(i)^T        nếu lb ≤ Y(i)^T ≤ ub
             { lb            nếu Y(i)^T < lb
             { ub            nếu Y(i)^T > ub
```

🔹 **Tham số GP (Gp = 0.5)** — tham số **duy nhất** của SFOA gốc, quyết định xác suất rơi vào pha Khám phá hay Khai thác mỗi vòng lặp, mỗi cá thể:
```
rand > GP  →  pha Khám phá (Exploration)
rand ≤ GP  →  pha Khai thác (Exploitation)
```
với `GP = 0.5` nghĩa là **hai pha có xác suất bằng nhau** mỗi vòng lặp.

✍️ *Phân tích độ nhạy (SFOA §4.3, Table 7):* Bài báo thử nghiệm 5 giá trị GP ∈ {0, 0.25, 0.5, 0.75, 1.0}:
- `GP = 0` → chỉ dùng pha Khai thác (không bao giờ Khám phá).
- `GP = 1.0` → chỉ dùng pha Khám phá (không bao giờ Khai thác) → **SFOA thất bại hội tụ ở nhiều hàm** (F1–F5, F13–F16) → chứng minh bằng thực nghiệm rằng **thiếu Khai thác thì không hội tụ được**, dù Khám phá tốt đến đâu.
- `GP = 0.5` (mặc định) cho kết quả cân bằng tốt nhất ở nhiều hàm phức tạp (F21–F24).

Đây là bằng chứng thực nghiệm trực tiếp cho nguyên lý "cân bằng Exploration/Exploitation" đã nêu ở §0.3.

## 1.6. Quy trình đầy đủ và độ phức tạp tính toán

### Lưu đồ tổng quát (Fig. 6, SFOA):

```
Bắt đầu
  │
  ▼
Khởi tạo quần thể X, tính F(X)
  │
  ▼
┌─────────────── Vòng lặp chính (T = 1..Tmax) ───────────────┐
│                                                             │
│   rand > Gp?  ──Yes──▶  KHÁM PHÁ                            │
│      │                    - tính θ, Et                      │
│      No                   - D>5: cập nhật 5 chiều (Eq.4)    │
│      │                    - D≤5: cập nhật 1 chiều (Eq.8)    │
│      ▼                    - check biên (Eq.7, giữ nguyên)   │
│   KHAI THÁC                                                  │
│      - tính 5 khoảng cách dm (Eq.10)                         │
│      - i≠N: săn mồi (Eq.11)                                  │
│      - i=N: tái sinh (Eq.12)                                 │
│      - check biên (Eq.13, kẹp về biên)                       │
│                                                             │
│   Đánh giá lại F(X), cập nhật nghiệm tốt nhất                │
│   T = T + 1                                                 │
└──────────────────────── Stop nếu T = Tmax ──────────────────┘
  │
  ▼
Xuất nghiệm toàn cục
```

### Độ phức tạp tính toán 📐 (Eq. 14–15, SFOA §3.4):

- Khởi tạo: `O(N·D)`
- Khám phá (D>5): `O(½·Tmax·N·5)`; Khai thác: `O(½·Tmax·N·D)`
- **Tổng (D>5):** `O(N·Tmax·D·(1/2 + 5/2D))`
- **Tổng (D≤5):** `O(N·Tmax·D·(1/2 + 1/2D))`

So sánh với PSO có độ phức tạp `O(Tmax·N·D)` — SFOA **nhỏ hơn** PSO trong hầu hết trường hợp (do chỉ cập nhật 5 hoặc 1 chiều ở pha Khám phá thay vì toàn bộ D chiều), dù **số lần đánh giá hàm mục tiêu** (function evaluations, FEs) của SFOA bằng đúng PSO (`N·Tmax`). Đây là lý do SFOA nhanh hơn PSO dù cùng số FEs — ý nghĩa thực tiễn: khi mỗi lần đánh giá hàm mục tiêu **rẻ** (rẻ = tính toán số học đơn giản), lợi thế tốc độ này đến từ chi phí xử lý nội bộ thấp hơn; còn khi mỗi lần đánh giá **đắt** (ví dụ: 1 lần gọi SAP2000 để giải FEM, như ở case study Phần 4), lợi thế tốc độ nội tại của SFOA trở nên **không đáng kể** so với chi phí gọi FEM — lúc đó tiêu chí quan trọng nhất là **số FEs** (bằng đúng PSO, ít hơn MPA/LSHADE).

## 1.7. So sánh SFOA với các thuật toán khác (PSO, GWO, MPA, DE)

SFOA §3.5 và §3.6 dành hẳn 1 mục để phân tích lý thuyết (không chỉ thực nghiệm) sự khác biệt về **mô hình toán học**:

| Thuật toán | Cơ chế cập nhật chính | Khác biệt cốt lõi với SFOA |
|---|---|---|
| **PSO** | 1 công thức duy nhất: quán tính + nhận thức cá nhân + xã hội | PSO dùng **1** chiến lược cho cả tìm kiếm toàn cục & cục bộ; SFOA có **hai pha tách biệt rõ ràng** (Khám phá / Khai thác) với công thức khác hẳn nhau |
| **GWO** | Phân cấp bầy đàn (alpha/beta/delta wolves), nhiều chiến lược tấn công | GWO chia quần thể theo thứ bậc; SFOA không phân cấp, chỉ có 1 cá thể đặc biệt (cá thể cuối, cho tái sinh) |
| **ABC** | 3 loại ong (employed/onlooker/scout) với cơ chế riêng biệt | Tương tự GWO — SFOA đơn giản hơn về số "vai trò" |
| **MPA** | 3 quy tắc cập nhật theo tỉ lệ vận tốc (Brownian/Lévy motion) | MPA phức tạp hơn (3 pha theo giai đoạn Brownian/Lévy + eddy formation + memory); SFOA chỉ 2 pha |
| **DE (rand-to-best/1)** | `X_new = X_best + β·(X_r1 − X_r2)`, β ngẫu nhiên [-1,1], có bước crossover riêng | SFOA "trông giống" DE ở pha Khám phá nhưng hệ số `θ` biến thiên theo vòng lặp và lồng trong hàm sin/cos (DE không có); hệ số `a1 = (2r-1)π` có biên độ lớn hơn β của DE; SFOA **không có bước crossover** riêng biệt; pha Khai thác của SFOA còn có thêm cơ chế tái sinh mà DE cơ bản không có |

⚠️ **Ghi nhớ quan trọng cho việc viết bài báo/so sánh học thuật**: SFOA dễ bị hiểu lầm là "một biến thể của DE" vì công thức pha Khám phá có dạng tương tự `best + hệ số×(hiệu hai vector)`. Bài báo dành hẳn đoạn văn (SFOA cuối §3.6) để phản biện điều này — cần nắm chắc luận điểm này nếu viết phần "Related Work" so sánh thuật toán.

## 1.8. Benchmark, chỉ số thống kê và phương pháp so sánh 100 thuật toán

### 1.8a. Ba bộ hàm benchmark

| Bộ hàm | Số lượng | Đặc điểm |
|---|---|---|
| **Classical (cổ điển)** | 24 hàm (F1–F24) | Đơn giản, gồm unimodal (1 cực trị, ví dụ Sphere F1) và multimodal (nhiều cực trị, ví dụ Rastrigin F13) |
| **CEC 2017** | 29 hàm | Phức tạp hơn: unimodal, multimodal, hybrid (ghép nhiều hàm con), composite (tổ hợp có trọng số) |
| **CEC 2022** | 12 hàm | Phiên bản benchmark mới nhất, cùng logic với CEC2017 nhưng cập nhật |

🔹 Phân biệt 2 loại hàm quan trọng:
- **Unimodal**: chỉ có 1 cực tiểu toàn cục → dùng để đánh giá **tốc độ hội tụ** (exploitation).
- **Multimodal**: nhiều cực tiểu địa phương → dùng để đánh giá **khả năng thoát cực trị địa phương** (exploration).

### 1.8b. Chỉ số thống kê (30 lần chạy độc lập)

Với mỗi hàm, mỗi thuật toán chạy 30 lần độc lập (do bản chất ngẫu nhiên của metaheuristic), báo cáo 4 chỉ số:

| Chỉ số | Ý nghĩa |
|---|---|
| **Best** | Giá trị nhỏ nhất tìm được trong 30 lần chạy |
| **Mean** | Giá trị trung bình |
| **Worst** | Giá trị lớn nhất (tệ nhất) |
| **STD** (Standard Deviation) | Độ lệch chuẩn — **thước đo độ ổn định**: STD nhỏ và gần 0 nghĩa là thuật toán cho kết quả nhất quán qua các lần chạy khác nhau |

### 1.8c. Phương pháp so sánh "one-on-one" và Rank-1 percentage

Vì so sánh SFOA với **100** thuật toán khác cùng lúc, các chỉ số thống kê cổ điển (Friedman rank, Wilcoxon) sẽ bị "làm phẳng" hiệu năng do số lượng đối thủ quá lớn [SFOA §4.5]. Bài báo đề xuất **one-on-one comparison**:

📐 **Eq. (16)–(17) [SFOA]:**
```
θp = Σ R1 / NA     (Rank-1 percentage của SFOA)
θc = Σ R2 / NA     (Rank-1 percentage của thuật toán so sánh)
```
- Với mỗi hàm benchmark, so 1-1 giữa SFOA và **từng** thuật toán trong 100 thuật toán: ai thắng thì được "rank 1"; nếu hòa (cả hai đạt nghiệm toàn cục) thì **cả hai** được rank 1.
- `θp` = % số lần SFOA "rank 1" trên tổng NA=100 lần so sánh, cho một hàm cụ thể.
- Ví dụ cụ thể (SFOA §4.5): ở hàm F1, SFOA thắng 37/100 thuật toán về độ chính xác tuyệt đối nhưng **hòa** ở mức nghiệm toàn cục nên `θp = 100%`, còn `θc = 37%` (chỉ 37 thuật toán khác cũng đạt nghiệm toàn cục).

**Kết quả tổng kết (SFOA §4.5, Table 10–11):**
- Classical: SFOA đạt Rank-1 trung bình **85.3%** (so với 32.8% của 100 thuật toán khác).
- CEC2017: **86.5%** (so với 15.2%).
- CEC2022: **87.3%** (so với 18.4%).
- Tổng kết thắng/thua: SFOA thắng **95/100** thuật toán về độ chính xác (2 hòa, 3 thua — thua LSHADE, MPA, WFO), thắng **97/100** về hiệu suất/thời gian CPU (3 thua — AFT, HS, WFO). **Chỉ duy nhất WFO thắng SFOA cả về độ chính xác lẫn hiệu suất.**

✍️ *Câu hỏi tự kiểm tra:* Nếu SFOA thua MPA về độ chính xác nhưng SFOA vẫn được coi là thuật toán tốt, dựa trên lập luận nào của bài báo? (Gợi ý: xem lại số tham số thuật toán, số lần đánh giá hàm mục tiêu FEs, và thời gian CPU ở SFOA §4.5 đoạn cuối.)

## 1.9. Bài toán kỹ thuật thực tế (Engineering case studies)

SFOA §5 thử nghiệm trên **10 bài toán kỹ thuật thực** (không phải hàm toán học trừu tượng), so sánh với 7 thuật toán phổ biến (PSO, BBO, GWO, WOA, SSA, HHO, AOA). Đây chính là "cầu nối" quan trọng dẫn tới case study Phần 4 (bến cảng) — vì cấu trúc bài toán **giống hệt về logic**: biến thiết kế → hàm mục tiêu (thường là khối lượng/chi phí) → ràng buộc kỹ thuật.

| # | Bài toán | Số biến | Ý nghĩa ràng buộc |
|---|---|---|---|
| 1 | Cantilever beam (dầm công-xôn) | 5 | Chuyển vị đầu tự do |
| 2 | Welded beam (dầm hàn) | 4 | Ứng suất cắt, uốn, độ võng, ổn định |
| 3 | Tension/compression spring (lò xo) | 3 | Ứng suất cắt, tần số, độ võng |
| 4 | Pressure vessel (bình áp lực) | 4 | Áp suất, thể tích |
| 5 | Three-bar truss (giàn 3 thanh) | 2 | Ứng suất |
| 6 | Speed reducer (hộp giảm tốc) | 7 | 11 ràng buộc cơ khí |
| 7 | Himmelblau problem | 5 | 6 ràng buộc phi tuyến |
| 8 | Multiple disk clutch brake | 5 (có biến rời rạc) | 9 ràng buộc |
| 9 | Car side impact | 11 | 10 ràng buộc — bài toán phức tạp nhất |
| 10 | Step cone pulley | 5 | 11 ràng buộc đẳng thức + bất đẳng thức |

**Nhận xét quan trọng cho người tự học hướng tới kỹ thuật xây dựng/công trình biển:**
- Ràng buộc được xử lý bằng **phương pháp hàm phạt** (penalty function method) — SFOA §5 nói rõ: "chúng tôi dùng phương pháp hàm phạt để xử lý ràng buộc do tính đơn giản và hiệu quả". Đây **chính là kỹ thuật được kế thừa** trong MOSFOA case study (Phần 4, §4.3).
- Với mỗi bài toán, bảng kết quả đều có cột `fmin` (giá trị hàm mục tiêu tốt nhất) và bộ biến thiết kế tối ưu tương ứng — đọc bảng này là cách luyện tư duy "đọc kết quả tối ưu kỹ thuật" cần thiết cho Phần 4.
- Bảng thống kê 30 lần chạy (Table 22, SFOA) cho thấy: **SFOA rất ổn định** (STD cực nhỏ) trong khi PSO/WOA/AOA có STD rất lớn ở một số bài toán (ví dụ Step cone pulley: STD của WOA lên tới 247,083 — chứng tỏ đôi khi WOA "sập" hoàn toàn không hội tụ). Đây là bài học quan trọng: **hiệu năng trung bình không đủ, cần nhìn cả STD/Worst để đánh giá độ tin cậy của thuật toán trong ứng dụng kỹ thuật thật.**

## 1.10. Bài tập thực hành Phần 1

✍️ **Bài 1.1 (lý thuyết):** Vẽ lại lưu đồ SFOA (không nhìn tài liệu), chú thích đầy đủ công thức tại mỗi bước.

✍️ **Bài 1.2 (lập trình):** Cài đặt SFOA từ đầu bằng Python hoặc MATLAB, kiểm chứng trên hàm Sphere (F1, D=30, biên [-100,100]). Kỳ vọng: hội tụ về 0 trong vài trăm vòng lặp (theo Table 6, SFOA đạt Best=Mean=Worst=STD=0 tại D=30).

✍️ **Bài 1.3 (phân tích độ nhạy):** Tự chạy lại SFOA của bạn với GP ∈ {0, 0.25, 0.5, 0.75, 1.0} trên hàm Rastrigin (F13, multimodal). Vẽ đường hội tụ (convergence curve) cho cả 5 trường hợp trên cùng một đồ thị, so sánh với Table 7 của SFOA.

✍️ **Bài 1.4 (ứng dụng kỹ thuật):** Cài đặt lại bài toán "tension/compression spring design" (§1.9, mục 3, D=3) — đối chiếu kết quả của bạn với Table 14 (SFOA): `fmin = 0.01267`.

✍️ **Bài 1.5 (tư duy phản biện):** Đọc lại đoạn phản biện "SFOA vs DE" ở SFOA §3.6, tự liệt kê 3 điểm khác biệt toán học cụ thể (không chép nguyên văn, diễn giải lại bằng lời của bạn).

---

# PHẦN 2 — TỐI ƯU HÓA ĐA MỤC TIÊU (MOO)

## 2.1. Vì sao một mục tiêu là không đủ

🔹 Trong thực tế kỹ thuật (đặc biệt công trình biển), gần như luôn tồn tại **nhiều mục tiêu xung đột nhau** [MOSFOA §1]:
- Giảm **chi phí xây dựng** thường đòi hỏi giảm kích thước/số lượng cọc → nhưng lại làm **tăng chuyển vị** kết cấu (giảm độ cứng).
- Ngược lại, tăng độ cứng (giảm chuyển vị) thường đòi hỏi tăng kích thước cấu kiện → tăng chi phí.

Nếu chỉ tối ưu 1 mục tiêu (ví dụ chỉ minimize cost), nghiệm thu được có thể **vi phạm** hoặc cận biên về mục tiêu còn lại (chuyển vị quá lớn), hoặc ngược lại. **Bài toán MOO không tìm 1 nghiệm duy nhất, mà tìm một *tập* nghiệm đánh đổi (trade-off)** để kỹ sư/người ra quyết định lựa chọn theo ưu tiên thực tế.

## 2.2. Pareto dominance, Pareto Set và Pareto Front

🔹 **Định nghĩa Pareto dominance** (MOSFOA §2, dựa trên Deb 2001, Pareto 1964):

> Nghiệm `x1` **trội hơn** (dominates) nghiệm `x2` nếu `x1` không tệ hơn `x2` ở **tất cả** các mục tiêu, và tốt hơn **hẳn** ở **ít nhất một** mục tiêu.

- **Pareto Set (PS)**: tập hợp tất cả các nghiệm **không bị trội** (non-dominated) trong không gian biến thiết kế.
- **Pareto Front (PF)**: ảnh của PS trong không gian mục tiêu (giá trị các hàm mục tiêu tương ứng) — đây chính là "đường cong đánh đổi" mà ta thường thấy trên đồ thị 2D (cost vs displacement).

📌 Minh họa trực quan (bài toán 2 mục tiêu — giống case study bến cảng):

```
 f2 (Chuyển vị)
   │
   │  ×  ×
   │      ×
   │        ×  ← Pareto Front: không điểm nào
   │           ×    trội hơn điểm khác trên đường này
   │              ×
   │   • (nghiệm bị trội — tệ hơn ở CẢ 2 mục tiêu
   │       so với ít nhất 1 điểm trên PF)
   └──────────────────────────── f1 (Chi phí)
```

⚠️ **Điểm hay nhầm:** Pareto Front **không phải** là "nghiệm tốt nhất" theo nghĩa duy nhất — nó là **tập hợp các nghiệm không thể cải thiện mục tiêu này mà không làm xấu đi mục tiêu khác**. Việc chọn 1 điểm cụ thể trên PF để triển khai thực tế là quyết định của kỹ sư/chủ đầu tư (decision maker), **không phải** việc của thuật toán tối ưu.

🔹 Thách thức chính của MOO (MOSFOA §2): thuật toán cần đạt một **PF xấp xỉ tốt** — nghĩa là vừa:
1. **Hội tụ tốt** (convergence): các điểm gần với PF thật.
2. **Đa dạng tốt** (diversity): các điểm trải đều, không bị dồn cục ở một vùng của PF, và bao phủ đủ rộng phạm vi đánh đổi.

Đây là lý do cần các cơ chế đặc thù cho MOO (Pareto dominance, external archive, chọn leader theo mật độ...) mà một thuật toán SOO thuần túy như SFOA gốc **không có**.

## 2.3. Các phương pháp quy về đơn mục tiêu (weighted-sum, ε-constraint)

Trước khi có các thuật toán tiến hóa đa mục tiêu hiện đại, người ta thường "quy đổi" bài toán MOO về bài toán SOO bằng các kỹ thuật cổ điển [MOSFOA §2]:

- **Weighted-sum method**: `F(x) = w1·f1(x) + w2·f2(x) + ...`, với `Σwi = 1`. Nhược điểm: phải chạy nhiều lần với các bộ trọng số khác nhau để dò ra cả đường PF; không hiệu quả với PF không lồi (non-convex).
- **ε-constraint method**: giữ 1 mục tiêu làm hàm mục tiêu chính, các mục tiêu còn lại chuyển thành ràng buộc `fi(x) ≤ εi`.
- **Interactive decision-making**: người ra quyết định tương tác trực tiếp với thuật toán trong quá trình tìm kiếm.

🔹 Các phương pháp này vẫn hữu ích trong nhiều tình huống thực tế, nhưng **không cho ra toàn bộ PF trong một lần chạy** — đây là lý do các thuật toán tiến hóa đa mục tiêu quần thể (population-based EMO) ra đời.

## 2.4. Metaheuristic đa mục tiêu quần thể: NSGA-II, SPEA2, PAES, MOPSO

MOSFOA §3 xây dựng B-MOSFOA/E-MOSFOA bằng cách **mượn 3 cơ chế nền tảng** từ các thuật toán MOO kinh điển sau — cần nắm ý tưởng gốc của từng thuật toán trước khi đọc MOSFOA:

| Thuật toán | Năm | Ý tưởng cốt lõi | Cơ chế được MOSFOA kế thừa |
|---|---|---|---|
| **NSGA-II** (Deb et al.) | 2002 | Sắp xếp không trội nhanh (fast non-dominated sorting) + crowding distance | Nguyên lý lưu trữ nghiệm không trội (external archive) |
| **SPEA2** (Zitzler et al.) | 2001 | Archive kích thước cố định, tính độ mạnh (strength) dựa trên số nghiệm bị trội | Nguyên lý external archive có giới hạn kích thước |
| **PAES** (Knowles & Corne) | 2000 | Chia không gian mục tiêu thành lưới (grid/adaptive grid) để đo mật độ | **Grid-based diversity control** — cơ chế lưới thích nghi dùng trong B-MOSFOA §3.1b |
| **MOPSO** (Coello et al.) | 2004 | Chọn "leader" (hạt dẫn đường) từ archive theo mật độ vùng lưới, dùng roulette wheel | **Density-based leader selection** — cơ chế chọn leader dùng trong B-MOSFOA §3.1c |

🔹 **Ý tưởng "adaptive grid" (lưới thích nghi)** — nắm khái niệm này kỹ vì nó là nền tảng của cả archive lẫn leader selection trong MOSFOA:

1. Không gian mục tiêu (2D hoặc 3D) được chia thành các ô lưới (grid cell) đều nhau.
2. Đếm số nghiệm rơi vào mỗi ô lưới → ô nào **ít nghiệm** (thưa) được ưu tiên hơn khi:
   - Cần **loại bớt** nghiệm khi archive đầy → **giữ lại** nghiệm ở ô thưa, loại bớt nghiệm ở ô đông.
   - Cần **chọn leader** để dẫn đường tìm kiếm → **ưu tiên chọn** nghiệm từ ô thưa, để quần thể "khám phá" thêm vùng còn trống của PF thay vì dồn hết vào vùng đã đông.

## 2.5. Bốn chỉ số đánh giá chất lượng Pareto Front: IGD, ε, Δ, MS

MOSFOA §4.2 (Table 2) dùng 4 chỉ số **unary** (đánh giá một tập nghiệm độc lập, so với PF thật/tham chiếu) để lượng hóa chất lượng thuật toán:

| Chỉ số | Đo gì | Mục đích | Giá trị tốt |
|---|---|---|---|
| **ε (epsilon)** [Zitzler et al. 2000] | Độ dịch chuyển tối thiểu cần để tập nghiệm "trội" được PF tham chiếu | Hội tụ (convergence) | **Thấp** |
| **IGD (Inverted Generational Distance)** [Knowles & Thiele 2006] | Khoảng cách trung bình từ mỗi điểm trên PF **tham chiếu** tới điểm **gần nhất** trong tập nghiệm xấp xỉ | Hội tụ **+** đa dạng | **Thấp** |
| **Δ (Delta / Spacing)** [Deb 2002 — NSGA-II] | Độ đồng đều khoảng cách giữa các nghiệm liên tiếp trên PF xấp xỉ | Phân bố (distribution) | **Thấp** |
| **MS (Maximum Spread)** | Phạm vi lớn nhất mà tập nghiệm bao phủ trong không gian mục tiêu | Đa dạng (diversity) | **Cao** |

🔹 **Vì sao cần cả 4 chỉ số, không chỉ 1?** Vì mỗi chỉ số chỉ đo **một khía cạnh**:
- Một tập nghiệm có thể có **IGD thấp** (gần PF thật) nhưng **MS thấp** (chỉ tập trung ở một góc nhỏ của PF) → nhìn tổng thể là kém dù IGD đẹp.
- Một tập nghiệm có thể có **MS cao** (bao phủ rộng) nhưng **Δ cao** (phân bố không đều — dồn cục ở 2 đầu, thưa ở giữa) → nhìn tổng thể vẫn kém.

⚠️ Đây chính là điểm then chốt để đọc hiểu các bảng kết quả MOSFOA (Bảng 3–5): **không có thuật toán nào thắng tuyệt đối ở cả 4 chỉ số cùng lúc** — MOSFOA §4.3 liên tục nhấn mạnh "complementary strengths" (thế mạnh bổ trợ lẫn nhau) giữa B-MOSFOA và E-MOSFOA — đọc bảng số liệu cần nhìn **toàn cảnh 4 chỉ số**, không chỉ 1 chỉ số rồi vội kết luận thuật toán nào "thắng tuyệt đối".

### Cách tính (trực giác, không cần nhớ công thức chính xác để tự học ở mức ứng dụng):

```
IGD(A, P*) = (1/|P*|) · Σ_{z∈P*} min_{a∈A} dist(z, a)
```
trong đó `P*` là PF tham chiếu (thường biết trước với hàm benchmark chuẩn), `A` là tập nghiệm thuật toán tìm được.

## 2.6. Bộ benchmark IMOP, UF, RM-MEDA

MOSFOA §4.1 (Table 1) dùng 3 bộ benchmark MOO chuẩn quốc tế:

| Bộ | Số hàm | Số mục tiêu | Đặc điểm | Mục đích kiểm định |
|---|---|---|---|---|
| **IMOP** (Tian et al. 2019) | IMOP1–8 | 2 hoặc 3 | PF có hình dạng đa dạng (lồi/lõm/rời rạc/dạng lưới) | Khả năng **mở rộng** (scalability) khi tăng số mục tiêu |
| **UF** (Zhang et al. 2009 — CEC 2009) | UF1–9 | 2 hoặc 3 | PF phức tạp, biến có khoảng giá trị không đối xứng | Hội tụ và đa dạng dưới hình dạng PF khó |
| **RM-MEDA** (Zhang et al. 2008) | P1–P9 | 2 hoặc 3 | PF không đều, mô phỏng bài toán thực tế | Kiểm định tính thực dụng, PF bất quy tắc |

🔹 Nhận xét từ kết quả thực nghiệm MOSFOA (§4.3a–c):
- **IMOP**: E-MOSFOA thắng IGD ở 5/8 hàm; B-MOSFOA thắng ở 3/8 hàm còn lại (IMOP1, 5, 6) — cho thấy **không hoàn toàn E-MOSFOA luôn thắng B-MOSFOA**, dù E-MOSFOA "nâng cao" hơn về cơ chế.
- **UF**: bài toán khó hơn — cả 2 biến thể MOSFOA đôi khi **thua** cả thuật toán nền (MOMSA, NS-MFO, MOGNDO) ở một số hàm (UF1, UF3) — bài báo thẳng thắn thừa nhận điều này, không "tô hồng" kết quả.
- **RM-MEDA**: B-MOSFOA mạnh về hội tụ (IGD) ở một số bài; E-MOSFOA mạnh về ε và tính đồng đều (Δ).

✍️ *Bài học phương pháp luận quan trọng*: Khi viết báo cáo/bài báo khoa học về so sánh thuật toán, **không nên chỉ báo cáo trường hợp thuật toán của mình thắng** — cách trình bày trung thực (thắng ở đâu, thua ở đâu, vì sao) mới thuyết phục về mặt học thuật. Đây là điều MOSFOA làm khá tốt và đáng học hỏi khi tự viết báo cáo nghiên cứu của bạn.

## 2.7. Bài tập thực hành Phần 2

✍️ **Bài 2.1 (lý thuyết):** Cho 5 nghiệm với (cost, displacement) = (10,0.03), (15,0.02), (12,0.025), (20,0.01), (13,0.028). Tự vẽ tay và xác định nghiệm nào thuộc Pareto Front, nghiệm nào bị trội (và bị trội bởi nghiệm nào).

✍️ **Bài 2.2 (lập trình):** Viết hàm kiểm tra Pareto dominance giữa 2 vector mục tiêu bất kỳ (M chiều tổng quát, không chỉ 2 chiều).

✍️ **Bài 2.3 (lập trình):** Viết hàm tính IGD giữa một tập nghiệm xấp xỉ và một PF tham chiếu cho trước (dùng khoảng cách Euclid).

✍️ **Bài 2.4 (đọc hiểu số liệu):** Mở Table 3 (IMOP) của MOSFOA, tìm hàng có `IGD` tốt nhất cho IMOP2 — xác định đó là thuật toán nào (I–V) và giá trị bao nhiêu. Tính tỉ lệ cải thiện so với thuật toán tệ nhất trong bảng.

---

# PHẦN 3 — TỪ SFOA ĐẾN MOSFOA

## 3.1. Vì sao SFOA gốc không dùng trực tiếp được cho MOO

MOSFOA §2 (cuối) chỉ rõ: SFOA gốc **chỉ tối ưu 1 hàm mục tiêu** → không có khái niệm "nghiệm nào tốt hơn nghiệm nào" khi có ≥ 2 mục tiêu xung đột (vì so sánh trực tiếp 2 số fitness không còn ý nghĩa khi có nhiều chiều mục tiêu). SFOA gốc thiếu:

1. **Cơ chế xác định "ai là nghiệm tốt nhất"** (X_best) khi có nhiều mục tiêu — SFOA gốc dùng đơn giản `X_best = argmin F(x)`, không áp dụng được cho vector mục tiêu.
2. **Cơ chế lưu trữ tập nghiệm không trội** — SFOA gốc chỉ theo dõi 1 nghiệm tốt nhất, không lưu cả một *tập* nghiệm.
3. **Cơ chế duy trì đa dạng** (diversity) trên không gian mục tiêu nhiều chiều — SFOA gốc không có khái niệm "độ thưa/đông" của nghiệm.

→ Đây chính là động lực để MOSFOA "cấy" 3 cơ chế EMO (external archive, density-based leader selection, adaptive grid — xem lại §2.4) **lên trên nền cơ học tìm kiếm gốc của SFOA** (Eq. 4–13, Phần 1), tạo ra **B-MOSFOA**.

## 3.2. B-MOSFOA: phiên bản nền tảng

🔹 Cấu trúc B-MOSFOA (MOSFOA §3.1) = **[cơ học tìm kiếm SFOA]** + **[archive ngoài]** + **[leader selection theo lưới]**.

### 3.2a. Cơ học tìm kiếm — về cơ bản giống hệt SFOA gốc, chỉ đổi X_best → X_leader

So sánh trực tiếp công thức (đối chiếu ký hiệu bài MOSFOA với SFOA gốc):

| SFOA gốc (Phần 1) | B-MOSFOA (MOSFOA Eq. 2–6) | Khác biệt |
|---|---|---|
| Eq.(4): dùng `X_best` | Eq.(2): dùng `X_leader` | X_best (1 nghiệm) → X_leader (1 nghiệm **được chọn từ archive** theo mật độ lưới, không cố định) |
| Eq.(5)–(6): `a1`, `θ` | giống hệt | không đổi |
| Eq.(8): dùng 2 cá thể `k1,k2` ngẫu nhiên | Eq.(3): giống hệt | không đổi |
| Eq.(9): `Et` | giống hệt | không đổi |
| Eq.(11): săn mồi dùng `X_best` | Eq.(4)–(5): dùng `X_leader` | tương tự — mọi chỗ dùng "nghiệm tốt nhất" đều đổi thành "leader chọn từ archive" |
| Eq.(12): tái sinh | Eq.(6): giống hệt | không đổi |

⚠️ **Đây là điểm mấu chốt để hiểu nhanh MOSFOA**: phần lớn công thức toán học **giữ nguyên 100%** so với SFOA gốc — sự khác biệt duy nhất về mặt công thức là **X_best (SOO) được thay bằng X_leader (MOO, chọn từ archive theo cơ chế mới)**. Nếu bạn đã nắm chắc Phần 1, phần "học lại" công thức ở Phần 3 gần như không tốn công.

### 3.2b. External Archive và Adaptive Grid (MOSFOA §3.1b)

- Một **archive ngoài** (kích thước giới hạn `Nr`) lưu trữ các nghiệm không trội tìm được xuyên suốt quá trình tìm kiếm (tương tự PS, nhưng chỉ là một xấp xỉ vì không thể biết PS thật).
- Khi archive đầy (> Nr), **lưới thích nghi** (adaptive grid) chia không gian mục tiêu thành các ô, ưu tiên **giữ lại** nghiệm ở vùng thưa dân, loại bỏ bớt nghiệm ở vùng đông đúc — giữ cho archive vừa có chất lượng tốt (đều là non-dominated) vừa có tính đa dạng.

### 3.2c. Leader Selection bằng Roulette Wheel theo mật độ (MOSFOA §3.1c)

📐 **Eq. (7) [MOSFOA]:**
```
Pi = c / Ni
```
- `Ni`: số nghiệm trong ô lưới thứ i.
- `Pi`: xác suất được chọn làm leader (tỉ lệ nghịch với mật độ — **ô càng thưa, xác suất được chọn làm leader càng cao**).
- Cơ chế "roulette wheel" (bánh xe roulette): mỗi ô lưới có một "miếng bánh" tỉ lệ với `Pi`, quay ngẫu nhiên để chọn ô, rồi chọn ngẫu nhiên 1 nghiệm trong ô đó làm leader.

**Ý nghĩa thực tiễn**: cơ chế này khuyến khích thuật toán "khám phá" các vùng còn thưa của PF (thay vì luôn đi theo 1 nghiệm tốt nhất tuyệt đối như SFOA gốc) → giúp PF thu được **bao phủ đều và rộng hơn**.

## 3.3. E-MOSFOA: phiên bản nâng cao

E-MOSFOA (MOSFOA §3.2) = B-MOSFOA + **3 cơ chế bổ sung**:

### 3.3a. Phase Control thích nghi (Adaptive GP) — Eq. (8)

Thay vì `GP` cố định = 0.5 như SFOA gốc, E-MOSFOA dùng lịch trình (schedule) biến thiên theo cosine:

📐 **Eq. (8) [MOSFOA]:**
```
GP = (GP0/2) · (1 + cos(π · T/Tmax))
```
- Tại `T=0`: `cos(0) = 1` → `GP = GP0` (giá trị ban đầu, thiên về khai thác hoặc khám phá tùy GP0).
- Tại `T=Tmax`: `cos(π) = -1` → `GP = 0` → **ở cuối vòng lặp, GP → 0 nghĩa là gần như luôn rơi vào pha Khai thác** (nhớ lại quy tắc `rand > GP` → Khám phá; `GP` nhỏ → hầu như luôn Khai thác).
- **Ý nghĩa**: giai đoạn đầu ưu tiên khám phá rộng, giai đoạn cuối ưu tiên khai thác tinh chỉnh quanh PF đã tìm được — đây là kỹ thuật **lịch trình thích nghi** (adaptive scheduling) rất phổ biến trong thiết kế metaheuristic hiện đại (không riêng gì SFOA).

### 3.3b. Chiến lược đột biến thích nghi (Adaptive Mutation) dùng DE — Eq. (9)–(11)

Khi D > 5, thay vì chỉ dùng công thức Eq.(4)/(2) gốc, E-MOSFOA còn sinh thêm 1 vector đột biến kiểu **Differential Evolution (DE)**:

📐 **Eq. (9)–(11) [MOSFOA]:**
```
mutant_i = X_r1 + F·(X_r2 − X_r3) + λ·(X_leader − X_r1)

F = 0.5·(1 − T/Tmax)          (hệ số tỉ lệ DE, giảm dần theo T)
λ = 0.5·(1 − T/Tmax)          (hệ số hút về leader, cũng giảm dần)

Y_i = crossover(X_i, mutant_i)
```
- Đây chính là công thức DE/rand/1 **kết hợp thêm số hạng hút về leader** (số hạng `λ·(X_leader − X_r1)`) — một dạng lai giữa DE cổ điển và "định hướng theo nghiệm tốt".
- `F` và `λ` **giảm dần tuyến tính theo T** — giống logic của Phase Control: giai đoạn đầu đột biến mạnh (khám phá), giai đoạn cuối đột biến yếu (khai thác/hội tụ).
- Bước **crossover** (lai ghép) kết hợp `X_i` (vị trí hiện tại) với `mutant_i` (vector đột biến) để tạo nghiệm mới `Y_i` — đây là bước DE chuẩn mà SFOA gốc **không có**.

⚠️ Lưu ý: cơ chế đột biến DE **chỉ áp dụng khi D > 5** (thay thế cho công thức arm-twist Eq.2 ở nhánh D>5); khi D ≤ 5, E-MOSFOA vẫn dùng công thức energy-step Eq.(3) y hệt B-MOSFOA/SFOA gốc.

### 3.3c. Archive Leader Refinement (tinh chỉnh cuối) — Eq. (12)–(13)

📐 **Eq. (12)–(13) [MOSFOA]:**
```
X* = argmin_i ( Σj f(i,j) )              (nghiệm "tốt nhất tổng hợp" trong archive)

Y_i = X* + ε · N(0, σ²)                  (nhiễu Gaussian quanh X*)
```
- Chỉ kích hoạt ở **giai đoạn cuối** (khi `it > 0.8·Max_it`, tức 20% vòng lặp cuối).
- Chọn nghiệm "tốt nhất tổng hợp" trong archive (tổng tất cả giá trị mục tiêu — một cách đơn giản hoá để chọn ra 1 đại diện, không nhất thiết là nghiệm "công bằng" nhất theo nghĩa Pareto, nhưng đóng vai trò một "hạt nhân" tốt để re-seed).
- **Tái khởi tạo một phần quần thể** bằng nhiễu Gaussian quanh nghiệm này — kỹ thuật **perturbation-based refinement** (tinh chỉnh bằng nhiễu động), giúp tăng cường tìm kiếm cục bộ tinh vi ở giai đoạn cuối mà không làm mất tính đa dạng hoàn toàn (vì chỉ áp dụng cho "một phần" quần thể, không phải toàn bộ).

## 3.4. Đọc hiểu pseudo-code Algorithm 1

Pseudo-code MOSFOA (Algorithm 1) mô tả **cả hai** biến thể trong cùng một khung, với các dòng rẽ nhánh `(B-MOSFOA)` / `(E-MOSFOA)`. Sơ đồ hoá lại cho dễ hiểu:

```
Input: hàm mục tiêu {f1,...,fM}; biên [lb,ub]; N; Max_it; GP0; Nr (kích thước archive)
Output: archive A cuối cùng (xấp xỉ Pareto Front)

Khởi tạo quần thể X ngẫu nhiên trong biên
Tính F(X) cho tất cả cá thể
Khởi tạo archive A từ các nghiệm không trội đầu tiên

While it ≤ Max_it:
    GP ← GP0                              [B-MOSFOA, cố định]
    GP ← Eq.(8), lịch trình cosine        [E-MOSFOA]
    Chọn X_leader từ A bằng roulette-wheel theo mật độ lưới (Eq.7)

    For i = 1..N:
        r = rand(0,1)
        If r < GP:                        # PHA KHÁM PHÁ
            If D > 5:
                B-MOSFOA: cập nhật Y_i bằng arm-twist (Eq.2)
                E-MOSFOA: sinh mutant (Eq.9-10), rồi crossover → Y_i (Eq.11)
            Else:
                cập nhật Y_i bằng energy-step (Eq.3)   [giống nhau cho cả 2]
        Else:                              # PHA KHAI THÁC
            If i < N:
                cập nhật Y_i bằng preying (Eq.4-5)
            Else (i = N):
                áp dụng regeneration (Eq.6)
        Xử lý biên cho Y_i

    [chỉ E-MOSFOA] If it > 0.8·Max_it:
        chọn X* từ archive (Eq.12)
        tái khởi tạo một phần quần thể bằng Gaussian quanh X* (Eq.13)

    Đánh giá lại F cho quần thể mới
    Cập nhật archive A bằng Pareto dominance + adaptive grid
    it = it + 1

Return A
```

✍️ *Bài tập đọc hiểu*: Xác định chính xác **5 điểm khác biệt** giữa nhánh `(B-MOSFOA)` và `(E-MOSFOA)` trong pseudo-code trên (gợi ý: GP cố định/thích nghi; cách sinh Y_i khi D>5; có/không bước re-seed cuối kỳ — liệt kê đủ và giải thích lý do từng điểm).

## 3.5. Kết quả thực nghiệm và cách diễn giải bảng số

Từ Bảng 3–5 (MOSFOA), có thể tổng hợp nguyên tắc đọc hiểu chung:

1. **Không có thuật toán thắng tuyệt đối mọi chỉ số, mọi bài toán** — đây là biểu hiện thực tế của định lý No Free Lunch (§0.3) ngay trong phạm vi hẹp giữa 5 thuật toán MOO so sánh (MOMSA, NS-MFO, MOGNDO, B-MOSFOA, E-MOSFOA).
2. **E-MOSFOA thường thắng về IGD** (hội tụ + đa dạng tổng hợp) nhiều hơn B-MOSFOA — hợp lý vì E-MOSFOA có thêm 2 cơ chế tăng cường khai thác tinh vi (Phase Control, DE mutation).
3. **B-MOSFOA đôi khi thắng về MS** (độ bao phủ tối đa) — vì B-MOSFOA không "thu hẹp" mạnh về khai thác cuối kỳ như E-MOSFOA (không có bước re-seed Eq.12-13), nên quần thể B-MOSFOA có xu hướng giữ tính khám phá/đa dạng cao hơn tới cuối.
4. Ở bộ **UF** (khó nhất), cả 2 biến thể **đôi khi thua** cả thuật toán nền — một minh chứng tốt để tự luyện thói quen đọc phản biện kết quả nghiên cứu (không chỉ đọc phần "chúng tôi thắng").

## 3.6. Bài tập thực hành Phần 3

✍️ **Bài 3.1 (lập trình từ Phần 1 lên Phần 3):** Lấy code SFOA đã viết ở Bài 1.2, sửa lại để hỗ trợ 2 hàm mục tiêu đồng thời (ví dụ bài toán ZDT1 chuẩn — PF đã biết trước dạng `f2 = 1 − sqrt(f1)`), thêm cơ chế Pareto dominance đơn giản (chưa cần archive/lưới) để chọn "leader" là 1 nghiệm ngẫu nhiên trong tập không trội hiện tại.

✍️ **Bài 3.2 (nâng cao):** Bổ sung external archive có giới hạn kích thước và cơ chế lưới thích nghi đơn giản (chia không gian mục tiêu thành lưới N×N ô đều theo min-max hiện tại của archive).

✍️ **Bài 3.3 (so sánh):** Chạy phiên bản của bạn (Bài 3.2) trên ZDT1, vẽ PF thu được, tính IGD so với PF lý thuyết, so sánh định tính với hình dạng PF ở Fig. 1 (MOSFOA, IMOP1 — có hình dạng PF tương tự ZDT1).

✍️ **Bài 3.4 (mở rộng lên E-MOSFOA):** Thêm cơ chế Phase Control cosine (Eq.8) và đột biến DE (Eq.9-11) vào code Bài 3.2, so sánh tốc độ hội tụ IGD theo iteration giữa 2 phiên bản B và E của chính bạn.

---

# PHẦN 4 — CASE STUDY KỸ THUẬT: BẾN CẢNG HÀNG LỎNG (LIQUID BULK JETTY)

Đây là phần ứng dụng thực tế của MOSFOA §5, minh chứng cho toàn bộ lý thuyết Phần 1–3 trên một công trình thật (Bến cảng Hải Linh, Thủy Nguyên, Hải Phòng, Việt Nam).

## 4.1. Ba hệ kết cấu: BD, MD, MJP

| Hệ kết cấu | Tên đầy đủ | Chức năng | Số cọc hiện trạng |
|---|---|---|---|
| **BD** | Berthing Dolphin (Trụ va — bến cập tàu) | Hấp thụ và tiêu tán động năng va đập khi tàu cập bến | 19 cọc BTCT ứng suất trước D600B, dài 39m |
| **MD** | Mooring Dolphin (Trụ neo) | Neo giữ tàu, chịu lực kéo/ngang từ dây neo dưới tác động gió/sóng/thủy triều | 9 cọc D600B, dài 40m |
| **MJP** | Main Jetty Platform (Cầu dẫn/bến chính) | Kết nối BD-MD, sàn thao tác vận chuyển dầu, không chịu va đập trực tiếp | 15 cọc D500B, dài 39m, lưới 3×5 |

🔹 Mỗi hệ được mô hình hóa **song song** trong SAP2000 (phần mềm phân tích kết cấu FEM) — Fig. 7 (MOSFOA) minh họa cả 3 mô hình FEM.

## 4.2. Biến thiết kế, hàm mục tiêu, ràng buộc

### Biến thiết kế (Table 7, MOSFOA)

| Hệ | Biến | Ý nghĩa | Loại |
|---|---|---|---|
| BD, MD | X1 = Dp | Đường kính ngoài cọc | Rời rạc (theo TCVN 7888:2014) |
| BD, MD | X2 = tp | Chiều dày thành cọc | Rời rạc |
| BD, MD | X3 = θ | Góc nghiêng so với trục z | Rời rạc {6,7,8} |
| BD, MD | X4 = Lp | Chiều dài cọc | Rời rạc [1:0.1:40] m |
| MJP | X1, X2, X3 | Đường kính, chiều dày, chiều dài cọc | Rời rạc |
| MJP | X4 = L_long, X5 = L_trans | Nhịp dầm dọc/ngang | Rời rạc [3-6] m |
| MJP | X6 = B, X7 = h | Bề rộng, chiều cao dầm | Rời rạc [0.5-2] m |

⚠️ **Điểm quan trọng**: tất cả biến đều **rời rạc** (discrete), không liên tục — vì thực tế thi công chỉ dùng các loại cọc/tiết diện tiêu chuẩn có sẵn (không thể đặt hàng đường kính cọc tùy ý). Đây là khác biệt với hầu hết ví dụ SOO trừu tượng ở Phần 1 (thường biến liên tục).

### Hàm mục tiêu 📐 (Eq. 18-20, MOSFOA)

```
minimize F(X) = { f1(X), f2(X) }
```
- **f1 = Chi phí xây dựng** (construction cost): với BD/MD tính theo thể tích cọc × đơn giá (Eq.19); với MJP cộng thêm thể tích bê tông dầm × đơn giá bê tông + khối lượng thép dầm × đơn giá thép (Eq.20).
- **f2 = Chuyển vị lớn nhất** của kết cấu (maximum displacement), lấy trực tiếp từ kết quả mô hình FEM SAP2000.

### Ràng buộc kỹ thuật (MOSFOA §5.4)

📐 **Eq. (21)-(26):**
- `g1`: khả năng chịu lực dọc trục của cọc không vượt quá sức chịu tải thiết kế (theo TCVN 10304:2014).
- `g2`: mô men uốn không vượt mô men nứt cho phép (theo TCVN 7888:2014).
- `g3`: chỉ số độ sệt đất (Consistency Index) tại mũi cọc `IB ≤ 0.35` (đảm bảo mũi cọc cắm vào lớp đất đủ tốt).
- `g4`: chiều dày lớp đất chịu lực tốt tại mũi cọc `h_tip ≥ 2m`.
- `g5` (chỉ MJP): bề rộng dầm phải lớn hơn đường kính cọc + 0.2m (đảm bảo tương thích hình học dầm-cọc).

## 4.3. Xử lý ràng buộc bằng hàm phạt (penalty method)

📐 **Eq. (27)-(28) [MOSFOA]:**
```
minimize F̂(X) = { f1(X) + P(X), f2(X) + P(X) }

P(X) = Σ αi · max(0, gi(X))
```
- Đây **chính là kỹ thuật đã dùng trong SFOA gốc** (§1.9/§5 SFOA) — "chúng tôi dùng phương pháp hàm phạt do tính đơn giản và hiệu quả" — nay áp dụng lại trong bối cảnh MOO.
- Nếu ràng buộc `gi(X) ≤ 0` bị vi phạm (`gi(X) > 0`), số hạng phạt `αi·gi(X)` được **cộng thêm** vào **cả hai** hàm mục tiêu, khiến nghiệm vi phạm luôn "trông tệ hơn" nghiệm khả thi ở cả 2 mục tiêu đồng thời → thuật toán MOO tự động đẩy nghiệm vi phạm ra khỏi vùng Pareto Front (vì nó gần như chắc chắn bị trội bởi mọi nghiệm khả thi khác).
- `αi` (hệ số phạt) cần đủ **lớn** để việc vi phạm ràng buộc luôn "đắt" hơn lợi ích có thể đạt được từ việc giảm cọc/kích thước — đây là điểm cần tinh chỉnh cẩn thận trong thực hành (hệ số quá nhỏ → nghiệm vi phạm vẫn lọt vào PF cuối; hệ số quá lớn → có thể làm méo bề mặt hàm mục tiêu, gây khó hội tụ).

## 4.4. Kết nối FEM (SAP2000) với vòng lặp tối ưu (MATLAB)

🔹 Kiến trúc tính toán (MOSFOA §5.1, và khớp với các driver MATLAB thực tế của dự án, xem `code/SOO_BD/`, `code/SOO_MD/`, `code/SOO_MPJ/`):

```
┌─────────────┐   set biến thiết kế (Dp, tp, θ, Lp, ...)   ┌─────────────┐
│   MATLAB    │ ────────────────────────────────────────▶ │   SAP2000   │
│ (B/E-MOSFOA)│                                             │  (FEM model)│
│             │ ◀──────────────────────────────────────── │             │
└─────────────┘   trả về: chuyển vị, nội lực, mô men       └─────────────┘
       │
       ▼
Tính f1 (chi phí, công thức đóng — không cần FEM)
Tính f2 = max displacement (lấy trực tiếp từ SAP2000)
Tính g1..g5 (một phần từ FEM, một phần từ công thức địa kỹ thuật)
Tính P(X), cộng vào f1, f2 → F̂(X)
```

⚠️ **Đây là điểm khác biệt lớn nhất so với các bài toán benchmark ở Phần 1–3**: mỗi lần đánh giá hàm mục tiêu (`function evaluation`) ở đây tương đương **1 lần chạy phân tích FEM đầy đủ trong SAP2000** — chi phí tính toán **rất đắt** (giây đến chục giây mỗi lần, thay vì micro-giây như hàm Sphere). Hệ quả thực tiễn:
- Số vòng lặp (`Max_it`) và kích thước quần thể (`N`) phải **nhỏ hơn nhiều** so với benchmark thuần túy (ví dụ Max_it=300, N=100 thay vì Max_it=2000 như benchmark SFOA gốc).
- Cần tính toán **song song hóa** (parallel — nhiều tiến trình SAP2000 chạy đồng thời) để campaign tối ưu hoàn thành trong thời gian hợp lý — đây chính là vấn đề vận hành thực tế đã được ghi trong `SESSION_HANDOFF_2026-08-15.md` của dự án này (không thuộc phạm vi lý thuyết MOSFOA nhưng là bài học triển khai thực tế đáng lưu ý cho ai áp dụng MOO+FEM).

## 4.5. Đọc hiểu kết quả Pareto Front thực tế

Từ Table 9–11 (MOSFOA), có 3 quan sát chung cho cả BD/MD/MJP đáng ghi nhớ:

1. **Thiết kế hiện trạng (current design) luôn bị trội** bởi hầu hết (hoặc toàn bộ) nghiệm trên PF tối ưu — nghĩa là thiết kế hiện tại **chưa tối ưu** theo cả 2 tiêu chí chi phí và chuyển vị đồng thời (dù có thể đã đủ an toàn theo tiêu chuẩn truyền thống).
2. **Chiều dài cọc tối ưu ngắn hơn đáng kể** so với hiện trạng (ví dụ BD: cọc tối ưu ~16.8-16.9m so với 39m hiện trạng) — cho thấy dư thừa an toàn lớn trong thiết kế truyền thống (thường do quy trình thiết kế thủ công dùng biên an toàn lớn, không khảo sát hết không gian thiết kế).
3. Luôn tồn tại **>1 lựa chọn hợp lý** (ví dụ giải pháp A/I ưu tiên chi phí thấp, C/III ưu tiên chuyển vị nhỏ, B/II cân bằng) — đây chính là **giá trị thực tiễn cốt lõi của MOO**: không áp đặt "1 đáp án đúng duy nhất", mà cung cấp bộ giải pháp để kỹ sư/chủ đầu tư tự cân nhắc theo ưu tiên dự án thực tế (ngân sách chặt hay yêu cầu vận hành khắt khe).

## 4.6. Bài tập thực hành Phần 4

✍️ **Bài 4.1 (đọc hiểu số liệu):** Từ Table 9 (BD), tính % giảm chi phí và % giảm chuyển vị của nghiệm "A" so với thiết kế hiện trạng. Lặp lại với nghiệm "III" (E-MOSFOA).

✍️ **Bài 4.2 (tư duy ràng buộc):** Nếu bỏ ràng buộc `g4: h_tip ≥ 2m` (Eq.25), dự đoán điều gì có thể xảy ra với nghiệm tối ưu (gợi ý: liên hệ tới rủi ro chọc thủng/trượt sâu nếu mũi cọc không cắm đủ sâu vào lớp đất tốt).

✍️ **Bài 4.3 (thiết kế thực nghiệm của riêng bạn):** Nếu bạn phải chọn 1 trong 3 giải pháp (A/B/C hoặc I/II/III) của bài toán MJP (Table 11) để đề xuất cho chủ đầu tư có ngân sách hạn chế nhưng yêu cầu chuyển vị không vượt 5×10⁻⁴ m, bạn sẽ chọn giải pháp nào? Giải thích.

✍️ **Bài 4.4 (mở rộng, dành cho người có nền tảng kết cấu):** Tự liệt kê thêm 1 ràng buộc kỹ thuật khác (ví dụ: chuyển vị ngang cho phép theo tiêu chuẩn PIANC, hoặc ràng buộc về độ mảnh cọc) có thể bổ sung vào mô hình MOSFOA cho bài toán BD, và viết công thức toán học tương ứng theo đúng dạng `gi(X) ≤ 0`.

---

# PHẦN 5 — LỘ TRÌNH TỰ HỌC ĐỀ XUẤT & PHỤ LỤC

## 5.1. Lộ trình 6 tuần

| Tuần | Nội dung | Đầu ra kỳ vọng |
|---|---|---|
| **1** | Phần 0 + Phần 1 (§1.1–1.6): đọc kỹ, vẽ lưu đồ, cài đặt SFOA cơ bản (Bài 1.1–1.2) | Code SFOA Python/MATLAB chạy được trên hàm Sphere/Rastrigin |
| **2** | Phần 1 (§1.7–1.10): so sánh lý thuyết, benchmark, ứng dụng kỹ thuật (Bài 1.3–1.5) | Bảng so sánh SFOA-tự-viết với kết quả gốc trên ≥ 3 hàm; giải xong 1 bài toán kỹ thuật (spring design) |
| **3** | Phần 2 (toàn bộ): lý thuyết Pareto, NSGA-II/SPEA2/PAES/MOPSO, 4 chỉ số IGD/ε/Δ/MS (Bài 2.1–2.4) | Hiểu và giải thích được bằng lời (không nhìn tài liệu) khái niệm Pareto dominance + cách đọc 1 bảng kết quả MOO |
| **4** | Phần 3 (§3.1–3.4): B-MOSFOA, E-MOSFOA, đọc pseudo-code (Bài 3.1–3.2) | Code MOO đơn giản (SFOA + Pareto + archive) chạy được trên ZDT1 |
| **5** | Phần 3 (§3.5–3.6) + Phần 4 (§4.1–4.4): đọc case study kỹ thuật, hiểu kiến trúc FEM+MOO (Bài 3.3–3.4, 4.1–4.2) | Nắm được toàn bộ chuỗi: biến thiết kế → FEM → hàm mục tiêu/ràng buộc → hàm phạt → MOO |
| **6** | Phần 4 (§4.5–4.6) + ôn tập tổng hợp toàn giáo trình | Có thể tự trình bày lại (thuyết trình 15-20 phút) toàn bộ chuỗi SFOA → MOSFOA → case study cho người khác nghe |

## 5.2. Bảng thuật ngữ đối chiếu Anh–Việt

| English | Tiếng Việt |
|---|---|
| Metaheuristic algorithm | Thuật toán meta-heuristic (siêu khải nghiệm) |
| Exploration / Exploitation | Khám phá (thăm dò toàn cục) / Khai thác (tinh chỉnh cục bộ) |
| No Free Lunch theorem | Định lý "không có bữa trưa miễn phí" |
| Population-based | Dựa trên quần thể |
| Fitness function | Hàm độ thích nghi (= hàm mục tiêu trong ngữ cảnh metaheuristic) |
| Convergence | Sự hội tụ |
| Premature convergence | Hội tụ sớm (kẹt cực trị địa phương) |
| Local optimum / Global optimum | Cực trị địa phương / Cực trị toàn cục |
| Benchmark function | Hàm kiểm định (chuẩn) |
| Unimodal / Multimodal | Đơn cực trị / Đa cực trị |
| Design variable | Biến thiết kế |
| Constraint | Ràng buộc |
| Penalty function method | Phương pháp hàm phạt |
| Pareto dominance | Quan hệ trội Pareto |
| Pareto Set (PS) | Tập Pareto |
| Pareto Front (PF) | Biên Pareto (mặt Pareto) |
| Non-dominated solution | Nghiệm không bị trội |
| Trade-off | Sự đánh đổi |
| External archive | Kho lưu trữ ngoài |
| Adaptive grid | Lưới thích nghi |
| Leader selection | Chọn cá thể dẫn đường |
| Diversity | Tính đa dạng |
| Crowding distance | Khoảng cách chen chúc (mật độ cục bộ) |
| Convergence accuracy | Độ chính xác hội tụ |
| Scalability | Khả năng mở rộng (theo số chiều/số mục tiêu) |
| Robustness | Tính bền vững/ổn định |
| Finite Element Model (FEM) | Mô hình phần tử hữu hạn |
| Berthing / Mooring load | Tải trọng va tàu / Tải trọng neo tàu |

## 5.3. Sổ tay công thức nhanh (cheat-sheet)

**SFOA (SOO):**
```
θ  = (π/2)·(T/Tmax)
a1 = (2r − 1)·π
Et = ((Tmax−T)/Tmax)·cos(θ)

Khám phá D>5:  Y = X ± a1·(X_best − X)·{cos θ | sin θ}   (5 chiều ngẫu nhiên)
Khám phá D≤5:  Y = Et·X + A1·(X_k1 − X) + A2·(X_k2 − X)   (1 chiều ngẫu nhiên)

Khai thác (i≠N, săn mồi):  Y = X + r1·dm1 + r2·dm2 ,   dm = X_best − X_mp
Khai thác (i=N, tái sinh): Y = exp(−T·N/Tmax) · X

Điều khiển pha: rand > Gp (=0.5) → Khám phá ; ngược lại → Khai thác
```

**MOSFOA (MOO) — khác biệt so với SFOA:**
```
X_best  →  X_leader (chọn từ archive bằng roulette-wheel, Pi = c/Ni)

[E-MOSFOA only]
GP(T) = (GP0/2)·(1 + cos(π·T/Tmax))                   — thay GP cố định
mutant = X_r1 + F·(X_r2−X_r3) + λ·(X_leader−X_r1)      — thay/bổ sung Khám phá D>5
F = λ = 0.5·(1 − T/Tmax)
[cuối kỳ, it>0.8·Max_it]:  re-seed quanh X* = argmin(Σf) bằng nhiễu Gaussian
```

**Xử lý ràng buộc (dùng chung cả SFOA lẫn MOSFOA):**
```
F̂(X) = F(X) + P(X),     P(X) = Σ αi·max(0, gi(X))
```

**4 chỉ số đánh giá MOO:**
```
ε, IGD  → càng THẤP càng tốt (hội tụ)
Δ       → càng THẤP càng tốt (đồng đều)
MS      → càng CAO càng tốt (bao phủ rộng)
```

## 5.4. Tài liệu tham khảo mở rộng

Danh sách rút gọn các tài liệu nền tảng quan trọng nhất được cả 2 bài báo trích dẫn, nên đọc thêm nếu muốn hiểu sâu hơn (đầy đủ trong mục References của từng bài báo gốc):

1. Wolpert, D.H., Macready, W.G. (1997). *No free lunch theorems for optimization.* IEEE TEC. — nền tảng lý thuyết §0.3.
2. Storn, R., Price, K. (1997). *Differential Evolution.* Journal of Global Optimization. — nền tảng cơ chế mutation/crossover dùng trong E-MOSFOA §3.3b.
3. Deb, K., Pratap, A., Agarwal, S., Meyarivan, T. (2002). *NSGA-II.* IEEE TEC. — nền tảng archive/dominance §2.4.
4. Zitzler, E., Laumanns, M., Thiele, L. (2001). *SPEA2.* — nền tảng archive có giới hạn §2.4.
5. Knowles, J.D., Corne, D.W. (2000). *Pareto Archived Evolution Strategy (PAES).* Evolutionary Computation. — nền tảng adaptive grid §2.4/§3.2b.
6. Coello, C.A.C., Pulido, G.T., Lechuga, M.S. (2004). *MOPSO.* IEEE TEC. — nền tảng leader selection theo lưới §2.4/§3.2c.
7. Zhang, Q., Zhou, A., Jin, Y. (2008). *RM-MEDA.* IEEE TEC. — bộ benchmark MOO §2.6.
8. Zhang, Q. et al. (2009). *UF test instances, CEC 2009.* — bộ benchmark MOO §2.6.
9. Tian, Y. et al. (2019). *IMOP benchmark suite.* IEEE Computational Intelligence Magazine. — bộ benchmark MOO §2.6.
10. PIANC (2002). *Guidelines for the Design of Fender Systems.* — tiêu chuẩn tải trọng va/neo tàu, Phần 4.
11. OCDI (2002). *Technical Standards for Port and Harbour Facilities in Japan.* — tiêu chuẩn tải trọng, Phần 4.
12. TCVN 7888:2014 — Cọc bê tông ly tâm ứng suất trước. TCVN 10304:2014 — Móng cọc, tiêu chuẩn thiết kế Việt Nam, Phần 4.

---

*Hết giáo trình. Chúc bạn tự học hiệu quả — nếu cần, có thể quay lại yêu cầu bổ sung ví dụ code hoàn chỉnh (Python/MATLAB) cho từng phần, hoặc bộ câu hỏi trắc nghiệm ôn tập theo từng Phần.*
