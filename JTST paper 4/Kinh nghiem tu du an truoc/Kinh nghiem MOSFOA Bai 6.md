# Kinh nghiệm từ dự án "MOSFOA Bài 6 — hệ kết cấu bên trên cầu tàu" — tổng hợp lỗi đã gặp để rút kinh nghiệm cho dự án sau

> Viết sau khi campaign chính thức hoàn thành (20/20 lần chạy độc lập hợp lệ, Npop=20/Max_it=100/Num_work=8, ~5,8 giờ/run). File này **không lặp lại** những gì đã ghi ở các file dưới đây — chỉ ghi những gì MỚI phát sinh riêng ở dự án này, đặc biệt là **2 lỗi nghiêm trọng chỉ bị phát hiện NGAY TRƯỚC/TRONG khi chạy campaign dài ngày**, dù đã đọc kỹ cả 5 file kinh nghiệm cũ trước khi viết code. Đọc các file sau **trước**, rồi mới đọc file này:
> - [Cach ket noi_SAP2000_MATLAB_OPTIMIZATION.md](Cach%20ket%20noi_SAP2000_MATLAB_OPTIMIZATION.md) — kinh nghiệm gốc SAP2000↔MATLAB.
> - [Kinh nghiem MOSFOA Paper 2.md](Kinh%20nghiem%20MOSFOA%20Paper%202.md) — 3 lỗi "im lặng" đã biết (JointDispl GroupElm, tên combo, FrameForce off-by-one) + kiến trúc watchdog.
> - [Kinh nghiem SFOA.md](Kinh%20nghiem%20SFOA.md), [Kinh nghiem MOFDA.md](Kinh%20nghiem%20MOFDA.md), [Kinh nghiem MOFDA vs MOSFOA.md](Kinh%20nghiem%20MOFDA%20vs%20MOSFOA.md).

---

## 1. ⚠️ LỖI NGHIÊM TRỌNG NHẤT — thiếu `rng()` khiến "N lần chạy độc lập" thực chất chạy CÙNG 1 chuỗi ngẫu nhiên

**Phát hiện**: kiến trúc watchdog (mỗi lần chạy độc lập = 1 tiến trình `matlab.exe` RIÊNG, đã dùng từ Bài 1/2) có một hệ quả không ai để ý: **MATLAB mặc định dùng CÙNG 1 seed khởi động cho MỌI tiến trình mới**, trừ khi tự gọi `rng('shuffle')`. Đã kiểm chứng thực nghiệm: 2 tiến trình `matlab -batch` độc lập hoàn toàn cho **CHÍNH XÁC** cùng giá trị `rand()` và `randperm()`.

**Hệ quả nếu không sửa**: `run_mosfoa2_parallel.m` (Bài 2) và bản gốc `run_emosfoa_wharf100dwt_parallel.m` (Bài 1) **ĐỀU KHÔNG có `rng()`**. Nghĩa là **kết quả "20/20 (hoặc 40/40) lần chạy khớp tuyệt đối, std=0" đã công bố ở Bài 2 có khả năng cao là do TOÀN BỘ các lần chạy dùng đúng 1 seed** (vì mỗi lần chạy = 1 tiến trình MATLAB mới, không có gì làm nó khác đi) — **không phải bằng chứng thật về độ ổn định thuật toán**. Đây là phát hiện xuyên dự án, cần cân nhắc xem lại Bài 2 nếu chưa nộp/công bố.

**Cách sửa (đã áp dụng cho Bài 6, xem `run_mosfoa6_parallel.m`)**:
```matlab
if isfile(ckptFile)
    S = load(ckptFile);
    rng(S.rngStateAtResume);   % RESUME: khoi phuc DUNG trang thai cu, KHONG tao seed moi
else
    rng('shuffle');            % LAN DAU: seed moi theo thoi gian he thong
    s0 = rng(); rngSeedUsed = s0.Seed;  % LUU LAI de truy vet/tai lap
end
...
% Trong saveCheckpointAtomic: luu ca rngSeedUsed VA rng() hien tai (khong
% chi seed goc) - vi trang thai RNG tien trien qua tung vong lap, resume
% phai khoi phuc DUNG trang thai tai thoi diem checkpoint, khong phai seed
% ban dau (neu chi luu seed goc va rng(seed) lai tu dau khi resume, se LAP
% LAI dung chuoi ngau nhien da dung cho cac vong truoc do - sai).
```

**Đã kiểm chứng sống**: kill MATLAB giữa chừng (vòng 1/3) → relaunch → resume đúng vòng 2/3 **và giữ đúng seed cũ** (in ra log để đối chiếu). Sau khi sửa, 20 lần chạy Bài 6 cho **các archive khác nhau thật sự** (kích thước 72-84, dao động tự nhiên) nhưng **min-f1 giống hệt nhau ở cả 20 run (std=0,0000)** — đây mới là dạng bằng chứng ổn định ĐÁNG TIN CẬY (nhiều điểm khởi đầu ngẫu nhiên khác nhau đều hội tụ về cùng 1 optimum), khác hẳn "giống hệt vì cùng seed".

**Bài học tổng quát — QUAN TRỌNG NHẤT của cả file này**: bất kỳ kiến trúc nào dùng "mỗi lần chạy độc lập = 1 tiến trình MATLAB mới" (watchdog pattern đã dùng xuyên suốt chuỗi dự án này) **BẮT BUỘC phải có `rng('shuffle')` + lưu lại seed thật** ngay từ dòng code đầu tiên, và **seed phải được khôi phục đúng (không phải reseed) khi resume từ checkpoint**. Kiểm tra ngay bằng cách chạy 2 tiến trình độc lập và in `rand()` — nếu giống nhau, chưa sửa đúng.

---

## 2. Bug "im lặng" MỚI — SAP2000 COM glitch thoáng qua trả về `NumberResults=0` cho TOÀN BỘ đại lượng, không báo lỗi

Khác với 3 bug "im lặng" đã biết ở Bài 2 (sai tham số API, sai thứ tự cột, tên combo lệch — đều là LỖI CODE cố định, luôn sai giống nhau mọi lần gọi), lỗi này là **SAP2000 tự thoáng qua trả về rỗng cho MỘT LẦN gọi cụ thể** (không phải lỗi code, không tái diễn cùng 1 chỗ) — quan sát được lặp lại ~2 lần trong 1 run 2020 lần đánh giá (tần suất thấp nhưng không phải hiếm).

**Hệ quả nghiêm trọng**: khi `NumberResults=0`, code (đúng logic, không phải bug) giữ nguyên giá trị khởi tạo `= 0` cho M_Ed → η_max=0 (một fitness "hoàn hảo giả", vì thiết kế nào cũng có mô-men uốn thật > 0 khi chịu tải). MOSFOA sau đó CHỌN điểm giả này làm leader (`selectLeader`), kéo nhiều cá thể khác hội tụ theo hướng sai → **sụp toàn bộ archive từ 60 điểm xuống còn 2 điểm chỉ trong 1 thế hệ**, và KHÔNG hồi phục lại cho đến hết run (MOSFOA tiếp tục "khai thác" quanh điểm giả này).

**Cách phát hiện**: archive/Repository size giảm ĐỘT NGỘT (>10 điểm trong 1 thế hệ) là dấu hiệu bất thường tuyệt đối — MOO hợp lệ chỉ co giãn từ từ, không bao giờ sụp mạnh như vậy trừ khi có 1 điểm áp đảo bất thường. Kiểm tra: cùng 1 giá trị x đã biết kết quả thật (vd baseline) mà lần này cho fitness khác hẳn (đặc biệt về 0 tuyệt đối) → gần như chắc chắn là lỗi trích xuất, không phải kết quả thật.

**Cách sửa (đã áp dụng, `evaluate_superstructure_design.m`)**: thêm 1 bước kiểm tra bảo vệ ngay sau khi trích xong TẤT CẢ đại lượng phản hồi (M_DN, M_DD, M_DCT, M_BMC, N_max_pile, U_max) — nếu **TẤT CẢ đồng thời bằng 0** (vô lý về vật lý cho 1 kết cấu đang chịu tải thật), coi là lỗi trích xuất và trả về infeasible ngay, KHÔNG chấp nhận làm kết quả:
```matlab
if M_DN==0 && M_DD==0 && M_DCT==0 && M_BMC_per_m==0 && N_max_pile==0 && U_max==0
    fit = [1e12, 1e12]; diagnostic.feasible = false;
    warning(...); return;
end
```
**Đã xác nhận sống**: sau khi vá, glitch y hệt vẫn xảy ra (~2 lần/run, in warning rõ ràng) nhưng archive **không còn sụp** — Repository tiếp tục tăng bình thường qua đúng điểm đã từng sụp ở lần chạy trước.

**Bài học tổng quát**: với BẤT KỲ pipeline SAP2000-in-the-loop nào, luôn thêm 1 lớp "sanity check vật lý" cuối cùng trước khi chấp nhận kết quả của 1 lần đánh giá — không chỉ kiểm tra `ret`/exception (những lỗi ồn ào), mà còn kiểm tra **giá trị có hợp lý về mặt vật lý không** (vd không thể TẤT CẢ nội lực/chuyển vị của 1 kết cấu chịu tải đều bằng 0 tuyệt đối cùng lúc). Đây là lớp phòng thủ khác hẳn việc "đếm đúng cột API" (mục 3 dưới) — cả 2 đều cần thiết, không thay thế nhau được.

---

## 3. Lỗi đơn vị: Tonf→kgf KHÔNG cần hệ số g (chỉ ×1000), nhưng Tonf→kN CẦN hệ số g (×9,80665) — rất dễ nhầm 2 phép quy đổi này với nhau

Phát hiện qua rà soát trước campaign (không phải qua chạy thật): `sigma_pile_kGcm2 = N_max_T*1000/9.80665 / (A_m2*1e4)` — sai vì **1 Tonf (tấn-lực) = 1000 kgf theo ĐỊNH NGHĨA** (cả 2 đều dùng cùng gia tốc chuẩn trong định nghĩa của chúng, gia tốc TRIỆT TIÊU khi quy đổi giữa 2 đơn vị lực kiểu "trọng lượng"), **không cần chia thêm cho g**. Ngược lại, Tonf→kN (đơn vị lực SI thuần) **THẬT SỰ CẦN** nhân 9,80665 (vì kN không dựa trên "trọng lượng chuẩn" như kgf/Tonf). Code cũ nhầm lẫn 2 loại quy đổi này, khiến ứng suất cọc tính RA THẤP HƠN THẬT ~9,8 LẦN (82,6 thay vì đúng ~810 kG/cm²) — không đổi kết luận khả thi (vẫn dư margin) nhưng SAI SỐ LIỆU nếu đưa vào bài báo.

**Bài học tổng quát**: khi mô hình SAP2000 dùng đơn vị nội bộ kiểu "trọng lượng" (Tonf, kgf — phổ biến ở công trình Việt Nam/châu Á), luôn phân biệt rõ 2 loại quy đổi: **quy đổi NỘI BỘ giữa các đơn vị trọng lượng** (Tonf↔kgf↔lbf, chỉ là hệ số tỷ lệ thuần túy, KHÔNG có g) và **quy đổi SANG đơn vị lực SI/vật lý thuần** (N, kN — CẦN g=9,80665). Viết công thức quy đổi xong, luôn thử tính tay 1 ví dụ đơn giản để kiểm chứng thứ nguyên trước khi tin.

---

## 4. `AreaForceShell` xác nhận LẦN THỨ 2, ĐỘC LẬP — có ĐÚNG 25 output, không phải 21/22 như tài liệu CSI hay được trích dẫn

`Kinh nghiem SFOA.md` mục 1.3 đã từng ghi "AreaForceShell có đúng 25 output" nhưng chỉ là 1 dòng ghi chú không kèm chi tiết. Dự án này **tự kiểm chứng lại độc lập bằng thực nghiệm sống** (gọi hàm với `nargout` tăng dần từ 30 xuống, tìm N lớn nhất không báo lỗi "too many output arguments", rồi in giá trị từng vị trí để đối chiếu tay) và xác nhận lại: **25 output là đúng**, gồm 21 trường theo tài liệu chuẩn (NumberResults...MAngle) **cộng thêm 3 trường không rõ ý nghĩa** (không cần dùng đến M11/M22 vẫn nằm trong 21 trường đầu, vị trí bracket 17/18 tương ứng — đã xác nhận bằng số liệu live). Code cũ trong dự án này (viết theo suy đoán từ tài liệu, chưa kiểm chứng live) đặt SAI vị trí M11/M22 (lệch 2 vị trí) — dù không gây lỗi rõ ràng (vẫn chạy, vẫn ra số) vì 2 trường lân cận tình cờ đọc được giá trị hợp lý về độ lớn, chỉ phát hiện được nhờ chủ động kiểm chứng, không phải nhờ quan sát lỗi.

**Bài học tổng quát**: giờ có 2 dự án độc lập cùng xác nhận 25 output cho `AreaForceShell` — nên coi đây là **sự thật đã xác lập** cho các dự án sau (không cần tự kiểm chứng lại từ đầu), nhưng vẫn nên viết 1 script `diagnose_areaforceshell.m` kiểu này CHO BẤT KỲ hàm OAPI nhiều-output nào lần đầu dùng trong dự án mới — đếm lại bằng thực nghiệm, không dựa vào "có vẻ đúng vì không báo lỗi".

---

## 5. Chỉ đọc `U1` (1 phương ngang) có thể bỏ sót chuyển vị ngang thật nếu tải có nhiều phương

Phát hiện qua rà soát (không phải qua chạy thật): code ban đầu chỉ trích `U1` từ `JointDispl` để tính chuyển vị ngang lớn nhất, nhưng công trình có tải neo tàu (NEO1/NEO2) và va tàu (VA1/VA2) tác động theo **cả 2 phương X và Y** (U1 và U2) tùy tổ hợp. Nếu tổ hợp bao gồm nhiều tải theo phương Y, chuyển vị ngang thật (hợp của U1, U2) có thể lớn hơn nhiều so với chỉ riêng U1 — làm ràng buộc chuyển vị bị đánh giá dễ dãi hơn thực tế. Đã sửa dùng `sqrt(U1^2+U2^2)` (nhất quán với cách đã dùng cho mô-men `sqrt(M2^2+M3^2)`).

**Bài học tổng quát**: khi trích "chuyển vị ngang" hay bất kỳ đại lượng vector nào từ SAP2000, luôn xác nhận **TẤT CẢ các phương liên quan** đã được xét đến, không chỉ phương "trực giác nghĩ tới đầu tiên" — đặc biệt khi mô hình có tải theo nhiều phương khác nhau (neo tàu, va tàu, gió, dòng chảy).

---

## 6. Rà soát kỹ thuật MỘT LẦN, do CHÍNH NGƯỜI DÙNG soạn checklist 25 mục, bắt được CẢ 3 lỗi trên trước khi campaign dài ngày bắt đầu

Người dùng gửi 1 checklist rà soát rất chi tiết (25 mục: design variables, objective/constraint, 410 tổ hợp, stale-results test, extreme-design test, run log, unit audit, code freeze...) NGAY TRƯỚC khi launch campaign chính thức (dù đã có pilot PASS trước đó). Việc rà soát này bắt được **cả 3 lỗi ở mục 1, 3, 5** — không lỗi nào trong 3 lỗi này bị phát hiện qua pilot 5,94 giờ chạy trước đó (vì pilot chỉ chạy 1 lần, không có run thứ 2 để lộ ra vấn đề seed; ứng suất cọc và U1/U2 không gây crash hay giá trị bất thường rõ ràng để tự phát hiện qua quan sát log).

**Bài học tổng quát — nên áp dụng SỚM hơn cho dự án sau**: 1 lần "pilot chạy được, không lỗi, hội tụ đẹp" **KHÔNG đủ để kết luận code đúng** — pilot chỉ kiểm tra được "pipeline không crash", không kiểm tra được tính ĐÚNG ĐẮN của giả định (đơn vị, phạm vi biến, seed). Nên tự soạn (hoặc yêu cầu) 1 checklist rà soát kiểu này **TRƯỚC pilot**, không phải trước campaign chính thức — sẽ tiết kiệm được việc phải huỷ pilot/campaign đã chạy và làm lại (ở đây may mắn pilot dùng ít tài nguyên hơn campaign nên chi phí phát hiện muộn còn chấp nhận được, nhưng nếu phát hiện lỗi seed SAU KHI đã chạy xong cả 20 run thay vì trước run01, sẽ phải huỷ bỏ TOÀN BỘ ~120 giờ tính toán).

---

## 7. Checklist rút gọn cho dự án MOSFOA/SAP2000-optimization tiếp theo (bổ sung vào các checklist đã có)

1. [ ] Đã thêm `rng('shuffle')` (lần đầu) + lưu/khôi phục `rng()` state đúng cách khi resume checkpoint — đã TỰ KIỂM CHỨNG bằng cách chạy 2 tiến trình độc lập in `rand()` khác nhau, KHÔNG chỉ tin code "trông đúng" (mục 1)?
2. [ ] Đã thêm 1 lớp "sanity check vật lý cuối cùng" trước khi chấp nhận fitness của mỗi lần đánh giá — phát hiện được trường hợp toàn bộ đại lượng phản hồi bằng 0 bất thường (mục 2)?
3. [ ] Mọi công thức quy đổi đơn vị lực (Tonf/kgf/kN/N) đã phân biệt rõ quy đổi NỘI BỘ (không cần g) và quy đổi SANG SI (cần g=9,80665), đã thử tính tay ít nhất 1 ví dụ để kiểm thứ nguyên (mục 3)?
4. [ ] Nếu dùng `AreaForceShell`, đã biết/xác nhận là 25 output thật (mục 4)?
5. [ ] Mọi đại lượng vector (chuyển vị, lực) trích từ SAP2000 đã xét đủ các phương liên quan, không chỉ 1 phương "trực giác" (mục 5)?
6. [ ] Đã tự soạn/áp dụng 1 checklist rà soát kỹ thuật TOÀN DIỆN (biến thiết kế, objective/constraint, đơn vị, stale-result test, extreme-design test) TRƯỚC pilot đầu tiên, không đợi đến trước campaign chính thức (mục 6)?
7. [ ] Nếu phát hiện 1 lần chạy/run bị lỗi giữa campaign dài ngày (archive sụp bất thường, log bất thường...) — đã cách ly (move sang thư mục `invalidated_*`) và chạy lại DUY NHẤT run đó với code đã vá, không trộn lẫn dữ liệu trước/sau vá, không phải huỷ bỏ toàn bộ campaign?
