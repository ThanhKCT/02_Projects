# BÀN GIAO PHIÊN LÀM VIỆC — 08/09/2026 (cập nhật: đã tiếp thu 3 điểm chốt trước khi chạy)

> Đọc file này trước khi làm bất cứ gì trong phiên Claude mới (sau `/clear`). Mục tiêu: **chạy vét cạn 4.080 tổ hợp qua đêm**, sau đó chạy 30 lần MOFDA + 30 lần MOSFOA (E-MOSFOA), rồi viết bài báo đối sánh thuật toán.

**3 điểm đã CHỐT trước khi chạy (bổ sung cuối phiên, xem chi tiết đề cương Mục B.1 và D.3.2):**
1. **Thuật ngữ**: chỉ dùng "khối lượng vật liệu" xuyên suốt bài (bỏ hẳn "khối lượng kết cấu").
2. **Tiêu chí "tìm được nghiệm Pareto tham chiếu"**: so khớp CHÍNH XÁC trên fitness, ngưỡng $10^{-6}$ (chống round-off, không phải ngưỡng gần đúng) — cố định trước khi chạy, không đổi theo kết quả. Xem đề cương Mục B.1.
3. **Đường cong hội tụ**: đã bổ sung `History.ArchiveX/ArchiveFitness/Hypervolume` lưu mỗi vòng lặp ở CẢ 2 connector (`run_mofda_wharf100dwt_parallel.m`, `run_emosfoa_wharf100dwt_parallel.m`), đã qua `checkcode` syntax check — 0 lỗi thật (chỉ cảnh báo cosmetic MSNU/NOCOMMA). Sẵn sàng phục vụ đường cong IGD/HV theo FE cho Mục 6.4.

---

## 0. Việc CẦN LÀM NGAY khi mở phiên mới (theo đúng thứ tự)

1. Người dùng đã khởi động lại máy PC — **kiểm tra sạch tiến trình** trước khi chạy:
   ```bash
   tasklist | grep -iE "sap2000|matlab"
   ```
   Nếu có sót (không nên có sau khi restart PC) thì `taskkill //F //IM SAP2000.exe` và `taskkill //F //IM MATLAB.exe`.
2. Xác nhận thư mục `D:\ResearchLab\02_Projects\02_Projects\MOFDA\Wharf100DWT\results\` **KHÔNG có** file `Wharf100DWT_BRUTEFORCE_FINAL.mat` hay `Wharf100DWT_BRUTEFORCE_CKPT.mat` còn sót từ lần chạy hỏng trước (nếu có, đã archive theo tên `..._SUSPECT_...`/`..._OUTDATED.mat.bak` — không đụng vào các file đó).
3. Chạy lệnh launch campaign vét cạn (mục 2 dưới đây) — **đây là việc đầu tiên và quan trọng nhất, ưu tiên launch ngay** vì mất ~19 giờ.
4. Trong lúc chờ vét cạn, có thể chuẩn bị thêm nhưng KHÔNG chạy song song bất kỳ campaign SAP2000 nào khác (tránh tranh chấp license/tài nguyên).

---

## 1. Bối cảnh & mục tiêu bài báo

**Tên bài báo (đã chốt):** TỐI ƯU ĐA MỤC TIÊU TIẾT DIỆN HỆ CỌC CẦU TÀU CONTAINER 100.000 DWT: ĐỐI SÁNH THUẬT TOÁN MOFDA VÀ MOSFOA

**Đề cương đầy đủ, đã chốt nội dung:** [`DE_CUONG_BAI_BAO_MOFDA_MOSFOA_SO_SANH_THUAT_TOAN.md`](DE_CUONG_BAI_BAO_MOFDA_MOSFOA_SO_SANH_THUAT_TOAN.md) — đọc file này để biết khung bài báo, cách diễn đạt khi viết (tránh tuyệt đối hoá), thứ tự trình bày Mục 6, quy ước tên MOSFOA/E-MOSFOA.

**Bản chất:** đối sánh 2 thuật toán (MOFDA, MOSFOA/E-MOSFOA) trên **cùng 1 bài toán tối ưu tiết diện cọc thực** (cầu tàu container 100.000 DWT, dự án Lạch Huyện), dùng **mặt Pareto vét cạn 4.080 tổ hợp làm chuẩn đối chiếu độc lập** cho cả 2 thuật toán. Không phải bài phát triển thuật toán — MOFDA và MOSFOA đều là thuật toán có sẵn (MOFDA: Truong et al. 2025; MOSFOA/E-MOSFOA: bản thảo cùng nhóm tác giả người dùng, đang chờ xuất bản).

**Bài báo trước (JMST V1-V5)** dùng 1 thuật toán (MOFDA), không gian nhỏ (243 tổ hợp), chưa có ràng buộc địa kỹ thuật thật. Bài mới kế thừa hạ tầng nhưng đổi hướng hoàn toàn sang đối sánh thuật toán, không gian mở rộng (4.080 tổ hợp).

---

## 2. Lệnh chạy vét cạn 4.080 tổ hợp (ƯU TIÊN SỐ 1 — chạy ngay, ~19 giờ)

```powershell
$matlab = "C:\Program Files\MATLAB\R2023b\bin\matlab.exe"
$logFile = "D:\ResearchLab\02_Projects\02_Projects\MOFDA\Wharf100DWT\results\campaign_bruteforce_4080_FINAL.log"
$cmd = "cd('D:\ResearchLab\02_Projects\02_Projects\MOFDA\Wharf100DWT'); run_bruteforce_wharf100dwt(8,100,6); exit;"
$argStr = "-r `"$cmd`" -logfile `"$logFile`""
Start-Process -FilePath $matlab -ArgumentList $argStr -WindowStyle Hidden
```

- Dùng `Start-Process -WindowStyle Hidden` (KHÔNG dùng cơ chế nền của Claude Code) — chạy độc lập, sống sót qua việc đóng phiên chat, theo đúng bài học đã đúc kết (`Cach ket noi_SAP2000_MATLAB_OPTIMIZATION.md` mục 5).
- `run_bruteforce_wharf100dwt(Num_work=8, ChunkSize=100, RestartEvery=6)` — có checkpoint/resume mỗi chunk (100 tổ hợp), atomic save, restart SAP2000 định kỳ có kèm `taskkill` an toàn (đã sửa lỗi rò rỉ tiến trình, xem mục 4.2).
- **Nếu bị ngắt giữa chừng** (mất điện, treo máy...): chạy lại **ĐÚNG lệnh trên** — script tự nhận checkpoint và resume, không mất tiến độ.
- Theo dõi tiến độ: `tail -f` file log, hoặc dùng Monitor/Bash `until grep -q "HOAN THANH brute-force\|LOI trong qua trinh" ...`.
- **ETA thực tế đã đo (2 lần, trước khi sửa bug $q_b$): ~18,6 giờ.** Sau khi sửa bug $q_b$ (mục 4.3), tốc độ không đổi đáng kể (bug chỉ ảnh hưởng GIÁ TRỊ tra bảng, không ảnh hưởng số lần gọi SAP2000).
- Khi xong: file kết quả tại `results/Wharf100DWT_BRUTEFORCE_FINAL.mat` — **đây sẽ là mặt Pareto tham chiếu CHÍNH THỨC duy nhất dùng cho bài báo.**

---

## 3. Lệnh chạy sau khi có mặt Pareto tham chiếu (MOFDA + MOSFOA, 30 lần/thuật toán)

Nhờ cơ chế cache (Bước A, xem mục 4.1), sau khi có `Wharf100DWT_BRUTEFORCE_FINAL.mat`, các lần chạy dưới đây sẽ RẤT NHANH (tỷ lệ trúng cache gần 100%, mỗi lần chạy chỉ mất vài phút thay vì hàng giờ).

**Ngân sách đánh giá công bằng đã xác lập:** MOFDA Np=50/maxiter=50 (FE=12.550) ↔ MOSFOA Np=50/Max_it=250 (FE=12.550) — khớp chính xác (xem đề cương mục 1). **N=30 lần chạy độc lập/thuật toán (tăng từ 20, chốt 08/09/2026)** — theo quy ước thống kê phổ biến cho bài báo đối sánh thuật toán (n≥30).

```matlab
% Trong MATLAB, sau khi co ket qua vet can:
cd('D:\ResearchLab\02_Projects\02_Projects\MOFDA\Wharf100DWT');
run_mofda_stats_wharf100dwt(30, 8, 50, 50);   % 30 lan doc lap MOFDA, Np=50 maxiter=50

% Chua co script tuong tu cho MOSFOA (E-MOSFOA) -- CAN VIET
% run_mosfoa_stats_wharf100dwt.m tuong tu, goi run_emosfoa_wharf100dwt_parallel(Num_work,50,250,RunTag)
% 30 lan voi RunTag='run01'..'run30', roi tinh GD/IGD/HV nhu ban MOFDA.
```

**⚠️ CHƯA VIẾT** `run_mosfoa_stats_wharf100dwt.m` (script chạy 30 lần độc lập cho MOSFOA + tính GD/IGD/HV) — cần viết trước khi thực hiện bước này, phỏng theo đúng `run_mofda_stats_wharf100dwt.m` đã có (mục 4.6). **Khi viết, PHẢI dùng đúng tiêu chí so khớp chính xác trên fitness, ngưỡng $10^{-6}$** (giống hệt logic đã có trong `run_mofda_stats_wharf100dwt.m`: `abs(RefFront - fRun(i,:)) < 1e-6`) — đây là tiêu chí đã CHỐT, không tự đổi ngưỡng hay dùng khoảng cách Euclid xấp xỉ (xem đề cương Mục B.1).

---

## 4. Trạng thái kỹ thuật chi tiết — các bug đã phát hiện & sửa (ĐỌC KỸ, tránh lặp lại)

### 4.1. Cơ chế cache (Bước A) — đã có, hoạt động đúng
`wharf100dwt_evaluate.m` tự động nạp `results/Wharf100DWT_BRUTEFORCE_FINAL.mat` (nếu tồn tại) làm cache, tra theo key `[CatIdx, D_thep, t_thep]` đã làm tròn. Vét cạn Ngày 1 phủ 100% lưới thiết kế → MOFDA/MOSFOA Ngày 2 hầu như không cần gọi lại SAP2000.

### 4.2. Rò rỉ tiến trình SAP2000 khi restart định kỳ (đã sửa 08/09/2026)
`SM.ApplicationExit()` (COM) KHÔNG đảm bảo giải phóng tiến trình OS chắc chắn. Lần chạy đầu tiên (18,6h) bị rò rỉ ~55 tiến trình SAP2000 sau nhiều lần restart định kỳ → làm SAI LỆCH kết quả (85,6% "bị phạt cứng" giả tạo do vượt giới hạn license, không phải bất khả thi kết cấu thật). **Đã sửa**: thêm `system('taskkill /F /IM SAP2000.exe')` làm lưới an toàn TRƯỚC MỖI LẦN mở lại SAP2000 trong `run_bruteforce_wharf100dwt.m` (không chỉ lúc mở đầu script). Đã xác nhận lại: sau khi sửa, restart không còn rò rỉ, tốc độ ổn định suốt campaign.

### 4.3. TCVN 10304: đổi từ 2014 sang 2025 + sửa lỗi bảng $q_b$ (đã sửa 08/09/2026)
- Ban đầu code dùng TCVN 10304:2014 (đọc trực tiếp PDF chuẩn từ phanvu.vn). Theo yêu cầu người dùng, đã đổi sang **TCVN 10304:2025** (file `TCVN 10304_2025.pdf` người dùng cung cấp, 124 trang, VSQI). Bảng $q_b$/$f_i$ (Bảng 2/3) **số liệu giống hệt** 2014, chỉ mở rộng thêm độ sâu 40m. Công thức đổi số nhưng cùng dạng (công thức (9), (2) thay cho (10),(2) của 2014). Không còn quy tắc "$q_b$=20MPa cố định cho cọc đóng/ép tựa đá" như 2014 — phải dùng công thức Rm=Rc,n·Ks/γg (giống cọc khoan nhồi).
- **Phát hiện lỗi lệch cột trong bảng $q_b$** (các hàng độ sâu 20-40m bị đọc lệch 1 cột khi tự đọc ảnh scan, mất giá trị thật ở IL=0,0). Đã sửa bằng cách đối chiếu chéo với bảng đã số hoá sẵn (`Table_Fi_tip.mat`) tìm thấy trong chính code MOSFOA thật của người dùng (`MOFDA/MOSFOA/_KHONG_CAN_CHO_BAI_MOFDA_vs_EMOSFOA/Run_MOMSFOA_official/MOSFOA_BD/Pile_TCVN10304_2014/`). Bảng $f_i$ đối chiếu khớp 100%, không lỗi.
- **⚠️ Campaign trước đó (18,6h, hoàn thành 08/09 sáng) dùng bảng $q_b$ SAI — kết quả KHÔNG dùng được, đã archive `..._SUSPECT_...`/`..._OUTDATED...`.** Phải chạy lại (mục 2).

### 4.4. Thiếu ràng buộc chống nhổ cọc (kéo/uplift) — phát hiện & sửa 08/09/2026
Code cũ dùng `abs(luc doc)`, không phân biệt nén/kéo, chỉ kiểm tra theo ngưỡng NÉN. Kiểm tra THẬT qua SAP2000 (mô hình CatIdx=3, D_thep=1,10, t_thep=0,020) xác nhận: **18/360 cọc thép bị KÉO** (tới ~31,3T) dưới tổ hợp bao "BAO KT"; cọc BTCT luôn nén (792/792). Đã bổ sung:
- Công thức (11)/Điều 7.2.2.4 (sức chịu tải kéo — chỉ ma sát thân, không có mũi, $\gamma_c=0{,}8$ vì ngàm ≥4m).
- $\gamma_k$ riêng cho kéo theo Điều 7.1.6.1 (phụ thuộc SỐ LƯỢNG CỌC trong móng — 192 cọc/phân đoạn ≥21 cọc → $\gamma_k=1{,}4$, trùng số với nén nhưng KHÁC cơ sở, đã ghi rõ trong code).
- `wharf100dwt_geotech_capacity_tcvn10304.m` đổi chữ ký hàm: `(D, t, maxCompression, maxTension, pileType, cfg)` → trả thêm `Rt_d`. `wharf100dwt_evaluate.m` đã cập nhật gọi đúng chữ ký mới, tách nén/kéo theo đúng dấu SAP2000 (P>0=kéo, P<0=nén — đã xác nhận bằng kiểm tra thật).
- **Đã kiểm tra qua smoke test SAP2000 thật, PASS, không lỗi.**

### 4.5. Mở rộng thiết kế (đã làm trước phiên này, không đổi)
- Catalogue BTCT: 3→5 dòng (D600-D1000, dữ liệu thật từ `Cataloge coc ly tam.md`) — `wharf100dwt_catalogue_btct.m`.
- Bounds: $x_1\in\{1..5\}$, $D_{thép}\in[0{,}80;1{,}30]$ bước 10mm, $t_{thép}\in[0{,}010;0{,}025]$ bước 1mm → **4.080 tổ hợp** — `wharf100dwt_config.m`.
- Lý do mở rộng (viết trong bài, KHÔNG khung theo kiểu "làm khó thuật toán"): không gian phản ánh phương án kết cấu thực tế, đồng thời đủ lớn để phân biệt năng lực 2 thuật toán (243 tổ hợp bản cũ quá nhỏ).

### 4.6. Kết nối MOFDA và MOSFOA (E-MOSFOA) với SAP2000 — đã viết, đã smoke test
- `run_mofda_wharf100dwt_parallel.m` — đã có từ trước, hỗ trợ `RunTag` (chạy nhiều lần độc lập không ghi đè). **Bổ sung 08/09/2026 (cuối phiên)**: `History.ArchiveX`, `History.ArchiveFitness` (snapshot toàn bộ archive mỗi vòng lặp, từ Gen#0), `History.Hypervolume` (tính từ `REP.pos_fit'`, tham chiếu = max mục tiêu ×1,1) — phục vụ đường cong hội tụ IGD/HV theo FE ở Mục 6.4 bài báo.
- `run_emosfoa_wharf100dwt_parallel.m` — **MỚI viết 08/09/2026**, lấy nguyên cơ chế thật từ code MOSFOA của người dùng (`EMOSFOA_BD_v3.m`: cosine phase-control $GP_t=GP_0\cdot0{,}5(1+\cos(\pi T/Max\_it))$, "energy-step" cho nVar≤5 — đúng trường hợp bài toán này (nVar=3), "preying"+"regeneration" khai thác, Gaussian refinement 20% vòng lặp cuối). Đã CHỦ ĐỘNG bỏ bước "snap về lưới catalog" của code gốc để công bằng với MOFDA (cả 2 đều tìm kiếm liên tục, làm tròn ở bước đánh giá trong `wharf100dwt_evaluate.m`). Đã thêm checkpoint/resume + atomic save (bản gốc không có). Đã smoke test SAP2000 thật — PASS. **Bổ sung 08/09/2026 (cuối phiên)**: cùng 3 trường `History.ArchiveX/ArchiveFitness/Hypervolume` như MOFDA, cùng thời điểm lưu (mỗi vòng lặp) — bảo đảm đối sánh đường cong hội tụ công bằng giữa 2 thuật toán.
- **Đã chạy `checkcode` (MATLAB Code Analyzer) trên cả 2 file + `wharf100dwt_evaluate.m` + `wharf100dwt_geotech_capacity_tcvn10304.m` sau khi sửa — 0 lỗi thật, chỉ có cảnh báo cosmetic (MSNU: comment `%#ok` cũ dư thừa; NOCOMMA: dấu phẩy thừa dòng L251/`run_mofda...`, L230/`run_emosfoa...`) — không cần sửa, không ảnh hưởng chạy.**
- `hypervolume.m`, `epsilon_matlab.m`, `spacing_to_extent.m`, `metric_of_maximum_spread.m` đã copy từ code MOSFOA sang `MOFDA/MOFDA/Functions/` (dùng chung với các hàm archive/grid đã có sẵn ở đó: `checkDomination.m`, `updateGrid.m`, `updateRepository.m`, `deleteFromRepository.m`, `selectLeader.m`, `dominates.m`).
- **CHƯA VIẾT**: `run_mosfoa_stats_wharf100dwt.m` (bản tương ứng `run_mofda_stats_wharf100dwt.m` cho MOSFOA — chạy N lần độc lập + tính GD/IGD/HV/Wilcoxon).

### 4.7. Dữ liệu tải trọng thật (mục 2.3 bài báo)
Đã trích từ `Cau tau Lach Huyen/1.Tai trong 100.000DWT..xls` (Excel COM, vì xlrd lỗi parse): q=4,0 T/m²; cần trục 76,73 T/bánh xe (governing); lực va Nx=187T/Ny=37,4T; lực neo (đầy tải) Sq=54,11T/Sn=93,72T/Sv=39,39T; dòng chảy U=1,55m/s. Nháp câu văn đã có trong `section_2_3_load_table_draft.md` (thư mục scratchpad phiên trước — **CẦN chép lại vào project nếu còn cần**, vì thư mục scratchpad theo phiên, có thể đã mất). Cần đối chiếu lại với tổ hợp "BAO KT" trước khi khẳng định đây là số liệu FEM dùng trực tiếp.

---

## 5. Bản đồ file quan trọng

| File | Vai trò |
|---|---|
| `Wharf100DWT/wharf100dwt_config.m` | Cấu hình bài toán, bounds (đã mở rộng) |
| `Wharf100DWT/wharf100dwt_catalogue_btct.m` | Catalogue BTCT 5 dòng |
| `Wharf100DWT/wharf100dwt_evaluate.m` | Hàm đánh giá — ĐÃ SỬA (nén/kéo tách riêng, gọi geotech signature mới) |
| `Wharf100DWT/wharf100dwt_geotech_capacity_tcvn10304.m` | Ràng buộc địa kỹ thuật TCVN 10304:2025 — ĐÃ SỬA (bug $q_b$, thêm uplift) |
| `Wharf100DWT/run_bruteforce_wharf100dwt.m` | Vét cạn — checkpoint/resume, chống rò rỉ SAP2000 |
| `Wharf100DWT/run_mofda_wharf100dwt_parallel.m` | MOFDA + SAP2000, hỗ trợ RunTag |
| `Wharf100DWT/run_emosfoa_wharf100dwt_parallel.m` | **MỚI** — MOSFOA(E-MOSFOA) + SAP2000, hỗ trợ RunTag |
| `Wharf100DWT/run_mofda_stats_wharf100dwt.m` | Chạy N lần MOFDA + GD/IGD |
| `MOFDA/MOFDA/Functions/` | Thư viện chung (archive/grid + GD/IGD/HV/spacing/spread) |
| `DE_CUONG_BAI_BAO_MOFDA_MOSFOA_SO_SANH_THUAT_TOAN.md` | Đề cương bài báo — ĐÃ CHỐT |
| `MOSFOA/_KHONG_DUNG_MOSFOA_Jameel_NSGAII/` | (trong dự án MOSFOA gốc) MOSFOA-Jameel đã loại, không dùng |
| `MOFDA/MOSFOA/_KHONG_CAN_CHO_BAI_MOFDA_vs_EMOSFOA/` | Code/dữ liệu bến Hải Linh (B-MOSFOA, BD/MD/MPJ...) — KHÔNG PHẢI RÁC, đọc README trong đó trước khi xoá |

---

## 6. Việc còn lại theo thứ tự (sau khi vét cạn xong)

1. ✅ Vét cạn 4.080 tổ hợp — CẦN CHẠY LẠI với bảng $q_b$ đã sửa đúng (mục 2) — chưa launch tại thời điểm bàn giao này.
2. ✅ Bổ sung lưu đường cong hội tụ ở cả 2 thuật toán — đã xong, đã qua syntax check.
3. Viết `run_mosfoa_stats_wharf100dwt.m` (phỏng theo `run_mofda_stats_wharf100dwt.m`, dùng đúng tiêu chí so khớp $10^{-6}$ đã chốt).
4. Chạy MOFDA 30 lần + MOSFOA 30 lần (mục 3) — nhanh nhờ cache.
5. Tính IGD/HV/tỷ lệ trùng khớp (tiêu chí đã chốt, Mục B.1 đề cương)/Wilcoxon (ưu tiên theo đề cương mục D.5.3 — GD chỉ giữ nếu bổ sung thông tin).
6. Dựng đường cong IGD/HV theo FE từ `History.ArchiveFitness`/`History.Hypervolume` cho Mục 6.4.
7. Kiểm chứng lại hiện tượng "dồn biên" từ mặt Pareto vét cạn CHÍNH THỨC (không giả định trước).
8. Viết bài theo khung đề cương Mục D — nhớ tách nội dung hạ tầng/code (không đưa vào bài) khỏi nội dung khoa học; dùng thống nhất thuật ngữ "khối lượng vật liệu".

## 7. Quyết định/giả thiết đã chốt, cần biết khi viết bài (không tự ý đổi)

- Chiều dài ngàm cọc GIỮ CỐ ĐỊNH khi D thay đổi (BTCT L=29m, thép L=30m).
- Mũi BTCT trong Lớp 10 (đất dính, IL=-0,13→cap 0,0); mũi thép trong Lớp 11 (đá, công thức cọc chống).
- Cọc bịt kín mũi (Ab = diện tích đặc).
- Không xét hiệu ứng nhóm cọc (giới hạn nghiên cứu, cần nêu ở Mục 6.5).
- $\gamma_k=1{,}4$ (nén, theo phương pháp bảng tra), $\gamma_n=1{,}15$ (cấp công trình C2 — GIẢ THIẾT, cần xác nhận lại nếu có hồ sơ phân cấp chính thức), $K_s=0{,}32$ cho Lớp 11 (GIẢ THIẾT vì không có RQD thật, khớp mô tả định tính "nứt nẻ mạnh").
- Tên bài, tên thuật toán: dùng "MOSFOA" ở tiêu đề/tóm tắt, "E-MOSFOA" khi mô tả kỹ thuật cụ thể (Mục 4.2). B-MOSFOA chỉ nhắc rất ngắn ở Mở đầu, không đối sánh.
- Thuật ngữ hàm mục tiêu: CHỈ dùng "khối lượng vật liệu" (không dùng "khối lượng kết cấu" hay tên khác) — xuyên suốt Tóm tắt, Mục 3.2, hình/bảng, Mục 6, Kết luận.
- Tiêu chí "tìm được nghiệm Pareto tham chiếu": so khớp CHÍNH XÁC trên fitness, ngưỡng $10^{-6}$ (chống round-off) — đã CHỐT trước khi chạy, không đổi theo kết quả (xem đề cương Mục B.1).
