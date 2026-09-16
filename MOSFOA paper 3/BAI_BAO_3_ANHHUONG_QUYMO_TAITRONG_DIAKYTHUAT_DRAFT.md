> **Ghi chú soạn thảo (xoá trước khi đưa vào docx):** Đây là **bản thảo V1** của Bài báo 3 trong chuỗi công bố MOSFOA, triển khai theo đề cương [`Bai_3.md`](Bai_3.md). Bài 3 **không chạy lại MOSFOA, không tạo Pareto front mới** — toàn bộ số liệu khối lượng/chuyển vị/tập Pareto tham chiếu của Công trình A (Lạch Huyện 100.000DWT) và Công trình B (VIPGreenPort 30.000DWT) được lấy nguyên vẹn từ bài báo liền trước trong chuỗi công bố (`..\MOSFOA paper 2\09.15.JMST_BAI_BAO_MOSFOA_2CONGTRINH_JMST_APPLICATION_V2.1.md`, mục 2 và 6) và từ `..\MOSFOA paper 2\So_sanh_2_du_an_Cau_tau.md`. Nội dung mới duy nhất của bài này là: (1) xác định nghiệm đại diện (khối lượng nhỏ nhất / chuyển vị nhỏ nhất / cân bằng) bằng phương pháp khoảng cách chuẩn hoá tới điểm lý tưởng — một phép tính đơn giản trên số liệu đã có, không phải MCDM đầy đủ; (2) phân tích kỹ thuật về ảnh hưởng của quy mô, tải trọng, địa kỹ thuật đến sự khác biệt giữa hai tập Pareto. Định dạng theo mẫu JMST như bài liền trước (giả định tạp chí mục tiêu giống Bài 2 — cần người dùng xác nhận trước khi hoàn thiện .docx). Tác giả/liên hệ giữ nguyên như Bài 2.

---

# TIÊU ĐỀ TIẾNG VIỆT

**ẢNH HƯỞNG CỦA QUY MÔ, TẢI TRỌNG VÀ ĐIỀU KIỆN ĐỊA KỸ THUẬT ĐẾN CẤU HÌNH HỆ CỌC TỐI ƯU CẦU TÀU: PHÂN TÍCH TỪ HAI CÔNG TRÌNH ỨNG DỤNG MOSFOA**

# TITLE (ENGLISH)

**INFLUENCE OF SCALE, LOAD AND GEOTECHNICAL CONDITIONS ON THE OPTIMAL PILE-SYSTEM CONFIGURATION OF WHARF STRUCTURES: AN ANALYSIS FROM TWO MOSFOA APPLICATION CASE STUDIES**

**Tác giả:** ĐỖ QUANG THÀNH¹\*, VŨ HỮU TRƯỜNG¹, LÊ THANH CƯỜNG²

¹Trường Đại học Hàng hải Việt Nam

²Trường Đại học Mở Thành phố Hồ Chí Minh

\*Email liên hệ: thanhdq.ctt@vimaru.edu.vn

---

**Tóm tắt**

Bài báo khai thác kết quả tối ưu đa mục tiêu hệ cọc cầu tàu bằng thuật toán MOSFOA đã được nhóm tác giả công bố trên hai công trình thực tế có quy mô, tải trọng và điều kiện địa kỹ thuật khác nhau: (A) cầu tàu container 100.000DWT tại Lạch Huyện, Hải Phòng và (B) cầu tàu 30.000DWT tại VIPGreenPort, Đình Vũ, Hải Phòng. Khác với công bố trước — tập trung kiểm chứng khả năng khôi phục tập Pareto tham chiếu của thuật toán — bài báo này không phát triển thuật toán mới và không so sánh MOSFOA với các phương pháp tối ưu khác, mà phân tích ý nghĩa kỹ thuật của sự khác biệt giữa hai tập Pareto tham chiếu (mỗi tập 6 phương án catalogue cọc ly tâm ứng suất trước AMACCAO) nhằm trả lời câu hỏi: khi quy mô công trình, tải trọng khai thác và điều kiện địa kỹ thuật thay đổi, cấu hình hệ cọc tối ưu thay đổi như thế nào? Ba nghiệm đại diện (khối lượng nhỏ nhất, chuyển vị nhỏ nhất, nghiệm cân bằng — xác định bằng khoảng cách chuẩn hoá tới điểm lý tưởng trong không gian hai mục tiêu) được trích xuất cho mỗi công trình để so sánh trực tiếp. Kết quả cho thấy tỷ lệ tăng khối lượng khi tăng đường kính cọc từ D600 lên D1200 giống hệt nhau ở hai công trình (~3,15 lần, do dùng chung bảng catalogue), nhưng mức giảm chuyển vị tương ứng khác biệt rõ rệt (47,7% ở công trình A so với 77,1% ở công trình B); đồng thời ranh giới miền khả thi địa kỹ thuật (D≥600mm) trùng nhau ở cả hai công trình dù điều kiện nền khác nhau. Các quan sát này minh hoạ vai trò của quy mô, tải trọng và địa kỹ thuật trong việc định hình không gian nghiệm khả thi và cấu hình hệ cọc tối ưu, đồng thời cho thấy các yếu tố này tác động đan xen, không thể tách bạch thành quan hệ nhân quả riêng lẻ chỉ từ hai công trình khảo sát. Các xu hướng nêu ra chỉ có giá trị trong phạm vi hai công trình nghiên cứu.

**Từ khóa**: *hệ cọc cầu tàu, tối ưu đa mục tiêu, MOSFOA, tập Pareto tham chiếu, quy mô công trình, điều kiện địa kỹ thuật.*

**Abstract**

This paper re-examines previously obtained MOSFOA multi-objective pile-system optimization results for two real wharf projects with different scale, load, and geotechnical conditions: (A) a 100,000DWT container wharf at Lach Huyen, Hai Phong, and (B) a 30,000DWT wharf at VIPGreenPort, Dinh Vu, Hai Phong. Unlike the prior publication — which verified the algorithm's ability to recover the reference Pareto set — this paper does not develop a new algorithm and does not benchmark MOSFOA against other optimizers; instead, it examines the engineering significance of the differences between the two reference Pareto sets (each comprising 6 prestressed centrifugal pile catalogue alternatives), addressing the question of how the optimal pile-system configuration changes with project scale, operational load, and geotechnical conditions. Three representative solutions (minimum mass, minimum displacement, and a compromise solution identified by normalized distance to the ideal point in objective space) are extracted for each project for direct comparison. Results show an identical mass-increase ratio from D600 to D1200 in both projects (~3.15×, since both share the same pile catalogue), but a markedly different displacement reduction (47.7% in Project A versus 77.1% in Project B); the geotechnical feasibility boundary (D≥600mm) coincides in both projects despite differing soil conditions. These observations illustrate how scale, load, and geotechnical conditions jointly shape the feasible design space and the resulting optimal pile configuration, while also showing that, with only two case studies, these factors cannot be disentangled into separate causal effects. The trends identified are valid only within the scope of the two projects studied.

**Keywords**: *wharf pile system, multi-objective optimization, MOSFOA, reference Pareto set, project scale, geotechnical conditions.*

---

## 1. Mở đầu

Hệ cọc cầu tàu chịu đồng thời tải trọng đứng (hàng hoá, cần trục, ô tô) và tải trọng ngang (va tàu, neo tàu, sóng, dòng chảy, động đất), trong khi phải thoả mãn đồng thời điều kiện kết cấu (sức chịu lực vật liệu) và điều kiện địa kỹ thuật (sức chịu tải cọc theo tiêu chuẩn nền móng). Tối ưu đa mục tiêu (MOO) hệ cọc — cực tiểu hoá khối lượng vật liệu đồng thời cực tiểu hoá chuyển vị ngang — không cho một nghiệm duy nhất mà cho một **tập Pareto** các phương án cân bằng khác nhau giữa hai tiêu chí.

Nghiệm tối ưu thu được từ một bài toán MOO không chỉ phụ thuộc thuật toán tìm kiếm, mà còn phụ thuộc chặt vào điều kiện cụ thể của công trình: quy mô (kích thước bến, số cọc), tải trọng khai thác (tàu thiết kế, cần trục, neo/va tàu), và điều kiện địa kỹ thuật (địa tầng, sức chịu tải cọc). Các nghiên cứu ứng dụng thuật toán tối ưu trong kỹ thuật công trình thường dừng lại ở việc báo cáo mặt Pareto thu được, mà ít khai thác thêm ý nghĩa kỹ thuật của sự khác biệt giữa các mặt Pareto khi điều kiện công trình thay đổi.

Bài báo trước trong cùng chuỗi công bố [1] đã áp dụng thuật toán MOSFOA — do nhóm tác giả phát triển và công bố trước đó [2] — vào bài toán tối ưu hệ cọc trên hai công trình cầu tàu thực tế có quy mô, tải trọng và địa kỹ thuật khác nhau: (A) Lạch Huyện 100.000DWT và (B) VIPGreenPort 30.000DWT, và đã kiểm chứng rằng thuật toán khôi phục đầy đủ tập Pareto tham chiếu (xác lập bằng vét cạn 33 phương án catalogue cọc) trong toàn bộ 40 lượt chạy độc lập (20 lượt/công trình). Trọng tâm của [1] là **kiểm chứng khả năng áp dụng của thuật toán**, không phải phân tích ý nghĩa kỹ thuật của sự khác biệt giữa hai tập nghiệm.

Bài báo hiện tại **kế thừa trực tiếp** hai tập Pareto tham chiếu đã xác lập trong [1] làm dữ liệu đầu vào, và đặt câu hỏi nghiên cứu khác:

> *Khi quy mô công trình, tải trọng và điều kiện địa kỹ thuật thay đổi, các đặc trưng của hệ cọc tối ưu (khối lượng, chuyển vị, mức đánh đổi giữa hai đại lượng này) thay đổi như thế nào?*

Bài báo **không phát triển thuật toán mới**, **không so sánh MOSFOA với các thuật toán tối ưu khác**, và **không chạy lại MOSFOA để tạo Pareto front mới** — toàn bộ dữ liệu khối lượng/chuyển vị/tập Pareto tham chiếu được trích dẫn nguyên vẹn từ [1]. Đóng góp nằm ở việc trích xuất các nghiệm đại diện từ mỗi tập Pareto tham chiếu và phân tích mối liên hệ giữa đặc điểm công trình và cấu hình hệ cọc tối ưu tương ứng.

## 2. Cơ sở dữ liệu và hai công trình nghiên cứu

### 2.1. Tóm tắt hai công trình

Bảng 1 tổng hợp các đặc điểm chính của hai công trình, kế thừa từ hồ sơ thiết kế/khai thác gốc và từ mô tả mô hình FEM trong [1].

**Bảng 1.** Đối chiếu đặc điểm hai công trình nghiên cứu.

| Nhóm yếu tố | Công trình A — Lạch Huyện | Công trình B — VIPGreenPort |
|---|---|---|
| **Quy mô** | Tàu thiết kế 100.000DWT (L330×B45,5×Tc14,8m); vị trí cửa ngõ biển hở | Tàu thiết kế 30.000DWT (L210×B30×Tc10,7m); vị trí trong sông, kín gió hơn |
| Chiều rộng bến | 50,0 m | 24,0 m (~2,08 lần nhỏ hơn A) |
| Cao trình đỉnh / đáy bến | +5,50 / −16,0 m (Hải đồ) | +5,50 / −10,60 m (GĐ1, Hải đồ) |
| **Hệ cọc** | 132 cọc BTCT ƯST D800‑t130 + 60 cọc thép D1016‑t16 phụ trợ (giữ cố định) = 192 cọc/phân đoạn; chiều dài chế tạo 28–34m | 132 cọc BTCT ƯST D700‑t130, không có cọc thép; chiều dài chế tạo ~40m |
| Mác bê tông cọc / dầm | M800 / M400 | M600 / M350 |
| **Tải trọng khai thác** | Cần trục 65T SWL (bánh max 76,7T); bích neo 150T (F1=93,72T) | Cần trục KE45T + QC40T (bánh max 35,4T); bích neo 100T (Sq=26,43T) |
| Số tổ hợp tải trọng | 36–37 | 37 |
| **Điều kiện địa kỹ thuật** | Địa tầng riêng theo hồ sơ khảo sát Lạch Huyện; TCVN 10304:2025, γₙ=1,15 (C2) | Địa tầng riêng theo hồ sơ khảo sát Đình Vũ; TCVN 10304:2025, γₙ=1,15 (C2) |
| Mô hình biên chân cọc | Lò xo trục U3 rời rạc (178 nút) | Ngàm cứng tuyệt đối tại chiều dài ngàm ảo (132 nút, theo TCXD 205:1998) |
| **Không gian thiết kế** | Chỉ số catalogue x∈[1,33] (11 D × 3 Class, AMACCAO), 18/33 khả thi (D≥600mm), 6 điểm Pareto tham chiếu | Cùng catalogue, cùng số lượng: 18/33 khả thi (D≥600mm), 6 điểm Pareto tham chiếu |

Hai công trình khác biệt rõ rệt về quy mô (bề rộng bến gấp ~2 lần), tải trọng thiết kế (tàu, cần trục, bích neo đều lớn hơn ở A), vật liệu (mác bê tông cao hơn ở A) và cách mô hình hoá điều kiện biên nền cọc (lò xo phân bố ở A, ngàm cứng tại ngàm ảo ở B) — tạo thành cặp case-study "lớn – nhỏ" phù hợp để khảo sát ảnh hưởng của các nhóm yếu tố này đến cấu hình hệ cọc tối ưu.

### 2.2. Nguồn dữ liệu tối ưu

Dữ liệu khối lượng, chuyển vị và tập Pareto tham chiếu của hai công trình được lấy nguyên vẹn từ [1] (mục 3, 5, 6), tóm tắt lại ở mục 3 dưới đây theo mức độ cần thiết cho phân tích của bài báo này. Bài báo **không lặp lại** phần trình bày mô hình FEM chi tiết, quy trình kết nối MATLAB–SAP2000, hay số liệu kiểm chứng khả năng khôi phục Pareto (đã trình bày đầy đủ trong [1]).

## 3. Phương pháp tối ưu và xác định nghiệm đại diện

### 3.1. Tóm tắt bài toán tối ưu

MOSFOA [2] được sử dụng trong [1] để tìm tập Pareto cho từng công trình, với biến thiết kế là chỉ số catalogue nguyên x∈[1,33] trỏ vào bảng cọc ly tâm ứng suất trước AMACCAO (11 đường kính D300–D1200mm × 3 cấp ứng suất trước A/B/C); hai mục tiêu là f1 = khối lượng vật liệu cọc (min) và f2 = chuyển vị ngang lớn nhất đỉnh bến (min); ràng buộc gồm sức chịu tải cọc theo TCVN 10304:2025 (γₙ=1,15, cấp hậu quả C2), khả năng chịu lực vật liệu (N≤Pmax, M≤Mu, kiểm tra độc lập, không dùng tương tác N–M) và chuyển vị ngang ≤30mm, xử lý theo nguyên tắc phạt cứng. Bài báo này không trình bày lại chi tiết thuật toán, mô hình FEM hay quy trình đánh giá — xem [1], [2].

### 3.2. Xác định nghiệm đại diện từ tập Pareto tham chiếu

Với mỗi công trình, ba nghiệm đại diện được trích xuất từ tập Pareto tham chiếu 6 điểm (đã xác lập bằng vét cạn trong [1]):

- **Nghiệm khối lượng nhỏ nhất**: điểm có f1 nhỏ nhất trong tập Pareto.
- **Nghiệm chuyển vị nhỏ nhất**: điểm có f2 nhỏ nhất trong tập Pareto.
- **Nghiệm cân bằng**: điểm có khoảng cách chuẩn hoá nhỏ nhất tới điểm lý tưởng (0,0) trong không gian hai mục tiêu đã chuẩn hoá min–max:

$$d_i=\sqrt{\left(\frac{f_{1,i}-f_1^{min}}{f_1^{max}-f_1^{min}}\right)^2+\left(\frac{f_{2,i}-f_2^{min}}{f_2^{max}-f_2^{min}}\right)^2}$$

Nghiệm cân bằng là điểm có $d_i$ nhỏ nhất, tương ứng phương án hài hoà nhất giữa hai mục tiêu khi không ưu tiên riêng bên nào (trọng số ngầm định bằng nhau). **Đây là một phép chọn điểm thoả hiệp đơn giản, không phải một quy trình MCDM đầy đủ** (không xét thêm tiêu chí kỹ thuật khác như hệ số sử dụng, không xây dựng nhiều kịch bản trọng số) — việc xếp hạng đầy đủ tập Pareto bằng phương pháp MCDM (TOPSIS, nhiều tiêu chí, nhiều kịch bản trọng số và phân tích độ nhạy) là nội dung của một bài báo khác trong chuỗi công bố, không trùng lặp với phạm vi bài này.

## 4. Phương pháp phân tích ảnh hưởng

Ba nhóm yếu tố được xem xét lần lượt: (i) quy mô công trình (kích thước bến, số lượng/chiều dài cọc), (ii) tải trọng khai thác (tàu thiết kế, cần trục, neo/va tàu), (iii) điều kiện địa kỹ thuật (địa tầng, ranh giới miền khả thi theo sức chịu tải cọc). Với mỗi nhóm, so sánh trực tiếp giá trị f1, f2, ranh giới miền khả thi và mức đánh đổi (trade-off) giữa hai công trình tại các vị trí catalogue tương ứng. Vì hai công trình khác nhau đồng thời ở cả ba nhóm yếu tố lẫn cách mô hình hoá điều kiện biên nền cọc, quan hệ nhân quả riêng lẻ của từng yếu tố **không thể tách bạch hoàn toàn** từ chỉ hai điểm dữ liệu — kết quả phân tích được trình bày như các quan sát định lượng có kèm cảnh báo về giới hạn suy rộng, theo đúng chuỗi: *quy mô + tải trọng + địa kỹ thuật → yêu cầu chịu lực/chuyển vị → không gian nghiệm khả thi → cấu hình hệ cọc tối ưu.*

## 5. Kết quả và thảo luận

### 5.1. Tập Pareto tham chiếu của hai công trình

**Bảng 2.** Tập Pareto tham chiếu — Công trình A.

| D (mm) | t (mm) | Class | f1 — khối lượng (T) | f2 — chuyển vị (mm) |
|---|---|---|---|---|
| 600 | 100 | C | 1762,4 | 15,3 |
| 700 | 110 | A | 2287,6 | 13,8 |
| 800 | 120 | B | 2876,2 | 12,3 |
| 900 | 130 | C | 3528,4 | 11,0 |
| 1000 | 130 | C | 3986,6 | 9,9 |
| 1200 | 150 | C | 5551,7 | 8,0 |

**Bảng 3.** Tập Pareto tham chiếu — Công trình B.

| D (mm) | t (mm) | Class | f1 — khối lượng (T) | f2 — chuyển vị (mm) |
|---|---|---|---|---|
| 600 | 100 | B | 2125,3 | 23,1 |
| 700 | 110 | C | 2758,6 | 17,0 |
| 800 | 120 | C | 3468,4 | 12,9 |
| 900 | 130 | A | 4254,8 | 10,0 |
| 1000 | 130 | B | 4807,3 | 8,3 |
| 1200 | 150 | A | 6694,6 | 5,3 |

### 5.2. Nghiệm đại diện

Áp dụng phương pháp khoảng cách chuẩn hoá (mục 3.2) trên hai tập Pareto: nghiệm cân bằng của công trình A là **D900‑t130‑ClassC** (d=0,621, sát điểm D800 d=0,658 và D1000 d=0,642 — vùng cân bằng khá bằng phẳng); nghiệm cân bằng của công trình B là **D800‑t120‑ClassC** (d=0,518, sát điểm D900 d=0,536).

**Bảng 4.** Các nghiệm đại diện của hai công trình.

| Loại nghiệm | Công trình A | Công trình B |
|---|---|---|
| Khối lượng nhỏ nhất | D600‑t100‑C: f1=1762,4T; f2=15,3mm | D600‑t100‑B: f1=2125,3T; f2=23,1mm |
| Chuyển vị nhỏ nhất | D1200‑t150‑C: f1=5551,7T; f2=8,0mm | D1200‑t150‑A: f1=6694,6T; f2=5,3mm |
| Cân bằng | D900‑t130‑C: f1=3528,4T; f2=11,0mm | D800‑t120‑C: f1=3468,4T; f2=12,9mm |

Đáng chú ý, baseline thiết kế hiện hữu của cả hai công trình (A: D800‑t120‑ClassC; B: D700‑t110‑ClassC, đã báo cáo trong [1] là trùng giá trị với các điểm Pareto tham chiếu) nằm **gần** nhưng không trùng với nghiệm cân bằng vừa xác định (A lệch một bậc catalogue về phía nhẹ hơn nghiệm cân bằng D900; B lệch một bậc về phía nhẹ hơn nghiệm cân bằng D800) — cho thấy thiết kế gốc của cả hai công trình thiên nhẹ hơn một chút so với điểm cân bằng hai mục tiêu theo tiêu chí khoảng cách chuẩn hoá đã dùng ở đây, phù hợp thực tế thiết kế thường ưu tiên tiết kiệm vật liệu khi vẫn còn dư chuyển vị so với giới hạn cho phép (30mm).

### 5.3. Ảnh hưởng của quy mô

Công trình A có quy mô lớn hơn B rõ rệt (bến rộng gấp ~2,08 lần, tàu thiết kế gấp ~3,3 lần DWT, số cọc/phân đoạn nhiều hơn ~1,45 lần: 192 so với 132), nhưng tại vị trí catalogue nhẹ nhất (D600), khối lượng vật liệu tuyệt đối của A (1762,4T) lại **thấp hơn** B (2125,3T). Nguyên nhân không nằm ở quy mô "danh nghĩa" (DWT, bề rộng bến) mà ở cấu hình cọc: cọc của B dài hơn đáng kể (chiều dài chế tạo ~40m so với 28–34m ở A, do đáy bến B tuy nông hơn về cao trình tuyệt đối nhưng cọc phải xuyên qua địa tầng khác để đạt sức chịu tải yêu cầu) trong khi số lượng cọc lại ít hơn (132 so với 192). Quan sát này cho thấy **quy mô công trình (đo bằng DWT tàu thiết kế hoặc bề rộng bến) không ánh xạ đơn điệu sang khối lượng vật liệu hệ cọc tối ưu** — chiều dài cọc thực tế (chi phối bởi địa tầng) và số lượng cọc (chi phối bởi bố trí kết cấu) có vai trò chi phối trực tiếp hơn.

Tỷ lệ tăng khối lượng khi tăng đường kính catalogue từ D600 lên D1200 lại **giống hệt nhau** ở cả hai công trình (~3,15 lần: A 5551,7/1762,4=3,150; B 6694,6/2125,3=3,149) — hệ quả tất yếu vì khối lượng/mét dài chỉ phụ thuộc (D,t) theo catalogue chung, không phụ thuộc đặc điểm riêng công trình; đây không phải một phát hiện về ảnh hưởng của quy mô mà là đặc điểm hình thức của việc dùng chung một bảng catalogue.

### 5.4. Ảnh hưởng của tải trọng

Công trình A chịu tải trọng thiết kế lớn hơn B ở mọi hạng mục đối chiếu được (cần trục 65T SWL so với 45/40T; bích neo 150T so với 100T; tàu 100.000DWT so với 30.000DWT). Tuy nhiên tại các vị trí catalogue tương ứng, chuyển vị ngang của A **nhỏ hơn** B (ví dụ D600: A=15,3mm so với B=23,1mm; D700 (baseline): A=13,8mm so với B=17,0mm). Kết quả này — tải trọng thiết kế lớn hơn nhưng chuyển vị nhỏ hơn — không mâu thuẫn về mặt vật lý: công trình A có bến rộng hơn, hệ cọc dày hơn (192 so với 132 cọc/phân đoạn, có thêm 60 cọc thép D1016 phụ trợ giữ cố định trong suốt campaign) và mác bê tông cao hơn (M800 so với M600), tạo độ cứng tổng thể lớn hơn nhiều so với mức tăng của tải trọng thiết kế. Vì tải trọng, độ cứng kết cấu tổng thể và điều kiện biên nền cọc (lò xo ở A, ngàm cứng tại ngàm ảo ở B) đều khác nhau đồng thời giữa hai công trình, **không thể quy kết chênh lệch chuyển vị này riêng cho yếu tố tải trọng** — chỉ có thể kết luận rằng tải trọng thiết kế lớn hơn không tự động kéo theo chuyển vị lớn hơn khi đi kèm một hệ kết cấu đủ cứng.

### 5.5. Ảnh hưởng của điều kiện địa kỹ thuật

Dù có địa tầng khác nhau (khảo sát địa chất riêng cho từng công trình) và công thức sức chịu tải Rd(D) sử dụng các thông số đầu vào (qb,tip, Σfihi) khác nhau theo TCVN 10304:2025, **ranh giới miền khả thi trùng nhau tuyệt đối ở cả hai công trình: D≥600mm (18/33 phương án khả thi)** — không có phương án D300–D500 nào khả thi ở cả A lẫn B. Đây là một sự trùng hợp đáng chú ý nhưng cần được diễn giải thận trọng: nó phản ánh rằng, với tải trọng khai thác thực tế của cả hai loại tàu (30.000–100.000DWT), catalogue AMACCAO chỉ cung cấp đủ sức chịu tải từ D600mm trở lên tại cả hai địa tầng khảo sát — **không có cơ sở để khái quát thành một ngưỡng chung D≥600mm cho mọi công trình cầu tàu**, vì ngưỡng này là kết quả đồng thời của catalogue cụ thể, tải trọng cụ thể và địa tầng cụ thể của hai trường hợp đã khảo sát.

Ngược lại, độ nhạy của chuyển vị theo đường kính cọc khác biệt rõ giữa hai công trình: đi từ D600 sang D1200, chuyển vị giảm 47,7% ở A (15,3→8,0mm) nhưng giảm tới 77,1% ở B (23,1→5,3mm). Vì điều kiện biên nền cọc được mô hình hoá khác nhau giữa hai công trình (lò xo trục U3 phân bố ở A so với ngàm cứng tuyệt đối tại chiều dài ngàm ảo cố định ở B — và **thông số biên này không được cập nhật lại theo D trong vòng lặp tối ưu ở cả hai công trình**, xem [1] mục 2.4), một phần chênh lệch độ nhạy này có thể liên quan đến cách mô hình hoá tương tác đất–cọc chứ không chỉ đến bản thân địa tầng — bài báo không có cơ sở dữ liệu để tách bạch hai nguyên nhân này.

### 5.6. Tổng hợp xu hướng thiết kế

Từ hai công trình khảo sát, có thể rút ra các quan sát sau, kèm giới hạn suy rộng tương ứng:

1. **Xu hướng lặp lại ở cả hai công trình** (tương đối tin cậy vì độc lập với đặc điểm riêng từng công trình): tăng đường kính cọc luôn đánh đổi khối lượng lấy chuyển vị theo quy luật đơn điệu giảm dần hiệu quả (diminishing returns) — mức giảm chuyển vị trên mỗi đơn vị khối lượng tăng thêm nhỏ dần khi tiết diện đã đủ lớn (D900→D1200 cho mức giảm chuyển vị tương đối nhỏ ở cả hai công trình so với khối lượng tăng thêm).
2. **Khác biệt giữa hai công trình** (không nên khái quát thành quy luật chung): (a) khối lượng tuyệt đối tại cùng một vị trí catalogue không tỷ lệ với quy mô "danh nghĩa" của công trình (DWT, bề rộng bến) mà phụ thuộc chiều dài cọc/số lượng cọc thực tế; (b) tải trọng thiết kế lớn hơn không nhất thiết kéo theo chuyển vị lớn hơn nếu đi kèm hệ kết cấu đủ cứng; (c) độ nhạy chuyển vị theo đường kính cọc có thể khác nhau đáng kể giữa hai công trình dù ranh giới khả thi địa kỹ thuật trùng nhau.
3. **Điểm không thể kết luận từ hai công trình**: quan hệ định lượng riêng biệt giữa từng yếu tố (quy mô/tải trọng/địa kỹ thuật) và cấu hình hệ cọc tối ưu — vì ba yếu tố này cùng thay đổi đồng thời và đan xen với cách mô hình hoá điều kiện biên, không có cơ sở thống kê để phân tách ảnh hưởng riêng lẻ.

## 6. Thảo luận kỹ thuật

**Vai trò của tối ưu đa mục tiêu**: sự tồn tại của một tập Pareto (không phải một nghiệm duy nhất) ở cả hai công trình khẳng định rằng khối lượng vật liệu và chuyển vị ngang là hai mục tiêu mâu thuẫn về bản chất trong bài toán hệ cọc cầu tàu — lựa chọn phương án cuối cùng luôn đòi hỏi đánh đổi, không phụ thuộc quy mô công trình.

**Vai trò của ràng buộc địa kỹ thuật**: ràng buộc sức chịu tải cọc loại bỏ hoàn toàn các phương án tiết diện nhỏ (D300–D500) ở cả hai công trình — nghiệm tối ưu cuối cùng do đó không thể giải thích chỉ bằng điều kiện vật liệu/chuyển vị mà còn bị chi phối bởi sức chịu tải cho phép của nền.

**Ý nghĩa đối với thiết kế**: với hai công trình có quy mô, tải trọng và địa tầng khác nhau nhưng dùng chung một catalogue cọc, kỹ sư thiết kế cần lưu ý rằng (i) kết quả tối ưu của một công trình không thể suy diễn trực tiếp sang công trình khác dù dùng chung catalogue; (ii) vị trí "nghiệm cân bằng" trên mặt Pareto (theo tiêu chí khoảng cách chuẩn hoá đã dùng) không nhất thiết trùng với thiết kế hiện hữu, và có thể được dùng làm điểm tham chiếu bổ sung khi cân nhắc phương án; (iii) việc đưa ràng buộc địa kỹ thuật vào bài toán tối ưu ngay từ đầu là cần thiết vì nó thu hẹp đáng kể miền nghiệm khả thi (ở đây từ 33 xuống còn 18 phương án tại cả hai công trình). Nội dung này không nhằm đề xuất một hướng thiết kế mới hay một quy chuẩn mới, chỉ là nhận xét kỹ thuật rút ra trực tiếp từ dữ liệu hai công trình.

**Giới hạn**: phân tích giới hạn ở hai công trình thực tế và một loại catalogue cọc duy nhất; không đủ cơ sở để khái quát hoá thành quy luật tổng quát cho mọi cầu tàu. Phương pháp xác định nghiệm cân bằng (khoảng cách chuẩn hoá, trọng số ngầm định bằng nhau) là một lựa chọn đơn giản, chưa xét thêm các tiêu chí kỹ thuật khác (hệ số sử dụng, khả năng thi công) hay các kịch bản trọng số khác nhau — nội dung này để dành cho một nghiên cứu MCDM đầy đủ hơn (TOPSIS đa tiêu chí, đa kịch bản trọng số, phân tích độ nhạy) trong một công bố khác của chuỗi nghiên cứu.

## 7. Kết luận

1. Quy mô công trình (đo bằng DWT tàu thiết kế hay bề rộng bến) không ánh xạ đơn điệu sang khối lượng vật liệu hệ cọc tối ưu — chiều dài và số lượng cọc thực tế có vai trò chi phối trực tiếp hơn trong hai công trình đã khảo sát.
2. Tải trọng khai thác lớn hơn không nhất thiết kéo theo chuyển vị tối ưu lớn hơn, nếu đi kèm một hệ kết cấu tổng thể đủ cứng (quan sát từ việc Công trình A — tải trọng lớn hơn — có chuyển vị nhỏ hơn Công trình B tại các vị trí catalogue tương ứng).
3. Điều kiện địa kỹ thuật có vai trò quan trọng trong việc xác định ranh giới miền nghiệm khả thi (D≥600mm ở cả hai công trình đã khảo sát) và trong việc chi phối độ nhạy của chuyển vị theo đường kính cọc.
4. Tập Pareto tham chiếu ở cả hai công trình cho phép lựa chọn phương án theo mức đánh đổi giữa khối lượng và chuyển vị; ba nghiệm đại diện (khối lượng nhỏ nhất, chuyển vị nhỏ nhất, cân bằng) được trích xuất cho mỗi công trình bằng phương pháp khoảng cách chuẩn hoá đơn giản, cung cấp điểm tham chiếu bổ sung cho thiết kế hiện hữu.
5. Các xu hướng rút ra (quan hệ đánh đổi đơn điệu giảm dần hiệu quả khi tăng tiết diện cọc) có tính lặp lại ở cả hai công trình, nhưng các giá trị định lượng cụ thể (mức giảm chuyển vị, ranh giới khả thi) chỉ có giá trị trong phạm vi hai công trình nghiên cứu và cần được kiểm chứng thêm trên nhiều công trình khác nếu muốn khái quát rộng hơn.

## Lời cảm ơn

*(Không có thông tin về nguồn tài trợ/đề tài được cung cấp trong phạm vi dự án — mục này để trống nếu không áp dụng, hoặc bổ sung trước khi nộp nếu có.)*

## Tài liệu tham khảo

[1] Đỗ Quang Thành, Vũ Hữu Trường, Lê Thanh Cường, "Ứng dụng thuật toán MOSFOA tối ưu đa mục tiêu hệ cọc cầu tàu: kiểm chứng trên hai công trình có quy mô và điều kiện địa kỹ thuật khác nhau" *(bài báo cùng chuỗi công bố, bản thảo đang hoàn thiện — cập nhật đầy đủ thông tin xuất bản/DOI khi có)*.

[2] Do-Quang, T., Vu-Huu, T. and Le, C.T. (2026), "Multi-objective Optimization of Marine Structures Using an Enhanced Starfish Algorithm", *Proceedings of the Institution of Civil Engineers – Structures and Buildings*. DOI: 10.1680/jstbu.26.00159.

[3] TCVN 10304:2025, *Móng cọc — Tiêu chuẩn thiết kế*, Bộ Xây dựng.

[4] QCVN 03:2022/BXD, *Quy chuẩn kỹ thuật quốc gia về phân cấp công trình phục vụ thiết kế xây dựng*, Bộ Xây dựng.

[5] Catalogue cọc ly tâm ứng suất trước AMACCAO, biên soạn theo TCVN 7888:2014 & JIS A 5373:2016 *(thông tin nhà xuất bản/năm phát hành đầy đủ chưa xác minh được — cần bổ sung trước khi nộp bản thảo chính thức, xem ghi chú tương tự trong Bài 2)*.

> Ngày nhận bài: xx/xx/2026
>
> Ngày nhận bản sửa: xx/xx/2026

---

## Việc cần hoàn thiện trước khi chuyển sang bản thảo chính thức (không thuộc nội dung bài báo)

1. **Xác nhận tạp chí mục tiêu**: bản thảo này giả định giữ nguyên định dạng/tạp chí như Bài 2 (JMST) vì chưa có chỉ định khác — cần người dùng xác nhận hoặc chỉnh style nếu tạp chí mục tiêu khác.
2. **Cập nhật trích dẫn [1]** (Bài 2) với DOI/thông tin xuất bản thật ngay khi Bài 2 được nộp/chấp nhận — hiện đang để ở dạng "bản thảo đang hoàn thiện".
3. **Bổ sung trích dẫn đầy đủ tài liệu [5]** (catalogue AMACCAO) — cùng khoảng trống đã ghi nhận ở Bài 2.
4. **Chèn hình minh hoạ đề xuất**: (a) 2 biểu đồ Pareto front A/B có đánh dấu 3 nghiệm đại diện (khối lượng nhỏ nhất/chuyển vị nhỏ nhất/cân bằng); (b) 1 biểu đồ cột so sánh mức giảm chuyển vị (%) D600→D1200 giữa hai công trình; (c) sơ đồ chuỗi "quy mô + tải trọng + địa kỹ thuật → không gian nghiệm khả thi → cấu hình hệ cọc tối ưu" (mục 4).
5. Kiểm tra lại giới hạn số trang của tạp chí mục tiêu khi dàn trang — nếu cần cắt, ưu tiên rút gọn mục 2.1 (đã có đầy đủ trong Bài 2), giữ nguyên mục 5–6 (nội dung phân tích mới).
6. File `.md` này chỉ là nội dung, chưa định dạng theo style tạp chí (JMST_Content/JMST-Section/JMST_Table Title/JMST_Fig Title... nếu vẫn dùng mẫu JMST).
