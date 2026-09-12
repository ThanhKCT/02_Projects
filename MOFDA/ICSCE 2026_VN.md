TỐI ƯU ĐA MỤC TIÊU TIẾT DIỆN HỆ CỌC CẦU TÀU CONTAINER 100.000 DWT: ĐỐI SÁNH THUẬT TOÁN MOFDA VÀ MOSFOA

Thanh Do-Quang¹,\*, T. Vu-Huu¹, Thanh Cuong-Le²

¹ Khoa Công trình, Trường Đại học Hàng hải Việt Nam, Hải Phòng, Việt Nam
² Khoa Xây dựng và Điện, Trường Đại học Mở Thành phố Hồ Chí Minh, Việt Nam
\*Tác giả liên hệ: thanhdq.ctt@viamru.edu.vn

**Tóm tắt.** Cầu tàu container trên nền cọc có khối lượng vật liệu phần cọc lớn, nên tiết diện cọc có thể được lựa chọn bằng tối ưu đa mục tiêu có ràng buộc thay vì chỉ dựa kinh nghiệm. Nghiên cứu xây dựng bài toán tối ưu đa mục tiêu rời rạc cho tiết diện cọc bê tông ly tâm dự ứng lực và cọc ống thép của một cầu tàu container 100.000 DWT thực tế (4.080 tổ hợp), với ràng buộc kết cấu, ràng buộc địa kỹ thuật theo TCVN 10304:2025 và chống nhổ cọc. Khối lượng vật liệu và chuyển vị ngang lớn nhất được đánh giá bằng mô hình SAP2000 kết nối MATLAB qua OAPI. Hai thuật toán tối ưu đa mục tiêu do cùng nhóm nghiên cứu công bố trước đây, MOFDA (hướng dòng chảy, chọn thủ lĩnh lai) và MOSFOA (sao biển, chạy bản thực nghiệm E-MOSFOA), được đối sánh trên cùng bài toán, cùng mô hình, cùng hàm mục tiêu, cùng ràng buộc và cùng ngân sách đánh giá (12.550 lần đánh giá FEM/lượt chạy, 30 lần chạy độc lập/thuật toán), đối chiếu với mặt Pareto tham chiếu thu được bằng vét cạn toàn bộ 4.080 tổ hợp (59 nghiệm không bị trội). E-MOSFOA hội tụ nhanh hơn và gần mặt Pareto tham chiếu hơn trong cùng ngân sách (IGD chuẩn hoá trung bình 0,000100 so với 0,000506 của MOFDA; kiểm định Wilcoxon rank-sum p = 1,07×10⁻¹⁰), đạt vùng ổn định của hypervolume chỉ sau khoảng 1.000–1.500 lần đánh giá so với khoảng 5.000–7.000 của MOFDA, và đạt tỷ lệ bao phủ mặt Pareto tham chiếu cao hơn, ổn định hơn (98,76% ± 0,88% so với 89,27% ± 4,46%). Kết quả cung cấp cơ sở định lượng để tham khảo khi lựa chọn thuật toán tối ưu cho các bài toán thiết kế tiết diện hệ cọc công trình cảng biển có ràng buộc tương tự.

**Từ khóa:** tối ưu đa mục tiêu; thuật toán MOFDA; thuật toán MOSFOA; tiết diện cọc; cầu tàu trên nền cọc; kết nối SAP2000–MATLAB.

1. Mở đầu

Cầu tàu container trên nền cọc là dạng kết cấu phổ biến cho bến cảng trọng tải lớn tại Việt Nam, trong đó hệ cọc — cọc bê tông ly tâm dự ứng lực (PHC) kết hợp cọc ống thép — vừa là cấu kiện chịu lực chính vừa chiếm tỷ trọng lớn về vật liệu. Tối ưu đa mục tiêu có ràng buộc, kết hợp trực tiếp với mô hình phần tử hữu hạn (FEM), cho phép khảo sát hệ thống hoá đánh đổi giữa khối lượng vật liệu và chuyển vị, thay vì chỉ kiểm tra một phương án chọn trước theo kinh nghiệm.

Hai thuật toán tối ưu đa mục tiêu đã được nhóm nghiên cứu phát triển và công bố: MOFDA — thuật toán hướng dòng chảy với chọn thủ lĩnh lai, đã kiểm chứng trên các hàm chuẩn, bài toán kỹ thuật có ràng buộc và một công trình khung thép thực tế [1]; và MOSFOA — thuật toán dựa trên sao biển, gồm hai bản B-MOSFOA và E-MOSFOA, đã kiểm chứng trên các bộ benchmark IMOP/UF/RM-MEDA và một công trình cảng biển khác [2]. Mỗi thuật toán được kiểm chứng trên một công trình riêng, điều kiện đánh giá không giống nhau, nên chưa có cơ sở so sánh trực tiếp. Câu hỏi của nghiên cứu này: trên cùng hệ thống đánh giá MATLAB–SAP2000, cùng hàm mục tiêu, ràng buộc và ngân sách đánh giá FEM, MOFDA và MOSFOA khác biệt thế nào về chất lượng nghiệm và tốc độ hội tụ khi giải cùng bài toán tiết diện hệ cọc cầu tàu container 100.000 DWT Lạch Huyện, với 4.080 tổ hợp thiết kế, ràng buộc kết cấu, địa kỹ thuật (TCVN 10304:2025) và chống nhổ cọc? Đóng góp gồm: (i) hình thành bài toán tối ưu rời rạc với ràng buộc kết cấu, địa kỹ thuật và chống nhổ; (ii) mặt Pareto tham chiếu bằng vét cạn, độc lập với kết quả tìm kiếm của thuật toán; (iii) đối sánh định lượng MOFDA và E-MOSFOA qua IGD, hypervolume, khả năng bao phủ Pareto, kiểm định Wilcoxon rank-sum và đường cong hội tụ theo FE, với kết luận rút ra trực tiếp từ số liệu ở Mục 3.

2. Phương pháp nghiên cứu

2.1. Đối tượng, mô hình phần tử hữu hạn và biến thiết kế

Đối tượng là cầu tàu container 100.000 DWT thuộc cảng cửa ngõ quốc tế Hải Phòng (Lạch Huyện) — bến liền bờ trên bệ cọc cao. Phân đoạn phân tích dài khoảng 75 m, cao trình đỉnh bến +5,50 m, đáy bến sau nạo vét −16,0 m, tàu thiết kế dài 330 m, mớn nước 14,8 m. Mỗi phân đoạn có 132 cọc bê tông ly tâm dự ứng lực và 60 cọc ống thép D1016, tổng 192 cọc; tiết diện cọc là biến thiết kế, áp dụng đồng nhất theo loại cọc, vị trí/độ xiên/chiều dài ngàm giữ cố định để ràng buộc địa kỹ thuật nhất quán giữa các tổ hợp. Mô hình SAP2000 tuyến tính tĩnh (4.913 nút, 1.734 phần tử thanh, 4.488 phần tử tấm vỏ) cho chuyển vị và nội lực theo tổ hợp bao "BAO KT"; tổ hợp bão nằm ngoài phạm vi này và ngoài phạm vi nghiên cứu (Mục 3.3). Mũi cọc BTCT nằm trong lớp sét/đá sét phong hoá cứng, mũi cọc thép nằm trong lớp đá phong hoá mạnh nứt nẻ; không xét hiệu ứng nhóm cọc.

**Hình 1.** Mô hình SAP2000 của cầu tàu container 100.000 DWT.

Ba biến thiết kế rời rạc được sử dụng:

$$\mathbf{x} = [\,CatIdx_{BTCT},\ D_{thép},\ t_{thép}\,]$$  (1)

trong đó $CatIdx_{BTCT}\in\{1,\dots,5\}$ là chỉ số dòng catalogue cọc PHC AMACCAO (Bảng 1, TCVN 7888:2014/JIS A 5373:2016 [3]); $D_{thép}\in[0{,}800;1{,}300]$ m (bước 0,01 m, 51 giá trị); $t_{thép}\in[0{,}010;0{,}025]$ m (bước 0,001 m, 16 giá trị) — cho $5\times51\times16=$ **4.080 tổ hợp**.

**Bảng 1.** Catalogue cọc PHC AMACCAO sử dụng (Class A, TCVN 7888:2014)

| CatIdx | D (m) | t (m) | A (m²) | Mcr (T.m) | Mu (T.m) | Pvl (T) |
|---|---:|---:|---:|---:|---:|---:|
| 1 | 0,600 | 0,100 | 0,15708 | 17,00 | 25,51 | 380 |
| 2 | 0,700 | 0,110 | 0,20389 | 26,00 | 39,00 | 500 |
| 3 | 0,800 | 0,120 | 0,25635 | 37,00 | 55,50 | 680 |
| 4 | 0,900 | 0,130 | 0,31447 | 48,95 | 73,42 | 880 |
| 5 | 1,000 | 0,130 | 0,35531 | 62,22 | 93,32 | 1.100 |

Hai hàm mục tiêu là khối lượng vật liệu cọc và chuyển vị ngang lớn nhất:

$$f_1 = A(D,t)_{BTCT}\,\Sigma L_{BTCT}\,\gamma_{bêtông} + A(D,t)_{thép}\,\Sigma L_{thép}\,\gamma_{thép}$$  (2)

$$f_2 = \max\!\left(\sqrt{U_1^{2}+U_2^{2}}\right)$$  (3)

với $\gamma_{bêtông}=2{,}5$ T/m³, $\gamma_{thép}=7{,}85$ T/m³, theo tổ hợp bao "BAO KT".

2.2. Ràng buộc và mặt Pareto tham chiếu

Ràng buộc kết cấu gồm: tương tác lực dọc trục – mô men cọc BTCT theo catalogue, $N/P_{vl}+M/M_u-1\le 0$ (4); ứng suất cọc thép $\sigma=N/A+M/W\le F_y/\gamma_M$ ($F_y=3.150$ kG/cm² [6], $\gamma_M=1{,}05$); và chuyển vị ngang $U_{max}/U_{allow}-1\le 0$ ($U_{allow}=71{,}7$ mm, TCVN 11820-5:2021 [4]). Ràng buộc địa kỹ thuật theo **TCVN 10304:2025 [5]**: công thức cọc ma sát cho cọc BTCT (mũi trong sét) và công thức cọc chống tựa đá cho cọc thép (mũi trong đá nứt nẻ, hệ số giảm cường độ $K_s=0{,}32$, giả thiết thận trọng do thiếu số liệu RQD thật), kiểm tra $\gamma_n N_d\le R_k/\gamma_k$ ($\gamma_k=1{,}4$, $\gamma_n=1{,}15$, cấp hậu quả C2). Ràng buộc chống nhổ (18/360 cọc thép chịu kéo, tới ≈31 T) chỉ dùng ma sát thân ($\gamma_c=0{,}8$). Mọi vi phạm được gộp thành một hàm phạt áp lên cả hai mục tiêu:

$$F_k(\mathbf{x}) = f_k(\mathbf{x})\,\big[\,1+C\,P(\mathbf{x})\,\big],\quad k=1,2,\quad C=10$$  (5)

giữ cố định cho cả hai thuật toán. Toàn bộ 4.080 tổ hợp được đánh giá bằng cùng mô hình FEM để dựng **mặt Pareto tham chiếu**, độc lập với thuật toán tìm kiếm: 3.337/4.080 tổ hợp khả thi, cho **59 nghiệm không bị trội**.

2.3. Thuật toán đối sánh và ngân sách đánh giá công bằng

*MOFDA* [1] mở rộng Flow Direction Algorithm bằng kho lưu trữ Pareto ngoài (lưới thích nghi) và quy tắc **chọn thủ lĩnh lai**, chấm điểm mỗi nghiệm lưu trữ theo

$$s_i = GI_i + \dfrac{\varepsilon_i}{1+DE_i}$$

($GI_i$ chỉ số ô lưới, $DE_i$ mật độ cục bộ, $\varepsilon_i\in[0,1]$ nhiễu ngẫu nhiên), thủ lĩnh là cá thể điểm thấp nhất — ưu tiên vùng thưa nghiệm, hạn chế hội tụ sớm so với roulette-wheel thuần túy.

*MOSFOA*, chạy bản **E-MOSFOA** [2], mở rộng Starfish Optimization Algorithm [7] bằng kho lưu trữ Pareto và ba cơ chế bổ sung: điều khiển pha cosine, $GP=\tfrac{GP_0}{2}\big(1+\cos(\pi\, it/Max\_it)\big)$, thay xác suất thăm dò cố định; đột biến kiểu DE dẫn hướng thủ lĩnh, $mutant_i = X_{r1}+F(X_{r2}-X_{r3})+\lambda(X_{leader}-X_{r1})$, $F=0{,}5(1-it/Max\_it)$, $\lambda=0{,}3$; và tinh chỉnh Gaussian dựa trên kho lưu trữ ở 20% vòng lặp cuối. Cả hai thuật toán đều đã được kiểm chứng riêng trên một công trình cảng/biển thực tế [1, 2].

MOFDA ($N_p=50$, $maxiter=50$, $\beta=4$ lân cận/cá thể) và E-MOSFOA ($N_p=50$, $Max\_it=250$) có cấu trúc vòng lặp khác nhau, nên **số lần đánh giá FEM (FE)** được dùng làm đơn vị chi phí chung: $FE=N_p[1+maxiter(\beta+1)]=N_p(Max\_it+1)=$ **12.550/lượt chạy** cho cả hai, với $Max\_it=5\times maxiter$. Hai thuật toán cùng dung lượng kho lưu trữ ($N_r=100$), số ô lưới ($nGrid=10$) và $N=30$ lần chạy độc lập.

Mỗi thuật toán chạy 30 lần, đối chiếu với mặt Pareto tham chiếu bằng kiểm định Wilcoxon rank-sum hai phía ($\alpha=0{,}05$) trên **IGD** (chuẩn hoá theo miền giá trị mặt tham chiếu), **hypervolume (HV)** (cùng điểm tham chiếu cố định) và **khả năng bao phủ Pareto**:

$$\text{Pareto coverage (\%)} = \dfrac{\text{số nghiệm tham chiếu phân biệt tìm thấy}}{59}\times 100\%$$

dùng ngưỡng so khớp $10^{-6}$ cố định trước.

3. Kết quả và thảo luận

3.1. Mặt Pareto tham chiếu

Khối lượng vật liệu của 59 nghiệm tham chiếu dao động **3.317,3–5.189,4 T**, chuyển vị **9,83–16,27 mm**, đều thấp hơn nhiều giới hạn TCVN 11820-5:2021. Hiện tượng dồn biên (Bảng 2) cho thấy nghiệm Pareto tập trung mạnh về cận trên của $D_{thép}$ (khoảng 70% trong dải 5% sát cận trên) và yếu hơn về dòng CatIdx_BTCT lớn nhất — cho thấy miền khảo sát có thể chưa bao quát hết vùng đánh đổi ở đường kính lớn hơn (Mục 3.3).

**Bảng 2.** Kiểm chứng hiện tượng dồn biên trên 59 nghiệm tham chiếu

| Biến thiết kế | Miền khảo sát | Tại cận trên | Trong 5% sát cận trên | Tại/gần cận dưới |
|---|---|---:|---:|---:|
| CatIdx_BTCT | [1, 5] | 18/59 (30,5%) | 18/59 (30,5%) | 0 |
| D_thép (m) | [0,800; 1,300] | 17/59 (28,8%) | 41/59 (69,5%) | 0 |
| t_thép (m) | [0,010; 0,025] | 2/59 (3,4%) | 2/59 (3,4%) | 0 |

**Hình 2.** Mặt Pareto tham chiếu (59 nghiệm) trên nền các tổ hợp khả thi.

3.2. Kết quả từng thuật toán và đối sánh trực tiếp

Qua 30 lần chạy độc lập/thuật toán (Bảng 3), cả hai đều lấp đầy kho lưu trữ 100 nghiệm mỗi lần chạy, nhưng E-MOSFOA bao phủ mặt Pareto tham chiếu (59 nghiệm) đầy đủ hơn, ổn định hơn (98,76% ± 0,88% so với 89,27% ± 4,46% của MOFDA) và đạt IGD thấp hơn (0,000100 so với 0,000506).

**Bảng 3.** Thống kê 30 lần chạy; kiểm định Wilcoxon rank-sum so với MOFDA

| Chỉ số | MOFDA (TB ± ĐLC) | E-MOSFOA (TB ± ĐLC) | p-value |
|---|---:|---:|---:|
| GD (chuẩn hoá) | 0,000031 ± 0,000081 | 0,000000 ± 0,000000 | 0,0419 |
| IGD (chuẩn hoá) | 0,000506 ± 0,000182 | 0,000100 ± 0,000074 | 1,07×10⁻¹⁰ |
| HV (điểm tham chiếu cố định) | 41.654,0150 ± 0,0064 | 41.654,0214 ± 0,0002 | 6,53×10⁻¹¹ |
| Pareto coverage (/59) | 52,67 ± 2,63 (89,27%) | 58,27 ± 0,52 (98,76%) | 3,14×10⁻¹¹ |

Cả bốn khác biệt đều có ý nghĩa thống kê ở $\alpha=0{,}05$; chênh lệch HV và GD nhỏ về giá trị tuyệt đối vì cả hai thuật toán đều tiệm cận cùng vùng ổn định, nên trọng tâm đối sánh đặt vào **IGD và tốc độ hội tụ theo FE** hơn là chênh lệch HV cuối cùng. Đường cong hội tụ (Hình 3) cho thấy E-MOSFOA đạt vùng ổn định của HV chỉ sau ≈1.000–1.500 FE, so với ≈5.000–7.000 FE của MOFDA, đường IGD trung bình của E-MOSFOA luôn nằm dưới MOFDA trong suốt quá trình tìm kiếm. Điều này phù hợp với cơ chế điều khiển pha cosine của E-MOSFOA — điều khiển tường minh quá trình chuyển thăm dò→khai thác ngay từ đầu — khác với trọng số suy giảm $(1-iter/Max\_iter)^{2\cdot randn}$ của MOFDA vốn phụ thuộc nhiều vào thành phần ngẫu nhiên mỗi vòng lặp; đột biến dẫn hướng thủ lĩnh và tinh chỉnh Gaussian giai đoạn cuối có thể góp phần giúp E-MOSFOA bám sát mặt Pareto sau khi đã định vị được vùng tốt. Đây là nhận xét định hướng dựa trên đối chiếu cơ chế với số liệu quan sát được, không phải phân tích độ nhạy tách biệt từng cơ chế.

**Hình 3.** Đường cong hội tụ IGD và HV theo số lần đánh giá FEM.

3.3. Giới hạn nghiên cứu

Sự tập trung nghiệm Pareto về cận trên của $D_{thép}$ cho thấy miền khảo sát có thể chưa bao quát hết vùng đánh đổi ở đường kính lớn hơn, dù kết quả đối sánh thuật toán vẫn có giá trị vì cả hai được đánh giá trên cùng mặt tham chiếu. $K_s=0{,}32$ cho lớp đá nứt nẻ là giả thiết thận trọng chờ số liệu RQD thật ($\gamma_n=1{,}15$ đã được xác nhận). Hiệu ứng nhóm cọc, tổ hợp bão và tương tác đất–cọc kiểu p–y nằm ngoài phạm vi nghiên cứu, vốn chỉ xét phân tích tuyến tính tĩnh.

4. Kết luận và kiến nghị

Bài báo đã hình thành bài toán tối ưu đa mục tiêu rời rạc cho tiết diện hệ cọc cầu tàu container 100.000 DWT (4.080 tổ hợp; ràng buộc kết cấu, địa kỹ thuật theo TCVN 10304:2025 và chống nhổ cọc), và dựng mặt Pareto tham chiếu bằng vét cạn (59 nghiệm) làm chuẩn đối chiếu độc lập với thuật toán; mặt này cho thấy hiện tượng dồn biên về phía $D_{thép}$ lớn, một giới hạn khi khái quát hoá giá trị tuyệt đối. Đối sánh MOFDA và E-MOSFOA trên cùng bài toán, mô hình, hàm mục tiêu, ràng buộc và ngân sách FE (30 lần chạy/thuật toán), E-MOSFOA đạt IGD thấp hơn rõ rệt (0,000100 so với 0,000506, p = 1,07×10⁻¹⁰), hội tụ nhanh hơn khoảng năm lần theo FE, và bao phủ mặt tham chiếu đầy đủ hơn, ổn định hơn (98,76% ± 0,88% so với 89,27% ± 4,46%). Trong phạm vi khảo sát, E-MOSFOA là lựa chọn có lợi hơn về tốc độ hội tụ — không hàm ý ưu thế phổ quát cho các bài toán kết cấu khác — và kết quả cung cấp cơ sở định lượng để tham khảo khi lựa chọn thuật toán cho các bài toán thiết kế tiết diện cọc công trình cảng biển có ràng buộc tương tự. Trước khi áp dụng các giá trị khối lượng/chuyển vị tối ưu vào thiết kế chính thức, cần xác nhận lại các giới hạn ở Mục 3.3 (miền khảo sát ở $D_{thép}$ lớn, giả thiết $K_s$, chưa xét hiệu ứng nhóm cọc) với số liệu hiện trường và thiết kế đầy đủ hơn.

Lời cảm ơn

Nghiên cứu được tài trợ bởi Trường Đại học Hàng hải Việt Nam.

Xung đột lợi ích

Các tác giả cam kết không có xung đột lợi ích liên quan đến nội dung bài báo này.

Tài liệu tham khảo

1. Vu-Huu, T., Khatir, S., Cuong-Le, T.: Real-World Steel Frame Optimization Using a Hybrid Leader Selection-Based Multi-Objective Flow Direction Algorithm. International Journal for Numerical Methods in Engineering 126(15), e70098 (2025). https://doi.org/10.1002/nme.70098

2. Do-Quang, T., Vu-Huu, T., Le, C.T.: Multi-objective Optimization of Marine Structures Using an Enhanced Starfish Algorithm. Proceedings of the Institution of Civil Engineers – Structures and Buildings (2026). https://doi.org/10.1680/jstbu.26.00159

3. AMACCAO PILE: Catalogue và thông số kỹ thuật cọc bê tông ly tâm AMACCAO D300–D1200, theo TCVN 7888:2014 và JIS A 5373:2016 (2014).

4. Bộ Khoa học và Công nghệ: TCVN 11820-5:2021 — Công trình cảng biển – Yêu cầu thiết kế – Phần 5: Công trình bến (2021).

5. Viện Tiêu chuẩn Chất lượng Việt Nam: TCVN 10304:2025 (Xuất bản lần 2) — Thiết kế móng cọc (2025).

6. Bộ Khoa học và Công nghệ: TCVN 9245:2012 — Cọc ống thép (2012).

7. Zhong, C., et al.: Starfish optimization algorithm (SFOA): a bio-inspired metaheuristic algorithm for global optimization compared with 100 optimizers. Neural Computing and Applications, 3641–3683 (2025).

---

Ngày nhận bài: xx/xx/2026

Ngày nhận bản sửa: xx/xx/2026

Ngày duyệt đăng: xx/xx/2026
