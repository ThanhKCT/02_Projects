# Dữ liệu Mô hình FEM – Cầu tàu VIPGreenPort (Viconship) 30.000DWT – Đình Vũ, Hải Phòng
### (Tổng hợp phục vụ bài toán tối ưu SOO / MOO — tham khảo cấu trúc `FEM_PhanDoan_TieuChuan_100000DWT.md`)

**Dự án:** Cầu cảng Viconship (VIPGreenPort) cho tàu container trọng tải 30.000DWT neo cập tại Đình Vũ, Hải Phòng.
**Chủ đầu tư:** Công ty Cổ phần Container Việt Nam / Công ty Cổ phần Cảng Xanh VIP. **Đơn vị tư vấn thiết kế:** Công ty CP Tư vấn Xây dựng CT Hàng hải. **Ngày lập thuyết minh (kè):** 10/2014. **Ngày lập bảng tính bến (VGP):** 2014 (cập nhật số liệu địa chất 2008/2012/2014).

**Nguồn dữ liệu đã đối chiếu chéo:**
| Nguồn | File |
|---|---|
| Bảng tính tải trọng & kết cấu bến (đọc bằng Excel COM, không lỗi font) | `Ke VIp grenn port/1.Tinh ben VGP.xls` (14 sheet: So lieu, Tai trong, To hop, TH, Hinh hoc, Va, Neo, Ltt(LK3), Ltt(BH17), CD day, Ngoai le, Noi suy…) |
| Thuyết minh TKBVTC tường cừ thép gia cố kè sau cầu (đọc bằng antiword, font TCVN3 lỗi 1 phần → đối chiếu số liệu bằng Excel) | `Ke VIp grenn port/Thuyet minh TKBVTC (17.10.2014).doc` |
| Mô hình phân tích kết cấu (SAP2000 v16, đơn vị **Tonf, m, °C**) | `SapV14/Cau tau.s2k` (bản export mới nhất, đã diff xác nhận **giống hệt hình học** với `Cau tau dau vao.s2k`/`Cau tau.$2k` — chỉ khác version SAP2000 export 16↔24) |
| Bản vẽ CAD (DXF, font TCVN3 → giải mã thủ công bằng bảng ký tự đối chiếu, KHÔNG dùng ezdxf tự động vì đây là font .VnTime/TCVN3 khác chuẩn Unicode) | `08_10-20_22. MB ben_MB dam coc(PA2).dxf` (mặt bằng bến + mặt bằng dầm cọc), `11_13. Mat dung ben.dxf` (mặt đứng), `14.16.Mat cat ngang.dxf` (mặt cắt ngang), `23_27. Bang toa do coc Cau-Ke.dxf` (bảng toạ độ cọc) |

> **Kết luận về phạm vi mô hình:** Mô hình `.s2k` có kích thước mặt bằng X≈24,6 m (ngang bến) × Y≈75,44 m (dọc bến). Chiều rộng bến toàn tuyến theo bảng tính là **24 m** (khớp chính xác, chênh lệch 0,6m là do dầm mép bến/dầm ngang đầu nhô ra ngoài trục cọc biên). Chiều dài giai đoạn 1 là **226,32 m = 3 × 75,44 m** — khớp gần như tuyệt đối với 3 lần chiều dài mô hình. **Kết luận: mô hình SAP hiện có là 1 trong 3 phân đoạn tiêu chuẩn của cầu tàu giai đoạn 1** (tương tự cấu trúc phát hiện ở dự án Lạch Huyện tham khảo).

---

## 1. Tổng quan kết cấu

| Thông số | Giá trị |
|---|---|
| Loại kết cấu | Bến liền bờ (cầu tàu bệ cọc cao), hệ dầm ngang – dầm dọc – dầm cần trục BTCT trên nền cọc ống BTCT dự ứng lực |
| Tổng chiều dài bến giai đoạn hoàn thiện | 377,2 m |
| Chiều dài bến giai đoạn 1 (đang khai thác) | **226,32 m = 3 phân đoạn × 75,44 m** |
| Chiều rộng mặt bến | **24,0 m** |
| Cao trình đỉnh bến | **+5,50 m** (Hải đồ) |
| Cao trình đáy bến giai đoạn 1 | −10,60 m (Hải đồ) |
| Cao trình đáy bến giai đoạn hoàn thiện | −11,50 m (Hải đồ) |
| Mực nước cao thiết kế (P1% mực nước giờ) | +3,75 m |
| Mực nước thấp thiết kế (P99% mực nước giờ) | +0,80 m |
| Khu nước trước bến | Bkn = 75 m; Lkn = 380 m |
| Vị trí | Sông Cấm, Đình Vũ, Hải Phòng |

**Tàu thiết kế (bảng "So lieu" + "Neo"):**
| Loại tàu | Trọng tải | L (m) | B (m) | Lượng giãn nước (T) | Tc mớn đầy tải (m) | T0 mớn không tải (m) |
|---|---|---|---|---|---|---|
| Container | 10.000 DWT | 159,0 | 23,5 | 15.031 | 8,00 | 4,92 |
| Container | 20.000 DWT | 186,0 | 27,1 | 29.099 | 9,90 | 6,20 |
| Container | **30.000 DWT (thiết kế)** | 210,0 | 30,0 | 42.825 | 10,70 | 6,75 |
| Tàu dầu | 20.000 DWT | 83,6 | 13,1 | 3.293 | 4,90 | 2,27 |

---

## 2. Hình học mô hình FEM (SAP2000)

| Trục | Min | Max | Ghi chú |
|---|---|---|---|
| X (ngang bến) | −0,59 m | 24,00 m | 5 hàng cọc tại lưới **A=2,75 / B=8,0 / C=13,25 / D=18,0 / E=22,75 m**; bước ngang không đều (5,25/5,25/4,75/4,75 m) |
| Y (dọc bến) | 0,13 m | 75,57 m | Bước cọc dọc bến chủ yếu **4,80–4,90 m** (16–17 cọc/hàng) |
| Z (cao độ cục bộ) | −21,09 m | 0,00 m | Z=0 tại đỉnh cọc/đáy hệ dầm (≈ cao độ đáy đài +4,07 m Hải đồ theo bảng tính Ltt) |

**Quy mô mô hình:**
- Số nút (Joints): **2.532**
- Số phần tử thanh (Frame elements): **960** (trong đó 132 phần tử cọc)
- Số phần tử tấm vỏ (Area/Shell elements): **2.289**
- Đơn vị làm việc: Tonf – m – °C (SAP2000 v16.0.0, mã kiểm tra tiết diện tham chiếu nội bộ ACI 318-05/IBC2003 & AISC-LRFD93 — không phải tiêu chuẩn thiết kế thực tế)

---

## 3. Vật liệu

| Vật liệu (SAP) | Loại | E (T/m²) | γ (T/m³) | Đối chiếu bảng tính "Tai trong" (Bảng 5-1) |
|---|---|---|---|---|
| `M600` | Bê tông cọc (ƯST) | 3.400.000 | (khai báo 0, tự trọng cọc không tính tự động trong SAP — cộng thủ công) | Bê tông DƯL: E=3.400.000 T/m², γ khô=2,5 T/m³, γ dưới nước=1,519 T/m³ |
| `M350` | Bê tông dầm/bản | 3.100.000 | 2,50 | Bêtông M350: E=3.100.000 T/m², γ khô=2,5 T/m³, γ dưới nước=1,519 T/m³ — khớp |
| `A615Gr60` | Cốt thép dọc | 20.389.019 | 7,849 | Thép: E=21.000.000 T/m² (bảng tính) — gần đúng (chênh do quy đổi ksi→T/m²), γ khô=7,85 T/m³, γ dưới nước=6,869 T/m³ — khớp |

Cốt thép dọc chủ các dầm theo `FRAME SECTION PROPERTIES 02`: `BarSizeL=#9`, đai `BarSizeC=#4 @150mm`, lớp bê tông bảo vệ `Cover=40mm` (áp dụng cho DN, DD, DCT-B/G/S, DNHT).

---

## 4. Tiết diện thanh (Frame Sections) — đối chiếu SAP ↔ Bảng tính "Hinh hoc"

| SectionName (SAP) | Tên cấu kiện (bảng tính) | Vật liệu | b × h (SAP) | b × h (bảng tính "Hinh hoc") | Ghi chú |
|---|---|---|---|---|---|
| `Coc` | Cọc ống BTCT dự ứng lực D700 | M600 | Pipe D=700mm, t=130mm | **D=700mm, t=130mm, d(trong)=440mm, A=232.792 mm², I=9,946×10⁹ mm⁴** | **Khớp tuyệt đối từng chữ số** với SAP (Area=0,232792 m²) |
| `DN` | Dầm ngang phía trong | M350 | 100×150cm | 100×150cm, A=15.000cm², Ix=28.125.000cm⁴ | Khớp |
| `DD` | Dầm dọc thường | M350 | 100×150cm | 100×150cm | Khớp |
| `DCT-S` | Dầm cần trục phía sông | M350 | 120×220cm | 120×220cm, A=26.400cm², Ix=106.480.000cm⁴ | Khớp |
| `DCT-B` | Dầm cần trục phía bờ | M350 | 120×220cm | 120×220cm | Khớp |
| `DCT-G` | Dầm cần trục giữa bến | M350 | 100×180cm | 100×180cm, A=18.000cm², Ix=48.600.000cm⁴ | Khớp |
| `DNHT` | Dầm ngang đầu (đầu phân đoạn) | M350 | **220×110cm** (A=2,42m²) | **160×220cm** (A=35.200cm²=3,52m²) | ⚠️ **KHÔNG khớp** — xem mục 14.1 |

Ghi chú tên gọi trên bản vẽ mặt bằng (`08_10-20_22...dxf`): dầm cần trục có hậu tố phân đoạn, ví dụ `DCTG1/DCTG2`, `DCTS1/DCTS2`, `DCTB1/DCTB2`, `DN1/DN2`, `DD1/DD2`, và thêm loại **`DMB` (dầm mép bến), b×h=35×150cm** không thấy xuất hiện là section riêng trong SAP — nhiều khả năng được gộp vào tiết diện tấm `DTT`/`BTT` (xem mục 5).

---

## 5. Tiết diện tấm (Area Sections)

| Section (SAP) | Vật liệu | Dày (m) | Đối chiếu bảng tính | Diễn giải |
|---|---|---|---|---|
| `BAN` | M350 | 0,40 | "Bản mặt cầu": dày 40cm, ký hiệu `BAN` | Bản mặt cầu tàu (deck slab) — khớp tuyệt đối |
| `DTT` | M350 | 0,35 | "Bản tựa" (bản tựa tàu/bản mép bến): dày 35cm, ký hiệu ghi trong bảng tính là **`BTT`** | Cùng cấu kiện, **lệch tên `DTT` (SAP) ↔ `BTT` (bảng tính)** — cùng độ dày 35cm nên xác định được là 1 cấu kiện, chỉ khác quy ước đặt tên giữa file tính và file FEM |

**Lớp phủ mặt cầu:** bê tông M200 dày 40cm, tải trọng qui đổi 0,88 T/m² (không mô hình như 1 material riêng trong SAP, được cộng vào tĩnh tải `BT`).

---

## 6. Hệ cọc (per 1 phân đoạn ~75,44 m, mô hình SAP)

| Loại cọc | Số lượng/phân đoạn (SAP) | Đường kính | Chiều dài chế tạo (theo bảng tính Ltt) | Chiều dài mô hình FEM (đỉnh cọc → ngàm) | Số cọc xiên |
|---|---|---|---|---|---|
| Cọc ống BTCT ƯST D700-130 (M600) | **132** | D=700mm, t=130mm, d trong=440mm | ~40,0m (từ đáy đài đến mũi cọc ≈15,57 + 25,43 = 41,0m tại LK3) | 14,42 – 21,09 m (8 nhóm chiều dài khác nhau theo vị trí địa chất) | **70/132** (độ xiên **8:1** theo ghi chú bản vẽ, hàng phía sông) |
| **Tổng GĐ1 (3 phân đoạn, suy từ mô hình SAP)** | **≈ 396 cọc** | | | | Đáng tin cậy hơn số liệu bảng thống kê cọc trích từ DXF (xem mục 14.2) |

**Phương pháp xác định chiều dài tính toán cọc** (sheet `Ltt(LK3)`, `Ltt(BH17)` — theo TCXD 205:1998, phương pháp hệ số biến dạng αbđ):
- Cao độ đáy đài: **+4,07 m**; cao độ mặt đất tự nhiên (nạo vét): **−11,50 m**; cao độ mũi cọc: **−36,93 m**
- Chiều dài cọc tự do (đáy đài→MĐTN): 15,57 m; chiều dài ngập trong đất: 25,43 m
- Hệ số biến dạng αbđ = 0,418 (tại LK3) / 0,354 (tại BH17); hệ số tỷ lệ nền k = 279,71 (LK3) / 121,25 T/m⁴ (BH17)
- Chiều rộng qui ước cọc bqư = 1,55 m (D=0,7m)
- → Do hệ số nền khác nhau theo từng lỗ khoan, **chiều dài ngàm ảo trong mô hình FEM khác nhau tại từng vị trí** (giải thích dải giá trị 14,42–21,09m ở trên); biên tại đáy cọc trong SAP được gán **ngàm cứng hoàn toàn** (không dùng lò xo nền rời rạc).

**Cọc kè sau cầu (khác với cọc cầu tàu, không nằm trong mô hình `.s2k` này):** D500-280mm (t=110mm), L=38m — dùng cho hệ tường góc kè, không phải cọc chịu lực chính của cầu tàu.

---

## 7. Điều kiện biên

- **Ngàm chân cọc** (`JOINT RESTRAINT ASSIGNMENTS`): toàn bộ **132 nút chân cọc** bị khoá 6 bậc tự do `U1=U2=U3=R1=R2=R3=Yes` — ngàm cứng tuyệt đối tại cao độ ngàm ảo (đã tính theo mục 6), **không có bảng lò xo nền (`JOINT SPRING ASSIGNMENTS`)** trong file `.s2k` này → khác với cách làm ở dự án tham khảo Lạch Huyện (dùng lò xo trục U3).
- Đầu cọc (Z=0) liên kết cứng vào hệ dầm/bản (không có giải phóng mô men).
- Giữa các phân đoạn: **khe phân đoạn rộng 2cm, có đặt băng chặn nước** (theo bản vẽ mặt đứng) — biên phân đoạn không được mô hình hoá tường minh trong 1 file `.s2k` (chỉ có 1 phân đoạn/model).

---

## 8. Địa chất công trình (thuyết minh mục II.2, đối chiếu bảng tính & bản vẽ mặt cắt)

| Lớp | Mô tả | Chiều dày (m) | γw (g/cm³) | C (kG/cm²) | φ | Is / e | Ghi chú |
|---|---|---|---|---|---|---|---|
| Đắp | Cát san lấp | 0,9 – 3,9 | — | — | — | — | San lấp mặt bằng |
| 1 | Bùn sét pha xám nâu, xám xanh | 4,2 – 11,6 | 1,74 | 0,06 | 4°58' | Is=1,53 | Yếu, chiều dày rất lớn |
| 2a | Sét pha xám vàng lẫn sạn, dẻo mềm | 3,3 (chỉ BH17) | 2,00 | 0,11 | 11°18' | Is=0,55 | Chịu tải trung bình |
| 2 | Sét xám ghi, xám xanh, dẻo chảy | 2,6 – 6,5 | 1,77 | 0,11 | 7°16' | Is=0,87 | Yếu |
| 3 | Sét xám vàng/ghi, dẻo cứng | 2,6 – 6,5 | 1,89 | 0,22 | 13°19' | Is=0,35 | Tương đối tốt |
| 4 | Sét xám nâu/ghi, dẻo mềm | 1,5 – 17,2 | 1,87 | 0,13 | 9°48' | Is=0,70 | Trung bình |
| 5 | Sét pha xám vàng/ghi, dẻo chảy | 5,6 – 13,5 | 1,90 | 0,93 (¹) | 8°21' | Is=0,10 | Yếu — (¹) giá trị C bất thường, cần đối chiếu bảng gốc |
| 6 | Sét xám vàng/ghi loang lổ, dẻo cứng | 2,8 – 7,9 | 1,97 | 0,23 | 13°49' | Is=0,41 | Tương đối tốt |
| 7 | Cát pha vàng xám/ghi, dẻo | 1,0 – 4,5 | 2,05 | 0,09 | 12°18' | Is=0,56 | Tốt |
| 8 | Sét pha vàng xám/ghi, dẻo mềm | 2,8 – 15,8 | 1,95 | 0,11 | 10°19' | Is=0,65 | Trung bình |
| 9 | Cát bụi xám ghi/vàng, chặt vừa | 1,7 – 14,9 | γ=2,66 | — | φk=32°07' | — | Tốt (SPT N=12–32) |
| 10 | Sét pha vàng xám, dẻo chảy | 1,0 – 9,3 | 2,02 | 0,09 | 8°06' | Is=0,88 | Yếu |
| 11 | Cát pha xám nâu/ghi, dẻo | 1,8 – 3,2 | 2,03 | 0,11 | 13°22' | Is=0,51 | Tương đối tốt |
| 12 | Cát sỏi lẫn cuội, kết cấu rất chặt | 0,3 – 3,1 | γ=2,66 | — | φk=33°09' | — | Tốt (SPT N=40–45) |
| 13 | Sét pha nâu đỏ, nửa cứng (phong hoá) | 1,9 – 5,5 | 2,07 | 0,22 | 18°16' | Is=0,12 | Tốt, SPT ≥50 |
| 14 | Đá sét kết nâu đỏ phong hoá nhẹ | chưa xác định | — | — | — | — | Đá gốc, cường độ nén khô 114,5 kG/cm² |

- Mực nước ngầm/thuỷ triều: biên độ triều lớn (3–4m khi triều cường); MNCTK +3,75m, MNTTK +0,80m (Hải đồ).
- Vận tốc dòng chảy tính toán: dọc bến Vdcl=1,62 m/s; ngang bến Vdct=0 m/s; chiều cao sóng hs=0,5m.
- Vận tốc gió khai thác bình thường V≤20,7 m/s (cấp 8); gió bão tính tải cần trục V=55 m/s.

---

## 9. Tải trọng (đối chiếu SAP `LoadPat` ↔ bảng tính "Tai trong"/"Va"/"Neo")

| LoadPat (SAP) | Loại | Diễn giải (bảng tính) | Giá trị |
|---|---|---|---|
| `DEAD`, `BT` | DEAD | Tự trọng cấu kiện (SAP tự tính, trừ cọc) + lớp phủ mặt cầu M200 dày 40cm | Lớp phủ 0,88 T/m²; bản mặt cầu tự trọng 1,0 T/m² (40cm×2,5T/m³) |
| `VA` | LIVE | Lực va tàu (30.000DWT), theo PIANC 2002 / OCDI Nhật 2002 | **Hx (⊥ bến) = 166 T; Hy (∥ bến) = 83 T** (SAP gán 1 điểm F1=150/F2=−75 — chênh do phân bố cho nhiều đệm/điểm đặt tải, xem mục 14.3) |
| `NEO` | LIVE | Lực neo tàu (bích 100T), theo 22TCN 222-95 | **Sq=26,43 T; Sn=45,79 T; Sv=44,36 T** — khớp tuyệt đối với `JOINT LOADS-FORCE` trong SAP (F1=−26,43; F2=45,79; F3=44,36) |
| `OTO` | Moving Load | Xe đầu kéo + trailer/chassic tương đương ôtô H30 | Trục trước 6T, trục sau 12T; bề rộng vệt bánh 0,3–0,6m; khoảng cách tim trục 6m+1,6m |
| `HH1…HH6` | LIVE (Area Uniform) | 6 kịch bản chất hàng hoá (chất từng nhịp, rải đều, ngoài phạm vi ray QC…) | Uniform = **4,0 T/m²** trong phạm vi từ ray cần trục sông vào bờ; **2,0 T/m²** dải 2m mép ngoài bến đến ray sông; không xếp hàng trong phạm vi 4m quanh ray |
| `CT-B(T)`, `CT-S(T)` | (tĩnh quy đổi) | Tải cần trục KE 45T (khổ ray 10,5m) quy đổi tĩnh theo trục X/Y | Tải max 1 chân cẩu 200T; 1 bánh 25T; 8 bánh/chân; spacing bánh (0,68-1,93-0,68-1,93-0,68-1,93-0,68-10,5-0,68…)m |
| `CT-QC` (moving) | BRIDGE LIVE | Cẩu giàn QC 40T dưới móc, khổ ray 20m, khi làm hàng | Bánh phía sông **35,4 T**; bánh phía bờ **29,4 T** — khớp tuyệt đối với `VEHICLES` trong SAP (AxleLoad) |
| `QC(BAO)` | LIVE | Cẩu giàn QC khi có gió bão (V=55m/s, không tải) | Bánh phía sông **28,5 T**; bánh phía bờ **43,8 T** — khớp tuyệt đối với `JOINT LOADS-FORCE` (F3=−28,5 / −43,8) |

**Tải trọng neo do gió & dòng chảy (sheet "Neo", theo công thức OCDI):** tính riêng cho từng cỡ tàu (có hàng/không hàng), ví dụ tàu 30.000DWT có hàng: Wq=41,7T (ngang), Wn=17,2T (dọc); không hàng: Wq=69,5T, Wn=21,8T — các thành phần này được tổ hợp ra giá trị neo cuối cùng Sq/Sn/Sv nêu trên.

**Thiết kế đệm tàu:** loại **Vsx-P 800H (cao su H1)**, năng lượng hấp thụ thiết kế 55,7 T·m (> năng lượng va tính toán tàu 30.000DWT = 22,24 T·m → hệ số dự phòng lớn vì đệm dùng chung cho cả 3 cỡ tàu 10-30k DWT); phản lực nén max 166T; hệ số ma sát mặt đệm cao su/vỏ tàu f=0,5; khoảng cách treo đệm thiết kế 9,8m (< khoảng cách max cho phép 14,74m).

---

## 10. Tổ hợp tải trọng (bảng tính "TH": 37 tổ hợp; SAP: `COMB1…COMB36` + `BAO`)

| Nhóm | Thành phần | Số lượng |
|---|---|---|
| Comb1 | BT | 1 |
| Comb2–13 | BT + (VA / NEO / HH1‑6 / OTO / CT-KE / CT-QC / QC-BAO) từng cái một | 12 |
| Comb14–22 | BT + VA + (HH1‑6 / OTO / CT-KE / CT-QC / QC-BAO) | 9 |
| Comb25–26 | BT + VA + (OTO+CT-KE) / (OTO+QC-BAO) | 2 |
| Comb27–32 | BT + NEO + HH1‑6 | 6 |
| Comb33–37 | NEO + (OTO/CT-KE/QC-BAO/OTO+CT-KE/OTO+QC-BAO), không có BT | 5 |

Tổ hợp bất lợi nhất cho kiểm tra bão thường là **BT + NEO + QC(BAO)** (Comb35/37) — tương đương tổ hợp `"BAO"` trong SAP.

---

## 11. Tiêu chuẩn thiết kế áp dụng (thuyết minh mục II.4)

TCVN 2737:1995 (tải trọng & tác động) · TCVN 5574:2012 (BTCT) · TCVN 5575:2012 (kết cấu thép) · TCXD 205:1998 (móng cọc — dùng tính chiều dài ngàm ảo cọc, mục 6) · TCVN 9346:2012 (chống ăn mòn môi trường biển) · 22TCN 207-92 (công trình bến cảng biển) · 22TCN 222-95 (tải trọng sóng/tàu lên công trình thuỷ — dùng tính lực neo, mục 9) · TCVN 4253:2012, TCVN 4116:1985 (nền & kết cấu thuỷ công) · TCVN 7888:2008 (cọc BTCT ly tâm ứng lực trước) · PIANC 2002 & OCDI (Nhật) 2002 (năng lượng va tàu, mục 9) · cùng nhóm tiêu chuẩn vật liệu/thí nghiệm/thi công TCVN đầy đủ liệt kê trong thuyết minh TKBVTC.
Phần mềm SAP2000 v16.0.0 tham chiếu nội bộ mã **ACI 318-05/IBC2003** (bê tông) và **AISC-LRFD93** (thép) chỉ để kiểm tra tiết diện tự động — thiết kế thực tế theo hệ TCVN/22TCN nêu trên.

---

## 12. Đề xuất khung bài toán tối ưu SOO / MOO

> Phần này là **đề xuất kỹ thuật** dựa trên dữ liệu trên, cần xác nhận/điều chỉnh theo mục tiêu cụ thể của bài báo.

**12.1. Biến thiết kế (design variables) khả dĩ:**
| Biến | Ký hiệu | Miền giá trị tham khảo |
|---|---|---|
| Đường kính ngoài cọc BTCT ƯST | D_coc | 500 – 900 mm (hiện D700) |
| Chiều dày thành cọc | t_coc | 100 – 150 mm (hiện 130mm) |
| Khoảng cách cọc dọc bến | s_y | 4,0 – 5,5 m (hiện 4,80–4,90m) |
| Khoảng cách cọc ngang bến | s_x | 4,5 – 5,5 m (hiện 4,75–5,25m, 5 hàng) |
| Độ xiên cọc hàng biên | rake | 1:6 – 1:10 (hiện 8:1) |
| Kích thước dầm ngang/dọc DN, DD | b×h | quanh 100×150cm |
| Kích thước dầm cần trục DCT-S/B/G | b×h | quanh 120×220cm / 100×180cm |
| Chiều dày bản mặt cầu BAN | t_ban | quanh 400mm |
| Chiều dài cọc (theo địa chất từng vị trí) | L_coc | theo cao độ mũi cọc yêu cầu, tham chiếu mục 6 |

**12.2. Ràng buộc (constraints):**
- Sức chịu tải cọc theo đất nền (TCXD 205:1998) tại từng vị trí địa chất (LK3, BH17… — mục 6, 8)
- Chuyển vị ngang đỉnh bến dưới tổ hợp bão (BT+NEO+QC-BAO) ≤ giới hạn khai thác cần trục
- Kiểm tra mô men/lực dọc cọc theo TCVN 5574:2012 (chưa có Mu/Pmax công bố sẵn trong hồ sơ — cần tính bổ sung hoặc lấy từ catalogue cọc PHC D700-130)
- Năng lượng va tàu hấp thụ ≤ khả năng đệm đã chọn (55,7 T·m, mục 9)
- Toàn bộ 37 tổ hợp tải trọng mục 10 phải được kiểm tra, đặc biệt tổ hợp bão

**12.3. Hàm mục tiêu (objectives) gợi ý:**
- **SOO:** min(khối lượng vật liệu quy đổi chi phí = f(số cọc, D, t, L_coc, thể tích BT dầm/bản))
- **MOO 2 mục tiêu:**
  - f1 = min(chi phí vật liệu: BTCT cọc D700 + BT dầm DN/DD/DCT + bản BAN)
  - f2 = min(chuyển vị ngang lớn nhất đỉnh bến dưới tổ hợp bão) hoặc max(hệ số an toàn nhỏ nhất)
- **MOO 3 mục tiêu:** thêm f3 = min(số nhóm chiều dài cọc khác nhau — hướng tới tiêu chuẩn hoá thi công, hiện có ít nhất 8 nhóm chiều dài/phân đoạn)

**12.4. Gợi ý kết nối FEM ↔ optimizer:**
- Dùng SAP2000 OAPI (COM `SapObject`, sẵn có do máy đã cài Office) hoặc lặp export/import `.s2k` theo từng thế hệ GA/NSGA-II.
- Vì mô hình chỉ đại diện **1/3 phân đoạn** GĐ1 (226,32m/75,44m), kết quả tối ưu trên 1 phân đoạn có thể nhân 3 để ước tính toàn GĐ1 — cần kiểm tra lại điều kiện biên tại khe phân đoạn (2cm, có băng chặn nước) khi ngoại suy.
- Nên tham số hoá cọc theo **nhóm chiều dài** (8 nhóm hiện có, mục 6) thay vì từng cọc riêng để giảm số biến, tương tự khuyến nghị ở dự án Lạch Huyện tham khảo.

---

## 13. Ghi chú & giới hạn của dữ liệu (đọc trước khi dùng cho FEM/optimization)

1. **Tiết diện `DNHT` không khớp giữa SAP (110×220cm, A=2,42m²) và bảng tính "Hinh hoc" (160×220cm, A=3,52m²).** Đây là "dầm ngang đầu" tại 2 đầu mỗi phân đoạn (48 phần tử/phân đoạn) — cần mở lại file SAP2000 gốc (View → Section) hoặc hỏi lại đơn vị thiết kế để xác nhận kích thước đúng trước khi dùng làm baseline tối ưu.
2. **Số lượng cọc toàn GĐ1 có 2 nguồn không khớp nhau:** (a) suy từ hình học SAP (3 phân đoạn × 132 cọc = 396 cọc — đáng tin cậy vì dựa trên hệ lưới nhất quán); (b) trích từ bảng thống kê cọc trên bản vẽ mặt bằng DXF (`216 xiên + 248 thẳng` cho phân đoạn 1-4, `100 xiên + 116 thẳng` cho phân đoạn 5-6 — có thể lệch do thứ tự text khi trích xuất tự động từ DXF không theo đúng cấu trúc bảng gốc, y hệt vấn đề đã gặp ở dự án Lạch Huyện tham khảo). **Nên ưu tiên số liệu (a).**
3. **Chiều dày thành cọc D700 có 2 giá trị khác nhau trên 2 bản vẽ:** bản vẽ mặt cắt ngang & mặt đứng ghi "D(70-44)" → t=130mm (khớp bảng tính + SAP); riêng bản vẽ mặt bằng dầm cọc lại ghi "D=700mm-T=110mm". **Giá trị 130mm được xác nhận bởi 3/4 nguồn (SAP, bảng tính Hinh hoc, bản vẽ mặt cắt/mặt đứng) nên đáng tin cậy hơn.**
4. **File `Cau tau.s2k` và `Cau tau dau vao.s2k`/`Cau tau.$2k`** đã kiểm tra là **cùng một mô hình hình học** (số nút, số phần tử, bbox giống hệt), chỉ khác việc được export bởi SAP2000 phiên bản 16 và 24 ở 2 thời điểm khác nhau — không cần xử lý như 2 mô hình riêng biệt.
5. **File thuyết minh `.doc` bị lỗi font khi đọc bằng `antiword`** (bảng chữ TCVN3/VNI hiển thị sai dấu tiếng Việt) — **toàn bộ số liệu định lượng dùng trong tài liệu này đã được đối chiếu và ưu tiên lấy từ bảng tính `.xls` đọc qua Excel COM (giữ nguyên Unicode)**, đáng tin cậy hơn nhiều so với suy đoán từ text lỗi font.
6. **Bản vẽ DXF dùng font .VnTime/TCVN3** (không phải font chuẩn hệ điều hành) — `ezdxf` đọc ra được các entity TEXT/MTEXT nhưng chuỗi ký tự vẫn ở dạng byte gốc của font TCVN3 (không tự giải mã sang Unicode). Việc dịch sang tiếng Việt có dấu ở tài liệu này được suy luận thủ công dựa theo mẫu ký tự và ngữ cảnh kỹ thuật, đã đối chiếu chéo với bảng tính Excel ở những chỗ có số liệu định lượng trùng nhau (D700-130, load values, kích thước dầm…) — độ tin cậy cao cho các mục đã đối chiếu, cần thận trọng với các dòng text thuần chữ chưa đối chiếu được (ví dụ 1 số ghi chú thi công nhỏ trong bản vẽ mặt bằng).
7. **Không có bảng lò xo nền (`JOINT SPRING ASSIGNMENTS`)** trong mô hình `.s2k` — khác với cách mô hình hoá kiểu lò xo trục ở dự án Lạch Huyện tham khảo. Ở đây TCXD 205:1998 được dùng để tính **trước** 1 chiều dài ngàm ảo tương đương rồi gán ngàm cứng tại đáy — nghĩa là độ cứng nền đã được "ẩn" vào chiều dài cọc mô hình, cần lưu ý khi so sánh độ nhạy thiết kế giữa 2 dự án.
8. **Giá trị "Sức chịu tải cho phép Pmax / Mô men nứt Mcr / Mô men phá huỷ Mu" của cọc D700-130 chưa có sẵn** trong hồ sơ đã đọc (khác với dự án Lạch Huyện có ghi rõ trên bản vẽ) — cần tra catalogue nhà sản xuất cọc PHC D700-130 hoặc tính theo TCVN 7888:2008 trước khi dùng làm ràng buộc cứng trong bài toán tối ưu.
9. Lực va tàu gán trong SAP tại 1 nút (F1=150T/F2=−75T) thấp hơn giá trị tổng tính toán trong bảng tính (Hx=166T/Hy=83T) — chênh lệch hợp lý vì tải va thực tế phân bố cho 2 đệm tàu liền kề, không dồn hết vào 1 điểm; không phải là lỗi số liệu.
