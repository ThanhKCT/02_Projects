# Kinh nghiệm từ dự án Kè (SFOA + SAP2000-in-loop) — để bắt đầu dự án mới

> Dự án mới: SFOA tối ưu **thể tích bê tông cọc**, trên 1 model SAP2000 khác (tốt hơn model Kè). File này tổng hợp bài học từ dự án Kè — đọc trước khi viết dòng code đầu tiên của dự án mới.
>
> **Đọc cả file [`Cach ket noi_SAP2000_MATLAB_OPTIMIZATION.md`](Cach%20ket%20noi_SAP2000_MATLAB_OPTIMIZATION.md) cùng thư mục** — đó là file tổng hợp kỹ thuật SAP2000↔MATLAB dùng chung cho mọi dự án, vừa được cập nhật thêm các mục 6.6–6.11 và checklist từ chính dự án Kè. File này (bạn đang đọc) chỉ nói phần **khác/riêng** và bài học **quy trình làm việc**, không lặp lại nội dung kỹ thuật đã có bên đó.

## 0. Bài học số 1 — quan trọng hơn mọi bug kỹ thuật

Dự án Kè mất phần lớn thời gian không phải vì SFOA hay vì COM automation khó, mà vì **gỡ đồng thời 2 loại lỗi cùng lúc**: lỗi ở chính model SAP2000 (section khai báo sai kiểu, dẫn tới "structure unstable") và lỗi ở code/automation (thứ tự cột kết quả, quote lệnh PowerShell). Khi một lần chạy cho kết quả vô lý, không thể biết ngay là do model hay do code — mỗi lần chẩn đoán phải loại trừ cả hai phía.

**Vì bạn nói model SAP2000 mới "ổn hơn"** — đừng chỉ tin theo cảm giác. Trước khi viết bất kỳ dòng MATLAB automation nào:

1. Mở model trên GUI, chạy phân tích tay với ít nhất 1 tổ hợp tải thật.
2. Xuất bảng nội lực/chuyển vị ra Excel trực tiếp từ GUI cho tổ hợp đó — đây sẽ là **ground truth** để đối chiếu code sau này (xem mục 6.7 file chung).
3. Kiểm tra từng section property quan trọng (đặc biệt loại shell: Membrane vs Shell-Thin/Thick — xem mục 6.6 file chung) — đừng suy đoán dựa trên việc model "đã dùng để thiết kế trước đó".
4. Chỉ sau khi chuyển vị/nội lực tay hợp lý và khớp kỳ vọng kỹ thuật, mới bắt đầu viết `Sap_<TenBaiToan>.m`.

Nếu làm ngược lại (viết automation trước, phát hiện bug thì sửa cả hai phía cùng lúc), sẽ lặp lại chính xác những gì đã xảy ra ở dự án Kè.

## 1. Kiến trúc đã dùng ở Kè — và khi nào KHÔNG nên copy nguyên xi

Dự án Kè dùng kiến trúc **tuần tự, 1 phiên SAP2000 duy nhất cho cả 1 run SFOA** (mở 1 lần ở đầu run, giữ nguyên qua toàn bộ Npop×(Max_it+1) lần đánh giá, chỉ update property qua `SetShell_1`/tương đương rồi `RunAnalysis` lại — không mở/đóng file mỗi lần đánh giá). Khác với kiến trúc `spmd`/nhiều worker song song mô tả ở mục 1, 3 của file chung (mỗi worker 1 instance SAP2000 riêng).

**Vì sao chọn tuần tự ở Kè**: bài toán chỉ 3 biến thiết kế (X1 cu, X2 bản đáy, X3 tường mặt), Npop=15 — song song hóa không đáng để thêm độ phức tạp COM (nhiều instance SAP2000 đồng thời từng gây nghi ngờ ổn định COM trong dự án khác). Đổi lại: **mỗi lần đánh giá tốn ~30-40s** (đo thực tế), 1 run 15×16=240 lần đánh giá ≈ 2-2.5 giờ, 5 run ≈ 10-12 giờ.

**Cân nhắc cho dự án mới**: nếu bài toán thể tích bê tông cọc có nhiều biến hơn (đường kính cọc, chiều dài cọc, số lượng cọc, bố trí...) và cần Npop/Max_it lớn hơn để hội tụ tốt, thời gian tuần tự có thể kéo dài quá mức chấp nhận được (>1-2 ngày) — khi đó nên cân nhắc kiến trúc song song `spmd` như file chung mục 1-3, dù phức tạp hơn. **Luôn đo t_FE thật (thời gian 1 lần đánh giá) trước, rồi nhân ra tổng thời gian dự kiến, mới quyết định có cần song song hay không** — đừng mặc định.

## 2. Đặc thù khi mục tiêu = thể tích bê tông cọc

Đây là điểm khác biệt lớn nhất so với mục tiêu "chuyển vị lớn nhất" của dự án Kè — vài gợi ý dựa trên kinh nghiệm Kè:

- **Thể tích bê tông cọc thường TÍNH TRỰC TIẾP được từ biến thiết kế** (V = N_cọc × π/4 × D² × L, hoặc theo tiết diện cọc thật nếu không tròn) — **không cần đọc qua SAP2000** để lấy giá trị này. Chỉ cần SAP2000 để **kiểm tra ràng buộc** (chuyển vị, ứng suất, khả năng chịu tải của cọc, chọc thủng...) khi D/L/N thay đổi. Tách rõ 2 phần này trong hàm mục tiêu (`fit = Vconcrete + penalty(constraint_violations)`), giống mẫu `fit(ix) = MaxDisplacement_mm + penalty` của Kè nhưng đổi objective.
- **Cẩn thận ràng buộc "đảo chiều"**: ở Kè, mục tiêu là GIẢM chuyển vị (an toàn thường tăng theo kích thước tiết diện, nên penalty giữ optimizer không "ăn gian" bằng cách giảm tiết diện quá mức). Với mục tiêu GIẢM thể tích bê tông, optimizer sẽ có xu hướng chọn D/L nhỏ nhất có thể — **áp lực lên các ràng buộc sẽ mạnh hơn hẳn** (nhiều cá thể vi phạm gần biên hoặc vượt biên khả năng chịu tải cọc, chọc thủng bản đáy...). Cần test kỹ penalty coefficient đủ lớn để không cho "lẻn qua" cá thể vi phạm nhẹ nhưng thể tích nhỏ.
- **Ràng buộc bearing capacity cọc (TCVN 10304:2014) gần như chắc chắn là ràng buộc chính**, không phải phụ như ở Kè (nơi pile bearing hầu như luôn thỏa). Nên implement và verify ràng buộc này **đầu tiên**, kỹ nhất — dùng lại code `pile_bearing_capacity.m` đã có sẵn trong `code/Pile_TCVN10304_2014/` nếu áp dụng được, đã verify từ trước.
- **Đỉnh giá trị giả tại đầu cọc** (mục 6.11 file chung) gần như chắc chắn sẽ gặp lại nếu kiểm tra cắt/chọc thủng bản đáy quanh cọc — chuẩn bị sẵn logic loại trừ theo tiết diện nguy hiểm (cách MẶT cọc, không phải tâm) ngay từ đầu, đừng đợi phát hiện ra bug rồi mới thêm như ở Kè.

## 3. Watchdog — dùng lại nguyên bản, đã verify ổn định

Sau khi sửa xong bug ArgumentList, `code/SOO_Ke/run_sap_watchdog.ps1` và `code/SOO_Ke/SOO_Ke_run_SAP.m` (phần checkpoint/resume, dòng ~40-270) đã chạy ổn định — copy nguyên khung này sang dự án mới, chỉ đổi:
- Đường dẫn `.sdb` và tên hàm mục tiêu (`Sap_Ke` → `Sap_<TenMoi>`)
- `DiagnosticColumns` cho khớp ràng buộc mới
- Giữ nguyên: cơ chế checkpoint mỗi iteration, idempotent-skip theo `finalName`, watchdog poll 45s / hang sau 3 lần flat, `-ArgumentList` dạng chuỗi (không mảng) khi gọi `matlab.exe`.

**Đã verify thực tế 2026-08-28**: watchdog resume đúng từ checkpoint sau khi bị kill giữa chừng (test bằng cách đổi `Nrun=5`→`Nrun=1` giữa lúc đang chạy iteration 4/15 — resume đúng tại T=5/15, không mất tiến độ, không chạy lại từ đầu).

## 4. Checklist khởi động dự án mới (thứ tự ưu tiên)

1. [ ] Xác thực model SAP2000 mới độc lập trên GUI trước (mục 0 ở trên) — **không bỏ qua bước này dù model "có vẻ ổn hơn"**.
2. [ ] Xuất ít nhất 1 bảng kết quả ground-truth từ GUI (nội lực bản đáy quanh cọc, phản lực đầu cọc) để đối chiếu code sau này.
3. [ ] Viết `Sap_<TenMoi>.m`: objective = thể tích bê tông cọc (tính trực tiếp từ biến, không qua SAP2000), constraint = đọc từ SAP2000 (bearing capacity cọc ưu tiên số 1, sau đó chuyển vị/ứng suất/cắt/chọc thủng).
4. [ ] Đối chiếu MỌI API đọc kết quả nhiều cột với export GUI + 1 điểm biết trước (mục 6.7 file chung) — làm ngay từ đầu, đừng đợi kết quả "trông sai sai" mới đi tìm.
5. [ ] Đo t_FE thật (1 lần đánh giá) → quyết định kiến trúc tuần tự hay song song (mục 1 ở trên).
6. [ ] Chạy smoke test (Npop nhỏ, Max_it=1) → pilot thật ở đúng Npop dự kiến → mới chạy campaign chính (mục 4, 5 file chung).
7. [ ] Copy khung watchdog + checkpoint/resume từ `SOO_Ke_run_SAP.m`/`run_sap_watchdog.ps1`, đổi tên hàm/đường dẫn (mục 3 ở trên).
8. [ ] Sau khi có kết quả, đối chiếu lại với thiết kế/tài liệu tham khảo bằng giá trị định lượng, không suy đoán quy ước (mục 6.3 file chung).
