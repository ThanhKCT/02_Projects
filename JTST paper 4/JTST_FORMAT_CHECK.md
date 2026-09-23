# JTST_FORMAT_CHECK.md

Báo cáo kiểm tra sau khi dàn trang `JTST_Bai bao Kh.docx` theo `JTST_TemplatePaper_Vietnamese.docx` (xem `JTST_FORMAT_SPEC.md` cho phân tích template đầy đủ). Output: `JTST_Bai_bao_Bai6_FINAL.docx`, `JTST_Bai_bao_Bai6_FINAL.pdf` (15 trang, render bằng LibreOffice, xem mục B).

---

## A. Đã sửa (format/style, không đổi nội dung khoa học)

**Trang đầu / trang thái**
- Thêm header1 (banner tạp chí) cho trang tiêu đề, header2 (trống, đúng như bản gốc template) cho thân bài, footer1 (số trang) xuyên suốt — được nối bằng đúng thứ tự phần tử `headerReference/footerReference` trước `pgSz/pgMar` theo schema OOXML (bản dựng đầu tiên đặt sai thứ tự khiến LibreOffice bỏ qua header2).
- Dựng lại toàn bộ hệ thống section break: trang tiêu đề+tóm tắt (1 cột) → thân bài (2 cột) → các vùng 1 cột "mở rộng" quanh MỌI bảng/hình rộng → vùng đóng bài 1 cột (Tuyên bố → Tài liệu tham khảo → khối tác giả), đúng theo cách template gốc dùng continuous section break.
- Title: bỏ in đậm (dòng tiếng Việt) và in nghiêng (dòng tiếng Anh) không có trong template gốc; đồng bộ Cambria 15pt cho cả 2 dòng.
- **Tác giả/đơn vị công tác chuyển từ cuối bài lên NGAY SAU 2 tiêu đề** (theo đúng chỉ định của bạn, khớp với 2 bài JTST đã xuất bản); ghi chú tác giả liên hệ + email giữ ngay bên dưới.
- Bảng Từ khóa/Tóm tắt: sửa tỷ lệ cột từ 50/50 sai lệch về đúng tỷ lệ thật của template (1987:8044 dxa ≈ 3,50 cm : 14,19 cm — đọc trực tiếp từ XML template, không suy đoán); thêm viền trên/dưới bảng + đường kẻ phân cách khối VN/EN.
- Rút gọn TÓM TẮT/ABSTRACT (giữ nguyên toàn bộ số liệu/kết luận, không thêm/bớt kết quả): ABSTRACT tiếng Anh còn 192 từ (trong khoảng 150–200); TÓM TẮT tiếng Việt giảm từ 382 → 241 từ (xem mục B — chưa xuống được 150–200 nếu giữ đủ nội dung bắt buộc).

**Lỗi định dạng hệ thống (ảnh hưởng nhiều vị trí)**
- Phát hiện và sửa lỗi style `ICST-Heading1` (bị dùng sai cho ô công thức, 9 tài liệu tham khảo, và khối tác giả) khiến toàn bộ các đoạn này hiển thị **chữ xanh + in đậm + font Arial** không đúng chủ đích — sửa tại styles.xml về Cambria/đen; khôi phục lại in đậm có chủ đích riêng cho dòng tên tác giả và tiêu đề "Đóng góp của các tác giả".
- Style `ICST-Tabletext` và `FootnoteText` (dùng trong mọi ô bảng + bảng tóm tắt) đổi từ Arial/Times New Roman sang Cambria cho đồng bộ font toàn bài.
- Toàn bộ 6 bảng dữ liệu (biến thiết kế, ràng buộc, tham số MOSFOA, Bảng 1, Bảng 2, Bảng 3) được thêm viền 3 đường thống nhất (viền trên + viền dưới tiêu đề cột + viền dưới bảng, không viền dọc/giữa các hàng), đúng phong cách 2 bài JTST đã xuất bản.
- Sửa lỗi Bảng 2 và Bảng 3 (search-vs-verified) bị **chẻ đôi giữa 2 cột thân bài** do gán nhầm thuộc tính section 2-cột cho chính đoạn ngắt đóng bảng — nay cả 2 bảng hiển thị đúng full-width.
- Sửa lỗi đánh số danh sách (i)/(ii)/…: danh sách 2 mục ở mục 5.6 và danh sách 4 mục ở mục 6 (Kết luận) bị nối số từ danh sách 6 bước ở mục 2.3 (hiển thị "(vii)", "(viii)"... thay vì "(i)", "(ii)"...) — đã tách numbering riêng, mỗi danh sách reset về (i).

**Nội dung khoa học đã xử lý theo quyết định của bạn (không phải tự ý sửa)**
- Xóa dòng ràng buộc g2 (Umax ≤ L/240) khỏi bảng ràng buộc theo quyết định "Bỏ ràng buộc g2 khỏi bài báo"; sửa câu "chịu ràng buộc gj(x) ≤ 0, j = 1,…,4" thành "chịu các ràng buộc kỹ thuật g1, g3, g4". Số liệu Umax trong Bảng 2 (mục 5.6) giữ nguyên như một đại lượng mô tả, không còn gắn với ràng buộc đã bỏ.
- Vẽ bổ sung sơ đồ quy trình MOSFOA–MATLAB–SAP2000 (đúng 6 bước đã liệt kê sẵn trong văn bản, không thêm nội dung mới) làm **Hình 1**; đánh số lại 3 hình còn lại (hội tụ, Pareto, so sánh A/B/C) từ Hình 1/2/3 → Hình 2/3/4, cập nhật câu dẫn "Hình 1 trình bày..." → "Hình 2 trình bày...".
- Thêm caption "Bảng 3." còn thiếu cho bảng đối chiếu search/verified (không thêm/bớt số liệu trong bảng).

**Placeholder**
- Xóa "[TO BE VERIFIED trước khi nộp]" sau câu tuyên bố không xung đột lợi ích.
- Xóa mục "Lời cảm ơn" (chỉ có placeholder "[Chỉ đưa nếu có...]", không có nội dung thật) — 2 bài JTST đã xuất bản cũng bỏ mục này khi không áp dụng.
- Thay placeholder "Đóng góp của các tác giả" bằng câu trung lập, không bịa nội dung (xem mục B).
- Sửa hình sơ đồ quy trình: bỏ tiêu đề trùng lặp bên trong ảnh (đã có caption "Hình 1." riêng), giảm kích thước, đánh dấu "giữ cùng trang với đoạn sau" để caption không bị tách khỏi hình khi ngắt cột.

---

## B. Còn NEEDS REVIEW (không tự quyết định)

- **TÓM TẮT tiếng Việt còn 241 từ** (mục tiêu 150–200): đã cắt từ 382 xuống 241 nhưng không thể xuống thấp hơn nếu giữ đủ toàn bộ 12 nội dung bắt buộc (bài toán, MOSFOA, mô hình cầu tàu, 410 tổ hợp tải trọng, 4 biến thiết kế, 2 mục tiêu, 20 runs, 40.400 evaluations, 2.311,93 tấn, 90 nghiệm Pareto, hậu kiểm 408 tổ hợp, cấu kiện/tổ hợp chi phối). Theo đúng chỉ định của bạn, báo NEEDS REVIEW thay vì tự cắt mạnh hơn — cần bạn quyết định giữ 241 từ hay chấp nhận bỏ bớt 1 nội dung để xuống dưới 200.
- **Nội dung thật của "Đóng góp của các tác giả"**: file nguồn không có dữ kiện thật (Methodology/Formal analysis/Writing... do ai làm) — đã thay bằng câu trung lập "Đóng góp cụ thể của từng tác giả sẽ được tác giả liên hệ bổ sung trước khi nộp bản thảo chính thức", cần điền nội dung thật trước khi nộp.
- **"Lời cảm ơn"/nguồn tài trợ**: không có thông tin trong file nguồn nên đã bỏ mục này; nếu nghiên cứu có tài trợ thật, cần bổ sung lại.
- **DOI, ngày nhận/duyệt bài, số Tập/Số, pISSN/eISSN**: vẫn giữ dạng placeholder chuẩn của template (`Tập …-Số … (20…)`) vì đây là thông tin do tòa soạn cấp sau khi bài được duyệt — không tự bịa số liệu.
- **Nhãn bên trong 2 ảnh dữ liệu có sẵn** (không phải text Word, thuộc về ảnh .png gốc):
  - Hình 2 (đường cong hội tụ) và Hình 3 (Pareto front): tiêu đề trục trong ảnh bị mất dấu tiếng Việt (ví dụ "Duong cong hoi tu f1 qua 20 lan chay doc lap") — lỗi phông chữ từ công cụ vẽ gốc.
  - Hình 4(a)/(b): nhãn cột "C (dap ung tot nhat)" — đúng như ghi chú đã có sẵn ngay phía trên hình trong bài ("nhãn 'C' trong ảnh gốc ghi 'dap ung tot nhat' — cần đọc/đổi thành 'C — ηmax nhỏ nhất'"), nhưng đây là nhãn nằm trong dữ liệu ảnh (không sửa được bằng thao tác Word), cần vẽ lại từ script gốc nếu muốn sửa đúng thuật ngữ.
- **Kiểm tra chéo bằng Microsoft Word thật**: file được kiểm tra bằng LibreOffice (không có Word trên máy) — do một số hành vi dàn cột/section có thể khác nhẹ giữa 2 phần mềm, khuyến nghị mở lại bằng Word thật trước khi nộp chính thức để xác nhận không có sai khác dàn trang.

---

## C. Kiểm tra template

| Hạng mục | Status | Ghi chú |
|---|---|---|
| Header | PASS | Banner trang 1 (header1) + trống ở thân bài (header2, đúng bản gốc template) |
| Title | PASS | Cambria 15pt, không bold/italic thừa, đúng template |
| Author | PASS | Chuyển lên ngay sau tiêu đề theo chỉ định; đơn vị công tác + tác giả liên hệ đầy đủ |
| Abstract | REVIEW | Đúng tỷ lệ cột bảng; ABSTRACT tiếng Anh đạt 150–200 từ; TÓM TẮT tiếng Việt còn 241 từ (xem mục B) |
| Body | PASS | Cambria xuyên suốt, 2 cột, justify, thụt đầu dòng đúng template |
| Heading | PASS | Đen, in đậm, numbering thủ công giữ nguyên (1., 1.1., …) |
| Equation | PASS | Đen, Cambria, số thứ tự căn phải, không còn chữ xanh |
| Figure | PASS | Hình 1–4 đánh số liên tục, caption dưới hình, căn giữa, full-width cho hình rộng |
| Table | PASS | Bảng 1–3 + 3 bảng công thức, caption trên bảng, viền 3 đường thống nhất, không còn bảng bị chẻ cột |
| References | PASS | Cambria 10pt, đen, giữ nguyên toàn bộ 9 tài liệu tham khảo và thứ tự |
| Footer | PASS | Số trang xuyên suốt |
| Page number | PASS | 1–15, không lặp/thiếu |

---

## D. Không thay đổi nội dung khoa học

Xác nhận **không** có thay đổi nào đối với:
- Số liệu campaign: Nrun=20, Npop=20, Max_it=100, Num_work=8, TotalFE=40.400.
- Ba nghiệm đại diện A/B/C (biến thiết kế, f1, ηmax,true) và mặt Pareto 90 nghiệm.
- Sự phân biệt search metric (f2, dùng tổ hợp bao trong vòng lặp MOSFOA) và final verification metric (ηmax,true, xác nhận từ 408 tổ hợp riêng lẻ) — không gộp hai khái niệm này ở bất kỳ đâu trong bản FINAL.
- Các tổ hợp tải trọng chi phối (ULSB-024, ULSB-051, ULSB-044, v.v.) và kết luận về bản mặt cầu là cấu kiện chi phối.
- Toàn bộ 9 tài liệu tham khảo (nội dung, thứ tự, số trích dẫn [1]–[9]) — không thêm, không bớt, không đổi thứ tự.
- Ký hiệu toán học (f1, f2, ηmax,true, x1…x4, ξR, ULSB, SLSDH, BAO-ULSB, BAO-SLSDH…) — giữ nguyên tuyệt đối.
- Kết luận (mục 6) — giữ nguyên 4 kết luận, chỉ sửa numbering hiển thị (i)-(iv), không đổi nội dung.

Thay đổi duy nhất mang tính "nội dung" nằm ngoài phạm vi thuần format là 2 việc đã được bạn duyệt trước (xóa ràng buộc g2, chèn hình sơ đồ quy trình) và việc rút gọn độ dài Tóm tắt/Abstract theo đúng yêu cầu ở mục 7 của bạn — không có số liệu, kết quả, hay kết luận khoa học nào khác bị thay đổi.
