# ĐỀ CƯƠNG BÀI BÁO — CHỐT (08/09/2026, đã tiếp thu góp ý sau cùng, kể cả 3 điểm chốt trước khi chạy)

**Tên bài báo (GIỮ NGUYÊN):** TỐI ƯU ĐA MỤC TIÊU TIẾT DIỆN HỆ CỌC CẦU TÀU CONTAINER 100.000 DWT: ĐỐI SÁNH THUẬT TOÁN MOFDA VÀ MOSFOA

**Phạm vi nghiên cứu:** 1 công trình – 2 thuật toán – 4.080 tổ hợp – Pareto tham chiếu (vét cạn) – 30 lần chạy độc lập/thuật toán – đối sánh định lượng.

> **CHỐT (cập nhật 08/09/2026):** N=30 lần chạy độc lập/thuật toán (tăng từ 20 lên 30) — theo quy ước phổ biến trong các bài báo đối sánh thuật toán tối ưu đa mục tiêu (n≥30 giúp phân phối trung bình mẫu tiệm cận chuẩn, khoảng tin cậy IGD/HV hẹp hơn, kiểm định Wilcoxon đáng tin cậy hơn). Chi phí thời gian tăng thêm không đáng kể nhờ cơ chế cache (Bước A).

> **Quy ước tên gọi**: dùng **"MOSFOA"** (tên chính thức của nhóm tác giả) ở tiêu đề, tóm tắt, mở đầu, kết luận. Trong Mục 4.2 (mô tả kỹ thuật thuật toán) nêu rõ **phiên bản thực nghiệm cụ thể là E-MOSFOA** (cosine phase-control, DE-mutation/energy-step, Gaussian refinement giai đoạn cuối) — đây là cơ chế thật đã cài đặt và sẽ chạy. B-MOSFOA chỉ nhắc 1-2 câu ở Mở đầu như bước phát triển trung gian, không đối sánh, không có mục riêng, không đưa bảng kết quả.

---

## A. Bản chất nghiên cứu (giữ xuyên suốt khi viết bài)

> Đây là bài **đối sánh MOFDA và MOSFOA trên một bài toán tối ưu kết cấu cảng biển thực**, không phải bài phát triển thuật toán. MOFDA là thuật toán dùng để đối sánh (không phải "phát triển trong nghiên cứu này"); MOSFOA là thuật toán thuộc hướng nghiên cứu của nhóm tác giả.

Hai thuật toán được thiết lập trên **cùng một hệ thống đánh giá MATLAB–SAP2000**: cùng mô hình FEM, cùng hàm đánh giá, cùng ràng buộc, cùng không gian thiết kế, cùng cơ chế lưu trữ nghiệm Pareto (archive/grid), cùng cách rời rạc hoá biến thiết kế, cùng ngân sách đánh giá FEM (FE), cùng số lần chạy độc lập. Do đó, khác biệt quan sát được có cơ sở quy về cơ chế tìm kiếm của từng thuật toán.

**Cách diễn đạt khi viết bài** (tránh tuyệt đối hoá): thay vì "tuyệt đối công bằng", dùng *"được kiểm soát thống nhất"* hoặc *"được thiết lập trên cùng điều kiện đánh giá nhằm bảo đảm tính nhất quán của phép đối sánh"*.

**Vét cạn 4.080 tổ hợp là chuẩn trung tâm của phép đối sánh** (điểm mạnh nhất của bài): cả 2 thuật toán được so sánh với 1 chuẩn độc lập (*true/reference Pareto front*), không chỉ so hai kết quả với nhau — cần nhấn mạnh logic này xuyên suốt Mục 5-6.

---

## B. Trạng thái hạ tầng — CHỈ DÙNG NỘI BỘ, không đưa nguyên trạng vào bài

*(Tên file MATLAB, checkpoint/resume, ghi atomic, cấu trúc thư mục, smoke test, dọn dẹp thư mục KHONG_DUNG... — giữ trong hồ sơ nghiên cứu, KHÔNG viết vào bài báo. Khi viết bài, chỉ chuyển hoá thành 1 câu phương pháp: "Hai thuật toán được triển khai trên cùng một hệ thống đánh giá MATLAB–SAP2000, sử dụng cùng hàm đánh giá, cùng cơ chế lưu trữ nghiệm Pareto và cùng ngân sách đánh giá mô hình FEM.")*

| Hạng mục | MOFDA | MOSFOA (bản chạy: E-MOSFOA) | Trạng thái |
|---|---|---|---|
| Kết nối SAP2000 song song, checkpoint/resume | `run_mofda_wharf100dwt_parallel.m` | `run_emosfoa_wharf100dwt_parallel.m` (mới viết, đã bổ sung checkpoint mà bản gốc không có) | Đã viết xong, đang xác nhận qua smoke test (Np nhỏ gặp lỗi tham số minh hoạ `randperm`, không phải lỗi logic — sẽ hết khi chạy Np=50 thật) |
| Hàm mục tiêu + ràng buộc (kể cả địa kỹ thuật TCVN 10304:2025) | `wharf100dwt_evaluate.m` | Dùng chung 100% | ✅ |
| Cơ chế lưu trữ Pareto (archive/grid) | `MOFDA/MOFDA/Functions/` | Dùng lại đúng các hàm trên, không viết bản riêng | ✅ |
| Rời rạc hoá biến thiết kế | Tìm kiếm liên tục, làm tròn ở bước đánh giá | Giống hệt (đã bỏ bước "snap lưới" của code gốc để nhất quán) | ✅ |
| Ngân sách FE | $N_p(1+5\cdot maxiter)$, β=4 | $N_p(Max\_it+1)$ | Khớp khi $Max\_it=5\times maxiter$ (vd Np=50,maxiter=50 ↔ Max_it=250, FE=12.550 cả 2) |
| $N_r$, `nGrid` | 100 / 10 | 100 / 10 | ✅ sẵn nhất quán |
| Lưu dữ liệu hội tụ (đường cong theo FE) | `History.ArchiveX`, `History.ArchiveFitness`, `History.Hypervolume` lưu mỗi vòng lặp trong `run_mofda_wharf100dwt_parallel.m` | Cùng 3 trường, cùng cơ chế, trong `run_emosfoa_wharf100dwt_parallel.m` | ✅ Đã bổ sung 08/09/2026, đã qua syntax check (`checkcode`), 0 lỗi thật — sẵn sàng phục vụ đường cong IGD/HV theo FE cho Mục 6.4 |

---

## B.1 Tiêu chí CHỐT xác định "tìm được nghiệm Pareto tham chiếu" (định nghĩa trước khi chạy, không đổi sau khi có kết quả)

> Vì không gian thiết kế là **lưới rời rạc hữu hạn** (4.080 tổ hợp, làm tròn ở bước đánh giá) và dùng chung **cơ chế cache theo khoá tổ hợp** (`catIdx_D_thep_t_thep`) giữa vét cạn và hai thuật toán, một điểm thiết kế trùng nhau tuyệt đối sẽ cho **giá trị hàm mục tiêu giống hệt bit-for-bit** (cùng một lần gọi SAP2000 gốc, đọc lại từ cache). Do đó tiêu chí "khớp" được định nghĩa bằng **so khớp chính xác trên không gian mục tiêu (fitness)**, không phải khoảng cách Euclid xấp xỉ:
>
> $$\text{"tìm được"} \iff \exists\, i: \max_k \left| f_k^{\text{run}} - f_k^{\text{ref},i} \right| < 10^{-6} \quad (k = 1,2 \text{ là 2 mục tiêu})$$
>
> - Ngưỡng $10^{-6}$ chỉ để chống sai số dấu phẩy động (round-off), **không phải ngưỡng "gần đúng"** — do đó không cần biện minh bằng "khoảng cách vật lý chấp nhận được", tránh tranh cãi của phản biện về việc chọn ngưỡng tuỳ tiện.
> - Cơ sở logic này áp dụng thống nhất cho cả MOFDA (`run_mofda_stats_wharf100dwt.m`, đã có sẵn) và MOSFOA/E-MOSFOA (`run_mosfoa_stats_wharf100dwt.m`, cần viết tương tự — xem Mục E).
> - Ghi rõ trong bài (Mục 5.3): tiêu chí này được **cố định trước khi chạy thực nghiệm chính thức**, không điều chỉnh theo kết quả quan sát được — trả lời trực tiếp góp ý phản biện về "tỷ lệ tìm được nghiệm Pareto tham chiếu" cần định nghĩa rõ ràng, có thể tái lập.

---

## C. Phát hiện/sửa lỗi kỹ thuật quan trọng (trước khi chạy chính thức)

- **Đã sửa lỗi lệch cột trong bảng $q_b$ (Bảng 2, TCVN 10304:2025)** ở `wharf100dwt_geotech_capacity_tcvn10304.m` — các hàng độ sâu 20-40m bị đọc lệch 1 cột từ ảnh scan, mất giá trị thật ở IL=0,0. Đã sửa bằng đối chiếu chéo với bảng đã số hoá sẵn (`Table_Fi_tip.mat`) trong chính code MOSFOA thật của nhóm tác giả.
- **BẮT BUỘC**: chạy lại vét cạn 4.080 tổ hợp với công thức đã sửa đúng → lấy làm mặt Pareto tham chiếu CHÍNH THỨC duy nhất. **Không dùng lại** mặt Pareto tạo ra trước khi sửa $q_b$ (kết quả cũ không đáng tin).
- Hiện tượng "dồn biên" quan sát ở lần chạy trước: **coi là giả thuyết cần kiểm chứng lại từ mặt Pareto vét cạn chính thức (sau khi sửa lỗi)**, KHÔNG đưa vào đề cương như một kết luận đã biết trước. Nếu số liệu chính thức xác nhận, đây sẽ là điểm thảo luận tốt ở Mục 6.4.
- **Bổ sung ràng buộc chống nhổ cọc (kéo/uplift) — phát hiện khi rà soát trước campaign chính thức**: code trước đó dùng trị tuyệt đối lực dọc, không phân biệt nén/kéo. Kiểm tra THẬT qua SAP2000 xác nhận **18/360 cọc thép bị kéo (tới ~31T)** dưới tổ hợp bao "BAO KT" (cọc BTCT luôn nén, 792/792). Đã bổ sung công thức (11)/Điều 7.2.2.4 (sức chịu tải kéo, chỉ ma sát thân, γc=0,8 vì ngàm ≥4m) — đã tra riêng $\gamma_k$ cho trường hợp kéo theo Điều 7.1.6.1 (phụ thuộc SỐ LƯỢNG CỌC trong móng, không phải theo phương pháp như nén): công trình có 192 cọc/phân đoạn (≥21 cọc) → $\gamma_k=1{,}4$ — trùng số với nén nhưng khác cơ sở, đã ghi rõ trong code để không nhầm lẫn nếu sau này đổi số lượng cọc.

---

## D. Khung nội dung bài báo (đã tiếp thu góp ý)

**Tóm tắt/Abstract**: bài toán tối ưu tiết diện cọc thực tế (4.080 tổ hợp), ràng buộc đầy đủ kể cả địa kỹ thuật TCVN 10304:2025; đối sánh MOFDA và MOSFOA trên cùng điều kiện đánh giá; dùng mặt Pareto vét cạn làm chuẩn đối chiếu độc lập. Không tuyên bố thuật toán nào vượt trội trong tóm tắt trước khi có số liệu.

**1. Mở đầu** — dẫn đến câu hỏi trọng tâm: *vì sao cần đối sánh MOFDA và MOSFOA trên một bài toán thiết kế hệ cọc cầu tàu thực với ràng buộc kết cấu và địa kỹ thuật?* Tránh kể lịch sử phát triển SFOA→B-MOSFOA→E-MOSFOA dài dòng — chỉ 1-2 câu nêu bối cảnh, không đối sánh B-MOSFOA. Kết mở đầu: bài toán nghiên cứu, khoảng trống, mục tiêu đối sánh, điểm mới — không tuyên bố kết quả trước.

**2. Đối tượng nghiên cứu và mô hình FEM** — mô tả công trình, hệ cọc, mô hình SAP2000, bảng tải trọng thật, cách MATLAB điều khiển SAP2000 để tính hàm mục tiêu/ràng buộc (**ở mức phương pháp, không trình bày code**). Không mở rộng sang toàn bộ hồ sơ thiết kế.

**3. Bài toán tối ưu đa mục tiêu**
   - 3.1 Biến thiết kế: catalogue 5 dòng D600-D1000 + lưới thép mở rộng. Diễn đạt khách quan: *"không gian thiết kế phản ánh các phương án kết cấu thực tế, đồng thời đủ lớn để đánh giá khả năng tìm kiếm của hai thuật toán"* — **không** khung theo kiểu "mở rộng để làm khó thuật toán".
   - 3.2 Hàm mục tiêu: khối lượng vật liệu + chuyển vị ngang cực đại. **Thuật ngữ CHỐT: chỉ dùng duy nhất "khối lượng vật liệu"** xuyên suốt Tóm tắt/Abstract, Mục 3.2, tên trục/tiêu đề hình vẽ, tiêu đề bảng kết quả, Mục 6, Kết luận — không dùng "khối lượng kết cấu" hay bất kỳ tên gọi khác thay thế ở bất kỳ đâu trong bài (kể cả hình/bảng).
   - 3.3-3.4 Ràng buộc: trình bày đủ rõ ràng buộc địa kỹ thuật TCVN 10304:2025 (công thức (9), Bảng 2/3, mũi BTCT Lớp 10, mũi thép Lớp 11) để người đọc hiểu bài toán không chỉ tối ưu theo vật liệu/kết cấu. Hàm phạt.

**4. Hai thuật toán đối sánh** — kiểm soát độ dài, không lặp lại toàn bộ lý thuyết gốc.
   - 4.1 MOFDA: chỉ nguyên lý, cơ chế chính, archive/grid, tham số dùng (β, Nr, nGrid).
   - 4.2 MOSFOA (bản chạy: E-MOSFOA): chỉ các thành phần cần thiết để hiểu cách tìm kiếm — cơ chế sao biển, cosine phase-control, DE-mutation/energy-step, Gaussian refinement (nêu rõ đây là biến thể enhanced được dùng để thực nghiệm). Không biến mục này thành bản sao bài phát triển MOSFOA.
   - 4.3 Ngân sách đánh giá công bằng (bảng mục B).

**5. Phương pháp đối sánh**
   - 5.1 Mặt Pareto tham chiếu — vét cạn 4.080 tổ hợp (bản đã sửa lỗi $q_b$), nhấn mạnh vai trò chuẩn độc lập.
   - 5.2 Quy trình: mỗi thuật toán 30 lần độc lập, cùng FE.
   - 5.3 Bộ chỉ số — **ưu tiên trong bài chính**: IGD, HV, tỷ lệ tìm được nghiệm Pareto tham chiếu (**tiêu chí so khớp chính xác trên fitness, ngưỡng $10^{-6}$ chống round-off, cố định trước khi chạy — xem Mục B.1**), Wilcoxon rank-sum. GD giữ lại **nếu** thực sự bổ sung thông tin (có thể để phụ lục nếu trùng lặp với IGD).

**6. Kết quả và thảo luận** — trình tự: Pareto tham chiếu → MOSFOA → MOFDA → **đối sánh trực tiếp** → giải thích khác biệt (không tách 2 thuật toán quá lâu mà thiếu đối chiếu).
   - 6.1 Mặt Pareto tham chiếu (số liệu chính thức sau khi sửa $q_b$) — kiểm chứng lại hiện tượng dồn biên nếu có, KHÔNG giả định trước.
   - 6.2-6.3 Kết quả từng thuật toán.
   - **6.4 (mục quan trọng nhất) — đối sánh trực tiếp, trả lời cụ thể**: thuật toán nào IGD tốt hơn; thuật toán nào HV tốt hơn; thuật toán nào tìm nhiều nghiệm Pareto tham chiếu hơn (theo tiêu chí Mục B.1); khác biệt có ý nghĩa thống kê không (Wilcoxon); hình dạng/độ phủ Pareto khác nhau thế nào; **tốc độ hội tụ khác nhau thế nào — dựng đường cong IGD/HV theo số lần đánh giá FE (dữ liệu `History.ArchiveFitness`/`History.Hypervolume` lưu mỗi vòng lặp, đã có sẵn ở cả 2 thuật toán)** — sau đó mới giải thích nguyên nhân cơ chế.
   - 6.5 Giới hạn nghiên cứu — viết ngắn, chỉ nêu giả thiết thực sự ảnh hưởng đến khả năng khái quát kết quả (tải bão, nhóm cọc, Ks/RQD, γk/γn), không biến thành hướng nghiên cứu mới.

**7. Kết luận** — bám sát số liệu thực nghiệm, tránh câu tuyệt đối kiểu "MOSFOA vượt trội MOFDA". Dùng khuôn: *"Trong bài toán cầu tàu container 100.000 DWT được nghiên cứu, MOSFOA đạt ... so với MOFDA theo ..., trong khi ...; sự khác biệt ... có/không có ý nghĩa thống kê."*

---

## E. Việc còn lại (theo thứ tự)

1. ✅ Xác nhận smoke test E-MOSFOA qua SAP2000 (Np≥5) thành công.
2. ✅ Bổ sung lưu đường cong hội tụ (`History.ArchiveX/ArchiveFitness/Hypervolume`) ở cả 2 thuật toán — đã qua syntax check (`checkcode`), 0 lỗi thật.
3. Chạy lại vét cạn 4.080 tổ hợp với bảng $q_b$ đã sửa đúng → mặt Pareto tham chiếu CHÍNH THỨC.
4. Chạy MOFDA và MOSFOA (E-MOSFOA) mỗi thuật toán 30 lần độc lập (Np=50, maxiter=50 / Max_it=250) — nhờ cache, nhanh sau khi có Pareto tham chiếu.
5. **Viết `run_mosfoa_stats_wharf100dwt.m`** (tương tự `run_mofda_stats_wharf100dwt.m` đã có) — dùng ĐÚNG tiêu chí so khớp chính xác trên fitness (ngưỡng $10^{-6}$, Mục B.1) để tính tỷ lệ tìm được nghiệm Pareto tham chiếu, cộng GD/IGD/HV. **CHƯA VIẾT — cần làm trước khi tổng hợp kết quả cuối.**
6. Tính IGD/HV/tỷ lệ trùng khớp/Wilcoxon (GD nếu cần).
7. Viết bài theo khung Mục D, tuân thủ thuật ngữ CHỐT "khối lượng vật liệu" (Mục 3.2).

**Đề cương đã đủ chặt, hạ tầng đã đủ (kể cả lưu đường cong hội tụ) để chuyển sang giai đoạn chạy thực nghiệm — chờ xác nhận cuối cùng của người dùng trước khi bắt đầu bước 3 (vét cạn lại, chiếm dụng máy ~19h).**
