# Công thức hoá bài toán tối ưu (MOSFOA) — sẵn sàng để code hoá MATLAB

> Thực hiện bước 7 (`Danh_gia_kha_thi_Bai_2.md` mục 5). Dựa trên các quyết định đã chốt: biến `{D_cọc, t_cọc}`, mục tiêu `{f1, f2}`, ràng buộc theo TCVN 10304:2025 (đã có Rk/Rd tại 1 điểm chuẩn/công trình). File này **không tự đặt thêm giả định mới** — chỗ nào cần thêm dữ liệu để code hoá đầy đủ đều đánh dấu rõ.

---

## 1. Biến thiết kế & mã hoá

### ✅ ĐÃ CÓ catalogue thật — [`Cataloge coc ly tam.md`](Cataloge%20coc%20ly%20tam.md) (AMACCAO PHC/PC, D300–D1200, theo TCVN 7888:2014 & JIS A 5373:2016)

**⚠️ Phát hiện quan trọng cần bạn xác nhận:** Trong catalogue thật này, **`t` (chiều dày thành cọc) KHÔNG phải biến độc lập với `D`** — mỗi đường kính ngoài chỉ có đúng **1 chiều dày chuẩn** theo dây chuyền sản xuất (D700→t=110mm, D800→t=120mm, D900/D1000→t=130mm...). Biến thứ hai thực chất có ý nghĩa là **Class (A/B/C)** — cấp ứng suất nén trước, quyết định `Mcr`/`Mu` (không ảnh hưởng khối lượng vì cùng tiết diện hình học). Bộ biến đã chốt tên là `{D_cọc, t_cọc}` — **về bản chất vật lý nên hiểu là `{D_cọc, Class}`**, vì `t_cọc` sẽ tự động theo `D_cọc` nếu dùng đúng catalogue AMACCAO này. Đây **không phải mâu thuẫn với quyết định đã chốt** (vẫn là 2 biến rời rạc, vẫn 1 chỉ số catalogue duy nhất) — chỉ là làm rõ ý nghĩa vật lý của biến thứ 2 để không nhầm khi code hoá.

### ✅ ĐÃ CHỐT (người dùng, 09/09/2026): dùng thẳng catalogue AMACCAO cho CẢ 2 công trình, không giữ riêng t=130 của hồ sơ gốc

Để đơn giản hoá, cọc "phương án gốc" của cả A và B đều quy về đúng dòng catalogue AMACCAO gần nhất theo D: **A → D800-t120** (thay vì D800-t130 hồ sơ gốc), **B → D700-t110** (thay vì D700-t130 hồ sơ gốc). Không còn "2 dòng ngoài catalogue" — toàn bộ không gian thiết kế nằm gọn trong 1 bảng catalogue chuẩn duy nhất.

**Hệ quả cần lưu ý khi code (không phải lỗi, chỉ là điểm khác so với hồ sơ thiết kế thi công gốc):**
- `A_tip` (diện tích mũi bịt kín, = π/4·D²) **không đổi** vì chỉ phụ thuộc D → **Rd(A)=473,5 Tf và Rd(B)=348,1 Tf đã tính ở `SucChiuTai_Coc_TCVN10304_2025.md` vẫn dùng được nguyên vẹn**, không cần tính lại phần địa kỹ thuật.
- `A_shaft`, `I`, `W`, khối lượng/m **đổi theo t catalogue** (mỏng hơn hồ sơ gốc 10-20mm) → `f1` (khối lượng) và `g2/g3` (Pmax, Mu theo vật liệu) của phương án gốc giờ dùng số liệu catalogue AMACCAO (mục 4), không dùng số liệu hồ sơ thiết kế gốc nữa (Pmax=658T/Mu=134,8T·m của hồ sơ A **không dùng làm baseline chính thức nữa** — xem đối chiếu mục 4, giờ chỉ còn giá trị tham khảo lịch sử).
- ✅ **ĐÃ CHỐT (người dùng, 09/09/2026): dùng Class C** (cấp ứng suất nén trước cao nhất trong 3 mức) làm baseline cho cả 2 công trình.

Biến thiết kế là **1 chỉ số nguyên** chọn 1 dòng trong bảng catalogue (D, Class):

```
x ∈ {1, 2, ..., K}   (K = 11 D × 3 Class = 33 dòng, dùng chung 1 bảng catalogue cho cả 2 công trình)
```

**Bảng hình học đầy đủ D300–D1200 (trích từ `Cataloge coc ly tam.md` mục 2 — dùng trực tiếp, không cần tính lại):**

| D (mm) | t (mm) | A (cm²) | I (cm⁴) | W (cm³) | Khối lượng (kg/m) |
|---|---|---|---|---|---|
| 300 | 60 | 452,4 | 43.197 | 2.880 | 113 |
| 350 | 65 | 582,0 | 76.013 | 4.344 | 146 |
| 400 | 75 | 765,8 | 134.810 | 6.741 | 191 |
| 450 | 80 | 929,9 | 207.740 | 9.233 | 232 |
| 500 | 90 | 1.159,2 | 318.340 | 12.734 | 290 |
| 600 | 100 | 1.570,8 | 628.320 | 20.944 | 393 |
| **700** | **110** ← dùng làm baseline B (thay t=130 hồ sơ gốc) | 2.038,9 | 1.123.800 | 32.109 | 510 |
| **800** | **120** ← dùng làm baseline A (thay t=130 hồ sơ gốc) | 2.563,5 | 1.833.200 | 45.830 | 641 |
| 900 | 130 | 3.144,7 | 2.752.100 | 61.158 | 786 |
| 1000 | 130 | 3.553,1 | 3.923.600 | 78.472 | 888 |
| 1200 | 150 | 4.948,0 | 8.011.800 | 133.530 | 1.237 |

Mỗi dòng catalogue `k` đi kèm:
- `A_shaft,k` = diện tích NGUYÊN VÀNH KHUYÊN (cột A ở trên, tính sẵn theo D,t thật — **dùng cho khối lượng f1**, vì thân cọc vẫn rỗng dù mũi bịt kín).
- `A_tip,k` = π/4·D² (diện tích tròn đặc, **chỉ dùng cho số hạng `qb·A` trong Rk** — vì đã chốt mũi cọc bịt kín, không phụ thuộc t).
- `u_k` = π·D — chu vi ngoài, dùng cho `Σfi·hi`.
- `I_k`, `W_k` — lấy thẳng từ catalogue (cột ở trên).
- `Mcr_k`, `Mu_k`, `Pmax_k` — **ĐÃ CÓ ĐẦY ĐỦ cho mọi D, theo 3 Class (A/B/C)** — xem mục 4 (đã cập nhật bằng số liệu catalogue thật).
- `Rd_k` = sức chịu tải theo đất nền — tính theo công thức đóng ở mục 2 (chỉ phụ thuộc D qua `A_tip`, `u`).

---

## 2. ⚠️ Vấn đề cần xử lý trước khi mở rộng ngoài 2 điểm baseline: `Rd` phụ thuộc chiều dài cọc, không chỉ D/t

Rk/Rd đã tính ở `SucChiuTai_Coc_TCVN10304_2025.md` chỉ đúng cho **đúng 1 chiều dài cọc cụ thể** (A: L=34m tới −28,5m; B: tới −36,93m) — vì `qb`, `Σfi·hi` phụ thuộc trực tiếp vào **cao độ mũi cọc** (qua trụ hố khoan đã xác định). Nếu đổi `D_cọc`/`t_cọc` mà **giữ nguyên cao độ mũi cọc** (đúng theo quyết định mục 2.3 — không đổi bố trí/hình học), thì:

- `u`, `A` đổi theo D/t (ảnh hưởng trực tiếp `Rk`).
- `qb`, `fi` (tra Bảng 2/3 theo độ sâu + loại đất, **không phụ thuộc D**) — **giữ nguyên** vì cùng trụ hố khoan, cùng cao độ mũi cọc.
- ⇒ Công thức `Rd(D,t)` cho MỖI công trình có thể viết lại thành 1 hàm **đóng kín, tính nhanh** không cần tra lại bảng mỗi lần:

```
Rk(D,t) = γc·(qb_tip · A(D)  +  u(D) · Σ(fi·hi))      # qb_tip, Σ(fi·hi) là HẰNG SỐ đã tính sẵn/công trình
Rd(D,t) = Rk(D,t) / 1,4
```

Trong đó (đã tính sẵn, dùng lại được):
| Công trình | `qb_tip` (kPa) | `Σ(fi·hi)` (kPa·m) |
|---|---|---|
| A (mặt cắt 1-1) | 11.100 | 366,75 |
| B | 8.605 | 667,70 |

**Việc cần làm:** nếu không gian catalogue có nhiều dòng D khác baseline nhiều (ví dụ D500 hay D1000), `qb_tip`/`Σfi·hi` cố định ở trên **có thể không còn hợp lý về mặt vật lý** (đường kính khác quá nhiều làm thay đổi giả thiết chiều rộng ảnh hưởng nền qua hệ số vùng) — nhưng theo đúng công thức TCVN 10304:2025 (9), `qb`/`fi` tra bảng chỉ phụ thuộc **độ sâu và loại đất**, không phụ thuộc D, nên về mặt tính đúng công thức, **cách trên áp dụng được cho mọi D trong bảng catalogue mà không cần tính lại** — chỉ cần lưu ý D quá nhỏ/quá lớn so với 2 baseline nên được xem xét cẩn trọng hơn khi phân tích kết quả (không phải lỗi công thức).

---

## 3. Hàm mục tiêu

### f1 — Khối lượng vật liệu (chỉ phần thuộc phạm vi tối ưu = cọc BTCT ƯST chính)

```
f1(x) = N_pile · ρ_bt · A(D_x) · L_pile_thực_tế
```

- `N_pile` = số lượng cọc BTCT ƯST chính trong 1 phân đoạn (A: 132; B: 132) — **cố định, không đổi theo x** (vì bố trí giữ nguyên, mục 2.3).
- `ρ_bt` = khối lượng riêng bê tông cọc (A: M600/M800 theo mác cụ thể; B: M600) — lấy từ vật liệu SAP đã có sẵn (`FEM_*.md` mục 3).
- `A(D_x)` = **`A_shaft` (diện tích vành khuyên/rỗng, cột A trong bảng catalogue mục 1)** — **KHÔNG dùng `A_tip` bịt kín ở đây** — vì thân cọc vẫn rỗng suốt chiều dài, chỉ riêng mũi cọc mới bịt kín bằng tấm thép nhỏ (ảnh hưởng không đáng kể tới khối lượng tổng, bỏ qua theo đúng mức độ chi tiết cần thiết).
- `L_pile_thực_tế` = chiều dài chế tạo cọc — **đã chốt số cụ thể**: **A = 34 m** (tại mặt cắt 1-1, từ DXF); **B = 41,00 m** (= 15,57 + 25,43, theo sheet `Ltt(LK3)`/`Ltt(BH17)` của `1.Tinh ben VGP.xls`) — cố định, không đổi theo D/t (theo đúng mục 2.3: giữ nguyên hình học/cao độ mũi cọc, chỉ đổi tiết diện).
- (Tuỳ chọn, cần xác nhận nếu muốn chính xác hơn): trừ đi khối lượng phần rỗng nếu vẫn tính theo cọc-ống trước khi bịt kín ở đầu/mũi — **bỏ qua chi tiết này** cho phù hợp mức độ chính xác cần thiết của Bài 2 (không mở rộng tính chi tiết cấu tạo đầu/mũi cọc, đúng tinh thần "gọn — chặt — đúng phạm vi").

### f2 — Chuyển vị ngang cực đại

```
f2(x) = max( |U1_joint| )   với joint thuộc đỉnh bến (cao trình mặt bến), dưới tổ hợp bất lợi nhất
```

- Công trình A: tổ hợp `"BAO"` (storm), lấy từ `SapModel.Results.JointDispl` sau `RunAnalysis` với tiết diện cọc đã cập nhật theo `x`.
- Công trình B: ✅ **ĐÃ XÁC NHẬN BẰNG KẾT QUẢ FEM THẬT** (người dùng chạy, xuất `Chuyen vi. s2k.s2k`, đã trích trực tiếp từ bảng `JOINT DISPLACEMENTS` cho toàn bộ 37 tổ hợp): **tổ hợp khống chế = `COMB14` (trùng giá trị với tổ hợp đặt tên sẵn `BAO` trong model — 2 tên cùng 1 kết quả, có thể là 1 tổ hợp được lưu 2 lần dưới 2 tên)**. `max|U1| = 15,36 mm` tại nút 273 — **nhỏ hơn nhiều** so với giới hạn vận hành 30mm (mục 4.3), dùng khoảng **51%** giới hạn cho phép ở phương án gốc (D700-t110-ClassC). Bảng đầy đủ 37 tổ hợp đã tính, xếp hạng theo `max|U1|` giảm dần — top 5: COMB14/BAO=15,36mm; COMB13=13,59mm; COMB17=13,58mm; COMB15=13,47mm; COMB18=12,81mm (tất cả đều < 30mm).

---

## 4. Ràng buộc

### 4.1. Ràng buộc địa kỹ thuật (TCVN 10304:2025)

```
g1(x):  γn · N_max(x) ≤ Rd(D_x, t_x)
```
- `N_max(x)` = lực dọc trục lớn nhất trong các cọc, đọc từ `SapModel.Results.FrameForce` sau khi chạy FEM với tiết diện `x`, dưới tổ hợp bất lợi nhất (nén lớn nhất).
- `γn`: **A — ✅ ĐÃ CHỐT (người dùng, 09/09/2026): Công trình A = Cấp I** (giữ theo đúng thuyết minh gốc/Thông tư 10/2013/TT-BXD, không dùng cách xếp "đặc biệt" theo Thông tư 06/2021/TT-BXD đã thảo luận trước đó). ⇒ **γn(A) = 1,0** (C1, theo bảng γn mục 7.1.6.1 TCVN 10304:2025) — vấn đề "chưa có TCVN 2737 để tra cấp đặc biệt" không còn phát sinh vì đã chốt dùng Cấp I.

- **B** — ✅ đã xác nhận trực tiếp **Cấp II → γn(B) = 1,15** (theo bảng γn mục 7.1.6.1: C1=1,0; C2=1,15; C3=1,20).
- `Rd(D_x,t_x)` — tính theo công thức mục 2 ở trên.

### 4.2. Ràng buộc vật liệu cọc (ứng suất/mô men)

```
g2(x):  N_max(x) ≤ Pmax(D_x, t_x)
g3(x):  M_max(x) ≤ Mu(D_x, t_x)     [kiểm tra bền — bắt buộc]
g4(x):  M_max(x) ≤ Mcr(D_x, t_x)    [kiểm tra nứt — tuỳ chọn, theo yêu cầu SLS nếu cần]
```

### ✅ ĐÃ CÓ — Bảng Mcr/Mu/Qallow theo D và Class (nguồn: `Cataloge coc ly tam.md` mục 3, catalogue AMACCAO PHC f'c≥80MPa)

| D (mm) | Class A: Mcr / Mu (kN·m) | Class B: Mcr / Mu (kN·m) | Class C: Mcr / Mu (kN·m) |
|---|---|---|---|
| 500 | 103,0 / 154,5 | 147,1 / 220,6 | 186,3 / 279,5 |
| 600 | 166,7 / 250,1 | 245,2 / 367,7 | 304,0 / 456,0 |
| **700** | 255,0 / 382,5 | 372,7 / 559,0 | 470,7 / 706,1 |
| **800** | 362,8 / 544,3 | 539,4 / 809,0 | 676,7 / 1.015,0 |
| 900 | 480,0 / 720,0 | 710,0 / 1.065,0 | 890,0 / 1.335,0 |
| 1000 | 610,0 / 915,0 | 900,0 / 1.350,0 | 1.130,0 / 1.695,0 |

**Sức chịu tải vật liệu Pmax (catalogue mục 4, dạng khoảng — sơ bộ, chưa tách theo Class):**

| D (mm) | Pmax (T) |
|---|---|
| 700 | 500 – 680 |
| 800 | 680 – 900 |
| 900 | 880 – 1.150 |
| 1000 | 1.100 – 1.400 |

**✅ ĐÃ ĐƠN GIẢN HOÁ (theo quyết định dùng thẳng catalogue AMACCAO cho cả 2 công trình):** không cần đối chiếu/hoà giải với số liệu hồ sơ gốc (Mu=134,8 T·m, Pmax=658T của thiết kế thi công cũ) nữa — **dùng thẳng bảng catalogue Mcr/Mu/Pmax ở trên cho MỌI dòng, kể cả 2 dòng baseline D800/D700**. Số liệu hồ sơ gốc chỉ còn giá trị **tham khảo lịch sử** (ghi chú lại để biết công trình thật từng dùng cọc dày hơn/khoẻ hơn catalogue chuẩn — có thể nhắc trong phần thảo luận của bài báo như 1 quan sát thú vị, không dùng làm ràng buộc tính toán).

**✅ ĐÃ CHỐT: dùng Class C** (mục 1) làm đại diện cho "phương án gốc" của cả 2 công trình trong kết quả trình bày.

### Ghi chú: mục 5.2 của `Cataloge coc ly tam.md` đề xuất hàm mục tiêu chi phí — KHÔNG áp dụng cho Bài 2

File catalogue có đề xuất hàm mục tiêu dạng chi phí `C_total = N_piles×(L×Cm + Cdrive) + Vcap×Cconcrete` — đây là gợi ý chung của tài liệu catalogue, **không áp dụng cho Bài 2** vì đã chốt `f1 = khối lượng vật liệu` (không phải chi phí, theo đúng danh sách cấm mục 3 `Danh_gia_kha_thi_Bai_2.md`).

### 4.3. ✅ ĐÃ CHỐT — Ràng buộc chuyển vị

```
g5(x):  f2(x) ≤ U_cho_phép = 30 mm
```
- **Nguồn:** người dùng cung cấp trực tiếp `chuyen vi ben.png` — *Bảng 12, Giới hạn chuyển vị khi khai thác đối với kết cấu bến*: phương ngang, đỉnh bến trên nền cọc/đỉnh trụ → giới hạn = `1/300 chiều cao bến, không vượt quá 100mm`. Người dùng xác nhận trực tiếp dùng **U_cho_phép = 30mm** cho cả 2 công trình (chặt hơn giá trị suy từ công thức bảng, xem đối chiếu dưới) — dùng 30mm làm giá trị chính thức.
- **Đối chiếu tham khảo (không dùng để tính, chỉ để kiểm tra hợp lý):** A: H=21,5m (đỉnh+5,5 → đáy nạo vét−16,0) → 1/300×H=71,7mm; B: H≈17,0m (đỉnh+5,5 → đáy bến hoàn thiện−11,5) → 1/300×H=56,7mm. Cả 2 đều **lớn hơn** 30mm → giá trị 30mm người dùng cho là **yêu cầu vận hành riêng của dự án, chặt hơn** giới hạn kết cấu chung của Bảng 12 (hợp lý — thường do yêu cầu về ray cần trục nhạy với biến dạng ngang hơn giới hạn kết cấu thông thường).
- **✅ Áp dụng làm ràng buộc cứng g5** (khác với đề xuất trước đó là "không đặt ràng buộc cứng, chỉ dùng f2 làm mục tiêu") — vì nay đã có căn cứ rõ ràng (30mm), việc vừa dùng `f2` làm mục tiêu tối thiểu hoá **vừa** đặt ràng buộc cứng ở 30mm là hợp lý và không trùng lặp logic: mục tiêu tìm phương án chuyển vị càng nhỏ càng tốt trong số các phương án **đã thoả mãn** giới hạn cứng 30mm (loại bỏ trước các phương án vượt ngưỡng vận hành, dù khối lượng nhỏ).

### 4.4. Xử lý nghiệm không khả thi (đề cương mục 4.5)

**Đề xuất áp dụng thống nhất cho cả 2 công trình** (theo đúng yêu cầu "cùng 1 nguyên tắc"):
```
Nếu vi phạm bất kỳ g1..g4:
    fitness = [rất lớn, rất lớn]   (phạt cứng — loại khỏi Pareto ngay, KHÔNG dùng hàm phạt mềm cộng dồn)
Ngược lại:
    fitness = [f1(x), f2(x)]
```
Lý do dùng phạt cứng thay vì hàm phạt mềm (cộng thêm vào f1/f2): đơn giản, minh bạch, không cần hiệu chỉnh hệ số phạt — phù hợp tinh thần "gọn – chặt", và catalogue rời rạc nhỏ nên không lo tốc độ hội tụ chậm vì phạt cứng.

---

## 5. Việc còn thiếu để code hoá đầy đủ (không tự đặt giả định, liệt kê rõ)

1. ~~Bảng catalogue cọc PHC/PC thật~~ ✅ **ĐÃ CÓ VÀ ĐÃ CHỐT DÙNG** — `Cataloge coc ly tam.md` (AMACCAO, D300-D1200, TCVN 7888:2014/JIS A 5373:2016), dùng cho **cả 2 công trình** (baseline A→D800-t120, B→D700-t110, Class C).
2. ~~Mcr/Mu/Pmax cho từng dòng catalogue~~ ✅ **ĐÃ CÓ VÀ ĐÃ CHỐT DÙNG** cho D500-D1000 × Class A/B/C (mục 4) — **kể cả 2 dòng baseline**, không dùng số liệu hồ sơ gốc nữa (đã đơn giản hoá theo quyết định mục 1).
3. ~~Cấp công trình B~~ ✅ Cấp II → `γn(B) = 1,15`. ~~Cấp công trình A~~ ✅ Cấp I → `γn(A) = 1,0` (cả 2 đã chốt, mục 4.1).
4. ~~Xác nhận Comb nào của B cho chuyển vị lớn nhất~~ ✅ **ĐÃ CÓ KẾT QUẢ FEM THẬT**: `COMB14` (=`BAO`), max|U1|=15,36mm tại nút 273 (xem mục 3, f2).
5. ~~Giới hạn chuyển vị vận hành~~ ✅ **ĐÃ CHỐT**: U_cho_phép = 30mm (nguồn: `chuyen vi ben.png`, Bảng 12, đối chiếu người dùng xác nhận) — dùng làm ràng buộc cứng g5 (mục 4.3).
6. ~~Chiều dài chế tạo cọc~~ ✅ **ĐÃ CHỐT**: A = 34 m (DXF mặt cắt 1-1); B = 41,00 m (sheet `Ltt(LK3)`/`Ltt(BH17)`, `1.Tinh ben VGP.xls`).
7. ~~Nguồn Mu=134,8 T·m hồ sơ A~~ — **không còn cần thiết**, vì đã chốt dùng thẳng catalogue AMACCAO (mục 1-2) thay cho số liệu hồ sơ gốc.

**✅ TẤT CẢ các việc trong danh sách này đã giải quyết xong.** Bộ số liệu baseline đã đầy đủ 100% để viết code khung ngay — không còn việc nào tồn đọng.
