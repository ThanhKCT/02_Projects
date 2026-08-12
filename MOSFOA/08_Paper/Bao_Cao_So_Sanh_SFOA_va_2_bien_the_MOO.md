# BÁO CÁO SO SÁNH: SFOA (gốc) và hai biến thể đa mục tiêu MOSFOA

**Ngày lập báo cáo:** 10/08/2026
**Phạm vi:** So sánh 3 tài liệu trong thư mục `08_Paper`:
1. `SFOA.pdf` — thuật toán đơn mục tiêu gốc (SOO)
2. `MOSFOA.V1.pdf` — biến thể đa mục tiêu (MOO) #1, đã công bố trên *Scientific Reports*
3. `MOSFOAV2.pdf` — biến thể đa mục tiêu (MOO) #2 (bản thảo), đề xuất B-MOSFOA & E-MOSFOA, ứng dụng cho công trình cảng biển

---

## 1. Thông tin xuất bản

| Mục | SFOA.pdf | MOSFOA.V1.pdf | MOSFOAV2.pdf |
|---|---|---|---|
| **Tên đầy đủ** | Starfish optimization algorithm (SFOA): a bio-inspired metaheuristic algorithm for global optimization compared with 100 optimizers | Multiobjective starfish optimization algorithm for engineering design and optimal power flow problems | Multi-objective Optimization Design of Marine Structures Based on An Enhanced Starfish Algorithm |
| **Tác giả** | Changting Zhong, Gang Li, Zeng Meng, Haijiang Li, Ali Riza Yildiz, Seyedali Mirjalili | Mohammed Jameel, Hana Merah, Alaa M. Abd El-latif, Tareq M. Al-shami, A. Almutairi, Mohamed Abouhawwash | *Không có trang tác giả trong file* — có vẻ là bản thảo đang soạn, chưa định dạng tạp chí, chưa có DOI |
| **Đơn vị** | Hainan Univ., Dalian Univ. of Technology (TQ), Hefei Univ. of Technology (TQ), Cardiff Univ. (UK), Uludağ Univ. (TNK), Torrens Univ./Obuda Univ. | Sana'a University (Yemen), Univ. of El-Oued (Algeria), Northern Border University & Qassim University (Saudi Arabia), Jadara University (Jordan), KFUPM (Saudi Arabia) | Không rõ — case study dùng tiêu chuẩn Việt Nam (TCVN), địa điểm Hải Phòng, Việt Nam → khả năng cao là bản thảo của nhóm tác giả Việt Nam |
| **Tạp chí / DOI** | *Neural Computing and Applications* (2025) 37:3641–3683, Springer. DOI: 10.1007/s00521-024-10694-1 | *Scientific Reports* (2026) 16:3302, Nature. DOI: 10.1038/s41598-026-35329-4 | Không có |
| **Ngày nhận/nhận đăng** | Nhận: 22/11/2023; Nhận đăng: 07/10/2024; Online: 16/12/2024 | Nhận: 17/08/2025; Nhận đăng: 16/12/2025 | Không có |
| **Loại thuật toán** | Single-objective (SOO) | Multi-objective (MOO) — tên gọi **MOSFOA** | Multi-objective (MOO) — hai biến thể **B-MOSFOA** (Base) và **E-MOSFOA** (Enhanced) |
| **Mã nguồn công khai** | MathWorks File Exchange #173735 | MathWorks File Exchange #183090 | Không đề cập |

> ⚠️ **Lưu ý quan trọng:** Cả `MOSFOA.V1.pdf` và `MOSFOAV2.pdf` đều dùng chữ viết tắt **"MOSFOA"** (Multi-objective Starfish Optimization Algorithm), nhưng là hai công trình độc lập, không liên quan tác giả. Bài V1 đã **công bố chính thức** trên *Scientific Reports* (2026). Xem mục 6 để biết rủi ro và khuyến nghị.

---

## 2. Bài gốc: SFOA (Single-Objective)

### 2.1 Ý tưởng & cảm hứng sinh học
Mô phỏng 3 hành vi của sao biển (starfish/sea star — lớp Asteroidea, ~2000 loài, 5 cánh tay):
- **Exploration (khám phá):** hành vi tìm kiếm bằng 5 cánh tay có "mắt" ở đầu.
- **Preying (săn mồi):** hành vi bao và tiêu hóa con mồi.
- **Regeneration (tái sinh):** khả năng tái tạo cánh tay/bộ phận đã mất.

### 2.2 Cấu trúc thuật toán
- **Khởi tạo:** `X_ij = l_j + r(u_j - l_j)`, quần thể N cá thể, D chiều.
- **Tham số điều khiển:** `Gp = 0.5` — xác suất chuyển đổi giữa exploration/exploitation (50/50).

**Pha Exploration** — chiến lược lai (hybrid search pattern), phân theo số chiều D:
- **D > 5** (five-dimensional search pattern): cập nhật đồng thời 5 chiều ngẫu nhiên, dùng sin/cos xoay theo hướng best:
  ```
  Y_i,p = X_i,p + a1(X_best,p − X_i,p)·cos(θ)   nếu r ≤ 0.5
  Y_i,p = X_i,p − a1(X_best,p − X_i,p)·sin(θ)   nếu r > 0.5
  a1 = (2r−1)π ;  θ = (π/2)·(T/T_max)
  ```
- **D ≤ 5** (unidimensional search pattern): chỉ cập nhật 1 chiều, dùng thông tin từ 2 cá thể ngẫu nhiên khác:
  ```
  Y_i,q = Et·X_i,p + A1(X_k1,p − X_i,p) + A2(X_k2,p − X_i,p)
  Et = (T_max − T)/T_max · cos(θ)
  ```

**Pha Exploitation** — 2 chiến lược:
- **Preying (săn mồi):** tìm 5 khoảng cách `d_m = X_best − X_mp` (m=1..5), chọn ngẫu nhiên 2 khoảng cách để cập nhật theo chiến lược "parallel two-directional search":
  ```
  Y_i = X_i + r1·d_m1 + r2·d_m2
  ```
- **Regeneration (tái sinh):** chỉ áp dụng cho cá thể cuối (i = N):
  ```
  Y_N = exp(−T×N/T_max)·X_N
  ```

- **Xử lý biên:** nếu vượt biên → giữ nguyên vị trí cũ (exploration) hoặc kẹp về lb/ub (exploitation).

### 2.3 Độ phức tạp tính toán
- `O(N×D)` cho khởi tạo; tổng thể `O(N·T_max·D·(1/2 + 5/2D))` khi D>5, thấp hơn PSO `O(T_max·N·D)`.

### 2.4 Thực nghiệm
- **65 hàm benchmark:** 24 hàm cổ điển (F1–F24), 29 hàm CEC2017, 12 hàm CEC2022.
- **So sánh với 100 thuật toán** (4 thuật toán trước 2000, 13 (2000-2009), 29 (2010-2019), 54 (từ 2020) — bao gồm PSO, DE, GWO, TLBO, HHO, EO, MPA, LSHADE-cnEpSin, BWO, YDSE, WFO...).
- **Kết quả tổng thể:** SFOA thắng **95/100** thuật toán về độ chính xác (2 hòa, 3 thua — chỉ thua LSHADE, MPA, WFO), thắng **97/100** về hiệu năng/CPU time (chỉ thua AFT, HS, WFO). Chỉ **WFO** thắng cả 2 mặt.
- **Rank-1 percentage:** 85.3% (cổ điển), 86.5% (CEC2017), 87.3% (CEC2022).
- **10 bài toán kỹ thuật thực tế:** cantilever beam, welded beam, tension/compression spring, pressure vessel, three-bar truss, speed reducer, Himmelblau, multi-disk clutch brake, car side impact, step-cone pulley. SFOA đạt nghiệm tốt nhất/gần tốt nhất trong hầu hết trường hợp, ổn định qua 30 lần chạy độc lập.

---

## 3. MOSFOA.V1 — "Multiobjective SFOA" (Jameel et al., *Scientific Reports* 2026)

### 3.1 Cơ chế đa mục tiêu: NSGA-II style
Mở rộng SFOA gốc bằng 2 cơ chế elitist kinh điển của **NSGA-II**:
- **Non-Dominated Sorting (NDS):** xếp hạng nghiệm theo các "front" trội (Pareto dominance ranking).
- **Crowding Distance (CD):**
  ```
  CD_i^j = (f_j^(i+1) − f_j^(i−1)) / (f_j^max − f_j^min)
  ```
  ưu tiên nghiệm ở vùng thưa để duy trì đa dạng.

**Không dùng external archive** — quần thể cha (P₀, N cá thể) + con (Pⱼ) trộn thành Rᵢ, sắp NDS+CD, chọn lại N cá thể tốt nhất → thế hệ tiếp theo (đúng khung NSGA-II cổ điển, chỉ thay operator sinh nghiệm mới bằng công thức exploration/exploitation của SFOA).

### 3.2 Độ phức tạp
`O(M·N)²` với M = số mục tiêu; công thức chi tiết theo từng vòng lặp có thêm chi phí NDS+CD: `O(Gmax·D·N + Gmax·Cost(fobj)·N + Gmax·(NDS+CD)·D + Gmax·(NDS+CD)·Cost(fobj))`.

### 3.3 Bài toán ứng dụng — MOOPF (Multi-objective Optimal Power Flow)
Bài báo phát triển thêm ứng dụng cho **hệ thống điện IEEE 30-bus**, với các hàm mục tiêu:
- **Fuel Cost (FC):** hàm chi phí phát điện dạng bậc hai theo công suất tác dụng.
- **Emission (EM):** phát thải SOₓ/NOₓ/COₓ, hàm mũ + bậc hai.
- **Active Power Loss (PL):** tổn thất công suất trên đường dây truyền tải.
- **Voltage Deviation (VD):** độ lệch điện áp tại nút tải so với điện áp tham chiếu.
- **8 case studies** kết hợp đơn/song/tam mục tiêu (single-, bi-, tri-objective).

### 3.4 Benchmark & baseline
- **Unconstrained:** ZDT1–4, ZDT6, DTLZ1, DTLZ2, DTLZ4, DTLZ5, DTLZ7.
- **Constrained/kỹ thuật:** BNH, SRN, OSY, TNK, Car (side impact), Disk Brake, 4-Bar Truss, CONSTR, **Welded Beam**.
- **Bài toán thực tế bổ sung:** Speed Reducer Design (đa mục tiêu).
- **So sánh benchmark toán học:** MOPSO, MOGWO, MOMVO, MOEA/D, MOEDO.
- **So sánh OPF:** MOALO, MOAVOA, MOMSA (và các thuật toán khác trong bảng kết quả case #1-4: PSO, YDSE, GWO, ALO, RIME, SFOA).
- **Chỉ số đánh giá:** IGD, HV (Hypervolume), **KKTPM** (KKT Proximity Metric — đặc trưng riêng của bài này, ít gặp trong các bài MOO khác), kiểm định thống kê Wilcoxon rank-sum & Friedman test.

### 3.5 Kết quả chính
- MOSFOA vượt trội về IGD và HV so với đối chứng trên phần lớn ZDT/DTLZ.
- Thắng thế rõ trong các bài toán kỹ thuật phức tạp: SRN, OSY, TNK, 4-Bar Truss, Welded Beam (theo box-plot HV).
- Áp dụng thành công cho OPF IEEE 30-bus (41 đường dây, 6 máy phát) ở cả chế độ đơn/song/tam mục tiêu; dùng lý thuyết tập mờ (fuzzy set theory) để chọn nghiệm "best-compromise".
- Kiểm định thống kê xác nhận tính vượt trội có ý nghĩa (p-value Wilcoxon).

---

## 4. MOSFOAV2 — B-MOSFOA & E-MOSFOA (bản thảo, ứng dụng công trình cảng biển)

### 4.1 Cơ chế đa mục tiêu: MOPSO/PAES style (archive + grid)
Khác hẳn V1, bài này mở rộng SFOA theo hướng **quần thể-đàn (swarm) với external archive**, giống MOPSO/PAES/SPEA2:

**B-MOSFOA (Base):**
- **External archive:** lưu các nghiệm không bị trội (non-dominated), tương tự NSGA-II/SPEA2.
- **Grid-based diversity control:** khi kích thước archive vượt `Nr`, chia không gian mục tiêu thành lưới thích nghi (adaptive grid), ưu tiên nghiệm ở ô lưới thưa.
- **Leader selection qua Roulette Wheel** theo mật độ ô lưới:
  ```
  P_i = c / N_i   (N_i = số nghiệm trong ô lưới i)
  ```
- **Exploration** (giữ nguyên ý tưởng SFOA, nhưng dùng leader từ archive thay cho "best" toàn cục):
  - D>5: "arm-twist" — công thức sin/cos như SFOA gốc nhưng thay `X_best` → `X_leader`.
  - D≤5: "energy-step" — như SFOA gốc.
- **Exploitation:** "Preying" (dùng khoảng cách tới leader) + "Regeneration" (cá thể cuối) — giữ nguyên công thức gốc, chỉ đổi `X_best`→`X_leader`.

**E-MOSFOA (Enhanced)** — bổ sung 3 cơ chế thích nghi:
1. **Phase Control thích nghi (cosine schedule):**
   ```
   GP = (GP₀/2)·(1 + cos(π·it/Max_it))
   ```
   thay cho `Gp` cố định = 0.5, giúp giảm dần xác suất khám phá theo thời gian.
2. **Adaptive Mutation kiểu Differential Evolution (DE)** khi D>5 (thay thế "arm-twist"):
   ```
   mutant_i = X_r1 + F·(X_r2 − X_r3) + λ·(X_leader − X_r1)
   F = 0.5·(1 − it/Max_it) ;  λ = 0.5·(1 − it/Max_it)
   Y_i = crossover(X_i, mutant_i)
   ```
3. **Archive Leader Refinement (Gaussian perturbation)** ở 20% vòng lặp cuối (`it > 0.8·Max_it`):
   ```
   X* = argmin(Σ f_i,j)   [nghiệm non-dominated tốt nhất trong archive]
   Y_i = X* + ε·N(0, σ²)
   ```

### 4.2 Benchmark & baseline
- **IMOP1-8** (2-3 mục tiêu, đánh giá khả năng mở rộng theo số mục tiêu).
- **UF1-9** (bộ CEC2009, hình dạng Pareto front đa dạng/khó).
- **RM-MEDA-P1,2,3,4,5,6,7,8,9** (bài toán bất thường/mô phỏng thực tế).
- **So sánh:** MOMSA, NS-MFO, MOGNDO.
- **Chỉ số đánh giá:** IGD, ε (epsilon indicator — độ hội tụ), Δ (spacing — tính đồng đều phân bố), MS (Maximum Spread — độ bao phủ đa dạng). Thống kê Best/Worst/Mean/SD qua 30 lần chạy độc lập.

### 4.3 Kết quả benchmark
- **IMOP:** E-MOSFOA đạt IGD tốt nhất ở 5/8 bài (IMOP2,3,4,7,8); B-MOSFOA tốt nhất ở IMOP1,5,6 (đặc biệt IGD=0.00 ở IMOP1). Rank1%: 85.3%(cổ điển)... (đây là số liệu từ SFOA gốc, không nhầm — trong V2 không có rank1%, chỉ có bảng IGD/ε/Δ/MS riêng).
- **UF:** E-MOSFOA hội tụ tốt nhất ở UF2,4,6,7,8; B-MOSFOA mạnh về chỉ số ε (dominance) ở một số bài (UF4). Baseline vẫn thắng ở UF1, UF3 (thừa nhận độ khó cao của bộ UF).
- **RM-MEDA:** B-MOSFOA tốt nhất về IGD ở một số bài (RM-MEDA2: 8.5×10⁻⁵); E-MOSFOA tốt hơn về ε và Δ (ví dụ RM-MEDA5).
- **Nhận định chung của tác giả:** E-MOSFOA hội tụ ổn định hơn, phân bố Pareto front đều hơn (Δ thấp hơn); B-MOSFOA có độ phủ (MS) rộng hơn ở một số bài toán.

### 4.4 Ứng dụng thực tế: Bến cảng lỏng (Liquid Bulk Jetty) — Hải Linh, Hải Phòng, Việt Nam
Ứng dụng hoàn toàn khác V1 — thuộc lĩnh vực **kết cấu công trình biển**:
- **3 hệ kết cấu con:**
  - **BD (Berthing Dolphin)** — trụ va, 19 cọc BTCT ứng suất trước D600B, dài 39m (hiện trạng).
  - **MD (Mooring Dolphin)** — trụ neo, 9 cọc D600B, dài 40m.
  - **MJP (Main Jetty Platform)** — cầu dẫn chính, 15 cọc D500B (lưới 3×5), dài 39m.
- **Mô hình FEM:** SAP2000, kết hợp khung tối ưu hóa MATLAB (coupled SAP2000–MATLAB framework).
- **Biến thiết kế:** đường kính cọc, độ dày vách cọc, góc nghiêng, chiều dài cọc (BD/MD); + khoảng nhịp dầm, kích thước dầm (MJP) — biến rời rạc (discrete).
- **2 hàm mục tiêu:** `f1` = chi phí xây dựng (giá cọc + bê tông + cốt thép dầm), `f2` = chuyển vị lớn nhất của kết cấu (từ FEM).
- **Ràng buộc:** khả năng chịu lực dọc trục cọc, mô men nứt, chỉ số sệt đất (Ib ≤ 0.35), độ dày lớp đất chịu lực tại mũi cọc (≥2m), tương thích hình học dầm-cọc (MJP) — theo tiêu chuẩn **TCVN 7888:2014**, **TCVN 10304:2014**, **PIANC (2002)**, **OCDI (2002)**. Xử lý ràng buộc bằng hàm phạt (penalty method).
- **Kết quả:** cả B-MOSFOA và E-MOSFOA cho nghiệm tối ưu tốt hơn thiết kế hiện trạng rõ rệt (giảm cả chi phí và chuyển vị). Ví dụ BD: thiết kế hiện tại dùng cọc 39m, nghiệm tối ưu chỉ cần cọc nghiêng ~16.8–16.9m (tiết kiệm chi phí đáng kể). E-MOSFOA cho Pareto front phân bố ổn định/đều hơn B-MOSFOA.

---

## 5. Bảng so sánh tổng hợp MOSFOA V1 vs V2

| Tiêu chí | MOSFOA.V1 (Jameel et al.) | MOSFOAV2 (B/E-MOSFOA) |
|---|---|---|
| Cơ chế MOO chính | Non-Dominated Sorting + Crowding Distance (kiểu NSGA-II) | External archive + Adaptive grid + Roulette-wheel leader selection (kiểu MOPSO/PAES) |
| Số biến thể đề xuất | 1 (MOSFOA) | 2 (B-MOSFOA cơ bản + E-MOSFOA nâng cao) |
| Cơ chế nâng cao thêm | Không | Cosine phase-control, DE mutation, Gaussian archive refinement (chỉ E-MOSFOA) |
| Vai trò "leader"/"best" | Không có leader — dùng best trong quần thể hiện tại theo front | Leader chọn từ external archive theo mật độ lưới |
| Benchmark chuẩn | ZDT1-4/6, DTLZ1/2/4/5/7 | IMOP1-8, UF1-9, RM-MEDA1-9 |
| Benchmark kỹ thuật/ràng buộc | BNH, SRN, OSY, TNK, Car, Disk Brake, 4-Bar Truss, CONSTR, Welded Beam | Không dùng (thay bằng case study thực tế) |
| Thuật toán đối chứng | MOPSO, MOGWO, MOMVO, MOEA/D, MOEDO, MOALO, MOAVOA, MOMSA | MOMSA, NS-MFO, MOGNDO |
| Chỉ số đánh giá | IGD, HV, **KKTPM**, Wilcoxon, Friedman | IGD, **ε**, **Δ**, **MS** |
| Ứng dụng thực tế | OPF IEEE 30-bus (điện lực) + Speed Reducer (cơ khí) | Bến cảng lỏng (BD/MD/MJP) — công trình biển, dùng FEM SAP2000 |
| Công cụ mô phỏng | MATLAB (không có mô hình FEM ngoài) | SAP2000 + MATLAB (coupled) |
| Tiêu chuẩn kỹ thuật áp dụng | Không có tiêu chuẩn ngành cụ thể (chỉ công thức OPF chuẩn IEEE) | TCVN 7888:2014, TCVN 10304:2014, PIANC 2002, OCDI 2002, CSA A23.3-14 |
| Điểm chung duy nhất | Cả hai đều dựa trên **SFOA gốc** (Zhong et al., 2024) và trích dẫn **MOMSA** làm baseline | — |

**→ Kết luận: không có sự trùng lặp về nội dung khoa học, phương pháp, hay dữ liệu thực nghiệm.** Đây là hai hướng phát triển kỹ thuật khác nhau (evolutionary-ranking vs archive/grid-swarm) trên cùng một thuật toán nền, phục vụ hai lĩnh vực ứng dụng hoàn toàn khác (hệ thống điện vs công trình biển).

---

## 6. Rủi ro cần lưu ý & khuyến nghị

### 6.1 Trùng tên gọi thuật toán ("MOSFOA")
- `MOSFOA.V1.pdf` đã **công bố chính thức** trên *Scientific Reports* (Nature) — nhận bài 17/08/2025, DOI 10.1038/s41598-026-35329-4.
- Nếu `MOSFOAV2.pdf` là bản thảo dự định nộp, việc dùng cùng tên **"MOSFOA"** cho thuật toán nền (trước khi rẽ thành B-/E-MOSFOA) có thể gây:
  - Nhầm lẫn với công trình đã công bố khi phản biện (reviewer) tra cứu.
  - Nghi vấn về tính mới nếu không trích dẫn/phân biệt rõ trong phần Related Work.
  - Vấn đề khi tra cứu chỉ số trích dẫn/liên kết công trình sau này (hai thuật toán khác nhau bị gán trùng tên viết tắt trên Google Scholar/Scopus).

### 6.2 Khuyến nghị hành động
1. **Bổ sung trích dẫn Jameel et al. (2026)** vào phần Introduction/Related Work của MOSFOAV2, nêu rõ: "một biến thể MOSFOA khác đã được đề xuất độc lập bởi Jameel et al. dựa trên NSGA-II; nghiên cứu này đề xuất một hướng tiếp cận khác dựa trên archive/grid, kèm ứng dụng cho kết cấu công trình biển."
2. Xem xét **đổi tên thuật toán nền** hoặc thêm định danh riêng biệt hơn (ví dụ giữ nguyên B-MOSFOA/E-MOSFOA làm tên chính thức, tránh gọi tắt chung "MOSFOA" một mình) để giảm khả năng trùng từ khóa khi tra cứu.
3. Nhấn mạnh trong phần đóng góp (contributions) rằng điểm khác biệt cốt lõi là: **cơ chế archive+grid+leader (không NDS+CD)**, **2 biến thể với cơ chế thích nghi (DE mutation, cosine phase-control)**, và **ứng dụng thực tế đầu tiên cho kết cấu bến cảng có ràng buộc kỹ thuật/tiêu chuẩn Việt Nam** — đây là những điểm mới rõ ràng, không trùng với V1.
4. Kiểm tra thêm liệu có công trình MOO khác cùng gốc SFOA nào khác đã xuất bản (nên rà soát Scopus/Web of Science với từ khóa "starfish optimization" + "multi-objective") để đảm bảo không có bài thứ 3 gây trùng tên tiếp.

---

## 7. Phụ lục — Trích dẫn nguồn chính

- Zhong, C., Li, G., Meng, Z., Li, H., Yildiz, A.R., Mirjalili, S. (2024). *Starfish optimization algorithm (SFOA): a bio-inspired metaheuristic algorithm for global optimization compared with 100 optimizers.* Neural Computing and Applications, 37, 3641–3683. https://doi.org/10.1007/s00521-024-10694-1
- Jameel, M., Merah, H., Abd El-latif, A.M., Al-shami, T.M., Almutairi, A., Abouhawwash, M. (2026). *Multiobjective starfish optimization algorithm for engineering design and optimal power flow problems.* Scientific Reports, 16, 3302. https://doi.org/10.1038/s41598-026-35329-4
- [Bản thảo chưa công bố]. *Multi-objective Optimization Design of Marine Structures Based on An Enhanced Starfish Algorithm.* (MOSFOAV2.pdf)
