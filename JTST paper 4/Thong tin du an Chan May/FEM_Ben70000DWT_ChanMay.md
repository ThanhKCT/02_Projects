# Dữ liệu Mô hình FEM – Bến số 1, Cảng Chân Mây (Tiếp nhận tàu 70.000DWT giảm tải)
### (Tổng hợp phục vụ bài toán tối ưu SOO / MOO)

**Dự án:** Tính toán kiểm định Bến số 1 – Cảng Chân Mây – tiếp nhận tàu 70.000DWT giảm tải.
**Chủ đầu tư / Đơn vị quản lý khai thác:** Công ty Cổ phần Cảng Chân Mây.
**Ngày lưu file SAP2000 gốc:** 22/12/2023 (theo dòng tiêu đề export `.$2k`, đường dẫn máy tác giả: `C:\Users\Dell\Documents\CMB\Cang Chan May\Sap (TC moi)\...`).

> ⚠️ **Lưu ý khung dữ liệu quan trọng nhất:** Đây là bài toán **KIỂM ĐỊNH (capacity check)** một bến hiện hữu để tiếp nhận tàu 70.000DWT giảm tải chứ không phải hồ sơ **thiết kế mới** hoàn chỉnh. Ở phiên đầu, dự án được cho là **KHÔNG có file thuyết minh thiết kế** — nhưng ở phiên làm việc thứ hai (2026-09-11), người dùng đã cung cấp bổ sung **thuyết minh thiết kế bản vẽ thi công — sửa chữa 2023** (`thong tin du an\2. Thuyet minh TKBVTC_SC2023 - A3.docx`) và **6 file DXF** (convert từ CAD gốc). Cần lưu ý: thuyết minh này là hồ sơ **SỬA CHỮA hệ dầm/bản/bọc đầu cọc năm 2023-2024** (không phải thuyết minh thiết kế mới xây dựng ban đầu năm 2003), nhưng nó mô tả đầy đủ **hiện trạng công trình gốc** (kích thước, vật liệu, số lượng cọc theo từng phân đoạn, địa chất, tiêu chuẩn áp dụng) nên được coi là **nguồn quyền uy (authoritative) cao nhất** hiện có cho các số liệu hiện trạng/kết cấu gốc, dùng để đối chiếu và giải quyết phần lớn các mâu thuẫn đã phát hiện ở phiên trước (chi tiết xem mục 14).

**Nguồn dữ liệu đã đối chiếu chéo:**
| Nguồn | File | Công cụ đọc |
|---|---|---|
| Mô hình phân tích kết cấu | `Sap (TC moi)\Ben so 1 Chan May.$2k` (SAP2000 v16.0.0, đơn vị **Tonf, m, °C**) | Python (regex parser tự viết cho định dạng bảng text SAP2000, có xử lý dòng tiếp nối "continuation line") |
| Bảng tính tải trọng/thông số bến | `Thong so Ben 1 cang Chan May (22-12-2023).xls` (21 sheet) | Excel COM automation qua PowerShell (`xlrd` báo lỗi giải mã do font/định dạng cũ, đã chuyển sang COM) |
| **Thuyết minh thiết kế BVTC — Sửa chữa 2023** (★ nguồn quyền uy nhất) | `thong tin du an\2. Thuyet minh TKBVTC_SC2023 - A3.docx` (642 đoạn văn, 21 bảng) | Python `python-docx`, trích toàn văn theo thứ tự block (paragraph + table) |
| Bản vẽ CAD (DXF, convert từ DWG) | `thong tin du an\*.dxf` (6 file: bình đồ địa hình, mặt bằng lỗ khoan, mặt cắt địa chất, mặt bằng hiện trạng, 3 phần mặt bằng bố trí đệm/mối nối, chi tiết cọc D600) | Python `ezdxf`, trích riêng entity TEXT/MTEXT/ATTRIB (không đọc toàn bộ geometry) |
| Bản vẽ CAD gốc | `CAD\` (46 file `.dwg` gốc) | Không đọc trực tiếp — đã được thay thế bằng 6 file `.dxf` liên quan nhất do người dùng convert sẵn |

> **Kết luận về phạm vi mô hình (ĐÃ GIẢI QUYẾT ở phiên 2):** Thuyết minh xác nhận cầu chính có tổng cộng **508 cọc ống thép D700, chia làm 5 phân đoạn**: Phân đoạn I: 91 cọc; II: 94 cọc; III: 126 cọc; IV: 101 cọc; **V: 96 cọc**. Số cọc trong mô hình FEM (`.$2k`) là đúng **96 cọc** — khớp chính xác tuyệt đối với **Phân đoạn V**. Kết hợp với kích thước mô hình theo Y (~60m, trong khi 300m/5 phân đoạn ≈ 60m/phân đoạn) và các bản vẽ DXF "Mặt bằng bố trí đệm và mối nối" (có ghi rõ nhãn "PHÂN ĐOẠN (BLOCK) I/II/III/IV/V" cho từng đoạn cầu chính) ⇒ **kết luận: mô hình SAP2000 đang xét đại diện cho PHÂN ĐOẠN V (Block V) của cầu chính**, không phải toàn bộ 300m. Đây là kết luận có độ tin cậy cao (3 nguồn độc lập khớp nhau: số cọc thuyết minh, kích thước mô hình SAP, nhãn phân đoạn trên DXF).

---

## 1. Tổng quan kết cấu

| Thông số | Giá trị | Nguồn |
|---|---|---|
| Loại kết cấu | Bến nhô dạng cầu tàu trên cọc (open pier), gồm **cầu chính** + **cầu dẫn**, có trụ neo/đệm va rời (dolphin) | Excel "So lieu" |
| Cầu chính (main platform) — dài × rộng | 300,0 m × 24,0 m | Excel "So lieu" |
| Cầu chính — cao trình đỉnh bến | +3,50 m (Hải đồ) | Excel "So lieu" / "CD day" |
| Cầu chính — cao trình đáy bến phía biển | −12,50 m (Hải đồ) | Excel "So lieu" |
| Cầu chính — cao trình đáy bến phía bờ (đoạn 120m) | −6,50 m (Hải đồ) | Excel "So lieu" |
| Cầu dẫn (access trestle) — dài × rộng | 73,5 m × 13,2 m | Excel "So lieu" |
| Cầu dẫn — cao trình đỉnh | +3,50 m (Hải đồ) | Excel "So lieu" |
| Mực nước cao thiết kế (P1%) | +1,48 m (Hải đồ) | Excel "So lieu"/"CD day" |
| Mực nước thấp thiết kế (P98%) | +0,48 m (Hải đồ) | Excel "So lieu"/"CD day" |
| Mực nước trung bình (P50%) | +0,95 m | Excel "MT" |
| Cấp công trình | **Loại công trình hàng hải; Cấp quản lý: Cấp I; Cấp kỹ thuật: Cấp III** ✅ (mục 3, Thông tin chung) | Thuyết minh TKBVTC-SC2023 |
| Tuổi thọ thiết kế | Chưa xác định — thuyết minh sửa chữa 2023 không nêu tuổi thọ thiết kế công trình gốc (chỉ nêu mục tiêu "đảm bảo tuổi thọ công trình" một cách định tính) | Thuyết minh TKBVTC-SC2023 |
| Cấp động đất | ✅ **agR = 0,0434g** (Huyện Phú Lộc, TT. Phú Lộc — TCVN 9386:2012, Phụ lục H; xác định thay cho ag=0,0368g sai địa điểm trong Excel) — Cấp VI theo thang MSK-64 (không đổi so với phân loại cũ vì 0,0434g vẫn nằm trong dải >0,03–0,06) | TCVN 9386:2012 Phụ lục H (địa điểm xác nhận bởi Thuyết minh) — quyết định người dùng, phiên 3 |

**Tàu thiết kế (Bảng 2-1, Excel "CD day"):**
| Loại tàu | Trọng tải | L/LOA (m) | B (m) | LPP (m) | Tc/Tkt mớn nước đầy tải (m) | T0 mớn không tải (m) |
|---|---|---|---|---|---|---|
| Tàu 3.000DWT (đỗ phía trong) | 3.000 DWT | 94 | 13,5 | 88,09 | 5,7 | 2,71 |
| Tàu container 165.000 DWT (~12.000 TEU) | 165.000 DWT | 398 | 56,4 | 376 | 15,0 | 9,52 |
| **Tàu 70.000 DWT giảm tải** (tàu tính toán chính) | 70.000 DWT | 231 | 32,3 | 221 | 11,6 | 7,56 |
| Sà lan 160 TEU | — | 77 | 15,2 | 73,2 | 4,1 | 2,38 |
| Tàu/sà lan 5.000 DWT | 5.000 DWT | 98 | 16,2 | — | 5,4 | 3,21 |

Chiều dài bến yêu cầu Lb = 1,15×Lt(max phục vụ) = 1,15×231 = 265,65m ≤ 300m thực tế ⇒ đạt yêu cầu cho tàu 70.000DWT (Excel "CD day", mục 4).

> **Ghi chú đối chiếu với thuyết minh TKBVTC-SC2023:** Thuyết minh sửa chữa 2023 (Chương III, mục 1.2) liệt kê đội tàu thiết kế/khai thác **khác** với bảng trên: tàu tổng hợp 30.000DWT (L=186m,B=27,1m,Tc=10,9m), tàu khách Super Star Leo (L=268m,B=32,2m,Tc=8,1m), tàu 50.000DWT (L=200m,B=32,2m,Tc=11,6m), tàu tổng hợp 3.000DWT (L=94m,B=13,5m,Tc=5,7m — khớp hàng "Tàu 3.000DWT" trong bảng trên), và 2 tàu khách du lịch cỡ lớn Quantum (167.800GRT) và Oasis (225.282GRT). **Không thấy nhắc đến tàu 70.000DWT giảm tải hay tàu container 165.000DWT nào trong thuyết minh sửa chữa** — điều này phù hợp với việc thuyết minh sửa chữa chỉ mô tả **năng lực khai thác đã được phê duyệt/hiện hữu** (tiếp nhận đến 50.000DWT theo QĐ số 4151/QĐ-CHHVN ngày 13/10/2017), còn việc **kiểm định khả năng tiếp nhận tàu 70.000DWT giảm tải** (đối tượng chính của bài toán FEM/SAP2000 đang xét) là một **nghiên cứu riêng, mới hơn**, không thuộc phạm vi thuyết minh sửa chữa 2023 này — cần lưu ý khi trích dẫn nguồn cho bài báo.

---

## 2. Hình học mô hình FEM (SAP2000)

| Trục | Min | Max | Ghi chú |
|---|---|---|---|
| X (ngang bến) | −0,823 m | 25,627 m | 5 hàng cọc tại X = 2,5 / 7,5 / 12,5 / 17,5 / 22,5 m (module ngang 5,0m); khớp bề rộng cầu chính 24m |
| Y (dọc bến) | −0,728 m | 60,0 m | Cụm cọc (bent) lặp lại theo module dọc **~5,2 m**, khoảng 12 cụm trong phạm vi mô hình |
| Z (cao độ) | −22,2 m | 0,0 m | Z=0 quy ước tại cao trình đáy đài/đỉnh cọc trong mô hình (KHÔNG chắc chắn có trùng cao độ Hải đồ +3,5m hay là một mốc cục bộ — cần xác nhận) |

**Quy mô mô hình:**
- Số nút (Joints): **1.942**
- Số phần tử thanh (Frame elements): **747**
- Số phần tử tấm vỏ (Area/Shell elements): **1.750**
- Số phần tử khối (Solid): 0 (không có bảng `CONNECTIVITY - SOLID`)
- Đơn vị làm việc: Tonf – m – °C (SAP2000 v16.0.0)
- Đối chiếu chéo nội bộ: `CONNECTIVITY - FRAME` (747) = `FRAME SECTION ASSIGNMENTS` (747) ✅ khớp; `CONNECTIVITY - AREA` (1.750) = `AREA SECTION ASSIGNMENTS` (1.750) ✅ khớp — không phát hiện chênh lệch.

---

## 3. Vật liệu

| Vật liệu (tên trong SAP) | Loại | E (T/m²) | γ (T/m³) | Ghi chú đối chiếu |
|---|---|---|---|---|
| `M400-DN` | Bê tông | 3.300.000 | 1,935 | Dùng cho dầm ngang (DN), dầm dọc (DD), và tiết diện `MR` |
| `M400-DCT` | Bê tông | 3.300.000 | 2,05 | Dầm cần trục (DCT) |
| `M400` | Bê tông | 3.300.000 | 2,50 | Dùng cho tiết diện tấm `BMC` (bản mặt cầu) |
| `4000Psi` | Bê tông | 2.534.564 | 2,40 | Có trong thư viện vật liệu nhưng **không thấy được gán** cho frame/area section nào đang dùng trong mô hình — khả năng là vật liệu mặc định thư viện SAP2000, chưa xoá |
| `Thep` (thép cọc) | Thép | 21.000.000 | **0** (!) | Trọng lượng riêng khai báo = 0 T/m³ — tự trọng cọc **không** tính qua vật liệu mà được cộng thủ công vào `JOINT LOADS - FORCE` (load pattern BT) tại các nút đầu cọc/mũ cọc (xem mục 9) |
| `A615Gr60` | Cốt thép | 20.389.019 | 7,85 | Dùng cho cốt thép dọc/đai khai báo tự động thiết kế (mục 4) |

**⚠️ Điểm cần đối chiếu lại (tương tự phát hiện ở dự án Lạch Huyện):**
1. Bảng `MATERIAL PROPERTIES 03A - STEEL DATA` cho vật liệu `Thep` ghi **Fy = 35.153 T/m² ≈ 3.515 kG/cm² (≈ 50 ksi)** — đây **chính xác là giá trị mặc định thư viện SAP2000 cho thép ASTM A992 Fy50** (ghi chú "Notes" trong bảng vật liệu 01-GENERAL còn ghi rõ "ASTM A992 Fy=50 ksi"). Đây **không phải** mác thép ống cọc thực tế (thường dùng API 5L / ASTM A252 cho cọc ống thép biển, Fy thấp hơn ~45 ksi). Thuyết minh TKBVTC-SC2023 dẫn tiêu chuẩn **TCVN 9245:2012 "Cọc ống thép"** cho cọc ống thép và **TCVN 5575:2012 "Kết cấu thép — Tiêu chuẩn thiết kế"** cho kết cấu thép nói chung (mục 12), nhưng **không nêu trực tiếp mác thép/Fy cụ thể của thép ống cọc** trong phần trích xuất được cho riêng Chân Mây.
   **✅ QUYẾT ĐỊNH NGƯỜI DÙNG (phiên 3):** Do không tìm được Fy riêng cho Chân Mây, lấy theo giá trị đã dùng ở dự án tham khảo Lạch Huyện (`FEM_tham khao.md`, mục 11 — cùng áp dụng TCVN 9245:2012 "Cọc ống thép"): **Fy = 3.150 kG/cm², Fu = 4.900 kG/cm², độ giãn dài tối thiểu 18%**. Đây là **giá trị mượn theo cùng tiêu chuẩn (proxy), KHÔNG phải số liệu xác nhận riêng cho Chân Mây** — dùng làm ràng buộc thiết kế thay cho Fy=3.515 kG/cm² (mặc định ASTM A992 của SAP2000) khi tính Mu/Pmax/ứng suất cho phép của cọc ống thép D700/t14mm (mục 11, 13).
2. Bảng `MATERIAL PROPERTIES 03B` cho `M400` ghi **Fc ≈ 2.109 T/m² ≈ 210,9 kG/cm²** — thấp hơn nhiều so với kỳ vọng của mác M400 (cường độ khối vuông danh định 400 kG/cm², quy đổi trụ tương đương khoảng ~320 kG/cm²). Đây nhiều khả năng cũng chỉ là tham số phi tuyến mặc định cho khớp dẻo (không ảnh hưởng phân tích tuyến tính) — **cần xác nhận trước khi dùng cho ràng buộc sức bền**. ✅ **Cường độ bê tông M400 nay đã được xác nhận một phần bởi thuyết minh** (Chương VII, mục 2): "Bê tông mác M400 đá 0,5×1... Cường độ chịu nén R = 40,0 MPa (mẫu lập phương 150×150×150mm); Mô đun đàn hồi E = 3,3×10⁴ MPa = 33.000.000 kPa; Mác chống thấm B-10" — **giá trị E = 33.000.000 kPa/m² này khớp gần như tuyệt đối với E = 3.300.000 T/m² (=33.000.000 kPa) khai báo trong SAP** ⇒ mô đun đàn hồi bê tông trong SAP là **giá trị thiết kế thật**, đáng tin cậy. Riêng Fc dùng cho khớp dẻo/thiết kế cốt thép tự động (210,9 kG/cm²) vẫn là tham số mặc định của module tự động thiết kế, khác với R=400kG/cm² (40MPa) danh định — cần dùng R=40MPa (thuyết minh) làm giá trị cường độ thiết kế chính thức khi tính Mu/Pmax, không dùng Fc mặc định của SAP.
3. Vật liệu `4000Psi` xuất hiện trong thư viện nhưng dường như không dùng — nên kiểm tra trực tiếp trong SAP2000 gốc (`.sdb`) nếu muốn chắc chắn 100%.
4. **✅ Mới xác nhận (thuyết minh, Chương VII mục 1):** Cốt thép thanh trong kết cấu BTCT của công trình dùng **CB240-T** (Giới hạn chảy 240 MPa, giới hạn bền kéo 380 MPa, độ giãn dài tối thiểu 20%) và **CB300-V** (Giới hạn chảy 300 MPa, giới hạn bền kéo 450 MPa, độ giãn dài tối thiểu 16%) theo TCVN 1651-2018 — **khác với vật liệu `A615Gr60` (Fy≈414MPa/60ksi, tiêu chuẩn Mỹ) mà SAP2000 dùng cho module tự động thiết kế cốt thép** (mục 4). Điều này **xác nhận thêm** nhận định trước đó: cốt thép A615Gr60 trong SAP chỉ là mặc định của module tự động thiết kế, KHÔNG phải mác thép thực tế thi công — khi tính Mu/Mcr cho ràng buộc tối ưu cần dùng CB240-T/CB300-V (TCVN) thay vì A615Gr60.
5. Que hàn (liên kết thép): độ bền kéo đứt tiêu chuẩn 410 N/mm², cường độ tính toán 180 N/mm² (theo TCVN 3223:2000, kiểm tra theo TCVN 5401:2010 & TCVN 5403:1991) — số liệu mới, hữu ích cho kiểm tra liên kết hàn dầm cần trục/mối nối cọc nếu cần.

---

## 4. Tiết diện thanh (Frame Sections)

12 tiết diện được khai báo, nhưng **chỉ 5 tiết diện thực sự được gán** cho 747 phần tử (`FRAME SECTION ASSIGNMENTS`):

| SectionName | Vật liệu | Hình dạng | Kích thước | Số phần tử gán | Cấu kiện tương ứng |
|---|---|---|---|---|---|
| `Coc1` | Thep | Pipe (ống tròn) | D = 0,70 m, t = 12,6 mm | **96** | Cọc ống thép — duy nhất 1 loại cọc trong mô hình này |
| `DN` | M400-DN | Chữ nhật | 1,55 × 1,00 m | **282** | Dầm ngang |
| `DD` | M400-DN | Chữ nhật | 1,55 × 1,00 m | **210** | Dầm dọc (cùng kích thước với DN) |
| `DCT` | M400-DCT | Chữ nhật | 1,95 × 1,30 m | **140** | Dầm cần trục |
| `MR` | M400-DN | Chữ nhật | 1,55 × 1,40 m | **18** | Chưa xác định rõ mục đích — có thể là dầm mép/dầm biên hoặc dầm đỡ ray — **cần đối chiếu SAP2000 gốc** |
| (không gán) | — | — | — | 1 | 1 frame có `AnalSect=None` |

**Tiết diện khai báo nhưng KHÔNG dùng:** `Coc2` … `Coc8` — 7 tiết diện có cùng hình dạng Pipe D=0,70m/t=12,6mm như `Coc1`, chỉ khác hệ số `AMod` (0,40 – 0,425, giảm dần), ghi chú "Added" trong khoảng 2020-2021. Nhiều khả năng đây là **các phương án cọc cũ qua nhiều lần chỉnh sửa mô hình** (thử các hệ số suy giảm diện tích do ăn mòn khác nhau) và bị bỏ lại trong file, không ảnh hưởng kết quả vì không được gán.

Cốt thép khai báo cho tự động thiết kế (`FRAME SECTION PROPERTIES 02 - CONCRETE COLUMN`, áp dụng cho DN/DD/DCT/MR): `NumBars=3×3`, `BarSizeL=#9`, đai `BarSizeC=#4 @150mm`, lớp bê tông bảo vệ `Cover=40mm` — **đây là thông số mặc định của module tự động thiết kế cột BT trong SAP2000, không nhất thiết là cốt thép thực tế đã thi công** (tương tự phát hiện ở dự án Lạch Huyện).

**✅ ĐÃ GIẢI QUYẾT — đường kính/chiều dày cọc cầu chính (phiên 2, dựa trên thuyết minh + DXF):**

Thuyết minh TKBVTC-SC2023 (Chương III, mục 1.3 "Hiện trạng chất lượng công trình — Cầu chính") ghi rõ: *"Nền cọc: bằng các cọc ống thép **D700, t=14mm**. Tổng số cọc là 508 cọc..."* — và cả 3 file DXF "Mặt bằng bố trí đệm và mối nối" (10/11/12) đều ghi nhãn **"CỌC ỐNG THÉP D700, t=14mm"** / **"D=700X14MM"** lặp lại nhất quán trên mặt cắt ngang của cả 5 phân đoạn (Block I–V). ⇒ **D700, t=14mm là giá trị CHÍNH THỨC, quyền uy cao nhất, được xác nhận bởi 3 nguồn độc lập (thuyết minh + Excel "L coc" tính tay + DXF bản vẽ thi công)** cho cọc cầu chính. Giá trị D=0,70m trong SAP là đúng.

Về chiều dày t=12,6mm trong SAP (khác t=14mm chính thức): nhiều khả năng đây là **chiều dày quy đổi sau khi trừ hao mòn/ăn mòn** cho mục đích kiểm định (t=14mm danh định − ăn mòn giả định ≈1,4mm ⇒ 12,6mm, tức giảm 10%) — thuyết minh có nhắc nhiều lần hiện tượng "cọc đã xuất hiện hiện tượng ăn mòn" tại vị trí đục lớp hà bám, phù hợp với việc mô hình kiểm định dùng tiết diện giảm yếu để đánh giá thiên về an toàn. **Đây là suy luận hợp lý nhưng chưa được xác nhận trực tiếp bằng văn bản** — nên hỏi lại đơn vị tính toán để chắc chắn 100% trước khi dùng làm căn cứ.

**Về tên file CAD "23-24. Cọc ống thép D600, L=51m" — ĐÃ LÀM RÕ (không còn là mâu thuẫn với D700 cầu chính):** Đọc trực tiếp nội dung DXF (text/tiêu đề bản vẽ) cho thấy đây là bản vẽ **"CHI TIẾT CỌC ỐNG THÉP D600 — PHƯƠNG ÁN 1" (DETAIL OF STEEL PIPE PILE D600 — ALT.No.1)**, thuộc bộ bản vẽ **"MẶT BẰNG NỀN CỌC (LAYOUT OF DOLPHIN)"** — tức là **một phương án cọc cho TRỤ NEO/DOLPHIN (25 cọc, độ xiên 5:1/6:1/10:1, có nhãn "BÍCH NEO (BOLLARD) 150t")**, **KHÔNG PHẢI cọc của cầu chính** (nơi mô hình SAP đang xét). Vì bản vẽ ghi rõ "Phương án 1", nhiều khả năng đây là một **phương án thiết kế/so sánh cho một dolphin thép**, khác với dolphin bê tông ƯST D800 (trụ neo T2/T4) đã xây dựng thực tế theo thuyết minh — cọc D600 thép này **có thể chưa/không được xây dựng**, hoặc thuộc hạng mục khác ngoài phạm vi thuyết minh sửa chữa 2023. Riêng cấu kiện D600 thứ hai xuất hiện trong DXF "Mặt bằng bố trí đệm và mối nối" là **"CỌC BÊ TÔNG ƯST PH600, t=100-130mm"** dùng cho **trụ đỡ/cầu công tác (bridge bent)** — cũng là một kết cấu khác, không phải cầu chính. ⇒ **Kết luận: không có mâu thuẫn thực sự — D700/t14mm là cọc cầu chính (đối tượng mô hình FEM), còn mọi ghi nhận "D600" đều thuộc các kết cấu phụ trợ khác (dolphin phương án so sánh, hoặc trụ đỡ cầu công tác).**

---

## 5. Tiết diện tấm (Area Sections)

Chỉ có **1 tiết diện tấm duy nhất** trong toàn mô hình:

| Section | Vật liệu | Dày (m) | Loại | Số phần tử | Ghi chú |
|---|---|---|---|---|---|
| `BMC` | M400 | 0,35 | Shell-Thin | 1.750 | Bản mặt cầu (deck slab) — không có tiết diện tấm nào khác (không có bản tựa tàu/tường chắn dạng shell riêng trong mô hình này, khác dự án Lạch Huyện có 4 loại) |

**✅ Xác nhận bởi thuyết minh:** Chương III mục 1.3 ghi "Bản mặt cầu: Bằng BTCT M400, dày 35cm" — khớp **chính xác tuyệt đối** với chiều dày 0,35m khai báo cho `BMC` trong SAP. Đây là một trong các điểm đối chiếu chéo đáng tin cậy nhất giữa 3 nguồn (SAP + Excel + thuyết minh).

---

## 6. Hệ cọc (trong phạm vi mô hình FEM)

| Loại cọc | Số lượng | Đường kính × chiều dày | Chiều dài mô hình FEM (đến điểm ngàm ảo, từ Z=0) | Độ xiên |
|---|---|---|---|---|
| Cọc ống thép D700-t12,6 (`Coc1`) | **96** | D=0,70m, t=12,6mm | 21,19 – 22,49 m | 66 cọc xiên ~6:1 (V:H, tỷ lệ 6,05–6,06), 30 cọc thẳng đứng |

**Phương pháp xác định chiều dài ngàm ảo (theo Excel sheet "L coc", tiêu chuẩn TCVN 11820-5:2021):**
- Công thức: `Lu = L0 + 1/β`, trong đó `L0` = chiều dài cọc từ đáy đài đến mặt đất tự nhiên; `β` = hệ số biến dạng của đất, phụ thuộc `Kn = 1500×N` (N = chỉ số SPT).
- Dữ liệu SPT dùng cho tính toán lấy từ các lỗ khoan **LK2, LK11, LK13, LK16** (Excel gốc ghi "BH11/BH13/BH16" — **✅ quyết định người dùng, phiên 3: thống nhất gọi theo hệ "LK..." vì đây là phương án có đầy đủ dữ liệu hơn** — toạ độ, mặt cắt địa chất, chỉ tiêu cơ lý trong thuyết minh+DXF, coi "BH11/BH13/BH16" = "LK11/LK13/LK16"; xem mục 8.3) — chỉ có tên hố khoan và giá trị N rời rạc trong bảng tính, không có mặt cắt địa chất/chỉ tiêu cơ lý đầy đủ riêng — xem mục 8.
- Giá trị Lu tính tay trong Excel (khoảng 15–23,5m tuỳ hố khoan/hàng cọc) **khớp cùng bậc độ lớn** với chiều dài cọc trong mô hình FEM (21,2–22,5m) — cho thấy mô hình SAP dùng đúng phương pháp ngàm ảo tính theo TCVN 11820-5:2021, KHÔNG dùng lò xo đất rời rạc.

**⚠️ Không tìm thấy bảng `JOINT SPRING ASSIGNMENTS` nào trong file `.$2k`** (đã grep toàn văn bản, chỉ có 3 chỗ nhắc từ "Spring" và đều là cấu hình màu hiển thị `SpringLinks`, không phải lò xo thực) — khác hẳn với ghi nhận ở dự án Lạch Huyện (vốn có lò xo trục U3 tại 178 nút). Ở đây **mô hình dùng HOÀN TOÀN phương pháp điểm ngàm cứng ảo** (fixed support tại đáy cọc, xem mục 7), không có lò xo ngang hay lò xo dọc trục nào.

**✅ Cập nhật (thuyết minh + DXF, phiên 2) — hệ cọc TOÀN BỘ công trình (không chỉ phạm vi mô hình FEM):**

| Kết cấu | Loại cọc | Số lượng | Độ xiên | Nguồn |
|---|---|---|---|---|
| **Cầu chính** (300m, 5 phân đoạn) | Cọc ống thép **D700, t=14mm** | **508 cọc** (I:91, II:94, III:126, IV:101, **V:96** ⇐ khớp mô hình SAP) | 66/96 cọc trong Block V xiên ~6:1, 30 thẳng đứng (theo SAP); DXF còn ghi thêm tỷ lệ 1:10 tại một số vị trí | Thuyết minh TKBVTC-SC2023, DXF 10/11/12 |
| Cầu dẫn (3 cầu dẫn, 73,5×13,2m) | Cọc ống thép **D1220, t=12mm** | 90 cọc | — | Thuyết minh TKBVTC-SC2023 |
| Trụ neo T2 (dolphin, 12,5×10×2,5m) | Cọc bê tông ƯST **D800**, L=52m | 29 cọc | 1:6 | Thuyết minh; DXF ghi "CỌC BÊ TÔNG ƯST D800,t=120mm" |
| Trụ neo T4 (dolphin, 12,5×10×2,5m) | Cọc bê tông ƯST **D800**, L=54m | 39 cọc (1 thẳng + 38 xiên) | 1:6 | Thuyết minh |
| Trụ neo T3 (dolphin, 11×15×2,5m) | Cọc khoan nhồi BTCT M400, **D=1200mm**, L=33m | 12 cọc | thẳng đứng | Thuyết minh |
| Trụ đỡ/cầu công tác (walkway/bridge bent) | Cọc bê tông ƯST **Φ600mm, t=100-130mm** | chưa xác định số lượng | — | DXF "Mặt bằng bố trí đệm và mối nối" |
| (Phương án so sánh — có thể không xây dựng) | Cọc ống thép **D600, t=12mm, L=51m** (dolphin, "Phương án 1") | 25 cọc | 5:1/6:1/10:1 | DXF "23-24. Cọc ống thép D600 l=51m" |

⇒ **Mô hình FEM `.$2k` đang xét chỉ đại diện cho cầu chính, Phân đoạn V, D700 thép (96 cọc) — KHÔNG bao gồm cầu dẫn, trụ neo/dolphin nào.** Toàn bộ mâu thuẫn D600 vs D700 đã được làm rõ ở mục 4 — không có mâu thuẫn thực sự, chỉ là các kết cấu khác nhau.

---

## 7. Điều kiện biên & lò xo nền (Soil springs)

- **Không có lò xo đất (springs)** trong mô hình — xem mục 6.
- **`JOINT RESTRAINT ASSIGNMENTS`:** 95 nút bị ngàm cứng hoàn toàn `U1=U2=U3=R1=R2=R3=Yes` (ngàm 6 bậc tự do) tại các nút đáy cọc (Z ≈ −20,9 đến −22,2m) — mô phỏng điểm ngàm ảo theo TCVN 11820-5:2021 (mục 6).
- **⚠️ Bất thường phát hiện:** mô hình có **96 cọc** nhưng chỉ có **95 nút được ngàm** — nút đáy cọc số hiệu **1945** không xuất hiện trong bảng `JOINT RESTRAINT ASSIGNMENTS`. Đây có thể là sai sót khi khai báo biên (thiếu ngàm 1 cọc), **cần kiểm tra lại trực tiếp trong SAP2000 gốc trước khi dùng mô hình để chạy phân tích/tối ưu.**
- Không có `JOINT RESTRAINT` nào khác (không có ngàm biên phân đoạn kiểu Lạch Huyện, phù hợp vì mô hình có vẻ không đại diện ranh giới giữa các phân đoạn liên tục mà là một kết cấu bến nhô độc lập).

---

## 8. Địa chất công trình

> ✅ **ĐÃ GIẢI QUYẾT phần lớn ở phiên 2** — Thuyết minh TKBVTC-SC2023 (Chương II, mục 3 "Đặc điểm địa chất") cung cấp bảng chỉ tiêu cơ lý cơ bản theo lớp đất, dựa trên "tài liệu khảo sát địa chất khu vực công trình do Công ty TVXD Cảng - Đường Thuỷ (nay là Công ty CP TVXD Cảng - Đường Thuỷ) thực hiện năm 2002" (cùng nguồn khảo sát đã biết từ phiên 1, nay đọc được nội dung chi tiết). Các DXF "Mặt bằng bố trí đệm và mối nối" (10/11/12) và "Mặt bằng hiện trạng" (06) còn có thêm mặt cắt địa chất minh hoạ theo từng phân đoạn (ghi rõ "chỉ mang tính chất minh hoạ") với chỉ tiêu cơ lý cục bộ theo từng lỗ khoan, và file "04.05. MC dia chat.dxf" chứa các mặt cắt địa chất chi tiết giữa các lỗ khoan.

**8.1. Bảng chỉ tiêu cơ lý theo lớp đất (nguồn: Thuyết minh TKBVTC-SC2023, Chương II mục 3 — áp dụng chung toàn khu vực công trình):**

| Lớp | Mô tả | Bề dày / Cao độ đáy lớp | γ (g/cm³) | φ (góc ma sát trong) | C (kg/cm²) | Is (độ sệt) | Δ (tỷ trọng hạt) |
|---|---|---|---|---|---|---|---|
| 1 | Bùn sét cát, xám đen, lẫn vỏ sò | Dày 0,4–14,6m; đáy lớp từ −3,3m đến −22,05m | 1,56 | 1°22' | 0,085 | 1,25 | — |
| 2 | Sét cát, xám đen, lẫn vỏ sò, trạng thái chảy đến dẻo chảy | Đáy lớp −14,0 đến −22,05m; dày TB 7,5m (ngoài khơi đến 10,5m) | 1,82 | 6°42' | 0,11 | 1,13 | — |
| 3 | Cát hạt trung, xám, lẫn ít vỏ sò, chặt vừa | Mặt lớp −3,3 đến −22,2m; đáy lớp −10,5 đến −40,6m; dày TB 14,5m | — | 31°16' | — (cát rời, không có C) | — | 2,66 |
| 4 | Sét xám đen, dẻo mềm | Mặt lớp −38,8 đến −40,2m; đáy lớp −36,65 đến −51,6m; dày 2,9–11,6m; chỉ gặp ở một số lỗ khoan phía ngoài | 1,67 | 11°29' | 0,215 | 0,71 | — |
| 5 | Đá granit, xám xanh (nền đá gốc) | Lớp đáy cùng | — | — | — | — | — |

**8.2. Số liệu bổ sung từ mặt cắt địa chất minh hoạ trong DXF (10/11/12, 06 — ghi chú "GEOLOGICAL SECTIONS FOR REFERENCE ONLY", giá trị cục bộ theo lỗ khoan, KHÔNG thay thế bảng 8.1 mà chỉ bổ sung góc nhìn cục bộ):**
- Bùn sét cát (Clayey mud): φ=2°37', C=0,076 kg/cm², Is=1,14, γ=1,59 g/cm³ (gần với Lớp 1 nhưng không trùng khớp tuyệt đối — biến đổi tự nhiên theo vị trí lỗ khoan).
- Sét dẻo mềm (Soft clay): φ=7°42', C=0,12 kg/cm², Is=0,88, γ=1,6 g/cm³ (gần với Lớp 4).
- Cát hạt trung (Medium sand): φ=35°37', γ=2,66 g/cm³ (γ khớp chính xác với Lớp 3; φ cao hơn — biến đổi theo vị trí).
- Đá granit phong hoá (Weathered granite): φ=29°1', γ=2,67 g/cm³ — **số liệu mới, thuyết minh chính không cho φ/γ của lớp đá**.
- Ngoài ra DXF còn phân biệt thêm biến thể "Cát hạt thô, chặt vừa/rất chặt" và "Cát hạt nhỏ" — cho thấy Lớp 3 (cát) có tính không đồng nhất về cỡ hạt/độ chặt theo vị trí, chi tiết hơn mô tả gộp trong thuyết minh chính.
- Cao độ mặt đá gốc (granit) biến thiên rất lớn theo lỗ khoan trong mặt cắt DXF: khoảng −35m đến hơn −70m ở phần lớn các lỗ khoan, nhưng có một số vị trí nông hơn (khoảng −10m đến −22m) — xác nhận nền đá gốc có địa hình khá gồ ghề dưới đáy biển khu vực bến.

**8.3. Lỗ khoan:**
- Theo DXF "03. Mặt bằng vị trí lỗ khoan" và "04.05. MC địa chất": tối thiểu **10 lỗ khoan chính LK1–LK10** (thực hiện năm 2001) **+ 2 lỗ khoan bổ sung LK1-01 và LK2-02** (thực hiện năm 2002) — tổng cộng ít nhất 12 lỗ khoan có toạ độ/mặt cắt trong hồ sơ CAD; bản vẽ vị trí lỗ khoan còn ghi nhận thêm nhãn LK16, LK17, LK19, LK20 (có thể thuộc một đợt khảo sát bổ sung khác hoặc thuộc khu vực lân cận, chưa xác nhận được).
- **✅ ĐÃ GIẢI QUYẾT theo quyết định người dùng (phiên 3) — tên hố khoan:** Excel "L coc" ghi "LK2, BH11, BH13, BH16" trong khi DXF/thuyết minh chỉ dùng tiền tố "LK" (LK1–LK10, LK16, LK17, LK19, LK20, LK1-01, LK2-02). "LK2" khớp trực tiếp; với "BH11/BH13/BH16" — vì phương án đặt tên "LK..." có **dữ liệu đầy đủ hơn hẳn** (toạ độ, mặt cắt địa chất, chỉ tiêu cơ lý trong thuyết minh+DXF, so với Excel chỉ có SPT N rời rạc không có hồ sơ đầy đủ), **người dùng quyết định thống nhất coi "BH11/BH13/BH16" = "LK11/LK13/LK16"** (số thứ tự đều nằm trong khoảng LK1–LK20 đã xác nhận tồn tại) và dùng tên "LK..." làm chuẩn xuyên suốt tài liệu này. Đây là một **quy ước làm việc (working assumption) do người dùng chọn**, không phải bằng chứng vật lý 100% chắc chắn hai bộ tên trỏ đến đúng cùng lỗ khoan — nếu cần độ chính xác tuyệt đối nên hỏi lại đơn vị khảo sát/tính toán gốc.

**8.4. Vẫn còn thiếu (chưa giải quyết được ở phiên 2):**
- Chưa có bảng SPT N chi tiết theo độ sâu cho từng lỗ khoan (chỉ có giá trị SPT rời rạc trong Excel "L coc" theo hố khoan LK2/LK11/LK13/LK16 — xem quy ước tên ở mục 8.3, và một số giá trị SPT/N lẫn trong text DXF "04.05. MC dia chat.dxf" nhưng chưa tách được rõ ràng theo từng lỗ khoan/độ sâu cụ thể do dữ liệu numeric lẫn lộn giữa toạ độ, cao độ và SPT trong text entity — cần xử lý sâu hơn bằng cách đọc toạ độ hình học kết hợp text nếu muốn khai thác đầy đủ).
- Chưa có module đàn hồi đất nền (E, module biến dạng) hay hệ số nền theo phương ngang (kh) độc lập với công thức Kn=1500×N.

**⇒ Kết luận:** Từ chỗ hoàn toàn không có dữ liệu định lượng (phiên 1), nay đã có bảng chỉ tiêu cơ lý γ/φ/C/Is theo 5 lớp đất (nguồn quyền uy: thuyết minh) — đủ để làm ràng buộc tham khảo ban đầu cho kiểm tra sức chịu tải cọc theo đất nền (TCVN 10304:2014, nay đã xác nhận là tiêu chuẩn áp dụng chính thức — xem mục 12), dù độ chi tiết vẫn thấp hơn một bộ hồ sơ khảo sát địa chất đầy đủ (không có biểu đồ SPT theo độ sâu từng hố khoan, không có thí nghiệm nén ba trục/cắt trực tiếp).

**8.5. ✅ Hệ số gia tốc nền động đất — ĐÃ GIẢI QUYẾT DỨT ĐIỂM (phiên 3):**

Thuyết minh (phiên 2) đã xác nhận địa điểm chính xác của công trình là **Xã Lộc Vĩnh, Huyện Phú Lộc, Tỉnh Thừa Thiên Huế**. Tra trực tiếp **Phụ lục H (Quy định) — "Bảng phân vùng gia tốc nền theo địa danh hành chính", TCVN 9386:2012** (bảng cho giá trị đại diện theo cấp huyện/thị xã/thành phố, áp dụng chung cho mọi xã/phường trực thuộc — không có mục riêng cho từng xã), dòng:

> *"Huyện Phú Lộc (TT. Phú Lộc): kinh độ 107,860479 — vĩ độ 16,280188 — đỉnh gia tốc nền agR = **0,0434 (g)**"*

⇒ **Giá trị chính thức thay thế: agR = 0,0434g** (chu kỳ lặp 500 năm, nền loại A), thay cho ag=0,0368g ghi nhầm theo địa điểm Cát Hải/Hải Phòng trong Excel "Tai trong". Theo bảng chuyển đổi cấp động đất của chính TCVN 9386:2012 (Phụ lục I): agR=0,0434g vẫn rơi vào dải **">0,03 – 0,06" = Cấp VI (thang MSK-64)** — tức là **phân loại cấp động đất VI không đổi**, chỉ có giá trị agR cụ thể là thay đổi (0,0368g → 0,0434g). Lưu ý: agR là đỉnh gia tốc nền tham chiếu nền loại A; giá trị thiết kế ag dùng trong tính toán cụ thể còn phụ thuộc hệ số tầm quan trọng công trình γI (theo cấp công trình — Cấp I quản lý/Cấp III kỹ thuật, mục 1) và hệ số nền loại đất theo TCVN 9386:2012 — **hệ số γI và loại nền chưa được xác nhận riêng cho Chân Mây**, cần bổ sung nếu muốn tính ag thiết kế cuối cùng chính xác 100%.

---

## 9. Tải trọng (Load Patterns trong SAP + đối chiếu Excel)

21 load pattern trong SAP, tương ứng 1 tải trọng bản thân + 3 nhóm tải khai thác + tải môi trường:

| LoadPat (SAP) | Loại | Diễn giải | Giá trị tiêu biểu | Đối chiếu Excel |
|---|---|---|---|---|
| `BT` | DEAD | Tự trọng kết cấu (`SelfWtMult=1`, trừ cọc) + lớp phủ mặt + tự trọng cọc gán thủ công | Lớp phủ mặt: **−0,11 T/m²**; tự trọng cọc/mũ cọc gán tại nút: −0,27 / −1,10 / −1,14 / −3,4 T tuỳ vị trí | Bảng 6-2 Excel: lớp phủ 5×2,2cm, γ=0,11 T/m³ ⇒ 0,11 T/m² ✅ khớp chính xác |
| `VA1` | LIVE | Lực va tàu 70.000DWT (qua đệm SPC-1300H) | F1(vuông góc bến)=**118,25 T**; F2(song song)=**−23,65 T** | Excel "Va": Nx=118,25T, Ny=23,65T ✅ khớp chính xác |
| `VA2` | LIVE | Lực va tàu 3.000DWT (qua đệm LMD 300H-2500L) | F1=**−62,3 T**; F2=**31,15 T** | Excel "Va": Nx=62,3T, Ny=31,15T ✅ khớp chính xác |
| `NEO1` | LIVE | Lực neo tàu 70.000DWT giảm tải (nhiều kịch bản: mũi/lái, ngang, giằng) | VD nút 359: F1=−20,37, F2=36,76, F3=4,13 T; nút 539: F1=−31,06, F2=17,93, F3=22,29 T | Excel "Tai trong" mục 3.3 ✅ khớp các thành phần Hx/Hy/Hz |
| `NEO2` | LIVE | Lực neo tàu 3.000DWT | VD nút 1286: F1=2,82, F2=−15,98, F3=4 T | Excel "Tai trong" mục 3.4 (các kịch bản neo tàu nhỏ) |
| `CT` | LIVE | Cần trục di động 63T (chân đế trên đỉnh cọc) | Area load Z = **−50,5 T/m²** trên 20 phần tử tấm nhỏ dưới chân đế | Excel "Tai trong": áp lực lớn nhất 1 chân = 145,2T / bàn đế 1,2×2,4m ⇒ 145,2/2,88=**50,4 T/m²** ✅ khớp gần đúng |
| `HH1`…`HH10` | LIVE | 10 kịch bản chất tải hàng hoá (theo mục "Tổ hợp": rải đều, chất xen kẽ theo nhịp/theo gối, ngang/dọc bến, kèm cần trục) | Uniform = **−4 T/m²** (khu vực sau ray cần trục) hoặc **−2 T/m²** (khu vực từ mép bến đến ray) | Excel "Tai trong" mục 2.1: q=2,0 T/m² (mép bến→ray) & q=4,0 T/m² (ray→hết bề rộng) ✅ khớp chính xác |
| `OTO` | VEHICLE LIVE (Moving Load, `LinMoving`) | Xe đầu kéo + rơ-moóc (Tractor-Trailer) di chuyển trên dầm dọc, làn `DD` | Trục trước 4,19T (Leading Load); trục giữa 23,34T (spacing 2,64m); 2× trục sau 16,82T (spacing 8,49m và 1,5m) | Excel "Tai trong" mục 2.3: W1=4,19T, W2=23,34T, W3=33,64T (= 2×16,82T tandem) ✅ khớp |
| `MT1` | OTHER | Môi trường — nhiệt độ tăng +10°C (trên tấm `BMC`) + lực dòng chảy/gió tác dụng lên cọc (trên frame cọc) | Nhiệt: ΔT=+10°C; Lực phân bố trên cọc: **≈0,049 T/m** (phạm vi ngập nước) | Excel "MT": ΔT=±10°C; FD (dòng chảy trên cọc D700+hà bám=0,9m, U=1m/s, CD=1,05) = **0,0494 T/m** ✅ khớp gần đúng |
| `MT2` | OTHER | Môi trường — nhiệt độ giảm −10°C + lực dòng chảy/gió (chiều ngược) | ΔT=−10°C; lực phân bố ≈0,049 T/m | — |
| `MT1-SLS`, `MT2-SLS` | OTHER | Phiên bản dùng cho tổ hợp SLS, giá trị giống MT1/MT2 | ΔT=±10°C | — |

**Ghi chú mô hình hoá:** load pattern `MT` (môi trường) được dùng để gộp CHUNG cả tải trọng nhiệt độ (gán kiểu `Type=Temperature` lên area) và tải trọng dòng chảy/gió (gán kiểu `Type=Force` phân bố đều lên frame cọc) — đây là cách đơn giản hoá thường gặp, không tách riêng 2 loại tải môi trường thành 2 pattern khác nhau như dự án Lạch Huyện.

**Tải trọng gió (Excel "MT", tiêu chuẩn BS 5400-2:1978 & BS 6399-2:1997):**
- Tốc độ gió trung bình 1h: điều kiện bình thường v=20,7 m/s; điều kiện bão v=38,61 m/s.
- Với tàu 50.000DWT: V≤20 m/s (gió cấp 8); với tàu 70.000DWT: V≤17 m/s (gió cấp 7) — theo Excel "So lieu".
- Tải gió ngang lên cầu chính (chiều dài chắn gió giả thiết 180m): p' bình thường ≈ 0,93 kN/m (quy về 1md cầu chính), bão ≈ 3,23 kN/m.
- Tải gió dọc (chiều dài chắn gió giả thiết 50m): p' bình thường ≈ 1,72 kN/m (dầm ngang), bão ≈ 6,00 kN/m.

**Tải trọng dòng chảy/sóng (Excel "MT"/"Song", tiêu chuẩn BS 6349-1:2000):**
- Vận tốc dòng chảy dọc thiết kế U=1,0 m/s; vận tốc dòng chảy ngang = 0 m/s.
- Chiều cao sóng thiết kế bình thường hs=0,5m.
- Sóng bão (mực nước cao +1,48m): hs=1,37m, chu kỳ Tp=4,52s. Sóng bão (mực nước thấp −0,01m): hs=1,85m, Tp=16,58s.
- Có bảng tính lực sóng Morison riêng cho cọc D800 (mũ cọc trụ neo, hà bám ⇒ D tính toán=0,9m) — **không thuộc phạm vi mô hình SAP đang xét** (mô hình chỉ có cọc D700 cầu chính).
- **Lưu ý:** bảng `AUTO WAVE 3` trong SAP có tham số mặc định phi thực tế (chiều sâu nước 45m, chiều cao sóng 18m, chu kỳ 12s) — đây rõ ràng là **giá trị mặc định của SAP2000 chưa từng được dùng** (không có load pattern nào tham chiếu Auto Wave), không phải input thiết kế thật.

**Va tàu (TCVN 11820-2:2017) & neo tàu (22TCN 222-95 kết hợp TCVN 11820 series):**
- Vận tốc cập bến: tàu 70.000DWT giảm tải Vb=0,10 m/s; tàu 3.000DWT Vb=0,14 m/s; sà lan 160TEU Vb=0,20 m/s.
- Năng lượng va: tàu 70.000DWT E=42,91 T.m (năng lượng thiết kế Ef=1,5×E=64,37 T.m); tàu 3.000DWT E=4,81 T.m (Ef=7,22 T.m).
- Đệm tàu lớn: **SPC-1300H** — năng lượng hấp thụ 73,2 T.m (>64,37 yêu cầu ✅), phản lực 118,25T, biến dạng tới hạn 70%, tự trọng 3,4T.
- Đệm tàu nhỏ: **LMD 300H-2500L** — năng lượng 7,8 T.m (>7,22 ✅), phản lực 62,3T, biến dạng tới hạn 52,5%, tự trọng 0,27T. (Ngoài ra còn nhắc "LMD 600H-2500H" tự trọng 1,14T ở bảng thiết bị, chưa rõ vị trí lắp đặt cụ thể.)
- **Bích neo (bollard) — ✅ ĐÃ GIẢI QUYẾT (phiên 2):** Đọc trực tiếp các DXF "Mặt bằng bố trí đệm và mối nối" (10/11/12) và "Mặt bằng hiện trạng" (06) cho thấy công trình có **3 cấp bích neo khác nhau tại 3 vị trí khác nhau**, không phải 1 mâu thuẫn mà là 3 số liệu đều đúng cho 3 vị trí:
  - **Bích neo 75T** — trên **cầu chính** (nhãn "BÍCH NEO (BOLLARD) 75t" xuất hiện lặp lại trên mặt bằng bến, mặt trước bến) ⇒ **khớp chính xác với Excel "Bích neo 75T"**.
  - **Bích neo 45T** — cũng trên cầu chính, tại vị trí khác với bích 75T (nhãn "BÍCH NEO (BOLLARD) 45t", "Bích neo tàu 45T") — một cấp bích neo thứ 3 mới phát hiện, dùng cho tàu nhỏ hơn ở một số vị trí dọc bến.
  - **Bích neo 150T** — trên **Trụ neo T2 (dolphin)** (nhãn "TRỤ NEO T2 (MOORING DOLPHIN T2)" kèm "BÍCH NEO (BOLLARD) 150t" / "150 tons" ngay trên cùng bản vẽ, và cũng xuất hiện trên DXF chi tiết cọc D600 "Phương án 1" mục 4) ⇒ **khớp chính xác với tên file CAD "Bollard 150T"**.
  - ⇒ **Kết luận: Excel "75T" và tên file CAD "150T" đều đúng, chỉ là 2 vị trí/kết cấu khác nhau (bích neo cầu chính vs bích neo trụ neo/dolphin) — không có mâu thuẫn dữ liệu.**
- **Đối chiếu điều kiện khai thác bình thường (thuyết minh, Chương III mục 1.2 "Tải trọng khai thác"):** vận tốc gió ≤20,0m/s (gió cấp 8) — khớp Excel "50.000DWT: V≤20m/s"; vận tốc dòng chảy ≤1,0m/s — khớp Excel U=1,0m/s; chiều cao sóng ≤1,25m (cấp 3: 0,75–1,25m) — **cao hơn** giá trị sóng bình thường hs=0,5m dùng trong Excel "MT" (khác ngữ cảnh: thuyết minh nêu điều kiện khai thác an toàn cho phép, Excel dùng giá trị tính toán tải trọng sóng thiết kế cụ thể — không nhất thiết mâu thuẫn); vận tốc cập tàu ≤0,15m/s (thành phần vuông góc bến) / ≤0,12m/s (tàu 50.000DWT) — **khác với** Vb=0,10m/s dùng cho tàu 70.000DWT giảm tải trong Excel/SAP (hợp lý vì là 2 kịch bản tàu khác nhau, tàu giảm tải có vận tốc cập cho phép thấp hơn do tải trọng va lớn hơn).

---

## 10. Tổ hợp tải trọng (410 tổ hợp trong SAP)

Theo Excel chương VII (nguyên tắc tổ hợp kiểu hệ số riêng phần Eurocode, "Set B"/"Set C"):

| Nhóm | Số lượng trong SAP | Mô tả |
|---|---|---|
| `ULSB-001` … `ULSB-388` | 388 | Tổ hợp trạng thái giới hạn cực hạn (ULS), dùng **hệ số riêng phần Set B**: γ(tĩnh tải)=1,35; γ(cần trục/ô tô)=1,35 (ψ₀=0,75 khi đi kèm ⇒ 1,0125); γ(hàng hoá)=1,5 (ψ₀=1,0); γ(va tàu)=1,2 (ψ₀=0,75 ⇒ 0,9); γ(neo tàu)=1,5 (ψ₀=0,5 ⇒ 0,75); γ(môi trường)=1,5 (ψ₀=0,6 ⇒ 0,9). Sinh ra từ tổ hợp hệ thống của **18 trường hợp tải trọng cơ bản** (Bảng 7-2 Excel: BT+Va, BT+Va+Neo, BT+HH, BT+HH+Neo, BT+CT+…, BT+Ôtô+…) |
| `SLSDH-01` … `SLSDH-20` | 20 | Tổ hợp trạng thái giới hạn khai thác (SLS) — hệ số ≈1,0 cho tải thường xuyên, hệ số tổ hợp ψ nhỏ hơn cho tải tạm thời (VD `SLSDH-01`: BT×1 + MT1-SLS×0,5 + HH1×0,8) |
| `BAO-ULSB` | 1 | Tổ hợp bao (envelope) của toàn bộ 388 tổ hợp ULSB |
| `BAO-SLSDH` | 1 | Tổ hợp bao (envelope) của toàn bộ 20 tổ hợp SLSDH |
| **Tổng cộng** | **410** | |

**⚠️ Lưu ý:** Excel còn định nghĩa hệ số riêng phần **"Set C"** (γ nhỏ hơn Set B, VD γ tĩnh tải=1,0, γ cần trục=1,15…) nhưng **không tìm thấy tổ hợp nào tương ứng Set C trong file `.$2k`** — có thể Set C được kiểm tra ở một model/bước riêng không có trong file này, hoặc không được đưa vào kiểm tra cuối cùng. Cần hỏi lại đơn vị tính toán.

**Hệ số tải trọng dài hạn QSP** (Excel mục 2.3, dùng cho kiểm tra nứt/biến dạng dài hạn): tĩnh tải hệ số 1; hàng hoá phân bố đều hệ số ψ₂=0,8; nhiệt độ hệ số ψ₂=0,5. (Chưa thấy load combo `QSP` tương ứng trong SAP `.$2k` — sheet Excel "QSP" tồn tại riêng nhưng chưa đối chiếu chi tiết đến từng combo).

---

## 11. Giới hạn / khả năng chịu lực cho phép

> ⚠️ **Vẫn CHƯA tìm thấy trực tiếp** giá trị mô-men nứt (Mcr), mô-men phá huỷ (Mu), hay lực dọc trục cho phép (Pmax) đã tính sẵn của cọc/dầm/bản trong bất kỳ nguồn nào (SAP/Excel/thuyết minh sửa chữa) — thuyết minh TKBVTC-SC2023 là hồ sơ **sửa chữa cục bộ** (dầm/bản/bọc đầu cọc), không phải hồ sơ tính toán kết cấu chi tiết của thiết kế gốc nên không trình bày bảng Mcr/Mu/Pmax. Tuy nhiên, thuyết minh **đã cung cấp đầy đủ số liệu vật liệu (mác/cấp bền) cần thiết để tự tính lại Mcr/Mu/Pmax** theo TCVN 5574:2018 (BTCT) / TCVN 5575:2012 (thép) / TCVN 9245:2012 (cọc ống thép) — đây là bước cải thiện đáng kể so với phiên 1 (khi còn chưa có cả số liệu vật liệu xác thực).

**✅ Số liệu vật liệu xác thực (nguồn: Thuyết minh TKBVTC-SC2023, Chương VII — thay thế các giá trị mặc định SAP2000 khi tính Mcr/Mu/Pmax):**
| Vật liệu | Chỉ tiêu | Giá trị | Ghi chú |
|---|---|---|---|
| Bê tông M400 (đá 0,5×1) | Cường độ chịu nén R (mẫu lập phương 150mm) | **40,0 MPa** | TCVN 6025:1995; test theo TCVN 5726:2022 |
| Bê tông M400 | Mô đun đàn hồi E | **3,3×10⁴ MPa** (=33.000.000 kPa) | Khớp gần tuyệt đối với E=3.300.000 T/m² trong SAP ✅ |
| Bê tông M400 | Mác chống thấm | B-10 | — |
| Cốt thép thanh CB240-T | Giới hạn chảy / bền kéo / giãn dài | **240 MPa / 380 MPa / 20%** | TCVN 1651-2018 — **khác A615Gr60 mặc định SAP (mục 3)** |
| Cốt thép thanh CB300-V | Giới hạn chảy / bền kéo / giãn dài | **300 MPa / 450 MPa / 16%** | TCVN 1651-2018 |
| Que hàn kết cấu thép | Độ bền kéo đứt / cường độ tính toán | 410 N/mm² / 180 N/mm² | TCVN 3223:2000 |
| Lớp bê tông bảo vệ cốt thép (tối thiểu) | — | 75mm (vùng nước lên xuống) / 50mm (trên mặt nước) | Mục "Các điểm lưu ý thi công" |

**✅ Fy thép cọc — QUYẾT ĐỊNH NGƯỜI DÙNG (phiên 3):** Vì không tìm được Fy riêng cho Chân Mây trong thuyết minh, lấy theo giá trị dự án tham khảo Lạch Huyện (`FEM_tham khao.md` mục 11, cùng áp dụng TCVN 9245:2012 "Cọc ống thép"):

| Chỉ tiêu | Giá trị (dùng cho Chân Mây, mượn theo TCVN 9245:2012) |
|---|---|
| Giới hạn chảy Fy | **3.150 kG/cm²** |
| Giới hạn bền Fu | **4.900 kG/cm²** |
| Độ giãn dài tối thiểu | **18%** |

⚠️ Đây là **giá trị proxy mượn từ dự án khác cùng áp dụng TCVN 9245:2012, KHÔNG phải số liệu xác nhận riêng cho cọc D700/t14mm của Chân Mây** — chấp nhận làm ràng buộc thiết kế theo quyết định người dùng, thay thế hẳn Fy=3.515 kG/cm² (mặc định ASTM A992 của SAP2000, mục 3). Nếu cần độ chính xác cao hơn (ví dụ khi phản biện bài báo), nên xác minh lại với đơn vị thiết kế/chứng chỉ vật liệu thực tế của lô cọc đã thi công.

**Số liệu gián tiếp còn lại (KHÔNG phải giá trị cho phép chính thức, chỉ tham khảo):**
- Fc bê tông M400 dùng cho khớp dẻo tự động thiết kế trong SAP (≈211 kG/cm²) — **nên thay bằng R=40MPa (≈408 kG/cm²) từ thuyết minh** khi tính Mu/Pmax thật, không dùng giá trị mặc định SAP.
- Năng lượng va tàu cho phép theo đệm đã chọn: SPC-1300H ≤73,2 T.m; LMD 300H-2500L ≤7,8 T.m (đây LÀ giá trị thiết kế thật của đệm, lấy từ catalogue nhà sản xuất qua Excel).

**⇒ Khuyến nghị cho bài toán tối ưu:** Dùng R=40MPa (bê tông) + CB240-T/CB300-V (cốt thép) theo TCVN 5574:2018 để tự tính Mcr/Mu cho dầm DN/DD/DCT/bản BMC (tiết diện đã biết chính xác từ SAP, khớp thuyết minh). Với cọc ống thép D700/t14mm, dùng Fy=3.150 kG/cm²/Fu=4.900 kG/cm² (proxy, xem trên) để tính Mu/Pmax theo TCVN 9245:2012 — thay cho việc để trống ràng buộc như phiên 2.

---

## 12. Tiêu chuẩn thiết kế áp dụng

**✅ CẬP NHẬT LỚN (phiên 2) — danh mục tiêu chuẩn CHÍNH THỨC, quyền uy cao nhất, trích nguyên văn Bảng "Quy chuẩn xây dựng và tiêu chuẩn kỹ thuật áp dụng trong thiết kế" (Chương II mục 7, thuyết minh TKBVTC-SC2023, 62 dòng, đầy đủ số hiệu):**

*I. Tiêu chuẩn thiết kế:* TCVN 2737:2023 (Tải trọng và tác động), TCVN 11820-1:2017 (Nguyên tắc chung), TCVN 11820-2:2017 (Tải trọng và tác động do tàu), TCVN 11820-3:2019 (Yêu cầu vật liệu), TCVN 11820-4-1:2019 (Nền móng), **TCVN 11820-5:2021** (Công trình bến — móng cọc, công thức ngàm ảo), TCVN 13330:2021 (Yêu cầu bảo trì), QĐ 109/QĐ-CHHVN 10/3/2005 (Quy định kỹ thuật khai thác cầu cảng), TCCS 03:2013/CHHVN, TCCS 04:2010/CHHVN, TCCS 04:2014/CHHVN (bảo trì), **TCCS 02:2018/CHHVN (Công trình bến cảng — Tiêu chuẩn kiểm định)**, TCVN 5574:2018 (Kết cấu BT&BTCT), TCVN 5575:2012 (Kết cấu thép), TCVN 12251:2020 (Chống ăn mòn), TCVN 4116:1985 (BT&BTCT thuỷ công), TCVN 4253:2012 (Nền công trình thuỷ công), **TCVN 10304:2014 (Móng cọc)**, **TCVN 9245:2012 (Cọc ống thép)**.

*II. Tiêu chuẩn vật liệu & thí nghiệm:* nhóm tiêu chuẩn xi măng (TCVN 5439/2682/6260/6067), bê tông (TCVN 6025:1995 phân mác theo cường độ nén, TCVN 4506:2012 nước trộn, TCVN 8826:2011 phụ gia), cốt thép (**TCVN 1651-2018 thép cốt bê tông** — phần 1 thanh tròn trơn & phần 2 thanh vằn), TCVN 5408:2007 (mạ kẽm), TCVN 12209:2018 (bê tông tự lèn); nhóm tiêu chuẩn thí nghiệm (TCVN 4787/6016/6068/6017/9338/9339/9348/6227/7572-20/8789/8828); nhóm thi công & nghiệm thu (TCXDVN 305:2004, TCVN 4453:1995, TCVN 9115:2019, TCVN 1651-1/2:2018, TCVN 7571:2019, TCVN 6522:2018, TCVN 9343:2012, **22 TCN 289-02**, TCVN 11859:2017).

*III. Tiêu chuẩn nước ngoài tham khảo:* **OCDI-2002 & 2009** (tiêu chuẩn kỹ thuật công trình cảng Nhật Bản), **BS 6349-1:2000** (Maritime structures — Code of practice for general criteria), **BS 6349-4:1994** (Designing fendering and mooring systems).

**Đối chiếu với danh mục trích từ Excel/SAP (phiên 1):** Phần lớn tiêu chuẩn TCVN 11820 series, TCVN 10304, BS 6349-1:2000 **khớp giữa 2 nguồn** ✅. Tuy nhiên có khác biệt đáng chú ý:
- Excel/SAP dùng thêm **22TCN 222-95, 22TCN 207-92, BS 5400-2:1978, BS 6399-2:1997** (tải trọng gió/sóng cũ, tiêu chuẩn Anh) — **các số hiệu này KHÔNG xuất hiện trong danh mục tiêu chuẩn chính thức của thuyết minh** — có thể là tiêu chuẩn được đơn vị tính toán (SAP/Excel) áp dụng bổ sung riêng cho phần tải trọng môi trường (gió/dòng chảy/sóng) mà thuyết minh sửa chữa không đề cập chi tiết (do phạm vi thuyết minh là sửa chữa kết cấu, không phải tính toán tải trọng môi trường từ đầu).
- Ngược lại, thuyết minh bổ sung nhiều tiêu chuẩn KHÔNG thấy trong Excel/SAP: **TCVN 2737:2023, TCVN 11820-3/4-1:2019, TCVN 13330:2021, TCCS 02:2018 (kiểm định), TCVN 5574:2018, TCVN 5575:2012, TCVN 12251:2020, TCVN 4116:1985, TCVN 4253:2012, TCVN 9245:2012 (cọc ống thép), OCDI-2002&2009, BS 6349-4:1994**.
- **⚠️ Đáng chú ý nhất: TCVN 9386:2012 (thiết kế công trình chịu động đất) — tiêu chuẩn được Excel "Tai trong" viện dẫn khi tính hệ số gia tốc nền ag — KHÔNG xuất hiện trong danh mục 62 tiêu chuẩn chính thức của thuyết minh sửa chữa.** Điều này phù hợp với việc thuyết minh này là hồ sơ sửa chữa cục bộ (không tính toán lại kháng chấn), nhưng cũng có nghĩa là **thuyết minh KHÔNG cung cấp giá trị ag thay thế** để đối chiếu/sửa cảnh báo cũ.
- SAP2000 nội bộ vẫn tham chiếu **ACI 318-05/IBC2003** (bê tông) và **AISC-LRFD93** (thép) chỉ cho mục đích tự động thiết kế/kiểm tra tiết diện của phần mềm — không phải tiêu chuẩn áp dụng chính thức của dự án (không đổi so với phiên 1).

**✅ Hệ số động đất — ĐÃ GIẢI QUYẾT DỨT ĐIỂM (phiên 3):** Excel "Tai trong" ghi nguyên văn *"Hệ số gia tốc nền tại khu vực xây dựng công trình (**Huyện Cát Hải, Tp. Hải Phòng**) là 0,0368g"* — thuyết minh TKBVTC-SC2023 xác nhận địa điểm CHÍNH XÁC của công trình là "Xã Lộc Vĩnh, Huyện Phú Lộc, Tỉnh Thừa Thiên Huế" (khác hẳn Cát Hải/Hải Phòng — địa điểm dự án Lạch Huyện). Tra trực tiếp **Phụ lục H, TCVN 9386:2012** cho "Huyện Phú Lộc (TT. Phú Lộc)": **agR = 0,0434g** — đây là giá trị chính thức thay thế cho ag=0,0368g (lỗi copy-paste từ dự án khác). Cấp động đất theo MSK-64 vẫn là **Cấp VI** (0,0434g nằm trong dải >0,03–0,06), không đổi so với phân loại cũ. Chi tiết & trích nguyên văn dòng bảng xem mục 8.5.

---

## 13. Đề xuất khung bài toán tối ưu SOO / MOO

> Phần này là **đề xuất kỹ thuật** dựa trên dữ liệu trích xuất được ở trên, không phải trích xuất trực tiếp từ hồ sơ — cần bạn xác nhận/điều chỉnh theo mục tiêu cụ thể của bài báo.

**13.1. Biến thiết kế (design variables) khả dĩ (dựa trên đúng tiết diện/vật liệu Chân Mây):**
| Biến | Ký hiệu | Miền giá trị tham khảo |
|---|---|---|
| Đường kính cọc ống thép | D_coc | 600 – 900 mm (giá trị hiện trạng chính thức **D700** — đã xác nhận bởi thuyết minh+DXF, xem mục 4; các ghi nhận "D600" thuộc kết cấu khác, không phải biến của bài toán này) |
| Chiều dày thành cọc thép | t_coc | 10 – 20 mm (giá trị chính thức **t=14mm** theo thuyết minh+DXF; t=12,6mm trong SAP nhiều khả năng là tiết diện quy đổi sau ăn mòn dùng cho kiểm định — xem mục 4) |
| Độ xiên cọc | rake | thẳng đứng – 1:5 ÷ 1:7 (hiện 66/96 cọc xiên 6:1, 30 cọc thẳng đứng) |
| Khoảng cách khoang cọc dọc bến (module bent) | s_y | 4,5 – 6,0 m (hiện ~5,2m suy từ toạ độ) |
| Khoảng cách hàng cọc ngang bến | s_x | cố định 5,0m theo 5 hàng hiện tại (có thể tối ưu thành biến nếu mở rộng phạm vi) |
| Kích thước dầm ngang/dọc (DN/DD) | b×h | quanh 1,00×1,55 m |
| Kích thước dầm cần trục (DCT) | b×h | quanh 1,30×1,95 m |
| Chiều dày bản mặt cầu (BMC) | t_ban | quanh 0,35 m |
| Chiều dài ngàm ảo cọc (Lu) | L_ngam | theo TCVN 11820-5:2021, phụ thuộc SPT N tại từng hố khoan (LK2/LK11/LK13/LK16 — quy ước tên theo mục 8.3) |

**13.2. Ràng buộc (constraints) — đã có thêm số liệu vật liệu xác thực + ag + Fy thép cọc ở phiên 2/3:**
- **Vẫn chưa có** Mu, Mcr, Pmax tính sẵn của cọc/dầm/bản (mục 11) ⇒ **phải tự tính** theo TCVN 5574:2018 (BTCT, dùng R=40MPa bê tông M400 + CB240-T/CB300-V cốt thép — số liệu đã xác thực từ thuyết minh) và TCVN 9245:2012/TCVN 5575:2012 (cọc ống thép/kết cấu thép, dùng Fy=3.150 kG/cm²/Fu=4.900 kG/cm² — giá trị proxy theo quyết định người dùng, mục 11).
- Ứng suất thép cọc σ ≤ Fy/γ — **✅ Fy=3.150 kG/cm² (proxy mượn từ Lạch Huyện, cùng TCVN 9245:2012 — mục 11)** thay cho Fy=3.515 kG/cm² mặc định ASTM A992 của SAP.
- Sức chịu tải cọc theo đất nền theo TCVN 10304:2014 (nay xác nhận là tiêu chuẩn chính thức áp dụng — mục 12) — **nay đã có bảng chỉ tiêu cơ lý γ/φ/C/Is theo 5 lớp đất** (mục 8, nguồn thuyết minh) đủ để làm ràng buộc tham khảo ban đầu, dù vẫn thiếu biểu đồ SPT chi tiết theo độ sâu từng hố khoan để tính chính xác 100%.
- Chuyển vị ngang lớn nhất tại đỉnh bến ≤ giới hạn khai thác cần trục 63T — cần tham chiếu quy định riêng dự án (chưa có).
- Kiểm tra kháng chấn theo TCVN 9386:2012 — **✅ agR=0,0434g (Huyện Phú Lộc, TT Huế — Phụ lục H TCVN 9386:2012), Cấp VI theo MSK-64** — thay cho ag=0,0368g sai địa điểm (Cát Hải/Hải Phòng) trong Excel. Xem mục 8.5.
- Tổ hợp tải trọng bắt buộc kiểm tra: tối thiểu 388 tổ hợp ULSB + 20 tổ hợp SLSDH (mục 10) — số lượng tổ hợp lớn hơn nhiều so với dự án Lạch Huyện (36 tổ hợp), cần cân nhắc kỹ thuật giảm số tổ hợp cần đánh giá mỗi vòng lặp tối ưu (chọn tổ hợp bao trùm/envelope `BAO-ULSB`, `BAO-SLSDH` để giảm chi phí tính toán).
- **Mới bổ sung:** Mô hình FEM nay đã xác nhận đại diện cho **Phân đoạn V** (mục "Kết luận về phạm vi mô hình" ở đầu file) — nếu muốn suy rộng kết quả tối ưu cho toàn bộ 300m cầu chính (508 cọc, 5 phân đoạn), cần cân nhắc liệu 4 phân đoạn còn lại (I–IV, có số lượng cọc/kích thước hơi khác — 91/94/126/101 cọc) có đại diện được bởi kết quả tối ưu của riêng Phân đoạn V hay không.

**13.3. Hàm mục tiêu (objectives) gợi ý:**
- **SOO đơn giản:** min(khối lượng vật liệu quy đổi chi phí = f(số cọc thép D700, khối lượng thép ống, thể tích BT dầm DN/DD/DCT + bản BMC))
- **MOO 2 mục tiêu:**
  - f1 = min(chi phí vật liệu: thép cọc ống D700 + BTCT dầm/bản)
  - f2 = min(chuyển vị ngang lớn nhất đỉnh bến dưới tổ hợp bao `BAO-ULSB`) hoặc max(hệ số an toàn nhỏ nhất trong các cấu kiện/cọc)
- **MOO 3 mục tiêu (mở rộng):** thêm f3 = min(số bất thường mô hình cần xử lý thủ công — VD số cọc thiếu ngàm, số tiết diện thừa không dùng) — mang tính chất "làm sạch mô hình" hơn là mục tiêu kỹ thuật thuần tuý, có thể bỏ qua nếu không phù hợp hướng bài báo.

**13.4. Gợi ý kết nối FEM ↔ optimizer:**
- Dùng SAP2000 OAPI (`SapObject` COM) hoặc export/import lặp lại file `.$2k` để thay đổi biến thiết kế theo từng thế hệ (generation) của thuật toán MOO MATLAB đã có sẵn.
- Vì mô hình chỉ có **1 loại tiết diện cọc thực sự dùng** (`Coc1`, 96 phần tử) — việc tham số hoá **đơn giản hơn nhiều** so với Lạch Huyện (vốn có 2 loại cọc × nhiều nhóm chiều dài): chỉ cần 1 nhóm biến D/t cọc + 1 biến độ xiên + các biến dầm/bản.
- Trước khi chạy optimization thật, cần: (a) ~~xác nhận Fy thép cọc thật~~ **✅ phiên 3: dùng Fy=3.150 kG/cm² proxy theo quyết định người dùng** (vẫn nên đối chiếu lại với chứng chỉ vật liệu thật nếu có thể, xem mục 11), (b) sửa/loại trừ điểm ngàm thiếu tại nút 1945, (c) ~~xác nhận hệ số ag đúng~~ **✅ phiên 3: agR=0,0434g (Phụ lục H TCVN 9386:2012, Huyện Phú Lộc) — xem mục 8.5**, (d) ~~xác nhận phạm vi mô hình~~ **✅ đã xác nhận ở phiên 2: mô hình là Phân đoạn V/5 của cầu chính** — cân nhắc có cần nhân hệ số quy đổi/kiểm tra thêm 4 phân đoạn còn lại hay không tuỳ mục tiêu bài báo.

---

## 14. Ghi chú & giới hạn của dữ liệu (đọc trước khi dùng cho FEM/optimization)

> **Cập nhật phiên 2 (2026-09-11):** Đã đọc thêm thuyết minh TKBVTC-SC2023 (`.docx`, nguồn quyền uy nhất) và 6 file DXF convert từ CAD gốc. Danh sách dưới đây được đánh dấu theo trạng thái: **✅ ĐÃ GIẢI QUYẾT** (có nguồn xác thực, độ tin cậy cao) / **🟡 GIẢI QUYẾT MỘT PHẦN** (có thêm bằng chứng nhưng chưa dứt điểm) / **⚠️ CÒN TỒN NGHI** (chưa có thay đổi so với phiên 1).

1. ✅ **ĐÃ GIẢI QUYẾT — có thuyết minh thiết kế:** Dự án nay đã có thuyết minh (`thong tin du an\2. Thuyet minh TKBVTC_SC2023 - A3.docx`), tuy là hồ sơ **sửa chữa 2023** (không phải thiết kế mới ban đầu) nhưng mô tả đầy đủ hiện trạng kết cấu gốc, địa chất, tiêu chuẩn áp dụng — coi là nguồn quyền uy nhất. Số liệu nào thuyết minh/DXF không đề cập vẫn ghi "chưa xác định", không suy đoán.
2. ✅ **ĐÃ GIẢI QUYẾT — phạm vi mô hình FEM:** Xác nhận mô hình SAP2000 đại diện cho **Phân đoạn V (Block V)** của cầu chính (96 cọc khớp chính xác với số cọc Phân đoạn V theo thuyết minh; nhãn "PHÂN ĐOẠN (BLOCK) V" xuất hiện trên DXF bố trí đệm/mối nối; kích thước mô hình theo Y ~60m ≈ 300m/5 phân đoạn). Xem chi tiết đầu file và mục 6.
3. ⚠️ **CÒN TỒN NGHI — cọc thiếu ngàm:** 96 cọc nhưng chỉ 95 nút được ngàm trong `JOINT RESTRAINT ASSIGNMENTS` (thiếu nút 1945) — thuyết minh/DXF không cung cấp thông tin để giải thích bất thường này, cần kiểm tra lại mô hình gốc SAP2000 (`.sdb`).
4. ✅ **ĐÃ GIẢI QUYẾT — đường kính cọc thép:** Cọc cầu chính chính thức là **D700, t=14mm** (xác nhận bởi thuyết minh + Excel "L coc" tính tay + 3 DXF bố trí đệm/mối nối, tất cả đều khớp). Mọi ghi nhận "D600" đều thuộc kết cấu KHÁC (dolphin thép "Phương án 1" 25 cọc, hoặc cọc BTCT ƯST Φ600 của trụ đỡ/cầu công tác) — không phải cọc cầu chính, không có mâu thuẫn thực sự. Chi tiết xem mục 4. Chênh lệch t=12,6mm (SAP) vs t=14mm (chính thức) được suy luận hợp lý là tiết diện quy đổi sau ăn mòn cho mục đích kiểm định, nhưng **chưa xác nhận bằng văn bản trực tiếp** — vẫn nên hỏi lại đơn vị tính toán.
5. ✅ **ĐÃ GIẢI QUYẾT — tải trọng bích neo:** Xác nhận có **3 cấp bích neo tại 3 vị trí**: 45T và 75T trên cầu chính (Excel "75T" khớp), 150T trên trụ neo T2/dolphin (tên file CAD "150T" khớp) — không mâu thuẫn, chỉ là 2-3 vị trí khác nhau. Chi tiết xem mục 9.
6. ✅ **ĐÃ GIẢI QUYẾT DỨT ĐIỂM (phiên 3) — hệ số gia tốc nền động đất:** Thuyết minh xác nhận CHẮC CHẮN địa điểm công trình là "Xã Lộc Vĩnh, Huyện Phú Lộc, Tỉnh Thừa Thiên Huế". Tra trực tiếp Phụ lục H, TCVN 9386:2012 cho "Huyện Phú Lộc": **agR = 0,0434g** (thay cho ag=0,0368g ghi nhầm theo địa điểm Cát Hải/Hải Phòng trong Excel) — Cấp VI theo MSK-64 (không đổi phân loại). Xem mục 8.5.
7. ✅ **ĐÃ GIẢI QUYẾT PHẦN LỚN — dữ liệu địa chất định lượng:** Nay đã có bảng chỉ tiêu cơ lý γ/φ/C/Is theo 5 lớp đất từ thuyết minh (mục 8.1), bổ sung thêm số liệu cục bộ theo lỗ khoan từ DXF (mục 8.2) và xác nhận ≥12 lỗ khoan (LK1-LK10 năm 2001 + LK1-01/LK2-02 năm 2002, mục 8.3). Vẫn còn thiếu biểu đồ SPT N chi tiết theo độ sâu từng lỗ khoan. ✅ Tên hố khoan "BH11/BH13/BH16" (Excel) nay được **quyết định (phiên 3) thống nhất coi là "LK11/LK13/LK16"** (hệ thống có dữ liệu đầy đủ hơn) — xem mục 8.3.
8. ✅ **ĐÃ GIẢI QUYẾT PHẦN LỚN (phiên 3) — giới hạn chịu lực Mcr/Mu/Pmax:** Vẫn không có giá trị Mcr/Mu/Pmax tính sẵn, nhưng nay đã có đủ số liệu vật liệu để tự tính: bê tông M400 R=40MPa/E=3,3×10⁴MPa + cốt thép CB240-T/CB300-V (xác thực từ thuyết minh), và **Fy=3.150 kG/cm²/Fu=4.900 kG/cm² cho cọc ống thép (proxy mượn từ Lạch Huyện, quyết định người dùng)** thay cho Fy=3.515 kG/cm² mặc định A992 của SAP — xem mục 11.
9. **7 tiết diện cọc thừa không dùng** (`Coc2`…`Coc8`, cùng hình học nhưng khác `AMod`) — khả năng là tàn dư qua các lần chỉnh sửa mô hình 2020-2021, không ảnh hưởng kết quả vì không được gán cho phần tử nào. (Không đổi so với phiên 1.)
10. **Tiết diện `MR`** (18 phần tử, 1,55×1,40m) chưa xác định rõ chức năng — thuyết minh/DXF không nhắc đến tiết diện này riêng biệt; cần kiểm tra trực quan trong SAP2000 (View → mesh) hoặc đối chiếu bản vẽ kết cấu chi tiết (không có trong bộ DXF đã đọc).
11. ✅ **ĐÃ GIẢI QUYẾT PHẦN LỚN — CAD:** Đã đọc được nội dung 6/46 file CAD quan trọng nhất (convert sẵn sang DXF bởi người dùng): bình đồ địa hình, mặt bằng lỗ khoan, mặt cắt địa chất, mặt bằng hiện trạng, 3 phần mặt bằng bố trí đệm/mối nối, chi tiết cọc D600. Text tiếng Việt trong các DXF này gặp **2 kiểu lỗi giải mã khác nhau** tuỳ file: (a) file "04.05. MC dia chat.dxf" cho ra text dạng garbled nhưng NHẤT QUÁN (kiểu font .VnTime/TCVN3 cũ, ví dụ "Ñaù"→"Đá", "seùt"→"sét") — có thể giải mã lại nếu cần bằng bảng ánh xạ TCVN3→Unicode; (b) các file còn lại (23-24, 10/11/12, 06) cho ra ký tự thay thế U+FFFD ("�") không thể phục hồi tự động (mất thông tin byte gốc khi ezdxf giải mã). Với cả 2 trường hợp, đã **suy luận được nội dung bằng cách đối chiếu ngữ cảnh** (thuật ngữ kỹ thuật quen thuộc, đối chiếu song song với thuyết minh Unicode sạch, và các chú thích tiếng Anh song ngữ có sẵn ngay trên bản vẽ) — đủ để trích xuất các số liệu quan trọng (mục 4,6,8,9), KHÔNG cần xây dựng bảng chuyển đổi TCVN3→Unicode đầy đủ 168 cặp. **40/46 file .dwg gốc còn lại vẫn KHÔNG đọc được** (không có bản .dxf tương ứng).
12. **Tổ hợp "Set C"** được định nghĩa trong Excel (hệ số riêng phần khác) nhưng không thấy tổ hợp SAP nào tương ứng trong file `.$2k` — chưa rõ có được kiểm tra ở nơi khác hay bị bỏ qua. (Không đổi so với phiên 1 — thuyết minh sửa chữa không đề cập tổ hợp tải trọng chi tiết.)
13. Số liệu môi trường (gió/dòng chảy/sóng) trong Excel và tải trọng phân bố trên cọc (MT1/MT2) trong SAP **khớp nhau khá tốt** (0,0494 T/m tính tay ≈ 0,049 T/m trong SAP) — đây vẫn là điểm đối chiếu chéo đáng tin cậy trong toàn bộ dữ liệu, nay được củng cố thêm bởi các điều kiện khai thác trong thuyết minh (gió ≤20m/s, dòng chảy ≤1m/s — mục 9).
14. Toàn bộ giá trị số trong Excel COM đôi khi trả về mã lỗi `-2146826265` (tương ứng lỗi `#REF!`/tham chiếu hỏng của Excel) tại một số ô trong sheet "Neo" (mục tải trọng neo do gió/dòng chảy chi tiết theo từng tàu) — các ô này **không đọc được giá trị thật**, đã bỏ qua, không suy đoán thay thế. (Không đổi so với phiên 1.)
15. **Mới phát hiện (phiên 2) — kích thước dầm cần trục không nhất quán giữa các nguồn:** Thuyết minh + SAP đều thống nhất dầm cần trục 130×195cm (1,30×1,95m), nhưng một nhãn trên DXF "Mặt bằng bố trí đệm và mối nối" ghi "Dầm cần trục 1,3×1,6m" (130×160cm) tại một vị trí — khả năng là kích thước cục bộ tại đầu dầm/vị trí mở rộng khác với tiết diện giữa nhịp, chưa xác nhận chắc chắn; không ảnh hưởng lớn vì đa số nguồn (2/3) thống nhất 130×195cm.
16. **Mới phát hiện (phiên 2) — đội tàu thiết kế trong thuyết minh khác với Excel/SAP:** Thuyết minh sửa chữa liệt kê các tàu 30.000DWT/50.000DWT/tàu khách du lịch Quantum-Oasis (năng lực khai thác đã phê duyệt/hiện hữu), KHÔNG nhắc tàu 70.000DWT giảm tải hay container 165.000DWT nào — việc kiểm định tàu 70.000DWT là một nghiên cứu riêng/mới hơn phạm vi thuyết minh sửa chữa 2023. Xem mục 1.
17. ✅ **ĐÃ GIẢI QUYẾT theo quyết định người dùng (phiên 3) — tên hố khoan giữa 2 hệ thống:** Excel "L coc" dùng tên "LK2, BH11, BH13, BH16"; DXF/thuyết minh chỉ dùng tiền tố "LK" (LK1–LK10, LK16, LK17, LK19, LK20, LK1-01, LK2-02). Vì hệ thống "LK..." có dữ liệu đầy đủ hơn (toạ độ, mặt cắt địa chất, chỉ tiêu cơ lý — trong khi "BH..." của Excel chỉ có SPT N rời rạc), **người dùng quyết định thống nhất gọi "BH11/BH13/BH16" = "LK11/LK13/LK16"** và dùng tên "LK..." xuyên suốt tài liệu — xem mục 8.3. Đây là quy ước làm việc, chưa phải bằng chứng vật lý tuyệt đối.
18. **Mới (phiên 3) — hệ số ag/Fy thép cọc đã được xử lý bằng quyết định của người dùng, không phải trích xuất trực tiếp từ hồ sơ Chân Mây:** (a) agR=0,0434g lấy từ tra cứu độc lập Phụ lục H TCVN 9386:2012 theo địa điểm đã xác nhận (mục 8.5) — đây LÀ số liệu chính thức đúng chuẩn quốc gia cho địa điểm, độ tin cậy cao; (b) Fy=3.150/Fu=4.900 kG/cm² của thép cọc là **giá trị mượn (proxy) từ dự án Lạch Huyện**, cùng áp dụng TCVN 9245:2012 nhưng KHÔNG phải số liệu xác nhận riêng cho lô thép cọc D700 đã thi công tại Chân Mây — độ tin cậy thấp hơn, nên ghi rõ giả định này khi viết bài báo/công bố kết quả.
