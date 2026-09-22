# FINAL VALIDATION — Bài 6 (JTST paper 4)

> Rà soát cuối cùng trước khi khóa bộ kết quả để viết manuscript. Toàn bộ số liệu trong file này được **đọc lại trực tiếp từ file nguồn** (`code/results/*.mat`, `campaign_pareto_tongthe_20runs.csv`, `governing_combos_analysis.mat`) qua 2 script `final_validation_bai6.m` và `final_validation_task456.m` — **không tái sử dụng số liệu đã tóm tắt ở báo cáo trước**, và **không chạy lại campaign optimization**.

---

## 1. Campaign validation

| Kiểm tra | Kết quả |
|---|---|
| Số run hợp lệ đọc được | **20/20** |
| Tất cả run có Npop=20? | Đúng |
| Tất cả run có Max_it=100? | Đúng |
| Tổng số lần đánh giá (Σ TotalFE của 20 run) | **40.400** (= 20×2.020, khớp kỳ vọng) |
| Số seed khác nhau trong 20 run | **20/20** (không trùng) |
| Số run có f1_min = 2.311,93 (sai số <0,01) | **20/20** |

### Bảng chi tiết 20 run (đọc trực tiếp từ 20 file `*_FINAL.mat`)

| Run | Seed | TotalFE | Feasible | Infeasible | ArchiveSize | BestF1 | BestF2 |
|---|---:|---:|---:|---:|---:|---:|---:|
| 1 | 480367125 | 2020 | 2020 | 0 | 82 | 2311,93 | 0,1550 |
| 2 | 482516343 | 2020 | 2020 | 0 | 78 | 2311,93 | 0,1550 |
| 3 | 484654065 | 2020 | 2020 | 0 | 75 | 2311,93 | 0,1550 |
| 4 | 486803840 | 2020 | 2020 | 0 | 83 | 2311,93 | 0,1550 |
| 5 | 488938522 | 2020 | 2020 | 0 | 75 | 2311,93 | 0,1550 |
| 6 | 491052015 | 2020 | 2020 | 0 | 72 | 2311,93 | 0,1550 |
| 7 | 493192904 | 2020 | 2020 | 0 | 80 | 2311,93 | 0,1550 |
| 8 | 495309583 | 2020 | 2020 | 0 | 78 | 2311,93 | 0,1550 |
| 9 | 497438078 | 2020 | 2020 | 0 | 74 | 2311,93 | 0,1550 |
| 10 | 499572458 | 2020 | 2020 | 0 | 80 | 2311,93 | 0,1550 |
| 11 | 501725463 | 2020 | 2020 | 0 | 83 | 2311,93 | 0,1550 |
| 12 | 503869175 | 2020 | 2020 | 0 | 76 | 2311,93 | 0,1550 |
| 13 | 506009537 | 2020 | 2020 | 0 | 74 | 2311,93 | 0,1550 |
| 14 | 508159148 | 2020 | 2020 | 0 | 79 | 2311,93 | 0,1550 |
| 15 | 510261322 | 2020 | 2020 | 0 | 77 | 2311,93 | 0,1550 |
| 16 | 512302977 | 2020 | 2020 | 0 | 75 | 2311,93 | 0,1550 |
| 17 | 514504181 | 2020 | 2020 | 0 | 77 | 2311,93 | **0,1552** |
| 18 | 516629849 | 2020 | 2020 | 0 | 75 | 2311,93 | 0,1550 |
| 19 | 518755487 | 2020 | 2020 | 0 | 79 | 2311,93 | 0,1550 |
| 20 | 523248598 | 2020 | **2016** | **4** | 84 | 2311,93 | 0,1550 |

Ghi chú: run20 có đúng 4 lần đánh giá bị đánh dấu infeasible do cơ chế bảo vệ glitch-COM (đã vá code, xem `Kinh nghiem MOSFOA Bai 6.md` mục 2) — đây là hành vi ĐÚNG như thiết kế, không phải lỗi.

### FINAL_CAMPAIGN_STATISTICS

| Đại lượng | min | max | mean | std | median |
|---|---:|---:|---:|---:|---:|
| f1_min (Tấn) | 2311,9305 | 2311,9305 | 2311,9305 | **0,00000000** | 2311,9305 |
| f2_min | 0,154960 | 0,155175 | 0,154973 | 0,00004914 | 0,154960 |
| ArchiveSize | 72 | 84 | 77,80 | 3,4121 | 77,5 |

**Kết luận ngắn gọn về stability**: f1_min **giống hệt tuyệt đối** (std=0,00000000) ở cả 20/20 run độc lập, khác seed hoàn toàn. f2_min dao động cực nhỏ (std=0,00005, biên độ 0,000215 trên thang giá trị ~0,155 — tương đương 0,14%). Đây là bằng chứng ổn định định lượng mạnh, đáng tin cậy (đã loại trừ khả năng "giống nhau vì cùng seed" — xem mục 7).

---

## 2. Pareto validation

| Kiểm tra | Kết quả |
|---|---|
| Số dòng trong `campaign_pareto_tongthe_20runs.csv` | 90 |
| Số dòng sau khi loại duplicate (theo X1-X4) | 90 (không có duplicate) |
| Số điểm BỊ TRỘI khi kiểm dominance lại trên chính 90 điểm | **0/90** (xác nhận đây đúng là mặt Pareto không bị trội) |

### Tọa độ A/B/C (tính lại độc lập, tiêu chí GIỮ NGUYÊN như đã chốt: A=min f1, C=min f2, B=knee point theo khoảng cách chuẩn hóa nhỏ nhất tới [0,0])

| Nghiệm | Dòng CSV | h_DN | h_DD | h_DCT | t_BMC | f1 | f2 |
|---|---:|---:|---:|---:|---:|---:|---:|
| A (min f1) | 1 | 1,10 | 1,10 | 1,40 | 0,25 | 2311,93 | 0,4053 |
| B (knee) | 40 | 1,15 | 1,45 | 1,40 | 0,35 | 2820,25 | 0,2082 |
| C (min f2) | 90 | 2,00 | 2,00 | 1,40 | 0,45 | 3820,83 | 0,1550 |

File dữ liệu dùng trực tiếp để vẽ hình Pareto: `code/results/campaign_pareto_tongthe_20runs.csv` (90 điểm) + `code/results/campaign_20runs_pareto_overlay.png` (đã vẽ sẵn, 20 mặt Pareto chồng lớp + mặt tổng thể).

---

## 3. A/B/C validation

Đọc trực tiếp từ `governing_combos_analysis.mat`:

| | A | B | C |
|---|---:|---:|---:|
| x (chỉ số catalogue) | [1 1 1 1] | [tương ứng h_DN=1,15...] | [19 19 1 5] |
| f1 (Tấn) | **2311,93** ✅ | **2820,25** ✅ | **3820,83** ✅ |
| η_DN | 0,2183 | 0,1860 | 0,0937 |
| η_DD | 0,1749 | 0,1162 | 0,0931 |
| η_DCT | 0,1008 | 0,0931 | 0,0802 |
| η_BMC | 0,3538 | 0,2082 | 0,1550 |
| **η_max_true** | **0,3538** ✅ | **0,2082** ✅ | **0,1550** ✅ |
| N_pile (Tấn) | 210,00 | 218,01 | 227,62 |
| U_max (m) | 0,0491 | 0,0490 | 0,0487 |

✅ = khớp chính xác với giá trị đã cho trước trong yêu cầu rà soát (Task 4) — **không có giá trị nào bị thay đổi**.

---

## 4. Governing combinations

| Đại lượng | Combo A | Combo B | Combo C | Nhất quán? |
|---|---|---|---|---|
| M_DN | ULSB-044 | ULSB-044 | ULSB-043 | Không hoàn toàn (2/3) |
| M_DD | ULSB-252 | ULSB-024 | ULSB-024 | Không hoàn toàn (2/3) |
| **M_DCT** | ULSB-024 | ULSB-024 | ULSB-024 | **Có, cả 3/3** |
| M_BMC | ULSB-038 | ULSB-029 | ULSB-029 | Không hoàn toàn (2/3) |
| **N_pile** | ULSB-051 | ULSB-051 | ULSB-051 | **Có, cả 3/3** |
| **U_max** | ULSB-051 | ULSB-051 | ULSB-051 | **Có, cả 3/3** |

**Xác nhận 4 câu hỏi bắt buộc (Task 5)**:
1. ULSB-024 chi phối M_DCT ở cả A/B/C? **ĐÚNG, không có ngoại lệ.**
2. ULSB-051 chi phối N_pile ở cả A/B/C? **ĐÚNG, không có ngoại lệ.**
3. ULSB-051 chi phối U_max ở cả A/B/C? **ĐÚNG, không có ngoại lệ.**
4. BMC là cấu kiện chi phối η_max ở cả A/B/C? **ĐÚNG, không có ngoại lệ** (η_BMC là giá trị lớn nhất trong 4 nhóm ở cả 3 nghiệm).

Không phát hiện ngoại lệ nào cần ghi chú thêm cho 4 mục trên. M_DN/M_DD/M_BMC KHÔNG hoàn toàn nhất quán giữa 3 nghiệm (đổi combo chi phối theo thiết kế) — đây là kết quả thật, không ép về 1 kết luận.

---

## 5. Envelope vs individual-combination verification

**Đây là task quan trọng nhất theo yêu cầu — đối chiếu số liệu:**

| Nghiệm | f2_search (combo bao BAO-ULSB) | f2_true (max qua 410 combo riêng) | Chênh lệch |
|---|---:|---:|---:|
| A | 0,4053 | 0,3538 | **+0,0515** |
| B | 0,2082 | 0,2082 | 0,0000 |
| C | 0,1550 | 0,1550 | −0,0000 |

**Phân tích nguyên nhân kỹ thuật (chỉ riêng nghiệm A có chênh lệch)**: combo bao `BAO-ULSB` trong SAP2000 là loại tổ hợp **Envelope** — với mỗi thành phần nội lực (M2, M3), SAP2000 báo cáo giá trị lớn nhất **độc lập theo từng thành phần**, có thể đến từ 2 tổ hợp cơ bản (trong số 388 ULSB) khác nhau. Khi tính $\eta = \sqrt{M_2^2+M_3^2}/M_u$ từ 2 giá trị M2, M3 "lớn nhất riêng lẻ" này, kết quả có thể **lớn hơn** giá trị $\sqrt{M_2^2+M_3^2}$ thực tế đạt được bởi bất kỳ 1 tổ hợp cụ thể nào — vì 2 giá trị max không nhất thiết xảy ra đồng thời trong cùng 1 kịch bản tải trọng thật. Đây là đặc tính vốn có, đã biết, của tổ hợp Envelope khi áp dụng cho một đại lượng tổng hợp (resultant) — **không phải lỗi tính toán, không phải lỗi MOSFOA**.

Với nghiệm B và C, giá trị M2/M3 chi phối η_BMC tình cờ đến từ cùng 1 tổ hợp cơ bản, nên combo bao và combo riêng cho kết quả trùng khớp tuyệt đối.

**Phân biệt 2 loại chỉ số (theo đúng yêu cầu, không gộp lẫn)**:
- **(1) Search metric** — $f_2$ dùng trong vòng lặp MOSFOA: chỉ số **cận trên thiên an toàn** (conservative upper-bound indicator) dựa trên combo bao, mục đích là không bỏ sót nghiệm nguy hiểm trong quá trình tìm kiếm, KHÔNG phải giá trị η thực tế đạt được bởi 1 tổ hợp cụ thể.
- **(2) Final verification metric** — $\eta_{max,true}$ báo cáo cho 3 nghiệm đại diện: giá trị **lớn nhất thật sự đạt được**, xác nhận từ 410 tổ hợp tải trọng riêng lẻ, có thể truy vết đến đúng 1 combo cụ thể.

**Đề xuất diễn đạt cho manuscript** (nguyên văn gợi ý, có thể điều chỉnh văn phong):
> "During the MOSFOA search, $f_2$ was evaluated using SAP2000's built-in envelope combination (`BAO-ULSB`), providing a conservative upper-bound estimate of the utilization ratio without exhaustively evaluating all 388 individual ULS combinations at every iteration. For the three representative Pareto solutions, all 410 load combinations were subsequently evaluated individually to confirm the true governing utilization ratio and its associated load combination. For solutions B and C, the envelope-based and individually-verified values coincided exactly; for solution A, the envelope-based estimate (0.4053) was found to be conservative relative to the true maximum obtained from any single combination (0.3538), consistent with the inherent behavior of envelope-type combinations when applied to a resultant quantity ($\sqrt{M_2^2+M_3^2}$) whose components may be maximized by different underlying load cases."

**Không** gọi đây là lỗi MOSFOA. **Không** sửa ngược dữ liệu campaign (`f1_min`, `f2_min` trong 20 file FINAL.mat giữ nguyên, vì đó là chỉ số SEARCH, đúng vai trò của nó). **Không** thay dữ liệu search bằng dữ liệu verification — cả 2 được trình bày song song, có chú thích rõ vai trò khác nhau.

---

## 6. Stability and convergence

**Dữ liệu convergence CÓ SẴN đầy đủ** trong cả 20 file `*_FINAL.mat` (`History.BestObjectives`, `History.RepositorySize`, `History.CumulativeFEs`, `History.NumFeasible/NumInfeasible` — 101 điểm/run, ứng với Max_it+1=101).

### Hội tụ min-f1 tại các mốc vòng lặp (cả 20 run, đọc trực tiếp)

| Run | iter0 | iter20 | iter50 | iter100 |
|---|---:|---:|---:|---:|
| 1–20 | 2495–2996 (dao động theo seed) | **2311,93** | **2311,93** | **2311,93** |

Toàn bộ 20/20 run đã hội tụ đúng giá trị 2311,93 **ngay từ vòng lặp 20/100** (20% tổng số vòng lặp) và giữ nguyên không đổi đến hết vòng 100 — không có run nào hội tụ muộn hơn hoặc hội tụ về giá trị khác. Đây là bằng chứng số liệu (không suy diễn từ hình ảnh) cho tính ổn định hội tụ.

**Đề xuất trình bày cho manuscript**: 1 hình đường cong hội tụ (trục X = vòng lặp 0-100, trục Y = min-f1) vẽ chồng cả 20 đường (hoặc dải min-max + đường trung bình) — dữ liệu đã sẵn sàng trong `final_validation_convergence.mat`, chỉ cần vẽ.

---

## 7. Reproducibility

Các trường xác nhận có trong MỖI file `*_FINAL.mat` (kiểm tra trên run01, áp dụng cho cả 20 file — cùng code, cùng cấu trúc lưu): `RunID, rngSeedUsed, RunStartTime, RunEndTime, TotalFE, TotalFeasible, TotalInfeasible, FinalArchiveSize, BestObjective1, BestObjective2, REP (Pareto archive: pos + pos_fit), History (đầy đủ theo vòng lặp), cfg (toàn bộ cấu hình dùng cho run đó), Npop, Max_it, Nr, Num_work, elapsedSec`.

**Chuỗi truy vết**: Run → Seed (`rngSeedUsed`, xác nhận 20/20 khác nhau) → Design (`REP.pos`, chỉ số catalogue, quy đổi được ra X1-X4 thật qua `cfg.X*_list`) → SAP2000 evaluation (đã kiểm chứng qua `evaluate_superstructure_design.m`, có `diagnostic` struct đầy đủ per-evaluation dù không lưu vào archive) → Objective (`REP.pos_fit`) → Pareto solution (`REP`) → Final verification (`governing_combos_analysis.mat`, cho A/B/C).

**Không thiếu thành phần nào** trong chuỗi truy vết cấp run/seed/design/objective/archive. Riêng dữ liệu "constraint values chi tiết + governing combination" **chỉ được lưu cho 3 nghiệm đại diện A/B/C** (hậu kiểm riêng), không lưu cho toàn bộ 40.400 lần đánh giá trong campaign (quyết định thiết kế có chủ đích từ đầu, vì tốc độ — dùng combo bao trong vòng lặp chính) — đã nêu rõ ở mục 5, không phải thiếu sót ngoài dự kiến.

---

## 8. Final tables for manuscript

Đã có sẵn, đối chiếu khớp với rà soát độc lập ở file này:
- Bảng nghiệm đại diện A/B/C (mục 13.5 đề cương) — `Bang_tong_hop_ket_qua_Bai6.md` mục 2.
- Bảng tổ hợp tải trọng chi phối (mục 13.7 đề cương) — `Bang_tong_hop_ket_qua_Bai6.md` mục 3.
- Bảng thống kê campaign (FINAL_CAMPAIGN_STATISTICS) — mục 1 file này.

---

## 9. Final figures required

| Hình | Trạng thái | Ghi chú |
|---|---|---|
| Pareto front (90 điểm + 20 run chồng lớp) | ✅ Đã có | `campaign_20runs_pareto_overlay.png` |
| Đường cong hội tụ (20 run) | 🟡 Dữ liệu sẵn sàng, CHƯA vẽ | Dữ liệu trong `final_validation_convergence.mat` |
| Sơ đồ quy trình MOSFOA–MATLAB–SAP2000 | 🔴 Chưa làm | Hình sơ đồ khái niệm, không phụ thuộc dữ liệu campaign |
| Mô hình FEM cầu tàu | 🔴 Chưa làm | Ảnh chụp/render mô hình SAP2000, không phụ thuộc dữ liệu campaign |
| So sánh 3 nghiệm đại diện (biểu đồ cột η/khối lượng) | 🔴 Chưa làm | Dữ liệu sẵn sàng (mục 3 file này), chỉ cần vẽ |

---

## 10. Manuscript readiness

## FINAL STATUS

**STATUS: READY AFTER MINOR POST-PROCESSING**

**REASON**: Toàn bộ dữ liệu số (campaign 20 run, mặt Pareto 90 điểm, 3 nghiệm đại diện, tổ hợp chi phối, đối chiếu envelope/individual, dữ liệu hội tụ) đã được xác nhận độc lập từ file nguồn, không phát hiện sai lệch/ngoại lệ nào so với báo cáo trước, và đủ để trả lời cả 4 câu hỏi nghiên cứu của đề cương. Phần còn thiếu chỉ là **hình vẽ trình bày** (convergence plot, biểu đồ so sánh A/B/C, sơ đồ quy trình, ảnh mô hình FEM) — không cần bất kỳ tính toán/chạy lại campaign nào, chỉ cần vẽ từ dữ liệu đã có sẵn hoặc chụp ảnh mô hình.

**REMAINING ACTIONS**:
1. Vẽ hình đường cong hội tụ (20 run, min-f1 theo vòng lặp) từ `final_validation_convergence.mat`.
2. Vẽ biểu đồ so sánh 3 nghiệm A/B/C (khối lượng, η từng cấu kiện) từ bảng mục 3 file này.
3. Chuẩn bị sơ đồ quy trình MOSFOA–MATLAB–SAP2000 (hình khái niệm) và 1 ảnh/render mô hình FEM cầu tàu (không phụ thuộc dữ liệu campaign, có thể làm song song với việc viết bài).
4. Sau khi có đủ hình, bắt đầu viết manuscript — **không cần quay lại chỉnh sửa số liệu campaign nữa**.

---

## Checklist cuối cùng

- [x] Campaign 20 runs validated — **GREEN**
- [x] Pareto front validated — **GREEN**
- [x] A/B/C validated — **GREEN**
- [x] 410 load combinations validated — **GREEN**
- [x] Governing combinations validated — **GREEN**
- [x] Envelope issue documented — **GREEN**
- [x] Convergence data available — **GREEN** (có sẵn, đã trích xuất)
- [x] Statistical stability available — **GREEN**
- [x] Reproducibility confirmed — **GREEN**
- [ ] Figures ready — **YELLOW** (2/5 hình đã có, 3/5 cần vẽ/chụp — không cần dữ liệu mới)
- [x] Tables ready — **GREEN**
