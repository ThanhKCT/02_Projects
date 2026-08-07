# Tóm tắt bối cảnh dự án — So sánh MOPSO / MOWAA / MOFDA (khung thép 2D qua SAP2000)

> File này dùng để mang bối cảnh sang session Claude Code khác. Đọc file này là đủ để tiếp tục công việc mà không cần hỏi lại từ đầu.

## Mục tiêu dự án
So sánh 3 thuật toán tối ưu đa mục tiêu (MOPSO, MOWAA, MOFDA) cho bài toán tối ưu khung thép phẳng 2D, dùng SAP2000 COM API để phân tích kết cấu, kiểm tra theo TCVN 5575:2024. Kết quả dùng để viết bài báo hội nghị khoa học (đăng kỷ yếu Lecture Notes, dạng CIGOS/ICSCEA).

**Thư mục làm việc:** `D:\1_MATLAB\claude - V2` (bản chính hiện dùng). Còn 1 bản cũ chưa đồng bộ ở `H:\My Drive\1. MATLAB\claude - V2` — không dùng nữa.

## Kiến trúc code hiện tại (đã dọn trùng lặp)
- `ProblemDefinition.m` — không gian biến thiết kế chung (8 biến, cận trên/dưới) cho cả 3 thuật toán.
- `CommonAlgParams.m` — nguồn tham số chung: `PopSize=50`, `ArchiveSize=100`, `MaxNFE=2550` (dựa trên `MaxIt_reference=50`).
- `ComputeKneePoint.m`, `SapStart.m`, `SapStop.m` — hàm dùng chung (trước đây lặp lại 3 lần trong 3 file Main).
- `MasterVerbose.m` — cờ verbose dạng hàm (tránh bị `clear` xóa mất).
- `Main_MOPSO_SAP2000.m`, `Main_MOWAA_SAP2000.m`, `Main_MOFDA_SAP2000.m` — đã chuyển từ **script sang function** `function [costs, Knee, elapsedSec] = Main_XXX_SAP2000(saveFileName)` để workspace độc lập, chạy lặp an toàn trong batch.
- `Master_Controller.m` — chạy tuần tự 3 thuật toán bằng gọi hàm trực tiếp, `taskkill` SAP2000 giữa các lần, gọi `Plot_Results` cuối.
- `ParetoFilterCosts.m` — lọc nghiệm không trội từ ma trận cost bất kỳ, dùng để tạo "mặt trận tham chiếu" (vì bài toán kỹ thuật thật không có Pareto front lý thuyết).
- `ExportAlgParams.m` — xuất bảng tham số 3 thuật toán ra `ThamSo_3ThuatToan.csv`, cảnh báo nếu NFE lệch >5%.
- `ComparePerformance.m` — so sánh nhanh 1 lần chạy (Hypervolume, Spacing, GD, IGD) từ `Data_MOPSO/MOWAA/MOFDA.mat`, xuất `SoSanh_HieuNang_1Lan.csv`.
- `BatchRun_N.m` — chạy N=10 lần độc lập/thuật toán (30 lần chạy tổng), lưu vào `BatchResults/`, resumable (bỏ qua file đã có).
- `AnalyzeBatchResults.m` — tổng hợp N lần chạy: trung bình±độ lệch chuẩn các chỉ số, mặt trận Pareto "gộp" (hợp nhất N lần + lọc lại) cho hình bài báo, boxplot Hypervolume/IGD.
- `Plot_Results.m` — vẽ Pareto 3 thuật toán, trục X=Khối lượng (kg, nhân STEEL_DENSITY=7850), trục Y=Chuyển vị (mm, nhân 1000), có nối đường mượt qua các điểm.

## Các lỗi/quyết định kỹ thuật quan trọng đã xử lý

1. **Bug `VERBOSE_MASTER` bị xóa** — do `Main_*.m` là script có `clear` chạy qua `run()` trong cùng workspace → sửa bằng cách chuyển hết sang function + tạo `MasterVerbose()`.
2. **`taskkill` không nhận trong MATLAB** — phải gọi qua `system('taskkill ...')`.
3. **MATLAB crash khi chạy MOFDA** — do bất ổn COM/SAP2000; xử lý bằng restart MATLAB, chạy lại riêng phần bị lỗi.
4. **MOFDA có Pareto front hẹp/bị trội (đã fix)** — nguyên nhân: cắt `max_iter` 50→10 cho MOFDA để cân bằng NFE đã phá vỡ lịch trình explore/exploit phụ thuộc `iter/max_iter` (biến `delta`) → hội tụ sớm. **Đã sửa đúng:** giữ `max_iter=50`, giảm `alpha_pop≈10` thay vào đó. User đã xác nhận qua kết quả chạy lại (front rộng ra 2000→4200kg).
5. **Tăng `ArchiveSize` 50→100** — miễn phí (không tốn thêm NFE), giúp front dày/mượt hơn.
6. **N=10 (không phải 30) cho batch run** — vì mỗi lần chạy ~40-45 phút (SAP2000 phân tích thật), N=30 sẽ mất ~65-70 giờ; N=10 (~22 giờ dự tính ban đầu) là mức chấp nhận phổ biến cho bài báo tối ưu kết cấu ghép FE/SAP2000.
7. **[MỚI - QUAN TRỌNG] Bug `SapStop.m` làm rò rỉ tiến trình SAP2000 — đã fix (2026-07-30):**
   `SapObject.ApplicationExit()` bị gọi **thiếu tham số bắt buộc** `(bool FileSave)` của SAP2000 API → COM luôn ném lỗi ngay lập tức → nhảy vào `catch` → `delete(SapObject)` không bao giờ chạy → SAP2000 không đóng thật, để lại tiến trình "mồ côi" (ẩn, `Visible=false` nên không thấy cửa sổ) sau **mỗi lần chạy**. Phát hiện qua Task Manager: sau 8 lần chạy batch có tới 4 nhóm tiến trình `SAP2000 (2)` cùng lúc (1 đang chạy thật + 3 zombie), làm RAM tích lũy dần → mỗi lần chạy chậm dần (từ ~44 phút lên ~83 phút/lần, gấp đôi). Bằng chứng: log `"=> Cảnh báo: SAP2000 đã được đóng trước đó."` xuất hiện ở 100% các lần chạy kể từ đầu — không phải ngẫu nhiên mà là lỗi chắc chắn.
   **Đã sửa:** `SapObject.ApplicationExit(false);` (truyền rõ tham số `false` = không lưu file khi thoát). Sửa trực tiếp trên file `SapStop.m`, MATLAB tự đọc lại ở lần gọi kế tiếp, không cần dừng batch đang chạy.
   **Xử lý tạm thời đã hướng dẫn:** End Task thủ công 3 tiến trình SAP2000 zombie (idle, 0% CPU) qua Task Manager để giải phóng RAM ngay, giữ lại tiến trình đang có CPU cao (đang chạy thật).

## Trạng thái batch run hiện tại (tính đến 2026-07-30)
- Đang chạy `BatchRun_N.m` (N=10/thuật toán, 30 lần tổng), thứ tự: MOPSO trước, rồi MOWAA, rồi MOFDA.
- Tại thời điểm dừng lại: đã hoàn thành 7/10 lần MOPSO, đang chạy lần 8/10 MOPSO.
- Sau khi fix bug SapStop, các lần chạy tiếp theo (từ lần 8 hoặc 9 trở đi) sẽ không còn tích lũy zombie, kỳ vọng tốc độ trở lại ~44-45 phút/lần.
- Script an toàn để dừng/chạy lại (resumable, bỏ qua file `.mat` đã có trong `BatchResults/`).

## Kết quả gần nhất (1 lần chạy đơn lẻ, từ `ComparePerformance.m`, CHƯA có kết luận thống kê — cần đợi batch N=10 xong)
| Thuật toán | SoNghiemPareto | Hypervolume% | GD | IGD |
|---|---|---|---|---|
| MOPSO | 100 | 42.1 (cao nhất) | 0 | 0 |
| MOWAA | 100 | 34.6 | 0.0152 | 0.0112 |
| MOFDA | chỉ 10 | 12.3 (thấp nhất) | 0.0543 | 0.0893 |

- MOPSO's front = chính mặt trận tham chiếu (GD=IGD=0) → hiện đang mạnh nhất trong lần chạy đơn lẻ này.
- MOFDA chỉ sinh 10 nghiệm không trội (dù ArchiveSize cho phép 100) — có thể là hạn chế thật của thuật toán này với quần thể nhỏ (~10 cá thể), **cần xác nhận qua kết quả batch N=10 trước khi kết luận trong bài báo** (chưa chắc là bug, có thể là đặc tính thật).
- Spacing của MOFDA thấp hơn không có nghĩa "tốt hơn" — chỉ số này không chuẩn hóa, front ít điểm/co cụm tự nhiên có Spacing nhỏ.

## Việc còn lại (chưa làm)
1. Chờ `BatchRun_N.m` chạy xong hết 30 lần (đã fix bug làm chậm, nên nhanh hơn ước tính ban đầu ~22h).
2. Chạy `AnalyzeBatchResults.m` để có kết luận thống kê đáng tin cậy (trung bình±độ lệch chuẩn, mặt trận gộp, boxplot) cho bài báo.
3. Xem xét kết quả nhiều lần chạy có xác nhận MOFDA yếu hơn một cách hệ thống hay không (SoNghiemPareto thấp, Hypervolume/GD/IGD kém) — nếu có, quyết định: báo cáo như phát hiện thật, hay điều chỉnh thêm tham số MOFDA.
4. Không có việc nguy hiểm/không thể đảo ngược nào đang chờ.
