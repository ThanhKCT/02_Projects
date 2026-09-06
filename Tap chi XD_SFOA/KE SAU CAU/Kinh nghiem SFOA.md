# Kinh nghiệm từ dự án SFOA "Kè sau cầu" — tổng hợp lỗi đã gặp để rút kinh nghiệm cho dự án sau

> Viết sau khi dự án đã hoàn thành (tối ưu SAP2000–MATLAB–SFOA cho kè sau cầu bến bệ cọc cao, thể tích bê tông tối ưu 231,16 m³, bài báo đã chốt gửi Tạp chí Xây dựng). File này bổ sung cho hai file kinh nghiệm đã có sẵn — **đọc trước cả hai file đó** rồi mới đọc file này (file này chỉ ghi những gì MỚI phát sinh trong giai đoạn cuối dự án, chưa có ở hai file kia):
> - `KINH_NGHIEM_TU_DU_AN_KE_SFOA.md` (cùng thư mục) — bài học từ dự án Kè trước đó.
> - Memory `sap2000-matlab-optimization-lessons` (Claude) / file `Cach ket noi_SAP2000_MATLAB_OPTIMIZATION.md` (dự án MOFDA) — bài học kỹ thuật SAP2000↔MATLAB dùng chung.

---

## 1. SAP2000 COM automation — bug mới phát hiện lần này

### 1.1. Hộp thoại "recent analysis results ... not flagged as compatible" chặn tự động hóa vô thời hạn

**Triệu chứng**: `SM.File.OpenFile(sdbPath)` treo vô thời hạn (không lỗi, không log) sau khi watchdog restore `.sdb` từ bản baseline sạch và mở lại — một hộp thoại Windows thật xuất hiện hỏi có muốn phục hồi kết quả phân tích cũ hay không, và vì chạy không giám sát (watchdog/-r) nên không ai bấm được.

**Nguyên nhân thật** (đã tốn ~30 phút chẩn đoán sai trước khi tìm đúng): KHÔNG phải do bản thân file `.sdb` baseline có cờ lỗi — mở trực tiếp file baseline trong 1 phiên SAP2000 độc lập cho `ret=0` ngay lập tức, không có hộp thoại. Nguyên nhân thật là **các file "sản phẩm phân tích"** cùng tên gốc (`<tên>.K_0`, `.K_I`, `.K_J`, `.K_M`, `.LOG`, `.OUT`, `.Y`, `.Y$$`, `.Y00`-`.Y03`, `.Y_`, `.Y_1`, `.msh`) — SAP2000 tự tái tạo các file này sau MỖI lần `RunAnalysis`, khớp với hình học/trạng thái model *lúc đó*. Khi watchdog copy `.sdb` baseline đè lên file làm việc (đổi hình học về as-built) nhưng KHÔNG xóa các file sản phẩm cũ (vẫn khớp hình học của lần chạy ngay trước khi crash/restart), SAP2000 phát hiện lệch giữa `.sdb` vừa nạp và kết quả phân tích cũ còn sót lại → bật hộp thoại.

**Bài học bắt buộc**: đây KHÔNG phải sự cố một lần — nó có thể tái diễn ở **MỌI lần watchdog phải restart** (RAM thấp, treo, crash) trong suốt campaign, không chỉ lần đầu. Sửa triệt để bằng cách xóa các file sản phẩm phân tích kể trên NGAY SAU MỖI LẦN restore `.sdb` từ baseline, TRƯỚC KHI gọi `OpenFile` (không phải chỉ lần đầu). Đã vá vào `watchdog_run.ps1` — copy nguyên khối logic này (đoạn xóa file `$targetBase.<ext>` cho từng phần mở rộng trên) sang mọi dự án dùng lại cơ chế watchdog + pristine-baseline-restore.

**Cách chẩn đoán nhanh nếu gặp lại**: mở 1 phiên SAP2000 độc lập, `OpenFile` trực tiếp file baseline (không qua watchdog) — nếu `ret=0` ngay, tức bản thân `.sdb` baseline sạch, nghi ngờ chuyển sang các file sản phẩm phân tích cùng thư mục thay vì nghi ngờ file `.sdb`.

### 1.2. `Add-Content`/ghi log bị lỗi "process cannot access the file" do một tiến trình KHÁC đang `tail -F` cùng file đó

**Triệu chứng**: watchdog log ra lỗi `IOException: The process cannot access the file '...' because it is being used by another process` khi cố ghi log, dù không có tiến trình MATLAB/SAP2000/watchdog nào khác đang chạy.

**Nguyên nhân**: một session Monitor/bash khác đang chạy `tail -n0 -F <cùng file log>` để theo dõi tiến độ — `tail -F` của git-bash/MSYS coreutils trên Windows giữ file handle mở theo kiểu **chặn ghi từ tiến trình khác** (khác hành vi POSIX thật trên Linux), nên bất kỳ tiến trình nào khác cố mở file đó để ghi (kể cả `Add-Content` của PowerShell) sẽ thất bại.

**Bài học**: trên Windows, **KHÔNG dùng `tail -F` / `Get-Content -Wait`** để theo dõi một file log mà một tiến trình KHÁC vẫn đang tích cực ghi vào — dùng vòng lặp polling (mở/đóng file mỗi lần poll, ví dụ `wc -l` + `tail -n <N-cũ>` mỗi 15-20s) thay vì giữ file mở liên tục. Áp dụng cho mọi Monitor/theo dõi log trong các dự án SAP2000-in-the-loop sau này (watchdog luôn ghi log liên tục suốt nhiều giờ).

### 1.3. Các bug đã biết từ trước vẫn đúng, xác nhận lại lần nữa
- Luôn dùng `matlab -r` (không `-batch`) cho bất kỳ script nào chạm SAP2000 OAPI qua COM; gọi bằng `run('script.m')`, không gọi bareword `script.m;` (bareword treo `-r` vô thời hạn).
- Luôn kiểm tra `ret` của mọi setter OAPI (`SetShell_1`, `RunAnalysis`...) — COM không throw exception khi fail.
- `AreaForceShell` có đúng 25 output — đếm lại token mỗi lần dùng, đừng copy-paste rồi tin tưởng.

---

## 2. Vận hành watchdog / môi trường Windows — bug mới phát hiện lần này

### 2.1. `TaskStop` một wrapper KHÔNG chắc đã kill hết tiến trình con lồng bên trong

Khi dừng một background task đang chạy `powershell -Command "... ; powershell -File watchdog_run.ps1 ..."`, `TaskStop` chỉ đảm bảo dừng đúng tiến trình wrapper NGOÀI CÙNG — tiến trình `powershell -File watchdog_run.ps1` LỒNG BÊN TRONG có thể vẫn sống sót độc lập (đã xác nhận thực tế: watchdog cũ vẫn ghi log tiếp sau khi `TaskStop` báo thành công). Tương tự, MATLAB/SAP2000 do watchdog đó mở ra cũng có thể còn sống.

**Bài học**: sau MỌI lần `TaskStop`/kill một tiến trình liên quan tới SAP2000-MATLAB, **luôn xác minh lại** bằng `Get-CimInstance Win32_Process -Filter "Name='powershell.exe'" | Where CommandLine -match "watchdog_run"` và `Get-Process MATLAB,SAP2000` trước khi relaunch — đừng tin tưởng riêng thông báo "Successfully stopped".

### 2.2. Sửa file `.ps1` trên đĩa KHÔNG ảnh hưởng tiến trình ĐANG CHẠY của chính file đó

PowerShell nạp toàn bộ script vào bộ nhớ khi bắt đầu chạy — sửa file `.ps1` trên đĩa sau đó không làm tiến trình đang chạy dùng logic mới. Muốn áp dụng bản vá, **phải kill + relaunch**, không chỉ sửa file rồi chờ.

### 2.3. Restart phiên/host (Claude Code process) có thể âm thầm giết tiến trình con (MATLAB/SAP2000) đang tính toán dở

Gặp 1 lần: watchdog + MATLAB + SAP2000 đang chạy bình thường (đã qua 49/50 vòng lặp), nhưng sau khi phiên làm việc (session) bị khởi động lại, khoảng trống ~4 giờ xuất hiện trong log và không còn tiến trình MATLAB/SAP2000 nào chạy nữa — dù không có lỗi nào được ghi lại (tiến trình bị giết từ bên ngoài, không phải crash tự nhiên).

**Bài học**: khi nhận được thông báo dạng "N background task(s) từ phiên trước không có completion record / may have been running when the process exited", **đừng giả định chúng vẫn đang chạy** — luôn kiểm tra `Get-Process` thật trước khi báo cáo trạng thái cho người dùng. May mắn là kiến trúc checkpoint/resume của SFOA (lưu sau mỗi vòng lặp) chịu được việc này — chỉ mất đúng phần chưa lưu checkpoint (ở đây là 1 vòng lặp cuối), không mất toàn bộ. **Luôn thiết kế checkpoint sau MỖI vòng lặp**, không chỉ sau mỗi lần chạy (run), đúng như code đã làm — đây là lý do sự cố này không gây thiệt hại lớn.

### 2.4. Một lệnh PowerShell chứa cả `Remove-Item` VÀ chuỗi `"C:\Program..."` (ở bất kỳ đâu trong cùng lệnh) có thể bị chặn nhầm

Gặp lỗi `Remove-Item on system path 'C:\Program' is blocked` dù mục tiêu xóa thực sự không liên quan gì đến `C:\Program Files` — có vẻ là một cơ chế an toàn tĩnh (phân tích toàn bộ text của lệnh, không chỉ riêng tham số `-Path` của `Remove-Item`) phản ứng nhầm khi 2 chuỗi này cùng xuất hiện trong 1 lệnh (ví dụ: 1 dòng `Remove-Item $LogPath` và 1 dòng khác `Start-Process 'C:\Program Files\...\matlab.exe'` trong CÙNG 1 lệnh PowerShell gửi lên).

**Bài học**: khi cần xóa/dọn 1 file trong cùng script có gọi tới đường dẫn `C:\Program Files\...`, dùng `Clear-Content` (không phải `Remove-Item`) cho việc dọn log, hoặc tách thành 2 lệnh PowerShell riêng biệt.

---

## 3. Chỉnh sửa file .docx trực tiếp qua XML — bài học mới

### 3.1. Luôn kiểm tra file `.docx` có đang mở trong Word của người dùng trước khi ghi đè

Ghi đè 1 file `.docx` đang mở trong Word của người dùng sẽ thất bại (file bị khóa) — hoặc tệ hơn, nếu người dùng đang tự chỉnh tay trong Word mà mình ghi đè thành công, sẽ MẤT toàn bộ chỉnh sửa tay chưa lưu của họ. **Luôn kiểm tra `Get-Process WINWORD | Select MainWindowTitle`** trước khi copy đè lên 1 file `.docx` đã gửi cho người dùng trước đó — nếu đang mở, lưu sang tên khác và hỏi người dùng thay vì tự ý ghi đè.

### 3.2. Neo phép thay thế bằng `w14:paraId`, không chỉ bằng nội dung text

`document.xml` của `.docx` thường là 1 dòng dài duy nhất, và Word tách 1 câu thành nhiều `<w:r>` (run) nhỏ do lịch sử track-changes/spell-check. Chạy `merge_runs.py` trước để gộp run liền kề cùng định dạng, nhưng khi cần sửa 1 Ô BẢNG cụ thể (ví dụ 1 giá trị số xuất hiện lặp lại ở nhiều ô khác nhau như "0,20"), PHẢI dùng `w14:paraId="XXXXXXXX"` (duy nhất cho mỗi đoạn/ô) làm mỏ neo trong `old_string`, không dùng riêng nội dung text (dễ trùng, Edit tool sẽ báo lỗi "not unique" hoặc tệ hơn — sửa nhầm ô khác nếu vô tình unique nhưng sai vị trí).

### 3.3. Khi chèn văn bản mới xen giữa 1 run có subscript, phải tách run đúng cách — không chèn số thường lẫn với số subscript

Khi thêm 1 câu mới có biến `x1, x2...` vào giữa 1 đoạn văn đã có subscript thật (`<w:vertAlign w:val="subscript"/>`) cho các biến khác trong cùng đoạn, dễ mắc lỗi chèn `x1` dạng số thường (không subscript) — khiến hiển thị KHÔNG đồng nhất với phần còn lại của tài liệu. Phải tách `<w:r>` mới thành nhiều run xen kẽ (thường/subscript/thường/subscript...), y hệt cấu trúc run đã có sẵn trong tài liệu cho biến tương tự.

### 3.4. Ghép nối trực tiếp 2 đoạn text bằng Edit dễ làm mất khoảng trắng ở ranh giới run

Khi cắt/nối 1 câu ở ranh giới giữa 2 `<w:r>` khác nhau (ví dụ câu bị chia bởi 1 run in đậm/subscript ở giữa), rất dễ quên mất dấu cách ở đầu/cuối `old_string`/`new_string`, dẫn đến lỗi dính chữ khi render (ví dụ "vớiN" thay vì "với N", "hệ sốβ" thay vì "hệ số β"). **Luôn `pandoc -t markdown` lại rồi đọc trực quan** sau MỖI đợt sửa để bắt các lỗi dính chữ này — đừng chỉ tin `validate.py` (chỉ kiểm tra cấu trúc XML/số đoạn văn, không kiểm tra nội dung/khoảng trắng).

### 3.5. `soffice`/`pdftoppm` không có sẵn trên máy Windows này (đã ghi nhận trước, xác nhận lại)

Script `soffice.py` của skill `docx` gọi `socket.AF_UNIX` — không tồn tại trên Windows, luôn lỗi. Thay thế bằng Word COM (`$word.Documents.Open` + `$doc.ExportAsFixedFormat($pdfPath, 17)`) nếu cần xuất PDF kiểm tra — nhưng cách này CÓ THỂ rất chậm/treo nếu tài liệu nhúng ảnh lớn (gặp 1 lần với ảnh `.emf` 15MB, phải hủy). Nên hỏi người dùng có thực sự cần bước kiểm tra trực quan PDF không trước khi làm, nhất là khi tài liệu có ảnh nặng.

---

## 4. Quy trình cập nhật kết quả SFOA/bài báo — bài học về tính kỷ luật

### 4.1. Nới cận (lb) sau khi phát hiện nghiệm cũ chạm đáy — kiểm tra LẠI xem có biến khác chạm đáy MỚI không, đừng tự ý nới lần 2

Sau khi nới `lb` và chạy lại, 1 biến khác (không phải biến ban đầu bị nghi ngờ) lại chạm đúng cận dưới MỚI. Bài học: nới cận không tự động "giải quyết xong" vấn đề giới hạn hộp tìm kiếm — luôn đối chiếu lại TOÀN BỘ vector nghiệm với TOÀN BỘ vector `lb` mới sau mỗi lần chạy, và **báo người dùng trước khi tự ý nới thêm lần nữa** (đừng coi nới cận là hành động có thể lặp lại tùy ý mà không hỏi).

### 4.2. Khi chạy lại campaign, các script hậu kiểm (post-check) có thể chứa hằng số "chép lại" từ lần chạy TRƯỚC — dễ bị lỗi thời âm thầm

Ví dụ: script `classify_pile_edge_corner_EN1992.m` có dòng comment ghi rõ giá trị `rho_l` (mu) "copied verbatim from that script's own log" của lần chạy TRƯỚC — nếu chạy lại campaign với nghiệm mới mà quên cập nhật các hằng số chép tay này, kết quả hậu kiểm sẽ SAI mà không có lỗi/cảnh báo nào. **Luôn `grep` toàn bộ thư mục script hậu kiểm tìm các giá trị số hard-code kiểu này trước khi chạy lại với nghiệm mới.**

### 4.3. Khi viết lại phần "thảo luận" của bài báo dựa trên số liệu mới, PHẢI tính lại từ dữ liệu thô — đừng tái sử dụng kết luận cũ

Ở lần chạy trước, "vùng giảm % tương đối nhiều nhất" là DAY130; ở lần chạy mới, biên độ tìm kiếm khác đi khiến TUONGM78 mới là vùng giảm nhiều nhất. Nếu chỉ đổi số mà giữ nguyên câu văn kết luận cũ ("mức giảm lớn nhất thuộc về vùng bản đáy...") sẽ SAI so với số liệu mới. **Luôn tính lại % thay đổi cho TỪNG biến từ mảng số liệu thô, không suy luận lại kết luận cũ.**

### 4.4. "Thời gian trung bình mỗi lần đánh giá" phải tính từ TOÀN BỘ dữ liệu thật, không chỉ đoạn "ổn định" thuận tiện

Lần đầu báo cáo 13,6 giây/lần bằng cách chỉ lấy trung bình 14 vòng lặp liên tiếp trong giai đoạn ổn định (bỏ qua các đoạn khởi động SAP2000 chậm hơn) — con số này bị người dùng phát hiện là không đại diện cho TOÀN BỘ quá trình khi được hỏi lại. Tính đúng bằng cách cộng dồn CHÍNH XÁC elapsed-time từng phiên chạy (kể cả các đoạn chậm do khởi động lại SAP2000) chia cho tổng số lần đánh giá thật, cho kết quả khác (14,2 giây, không phải 13,6 giây). **Bài học: khi báo cáo bất kỳ số liệu "trung bình" nào trong bài báo khoa học, phải minh bạch xem có loại trừ phần dữ liệu nào không — nếu có loại trừ, phải nêu rõ trong bài, hoặc tốt hơn là tính từ TOÀN BỘ dữ liệu để không phải giải thích ngoại lệ.**

### 4.5. Quy tắc "tên tiêu chuẩn chỉ xuất hiện ở N vị trí" cần audit lại bằng `grep` sau MỖI đợt sửa, không chỉ 1 lần

Qua nhiều vòng góp ý, các đoạn văn ở Mục 1/2.1/Kết luận bị chỉnh sửa lặp đi lặp lại — mỗi lần sửa có nguy cơ vô tình chèn lại tên tiêu chuẩn đầy đủ ở một vị trí không được phép. **Sau MỖI đợt áp dụng góp ý, `grep -n "TCVN\|EN 1992"` toàn bộ file .md/.docx đã export, không chỉ tin vào trí nhớ về những gì đã sửa ở vòng trước.**

### 4.6. Copy-paste khi sửa nhiều đoạn tương tự nhau rất dễ để sót số liệu CŨ

Có 1 lần viết lại đoạn thảo luận, vô tình gõ lại đúng con số % của bản CŨ (45,4%) thay vì tính lại cho nghiệm mới (46,9%) — phát hiện ngay sau khi gõ nhờ tự kiểm tra lại phép tính, nhưng suýt lọt qua. **Luôn tính tay lại (hoặc dùng công cụ) MỌI con số % / chênh lệch trước khi gõ vào văn bản, đừng gõ theo trí nhớ "na ná" số cũ.**

---

## 5. Checklist rút gọn cho dự án SFOA tiếp theo

1. [ ] Trước khi chạy watchdog dài giờ: đã vá watchdog để xóa file sản phẩm phân tích (`.K_0/.LOG/.OUT/.Y*/.msh`) sau MỖI lần restore `.sdb` baseline (mục 1.1)?
2. [ ] Theo dõi log dài giờ: dùng vòng lặp polling, KHÔNG dùng `tail -F`/`Get-Content -Wait` nếu có tiến trình khác đang ghi cùng file (mục 1.2)?
3. [ ] Sau mỗi lần `TaskStop`/kill: đã xác minh lại bằng `Get-Process`/`Get-CimInstance` trước khi relaunch (mục 2.1)?
4. [ ] Sau mỗi lần sửa `.ps1` đang có tiến trình chạy: đã kill + relaunch, không chỉ sửa file (mục 2.2)?
5. [ ] Trước khi ghi đè bất kỳ `.docx` nào đã gửi người dùng: đã kiểm tra `Get-Process WINWORD` (mục 3.1)?
6. [ ] Sau mỗi đợt sửa bài báo: đã `pandoc` lại và đọc trực quan + `grep` các quy tắc thuật ngữ/số liệu cũ còn sót (mục 3.4, 4.5, 4.6)?
7. [ ] Sau khi nới cận `lb`/chạy lại campaign: đã đối chiếu TOÀN BỘ nghiệm mới với TOÀN BỘ `lb` mới, báo người dùng nếu còn biến chạm đáy (mục 4.1)?
8. [ ] Trước khi chạy lại script hậu kiểm với nghiệm mới: đã `grep` tìm hằng số hard-code từ lần chạy trước (mục 4.2)?
9. [ ] Mọi số liệu "trung bình"/% trong bài báo: đã tính lại từ dữ liệu thô của lần chạy MỚI NHẤT, không tái dùng kết luận/số liệu cũ (mục 4.3, 4.4, 4.6)?
