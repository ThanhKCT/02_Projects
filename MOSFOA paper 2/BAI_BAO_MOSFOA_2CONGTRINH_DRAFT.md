> **Ghi chú soạn thảo (xoá trước khi đưa vào docx):** Bản thảo này soạn theo đúng khung mục lục ở `Yeu_cau_trien_khai_Bai_2.md` mục 12 (đã tương thích cấu trúc `JMST-Template.docx`). Số liệu bảng/biểu trong mục 6 lấy trực tiếp từ `code/results/Bruteforce_A_FINAL.mat`, `Bruteforce_B_FINAL.mat` và 40 file `MOSFOA2_*_run*_FINAL.mat` (20 lần/công trình, chạy xong 14–15/09/2026). Các mục còn để `[CẦN ĐIỀN]` là chỗ cần tác giả xác nhận thủ công (tên/đơn vị tác giả, danh mục tài liệu tham khảo đầy đủ) — không tự suy diễn theo đúng nguyên tắc của dự án.

---

# TIÊU ĐỀ TIẾNG VIỆT

**ỨNG DỤNG THUẬT TOÁN MOSFOA TỐI ƯU ĐA MỤC TIÊU HỆ CỌC CẦU TÀU: KIỂM CHỨNG TRÊN HAI CÔNG TRÌNH CÓ QUY MÔ VÀ ĐIỀU KIỆN ĐỊA KỸ THUẬT KHÁC NHAU**

# TITLE (ENGLISH)

**APPLICATION OF THE MOSFOA ALGORITHM FOR MULTI-OBJECTIVE OPTIMIZATION OF WHARF PILE SYSTEMS: VERIFICATION ON TWO PROJECTS WITH DIFFERENT SCALE AND GEOTECHNICAL CONDITIONS**

**Tác giả:** [CẦN ĐIỀN — họ tên, học hàm/học vị]¹\*

¹[CẦN ĐIỀN — Khoa/Viện, Trường]

\*Email liên hệ: dangvanhai@hanyang.ac.kr

DOI: https://doi.org/10.65154/jmst.%ID

---

**Tóm tắt**

Bài báo trình bày việc kiểm chứng khả năng áp dụng và tính ổn định của thuật toán tối ưu đa mục tiêu MOSFOA (đã được phát triển và công bố trước đó) khi giải bài toán tối ưu hệ cọc cầu tàu trên hai công trình thực tế có quy mô, tải trọng và điều kiện địa kỹ thuật khác nhau: (A) cầu tàu container 100.000DWT tại Lạch Huyện, Hải Phòng và (B) cầu tàu 30.000DWT tại VIPGreenPort, Đình Vũ, Hải Phòng. Biến thiết kế là chỉ số catalogue cọc ly tâm ứng suất trước AMACCAO (11 đường kính × 3 cấp ứng suất trước = 33 phương án rời rạc); hai mục tiêu là tối thiểu hoá khối lượng vật liệu cọc và tối thiểu hoá chuyển vị ngang lớn nhất đỉnh bến; ràng buộc gồm sức chịu tải cọc theo TCVN 10304:2025, khả năng chịu lực vật liệu và giới hạn chuyển vị vận hành. Quy trình tối ưu kết nối trực tiếp MOSFOA (MATLAB) với mô hình phần tử hữu hạn SAP2000 qua giao diện lập trình OAPI, đánh giá từng phương án bằng phân tích kết cấu thực. Kết quả 20 lần chạy độc lập cho mỗi công trình cho thấy MOSFOA hội tụ chính xác về mặt Pareto tham chiếu (xây dựng bằng phương pháp vét cạn toàn bộ 33 phương án) trong 100% số lần chạy ở cả hai công trình, với kích thước tập nghiệm Pareto ổn định tuyệt đối (6/6 nghiệm, độ lệch chuẩn bằng 0). Kết quả khẳng định MOSFOA duy trì được khả năng tìm kiếm và tính ổn định khi áp dụng cho các bài toán tối ưu hệ cọc cầu tàu thực tế có đặc điểm kỹ thuật khác nhau đáng kể.

**Từ khóa**: *tối ưu đa mục tiêu, MOSFOA, hệ cọc cầu tàu, SAP2000 OAPI, Pareto front, TCVN 10304:2025.*

**Abstract**

This paper verifies the applicability and stability of the multi-objective Sand Cat Swarm/Fox Optimization Algorithm variant MOSFOA (previously developed and published) for solving wharf pile-system optimization problems on two real projects with different scale, load, and geotechnical conditions: (A) a 100,000DWT container wharf at Lach Huyen, Hai Phong, and (B) a 30,000DWT wharf at VIPGreenPort, Dinh Vu, Hai Phong. The design variable is a discrete catalogue index over AMACCAO prestressed centrifugal concrete piles (11 diameters × 3 prestress classes = 33 candidates); the two objectives minimize pile material mass and maximum lateral deck displacement, subject to pile bearing-capacity constraints per TCVN 10304:2025, material strength limits, and an operational displacement limit. The optimization loop couples MOSFOA (MATLAB) directly with SAP2000 finite-element models through the OAPI interface, evaluating every candidate design through genuine structural analysis. Twenty independent runs per project show MOSFOA converging exactly to the reference Pareto front (obtained by exhaustive enumeration of all 33 candidates) in 100% of runs for both projects, with a perfectly stable Pareto set size (6/6 solutions, zero standard deviation across runs). The results confirm that MOSFOA retains its search capability and stability when applied to real wharf pile-optimization problems with substantially different engineering characteristics.

**Keywords**: *multi-objective optimization, MOSFOA, wharf pile system, SAP2000 OAPI, Pareto front, TCVN 10304:2025.*

---

## 1. Mở đầu

Thiết kế hệ cọc cầu tàu bến cảng là bài toán đa mục tiêu điển hình: giảm khối lượng vật liệu (chi phí, tiến độ) thường mâu thuẫn với yêu cầu giảm chuyển vị ngang và bảo đảm sức chịu tải của cọc. Các phương pháp thiết kế truyền thống dựa trên kinh nghiệm và lặp thử-sai khó khai thác hết không gian phương án khả thi, trong khi các thuật toán tối ưu tiến hoá đa mục tiêu (MOO) kết hợp phân tích phần tử hữu hạn (FEM) cho phép khảo sát hệ thống toàn bộ tập nghiệm không trội (Pareto front).

Thuật toán MOSFOA đã được nhóm tác giả phát triển và công bố trong một nghiên cứu trước [1], bước đầu kiểm chứng trên một công trình cầu tàu 100.000DWT. Tuy nhiên, một hạn chế phổ biến của các nghiên cứu ứng dụng thuật toán tối ưu trong kỹ thuật công trình là chỉ kiểm chứng trên **một** case-study, khiến khó khẳng định tính ổn định và khả năng áp dụng rộng của thuật toán khi công trình có quy mô, tải trọng, điều kiện địa chất khác biệt.

Bài báo này **không** đề xuất phát triển hay cải tiến MOSFOA, mà tập trung trả lời câu hỏi khoa học:

> *MOSFOA có duy trì được khả năng tìm kiếm nghiệm Pareto và tính ổn định khi áp dụng cho các bài toán tối ưu hệ cọc cầu tàu thực tế có quy mô, tải trọng và điều kiện địa kỹ thuật khác nhau hay không?*

Để trả lời, MOSFOA được áp dụng độc lập trên hai công trình thực tế tại khu vực Hải Phòng — cầu tàu 100.000DWT (Lạch Huyện) và cầu tàu 30.000DWT (VIPGreenPort) — giữ nguyên đặc điểm mô hình hoá riêng của từng công trình, mỗi công trình chạy 20 lần độc lập và đối chiếu với mặt Pareto tham chiếu xây dựng bằng phương pháp vét cạn.

## 2. Đối tượng và mô hình FEM

### 2.1. Công trình A — Lạch Huyện 100.000DWT

Cầu tàu container 100.000DWT tại Cảng cửa ngõ quốc tế Hải Phòng — Lạch Huyện (đã dùng trong [1]). Mô hình FEM đại diện một phân đoạn tiêu chuẩn dài ~75,0m (14 nhịp × 5,1m), rộng 50,0m, cao trình đỉnh bến +5,50m (Hải đồ), đáy bến −16,0m. Hệ cọc chính gồm 132 cọc ống BTCT ứng suất trước D800‑t130 và 60 cọc ống thép D1016‑t16 phụ trợ (giữ nguyên, không tối ưu). Bê tông cọc M800, dầm/bản M400.

### 2.2. Công trình B — VIPGreenPort 30.000DWT

Cầu tàu 30.000DWT tại VIPGreenPort/Viconship, Đình Vũ, Hải Phòng. Phân đoạn tiêu chuẩn dài ~75,44m, rộng 24,0m, cao trình đỉnh bến +5,50m (Hải đồ), đáy bến −10,60m (giai đoạn 1). Hệ cọc gồm 132 cọc ống BTCT ứng suất trước D700‑t130 (không có cọc thép phụ trợ). Bê tông cọc M600, dầm/bản M350.

### 2.3. So sánh đặc điểm hai công trình

| Thông số | A — Lạch Huyện 100k | B — VIPGreenPort 30k |
|---|---|---|
| Tàu thiết kế | 100.000 DWT | 30.000 DWT |
| Chiều rộng bến | 50,0 m | 24,0 m |
| Số cọc/phân đoạn | 192 (132 BTCT + 60 thép) | 132 (chỉ BTCT) |
| Mác bê tông cọc/dầm | M800 / M400 | M600 / M350 |
| Số tổ hợp tải trọng | 37 | 37 |
| Mô hình biên chân cọc | Lò xo trục U3 rời rạc (178 nút) + ngàm biên | Ngàm cứng tuyệt đối tại chiều dài ngàm ảo (132 nút) |
| Điều kiện áp dụng γ<sub>n</sub> (TCVN 10304:2025) | C2 (γ<sub>n</sub>=1,15) | C2 (γ<sub>n</sub>=1,15) |

Hai công trình khác biệt rõ rệt về quy mô (rộng bến gấp ~2 lần, số cọc/phân đoạn gấp ~1,45 lần), mác vật liệu và cách mô hình hoá điều kiện biên nền cọc — đúng mục tiêu tạo cặp case-study "lớn – nhỏ" để kiểm chứng khả năng áp dụng của MOSFOA trên các điều kiện kỹ thuật khác nhau, không ép hai mô hình FEM về cùng một dạng.

### 2.4. Mô hình FEM và điều kiện biên

Cả hai mô hình được giữ nguyên bản chất gốc theo hồ sơ thiết kế/khai thác thực tế (xem 2.1, 2.2, 2.3), dựng trong SAP2000. Không hiệu chỉnh lại cách mô hình hoá nền của công trình này theo công trình kia.

### 2.5. Kết nối MATLAB–SAP2000

Vòng lặp tối ưu thực hiện theo sơ đồ: MOSFOA sinh phương án (chỉ số catalogue) → MATLAB tham số hoá tiết diện cọc trong mô hình SAP2000 tương ứng qua OAPI (`SetPipe`, gán vật liệu/tiết diện) → chạy phân tích kết cấu (`RunAnalysis`) → đọc nội lực (`FrameForce`) và chuyển vị (`JointDispl`, nhóm `GroupElm`) → kiểm tra ràng buộc → tính f1, f2 → trả kết quả cho MOSFOA tiếp tục tìm kiếm. Hai mô hình SAP2000 của A và B được giữ hoàn toàn tách biệt trong suốt quá trình chạy.

## 3. Xây dựng bài toán tối ưu

### 3.1. Biến thiết kế

Biến thiết kế duy nhất là chỉ số nguyên `x ∈ [1,33]` trỏ vào bảng catalogue cọc ly tâm ứng suất trước AMACCAO (11 đường kính D300–D1200mm × 3 cấp ứng suất trước A/B/C = 33 dòng), mỗi chỉ số xác định trọn bộ cặp (D<sub>cọc</sub>, t<sub>cọc</sub>, Class) — cọc thép phụ trợ ở công trình A giữ cố định, không đưa vào biến tối ưu. Số lượng, bước cọc và cấu tạo dầm/bản giữ nguyên theo mô hình gốc, không mở rộng biến thiết kế ra ngoài phạm vi hệ cọc.

### 3.2. Hàm mục tiêu

- f1 = min(khối lượng vật liệu cọc), tính từ khối lượng/m theo catalogue × số cọc × chiều dài chế tạo.
- f2 = min(chuyển vị ngang lớn nhất tại đỉnh bến), trích từ tổ hợp tải trọng khống chế chuyển vị của mỗi công trình (A: "BAO KT"; B: "COMB14"/"BAO").

### 3.3. Ràng buộc kết cấu

Nội lực dọc trục và mô men uốn lớn nhất của cọc (trích đúng cột `P`, `M2`, `M3` theo thứ tự chuẩn OAPI CSI) phải thoả mãn giới hạn khả năng chịu lực vật liệu (P<sub>max</sub>, M<sub>u</sub>) theo catalogue ứng với từng cấp ứng suất trước.

### 3.4. Ràng buộc địa kỹ thuật

Sức chịu tải cọc tính theo TCVN 10304:2025, dạng khép kín R<sub>d</sub>(D) = γ<sub>k</sub>·(q<sub>b,tip</sub>·A<sub>tip</sub>(D) + u(D)·Σf<sub>i</sub>h<sub>i</sub>), với q<sub>b,tip</sub>, Σf<sub>i</sub>h<sub>i</sub> tính sẵn theo hồ sơ địa chất từng công trình (mục 2 file `SucChiuTai_Coc_TCVN10304_2025.md`). Hệ số tin cậy γ<sub>n</sub>=1,15 (cấp hậu quả C2, theo QCVN 03:2022/BXD Phụ lục A) áp dụng thống nhất cho cả hai công trình. Ràng buộc: γ<sub>n</sub>·N<sub>max</sub> ≤ R<sub>d</sub>.

### 3.5. Ràng buộc chuyển vị và xử lý phương án không khả thi

Chuyển vị ngang lớn nhất ≤ 30mm. Xử lý ràng buộc theo nguyên tắc **phạt cứng** (hard-penalty): phương án vi phạm bất kỳ ràng buộc nào bị loại khỏi tập nghiệm khả thi, không dùng hàm phạt mềm/hệ số phạt liên tục.

## 4. Áp dụng MOSFOA

MOSFOA là thuật toán tối ưu đa mục tiêu đã được phát triển và công bố trước đó [1]; bài báo này không lặp lại phần trình bày cơ chế thuật toán, chỉ nêu cấu hình sử dụng ở mục 5. MOSFOA được dùng nguyên bản, không chỉnh sửa/cải tiến.

## 5. Thiết kế thí nghiệm và chỉ tiêu đánh giá

- Cấu hình MOSFOA: kích thước quần thể N<sub>p</sub>=8, số vòng lặp Max_it=20 → ngân sách đánh giá FEM ước tính 168 lần/lượt chạy (phù hợp không gian thiết kế rời rạc nhỏ, K=33).
- Số lần chạy độc lập: 20 lần/công trình (Nrun=20), giữ nguyên tham số MOSFOA giữa các lần, không hiệu chỉnh theo kết quả.
- Mặt Pareto tham chiếu: xây dựng bằng **vét cạn toàn bộ 33 phương án** cho mỗi công trình (khả thi do không gian thiết kế nhỏ).
- Chỉ tiêu đánh giá: kích thước tập nghiệm Pareto, tỷ lệ khớp với Pareto tham chiếu (dung sai tương đối <0,1%), độ ổn định giữa các lần chạy (độ lệch chuẩn), thời gian tính toán.
- Toàn bộ 40 lượt chạy (20×2 công trình) thực hiện trên cùng một máy trạm, kết nối MATLAB–SAP2000 song song 8 worker, có cơ chế checkpoint/resume và giám sát (watchdog) tự động phục hồi khi tiến trình bị gián đoạn.

## 6. Kết quả và thảo luận

### 6.1. Đặc điểm hai bài toán

Vét cạn 33 phương án cho mỗi công trình cho kết quả:

| | Công trình A | Công trình B |
|---|---|---|
| Tổng số phương án | 33 | 33 |
| Số phương án khả thi | 18 (D≥600mm) | 18 (D≥600mm) |
| Số nghiệm Pareto tham chiếu | 6 | 6 |

Miền khả thi của cả hai công trình thu hẹp về D≥600mm sau khi áp dụng đúng γ<sub>n</sub>=1,15 và sửa lỗi trích xuất nội lực — kết quả nhất quán giữa hai công trình dù khác biệt về tải trọng và địa chất.

### 6.2. Kết quả Công trình A — mặt Pareto tham chiếu

| D (mm) | t (mm) | Class | f1 — khối lượng (T) | f2 — chuyển vị (mm) |
|---|---|---|---|---|
| 600 | 100 | C | 1762,4 | 15,3 |
| 700 | 110 | A | 2287,6 | 13,8 |
| 800 | 120 | B | 2876,2 | 12,3 |
| 900 | 130 | C | 3528,4 | 11,0 |
| 1000 | 130 | C | 3986,6 | 9,9 |
| 1200 | 150 | C | 5551,7 | 8,0 |

Baseline hiện tại của công trình A (D800‑t120‑ClassC, f1=2876,2T, f2=12,3mm) trùng khớp giá trị với điểm Pareto thứ 3 — thiết kế hiện hữu (sau khi quy đổi theo catalogue) đã nằm trên đường Pareto.

### 6.3. Kết quả Công trình B — mặt Pareto tham chiếu

| D (mm) | t (mm) | Class | f1 — khối lượng (T) | f2 — chuyển vị (mm) |
|---|---|---|---|---|
| 600 | 100 | B | 2125,3 | 23,1 |
| 700 | 110 | C | 2758,6 | 17,0 |
| 800 | 120 | C | 3468,4 | 12,9 |
| 900 | 130 | A | 4254,8 | 10,0 |
| 1000 | 130 | B | 4807,3 | 8,3 |
| 1200 | 150 | A | 6694,6 | 5,3 |

Tương tự công trình A, baseline của B (D700‑t110‑ClassC, f1=2758,6T, f2=17,0mm) cũng trùng khớp điểm Pareto thứ 2.

### 6.4. Độ ổn định của MOSFOA qua 20 lần chạy độc lập

| Chỉ tiêu | Công trình A | Công trình B |
|---|---|---|
| Kích thước Repository (mean ± std) | 6,00 ± 0,00 | 6,00 ± 0,00 |
| Số điểm khớp Pareto tham chiếu/lần chạy | 6,00/6 ± 0,00 | 6,00/6 ± 0,00 |
| Tỷ lệ lần chạy khớp đủ 100% mặt Pareto | **20/20 (100%)** | **20/20 (100%)** |
| Thời gian chạy (phút, mean ± std) | 44,5 ± 7,7* | 61,9 ± 0,3 |

*Độ lệch chuẩn thời gian của A bị ảnh hưởng bởi 1/20 lần chạy được watchdog tự động khôi phục từ checkpoint giữa chừng (do một lần dừng tiến trình ngoài ý muốn) — bản thân kết quả tối ưu không bị ảnh hưởng; loại trừ lần này thời gian ổn định quanh 46,0–47,0 phút.

Cả 40/40 lượt chạy (20×2 công trình) đều hội tụ **chính xác tuyệt đối** về mặt Pareto tham chiếu, không có trường hợp thiếu nghiệm hay dư nghiệm không tối ưu. Độ lệch chuẩn bằng 0 ở cả kích thước Repository lẫn tỷ lệ khớp cho thấy tính ổn định rất cao của MOSFOA trong phạm vi bài toán khảo sát.

### 6.5. So sánh đặc điểm nghiệm Pareto giữa hai công trình

Cùng dạng đường cong đánh đổi khối lượng–chuyển vị (đơn điệu giảm chuyển vị khi tăng đường kính/khối lượng cọc) xuất hiện ở cả hai công trình, phản ánh bản chất vật lý chung của bài toán dù khác nhau về quy mô tải trọng và điều kiện nền. Công trình B có chuyển vị baseline và biên trên (23,1mm) lớn hơn A (15,3mm) — phù hợp với việc B dùng mô hình ngàm cứng tại chiều dài ngàm ảo trong khi A dùng lò xo nền phân bố, cũng như cọc B mảnh hơn (D700 so với D800 ở cùng vị trí catalogue tương ứng). Cả hai công trình đều có miền khả thi bắt đầu từ D≥600mm và cùng 6 nghiệm Pareto — sự trùng hợp về số lượng nghiệm không hàm ý quy luật tổng quát, chỉ phản ánh đặc điểm không gian thiết kế rời rạc 33 phương án dùng chung một bảng catalogue.

### 6.6. Thảo luận

Việc mặt Pareto tham chiếu chỉ có 6 điểm trên một không gian rời rạc 33 phương án lý giải vì sao độ lệch chuẩn giữa các lần chạy bằng 0 — đây là kết quả mong đợi đối với một bài toán tổ hợp nhỏ, không phải bằng chứng tổng quát về khả năng hội tụ của MOSFOA trên không gian liên tục/lớn hơn. Điều có giá trị kiểm chứng ở đây là: (i) MOSFOA vận hành ổn định và chính xác khi kết nối trực tiếp với hai mô hình FEM SAP2000 độc lập, có điều kiện biên, tải trọng và vật liệu khác nhau, không cần hiệu chỉnh riêng tham số thuật toán cho từng công trình; (ii) kết quả tái lập được 100% giữa các lần chạy, hỗ trợ tính tin cậy khi áp dụng MOSFOA cho bài toán tối ưu hệ cọc cầu tàu thực tế; (iii) quy trình phát hiện và sửa 3 lỗi trích xuất dữ liệu OAPI âm thầm trong quá trình triển khai (đọc sai loại nhóm phần tử tại `JointDispl`, sai tên tổ hợp tải trọng, lệch cột kết quả `FrameForce`) cho thấy tầm quan trọng của việc đối chiếu số liệu thô với kỳ vọng vật lý trước khi tin tưởng kết quả tối ưu tự động.

## 7. Kết luận

MOSFOA giải thành công bài toán tối ưu đa mục tiêu hệ cọc cầu tàu trên cả hai công trình thực tế có quy mô, tải trọng và điều kiện địa kỹ thuật khác nhau đáng kể. Qua 20 lần chạy độc lập/công trình (40 lượt chạy), MOSFOA hội tụ chính xác 100% về mặt Pareto tham chiếu xây dựng bằng vét cạn, với độ ổn định tuyệt đối (độ lệch chuẩn bằng 0) về kích thước và thành phần tập nghiệm Pareto. Hai công trình cho đặc điểm nghiệm Pareto cùng quy luật vật lý (đánh đổi khối lượng–chuyển vị đơn điệu) nhưng khác nhau về giá trị tuyệt đối, phản ánh đúng sự khác biệt về tải trọng, vật liệu và điều kiện nền. Kết quả khẳng định MOSFOA không chỉ được kiểm chứng trên một bài toán cầu tàu đơn lẻ mà còn áp dụng thành công và ổn định trên hai công trình có đặc điểm kỹ thuật khác nhau. Nghiên cứu **không** kết luận MOSFOA là thuật toán tối ưu tốt nhất nói chung; kết luận chỉ giới hạn trong phạm vi hai bài toán khảo sát. Phân tích ảnh hưởng riêng biệt của quy mô, tải trọng và điều kiện địa kỹ thuật đến đặc điểm nghiệm tối ưu được dành cho nghiên cứu tiếp theo.

## Lời cảm ơn

[CẦN ĐIỀN nếu có — ví dụ nguồn tài trợ/đề tài.]

## Tài liệu tham khảo

[1] [CẦN ĐIỀN — trích dẫn đầy đủ bài báo MOSFOA gốc, tác giả/năm/tạp chí Q3 đã công bố trước đó.]

[2] TCVN 10304:2025, *Móng cọc — Tiêu chuẩn thiết kế*, Bộ Xây dựng.

[3] QCVN 03:2022/BXD, *Quy chuẩn kỹ thuật quốc gia về phân cấp công trình phục vụ thiết kế xây dựng*, Bộ Xây dựng.

[4] [CẦN ĐIỀN — trích dẫn catalogue cọc ly tâm ứng suất trước AMACCAO, TCVN 7888:2014 & JIS A 5373:2016.]

[5] 22TCN 222-95, *Tải trọng và tác động (do sóng và do tàu) lên công trình thủy*.

[6] 22TCN 207-92, *Công trình bến cảng biển — Tiêu chuẩn thiết kế*.

> Ngày nhận bài: xx/xx/2026
>
> Ngày nhận bản sửa: xx/xx/2026

---

## Việc cần hoàn thiện trước khi chuyển sang .docx (không thuộc bản thảo chính thức)

1. Điền tên/học hàm/học vị/đơn vị công tác tác giả (mục front-matter) — hiện chỉ có email `dangvanhai@hanyang.ac.kr`.
2. Bổ sung trích dẫn đầy đủ tài liệu [1] (bài báo MOSFOA gốc) và [4] (catalogue AMACCAO) theo đúng chuẩn JMST (số Ả Rập trong ngoặc vuông, tên tài liệu in nghiêng).
3. Chèn hình minh hoạ: (a) sơ đồ quy trình MATLAB–SAP2000–MOSFOA (mục 2.5), (b) 2 biểu đồ Pareto front A/B (mục 6.2–6.3), (c) 1 biểu đồ hội tụ Repository qua 20 vòng lặp (ví dụ từ `campaign_B_run01.log`).
4. Kiểm tra lại giới hạn 7 trang của JMST khi dàn trang 2 cột — có thể cần rút gọn mục 2 (so sánh 2 công trình) hoặc chuyển bớt sang bảng phụ lục.
5. Xác nhận lại số liệu "chuyển vị baseline" ở mục 6.2/6.3 khớp với giá trị đã chốt trong `Cong_thuc_Bai_toan_Toi_uu.md` trước khi nộp.
6. Style JMST cụ thể (JMST_Content cỡ 10, JMST-Section cỡ 11 đậm, JMST_Table Title, JMST_Fig Title...) áp dụng khi dựng file `.docx` thật — file `.md` này chỉ là nội dung, chưa định dạng.
