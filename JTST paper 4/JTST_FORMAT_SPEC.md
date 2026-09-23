# JTST_FORMAT_SPEC.md

Đặc tả định dạng rút ra từ:
- `JTST_TemplatePaper_Vietnamese.docx` (MASTER TEMPLATE — nguồn chính, mọi giá trị số lấy trực tiếp từ XML của file này, không suy đoán)
- `JTST-2026-150202.pdf` và `JTST-2026-150211.pdf` (2 bài đã xuất bản — dùng để đối chiếu cách template được áp dụng thực tế khi có mâu thuẫn hoặc khi template để trống)

Mọi giá trị twips/EMU dưới đây được đọc trực tiếp từ `word/document.xml`, `word/styles.xml`, `word/header*.xml`, `word/footer*.xml` của template (đơn vị: 1440 twip = 1 inch; 1 cm ≈ 566,9 twip).

---

## 1. Trang & lề (Page setup)

Khổ trang: **Letter** — `w:pgSz w:w="12240" w:h="15840"` (8.5in × 11in). Template dùng khổ Letter, không phải A4 — giữ nguyên theo template dù tạp chí VN thường dùng A4, vì đây là số đo thật trong file `.docx` gốc.

Template dùng **nhiều section (continuous section breaks)**, đổi lề/số cột theo từng vùng nội dung:

| Vùng nội dung | Số cột | top | bottom | left | right | header | footer |
|---|---:|---:|---:|---:|---:|---:|---:|
| Trang đầu: Title + bảng Từ khóa/Tóm tắt | 1 | 1134 | 1134 | 1418 | 851 | 709 | 709 |
| Thân bài (2 cột) | 2 (space=284) | 1134 | 1134 | 1418 | 851 | 709 | 709 |
| Vùng cần full-width (bảng rộng, hình rộng) | 1 (continuous) | 1134 | 1134 | 1701 | 1134 | 709 | 709 |
| Vùng đóng (Declarations → References → khối tác giả cuối) | 1 (continuous) | 1134 | 1134 | 1701 | 851 | 709 | 709 |

Quy tắc kế thừa header/footer theo chuẩn OOXML: chỉ section đầu tiên và section thân bài 2 cột khai báo `headerReference`/`footerReference`; các section break "continuous" xen giữa (để mở rộng bảng/hình) **không** khai báo lại — chúng tự kế thừa header/footer của section liền trước. Đây không phải thiếu sót, mà đúng cách template gốc làm.

---

## 2. Header / Footer

- **header1.xml** (dùng cho section 1 — trang đầu): banner tạp chí — dòng "Tập …-Số … (20…)", "Tạp chí Khoa học công nghệ Giao thông vận tải / Journal of Transportation Science and Technology", "Trang tạp chí: https://tapchicongnghegtvt.vn" + 2 ảnh logo, có hyperlink tới trang tạp chí.
- **header2.xml** (dùng cho thân bài 2 cột, các trang sau): **để trống hoàn toàn** trong template gốc. Đối chiếu 2 bài đã xuất bản: trang sau có header dạng "tên tác giả (trái) + tên rút gọn bài báo in nghiêng", nhưng đây là phần **biên tập/tòa soạn bổ sung khi dàn trang xuất bản**, tác giả không tự điền. → Giữ header2 trống đúng như template, không tự bịa nội dung.
- **footer1.xml**: chỉ chứa số trang (page number field). Áp dụng cho toàn bộ tài liệu (kế thừa xuyên suốt, không cần khai báo lại ở các section sau).
- DOI, ngày nhận/duyệt bài, pISSN/eISSN: đây là các trường do tòa soạn điền sau khi bài được chấp nhận — **không tự bịa số DOI/ngày tháng**. Giữ nguyên dạng placeholder chuẩn của template (`https://www.doi.org/10.55228/`, `Received:...; Accepted:...`, `pISSN: 1859-4263; eISSN: 3030-4261`) ở cuối khối abstract, KHÔNG điền số liệu giả.

---

## 3. Trang đầu — bố cục logic

Đối chiếu 2 bài đã xuất bản, thứ tự thực tế trên trang 1 là:

1. Banner tạp chí (header1)
2. Title tiếng Việt
3. Title tiếng Anh (in nghiêng, ngay dưới)
4. **Tên tác giả** (có số mũ đơn vị + dấu `*` tác giả liên hệ)
5. **Đơn vị công tác** (in nghiêng, đánh số mũ tương ứng)
6. Bảng 2 cột Từ khóa/Tóm tắt (VN rồi EN)
7. Footnote cuối trang: tác giả liên hệ + email
8. DOI / ngày nhận-duyệt / ISSN

**Lưu ý quan trọng — khác biệt giữa template gốc và thực tế xuất bản:** Trong file `JTST_TemplatePaper_Vietnamese.docx` gốc, khối tên tác giả/đơn vị/email chỉ xuất hiện **một lần duy nhất, ở cuối tài liệu** (sau References), không có ở trang đầu — đây là cách trình bày kiểu "ẩn danh khi phản biện" (blind review). Nhưng cả 2 bài đã xuất bản đều đặt tên tác giả **ngay sau tiêu đề** ở trang 1 (và KHÔNG lặp lại dạng đầy đủ ở cuối, chỉ có khối tiếng Anh ngắn gọn trước References). Theo chỉ định trực tiếp của người dùng (mục 6 yêu cầu), bản FINAL sẽ đặt **tên tác giả + đơn vị công tác ngay sau 2 tiêu đề** (giống bài đã xuất bản), đồng thời vẫn giữ khối tiếng Anh rút gọn trước References (đúng như 2 bài mẫu đều làm).

### Tỷ lệ cột bảng Từ khóa/Tóm tắt

Đọc trực tiếp từ `w:tblGrid` của template: `gridCol w="1987"` (cột trái, Từ khóa) + `gridCol w="8044"` (cột phải, Tóm tắt/Abstract), tổng `tblW=10031` dxa, `type="dxa"` (fixed layout).

- 1987 twip ≈ **3,50 cm**
- 8044 twip ≈ **14,19 cm**

→ Xác nhận đúng tỷ lệ người dùng nêu (~3,5 cm : ~14,2 cm), lấy từ số đo thật, không suy đoán. Bảng trong `JTST_Bai bao Kh.docx` hiện đang chia đều 4985:4985 (50/50) — SAI, cần sửa lại đúng 1987:8044.

---

## 4. Title

- Font: **Cambria**, cỡ **15pt** (`w:sz="30"`, đơn vị half-point) cho cả 2 dòng (VN và EN).
- **Không bold, không italic** trên cả 2 dòng — template chỉ có `w:bCs/` (bold cho complex-script) chứ không có `w:b/` (bold cho Latin), tức về mặt hiển thị là **không in đậm**.
- Căn lề: `w:jc w:val="both"` (justify) — với một dòng/đoạn duy nhất, hiệu ứng hiển thị tương đương căn trái. Bản `JTST_Bai bao Kh.docx` hiện tại dùng `center` + title VN in đậm + title EN in nghiêng → cần sửa về đúng template (bỏ bold/italic, đổi jc→both).
- Khoảng cách: `spacing after=0` (dòng title VN), `after=120` (dòng title EN), `line=276 auto`.

---

## 5. Author / Affiliation (theo quyết định mục 3 ở trên)

Đặt ngay sau 2 dòng tiêu đề, theo đúng cách 2 bài mẫu trình bày:
- Dòng tên tác giả: mỗi tên có số mũ đơn vị (`w:vertAlign="superscript"`), dấu `*` sau tên tác giả liên hệ.
- Dòng đơn vị công tác: in nghiêng, đánh số mũ tương ứng, mỗi đơn vị một dòng.
- Footnote cuối trang 1 (style `FootnoteText`, Cambria 9pt): `*Tác giả liên hệ. <Đơn vị>.` + dòng `Email: <email>` (Cambria 9pt, in nghiêng theo mẫu).
- Khối tiếng Anh rút gọn (tương tự 2 bài mẫu) vẫn giữ ở cuối bài, ngay trước "Tài liệu tham khảo", dạng bảng 1 ô viền đơn giống template gốc.

---

## 6. Heading

Style: **`ICST-Introduction`** — dùng cho MỌI heading cấp 1 dạng "N. Tên mục" (vd "1. Giới thiệu", "4. Thiết lập bài toán tối ưu"). Font Cambria, cỡ 11pt, và cho heading phụ cấp 2 dạng "N.N Tên mục" style vẫn là `ICST-Introduction` nhưng thêm in đậm + in nghiêng trực tiếp trên run (không có style `ICST-Heading2` riêng trong template này). Không có heading cấp 3 riêng trong bài (bài chỉ dùng 2 cấp: N. và N.N).

**Lưu ý đặt tên style dễ nhầm:** style `ICST-Heading1` trong template này **KHÔNG dùng cho heading** — nó được dùng cho các đoạn **thân bài (body text)** ngay sau heading trong file mẫu gốc. Đây là cách đặt tên style nội bộ hơi gây nhầm lẫn của template nhưng là dữ kiện thật đọc từ XML, không phải suy đoán — khi áp dụng cần dùng đúng theo dữ kiện này chứ không theo tên gọi.

Numbering: numbering thủ công bằng text ("1.", "1.1.", "4.6.") có sẵn trong nội dung, không dùng danh sách numbering tự động của Word (không có `<w:numPr>` gắn với các heading này) → giữ nguyên cách đánh số thủ công đã có trong bài, không đổi sang auto-numbering.

---

## 7. Body text

- Font: **Cambria**, không có `w:sz` tường minh ở style `Normal` cấp body thường (kế thừa cỡ mặc định 11pt của style Normal), thụt đầu dòng `firstLine=284` twip (~0,2in) cho đoạn văn thường, `jc="both"` (justify).
- Danh sách gạch đầu dòng: style `ICST-Bulletedlist`, cỡ 10pt, `hanging=170`, `left=397`.
- Danh sách đánh số dạng "(i)/(ii)/(iii)": style `ICST-Listnumbered`, cỡ 10–11pt, cùng kiểu hanging indent.
- Không dùng Arial cho body text (template không dùng Arial ở bất kỳ đâu trong nội dung chính; Arial chỉ xuất hiện ở style `ICST-Tabletext`/`ICST-Captions` khai báo nhưng bị **ghi đè bằng Cambria trực tiếp trên từng run thật** trong toàn bộ ví dụ của template — tức nội dung thực tế luôn hiển thị Cambria, không phải Arial).

---

## 8. Equations

Template trình bày công thức bằng **bảng 2 cột không viền** (không phải Word Equation/OMML): cột trái chứa công thức (trong template gốc là ảnh WMF do dùng Equation Editor cũ; trong `JTST_Bai bao Kh.docx` hiện tại công thức đã được gõ dạng text thường trong ô bảng), cột phải chứa số thứ tự `(n)` căn phải. Bảng không có `tblBorders` (ẩn viền).

Quyết định áp dụng cho bài đang format: **giữ nguyên cách trình bày công thức dạng bảng 2 cột (text + số thứ tự bên phải) đã có sẵn trong `JTST_Bai bao Kh.docx`** — đây là cách gõ công thức duy nhất template hỗ trợ sẵn (không có OMML mẫu thật để tái sử dụng, ảnh WMF gốc cũng chỉ là ảnh chụp công thức không tái tạo được nội dung công thức mới). Không đổi ký hiệu (f1, f2, ηmax,true, x1…x4, ξR…), chỉ chỉnh: căn giữa công thức trong ô trái, số `(n)` căn phải trong ô phải, font Cambria, màu đen, bỏ viền bảng nếu đang hiện viền.

---

## 9. Figures

- Caption: **`Hình N.`** in đậm, theo sau là mô tả không in đậm, cỡ **10pt**, căn giữa (`jc="center"`), đặt **NGAY DƯỚI hình** (không đặt trên).
- Hình căn giữa trang, không vượt khổ text.
- Đối chiếu 2 bài mẫu: hình rộng (biểu đồ, sơ đồ) được đặt trong vùng single-column (full width trang) — khớp với cách template xử lý hình rộng trong ví dụ mẫu (Hình 2 mẫu đặt trong section riêng, không co vào 1 cột hẹp).

---

## 10. Tables

- Caption: **`Bảng N.`** in đậm + mô tả, cỡ **10pt**, đặt **NGAY TRÊN bảng** (ngược chiều với hình).
- Viền bảng kiểu "three-line/booktabs": `tblBorders` chỉ khai báo viền **trên** và **dưới** toàn bảng (`single, sz=6`); dòng phân cách ngay dưới hàng tiêu đề được tạo bằng border riêng cho từng ô hàng tiêu đề (`single, sz=4`) — **không có viền dọc, không có viền ngang giữa các hàng dữ liệu**.
- Font nội dung ô bảng: Cambria, cỡ **10pt** (`sz="20"` half-point), số liệu căn giữa.
- Bảng rộng (>3 cột hoặc cột chứa văn bản dài) cần đặt trong vùng single-column (xem mục 1) để không bị bó hẹp trong 1 cột của layout 2 cột thân bài.

---

## 11. References

- Heading "Tài liệu tham khảo" dùng style `ICST-Introduction`.
- Từng mục `[n] …` dùng font Cambria, cỡ **10pt**, không thụt lề kiểu hanging đặc biệt trong template gốc (đoạn văn thường, justify).
- Định dạng theo IEEE (đã đúng trong bài hiện tại) — **giữ nguyên toàn bộ nội dung/tên tài liệu tham khảo hiện có, không thêm/bớt/đổi thứ tự**, chỉ chỉnh font/size/spacing cho khớp style `ICST-Introduction`/body 10pt.

---

## 12. Declarations & khối đóng bài (thứ tự chuẩn theo 2 bài mẫu + template)

1. (Nếu ≥2 tác giả) "Đóng góp của các tác giả trong bài báo"
2. "Tuyên bố không xung đột lợi ích và cam kết bản quyền" — câu chuẩn: *"Các tác giả tuyên bố về sự không xuất hiện những xung đột tiềm ẩn từ nghiên cứu này, và cam kết bài báo chưa từng được công bố trước đây."*
3. "Chia sẻ dữ liệu theo yêu cầu"
4. (Tuỳ chọn, chỉ nếu có nội dung thật) "Lời cảm ơn" — 2 bài mẫu đã xuất bản **không có mục này**; template để mục này ở dạng tuỳ chọn. Nếu không có thông tin tài trợ thật, **bỏ hẳn mục này** thay vì để placeholder.
5. Khối tác giả tiếng Anh rút gọn (bảng viền đơn, mỗi tác giả 1 dòng, `*Corresponding author: email`).
6. "Tài liệu tham khảo"

---

## 13. Các mục KHÔNG được tự quyết — chuyển sang NEEDS REVIEW

- Nội dung thật của "Đóng góp của các tác giả trong bài báo" (ai làm Methodology/Formal analysis/Writing…) — file nguồn chỉ có placeholder `[TO BE VERIFIED]`, không có dữ kiện thật.
- Có/không có "Lời cảm ơn" và nguồn tài trợ thật (nếu có) — file nguồn chỉ có placeholder.
- Số DOI, ngày nhận/duyệt bài, số Tập/Số — do tòa soạn cấp sau khi duyệt, không tự bịa.

---

## 14. Vấn đề khoa học đã được người dùng quyết định xử lý (không thuộc phạm vi "tự ý sửa nội dung")

- **Ràng buộc g2 (Umax ≤ L/240 ≈ 0,0217 m):** người dùng đã xác nhận **bỏ ràng buộc g2 khỏi bài báo** (số liệu Umax=0,0487–0,0491m của 3 nghiệm A/B/C vượt xa ngưỡng quy ước này — mâu thuẫn chưa xác minh được nêu trong file nguồn). Xử lý: xóa dòng g2 khỏi bảng ràng buộc (mục 4.3), sửa câu dẫn "gj(x) ≤ 0, j = 1,…,4" cho khớp còn 3 ràng buộc (g1, g3, g4), giữ nguyên số liệu Umax đã báo cáo (Bảng 2, mục 5.6) như một đại lượng mô tả, không gắn với ràng buộc bị loại bỏ.
- **Hình sơ đồ quy trình MOSFOA–MATLAB–SAP2000 (mục 2.3):** file nguồn chỉ có ghi chú ngoặc vuông yêu cầu tự vẽ, chưa có ảnh. Đã tạo hình thật (`code/results/Hinh_sodoquytrinh.png`) từ đúng 6 bước liệt kê sẵn trong văn bản (không thêm bước mới), chèn làm **Hình 1**, đánh số lại 3 hình còn lại (cũ Hình 1/2/3 → mới Hình 2/3/4).
- **Bảng đối chiếu search vs. verified (mục 5.7):** có trong nội dung nhưng chưa có caption "Bảng N." — bổ sung caption "Bảng 3." (đánh số tiếp theo Bảng 1, Bảng 2) theo đúng quy định "mọi bảng phải có caption đánh số liên tục", không thêm/bớt số liệu trong bảng.
