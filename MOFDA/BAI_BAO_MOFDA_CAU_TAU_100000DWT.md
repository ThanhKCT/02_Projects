TỐI ƯU HÓA ĐA MỤC TIÊU TIẾT DIỆN CỌC CẦU TÀU CONTAINER 100.000 DWT BẰNG THUẬT TOÁN MOFDA

MULTI-OBJECTIVE OPTIMIZATION OF PILE CROSS-SECTIONS FOR A 100,000-DWT CONTAINER WHARF USING THE MOFDA ALGORITHM

**[Họ và tên tác giả]¹\***

¹ *[Tên Khoa/Viện], [Tên trường/đơn vị công tác]*

\*Email liên hệ: *[điền địa chỉ email liên hệ chính thức của tác giả]*

DOI: https://doi.org/10.65154/jmst.%ID

---

## Tóm tắt

Cầu tàu container trên nền cọc có khối lượng vật liệu cọc lớn, trong khi thiết kế hiện hành thường chọn tiết diện theo kinh nghiệm, chưa khai thác bài toán tối ưu có ràng buộc. Bài báo ứng dụng thuật toán MOFDA (Multi-Objective Flow Direction Algorithm), đã công bố và kiểm chứng, để tối ưu tiết diện hệ cọc (bê tông ly tâm dự ứng lực và ống thép) của một cầu tàu container 100.000 DWT thực tế. Biến thiết kế gồm chỉ số catalogue cọc bê tông ly tâm (3 lựa chọn theo TCVN 7888:2014) và kích thước cọc thép rời rạc hóa, tạo không gian 243 tổ hợp. Hai mục tiêu là khối lượng vật liệu cọc và chuyển vị ngang lớn nhất, đánh giá qua mô hình SAP2000 kết nối MATLAB qua OAPI, chạy song song 8 tiến trình. Do không gian nhỏ, toàn bộ 243 tổ hợp được liệt kê để xác định mặt Pareto thật (16 nghiệm) đối chiếu. MOFDA tìm được 14 nghiệm không bị trội, trong đó 8/16 trùng khớp chính xác mặt Pareto thật, xác nhận thuật toán hội tụ đúng hướng dù chưa bao phủ hết không gian tối ưu. Khối lượng vật liệu dao động 3.030,6–4.298,3 tấn ứng chuyển vị 11,9–13,9 mm, thấp hơn nhiều giới hạn 71,7 mm theo TCVN 11820-5:2021. Nghiên cứu cung cấp cơ sở định lượng cho lựa chọn tiết diện cọc bến cảng, minh chứng khả năng áp dụng MOFDA với mô hình FEM thật.

**Từ khóa:** tối ưu đa mục tiêu, thuật toán MOFDA, tiết diện cọc, cầu tàu trên nền cọc, kết nối SAP2000-MATLAB.

## Abstract

Container wharves on pile foundations require large quantities of pile material, yet current practice typically sizes pile cross-sections by experience followed by verification, rather than through systematic constrained optimization. This paper applies the Multi-Objective Flow Direction Algorithm (MOFDA) — a previously published and validated algorithm — to optimize the pile cross-sections (prestressed spun concrete piles and steel pipe piles) of a real 100,000-DWT container wharf in Vietnam. The design variables comprise a catalogue index for the concrete pile (three choices, D700/D800/D900, from the commercial AMACCAO catalogue per TCVN 7888:2014) and steel pile dimensions discretized on a fixed grid, yielding a search space of 243 combinations. The two objectives are pile material mass and the maximum lateral displacement of the wharf under the governing load envelope, evaluated directly through a SAP2000 finite-element model (4,913 joints, 1,734 frame elements, 4,488 shell elements) coupled to MATLAB via the Open Application Programming Interface (OAPI), executed in parallel across eight instances. Because the discrete search space is small, the full set of 243 combinations was also exhaustively enumerated to establish the true Pareto front (16 solutions), used as ground truth to verify the MOFDA results. MOFDA (population 15, 15 iterations) found 14 non-dominated solutions, of which 8 of 16 exactly matched the true Pareto front, confirming correct convergence behaviour despite an evaluation budget insufficient to recover the full optimal set. Results show pile material mass ranging from 3,030.6 to 4,298.3 tonnes against lateral displacements of 11.9–13.9 mm, well below the 71.7 mm allowable limit per TCVN 11820-5:2021. The study provides a quantitative basis for pile cross-section selection in wharf design and demonstrates the practical applicability of MOFDA coupled directly with a genuine finite-element model.

**Keywords:** multi-objective optimization, MOFDA algorithm, pile cross-section, piled wharf, SAP2000-MATLAB coupling.

---

## 1. Mở đầu

Cầu tàu container trên nền cọc là dạng kết cấu phổ biến trong các bến cảng biển trọng tải lớn tại Việt Nam. Hệ cọc — thường kết hợp cọc bê tông cốt thép dự ứng lực (BTCT DƯL) ly tâm và cọc ống thép — là cấu kiện chịu lực chính, đồng thời chiếm tỷ trọng lớn trong khối lượng vật liệu và chi phí xây dựng. Quy trình thiết kế phổ biến hiện nay là chọn trước tiết diện cọc theo kinh nghiệm hoặc catalogue thương mại, sau đó kiểm tra lại bằng mô hình phần tử hữu hạn (FEM) — một quy trình thuận (forward design) chưa được hệ thống hóa thành bài toán tối ưu có ràng buộc.

Các thuật toán tối ưu dựa trên metaheuristic (GA, PSO, GWO, WOA, các biến thể thuật toán dòng chảy...) đã được ứng dụng rộng rãi cho tối ưu kết cấu khung thép, giàn, dầm. Thuật toán Flow Direction đa mục tiêu (MOFDA — Multi-Objective Flow Direction Algorithm) là một thuật toán đã được công bố, với cơ chế lựa chọn thủ lĩnh lai (hybrid leader selection) thay cho phương pháp bánh xe roulette truyền thống, đã được kiểm chứng trên 31 hàm chuẩn, 11 bài toán kỹ thuật có ràng buộc và một công trình khung thép thực tế [1]. Bài báo này kế thừa MOFDA đã được kiểm chứng, mở rộng ứng dụng sang một đối tượng kết cấu mới: hệ cọc công trình bến cảng, gồm hai loại vật liệu (BTCT DƯL và thép), chịu tải trọng phức hợp (tải đứng, tải ngang, mô men do va/neo tàu), kết hợp trực tiếp với mô hình FEM thật thay vì hàm mục tiêu giải tích hay mô hình thay thế (surrogate).

Việc ứng dụng thuật toán tối ưu đa mục tiêu kết hợp trực tiếp với mô hình FEM thật cho bài toán tiết diện hệ cọc công trình bến cảng, theo đúng hệ tiêu chuẩn thiết kế công trình cảng biển Việt Nam hiện hành, chưa được công bố trong tài liệu tiếng Việt. Mục tiêu của bài báo là: (i) hình thành bài toán tối ưu đa mục tiêu cho tiết diện cọc của một cầu tàu 100.000 DWT thực tế, với biến thiết kế theo catalogue thương mại thật và ràng buộc theo tiêu chuẩn Việt Nam hiện hành; (ii) xây dựng khung kết nối MOFDA (MATLAB) với SAP2000 qua OAPI, chạy song song nhiều tiến trình; (iii) đối chiếu kết quả MOFDA với mặt Pareto thật (do không gian tìm kiếm rời rạc đủ nhỏ để liệt kê toàn bộ), qua đó xác nhận độ tin cậy của thuật toán trong bài toán cụ thể này.

Cần nhấn mạnh phạm vi bài báo: (1) MOFDA được sử dụng như công cụ đã kiểm chứng, không phải đối tượng phát triển mới, do đó bài báo không so sánh MOFDA với các thuật toán tối ưu đa mục tiêu khác; (2) hồ sơ thiết kế kỹ thuật của công trình chỉ được sử dụng để dựng mô hình FEM đầu vào (hình học, vật liệu, tải trọng, điều kiện biên), không nhằm mục đích đánh giá hay phê bình hồ sơ thiết kế gốc.

## 2. Đối tượng nghiên cứu và mô hình phần tử hữu hạn

### 2.1. Mô tả công trình

Đối tượng nghiên cứu là cầu tàu container 100.000 DWT thuộc dự án cảng cửa ngõ quốc tế Hải Phòng (Lạch Huyện), kết cấu bến liền bờ dạng bệ cọc cao đài mềm (dầm–bản BTCT trên nền cọc). Mô hình phân tích đại diện cho một phân đoạn tiêu chuẩn dài khoảng 75 m, rộng mặt cầu 50 m, cao trình đỉnh bến +5,50 m và đáy bến sau nạo vét −16,0 m (Hải đồ). Tàu thiết kế 100.000 DWT có chiều dài 330 m, chiều rộng 45,5 m, mớn nước đầy tải 14,8 m.

### 2.2. Hệ cọc

Hệ cọc của một phân đoạn gồm 132 cọc ống BTCT DƯL D800-540 (bố trí thẳng đứng và xiên 6:1) và 60 cọc ống thép D1016-T16 (xiên 6:1 và 7:1), tổng cộng 192 cọc. Trong bài toán tối ưu này, tiết diện cọc (đường kính, chiều dày) được coi là biến thiết kế áp dụng đồng nhất cho toàn bộ cọc cùng loại; vị trí, độ xiên và chiều dài cọc giữ nguyên theo hồ sơ.

### 2.3. Mô hình SAP2000

Mô hình FEM tuyến tính tĩnh được xây dựng trong SAP2000, gồm 4.913 nút, 1.734 phần tử thanh và 4.488 phần tử tấm vỏ, đơn vị làm việc Tonf–m–°C. Vật liệu gồm bê tông M400 (dầm/bản), M800 (cọc BTCT), thép cọc, cốt thép A615Gr60 và tao dự ứng lực A416Gr270. Điều kiện biên gồm 192 nút ngàm biên phân đoạn và 178 nút gán lò xo nền theo phương dọc trục cọc. Mô hình bao gồm 36 tổ hợp tải cơ bản (tĩnh tải, va tàu, neo tàu, tải môi trường, hàng hóa khai thác, cần trục); trong đó 35/36 tổ hợp đã được gộp sẵn thành một tổ hợp bao dạng đường bao (envelope) trong mô hình gốc, được sử dụng trực tiếp cho việc trích xuất chuyển vị và nội lực nhằm giảm số lượt truy xuất kết quả qua OAPI. Tổ hợp bão riêng (hệ số vượt tải 1,25 cho tải cần trục khi có bão) nằm ngoài phạm vi đường bao này và chưa được đưa vào campaign tối ưu — đây là một giới hạn được ghi nhận rõ trong mục 4.4.

## 3. Phương pháp

### 3.1. Bài toán tối ưu đa mục tiêu

**Biến thiết kế.** Bài toán có ba biến thiết kế:

x = [CatIdx_BTCT, D_thép, t_thép]

trong đó CatIdx_BTCT là chỉ số dòng trong catalogue cọc bê tông ly tâm dự ứng lực (PHC) của nhà sản xuất AMACCAO, theo TCVN 7888:2014 và JIS A 5373:2016 [2], giới hạn trong ba dòng nằm trong miền nghiên cứu ban đầu 0,70–0,90 m (Bảng 1). Đường kính và chiều dày cọc BTCT không còn là hai biến độc lập — mỗi đường kính catalogue tương ứng đúng một chiều dày cố định, phản ánh đúng thực tế sản phẩm thương mại. Cọc ống thép (D1016-T16) chưa có catalogue thương mại tương ứng nên được rời rạc hóa theo lưới cố định: D_thép trong [0,90; 1,10] m bước 25 mm (9 giá trị), t_thép trong [0,012; 0,020] m bước 1 mm (9 giá trị), nằm trong dải cho phép tham chiếu của TCVN 9245:2012/JIS A5525. Không gian tìm kiếm là tích của ba miền rời rạc: 3×9×9 = 243 tổ hợp.

**Bảng 1.** Catalogue cọc bê tông ly tâm AMACCAO sử dụng (Class A, TCVN 7888:2014) [JMST_Table Title]

| CatIdx | Đường kính D (m) | Chiều dày t (m) | Diện tích A (m²) | M_cr (T.m) | M_u (T.m) | P_vl (T) |
|---|---:|---:|---:|---:|---:|---:|
| 1 | 0,700 | 0,110 | 0,20389 | 26,00 | 39,00 | 500 |
| 2 | 0,800 | 0,120 | 0,25635 | 37,00 | 55,50 | 680 |
| 3 | 0,900 | 0,130 | 0,31447 | 48,95 | 73,42 | 880 |

*Nguồn: Catalogue cọc bê tông ly tâm AMACCAO PILE [2], quy đổi mô men từ kN.m sang T.m.* [JMST_Source]

**Hàm mục tiêu.** Hai hàm mục tiêu được xét đồng thời:

f₁ = A(D,t)_BTCT × ΣL_BTCT × γ_bt + A(D,t)_thép × ΣL_thép × γ_thép  (1)

f₂ = max(√(U₁² + U₂²))  (2)

trong đó f₁ là tổng khối lượng vật liệu cọc (tấn), tính từ diện tích mặt cắt vành khuyên nhân với tổng chiều dài chế tạo thực tế của từng nhóm cọc (không dùng chiều dài mô hình FEM đến điểm ngàm ảo) và khối lượng riêng vật liệu (γ_bê tông = 2,5 T/m³, γ_thép = 7,85 T/m³ — đã đối chiếu khớp với dữ liệu trọng lượng danh định của catalogue AMACCAO); f₂ là chuyển vị ngang lớn nhất của cầu tàu (U₁, U₂ là hai thành phần chuyển vị theo hai phương ngang) trên tổ hợp bao, không xét thành phần đứng.

**Ràng buộc.** Bốn nhóm ràng buộc được áp dụng:

g₁: N/P_vl + M/M_u − 1 ≤ 0  (3)

theo đúng công thức tương tác lực dọc trục – mô men do nhà sản xuất khuyến nghị cho cọc ly tâm dự ứng lực [2], thay cho việc kiểm tra riêng lẻ lực dọc trục và mô men;

g₂: σ_thép/(F_y/γ_M) − 1 ≤ 0, với σ_thép = N/A + M/W tính gần đúng cho ứng suất nén/kéo dọc trục kết hợp uốn hai phương của cọc ống thép, F_y = 3.150 kG/cm² theo bản vẽ thiết kế (TCVN 9245:2012);

g₃: U_max/U_allow − 1 ≤ 0, với U_allow = 71,7 mm, xác định theo TCVN 11820-5:2021, Điều 8.9, Bảng 12 — giới hạn chuyển vị ngang tại đỉnh bến trên nền cọc bằng 1/300 chiều cao bến (H = 21,5 m, tính từ cao trình đỉnh bến đến đáy bến hoàn thiện) và không vượt quá 100 mm;

g₄: ràng buộc sức chịu tải địa kỹ thuật theo TCVN 10304:2025 — hiện được ghi nhận trong khung bài toán nhưng chưa triển khai tính toán đầy đủ do thiếu số liệu chỉ tiêu cơ lý đất nền chi tiết (xem mục 4.4).

Vi phạm ràng buộc được chuẩn hóa và tổng hợp thành hàm phạt nhân đồng thời lên cả hai mục tiêu:

F_k(x) = f_k(x) × [1 + C×P(x)], k = 1,2  (4)

với P(x) = Σg_j(x)⁺ là tổng các vi phạm dương chuẩn hóa và C = 10 là hệ số khuếch đại phạt. Cách phạt nhân (thay vì cộng) tránh vấn đề khác thứ nguyên giữa khối lượng (tấn) và chuyển vị (m), đồng thời không làm sai lệch mặt Pareto khả thi (khi P(x)=0 thì F_k=f_k).

### 3.2. Thuật toán MOFDA

MOFDA mô phỏng chuyển động của một "dòng chảy" hướng về vùng có giá trị hàm mục tiêu tốt hơn, kết hợp cơ chế lựa chọn thủ lĩnh lai để tăng khả năng hội tụ và duy trì đa dạng nghiệm Pareto, lưu trữ các nghiệm không bị trội trong một kho lưu trữ (repository) có cơ chế lưới (grid) để kiểm soát mật độ nghiệm [1]. Bài báo sử dụng nguyên bản cơ chế thuật toán đã công bố, không điều chỉnh công thức cập nhật vị trí.

### 3.3. Khung kết nối MOFDA–SAP2000 và tính toán song song

Mỗi lần đánh giá một cá thể bao gồm: (i) ghi giá trị tiết diện cọc vào các thuộc tính mặt cắt tương ứng trong SAP2000 qua OAPI; (ii) chạy phân tích kết cấu; (iii) trích xuất chuyển vị và nội lực trên tổ hợp bao; (iv) tính hai hàm mục tiêu và mức vi phạm ràng buộc. Do khối lượng tính toán của việc thay đổi thuộc tính mặt cắt là nhỏ (không làm lại lưới phần tử), toàn bộ quá trình đánh giá được song song hóa trên 8 tiến trình SAP2000 độc lập, mỗi tiến trình lưu một bản sao mô hình riêng để tránh xung đột ghi file. Số lượng tiến trình song song được xác định thực nghiệm trên máy tính sử dụng (bộ xử lý 14 lõi/28 luồng): tăng từ 8 lên 10 tiến trình chỉ cải thiện thông lượng 8,6% do tranh chấp tài nguyên tính toán giữa các tiến trình SAP2000, không tương xứng với mức tăng 25% số tiến trình, nên 8 tiến trình được lựa chọn cho các lần chạy chính thức.

### 3.4. Liệt kê toàn bộ không gian tìm kiếm

Vì không gian tìm kiếm chỉ gồm 243 tổ hợp rời rạc — nhỏ hơn nhiều so với số lần đánh giá thông thường của một thuật toán quần thể — toàn bộ 243 tổ hợp được đánh giá trực tiếp qua cùng mô hình FEM để xác định chính xác mặt Pareto thật, dùng làm cơ sở đối chiếu khách quan cho kết quả MOFDA. Đây là một bước kiểm chứng bổ sung, tận dụng đặc điểm không gian rời rạc nhỏ của bài toán cụ thể này, không thay thế cho việc ứng dụng MOFDA.

## 4. Kết quả và thảo luận

### 4.1. Mặt Pareto thật (liệt kê toàn bộ)

Toàn bộ 243 tổ hợp được đánh giá thành công qua SAP2000 (không có tổ hợp nào bị loại do lỗi phân tích), trong thời gian 70,9 phút với 8 tiến trình song song. Kết quả xác định được 16 nghiệm không bị trội, trình bày trong Bảng 2.

**Bảng 2.** Mặt Pareto thật của bài toán (16 nghiệm, liệt kê toàn bộ 243 tổ hợp) [JMST_Table Title]

| CatIdx | D_thép (m) | t_thép (m) | f₁ (tấn) | f₂ (mm) |
|---|---:|---:|---:|---:|
| 1 | 1,100 | 0,0180 | 3.030,6 | 13,88 |
| 1 | 1,075 | 0,0190 | 3.056,8 | 13,76 |
| 1 | 1,100 | 0,0190 | 3.078,0 | 13,53 |
| 1 | 1,075 | 0,0200 | 3.103,0 | 13,44 |
| 1 | 1,100 | 0,0200 | 3.125,3 | 13,22 |
| 2 | 1,100 | 0,0180 | 3.587,1 | 13,15 |
| 2 | 1,075 | 0,0190 | 3.613,3 | 13,05 |
| 2 | 1,100 | 0,0190 | 3.634,5 | 12,86 |
| 2 | 1,075 | 0,0200 | 3.659,5 | 12,78 |
| 2 | 1,100 | 0,0200 | 3.681,8 | 12,60 |
| 3 | 1,075 | 0,0180 | 4.183,6 | 12,52 |
| 3 | 1,100 | 0,0180 | 4.203,7 | 12,37 |
| 3 | 1,075 | 0,0190 | 4.229,9 | 12,29 |
| 3 | 1,100 | 0,0190 | 4.251,0 | 12,13 |
| 3 | 1,075 | 0,0200 | 4.276,0 | 12,07 |
| 3 | 1,100 | 0,0200 | 4.298,3 | 11,92 |

Cả ba lựa chọn catalogue cọc BTCT (D700, D800, D900) đều xuất hiện trên mặt Pareto, không có lựa chọn nào bị loại hoàn toàn. Toàn bộ 16 nghiệm Pareto đều sử dụng cọc thép có kích thước lớn nhất trong miền nghiên cứu (D_thép = 1,075 hoặc 1,100 m; t_thép = 0,018–0,020 m) — phản ánh đúng bản chất vật lý: cọc thép càng lớn thì độ cứng hệ càng tăng, giảm chuyển vị ngang, đánh đổi bằng khối lượng vật liệu tăng thêm. Khối lượng vật liệu dao động 3.030,6–4.298,3 tấn ứng với chuyển vị ngang 11,92–13,88 mm — toàn bộ đều thấp hơn nhiều giới hạn cho phép 71,7 mm, cho thấy dải biến thiên chuyển vị trong bài toán này không phải yếu tố khống chế thiết kế mạnh, trong khi khối lượng vật liệu là mục tiêu có ý nghĩa thực tiễn rõ hơn để cân nhắc lựa chọn.

### 4.2. Đối chiếu kết quả MOFDA với mặt Pareto thật

MOFDA được chạy với quần thể 15 cá thể, 15 vòng lặp (1.140 lần đánh giá FEM), thời gian thực hiện 5,35 giờ với 8 tiến trình song song, tìm được 14 nghiệm không bị trội trong kho lưu trữ cuối cùng. Đối chiếu trực tiếp với 16 nghiệm Pareto thật (Bảng 2): **8/16 nghiệm (50%) trùng khớp chính xác** cả về biến thiết kế và giá trị hàm mục tiêu. Sáu nghiệm còn lại trong kho lưu trữ MOFDA, tuy không bị trội lẫn nhau trong tập nghiệm mà thuật toán đã khảo sát, bị trội bởi từ 1 đến 7 nghiệm khác trong tập 243 tổ hợp đầy đủ — tức là các nghiệm gần-tối-ưu nhưng chưa phải tối ưu toàn cục, do ngân sách đánh giá (1.140 lần) tuy lớn hơn số tổ hợp khả dĩ (243 lần) nhưng thuật toán quần thể không đảm bảo khảo sát hết mọi tổ hợp rời rạc.

Kết quả này khẳng định hai điểm: (i) MOFDA hội tụ đúng hướng, các nghiệm tìm được đều nằm gần mặt Pareto thật cả về giá trị hàm mục tiêu lẫn cấu trúc biến thiết kế (ưu tiên chọn cọc thép kích thước lớn, đúng như mặt Pareto thật); (ii) đối với bài toán có không gian tìm kiếm rời rạc nhỏ như trường hợp này, phương pháp liệt kê toàn bộ hiệu quả hơn về mặt tính toán (243 so với 1.140 lần đánh giá) và đảm bảo chắc chắn tìm được lời giải tối ưu toàn cục — một điểm cần lưu ý khi lựa chọn công cụ giải bài toán tối ưu, đặc biệt khi biến thiết kế được rời rạc hóa theo catalogue thương mại có số lựa chọn hạn chế.

### 4.3. Đề xuất kỹ thuật

Với dải nghiệm Pareto thu được, một nghiệm đại diện cân bằng giữa hai mục tiêu (ví dụ CatIdx=2, D_thép=1,100 m, t_thép=0,019 m: f₁≈3.634,5 tấn, f₂≈12,86 mm) có thể được xem xét làm phương án tham khảo cho giai đoạn thiết kế sơ bộ, tùy theo mức độ ưu tiên giữa tiết kiệm vật liệu và kiểm soát chuyển vị của dự án cụ thể. Việc lựa chọn cuối cùng cần kết hợp thêm các ràng buộc chưa triển khai đầy đủ trong nghiên cứu này (mục 4.4).

### 4.4. Giới hạn của nghiên cứu

Nghiên cứu còn một số giới hạn cần lưu ý khi áp dụng kết quả: (i) ràng buộc sức chịu tải địa kỹ thuật theo TCVN 10304:2025 chưa được triển khai tính toán đầy đủ do thiếu số liệu chỉ tiêu cơ lý đất nền chi tiết; (ii) tổ hợp tải trọng bão (hệ số vượt tải cho tải cần trục khi có bão) chưa được đưa vào phạm vi đánh giá của campaign tối ưu; (iii) catalogue cọc ống thép chưa có sẵn nên biến thiết kế tương ứng được rời rạc hóa theo lưới giả định, chưa phải danh mục sản phẩm thương mại thật như cọc BTCT; (iv) mô hình chỉ xét phân tích tuyến tính tĩnh, chưa xét ứng xử phi tuyến hình học/vật liệu hay tương tác đất–cọc chi tiết kiểu p–y. Các giới hạn này không làm thay đổi kết luận về khả năng ứng dụng của MOFDA nhưng cần được bổ sung trước khi sử dụng kết quả số cho thiết kế thi công.

## 5. Kết luận

Bài báo đã ứng dụng thành công thuật toán MOFDA để giải bài toán tối ưu đa mục tiêu tiết diện hệ cọc của một cầu tàu container 100.000 DWT thực tế, kết hợp trực tiếp với mô hình phần tử hữu hạn SAP2000 qua giao diện lập trình ứng dụng, chạy song song trên nhiều tiến trình. Các kết luận chính gồm:

(1) Bài toán tối ưu ba biến thiết kế (chỉ số catalogue cọc BTCT và kích thước cọc thép rời rạc hóa) với ràng buộc theo tiêu chuẩn Việt Nam hiện hành (TCVN 7888:2014, TCVN 11820-5:2021, TCVN 9245:2012) đã được hình thành và giải thành công.

(2) Không gian tìm kiếm rời rạc của bài toán chỉ gồm 243 tổ hợp — nhỏ hơn dự kiến ban đầu — cho phép liệt kê toàn bộ để xác định chính xác mặt Pareto thật gồm 16 nghiệm, làm cơ sở đối chiếu khách quan cho kết quả MOFDA.

(3) MOFDA tìm được 14 nghiệm không bị trội, trong đó 8/16 nghiệm trùng khớp chính xác với mặt Pareto thật, xác nhận thuật toán hội tụ đúng hướng trong bài toán kỹ thuật thực tế này, dù chưa bao phủ hết không gian nghiệm tối ưu với ngân sách đánh giá đã dùng.

(4) Khối lượng vật liệu cọc tối ưu dao động 3.030,6–4.298,3 tấn, tương ứng chuyển vị ngang 11,9–13,9 mm — đều thấp hơn nhiều giới hạn cho phép 71,7 mm theo TCVN 11820-5:2021, cho thấy dư địa lựa chọn thiết kế theo mục tiêu tiết kiệm vật liệu.

(5) Đối với các bài toán có không gian thiết kế rời rạc nhỏ (do giới hạn của catalogue thương mại), phương pháp liệt kê toàn bộ nên được cân nhắc song song với thuật toán metaheuristic để vừa đảm bảo tìm được lời giải tối ưu toàn cục, vừa có cơ sở kiểm chứng độ tin cậy của thuật toán áp dụng.

## Lời cảm ơn

*(nếu có)*

## TÀI LIỆU THAM KHẢO

[1] Truong V.H., Khatir S., Cuong-Le T. (2026), *Real-World Steel Frame Optimization Using a Hybrid Leader Selection-Based Multi-Objective Flow Direction Algorithm*, Center for Engineering Application & Technology Solutions, Trường Đại học Mở Thành phố Hồ Chí Minh.

[2] AMACCAO PILE (2014), *Catalog và thông số kỹ thuật cọc bê tông ly tâm AMACCAO D300-D1200*, theo TCVN 7888:2014 và JIS A 5373:2016.

[3] Bộ Khoa học và Công nghệ (2021), *TCVN 11820-5:2021 — Công trình cảng biển – Yêu cầu thiết kế – Phần 5: Công trình bến*.

[4] Bộ Khoa học và Công nghệ (2020), *TCVN 11820-4-1:2020 — Công trình cảng biển – Yêu cầu thiết kế – Phần 4-1: Nền móng*.

[5] Bộ Khoa học và Công nghệ, *TCVN 10304:2025 — Thiết kế móng cọc*.

[6] Bộ Khoa học và Công nghệ, *TCVN 9245:2012 — Cọc ống thép*.

---

Ngày nhận bài: xx/xx/2026
Ngày nhận bản sửa: xx/xx/2026
Ngày duyệt đăng: xx/xx/2026
