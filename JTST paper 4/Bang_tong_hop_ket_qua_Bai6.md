# Bảng tổng hợp kết quả — Bài 6 (JTST paper 4)

> Tổng hợp từ campaign chính thức 20/20 lần chạy độc lập (Npop=20, Max_it=100, Num_work=8) và phân tích hậu kỳ 3 nghiệm Pareto đại diện (tách riêng đủ 410 tổ hợp tải trọng). Dữ liệu nguồn: `code/results/campaign_pareto_tongthe_20runs.csv`, `code/results/governing_combos_analysis.mat`, `code/results/campaign_stability_analysis.mat`.

---

## 1. Tổng quan campaign

| Chỉ tiêu | Giá trị |
|---|---:|
| Số lần chạy độc lập hợp lệ | 20/20 |
| Npop / Max_it / Num_work | 20 / 100 / 8 |
| Thời gian trung bình/lần chạy | ~5,85 giờ |
| Tổng số lần đánh giá (toàn campaign) | 20 × 2.020 = 40.400 |
| Số nghiệm Pareto trung bình/run | 77,8 (72–84) |
| Số nghiệm Pareto tổng thể (hợp nhất 20 run, loại trội) | **90** |
| min f1 (khối lượng) — tất cả 20 run | **2.311,93 Tấn** (giống hệt, std=0,0000) |
| min f2 (η_max, theo combo bao) — tất cả 20 run | 0,1550–0,1552 (std≈0,00005) |
| Sự cố trong campaign | 1 lần treo (run17, tự phục hồi) + 1 lần archive sụp do SAP2000 COM glitch (run20, đã vá code, chạy lại sạch) |

---

## 2. Bảng nghiệm Pareto đại diện (theo mục 13.5 đề cương)

| Nghiệm | Ý nghĩa | h_DN (m) | h_DD (m) | h_DCT (m) | t_BMC (m) | Khối lượng f1 (Tấn) | η_max thật* |
|---|---|---:|---:|---:|---:|---:|---:|
| **A** | Khối lượng nhỏ nhất | 1,10 | 1,10 | 1,40 | 0,25 | 2.311,93 | 0,3538 |
| **B** | Nghiệm cân bằng (knee point) | 1,15 | 1,45 | 1,40 | 0,35 | 2.820,25 | 0,2082 |
| **C** | Đáp ứng (η) nhỏ nhất | 2,00 | 2,00 | 1,40 | 0,45 | 3.820,83 | 0,1550 |

\* η_max thật = giá trị lớn nhất trong {η_DN, η_DD, η_DCT, η_BMC} khi tách riêng đủ 410 tổ hợp (không dùng combo bao). Xem ghi chú phương pháp luận ở mục 4.

### 2.1. Chi tiết từng nghiệm — mô-men/lực/chuyển vị và tổ hợp chi phối tương ứng

| Đại lượng | Nghiệm A | Nghiệm B | Nghiệm C |
|---|---|---|---|
| M_DN (kN·m) — combo | 1.675,57 — ULSB-044 | 1.569,32 — ULSB-044 | 2.514,25 — ULSB-043 |
| η_DN | 0,2183 | 0,1860 | 0,0937 |
| M_DD (kN·m) — combo | 1.342,81 — ULSB-252 | 1.597,86 — ULSB-024 | 2.498,18 — ULSB-024 |
| η_DD | 0,1749 | 0,1162 | 0,0931 |
| M_DCT (kN·m) — combo | 1.674,14 — **ULSB-024** | 1.545,87 — **ULSB-024** | 1.332,24 — **ULSB-024** |
| η_DCT | 0,1008 | 0,0931 | 0,0802 |
| M_BMC (kN·m/m) — combo | 86,77 — ULSB-038 | 121,17 — ULSB-029 | 164,59 — ULSB-029 |
| η_BMC (**chi phối η_max**) | **0,3538** | **0,2082** | **0,1550** |
| N_pile (Tấn) — combo | 210,00 — **ULSB-051** | 218,01 — **ULSB-051** | 227,62 — **ULSB-051** |
| U_max (m) — combo | 0,0491 — **ULSB-051** | 0,0490 — **ULSB-051** | 0,0487 — **ULSB-051** |

---

## 3. Bảng tổ hợp tải trọng chi phối (theo mục 13.7 đề cương)

| Đại lượng | Tổ hợp chi phối | Ghi chú |
|---|---|---|
| M_DN | ULSB-044 (A, B) / ULSB-043 (C) | Không hoàn toàn cố định, đổi nhẹ theo thiết kế |
| M_DD | ULSB-024 (B, C) / ULSB-252 (A) | |
| **M_DCT** | **ULSB-024 (cả A, B, C)** | **Cố định tuyệt đối** — không đổi theo kích thước kết cấu bên trên |
| M_BMC | ULSB-038 (A) / ULSB-029 (B, C) | |
| **N_pile** | **ULSB-051 (cả A, B, C)** | **Cố định tuyệt đối** |
| **U_max** | **ULSB-051 (cả A, B, C)** | **Cố định tuyệt đối — cùng combo với N_pile** |

**2 phát hiện chính (mang tính "bản sắc" của Bài 6):**
1. **Bản mặt cầu (BMC) luôn là cấu kiện chi phối η_max** ở cả 3 nghiệm đại diện trên toàn dải Pareto — không phải dầm ngang/dọc/cần trục như trực giác thường giả định.
2. **Tổ hợp ULSB-051 chi phối đồng thời cả lực dọc cọc (N_pile) và chuyển vị ngang (U_max)**, và **ULSB-024 luôn chi phối mô-men dầm cần trục (M_DCT)** — nhất quán tuyệt đối ở cả 3 nghiệm, không phụ thuộc vào việc kích thước kết cấu bên trên thay đổi thế nào. Đây là bằng chứng trực tiếp trả lời câu hỏi nghiên cứu #3 của đề cương ("các tổ hợp tải trọng nào có xu hướng chi phối tính khả thi của nghiệm tối ưu").

---

## 4. ⚠️ Ghi chú phương pháp luận — chênh lệch η_max "combo bao" và "combo tách riêng"

Trong vòng lặp tối ưu (campaign chính thức), $f_2=\eta_{max}$ được tính từ tổ hợp bao `BAO-ULSB` (đã bao 388 tổ hợp ULS trong chính SAP2000) để tiết kiệm thời gian. Khi tách riêng đủ 410 tổ hợp cho 3 nghiệm đại diện, phát hiện:

- Nghiệm B, C: $\eta_{max}$ từ combo bao **khớp chính xác** với giá trị lớn nhất tìm được khi tách riêng từng combo (0,2082 và 0,1550).
- Nghiệm A: $\eta_{max}$ từ combo bao = 0,4053, nhưng giá trị lớn nhất thật khi tách riêng chỉ là **0,3538** (chênh ~13%).

**Nguyên nhân**: tổ hợp bao (envelope) trong SAP2000 lấy giá trị lớn nhất của M2 và M3 **độc lập với nhau** (có thể đến từ 2 tổ hợp cơ bản khác nhau), sau đó mới ghép $\sqrt{M_2^2+M_3^2}$ — tạo ra một giá trị **thiên về an toàn nhưng không thực sự xảy ra đồng thời trong bất kỳ 1 tổ hợp cụ thể nào**. Đây là đặc tính vốn có của combo bao, không phải lỗi tính toán.

**Khuyến nghị khi viết bài báo**: nêu rõ $f_2$ dùng trong quá trình tìm kiếm tối ưu (MOSFOA) là **cận trên thiên an toàn** dựa trên combo bao (hợp lý cho mục đích tối ưu — không bỏ sót nghiệm nguy hiểm); còn giá trị $\eta_{max}$ báo cáo cho **3 nghiệm đại diện cuối cùng** trong bài nên dùng giá trị **đã xác nhận qua tách combo riêng lẻ** (Bảng mục 2.1) — chính xác và có thể truy vết đến đúng 1 tổ hợp tải trọng cụ thể.

---

## 5. Nguồn dữ liệu và khả năng tái lập

- Mặt Pareto tổng thể (90 điểm, giá trị X1-X4 thật): `code/results/campaign_pareto_tongthe_20runs.csv`
- Biểu đồ 20 mặt Pareto chồng lớp + mặt tổng thể: `code/results/campaign_20runs_pareto_overlay.png`
- Chi tiết từng nghiệm đại diện + tổ hợp chi phối: `code/results/governing_combos_analysis.mat`
- Mỗi file `*_FINAL.mat` (20 file, `Bai6_MOSFOA_Np20_Maxit100_run01..20_FINAL.mat`) lưu đầy đủ seed (`rngSeedUsed`), thời gian bắt đầu/kết thúc, số lần đánh giá khả thi/không khả thi — có thể tái lập/kiểm tra lại bất kỳ lúc nào.
