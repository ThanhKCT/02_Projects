# BÀN GIAO — Dự án "Kè sau cầu" SFOA+SAP2000 (2026-08-29)

Tài liệu này để một phiên Claude Code MỚI (trên máy PC mới) đọc và tiếp tục công việc mà không cần lại toàn bộ lịch sử chat. Viết cho chính Claude đọc trước, sau đó là người dùng.

## 0. Đọc bắt buộc, ĐÚNG THỨ TỰ, trước khi động vào bất kỳ code nào

1. `KINH_NGHIEM_TU_DU_AN_KE_SFOA.md` (cùng thư mục gốc dự án)
2. `Cach ket noi_SAP2000_MATLAB_OPTIMIZATION.md` (cùng thư mục gốc dự án)

Hai file này chứa toàn bộ bài học vận hành (mục 6.x) đã được áp dụng trong suốt dự án — đừng đoán lại từ đầu.

## 1. Mục tiêu dự án

Tối ưu SFOA (Starfish Optimization Algorithm) khối lượng bê tông **kết cấu tường/bản đáy kè** (KHÔNG phải cọc — cọc giữ nguyên, dù tên nhiệm vụ ban đầu ghi "thể tích bê tông cọc"), tích hợp SAP2000-in-the-loop qua MATLAB COM (SM Toolbox).

**6 biến thiết kế** (chiều dày shell, rời rạc hoá bội số 0,01m TRƯỚC khi ghi vào SAP2000 và trước khi tính khối lượng): `TUONGC30, TUONGM30, TUONGM43, TUONGM78` (4 vùng tường) + `DAY130, DAY60` (2 vùng bản đáy). Cọc và `GIOCHANXE` giữ cố định.

**Mục tiêu**: V_bêtông = Σ(Diện_tích_i × chiều_dày_i), tính trực tiếp trong MATLAB (diện tích đã precompute 1 lần, không đổi).

**5 ràng buộc** (đọc từ SAP2000 mỗi lần đánh giá) — chi tiết đầy đủ + nguồn TCVN trong memory `ke-sau-cau-sfoa-spec` (xem mục 7 bên dưới về cách phiên mới truy cập memory này):
1. Sức chịu tải cọc — **TCVN 10304:2025** (không phải 2014!). Sức chịu tải đã hiệu chỉnh: C400=78,76T, C500=112,44T.
2. Chuyển vị ngang — TCVN 11820-5:2021 Bảng 12, chỉ dùng `|U1|` (phương áp lực đất), tại các joint đỉnh tường (nhóm `WallTop`). Giới hạn = min(H/300,100mm), H=4,5m → 15mm.
3. Cắt — TCVN 4116:2023 Điều 8.2.12, loại trừ đỉnh nhiễu FE giả gần cọc (DAY zones) và gần chân tường (TUONG zones), CHỈ loại trừ cắt, KHÔNG loại trừ mô men (mô men chân công-xôn là cơ học thật).
4. Bề rộng vết nứt — TCVN 4116:2023 Điều 9.2, giới hạn **0,2mm** (Điều 9.1.1: cấu kiện nằm vùng mực nước thay đổi) — **MỚI cập nhật 2026-08-29**, thay cho 0,08/0,10mm cũ (TCVN 4116-85).
5. Chọc thủng — TCVN 5574:2018, theo từng cọc, dùng h0 của đúng vùng DAY cọc đó nằm dưới.

## 2. Trạng thái: ĐÃ XONG và ĐÃ VERIFY (không cần làm lại)

- Mô hình SAP2000 gốc đã được **user tự validate trong GUI** trước khi viết code tự động — `Sap\ke pd 10.sdb` (đã bị `precompute_wall_setup.m` ghi đè tại chỗ để thêm Groups — đã verify vô hại; bản gốc 2016 sạch còn ở `Sap\Sap ke pd 10\ke pd 10.sdb` làm fallback).
- `precompute_wall_setup.m` — đã chạy, tạo `wall_setup_data.mat` (diện tích 6 vùng, joint đỉnh tường, ánh xạ cọc↔vùng DAY, dữ liệu base-junction cho từng vùng TUONG).
- `Sap_KeSauCau.m` — hàm mục tiêu + 5 ràng buộc, đã bắt và sửa **3 bug nghiêm trọng** (xem mục 3), đã verify bằng smoke test + pilot thật.
- **Smoke test** (Npop=4, Max_it=1): BestX=[0,20 0,24 0,25 0,90 1,20 0,63] → V=270,372 m³, tất cả 5 ràng buộc đạt.
- **Pilot run** (Npop=10, Max_it=5, 60 FE, 830s, không cần watchdog restart): BestX=**[0,20 0,29 0,28 0,40 0,78 0,59]** → **V=242,117 m³**, tất cả 5 ràng buộc đạt, Penalty=0. Đây là điểm khả thi tốt nhất hiện có.
- t_FE (thời gian 1 lần đánh giá SAP2000 thật) ≈ 14-26s tuỳ máy/tải hệ thống.

## 3. Bug đã gặp — ĐỪNG lặp lại

1. **Lỗi thứ tự cột `AreaForceShell`** (đếm thiếu token khi destructuring, làm M11/M22/V13/V23 lệch sang FAngle/FVM/...). Chữ ký ĐÚNG (25 output, luôn đếm lại từng lần dùng):
   `ret,NumberResults,Obj,Elm,PointElm,LoadCase,StepType,StepNum,F11,F22,F12,FMax,FMin,FAngle,FVM,M11,M22,M12,MMax,MMin,MAngle,V13,V23,VMax,VAngle`
2. **Fallback "never empty" từng vô tình tắt hẳn bộ lọc loại trừ** khi mọi điểm đều rơi vào bán kính loại trừ (cọc dày, hoặc vùng TUONGM78 mỏng hơn chính h0 của nó) — sửa thành "giữ điểm có margin lớn nhất" thay vì "tắt lọc, giữ tất cả".
3. **🚨 Bug nghiêm trọng nhất**: `SetShell_1` dùng sai tên vật liệu `'M350'` thay vì đúng tên model `'BTM350'` — khiến **toàn bộ SetShell_1 âm thầm fail (ret=1)** suốt cả 1 phiên, độ dày SAP2000 KHÔNG BAO GIỜ thực sự đổi dù MATLAB tưởng đã đổi. Smoke test + pilot đầu tiên (nhìn có vẻ hợp lý) hoá ra **vô giá trị hoàn toàn**, đã xoá. **Bài học bắt buộc nhớ**: luôn kiểm tra return code (`ret`) của MỌI lệnh setter OAPI (SetShell_1, RunAnalysis...) — COM không throw exception khi setter fail, chỉ trả mã lỗi số. Đã thêm check `if r~=0; error(...); end` vĩnh viễn sau mỗi setter trong `Sap_KeSauCau.m`.

## 4. Vận hành SAP2000/MATLAB — bắt buộc đọc trước khi chạy trên máy mới

- **KHÔNG BAO GIỜ gọi MATLAB trực tiếp** cho bất kỳ chạy nào có SAP2000 — luôn qua `watchdog_run.ps1`. SAP2000 có hiện tượng "phình" bộ nhớ khi `OpenFile` (đỉnh ~5-6GB, khoảng t=80-150s) rồi tự hạ — đây là hiện tượng MÔI TRƯỜNG (đã xác nhận nhiều lần trên máy hiện tại), không phải bug code.
- **Ngưỡng RAM watchdog: dùng `-MinFreeGB 0.3`** (KHÔNG dùng 1.0 hay 2.5 — cả hai từng gây restart liên tục vô ích khi máy có tải nền cao). Cần đo lại ngưỡng phù hợp trên máy PC mới (theo dõi 1 lần chạy tay, xem đáy RAM trống rơi tới đâu) vì mỗi máy có baseline RAM khác nhau.
- **⚠️ QUAN TRỌNG cho máy mới**: `watchdog_run.ps1` đang **hardcode đường dẫn tuyệt đối**:
  ```
  addpath('D:\ResearchLab\04_Tap chi trong nc\Truong CTT 51\code\Functions')
  addpath('D:\ResearchLab\04_Tap chi trong nc\Truong CTT 51\Ke sau cau\code\SOO_KeSauCau\Ke_Sap')
  ```
  và đường dẫn MATLAB.exe `C:\Program Files\MATLAB\R2023b\bin\matlab.exe`. Nếu máy mới có ổ đĩa/đường dẫn khác, **PHẢI sửa các đường dẫn này trong `watchdog_run.ps1` trước khi chạy**.
- **SM Toolbox** (COM wrapper cho SAP2000 OAPI) là **MATLAB Add-On cài theo máy**, P-code, ở `%AppData%\Roaming\MathWorks\MATLAB Add-Ons\Toolboxes\SM Toolbox\+SM\` — **không nằm trong repo này**. Máy PC mới phải tự cài Add-On này (và có license SAP2000 hợp lệ) trước khi bất kỳ script nào chạy được.
- Hiện tại toàn bộ pipeline dùng `matlab -batch` (đã chạy ổn định, verify nhiều lần). **CHƯA thử `matlab -r`** — nếu áp dụng song song 8-worker, nên thử nghiệm `-r` vs `-batch` xem có khác biệt về threading COM không (mô hình MTA/STA có thể ảnh hưởng đến việc mở nhiều phiên SAP2000 đồng thời) TRƯỚC khi cam kết vào campaign lớn.
- **8-worker song song = KIẾN TRÚC KHÁC, CHƯA ĐƯỢC KIỂM CHỨNG**: toàn bộ code hiện tại (`SOO_KeSauCau_run_SAP.m`) chạy **tuần tự, 1 phiên COM SAP2000 duy nhất/lần chạy** — thiết kế cố ý để tránh đúng loại bất ổn bộ nhớ/COM đã gặp. Chạy 8 phiên SAP2000 song song trên cùng máy cần xác nhận trước: (a) license SAP2000 có cho phép ≥8 phiên đồng thời không (nhiều license single-seat), (b) đủ RAM cho 8× áp lực bộ nhớ (mỗi phiên có thể phình tới 5-6GB), (c) có xung đột file `.sdb` nếu 8 worker cùng mở 1 file không (nên mỗi worker có bản copy `.sdb` riêng). **Đừng tự ý triển khai song song mà không test nhỏ trước** (ví dụ 2 worker trước khi lên 8).

## 5. Việc cần làm tiếp (nhiệm vụ chính cho phiên mới)

**Quyết định quy mô campaign chính thức** (Npop/Max_it/Nrun) cho bài báo. Hiện đang là placeholder trong `SOO_KeSauCau_run_SAP.m` case `'paper'`: Npop=15, Max_it=15 (240 FE/lần chạy), Nrun chưa chốt (đề xuất tạm Nrun=5-10 theo tiền lệ dự án Kè cũ).

**Nhiệm vụ cụ thể user yêu cầu**: nghiên cứu cách một dự án khác (MOFDA/Wharf100DWT) tính quy mô campaign — cụ thể là công thức tính `N_total` từ đo thời gian pilot, và cách sizing Npop/Max_it — trong file `run_campaign_TEMPLATE.m` (và tham khảo `PHUONG_AN_CHAY_CAMPAIGN_MOFDA_SAP2000.md`). User sẽ gửi 2 file này khi phiên mới cần. **CHỈ mượn phương pháp/công thức sizing, KHÔNG mượn kiến trúc hay đổi lõi nghiên cứu** — giữ nguyên toàn bộ: 6 biến thiết kế, 5 ràng buộc TCVN, thuật toán SFOA, mô hình SAP2000 của Kè sau cầu như mục 1-2 ở trên.

Sau khi chốt quy mô: chạy campaign đầy đủ (watchdog-supervised), rồi viết bài báo `.md` (không phải `.docx`) theo khuôn `Ke VIp grenn port\Quy cach bai bao khoa hoc-TCXD.docx` (Tạp chí Xây dựng: heading, tài liệu tham khảo IEEE, dấu phẩy thập phân, ≤3500 từ).

## 6. Dọn dẹp (không khẩn cấp)

`Ke_Sap\` có nhiều script chẩn đoán/dùng 1 lần còn sót lại: `probe_api.m, probe_api2.m, test_timing.m, test_two_evals.m, test_setshell.m, test_lock.m, dump_result.m, dump_pilot.m, dump_pilot2.m, dump_smoke2.m`, cùng các `*_log.txt` cũ. Có thể xoá khi dọn dẹp cuối dự án — chưa cần làm ngay.

## 7. Memory

Toàn bộ chi tiết kỹ thuật đầy đủ (từng bug, từng con số, từng trích dẫn TCVN) nằm trong memory file `ke-sau-cau-sfoa-spec.md` của Claude (ở máy hiện tại, thư mục `.claude/projects/.../memory/`). Máy mới sẽ có memory riêng — **file bàn giao này là bản tóm tắt đầy đủ nhất có thể**; nếu phiên mới cần chi tiết hơn (ví dụ trích dẫn TCVN chính xác, log debug cũ), có thể tìm trong các file `.txt` log và code comment tại `Ke_Sap\Sap_KeSauCau.m` — mọi quyết định quan trọng đều có comment giải thích ngay tại chỗ trong code, không chỉ trong memory.
