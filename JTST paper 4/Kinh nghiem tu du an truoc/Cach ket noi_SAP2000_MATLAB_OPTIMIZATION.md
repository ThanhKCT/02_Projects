# Kinh nghiệm kết nối SAP2000-MATLAB cho bài toán tối ưu (mọi thuật toán)

> File này đúc kết từ dự án SOO-SFOA (Tạp chí Xây dựng, 2026). Viết để **dùng lại cho các dự án sau** khi cần ghép SAP2000-MATLAB với bất kỳ thuật toán tối ưu nào (GWO, PSO, WOA, GA, MOO...), không riêng SFOA. Nên copy file này vào dự án mới và đọc trước khi bắt đầu code.

## 1. Kiến trúc chuẩn đã kiểm chứng hoạt động

```
Design vector x (thuật toán đề xuất)
      ↓
MATLAB rời rạc hóa x về danh mục hợp lệ (D,t theo catalogue; nhịp/dầm theo lưới)
      ↓
Ghi thông số hình học vào SAP2000 đang mở (qua SM.* / SAP2000 OAPI, COM)
      ↓
Chạy phân tích FEM (SM.Analyze.RunAnalysis)
      ↓
Đọc ngược displacement, N/M/V, phản lực → MATLAB
      ↓
Tính constraint g_j(x), hàm phạt P(x), fitness = objective + P(x)
      ↓
Trả fitness về cho thuật toán tối ưu
```

**Song song hóa**: dùng `spmd` + `parpool`, mỗi worker mở **1 instance SAP2000 riêng**, lưu **1 file .sdb riêng** trong 1 thư mục con riêng (ví dụ `MPJ_Sap/SOO_<Obj>_W<idx>/MPJ_<idx>.sdb`) — **tuyệt đối không để nhiều worker cùng mở/ghi 1 file .sdb** (xung đột lock file, kết quả sai âm thầm).

## 2. Mở SAP2000 hoàn toàn ẩn (headless) — mẫu code dùng lại được

```matlab
function open_Sap2000(h)
SM.App('sap'); SM.Ver('24');
ProgramPath = 'C:\Program Files\Computers and Structures\SAP2000 24\SAP2000.exe';
APIDLLPath  = 'C:\Program Files\Computers and Structures\SAP2000 24\SAP2000v1.dll';
[Sobj] = SM.Helper.CreateObject(ProgramPath, APIDLLPath);
[Smdl] = SM.SapModel();
if h==1
    SM.ApplicationStart('Visible', false)  % <-- KHÔNG hiện cửa sổ ngay từ đầu, không phải "hiện rồi ẩn"
    SM.Hide;
else
    SM.ApplicationStart
end
end
```
Gọi thêm `SM.Hide` sau mỗi `OpenFile`/`Save` cho chắc. Ẩn/hiện **không ảnh hưởng tốc độ tính toán** — tốc độ do FEM solve + round-trip COM quyết định, không do render giao diện.

## 3. Số worker song song — công thức và giới hạn thật đã đo

```matlab
workerFraction = 0.8;
localCluster = parcluster('local');
detectedLogicalProcessors = str2double(getenv('NUMBER_OF_PROCESSORS'));
maxParallelSAP = min([detectedLogicalProcessors, localCluster.NumWorkers, Npop]);
Num_work = max(1, floor(workerFraction * maxParallelSAP));
```

- **License SAP2000 node-locked cho phép tối đa 11 tiến trình SAP2000 đồng thời** (đã kiểm chứng thực tế trên máy 14 lõi/28 luồng — không phải suy đoán). Nếu máy khác, phải tự đo lại — đừng giả định số này cố định.
- `maxNumCompThreads(1)` trong mỗi worker để tránh 1 worker chiếm hết CPU của các worker khác.
- Luôn `system('taskkill /F /IM SAP2000.exe')` trước khi tạo parpool mới (dọn tiến trình mồ côi từ lần chạy trước).

## 4. Hiệu năng thật — đừng tin vào ngoại suy

- **Thời gian mỗi vòng lặp KHÔNG cố định**, tăng dần 2-4 lần khi quần thể hội tụ: quần thể ngẫu nhiên ban đầu có nhiều cá thể không khả thi, bị loại nhanh bằng phạt cứng (rẻ); quần thể hội tụ có nhiều cá thể khả thi, phải giải FEM + kiểm tra ràng buộc đầy đủ (đắt). Đây là đặc điểm riêng của bài toán SOO/MOO kết hợp FEM lặp, khác benchmark toán học thuần túy.
- **Ngoại suy thời gian từ Npop khác nhau KHÔNG chính xác**: dự án này ngoại suy từ pilot Npop=100 sang Npop=30 (chia hệ số Npop) → sai lệch ~33% so với đo thật (ước tính 21s/vòng, thực tế 28s/vòng). **Luôn chạy 1 pilot thật ở đúng Npop sẽ dùng cho campaign chính** trước khi cam kết hàng chục giờ tính toán.
- Quy trình 3 bước bắt buộc trước khi chạy campaign thật: **(1) smoke test** (Npop nhỏ, Max_it=1, kiểm tra pipeline không lỗi) → **(2) pilot thật** ở đúng Npop dự kiến, Max_it lớn (để xem đường hội tụ thật, chọn Max_it an toàn) → **(3) campaign chính** (Nrun đầy đủ).

## 5. Cơ chế chống mất dữ liệu cho campaign nhiều giờ/ngày — BẮT BUỘC, đã kiểm chứng sống

Một job có thể chạy hàng chục giờ liên tục — mất điện/crash/reboot **sẽ xảy ra** (dự án này gặp 3 lần crash bất thường trong 1 ngày trên cùng 1 máy). Thiết kế driver theo 3 nguyên tắc sau **trước khi chạy campaign thật**, không phải sau khi mất dữ liệu mới thêm:

1. **Idempotent theo từng run**: đầu mỗi run, kiểm tra file kết quả cuối đã tồn tại chưa → nếu có, `continue` bỏ qua ngay. Nhờ vậy, script/watchdog có thể gọi lại **đúng 1 lệnh cố định** (`Nrun=N, runIdOffset=0`) bao nhiêu lần cũng được, không cần tính toán lại offset.
2. **Checkpoint giữa chừng mỗi K vòng lặp** (K=20 là hợp lý cho job vài chục phút/run): lưu state đủ để resume (quần thể hiện tại, fitness, best-so-far, vòng lặp T, thời gian đã chạy) ra file `*_CKPT.mat`. Đầu mỗi run, nếu thấy checkpoint thì load và resume từ `T+1` thay vì làm lại từ đầu.
3. **Ghi file atomic**: mọi lần lưu (checkpoint và kết quả cuối) đều ghi ra `<file>.tmp` rồi `movefile(tmp, file, 'f')`. Đảm bảo mất điện đúng lúc ghi đĩa không để lại file `.mat` dở dang/hỏng.
4. **Watchdog ngoài (PowerShell/bash)** gọi lại MATLAB tới khi đủ Nrun, có đếm số lần gọi liên tiếp không tiến triển (ví dụ ≥5 lần) để **tự dừng** — tránh vòng lặp crash vô hạn nếu là lỗi thật (không phải gián đoạn tạm thời).
5. **Khởi chạy tách tiến trình**: dùng `Start-Process -WindowStyle Hidden` (PowerShell) cho job dài — **KHÔNG dùng cơ chế background của công cụ chat/agent** (dễ bị kill khi phiên chat/agent kết thúc hoặc khởi động lại).

## 6. LỖI ĐÃ GẶP — kiểm tra ngay các điều này nếu thấy hiện tượng tương tự

### 6.1. PowerShell `Start-Process -ArgumentList` dạng mảng cắt cụt lệnh MATLAB (rất nguy hiểm vì im lặng)
**Hiện tượng**: gọi `Start-Process -FilePath matlab.exe -ArgumentList @("-batch", $cmd) ...` → MATLAB thoát sau ~10-15s, `exit code = 0` (không lỗi!), không có output nào, không chạy được gì.
**Nguyên nhân**: PowerShell 5.1 (khác .NET Core) khi nhận `-ArgumentList` là **mảng**, chỉ nối các phần tử bằng dấu cách thành 1 chuỗi thô, KHÔNG tự quote lại từng phần tử. Nếu `$cmd` chứa dấu cách (gần như luôn có, do các câu lệnh MATLAB cách nhau bằng `; `), Windows sẽ tách lại chuỗi đó theo khoảng trắng thành nhiều argv riêng — MATLAB `-batch` chỉ nhận được mảnh đầu tiên (ví dụ `objCol=1;`), chạy xong ngay, không lỗi.
**Cách sửa**: luôn truyền **một chuỗi đã tự quote sẵn** cho `-ArgumentList`, không dùng mảng:
```powershell
$argStr = "-batch `"$cmd`""
Start-Process -FilePath $matlab -ArgumentList $argStr -WorkingDirectory $dir -Wait ...
```
**Bài học tổng quát**: nếu thấy MATLAB batch "chạy xong quá nhanh, không lỗi, không kết quả" khi gọi qua PowerShell — nghi ngay lỗi này trước khi nghi code MATLAB.

### 6.2. Nhầm số cột diagnostic giữa các hệ kết cấu tương tự
Copy driver từ hệ A sang hệ B (ví dụ BD→MPJ) mà không kiểm tra lại số cột/tên cột diagnostic — hệ B có thể có ràng buộc khác (ví dụ MPJ không có uplift nhưng có thêm khoảng cách cọc-dầm) → lỗi `Unable to perform assignment... M-by-N and ... M-by-K` khi ghép kết quả song song. **Luôn đối chiếu lại đúng danh sách cột với chính file hàm mục tiêu (`diagnostic(ix,:) = [...]`), không copy từ driver khác.**

### 6.3. Nhầm chỉ số biến rời rạc (ví dụ catalogue cọc) khi so sánh với thiết kế/bài báo tham chiếu
Suy đoán chỉ số hàng trong danh mục (ví dụ "cọc D500 cấp B = hàng số mấy") dựa trên quy ước tên gọi (A/B/C/D ↔ 1/2/3/4) **có thể sai** — quy ước thật không nhất thiết tuần tự. **Cách an toàn: đối chiếu bằng một giá trị định lượng độc lập** (đơn giá, khối lượng...) khớp với tài liệu nguồn, không suy đoán quy ước đặt tên. Trong dự án này, đối chiếu đơn giá USD/m đã lật lại 1 giả định sai (chỉ số 16 → đúng là 17).

### 6.4. `matlab -batch` dùng seed RNG mặc định giống nhau mỗi lần khởi động MỚI
Hai lần gọi `matlab -batch` riêng biệt (2 tiến trình khác nhau), nếu không `rng('shuffle')`, sẽ dùng đúng cùng 1 seed → kết quả **giống hệt nhau**. Không phải bug, nhưng dễ hiểu lầm là "không có tính ngẫu nhiên". Trong 1 script với loop `for iloop=1:Nrun` chạy trong CÙNG 1 tiến trình thì không bị ảnh hưởng (RNG tự tiến triển qua các lần lặp) — chỉ cần lưu ý khi so sánh 2 lần GỌI RIÊNG (ví dụ 2 lần calibration).

### 6.5. Trích dẫn tài liệu tham khảo lệch số sau khi sửa bản thảo
Khi thêm/xóa/đổi thứ tự tài liệu tham khảo, các số trích dẫn trong thân bài **không tự động cập nhật** — luôn rà lại toàn bộ số trích dẫn trong bài khớp đúng với danh mục cuối cùng trước khi coi là hoàn thiện.

### 6.6. `matlab -batch` làm SAP2000 OAPI (qua `SM.*`) crash KHÔNG ỔN ĐỊNH — dùng `-r`, không dùng `-batch`
**Hiện tượng** (dự án Wharf100DWT, 27/08/2026): gọi các lệnh `SM.App`/`SM.Ver`/`SM.Helper.CreateObject`/`SM.ApplicationStart` qua `matlab -batch "..."` — MATLAB thoát đột ngột, **không có thông báo lỗi nào** (kể cả bọc try/catch quanh toàn bộ), **không ghi vào Windows Event Log** (không phải crash cứng access-violation được hệ điều hành ghi nhận). Đặc biệt khó chẩn đoán: **vị trí dừng KHÁC NHAU giữa các lần chạy với đúng cùng 1 đoạn code, cùng input** (có lần dừng ở `ApplicationStart`, có lần dừng sớm hơn ngay ở `CreateObject`).
**Nguyên nhân:** `-batch` không chạy Windows message pump. Các đối tượng COM/ActiveX kiểu STA (single-threaded apartment) — SAP2000 OAPI thuộc loại này — cần message pump chạy để hoạt động ổn định; thiếu nó gây lỗi timing không tất định (race condition), không phải lỗi logic cố định trong code.
**Cách sửa (đã kiểm chứng thật, chạy trót lọt nhiều lần liên tiếp không lỗi):** chạy MATLAB ở chế độ desktop đầy đủ bằng cờ `-r` (KHÔNG thêm `-nodesktop`, KHÔNG dùng `-batch`), ví dụ:
```powershell
$cmd = "cd('...'); ten_ham_can_chay(); exit;"
$argStr = "-r `"$cmd`""
Start-Process -FilePath $matlab -ArgumentList $argStr -Wait
```
**Bài học tổng quát:** với BẤT KỲ script MATLAB nào tự động hoá phần mềm ngoài qua COM (`SM.*` cho SAP2000, `actxserver`, Word/Excel COM automation...) — **luôn chạy bằng `-r`, không dùng `-batch`**, dù `-batch` là cờ "hiện đại" MathWorks khuyến nghị chung cho chạy không tương tác. Nếu thấy MATLAB "biến mất" hoàn toàn không dấu vết, không lỗi, không log, ngay sau một lệnh COM automation — nghi ngay `-batch` trước khi nghi logic code.

### 6.7. `readtable(...,'TextType','string')` có thể làm SẬP TOÀN BỘ tiến trình MATLAB, không phải lỗi bắt được
**Hiện tượng** (dự án Wharf100DWT, 27/08/2026, MATLAB R2023b): gọi `readtable(path, 'TextType', 'string')` trên một file CSV hợp lệ — MATLAB thoát im lặng ngay tại dòng đó, không có exception nào để try/catch bắt, không log.
**Cách chẩn đoán khi nghi ngờ dòng nào gây crash im lặng kiểu này:** KHÔNG dựa vào `disp()`/`fprintf()` ra Command Window hay ra file qua `-RedirectStandardOutput` của `Start-Process` — output có thể bị buffer và mất hoàn toàn nếu tiến trình bị crash trước khi buffer được flush. Phải ghi từng bước ra file bằng `fopen`/`fprintf`/`fclose` NGAY SAU MỖI DÒNG NGHI NGỜ (fclose đảm bảo flush xuống đĩa dù tiến trình chết ngay sau đó) để cô lập chính xác dòng gây crash.
**Cách sửa:** thay `readtable` bằng I/O cấp thấp (`fopen`/`fgetl`/`strsplit`/`str2double` theo dòng) — chậm hơn nhưng ổn định, đã kiểm chứng cho đúng kết quả.
**Bài học tổng quát:** nếu MATLAB "biến mất" không dấu vết khi đọc CSV/Excel, nghi ngay `readtable`/text-import engine trước khi nghi logic code.

### 6.8. `matlab -r "...; ten_script.m; exit;"` TREO VÔ HẠN nếu gọi script bằng bareword có đuôi `.m` — phải dùng `run(...)`
**Hiện tượng** (dự án Kè sau cầu, 29/08/2026, MATLAB R2023b, máy mới): sau khi chuyển từ `-batch` sang `-r` theo mục 6.6, lệnh `-r "addpath(...); addpath(...); test_timing.m; exit;"` (đúng cú pháp đã dùng ổn định với `-batch`) khiến MATLAB **treo vô hạn, không lỗi, không log, RAM ổn định** — dừng lại NGAY TRƯỚC dòng đầu tiên của `test_timing.m` (đã xác nhận bằng marker ghi file ngay trước lệnh gọi: marker "sắp gọi" ghi được, nhưng script không hề bắt đầu chạy). Không phải do `addpath` (đã test riêng, chạy tức thì) và không phải do bản thân hàm bị gọi (gọi trực tiếp `open_Sap2000(1)` bằng cú pháp hàm bình thường vẫn chạy tốt dưới `-r`, chỉ chậm hơn ~vài chục giây do overhead desktop).
**Nguyên nhân (suy luận từ thực nghiệm, chưa xác nhận từ tài liệu MathWorks)**: `-batch` không dùng desktop Java/Swing nên "tên_script.m" được trình thông dịch coi là lệnh chạy script theo đúng nghĩa script/hàm. Dưới `-r` (desktop đầy đủ), Command Window là thành phần Java tương tác — cú pháp bareword có dấu chấm (`ten_script.m`) rơi vào một nhánh xử lý khác (có thể liên quan gợi ý/auto-resolve của Command Window) và với cửa sổ bị ẩn (`-WindowStyle Hidden`), nhánh này treo vô thời hạn vì không ai tương tác được.
**Cách sửa (đã kiểm chứng, chạy thành công nhiều lần liên tiếp)**: luôn gọi script qua hàm `run(...)` tường minh thay vì bareword:
```powershell
$cmd = "addpath('...'); addpath('...'); run('ten_script.m'); exit;"
$argStr = "-r `"$cmd`""
```
**Bài học tổng quát**: khi áp dụng fix `-r` của mục 6.6, đừng copy nguyên xi chuỗi lệnh đã dùng với `-batch` — riêng cú pháp gọi script theo tên file (đuôi `.m`, không có dấu ngoặc) cần đổi sang `run('ten_file.m')`. Nếu thấy `-r` "treo êm" ngay từ đầu (RAM ổn định, không crash, không tiến triển) sau khi đã áp dụng đúng mục 6.6 — nghi ngay cú pháp gọi script bareword trước khi nghi COM/SAP2000.

### 6.9. File `.sdb` TỰ THOÁI HOÁ sau nhiều giờ `RunAnalysis` liên tục — `OpenFile` treo vĩnh viễn, không phải lỗi COM/kill
**Hiện tượng** (dự án Kè sau cầu, 30/08/2026, MATLAB R2023b): sau ~27 vòng lặp SFOA (~6 giờ, hàng nghìn lượt `SetShell_1`+`RunAnalysis` liên tiếp trên CÙNG 1 file `.sdb`), watchdog restart bình thường (do chạm `MaxAttemptSeconds`) nhưng **`SM.File.OpenFile` treo vĩnh viễn** ở lần mở lại kế tiếp — MATLAB và SAP2000 vẫn "sống" (process tồn tại) nhưng **CPU gần như đứng yên** (đo bằng `Get-Process ... | Select CPU` cách nhau vài phút, gần như không tăng), không lỗi, không crash, không ghi log — dễ nhầm với lỗi COM/message-pump ở mục 6.6.
**Đã loại trừ bằng thực nghiệm trực tiếp** (đừng đoán, hãy cô lập như dưới đây):
1. Không phải do timing sau kill ép buộc — đã chờ >4 phút sau `taskkill /F` rồi mở lại, vẫn treo y hệt.
2. Không phải do logic resume/checkpoint — viết 1 script cô lập CHỈ gọi `open_Sap2000`+`OpenFile` (không đụng gì đến checkpoint/SFOA), vẫn treo y hệt tại đúng `OpenFile`.
**Cách xác nhận nguyên nhân thật**: phục hồi `.sdb` từ bản backup `.sbk` mà SAP2000 tự tạo (khi model được lưu/đóng sạch trước đó) → `OpenFile` chạy lại **NGAY LẬP TỨC (~3 giây)**. Vậy nguyên nhân là **chính file `.sdb` đã tự thoái hoá/tích luỹ trạng thái nội bộ** sau nhiều giờ phân tích liên tục trên cùng 1 file, không phải do code, không phải do COM, không phải do việc kill tiến trình.
**Cách phòng ngừa vĩnh viễn (đã áp dụng, xác nhận chạy ổn định >5 giờ liên tục sau khi fix)**: lưu sẵn 1 bản `.sdb` "sạch" đã xác nhận mở được (đặt tên rõ ràng, ví dụ `*.PRISTINE_BASELINE.sdb`), rồi **COPY ĐÈ bản baseline này lên file `.sdb` làm việc TRƯỚC MỖI LẦN watchdog khởi động lại** (không chỉ lần đầu tiên). An toàn vì trạng thái của thuật toán tối ưu (quần thể, checkpoint) luôn nằm ở file `.mat` RIÊNG, không phụ thuộc nội dung `.sdb` — mỗi lần đánh giá đều tự ghi đè hình học cần thiết (`SetShell_1`...) trước khi `RunAnalysis`.
**Bài học tổng quát**: với bất kỳ campaign nào dự kiến chạy nhiều giờ trên CÙNG 1 file `.sdb` — đừng tin file đó sẽ luôn khoẻ mạnh. Chụp lại 1 bản baseline sạch sớm và phục hồi định kỳ/mỗi lần khởi động lại, thay vì chỉ dùng file gốc suốt cả campaign.

## 7. Công cụ dựng file Word (.docx) trên máy Windows thiếu LibreOffice/poppler

- Package `docx` (Node.js) **không có sẵn**, phải `npm install docx` trong thư mục làm việc trước khi chạy script dựng file.
- Nếu máy không có LibreOffice (`soffice`) hoặc Poppler (`pdftoppm`) — quy trình chuẩn "convert to PDF rồi render ảnh xem trước" của các skill sẽ không chạy được.
- **Thay thế đã kiểm chứng hoạt động**: dùng chính Microsoft Word (nếu máy có) qua PowerShell COM để MỞ file `.docx` và xuất PDF — nếu Word mở được và xuất PDF không lỗi, đó là xác nhận đủ tin cậy là file không hỏng cấu trúc (Word sẽ báo lỗi/sửa chữa nếu file OOXML hỏng):
  ```powershell
  $word = New-Object -ComObject Word.Application
  $word.Visible = $false
  $doc = $word.Documents.Open($docxPath)
  $doc.SaveAs([ref]$pdfPath, [ref]17)  # 17 = wdFormatPDF
  $doc.Close(); $word.Quit()
  ```
- Việc render PDF→ảnh PNG để xem trước (không qua LibreOffice) **đã thử và KHÔNG thành công** trên máy này qua 2 cách (WinRT `Windows.Data.Pdf` và `EnhMetaFileBits` của Word COM) — PowerShell 5.1 WinRT interop không ổn định. Nếu cần xem trước bằng ảnh thật, nên cài LibreOffice trước, hoặc gửi file cho người dùng tự mở trong Word.

## 8. Checklist nhanh khi bắt đầu dự án SAP2000-MATLAB mới với thuật toán khác

- [ ] Viết hàm mục tiêu riêng (giống `Sap_MPJ.m`): nhận `X` (ma trận thiết kế) + `data` (catalogue), trả `[fit, diagnostic]`. Phần này **độc lập với thuật toán tối ưu** — tái dùng được.
- [ ] Viết `open_Sap2000.m` dùng `SM.ApplicationStart('Visible', false)` — copy nguyên mẫu mục 2.
- [ ] Đo lại số worker khả thi (license SAP2000 cho phép bao nhiêu instance đồng thời trên máy đích — đừng giả định 11).
- [ ] Chạy smoke test (Npop nhỏ, Max_it=1) trước khi làm bất cứ điều gì khác.
- [ ] Chạy 1 pilot thật ở đúng Npop dự kiến dùng cho campaign — lấy Max_it và thời gian/vòng lặp THẬT, không ngoại suy.
- [ ] Viết driver có đủ 3 cơ chế mục 5 (idempotent-skip, checkpoint, atomic-save) **trước khi** chạy campaign thật, không phải sau khi mất dữ liệu.
- [ ] Nếu launch qua PowerShell, dùng chuỗi tự quote cho `-ArgumentList`, không dùng mảng (mục 6.1).
- [ ] **Luôn dùng `-r`, KHÔNG dùng `-batch`** khi script có gọi COM automation (`SM.*`, `actxserver`...) — `-batch` gây crash không ổn định do thiếu message pump (mục 6.6).
- [ ] Khi dùng `-r`, gọi script bằng `run('ten_file.m')`, KHÔNG gọi bareword `ten_file.m;` — bareword treo vô hạn dưới desktop mode (mục 6.8).
- [ ] Tránh `readtable(...)` cho các file cấu hình quan trọng nếu chưa kiểm chứng ổn định trên máy đích — cân nhắc dùng `fopen`/`fgetl` thủ công (mục 6.7).
- [ ] Nếu campaign dài nhiều giờ/ngày, dùng watchdog PowerShell + `Start-Process -WindowStyle Hidden`, không dùng cơ chế background của công cụ chat/agent.
- [ ] Nếu có thiết kế/bài báo tham chiếu để đối chiếu, khớp bằng giá trị định lượng (đơn giá, khối lượng), không suy đoán quy ước đặt tên (mục 6.3).
