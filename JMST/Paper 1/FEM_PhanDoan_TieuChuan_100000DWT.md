# Dữ liệu Mô hình FEM – Phân đoạn Tiêu chuẩn Cầu tàu 100.000DWT
### (Tổng hợp phục vụ bài toán tối ưu SOO / MOO)

**Dự án:** Cảng cửa ngõ quốc tế Hải Phòng (Lạch Huyện) – Hợp phần B (2 bến khởi động) – Gói thầu thiết kế **XL01**: Cầu tàu 100.000DWT, xử lý nền đất yếu gầm bến, bến sà lan, nạo vét khu nước đậu tàu.
**Chủ đầu tư:** Công ty TNHH Cảng Container Quốc tế Hải Phòng (HICT). **Đơn vị thiết kế:** Công ty CP Tư vấn Xây dựng CT Hàng hải. **Ngày lập thuyết minh:** 12/2014.

**Nguồn dữ liệu đã đối chiếu chéo:**
| Nguồn | File |
|---|---|
| Thuyết minh thiết kế kỹ thuật | `Thuyet minh 06.12.doc` |
| Bản vẽ (AutoCAD, đã convert DXF, giải mã font TCVN3→Unicode bằng Python/ezdxf) | `02-05. Mat bang, mat dung.dxf`, `06. Mat ben.dxf`, `07..15. Mat cat ngang.dxf`, `16..28. Mat bang dam coc.dxf` |
| Mô hình phân tích kết cấu | `Ben 100.000DWT KT.s2k` (SAP2000 v14.1.0, đơn vị **Tonf, m, °C**) |
| Bảng tính tải trọng | `1.Tai trong 100.000DWT..xls` |

> **Kết luận về phạm vi mô hình:** File `.s2k` không gán số hiệu phân đoạn cụ thể (bảng `PROJECT INFORMATION` để trống). Đối chiếu kích thước, số lượng cọc và cao trình với thuyết minh + bản vẽ cho thấy đây là **mô hình TIÊU BIỂU/ĐIỂN HÌNH cho 1 trong 10 phân đoạn** (750m ÷ 10 = 75m/đoạn) — dùng làm mẫu tính toán chung, áp dụng lặp lại cho toàn tuyến bến (xem mục 12 – Ghi chú).

---

## 1. Tổng quan kết cấu

| Thông số | Giá trị |
|---|---|
| Loại kết cấu | Bến liền bờ, bệ cọc cao đài mềm (dầm – bản BTCT trên nền cọc) |
| Chiều dài toàn tuyến cầu cảng | 750,0 m (10 phân đoạn) |
| Chiều dài 1 phân đoạn (mô hình) | ~75,0 m (14 nhịp cọc × 5,1 m) |
| Chiều rộng mặt cầu | 50,0 m (mô hình: bề rộng dựng hình ~51,4 m tính cả phần mở rộng) |
| Cao trình đỉnh bến | +5,50 m (Hải đồ) |
| Cao trình đáy bến (hoàn thiện) | −16,0 m (Hải đồ) |
| Mực nước cao thiết kế (P1%) | +3,55 m (Hải đồ) |
| Mực nước thấp thiết kế (P99%) | +0,43 m (Hải đồ) |
| Cấp công trình | Cấp I (công trình giao thông hàng hải) |
| Tuổi thọ thiết kế | 50 năm |
| Cấp động đất | Cấp VI (thang MSK-64), hệ số gia tốc nền a = 0,0368 |

**Tàu thiết kế:**
| Loại tàu | Trọng tải | L (m) | B (m) | Tc mớn nước đầy tải (m) |
|---|---|---|---|---|
| Tàu container | 50.000 DWT | 280 | 35 | 13,0 |
| Tàu container | 100.000 DWT | 330 | 45,5 | 14,8 |
| Sà lan | 160 TEU | 77 | 15,2 | 4,1 |

---

## 2. Hình học mô hình FEM (SAP2000)

| Trục | Min | Max | Ghi chú |
|---|---|---|---|
| X (dọc bến) | −1,8 m | 73,2 m | Module lưới cọc dọc: **5,1 m** (khớp thuyết minh IV.6.1) |
| Y (ngang bến) | −22,75 m | 28,68 m | Khớp bề rộng mặt cầu 50 m + phần mở rộng bố trí cọc biên |
| Z (cao độ) | −23,11 m | +5,50 m | Z = +5,50 khớp chính xác cao trình đỉnh bến |

**Quy mô mô hình:**
- Số nút (Joints): **4.913**
- Số phần tử thanh (Frame elements): **1.734**
- Số phần tử tấm vỏ (Area/Shell elements): **4.488**
- Đơn vị làm việc: Tonf – m – °C

---

## 3. Vật liệu

| Vật liệu | Loại | E (T/m²) | γ (T/m³) | Ghi chú đối chiếu |
|---|---|---|---|---|
| `Be tong M400` | Bê tông | 3.300.000 | 2,50 | Dầm ngang/dọc, dầm cần trục, bản mặt cầu — khớp thuyết minh IV.6.2 |
| `Be tong M800` | Bê tông | 3.600.000 | — | Cọc ống BTCT DƯL — khớp ghi chú bản vẽ "bê tông cọc mác 800 kG/cm²" |
| `Coc thep` (thép cọc) | Thép | 20.000.000 (=2×10⁶ kgf/cm²) | — | Cọc ống thép D1016 |
| `A615Gr60` | Cốt thép | 20.389.019 | — | Fy ≈ 4.218 kgf/cm² (~414 MPa, khớp chuẩn Gr60/60ksi) |
| `A992Fy50` | Thép hình | 20.389.019 | — | Dùng cho `ASEC1` (mục đích cụ thể chưa xác định rõ trong DXF — cần đối chiếu mô hình gốc) |

**⚠️ Điểm cần đối chiếu lại:** Bảng vật liệu phi tuyến (`MATERIAL PROPERTIES 03A`) trong SAP quy đổi Fy thép cọc ≈ **2.531 kgf/cm²**, trong khi ghi chú bản vẽ "01. Quy định hồ sơ thiết kế" ghi rõ **Fy = 3.150 kgf/cm², Fu = 4.900 kgf/cm², độ giãn dài 18%**. Đây nhiều khả năng chỉ là thông số mặc định cho khớp dẻo phi tuyến (không ảnh hưởng phân tích tuyến tính) nhưng **cần xác nhận trước khi dùng làm ràng buộc cứng (hard constraint) trong bài toán tối ưu.**

---

## 4. Tiết diện thanh (Frame Sections)

| SectionName | Vật liệu | Hình dạng | Kích thước | Cấu kiện tương ứng |
|---|---|---|---|---|
| `COCBTCT` | Be tong M800 | Pipe (ống tròn) | D=0,80 m, t=0,13 m → D(800‑540) | Cọc ống BTCT dự ứng lực |
| `COCTHEP` | Coc thep | Pipe (ống tròn) | D=1,016 m, t=0,016 m → D1016‑T16 | Cọc ống thép |
| `DN` | Be tong M400 | Chữ nhật | 1,2 × 1,9 m (120×190cm) | Dầm ngang (DN1/DN2 cơ bản) |
| `DD` | Be tong M400 | Chữ nhật | 1,2 × 1,9 m (120×190cm) | Dầm dọc (DD cơ bản) |
| `DCT1` | Be tong M400 | Chữ nhật | 1,6 × 2,5 m (160×250cm) | Dầm cần trục phía sông |
| `DCT2` | Be tong M400 | Chữ nhật | 1,6 × 2,5 m (160×250cm) | Dầm cần trục phía bờ |
| `KVA2` | Be tong M400 | Chữ nhật | 1,2 × 2,5 m | Đoạn dầm mở rộng vùng va tàu |
| `KVA_HAO` | Be tong M400 | Chữ nhật | 1,2 × 1,75 m | Đoạn dầm tại hào công nghệ (vùng va) |
| `VA2` | Be tong M400 | Chữ nhật | 2,2 × 2,5 m | Dầm vùng đệm va tàu |
| `VA_HAO` | Be tong M400 | Chữ nhật | 2,2 × 1,75 m | Dầm vùng đệm va tàu tại hào công nghệ |
| `KVA1`, `VA1` | Be tong M400 | Nonprismatic (biến tiết diện tuyến tính/parabol) | Dài 0,7 m, chuyển từ `DN`→`KVA2`/`VA2` | Đoạn vuốt tiết diện dầm |
| `KHOANNEO` | Be tong M400 | Tròn đặc | D=1,0 m | Cọc khoan neo (gia cố mũi cọc vào đá) |

Cốt thép dọc chủ theo `FRAME SECTION PROPERTIES 02`: `BarSizeL=#9`, đai `BarSizeC=#4 @150mm`, lớp bê tông bảo vệ `Cover=40mm`.

## 5. Tiết diện tấm (Area Sections)

| Section | Vật liệu | Dày (m) | Ghi chú |
|---|---|---|---|
| `BMC` | Be tong M400 | 0,50 | Có thể là bản mặt cầu (deck slab) |
| `BTT` | Be tong M400 | 0,40 | Có thể liên quan bản tựa tàu |
| `ASEC1` | A992Fy50 (thép) | 0,25 | Mục đích chưa xác định — **cần đối chiếu mô hình gốc trong SAP2000** |
| `ASEC2` | 4000Psi (bê tông) | 0,25 | Mục đích chưa xác định — **cần đối chiếu mô hình gốc trong SAP2000** |

---

## 6. Hệ cọc (per 1 phân đoạn ~75m)

| Loại cọc | Số lượng/phân đoạn | Đường kính | Chiều dài chế tạo thực tế (theo bản vẽ, thay đổi theo địa chất) | Chiều dài mô hình FEM (đến điểm ngàm ảo) | Độ xiên |
|---|---|---|---|---|---|
| Cọc ống BTCT DƯL D(800‑540) | **132** | D800mm, dày 130mm | 28 – 34 m | 20,2 – 28,2 m (không đồng nhất, phân bố theo 8 nhóm giá trị) | 6:1 (hàng trong), thẳng đứng (hàng dưới dầm dọc/ngang) |
| Cọc ống thép D1016‑T16 | **60** | D1016mm, dày 16mm | 28 – 32 m | 24,4 – 28,6 m | 6:1 (đóng chụm đôi), hàng ngoài cùng xiên 7:1 |
| **Tổng/phân đoạn** | **192 cọc** | | | | |
| **Tổng toàn cầu tàu (10 đoạn)** | **1.320 BTCT DƯL + 600 thép = 1.920 cọc** | | | | Khớp chính xác thuyết minh mục IV.6.1 |

Mũi cọc: khoan tạo lỗ, cấy cốt thép, đổ bê tông ngàm vào lớp đá (lớp 10/11/12) để tăng khả năng chịu nhổ.

---

## 7. Điều kiện biên & lò xo nền (Soil springs)

- **Ngàm/gối biên phân đoạn** (`JOINT RESTRAINT ASSIGNMENTS`): nhiều nút biên bị khoá `U1=U2=Yes, U3=No, R1=R2=R3=Yes` — mô phỏng điều kiện đối xứng/liên tục giữa các phân đoạn lân cận (chặn chuyển vị ngang & xoay, tự do theo phương đứng).
- **Lò xo đất nền** (`JOINT SPRING ASSIGNMENTS 1 - UNCOUPLED`): chỉ gán theo phương dọc trục cọc (U3, hệ toạ độ local) tại **178 nút** (vùng chân cọc) — mô hình hoá ma sát/kháng mũi cọc đơn giản hoá kiểu lò xo trục (không có lò xo ngang p‑y rời rạc trong bảng này ⇒ có thể bến dùng phương pháp điểm ngàm ảo/chiều dài tự do tương đương cho ứng xử ngang).
- **Độ cứng lò xo trục K33 ghi nhận (T/m):** 129.825 / 144.666 / 166.015 / 191.081 / 298.646 / 315.144 / 403.739 / 428.578 / 758.640 / **3.000.000** / **3.500.000** — hai giá trị lớn bất thường (~3–3,5 triệu T/m) khả năng tương ứng các cọc ngàm sâu vào lớp đá gốc (lớp 11/12).

---

## 8. Địa chất công trình (từ thuyết minh mục II.3, 38 lỗ khoan)

| Lớp | Mô tả | Chiều dày (m) | SPT N30 | Ghi chú |
|---|---|---|---|---|
| 1a | Cát hạt bụi xám vàng, rời rạc | 0,7 – 5,0 | 4 – 7 | Chịu tải yếu, chỉ ở lỗ khoan trên cạn |
| 1 | Cát hạt trung xám đen, rời rạc | 0,4 – 5,4 | ~10 | Chịu tải yếu, phân bố hẹp |
| 2 | Sét xám nâu kẹp cát, trạng thái chảy | 3,8 – 17,1 | 1 – 4 | **Yếu, chiều dày lớn, phân bố rộng** |
| 3 | Sét pha xám nâu/vàng, dẻo chảy | 0,8 – 5,3 | 1 – 6 | Yếu, phân bố hẹp |
| 4 | Cát bụi xám vàng, chặt vừa | 1,2 – 4,9 | 10 – 17 | Chịu tải trung bình |
| 5 | Cát pha xám vàng, trạng thái chảy | 2,0 – 3,0 | 3 – 5 | Yếu, phân bố hẹp |
| TK1 | Sét xám nâu, dẻo chảy | 3,7 (chỉ tại TK9) | 2 – 3 | Yếu |
| 6 | Cát pha xám vàng, dẻo | 2,0 – 7,0 | 6 – 17 | Chịu tải tương đối tốt |
| 7 | Sét pha xám nâu, dẻo mềm | 1,7 – 6,5 | 4 – 7 | Chịu tải trung bình |
| 8 | Sét xám nâu, dẻo cứng | 0,3 – 9,0 | 8 – 16 | Chịu tải tương đối tốt |
| 9 | Sét xám xanh, dẻo chảy | 1,0 – 16,7 | 3 – 8 | **Yếu, chiều dày lớn, nằm sâu** |
| TK2 | Cát pha xám đen lẫn sạn, cứng | 1,1 (chỉ tại VT3) | — | Tốt |
| 10 | Đá sét kết phong hoá hoàn toàn → sét pha nâu đỏ, cứng | 0,3 – 5,0 | 41 – >50 | Tốt, không liên tục |
| 11 | Đá sét kết nâu đỏ, phong hoá mạnh, nứt nẻ | 1,0 – 5,5 | — | Chịu tải cao |
| 12 | Đá sét kết tím gan gà, phong hoá nhẹ, cứng chắc | (đã khoan vào 2,0 – 8,1) | — | Đá gốc, chịu tải cao |

**Chỉ tiêu cơ lý định lượng trích được từ bản vẽ mặt cắt địa chất** (đối chiếu được layer 2, 7, 8, 9, 10 — **các lớp còn lại nên lấy từ "Bảng 1: Bảng tổng hợp chỉ tiêu cơ lý" gốc trong thuyết minh vì trích xuất tự động từ DXF không đảm bảo khớp 100% thứ tự hàng/cột**):

| Lớp | γ (g/cm³) | Δ (tỷ trọng hạt) | e (hệ số rỗng) | C (kG/cm²) | φ | Ghi chú |
|---|---|---|---|---|---|---|
| 2 | 1,71 | 2,68 | 1,362 | 0,069 | 5°53' | N=1‑4 |
| 7 | 1,94 | 2,70 | 0,779 | 0,225 | 13°21' | N=8‑16 |
| 8 | 2,04 | 2,70 | 0,583 | 0,20 | 18°10' | N=41‑50 (có thể lệch nhãn, cần đối chiếu) |
| 9 | 1,76 | 2,70 | 1,204 | 0,117 | 7°26' | N=3‑8 |
| 10 (đá) | 2,51 | 2,74 | — | rN(khô)=129 kG/cm², rN(bão hòa)=92 kG/cm² | — | Đá sét kết phong hoá |

- Cấp động đất VI (MSK‑64), hệ số gia tốc nền **a = 0,0368**.
- Vùng nước trước bến 100.000DWT có cao độ tự nhiên −1,9 ÷ −8,0 m (Hải đồ); nạo vét tới −16,0 m gặp lớp sét dẻo cứng (lớp 8) ⇒ phải kết hợp tàu hút + tàu cuốc.

---

## 9. Tải trọng (Load Patterns trong SAP + đối chiếu thuyết minh)

| LoadPat (SAP) | Loại | Diễn giải | Giá trị tiêu biểu |
|---|---|---|---|
| `BT` | DEAD | Tĩnh tải bản thân + lớp phủ | Tự trọng (SelfWtMult=1) + phủ mặt −0,11 T/m² |
| `Va` | LIVE | Lực va tàu (berthing) | Ví dụ nút: F1=−38,4 T; F2=−192 T |
| `Neo1` | LIVE | Lực neo tàu – kịch bản 1 (bích 150T) | F1=93,72; F2=54,11; F3=39,39 T |
| `Neo2` | LIVE | Lực neo tàu – kịch bản 2 | F1=68,15; F2=39,35; F3=66,03 T |
| `MT` | LIVE | Tải trọng môi trường (gió + dòng chảy + sóng) | — |
| `HH1…HH6` | LIVE | Hàng hoá khai thác, 6 kịch bản vị trí chất tải | Uniform = **−4 T/m²** (khớp thuyết minh: q=4,0 T/m² tuyến sau bến; q=2,0 T/m² tuyến mép bến) |
| `CT1 (di dong)` | BRIDGE LIVE (Moving Load) | Cần trục di chuyển làm hàng (hoạt tải di động theo "lane") | Theo bảng áp lực bánh xe IV.3 |
| `CT2 (Bao)` | BRIDGE LIVE (Moving Load) | Cần trục khi có bão | Ví dụ: F1=50,2 / 47,4 T tại các nút ray |
| `CT1(tinh Z)`, `CT2 (tinh X)`, `CT1(tinh Y)` | LIVE | Tải trọng tĩnh quy đổi từ cần trục theo 3 phương | — |

**Bảng áp lực bánh xe cần trục (từ thuyết minh IV.3 – cần trục 65T, khẩu độ ray 24m, 2 cụm × 8 bánh/cụm):**

| Trường hợp | Hướng | Phía trước bến (T) | Phía sau bến (T) |
|---|---|---|---|
| Cần trục di chuyển làm hàng | Tải đứng | 76,7 | 59,2 |
| | Vuông góc ray | 7,7 T/cụm | 5,92 T/cụm |
| Cần trục đứng yên làm hàng | Tải đứng | 40,6 | 43,6 |
| | Vuông góc ray | 4,1 T/cụm | 4,36 T/cụm |
| **Khi có gió bão** | Tải đứng | 58,9 | 62,0 |
| | Vuông góc ray | 59,25 T/ray | 62,75 T/ray |

**Điều kiện môi trường thiết kế (IV.4 & II.5):**
- Vận tốc dòng chảy lớn nhất: 1,55 m/s
- Chiều cao sóng thiết kế: ≤ 1,0 m
- Vận tốc gió cấp 8 (tàu neo cập): ≈ 20,7 m/s; khi thiết bị bốc xếp hoạt động: 16 m/s
- Vận tốc cập tàu cho phép: ≤ 0,12 m/s
- Hệ số sa bồi luồng: 0,234 (năm đầu) → 0,144 (ổn định); khối lượng sa bồi ~1,711 triệu m³/năm

---

## 10. Tổ hợp tải trọng (36 tổ hợp trong SAP)

`COMB1` (BT+Va), `COMB2` (BT+Va+MT), `COMB3.1…3.6` (BT+HH1…HH6), `COMB4.1…4.6` (BT+HHi+Va), `COMB5.1‑5.2` (BT+MT+Neo1/Neo2), `COMB6.1…6.12` (BT+MT+Neo1+HHi, tổ hợp khai thác kết hợp neo + hàng hoá), `COMB7.1‑7.3`, `COMB8.1‑8.4`, và `"BAO (storm)"` = BT + 1,25×CT2(Bao) + 1,25×CT2(tĩnh X) — tổ hợp bão có hệ số vượt tải 1,25 cho tải cần trục.

---

## 11. Giới hạn / khả năng chịu lực cho phép (thiết kế – từ ghi chú bản vẽ "01. Quy định hồ sơ")

| Cấu kiện | Chỉ tiêu | Giá trị |
|---|---|---|
| Cọc ống thép D1016‑T16 / D600‑T12 (TCVN 9245/9246:2012) | Giới hạn chảy Fy | 3.150 kG/cm² |
| | Giới hạn bền Fu | 4.900 kG/cm² |
| | Độ giãn dài | 18% |
| Cọc ống BTCT DƯL D800 | Mác bê tông | 800 kG/cm² |
| | Mômen nứt Mcr | 67,4 T.m |
| | Mômen phá huỷ Mu | 134,8 T.m |
| | Tải trọng dọc trục cho phép Pmax | 658 T |
| Dầm/bản cầu tàu | Mác bê tông | M400 |

---

## 12. Tiêu chuẩn thiết kế áp dụng

TCVN 2737:1995 (tải trọng & tác động) · TCVN 5574:2012 (BTCT) · TCVN 5575:2012 (kết cấu thép) · TCVN 10304:2014 (móng cọc) · TCVN 9386:2012 (kháng chấn) · TCVN 9346:2012 (chống ăn mòn môi trường biển) · 22TCN 207‑92 (công trình bến cảng biển) · 22TCN 222‑95 (tải trọng sóng/tàu lên công trình thuỷ) · TCVN 4253:2012, TCVN 4116:1985 (nền & kết cấu thuỷ công) · QCVN 20:2010/BGTVT · TCVN 6051:1995, TCVN 5741:1993 (bảo vệ catốt) · TCVN 9245:2012 (cọc ống thép) · TCVN 7888:2008 (cọc BTCT ly tâm ƯLT).
Phần mềm SAP2000 (v14.1.0) tham chiếu nội bộ mã **ACI 318‑05/IBC2003** (bê tông) và **AISC‑LRFD93** (thép) chỉ cho mục đích kiểm tra tiết diện tự động của phần mềm — thiết kế thực tế vẫn theo hệ TCVN/22TCN nêu trên.

---

## 13. Đề xuất khung bài toán tối ưu SOO / MOO

> Phần này là **đề xuất kỹ thuật** dựa trên dữ liệu trên, không phải trích xuất trực tiếp từ hồ sơ — cần bạn xác nhận/điều chỉnh theo mục tiêu cụ thể.

**13.1. Biến thiết kế (design variables) khả dĩ:**
| Biến | Ký hiệu | Miền giá trị tham khảo |
|---|---|---|
| Đường kính cọc BTCT DƯL | D_btct | 600 – 1000 mm (hiện D800) |
| Chiều dày thành cọc BTCT | t_btct | 100 – 150 mm (hiện 130mm) |
| Đường kính cọc thép | D_thep | 800 – 1200 mm (hiện D1016) |
| Chiều dày thành cọc thép | t_thep | 12 – 20 mm (hiện 16mm) |
| Khoảng cách cọc dọc bến | s_x | 4,5 – 6,0 m (hiện 5,1m) |
| Độ xiên cọc | rake | 1:6 – 1:8 (hiện 6:1 / 7:1) |
| Chiều dài ngàm cọc vào đá | L_ngam | theo cao độ lớp 10/11/12 tại từng vị trí |
| Kích thước dầm ngang/dọc | b×h (DN, DD) | quanh 120×190cm |
| Kích thước dầm cần trục | b×h (DCT) | quanh 160×250cm |
| Chiều dày bản mặt cầu | t_ban | quanh 400‑500mm |

**13.2. Ràng buộc (constraints):**
- Mômen thiết kế cọc BTCT ≤ Mu = 134,8 T.m (ULS), kiểm tra nứt tại Mcr = 67,4 T.m (SLS)
- Lực dọc trục cọc BTCT ≤ Pmax = 658 T
- Ứng suất thép cọc σ ≤ Fy/γ (Fy tham chiếu 3.150 kG/cm² — **xác nhận lại theo mục 3**)
- Sức chịu tải cọc theo đất nền (TCVN 10304:2014) tại mỗi lớp địa chất (mục 8)
- Chuyển vị ngang lớn nhất tại đỉnh bến ≤ giới hạn vận hành cần trục/khai thác (đề xuất tham chiếu quy định riêng của dự án, thường vài cm)
- Kiểm tra kháng chấn theo TCVN 9386:2012 với a=0,0368
- Tổ hợp tải trọng bắt buộc kiểm tra: toàn bộ 36 tổ hợp mục 10 (đặc biệt `"BAO (storm)"`)

**13.3. Hàm mục tiêu (objectives) gợi ý:**
- **SOO đơn giản:** min(khối lượng vật liệu quy đổi chi phí = f(số cọc, D, t, L_ngam, thể tích BT dầm/bản))
- **MOO 2 mục tiêu:** 
  - f1 = min(chi phí vật liệu: thép cọc + BTCT cọc + BT dầm/bản)
  - f2 = min(chuyển vị ngang lớn nhất đỉnh bến dưới tổ hợp `"BAO (storm)"`)
  hoặc f2 = max(hệ số an toàn nhỏ nhất trong các cấu kiện/cọc)
- **MOO 3 mục tiêu (mở rộng):** thêm f3 = min(số lượng chủng loại cọc khác nhau — hướng tới tiêu chuẩn hoá thi công)

**13.4. Gợi ý kết nối FEM ↔ optimizer:**
- Dùng SAP2000 OAPI (`SapObject` COM, có sẵn trên máy vì Windows đã cài Office/COM) hoặc export/import lặp lại file `.s2k` để thay đổi biến thiết kế theo từng thế hệ (generation) của GA/NSGA‑II.
- Trích xuất kết quả qua bảng `Frame Forces`, `Joint Displacements` (giao diện API hoặc export .s2k kết quả) làm input tính constraint/objective.
- Vì 132 cọc BTCT + 60 cọc thép/phân đoạn có nhiều nhóm chiều dài khác nhau theo địa chất (mục 6, 8) — nên tham số hoá theo **nhóm cọc theo vị trí địa chất** thay vì từng cọc riêng lẻ để giảm số biến.

---

## 14. Ghi chú & giới hạn của dữ liệu (đọc trước khi dùng cho FEM/optimization)

1. **Chiều dài cọc trong SAP (~20–28,6m)** là chiều dài từ đỉnh cọc (+5,5m) đến **điểm ngàm ảo/lò xo đất** — **khác** với chiều dài chế tạo thực tế ghi trong bản vẽ (28–34m). Cần dùng đúng bộ nào tuỳ mục đích: chiều dài thực tế cho khối lượng vật tư, chiều dài SAP cho độ cứng kết cấu.
2. **Fy thép cọc trong bảng vật liệu phi tuyến SAP (~2.531 kG/cm²)** chưa khớp với giá trị thiết kế chính thức 3.150 kG/cm² ghi trên bản vẽ — cần xác minh trước khi đưa vào ràng buộc.
3. **Bảng chỉ tiêu cơ lý đất nền** mới đối chiếu chắc chắn được 5/12 lớp (2,7,8,9,10 — lưu ý lớp 8 có N=41‑50 bất thường so với mô tả "dẻo cứng", khả năng bị lệch hàng khi trích xuất, **nên đối chiếu lại bảng gốc**). Các lớp 1a,1,3,4,5,6,TK1,TK2,11,12 cần lấy trực tiếp từ "Bảng 1: Bảng tổng hợp chỉ tiêu cơ lý các lớp đất" trong thuyết minh gốc.
4. **Mục đích của `ASEC1`/`ASEC2`/`BMC`/`BTT`** (tiết diện tấm) được suy luận từ tên biến, chưa xác nhận 100% — nên kiểm tra trực tiếp trong SAP2000 (View → mesh) trước khi dùng.
5. Số lượng cọc theo từng phân đoạn cụ thể (section 3,5,6,7…) trích từ text rời rạc trong DXF có sai số nhỏ (~130/58 so với 132/60 chuẩn) do thứ tự văn bản không theo đúng cấu trúc bảng gốc — **số 132 BTCT + 60 thép/phân đoạn (từ chính mô hình SAP + tổng thể 1320/600 trong thuyết minh) đáng tin cậy hơn** để dùng làm baseline.
