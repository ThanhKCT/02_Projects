# Kinh nghiệm từ dự án MOFDA "Cầu tàu container 100.000 DWT" — tổng hợp lỗi đã gặp để rút kinh nghiệm cho dự án sau

> Viết sau khi dự án đã hoàn thành (tối ưu đa mục tiêu tiết diện cọc bằng MOFDA, đối chiếu 243 tổ hợp brute-force, bài báo JMST đã hoàn thiện qua 3 vòng góp ý). File này **không lặp lại** những gì đã ghi ở các file dưới đây — chỉ ghi những gì MỚI phát sinh, đặc biệt là giai đoạn hoàn thiện bài báo (phần chưa có file nào ghi lại). Đọc các file sau **trước**, rồi mới đọc file này:
> - [Cach ket noi_SAP2000_MATLAB_OPTIMIZATION.md](Cach%20ket%20noi_SAP2000_MATLAB_OPTIMIZATION.md) — kinh nghiệm gốc SAP2000↔MATLAB (COM automation, `-r` vs `-batch`, checkpoint/watchdog...), dùng chung mọi dự án.
> - [PHUONG_AN_CHAY_CAMPAIGN_MOFDA_SAP2000.md](PHUONG_AN_CHAY_CAMPAIGN_MOFDA_SAP2000.md) — phương pháp quyết định brute-force-hay-metaheuristic, khung file tái sử dụng cho MOFDA.
> - [Wharf100DWT/README.md](Wharf100DWT/README.md) — nhật ký lỗi thật đã gặp khi code/chạy thử (W.1 `readtable` crash, W.2 `-batch` crash, đo thời gian thật ~90s/lần gọi...).
> - `Tap chi XD_SFOA/KE SAU CAU/Kinh nghiem SFOA.md` (dự án khác, cùng tác giả) — các bug watchdog/`.sdb`/docx-editing khác đã gặp ở dự án song song, đáng đọc chéo vì nhiều bug COM automation là dùng chung.

---

## 1. Quyết định brute-force sớm — bài học đắt giá nhất, đã ghi ở file khác nhưng đáng nhắc lại

Ban đầu định chạy MOFDA Np=50×maxit=100 (~25.000 lần đánh giá, ước tính ~4,6 ngày) trước khi nhận ra không gian rời rạc thực tế của bài toán chỉ có **3×9×9 = 243 tổ hợp** — brute-force giải xong trong **71 phút** với 8 tiến trình song song, cho mặt Pareto THẬT (đúng 100%) thay vì một mặt Pareto xấp xỉ từ metaheuristic. **Luôn tính tích số lựa chọn của từng biến thiết kế TRƯỚC khi chọn quy mô thuật toán/cam kết thời gian chạy** — xem sơ đồ quyết định đầy đủ ở `PHUONG_AN_CHAY_CAMPAIGN_MOFDA_SAP2000.md` mục 0.

---

## 2. Chỉnh sửa bài báo `.docx` qua XML trên máy Windows không có LibreOffice/`zip` — bài học MỚI (chưa có ở file nào khác)

Bối cảnh: bài báo JMST gốc (`.docx` thật, không phải Markdown) phải sửa qua 3 vòng góp ý liên tiếp (đổi mục 4.3, thêm Bảng 3, sửa ràng buộc/hàm phạt/kết luận, rồi 5 chỉnh sửa nhỏ cuối) — mỗi vòng là unzip → sửa `document.xml` bằng string-replace chính xác → rezip → validate → render kiểm tra trực quan.

### 2.1. Máy này KHÔNG có lệnh `zip` trong Git-Bash — phải tự viết script Python thay thế

Lệnh `zip -Xr out.docx .` trong hướng dẫn của skill `docx` báo lỗi `zip: command not found` trên máy này (khác giả định của skill). **Cách sửa**: viết một script Python nhỏ dùng module `zipfile` chuẩn (luôn có sẵn) để nén lại thư mục đã unzip thành `.docx`:
```python
import zipfile, os
with zipfile.ZipFile(out_path, "w", zipfile.ZIP_DEFLATED) as zf:
    for root, dirs, files in os.walk(src_dir):
        for name in files:
            full = os.path.join(root, name)
            rel = os.path.relpath(full, src_dir).replace(os.sep, "/")
            zf.write(full, rel)
```
**Bài học tổng quát**: trên máy Windows mới, đừng giả định `zip`/`unzip`/`soffice`/`pdftoppm` đều có sẵn như hướng dẫn skill mặc định — kiểm tra từng lệnh (`command -v ...`) trước, và chuẩn bị sẵn thay thế bằng Python (`zipfile` luôn có, không cần cài thêm).

### 2.2. `python -c "print(...)"` với văn bản tiếng Việt qua Bash trên máy này CRASH vì console dùng cp1252

**Hiện tượng**: `PYTHONIOENCODING` mặc định không phải UTF-8 trên Git-Bash/Windows này — bất kỳ script Python nào `print()` chuỗi có dấu tiếng Việt ra stdout đều bay lỗi `UnicodeEncodeError: 'charmap' codec can't encode character...`, dù chuỗi đọc từ file UTF-8 hoàn toàn hợp lệ.
**Cách sửa**: luôn set `PYTHONIOENCODING=utf-8` trước lệnh `python` khi script có in tiếng Việt ra console (`PYTHONIOENCODING=utf-8 python script.py`). Khi cần xem một đoạn XML/text dài có tiếng Việt để đối chiếu, **ghi ra file rồi dùng tool Read** (xử lý UTF-8 đúng, không qua console) thay vì cố in ra Bash — an toàn và không giới hạn độ dài như console.
**Bài học tổng quát**: trên máy Windows chưa xác nhận locale console, mặc định coi in tiếng Việt/Unicode ra Bash là rủi ro — ghi file trung gian rồi Read là cách né an toàn nhất, không phải debug encoding mỗi lần.

### 2.3. Không có `soffice`/`pdftoppm` — nhưng PyMuPDF (`fitz`) đã có sẵn, dùng thay thế tốt hơn cả

Đã xác nhận từ dự án khác (`Kinh nghiem SFOA.md` mục 3.5): `soffice.py` của skill `docx` gọi `socket.AF_UNIX` không tồn tại trên Windows, luôn lỗi. Dự án này xác nhận thêm: **thay vì chỉ dừng ở Word COM xuất PDF rồi "gửi người dùng tự xem"**, máy này có sẵn **PyMuPDF** (`import fitz`), dùng để tự rasterize PDF thành PNG từng trang mà không cần Poppler:
```python
import fitz
doc = fitz.open("file.pdf")
for i in range(doc.page_count):
    doc[i].get_pixmap(dpi=150).save(f"page-{i+1:02d}.png")
```
Kết hợp với Word COM (`$doc.SaveAs([ref]$pdfPath, [ref]17)`) để xuất PDF trước, quy trình đầy đủ là: **sửa XML → rezip → Word COM mở + xuất PDF (xác nhận file không hỏng cấu trúc) → PyMuPDF render PNG từng trang → tự đọc ảnh bằng Read tool để kiểm tra trực quan trước khi gửi người dùng**, không cần LibreOffice/Poppler ở bất kỳ bước nào. **Luôn thử `import fitz` trước khi kết luận "máy này không xem trước được PDF"**.

### 2.4. Chèn 1 bảng mới vào bài báo 2-cột (kiểu tạp chí) đòi hỏi tái tạo đúng cấu trúc section-break 2-cột↔1-cột

Template JMST trình bày 2 cột, nhưng mỗi bảng/hình rộng lại nằm trong một "section" riêng 1 cột (dùng continuous section break) chèn giữa 2 section 2-cột. Muốn thêm Bảng 3 (bảng mới) đúng chỗ, không thể chỉ chèn `<w:tbl>` vào giữa văn bản — phải:
1. Tìm đúng mẫu 3 đoạn `<w:sectPr>` liên tiếp quanh Bảng 2 đã có sẵn (đóng section 2-cột → đóng section 1-cột chứa bảng → section 2-cột kế tiếp) để hiểu format `w:cols w:num="1"` / `w:num="2" w:space="340"`.
2. Chèn **2 đoạn `<w:sectPr>` mới** (1 đóng section 2-cột hiện tại ngay trước bảng mới, 1 đóng section 1-cột bao bảng mới) — **tái dùng nguyên mẫu `<w:sectPr>` đã có** (copy y hệt `pgSz`/`pgMar`/`docGrid`, chỉ đổi `w:cols`), không tự chế lại từ đầu.
3. Đoạn `<w:sectPr>` 2-cột NGAY SAU bảng cũ (đã có sẵn trong tài liệu, đóng phần thảo luận sau bảng) **giữ nguyên, không cần thêm** — nó tự động trở thành điểm đóng cho section mới sau khi chèn xong.
**Bài học tổng quát**: khi chèn nội dung rộng (bảng/hình) vào văn bản nhiều cột kiểu tạp chí, luôn tìm 1 bảng/hình TƯƠNG TỰ đã có sẵn trong CHÍNH tài liệu đó làm khuôn mẫu cấu trúc section-break, đừng tự suy đoán cú pháp `w:sectPr`/`w:cols`.

### 2.5. Xác nhận số lần xuất hiện (`count`) TRƯỚC MỌI lần thay thế chuỗi — không giả định duy nhất

Tài liệu không có `w14:paraId` để neo (khác dự án SFOA), nên mọi phép thay thế trong 3 vòng sửa (~30 lượt) đều dùng nguyên văn đoạn text làm `old_string`. Kỷ luật áp dụng nhất quán: **luôn `data.count(old_string)` và so với số lượng kỳ vọng TRƯỚC khi `.replace(...)`**, dừng ngay (assert) nếu không khớp — không có lượt nào bị sai trong cả 3 vòng nhờ kỷ luật này. **Bài học tổng quát**: khi không có anchor duy nhất kiểu `paraId`, count-then-replace-with-assert là kỹ thuật thay thế an toàn tương đương, miễn là áp dụng nghiêm ngặt cho MỌI lần sửa, không riêng những lần "nghi ngờ trùng lặp".

### 2.6. File nguồn `.docx` gốc có thể biến mất khỏi thư mục dự án giữa các phiên làm việc — không rõ nguyên nhân

`JMST V1.docx` (bản gốc trước khi sửa) tồn tại đầu phiên trước, nhưng đã biến mất khỏi thư mục dự án ở phiên sau (không phải do session này xoá) — may mắn không mất nội dung vì mỗi vòng sửa đều làm việc trực tiếp trên thư mục đã unzip (`docx_build/unpacked_v1/`) rồi rezip ra file mới (`V2`→`V3`→`V4`), không phụ thuộc file gốc còn tồn tại hay không. **Bài học tổng quát**: khi sửa `.docx` qua nhiều vòng/nhiều phiên, giữ nguyên 1 thư mục đã-unzip làm "nguồn chân lý" xuyên suốt (tiếp tục sửa trên chính nó, không unzip lại từ file gốc mỗi vòng) — nhờ vậy dự án này không bị ảnh hưởng dù file gốc biến mất ngoài ý muốn. Luôn báo cho người dùng biết ngay khi phát hiện 1 file quan trọng không còn tồn tại như mong đợi, thay vì im lặng bỏ qua.

---

## 3. Kỷ luật kiểm tra tài liệu tham khảo & thuật ngữ qua nhiều vòng góp ý

### 3.1. Không bịa thông tin trích dẫn — tra cứu thật qua Crossref API khi được yêu cầu "kiểm tra lại"

Tài liệu tham khảo [1] ban đầu ghi năm sai (2026 thay vì 2025 thật) và thiếu volume/issue/số bài/DOI (chỉ ghi tên đơn vị tác giả thay vì tên tạp chí thật). Khi người dùng yêu cầu "kiểm tra và bổ sung đầy đủ", đã dùng `WebSearch` tìm đúng bài báo thật rồi gọi trực tiếp `https://api.crossref.org/works/<DOI>` để lấy dữ liệu chuẩn (tên tạp chí, volume, issue, article number, ngày xuất bản) — **không suy đoán hay tự điền số liệu**. **Bài học tổng quát**: khi được yêu cầu hoàn thiện một trích dẫn khoa học, ưu tiên tra cứu Crossref/DOI resolver (dữ liệu có cấu trúc, đáng tin) hơn là chỉ đọc trang tóm tắt của nhà xuất bản (nhiều trang chặn `WebFetch` bằng 403).

### 3.2. Tài liệu tham khảo không được trích dẫn ở đâu trong bài — phải `grep` toàn bộ thân bài trước khi kết luận "giữ" hay "xoá"

[4] TCVN 11820-4-1:2020 nằm trong danh mục tham khảo nhưng **không xuất hiện dạng số ngoặc `[4]` lẫn tên đầy đủ tiêu chuẩn ở bất kỳ đâu trong thân bài** (kiểm bằng `data.count('11820-4-1')` trên toàn văn `document.xml`, chỉ ra đúng 1 lần — chính là trong danh mục tham khảo). Đã xoá và đánh số lại các mục sau ([5]→[4], [6]→[5]). **Bài học tổng quát**: trước khi xoá HAY giữ một tài liệu tham khảo nghi ngờ không dùng, luôn `grep`/đếm số lần xuất hiện của số hiệu tiêu chuẩn/tên tác giả đó trong TOÀN BỘ thân bài (không chỉ tin trí nhớ "hình như có nhắc"), và nhớ đánh số lại các mục phía sau khi xoá.

### 3.3. Cụm từ overclaim lặp lại rải rác nhiều nơi — mỗi vòng góp ý chỉ bắt được 1-2 chỗ, phải quét lại toàn văn mỗi vòng

Cụm "mặt Pareto tham chiếu **độc lập**" (hàm ý một mặt Pareto tách biệt/không phụ thuộc gì) xuất hiện ở ít nhất 4 vị trí khác nhau (Tóm tắt, Abstract, mục 3.4, kết luận (2)) nhưng góp ý ban đầu chỉ nêu ví dụ ở Tóm tắt — phải tự `data.count('độc lập')` và duyệt TỪNG kết quả để phân biệt đúng những chỗ thật sự cùng nghĩa "Pareto tham chiếu độc lập" (cần sửa) với những chỗ "độc lập" mang nghĩa khác không liên quan (ví dụ "biến độc lập", "8 tiến trình SAP2000 độc lập", "phương án tối ưu độc lập" — giữ nguyên). **Bài học tổng quát (giống mục 4.5 của `Kinh nghiem SFOA.md`, xác nhận lại lần nữa)**: khi người dùng chỉ ra 1 ví dụ cụ thể của một cụm từ cần sửa, luôn tự `grep`/đếm toàn văn cụm từ đó (không chỉ sửa đúng câu được trích dẫn) — nhưng đồng thời phải đọc ngữ cảnh từng kết quả trước khi sửa, vì cùng 1 từ khoá có thể mang nhiều nghĩa khác nhau trong cùng tài liệu.

### 3.4. Khi sửa 1 câu overclaim ở Tóm tắt tiếng Việt, nhớ rà cả Abstract tiếng Anh song song

Bài báo có Tóm tắt + Abstract riêng biệt diễn đạt cùng nội dung bằng 2 ngôn ngữ — góp ý chỉ trích dẫn câu tiếng Việt, nhưng câu tiếng Anh tương ứng ("an independent reference Pareto front") mang đúng vấn đề overclaim tương tự. Đã chủ động sửa đồng bộ cả 2 để nhất quán, dù góp ý không nêu rõ bản tiếng Anh. **Bài học tổng quát**: với tài liệu song ngữ, mọi thay đổi về nội dung/mức độ khẳng định ở 1 ngôn ngữ cần kiểm tra và đồng bộ hoá sang ngôn ngữ còn lại, không chỉ sửa đúng chỗ được trích dẫn.

### 3.5. Phân biệt đúng LOẠI tiêu chuẩn khi trích dẫn — tiêu chuẩn vật liệu khác tiêu chuẩn thiết kế kết cấu

TCVN 9245:2012 ("Cọc ống thép", đã xác nhận qua tra cứu web) là tiêu chuẩn **vật liệu/sản phẩm** (quy định mác thép, giới hạn chảy Fy theo từng mác), KHÔNG phải tiêu chuẩn thiết kế kết cấu thép (loại cung cấp công thức kiểm tra ứng suất/hệ số an toàn γM). Câu gốc "Fy = 3.150 kG/cm² theo bản vẽ thiết kế (TCVN 9245:2012)" đặt sau cả công thức kiểm tra ứng suất dễ khiến người đọc hiểu nhầm TCVN 9245:2012 là nguồn của cả công thức — sau khi bỏ "theo bản vẽ thiết kế", câu trích dẫn thu hẹp đúng phạm vi: chỉ gắn với giá trị Fy (vật liệu), không gắn với công thức thiết kế. **Bài học tổng quát**: khi trích dẫn 1 tiêu chuẩn ngay sau 1 công thức/giá trị, kiểm tra xem tiêu chuẩn đó thực sự là loại "vật liệu" hay "thiết kế/kiểm toán" — đặt trích dẫn đúng vị trí (ngay sau đại lượng nó thực sự cung cấp), tránh gắn cả câu.

---

## 4. Checklist rút gọn cho dự án MOFDA/bài báo tiếp theo

1. [ ] Đã tính tổng số tổ hợp khả dĩ trước khi chọn quy mô MOFDA/cam kết thời gian chạy — brute-force trước nếu ≤ vài nghìn tổ hợp (mục 1).
2. [ ] Trước khi sửa `.docx`: kiểm tra `command -v zip`/`soffice`/`pdftoppm` — nếu thiếu, dùng `zipfile` (Python) thay `zip`, PyMuPDF (`fitz`) + Word COM thay LibreOffice (mục 2.1, 2.3).
3. [ ] Mọi lệnh `python` có in tiếng Việt ra Bash: thêm `PYTHONIOENCODING=utf-8`, hoặc ghi ra file rồi Read thay vì in console (mục 2.2).
4. [ ] Khi chèn bảng/hình rộng vào văn bản nhiều cột: tìm 1 bảng/hình có sẵn làm khuôn mẫu `sectPr`/`w:cols`, không tự suy đoán (mục 2.4).
5. [ ] Mọi phép thay thế text trong `document.xml`: `count(old) == kỳ vọng` rồi mới `.replace(...)` — không giả định duy nhất (mục 2.5).
6. [ ] Làm việc xuyên suốt trên 1 thư mục đã-unzip cho nhiều vòng sửa, không phụ thuộc file `.docx` gốc còn tồn tại (mục 2.6).
7. [ ] Khi hoàn thiện tài liệu tham khảo: tra Crossref/DOI thật (không suy đoán), và `grep` xác nhận MỌI tài liệu trong danh mục thực sự được trích dẫn ở thân bài trước khi giữ/xoá (mục 3.1, 3.2).
8. [ ] Khi sửa 1 cụm từ overclaim theo ví dụ người dùng nêu: `grep` toàn văn cụm đó, đọc ngữ cảnh từng chỗ trước khi sửa hàng loạt, và đồng bộ cả 2 ngôn ngữ nếu có song ngữ (mục 3.3, 3.4).
9. [ ] Khi trích dẫn tiêu chuẩn ngay sau công thức/giá trị: xác nhận tiêu chuẩn đó là loại vật liệu hay thiết kế, đặt trích dẫn đúng phạm vi (mục 3.5).
