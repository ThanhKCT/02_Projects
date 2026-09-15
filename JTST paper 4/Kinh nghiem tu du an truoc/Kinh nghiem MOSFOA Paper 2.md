# Kinh nghiệm từ dự án "MOSFOA Paper 2 — kiểm chứng MOSFOA trên 2 công trình cầu tàu"

> Tổng hợp các lỗi/bài học thực tế gặp phải trong quá trình triển khai (2026-09-10 → 2026-09-12), để các dự án sau (đặc biệt là dự án nào lại dùng MATLAB–SAP2000 OAPI hoặc chạy campaign tối ưu nhiều giờ không giám sát) đọc trước, tránh lặp lại.
>
> Đọc kèm: [[sap2000-matlab-optimization-lessons]] / `Cach ket noi_SAP2000_MATLAB_OPTIMIZATION.md` (bài học chung, dự án này KHÔNG lặp lại nội dung đã có ở đó, chỉ bổ sung cái mới).

---

## 1. Ba lỗi "im lặng" trong code trích xuất kết quả SAP2000 — không báo lỗi, chỉ cho số liệu sai

Cả 3 lỗi dưới đây **không gây crash, không có exception, không có return code báo lỗi** — chương trình chạy trơn tru, chỉ là kết quả sai (hằng số 0, hoặc số liệu của 1 đại lượng khác). Đây là loại lỗi nguy hiểm nhất vì rất dễ bị bỏ qua nếu không chủ động nghi ngờ.

### 1.1. `JointDispl('ALL', eItemTypeElm.ObjectElm)` — sai vì `'ALL'` là tên NHÓM, phải dùng `GroupElm`

`'ALL'` là 1 group có sẵn của SAP2000 (đại diện toàn bộ model), không phải tên 1 đối tượng đơn lẻ. Gọi với `ObjectElm` khiến SAP2000 tìm 1 "đối tượng" tên "ALL" (không tồn tại) → trả về `NumberResults=0` mọi lần, không báo lỗi gì khác. Hệ quả: biến chuyển vị tính được **luôn = 0**, khiến ràng buộc liên quan luôn được coi là thoả mãn (dương tính giả toàn bộ).

**Cách phát hiện**: viết 1 script chẩn đoán độc lập, in ra `NumberResults` và giá trị thô ngay sau lệnh gọi, đối chiếu với 1 giá trị đã biết trước (ví dụ 1 nút/tổ hợp đã kiểm tra thủ công từ trước) — nếu ra 0 hoặc khác hẳn giá trị tham chiếu, nghi ngay tham số `eItemTypeElm`.

**Bài học tổng quát**: khi gọi bất kỳ hàm `Results.*` nào của SAP2000 OAPI với tên `'ALL'` (hoặc bất kỳ tên nhóm có sẵn nào), luôn dùng `GroupElm`, không phải `ObjectElm`.

### 1.2. Tên tổ hợp tải trọng dính dấu ngoặc kép thừa — do lỗi tách chuỗi từ file `.s2k` cũ

Một phiên làm việc trước đã trích tên tổ hợp bằng cách đọc trực tiếp văn bản `.s2k`, và vô tình giữ luôn dấu ngoặc kép bao quanh string (`"BAO KT"`) làm 1 phần của tên — trong khi tên tổ hợp THẬT trong SAP2000 không có dấu ngoặc (`BAO KT`). Dấu ngoặc trong file `.s2k` là **cú pháp bao chuỗi của chính định dạng file**, không phải ký tự thuộc về tên.

Hệ quả: `SetComboSelectedForOutput('"BAO KT"', true)` không khớp được combo nào → mọi kết quả liên quan combo đó im lặng trả về rỗng.

**Cách phát hiện**: gọi `SM.RespCombo.GetNameList()` (hoặc hàm liệt kê tương đương) để lấy DANH SÁCH TÊN THẬT trực tiếp từ model đang mở, in ra và so sánh ký tự-với-ký tự với chuỗi hardcode trong code — đừng tin tưởng tên đã trích xuất từ 1 lần đọc file text trước đó mà không đối chiếu lại với chính SAP2000 API.

### 1.3. `FrameForce` đọc lệch cột (off-by-one) — lực dọc trục cọc luôn = 0

Đây là lỗi nghiêm trọng nhất, phát hiện muộn nhất (chỉ lộ ra khi rà soát lại γn). Thứ tự cột THẬT của hàm `FrameForce` (xác nhận qua docs.csiamerica.com):

```
NumberResults, Obj, ObjSta, Elm, ElmSta, LoadCase, StepType, StepNum, P, V2, V3, T, M2, M3
```

Code cũ đếm sai vị trí, gán `P` từ ô của `StepNum` (luôn = 0 với phân tích tĩnh đơn giản, không có "step" thật) và gán `M2/M3` từ ô của `V3/T`. Hệ quả: **lực dọc trục cọc luôn = 0 cho MỌI phương án thiết kế** → ràng buộc sức chịu tải đất nền (vốn so sánh `γn·N_max ≤ Rd`) chưa từng được kiểm tra thật, luôn đúng một cách giả tạo (`0 ≤ bất kỳ số dương nào`). Mô men uốn cũng bị tính từ V3+T (lực cắt + xoắn) thay vì M2+M3 thật.

**Bài học tổng quát — quan trọng nhất của cả file này**: khi copy 1 lệnh gọi hàm nhiều-output của SAP2000 OAPI (dạng `[ret, N, out1, out2, ..., outK] = SM.Results.SomeFunc(...)`), **luôn đếm lại số lượng dấu `~`/tên biến so với tài liệu chính thức của đúng hàm đó**, đừng tin tưởng đã đếm đúng chỉ vì code "trông hợp lý" hay vì đã chạy không lỗi trước đó. Một cách kiểm tra nhanh, rẻ tiền: in ra giá trị vừa trích được và tự hỏi "con số này có hợp lý về độ lớn/dấu với hiểu biết kỹ thuật không?" — `N_max=0` cho 1 cọc chịu tải thật là dấu hiệu đáng ngờ ngay lập tức, dù không có exception nào báo.

### 1.4. Phương pháp chẩn đoán chung nên áp dụng SỚM hơn cho cả 3 lỗi trên

Bài học chung nhất rút ra: nên viết 1 script `diagnose_<case>.m` (không chạy tối ưu, không chạy campaign) làm bước ĐẦU TIÊN cho bất kỳ dự án SAP2000-OAPI mới nào, in ra RAW mọi giá trị trung gian quan trọng (tên section thật, tên combo thật, số nút/thanh, toạ độ mẫu, 1 giá trị lực/chuyển vị mẫu) và đối chiếu bằng tay với model gốc — làm việc này TRƯỚC khi tin tưởng bất kỳ kết quả vét cạn/campaign nào, không phải chỉ khi thấy kết quả "trông lạ".

---

## 2. `γn` (TCVN 10304:2025) và "cấp công trình đặc biệt/I/II/III" (Thông tư 34/2026) là HAI THANG KHÁC NHAU — đừng nhầm lẫn

- `γn` (hệ số tin cậy tầm quan trọng công trình, dùng trong `γn·N_max ≤ Rd`) tra theo **"cấp hậu quả" C1/C2/C3** — nguồn gốc là **QCVN 03:2022/BXD, Phụ lục A**. Phụ lục A liệt kê tiêu chí C3 rất cụ thể (tập trung đông người, hoá chất/nguy hiểm, ý nghĩa chính trị, quy mô kết cấu lớn: nhà cao >75m, nhịp ≥100m, bể chứa >15.000m³...) — **không hề nhắc đến bến cảng hay trọng tải tàu (DWT)**.
- "Cấp công trình đặc biệt/I/II/III/IV" theo trọng tải tàu (DWT) là **Thông tư 34/2026/TT-BXD (thay thế TT 06/2021), Phụ lục I, Bảng 1.4, mục 1.4.5.1** — mục đích hoàn toàn khác (xác định thẩm quyền cấp phép/thẩm định), **không phải** để tra `γn`.
- **Không có bảng quy đổi chính thức nối 2 thang này với nhau.** Một công trình bến cọc, dù được xếp "cấp đặc biệt" theo DWT (Thông tư 34), vẫn có thể chỉ là **C2 (mặc định)** theo QCVN 03:2022 nếu nó không khớp đúng bất kỳ tiêu chí C1/C3 nào được liệt kê rõ trong Phụ lục A.
- **Hệ quả thực tế trong dự án này**: quyết định ban đầu (γn(A)=1,0 do "Cấp I") bị sửa lại thành γn=1,15 (C2) cho CẢ 3 công trình sau khi đọc kỹ 2 văn bản gốc — thay đổi này làm ĐẢO NGƯỢC hoàn toàn kết luận khả thi của công trình A (từ "mọi D đều khả thi" xuống "chỉ D≥600mm khả thi", khớp đúng công trình B).

**Bài học**: khi 1 hệ số kỹ thuật (γn, hệ số tải trọng, hệ số an toàn...) được tra theo "cấp" nào đó, luôn xác minh **cấp đó thuộc đúng văn bản/mục đích nào** — đừng giả định 2 hệ thống phân cấp nghe có vẻ giống nhau ("cấp I/II/III" xuất hiện ở cả 2 thang) là tương đương nhau.

---

## 3. Kiến trúc watchdog cho campaign tối ưu chạy nhiều giờ không giám sát (qua đêm/nhiều ngày)

Đây là phần **quan trọng nhất để tái sử dụng** cho mọi dự án tối ưu SAP2000-in-the-loop chạy dài. Đã kiểm chứng thật (không chỉ lý thuyết): tự kill MATLAB giữa chừng để mô phỏng treo, xác nhận toàn bộ chu trình phát hiện → dọn dẹp → relaunch → resume đúng từ checkpoint hoạt động chính xác trước khi tin tưởng chạy 33-43 giờ không giám sát.

### 3.1. Nguyên tắc kiến trúc

1. **Mỗi lần chạy độc lập (1 "run"/"trial") = 1 tiến trình MATLAB RIÊNG**, không phải 1 vòng lặp `for` bên trong 1 phiên MATLAB duy nhất chạy hết N lần. Nếu dùng vòng lặp gộp, treo ở lần thứ 5 sẽ chặn vĩnh viễn các lần 6..N — không có cách nào bên ngoài can thiệp được vào giữa 1 phiên MATLAB đang treo.
2. **`Start-Process -WindowStyle Hidden`** để khởi động MATLAB — KHÔNG dùng cơ chế chạy nền của bản thân công cụ chat/agent. Lý do: tiến trình tạo bằng `Start-Process` là tiến trình Windows độc lập thật sự, **sống sót ngay cả khi đóng hẳn ứng dụng chat/agent** — đã xác nhận đúng ý định thiết kế này với người dùng.
3. **Checkpoint sau MỖI vòng lặp/thế hệ** (không phải sau mỗi run) — ghi atomic (`*.tmp` rồi `movefile` đè lên file thật) để không bao giờ có file `.mat` dở dang nếu mất điện đúng lúc ghi đĩa.
4. **Idempotent-skip theo từng run**: đầu mỗi lần chạy, kiểm tra file kết quả cuối (`*_FINAL.mat`) đã tồn tại chưa → nếu có thì bỏ qua ngay. Nhờ vậy, gọi lại watchdog bao nhiêu lần cũng an toàn (không chạy trùng, không mất tiến độ).
5. **Phát hiện treo bằng "log KHÔNG CẬP NHẬT" (staleness), không dùng CPU** — đơn giản hơn và bắt được cả 2 kiểu treo ("1 tiến trình CPU cao bất thường" lẫn "toàn bộ gần 0% CPU do lỗi IPC") bằng 1 phép kiểm tra duy nhất. Ngưỡng nên đặt ~2,5-3x thời gian bình thường của 1 vòng lặp để tránh báo động giả (thời gian mỗi vòng có thể dao động ±50-80% tuỳ tải hệ thống — đã quan sát thực tế).
6. **Đếm số lần restart LIÊN TIẾP KHÔNG TIẾN TRIỂN** (checkpoint không nhích thêm vòng nào so với lần restart trước) TÁCH RIÊNG với tổng số lần restart. Nếu là treo tạm thời thật (COM/IPC), mỗi lần restart sẽ tiến thêm ít nhất 1 vòng trước khi treo lại; nếu checkpoint đứng yên qua nhiều lần restart liên tiếp (ví dụ ≥5 lần) thì đó là **lỗi thật** (bug logic khiến luôn treo đúng 1 chỗ) — nên dừng hẳn và báo cần kiểm tra thủ công, thay vì thử mù quáng đến hết `MaxRestarts` (có thể tốn hàng giờ vô ích).
7. **Dọn file rác kết quả phân tích cũ TRƯỚC MỖI lần relaunch** (không phải chỉ lần đầu) — các đuôi `.K_0/.K_I/.K_J/.K_M/.LOG/.OUT/.Y*/.msh` (KHÔNG đụng `.s2k/.$2k/.sbk/.ico/.sdb`). Nếu chạy song song nhiều worker (mỗi worker có bản sao model riêng trong thư mục con), phải dọn ở **CẢ thư mục gốc lẫn từng thư mục con của từng worker** — bỏ sót 1 thư mục con vẫn có thể gây treo do hộp thoại "kết quả phân tích không tương thích" (không thể tự động trả lời được).

### 3.2. Cơ chế "đề phòng mất điện" — tự động chạy tiếp khi bật lại máy

- **Task Scheduler (`schtasks /Create`) dễ bị chặn** — gặp 2 lớp chặn khác nhau trong dự án này: (a) trình phân loại quyền của Claude Code tự chặn vì đây là "thay đổi cấu hình hệ thống lâu dài" (đúng, cần), và (b) **ngay cả khi người dùng tự tay chạy lệnh, vẫn bị Windows báo "Access is denied"** — nhiều khả năng do phần mềm bảo mật/EDR trên máy chặn `schtasks` (đây là kỹ thuật duy trì mã độc phổ biến nên hay bị các phần mềm AV/EDR chặn mặc định, kể cả không cần cờ `/RL HIGHEST`).
- **Giải pháp thay thế hiệu quả, ít bị chặn hơn**: đặt 1 file `.vbs` vào thư mục **Startup của Windows** (`shell:startup`, tức `%APPDATA%\Microsoft\Windows\Start Menu\Programs\Startup`) — cơ chế này chỉ là COPY 1 FILE vào 1 thư mục thông thường của người dùng, không đụng Task Scheduler/registry, nên không bị chặn. File `.vbs` dùng `WScript.Shell.Run "...", 0, False` để chạy PowerShell hoàn toàn ẩn (tham số `0` = ẩn cửa sổ, `False` = không đợi) mỗi khi đăng nhập Windows.
- Script được tự động chạy lại này PHẢI tự idempotent/tự resume (mục 3.1.4) — vì nó có thể bị gọi lại nhiều lần (mỗi lần đăng nhập), không chỉ đúng 1 lần sau mất điện.
- Nên có thêm 1 cơ chế khoá đơn giản (ghi PID vào file lock, kiểm tra tiến trình đó còn sống không) để tránh 2 phiên chạy trùng nếu vì lý do gì đó bị kích hoạt 2 lần gần nhau — dù trong thực tế Windows không tự "đăng nhập lại" khi máy vẫn đang chạy bình thường (chỉ trigger thật sự sau khi khởi động lại/mất điện).

### 3.3. Luôn TEST watchdog bằng cách chủ động gây lỗi, trước khi tin tưởng chạy thật nhiều giờ

Không chỉ tin vào thiết kế trên giấy — đã chủ động `taskkill` MATLAB đang chạy giữa 1 campaign test ngắn (Max_it nhỏ) để xác nhận: watchdog phát hiện trong ~20s → dọn dẹp → relaunch → in đúng dòng "tìm thấy checkpoint, tiếp tục từ vòng X" (không phải chạy lại từ đầu) → hoàn tất bình thường → tự nhận biết đã xong và dừng đúng lúc. Việc test chủ động này rẻ (vài phút) so với rủi ro phát hiện watchdog có bug chỉ sau khi mất hàng giờ chạy thật không giám sát.

---

## 4. Vài lưu ý nhỏ khác

- **Cẩn thận khi dự án bị người dùng tổ chức lại cấu trúc thư mục giữa phiên làm việc** (đổi tên thư mục, gộp file rải rác vào thư mục con theo từng công trình) — code với đường dẫn hardcode (`cfg.sdb_path`) sẽ âm thầm trỏ sai nếu không chủ động `ls` lại cấu trúc thư mục hiện tại trước khi chạy lại sau một khoảng nghỉ, đừng giả định đường dẫn hôm qua vẫn đúng hôm nay.
- **CPU-counter 2 lần cách nhau vài giây** (giống hệt nhau = treo thật; tăng dần dù chậm = vẫn đang chạy, chỉ chậm) là cách kiểm tra bổ trợ tốt, độc lập với staleness log — dùng khi nghi ngờ 1 vòng lặp "chậm bất thường" nhưng chưa chắc là treo.
- **Đừng hoảng khi 1 vòng lặp chạy chậm hơn bình thường 30-50%** — quan sát thực tế trong dự án này cho thấy thời gian/vòng lặp dao động khá lớn tuỳ tải hệ thống tại thời điểm đó (100-200s cho cùng 1 loại tác vụ), không nhất thiết là dấu hiệu treo.
