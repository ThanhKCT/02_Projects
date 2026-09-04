**TỐI ƯU KHỐI LƯỢNG BÊ TÔNG KẾT CẤU KÈ SAU CẦU BẰNG THUẬT TOÁN TỐI ƯU SAO BIỂN KẾT HỢP SAP2000–MATLAB**

Concrete Quantity Optimization of the Bridge-Abutment Revetment Structure Using the Starfish Optimization Algorithm Coupled with SAP2000–MATLAB

**[Họ và tên tác giả]^1,\*^**

^1^ [Đơn vị công tác]

\* Email liên hệ: dangvanhai@hanyang.ac.kr

**TÓM TẮT**

Nghiên cứu áp dụng thuật toán tối ưu sao biển nguyên bản (Original Starfish Optimization Algorithm – SFOA) để tối thiểu hóa thể tích bê tông kết cấu tường chắn và bản đáy của một công trình kè sau cầu thực tế, chịu đồng thời năm nhóm ràng buộc kỹ thuật theo tiêu chuẩn Việt Nam hiện hành. Mô hình phần tử hữu hạn SAP2000 được liên kết trực tiếp với MATLAB qua giao diện COM, cho phép SFOA cập nhật sáu biến chiều dày độc lập (bốn vùng tường, hai vùng bản đáy) và đánh giá phản hồi kết cấu bằng phân tích FEM trong từng bước lặp. Các nhóm ràng buộc gồm sức chịu tải cọc (TCVN 10304:2025), chuyển vị ngang đỉnh tường (TCVN 11820-5:2021), khả năng chịu cắt và bề rộng vết nứt (TCVN 4116:2023), và chọc thủng bản đáy theo từng cọc (TCVN 5574:2018). Kết quả tối ưu với quần thể 50 cá thể, 50 vòng lặp cho thể tích bê tông 232,48 m³, giảm thể tích bê tông 51,66 m³ (18,18%) so với thiết kế hiện trạng (284,14 m³), đồng thời thỏa mãn toàn bộ năm nhóm ràng buộc kỹ thuật. Đường cong hội tụ ổn định từ khoảng vòng lặp thứ 47. Kết quả cho thấy phương pháp tối ưu có khả năng phân bổ lại chiều dày giữa các vùng kết cấu theo mức độ yêu cầu chịu lực, qua đó giảm thể tích bê tông so với phương án hiện trạng.

**Từ khóa:** Thuật toán tối ưu sao biển; tối ưu kết cấu; kè sau cầu; SAP2000–MATLAB; TCVN 10304:2025; TCVN 4116:2023.

**ABSTRACT**

This study applies the original Starfish Optimization Algorithm (SFOA) to minimize the concrete volume of the retaining wall and base slab of an actual bridge-abutment revetment structure, subject to five groups of simultaneous technical constraints under current Vietnamese standards. A SAP2000 finite-element model is directly coupled with MATLAB through a COM interface, allowing SFOA to update six independent thickness variables (four wall zones, two base-slab zones) and evaluate the structural response through FEM analysis at every iteration. The constraint groups comprise pile bearing capacity (TCVN 10304:2025), lateral displacement at the wall top (TCVN 11820-5:2021), shear capacity and crack width (TCVN 4116:2023), and per-pile punching shear of the base slab (TCVN 5574:2018). With a population of 50 individuals over 50 iterations, the optimal solution reaches a concrete volume of 232.48 m³, a reduction of 51.66 m³ (18.18%) compared with the as-built design (284.14 m³), while satisfying all five groups of constraints. The convergence curve stabilizes from around iteration 47. The results indicate that the proposed optimization approach can reallocate the thickness of the structural zones according to their structural demand, thereby reducing the concrete volume relative to the as-built design.

**Keywords:** Starfish Optimization Algorithm; structural optimization; bridge-abutment revetment; SAP2000–MATLAB; TCVN 10304:2025; TCVN 4116:2023.

**1. ĐẶT VẤN ĐỀ**

Kè sau cầu, trong nghiên cứu này, là kết cấu chắn đất phía sau công trình bến bệ cọc cao, bố trí tại khu vực tiếp giáp giữa công trình bến và bãi sau kè, có chức năng giữ ổn định khối đất đắp và bảo vệ mặt bãi sau bến. Do tường chắn và bản đáy thường được chia thành nhiều vùng chiều dày khác nhau theo cao trình và vị trí để phù hợp với sự phân bố nội lực thực tế, thể tích bê tông của kết cấu phụ thuộc đồng thời vào nhiều biến thiết kế độc lập. Thiết kế theo kinh nghiệm, dựa trên kiểm tra tuần tự từng tiết diện, khó xác định đồng thời tổ hợp chiều dày tối thiểu cho tất cả các vùng sao cho vẫn thỏa mãn mọi ràng buộc kỹ thuật, dẫn đến dư thừa khả năng chịu lực cục bộ và làm tăng thể tích bê tông sử dụng không cần thiết.

Các thuật toán tối ưu metaheuristic, kết hợp trực tiếp với mô hình phần tử hữu hạn (FEM) để đánh giá phản hồi kết cấu trong vòng lặp tối ưu, phù hợp với lớp bài toán tối ưu kết cấu có tính phi tuyến cao, biến thiết kế rời rạc và nhiều ràng buộc kỹ thuật đồng thời mà phương pháp giải tích truyền thống khó xử lý [1]. Thuật toán tối ưu sao biển (Starfish Optimization Algorithm – SFOA) là thuật toán metaheuristic được đề xuất gần đây, lấy cảm hứng từ hành vi săn mồi và tái sinh của sao biển, đã được đánh giá hiệu quả trên nhiều hàm kiểm thử chuẩn và một số bài toán kỹ thuật [1]. Nghiên cứu này không đánh giá SFOA trên các hàm kiểm thử chuẩn mà tập trung vào khả năng ứng dụng SFOA nguyên bản cho bài toán tối ưu kết cấu thực tế, kết hợp trực tiếp với FEM và các ràng buộc theo tiêu chuẩn Việt Nam hiện hành.

Việc kết hợp SFOA với SAP2000 cho bài toán tối ưu thể tích bê tông kết cấu kè sau cầu, chịu đồng thời năm nhóm ràng buộc kỹ thuật theo hệ tiêu chuẩn phù hợp với công trình bến bệ cọc cao — bao gồm hai tiêu chuẩn mới ban hành gần đây (TCVN 10304:2025 và TCVN 4116:2023) — trong phạm vi nghiên cứu được khảo sát, chưa được xem xét. Mục tiêu của nghiên cứu là: (1) xây dựng khung tính toán SAP2000–MATLAB–SFOA cho bài toán tối ưu thể tích bê tông của sáu vùng chiều dày kè sau cầu, chịu đồng thời năm nhóm ràng buộc kỹ thuật theo hệ tiêu chuẩn được lựa chọn; (2) áp dụng khung tính toán này cho một công trình thực tế và đánh giá mức giảm thể tích bê tông so với hiện trạng. Đóng góp chính của nghiên cứu là minh chứng qua một công trình thực tế về khả năng ứng dụng SFOA nguyên bản, không cần điều chỉnh hay lai ghép thêm cơ chế nào, cho một bài toán tối ưu kết cấu chắn đất thực tế có nhiều nhóm ràng buộc kỹ thuật đồng thời. Với không gian thiết kế rời rạc có quy mô khoảng 1,7 tỷ tổ hợp, việc khảo sát toàn bộ bằng phương pháp vét cạn là không khả thi về mặt tính toán; do đó cần sử dụng một phương pháp tìm kiếm phù hợp.

**2. MÔ HÌNH BÀI TOÁN VÀ PHƯƠNG PHÁP**

**2.1. Hệ kết cấu**

Đối tượng nghiên cứu, như mô tả ở Mục 1, có tường chắn cao 4,5 m, chia thành bốn vùng chiều dày độc lập theo cao trình và vị trí dọc tuyến (TUONGC30, TUONGM30, TUONGM43, TUONGM78), liên kết với bản đáy đặt trên hệ 142 cọc bê tông ly tâm ứng suất trước (đường kính D400 và D500), bản đáy được chia thành hai vùng chiều dày độc lập (DAY130, DAY60). Loại kết cấu này được thiết kế theo TCVN 11820-5:2021 – tiêu chuẩn công trình bến, trong đó có các yêu cầu riêng đối với bến bệ cọc cao và kết cấu chắn đất phía sau bến, không chỉ là nguồn cho riêng giới hạn chuyển vị. Kết cấu tường và bản đáy được mô hình hóa bằng phần tử vỏ (shell) trong SAP2000, vật liệu bê tông mác M350; cọc được mô hình bằng phần tử thanh (frame), giữ nguyên kích thước và bố trí trong toàn bộ quá trình tối ưu (không phải biến thiết kế).

**2.2. Tải trọng và tổ hợp tải**

Mô hình chịu bốn trường hợp tải cơ bản: tĩnh tải bản thân (DEAD), trọng lượng khối đất đắp sau tường (Gdat), áp lực đất chủ động dạng lực tập trung và dạng phân bố (Pdat, ALD). Hai tổ hợp tải được xét: TH1 = DEAD + Gdat + Pdat + ALD (không có hoạt tải khai thác) và TH2 = TH1 + HH (có bổ sung hoạt tải chất xếp/khai thác trên mặt bãi). Tổ hợp bao BAO, lấy giá trị bao trùm của TH1 và TH2, được dùng để trích xuất nội lực và chuyển vị cho toàn bộ quá trình kiểm tra ràng buộc.

**2.3. Biến thiết kế và hàm mục tiêu**

Sáu biến thiết kế liên tục $x = [x_1, x_2, ..., x_6]$ tương ứng chiều dày sáu vùng shell (TUONGC30, TUONGM30, TUONGM43, TUONGM78, DAY130, DAY60), được rời rạc hóa về bội số 0,01m trước khi ghi vào mô hình SAP2000 và trước khi tính hàm mục tiêu. Hàm mục tiêu là tổng thể tích bê tông của sáu vùng, tính trực tiếp từ diện tích mặt bằng/mặt đứng đã xác định trước của từng vùng (không đọc từ SAP2000, vì diện tích hình học không đổi theo chiều dày):

$$V(x) = \sum_{i=1}^{6} A_i \cdot x_i \tag{1}$$

trong đó $A_i$ là diện tích vùng $i$ (m²), $x_i$ là chiều dày vùng $i$ (m) và $V(x)$ là thể tích bê tông (m³). Hàm thích nghi dùng cho SFOA kết hợp hàm mục tiêu với hàm phạt tuyến tính theo tổng mức vi phạm ràng buộc $g(x)$ (mục 2.4) [2]:

$$f(x) = V(x) + C \cdot g(x), \quad g(x) = \sum_{j=1}^{5} \max(0, \, v_j(x)) \tag{2}$$

với $v_j(x)$ là mức vi phạm không thứ nguyên của nhóm ràng buộc thứ $j$, xác định theo tỷ số giữa đại lượng kiểm tra $R_j(x)$ và giới hạn cho phép $R_{j,\mathrm{lim}}$:

$$v_j(x) = \max\left(0, \, \frac{R_j(x)}{R_{j,\mathrm{lim}}} - 1\right) \tag{3}$$

($v_j(x) = 0$ nếu ràng buộc được thỏa mãn). Trong nghiên cứu này, hệ số phạt được chọn bằng $C = 10^6$ nhằm ưu tiên các nghiệm thỏa mãn ràng buộc.

**2.4. Ràng buộc kỹ thuật**

Bảng 1 tổng hợp năm nhóm ràng buộc kỹ thuật được kiểm tra tại mỗi lần đánh giá, cùng nguồn tiêu chuẩn và cách xử lý trong vòng lặp tối ưu.

Bảng 1. Năm nhóm ràng buộc kỹ thuật của bài toán tối ưu

| STT | Ràng buộc | Đại lượng kiểm tra | Điều kiện thỏa mãn | Nguồn/Ghi chú |
|---|---|---|---|---|
| 1 | Sức chịu tải cọc | $N_d$ từng cọc (từ phản lực đầu cọc) | $N_d \le [N_d]$ (78,76T với cọc D400; 112,44T với cọc D500) | TCVN 10304:2025 |
| 2 | Chuyển vị ngang đỉnh tường | $\max\|U_1\|$ tại các nút thuộc nhóm đỉnh tường | $\le \min(H/300,\,100\text{mm}) = 15\text{mm}$ | TCVN 11820-5:2021, Bảng 12 |
| 3 | Khả năng chịu cắt | Lực cắt $Q$ tại tiết diện cách mặt gối tựa một đoạn $h_0$ | $\gamma_{lc}\gamma_n Q \le \gamma_c\gamma_{b7}Q_b$ | TCVN 4116:2023, Điều 8.2.12 |
| 4 | Bề rộng vết nứt | $a_{cr}$ tính từ ứng suất cốt thép $\sigma_s$ | $a_{cr} \le \gamma_c \cdot 0,2\text{mm}$ | TCVN 4116:2023, Điều 9.2/9.1.1 |
| 5 | Chọc thủng bản đáy | Phản lực đầu cọc so với khả năng chống chọc thủng theo chu vi tháp chọc thủng | $\|N_d\| \le \gamma_c R_{bt} u h_0$ | TCVN 5574:2018 |

Theo TCVN 11820-5:2021, Bảng 12, giới hạn chuyển vị ngang là $U_{lim} = \min(H/300,\,100\text{mm})$; với $H = 4,5$ m, giới hạn sử dụng là 15 mm. Nhóm ràng buộc 3 và 4 được kiểm tra riêng cho từng vùng, sử dụng nội lực bao (M, V) trích xuất từ SAP2000 theo tổ hợp bao BAO. Đối với kiểm tra chịu cắt, nội lực được trích xuất tại các vị trí cách mặt gối tựa hoặc mép cọc một khoảng không nhỏ hơn $h_0$, nhằm hạn chế đỉnh nội lực cục bộ tại biên phần tử vỏ. Bộ lọc này chỉ áp dụng cho lực cắt; mô men uốn tại chân công-xôn được giữ nguyên vì phản ánh cơ học thực. Kiểm tra chọc thủng được thực hiện riêng cho từng cọc, với $h_0$ của vùng bản đáy tương ứng.

**2.5. Khung tính toán SAP2000–MATLAB–SFOA**

Mỗi cá thể được đánh giá qua các bước: (1) rời rạc hóa biến thiết kế về bội số 0,01m; (2) cập nhật chiều dày các vùng shell trong SAP2000 qua hàm OAPI `SetShell_1`; (3) chạy phân tích FEM (`RunAnalysis`); (4) trích xuất phản lực đầu cọc, chuyển vị và nội lực vỏ theo tổ hợp bao BAO; (5) kiểm tra các nhóm ràng buộc, tính hàm mục tiêu và hàm thích nghi; (6) trả kết quả về SFOA để cập nhật quần thể. Toàn bộ quá trình dùng một phiên SAP2000 duy nhất, giữ mở xuyên suốt, chỉ cập nhật tiết diện giữa các lần đánh giá.

**2.6. Thuật toán SFOA nguyên bản và thiết lập tính toán**

Nghiên cứu sử dụng đúng SFOA nguyên bản [1], gồm hai pha khám phá và khai thác dựa trên hành vi tìm mồi và tái sinh của sao biển, không bổ sung cơ chế nào khác. Do mục tiêu là đánh giá khả năng ứng dụng SFOA cho một bài toán thiết kế cụ thể — không nhằm so sánh hay phát triển thuật toán — quá trình tối ưu chỉ thực hiện một lần chạy duy nhất ($N_{run}=1$), không yêu cầu thống kê giá trị tốt nhất, giá trị trung bình và độ lệch chuẩn qua nhiều lần chạy như các nghiên cứu đánh giá thuật toán. Khảo sát sơ bộ với $N_{pop}=15$, 40 vòng lặp cho thấy nghiệm cải thiện rất ít ở các vòng lặp cuối; do đó nghiên cứu chọn $N_{pop}=50$, $Maxit=50$ (2.550 lần đánh giá) cho lần chạy chính thức, lớn hơn đáng kể ngưỡng hội tụ quan sát được để tạo biên an toàn.

**3. KẾT QUẢ VÀ THẢO LUẬN**

**3.1. Sự hội tụ của thuật toán**

Hình 1 thể hiện đường cong hội tụ (giá trị tốt nhất tích lũy theo vòng lặp) của lần chạy chính thức. Giá trị hàm mục tiêu giảm nhanh trong giai đoạn đầu, từ 261,97 m³ ở vòng lặp thứ nhất xuống 233,37 m³ ở vòng lặp thứ 13, sau đó cải thiện chậm dần và không đổi từ vòng lặp 47 đến 50 (232,48 m³ trong bốn vòng lặp cuối), cho thấy nghiệm thu được đã ổn định ở giai đoạn cuối của lần chạy.

Hình 1. Đường cong hội tụ của SFOA (giá trị tốt nhất tích lũy theo vòng lặp)

**3.2. Nghiệm tối ưu**

Bảng 2 trình bày nghiệm tối ưu thu được so với phương án thiết kế hiện trạng của công trình.

Bảng 2. So sánh nghiệm tối ưu với thiết kế hiện trạng

| Biến thiết kế | Thiết kế hiện trạng (m) | Nghiệm tối ưu thu được (m) |
|---|---|---|
| $x_1$ – TUONGC30 | 0,30 | 0,20 |
| $x_2$ – TUONGM30 | 0,30 | 0,22 |
| $x_3$ – TUONGM43 | 0,43 | 0,25 |
| $x_4$ – TUONGM78 | 0,78 | 0,40 |
| $x_5$ – DAY130 | 1,30 | 0,71 |
| $x_6$ – DAY60 | 0,60 | 0,58 |
| **Thể tích bê tông $V$ (m³)** | **284,14** | **232,48 (nhỏ nhất)** |
| **Chênh lệch $\Delta V$** | -- | **-51,66 m³ (-18,18%)** |

Nghiệm tối ưu giảm chiều dày ở cả sáu vùng so với hiện trạng, trong đó mức giảm lớn nhất tương đối rơi vào vùng bản đáy DAY130 (từ 1,30 m xuống 0,71 m, tương ứng 45,4%) — vùng có diện tích nhỏ nhất (33,97 m²) nhưng chiều dày hiện trạng lớn nhất, cho thấy chiều dày vùng này có thể giảm đáng kể mà vẫn thỏa mãn các ràng buộc kỹ thuật. Ngược lại, DAY60 (diện tích lớn nhất, 290,27 m²) chỉ giảm từ 0,60 m xuống 0,58 m, ở mức hạn chế hơn.

**3.3. Kiểm tra ràng buộc kỹ thuật của nghiệm tối ưu**

Bảng 3 tổng hợp giá trị các đại lượng kiểm tra của nghiệm tối ưu so với giới hạn cho phép.

Bảng 3. Kiểm tra ràng buộc của nghiệm tối ưu

| Ràng buộc | Giá trị/tỷ số | Giới hạn | Kết luận |
|---|---|---|---|
| Sức chịu tải cọc (tỷ số $N_d/[N_d]$ lớn nhất) | 0,375 | $\le 1,0$ | Thỏa mãn |
| Chuyển vị ngang đỉnh tường | 4,06 mm | $\le 15$ mm | Thỏa mãn |
| Khả năng chịu cắt | Không vi phạm | -- | Thỏa mãn |
| Bề rộng vết nứt | Không vi phạm | $\le 0,2$ mm | Thỏa mãn |
| Chọc thủng bản đáy (hậu kiểm EN 1992-1-1, 142 cọc) | 0,43 | $\le 1,0$ | Thỏa mãn |

Toàn bộ năm nhóm ràng buộc kỹ thuật đều được thỏa mãn (hàm phạt bằng 0). Đối với sức chịu tải cọc, tỷ số sử dụng lớn nhất là 37,5%; chuyển vị ngang đỉnh tường đạt 27,1% giới hạn (4,06 mm so với 15 mm); chọc thủng (mục 3.5) đạt tối đa 43%. Các điều kiện chịu cắt và bề rộng vết nứt vẫn cần được kiểm soát khi tiếp tục giảm chiều dày các vùng kết cấu.

**3.4. Hiệu quả tính toán**

Tổng số lần đánh giá là 2.550, gồm 50 đánh giá cho quần thể khởi tạo và 50 đánh giá mỗi vòng lặp. Thời gian trung bình khoảng 15,4 giây/lần, tổng thời gian khoảng 10 giờ 55 phút.

**3.5. Hạn chế**

Nghiên cứu chỉ thực hiện một lần chạy duy nhất ($N_{run}=1$), phù hợp với mục tiêu dùng SFOA làm công cụ thiết kế cho một công trình cụ thể thay vì đánh giá độ ổn định thống kê; đường cong hội tụ (mục 3.1) đánh giá mức độ ổn định của nghiệm. Các ràng buộc chịu cắt và bề rộng vết nứt dựa trên tỷ lệ cốt thép ước tính từ mô men yêu cầu ($A_{s,req}$), chưa hậu kiểm theo bản vẽ cốt thép cấu tạo. Ràng buộc chọc thủng trong vòng lặp tối ưu được tính theo công thức đang sử dụng trong mô hình (TCVN 5574:2018). Nghiệm tối ưu sau đó được hậu kiểm bổ sung, độc lập với vòng lặp, theo EN 1992-1-1 [7] (Điều 6.4.3–6.4.4) cho toàn bộ 142 cọc, phân loại theo vị trí trong/biên/góc bản đáy (86/52/4 cọc, $\beta=1{,}15/1{,}40/1{,}50$): không có cọc nào vi phạm, tỷ số sử dụng lớn nhất 0,43 tại một cọc biên. Nghiệm tối ưu được xem là phương án đề xuất ở cấp độ tối ưu chiều dày; trước khi thi công cần hoàn thiện chi tiết cốt thép theo hồ sơ thiết kế.

**4. KẾT LUẬN**

Nghiên cứu đã xây dựng và áp dụng khung tính toán kết hợp SAP2000–MATLAB và SFOA nguyên bản để tối ưu sáu biến chiều dày của tường chắn và bản đáy kè sau cầu, đồng thời kiểm tra năm nhóm ràng buộc kỹ thuật theo hệ tiêu chuẩn phù hợp với công trình bến bệ cọc cao, bao gồm hai tiêu chuẩn mới ban hành gần đây (TCVN 10304:2025 và TCVN 4116:2023).

Đối với công trình khảo sát, nghiệm tối ưu cho thể tích bê tông 232,48 m³, giảm 51,66 m³, tương đương 18,18% so với phương án hiện trạng. Nghiệm thu được thỏa mãn toàn bộ các ràng buộc kiểm tra và ổn định ở các vòng lặp cuối của quá trình tối ưu.

Kết quả hiện mới dừng ở tối ưu chiều dày và kiểm tra ràng buộc trong mô hình tính toán; hậu kiểm bổ sung, có phân loại vị trí trong/biên/góc cho từng cọc, xác nhận nghiệm tối ưu cũng thỏa mãn chọc thủng theo EN 1992-1-1 [7] (tỷ số sử dụng lớn nhất 0,43). Việc hoàn thiện chi tiết cốt thép cần được thực hiện ở bước thiết kế tiếp theo trước khi áp dụng cho thiết kế thi công.

**TÀI LIỆU THAM KHẢO**

[1] Zhong, C., Li, G., Meng, Z., Li, H., Yildiz, A.R., Mirjalili, S. Starfish optimization algorithm (SFOA): a bio-inspired metaheuristic algorithm for global optimization compared with 100 optimizers. Neural Computing and Applications, vol. 37, pp. 3641-3683, 2025, doi: 10.1007/s00521-024-10694-1.

[2] Deb, K. An efficient constraint handling method for genetic algorithms. Computer Methods in Applied Mechanics and Engineering, vol. 186, no. 2-4, pp. 311-338, 2000, doi: 10.1016/S0045-7825(99)00389-8.

[3] TCVN 10304:2025. Thiết kế móng cọc. Bộ Xây dựng, Việt Nam, 2025.

[4] TCVN 11820-5:2021. Công trình cảng biển - Yêu cầu thiết kế - Phần 5: Công trình bến. Bộ Khoa học và Công nghệ, Việt Nam, 2021.

[5] TCVN 4116:2023. Công trình thủy lợi - Kết cấu bê tông và bê tông cốt thép thủy công - Yêu cầu thiết kế. Bộ Khoa học và Công nghệ, Việt Nam, 2023.

[6] TCVN 5574:2018. Thiết kế kết cấu bê tông và bê tông cốt thép. Bộ Khoa học và Công nghệ, Việt Nam, 2018.

[7] EN 1992-1-1:2004+A1:2014. Eurocode 2: Design of concrete structures - Part 1-1: General rules and rules for buildings. European Committee for Standardization (CEN), Brussels, 2014.
