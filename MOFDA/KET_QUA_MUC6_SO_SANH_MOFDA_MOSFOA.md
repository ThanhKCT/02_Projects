# MỤC 6 — KẾT QUẢ VÀ THẢO LUẬN (bản nháp dữ liệu thật, 10/09/2026)

> Bản nháp này viết theo đúng khung Mục D.6 của [`DE_CUONG_BAI_BAO_MOFDA_MOSFOA_SO_SANH_THUAT_TOAN.md`](DE_CUONG_BAI_BAO_MOFDA_MOSFOA_SO_SANH_THUAT_TOAN.md), dùng số liệu THẬT từ campaign 30 lần MOFDA + 30 lần MOSFOA (E-MOSFOA) hoàn tất 10/09/2026 và mặt Pareto tham chiếu CHÍNH THỨC (vét cạn 4.080 tổ hợp). Nguồn số liệu: `Wharf100DWT/results/analysis/` (script `analyze_mofda_vs_mosfoa.m`). Đây là bản nháp Mục 6 — CHƯA phải toàn bộ bài báo (Mục 1-5, 7 cần nội dung mô tả công trình/thuật toán, xem ghi chú cuối file).

---

## 6.1. Mặt Pareto tham chiếu

Vét cạn toàn bộ 4.080 tổ hợp thiết kế (bảng $q_b$ TCVN 10304:2025 đã sửa lỗi, đã bổ sung ràng buộc chống nhổ cọc) xác định được **3.337/4.080 tổ hợp khả thi** (743 tổ hợp bị loại do vi phạm hình học/ràng buộc cứng), trong đó **59 nghiệm không bị trội** tạo thành mặt Pareto tham chiếu chính thức. Khối lượng vật liệu dao động **3.317,3–5.189,4 tấn**, chuyển vị ngang lớn nhất dao động **9,83–16,27 mm** — đều thấp hơn nhiều giới hạn cho phép theo TCVN 11820-5:2021.

**Kiểm chứng hiện tượng "dồn biên" (boundary clustering)** — giả thuyết nêu tại Mục C của đề cương, được kiểm tra trực tiếp trên dữ liệu chính thức (không giả định trước):

| Biến thiết kế | Miền khảo sát | Số nghiệm tại đúng cận trên | Số nghiệm trong 5% dải sát cận trên | Số nghiệm tại/gần cận dưới |
|---|---|---:|---:|---:|
| CatIdx_BTCT (dòng catalogue cọc BTCT, 1=D600...5=D1000) | [1, 5] | 18/59 (30,5%) | 18/59 (30,5%) | 0 |
| D_thép (m) | [0,800; 1,300] | 17/59 (28,8%) | 41/59 (69,5%) | 0 |
| t_thép (m) | [0,010; 0,025] | 2/59 (3,4%) | 2/59 (3,4%) | 0 |

Số liệu chính thức **xác nhận hiện tượng dồn biên đối với đường kính cọc thép (D_thép)**: gần 70% nghiệm Pareto nằm trong 5% dải sát cận trên của miền khảo sát (1,275–1,300 m), và không có nghiệm nào gần cận dưới. Dồn biên tương tự nhưng yếu hơn quan sát được ở CatIdx_BTCT (30,5% tại cận trên, tức dòng D1000). Ngược lại, chiều dày cọc thép (t_thép) phân bố trải đều trong miền khảo sát, không thể hiện dồn biên rõ rệt. Kết quả này nhất quán với quan sát ở nghiên cứu trước (243 tổ hợp, ba dòng BTCT hẹp hơn) và cho thấy cận trên hiện tại của D_thép có thể chưa đủ rộng để bao trọn vùng đánh đổi tối ưu giữa khối lượng và chuyển vị — cần lưu ý khi diễn giải kết quả và nêu ở Mục 6.5 (giới hạn nghiên cứu).

---

## 6.2–6.3. Kết quả từng thuật toán (30 lần chạy độc lập, Np=50, FE=12.550/lần)

| Chỉ số | MOFDA (Np=50, maxiter=50) | MOSFOA — E-MOSFOA (Np=50, Max_it=250) |
|---|---:|---:|
| GD (chuẩn hoá) | 0,000031 ± 0,000081 | 0,000000 ± 0,000000 |
| IGD (chuẩn hoá) | 0,000506 ± 0,000182 | 0,000100 ± 0,000074 |
| HV (W cố định = [70.340,29 tấn; 0,631374 m]) | 41.654,0150 ± 0,0064 | 41.654,0214 ± 0,0002 |
| Kích thước kho lưu trữ (repository) | 100,0 ± 0,0 | 100,0 ± 0,0 |
| Số nghiệm khớp chính xác mặt Pareto tham chiếu (ngưỡng 10⁻⁶, /100 nghiệm repository, tối đa có thể = 59 nghiệm phân biệt) | 99,77 ± 0,63 | 100,00 ± 0,00 |

Cả hai thuật toán đều đạt kho lưu trữ đầy (100 nghiệm/lần chạy) và tìm được gần như toàn bộ mặt Pareto tham chiếu ở mọi lần chạy độc lập. **MOSFOA (E-MOSFOA) tìm được đúng 100% (59/59) nghiệm Pareto tham chiếu ở cả 30/30 lần chạy, không có độ lệch (std=0)** — kết quả hoàn toàn ổn định. MOFDA đạt trung bình 99,77/100 nghiệm khớp chính xác (tức trung bình còn sót lại chưa đến 1 nghiệm/lần chạy, độ lệch chuẩn 0,63), cho thấy độ ổn định thấp hơn một chút nhưng vẫn ở mức rất cao.

## 6.4. Đối sánh trực tiếp MOFDA và MOSFOA

### 6.4.1. Kiểm định Wilcoxon rank-sum (30 vs 30, α = 0,05)

| Chỉ số | MOFDA (TB±ĐLC) | MOSFOA (TB±ĐLC) | p-value | Kết luận |
|---|---:|---:|---:|---|
| GD | 0,000031 ± 0,000081 | 0,000000 ± 0,000000 | 0,0419 | Khác biệt có ý nghĩa thống kê |
| IGD | 0,000506 ± 0,000182 | 0,000100 ± 0,000074 | 1,07×10⁻¹⁰ | Khác biệt có ý nghĩa thống kê (rất mạnh) |
| HV | 41.654,0150 ± 0,0064 | 41.654,0214 ± 0,0002 | 6,53×10⁻¹¹ | Khác biệt có ý nghĩa thống kê (rất mạnh) |
| Số nghiệm khớp chính xác | 99,77 ± 0,63 | 100,00 ± 0,00 | 0,0419 | Khác biệt có ý nghĩa thống kê |

Theo cả 4 chỉ số, **MOSFOA (E-MOSFOA) vượt trội MOFDA có ý nghĩa thống kê** trên bài toán cầu tàu container 100.000 DWT được nghiên cứu: IGD trung bình thấp hơn khoảng 5 lần (0,000100 so với 0,000506), HV trung bình cao hơn (dù chênh lệch tuyệt đối nhỏ do cả hai đều gần bão hoà), và tỷ lệ khớp chính xác mặt Pareto tham chiếu đạt tuyệt đối 100% ở MOSFOA so với 99,77% ở MOFDA. Khác biệt về IGD và HV có ý nghĩa thống kê rất mạnh (p < 10⁻¹⁰); khác biệt về GD và số nghiệm khớp chính xác có ý nghĩa ở mức α = 0,05 (p ≈ 0,042) nhưng yếu hơn — phù hợp vì cả hai chỉ số này gần đạt trần lý thuyết (GD→0, khớp→100%) ở cả hai thuật toán nên dư địa khác biệt bị thu hẹp.

### 6.4.2. Tốc độ hội tụ theo số lần đánh giá FEM (FE)

Đường cong IGD/HV trung bình theo FE (30 lần chạy/thuật toán, dải ±1 độ lệch chuẩn) được dựng từ `History.ArchiveFitness` lưu mỗi vòng lặp, dùng cùng điểm tham chiếu HV cố định cho cả hai thuật toán để bảo đảm so sánh được trực tiếp (xem hình đính kèm `Wharf100DWT/results/analysis/convergence_IGD_HV_vs_FE.png`).

- **MOSFOA hội tụ nhanh hơn rõ rệt**: đạt vùng bão hoà HV (~41.654) chỉ sau khoảng FE ≈ 1.000–1.500 (tương đương 20–30 vòng lặp đầu trong tổng 250 vòng), trong khi MOFDA cần khoảng FE ≈ 5.000–7.000 (tương đương 20–28 vòng lặp trong tổng 50 vòng) mới đạt mức bão hoà tương đương.
- Đường IGD trung bình của MOSFOA nằm dưới đường của MOFDA trong suốt quá trình tìm kiếm, nhất quán với kết quả tổng hợp ở Mục 6.4.1.
- Cả hai thuật toán đều hội tụ về cùng một vùng nghiệm (HV cuối cùng chênh lệch không đáng kể về mặt tuyệt đối), nhưng **MOSFOA đạt được điều đó với ngân sách đánh giá FEM nhỏ hơn nhiều** trong giai đoạn đầu tìm kiếm — đây là khác biệt thực chất nhất giữa hai thuật toán trên bài toán này, hơn là chênh lệch ở kết quả cuối cùng (vốn đã gần bão hoà ở cả hai).

### 6.4.3. Nhận xét cơ chế (định hướng thảo luận, cần hoàn thiện khi viết Mục 4)

Ưu thế hội tụ nhanh của MOSFOA phù hợp với đặc điểm cơ chế sao biển kết hợp cosine phase-control và DE-mutation/energy-step của E-MOSFOA (chuyển pha khám phá→khai thác được điều khiển tường minh theo hàm cosine, thay vì suy giảm tuyến tính/ngẫu nhiên như MOFDA), cùng bước tinh chỉnh Gaussian giai đoạn cuối giúp bám sát nhanh mặt Pareto một khi đã xác định được vùng lân cận tốt. Nhận xét này cần được đối chiếu lại với mô tả kỹ thuật đầy đủ hai thuật toán ở Mục 4 khi hoàn thiện bài báo — không đưa vào bản nháp này như kết luận cuối cùng.

## 6.5. Giới hạn nghiên cứu (bổ sung mục dồn biên, phần còn lại kế thừa từ bài báo MOFDA trước)

- Hiện tượng dồn biên xác nhận ở Mục 6.1 (D_thép, và ở mức độ thấp hơn là CatIdx_BTCT) cho thấy cận trên hiện tại của miền khảo sát có thể chưa đủ rộng để mặt Pareto tham chiếu phản ánh đầy đủ vùng đánh đổi tối ưu lý thuyết — kết quả đối sánh thuật toán (Mục 6.4) vẫn có giá trị vì cả hai thuật toán được đánh giá trên cùng mặt Pareto tham chiếu và cùng miền khảo sát, nhưng phạm vi khái quát hoá kết quả tuyệt đối (giá trị khối lượng/chuyển vị) cần thận trọng.
- Các giới hạn khác (không xét hiệu ứng nhóm cọc, giả thiết γ_k/γ_n/K_s, tổ hợp bão riêng nằm ngoài phạm vi) — xem Mục 3 file bàn giao trước, giữ nguyên khi viết Mục 6.5 đầy đủ.

---

## Ghi chú kỹ thuật (KHÔNG đưa vào bài báo — chỉ phục vụ nội bộ)

- File nguồn số liệu: `Wharf100DWT/results/analysis/combined_run_stats.csv`, `wilcoxon_mofda_vs_mosfoa.csv`, `boundary_clustering_reference_pareto.csv`, `convergence_curve_MOFDA.csv`, `convergence_curve_MOSFOA.csv`, `convergence_IGD_HV_vs_FE.png`.
- Script tạo ra toàn bộ số liệu trên: `Wharf100DWT/analyze_mofda_vs_mosfoa.m` (đã qua `checkcode`, 0 lỗi/cảnh báo).
- Điểm tham chiếu HV **cố định** W = nadir của toàn bộ 3.337 tổ hợp khả thi (không tính 743 tổ hợp bị phạt cứng) × 1,05 = [70.340,29 tấn; 0,631374 m] — dùng thống nhất cho cả 60 lần chạy (30+30) và toàn bộ đường cong hội tụ, bảo đảm HV so sánh được trực tiếp giữa hai thuật toán (khác với `History.Hypervolume` lưu sẵn trong các file `_FINAL.mat`, vốn dùng điểm tham chiếu thích ứng theo từng vòng lặp — chỉ phù hợp để xem xu hướng hội tụ nội bộ một lần chạy, KHÔNG dùng để so sánh chéo).
- **CHƯA LÀM**: Mục 1 (Mở đầu), Mục 2 (đối tượng nghiên cứu/mô hình FEM — cần cập nhật số liệu 4.080 tổ hợp, TCVN 10304:2025, ràng buộc chống nhổ cọc so với bài báo cũ 243 tổ hợp), Mục 3 (biến thiết kế/hàm mục tiêu — có thể kế thừa phần lớn cấu trúc từ [`BAI_BAO_MOFDA_CAU_TAU_100000DWT.md`](BAI_BAO_MOFDA_CAU_TAU_100000DWT.md) nhưng cần cập nhật số liệu), Mục 4 (mô tả 2 thuật toán, đặc biệt E-MOSFOA — cần lấy từ code/tài liệu thuật toán gốc của nhóm tác giả), Mục 5 (phương pháp đối sánh — phần lớn có sẵn ở Mục B/B.1/D.5 của đề cương, có thể chuyển thể trực tiếp), Mục 7 (Kết luận — viết sau khi có Mục 1-6 đầy đủ), Tóm tắt/Abstract, Tài liệu tham khảo bổ sung cho MOSFOA.
