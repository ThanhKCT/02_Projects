# Bàn giao phiên làm việc — 2026-08-21 — Bài báo SOO-SFOA (Tạp chí Xây dựng)

> Đọc file này ở đầu phiên chat mới. Các file bàn giao trước: [SESSION_HANDOFF_2026-08-13.md](SESSION_HANDOFF_2026-08-13.md), [SESSION_HANDOFF_2026-08-15.md](SESSION_HANDOFF_2026-08-15.md) — vẫn còn giá trị lịch sử (mục tiêu gốc, quyết định thu hẹp phạm vi), nhưng **file này là bản cập nhật mới nhất và đầy đủ nhất** — nếu có mâu thuẫn, tin theo file này.

## 1. TRẠNG THÁI: BÀI BÁO ĐÃ HOÀN THIỆN VỀ NỘI DUNG KHOA HỌC

Khác với 2 phiên trước (còn đang chạy thực nghiệm), phiên này đã **hoàn tất toàn bộ vòng đời**: chốt phạm vi → chạy campaign thật → tổng hợp số liệu → đối chiếu chéo với bài nền → viết bản thảo Word hoàn chỉnh. Không còn việc tính toán nào phải chạy. Việc còn lại chỉ là biên tập/xác nhận thông tin con người (tên tác giả, tạp chí đích của tài liệu [2]).

## 2. QUYẾT ĐỊNH PHẠM VI CUỐI CÙNG (đã chốt, không đổi nữa)

Bài báo **chỉ khảo sát MJP (Main Jetty Platform)** — bỏ hẳn BD và MD khỏi phạm vi (khác đề cương gốc 3 hệ/6 case). Lý do: campaign 6-case cũ (Npop=30, Nrun=10) đã khởi động ngày 15/08 nhưng chết giữa chừng do gián đoạn hệ thống, chỉ xong 7/60 run sau 35h không giám sát. Quyết định lại: tập trung toàn bộ ngân sách thời gian cho MJP để đạt **Nrun=30 (chuẩn vàng đầy đủ)** thay vì dàn trải 3 hệ với Nrun thấp. MJP được chọn vì là hệ kết cấu chính trong 3 hệ của bài MOO/MOSFOA nền.

**Cấu hình cuối cùng đã chạy thật và có kết quả:** Npop=30, Nrun=30/objective, Max_it=150 (xác nhận bằng pilot thật ở đúng Npop=30, không phải ngoại suy) — tổng 60 run (30 Cost + 30 Displacement).

## 3. KẾT QUẢ THỰC NGHIỆM — SỐ LIỆU THẬT, ĐÃ CÓ TRONG BẢN THẢO

| Case | Best | Mean | Max | STD | CV(%) |
|---|---|---|---|---|---|
| MJP-Cost | 5.291,8573 | 8.012,5085 | 10.073,9390 | 1.440,4557 | 17,98 |
| MJP-Displacement | 0,0000388 | 0,0000388 | 0,0000388 | 0,0000000 | 0,00 |

- **MJP-Displacement hội tụ tuyệt đối trên cả 30/30 run** (CV=0%) — độ ổn định hoàn hảo.
- Nghiệm cost-optimal (cọc 300-A, D=300mm) và displacement-optimal (cọc 1200-C, D=1200mm) khác biệt hoàn toàn — xung đột mục tiêu rõ ràng: ưu tiên displacement làm cost tăng **2.542%**; ưu tiên cost làm displacement tăng 96,2% (nhưng vẫn ở bậc mm).
- So với thiết kế hiện tại (cọc 500-B, L=38m, Cost=25.708,94 USD, Disp=0,00022445m): SFOA-C rẻ hơn 79,4%; SFOA-D cứng hơn 82,7% nhưng đắt 4,4 lần.

### Phát hiện đối chiếu chéo quan trọng (kiểm chứng độc lập mô hình)
Đối chiếu với `paper/02_MOSFOA.docx` (bài MOO/MOSFOA nền — tác giả **Thanh Do-Quang, T. Vu-Huu, Thanh Cuong-Le**, Vietnam Maritime University & HCMC Open University):
- **Nghiệm MJP-Displacement của tôi khớp tuyệt đối tới từng chữ số** với thiết kế "III" (E-MOSFOA, cọc 1200-C) trong Bảng 12 của bài nền: Cost=139.831,48 USD, Displacement=0,00003877 m — cả hai giống hệt nhau.
- Phát hiện lỗi tự đoán ban đầu: pile index dùng sai (16 → đúng phải là **17**), chiều dài cọc hiện tại sai (39m → đúng phải là **38m**). Sau khi sửa, chạy lại đúng cấu hình cho kết quả khớp gần như tuyệt đối với Bảng 12 (25.708,9425 vs 25.708,94 USD).
- **Đơn vị Cost = USD** (không phải VNĐ) — xác nhận trực tiếp từ bài nền (P_cr=46,25 USD/m³, P_st=0,57 USD/kg).
- Ký hiệu cọc (300-A, 500-B, 1200-C...) xác định bằng cách khớp đơn giá USD/m với Bảng 12, không tự suy đoán quy ước cấp thép A/B/C/D.

## 4. FILE ĐẦU RA CHÍNH (deliverables)

| File | Vai trò |
|---|---|
| [02_Draft_SOO_SFOA_Marine_Jetty_TCXD.md](02_Draft_SOO_SFOA_Marine_Jetty_TCXD.md) | Bản thảo Markdown — nguồn nội dung chính, đầy đủ số liệu thật |
| `paper/02_Draft_SOO_SFOA_Marine_Jetty_TCXD.docx` | **Bản Word đã format theo thể lệ Tạp chí Xây dựng** (A4, Myriad Pro 9, lề 3/2/1,8/1,3cm, đã chèn Bảng 1-5 + Hình 1-2) — đã gửi cho người dùng, đây là bản để nộp sau khi hoàn tất mục 5 |
| `paper/build_docx.js` | Script Node.js (dùng npm package `docx`) tạo ra file .docx trên — sửa nội dung ở đây rồi `node build_docx.js` để tái tạo nếu cần đổi số liệu |
| `paper_figures/Hinh1_convergence.png`, `Hinh2_tradeoff.png` | 2 hình 300dpi, dựng từ MATLAB, đã chèn vào docx |
| `code/SOO_MPJ/results/MPJ_SOO_{Cost,Displacement}_run01..30_CAMPAIGN.mat` | Dữ liệu thô 60 run — nguồn của mọi số liệu trong bảng |
| `paper/02_MOSFOA.docx` | Bài MOO/MOSFOA nền — dùng để đối chiếu tác giả, đơn vị, thiết kế hiện tại (mục 3 trên) |

## 5. VIỆC CÒN LẠI — CHỈ CẦN NGƯỜI DÙNG XÁC NHẬN, KHÔNG CẦN CHẠY LẠI GÌ

1. **Tên tác giả + đơn vị công tác** — hiện đang là placeholder "abc" / "abc@gmail.com" theo yêu cầu tường minh của người dùng ("để tôi thay sau"). Cần sửa cả trong `.md` và `.docx` (hoặc sửa `build_docx.js` rồi build lại).
2. **Tài liệu tham khảo [2]** (bài MOO nền) — hiện ghi "Bản thảo đang chuẩn bị nộp / in preparation" vì `paper/02_MOSFOA.docx` chưa có tên tạp chí/số/năm. Cập nhật khi bài nền được nộp/công bố.
3. **Công thức (1)(2)(3) trong file .docx** — dựng bằng text + subscript/superscript qua docx-js, KHÔNG phải object MathType thật. Thể lệ tạp chí yêu cầu MathType — cần người dùng tự chuyển trong Word trước khi nộp.
4. Nên tự rà lại dàn trang thực tế trong Word (ngắt trang bảng/hình) — tôi không có công cụ render ảnh xem trước trên máy này (xem mục 7.3), chỉ xác nhận Word mở file không lỗi và xuất PDF được 6 trang.

## 6. BÀI HỌC KỸ THUẬT QUAN TRỌNG (áp dụng cho các phiên sau, nhất là nếu cần chạy lại campaign MATLAB dài hoặc dựng docx)

### 6.1. Cơ chế chống mất dữ liệu cho campaign MATLAB dài — ĐÃ XÂY DỰNG VÀ KIỂM CHỨNG THẬT
Đã thêm vào [code/SOO_MPJ/SOO_MPJ_run.m](code/SOO_MPJ/SOO_MPJ_run.m):
- Mỗi run tự **skip nếu đã có file kết quả** (idempotent) — watchdog chỉ cần gọi lại đúng 1 lệnh `Nrun=30, runIdOffset=0` bao nhiêu lần cũng được.
- **Checkpoint mỗi 20 vòng lặp** (ghi atomic qua `.tmp` + `movefile`) — nếu mất điện/crash giữa run, resume từ checkpoint gần nhất, tối đa mất ~20 vòng.
- File kết quả cuối cũng ghi atomic (`.tmp` + rename) trước khi xóa checkpoint.
- **Đã kiểm chứng SỐNG**: máy crash thật (Kernel-Power Event 41) đúng lúc pilot30 đang chạy — resume đúng từ checkpoint, không mất dữ liệu, không phải chạy lại từ đầu.

### 6.2. Watchdog tự relaunch — [code/run_mpj_campaign_watchdog.ps1](code/run_mpj_campaign_watchdog.ps1)
Tự động gọi lại MATLAB tới khi đủ Nrun mỗi case, tự dừng an toàn sau 5 lần liên tiếp không tiến triển (tránh crash-loop). Khóa bằng file cờ `code/CAMPAIGN_ACTIVE.flag` (đã đổi tên thành `CAMPAIGN_DONE.flag` khi xong — vô hại nếu để nguyên).

**BUG QUAN TRỌNG đã tìm & sửa**: PowerShell 5.1 `Start-Process -ArgumentList` khi truyền **mảng** (`@("-batch", $cmd)`) sẽ chỉ nối các phần tử bằng dấu cách rồi để Windows tách lại theo khoảng trắng — làm lệnh MATLAB bị cắt cụt ở dấu `;` đầu tiên, MATLAB thoát êm (exit 0, không lỗi, không output) sau ~12s. **Cách sửa đúng: truyền MỘT chuỗi đã tự quote** (`"-batch \"$cmd\""`), không dùng mảng. Đây là lỗi ẩn nguy hiểm — trông như "chạy xong không lỗi" nhưng thực ra không làm gì cả. Nếu thấy MATLAB batch thoát bất thường nhanh/không output khi gọi qua PowerShell `-ArgumentList`, kiểm tra ngay điều này trước.

### 6.3. Dựng file .docx theo thể lệ tạp chí — [paper/build_docx.js](paper/build_docx.js)
- Máy này **không có sẵn** npm package `docx` (khác với mô tả "preinstalled" của docx skill) → phải `npm install docx` trong thư mục `paper/` trước.
- Máy này **không có LibreOffice/poppler** (`pdftoppm`) → không dùng được quy trình render-ảnh-xem-trước chuẩn của docx skill. **Word đã cài sẵn** (`C:\Program Files\Microsoft Office\root\Office16\WINWORD.EXE`) — dùng PowerShell COM (`New-Object -ComObject Word.Application`) để mở file và `SaveAs(..., wdFormatPDF)` kiểm tra file không hỏng/đếm số trang. Việc render PDF→PNG qua WinRT `Windows.Data.Pdf` hoặc qua `EnhMetaFileBits` đều thất bại trên máy này (PowerShell 5.1 WinRT interop không ổn định) — nếu cần ảnh xem trước thật, cân nhắc cài LibreOffice trước.

### 6.4. Hiệu năng thật của campaign MPJ ở Npop=30
Đo được ~28s/vòng lặp (Num_work=11), **cao hơn ~33% so với ước tính ngoại suy ban đầu** (~21s, suy từ pilot Npop=100). Tổng thời gian thật cho 60 run (Max_it=150): ~67,3 giờ (~2,8 ngày) — nếu cần lặp lại kiểu campaign này cho hệ khác (BD/MD), nên dùng số đo thật này để ước tính, không dùng ngoại suy.

### 6.5. Máy này có vấn đề ổn định thật
Ghi nhận **3 lần crash bất thường trong 1 ngày** (Windows Event 41, "hệ thống khởi động lại không tắt sạch"). Nếu chạy job dài trong tương lai, nên đăng ký Task Scheduler tự relaunch watchdog khi đăng nhập lại (lệnh mẫu đã đưa người dùng ở phiên trước, xem SESSION_HANDOFF_2026-08-17 nếu còn — người dùng có thể chưa chạy lệnh này) và/hoặc kiểm tra nguồn điện/UPS vật lý của máy.

## 7. GHI CHÚ VẬN HÀNH KHÁC

- File cũ `MPJ_SOO_*_run01..30_PILOT30.mat` (kết quả pilot xác nhận Max_it=150) khác với `*_CAMPAIGN.mat` (dữ liệu bài báo chính) — không nhầm lẫn hai loại này.
- Toàn quyền tự chủ đã được người dùng cấp trong phiên này ("tôi cấp quyền hoàn toàn cho bạn") — **trừ** thay đổi cấu hình hệ thống Windows (Task Scheduler, auto-login...) — luôn đưa lệnh sẵn cho người dùng tự chạy, không tự ý thực thi.
