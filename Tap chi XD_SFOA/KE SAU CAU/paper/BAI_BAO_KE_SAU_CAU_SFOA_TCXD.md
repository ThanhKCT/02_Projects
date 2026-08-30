**Tối ưu hóa khối lượng bê tông tường chắn và bản đáy kè sau cầu bằng thuật toán tối ưu sao biển kết hợp SAP2000–MATLAB**

Concrete-volume optimization of the retaining wall and base slab of a bridge-abutment revetment using the starfish optimization algorithm coupled with SAP2000–MATLAB

**[Họ và tên tác giả]^1,\*^**

^1^ [Đơn vị công tác]

\* Email liên hệ: dangvanhai@hanyang.ac.kr

**TÓM TẮT**

Nghiên cứu áp dụng thuật toán tối ưu sao biển nguyên bản (Original Starfish Optimization Algorithm – SFOA) để tối thiểu hóa khối lượng bê tông kết cấu tường chắn và bản đáy của một công trình kè sau cầu thực tế, chịu đồng thời năm ràng buộc kỹ thuật theo tiêu chuẩn Việt Nam hiện hành. Mô hình phần tử hữu hạn SAP2000 được liên kết trực tiếp với MATLAB qua giao diện COM, cho phép SFOA cập nhật sáu biến chiều dày độc lập (bốn vùng tường, hai vùng bản đáy) và đánh giá phản hồi kết cấu bằng phân tích FEM trong từng bước lặp. Các ràng buộc gồm sức chịu tải cọc (TCVN 10304:2025), chuyển vị ngang đỉnh tường (TCVN 11820-5:2021), khả năng chịu cắt và bề rộng vết nứt (TCVN 4116:2023), và chọc thủng bản đáy theo từng cọc (TCVN 5574:2018). Kết quả tối ưu với quần thể 50 cá thể, 50 vòng lặp cho khối lượng bê tông 232,48 m³, giảm 51,66 m³ (18,18%) so với thiết kế hiện trạng (284,14 m³), đồng thời thỏa mãn toàn bộ năm ràng buộc kỹ thuật với biên an toàn dương. Đường cong hội tụ ổn định từ khoảng vòng lặp thứ 47. Kết quả cho thấy SFOA nguyên bản, kết hợp trực tiếp với FEM, có khả năng khai thác dư thừa khả năng chịu lực giữa các vùng kết cấu có nội lực khác nhau mà thiết kế theo kinh nghiệm khó nhận diện đầy đủ.

**Từ khóa:** Thuật toán tối ưu sao biển; tối ưu kết cấu; kè sau cầu; SAP2000–MATLAB; TCVN 10304:2025; TCVN 4116:2023.

**ABSTRACT**

This study applies the original Starfish Optimization Algorithm (SFOA) to minimize the concrete volume of the retaining wall and base slab of an actual bridge-abutment revetment structure, subject to five simultaneous technical constraints under current Vietnamese standards. A SAP2000 finite-element model is directly coupled with MATLAB through a COM interface, allowing SFOA to update six independent thickness variables (four wall zones, two base-slab zones) and evaluate the structural response through FEM analysis at every iteration. The constraints comprise pile bearing capacity (TCVN 10304:2025), lateral displacement at the wall top (TCVN 11820-5:2021), shear capacity and crack width (TCVN 4116:2023), and per-pile punching shear of the base slab (TCVN 5574:2018). With a population of 50 individuals over 50 iterations, the optimal solution reaches a concrete volume of 232.48 m³, a reduction of 51.66 m³ (18.18%) compared with the as-built design (284.14 m³), while satisfying all five constraints with a positive safety margin. The convergence curve stabilizes from around iteration 47. The results show that the original SFOA, directly coupled with FEM, can exploit the structural capacity reserve across zones with different internal-force demand that experience-based design often cannot fully identify.

**Keywords:** Starfish Optimization Algorithm; structural optimization; bridge-abutment revetment; SAP2000–MATLAB; TCVN 10304:2025; TCVN 4116:2023.

**1. ĐẶT VẤN ĐỀ**

Kè sau cầu là kết cấu chắn đất bố trí phía sau mố cầu, có chức năng giữ ổn định khối đất đắp và bảo vệ nền đường dẫn, thường gồm hệ tường chắn thẳng đứng liên kết với bản đáy đặt trên hệ cọc. Do tường và bản đáy thường được chia thành nhiều vùng có chiều dày khác nhau theo cao trình và vị trí để phù hợp với sự phân bố nội lực thực tế, khối lượng bê tông của toàn bộ kết cấu phụ thuộc đồng thời vào nhiều biến thiết kế độc lập. Thiết kế theo kinh nghiệm, dựa trên kiểm tra tuần tự từng tiết diện, khó xác định đồng thời tổ hợp chiều dày tối thiểu cho tất cả các vùng sao cho vẫn thỏa mãn mọi ràng buộc kỹ thuật, dẫn đến dư thừa khả năng chịu lực cục bộ và tăng chi phí vật liệu không cần thiết.

Các thuật toán tối ưu metaheuristic, kết hợp trực tiếp với mô hình phần tử hữu hạn (FEM) để đánh giá phản hồi kết cấu trong vòng lặp tối ưu, là hướng tiếp cận phù hợp cho lớp bài toán tối ưu kết cấu có tính phi tuyến cao, biến thiết kế rời rạc và nhiều ràng buộc kỹ thuật đồng thời mà phương pháp giải tích truyền thống khó xử lý [1]. Thuật toán tối ưu sao biển (Starfish Optimization Algorithm – SFOA) là một thuật toán metaheuristic được đề xuất gần đây, lấy cảm hứng từ hành vi săn mồi và tái sinh của sao biển, đã được đánh giá hiệu quả trên nhiều hàm benchmark và một số bài toán kỹ thuật [1]. Nghiên cứu này không khảo sát SFOA ở mức benchmark thuật toán mà tập trung vào khả năng ứng dụng của SFOA nguyên bản cho một bài toán tối ưu kết cấu công trình thực tế, kết hợp trực tiếp với phân tích FEM và chịu đồng thời nhiều ràng buộc theo tiêu chuẩn thiết kế hiện hành của Việt Nam.

Việc kết hợp SFOA với SAP2000 cho bài toán tối ưu khối lượng bê tông kết cấu kè chắn đất có nhiều vùng chiều dày độc lập, chịu ràng buộc đồng thời về sức chịu tải cọc, chuyển vị, khả năng chịu cắt, bề rộng vết nứt và chọc thủng theo các tiêu chuẩn thiết kế hiện hành — bao gồm hai tiêu chuẩn mới ban hành gần đây là TCVN 10304:2025 (thay thế TCVN 10304:2014) và TCVN 4116:2023 — chưa được khảo sát trong các nghiên cứu trước. Mục tiêu của nghiên cứu là: (1) xây dựng khung tính toán SAP2000–MATLAB–SFOA cho bài toán tối ưu đơn mục tiêu khối lượng bê tông của sáu vùng chiều dày kè sau cầu, chịu đồng thời năm ràng buộc kỹ thuật theo TCVN hiện hành; (2) áp dụng khung tính toán này cho một công trình kè sau cầu thực tế và đánh giá định lượng hiệu quả giảm khối lượng bê tông so với phương án thiết kế hiện trạng. Đóng góp chính của nghiên cứu là minh chứng thực nghiệm về khả năng ứng dụng SFOA nguyên bản, không cần điều chỉnh hay lai ghép thêm cơ chế nào, cho một bài toán tối ưu kết cấu chắn đất thực tế có nhiều ràng buộc TCVN đồng thời — trong đó phần lớn cấu hình khả dĩ (khoảng 1,7 tỷ tổ hợp rời rạc) vượt xa khả năng liệt kê toàn bộ (brute-force), buộc phải dùng công cụ tìm kiếm metaheuristic.

**2. MÔ HÌNH BÀI TOÁN VÀ PHƯƠNG PHÁP**

**2.1. Hệ kết cấu**

Đối tượng nghiên cứu là kè sau cầu với tường chắn đất cao 4,5m, được chia thành bốn vùng chiều dày độc lập theo cao trình và vị trí dọc tuyến (TUONGC30, TUONGM30, TUONGM43, TUONGM78), liên kết với bản đáy đặt trên hệ 142 cọc bê tông ly tâm ứng suất trước (đường kính D400 và D500), bản đáy được chia thành hai vùng chiều dày độc lập (DAY130, DAY60). Kết cấu tường và bản đáy được mô hình hóa bằng phần tử vỏ (shell) trong SAP2000, vật liệu bê tông mác M350; cọc được mô hình bằng phần tử thanh (frame), giữ nguyên kích thước và bố trí trong toàn bộ quá trình tối ưu (không phải biến thiết kế).

**2.2. Tải trọng và tổ hợp tải**

Mô hình chịu bốn trường hợp tải cơ bản: tĩnh tải bản thân (DEAD), trọng lượng khối đất đắp sau tường (Gdat), áp lực đất chủ động dạng lực tập trung và dạng phân bố (Pdat, ALD). Hai tổ hợp tải được xét: TH1 = DEAD + Gdat + Pdat + ALD (không có hoạt tải khai thác) và TH2 = TH1 + HH (có bổ sung hoạt tải chất xếp/khai thác trên mặt bãi). Tổ hợp bao BAO, lấy giá trị bao trùm (envelope) của TH1 và TH2, được dùng để trích xuất nội lực và chuyển vị cho toàn bộ quá trình kiểm tra ràng buộc.

**2.3. Biến thiết kế và hàm mục tiêu**

Sáu biến thiết kế liên tục $x = [x_1, x_2, ..., x_6]$ tương ứng chiều dày sáu vùng shell (TUONGC30, TUONGM30, TUONGM43, TUONGM78, DAY130, DAY60), được rời rạc hóa về bội số 0,01m trước khi ghi vào mô hình SAP2000 và trước khi tính hàm mục tiêu. Hàm mục tiêu là tổng khối lượng bê tông của sáu vùng, tính trực tiếp từ diện tích mặt bằng/mặt đứng đã xác định trước của từng vùng (không đọc từ SAP2000, vì diện tích hình học không đổi theo chiều dày):

$$V(x) = \sum_{i=1}^{6} A_i \cdot x_i \tag{1}$$

trong đó $A_i$ là diện tích vùng $i$ (m²) và $x_i$ là chiều dày vùng $i$ (m). Hàm thích nghi (fitness) dùng cho SFOA kết hợp hàm mục tiêu với hàm phạt tuyến tính theo tổng mức vi phạm ràng buộc $g(x)$ (mục 2.4), theo cách tiếp cận phạt tĩnh hệ số lớn thường dùng cho bài toán tối ưu ràng buộc [2]:

$$f(x) = V(x) + C \cdot g(x), \quad g(x) = \sum_{j=1}^{5} \max(0, \, v_j(x)) \tag{2}$$

với $v_j(x)$ là mức vi phạm của ràng buộc thứ $j$ (bằng 0 nếu thỏa mãn) và $C = 10^6$ là hệ số phạt.

**2.4. Ràng buộc kỹ thuật**

Bảng 1 tổng hợp năm ràng buộc kỹ thuật được kiểm tra tại mỗi lần đánh giá, cùng nguồn tiêu chuẩn và cách xử lý trong vòng lặp tối ưu.

Bảng 1. Ràng buộc kỹ thuật của bài toán tối ưu

| STT | Ràng buộc | Đại lượng kiểm tra | Điều kiện thỏa mãn | Nguồn/Ghi chú |
|---|---|---|---|---|
| 1 | Sức chịu tải cọc | $N_d$ từng cọc (từ phản lực đầu cọc) | $N_d \le [N_d]$ (78,76T với cọc D400; 112,44T với cọc D500) | TCVN 10304:2025 |
| 2 | Chuyển vị ngang đỉnh tường | $\max\|U_1\|$ tại các nút thuộc nhóm đỉnh tường | $\le \min(H/300,\,100\text{mm}) = 15\text{mm}$ | TCVN 11820-5:2021, Bảng 12 |
| 3 | Khả năng chịu cắt | Lực cắt $Q$ tại tiết diện cách mặt gối tựa một đoạn $h_0$ | $\gamma_{lc}\gamma_n Q \le \gamma_c\gamma_{b7}Q_b$ | TCVN 4116:2023, Điều 8.2.12 |
| 4 | Bề rộng vết nứt | $a_{cr}$ tính từ ứng suất cốt thép $\sigma_s$ | $a_{cr} \le \gamma_c \cdot 0,2\text{mm}$ | TCVN 4116:2023, Điều 9.2/9.1.1 |
| 5 | Chọc thủng bản đáy | Phản lực đầu cọc so với khả năng chống chọc thủng theo chu vi tháp chọc thủng | $\|N_d\| \le \gamma_c R_{bt} u h_0$ | TCVN 5574:2018 |

Ràng buộc 3 và 4 được kiểm tra riêng cho từng vùng trong số sáu vùng chiều dày, sử dụng nội lực bao (M, V) trích xuất từ SAP2000 tại các điểm cách mặt gối tựa (chân tường hoặc mép cọc) một khoảng lớn hơn hoặc bằng chiều cao làm việc $h_0$ của tiết diện, nhằm loại trừ các đỉnh nội lực cắt giả do hiệu ứng tập trung ứng suất cục bộ tại các nút biên cứng của phần tử vỏ — một hiện tượng đặc trưng của lưới phần tử hữu hạn, không phản ánh tiết diện nguy hiểm thực tế. Mô men uốn không áp dụng bộ lọc này vì giá trị lớn nhất tại chân công-xôn là cơ học thực. Ràng buộc 5 được kiểm tra riêng cho từng cọc trong số 142 cọc, sử dụng chiều cao làm việc $h_0$ của đúng vùng bản đáy mà cọc đó thuộc về.

**2.5. Khung tính toán SAP2000–MATLAB–SFOA**

Mỗi lần đánh giá một cá thể trong quần thể SFOA được thực hiện qua chuỗi bước: (i) MATLAB rời rạc hóa vector thiết kế về bội số 0,01m; (ii) ghi chiều dày của sáu vùng vào phiên SAP2000 đang mở thông qua hàm OAPI `SetShell_1`; (iii) chạy phân tích kết cấu (`RunAnalysis`); (iv) đọc phản lực đầu cọc, chuyển vị nút và nội lực vỏ theo tổ hợp bao BAO; (v) tính hàm mục tiêu, mức vi phạm từng ràng buộc và hàm thích nghi; (vi) trả giá trị thích nghi về cho SFOA để cập nhật quần thể. Toàn bộ quá trình tối ưu sử dụng một phiên SAP2000 duy nhất được giữ mở xuyên suốt, chỉ cập nhật thuộc tính tiết diện giữa các lần đánh giá, nhằm tránh chi phí mở/đóng file lặp lại.

**2.6. Thuật toán SFOA nguyên bản và thiết lập tính toán**

Nghiên cứu sử dụng đúng SFOA nguyên bản [1], gồm hai pha khám phá và khai thác dựa trên hành vi tìm mồi và tái sinh của sao biển, không bổ sung cơ chế nào khác. Do đây là nghiên cứu ứng dụng SFOA làm công cụ tối ưu thiết kế cho một công trình cụ thể — không nhằm so sánh hay phát triển thuật toán — quá trình tối ưu chỉ thực hiện một lần chạy độc lập duy nhất ($N_{run}=1$), không yêu cầu thống kê Best/Mean/STD qua nhiều lần chạy như các nghiên cứu đánh giá thuật toán. Quy mô quần thể $N_{pop}=50$ và số vòng lặp $Max_{it}=50$ (tổng 2.550 lần đánh giá) được xác định dựa trên một khảo sát hội tụ thực nghiệm riêng ở quy mô quần thể nhỏ hơn ($N_{pop}=15$, 40 vòng lặp): đường cong hội tụ ổn định rõ rệt từ khoảng vòng lặp thứ 26-30, chỉ cải thiện thêm 0,16% trong 14 vòng lặp cuối. Quy mô chính thức được chọn lớn hơn đáng kể so với ngưỡng hội tụ quan sát được để tạo biên an toàn.

**3. KẾT QUẢ VÀ THẢO LUẬN**

**3.1. Sự hội tụ của thuật toán**

Hình 1 thể hiện đường cong hội tụ (giá trị tốt nhất tích lũy theo vòng lặp) của lần chạy chính thức. Giá trị hàm mục tiêu giảm nhanh trong giai đoạn đầu, từ 261,97 m³ ở vòng lặp thứ nhất xuống 233,37 m³ ở vòng lặp thứ 13, sau đó tiếp tục cải thiện chậm dần và ổn định hoàn toàn từ vòng lặp thứ 47 đến vòng lặp thứ 50 (232,48 m³ không đổi trong bốn vòng lặp cuối). Đặc điểm hội tụ này khớp với xu hướng quan sát được ở khảo sát sơ bộ tại mục 2.6, cho thấy 50 vòng lặp là đủ để thuật toán đạt trạng thái ổn định với biên an toàn.

Hình 1. Đường cong hội tụ của SFOA (giá trị tốt nhất tích lũy theo vòng lặp)

**3.2. Nghiệm tối ưu**

Bảng 2 trình bày nghiệm tốt nhất tìm được so với phương án thiết kế hiện trạng (as-built) của công trình.

Bảng 2. So sánh nghiệm tối ưu với thiết kế hiện trạng

| Biến thiết kế | Thiết kế hiện trạng (m) | Nghiệm tốt nhất tìm được (m) |
|---|---|---|
| $x_1$ – TUONGC30 | 0,30 | 0,20 |
| $x_2$ – TUONGM30 | 0,30 | 0,22 |
| $x_3$ – TUONGM43 | 0,43 | 0,25 |
| $x_4$ – TUONGM78 | 0,78 | 0,40 |
| $x_5$ – DAY130 | 1,30 | 0,71 |
| $x_6$ – DAY60 | 0,60 | 0,58 |
| **Khối lượng bê tông $V$ (m³)** | **284,14** | **232,48 (min)** |
| **Chênh lệch $\Delta V$** | -- | **-51,66 m³ (-18,18%)** |

Nghiệm tối ưu giảm chiều dày ở cả sáu vùng so với hiện trạng, trong đó mức giảm lớn nhất tương đối rơi vào vùng bản đáy DAY130 (giảm từ 1,30m xuống 0,71m, tương ứng 45,4%) — vùng có diện tích nhỏ nhất (33,97 m²) nhưng chiều dày hiện trạng lớn nhất, cho thấy dư thừa khả năng chịu lực đáng kể ở vùng này trong thiết kế ban đầu. Ngược lại, vùng DAY60 (diện tích lớn nhất, 290,27 m²) chỉ giảm nhẹ từ 0,60m xuống 0,58m, phù hợp với việc vùng có diện tích lớn đóng góp tỷ trọng lớn vào hàm mục tiêu nên thuật toán thận trọng hơn khi giảm chiều dày ở đây.

**3.3. Kiểm tra ràng buộc kỹ thuật của nghiệm tối ưu**

Bảng 3 tổng hợp giá trị các đại lượng kiểm tra của nghiệm tối ưu so với giới hạn cho phép.

Bảng 3. Kiểm tra ràng buộc của nghiệm tối ưu

| Ràng buộc | Giá trị/tỷ số | Giới hạn | Kết luận |
|---|---|---|---|
| Sức chịu tải cọc (tỷ số $N_d/[N_d]$ lớn nhất) | 0,375 | $\le 1,0$ | Thỏa mãn |
| Chuyển vị ngang đỉnh tường | 4,06 mm | $\le 15$ mm | Thỏa mãn |
| Khả năng chịu cắt | Không vi phạm | -- | Thỏa mãn |
| Bề rộng vết nứt | Không vi phạm | $\le 0,2$ mm | Thỏa mãn |
| Chọc thủng bản đáy | Không vi phạm | -- | Thỏa mãn |

Toàn bộ năm ràng buộc đều thỏa mãn với biên an toàn dương (hàm phạt bằng 0), trong đó ràng buộc sức chịu tải cọc có biên an toàn lớn nhất (tỷ số sử dụng chỉ 37,5%) và ràng buộc chuyển vị ngang có biên an toàn tương đối (4,06mm so với giới hạn 15mm, đạt 27,1% giới hạn) — hai ràng buộc này không phải là ràng buộc chi phối (binding constraint) đối với nghiệm tối ưu tìm được, cho thấy dư địa giảm khối lượng bê tông trong bài toán này chủ yếu bị giới hạn bởi ràng buộc chịu cắt và bề rộng vết nứt tại các vùng chiều dày mỏng nhất.

**3.4. Hiệu quả tính toán**

Toàn bộ quá trình tối ưu thực hiện 2.550 lần đánh giá (bằng $N_{pop} \times (Max_{it}+1) = 50 \times 51$), mỗi lần đánh giá bao gồm một lần cập nhật thuộc tính tiết diện và một lần giải FEM đầy đủ trong SAP2000. Thời gian tính toán thực đo trung bình khoảng 15,4 giây cho mỗi lần đánh giá, với kiến trúc tuần tự sử dụng một phiên SAP2000 duy nhất (không song song hóa). Tổng thời gian tính toán của toàn bộ quá trình tối ưu xấp xỉ 10 giờ 55 phút.

**3.5. Hạn chế**

Nghiên cứu chỉ thực hiện một lần chạy độc lập ($N_{run}=1$), phù hợp với mục tiêu ứng dụng SFOA làm công cụ thiết kế cho một công trình cụ thể thay vì đánh giá độ ổn định thống kê của thuật toán; đường cong hội tụ ổn định rõ rệt (mục 3.1) được dùng làm minh chứng thay thế cho thống kê đa lần chạy. Các ràng buộc chịu cắt và bề rộng vết nứt trong vòng lặp tối ưu dựa trên tỷ lệ cốt thép ước tính từ mô men yêu cầu ($A_{s,req}$), chưa hậu kiểm theo bản vẽ bố trí cốt thép cấu tạo cụ thể; nghiệm được đề xuất cần được hậu kiểm chi tiết trước khi triển khai thi công.

**4. KẾT LUẬN**

Nghiên cứu đã xây dựng và áp dụng thành công một khung tính toán kết hợp SAP2000, MATLAB và thuật toán tối ưu sao biển nguyên bản (SFOA) cho bài toán tối ưu khối lượng bê tông kết cấu tường chắn và bản đáy của một công trình kè sau cầu thực tế, với sáu biến thiết kế và năm ràng buộc kỹ thuật theo tiêu chuẩn Việt Nam hiện hành được kiểm tra đồng thời trong vòng lặp tối ưu, bao gồm hai tiêu chuẩn mới ban hành gần đây (TCVN 10304:2025 và TCVN 4116:2023). Kết quả tối ưu đạt khối lượng bê tông 232,48 m³, giảm 51,66 m³ (18,18%) so với thiết kế hiện trạng, đồng thời thỏa mãn toàn bộ năm ràng buộc kỹ thuật với biên an toàn dương; đường cong hội tụ ổn định từ vòng lặp thứ 47 trên tổng số 50 vòng lặp, cho thấy quy mô tính toán đã chọn là phù hợp.

Kết quả cho thấy SFOA nguyên bản, không cần điều chỉnh hay bổ sung cơ chế đặc thù, có khả năng khai thác hiệu quả dư thừa khả năng chịu lực phân bố không đồng đều giữa các vùng kết cấu có nội lực khác nhau — điều mà thiết kế theo kinh nghiệm, kiểm tra tuần tự từng tiết diện, khó nhận diện đầy đủ trong một không gian thiết kế có quy mô tổ hợp rời rạc vượt xa khả năng liệt kê toàn bộ. Hướng phát triển tiếp theo bao gồm hậu kiểm chi tiết cấu tạo cốt thép cho nghiệm được đề xuất trước khi áp dụng vào thiết kế thi công, cũng như mở rộng bài toán sang hướng tối ưu đa mục tiêu (kết hợp thêm tiêu chí chi phí thi công hoặc độ nhạy ràng buộc) và xem xét kiến trúc tính toán song song để tăng quy mô khảo sát trong các nghiên cứu tiếp theo.

**TÀI LIỆU THAM KHẢO**

[1] Zhong, C., Li, G., Meng, Z., Li, H., Yildiz, A.R., Mirjalili, S. Starfish optimization algorithm (SFOA): a bio-inspired metaheuristic algorithm for global optimization compared with 100 optimizers. Neural Computing and Applications, vol. 37, pp. 3641-3683, 2025, doi: 10.1007/s00521-024-10694-1.

[2] Deb, K. An efficient constraint handling method for genetic algorithms. Computer Methods in Applied Mechanics and Engineering, vol. 186, no. 2-4, pp. 311-338, 2000, doi: 10.1016/S0045-7825(99)00389-8.

[3] TCVN 10304:2025. Thiết kế móng cọc. Bộ Xây dựng, Việt Nam, 2025.

[4] TCVN 11820-5:2021. Công trình cảng biển - Yêu cầu thiết kế - Phần 5: Công trình bến. Bộ Khoa học và Công nghệ, Việt Nam, 2021.

[5] TCVN 4116:2023. Công trình thủy lợi - Kết cấu bê tông và bê tông cốt thép thủy công - Yêu cầu thiết kế. Bộ Khoa học và Công nghệ, Việt Nam, 2023.

[6] TCVN 5574:2018. Thiết kế kết cấu bê tông và bê tông cốt thép. Bộ Khoa học và Công nghệ, Việt Nam, 2018.
