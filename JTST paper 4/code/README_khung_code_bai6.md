# Khung code MATLAB–SAP2000 cho Bài 6 (JTST paper 4)

Theo [`Cong_thuc_Bai_toan_Toi_uu_Bai6.md`](../Cong_thuc_Bai_toan_Toi_uu_Bai6.md) (đọc trước) và kiến trúc/kinh nghiệm [`Cach ket noi_SAP2000_MATLAB_OPTIMIZATION.md`](../Kinh%20nghiem%20tu%20du%20an%20truoc/Cach%20ket%20noi_SAP2000_MATLAB_OPTIMIZATION.md) + [`Kinh nghiem MOSFOA Paper 2.md`](../Kinh%20nghiem%20tu%20du%20an%20truoc/Kinh%20nghiem%20MOSFOA%20Paper%202.md).

## Các file

| File | Vai trò |
|---|---|
| `MOSFOA_core/*.m` (7 file) | **Copy nguyên** từ `MOFDA/MOFDA/Functions/` — thuật toán MOSFOA gốc của bạn (checkDomination, dominates, hypervolume, selectLeader, updateGrid, updateRepository, deleteFromRepository). KHÔNG chỉnh sửa. |
| `open_Sap2000_v2.m` / `open_Sap2000_worker_v2.m` | Copy nguyên từ `MOSFOA paper 2/code/` (đã chạy thật ổn định nhiều giờ liên tục ở Bài 1/2). |
| `model/Ben so 1 Chan May.sdb` | **BẢN LÀM VIỆC** — copy từ `Mo hinh SAP/Ben so 1 Chan May.sdb` (file gốc giữ nguyên, không bao giờ ghi đè). |
| `project_config_bai6.m` | Toàn bộ hằng số đã chốt: X1-X4 (biến thiết kế), Rb/Rs (Mu), Rd/γn (cọc), U_allow, tên section/combo. |
| `mu_beam_tcvn5574.m` | Công thức Mu (TCVN 5574:2018, As theo ξ=ξ_R) — dùng chung cho DN/DD/DCT/BMC. |
| `evaluate_superstructure_design.m` | Hàm mục tiêu/fitness chính — nhận x (chỉ số catalogue X1-X4), trả `[f1,f2]` + phạt cứng nếu vi phạm ràng buộc. |
| `mosfoa6_evaluate_batch.m` | Bọc batch cho vòng lặp MOSFOA. |
| `run_mosfoa6_parallel.m` | Chạy 1 lần MOSFOA song song (lõi thuật toán copy nguyên từ `run_emosfoa_wharf100dwt_parallel.m`). |
| `diagnose_bai6.m` | **BẮT BUỘC chạy ĐẦU TIÊN** — in raw tên section/combo/nút thật, đối chiếu tay, đo hằng số hình học (L_DN/L_DD/L_DCT/A_BMC). |
| `prepare_model_bai6.m` | Chạy 1 lần, SAU diagnose — sửa nút 1945 thiếu ngàm trên bản làm việc. |

## ⚠️ Các điểm CHƯA kiểm chứng live (TODO trong code, cần bạn chạy thật trên máy)

1. **`SM.PropArea.SetShell_1(...)` signature** (evaluate_superstructure_design.m mục 1) — copy theo tài liệu CSI OAPI, chưa test trên model này. Nếu lỗi, `diagnostic.SetShell_error` sẽ cho thông báo cụ thể.
2. **`SM.Results.AreaForceShell(...)` thứ tự cột** (local_area_and_pile) — copy theo tài liệu CSI OAPI, ĐẶC BIỆT rủi ro vì Bài 2 từng gặp lỗi off-by-one y hệt kiểu này với `FrameForce` (đã sửa, xác nhận đúng thứ tự cho FrameForce). Chưa có script diagnose riêng cho AreaForceShell — nên tự in raw giá trị M11/M22 của 1 phần tử BMC đã biết trước (so với giá trị hợp lý) trước khi tin campaign.
3. **`cfg.deck_top_Z`** đang để `0.0` (TODO) — cần xác nhận đúng cao độ Z trong hệ toạ độ model FEM này (không nhất thiết trùng Z=0 SAP với Hải đồ — xem đầu file `FEM_Ben70000DWT_ChanMay.md`) để lọc đúng nút khi tính U_max.
4. **γ (đơn vị Tonf-m nội bộ model)** — code nhân 9,80665 khi chuyển M2/M3/M11/M22 từ Tonf.m sang kN.m để khớp đơn vị kPa của Rb/Rs. Xác nhận lại đơn vị SAP model thật vẫn là Tonf-m-°C (đã xác nhận ở FEM doc mục 2) trước khi tin số.

## Quy trình chạy đề xuất

1. `matlab -r "cd('...code'); diagnose_bai6; exit;"` — xác nhận tên section/combo/số phần tử khớp FEM doc, đo geom constants, kiểm tra nút 1945.
2. `matlab -r "cd('...code'); prepare_model_bai6; exit;"` — sửa nút 1945 trên bản làm việc.
3. Chạy lại `diagnose_bai6` để xác nhận nút 1945 đã ngàm.
4. Viết 1 script nhỏ gọi `evaluate_superstructure_design` cho 1 phương án (baseline `cfg.baseline_idx=[10 10 12 3]`), in toàn bộ `diagnostic` — đối chiếu M/η/U/N_pile có hợp lý không (đặc biệt để bắt lỗi ở mục ⚠️ trên) trước khi tin bất kỳ campaign nào.
5. Smoke test `run_mosfoa6_parallel(2, 4, 1)` (Npop nhỏ, 1 vòng lặp) — đo thời gian 1 eval thật trên model này (model lớn hơn Bài 2: 747 frame + 1750 area, RunAnalysis có thể chậm hơn).
6. Pilot ở Npop/Max_it dự kiến dùng cho campaign thật, rồi mới quyết định Nrun.
