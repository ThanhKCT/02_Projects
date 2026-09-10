# So sánh 2 dự án Cầu tàu dùng làm case-study cho bài toán tối ưu SOO/MOO

So sánh giữa:
- **Dự án A — Lạch Huyện (HICT), 100.000DWT** — nguồn: [`FEM_PhanDoan_TieuChuan_100000DWT.md`](FEM_PhanDoan_TieuChuan_100000DWT.md)
- **Dự án B — VIPGreenPort/Viconship (Đình Vũ), 30.000DWT** — nguồn: [`FEM_CauTau_VIPGreenPort_30000DWT.md`](FEM_CauTau_VIPGreenPort_30000DWT.md)

---

## 1. Quy mô & tổng quan

| Thông số | A. Lạch Huyện 100.000DWT | B. VIPGreenPort 30.000DWT | Tỷ lệ A/B |
|---|---|---|---|
| Tàu thiết kế lớn nhất | 100.000 DWT (L330×B45,5×Tc14,8m) | 30.000 DWT (L210×B30×Tc10,7m) | ~3,3× DWT |
| Vị trí | Cửa ngõ Lạch Huyện, Hải Phòng (biển hở) | Sông Cấm, Đình Vũ, Hải Phòng (sông, kín gió hơn) | — |
| Tổng chiều dài bến | 750 m (10 phân đoạn) | 377,2 m hoàn thiện / 226,32 m GĐ1 (3 phân đoạn GĐ1) | 2,0× (GĐ1) |
| Chiều dài 1 phân đoạn | ~75,0 m (14 nhịp × 5,1m) | ~75,44 m (module cọc dọc ~4,8–4,9m) | ≈ bằng nhau (trùng hợp) |
| Chiều rộng mặt bến | 50,0 m | 24,0 m | 2,08× |
| Cao trình đỉnh bến | +5,50 m (Hải đồ) | +5,50 m (Hải đồ) | **bằng nhau** |
| Cao trình đáy bến | −16,0 m (Hải đồ) | −10,60 m (GĐ1) / −11,50 m (hoàn thiện) | 1,4–1,5× sâu hơn |
| MNCTK / MNTTK | +3,55 / +0,43 m | +3,75 / +0,80 m | tương đương |
| Cấp công trình / tuổi thọ | Cấp I, 50 năm, kháng chấn cấp VI (a=0,0368) | Không nêu rõ cấp/tuổi thọ trong hồ sơ đã đọc; không có tính toán kháng chấn | A đầy đủ hơn |

**Nhận xét:** Hai dự án có **cùng cao trình đỉnh bến +5,50m** (cùng chuẩn hải đồ khu vực Hải Phòng) nhưng khác biệt lớn về **quy mô tàu (100k vs 30k DWT) → kéo theo bề rộng bến gấp đôi (50m vs 24m)** và **độ sâu trước bến gấp ~1,5 lần**. Đây là 2 điểm dữ liệu tốt để kiểm tra khả năng mở rộng (scalability) của thuật toán tối ưu theo quy mô công trình.

---

## 2. Hình học mô hình FEM (SAP2000)

| Thông số | A. Lạch Huyện | B. VIPGreenPort |
|---|---|---|
| Phần mềm | SAP2000 v14.1.0 | SAP2000 v16.0.0 (2 bản export trùng hình học, 1 export lại bằng v24) |
| Số nút (Joints) | 4.913 | 2.532 |
| Số phần tử thanh (Frame) | 1.734 | 960 |
| Số phần tử tấm (Area) | 4.488 | 2.289 |
| Bbox X | −1,8 ÷ 73,2 m (dọc bến) | −0,59 ÷ 24,0 m (**ngang** bến — trục X/Y đảo chiều giữa 2 model) |
| Bbox Y | −22,75 ÷ 28,68 m (ngang bến) | 0,13 ÷ 75,57 m (**dọc** bến) |
| Bbox Z | −23,11 ÷ +5,50 m | −21,09 ÷ 0,00 m (hệ toạ độ cục bộ, Z=0 ≈ +4,07m Hải đồ) |
| Điều kiện biên chân cọc | Lò xo trục U3 rời rạc tại 178 nút (mô phỏng ma sát/mũi cọc) + ngàm biên phân đoạn | **Ngàm cứng tuyệt đối** 6 bậc tự do tại toàn bộ 132 nút chân cọc (độ cứng nền đã "ẩn" vào chiều dài ngàm ảo tính theo TCXD 205:1998) |

**Nhận xét kỹ thuật quan trọng cho FEM↔optimizer:** Hai dự án dùng **2 cách tiếp cận mô hình hoá nền cọc khác nhau** — A dùng lò xo (winkler-spring), B dùng chiều dài ngàm ảo + ngàm cứng. Nếu đưa cả 2 vào chung một pipeline tối ưu, cần chuẩn hoá lại cách xử lý độ cứng nền (hoặc chấp nhận đây là 2 biến thể phương pháp luận cần so sánh độ nhạy kết quả).

---

## 3. Vật liệu

| Vật liệu | A. Lạch Huyện | B. VIPGreenPort |
|---|---|---|
| Bê tông cọc | M800 (E=3.600.000 T/m²) | M600 (E=3.400.000 T/m²) |
| Bê tông dầm/bản | M400 (E=3.300.000 T/m²) | M350 (E=3.100.000 T/m²) |
| Cốt thép | A615Gr60 (Fy≈4.218 kG/cm²) | A615Gr60 (giống hệ ký hiệu, cùng nguồn gốc thiết kế) |
| Thép cọc ống | Có (cọc thép D1016, Fy tham chiếu 3.150 kG/cm²) | **Không có cọc thép** — toàn bộ cọc là BTCT ƯST |

**Nhận xét:** Dự án A (100k DWT, biển hở) dùng **mác bê tông cao hơn** (M800/M400 so với M600/M350) và có thêm **hệ cọc ống thép** (chịu tải trọng va tàu lớn hơn, D1016mm) bên cạnh cọc BTCT — phản ánh tải trọng thiết kế lớn hơn nhiều. Dự án B chỉ dùng 1 loại cọc BTCT ƯST duy nhất (D700-130) cho toàn bộ hệ, đơn giản hoá thi công nhưng ít linh hoạt hơn về biến thiết kế.

---

## 4. Hệ cọc

| Thông số | A. Lạch Huyện | B. VIPGreenPort |
|---|---|---|
| Loại cọc chính | Cọc ống BTCT ƯST D800 (D800-540, t=130mm) **+** cọc ống thép D1016 (t=16mm) | Chỉ 1 loại: Cọc ống BTCT ƯST **D700-130** (D700-440, t=130mm) |
| Số cọc/phân đoạn | 132 BTCT + 60 thép = **192 cọc** | **132 cọc** (không có cọc thép) |
| Tổng số cọc toàn tuyến | 1.320 BTCT + 600 thép = **1.920 cọc** (10 phân đoạn × 750m) | **≈396 cọc** GĐ1 (3 phân đoạn × 132, suy từ SAP — đáng tin cậy hơn số liệu DXF ~464-680) |
| Chiều dài chế tạo | 28–34m (BTCT) / 28–32m (thép) | ~40m (BTCT ƯST D700) |
| Chiều dài mô hình FEM (ngàm ảo) | 20,2–28,2m (BTCT) / 24,4–28,6m (thép) | 14,42–21,09m |
| Độ xiên | 6:1 (hàng trong), 7:1 (hàng biên thép) | **8:1** (hàng phía sông) |
| Số hàng cọc ngang bến | Không nêu rõ số hàng trong file A | **5 hàng** (lưới cách nhau 4,75–5,25m) |
| Bước cọc dọc bến | 5,1 m | 4,80–4,90 m |
| Sức chịu tải cho phép công bố | **Có**: Mcr=67,4 T.m, Mu=134,8 T.m, Pmax=658T (cọc D800) | **Không có sẵn** trong hồ sơ đã đọc — cần tra thêm |

**Nhận xét:** Cùng họ vật liệu (cọc ống BTCT ƯST tiết diện vành khuyên, cùng cấu tạo D-t giống công thức thiết kế Việt Nam điển hình cho cảng biển), nhưng A có thêm lớp cọc thép D1016 để tăng khả năng chịu lực ngang (phù hợp tải va/neo tàu 100k DWT lớn hơn nhiều). Độ xiên B (8:1) hơi thoải hơn A (6:1/7:1) — hợp lý vì tải ngang nhỏ hơn.

---

## 5. Kết cấu dầm – bản

| Cấu kiện | A. Lạch Huyện | B. VIPGreenPort |
|---|---|---|
| Dầm ngang (DN) | 120×190cm | 100×150cm |
| Dầm dọc (DD) | 120×190cm | 100×150cm |
| Dầm cần trục | 160×250cm (×2 tuyến: sông + bờ) | 120×220cm (sông/bờ) + 100×180cm (giữa, ray thứ 3) |
| Bản mặt cầu | Không nêu rõ ký hiệu tách biệt (BMC dày 50cm) | `BAN` dày 40cm |
| Bản tựa/bản mép bến | `BTT` dày 40cm (chưa xác nhận công năng) | `DTT`/`BTT` dày 35cm (bản tựa tàu — xác nhận qua bảng tính) |
| Đoạn vuốt tiết diện tại vùng va tàu | Có (`KVA1/2`, `VA1/2`, nonprismatic) | Không thấy trong hồ sơ đã đọc |
| Cọc khoan neo bổ sung vào đá | Có (`KHOANNEO`, D=1,0m) | Không có |

**Nhận xét:** A có kết cấu **phức tạp và "nặng" hơn hẳn** (dầm 120×190/160×250cm, có đoạn vuốt tiết diện vùng va tàu, có cọc khoan neo bổ sung vào đá gốc) — phù hợp bến nước sâu chịu tải tàu lớn ngoài biển hở. B có kết cấu **gọn nhẹ hơn** (dầm 100×150/120×220cm), điển hình bến sông cỡ trung.

---

## 6. Tải trọng khai thác

| Loại tải | A. Lạch Huyện | B. VIPGreenPort |
|---|---|---|
| Hàng hoá phân bố | 4,0 T/m² (khớp cả 2 dự án) | 4,0 T/m² (ray sông→bờ); 2,0 T/m² (dải 2m mép ngoài) |
| Cần trục chính | 65T SWL, khổ ray 24m; bánh max 76,7T (khai thác)/58,9T (bão) | **2 loại**: KE 45T khổ ray 10,5m (bánh 25T) **+** QC 40T khổ ray 20m (bánh 35,4T sông/29,4T bờ khai thác; 28,5/43,8T khi bão) |
| Ô tô/xe chuyên dụng | Không nêu chi tiết trong file A | Tương đương H30: trục trước 6T, trục sau 12T |
| Lực va tàu (berthing) | Không có bảng chi tiết trong file A (chỉ có LoadPat `Va`) | **Có đầy đủ**: theo PIANC2002/OCDI, E=22,24 T.m (30k DWT), đệm Vsx-P 800H, Hx=166T/Hy=83T |
| Lực neo tàu (mooring) | Neo1 (bích 150T): F1=93,72/F2=54,11/F3=39,39T; Neo2: F1=68,15/F2=39,35/F3=66,03T | Bích 100T: Sq=26,43/Sn=45,79/Sv=44,36T (theo 22TCN 222-95) |
| Tải trọng sóng/gió/dòng chảy | `AUTO WAVE`: SWaterDepth=45m (nghi ngờ giá trị mặc định, chưa xác nhận dùng thật) | Có tính toán cụ thể: Vdòng chảy=1,62m/s dọc bến, sóng hs=0,5m, gió khai thác 20,7m/s, gió bão 55m/s (dùng tính tải cần trục QC-BAO) |
| Số tổ hợp tải trọng | 36 tổ hợp | 37 tổ hợp (cấu trúc tương tự: BT/VA/NEO/HHi/OTO/cần trục, tổ hợp bão riêng) |

**Nhận xét:** Bích neo A (150T) cao hơn B (100T) tương ứng tàu lớn hơn. Điểm đáng chú ý: **bảng tính của B chi tiết và minh bạch hơn nhiều** (đọc được đầy đủ công thức PIANC/OCDI, số liệu neo do gió/dòng chảy) trong khi A phải suy luận nhiều từ ghi chú bản vẽ do thiếu bảng tính gốc — nguồn dữ liệu B đáng tin cậy hơn ở phần tải trọng.

---

## 7. Tiêu chuẩn thiết kế áp dụng

| | A. Lạch Huyện | B. VIPGreenPort |
|---|---|---|
| Móng cọc | TCVN 10304:2014 | TCXD 205:1998 (bộ tiêu chuẩn cũ hơn) |
| Kháng chấn | TCVN 9386:2012, a=0,0368 | Không thấy tính toán kháng chấn |
| Tải trọng tàu/sóng | 22TCN 222-95 | 22TCN 222-95 (giống) + PIANC 2002/OCDI 2002 (bổ sung, chi tiết hơn) |
| Công trình bến cảng | 22TCN 207-92 | 22TCN 207-92 (giống) |
| Năm thiết kế | 12/2014 | 10/2014 (kè) — bến chính có thể sớm hơn (thuyết minh dẫn chiếu hồ sơ 1996/2008/2010) |

**Nhận xét:** Cùng hệ tiêu chuẩn Việt Nam nền tảng (22TCN 207-92, 222-95) nhưng A áp dụng **bộ móng cọc mới hơn (TCVN 10304:2014 thay cho TCXD 205:1998)** và có thêm kiểm tra kháng chấn — phù hợp thời điểm thiết kế sau và quy mô công trình cấp I. B vẫn dùng TCXD 205:1998 (bộ cũ, dù cùng năm thiết kế ~2014) — có thể do dự án B là công trình cải tạo/nâng cấp trên nền dự án cũ (1996, 2008, 2010) nên giữ nguyên tiêu chuẩn gốc.

---

## 8. Ý nghĩa đối với bài toán tối ưu SOO/MOO

1. **2 dự án tạo thành cặp case-study "lớn – nhỏ" lý tưởng** để kiểm chứng khả năng mở rộng (scalability) của thuật toán tối ưu đa mục tiêu: cùng dạng kết cấu (bệ cọc cao, dầm–bản BTCT trên cọc ống BTCT ƯST), cùng vùng địa lý (Hải Phòng), nhưng khác nhau ~2× về bề rộng bến, ~2× tổng số cọc/phân đoạn (192 vs 132 — do A có thêm cọc thép), ~1,3× mác bê tông.
2. **Biến thiết kế nên dùng chung 1 khung tham số hoá** giữa 2 dự án (đường kính D, chiều dày t, khoảng cách s_x/s_y, kích thước dầm b×h) để so sánh trực tiếp Pareto front giữa 2 quy mô — xem miền giá trị đề xuất ở mục 12/13 trong từng file gốc.
3. **A phù hợp hơn để làm case-study "đầy đủ ràng buộc"** vì đã có sẵn Mcr/Mu/Pmax cọc, cấp kháng chấn — trong khi **B phù hợp hơn để làm case-study "tải trọng minh bạch"** vì có bảng tính chi tiết công thức PIANC/OCDI cho lực va/neo tàu (rất hữu ích để xây dựng hàm ràng buộc chịu lực từ tải môi trường thay vì trị số cho sẵn).
4. **Khác biệt cách mô hình hoá nền cọc (lò xo ở A vs ngàm ảo ở B)** là điểm cần xử lý thống nhất trước khi đưa cả 2 vào cùng 1 pipeline FEM–optimizer tự động — khuyến nghị chuyển đổi cả 2 về **1 phương pháp chung** (ví dụ đều dùng TCVN 10304:2014 + lò xo p-y) để đảm bảo so sánh công bằng giữa 2 quy mô công trình trong bài báo.
5. Cả 2 dự án đều thiếu công khai **hàm chi phí thực tế** (đơn giá vật liệu/nhân công) — cần bổ sung từ nguồn khác (đơn giá định mức xây dựng hiện hành) để hàm mục tiêu chi phí trong MOO có ý nghĩa thực tiễn, không chỉ dừng ở khối lượng vật liệu quy đổi.

---

## 9. Bảng tổng hợp nhanh (dùng tra cứu nhanh khi code hoá bài toán)

| | A. Lạch Huyện 100k | B. VIPGreenPort 30k |
|---|---|---|
| D cọc chính (mm) | 800 | 700 |
| t cọc (mm) | 130 | 130 |
| Số hàng cọc ngang bến | không rõ | 5 |
| s_x × s_y cọc (m) | — × 5,1 | 5,25×4,9 (không đều) × 4,8-4,9 |
| Mác BT cọc / dầm | M800 / M400 | M600 / M350 |
| Rộng bến (m) | 50 | 24 |
| Cao trình đỉnh bến | +5,50 | +5,50 |
| Số cọc/phân đoạn | 192 (132+60) | 132 |
| Số tổ hợp tải | 36 | 37 |
