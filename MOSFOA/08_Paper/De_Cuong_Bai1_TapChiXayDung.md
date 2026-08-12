# ĐỀ CƯƠNG BÀI BÁO #1 — CHUẨN ĐỊNH DẠNG TẠP CHÍ XÂY DỰNG

> Tài liệu này được dựng lại **đúng theo file thể thức "Quy cách bài báo khoa học-TCXD.docx"** do Tạp chí Xây dựng cung cấp. Phần 0 tóm tắt toàn bộ quy tắc định dạng bắt buộc; Phần A là bản mẫu (skeleton) đã điền nội dung thực tế của đề tài, format sẵn theo đúng quy tắc để copy trực tiếp vào Word; Phần B là hướng dẫn triển khai kỹ thuật từng bước (giữ nguyên từ bản trước, cập nhật số mục cho khớp).

---

## PHẦN 0 — TÓM TẮT QUY TẮC ĐỊNH DẠNG (rút từ file quy cách của Tạp chí)

| Mục | Quy tắc |
|---|---|
| **Tít chính** | Chữ thường, **đậm** (không viết hoa toàn bộ) |
| **Tít dịch (tên tiếng Anh)** | Chữ thường, không đậm |
| **Tên tác giả** | VIẾT HOA, đánh số mũ 1,2,3… và dấu * cho tác giả liên hệ chính |
| **Đơn vị công tác, Email** | Chữ thường |
| **TÓM TẮT / ABSTRACT** (nhãn) | CHỮ HOA, **đậm**; nội dung đoạn văn bên dưới viết thường bình thường |
| **Từ khóa / Keywords** (nhãn) | Chữ thường, **đậm**; các từ khóa cách nhau bằng dấu **chấm phẩy (;)** |
| **Tên mục "Đặt vấn đề"** | Bắt buộc dùng **"ĐẶT VẤN ĐỀ"** — KHÔNG dùng "Mở đầu"/"Giới thiệu" |
| **Đầu mục chính (1, 2, 3…)** | CHỮ HOA, **đậm** |
| **Tiểu mục (1.1, 1.2, 2.1…)** | Chữ thường, **đậm** |
| **Tiểu mục con (1.1.1, 1.1.2…)** | Chữ thường, *nghiêng* |
| **Cấp sâu hơn (1.1.1.1…)** | Chữ thường, *nghiêng* |
| **Chú thích Bảng/Hình** | Chữ thường, căn trái; format: `Bảng 1. Tên bảng` / `Hình 1. Tên hình` (số và tên cách nhau bằng dấu chấm) |
| **Chú thích chi tiết trong hình** | Chữ thường, *nghiêng*, ví dụ: `1 - Đường cong; 2 - Đường xiên…` |
| **Từ "Hình", "Bảng" khi nhắc trong bài** | Luôn viết hoa chữ đầu, ví dụ "...như trong Hình 2." |
| **Số thứ tự công thức** | Đánh số tuần tự (1), (2), (3)… đến hết bài (không tách riêng theo từng mục) |
| **Trích dẫn trong bài** | Viết `[1, 2]` — KHÔNG viết `[1], [2]` |
| **Số thập phân** | Tiếng Việt dùng dấu phẩy: `15,7` (không dùng `15.7`); tiếng Anh vẫn dùng dấu chấm `15.7` |
| **Không** | Không tạo hyperlink cho số/tên hình, bảng, TLTK; không dùng auto-numbering cho tiêu đề mục; không bôi đậm/nghiêng theo ý chủ quan ngoài quy định |
| **Tài liệu tham khảo** | Chuẩn IEEE biến thể VN: `Tác giả. Tên bài báo. Tên tạp chí, số, trang, năm, doi.` — số TLTK trong `[ ]` **không có dấu chấm sau**. Nếu trích nguồn Internet: thêm `Internet: địa chỉ đầy đủ, ngày truy cập.` |
| **Trình tự phần Nội dung** | `1. ĐẶT VẤN ĐỀ` → các mục nội dung chính (2, 3…) → `... KẾT LUẬN` (mục cuối) → `Lời cảm ơn (nếu có)` → `TÀI LIỆU THAM KHẢO` |

---

## PHẦN A — BẢN MẪU (SKELETON) ĐÃ ĐIỀN NỘI DUNG THỰC TẾ

> Ghi chú: các đoạn `[...]` là placeholder cần điền số liệu/kết quả thật sau khi chạy mô hình (xem Phần B). Định dạng chữ đậm/nghiêng dưới đây **thể hiện đúng** yêu cầu format của tạp chí — khi đưa vào Word, giữ nguyên kiểu chữ này.

---

**Tối ưu hóa thiết kế kết cấu trụ va bến cảng lỏng bằng thuật toán tối ưu hóa Sao biển (SFOA) kết hợp mô hình phần tử hữu hạn**

*Structural design optimization of a berthing dolphin at a liquid bulk jetty using the Starfish Optimization Algorithm coupled with a finite element model*

**[HỌ TÊN TÁC GIẢ 1]¹\*, [HỌ TÊN TÁC GIẢ 2]²**

¹ [Tên đơn vị công tác tác giả 1]
² [Tên đơn vị công tác tác giả 2]

\*Email: [email tác giả liên hệ chính]

**TÓM TẮT**

Trụ va (Berthing Dolphin - BD) là kết cấu quan trọng trong hệ thống bến cảng, có vai trò tiếp nhận và tiêu tán năng lượng va tàu. Thiết kế hiện nay chủ yếu dựa trên kinh nghiệm và tính toán lặp thủ công, dẫn đến khả năng dư thừa vật liệu và chưa khai thác hết tiềm năng tối ưu chi phí. Nghiên cứu này đề xuất một khung tính toán liên kết mô hình phần tử hữu hạn (SAP2000) với thuật toán tối ưu hóa Sao biển (Starfish Optimization Algorithm - SFOA) trong môi trường MATLAB để tối ưu hóa chi phí xây dựng kết cấu BD, có xét đầy đủ các ràng buộc kỹ thuật và địa kỹ thuật theo TCVN 7888:2014, TCVN 10304:2014 và tiêu chuẩn quốc tế PIANC, OCDI. Kết quả áp dụng cho công trình thực tế cho thấy nghiệm tối ưu do SFOA tìm được giúp giảm [XX]% chi phí xây dựng và [XX]% chuyển vị lớn nhất so với thiết kế hiện trạng, đồng thời SFOA thể hiện độ chính xác và tốc độ hội tụ vượt trội so với các thuật toán PSO, GWO, WOA, HHO trên cùng bài toán. Kết quả nghiên cứu là cơ sở để mở rộng khung tính toán sang bài toán tối ưu hóa đa mục tiêu cho toàn hệ thống bến cảng.

**Từ khóa:** Trụ va; tối ưu hóa kết cấu; thuật toán Sao biển; mô hình phần tử hữu hạn; cọc bê tông ứng suất trước.

**ABSTRACT**

The berthing dolphin (BD) is a critical component of jetty systems, designed to absorb and dissipate berthing energy. Current design practice largely relies on experience-based trial-and-error calculation, often resulting in material redundancy and unexploited cost-saving potential. This study proposes a computational framework coupling a finite element model (SAP2000) with the Starfish Optimization Algorithm (SFOA) in MATLAB to minimize the construction cost of a BD structure, subject to structural and geotechnical constraints in accordance with TCVN 7888:2014, TCVN 10304:2014, and the international standards PIANC and OCDI. Results from a real-world case study show that the optimal solution obtained by SFOA reduces construction cost by [XX]% and maximum displacement by [XX]% compared with the current design, while SFOA demonstrates superior accuracy and convergence speed relative to PSO, GWO, WOA, and HHO on the same problem. These findings provide a foundation for extending the framework toward multi-objective optimization of the entire jetty system.

**Keywords:** Berthing dolphin; structural optimization; Starfish Optimization Algorithm; finite element model; prestressed concrete pile.

---

### 1. ĐẶT VẤN ĐỀ

[Nội dung: vai trò của BD trong hệ thống bến cảng; thực trạng thiết kế theo kinh nghiệm ở Việt Nam; tổng quan ngắn về ứng dụng metaheuristic (PSO, GWO, WOA, HHO...) trong tối ưu hóa kết cấu công trình; khoảng trống nghiên cứu — chưa có công trình áp dụng SFOA (thuật toán công bố năm 2024) cho kết cấu cảng biển kết hợp mô hình FEM thực tế theo tiêu chuẩn Việt Nam; mục tiêu và đóng góp của bài báo; cấu trúc bài báo.]

Trích dẫn ví dụ trong đoạn văn: "...đã được nhiều tác giả nghiên cứu ứng dụng cho các bài toán tối ưu hóa kết cấu công trình [1, 2, 3]."

### 2. PHƯƠNG PHÁP NGHIÊN CỨU

**2.1. Thuật toán tối ưu hóa Sao biển (SFOA)**

[Tóm tắt cảm hứng sinh học (hành vi khám phá, săn mồi, tái sinh của sao biển); nêu 2 pha exploration/exploitation; trình bày công thức cốt lõi — đánh số công thức tuần tự (1), (2), (3)… Trích dẫn nguyên bản: Zhong và cộng sự [4].]

*2.1.1. Pha khám phá (exploration)*

[Công thức (1)-(4) — mô hình hóa search pattern 5 chiều (D>5) và 1 chiều (D≤5).]

*2.1.2. Pha khai thác (exploitation)*

[Công thức (5)-(7) — preying & regeneration.]

**2.2. Xây dựng bài toán tối ưu hóa kết cấu trụ va**

[Mô tả công trình nghiên cứu điển hình: cấu hình hiện trạng BD (19 cọc D600B, dài 39m); mô hình hóa hình học, đài cọc.]

*2.2.1. Biến thiết kế*

[X1 = đường kính cọc; X2 = độ dày vách cọc; X3 = góc nghiêng; X4 = chiều dài cọc — theo danh mục TCVN 7888:2014, xem Bảng 1.]

*2.2.2. Hàm mục tiêu và ràng buộc*

[Hàm mục tiêu (công thức tiếp theo trong dãy số): `f(X) = Σ Lp × Pp`. Ràng buộc kết cấu, địa kỹ thuật theo TCVN 10304:2014, PIANC, OCDI. Xử lý ràng buộc bằng hàm phạt.]

**2.3. Khung tính toán liên kết SAP2000-MATLAB**

[Mô tả mô hình FEM trong SAP2000 (cọc, đài, lò xo đất nền, tổ hợp tải trọng — xem Bảng 2); liên kết qua giao diện lập trình ứng dụng (OAPI); sơ đồ khối toàn bộ quy trình — xem Hình 1; thiết lập tham số thuật toán (N, số vòng lặp, số lần chạy độc lập).]

### 3. KẾT QUẢ VÀ THẢO LUẬN

**3.1. Kết quả tối ưu hóa bằng SFOA**

[Bảng 3: biến thiết kế tối ưu, giá trị hàm mục tiêu, so sánh % giảm chi phí/chuyển vị so với thiết kế hiện trạng.]

**3.2. Đường cong hội tụ**

[Hình 2. Đường cong hội tụ của SFOA qua các vòng lặp.]

**3.3. So sánh với các thuật toán đối chứng**

[Bảng 4: Best/Trung bình/Xấu nhất/Độ lệch chuẩn của SFOA, PSO, GWO, WOA, HHO qua nhiều lần chạy độc lập; Hình 3. Biểu đồ hộp (boxplot) kết quả.]

**3.4. Thảo luận**

[Phân tích nguyên nhân cấu hình tối ưu khác biệt so với hiện trạng; ý nghĩa thực tiễn; hạn chế nghiên cứu (đơn mục tiêu) — mở hướng cho nghiên cứu tối ưu hóa đa mục tiêu tiếp theo.]

### 4. KẾT LUẬN

[Tóm tắt đóng góp: khung tính toán FEM-SFOA khả thi cho thiết kế tối ưu trụ va; SFOA vượt trội thuật toán đối chứng; tiềm năng ứng dụng thực tế; hướng phát triển mở rộng sang tối ưu hóa đa mục tiêu cho toàn hệ thống bến (BD+MD+MJP).]

**Lời cảm ơn** (nếu có)

[Ghi lời cảm ơn tài trợ/hỗ trợ dữ liệu, nếu có.]

**TÀI LIỆU THAM KHẢO**

[1] [Tác giả]. [Tên bài báo]. [Tên tạp chí], số [X], tr. [XX-XX], [năm], doi: [XX].

[2] [Tác giả]. [Tên bài báo]. [Tên tạp chí], số [X], tr. [XX-XX], [năm], doi: [XX].

[3] [Tác giả]. [Tên bài báo]. [Tên tạp chí], số [X], tr. [XX-XX], [năm]. Internet: [địa chỉ đầy đủ] (truy cập: [tháng/năm]).

[4] Zhong C, Li G, Meng Z, Li H, Yildiz AR, Mirjalili S. Starfish optimization algorithm (SFOA): a bio-inspired metaheuristic algorithm for global optimization compared with 100 optimizers. Neural Computing and Applications, vol. 37, pp. 3641-3683, 2025, doi: 10.1007/s00521-024-10694-1.

[Tiếp tục bổ sung TLTK cho TCVN 7888:2014, TCVN 10304:2014, PIANC (2002), OCDI (2002), PSO, GWO, WOA, HHO gốc...]

---

### Danh mục Bảng/Hình dự kiến (điền số liệu thật khi có kết quả)

- **Bảng 1.** Bảng tra tiết diện cọc bê tông ứng suất trước theo TCVN 7888:2014 dùng trong bài toán tối ưu hóa
- **Bảng 2.** Tổ hợp tải trọng sử dụng trong mô hình phần tử hữu hạn
- **Bảng 3.** So sánh biến thiết kế và hàm mục tiêu giữa nghiệm tối ưu SFOA và thiết kế hiện trạng
- **Bảng 4.** Kết quả thống kê (Tốt nhất/Trung bình/Xấu nhất/Độ lệch chuẩn) của SFOA và các thuật toán đối chứng
- **Hình 1.** Sơ đồ khối quy trình tính toán liên kết SAP2000-MATLAB
- **Hình 2.** Đường cong hội tụ của SFOA và các thuật toán đối chứng
- **Hình 3.** Biểu đồ hộp (boxplot) kết quả các lần chạy độc lập

---

## PHẦN B — HƯỚNG DẪN TRIỂN KHAI TỪNG BƯỚC

*(Giữ nguyên nội dung kỹ thuật đã xây dựng trước đó — chỉ cần đối chiếu số thứ tự mục nội dung mới ở Phần A khi viết bản thảo: nội dung "Bước 1-2" tương ứng mục 2.2-2.3 ở trên; "Bước 3-5" phục vụ mục 3.1-3.4.)*

### Bước 0 — Chuẩn bị (0,5 tuần)
- [ ] Tải lại code SFOA gốc từ MathWorks File Exchange (#173735) đã có sẵn.
- [ ] Kiểm tra phiên bản SAP2000 đang dùng có hỗ trợ OAPI.
- [ ] Kiểm tra MATLAB gọi được COM/ActiveX của SAP2000.
- [ ] Chuẩn bị file mô hình SAP2000 (.sdb) hiện có của BD.

### Bước 1 — Tham số hóa mô hình BD trong SAP2000 (1-1,5 tuần)
- [ ] Xác định 4 biến thiết kế X1(Dp), X2(tp), X3(θ), X4(Lp).
- [ ] Lập bảng tra `pile_catalog.xlsx/mat` (mã cọc, Dp, tp, giá $/m) — dùng cho **Bảng 1**.
- [ ] Viết hàm MATLAB `update_BD_model(X)` dùng `SapModel.FrameObj.SetSection`, `SapModel.PointObj.SetCoordCartesian`, `SapModel.Analyze.RunAnalysis`, `SapModel.Results.JointDispl/FrameForce`.

### Bước 2 — Xây dựng hàm mục tiêu + ràng buộc (1 tuần)
- [ ] `f1_cost(X)`, `check_constraints(X, FEM_results)`, hàm phạt `P(X)`.
- [ ] Lưu cache kết quả theo tổ hợp X để tránh gọi lại SAP2000 trùng lặp.

### Bước 3 — Ghép nối với code SFOA (0,5 tuần)
- [ ] Truyền `fobj = @(X) objective_function(X)` vào code SFOA gốc.
- [ ] Hàm ánh xạ biến rời rạc (snap-to-catalog).
- [ ] Thiết lập N = 30-50, Tmax = 100-300; test trước với Tmax nhỏ.

### Bước 4 — Chạy so sánh với PSO/GWO/WOA/HHO (0,5-1 tuần)
- [ ] Chạy cùng `fobj`, cùng cấu hình, 20-30 lần độc lập → phục vụ **Bảng 4**, **Hình 3**.

### Bước 5 — Xử lý số liệu & trực quan hóa (0,5 tuần)
- [ ] Lập **Bảng 3**, **Bảng 4**; vẽ **Hình 1** (sơ đồ khối), **Hình 2** (hội tụ), **Hình 3** (boxplot).
- [ ] Tính % giảm chi phí/chuyển vị so với hiện trạng — điền vào phần Tóm tắt/Kết luận.

### Bước 6 — Viết bản thảo theo Phần A (1,5-2 tuần)
- [ ] Điền nội dung thật vào các đoạn `[...]` trong Phần A.
- [ ] Kiểm tra lại toàn bộ format theo bảng quy tắc ở Phần 0 (đặc biệt: số thập phân dùng dấu phẩy, trích dẫn `[1, 2]`, không hyperlink, tên "Hình"/"Bảng" viết hoa khi nhắc trong câu).

### Bước 7 — Hoàn thiện & nộp bài (0,5 tuần)
- [ ] Kiểm tra định dạng cuối cùng đúng 100% theo Phần 0.
- [ ] Kiểm tra trùng lặp nội bộ với bài chính (luận án).
- [ ] Nộp kèm cover letter theo yêu cầu tạp chí.

**Tổng thời gian dự kiến: ~6-7 tuần.**

### Lưu ý rủi ro kỹ thuật
1. OAPI SAP2000 chạy hàng nghìn lần có thể treo/memory leak — dùng `try/catch` + đóng/mở lại SAP2000 định kỳ.
2. Kiểm tra license SAP2000 cho phép chạy batch dài.
3. Chạy thử nghiệm nhỏ (Tmax=5-10, N=10) trước khi chạy full-scale.
