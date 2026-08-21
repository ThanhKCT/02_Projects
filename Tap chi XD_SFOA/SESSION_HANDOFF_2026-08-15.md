# Bàn giao phiên làm việc — 2026-08-15 — Bài báo SOO-SFOA (Tạp chí Xây dựng)

> Đọc file này ở đầu phiên chat mới để tiếp tục đúng mạch. File bàn giao trước: [SESSION_HANDOFF_2026-08-13.md](SESSION_HANDOFF_2026-08-13.md) — vẫn còn giá trị cho phần mục tiêu/draft/outline, phần "việc cần làm" của nó đã được cập nhật bởi file này.

## 1. Mục tiêu dự án (không đổi so với phiên trước)

Viết bài báo khoa học (Tạp chí Xây dựng) về áp dụng **SFOA nguyên bản** để giải **6 bài toán tối ưu đơn mục tiêu (SOO)** trên 3 hệ kết cấu công trình biển: **BD, MD, MJP/MPJ** — mỗi hệ 2 mục tiêu (Min Cost, Min Displacement). Câu chuyện khoa học khóa cứng:

> SFOA giải tốt SOO → nhưng SOO chỉ cho nghiệm cực trị → Cost và Displacement xung đột → cần tập nghiệm Pareto → MOSFOA được biện minh.

**Quyết định quan trọng của người dùng trong phiên này**: **giữ nguyên cả 3 hệ kết cấu (BD, MD, MPJ)**, không rút gọn xuống chỉ MJP (đã có lúc cân nhắc phương án rút gọn, nhưng người dùng chốt giữ đủ 3 hệ). Thay vào đó, **tính toán lại tài nguyên máy và số vòng lặp (Npop/Max_it/Nrun) để tối ưu** — người dùng **không khóa cứng** các con số 100/300/30 của đề cương gốc, cho phép điều chỉnh miễn có căn cứ. Mục đích cốt lõi vẫn là: SFOA/SOO làm cầu nối khoa học sang bài MOSFOA đã có.

Nguyên tắc cấm tuyệt đối (giữ nguyên từ phiên trước): không kết luận "SFOA yếu"; không đưa Pareto/MOSFOA vào thực nghiệm SOO; không tái dùng Pareto front của bài MOO làm kết quả chính; không tự bịa số liệu.

## 2. PHÁT HIỆN QUAN TRỌNG NHẤT: phiên chat này chạy TRỰC TIẾP trên máy cơ quan

Xác nhận bằng `systeminfo`/`wmic`: máy hiện tại (nơi Claude Code đang chạy) chính là máy cơ quan — **Intel Xeon E5-2680 v4 @ 2.40GHz, 14 lõi thật/28 luồng, RAM 49GB, mainboard X99-TF, Windows 10 Pro**, cùng ổ D: chứa project. Không cần hỏi người dùng cấu hình nữa — có thể tự kiểm tra/chạy trực tiếp.

Đã xác nhận trên máy này:
- **MATLAB R2023b** + **Parallel Computing Toolbox** đã cài, **có license hợp lệ** (`license('test','Distrib_Computing_Toolbox')=1`).
- `parcluster('local').NumWorkers = 14`, `feature('numcores') = 14`.
- **SAP2000 24** đã cài (`C:\Program Files\Computers and Structures\SAP2000 24\`), **license node-locked** — **cho phép 11 tiến trình SAP2000 chạy đồng thời không xung đột** (đã kiểm chứng thực tế, không chỉ suy đoán).
- Theo công thức có sẵn trong driver (`Num_work = floor(0.8 × min(logical_processors=28, localCluster.NumWorkers=14, Npop))`), với Npop=100 → **Num_work = 11 worker**.

## 3. Driver MATLAB — hiện trạng đầy đủ cho cả 3 hệ (trước đây chỉ có BD)

Đã viết thêm 2 driver còn thiếu, theo đúng pattern của [code/SOO_BD/SOO_BD_run.m](code/SOO_BD/SOO_BD_run.m) (đã smoke-test từ phiên trước):
- [code/SOO_MD/SOO_MD_run.m](code/SOO_MD/SOO_MD_run.m) — nVar=3, lb=[1,6,16], ub=[size(data,1),8,39], fun=`Sap_MD_HL_v3`, model `MD_Sap/MD_v3.sdb`.
- [code/SOO_MPJ/SOO_MPJ_run.m](code/SOO_MPJ/SOO_MPJ_run.m) — nVar=6, lb=[1,16,3,3,0.5,0.5], ub=[size(data,1),39,6,6,2,2], fun=`Sap_MPJ`, model `MPJ_Sap/MPJ.sdb`.

**Bug thật đã phát hiện và sửa**: `Sap_MPJ.m` trả về **18 cột diagnostic** (không phải 20 như BD/MD — MPJ không có 3 cột uplift nhưng có thêm `BeamPileClearanceOK`). Ban đầu tôi copy nhầm danh sách 20 cột của BD/MD sang MPJ → crash ở bước tổng hợp `FitAll/DiagAll` (`Unable to perform assignment... 10-by-20 and ... 10-by-18`). **Đã sửa `DiagnosticColumns` đúng 18 tên trong cả `SOO_MPJ_run.m` và `SOO_MPJ_calib.m`.** Nếu thấy lỗi tương tự tái xuất hiện, kiểm tra lại đúng field này trước.

Cả 3 driver (`SOO_BD_run.m`, `SOO_MD_run.m`, `SOO_MPJ_run.m`) giờ hỗ trợ 3 `runMode`: `'smoke'` (Max_it=1,Npop=8), **`'pilot'` (Max_it=150,Npop=100 — mới thêm, dùng để đo hội tụ thật)**, `'full'` (Max_it=300,Npop=100 — theo đề cương gốc, có thể sẽ đổi Max_it/Nrun theo mục 6 dưới).

Còn 3 file calibration riêng (không phải dữ liệu bài báo, chỉ để đo t_FE): `SOO_BD_calib.m`, `SOO_MD_calib.m`, `SOO_MPJ_calib.m` — copy từ driver thật, `runMode='calib'` (Max_it=0 hoặc 5, Npop=100).

## 4. Bài học vận hành quan trọng (áp dụng cho mọi lần chạy MATLAB dài sau này)

1. **Lệnh chạy nền qua Bash tool (`run_in_background:true`) có thể bị kill khi phiên Claude Code trước đó kết thúc/khởi động lại** — đã xảy ra thật (mất một chuỗi pilot 3 hệ đang chạy nối tiếp). KHÔNG dùng cơ chế này cho job dài (nhiều giờ/ngày).
2. **Giải pháp đã kiểm chứng hoạt động**: viết 1 file `.bat` gọi `matlab.exe -batch ...` (nối tiếp nhiều lệnh nếu cần), rồi khởi chạy bằng **PowerShell `Start-Process -WindowStyle Hidden -RedirectStandardOutput ... -RedirectStandardError ...`** (không dùng `-Wait`) → tạo tiến trình **tách hẳn khỏi phiên chat**, sống sót khi phiên chat bị ngắt. Ví dụ đã dùng: [code/run_pilots_MD_MPJ.bat](code/run_pilots_MD_MPJ.bat), log ra `code/pilot_log.txt` / `code/pilot_log_err.txt`.
   - **Lưu ý**: dùng cách này thì **sẽ không tự nhận được task-notification** khi xong (khác cơ chế Bash background) — phải tự kiểm tra file log hoặc `results/*_progress.log` khi người dùng hỏi lại.
3. **File `results/*_progress.log` (ghi tăng dần từng 10 vòng lặp) là lưới an toàn thật sự** — đã kiểm chứng: khi tiến trình BD pilot bị kill giữa chừng (mất ở it=110/150), toàn bộ log tiến độ đến it=110 vẫn còn nguyên, đủ để phân tích hội tụ dù không có file `.mat` cuối cùng (file `.mat` chỉ được lưu khi `Nrun` hoàn tất hết, nên nếu bị ngắt giữa run sẽ mất `.mat` của run đó, nhưng KHÔNG mất log tiến độ).
4. **`matlab -batch` dùng seed RNG mặc định giống nhau mỗi phiên mới** — 2 lần gọi lại không set `rng()` sẽ cho **kết quả giống hệt nhau** (đã kiểm chứng thực nghiệm với 2 lần calib MPJ trùng khớp tuyệt đối). Cần nhớ điều này khi diễn giải "biến động" giữa các lần chạy calib riêng lẻ — không phải biến động thật, mà do cùng 1 quần thể ngẫu nhiên.

## 5. Kết quả pilot hội tụ (Max_it=150, Npop=100, Nrun=1, objective=Cost) — ĐÃ CHẠY XONG

Chạy tuần tự BD → MD → MPJ qua tiến trình tách biệt (mục 4.2). BD bị ngắt giữa chừng (phiên trước kết thúc đột ngột) nhưng dữ liệu đến it=110 vẫn dùng được. MD và MPJ chạy trọn 150 vòng.

| Hệ | Hội tụ (Best-so-far ổn định từ) | Giá trị Best cuối | Batch-cost lúc khởi động → lúc ổn định | File log |
|---|---|---|---|---|
| BD | ~it=30 (đứng yên 10.164,8212 từ it=30 đến it=110, dừng giữa chừng ở it=110/150) | 10.164,8212 (chưa chắc là cuối cùng, còn 40 vòng chưa chạy) | ~117s → vẫn đang tăng, ~234s tại it=110 (chưa rõ đỉnh, KHÔNG có `.mat` vì chưa chạy hết) | `code/SOO_BD/results/BD_Cost_progress.log` (dòng `run901`) |
| MD | ~it=10 (đứng yên 2.422,2269 từ it=10 đến it=150 — 140 vòng liên tiếp) | 2.422,2269 | ~79s → ổn định ~110-123s | `code/SOO_MD/results/MD_Cost_progress.log`, `.../MD_SOO_Cost_run901_PILOT.mat` |
| MPJ | vẫn cải thiện nhẹ đến it=140 (0,12%/lần), gần phẳng từ it=150 | 5.291,8573 | ~40s → ổn định ~66-73s | `code/SOO_MPJ/results/MPJ_Cost_progress.log`, `.../MPJ_SOO_Cost_run901_PILOT.mat` |

**Phát hiện quan trọng nhất về hiệu năng**: **thời gian/batch KHÔNG cố định** — tăng 2-4 lần khi quần thể hội tụ (quần thể ngẫu nhiên ban đầu có nhiều cá thể không khả thi bị loại nhanh bằng phạt cứng; quần thể đã hội tụ có phần lớn cá thể khả thi, phải giải FEM+kiểm tra ràng buộc đầy đủ, chậm hơn nhiều). **Ước tính thời gian ở phiên trước (dựa trên calibration batch=0, quần thể ngẫu nhiên) đã lạc quan quá mức.**

Đã dựng 1 biểu đồ (artifact/widget, không lưu file) minh họa 3 đường hội tụ chuẩn hóa — có thể tái tạo lại dễ dàng nếu cần cho Hình 1 của bài báo, dữ liệu thô nằm trong bảng trên và các file log.

## 6. Tính lại tổng thời gian campaign — ĐÃ ĐỀ XUẤT, NGƯỜI DÙNG CHƯA CHỐT CUỐI CÙNG

Dùng dữ liệu pilot thật (không phải calibration lạc quan):

| Cấu hình | Max_it | Nrun | Npop | Tổng thời gian ước tính (6 case, máy cơ quan) |
|---|---|---|---|---|
| Gốc đề cương | 300 | 30 | 100 | **~84 ngày** (tính lại, xấu hơn nhiều so với ước tính ~30-38 ngày ở phiên trước — vì batch-cost không cố định) |
| **Đề xuất chính (đã trình bày, đang chờ chốt)** | **180** | **20** | **100** | **~32 ngày** |
| Phương án nhanh hơn | 150 | 20 | 100 | ~26 ngày (rủi ro nhỏ hơn về margin an toàn cho MPJ) |

**Trạng thái**: tôi đã trình bày bảng này và đề xuất **Max_it=180, Nrun=20, Npop=100 (~32 ngày)** làm khuyến nghị chính, kèm lý do (MPJ — hệ hội tụ chậm nhất — có margin 30 vòng an toàn sau lần cải thiện cuối; Nrun=20 vẫn đủ mạnh cho kiểm định thống kê, là mức phổ biến trong các bài tối ưu kết cấu-FEM chi phí cao). **Người dùng CHƯA xác nhận** con số cuối cùng khi phiên bị ngắt.

## 6.1. CẬP NHẬT CÙNG NGÀY: người dùng đổi yêu cầu — muốn xong trong 2 NGÀY, không phải 32 ngày

Người dùng quay lại trong cùng ngày (2026-08-15) và yêu cầu: **rút xuống chạy được trong ~2 ngày**, chấp nhận đánh đổi để "kết quả tốt nhất có thể trong khung thời gian đó", và muốn **bài báo hoàn thiện sau 2 ngày**.

**Đòn bẩy thời gian thật sự tìm ra**: không phải giảm Max_it (đã ở mức tối thiểu an toàn dựa trên hội tụ thật) mà là **giảm Npop**. Nút thắt cổ chai là số cá thể mỗi worker phải đánh giá tuần tự trong 1 vòng lặp = `ceil(Npop/Num_work)`. Với Num_work=11 (cố định do license SAP2000), Npop=100 → 10 cá thể/worker/vòng; Npop=30 → 3 cá thể/worker/vòng → **nhanh gấp ~3,3 lần**, mà Npop=30 vốn là giá trị mặc định chuẩn trong benchmark SFOA/metaheuristic (không phải cắt ẩu).

Tính lại Max_it tối thiểu an toàn cho từng hệ (dùng đúng dữ liệu pilot thật, đọc lại từng dòng log, không phải ước tính):
- **BD**: hội tụ tuyệt đối (giá trị đứng yên 10164,8212) từ it=30 đến it=110 (80 vòng liền không đổi) → chọn **Max_it=50** (margin 20 vòng).
- **MD**: hội tụ tuyệt đối (2422,2269) từ it=10 đến it=150 (140 vòng liền không đổi) → chọn **Max_it=40** (margin 30 vòng).
- **MPJ**: **vẫn đang cải thiện** ở it=120→130→140 (5304,85→5298,35→5291,86), chưa hẳn phẳng ở it=150 → **giữ nguyên Max_it=150** (không có margin dư, đây là hệ rủi ro nhất).

**Đã chọn cùng người dùng**: **Npop=30, Nrun=10, Max_it=[BD:50, MD:40, MPJ:150]** (phương án khuyến nghị, người dùng xác nhận nguyên văn "chốt như bạn khuyến nghị: Npop=30, Nrun=10"). Ước tính tổng thời gian tính toán ~36 giờ (~1,5 ngày), còn dư ~10-12h cho phân tích + viết bài.

### Đã làm ngay sau khi chốt (2026-08-15 tối):
1. **Smoke-test Displacement (objCol=2) cho cả 3 hệ — CHƯA từng test trước đây, đã PASS cả 3, không lỗi**: BD best=0,0068 (27,1s), MD best=0,0087 (15,0s), MPJ best=0,0002 (21,7s). Rủi ro lớn nhất trước khi chạy thật đã được loại bỏ.
2. Thêm `case 'campaign'` vào cả 3 driver (`SOO_BD_run.m`, `SOO_MD_run.m`, `SOO_MPJ_run.m`) với Npop=30 và Max_it riêng từng hệ như trên (kèm comment giải thích căn cứ ngay trong code).
3. Viết [code/run_campaign_all6.bat](code/run_campaign_all6.bat): chạy tuần tự cả 6 case (BD-C, BD-D, MD-C, MD-D, MPJ-C, MPJ-D), mỗi case `runMode='campaign', Nrun=10, runIdOffset=0` → file kết quả `..._run01..10_CAMPAIGN.mat`.
4. **Đã khởi chạy** qua PowerShell `Start-Process -WindowStyle Hidden` (tiến trình tách biệt, sống sót qua gián đoạn phiên chat — xem bài học mục 4) lúc **~22:39 ngày 15-08-2026**. Log: `code/campaign_log.txt`, `code/campaign_log_err.txt`. Xác nhận đã chạy (PID matlab/cmd riêng biệt), máy sạch trước khi chạy (không còn tiến trình SAP2000/MATLAB cũ).
5. Đã tạo 7 task theo dõi qua TaskCreate (1 task/case + 1 task tổng hợp cuối).

### Ước tính hoàn thành từng case (Npop=30, dựa trên tốc độ pilot Npop=100 chia cho hệ số ~3,33):
| Case | Max_it | Ước tính/run | Ước tính Nrun=10 |
|---|---|---|---|
| BD-Cost, BD-Displacement | 50 | ~0,68h | ~6,8h/case |
| MD-Cost, MD-Displacement | 40 | ~0,33h | ~3,3h/case |
| MPJ-Cost, MPJ-Displacement | 150 | ~0,80h | ~8,0h/case |

Tổng ước tính ~36h chạy tuần tự đúng thứ tự BD-C→BD-D→MD-C→MD-D→MPJ-C→MPJ-D. **Chưa kiểm chứng thực tế** — cần theo dõi `results/*_progress.log` để xác nhận đúng tiến độ, đặc biệt MPJ-Displacement (case cuối, rủi ro cao nhất nếu lịch trình bị trễ dồn từ các case trước).

### VIỆC CẦN LÀM TIẾP (thay thế mục 7 cũ bên dưới — đã lỗi thời):
1. Theo dõi tiến độ định kỳ qua `code/SOO_{BD,MD,MPJ}/results/*_progress.log` và `code/campaign_log.txt`/`campaign_log_err.txt`. Nếu MPJ (case cuối) có dấu hiệu trễ nhiều so với ước tính, cân nhắc báo người dùng để quyết định có cắt bớt Nrun cho case đó không.
2. Khi mỗi case hoàn tất (đủ 10 file `..._run0X_CAMPAIGN.mat`), có thể bắt đầu tổng hợp Best/Mean/Max/STD/CV cho case đó ngay, không cần chờ hết cả 6 case.
3. Khi đủ cả 6 case: điền bảng Kết quả/Thảo luận/Kết luận trong [02_Draft_SOO_SFOA_Marine_Jetty_TCXD.md](02_Draft_SOO_SFOA_Marine_Jetty_TCXD.md), sửa số cọc BD=19, bổ sung tác giả/đơn vị/trích dẫn [2], đưa phát hiện "Npop giảm để khả thi thời gian" + "batch-cost tăng khi hội tụ" vào phần Hiệu quả tính toán/Hạn chế — ghi trung thực đây là đánh đổi vì giới hạn thời gian, không giấu.
4. **Lưu ý minh bạch khoa học**: Nrun=10 và Npop=30 thấp hơn chuẩn "vàng" (20-30 run, Npop=50-100) — phải ghi rõ trong phần Hạn chế/Thảo luận của bài báo, không trình bày như thể đây là lựa chọn tối ưu tuyệt đối.

## 7. VIỆC CẦN LÀM Ở PHIÊN TIẾP THEO (theo thứ tự)

1. **Xác nhận với người dùng cấu hình cuối**: Max_it=180/Nrun=20/Npop=100 (~32 ngày) hay phương án khác (bảng mục 6). Không tự quyết một mình.
2. Sau khi chốt: viết script campaign thật cho cả 6 case (BD-C, BD-D, MD-C, MD-D, MPJ-C, MPJ-D), mỗi case Nrun run độc lập, dùng `runMode='full'` nhưng **cần sửa lại `Max_it` trong switch-case của cả 3 driver nếu chốt số khác 300** (hiện `'full'` case đang hardcode Max_it=300 — nếu chốt 180 thì phải sửa case này hoặc thêm case mới, ví dụ `'campaign'`).
3. Smoke-test nhanh Displacement objective (objCol=2) cho cả 3 hệ trước khi chạy thật — **chưa hề test Displacement**, chỉ mới test Cost. Rủi ro: hành vi hội tụ/batch-cost có thể khác Cost.
4. Chạy campaign thật bằng cơ chế tách-tiến-trình đã kiểm chứng (mục 4.2) — **KHÔNG dùng Bash `run_in_background`** cho job nhiều ngày. Cần dùng `.bat` wrapper + `Start-Process -WindowStyle Hidden`, log ra file, và tự kiểm tra `results/*_progress.log` định kỳ (không có task-notification tự động).
5. Theo dõi tiến độ: đọc `results/<Case>_<Obj>_progress.log` mỗi lần người dùng hỏi hoặc định kỳ hợp lý — file này là nguồn sự thật, sống sót qua gián đoạn.
6. Khi đủ dữ liệu: tổng hợp Best/Mean/Max/STD/CV, 2 nghiệm cực trị mỗi hệ, so sánh thiết kế hiện tại, bảng cross-objective trade-off — điền vào các bảng `[TBD]` trong [02_Draft_SOO_SFOA_Marine_Jetty_TCXD.md](02_Draft_SOO_SFOA_Marine_Jetty_TCXD.md).
7. (Việc tồn đọng từ phiên trước, chưa làm) Sửa mục 1.1 draft: xác nhận số cọc BD thật là **19** (không phải 9 như outline) — mô hình SAP2000 `Sap_BD_HL_v3.m` có D1...D19.
8. (Việc tồn đọng) Bổ sung tên tác giả/đơn vị công tác thật, trích dẫn đầy đủ tài liệu [2] (bài MOO/MOSFOA nền, hiện là placeholder).
9. Cân nhắc đưa phát hiện "batch-cost tăng khi hội tụ" (mục 5) vào phần "Hiệu quả tính toán" (mục 13.5 outline) của bài báo — đây là quan sát thật, có giá trị khoa học, không phải hạn chế cần giấu.

## 8. Bản đồ file quan trọng (cập nhật)

| File | Vai trò |
|---|---|
| [SESSION_HANDOFF_2026-08-13.md](SESSION_HANDOFF_2026-08-13.md) | Bàn giao phiên trước — mục tiêu, draft, outline, phát hiện pipeline MOO |
| [01_SO0_SFOA_Marine_Jetty_TCID_Outline.md](01_SO0_SFOA_Marine_Jetty_TCID_Outline.md) | Đề cương (Npop/Max_it/Nrun gốc = 100/300/30, không còn khóa cứng theo ý người dùng) |
| [02_Draft_SOO_SFOA_Marine_Jetty_TCXD.md](02_Draft_SOO_SFOA_Marine_Jetty_TCXD.md) | Bản thảo — Results còn TBD |
| [code/SOO_BD/SOO_BD_run.m](code/SOO_BD/SOO_BD_run.m) | Driver BD — có mode smoke/pilot/full |
| [code/SOO_MD/SOO_MD_run.m](code/SOO_MD/SOO_MD_run.m) | Driver MD — mới viết phiên này |
| [code/SOO_MPJ/SOO_MPJ_run.m](code/SOO_MPJ/SOO_MPJ_run.m) | Driver MPJ — mới viết, đã sửa bug 18-cột diagnostic |
| `code/SOO_BD/SOO_BD_calib.m`, `code/SOO_MD/SOO_MD_calib.m`, `code/SOO_MPJ/SOO_MPJ_calib.m` | Script đo t_FE phần cứng — không phải dữ liệu bài báo |
| `code/SOO_BD/test_single_sap.m` | Chẩn đoán SAP2000 đơn lẻ — có thể xóa |
| [code/run_pilots_MD_MPJ.bat](code/run_pilots_MD_MPJ.bat) | Wrapper chạy pilot MD+MPJ tách tiến trình — mẫu cho campaign thật |
| `code/pilot_log.txt`, `code/pilot_log_err.txt` | Log pilot MD+MPJ (đã xong) |
| `code/SOO_BD/results/BD_Cost_progress.log`, `code/SOO_MD/results/MD_Cost_progress.log`, `code/SOO_MPJ/results/MPJ_Cost_progress.log` | Log tiến độ pilot từng hệ — nguồn dữ liệu hội tụ thật |
| `code/SOO_MD/results/MD_SOO_Cost_run901_PILOT.mat`, `code/SOO_MPJ/results/MPJ_SOO_Cost_run901_PILOT.mat` | Kết quả pilot đã lưu đầy đủ (BD không có .mat vì bị ngắt giữa chừng) |

---
*File này do Claude tạo để bàn giao giữa 2 phiên chat. Phiên mới nên đọc file này (và file 08-13 nếu cần thêm bối cảnh mục tiêu/draft) trước, sau đó đọc trực tiếp các file trong mục 8 nếu cần chi tiết.*
