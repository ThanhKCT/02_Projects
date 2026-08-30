# Wharf100DWT — Mã MATLAB tối ưu tiết diện cọc cầu tàu 100.000 DWT (MOFDA)

Đi kèm [DE_CUONG_BAI_BAO_MOFDA_CAU_TAU_100000DWT.md](../DE_CUONG_BAI_BAO_MOFDA_CAU_TAU_100000DWT.md) — mọi tham số/giả thiết trong code này bám theo các quyết định đã chốt ở đó. Sửa cả hai nơi nếu đổi bất kỳ con số nào.

## ⚠️ ĐÃ CHỐT LẠI (28/08/2026): biến thiết kế còn 3 chiều, không phải 4

`x = [CatIdx_BTCT, D_thep, t_thep]` — **CatIdx_BTCT** là chỉ số dòng trong catalogue AMACCAO thật (`../Cataloge coc ly tam.md`, xem `wharf100dwt_catalogue_btct.m`): 1=D700(t110mm), 2=D800(t120mm), 3=D900(t130mm), dùng Class A. D và t của BTCT **không còn là 2 biến độc lập** — mỗi D catalogue đi kèm đúng 1 t cố định. Cọc thép (D_thep, t_thep) vẫn 2 biến, nhưng nay rời rạc hoá theo lưới cố định (D bước 25mm, t bước 1mm) thay vì liên tục làm tròn mm. Đã chạy thử thật lại toàn bộ pipeline với cấu trúc mới — thành công (xem `results/Wharf100DWT_MOFDA_FULL_Np8_Maxit1_FINAL.mat`, 28/08/2026).

## Thứ tự chạy (BẮT BUỘC theo đúng thứ tự)

> ⚠️ **BẮT BUỘC chạy MATLAB ở chế độ desktop đầy đủ (`-r`), TUYỆT ĐỐI KHÔNG dùng `-batch`.** Đã xác nhận thật trên máy này: chạy qua `matlab -batch "..."` làm **crash cứng, không ổn định** (vị trí crash đổi mỗi lần chạy) ngay trong các lệnh mở SAP2000 qua `SM.*` (`SM.App`, `SM.ApplicationStart`...) — nguyên nhân là `-batch` không chạy Windows message pump mà COM/ActiveX automation (kiểu SAP2000 OAPI) cần để hoạt động ổn định. Chạy qua `-r` (desktop MATLAB đầy đủ) đã xác nhận chạy trót lọt không lỗi. Xem mục "LỖI ĐÃ GẶP" bên dưới.

1. **`wharf100dwt_fix_comb62.m`** — chạy **1 lần duy nhất**, trước tiên. Sửa lỗi COMB6.2 trùng COMB6.1 trong hồ sơ gốc (xem đề cương mục 5.4.1). Mở SAP2000 có giao diện để bạn tự kiểm tra rồi tự bấm Save. **CHƯA được chạy thử thật** — kiểm tra kỹ trong SAP2000 GUI sau khi chạy.
2. **`run_mofda_wharf100dwt('smoke')`** — Np=6, maxiter=1. Chỉ để xác nhận pipeline (MATLAB↔SAP2000 OAPI↔MOFDA) chạy hết vòng không lỗi. **Không dùng kết quả smoke để phân tích/công bố.** **✅ ĐÃ CHẠY THỬ THẬT THÀNH CÔNG** (27/08/2026, chế độ `-r`) — xem mục "Kết quả chạy thử thật" bên dưới.
3. **`run_mofda_wharf100dwt('pilot')`** — Np=15, maxiter=15. Đo thời gian thật/vòng lặp, dùng để: (a) hiệu chỉnh `cfg.penalty.C_init` (mục "Hiệu chỉnh hệ số phạt C" bên dưới), (b) ước lượng thời gian cho campaign 'full' trước khi cam kết chạy nhiều giờ. **⚠️ Ước lượng sơ bộ từ smoke test: ~90 giây/lần gọi SAP2000 — pilot 15×(15×5+1)≈1.140 lần gọi có thể mất >24 giờ ở quy mô hiện tại. Cân nhắc giảm Np/maxiter cho pilot đầu tiên hoặc chạy song song (spmd) trước khi cam kết.**
4. **`run_mofda_wharf100dwt('full')`** — chỉ chạy sau khi (1)-(3) đã xong và đạt yêu cầu.

Chạy trong Command Window của MATLAB (khuyến nghị, đơn giản nhất):
```matlab
cd('D:\ResearchLab\02_Projects\02_Projects\MOFDA\Wharf100DWT')
wharf100dwt_fix_comb62();          % bước 1 — 1 lần duy nhất
run_mofda_wharf100dwt('smoke');    % bước 2
run_mofda_wharf100dwt('pilot');    % bước 3
```

Hoặc chạy từ dòng lệnh ngoài (PowerShell) — chú ý dùng `-r` (KHÔNG `-batch`) và tự quote nguyên chuỗi lệnh (mục 6.1, [Cach ket noi_SAP2000_MATLAB_OPTIMIZATION.md](../Cach ket noi_SAP2000_MATLAB_OPTIMIZATION.md)):
```powershell
$matlab = "C:\Program Files\MATLAB\R2023b\bin\matlab.exe"
$cmd = "addpath('C:\Program Files\MATLAB'); cd('D:\ResearchLab\02_Projects\02_Projects\MOFDA\Wharf100DWT'); run_mofda_wharf100dwt('smoke'); exit;"
$argStr = "-r `"$cmd`""
Start-Process -FilePath $matlab -ArgumentList $argStr -Wait
```

## Cấu trúc file

| File | Vai trò |
|---|---|
| `wharf100dwt_config.m` | Toàn bộ tham số bài toán (biến, giới hạn, vật liệu, penalty) — nguồn chân lý duy nhất |
| `Functions/open_Sap2000.m` | Mở SAP2000 headless (SM.* wrapper), mở model, chọn output combo |
| `wharf100dwt_evaluate.m` | Hàm mục tiêu: X → [fit, diagnostic] — gọi SAP2000 OAPI, tính f1/f2 + penalty |
| `wharf100dwt_material_tonnage.m` | f1 = khối lượng vật lý cọc (tấn) |
| `wharf100dwt_pile_capacity_btct.m` | Mcr/Mu/Pmax cọc BTCT theo (D,t), quy đổi tỷ lệ từ neo D800‑540 |
| `wharf100dwt_geotech_capacity_stub.m` | **STUB** ràng buộc địa kỹ thuật TCVN 10304 — xem cảnh báo bên dưới |
| `wharf100dwt_fix_comb62.m` | Script sửa COMB6.2 — chạy 1 lần trước campaign đầu tiên |
| `run_mofda_wharf100dwt.m` | Điểm vào chính, vòng lặp MOFDA (dùng lại `MOFDA/MOFDA/Functions` gốc) |
| `pile_length_table.csv` | Chiều dài chế tạo TỪNG CỌC (192 dòng) suy ra từ `fem_length_m` thật — xem điểm #2 dưới đây |
| `results/` | File `.mat` checkpoint/kết quả mỗi lần chạy (đặt tên theo runMode + timestamp) |

## ⚠️ Các giả thiết/đơn giản hoá CẦN xác nhận trước khi dùng kết quả để công bố

1. ~~**γ bê tông M800 = 2,5 T/m³**~~ **ĐÃ XỬ LÝ.** Đã kiểm tra trực tiếp bảng vật liệu SAP (`MATERIAL PROPERTIES 02`): `Be tong M800` và `Coc thep` đều có `UnitWeight=0` trong model gốc (tự trọng cọc không được tính vào tải BT — có thể chủ đích vì cọc nằm trong đất/nước). Vì model không dùng được, chuyển sang giá trị kỹ thuật chuẩn: γ_bê tông = 2,5 T/m³ — khối lượng riêng BTCT thường không phụ thuộc đáng kể vào mác (M400/M800 cùng là bê tông thường, chỉ khác hàm lượng xi măng), khớp đúng giá trị M400 trong CHÍNH model này (TCVN 2737:1995). γ_thép = 7,85 T/m³ khớp đúng `UnitWeight≈7,849` của A992Fy50/A615Gr60/A416Gr270 trong CHÍNH model. Cả 2 coi là đủ căn cứ, không còn là giả thiết yếu.
2. **Chiều dài chế tạo cọc cho f1 — BTCT đã xác nhận biên thật bằng bản vẽ; thép vẫn là giả thiết.**
   - `Bang toa do coc.xls` đã kiểm tra: chỉ có toạ độ mặt bằng (x,y), không có chiều dài — không dùng được.
   - **BTCT — đã xác nhận bằng bản vẽ chế tạo thật `01..09. Coc DUL.dxf`** (đọc bằng `ezdxf`): có đúng **7 chiều dài chế tạo tiêu chuẩn thật** cho cọc D800‑540: **28, 29, 30, 31, 32, 34, 37 m** (không liên tục, không có 33/35/36m). Bản vẽ này còn xác nhận chéo khớp chính xác 100% với `cfg.btctAnchor` đang dùng: Mcr=67,40 T.m, Mu=134,80 T.m, Pmax=658 T. **Biên trên thật là 37m, không phải 34m như giả thiết trước** — đã sửa lại.
   - **Thép D1016 — CHƯA có bản vẽ chế tạo riêng** (bản vẽ hiện có chỉ là cọc BTCT DƯL) — dải [28,32]m vẫn là giả thiết chưa xác nhận.
   - `pile_length_table.csv` suy ra chiều dài chế tạo từng cọc bằng quy đổi tuyến tính (affine) từ `fem_length_m` thật (không snap về đúng 7 giá trị rời rạc — thử snap cho kết quả dồn cục bất thường tại 34m do khoảng cách không đều giữa các mốc, kém tin cậy hơn nội suy liên tục). Tổng chiều dài dùng cho f1: **BTCT = 4.243,0 m** (132 cọc, đã cập nhật theo biên 37m), **thép = 1.806,8 m** (60 cọc, chưa đổi vì chưa có dữ liệu mới).
3. **Sức kháng BTCT (Mcr/Mu/Pmax) = quy đổi TỶ LỆ diện tích/mô men kháng uốn** từ tiết diện gốc D800‑540, KHÔNG PHẢI kiểm toán TCVN 5574:2018 chi tiết theo cốt thép DƯL thực tế ở từng (D,t). Đây là tiền xử lý kế thừa đúng cách làm của mã trước đó (xem ngữ cảnh dự án). *(Bản thân giá trị neo Mcr=67,40 T.m / Mu=134,80 T.m / Pmax=658 T đã được xác nhận chéo khớp chính xác 100% với bản vẽ chế tạo `01..09. Coc DUL.dxf` — điểm chưa xác nhận chỉ còn ở CÁCH QUY ĐỔI sang D,t khác, không phải ở bản thân 3 con số neo.)*
4. **γ_M thép = 1,05** (hệ số an toàn vật liệu) — giá trị giả định, cần đối chiếu TCVN 5575:2024.
5. **Ràng buộc địa kỹ thuật TCVN 10304 = STUB, LUÔN TRẢ VỀ "không vi phạm"** (`geotechChecked=false` trong diagnostic) — thiếu dữ liệu chỉ số sệt IL đầy đủ 12 lớp đất. Có module tái dùng được tại `Tap chi XD_SFOA/code/Run_MOMSFOA_official/MOSFOA_MPJ/Pile_TCVN10304_2014/pile_bearing_capacity.m` — xem chi tiết việc cần làm trong `wharf100dwt_geotech_capacity_stub.m`. **Không được báo cáo "đã kiểm tra đủ theo TCVN 10304" trong bài cho đến khi stub này được thay bằng tính toán thật.**
6. **Chiều cao bến H=21,5m** dùng cho giới hạn chuyển vị 71,7mm — giả thiết H = đỉnh bến − đáy bến hoàn thiện, cần xác nhận lại định nghĩa chính thức trong TCVN 11820‑5 (xem đề cương mục 18).
7. **COMB6.2** — xem mục "Thứ tự chạy" ở trên, bắt buộc chạy `wharf100dwt_fix_comb62.m` trước.

## ✅ Kết quả chạy thử thật (smoke test, 27/08/2026)

Chạy `run_mofda_wharf100dwt('smoke')` thật (Np=6, maxiter=1, chế độ `-r`) — **thành công, không lỗi**, xác nhận toàn bộ chuỗi MATLAB↔SAP2000 OAPI↔MOFDA hoạt động đúng. File kết quả: `results/Wharf100DWT_MOFDA_SMOKE_20260827_221206_Np6_Maxit1.mat`.

Kiểm tra số liệu Gen#0 (4 cá thể không bị trội trong repository ban đầu):
- **f1 (khối lượng, tấn): 3.561 – 4.165** — khớp đúng bậc độ lớn tính tay kiểm chứng độc lập (~3.448 tấn tại tiết diện gốc D800‑540/D1016‑T16, dùng đúng `sumLfab_BTCT_m`/`sumLfab_Thep_m` đã nạp).
- **f2 (chuyển vị ngang, m): 0,0127 – 0,0136** (12,7–13,6 mm) — nhỏ hơn nhiều giới hạn 71,7mm (`dU_allow_m` nạp đúng `0,07166667`), không cá thể nào bị phạt do vượt chuyển vị.
- Không cá thể nào rơi vào `HARD_PENALTY=1e6` — nghĩa là mọi lần gọi `SM.PropFrame.SetPipe` → `SM.Analyze.RunAnalysis` → trích xuất `"BAO KT"` đều thành công thật trên SAP2000.
- `cfg` ghi vào file khớp đúng mọi giá trị đã chốt: `comboEnvelope="BAO KT"`, `btctName="COCBTCT"`, `thepName="COCTHEP"`, `gammaConcrete=2,5`, `gammaSteel=7,85`.

**Thời gian đo được (quan trọng cho việc lập kế hoạch pilot/full):** ~90 giây/lần gọi SAP2000 (6 lần đánh giá Gen#0 mất ~9 phút) trên máy này, chạy đơn luồng (1 instance SAP2000, không song song). Chậm hơn đáng kể so với ước lượng chung chung trong [Cach ket noi_SAP2000_MATLAB_OPTIMIZATION.md](../Cach ket noi_SAP2000_MATLAB_OPTIMIZATION.md) (vài giây/lần cho mô hình tương tự) — có thể do mô hình 4.913 nút/4.488 tấm lớn hơn, hoặc do chạy dưới desktop MATLAB (`-r`) có overhead cao hơn `-batch`. **Đúng theo khuyến nghị của tài liệu đó: không ngoại suy, phải tự đo pilot thật ở đúng Npop dự kiến trước khi cam kết campaign chính.**

## LỖI ĐÃ GẶP — kiểm tra ngay các điều này nếu thấy hiện tượng tương tự (bổ sung riêng cho Wharf100DWT)

### W.1. `readtable(...,'TextType','string')` làm SẬP TOÀN BỘ tiến trình MATLAB (không phải lỗi bắt được)
**Hiện tượng:** gọi `run_mofda_wharf100dwt(...)` (hoặc bất kỳ script nào gọi `wharf100dwt_config()`), MATLAB thoát im lặng, không có thông báo lỗi nào (kể cả khi bọc try/catch quanh toàn bộ), không ghi vào Windows Event Log (không phải crash cứng kiểu access violation được hệ điều hành ghi nhận).
**Nguyên nhân:** đã cô lập bằng chẩn đoán từng bước (ghi file `fopen/fprintf/fclose` ngay sau mỗi dòng để đảm bảo flush trước khi có thể crash) — xác nhận chính xác dòng `T = readtable(pileLenCsv, 'TextType', 'string');` làm crash, trên bản MATLAB R2023b cài trên máy này, với đúng file `pile_length_table.csv` đi kèm. Không rõ nguyên nhân gốc (có thể lỗi/không tương thích trong text-import engine của bản MATLAB này).
**Cách sửa (đã áp dụng trong `wharf100dwt_config.m`):** thay `readtable` bằng vòng lặp thủ công `fopen`/`fgetl`/`strsplit`/`str2double` — đã chạy thử thật, cho đúng kết quả (`nBTCT=132 sumBTCT=4243,042 nThep=60 sumThep=1806,835`).
**Bài học tổng quát:** nếu thấy MATLAB "biến mất" hoàn toàn không dấu vết khi đọc CSV/Excel, nghi ngay `readtable`/import engine trước khi nghi logic code — thử thay bằng I/O cấp thấp (`fopen`/`fgetl`/`textscan`).

### W.2. `matlab -batch` làm SAP2000 OAPI (qua thư viện `SM`) crash không ổn định — vị trí crash đổi mỗi lần chạy
**Hiện tượng:** gọi các lệnh `SM.App`/`SM.Ver`/`SM.Helper.CreateObject`/`SM.ApplicationStart` qua `matlab -batch "..."`, MATLAB thoát đột ngột, không lỗi, không log — nhưng **vị trí dừng KHÁC NHAU giữa các lần chạy giống hệt nhau** (có lần dừng ở `ApplicationStart`, có lần dừng sớm hơn ở `CreateObject`, dù code và input hoàn toàn giống nhau).
**Nguyên nhân:** `-batch` không chạy Windows message pump — các đối tượng COM/ActiveX kiểu STA (như SAP2000 OAPI) cần message pump để hoạt động ổn định; thiếu nó gây lỗi timing không tất định (race condition), không phải lỗi logic cố định.
**Cách sửa (đã kiểm chứng thật):** chạy MATLAB ở chế độ desktop đầy đủ bằng cờ `-r` (KHÔNG `-nodesktop`, KHÔNG `-batch`) — đã chạy trót lọt 100% các bước `SM.App → SM.Ver → CreateObject → ApplicationStart → SapModel → OpenFile` nhiều lần liên tiếp không lỗi.
**Bài học tổng quát:** với bất kỳ script MATLAB nào tự động hoá SAP2000/Excel/Word qua COM (`SM.*`, `actxserver`, `ActiveX`...), **luôn chạy bằng `-r`, không dùng `-batch`** — dù `-batch` là cách "hiện đại" được khuyến nghị chung cho MATLAB không tương tác, nó không phù hợp cho các tác vụ dùng COM automation.

## Hiệu chỉnh hệ số phạt C (`cfg.penalty.C_init`, hiện = 10)

Sau khi chạy `'pilot'`, mở file kết quả trong `results/`, kiểm tra:
- Nếu cá thể vi phạm ràng buộc (cột `g_total` trong `diagnostic` hoặc suy ra từ `penMult>1` trong log) vẫn lọt vào Repository cuối cùng (Pareto front) → **tăng C** (ví dụ gấp đôi) và chạy lại pilot.
- Nếu Repository cuối cùng có quá ít cá thể / Pareto front bị "biến dạng" bất thường dù không cá thể nào vi phạm → **giảm C**.
- Mục tiêu: mọi cá thể còn trong Repository cuối cùng phải có `g_total = 0` (khả thi hoàn toàn) — đây là cách kiểm tra nhanh C đã đủ lớn hay chưa.

## Chưa làm / việc tiếp theo

- [ ] Chạy `wharf100dwt_fix_comb62.m` và xác nhận trực quan trong SAP2000 GUI (chưa chạy — script này mở GUI, cần bạn tự bấm Save).
- [x] ~~Chạy `run_mofda_wharf100dwt('smoke')`~~ **ĐÃ CHẠY THỬ THẬT THÀNH CÔNG** (27/08/2026) — xem mục "Kết quả chạy thử thật" ở trên. Tìm và sửa 2 lỗi nghiêm trọng trong lúc chạy thử (W.1 `readtable` crash, W.2 `-batch` vs `-r`).
- [ ] Xử lý các điểm giả thiết còn lại theo thứ tự ưu tiên (đặc biệt #5 — geotech stub — ảnh hưởng trực tiếp đến độ tin cậy số liệu công bố; #2 đã cải thiện nhưng vẫn là xấp xỉ affine, chưa phải bảng thật).
- [ ] Chạy pilot, hiệu chỉnh C, ước lượng thời gian campaign 'full' — **lưu ý thời gian đo được ở smoke (~90s/lần gọi) khiến pilot mặc định (Np=15, maxiter=15) có thể mất >24 giờ chạy đơn luồng — cân nhắc giảm quy mô pilot đầu tiên hoặc triển khai song song (spmd, xem Cach ket noi_SAP2000_MATLAB_OPTIMIZATION.md) trước.**
