# Phương pháp tính sức chịu tải cọc theo TCVN 10304:2025 — dùng chung cho Công trình A & B

> **Trạng thái: Phương pháp/công thức/bảng tra đã xác minh đầy đủ và sẵn sàng dùng. Số liệu tính toán cụ thể (Rk, Rd bằng số) CHƯA hoàn thành** do thiếu 1 đầu vào cụ thể — xem mục 5 "Việc còn thiếu" trước khi dùng để viết bài hoặc code hoá.
> Thực hiện theo uỷ quyền "tự đề xuất và thực hiện" — tất cả các bước đều trích trực tiếp từ nguồn gốc (ảnh chụp trang chuẩn, không suy diễn), phần nào chưa đủ căn cứ được đánh dấu rõ theo đúng nguyên tắc của `Yeu_cau_trien_khai_Bai_2.md` mục 13.

---

## 1. Nguồn và vị trí điều khoản trong TCVN 10304:2025

File `TCVN 10304_2025.pdf` (124 trang, Xuất bản lần 2, VSQI 2025) có nội dung thân bài **nằm ở dạng ảnh nhúng** (không phải text thuần — các trang lẻ chỉ chứa watermark, nội dung thật nằm trên các trang được nhúng ảnh) nên đã trích bằng cách render từng trang thành ảnh (PyMuPDF) và đọc trực tiếp — **không OCR, không suy diễn nội dung**.

**Điều khoản áp dụng cho cả 2 công trình** (cọc ống BTCT dự ứng lực, hạ bằng phương pháp đóng/ép, không moi đất — đúng loại cọc của cả A và B):

| Điều khoản | Tên | Trang | Ảnh lưu tại |
|---|---|---|---|
| 7.1.6.1 | Công thức (2): `Rd = Rk/γk`, điều kiện `γn·Nd ≤ Rd` | 26 | `TCVN10304_2025_TrichDan/trang_26.png` |
| 7.1.6.1 (tiếp) | Hệ số `γk` theo số lượng cọc trong nhóm | 27 | `trang_27.png` |
| 7.1.6.2 | Công thức (3): phân phối tải trọng `Nd` lên từng cọc trong nhóm | 27 | `trang_27.png` |
| 7.2.2.1 | Công thức (9): `Rk = γc(γR,R·qb·A + u·Σγr,f·fi·hi)` — cọc đóng/ép/cọc-ống hạ không moi đất | 31 | `trang_31.png` |
| Bảng 2 | Sức kháng đơn vị dưới mũi cọc `qb` theo độ sâu & loại đất/IL | 32–33 | `trang_32.png`, `trang_33.png` |
| Bảng 3 | Sức kháng đơn vị trên mặt bên `fi` theo độ sâu trung bình lớp & loại đất/IL | 33–34 | `trang_33.png`, `trang_34.png` |
| Bảng 4 | Hệ số điều kiện làm việc `γR,R`, `γR,f` theo phương pháp hạ cọc | 34 | `trang_34.png` |

**Kết luận đối chiếu 2014 → 2025:** Công thức (9), Bảng 2, Bảng 3 **không đổi về giá trị số** so với TCVN 10304:2014 (đối chiếu bằng trí nhớ chuyên môn thấy khớp với bảng gốc SNIP 2.02.03-85 quen thuộc) — bản 2025 chủ yếu là tái bản/biên tập lại. **Tuy nhiên đây mới là đối chiếu định tính (không phải so từng số với file 2014 gốc)** — nếu cần khẳng định 100%, nên có file TCVN 10304:2014 để so trực tiếp.

---

## 2. Công thức áp dụng (nguyên văn, đã kiểm tra)

**Bước 1 — Giá trị tiêu chuẩn `Rk` (công thức 9, mục 7.2.2.1):**

```
Rk = γc · ( γR,R · qb · A  +  u · Σ γR,f · fi · hi )
```
- `γc` = 1,0 (hệ số điều kiện làm việc cọc trong đất, trường hợp thông thường — không phải cột đỡ đường dây điện trên không).
- `qb` (kPa) tra **Bảng 2** theo độ sâu đặt mũi cọc và loại đất/chỉ số chảy `IL` tại cao độ mũi cọc.
- `A` (m²) = diện tích tựa lên đất của cọc = diện tích tiết diện ngang **thực tế của cọc-ống** (theo định nghĩa trong tiêu chuẩn) — với cọc PC hollow, cần xác nhận cọc bịt kín mũi hay để hở (xem mục 5).
- `u` (m) = chu vi ngoài tiết diện cọc = `π·D` (D = đường kính ngoài).
- `fi` (kPa) tra **Bảng 3** theo độ sâu trung bình và loại đất/IL của từng lớp đất thứ i mà cọc xuyên qua (chia lớp dày ≤ 2m theo Chú thích 2 – Bảng 3).
- `hi` (m) = chiều dày lớp đất thứ i tiếp xúc mặt bên cọc **tại đúng vị trí cọc/lỗ khoan đang tính** (không phải chiều dày trung bình toàn khu vực).
- `γR,R = γR,f = 1,0` — áp dụng cho "hạ cọc đặc và cọc rỗng mũi cọc hở bằng búa cơ khí, búa hơi, búa diesel" (Bảng 4, dòng 1) — đúng phương pháp thi công của cả 2 công trình (búa đóng/búa rung, không khoan dẫn).

**Bước 2 — Giá trị tính toán/thiết kế `Rd` (công thức 2, mục 7.1.6.1):**

```
Rd = Rk / γk
```
- `γk = 1,4` — áp dụng khi Rk xác định "bằng tính toán theo các bảng tra trong tiêu chuẩn này" (đúng trường hợp dùng Bảng 2/3 ở trên), với điều kiện số cọc trong nhóm **≥ 21 cọc** (cả 2 công trình đều có ≥132 cọc/phân đoạn ⇒ áp dụng đúng mức 1,4, không rơi vào các mức tăng cao hơn cho nhóm cọc nhỏ).

**Bước 3 — Điều kiện kiểm tra:**

```
γn · Nd ≤ Rd
```
- `γn` = hệ số tầm quan trọng công trình: 1,0 (cấp C1) / 1,15 (cấp C2) / 1,20 (cấp C3) — **cần xác nhận cấp công trình của B** (A đã biết là Cấp I / công trình cấp đặc biệt theo hồ sơ gốc, cần đối chiếu quy đổi sang thang C1/C2/C3 của TCVN 2737 nếu dùng trực tiếp).
- `Nd` = tải trọng dọc trục tính toán truyền lên 1 cọc, lấy từ kết quả phân tích FEM (SAP2000) — **đây chính là điểm nối giữa FEM và ràng buộc địa kỹ thuật** nêu ở mục 7.1 của `Yeu_cau_trien_khai_Bai_2.md`: FEM cho `Nd`, TCVN 10304:2025 cho `Rd`, so sánh độc lập ở bước hậu kiểm (đúng nguyên tắc đã chốt ở mục 7.1 file `Danh_gia_kha_thi_Bai_2.md`).

---

## 3. Dữ liệu đầu vào đã sẵn sàng cho từng công trình

### Công trình B (VIPGreenPort) — SẴN SÀNG PHẦN LỚN
- Cao độ đáy đài: **+4,07 m**; cao độ mũi cọc thiết kế: **−36,93 m** (theo sheet `Ltt(LK3)`/`Ltt(BH17)`, bảng tính `1.Tinh ben VGP.xls`).
- Chiều dài cọc ngập đất: **25,43 m** (từ −11,50 m mặt đất tự nhiên đến −36,93 m mũi cọc).
- Đường kính cọc: D = 700 mm ⇒ u = π×0,7 = 2,199 m; A (nếu bịt kín) = π/4×0,7² = 0,385 m²; A (nếu để hở, tính theo thành ống) = 0,2328 m² (giá trị đã xác nhận khớp SAP).
- Bảng chỉ tiêu cơ lý 14 lớp đất: đã có đầy đủ (xem `FEM_CauTau_VIPGreenPort_30000DWT.md` mục 8).

### Công trình A (Lạch Huyện) — SẴN SÀNG PHẦN LỚN
- Đường kính cọc: D = 800 mm, t = 130 mm ⇒ u = π×0,8 = 2,513 m; A (bịt kín) = π/4×0,8² = 0,503 m²; A (hở, thành ống D800-540) = 0,232792 m² (đã xác nhận khớp SAP mục 4 file FEM).
- Bảng chỉ tiêu cơ lý 15 lớp đất: **đã xác minh đủ** (mục 8, vừa cập nhật — xem `FEM_PhanDoan_TieuChuan_100000DWT.md`).
- Cao độ mũi cọc thiết kế thực tế: **CHƯA XÁC ĐỊNH** — xem mục 5.

---

## 4. Ví dụ minh hoạ cách tính (khung công thức, KHÔNG phải kết quả cuối)

Để minh hoạ cách áp dụng (không phải số liệu chính thức), với 1 lớp đất giả định:
- Nếu 1 đoạn cọc dày h=2m nằm trong lớp sét có IL=0,5 ở độ sâu trung bình 20m: tra Bảng 3 → nội suy giữa cột IL=0,5 (hàng 20m) để ra fi (kPa).
- Nhân fi × h × u rồi cộng dồn qua tất cả các lớp mà cọc xuyên qua, cộng với qb×A tại mũi cọc → ra Rk theo công thức (9).

**Đây chỉ là ví dụ về CÁCH LÀM, không đại diện Rk thật của công trình nào** — để có Rk thật cần đủ dữ liệu ở mục 5.

---

## 5. Việc còn thiếu — CẦN XÁC NHẬN TRƯỚC KHI TÍNH SỐ THẬT

**Theo đúng nguyên tắc "không tự đặt giả định" (`Yeu_cau_trien_khai_Bai_2.md` mục 13), các điểm sau CHƯA đủ căn cứ để tính ra Rk/Rd bằng số và KHÔNG được tự điền:**

1. **Cột địa tầng theo đúng lỗ khoan thiết kế (trụ hố khoan)** — cần biết cọc xuyên qua **chính xác bao nhiêu mét mỗi lớp đất** tại vị trí lỗ khoan dùng để thiết kế (LK3/BH17 cho công trình B; lỗ khoan tương ứng cho công trình A). Hiện có:
   - Bảng chỉ tiêu cơ lý **theo loại lớp đất** (đầy đủ cho cả 2 công trình) — cho biết *loại đất từng lớp có tính chất gì*.
   - Nhưng **không có** cột địa tầng *theo đúng 1 lỗ khoan cụ thể* (thứ tự lớp + chiều dày từng lớp tại lỗ khoan đó) ở dạng đáng tin cậy — dữ liệu này có khả năng tồn tại trong bản vẽ mặt đứng bến (`11_13. Mat dung ben.dxf` của công trình B) dưới dạng nhãn (elevation, layer number) cạnh các lỗ khoan LK2/BH17/LK3/LK4, nhưng **trích xuất text tự động từ DXF cho thứ tự không đáng tin** (đúng vấn đề đã cảnh báo trong `FEM_PhanDoan_TieuChuan_100000DWT.md` mục 14.5) — **cần đọc trực tiếp bản vẽ bằng mắt (hoặc xuất hình ảnh CAD) để lấy đúng, không suy diễn từ text**.
   - Với công trình A, cần bản vẽ mặt cắt địa chất/mặt đứng tương ứng (nếu có trong `D:\ResearchLab\02_Projects\JMST\Paper 1\`) để lấy trụ hố khoan cụ thể.
2. **Cao độ mũi cọc thiết kế thực tế của công trình A** — chỉ có "chiều dài chế tạo 28–34m" (khoảng, không phải giá trị đơn), cần xác nhận cao độ đáy đài của A (SAP model dùng Z=0 làm gốc, không rõ quy đổi sang cao độ Hải đồ) để suy ra cao độ mũi cọc chính xác.
3. **Cọc bịt kín mũi hay để hở** (ảnh hưởng trực tiếp đến diện tích `A` trong công thức 9) — chưa thấy ghi chú tường minh trong hồ sơ đã đọc của cả 2 công trình. Cần đối chiếu bản vẽ chi tiết đầu cọc.
4. **Cấp công trình B** (để lấy `γn` đúng) — hồ sơ B chưa nêu rõ cấp công trình như A (A đã biết Cấp I).

**Đề xuất bước tiếp theo (chưa thực hiện, chờ xác nhận/ưu tiên):**
- (a) Xuất bản vẽ `11_13. Mat dung ben.dxf` (công trình B) thành ảnh và đọc trực tiếp bằng mắt cột địa tầng tại LK3/BH17 (giống cách đã làm thành công với bảng địa chất của công trình A) — đây là việc khả thi nhất, đã có kỹ thuật render DXF sẵn.
- (b) Tìm bản vẽ mặt cắt địa chất of công trình A trong thư mục `JMST/Paper 1` (đã có DXF `07..15. Mat cat ngang.dxf`) để lấy trụ hố khoan + cao độ mũi cọc thực tế.
- (c) Sau khi có (a) và (b), tính Rk/Rd bằng số cho pile baseline của cả 2 công trình theo đúng công thức đã xác minh ở mục 2.

**Đã thử (a) bằng phân tích toạ độ text trong DXF (`ezdxf`), kết quả — CHỈ XÁC NHẬN ĐƯỢC 1 PHẦN, chưa đủ tin cậy để dùng:**
- ✅ Xác nhận chắc chắn **cao độ miệng lỗ khoan** của cả 4 lỗ khoan xuất hiện trên mặt đứng bến B (đối chiếu bằng công thức số học `cao độ = cao độ miệng − chiều sâu`, khớp chính xác từng số): **LK2 = −2,7 m; BH17 = −1,0 m; LK3 = −2,2 m; LK4 = −2,3 m** (Hải đồ).
- ❌ **CHƯA xác nhận được** cột địa tầng chi tiết (chiều dày/cao độ đáy từng lớp) theo đúng từng lỗ khoan — thử nhóm các nhãn số theo khoảng cách toạ độ X gần lỗ khoan, nhưng phát hiện **các bảng chi tiết phụ (ví dụ log lớp đất) được đặt ở các vùng Y rất khác nhau trên bản vẽ** (không nằm cùng dải Y với đường mặt đứng chính một cách nhất quán giữa các lỗ khoan) — nhóm theo khoảng cách toạ độ một mình **không đủ tin cậy để gán đúng số liệu cho đúng lỗ khoan** (rủi ro gán nhầm y hệt vấn đề đã cảnh báo với trích xuất text tự động). **Do đó KHÔNG dùng kết quả nhóm này để tính toán** — cần mở trực tiếp file DXF bằng AutoCAD/phần mềm CAD để đọc bằng mắt vùng cột địa tầng, không tiếp tục suy diễn bằng toạ độ.

---

## 6. CẬP NHẬT — Đã tính được Rk/Rd THẬT cho Công trình A (mặt cắt 1-1)

**Nguồn dữ liệu (tất cả trích trực tiếp từ DXF gốc bằng toạ độ text, KHÔNG suy diễn — kỹ thuật: dùng các mốc cao độ đã biết chắc chắn (+5,50 tại y=69129; −16,00 tại y=66988, lặp lại giống hệt ở cả 7 mặt cắt) để suy ra thang quy đổi Y→cao độ = 99,58 đơn vị DXF/m, sau đó tra cao độ của MỌI text số hiệu lớp đất theo đúng toạ độ Y của nó — không dựa vào thứ tự hay khoảng cách X như lần thử thất bại với công trình B):**

File nguồn: `07..15. Mat cat ngang.dxf` (công trình A), mặt cắt ngang 1-1 (tuyến lỗ khoan VT2-KB3-TK10).

| Thông số | Giá trị | Nguồn |
|---|---|---|
| Cọc | PHC D800-540 (D=800mm, t=130mm), L=34m | text DXF "cọc ống btct dưl (phc pile) D(80-54), L=34m" |
| Đỉnh cọc | +5,50 m | mốc cao độ chuẩn |
| Cao độ đáy nạo vét (dùng làm mốc "mặt đất tự nhiên" theo Bảng 2/3) | −16,00 m | mốc cao độ chuẩn |
| Cao độ mũi cọc (suy từ +5,50 − 34) | **≈ −28,50 m** | tính từ L=34m |
| Lớp đất tại mũi cọc | Lớp 10 (đá sét kết phong hoá hoàn toàn, cứng, N=41-50) — đáy lớp 10 tại **−28,64 m** (khớp gần như tuyệt đối với mũi cọc thiết kế −28,50m ⇒ xác nhận **chủ đích ngàm mũi cọc vào ngay đỉnh lớp 10/11**) | text số hiệu lớp "10" tại toạ độ Y tương ứng cao độ −28,64m |
| Chuỗi lớp dưới cao độ nạo vét | Lớp 9: −16,00 → −23,55 m (dày 7,55m, IL=0,87); Lớp 10: −23,55 → −28,64 m (dày 5,09m, IL≈0,0) | số hiệu lớp "9","10" + Bảng chỉ tiêu cơ lý đã xác minh (mục 8, `FEM_PhanDoan...md`) |
| Cọc bịt kín hay để hở mũi | **BỊT KÍN bằng tấm thép** (xác nhận qua ghi chú bản vẽ chi tiết mũi cọc `01..09. Coc DUL.dxf`: "steel plate 20", "welding to steel plate of pile tip") ⇒ dùng diện tích tiết diện NGUYÊN (không phải diện tích thành ống) | text DXF |

**Tính toán (công thức 9, TCVN 10304:2025, mục 2 file này):**
- A = π/4×0,8² = 0,5027 m²; u = π×0,8 = 2,5133 m
- Chiều sâu mũi cọc tính từ đáy nạo vét (theo đúng quy định 7.2.2/Bảng 2 chú thích 3): 28,50 − 16,00 = **12,5 m**
- `qb` (Bảng 2, cột IL=0,0/cát lẫn sỏi sạn, nội suy giữa 10m và 15m) = **11.100 kPa**
- `Σfi·hi` (Bảng 3, chia lớp ≤2m, lớp 9 nội suy IL=0,87 giữa cột 0,8/0,9; lớp 10 dùng cột IL≤0,2) = **366,75 kPa·m**
- `Rk = γc(γR,R·qb·A + u·Σγr,f·fi·hi)` = 1,0×(11.100×0,5027 + 2,5133×366,75) = 5.579 + 921,7 = **6.501 kN ≈ 663,0 Tf**
- `Rd = Rk/γk` = 663,0 / 1,4 = **≈ 473,5 Tf**

**Đối chiếu:** `Rd(đất nền) ≈ 473,5 Tf` **<** `Pmax(vật liệu cọc) = 658 Tf` (giá trị đã có sẵn trong hồ sơ, mục 11 `FEM_PhanDoan_TieuChuan_100000DWT.md`) ⇒ **sức chịu tải đất nền là điều kiện khống chế** — kết quả hợp lý về mặt kỹ thuật (cọc phải ngàm sâu vào đá đúng như thiết kế vì đất nền phía trên rất yếu), tăng độ tin cậy của phép tính.

**⚠️ Giới hạn của kết quả này — cần lưu ý trước khi dùng làm ràng buộc cứng trong tối ưu:**
1. Chỉ đại diện **1 mặt cắt cụ thể (1-1)** với 1 chiều dài cọc cụ thể (L=34m) — các mặt cắt khác (2-2 đến 8-8) có chiều dài cọc khác (28-37m theo mục 3) và địa tầng khác, **cần tính riêng từng mặt cắt** nếu muốn dùng làm ràng buộc cho toàn bộ phân đoạn tối ưu (không suy rộng 1 mặt cắt cho cả phân đoạn).
2. Chia lớp đất thành các đoạn ≤2m là lựa chọn rời rạc hoá thủ công (không phải giá trị duy nhất đúng) — sai số nội suy nhỏ (~vài %) có thể xảy ra.
3. Cách hiểu điều khoản "chiều sâu đặt mũi cọc tính từ cao độ quy ước" khi đào xén ≥3m (Bảng 2, chú thích 3) được áp dụng đơn giản hoá là "tính từ cao độ đáy nạo vét thực tế" — **bản thân điều khoản gốc còn đề cập đến "cao độ quy ước" có thể bảo thủ hơn (nông hơn cao độ nạo vét thực)** — cần đọc lại kỹ điều khoản này (trang 32, chú thích 3, Bảng 2) trước khi dùng chính thức, hiện tại **đang hiểu theo hướng đơn giản nhất, có thể chưa tối ưu về độ an toàn**.
4. Giả thiết "cọc bịt kín" dựa trên ghi chú bản vẽ pile TIP DETAIL của **1 loại chiều dài** (L=28m, bản vẽ đầu tiên trong `Coc DUL.dxf`) — hợp lý suy rộng cho toàn bộ các chiều dài khác (cùng 1 series thiết kế) nhưng chưa kiểm tra từng bản vẽ.
5. **Công trình B vẫn CHƯA có kết quả tương tự** — kỹ thuật "quy đổi Y→cao độ qua mốc lặp lại" đã chứng minh hiệu quả ở đây, cần áp dụng lại cho `11_13. Mat dung ben.dxf` (công trình B) ở phiên làm việc tiếp theo.

---

## 7. CẬP NHẬT — Đã tính được Rk/Rd cho Công trình B (khắc phục vấn đề tối qua)

**Nguyên nhân thất bại tối qua:** nhóm theo khoảng cách toạ độ X. **Cách khắc phục:** tìm được 1 thước cao độ chuẩn thật trong bản vẽ (`11_13. Mat dung ben.dxf`) với các mốc tròn số **0,00 / −5,00 / −10,00 /.../ −40,00 m** lặp lại đều 100 đơn vị DXF/m (đối chiếu ở x≈−535, y từ 95558 đến 91558) — dùng thước này để quy đổi Y→cao độ CHO MỌI text trong toàn bộ file, loại bỏ ngay các cụm dữ liệu "lệch thang" (ví dụ 1 bảng chi tiết phụ có toạ độ Y hoàn toàn khác thang chính — đã tự động phát hiện và loại bỏ bằng bộ lọc "cao độ hợp lý −50..+10m").

Tìm được 1 trụ lỗ khoan **hoàn chỉnh, tự kiểm chứng được** (7 điểm layer-số/khoảng cách/cao độ có cùng 1 hằng số lệch = cao độ miệng lỗ khoan = **−0,21 m**, khớp tuyệt đối ở cả 7 điểm — độ tin cậy cao), nằm rất gần vị trí X của cao độ mũi cọc thiết kế (−36,93m khớp gần đúng ranh giới lớp 12 tại −36,56m tìm được trên thước chính, cùng khu vực toạ độ X).

**Trụ lỗ khoan dùng để tính (đơn vị: cao độ đáy lớp, Hải đồ):**
| Lớp | Cao độ đáy lớp | Chiều dày (từ đáy nạo vét −11,50m) |
|---|---|---|
| 1 | −7,49 m | (trên mực nạo vét, không tính) |
| 4 | −16,59 m | 5,09 m (tính từ −11,50) |
| 6 | −20,79 m | 4,20 m |
| 8 | −29,09 m | 8,30 m |
| 11 | −34,29 m | 5,20 m |
| 13 | −35,79 m | 1,50 m |
| 14 (đá, mũi cọc −36,93m nằm trong lớp này) | −37,79 m | (chỉ dùng 1,14m đến mũi cọc) |

**Tính toán (D=700mm, t=130mm, u=2,199m):**

| Trường hợp diện tích mũi cọc A | Rk | Rd = Rk/1,4 |
|---|---|---|
| Để hở (thành ống, A=0,2328 m² — khớp SAP) | 3.471,5 kN ≈ 354,0 Tf | ≈ 252,9 Tf |
| **✅ Bịt kín (tiết diện tròn đầy, A=0,3848 m²) — ĐÃ CHỐT dùng giá trị này** | **4.779,8 kN ≈ 487,4 Tf** | **≈ 348,1 Tf** |

**✅ ĐÃ CHỐT (theo quyết định người dùng 09/09/2026): cọc công trình B lấy BỊT KÍN mũi (đồng nhất với công trình A) → dùng chính thức `Rk = 487,4 Tf`, `Rd = 348,1 Tf`.**

**So sánh với Công trình A:** Rd(B)=348,1 Tf < Rd(A)=473,5 Tf — hợp lý vì cọc B nhỏ hơn (D700 so với D800) và tàu thiết kế nhỏ hơn (30k so với 100k DWT).

**⚠️ Giới hạn/giả thiết còn lại cần lưu ý:**
1. ~~Chưa xác nhận cọc B bịt kín hay để hở mũi~~ → **đã chốt: bịt kín** (xem trên).
2. Lớp 11 (cát pha, dẻo) được xử lý theo cột IL đất sét trong Bảng 3 — theo đúng tiêu chuẩn (chú thích 8, Bảng 2) cát pha có Ip≤4 & e<0,8 phải tính như cát bụi chặt vừa (dùng cột sức kháng của CÁT, không phải cột IL của SÉT) — **hồ sơ hiện có chưa xác nhận Ip và e của lớp 11 nên tạm dùng cột IL sét, cần đối chiếu lại**.
3. Trụ lỗ khoan này chưa xác định được tên chính thức (LK nào) — chỉ xác định qua toạ độ gần đúng với vị trí thiết kế cọc, độ tin cậy cao nhưng chưa 100% chắc chắn tên gọi.
4. Chưa có Mu/Mcr/Pmax vật liệu cọc D700 để đối chiếu chéo như đã làm với công trình A (mục 6, Rd(A) thấp hơn Pmax(A) — kiểm tra tương tự cho B chưa thực hiện được).

### 7.1. Đã kiểm tra Phụ lục C (cọc tương tác với đá) cho đoạn mũi cọc B nằm trong đá — KẾT LUẬN: KHÔNG ÁP DỤNG SẠCH, chỉ dùng để đối chiếu độ an toàn

**Phát hiện quan trọng khi đọc Phụ lục C (trang 107, TCVN 10304:2025):** điều khoản C.1 nêu rõ phạm vi áp dụng là **"cọc NHỒI, cọc KHOAN và cọc-ống NHỒI bê tông xuyên qua đá KHÔNG PHONG HÓA"**. Cọc công trình B là **cọc ĐÓNG đúc sẵn (PHC)**, không phải cọc nhồi/khoan, và lớp đá tại mũi cọc được mô tả là **"phong hoá nhẹ"** (không phải "không phong hoá"). ⇒ **Phụ lục C không thuộc đúng phạm vi áp dụng cho trường hợp này về mặt câu chữ tiêu chuẩn** — không dùng làm căn cứ chính thức thay thế kết quả ở mục 7.

**Đã tính thử (chỉ để đối chiếu độ an toàn, KHÔNG dùng làm giá trị chính thức):** dùng công thức (C.3) `Rsi = 0,63×√(pa×Rci)` với `Rci` tạm lấy bằng cường độ nén **khô** của đá lớp 14 = 114,5 kG/cm² (**chưa có giá trị bão hoà nước theo đúng yêu cầu của C.3** — dùng giá trị khô là ước lượng thiên cao, cần thận trọng) cho đoạn 1,14m mũi cọc nằm trong đá:
- `Rsi` = 0,63×√(100×11.228,6) = **667,6 kPa**
- Đóng góp riêng đoạn đá này theo Phụ lục C: `u×Rsi×h` = 2,199×667,6×1,14 = **1.673,5 kN ≈ 170,7 Tf**
- Trong khi đó, cách tính ở mục 7 (dùng tạm chỉ tiêu lớp 13 sét pha cho đoạn này theo Bảng 3) chỉ cho đóng góp ≈ 215 kN ≈ **21,9 Tf** cho cùng đoạn 1,14m.

**Kết luận:** Cách tính chính thức ở mục 7 (dựa Bảng 2/3 cho đất, xấp xỉ đoạn đá bằng chỉ tiêu lớp sét pha liền kề) **thấp hơn nhiều** (an toàn hơn, thiên về bảo thủ) so với ước lượng theo hướng Phụ lục C cho riêng đoạn đá. Điều này củng cố rằng **kết quả `Rd=348,1 Tf` ở mục 7 là kết quả AN TOÀN (không bị thổi phồng)**, dù không chính xác tuyệt đối 100%. **Giữ nguyên `Rd=348,1 Tf` làm giá trị chính thức**, không thay bằng số liệu Phụ lục C (do sai phạm vi áp dụng + thiếu dữ liệu Rci bão hoà).

---

## 8. Cập nhật vào checklist chính

Việc này tương ứng **mục 2.2** và bước 4 (mục 5, trình tự thực hiện) của `Danh_gia_kha_thi_Bai_2.md` — trạng thái: **CẢ HAI công trình A và B đều đã có Rk/Rd tính bằng số thật (không phải minh hoạ)** — tại 1 mặt cắt/1 vị trí đại diện mỗi công trình. Còn tồn đọng: xác nhận bịt kín/hở mũi cọc B, xử lý đoạn ngàm đá bằng Phụ lục C, mở rộng tính cho các mặt cắt/nhóm cọc khác nếu cần cho không gian thiết kế tối ưu.
