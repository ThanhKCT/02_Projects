TỐI ƯU ĐA MỤC TIÊU TIẾT DIỆN HỆ CỌC CẦU TÀU CONTAINER 100.000 DWT SỬ DỤNG THUẬT TOÁN MOFDA

MULTI-OBJECTIVE OPTIMIZATION OF PILE-SYSTEM CROSS-SECTIONS FOR A 100,000-DWT CONTAINER WHARF USING THE MOFDA ALGORITHM

**[Họ và tên tác giả]¹\***

¹ *[Tên Khoa/Viện], [Tên trường/đơn vị công tác]*

\*Email liên hệ: *[điền địa chỉ email liên hệ chính thức của tác giả]*

DOI: https://doi.org/10.65154/jmst.%ID

---

## Tóm tắt

Cầu tàu container trên nền cọc có khối lượng vật liệu cho phần cọc lớn, trong khi tiết diện cọc trong thiết kế hiện hành thường được chọn sơ bộ rồi kiểm tra, chưa khai thác đầy đủ bài toán tối ưu có ràng buộc. Nghiên cứu xây dựng bài toán tối ưu đa mục tiêu cho tiết diện hệ cọc bê tông ly tâm dự ứng lực và cọc ống thép của một cầu tàu container 100.000 DWT thực tế. Biến thiết kế gồm 3 lựa chọn cọc bê tông theo TCVN 7888:2014 và các kích thước cọc thép rời rạc, tạo thành 243 tổ hợp. Hai mục tiêu là khối lượng vật liệu cọc và chuyển vị ngang lớn nhất, được đánh giá bằng mô hình phần tử hữu hạn SAP2000 kết nối MATLAB qua OAPI. Thuật toán hướng dòng chảy đa mục tiêu (Multi-Objective Flow Direction Algorithm – MOFDA), đã được công bố và kiểm chứng trước đó, được áp dụng để giải bài toán. Toàn bộ 243 tổ hợp được liệt kê để xây dựng mặt Pareto tham chiếu trong phạm vi các ràng buộc, gồm 16 nghiệm. MOFDA tìm được 14 nghiệm không bị trội, trong đó nhận diện chính xác 8/16 nghiệm Pareto tham chiếu. Các nghiệm Pareto cho thấy sự đánh đổi giữa khối lượng vật liệu (3.030,6–4.298,3 tấn) và chuyển vị ngang (11,9–13,9 mm), đều thấp hơn đáng kể giới hạn 71,7 mm theo TCVN 11820-5:2021. Kết quả cung cấp cơ sở định lượng hỗ trợ lựa chọn tiết diện cọc ở giai đoạn thiết kế sơ bộ.

**Từ khóa:** tối ưu đa mục tiêu, thuật toán MOFDA, tiết diện cọc, cầu tàu trên nền cọc, kết nối SAP2000-MATLAB.

## Abstract

Container wharves on pile foundations require a large quantity of pile material, while current design practice typically selects the pile cross-section preliminarily and then verifies it, without fully exploiting constrained optimization. This study formulates a multi-objective optimization problem for the cross-sections of the pile system — prestressed spun concrete piles and steel pipe piles — of a real 100,000-DWT container wharf. The design variables comprise three concrete pile options per TCVN 7888:2014 and discretized steel pile dimensions, forming 243 combinations. The two objectives are pile material mass and maximum lateral displacement, evaluated using a SAP2000 finite-element model coupled with MATLAB via OAPI. The Multi-Objective Flow Direction Algorithm (MOFDA), previously published and validated, is applied to solve the problem. All 243 combinations are enumerated to construct a reference Pareto front within the imposed constraints, comprising 16 solutions. MOFDA found 14 non-dominated solutions, of which 8 out of 16 reference Pareto solutions were exactly identified. The Pareto solutions show a trade-off between material mass (3,030.6–4,298.3 tonnes) and lateral displacement (11.9–13.9 mm), all significantly below the 71.7 mm limit per TCVN 11820-5:2021. The results provide a quantitative basis to support pile cross-section selection at the preliminary design stage.

**Keywords:** multi-objective optimization, MOFDA algorithm, pile cross-section, piled wharf, SAP2000-MATLAB coupling.

---

## 1. Mở đầu

Cầu tàu container trên nền cọc là dạng kết cấu phổ biến trong các bến cảng biển trọng tải lớn tại Việt Nam. Hệ cọc — thường kết hợp cọc bê tông cốt thép dự ứng lực (BTCT DƯL) ly tâm và cọc ống thép — là cấu kiện chịu lực chính, đồng thời chiếm tỷ trọng lớn trong khối lượng vật liệu và chi phí xây dựng. Quy trình thiết kế phổ biến hiện nay là chọn trước tiết diện cọc theo kinh nghiệm hoặc catalogue thương mại, sau đó kiểm tra lại bằng mô hình phần tử hữu hạn (FEM) — một quy trình thuận (forward design) chưa được hệ thống hóa thành bài toán tối ưu có ràng buộc.

Các thuật toán tối ưu dựa trên metaheuristic (GA, PSO, GWO, WOA, các biến thể thuật toán dòng chảy...) đã được ứng dụng rộng rãi cho tối ưu kết cấu khung thép, giàn, dầm. Thuật toán Flow Direction đa mục tiêu (MOFDA) là một thuật toán đã được công bố, với cơ chế lựa chọn thủ lĩnh lai (hybrid leader selection) thay cho phương pháp bánh xe roulette truyền thống, đã được kiểm chứng trên 31 hàm chuẩn, 11 bài toán kỹ thuật có ràng buộc và một công trình khung thép thực tế [1]. Bài báo này kế thừa MOFDA đã được kiểm chứng và áp dụng cho một đối tượng kết cấu khác là hệ cọc công trình bến cảng, gồm hai loại vật liệu, chịu tải trọng phức hợp, kết hợp trực tiếp với mô hình FEM thật thay vì hàm mục tiêu giải tích hay mô hình thay thế.

Theo phạm vi tài liệu được khảo sát, việc kết hợp tối ưu đa mục tiêu với mô hình phần tử hữu hạn trực tiếp cho bài toán tiết diện hệ cọc cầu tàu thực tế, theo các tiêu chuẩn thiết kế công trình cảng biển Việt Nam được áp dụng trong phạm vi nghiên cứu, còn ít được đề cập. Mục tiêu của bài báo là: (i) hình thành bài toán tối ưu đa mục tiêu cho tiết diện cọc của một cầu tàu 100.000 DWT thực tế, với biến thiết kế theo catalogue thương mại và các ràng buộc kết cấu, chuyển vị được xây dựng theo các tiêu chuẩn Việt Nam áp dụng trong phạm vi dữ liệu nghiên cứu; (ii) xây dựng quy trình kết nối MOFDA (MATLAB) với SAP2000 qua OAPI, chạy song song nhiều tiến trình để tự động đánh giá phương án bằng mô hình FEM; (iii) đối chiếu kết quả MOFDA với mặt Pareto tham chiếu (thu được bằng cách liệt kê toàn bộ không gian thiết kế rời rạc, do không gian này đủ nhỏ), qua đó đánh giá khả năng ứng dụng của thuật toán trong bài toán kết cấu thực tế cụ thể này.

## 2. Đối tượng nghiên cứu và mô hình phần tử hữu hạn

### 2.1. Mô tả công trình

Đối tượng nghiên cứu là cầu tàu container 100.000 DWT thuộc dự án cảng cửa ngõ quốc tế Hải Phòng (Lạch Huyện), kết cấu bến liền bờ dạng bệ cọc cao đài mềm. Mô hình phân tích đại diện cho một phân đoạn tiêu chuẩn dài khoảng 75 m, rộng mặt cầu 50 m, cao trình đỉnh bến +5,50 m và đáy bến sau nạo vét −16,0 m (Hải đồ). Tàu thiết kế 100.000 DWT có chiều dài 330 m, chiều rộng 45,5 m, mớn nước đầy tải 14,8 m.

**Hình 1.** Mô hình SAP2000 của cầu tàu container 100.000 DWT: (a) mặt đứng (2D); (b) phối cảnh không gian (3D)

*[Ảnh: fig_hinh1a_sap2d.png (a) và fig_hinh1b_sap3d.png (b) — nhúng trực tiếp trong file Word]*

### 2.2. Hệ cọc

Hệ cọc của một phân đoạn gồm 132 cọc ống BTCT DƯL D800-540 (bố trí thẳng đứng và xiên 6:1) và 60 cọc ống thép D1016-T16 (xiên 6:1 và 7:1), tổng cộng 192 cọc. Trong bài toán tối ưu này, tiết diện cọc được coi là biến thiết kế áp dụng đồng nhất cho toàn bộ cọc cùng loại; vị trí, độ xiên và chiều dài cọc được giữ cố định trong tất cả các phương án khảo sát.

### 2.3. Mô hình SAP2000

Mô hình FEM tuyến tính tĩnh được xây dựng trong SAP2000, gồm 4.913 nút, 1.734 phần tử thanh và 4.488 phần tử tấm vỏ, đơn vị làm việc Tonf–m–°C. Vật liệu gồm bê tông M400 (dầm/bản), M800 (cọc BTCT), thép cọc, cốt thép A615Gr60 và tao dự ứng lực A416Gr270. Điều kiện biên gồm 192 nút ngàm biên phân đoạn và 178 nút gán lò xo nền theo phương dọc trục cọc. Mô hình bao gồm 36 tổ hợp tải cơ bản; trong đó 35/36 tổ hợp đã được gộp sẵn thành một tổ hợp bao dạng đường bao (envelope) trong mô hình tính toán, được sử dụng trực tiếp cho việc trích xuất chuyển vị và nội lực. Tổ hợp bão riêng (hệ số vượt tải 1,25 cho tải cần trục khi có bão) nằm ngoài phạm vi đường bao này và chưa được đưa vào đợt tính toán tối ưu — giới hạn được nêu rõ tại mục 4.4.

## 3. Phương pháp

### 3.1. Bài toán tối ưu đa mục tiêu

Bài toán được xây dựng dưới dạng tối ưu rời rạc, trong đó các biến thiết kế chỉ nhận các giá trị thuộc các miền lựa chọn xác định trước (catalogue thương mại đối với cọc BTCT, lưới giá trị rời rạc đối với cọc thép), thay vì biến liên tục. Bài toán có ba biến thiết kế:

x = [CatIdx_BTCT, D_thép, t_thép]  (1)

với cận dưới và cận trên của từng biến thiết kế: CatIdx_BTCT ∈ {1, 2, 3} (cận dưới 1, cận trên 3, tương ứng D700–D900, Bảng 1); D_thép ∈ [0,900; 1,100] m, bước 0,025 m (cận dưới 0,900 m, cận trên 1,100 m, 9 giá trị); t_thép ∈ [0,012; 0,020] m, bước 0,001 m (cận dưới 0,012 m, cận trên 0,020 m, 9 giá trị).

CatIdx_BTCT là chỉ số dòng trong catalogue cọc bê tông ly tâm dự ứng lực (PHC) của nhà sản xuất AMACCAO, theo TCVN 7888:2014 và JIS A 5373:2016 [2], giới hạn trong ba dòng nằm trong miền nghiên cứu ban đầu có đường kính từ 0,70 đến 0,90 m (Bảng 1). Đường kính và chiều dày cọc BTCT không còn là hai biến độc lập — mỗi đường kính catalogue tương ứng đúng một chiều dày cố định. Cọc ống thép (D1016-T16) chưa có catalogue thương mại tương ứng nên được rời rạc hóa theo lưới cố định trong phạm vi cận trên/cận dưới nêu trên. Không gian tìm kiếm là tích của ba miền rời rạc: 3×9×9 = 243 tổ hợp.

**Bảng 1.** Catalogue cọc bê tông ly tâm AMACCAO sử dụng (Class A, TCVN 7888:2014)

| CatIdx | D (m) | t (m) | A (m²) | Mcr (T.m) | Mu (T.m) | Pvl (T) |
|---|---:|---:|---:|---:|---:|---:|
| 1 | 0,700 | 0,110 | 0,20389 | 26,00 | 39,00 | 500 |
| 2 | 0,800 | 0,120 | 0,25635 | 37,00 | 55,50 | 680 |
| 3 | 0,900 | 0,130 | 0,31447 | 48,95 | 73,42 | 880 |

Nguồn: Catalogue cọc bê tông ly tâm AMACCAO PILE [2], quy đổi mô men kN.m sang T.m.

Hai hàm mục tiêu được xét đồng thời:

f₁ = A(D,t)_BTCT × ΣL_BTCT × γ_bt + A(D,t)_thép × ΣL_thép × γ_thép  (2)

f₂ = max(√(U₁² + U₂²))  (3)

trong đó f₁ là tổng khối lượng vật liệu cọc (tấn), tính từ diện tích mặt cắt vành khuyên nhân với tổng chiều dài chế tạo thực tế của từng nhóm cọc và khối lượng riêng vật liệu (γ_bê tông = 2,5 T/m³, γ_thép = 7,85 T/m³ — đã đối chiếu khớp với dữ liệu trọng lượng danh định của catalogue AMACCAO); f₂ là chuyển vị ngang lớn nhất của cầu tàu trên tổ hợp bao, không xét thành phần đứng. Hai mục tiêu này phản ánh sự đánh đổi giữa yêu cầu giảm khối lượng vật liệu và yêu cầu bảo đảm độ cứng ngang cần thiết của hệ cọc, qua đó kiểm soát chuyển vị ngang của cầu tàu.

Ba nhóm ràng buộc được áp dụng trực tiếp trong quá trình đánh giá phương án, gồm: (i) tương tác lực dọc trục – mô men cọc BTCT theo đúng công thức do nhà sản xuất khuyến nghị cho cọc ly tâm dự ứng lực [2]:

N/Pvl + M/Mu − 1 ≤ 0  (4)

(ii) ứng suất cọc thép σ = N/A + M/W ≤ Fy/γM, với Fy = 3.150 kG/cm² (TCVN 9245:2012); và (iii) chuyển vị ngang U_max/U_allow − 1 ≤ 0, với U_allow = 71,7 mm theo TCVN 11820-5:2021, Điều 8.9, Bảng 12 (1/300 chiều cao bến, H = 21,5 m, không vượt quá 100 mm). Sức chịu tải địa kỹ thuật theo TCVN 10304:2025 được xác định là một yêu cầu kiểm tra cần thiết nhưng chưa được triển khai định lượng trong nghiên cứu do thiếu đầy đủ số liệu chỉ tiêu cơ lý đất nền (mục 4.4). Do đó, kết quả tối ưu chỉ có giá trị trong phạm vi ba nhóm ràng buộc đã được triển khai và chưa được sử dụng để thay thế kiểm tra địa kỹ thuật trong thiết kế chính thức.

Vi phạm ràng buộc được chuẩn hóa và tổng hợp thành hàm phạt nhân đồng thời lên cả hai mục tiêu:

Fk(x) = fk(x) × [1 + C×P(x)], k = 1,2  (5)

với P(x) là tổng các vi phạm dương chuẩn hóa và C = 10 là hệ số khuếch đại phạt. Mỗi mức vi phạm được chuẩn hóa theo dạng v_i = max(0, g_i), với g_i là hàm ràng buộc đã được đưa về dạng không thứ nguyên g_i ≤ 0; khi đó P(x) = Σv_i. Cách phạt nhân cho phép duy trì dạng thứ nguyên của từng hàm mục tiêu và hạn chế ảnh hưởng của sự khác biệt về thang đo giữa khối lượng và chuyển vị; khi P(x)=0 thì Fk=fk, tức phương án khả thi không chịu tác động của hàm phạt. Giá trị C = 10 được lựa chọn qua các lần chạy thử và giữ cố định trong toàn bộ đợt tính toán chính thức.

### 3.2. Thuật toán MOFDA

MOFDA mô phỏng chuyển động của một "dòng chảy" hướng về vùng có giá trị hàm mục tiêu tốt hơn, kết hợp cơ chế lựa chọn thủ lĩnh lai để tăng khả năng hội tụ và duy trì đa dạng nghiệm Pareto, lưu trữ các nghiệm không bị trội trong một kho lưu trữ có cơ chế lưới để kiểm soát mật độ nghiệm [1]. Bài báo sử dụng nguyên bản cơ chế thuật toán đã công bố, không điều chỉnh công thức cập nhật vị trí.

### 3.3. Quy trình kết nối MOFDA–SAP2000 và tính toán song song

Mỗi lần đánh giá một cá thể được thực hiện theo chu trình: (1) MOFDA sinh phương án tiết diện; (2) MATLAB truyền biến thiết kế sang SAP2000 qua OAPI; (3) SAP2000 cập nhật mô hình và phân tích; (4) MATLAB nhận chuyển vị và nội lực trên tổ hợp bao; (5) tính hai hàm mục tiêu và kiểm tra vi phạm ràng buộc; (6) kết quả trả về MOFDA; (7) thuật toán tiếp tục tìm kiếm ở vòng lặp kế tiếp. Toàn bộ quá trình được song song hóa trên 8 tiến trình SAP2000 độc lập, mỗi tiến trình sử dụng một bản sao mô hình riêng để tránh xung đột khi ghi tệp. Số lượng 8 tiến trình được lựa chọn qua các lần thử nghiệm trên máy tính sử dụng 14 lõi/28 luồng, trong đó việc tăng thêm số tiến trình không cho thấy hiệu quả tính toán tương xứng do tranh chấp tài nguyên.

### 3.4. Liệt kê toàn bộ không gian tìm kiếm

Do không gian thiết kế hiện tại chỉ gồm 243 tổ hợp — nhỏ hơn nhiều so với số lần đánh giá thông thường của một thuật toán quần thể — toàn bộ không gian được đánh giá trực tiếp qua cùng mô hình FEM để xây dựng mặt Pareto tham chiếu cho kết quả MOFDA. Đây là một bước kiểm chứng bổ sung, tận dụng đặc điểm không gian rời rạc nhỏ của bài toán này, không nhằm thay thế cho việc ứng dụng MOFDA và không phải một phương pháp cạnh tranh với thuật toán.

## 4. Kết quả và thảo luận

### 4.1. Mặt Pareto tham chiếu (liệt kê toàn bộ)

Toàn bộ 243 tổ hợp được đánh giá thành công qua SAP2000, trong thời gian 70,9 phút với 8 tiến trình song song. Kết quả xác định được 16 nghiệm không bị trội, trình bày trong Bảng 2.

**Bảng 2.** Mặt Pareto tham chiếu thu được từ 243 tổ hợp thiết kế (16 nghiệm không bị trội)

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

Cả ba lựa chọn catalogue cọc BTCT (D700, D800, D900) đều xuất hiện trên mặt Pareto. Toàn bộ 16 nghiệm Pareto đều sử dụng đường kính cọc thép ở phía trên của miền khảo sát, D_thép = 1,075–1,100 m; chiều dày thay đổi trong khoảng t_thép = 0,018–0,020 m. Kết quả cho thấy trong miền thiết kế khảo sát, tăng kích thước cọc thép làm tăng độ cứng ngang của hệ và có xu hướng giảm chuyển vị, đồng thời làm tăng khối lượng vật liệu. Khối lượng vật liệu dao động 3.030,6–4.298,3 tấn ứng với chuyển vị ngang 11,92–13,88 mm — đều thấp hơn nhiều giới hạn cho phép 71,7 mm.

**Hình 2.** Mặt Pareto tham chiếu của bài toán (16 nghiệm, liệt kê toàn bộ)

*[Ảnh: fig_hinh2_pareto_thamchieu.png — nhúng trực tiếp trong file Word]*

### 4.2. Đối chiếu kết quả MOFDA với mặt Pareto tham chiếu

MOFDA được thực hiện một lần chạy chính thức, với quần thể 15 cá thể, 15 vòng lặp; ở mỗi vòng lặp, mỗi cá thể tạo ra β = 4 hướng dòng chảy lân cận cộng với 1 lần cập nhật chính (đặc thù cơ chế tìm kiếm của MOFDA), tương ứng tổng số lần đánh giá FEM là Np×[1 + maxiter×(β+1)] = 15×[1 + 15×5] = 1.140 lần. Thời gian thực hiện 5,35 giờ với 8 tiến trình song song, thu được 14 nghiệm không bị trội trong kho lưu trữ của lần chạy này. Đối chiếu trực tiếp với 16 nghiệm thuộc mặt Pareto tham chiếu: 8 trong 16 nghiệm (50%) được nhận diện chính xác, trùng khớp cả về biến thiết kế và giá trị hàm mục tiêu. Kết quả cho thấy thuật toán có khả năng hội tụ về vùng nghiệm Pareto của bài toán trong giới hạn số lần đánh giá được sử dụng. Sáu nghiệm còn lại không bị trội trong tập nghiệm của MOFDA nhưng bị trội khi xét toàn bộ 243 tổ hợp, cho thấy đây là các nghiệm gần vùng Pareto nhưng chưa thuộc mặt Pareto tham chiếu.

**Hình 3.** Đối chiếu mặt Pareto MOFDA (14 nghiệm) với mặt Pareto tham chiếu (16 nghiệm)

*[Ảnh: fig_hinh3_doichieu.png — nhúng trực tiếp trong file Word]*

Kết quả cho thấy MOFDA nhận diện được một phần đáng kể mặt Pareto tham chiếu trong giới hạn số lần đánh giá FEM được sử dụng, kể cả về cấu trúc biến thiết kế (ưu tiên chọn cọc thép kích thước lớn, đúng như mặt Pareto tham chiếu). Đối với bài toán có không gian thiết kế rời rạc nhỏ như trường hợp này, việc liệt kê toàn bộ không gian là khả thi và được sử dụng như một bước kiểm chứng độc lập cho kết quả MOFDA.

### 4.3. Lựa chọn các phương án đại diện trên mặt Pareto

Mặt Pareto không xác định một nghiệm tối ưu duy nhất mà cung cấp các phương án thiết kế tương ứng với những mức độ đánh đổi khác nhau giữa khối lượng vật liệu cọc và chuyển vị ngang. Trong nghiên cứu này, ba phương án đại diện được lựa chọn theo ba xu hướng: ưu tiên giảm khối lượng, cân bằng giữa hai mục tiêu và ưu tiên kiểm soát chuyển vị. Việc lựa chọn này nhằm minh họa khả năng khai thác kết quả Pareto trong giai đoạn thiết kế sơ bộ, thay vì xác định một phương án tối ưu duy nhất cho công trình.

Phương án 1 là phương án có khối lượng vật liệu nhỏ nhất trên mặt Pareto, với CatIdx = 1, đường kính cọc thép D_thép = 1,100 m và chiều dày t_thép = 0,018 m; khối lượng vật liệu đạt 3.030,6 tấn và chuyển vị ngang lớn nhất là 13,88 mm. Phương án này thể hiện xu hướng ưu tiên giảm khối lượng vật liệu, đồng thời vẫn thỏa mãn ràng buộc chuyển vị được xét trong nghiên cứu.

Phương án 2 là phương án có mức cân bằng tương đối giữa hai mục tiêu, với CatIdx = 2, D_thép = 1,100 m và t_thép = 0,019 m; khối lượng vật liệu là 3.634,5 tấn và chuyển vị ngang lớn nhất là 12,86 mm. Đây là phương án trung gian được lựa chọn để minh họa sự đánh đổi giữa hai mục tiêu.

Phương án 3 là phương án có chuyển vị ngang nhỏ nhất trên mặt Pareto, với CatIdx = 3, D_thép = 1,100 m và t_thép = 0,020 m; khối lượng vật liệu là 4.298,3 tấn và chuyển vị ngang lớn nhất là 11,92 mm. Phương án này thể hiện xu hướng ưu tiên tăng độ cứng và kiểm soát chuyển vị ngang.

Ba phương án trên không được xem là ba phương án tối ưu độc lập mà là các điểm đại diện cho ba mức độ ưu tiên khác nhau trên cùng một mặt Pareto. Việc lựa chọn phương án cụ thể trong thực tế cần căn cứ vào yêu cầu kỹ thuật, mức độ ưu tiên về vật liệu và các điều kiện thiết kế bổ sung của dự án.

**Bảng 3.** Ba phương án đại diện trên mặt Pareto

| Phương án | Tiêu chí lựa chọn | CatIdx | D_thép (m) | t_thép (m) | f₁ (tấn) | f₂ (mm) |
|---|---|---:|---:|---:|---:|---:|
| PA1 | Khối lượng nhỏ nhất | 1 | 1,100 | 0,018 | 3.030,6 | 13,88 |
| PA2 | Cân bằng tương đối | 2 | 1,100 | 0,019 | 3.634,5 | 12,86 |
| PA3 | Chuyển vị nhỏ nhất | 3 | 1,100 | 0,020 | 4.298,3 | 11,92 |

Bảng 3 cho thấy khi chuyển từ PA1 sang PA3, khối lượng vật liệu tăng từ 3.030,6 lên 4.298,3 tấn, trong khi chuyển vị ngang giảm từ 13,88 xuống 11,92 mm. PA2 nằm giữa hai xu hướng này và thể hiện một mức đánh đổi trung gian. Như vậy, kết quả tối ưu đa mục tiêu không chỉ cung cấp một giá trị đơn lẻ mà còn cho phép người thiết kế xem xét nhiều phương án theo mức độ ưu tiên khác nhau.

### 4.4. Giới hạn của nghiên cứu

Nghiên cứu còn một số giới hạn: (i) ràng buộc sức chịu tải địa kỹ thuật theo TCVN 10304:2025 chưa được triển khai tính toán đầy đủ do thiếu số liệu chỉ tiêu cơ lý đất nền chi tiết; (ii) tổ hợp tải trọng bão chưa được đưa vào phạm vi đánh giá của đợt tính toán tối ưu; (iii) catalogue cọc ống thép chưa có sẵn nên biến thiết kế tương ứng được rời rạc hóa theo lưới giả định; (iv) mô hình chỉ xét phân tích tuyến tính tĩnh, chưa xét ứng xử phi tuyến hay tương tác đất–cọc chi tiết kiểu p–y. Các giới hạn này cần được xem xét khi đánh giá phạm vi áp dụng của kết quả tối ưu, và cần được bổ sung trước khi sử dụng kết quả số cho thiết kế thi công. Kết quả tối ưu không được sử dụng trực tiếp để thay thế các bước kiểm tra và thiết kế chính thức.

## 5. Kết luận

Bài báo đã ứng dụng thuật toán tối ưu đa mục tiêu MOFDA — một thuật toán đã được công bố, không phát triển hay điều chỉnh thêm trong nghiên cứu này — để hỗ trợ lựa chọn tiết diện hệ cọc của một cầu tàu container 100.000 DWT thực tế, kết hợp trực tiếp với mô hình phần tử hữu hạn SAP2000 qua OAPI, chạy song song trên nhiều tiến trình. Các kết luận chính gồm:

(1) Đã hình thành bài toán tối ưu rời rạc cho tiết diện hệ cọc (chỉ số catalogue cọc BTCT và kích thước cọc thép rời rạc hóa) của một cầu tàu container thực tế, với các ràng buộc kết cấu và chuyển vị được xây dựng theo các tiêu chuẩn Việt Nam áp dụng trong nghiên cứu (TCVN 7888:2014, TCVN 11820-5:2021, TCVN 9245:2012).

(2) Đã xây dựng được quy trình kết nối MOFDA–MATLAB–SAP2000, cho phép tự động đánh giá từng phương án bằng mô hình FEM; do không gian thiết kế của bài toán chỉ gồm 243 tổ hợp, toàn bộ không gian cũng được liệt kê để xây dựng mặt Pareto tham chiếu gồm 16 nghiệm.

(3) Mặt Pareto trong phạm vi các ràng buộc được triển khai cho thấy rõ sự đánh đổi giữa khối lượng vật liệu cọc (3.030,6–4.298,3 tấn) và chuyển vị ngang (11,9–13,9 mm) — đều thấp hơn nhiều giới hạn cho phép 71,7 mm theo TCVN 11820-5:2021.

(4) MOFDA nhận diện được 8 trong 16 nghiệm thuộc mặt Pareto tham chiếu, cho thấy khả năng ứng dụng thuật toán vào bài toán kết cấu thực tế trong phạm vi nghiên cứu, dù chưa bao phủ hết không gian nghiệm tối ưu với ngân sách đánh giá đã dùng.

(5) Mặt Pareto cung cấp cơ sở để lựa chọn phương án sơ bộ theo các mức độ ưu tiên khác nhau. Ba phương án đại diện được lựa chọn tương ứng với xu hướng giảm khối lượng, cân bằng hai mục tiêu và kiểm soát chuyển vị, qua đó minh họa khả năng sử dụng kết quả tối ưu đa mục tiêu trong hỗ trợ quyết định ở giai đoạn thiết kế sơ bộ. Trước khi áp dụng cho thiết kế chính thức, cần bổ sung các kiểm tra còn thiếu, đặc biệt là kiểm tra sức chịu tải địa kỹ thuật.

## Lời cảm ơn

*(nếu có)*

## TÀI LIỆU THAM KHẢO

[1] Truong V.H., Khatir S., Cuong-Le T. (2025), *Real-World Steel Frame Optimization Using a Hybrid Leader Selection-Based Multi-Objective Flow Direction Algorithm*, International Journal for Numerical Methods in Engineering, 126(15), e70098. https://doi.org/10.1002/nme.70098

[2] AMACCAO PILE (2014), *Catalogue và thông số kỹ thuật cọc bê tông ly tâm AMACCAO D300-D1200*, theo TCVN 7888:2014 và JIS A 5373:2016.

[3] Bộ Khoa học và Công nghệ (2021), *TCVN 11820-5:2021 — Công trình cảng biển – Yêu cầu thiết kế – Phần 5: Công trình bến*.

[4] Bộ Khoa học và Công nghệ, *TCVN 10304:2025 — Thiết kế móng cọc*.

[5] Bộ Khoa học và Công nghệ, *TCVN 9245:2012 — Cọc ống thép*.

---

Ngày nhận bài: xx/xx/2026
Ngày nhận bản sửa: xx/xx/2026
Ngày duyệt đăng: xx/xx/2026
