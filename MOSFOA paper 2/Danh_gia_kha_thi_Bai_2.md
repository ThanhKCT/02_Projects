# Đánh giá khả thi & Checklist triển khai Bài báo 2
### (MOSFOA tối ưu đa mục tiêu hệ cọc cầu tàu — kiểm chứng trên 2 công trình khác quy mô/tải trọng/địa kỹ thuật)

> **Phiên bản đã chốt** theo góp ý cuối — thay thế các khuyến nghị "thống nhất mô hình FEM" và "chốt sẵn bộ biến" ở bản đánh giá trước.

> **Tài liệu thẩm quyền cao nhất:** [`Yeu_cau_trien_khai_Bai_2.md`](Yeu_cau_trien_khai_Bai_2.md) — mọi nội dung trong file đánh giá này phải tuân theo tài liệu đó; nếu có mâu thuẫn, tài liệu đó là căn cứ quyết định cuối cùng.

Đối chiếu đề cương [`Bai_2.md`](Bai_2.md) với dữ liệu thực tế đã trích xuất từ 2 công trình:
- **Công trình A:** Cầu tàu container 100.000DWT — Lạch Huyện — [`FEM_PhanDoan_TieuChuan_100000DWT.md`](FEM_PhanDoan_TieuChuan_100000DWT.md)
- **Công trình B:** Cầu tàu container 30.000DWT — VIPGreenPort, Đình Vũ — [`FEM_CauTau_VIPGreenPort_30000DWT.md`](FEM_CauTau_VIPGreenPort_30000DWT.md)
- Bảng so sánh tổng hợp: [`So_sanh_2_du_an_Cau_tau.md`](So_sanh_2_du_an_Cau_tau.md)

**Kết luận chốt: Bài 2 được giữ lại và triển khai với cặp công trình Lạch Huyện 100.000DWT + VIPGreenPort 30.000DWT.**

**Nguyên tắc quan trọng nhất:** Giữ nguyên bản chất hai mô hình FEM thực tế; **chỉ thống nhất** cách xây dựng bài toán tối ưu, hàm mục tiêu và nguyên tắc kiểm tra/ràng buộc cần thiết.

---

## 1. Đối chiếu đề cương ↔ dữ liệu thực tế (đã cập nhật theo góp ý)

| Mục đề cương | Yêu cầu | Thực tế 2 công trình | Quyết định |
|---|---|---|---|
| 1.1 | Cùng bản chất bài toán, khác quy mô/tải trọng/địa kỹ thuật | Cả 2 đều bến bệ cọc cao, dầm–bản BTCT trên cọc ống BTCT ƯST; khác 100k/30k DWT, khác site | ✅ Đạt |
| 3.3 | Bảng so sánh điều kiện đầu vào | Đã lập sẵn trong `So_sanh_2_du_an_Cau_tau.md` | ✅ Dùng ngay (rút gọn còn 6 dòng theo khung đề cương) |
| 3.4 | Mô hình 3D, ĐK biên, mô hình tương tác cọc–nền | A dùng lò xo Winkler; B dùng ngàm cứng + chiều dài ngàm ảo (TCXD 205:1998) | ✅ **GIỮ NGUYÊN cả 2 phương pháp** — đây là đặc điểm dữ liệu công trình thực tế, không phải biến số cần kiểm soát của Bài 2 (xem mục 2.1) |
| 3.5 | Liên kết MATLAB–SAP2000 qua OAPI | Cả 2 model đều SAP2000 v14/v16, hỗ trợ OAPI chuẩn | ✅ Khả thi |
| 4.2 | f1 = khối lượng vật liệu; f2 = chuyển vị ngang cực đại | Đủ dữ liệu vật liệu/tiết diện; đã có tổ hợp bão bất lợi nhất (`BAO`/`Comb35-37`) | ✅ Khả thi, giữ đúng 2 mục tiêu, **không thêm mục tiêu thứ 3** |
| 4.4 | Ràng buộc sức chịu tải cọc theo TCVN 10304:2025 | Đã tính Rk/Rd thật theo TCVN 10304:2025 cho cả 2 công trình (1 vị trí đại diện/công trình) | ✅ Đạt (xem mục 2.2) |
| 4.1 | Biến thiết kế | A có 2 loại cọc (BTCT D800 + thép D1016, thép giữ nguyên không tối ưu); B chỉ 1 loại cọc (BTCT D700) | ✅ **Đã chốt: `{D_cọc, t_cọc}`** (xem mục 2.3) |
| Địa chất (phục vụ mục 4.4) | Dữ liệu địa chất đầy đủ, tin cậy | A đã xác minh đủ 15/15 lớp (từ ảnh gốc Bảng 1 thuyết minh); B đã đối chiếu tốt 14/14 lớp | ✅ Đạt cho cả 2 công trình (xem mục 2.4) |

---

## 2. Các quyết định chốt & việc cần làm

### 2.1. Mô hình FEM — GIỮ NGUYÊN, không cưỡng ép thống nhất

**Quyết định:** Giữ nguyên hai mô hình FEM gốc của từng công trình (A: lò xo trục Winkler tại 178 nút; B: ngàm cứng + chiều dài ngàm ảo theo TCXD 205:1998). **Không** chỉnh sửa để 2 model có cùng cách mô hình hoá tương tác cọc–nền.

**Lý do:**
- Hai mô hình là dữ liệu thực tế của hai công trình khác nhau — khác biệt mô hình hoá nền là **một đặc điểm của dữ liệu công trình**, không phải là biến nhiễu cần loại bỏ.
- Bài 2 kiểm chứng khả năng áp dụng MOSFOA trên hai bài toán thực tế **như chúng vốn có**, không nghiên cứu ảnh hưởng của phương pháp mô hình FEM/mô hình nền (đó là phạm vi khác, không thuộc Bài 2 lẫn Bài 3).

**Việc cần làm khi viết bài:**
- [ ] Mô tả rõ, minh bạch phương pháp mô hình hoá cọc–nền của **từng** công trình trong mục 3.4 của bài báo.
- [ ] **Không tuyên bố** hai mô hình FEM hoàn toàn đồng nhất hay tương đương về phương pháp — chỉ nêu chúng "cùng loại bài toán tối ưu hệ cọc trên nền FEM thực tế".

> **Điều khoản bắt buộc (theo `Yeu_cau_trien_khai_Bai_2.md` mục 8):** Hai mô hình SAP2000 (Công trình A và Công trình B) phải được **giữ riêng làm 2 file/model độc lập** trong suốt quá trình tối ưu. **Không được gộp** hai mô hình thành một model SAP2000 chung, dù chỉ để tiện thao tác kỹ thuật. Vòng lặp MOSFOA↔MATLAB↔SAP2000 chạy độc lập cho từng model, kết quả 2 case chỉ được so sánh ở tầng hậu xử lý (MATLAB), không được trộn dữ liệu ở tầng FEM.

### 2.2. ✅ Chuẩn hoá phần kiểm tra địa kỹ thuật theo TCVN 10304:2025 — ĐÃ CÓ SỐ THẬT CHO CẢ 2 CÔNG TRÌNH

**Quyết định:** Mặc dù giữ nguyên mô hình FEM (mục 2.1), phần **kiểm tra sức chịu tải cọc và ràng buộc địa kỹ thuật** vẫn phải xây dựng trên **cùng một cơ sở tính toán — TCVN 10304:2025** — áp dụng riêng cho số liệu địa chất của từng công trình. Đây là phần "nguyên tắc xử lý ràng buộc" cần thống nhất, tách biệt với "mô hình FEM kết cấu" ở mục 2.1.

**Cập nhật 09/09/2026 — xem chi tiết đầy đủ tại [`SucChiuTai_Coc_TCVN10304_2025.md`](SucChiuTai_Coc_TCVN10304_2025.md):**
- ✅ Đã đọc đúng điều khoản TCVN 10304:2025 (mục 7.1.6, 7.2.2.1, Bảng 2/3/4) — công thức Rk, Rd, γk, γn đã xác minh bằng ảnh gốc, lưu tại `TCVN10304_2025_TrichDan/`.
- ✅ **Đã tính được Rk/Rd bằng số THẬT cho cả 2 công trình** (không phải minh hoạ), bằng cách trích toạ độ text trực tiếp từ DXF gốc và quy đổi qua thước cao độ chuẩn (kỹ thuật đã kiểm chứng chéo bằng hằng số lệch tự nhất quán — xem file chi tiết mục 6-7):
  - **Công trình A** (mặt cắt 1-1, cọc PHC D800-540 L=34m, mũi cọc −28,5m ngay tại đỉnh lớp đá 10/11, **mũi cọc bịt kín bằng tấm thép**): **Rk≈663 Tf, Rd≈473,5 Tf** — đối chiếu với Pmax vật liệu=658 Tf cho thấy đất nền khống chế (hợp lý).
  - **Công trình B** (mũi cọc thiết kế −36,93m, ngay tại lớp đá 12/14, **đã chốt mũi cọc bịt kín** — đồng nhất với A): **Rk≈487,4 Tf, Rd≈348,1 Tf** (chính thức).
- ✅ **Đã kiểm tra Phụ lục C** (cọc tương tác với đá) cho đoạn mũi cọc B nằm trong đá — kết luận: **không thuộc đúng phạm vi áp dụng** (Phụ lục C chỉ dành cho cọc nhồi/khoan qua đá không phong hoá, còn cọc B là cọc đóng qua đá phong hoá nhẹ). Đã tính đối chiếu: cách tiếp cận Phụ lục C cho giá trị cao hơn ~8 lần cho riêng đoạn đá → xác nhận `Rd=348,1 Tf` hiện dùng là kết quả **an toàn/bảo thủ**, giữ nguyên làm giá trị chính thức.
- ⚠️ Kết quả trên **mỗi công trình chỉ đại diện 1 mặt cắt/1 vị trí cọc cụ thể**, chưa mở rộng cho toàn bộ các nhóm chiều dài cọc khác trong phân đoạn — xem chi tiết ở file gốc mục 7.1 (lớp 11 của B cần đối chiếu lại cách phân loại cát pha/sét, chưa ảnh hưởng lớn tới kết luận).

**Việc cần làm (còn lại, không còn là điều kiện tiên quyết để tiếp tục các bước khác):**
- [x] Xác minh đầy đủ dữ liệu địa chất công trình A (mục 2.4).
- [x] Lấy trụ hố khoan cụ thể tại vị trí cọc — **đã lấy được cho cả 2 công trình** bằng kỹ thuật quy đổi toạ độ DXF (không cần mở AutoCAD thủ công).
- [x] Xác định cao độ mũi cọc thiết kế thực tế — đã có cho cả A (−28,5m, mặt cắt 1-1) và B (−36,93m).
- [x] Xác nhận cọc B bịt kín/để hở mũi — **đã chốt: bịt kín** (đồng nhất với A).
- [x] Tính Rk/Rd theo TCVN 10304:2025 cho cả 2 công trình — xong (1 vị trí đại diện mỗi công trình).
- [x] Kiểm tra Phụ lục C (cọc tương tác với đá) cho đoạn mũi cọc B — đã kiểm tra, không áp dụng được (sai phạm vi), giữ nguyên kết quả xấp xỉ (an toàn hơn).
- [ ] Mở rộng tính cho các mặt cắt/nhóm chiều dài cọc khác nếu cần phủ hết không gian thiết kế tối ưu (hiện mới có 1 điểm dữ liệu/công trình) — **không cấp thiết**, có thể làm khi code hoá catalogue cọc.
- [ ] Xác định các giới hạn chịu lực vật liệu cần thiết của cọc B (Mcr, Mu, Pmax) để đối chiếu chéo như đã làm với A (A: Rd=473,5 < Pmax=658, hợp lý).
- [ ] Áp dụng **cùng một nguyên tắc xử lý ràng buộc/nghiệm không khả thi** cho cả hai công trình (mục 4.5 đề cương).

### 2.3. ✅ ĐÃ CHỐT — Bộ biến thiết kế cuối cùng: chỉ `{D_cọc, t_cọc}`

**Quyết định cuối (người dùng, 09/09/2026):** Bộ biến thiết kế của Bài 2 là **đúng 2 biến — `D_cọc` (đường kính ngoài cọc) và `t_cọc` (chiều dày thành cọc)** — không thêm `s_x`, `s_y`, kích thước dầm, hay bất kỳ biến bố trí/cấu kiện nào khác.

**Lý do (đã có bằng chứng ở mục 2.5):** đối chiếu bố trí cọc thực tế cho thấy `s_x` không đều ngay trong từng công trình (nên không phù hợp làm biến), và dù `s_y` khả dĩ dùng chung được, quyết định cuối vẫn chọn **giữ bộ biến tối giản nhất** đúng tinh thần "số lượng biến vừa đủ, không mở rộng quá mức" (mục 5, `Yeu_cau_trien_khai_Bai_2.md`).

**Hệ quả:**
- Khi tham số hoá mô hình SAP2000 qua OAPI, mỗi lần đánh giá **chỉ thay đổi mã tiết diện cọc** (`SapModel.PropFrame.SetPipe`), **giữ nguyên toàn bộ bố trí/toạ độ cọc, kích thước dầm, bản** như mô hình gốc của từng công trình.
- Cọc thép phụ trợ của công trình A **giữ nguyên, không đưa vào tối ưu** (chỉ D_cọc/t_cọc của cọc BTCT ƯST chính được tối ưu).
- Biến `D_cọc`/`t_cọc` nên mã hoá theo **danh mục catalogue cọc PHC/PC thực tế** (cặp D-t rời rạc, không phải 2 biến liên tục độc lập) — xem khuyến nghị mục 7.2 bên dưới.

- [x] Đối chiếu trực tiếp sơ đồ bố trí cọc của hai mô hình SAP2000 — xong, xem mục 2.5.
- [x] Chốt bộ biến — **`{D_cọc, t_cọc}`**, không mở rộng thêm.

### 2.4. ✅ ĐÃ XONG — Xác minh đầy đủ dữ liệu địa chất công trình A (Lạch Huyện)

**Cập nhật 08/09/2026:** Đã tìm được file gốc `Thuyet minh 06.12.doc` (lưu tại `D:\ResearchLab\02_Projects\JMST\Paper 1\`, dùng chung với Bài 1). Đã trích xuất "Bảng 1: Bảng tổng hợp chỉ tiêu cơ lý các lớp đất" (2 trang, nhúng dạng ảnh trong .doc — trích bằng cách export .doc→PDF qua Word COM rồi render trang bằng PyMuPDF, không OCR/suy diễn).

**Kết quả:** Xác minh đủ **15/15 lớp** (1a, 1, 2, 3, 4, 5, TK1, 6, 7, 8, 9, TK2, 10, 11, 12) với đầy đủ chỉ tiêu W, γw, Δ, e₀, φ, C (và Rk/Rbh cho 2 lớp đá 11, 12). Đã cập nhật vào [`FEM_PhanDoan_TieuChuan_100000DWT.md`](FEM_PhanDoan_TieuChuan_100000DWT.md) mục 8. Ảnh gốc lưu tại [`Dia_chat_LachHuyen_BangGoc/`](Dia_chat_LachHuyen_BangGoc/) để đối chiếu khi tính toán chính thức.

**Phát hiện quan trọng:** Bảng chỉ tiêu cơ lý cũ (trích tự động từ DXF mặt cắt địa chất) **thực sự bị lệch nhãn** như chính file đó đã tự nghi ngờ — giá trị gán cho "lớp 8" và "lớp 10" trong bảng cũ thực chất là của **lớp 10** và **lớp 11**. Đã sửa lại đúng theo bảng gốc — đây là ví dụ cụ thể cho thấy nguyên tắc "không tự đặt giả định, phải đối chiếu nguồn gốc" trong `Yeu_cau_trien_khai_Bai_2.md` là cần thiết.

- [x] Xác minh đủ 12/12 (thực tế 15/15) lớp địa chất công trình A.
- [ ] Việc còn lại: dùng bộ số liệu đã xác minh này làm đầu vào tính sức chịu tải cọc theo TCVN 10304:2025 (mục 2.2).

### 2.5. ✅ Ý nghĩa `s_x`, `s_y` — ĐÃ ĐỐI CHIẾU bố trí cọc thực tế, có khuyến nghị

- `s_x`: khoảng cách cọc theo phương **ngang bến** (vuông góc tuyến bến).
- `s_y`: khoảng cách cọc theo phương **dọc bến** (song song tuyến bến).

**Kết quả đối chiếu trực tiếp lưới cọc (từ `pile_master_table.csv` công trình A và dữ liệu hình học SAP công trình B):**

| | Công trình A (Lạch Huyện) | Công trình B (VIPGreenPort) |
|---|---|---|
| Khoảng cách **dọc bến** (s_y) | **5,10 m — đều tuyệt đối** trên toàn bộ 15 hàng cọc dọc | **4,80–4,90 m — gần đều** (chỉ lệch 0,1m ở 2 hàng biên) |
| Khoảng cách **ngang bến** (s_x) | **KHÔNG đều**: 5,25m (4 hàng phía sông) và 6,00m (3 hàng phía bờ) — 2 giá trị khác nhau trong cùng 1 công trình, chưa kể hàng cọc thép biên đóng chụm đôi cách nhau ~2,0m riêng | **KHÔNG đều**: 5,25m (2 khoảng) và 4,75m (2 khoảng) — cũng nhiều giá trị khác nhau trong cùng 1 công trình |

**Khuyến nghị (dựa trên bằng chứng trên, chưa phải quyết định cuối — cần bạn chốt):**
- **`s_y` (dọc bến) CÓ THỂ đưa vào làm biến thiết kế dùng chung cho cả 2 công trình** — vì mỗi công trình vốn đã có 1 module chủ đạo tương đối đồng nhất (A: 5,10m đều; B: ~4,85m gần đều), thay đổi giá trị này chỉ dịch chuyển đều các hàng ngang, không phá vỡ cấu tạo chức năng.
- **`s_x` (ngang bến) KHÔNG NÊN đưa vào làm 1 biến vô hướng đơn giản** — vì ngay trong **từng công trình riêng lẻ** đã tồn tại nhiều giá trị khoảng cách ngang khác nhau (do bố trí theo chức năng: hàng dưới dầm cần trục sông/giữa/bờ khác nhau), không phải do khác biệt giữa 2 công trình. Ép về 1 biến vô hướng sẽ **phá vỡ cấu tạo thực tế của cả 2 mô hình**, vi phạm đúng nguyên tắc mục 5 của `Yeu_cau_trien_khai_Bai_2.md` ("không ép hai công trình phải có cùng bộ biến nếu điều đó làm sai lệch cấu tạo thực tế").

**✅ ĐÃ CHỐT (09/09/2026):** dùng đúng 2 biến `{D_cọc, t_cọc}`, loại cả `s_x` lẫn `s_y` khỏi bộ biến thiết kế — giữ nguyên toàn bộ bố trí cọc (toạ độ, khoảng cách ngang/dọc) như mô hình gốc của từng công trình. Xem quyết định cuối tại mục 2.3.

---

## 3. Phạm vi nghiên cứu Bài 2 (ranh giới cần giữ)

**Trong phạm vi:**
> Kiểm chứng khả năng áp dụng và tính ổn định của MOSFOA khi giải bài toán tối ưu đa mục tiêu hệ cọc trên hai công trình cầu tàu có quy mô và điều kiện địa kỹ thuật khác nhau.

**Ngoài phạm vi (không đưa vào Bài 2):**
- Phát triển thuật toán mới.
- So sánh nhiều thuật toán (đó là Bài 1: MOFDA vs MOSFOA).
- Nghiên cứu độ nhạy tham số MOSFOA.
- Xây dựng quy luật tổng quát về ảnh hưởng của quy mô/tải trọng/địa chất lên nghiệm tối ưu (dành cho Bài 3).
- Nghiên cứu ảnh hưởng của phương pháp mô hình FEM/mô hình nền (không thuộc cả Bài 2 lẫn Bài 3 theo góp ý — chỉ mô tả minh bạch, không phân tích sâu).

**Hàm mục tiêu — CHỈ đúng 2 mục tiêu, danh sách CẤM tường minh** (theo `Yeu_cau_trien_khai_Bai_2.md` mục 6):
- `f1 = min(khối lượng vật liệu)` — chỉ tính cho phần cấu kiện thuộc phạm vi tối ưu (hệ cọc, xem mục 2.3).
- `f2 = min(chuyển vị ngang cực đại)` — của cầu tàu, dưới tổ hợp bất lợi nhất.
- **TUYỆT ĐỐI KHÔNG thêm** vào Bài 2 dưới bất kỳ hình thức nào (kể cả làm mục tiêu phụ hay chỉ số tham khảo trong kết quả):
  - Chi phí kinh tế/đơn giá (khi chưa có dữ liệu đơn giá đáng tin cậy).
  - Phát thải carbon (CO₂).
  - Thời gian thi công.
  - Số nhóm chiều dài cọc / mức độ tiêu chuẩn hoá thi công.
  - Bất kỳ mục tiêu thứ 3 nào khác không được liệt kê ở trên.
- Ghi chú: các mục tiêu bị cấm này (carbon, thời gian thi công, số nhóm cọc…) từng được đề xuất như hướng "mở rộng MOO 3 mục tiêu" trong các file dữ liệu tham khảo (`FEM_PhanDoan_TieuChuan_100000DWT.md` mục 13.3, `FEM_CauTau_VIPGreenPort_30000DWT.md` mục 12.3) — **các đề xuất đó KHÔNG áp dụng cho Bài 2**, chỉ là gợi ý mở cho nghiên cứu khác/Bài 3 nếu có.

---

## 4. Điểm thuận lợi đã xác nhận (không cần xử lý thêm)

| Yêu cầu | Tình trạng |
|---|---|
| Model SAP ở quy mô 1 phân đoạn tiêu chuẩn (không phải toàn tuyến) | ✅ Cả 2 model đã sẵn ở quy mô nhỏ (75m/75,44m) → chi phí tính FEM/lần đánh giá thấp, khả thi cho nhiều lượt gọi SAP2000 qua MATLAB OAPI trong MOSFOA |
| f1 = khối lượng vật liệu (không cần đơn giá) | ✅ Tính trực tiếp từ tiết diện + vật liệu khai báo sẵn trong SAP của cả 2 công trình |
| f2 = chuyển vị ngang cực đại | ✅ Tổ hợp bão bất lợi nhất đã xác định sẵn cho cả 2 (`BAO` ở A, `Comb35-37` ở B) |
| Khả năng liên kết OAPI | ✅ Cả 2 model đều SAP2000 phiên bản hỗ trợ OAPI chuẩn |

---

## 5. Trình tự thực hiện (đã chốt theo góp ý)

1. [ ] Hoàn thiện và kiểm tra dữ liệu của hai mô hình FEM.
2. [ ] **Giữ nguyên** mô hình FEM gốc của từng công trình (không chỉnh sửa mô hình cọc–nền).
3. [x] Xác minh dữ liệu địa chất Lạch Huyện — đã đủ 15/15 lớp (xem mục 2.4).
4. [x] Xây dựng phần kiểm tra sức chịu tải cọc theo TCVN 10304:2025 — **xong, có Rk/Rd bằng số cho cả 2 công trình** (1 vị trí đại diện/công trình; xem mục 2.2, chi tiết `SucChiuTai_Coc_TCVN10304_2025.md`).
5. [x] Đối chiếu sơ đồ bố trí cọc thực tế của hai công trình — **xong, xem mục 2.5**: khuyến nghị loại `s_x` (không đều ngay trong từng công trình), cân nhắc thêm `s_y` (tương đối đều ở cả 2 bên).
6. [x] Chốt bộ biến thiết kế — **`{D_cọc, t_cọc}`** (xem mục 2.3).
7. [x] Xây dựng hàm mục tiêu (`f1`, `f2`) và các ràng buộc — **✅ XONG HOÀN TOÀN, không còn việc tồn đọng**, xem [`Cong_thuc_Bai_toan_Toi_uu.md`](Cong_thuc_Bai_toan_Toi_uu.md): catalogue cọc AMACCAO dùng chung cho cả 2 công trình (baseline A=D800-t120, B=D700-t110, cả 2 Class C), γn(A)=1,0 (Cấp I), γn(B)=1,15 (Cấp II), chiều dài cọc A=34m/B=41m, giới hạn chuyển vị vận hành=30mm, tổ hợp khống chế B=COMB14/BAO (max|U1|=15,36mm, đã kiểm tra bằng FEM thật — thoả mãn, dùng ~51% giới hạn).
8. [x] Liên kết MATLAB–SAP2000 bằng OAPI — **✅ khung code hoàn thiện cho cả 2 công trình**: [`code/`](code/) (`pile_catalogue_AMACCAO.m`, `project_config.m`, `open_Sap2000.m`, `evaluate_pile_design.m`, `driver_example.m`, xem [`code/README_khung_code.md`](code/README_khung_code.md)). Cả A và B đều đã điền đủ số liệu thật. Công trình A: combo khống chế chuyển vị = **`"BAO KT"`** (13,81mm) — đã xem xét đủ **37/37 tổ hợp** (3 tổ hợp COMB7.1/8.1/8.2 xuất ra rỗng do chưa chạy phân tích trong model gốc, theo quyết định người dùng coi như đóng góp=0, không ảnh hưởng kết luận). Phát hiện thêm: `"BAO KT"` là tổ hợp bão thứ 2 riêng biệt với `"BAO (storm)"` (trước đó bị gộp nhầm do lỗi trích xuất tên có ngoặc kép). Công trình B: `COMB14`/`BAO` (15,36mm, 37/37 tổ hợp). Cả 2 đều thoả mãn tốt giới hạn 30mm. `sdb_path` của cả 2 công trình đã xác nhận đầy đủ (A: `SapV14/Ben100kDWT_sensitivity.sdb`, đã kiểm chứng bằng số — Point/Frame/Area Count khớp tuyệt đối 4913/1734/4488; B: `SapV14/Cau tau.sdb`) — **không còn việc gì tồn đọng, sẵn sàng chạy `driver_example.m` cho cả 2 công trình.**
9. [ ] Chạy MOSFOA độc lập trên từng công trình (cùng cấu hình tham số, số lần chạy — mục 5.3–5.4 đề cương).
10. [ ] Đánh giá độ ổn định và chất lượng nghiệm Pareto (IGD, HV, tỷ lệ nghiệm khả thi…).
11. [ ] So sánh kết quả giữa hai công trình.
12. [ ] Chỉ thảo luận ở mức chứng minh khả năng áp dụng MOSFOA; **không** chuyển nội dung sang phân tích độ nhạy/quy luật tổng quát (dành cho Bài 3).

---

## 6. Rủi ro còn lại cần lưu ý khi viết bài

- Vì giữ nguyên 2 phương pháp mô hình cọc–nền khác nhau, **khi thảo luận khác biệt nghiệm Pareto giữa 2 công trình (mục 7.5–7.6 đề cương), cần thận trọng không quy kết toàn bộ khác biệt là do "quy mô + tải trọng + địa kỹ thuật"** — nêu rõ trong hạn chế nghiên cứu rằng khác biệt phương pháp mô hình cọc–nền cũng là một yếu tố nền tảng của 2 bài toán (không tách bạch định lượng được trong phạm vi Bài 2).
- ~~Rủi ro bộ biến không đối xứng~~ — **đã không còn xảy ra**: bộ biến cuối cùng `{D_cọc, t_cọc}` đối xứng hoàn toàn giữa A và B (cọc thép phụ trợ của A giữ nguyên, không phải biến) — mục 7.4 (chỉ số so sánh tương đối) vẫn nên giữ làm thông lệ tốt, nhưng không còn là điều bắt buộc để xử lý bất đối xứng.
- Cần thống nhất ngay từ đầu bộ tham số MOSFOA (kích thước quần thể, số vòng lặp, số lần chạy) áp dụng **như nhau** cho cả 2 case trước khi chạy; chỉ điều chỉnh vì lý do quy mô bài toán (nêu rõ lý do), tuyệt đối không điều chỉnh theo kết quả — đúng tinh thần mục 5.4 của `Bai_2.md`.

---

## 7. Bổ sung làm chặt chẽ hơn (rà soát lại sau khi chốt góp ý)

### 7.1. Làm rõ quan hệ giữa "mô hình FEM giữ nguyên" và "kiểm tra TCVN 10304:2025 thống nhất"

Hai quyết định (mục 2.1 và 2.2) **không mâu thuẫn** nếu tách rõ vai trò — cần ghi thành nguyên tắc tường minh trong bài báo:

> Mô hình FEM (lò xo Winkler ở A / ngàm ảo ở B) chỉ dùng để tính **nội lực và chuyển vị** của kết cấu (đầu vào cho `f2` và kiểm tra ứng suất/mô men). Sức chịu tải cọc theo đất nền (`Qa`, TCVN 10304:2025) là một **bước hậu kiểm độc lập**, so sánh lực dọc trục cọc lấy ra từ FEM với `Qa` tính riêng theo số liệu địa chất — không phải một thành phần của độ cứng mô hình FEM. Do đó, "thống nhất theo TCVN 10304:2025" chỉ áp dụng cho **bước hậu kiểm**, không áp dụng cho **bản thân mô hình FEM**.

- [ ] Ghi rõ nguyên tắc này trong mục 3.4/4.4 của bài báo để tránh phản biện cho rằng 2 quyết định "giữ nguyên FEM" và "thống nhất kiểm tra" là mâu thuẫn nhau.

### 7.2. Mã hoá biến `D_cọc`, `t_cọc` theo danh mục catalogue (không phải 2 biến liên tục độc lập)

Cọc ống PHC/PC không có tổ hợp (D,t) tuỳ ý — nhà sản xuất chỉ cung cấp một số cặp cố định theo catalogue (VD D700 chỉ có t=100 hoặc 130mm). Khuyến nghị:
- [ ] Mã hoá biến thiết kế là **chọn 1 mã cọc trong danh mục catalogue** (biến rời rạc dạng index), không phải 2 biến số liên tục độc lập D và t.
- [ ] Hệ quả thuận lợi: không gian thiết kế với biến catalogue-hoá thường **rất nhỏ** (vài chục mã cọc) → **khả thi để vét cạn Pareto tham chiếu**, đáp ứng đúng mục 6.3 đề cương mà không cần lo lắng về chi phí tính toán.

### 7.3. Cố định bố trí cọc (số lượng, toạ độ) khi chỉ tối ưu D, t

Đã chốt loại cả `s_x`, `s_y` khỏi bộ biến (mục 2.3/2.5) — cần nêu rõ trong bài báo:
- [ ] Khi thay đổi mã cọc (`D_cọc`/`t_cọc`), **số lượng và toạ độ cọc giữ nguyên như mô hình gốc** — mỗi lần đánh giá chỉ cập nhật lại tiết diện qua OAPI (`SapModel.PropFrame.SetPipe`), không thay đổi hình học/lưới cọc. Điều này vừa giữ bài toán trong đúng phạm vi "tối ưu hệ cọc", vừa giúp việc lặp FEM nhanh và ổn định.

### 7.4. Nguyên tắc so sánh khi số biến giữa A và B không đối xứng

Góp ý cho phép A có phạm vi biến rộng hơn B (nếu A giữ cả biến cho cọc thép phụ trợ). Để mục 7.5 đề cương (so sánh nghiệm) không bị vênh:
- [ ] Khi so sánh giữa 2 công trình, ưu tiên dùng **chỉ số tương đối/chuẩn hoá** (% giảm khối lượng so với phương án gốc, % giảm chuyển vị so với phương án gốc, tỷ lệ nghiệm khả thi…) thay vì so sánh trực tiếp giá trị biến thiết kế — vì số lượng/loại biến giữa 2 case có thể không đối xứng.

### 7.5. Kế hoạch song song hoá tính toán — PC có 8 worker

Thông tin bổ sung: máy tính triển khai có thể chạy **song song 8 worker**. Đây là điều kiện thuận lợi lớn để rút ngắn thời gian chạy MOSFOA (vốn cần nhiều lượt gọi FEM × 20 lần chạy độc lập × 2 công trình), nhưng cần chốt rõ trước khi triển khai:

- [ ] **Xác nhận giấy phép SAP2000**: chạy song song 8 tiến trình SAP2000 qua OAPI đồng thời **cần 8 license SAP2000 hoạt động cùng lúc** (license mạng/nhiều seat), hoặc dùng 8 máy ảo/8 profile riêng — license đơn lẻ (standalone) thường chỉ cho phép 1 instance COM hoạt động tại 1 thời điểm. **Cần kiểm tra loại license hiện có trước khi thiết kế kiến trúc song song**, nếu không sẽ phải chuyển sang song song hoá theo cách khác (VD: 1 instance SAP2000 xử lý tuần tự nhưng 8 worker MATLAB xử lý song song phần tính `f1`/ràng buộc không cần SAP2000, chỉ FEM chạy tuần tự).
- [ ] Nếu license cho phép 8 instance song song: **chọn kích thước quần thể MOSFOA là bội số của 8** (VD 40, 56, 80) để mỗi thế hệ (generation) chia đều cho 8 worker, tối ưu hiệu suất song song (không dư/thiếu worker ở lượt cuối mỗi thế hệ).
- [ ] Vì Model A (4.913 nút/1.734 thanh) nặng hơn Model B (2.532 nút/960 thanh) đáng kể, **thời gian chạy thực tế của 2 công trình sẽ khác nhau dù cùng số lần gọi FEM** — quy định tiêu chí dừng/số lần chạy theo **số lần gọi hàm mục tiêu (fitness evaluations)**, không theo thời gian chạy thực tế, để tránh vô tình giảm số vòng lặp của công trình A chỉ vì nó chạy lâu hơn (vi phạm nguyên tắc "giữ cùng cấu hình" mục 5.4 đề cương).
- [ ] Nên đo thời gian chạy 1 lượt FEM đơn lẻ của cả 2 model trước (baseline benchmark) để ước lượng tổng thời gian cần cho toàn bộ kế hoạch (2 case × 20 lần chạy × số thế hệ × kích thước quần thể / 8 worker) trước khi thực thi toàn bộ.

### 7.6. ✅ ĐÃ CHỐT — Tiêu chuẩn "TCVN 10304:2025"

**Xác nhận:** File gốc `TCVN 10304_2025.pdf` đã được bổ sung vào thư mục dự án. Đã kiểm tra trang bìa: **TCVN 10304:2025, Xuất bản lần 2 — "Thiết kế móng cọc" (Design of pile foundations)**, 124 trang, do Viện Tiêu chuẩn Chất lượng Việt Nam (VSQI) ban hành năm 2025 — là **bản soát xét mới thay thế TCVN 10304:2014**, không phải gõ nhầm năm.

- [x] Số hiệu tiêu chuẩn dùng cho toàn bộ Bài 2 (mục 2.2, 4.4 đề cương): **TCVN 10304:2025** (thay thế hoàn toàn TCVN 10304:2014).
- [x] Đã đọc trực tiếp điều khoản 7.1.6, 7.2.2.1, Bảng 2/3/4 và Phụ lục C của bản 2025 (ảnh gốc, không suy diễn) và dùng đúng các điều khoản này để tính Rk/Rd thật cho cả 2 công trình (mục 2.2) — không dùng lại công thức "theo trí nhớ" của bản 2014.

### 7.7. ✅ ĐÃ CHỐT — Song song hoá 8 worker khả thi

**Xác nhận từ người dùng:** Đã chạy thử kiến trúc song song 8 worker (SAP2000 OAPI qua MATLAB) trên dự án khác — hoạt động ổn định. **Đối chiếu thêm với `Cach ket noi_SAP2000_MATLAB_OPTIMIZATION.md` mục 3:** license SAP2000 node-locked đã đo được cho phép tối đa **11 tiến trình đồng thời** trên máy tham chiếu — 8 worker nằm an toàn trong giới hạn này, nhưng **file đó cũng lưu ý "nếu máy khác nhau, phải tự đo lại, đừng giả định số 11 cố định"** — nên đo nhanh trên đúng máy triển khai Bài 2 trước khi chạy campaign chính thức.

- [x] Kiến trúc song song 8 worker — khả thi, đã kiểm chứng thực tế.
- [ ] Chọn **kích thước quần thể MOSFOA là bội số của 8**; quy định tiêu chí dừng theo **số lần gọi hàm mục tiêu**, không theo thời gian chạy thực tế (model A nặng hơn B ~2×).
- [ ] Trước khi chạy campaign chính: làm đúng quy trình 3 bước đã đúc kết sẵn trong `Cach ket noi_SAP2000_MATLAB_OPTIMIZATION.md` mục 4 — **(1) smoke test** (Npop nhỏ, 1 vòng lặp) → **(2) pilot thật** ở đúng Npop dự kiến (đo thời gian/vòng lặp thật, không ngoại suy) → **(3) campaign chính**. Đồng thời dựng sẵn 3 cơ chế chống mất dữ liệu ở mục 5 file đó (idempotent-skip, checkpoint, ghi atomic) **trước khi** chạy, không phải sau khi mất dữ liệu.

---

## 8. Sơ đồ quy trình MOSFOA ↔ MATLAB ↔ SAP2000 (theo `Yeu_cau_trien_khai_Bai_2.md` mục 8)

Áp dụng **giống hệt cho cả 2 công trình**, chạy độc lập trên 2 model SAP2000 riêng biệt (không gộp — xem điều khoản ở mục 2.1):

```
        MOSFOA
           │
           ▼
  Sinh phương án thiết kế (D_cọc, t_cọc, …)
           │
           ▼
        MATLAB
           │
           ▼
  Tham số hoá mô hình SAP2000 (qua OAPI, VD SetPipe)
           │
           ▼
      SAP2000 / FEM  ◄── model A (riêng) hoặc model B (riêng), KHÔNG gộp
           │
           ▼
     Phân tích kết cấu
           │
           ▼
       Đọc kết quả (nội lực, chuyển vị)
           │
           ▼
     Kiểm tra ràng buộc (kết cấu + địa kỹ thuật TCVN 10304:2025)
           │
           ▼
      Tính f1 (khối lượng), f2 (chuyển vị ngang cực đại)
           │
           ▼
   MOSFOA tiếp tục tìm kiếm (cập nhật Pareto archive)
```

- [ ] Viết 1 hàm/wrapper MATLAB dùng chung cấu trúc cho cả 2 case, chỉ khác tham số đầu vào là đường dẫn model (`Cau tau.s2k`/`.sdb` cho A, tương ứng cho B) và bảng tra catalogue cọc riêng của từng công trình.

---

## 9. Cấu trúc bài báo dự kiến (7 chương, theo `Yeu_cau_trien_khai_Bai_2.md` mục 12)

| Chương | Nội dung chính |
|---|---|
| 1. Mở đầu | Bài toán hệ cọc cầu tàu; sự cần thiết MOO; hạn chế kiểm chứng trên 1 công trình; giới thiệu MOSFOA (đã công bố trước); khoảng trống nghiên cứu; mục tiêu & phạm vi |
| 2. Đối tượng và mô hình FEM | 2.1 Công trình A; 2.2 Công trình B; 2.3 So sánh đặc điểm 2 công trình; 2.4 Mô hình FEM & điều kiện biên (giữ nguyên đặc điểm riêng từng mô hình); 2.5 MATLAB–SAP2000 |
| 3. Xây dựng bài toán tối ưu | 3.1 Biến thiết kế (chốt sau khi kiểm tra khả năng tham số hoá thực tế); 3.2 Hàm mục tiêu (f1, f2); 3.3 Ràng buộc kết cấu; 3.4 Ràng buộc địa kỹ thuật; 3.5 Xử lý phương án không khả thi |
| 4. Áp dụng MOSFOA | Trình bày ngắn gọn nguyên lý (đã công bố ở bài Q3 trước) — không lặp lại phần phát triển thuật toán |
| 5. Thiết kế thí nghiệm và chỉ tiêu đánh giá | Cấu hình MOSFOA; số lần chạy; số vòng lặp; kích thước quần thể; ngân sách đánh giá FEM; cách xây dựng Pareto tham chiếu (nếu có); IGD; HV; tỷ lệ nghiệm khả thi; độ ổn định |
| 6. Kết quả và thảo luận | 6.1 Đặc điểm 2 bài toán; 6.2 Kết quả công trình A; 6.3 Kết quả công trình B; 6.4 Độ ổn định MOSFOA; 6.5 So sánh đặc điểm nghiệm Pareto giữa 2 công trình; 6.6 Thảo luận (chỉ tập trung khả năng áp dụng, không đi sâu độ nhạy) |
| 7. Kết luận | MOSFOA giải được bài toán trên cả 2 công trình; mức độ ổn định; đặc điểm chung/khác của nghiệm; ý nghĩa kiểm chứng trên 2 công trình — **không** tuyên bố MOSFOA tối ưu nhất nói chung |

> Lưu ý: cấu trúc 7 chương này **thay thế** khung 8 chương sơ bộ ban đầu trong `Bai_2.md` — dùng cấu trúc 7 chương ở trên làm khung viết bài chính thức.
