# Bàn giao phiên làm việc — 2026-08-13 — Bài báo SOO-SFOA (Tạp chí Xây dựng)

> Đọc file này ở đầu phiên chat mới để tiếp tục đúng mạch, không cần hỏi lại người dùng những gì đã chốt.

## 1. Mục tiêu dự án

Viết bài báo khoa học (Tạp chí Xây dựng) về áp dụng **SFOA nguyên bản** (Original Starfish Optimization Algorithm) để giải **6 bài toán tối ưu đơn mục tiêu (SOO)** trên 3 hệ kết cấu công trình biển: **BD** (Berthing Dolphin), **MD** (Mooring Dolphin), **MJP/MPJ** (Main Jetty Platform) — mỗi hệ 2 mục tiêu độc lập (Min Cost, Min Displacement). Đây là bài "tiền thân" dẫn tới bài MOO/MOSFOA đã có trước đó (`paper/MOSFOAV2.pdf`). Câu chuyện khoa học khóa cứng:

> SFOA giải tốt SOO → nhưng SOO chỉ cho nghiệm cực trị → Cost và Displacement xung đột → cần tập nghiệm Pareto → MOSFOA được biện minh.

Tài liệu gốc quy định toàn bộ nội dung/văn phong/checklist: [01_SO0_SFOA_Marine_Jetty_TCID_Outline.md](01_SO0_SFOA_Marine_Jetty_TCID_Outline.md). Quy cách trình bày tạp chí: [paper/Quy cach bai bao khoa hoc-TCXD.docx](paper/Quy%20cach%20bai%20bao%20khoa%20hoc-TCXD.docx).

**Nguyên tắc cấm tuyệt đối** (đã nhắc trong outline, PHẢI giữ):
- Không kết luận "SFOA yếu/thất bại".
- Không đưa Pareto/MOSFOA vào thực nghiệm của bài SOO này.
- Không tái sử dụng nguyên xi Pareto front của bài MOO làm kết quả chính (chỉ dùng để tham chiếu/kiểm tra).
- Không tự bịa số liệu kết quả — mọi bảng Kết quả phải chờ dữ liệu chạy thật.

## 2. Đã giao cho người dùng

**Bản thảo draft**: [02_Draft_SOO_SFOA_Marine_Jetty_TCXD.md](02_Draft_SOO_SFOA_Marine_Jetty_TCXD.md) (~3.360 từ, đúng cấu trúc & quy cách tạp chí). Phần Đặt vấn đề / Mô hình & phương pháp / Thiết lập thực nghiệm đã viết đầy đủ, dùng được ngay. **Phần TÓM TẮT/ABSTRACT, KẾT QUẢ VÀ THẢO LUẬN, KẾT LUẬN định lượng còn để `[TBD]`** vì chưa có số liệu chạy thật — tuyệt đối không điền số bịa vào đó.

**Việc cần sửa trong draft trước khi hoàn thiện**: mô tả BD hiện ghi "9 cọc" theo outline, nhưng mô hình SAP2000 thật (`Sap_BD_HL_v3.m`) có **19 cọc** (D1…D19). Cần chốt số đúng với người dùng rồi sửa mục 1.1 của draft.

## 3. Kho code — hiện trạng sau khi người dùng gửi 4 file zip

Người dùng đã gửi vào `code/`: `Functions.zip`, `Pile_TCVN10304_2014.zip`, `Run_MOMSFOA_official.zip`, `tools.zip`. Đã giải nén vào `code/_extracted/`.

**Phát hiện quan trọng nhất**: `Run_MOMSFOA_official/` chứa **pipeline B-MOSFOA/E-MOSFOA đã hoàn chỉnh và đã chạy xong** cho cả BD, MD, MPJ (dùng cho bài MOO trước đó) — gồm đầy đủ `Functions/` (open_Sap2000.m, checkDomination, updateRepository, selectLeader, hypervolume, plotting...), `Pile_TCVN10304_2014/` (8 hàm phụ trợ từng thiếu: pile_bearing_capacity, pile_create, calc_section_inertia, get_equivalent_pile_width, get_k_from_IL, get_equivalent_k_multi, select_concrete_E_by_grade — cộng thêm nhiều hàm get_gamma_*), các file mô hình SAP2000 `.sdb` gốc, script driver `BMOSFOA_XX_v3.m`/`EMOSFOA_XX_v3.m`, và cả **kết quả .mat của các lần chạy FULL** (vd. `BD_BMOSFOA_FULL_...Npop100_Nvar3_Maxit300.mat`).

Từ đọc code, xác định được **cách mã hóa biến thiết kế thực tế** (khác cách viết tách biệt D,t,θ,L trong outline — cần đối chiếu lại khi viết mục 1.5 của bài):
- **BD & MD**: `nVar=3`, `x = [pile_type_idx, inclined_pile_ratio, pile_length_L]`
  - `pile_type_idx`: chỉ số dòng trong bảng catalogue cọc (gộp chung D & t), miền `[1, size(data,1)]`
  - `inclined_pile_ratio`: miền `[6, 8]`, bước 1
  - `pile_length_L`: miền `[16, 39]` m, bước 0,1
  - Catalogue `data` = `readmatrix('Prestress_Pile_TCVN7888_2014.xlsx')` (BD) hoặc tương đương cho MD, đã lưu sẵn thành `X1_X2.mat` trong mỗi case.
- **MJP/MPJ**: `nVar=6`, `x = [pile_type_idx, pile_length_L(16-39), span_X(3-6), span_Y(3-6), beam_width(0.5-2), beam_height(0.5-2)]`

Hàm mục tiêu `Sap_BD_HL_v3` / `Sap_MD_HL_v3` / `Sap_MPJ` trả về `[fit, diagnostic]`: `fit` = `[Cost_penalized, Displacement_penalized]` (2 cột, dùng chung cho cả MOO và giờ dùng SOO bằng cách chỉ lấy 1 cột); `diagnostic` = 20 cột (RawCost, RawDisplacement, MaxAbsM2, MaxAbsM3, MomentCapacity, MaxAbsAxialReaction, PileBearingCapacity, M2Violation, M3Violation, BearingViolation, UpliftDemand, UpliftResistance, UpliftViolation, TotalStructuralViolation, Penalty, LengthConditionOK, TipSoilConditionOK, TipLayerThicknessOK, SAPAnalysisExecuted, AllConstraintsSatisfied).

Kết nối SAP2000↔MATLAB qua COM dùng `SM` (SM tool) trong `Functions/open_Sap2000.m`, chạy song song bằng `spmd`: mỗi worker mở **một tiến trình SAP2000 riêng**, tự lưu bản copy `.sdb` riêng để tránh đụng file.

## 4. Đã dựng cho bài SOO (dựa trên pipeline MOO đã xác minh)

Đã tạo 3 folder tự chứa (copy từ `Run_MOMSFOA_official`, không symlink):
- `code/SOO_BD/` (Functions/, BD_Sap/, Pile_TCVN10304_2014/, X1_X2.mat)
- `code/SOO_MD/` (tương tự cho MD)
- `code/SOO_MPJ/` (tương tự cho MPJ)

Đã viết **driver đơn mục tiêu** [code/SOO_BD/SOO_BD_run.m](code/SOO_BD/SOO_BD_run.m): giữ nguyên hạ tầng song song SAP2000 (spmd) từ `BMOSFOA_BD_v3.m`, nhưng **bỏ toàn bộ cơ chế Pareto/repository/leader-selection**, thay bằng theo dõi 1 nghiệm tốt nhất theo đúng cơ chế `SFOA.m` nguyên bản (exploration/exploitation, theta/tEO/GP). Nhận tham số qua biến workspace trước khi `run()`: `objCol` (1=Cost, 2=Displacement), `runMode` ('smoke'/'full'), `Nrun`, `runIdOffset`. Có **checkpoint sau mỗi run** (lưu `.mat` riêng + ghi log tiến độ vào `results/BD_<obj>_progress.log`) — quan trọng vì campaign đầy đủ sẽ chạy nhiều ngày, không được để mất dữ liệu nếu bị ngắt.

**Chưa viết**: `SOO_MD_run.m`, `SOO_MPJ_run.m` (cùng pattern, MPJ cần sửa nVar=6/lb/ub theo mục 3). Đang chờ quyết định về quy mô/số worker trước khi viết tiếp để tránh phải sửa lại.

## 5. Smoke test đã chạy — KẾT QUẢ

Chạy `matlab -batch` với `objCol=1; runMode='smoke'; Nrun=1` cho BD-Cost (Npop=8, Max_it=1, 3 worker song song).

**Log**: [code/SOO_BD/smoke_test_BD_C.log](code/SOO_BD/smoke_test_BD_C.log), [code/SOO_BD/results/BD_Cost_progress.log](code/SOO_BD/results/BD_Cost_progress.log), kết quả: [code/SOO_BD/results/BD_SOO_Cost_run01_SMOKE.mat](code/SOO_BD/results/BD_SOO_Cost_run01_SMOKE.mat).

**Kết luận: pipeline chạy đúng, không lỗi.** Best(penalized) = Best(raw) = 32.940,13 (nghiệm khả thi, không bị phạt). 16 FE trong 32,4 s.

## 6. PHÁT HIỆN CHẶN ĐƯỜNG (lý do tạm dừng)

Máy hiện tại: **Intel i5-1145G7, 4 lõi thật / 8 luồng**. MATLAB local cluster mặc định `NumWorkers=4` (theo lõi thật) → với `workerFraction=0.8` chỉ đạt **3 tiến trình SAP2000 song song tối đa**.

Đo được: **≈5,4 giây/lần đánh giá FEM** (thời gian tuần tự mỗi worker, mô hình BD 19 cọc).

**Ngoại suy cho đúng cấu hình đã khóa trong đề cương** (Npop=100, Max_it=300, Nrun=30, × 6 case):
- 1 run đầy đủ: 301 thế hệ × ⌈100/3⌉ × 5,4 s ≈ **15,3 giờ**
- 30 run/case ≈ **19 ngày/case**
- **6 case ≈ 115 ngày chạy liên tục** trên máy hiện tại → **không khả thi**.

Đã trình bày lựa chọn cho người dùng (giữ 3 worker vs. thử tăng worker; giữ Npop=100/300/30 vs. giảm quy mô ở các mức khác nhau vs. chạy thử để xem đường hội tụ trước) — **người dùng chưa chốt**, xin dừng lại để **sáng mai (2026-08-14) gửi cấu hình máy cơ quan** rồi tính lại bài toán thời gian với phần cứng đó.

## 7. VIỆC CẦN LÀM Ở PHIÊN TIẾP THEO (theo thứ tự)

1. **Nhận cấu hình máy cơ quan** từ người dùng (số lõi CPU thật/luồng, RAM, đã cài MATLAB + Parallel Computing Toolbox + SAP2000 chưa, máy có thể chạy liên tục nhiều ngày không).
2. Tính lại công thức thời gian ở mục 6 với phần cứng mới (số worker tối đa = `floor(workerFraction × min(logical_cores, physical_cores_or_license_cap, Npop))`), đề xuất số worker + Npop/Max_it/Nrun hợp lý cho người dùng chốt (không tự quyết một mình — đây là quyết định đánh đổi khoa học/thời gian của người dùng).
3. Sau khi chốt quy mô: viết `SOO_MD_run.m` và `SOO_MPJ_run.m` theo đúng pattern của `SOO_BD_run.m` (chú ý MPJ nVar=6, lb/ub khác — xem mục 3).
4. Smoke-test MD-Cost, MD-Displacement, MPJ-Cost, MPJ-Displacement, và BD-Displacement (mới test BD-Cost) trước khi chạy thật — không bỏ qua bước này.
5. Chạy campaign thật (nền, có checkpoint), theo dõi bằng cách đọc `results/*_progress.log` — không cần polling liên tục, dùng ScheduleWakeup giãn cách hợp lý hoặc chờ task-notification khi lệnh nền hoàn tất.
6. Khi đủ dữ liệu 6 case × N run: tổng hợp Best/Mean/Max/STD/CV, 2 nghiệm cực trị mỗi hệ, so sánh với thiết kế hiện tại, bảng cross-objective trade-off — điền vào các bảng `[TBD]` trong [02_Draft_SOO_SFOA_Marine_Jetty_TCXD.md](02_Draft_SOO_SFOA_Marine_Jetty_TCXD.md).
7. Sửa mục 1.1 của draft: xác nhận lại số cọc BD (19, không phải 9) với người dùng rồi cập nhật.
8. Bổ sung: tên tác giả/đơn vị công tác thật (đang để placeholder), thông tin trích dẫn đầy đủ cho tài liệu [2] (bài MOO/MOSFOA nền — hiện đang placeholder trong danh mục tài liệu tham khảo).

## 8. Bản đồ file quan trọng

| File | Vai trò |
|---|---|
| [01_SO0_SFOA_Marine_Jetty_TCID_Outline.md](01_SO0_SFOA_Marine_Jetty_TCID_Outline.md) | Đề cương khóa cứng nội dung + checklist |
| [paper/Quy cach bai bao khoa hoc-TCXD.docx](paper/Quy%20cach%20bai%20bao%20khoa%20hoc-TCXD.docx) | Quy cách trình bày tạp chí |
| [02_Draft_SOO_SFOA_Marine_Jetty_TCXD.md](02_Draft_SOO_SFOA_Marine_Jetty_TCXD.md) | Bản thảo đang viết (Results còn TBD) |
| `code/SFOA.m`, `code/mainSFOA.m` | SFOA nguyên bản (benchmark gốc) |
| `code/_extracted/Run_MOMSFOA_official/MOSFOA_{BD,MD,MPJ}/` | Pipeline MOO đã xác minh chạy được — nguồn tham chiếu cho mọi hàm phụ trợ |
| `code/SOO_BD/SOO_BD_run.m` | Driver SOO đã viết & smoke-test thành công (BD) |
| `code/SOO_BD/results/`, `code/SOO_BD/smoke_test_BD_C.log` | Kết quả & log smoke test |
| `code/SOO_MD/`, `code/SOO_MPJ/` | Đã dựng folder, **chưa có driver** |

---
*File này do Claude tạo để bàn giao giữa 2 phiên chat. Phiên mới nên đọc file này trước, sau đó đọc trực tiếp các file trong mục 8 nếu cần chi tiết.*
