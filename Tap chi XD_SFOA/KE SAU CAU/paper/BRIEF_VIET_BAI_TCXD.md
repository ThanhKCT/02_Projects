# BRIEF VIẾT BÀI — SFOA/SOO cho kết cấu tường/bản đáy "kè sau cầu" (Tạp chí Xây dựng, ≤3500 từ)

> Tổng hợp 2026-08-29 bởi agent con, đọc từ: `Tap chi XD_SFOA\CAU TAU HAI LINH\paper\Quy cach bai bao khoa hoc-TCXD.docx`, `...\01_SO0_SFOA_Marine_Jetty_TCID_Outline.md`, `...\02_Draft_SOO_SFOA_Marine_Jetty_TCXD.md`, `...\LESSONS_PAPER_WRITING_REVIEW_PROCESS.md`. Dùng brief này để soạn bài "kè sau cầu" ngay khi có kết quả campaign — không cần đọc lại 4 file nguồn.

## A. Quy định bắt buộc từ `Quy cach bai bao khoa hoc-TCXD.docx`

File này (4 trang, đã đọc toàn bộ qua pandoc) **chỉ quy định thể thức trình bày**, không nêu giới hạn số từ/số trang hay độ dài tóm tắt — hai con số đó (150–300 từ tóm tắt, ≤5.000 từ nội dung) đến từ trang "Thể lệ viết và gửi bài" trên website tạp chí, được trích dẫn lại trong outline mẫu, **không có trong chính file quy cách này** (xem cảnh báo ở mục E). Nội dung quy cách đọc được:

**Phần đầu:**
- Tên bài báo: tít chính chữ thường đậm; tít dịch (tiếng Anh) chữ thường **không đậm**.
- Tác giả: viết hoa; đánh số mũ `1,2,3` và `*` để chú thích đơn vị công tác + email liên hệ chính.
- Đơn vị công tác, Email: chữ thường.
- TÓM TẮT/ABSTRACT: chữ hoa, đậm (chỉ tiêu đề mục).
- Từ khóa/Keywords: chữ thường, đậm; các từ khóa phân cách bằng dấu chấm phẩy (;).

**Phần nội dung:**
- Mục 1 phải tên là **"ĐẶT VẤN ĐỀ"** — tuyệt đối không dùng "Mở đầu"/"Giới thiệu".
- Mục chính: viết hoa, đậm, số **1, 2, 3...**
- Tiểu mục cấp 1 (1.1, 1.2...): chữ thường, đậm.
- Tiểu mục cấp 2 (1.1.1...): chữ thường, nghiêng. Cấp sâu hơn (1.1.1.1...) cũng nghiêng.
- Chú thích bảng/hình: chữ thường, căn trái; số thứ tự và tên cách nhau bằng dấu chấm — ví dụ "Bảng 1. Cường độ dự trữ..." / "Hình 1. Cường độ dự trữ...". Chú thích chi tiết bên trong hình: chữ thường, nghiêng.
- Trong thân bài, chữ "Hình" và "Bảng" luôn viết hoa (Hình 1, Bảng 2...).
- Tài liệu tham khảo theo **chuẩn IEEE**: số thứ tự trong ngoặc vuông, **không có dấu chấm sau `[n]`**; nhiều nguồn trong một câu viết `[1, 2]`, **không viết** `[1], [2]`.
- Số thập phân tiếng Việt dùng dấu phẩy (ví dụ 15,7 chứ không phải 15.7; bản tiếng Anh thì ngược lại dùng dấu chấm).
- Công thức đánh số liên tục (1), (2), (3)... đến hết bài (không reset theo mục).
- Không in đậm/nghiêng chủ quan trong thân bài ngoài các quy định trên; không hyperlink số thứ tự mục/hình/bảng/tài liệu tham khảo; không tự xuống dòng đánh số đầu mục.

## B. Cấu trúc heading đề xuất cho bài mới (ngân sách từ, tổng ≤3500 từ phần nội dung)

Bài mới đơn giản hơn draft mẫu MJP đáng kể: **1 hàm mục tiêu duy nhất** (khối lượng bê tông, không phải cặp Cost/Displacement), do đó **bỏ hẳn toàn bộ phần phân tích chéo trade-off** (mục 4.3 + Bảng 6/7 + Hình 2 của draft mẫu) — đây là phần tốn từ nhiều nhất trong draft mẫu (~35% dung lượng mục Kết quả). Đề xuất phân bổ:

| Mục | Nội dung | Từ dự kiến |
|---|---|---|
| 1. ĐẶT VẤN ĐỀ | Bối cảnh kè sau cầu, SFOA + khoảng trống nghiên cứu, mục tiêu, đóng góp (không cần 3 câu hỏi nghiên cứu đầy đủ như draft mẫu — có thể gộp còn 1-2 câu hỏi) | 450–550 |
| 2. MÔ HÌNH BÀI TOÁN VÀ PHƯƠNG PHÁP | Hệ kết cấu; khung SAP2000-MATLAB-SFOA; tải trọng/tổ hợp; ràng buộc kỹ thuật (1 bảng); biến thiết kế (6 biến) + hàm mục tiêu (1 hàm, 1 bảng nếu cần đơn giá); thuật toán SFOA nguyên bản | 1000–1150 |
| 3. THIẾT LẬP THỰC NGHIỆM SỐ | Số run, N_pop, N_it, chỉ tiêu đánh giá — có thể gộp vào cuối mục 2 nếu cần tiết kiệm từ vì chỉ còn 1 case (không phải ma trận 2 case như draft) | 100–150 |
| 4. KẾT QUẢ VÀ THẢO LUẬN | Hội tụ + độ ổn định (1 hình, 1 bảng thống kê); kết quả tối ưu (1 bảng biến thiết kế); so sánh với thiết kế hiện tại (1 bảng); hiệu quả tính toán (ngắn, có thể gộp vào đoạn cuối, bỏ bớt chi tiết môi trường phần cứng nếu cần) | 900–1050 |
| 5. KẾT LUẬN | 2-3 ý, không cần 4 ý đầy đủ như draft mẫu vì không có phần trade-off cần dẫn sang MOSFOA (trừ khi vẫn muốn giữ narrative "SOO → hạn chế → MOO" cho chuỗi nghiên cứu riêng của dự án kè sau cầu) | 200–250 |
| **Tổng** | | **≈2650–3150** |

Còn dư 350–850 từ so với trần 3500 — dùng làm biên an toàn cho phần diễn giải kỹ thuật, chú thích bảng, hoặc mở rộng phần hạn chế/thảo luận nếu cần. **Không nên tiêu hết trần ngay từ đầu** — kinh nghiệm từ Paper 1 cho thấy các vòng phản biện thường yêu cầu *thêm* câu làm rõ giới hạn/nguồn số liệu chứ không rút gọn.

**Lưu ý riêng cho bài kè sau cầu**: đối tượng tối ưu là **6 biến chiều dày shell** (TUONGC30, TUONGM30, TUONGM43, TUONGM78, DAY130, DAY60), **5 ràng buộc TCVN** (sức chịu tải cọc TCVN 10304:2025; chuyển vị ngang TCVN 11820-5:2021; cắt TCVN 4116:2023 §8.2.12; nứt TCVN 4116:2023 §9.2 giới hạn 0,2mm; chọc thủng TCVN 5574:2018) — xem chi tiết đầy đủ trong memory `ke-sau-cau-sfoa-project` và code comment `Sap_KeSauCau.m`.

## C. Mẹo trình bày cụ thể (copy được từ draft mẫu)

- **Công thức**: dùng LaTeX inline `$...$` và block `$$...$$ \tag{n}` đánh số liên tục toàn bài; văn bản luôn giải thích ký hiệu ngay sau công thức bằng "trong đó..." liệt kê từng biến.
- **Bảng ràng buộc kỹ thuật**: mẫu draft dùng bảng 5 cột (STT | Ràng buộc | Đại lượng kiểm tra $g_j(x)$ | Điều kiện thỏa mãn | Cách xử lý — hard gate/soft penalty) — tái dùng được nguyên khuôn cho bài mới, chỉ đổi nội dung ràng buộc.
- **Bảng kết quả tối ưu**: cột theo thứ tự Nghiệm | Mục tiêu | (các biến thiết kế theo đúng ký hiệu công thức) | giá trị hàm mục tiêu (đóng dấu **(min)** ở ô đạt cực trị).
- **Bảng thống kê nhiều run**: Case | Best | Mean | Max | STD | CV(%) — **KHÔNG áp dụng cho bài này** vì Nrun=1 (xem cảnh báo mục E dưới của phiên chính); chỉ báo cáo 1 giá trị Best + đường cong hội tụ.
- **Bảng so sánh baseline vs SFOA**: thêm cột ΔV(%) so với thiết kế hiện tại (as-built), có dấu `--` cho hàng baseline.
- **Hình hội tụ**: đường liền = Best-so-far của lần chạy; KHÔNG có dải Min-Max band (vì chỉ 1 run) — có thể thêm điểm đánh dấu vị trí plateau nếu muốn.
- **Trích dẫn trong bài**: số ngoặc vuông kiểu IEEE, gộp nhiều nguồn `[1, 2]`; câu dạng "Kết quả cho thấy... [3]" đặt cuối câu, không đặt đầu câu kiểu "Theo [3]...".
- **Mục Kết luận**: mở đầu bằng tóm tắt framework đã làm, sau đó liệt kê kết quả chính bằng số liệu cụ thể (không nói chung chung "SFOA hiệu quả"), kết thúc bằng câu "định vị nghiên cứu" (đóng góp + hạn chế + hướng phát triển).
- Mọi đại lượng "tăng X%" nếu đồng thời diễn đạt bằng "Y lần" trong cùng câu, **phải tính lại bằng script**, không nhẩm.

## D. Checklist lỗi cần tránh (đúc kết từ LESSONS + Phan bien 1V4)

**Từ ngữ/claim phải hạ giọng:**
- "chứng minh/khẳng định" → tránh khẳng định tuyệt đối không có bằng chứng đủ mạnh.
- "tối ưu toàn cục/global optimum" → không dùng trừ khi có exact solution đối chứng.
- "vượt trội/hiệu quả vượt trội" → không dùng nếu không có benchmark đối chứng (PSO/GA/GWO...).
- "nghiệm tối ưu" cho MỘT lời giải cụ thể → đổi thành **"nghiệm tốt nhất tìm được theo mục tiêu X"** / "best-found solution".
- "dữ liệu thực nghiệm" cho nghiên cứu FEM số → đổi thành "kết quả tính toán số".
- "thỏa mọi ràng buộc/an toàn theo TCVN" → chỉ nói vậy nếu ràng buộc đó **thực sự có trong hệ constraint đang tối ưu** (phân biệt rõ constraint trong vòng lặp SFOA vs. hậu kiểm ngoài vòng lặp).
- "độ nhạy/sensitivity" → chỉ dùng nếu có phân tích sensitivity thật.

**Xác minh bằng code/data thật, không suy đoán:**
- Tiêu chuẩn thiết kế bê tông gán trong SAP2000 (`DesignConcrete`) — đọc trực tiếp trong file `.$2k`, đừng giả định.
- Tình trạng hiệu lực tiêu chuẩn — đã xác nhận TCVN 10304:2025 (không phải 2014) và TCVN 4116:2023 giới hạn nứt 0,2mm (không phải 0,08/0,10mm bản 1985) — xem memory `ke-sau-cau-sfoa-project`.
- Mọi câu "tăng X% ⇔ Y lần" phải tính lại bằng script, dùng số full-precision từ file kết quả gốc, không dùng số đã làm tròn hiển thị trong bảng.

**Quy cách tạp chí — chốt trước, đừng sửa cuối:**
- ĐẶT VẤN ĐỀ và KẾT LUẬN nằm cùng dãy số với các mục nội dung khác (1...5), không tách rời số.
- Tít dịch tiếng Anh: sentence case, không đậm, không Title Case.
- Trích dẫn `[1, 2]` không `[1],[2]`; không chấm sau `[n]`.
- Không in đậm/nghiêng chủ quan trong thân bài.

## E. Cảnh báo/rủi ro cần lưu ý

1. **Giới hạn từ và độ dài tóm tắt không nằm trong file quy cách gốc** — 150–300 từ tóm tắt, ≤5.000 từ nội dung chỉ có trong trang "Thể lệ" của tạp chí (theo outline mẫu MJP). User đã yêu cầu rõ ràng ≤3500 từ cho bài này — dùng đúng con số user yêu cầu, không cần đối chiếu lại thể lệ trừ khi có nghi vấn.
2. **Outline mẫu MJP không áp dụng trực tiếp** — được thiết kế cho bài toán multi-objective (Cost–Displacement). Bài "kè sau cầu" là **SOO thuần túy (1 objective, 6 biến)** → bỏ hẳn phần "phân tích trade-off" và narrative "SOO có hạn chế vì không có Pareto, cần MOSFOA" — không có gì để so sánh chéo vì chỉ có 1 mục tiêu.
3. **Nrun=1 (quyết định của user)** — bảng thống kê kiểu Best/Mean/STD/CV **không áp dụng được** cho bài này (khác MJP có 30 run). Chỉ báo cáo 1 giá trị Best + đường cong hội tụ (đã có bằng chứng plateau rõ từ pilot Npop=15/Max_it=40, xem memory) làm minh chứng ổn định thay cho thống kê đa-run.
4. Nếu campaign chưa chạy xong, đã có thể dựng khung heading + viết trước toàn bộ phần 1–3 (không phụ thuộc kết quả) và để trống các ô số liệu chờ điền khi có kết quả thật — tránh tự bịa số liệu minh họa.
