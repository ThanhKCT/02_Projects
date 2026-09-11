# Kinh nghiệm từ dự án "MOFDA vs MOSFOA — đối sánh thuật toán trên cầu tàu 100.000 DWT" — tổng hợp lỗi đã gặp để rút kinh nghiệm cho dự án sau

> Viết sau khi dự án hoàn thành (30+30 lần chạy độc lập, phân tích IGD/HV/Wilcoxon/đường cong hội tụ/dồn biên, bài báo đối sánh đã hoàn thiện bản nháp). File này **không lặp lại** những gì đã ghi ở các file dưới đây — chỉ ghi những gì MỚI phát sinh riêng ở dự án này. Đọc các file sau **trước**, rồi mới đọc file này:
> - [Cach ket noi_SAP2000_MATLAB_OPTIMIZATION.md](Cach%20ket%20noi_SAP2000_MATLAB_OPTIMIZATION.md) — kinh nghiệm gốc SAP2000↔MATLAB (COM automation, `-r` vs `-batch`, checkpoint/watchdog...).
> - [Kinh nghiem MOFDA.md](Kinh%20nghiem%20MOFDA.md) — kinh nghiệm dự án MOFDA đơn thuật toán trước đó (sửa `.docx` qua XML, kỷ luật kiểm tra trích dẫn/overclaim). Dự án này **dùng lại** đúng kỷ luật đó (mục 3 dưới đây), không lặp lại chi tiết.
> - `Tap chi XD_SFOA/KE SAU CAU/Kinh nghiem SFOA.md` (dự án khác, cùng tác giả) — bug watchdog/`.sdb` khác, đáng đọc chéo.

---

## 1. `matlab -batch` an toàn (và nhanh hơn) cho script HẬU XỬ LÝ THUẦN TUÝ — chỉ campaign chạy SAP2000 mới cần `-r`

Quy tắc "dùng `-r`, không dùng `-batch`" ở [[sap2000-matlab-optimization-lessons]] chỉ áp dụng cho script **gọi SAP2000 OAPI qua `SM.*`/COM**. Dự án này xác nhận thêm: với script chỉ đọc lại các file `.mat` đã lưu sẵn để tính GD/IGD/HV/Wilcoxon/vẽ hình (không mở SAP2000), `matlab -batch` chạy ổn định và nhanh hơn `-r` (không cần khởi động desktop ẩn). **Bài học tổng quát**: trước khi mặc định dùng `-r` cho MỌI lệnh MATLAB, tự hỏi "script này có gọi COM/SAP2000 không?" — nếu không, `-batch` là lựa chọn đúng và đơn giản hơn.

### 1.1. Nhưng cẩn thận: đường dẫn tương đối kiểu forward-slash trong `load()`/hàm I/O có thể KHÔNG resolve đúng dù `cd()` đã đúng thư mục

Gặp lỗi `"X is not found in the current folder or on the MATLAB path, but exists in: <đúng thư mục hiện tại>"` khi gọi `load('results/file.mat')` (forward-slash, tương đối) bên trong một script được `run()` sau khi đã `cd()` đúng — dù thông báo lỗi tự thừa nhận file "exists in" đúng thư mục hiện tại. **Cách sửa**: dùng đường dẫn TUYỆT ĐỐI kiểu Windows (backslash) cho tham số của các hàm đọc/ghi file (`load`, `save`, `fopen`...) trong script MATLAB, đừng tin đường dẫn tương đối forward-slash dù `cd()`/`addpath()` chấp nhận nó bình thường. **Bài học tổng quát**: `cd()` và `addpath()` khoan dung với forward-slash, nhưng các hàm I/O file (`load`/`save`/`fopen`) trên máy Windows này thì không đáng tin cậy với đường dẫn tương đối forward-slash — luôn dùng đường dẫn tuyệt đối cho các hàm này.

---

## 2. Chỉ số Hypervolume (HV) PHẢI dùng điểm tham chiếu W **CỐ ĐỊNH** khi so sánh nhiều lần chạy/nhiều thuật toán — không dùng lại W thích ứng đã lưu sẵn cho mục đích khác

Cả hai script campaign (`run_mofda_wharf100dwt_parallel.m`, `run_emosfoa_wharf100dwt_parallel.m`) đã lưu sẵn `History.Hypervolume` mỗi vòng lặp, nhưng dùng **W thích ứng theo từng vòng** (`max(REP.pos_fit,[],1)*1.1`, tính lại mỗi lần) — hợp lý để xem xu hướng hội tụ NỘI BỘ một lần chạy (HV tăng dần theo iteration), nhưng **hoàn toàn sai** nếu dùng trực tiếp để so sánh HV giữa các lần chạy khác nhau hoặc giữa 2 thuật toán, vì W khác nhau ở mỗi lần chạy/vòng lặp thì các con số HV không cùng thang đo. Phải tính lại HV từ `History.ArchiveFitness` (snapshot fitness thô đã lưu sẵn) với **một W cố định duy nhất, dùng chung cho toàn bộ 60 lần chạy (2 thuật toán × 30 lần) và toàn bộ đường cong hội tụ** — ở đây chọn W = nadir của toàn bộ tổ hợp khả thi (không tính tổ hợp bị phạt cứng) × 1,05 để đảm bảo không nghiệm khả thi nào (kể cả nghiệm dở của lần chạy hội tụ kém) vượt qua W ở bất kỳ trục nào. **Bài học tổng quát**: khi thiết kế script lưu chỉ số hội tụ (HV, hay bất kỳ chỉ số phụ thuộc điểm tham chiếu/chuẩn hoá nào) cho MỘT lần chạy, cân nhắc trước liệu chỉ số đó có cần dùng lại để SO SÁNH CHÉO nhiều lần chạy sau này không — nếu có, nên lưu **cả 2 phiên bản** (thích ứng cho theo dõi nội bộ + công thức để tính lại với chuẩn cố định), tránh phải suy luận lại/tính lại từ dữ liệu thô như ở đây (may mắn vẫn khả thi vì `ArchiveFitness` đã được lưu sẵn).

---

## 3. Vẽ mặt Pareto trên nền "tổ hợp khả thi" phải phân biệt khả thi-có-bị-phạt-mềm và khả thi-không-bị-phạt

Không gian 4.080 tổ hợp có 3.337 "khả thi" (không bị phạt cứng), nhưng phần lớn trong số đó (3.084/3.337) vẫn bị phạt MỀM (vi phạm ràng buộc mức nhẹ, `g_total>0`, fitness đã bị nhân hệ số phạt `1+C·g_total`) nên giá trị fitness hiển thị đã bị THỔI PHỒNG rất lớn (f1 tới ~67.000 tấn so với mặt Pareto thật chỉ 3.300-5.200 tấn). Lần vẽ đầu tiên dùng cả 3.337 điểm làm nền khiến mặt Pareto thật (59 điểm) bị nén vào một góc nhỏ xíu, không nhìn được gì. **Cách sửa**: chỉ dùng tập con **thực sự không bị phạt** (`g_total==0`, ở đây 253/3.337) làm nền để hình vẽ có ý nghĩa — các điểm này phản ánh đúng vùng đánh đổi thật, mặt Pareto nổi rõ như đường bao dưới-trái của đám mây điểm này. **Bài học tổng quát**: khi trực quan hoá kết quả tối ưu có hàm phạt, luôn kiểm tra xem "khả thi" trong dữ liệu có đồng nghĩa với "không bị phạt" hay không trước khi chọn tập nền để vẽ — nếu có phạt mềm, phải lọc riêng, không gộp chung.

---

## 4. Trước khi tự trích dẫn "bài báo trước của nhóm" là tài liệu tham khảo [n], XÁC NHẬN LẠI bài đó còn đang được nộp/đăng hay đã bị RÚT

Bài đối sánh này ban đầu được viết dựa trên giả định bài báo 243-tổ-hợp cũ (`JMST V5.docx`, "đã hoàn thiện qua 3 vòng góp ý", cùng đối tượng công trình) vẫn là một bài báo sẽ được công bố riêng, nên đã tự trích dẫn nó làm tài liệu tham khảo [3] và viết phần lớn Mục 1/2/3/6/7 theo khung "so với nghiên cứu trước [3]" (mở rộng không gian thiết kế, bổ sung ràng buộc địa kỹ thuật... so với bài đó). Khi người dùng xác nhận bài đó **đã bị rút, không đăng nữa** (nội dung gộp thẳng vào bài đang viết), toàn bộ khung so sánh này trở thành SAI LOGIC — không thể "so với nghiên cứu trước" một bài không tồn tại để trích dẫn. Phải: (i) xoá hẳn trích dẫn [3] khỏi danh mục tham khảo, đánh số lại toàn bộ các mục sau; (ii) grep toàn văn "nghiên cứu trước"/"[3]" và viết lại MỌI đoạn liên quan thành trình bày trực tiếp nội dung của chính bài đang viết (không còn ngụ ý có một bài đã công bố đứng sau) — ảnh hưởng tới ít nhất 8 đoạn rải khắp 5 mục khác nhau, không chỉ 1-2 chỗ. **Bài học tổng quát**: "bài báo trước của nhóm, đã hoàn thiện qua N vòng góp ý" KHÔNG đồng nghĩa với "sẽ được công bố/có thể tự trích dẫn" — trạng thái xuất bản (nộp/rút/công bố) có thể thay đổi độc lập với chất lượng bản thảo. Khi một dự án MỚI dự kiến tự trích dẫn một dự án CŨ của cùng nhóm làm tài liệu tham khảo, hỏi thẳng người dùng xác nhận trạng thái công bố hiện tại của bài cũ đó **trước khi viết phần lớn nội dung dựa trên giả định nó sẽ được trích dẫn** — không tự suy đoán từ ghi chú "đã hoàn thiện" trong bộ nhớ/hồ sơ dự án trước, vì ghi chú đó chỉ phản ánh trạng thái tại thời điểm ghi, không phải trạng thái hiện tại.

---

## 5. Số liệu chuẩn hoá/tỷ lệ phần trăm trong output log cần ghi rõ MẪU SỐ ngay tại chỗ in ra — tránh gây hiểu lầm khi đọc lại

Dòng log "So nghiem trung khop chinh xac mat Pareto that (/59): mean=99.77" khiến người đọc (kể cả khi phân tích lại) dễ hiểu lầm 99,77 là % trên 59 nghiệm tham chiếu — thực ra mẫu số đúng là kích thước kho lưu trữ (100 nghiệm/lần chạy), số 59 trong ngoặc chỉ là kích thước mặt Pareto tham chiếu để đối chiếu ngữ cảnh, không phải mẫu số của con số thống kê. Phải dừng lại kiểm tra code tính toán (`for i = 1:size(fRun,1) ... if any(all(...))`) để xác nhận chính xác trước khi diễn giải trong bài báo. **Bài học tổng quát**: khi in ra một tỷ lệ/số đếm có khả năng gây hiểu lầm về mẫu số, ghi rõ MẪU SỐ THẬT ngay trong chuỗi định dạng (`fprintf`) thay vì chỉ ghi một con số ngữ cảnh trong ngoặc — tránh phải suy luận ngược lại từ code mỗi lần đọc log.

**⚠️ Cập nhật quan trọng — xác nhận đây KHÔNG chỉ là rủi ro lý thuyết mà là bug THẬT, người dùng (đóng vai phản biện) đã phát hiện chính xác**: khi bài báo được góp ý chốt bản thảo, phản biện nghi ngờ đúng con số 99,77/100 này và yêu cầu định nghĩa lại "Pareto coverage = số nghiệm PHÂN BIỆT trong 59/59". Viết script riêng đếm lại đúng định nghĩa (`compute_pareto_coverage.m`, duyệt từng điểm trong 59 điểm tham chiếu, kiểm tra có ít nhất 1 nghiệm trong repository khớp) cho kết quả **khác hẳn** số cũ: MOFDA thật ra chỉ phủ 52,67/59 = 89,27% (không phải 99,77%), MOSFOA chỉ phủ 58,27/59 = 98,76% (không phải 100%). Khoảng cách giữa hai thuật toán THẬT còn lớn hơn số liệu cũ tưởng nhầm là "cả hai gần như bão hoà". **Bài học tổng quát bổ sung**: khi một chỉ số đếm/tỷ lệ có 2 mẫu số hợp lý cùng tồn tại trong bài toán (ở đây: kích thước kho lưu trữ 100 và kích thước tập tham chiếu 59), và code chỉ tính theo MỘT trong hai mà không nói rõ, đừng tin số liệu "trông hợp lý" (vd 99,77% gần 100% "nghe có vẻ đúng vì thuật toán tốt") — phải tự hỏi "con số này đúng là đang đếm cái gì, trên mẫu số nào" và viết lại phép đếm từ dữ liệu thô nếu còn nghi ngờ, đặc biệt khi kích thước 2 tập khác nhau (100 vs 59) mà chỉ số lại được trình bày như thể chúng cùng một mẫu số.

---

## 6. Giám sát campaign N-lần-chạy qua Monitor: lọc theo mốc (mỗi 5/10 lần), không lọc theo TỪNG lần — cảnh báo lặp vô hại (`Warning`) gây nhiễu

Bộ lọc `grep` ban đầu cho Monitor bắt cả dòng cảnh báo MATLAB lặp lại vô hại mỗi lần chạy ("Files that have already been attached are being ignored" — do tái sử dụng parallel pool giữa 30 lần chạy) khiến mỗi lần chạy (30 lần MOFDA + 30 lần MOSFOA = 60 lần) đều tạo ra 1-2 thông báo, rất nhiễu. Đã sửa lại: chỉ bắt các dòng tiến độ ở mốc cố định (`lan (5|10|15|20|25|30)/30`), lỗi thật, và dòng tổng kết cuối — bỏ hẳn `Warning` khỏi bộ lọc vì đã xác nhận là vô hại và lặp lại đều đặn. **Bài học tổng quát**: với campaign N-lần-lặp (N≥10), thiết kế bộ lọc Monitor lấy mẫu theo MỐC (vd mỗi 1/6 hoặc 1/10 tổng số) ngay từ đầu, không lọc theo "mọi dòng khớp một từ khoá tiến độ" — và loại trừ tường minh các cảnh báo đã biết là lặp lại/vô hại (thay vì chờ phát hiện nhiễu rồi mới sửa).

---

## 7. Vòng góp ý "chốt bản thảo" (siết khoa học/khách quan) — các khuôn diễn đạt nên áp dụng NGAY từ bản nháp đầu, không đợi phản biện chỉ ra

Một vòng góp ý chi tiết (21 mục) yêu cầu sửa cách trình bày/lập luận (không đổi số liệu tính toán, trừ đúng 1 chỗ ở mục 5/8) đã chỉ ra một số mẫu lỗi diễn đạt LẶP LẠI nhiều lần trong bản thảo ban đầu — đáng áp dụng ngay từ lần viết đầu tiên cho dự án đối sánh thuật toán tiếp theo, thay vì phải sửa hàng loạt sau:

- **Đơn vị so sánh phải nhất quán khi 2 thuật toán có cấu trúc vòng lặp khác nhau**: MOFDA (`maxiter=50`, mỗi vòng lặp $\beta+1=5$ lần đánh giá/cá thể) và E-MOSFOA (`Max_it=250`, mỗi vòng lặp 1 lần đánh giá/cá thể) có số vòng lặp KHÔNG bằng nhau dù tổng FE bằng nhau — mọi câu so sánh tốc độ hội tụ phải dùng FE (số lần đánh giá FEM) làm đơn vị, TUYỆT ĐỐI không viết "X cần ít vòng lặp hơn" hay đặt song song "(tương đương N vòng lặp)" của 2 thuật toán cạnh nhau, vì điều đó ngầm coi 2 cấu trúc vòng lặp có thể so sánh trực tiếp.
- **Không dùng p-value một mình để tuyên bố "hiệu quả kỹ thuật lớn"**: một chỉ số có p rất nhỏ (vd HV p=6,5×10⁻¹¹) vẫn phải đi kèm nhận xét về ĐỘ LỚN chênh lệch tuyệt đối nếu chênh lệch đó nhỏ (ở đây HV hai thuật toán chỉ khác nhau ở chữ số thập phân thứ 2-3 dù p cực nhỏ, vì cỡ mẫu 30 đủ lớn để phát hiện chênh lệch rất nhỏ). Nguyên tắc: p-value trả lời "có khác biệt hay không", không trả lời "khác biệt có đáng kể về mặt kỹ thuật hay không" — hai câu hỏi này phải tách riêng trong văn bản.
- **Giải thích cơ chế gây ra khác biệt quan sát được luôn dùng khuôn "phù hợp với giả thuyết rằng..." / "có thể góp phần"**, không dùng khuôn khẳng định nhân-quả trực tiếp ("X là nguyên nhân làm Y nhanh hơn"), trừ khi có phân tích độ nhạy/ablation tách riêng từng cơ chế (mà dự án dạng "đối sánh 2 thuật toán đã có sẵn" thường không làm và không nên làm nếu phạm vi nghiên cứu không yêu cầu).
- **Phần mô tả thuật toán (kiểu Mục 4) không nên kể lại chi tiết % cải thiện của case study/benchmark trong bài báo GỐC** nếu con số đó không trực tiếp phục vụ phép so sánh hiện tại — dễ đọc thành "quảng bá" trước khi vào thí nghiệm, và không cần thiết cho mục tiêu "giúp người đọc hiểu nguyên lý + tham số dùng trong nghiên cứu này".
- **Câu kết luận không nên khẳng định ưu thế phổ quát** ("X là thuật toán tốt hơn") dù kết quả thực nghiệm ủng hộ rõ ràng trong phạm vi bài toán đã khảo sát — luôn đóng khung bằng "trong bài toán khảo sát"/"trong phạm vi nghiên cứu", và có thể thêm hẳn 1 câu tường minh kiểu "không đủ cơ sở để khẳng định ưu thế phổ quát của thuật toán đối với các bài toán kết cấu khác" ở đoạn kết.

---

## 8. Checklist rút gọn cho dự án đối sánh thuật toán tiếp theo (bổ sung vào checklist đã có ở `Kinh nghiem MOFDA.md` mục 4)

1. [ ] Script hậu xử lý (không gọi SAP2000) → `matlab -batch`, không cần `-r`; nhưng dùng đường dẫn TUYỆT ĐỐI (backslash) cho `load`/`save`/`fopen`, không tin đường dẫn tương đối forward-slash (mục 1).
2. [ ] HV (hay bất kỳ chỉ số cần điểm/chuẩn tham chiếu) dùng để SO SÁNH CHÉO nhiều lần chạy/thuật toán → phải dùng MỘT điểm tham chiếu cố định chung, không dùng lại giá trị đã lưu sẵn cho mục đích theo dõi hội tụ nội bộ (mục 2).
3. [ ] Vẽ mặt Pareto trên nền tổ hợp khả thi → lọc riêng tập "không bị phạt mềm" (`g_total==0`), không gộp chung với tổ hợp bị phạt (mục 3).
4. [ ] Trước khi tự trích dẫn bài báo trước của nhóm làm tài liệu tham khảo → hỏi xác nhận trạng thái công bố HIỆN TẠI (còn nộp hay đã rút), đừng suy đoán từ ghi chú "đã hoàn thiện" trong hồ sơ cũ (mục 4).
5. [ ] Mọi tỷ lệ/số đếm chuẩn hoá in ra log → ghi rõ mẫu số thật trong chính chuỗi `fprintf`; khi có 2 mẫu số hợp lý cùng tồn tại (vd kích thước archive vs kích thước tập tham chiếu), viết lại phép đếm từ dữ liệu thô để xác nhận đang dùng đúng mẫu số nào (mục 5).
6. [ ] Monitor campaign N-lần-lặp → lọc theo mốc cố định + loại trừ cảnh báo lặp vô hại ngay từ đầu, không lọc theo mọi dòng tiến độ (mục 6).
7. [ ] Viết bản thảo đối sánh thuật toán lần đầu đã áp dụng ngay: FE (không phải vòng lặp) làm đơn vị so sánh tốc độ; p-value đi kèm nhận xét độ lớn chênh lệch tuyệt đối; giải thích cơ chế dùng khuôn giả thuyết; không kể lại % case study cũ không liên quan; kết luận đóng khung trong phạm vi bài toán khảo sát (mục 7).
