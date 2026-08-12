**Tối ưu hóa thiết kế kết cấu trụ va bến cảng lỏng bằng thuật toán tối ưu hóa Sao biển (SFOA) kết hợp mô hình phần tử hữu hạn**

*Structural design optimization of a berthing dolphin at a liquid bulk jetty using the Starfish Optimization Algorithm coupled with a finite element model*

**[HỌ TÊN TÁC GIẢ]¹\***

¹ [Đơn vị công tác]

\*Email: [email]

**TÓM TẮT**

[Sẽ hoàn thiện sau khi có số liệu kết quả — xem placeholder ở bản đề cương. Giữ nguyên cấu trúc: vấn đề → phương pháp → kết quả số cụ thể → ý nghĩa.]

**Từ khóa:** Trụ va; tối ưu hóa kết cấu; thuật toán Sao biển; mô hình phần tử hữu hạn; cọc bê tông ứng suất trước.

**ABSTRACT**

[To be completed after numerical results are available.]

**Keywords:** Berthing dolphin; structural optimization; Starfish Optimization Algorithm; finite element model; prestressed concrete pile.

---

### 1. ĐẶT VẤN ĐỀ

Trụ va (Berthing Dolphin - BD) là một trong những kết cấu quan trọng nhất của hệ thống bến cảng, có nhiệm vụ tiếp nhận, hấp thụ và tiêu tán năng lượng va đập của tàu trong quá trình cập bến, đồng thời hỗ trợ các thao tác neo đậu, đảm bảo an toàn và tính liên tục trong khai thác của công trình cảng. Do phải chịu tổ hợp tải trọng phức tạp (tải va tàu, tải neo, tải trọng tĩnh) trong điều kiện làm việc dưới nước và nền đất yếu, việc thiết kế trụ va hiện nay ở Việt Nam chủ yếu vẫn dựa trên kinh nghiệm của kỹ sư thiết kế kết hợp tính toán lặp (trial-and-error) theo các tiêu chuẩn hiện hành. Cách tiếp cận này, tuy đảm bảo được yêu cầu an toàn, nhưng thường dẫn đến việc lựa chọn phương án kết cấu có tính dự trữ cao, gây dư thừa vật liệu và chưa khai thác hết tiềm năng tối ưu hóa chi phí xây dựng.

Trong những năm gần đây, các thuật toán tối ưu hóa metaheuristic lấy cảm hứng từ tự nhiên đã được ứng dụng rộng rãi trong lĩnh vực tối ưu hóa kết cấu công trình xây dựng, nhờ khả năng tìm kiếm nghiệm toàn cục hiệu quả mà không yêu cầu thông tin đạo hàm của hàm mục tiêu. Các thuật toán tiêu biểu có thể kể đến như tối ưu hóa bầy đàn (Particle Swarm Optimization - PSO) [1], tối ưu hóa sói xám (Grey Wolf Optimizer - GWO) [2], tối ưu hóa cá voi (Whale Optimization Algorithm - WOA) [3], và tối ưu hóa chim ưng Harris (Harris Hawks Optimization - HHO) [4]. Các thuật toán này đã được áp dụng thành công cho nhiều bài toán tối ưu hóa kết cấu công trình dân dụng, cầu, và một số công trình biển, tuy nhiên số lượng nghiên cứu áp dụng cho kết cấu trụ va bến cảng theo tiêu chuẩn thiết kế Việt Nam còn rất hạn chế.

Năm 2024, Zhong và cộng sự [5] đề xuất thuật toán tối ưu hóa Sao biển (Starfish Optimization Algorithm - SFOA), lấy cảm hứng từ các hành vi khám phá, săn mồi và tái sinh của sao biển. Thông qua thực nghiệm trên 65 hàm chuẩn và so sánh với 100 thuật toán khác, SFOA đã cho thấy hiệu quả vượt trội cả về độ chính xác và tốc độ hội tụ, đồng thời được kiểm chứng trên 10 bài toán kỹ thuật cơ khí điển hình. Tuy nhiên, đến nay chưa có nghiên cứu nào ứng dụng SFOA cho bài toán tối ưu hóa kết cấu công trình cảng biển có xét đầy đủ ràng buộc kỹ thuật và địa kỹ thuật thực tế thông qua mô hình phần tử hữu hạn (FEM).

Xuất phát từ khoảng trống nghiên cứu trên, bài báo này đề xuất một khung tính toán liên kết mô hình phần tử hữu hạn (SAP2000) với thuật toán SFOA trong môi trường MATLAB, nhằm tối ưu hóa chi phí xây dựng kết cấu trụ va, có xét đến các ràng buộc về khả năng chịu lực của cọc và điều kiện địa kỹ thuật theo TCVN 7888:2014 [6], TCVN 10304:2014 [7], và các tiêu chuẩn quốc tế PIANC (2002) [8], OCDI (2002) [9]. Đóng góp chính của nghiên cứu gồm: (i) xây dựng khung tính toán tự động liên kết SAP2000-MATLAB cho bài toán tối ưu hóa kết cấu cảng biển; (ii) áp dụng và đánh giá hiệu quả của SFOA so với các thuật toán PSO, GWO, WOA, HHO trên một công trình thực tế; (iii) làm cơ sở phương pháp luận cho việc mở rộng sang bài toán tối ưu hóa đa mục tiêu ở các nghiên cứu tiếp theo.

Cấu trúc còn lại của bài báo được tổ chức như sau: Mục 2 trình bày phương pháp nghiên cứu, bao gồm cơ sở thuật toán SFOA, xây dựng bài toán tối ưu hóa và khung tính toán liên kết SAP2000-MATLAB; Mục 3 trình bày và thảo luận kết quả; Mục 4 đưa ra các kết luận chính.

### 2. PHƯƠNG PHÁP NGHIÊN CỨU

**2.1. Thuật toán tối ưu hóa Sao biển (SFOA)**

SFOA [5] là thuật toán tối ưu hóa ngẫu nhiên lấy cảm hứng từ ba hành vi sinh học của sao biển: khám phá (exploration) bằng năm cánh tay có "mắt" ở đầu mút, săn mồi (preying) và tái sinh (regeneration). Tương tự các thuật toán metaheuristic phổ biến khác, SFOA gồm hai pha chính: khám phá và khai thác, được lựa chọn với xác suất bằng nhau thông qua tham số điều khiển `Gp = 0,5`.

Quần thể ban đầu gồm N cá thể (sao biển), mỗi cá thể là một nghiệm ứng viên trong không gian D chiều, được khởi tạo ngẫu nhiên trong biên của các biến thiết kế:

X_ij = l_j + r(u_j − l_j), i = 1,…,N; j = 1,…,D  (1)

trong đó `r` là số ngẫu nhiên trong đoạn (0,1); `l_j`, `u_j` là biên dưới và biên trên của biến thiết kế thứ j.

*2.1.1. Pha khám phá (exploration)*

Với bài toán có số chiều D > 5, SFOA sử dụng mô hình tìm kiếm năm chiều, cập nhật đồng thời 5 chiều được chọn ngẫu nhiên:

Y^T_{i,p} = X^T_{i,p} + a1(X^T_{best,p} − X^T_{i,p})·cos(θ), nếu r ≤ 0,5
Y^T_{i,p} = X^T_{i,p} − a1(X^T_{best,p} − X^T_{i,p})·sin(θ), nếu r > 0,5  (2)

với a1 = (2r − 1)π (3), θ = (π/2)·(T/T_max) (4), T là số vòng lặp hiện tại, T_max là số vòng lặp tối đa.

Với bài toán có D ≤ 5 (như bài toán 4 biến trong nghiên cứu này), SFOA sử dụng mô hình tìm kiếm một chiều:

Y^T_{i,p} = E_t·X^T_{i,p} + A1(X^T_{k1,p} − X^T_{i,p}) + A2(X^T_{k2,p} − X^T_{i,p})  (5)

với E_t = (1 − T/T_max)·cos(θ) (6); A1, A2 là số ngẫu nhiên trong đoạn (−1,1); k1, k2 là hai cá thể được chọn ngẫu nhiên khác.

*2.1.2. Pha khai thác (exploitation)*

Pha khai thác mô hình hóa hành vi săn mồi theo chiến lược tìm kiếm hai hướng song song, sử dụng khoảng cách giữa nghiệm tốt nhất hiện tại và các cá thể khác:

d_m = X^T_{best} − X^T_{mp}, m = 1,…,5  (7)
Y^T_i = X^T_i + r1·d_{m1} + r2·d_{m2}  (8)

Hành vi tái sinh chỉ áp dụng cho cá thể cuối (i = N) trong quần thể:

Y^T_i = X^T_i·exp(−T×N/T_max)  (9)

Nếu nghiệm mới nằm ngoài biên của biến thiết kế, giá trị được kẹp lại về biên gần nhất (đối với pha khai thác) hoặc giữ nguyên giá trị cũ (đối với pha khám phá) — chi tiết công thức xử lý biên được trình bày trong nghiên cứu gốc [5].

**2.2. Xây dựng bài toán tối ưu hóa kết cấu trụ va**

Công trình nghiên cứu là trụ va (BD) thuộc hệ thống bến cảng lỏng, với cấu hình hiện trạng gồm 19 cọc bê tông ứng suất trước D600B, chiều dài 39m, bố trí gồm 9 cọc thẳng đứng chịu tải dọc trục, 6 cọc xiên trong mặt phẳng (độ nghiêng 6:1), và 4 cọc xiên không gian (độ nghiêng 6:1, xoay 30° hoặc 60°) để tăng khả năng chịu tải theo các phương chéo. Đài cọc bê tông cốt thép đổ tại chỗ (mác C40/50) có kích thước 8,4×9,6×(2,0-3,0)m.

*2.2.1. Biến thiết kế*

Bốn biến thiết kế rời rạc được xem xét, như trình bày trong Bảng 1: đường kính ngoài cọc (X1 = Dp), độ dày vách cọc (X2 = tp), góc nghiêng cọc xiên so với trục z (X3 = θ), và chiều dài cọc (X4 = Lp).

*Bảng 1. Biến thiết kế của bài toán tối ưu hóa trụ va*

| Biến | Ký hiệu | Đơn vị | Loại | Miền giá trị |
|---|---|---|---|---|
| X1 | Dp | mm | Rời rạc | Theo danh mục TCVN 7888:2014 [6] |
| X2 | tp | mm | Rời rạc | Theo danh mục TCVN 7888:2014 [6] |
| X3 | θ | độ | Rời rạc | {6; 7; 8} |
| X4 | Lp | m | Rời rạc | [1:0,1:40] |

*2.2.2. Hàm mục tiêu*

Hàm mục tiêu là chi phí xây dựng phần cọc của trụ va, tính theo tổng chiều dài và đơn giá của từng cọc:

f(X) = Σ_{i=1}^{Np} L_p × P_p  (10)

trong đó Np là tổng số cọc, L_p là chiều dài cọc, P_p là đơn giá cọc theo mét dài (USD/m), lấy theo bảng tra tương ứng với cặp (Dp, tp) đã chọn.

*2.2.3. Ràng buộc*

Các ràng buộc kết cấu và địa kỹ thuật được thiết lập để đảm bảo an toàn của hệ móng cọc, dựa trên kết quả phân tích từ mô hình FEM và tiêu chuẩn TCVN 10304:2014 [7]:

g1(X) = R_{c,FEA} − N_{c,d} ≤ 0  (11)
g2(X) = M_{FEA} − M_{cr} ≤ 0  (12)
g3(X) = I_B − 0,35 ≤ 0  (13)
g4(X) = 2 − h_{tip} ≤ 0  (14)

trong đó R_{c,FEA} và M_{FEA} là lực dọc và mô men lớn nhất trong cọc trích xuất từ kết quả phân tích SAP2000; N_{c,d} là khả năng chịu tải dọc trục thiết kế của cọc theo TCVN 10304:2014; M_{cr} là mô men gây nứt của tiết diện cọc theo TCVN 7888:2014; I_B là chỉ số sệt của lớp đất tại mũi cọc; h_{tip} là độ dày lớp đất chịu lực tại mũi cọc (m). Tải trọng tác dụng lên mô hình gồm tải trọng tĩnh (DL), tải va tàu (BL) và tải neo (ML), xác định theo PIANC (2002) [8] và OCDI (2002) [9], tổ hợp theo Bảng 2.

*Bảng 2. Tổ hợp tải trọng sử dụng trong mô hình phần tử hữu hạn của trụ va*

| Trường hợp tải | X (kN) | Y (kN) | Z (kN) |
|---|---|---|---|
| DL | — | — | — (tính tự động trong SAP2000) |
| BL | 222,42 | 444,83 | 0 |
| ML | 99,05 | 118,07 | 71,2 |

Do bài toán có ràng buộc, phương pháp hàm phạt được sử dụng để đưa bài toán về dạng không ràng buộc, phù hợp để áp dụng trực tiếp thuật toán SFOA:

F̂(X) = f(X) + P(X)  (15)
P(X) = Σ_{i=1}^{m} α_i × max(0, g_i(X))  (16)

trong đó α_i là hệ số phạt của ràng buộc thứ i, m là tổng số ràng buộc.

**2.3. Khung tính toán liên kết SAP2000-MATLAB**

Do hàm mục tiêu (10) và các ràng buộc (11)-(14) phụ thuộc vào kết quả phân tích kết cấu (nội lực, mô men, chuyển vị) không thể biểu diễn dưới dạng giải tích khép kín, nghiên cứu xây dựng một khung tính toán tự động liên kết mô hình phần tử hữu hạn trong SAP2000 với thuật toán tối ưu hóa trong MATLAB, thông qua giao diện lập trình ứng dụng mở (Open Application Programming Interface - OAPI) do CSI cung cấp. Quy trình tính toán được mô tả trong Hình 1, gồm các bước: (i) SFOA khởi tạo/cập nhật quần thể nghiệm ứng viên X; (ii) mỗi nghiệm X được truyền vào mô hình SAP2000 thông qua OAPI để cập nhật tiết diện, tọa độ nút (góc nghiêng, chiều dài cọc); (iii) chạy phân tích kết cấu; (iv) trích xuất kết quả nội lực/mô men lớn nhất; (v) tính hàm mục tiêu và hàm phạt theo (15)-(16); (vi) SFOA sử dụng giá trị hàm mục tiêu để cập nhật quần thể ở vòng lặp tiếp theo. Quá trình lặp lại đến khi đạt số vòng lặp tối đa T_max.

*[Hình 1. Sơ đồ khối quy trình tính toán liên kết SAP2000-MATLAB]*

Thuật toán SFOA được thiết lập với kích thước quần thể N = [ ], số vòng lặp tối đa T_max = [ ], và được chạy [ ] lần độc lập để đảm bảo độ tin cậy thống kê của kết quả. Kết quả của SFOA được so sánh với bốn thuật toán đối chứng phổ biến: PSO [1], GWO [2], WOA [3], và HHO [4], sử dụng cùng hàm mục tiêu, cùng cấu hình tham số quần thể/vòng lặp, và cùng số lần chạy độc lập.

---

### 3. KẾT QUẢ VÀ THẢO LUẬN — *(chưa hoàn thiện — cần số liệu chạy mô hình, xem Mục "Việc cần cung cấp" dưới đây)*

**3.1. Kết quả tối ưu hóa bằng SFOA** — *[chờ số liệu]*

**3.2. Đường cong hội tụ** — *[chờ số liệu]*

**3.3. So sánh với các thuật toán đối chứng** — *[chờ số liệu]*

**3.4. Thảo luận** — *[chờ số liệu]*

### 4. KẾT LUẬN — *[chờ số liệu để viết hoàn chỉnh]*

**Lời cảm ơn** (nếu có)

**TÀI LIỆU THAM KHẢO**

[1] J. Kennedy, R. Eberhart. Particle swarm optimization. Proceedings of ICNN'95 - International Conference on Neural Networks, vol. 4, pp. 1942-1948, 1995, doi: 10.1109/ICNN.1995.488968.

[2] S. Mirjalili, S. M. Mirjalili, A. Lewis. Grey wolf optimizer. Advances in Engineering Software, vol. 69, pp. 46-61, 2014, doi: 10.1016/j.advengsoft.2013.12.007.

[3] S. Mirjalili, A. Lewis. The whale optimization algorithm. Advances in Engineering Software, vol. 95, pp. 51-67, 2016, doi: 10.1016/j.advengsoft.2016.01.008.

[4] A. A. Heidari, S. Mirjalili, H. Faris, I. Aljarah, M. Mafarja, H. Chen. Harris hawks optimization: algorithm and applications. Future Generation Computer Systems, vol. 97, pp. 849-872, 2019, doi: 10.1016/j.future.2019.02.028.

[5] C. Zhong, G. Li, Z. Meng, H. Li, A. R. Yildiz, S. Mirjalili. Starfish optimization algorithm (SFOA): a bio-inspired metaheuristic algorithm for global optimization compared with 100 optimizers. Neural Computing and Applications, vol. 37, pp. 3641-3683, 2025, doi: 10.1007/s00521-024-10694-1.

[6] Bộ Khoa học và Công nghệ. TCVN 7888:2014 - Cọc bê tông ly tâm ứng suất trước. Hà Nội, 2014.

[7] Bộ Khoa học và Công nghệ. TCVN 10304:2014 - Móng cọc - Tiêu chuẩn thiết kế. Hà Nội, 2014.

[8] International Navigation Association (PIANC). Guidelines for the design of fender systems. Brussels, Belgium, 2002.

[9] The Overseas Coastal Area Development Institute of Japan (OCDI). Technical standards for port and harbour facilities in Japan. Tokyo, Japan, 2002.

---

## VIỆC CẦN ANH/CHỊ CUNG CẤP ĐỂ HOÀN THIỆN MỤC 3, 4, TÓM TẮT/ABSTRACT

1. **Bảng tra đầy đủ danh mục cọc TCVN 7888:2014** đang dùng trong luận án (mã cọc, Dp, tp, đơn giá $/m hoặc VNĐ/m) — có thể chỉ cần gửi lại đúng phần dữ liệu đã dùng cho Table 9 trong bài chính (B-MOSFOA/E-MOSFOA) nếu muốn dùng chung catalog.
2. **Thông số sức chịu tải đất nền** theo từng lớp (q_b - sức chống mũi; f_i - ma sát bên đơn vị, theo TCVN 10304:2014) hoặc báo cáo khảo sát địa chất gốc — để tính chính xác N_{c,d} trong ràng buộc (11).
3. **Xác nhận khả năng chạy OAPI:** anh/chị đã có file mô hình SAP2000 (.sdb) của BD tham số hóa được chưa? Phiên bản SAP2000 đang dùng (v20/v21/v22...)? MATLAB kết nối OAPI đã thử thành công chưa? (để tôi viết đúng cú pháp `SapObject`/`cSapModel` tương ứng — xem code mẫu ở file `code/update_BD_model_SAP2000.m` gửi kèm).
4. **Tên tác giả + đơn vị công tác + email** để điền phần đầu bài.
5. Có cần tôi viết luôn code PSO/GWO/WOA/HHO (bản đơn giản) hay anh/chị đã có sẵn code gốc từ MathWorks/trang tác giả (khuyến nghị dùng code gốc để đảm bảo tính trung thực khi so sánh)?
6. Sau khi chạy xong pipeline, gửi lại: (a) bảng biến thiết kế tối ưu + giá trị hàm mục tiêu của từng thuật toán, (b) bảng Best/Mean/Worst/STD qua N lần chạy độc lập, (c) dữ liệu đường cong hội tụ (nếu có) — tôi sẽ viết hoàn chỉnh Mục 3, 4, Tóm tắt và Abstract dựa trên số liệu thật.
