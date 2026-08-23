# BÀN GIAO SANG PHIÊN MỚI (MÁY PC) — Paper 1

**Ngày:** 22/08/2026. Phiên trước chạy trên laptop, dừng lại để chuyển qua máy PC (chạy SAP2000 OAPI liên tục). Phiên mới trên PC **không có trí nhớ của phiên laptop** — mọi thứ cần biết đã ghi vào các file trong thư mục này. Đọc file này trước, không cần hỏi lại các mục "ĐÃ KHÓA".

---

## 1. Đọc gì trước

1. `PAPER_1_DE_CUONG_CHI_TIET.md` — đề cương đầy đủ, mọi quyết định đã khóa (title, RQ, 192/178/14 cọc, 4 phương pháp, BAO KT, §27 quy định JMST...).
2. `Paper1_JMST_Draft_v1.md` — bản thảo đang viết (DRAFT v5). Đọc khối comment `<!--...-->` ở đầu file trước — nó tóm tắt chính xác cái gì đã xong, cái gì chưa.
3. `DOI_CHIEU_CONG_THUC_M1_M6_FINAL.md` — công thức M1–M6 đã đối chiếu ảnh gốc (M4/M5 không dùng, chỉ để tham khảo).
4. File này (mục 3 dưới) — việc cần làm tiếp và các "gotcha" kỹ thuật đã phát hiện.

## 2. Trạng thái tóm tắt

- **Phạm vi đã khóa: 4 phương pháp — M1 (22TCN 207-92), M2 (20TCN21-86/TCXD 205-1998), M3 (TCVN 10304:2014), M6 (Nhật Bản 2002).** Đã bỏ M4 (Nga) và M5 (Budin–Demina) — thiếu căn cứ số liệu (quyết định người dùng 22/08/2026). Không bàn lại.
- Đã tính `h_z`/`l_tt` cho 178 cọc theo cả 4 phương pháp bằng công thức + dữ liệu hình học/tải trọng thật (không phải chạy SAP) — kết quả ở `pile_hz_ltt_results_ALL.csv`, thống kê ở `table5_ltt_statistics.csv`, đã đưa vào Bảng 5 trong draft §5.1.
- **Việc CHƯA làm — đây là việc chính của phiên PC**: dựng 4 mô hình SAP2000 sensitivity thật (đổi vị trí điểm ngàm — tức đổi hình học chân cọc — của 178 cọc theo từng phương pháp), chạy phân tích, trích `U_X`, `U_Y`, `M_max`, `V_max`, tính `S_R`, điền vào draft §5.2–§6.

## 3. Dữ liệu nền đã có sẵn (không cần làm lại)

| File | Nội dung |
|---|---|
| `pile_master_table.csv` | 192 cọc, lấy trực tiếp từ `Ben 100.000DWT KT.s2k` gốc — frame ID, loại cọc, tọa độ đỉnh/đáy, chiều dài FEM, độ xiên, spring K33, treatment/control |
| `pile_hz_input_table.csv` | 178 cọc treatment — giao điểm mái dốc (`Y_s`,`Z_s`), `H0`, đặc trưng tiết diện D/t/E/I/b |
| `pile_P_per_direction.csv` | Lực ngang `P_X`, `P_Y` per cọc, trích từ envelope `BAO KT` tại **đỉnh cọc** (xem gotcha #2 dưới) |
| `pile_hz_ltt_results_ALL.csv` | `l_tt` theo M1/M2/M3/M6 cho 178 cọc (kết quả công thức, đã xong) |
| `pile_coordinates_extracted.csv` | Tọa độ theo nhãn hàng-cột A1,B2... từ bản vẽ Excel — chỉ để đối chiếu bản vẽ, không cần cho tính toán |

## 4. Việc cần làm tiếp — dựng & chạy 4 mô hình SAP2000

### Ý chính
Đổi phương pháp fixity = đổi **vị trí chân cọc** (tọa độ 3D điểm đáy, dọc theo trục cọc hiện có, tại khoảng cách `l_tt` mới tính từ đỉnh) cho 178 cọc treatment, theo từng phương pháp M1/M2/M3/M6, rồi chạy lại phân tích với đúng envelope `BAO KT`.

### Chiến lược đã xác định (quan trọng — xem gotcha #1)
**Mở file model gốc CHỈ 1 LẦN**, giữ SAP2000 chạy suốt, lặp qua 4 phương pháp trong cùng phiên (sửa → phân tích → trích kết quả → khôi phục tọa độ gốc → sang phương pháp kế) rồi mới đóng 1 lần ở cuối. Không mở lại file nhiều lần.

### Các bước gợi ý
1. Với mỗi cọc treatment (từ `pile_hz_input_table.csv` + `pile_hz_ltt_results_ALL.csv`): tính tọa độ 3D mới của chân cọc = điểm trên trục cọc (đã biết từ `top_X/Y/Z`, `bot_X/Y/Z` trong `pile_master_table.csv`) tại khoảng cách `l_tt` (theo phương pháp đang xét) tính từ đỉnh, dọc theo hướng trục cọc hiện có (dùng vector đơn vị `(top-bot)/|top-bot|`).
2. Dùng OAPI di chuyển joint đáy cọc (`PointObj`/`EditPoint`, hoặc xóa-tạo lại frame với joint mới) tới tọa độ mới — cần giữ nguyên spring/restraint assignment tại joint đó (SAP có thể tự giữ assignment theo joint khi di chuyển, cần kiểm tra bằng test nhỏ trước).
3. Unlock model (`SapModel.SetModelIsLocked(False)`), áp thay đổi, chạy `Analyze.RunAnalysis()`.
4. Trích `U_X`, `U_Y` (chuyển vị đỉnh bến) và `M_max`, `V_max` (nội lực 178 cọc) cho envelope `BAO KT` — dùng `AnalysisResults` API, hoặc đơn giản hơn: export bảng text rồi parse bằng cách đã dùng cho `pile_P_per_direction.csv` (ripgrep + Python, đã chứng minh nhanh/ổn định).
5. Ghi lại kết quả 4 phương pháp + BASE (mô hình gốc, không đổi gì) → tính `S_R` → điền Bảng 6, §5.2–5.4, §6 trong draft.
6. Khôi phục tọa độ chân cọc về gốc trước khi chuyển sang phương pháp kế tiếp (hoặc dùng joint mới riêng cho mỗi phương pháp nếu đơn giản hơn — cân nhắc).

## 5. GOTCHA kỹ thuật đã phát hiện (đọc kỹ trước khi làm)

1. **Mở file model gốc (2,4GB) qua OAPI mất ~50 phút** (đã đo thực tế: 11:12→12:01). Không phải lỗi — file rất lớn. Đây là lý do phải mở 1 lần, không mở lại nhiều lần.
2. **`JointI` luôn là ĐÁY cọc, `JointJ` luôn là ĐỈNH** trong file model này (không phải quy ước thường gặp ngược lại) — đã xác nhận qua so khớp `pile_master_table.csv`. Khi trích lực trong bảng kết quả, `Station=0` là ĐÁY, phải lấy `Station=Length` (giá trị max) để có lực ở ĐỈNH.
3. **SAP2000 OAPI ProgID đúng trên máy này**: `SAP2000v1.Helper` + `CreateObjectProgID("CSI.SAP2000.API.SapObject")` — KHÔNG phải `SAP2000v14.Helper`/`CSI.SAP2000v14.SapObject` (không tồn tại, sẽ lỗi "Class not registered"). `ApplicationStart` cần đủ 3 tham số: `(eUnits, bool Visible, string FileName)` — dùng `[SAP2000v1.eUnits]::Ton_m_C` (model gốc đơn vị Tonf-m-°C). `GetVersion` cần 2 tham số `[ref]` (version string + build number), không phải 1.
4. **KHÔNG dùng Word COM automation** cho bất kỳ việc gì trong dự án này — đã thử 6+ cách (ExportAsFixedFormat, SaveAs2 PDF/docx, clipboard EMF...), Word treo vô hạn ở MỌI bước lưu/export trên máy laptop. Đọc text (`.Content.Text`, `Find.Execute`) thì vẫn nhanh/ổn — chỉ save/export là vấn đề. Nếu máy PC cũng dùng Word COM, thử lại từ đầu, đừng giả định sẽ treo giống laptop.
5. **Trích dữ liệu từ file `.s2k` lớn**: dùng `ripgrep` (lệnh `rg`, hoặc tool Grep) với pattern bám nội dung dòng (ví dụ `^   Joint=\d+   CoordSys=GLOBAL...`), KHÔNG dùng `awk`/`grep` thường quét tuần tự (quá chậm trên file 2,4GB — từng bị treo/timeout). Luôn kiểm tra count kết quả khớp số liệu đã biết (192 cọc, 178 spring, 14 restraint...) trước khi tin dữ liệu.
6. **pandas/xlrd không có sẵn** trên Python hệ thống — cần `pip install pandas xlrd openpyxl` trước khi đọc `.xls`. Python ở `C:\Users\Admin\AppData\Local\Programs\Python\Python311\python.exe`.
7. Có **15/178 cọc** (tại Y=−21m, gần bờ) mà giao điểm mái dốc tuyến tính `z_s≈−0,335Y−7,84` tính ra nằm ngoài đoạn cọc mô hình (lệch ~14,5cm) — xem `pile_hz_input_table.csv` cột `on_segment=False`. Sai số nhỏ, có thể dùng tạm giá trị đã tính, nhưng nên xử lý (ví dụ lấy luôn đáy cọc làm giao điểm quy ước) trước khi công bố số liệu cuối.

## 6. Nguyên tắc không đổi (nhắc lại từ đề cương, để không bị lệch)

- Chỉ đổi fixity của 178 cọc treatment; 14 cọc control giữ nguyên tuyệt đối.
- Không đổi geometry/material/loads giữa các mô hình — chỉ đổi vị trí chân cọc treatment theo `l_tt`.
- Governing envelope: `BAO KT` (Max/Min), cả 2 phương X/Y.
- `S_R` dùng trị tuyệt đối: `S_R = (|R_max|−|R_min|)/|R_min| × 100%`.
- Không kết luận phương pháp nào "tốt nhất" — chỉ định lượng độ nhạy.
