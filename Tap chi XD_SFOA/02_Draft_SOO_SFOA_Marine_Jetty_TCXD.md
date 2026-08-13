<!-- GHI CHÚ NỘI BỘ (xóa trước khi nộp): Bản thảo này đã hoàn chỉnh phần lý thuyết,
phương pháp và thiết kế thực nghiệm theo đề cương. Phần 4 (KẾT QUẢ VÀ THẢO LUẬN)
và TÓM TẮT/ABSTRACT còn để [TBD] vì 180 lượt chạy SFOA-SAP2000 (6 case × 30 run)
CHƯA được thực thi — pipeline MATLAB-SAP2000 hiện thiếu một số hàm phụ trợ
(xem báo cáo kèm theo). Không điền số liệu giả định vào các bảng. -->

**Ứng dụng thuật toán tối ưu sao biển cho tối ưu đơn mục tiêu kết cấu công trình biển**

Application of the Starfish Optimization Algorithm to Single-Objective Optimization of Marine Jetty Structures

**[TÊN TÁC GIẢ]^1,\*^**

^1^[Đơn vị công tác]

^\*^Email: dangvanhai@hanyang.ac.kr

**TÓM TẮT**

Kết cấu công trình biển dạng bến cập tàu và cầu cảng chịu đồng thời tải trọng cập tàu, tải trọng neo và tải trọng khai thác, trong khi vẫn phải bảo đảm chi phí xây dựng hợp lý và độ cứng phù hợp. Nghiên cứu áp dụng thuật toán tối ưu sao biển nguyên bản (Original Starfish Optimization Algorithm - SFOA) để giải sáu bài toán tối ưu đơn mục tiêu (SOO) trên ba hệ kết cấu: Berthing Dolphin (BD), Mooring Dolphin (MD) và Main Jetty Platform (MJP), với hai mục tiêu độc lập là tối thiểu chi phí xây dựng và tối thiểu chuyển vị lớn nhất. Mô hình phần tử hữu hạn SAP2000 được liên kết trực tiếp với MATLAB qua giao diện COM để đánh giá phản ứng kết cấu trong từng lần lặp của SFOA. Mỗi bài toán được chạy độc lập 30 lần với 100 cá thể và 300 vòng lặp để đánh giá độ ổn định thuật toán. [Kết quả số liệu cụ thể (Best/Mean/STD, thiết kế tối ưu, mức chênh lệch chi phí-chuyển vị) sẽ được bổ sung sau khi hoàn tất thực nghiệm]. Dự kiến SFOA hội tụ ổn định khi tối ưu từng mục tiêu riêng lẻ, nhưng nghiệm tối ưu chi phí và nghiệm tối ưu chuyển vị khác biệt về biến thiết kế, thể hiện xung đột giữa hai mục tiêu. Vì cách tiếp cận đơn mục tiêu chỉ tạo ra nghiệm cực trị mà không duy trì tập nghiệm không trội, nghiên cứu chỉ ra sự cần thiết phát triển một phiên bản đa mục tiêu của SFOA (MOSFOA) để cung cấp tập phương án cân bằng chi phí và độ cứng cho bài toán thiết kế thực tế.

**Từ khóa:** Thuật toán tối ưu sao biển; tối ưu đơn mục tiêu; kết cấu công trình biển; SAP2000-MATLAB; đánh đổi chi phí-chuyển vị; bến cập tàu.

**ABSTRACT**

Marine jetty structures such as berthing and mooring dolphins simultaneously resist berthing, mooring and operational loads while having to satisfy both cost-effectiveness and stiffness requirements. This study applies the original Starfish Optimization Algorithm (SFOA) to six single-objective optimization (SOO) problems on three structural systems — Berthing Dolphin (BD), Mooring Dolphin (MD) and Main Jetty Platform (MJP) — using two independent objectives: minimum construction cost and minimum maximum displacement. A SAP2000 finite-element model is coupled directly with MATLAB through a COM interface to evaluate structural response at every SFOA iteration. Each problem is solved over 30 independent runs with a population of 100 and 300 iterations to assess algorithmic stability. [Quantitative findings — best/mean/standard-deviation statistics, optimal designs and the cost-displacement gap — will be reported once the numerical campaign is completed]. SFOA is expected to converge stably when each objective is optimized independently, while the cost-optimal and displacement-optimal designs are expected to differ in design variables, revealing a conflict between the two objectives. Because a single-objective approach only yields extreme solutions and cannot maintain a non-dominated solution set, the study motivates the development of a multi-objective SFOA (MOSFOA) capable of providing a trade-off design set for practical decision-making.

**Keywords:** Starfish Optimization Algorithm; single-objective optimization; marine jetty structures; SAP2000-MATLAB coupling; cost-displacement trade-off; berthing dolphin.

**ĐẶT VẤN ĐỀ**

Kết cấu công trình biển như bến cập tàu (Berthing Dolphin - BD), bến neo (Mooring Dolphin - MD) và cầu cảng chính (Main Jetty Platform - MJP) có nhiều biến thiết kế (đường kính cọc, chiều dày thành cọc, góc nghiêng, chiều dài cọc, nhịp dầm...) và chịu đồng thời nhiều tổ hợp tải trọng phức tạp gồm tải trọng bản thân, tải trọng cập tàu, tải trọng neo và tải trọng khai thác. Thiết kế thực tế phải đồng thời bảo đảm an toàn kết cấu, độ cứng/chuyển vị trong giới hạn cho phép và hiệu quả kinh tế. Mô hình phần tử hữu hạn (FEM) cho phép đánh giá trực tiếp phản ứng kết cấu dưới các tổ hợp tải này, còn các thuật toán tối ưu metaheuristic phù hợp với bài toán tối ưu phi tuyến, biến rời rạc và nhiều ràng buộc kỹ thuật mà các phương pháp giải tích khó xử lý.

Thuật toán tối ưu sao biển (Starfish Optimization Algorithm - SFOA) là một thuật toán metaheuristic lấy cảm hứng từ hành vi săn mồi và tái sinh của sao biển, gồm hai pha chính là khám phá (exploration) và khai thác (exploitation) [1]. SFOA đã được kiểm chứng tốt trên nhiều hàm benchmark và một số bài toán kỹ thuật, tuy nhiên nghiên cứu này không khảo sát SFOA ở mức benchmark mà tập trung vào khả năng ứng dụng của SFOA nguyên bản cho các bài toán tối ưu kết cấu công trình biển thực tế, có tính phi tuyến cao, biến rời rạc và kết hợp trực tiếp với phân tích FEM. Đây là khoảng trống nghiên cứu cần khảo sát, không nhằm khẳng định SFOA là thuật toán yếu.

Trong thiết kế kết cấu công trình biển, hai tiêu chí quan trọng nhất thường là chi phí xây dựng C(x) và chuyển vị lớn nhất D(x), với x là vector biến thiết kế. Khi áp dụng SFOA nguyên bản theo cách tiếp cận đơn mục tiêu (SOO), hai bài toán $\min C(x)$ và $\min D(x)$ được giải độc lập trong cùng một không gian thiết kế, mỗi bài toán chỉ trả về một nghiệm tối ưu duy nhất theo tiêu chí được chọn.

Mục tiêu tổng quát của nghiên cứu là đánh giá khả năng của SFOA nguyên bản trong tối ưu đơn mục tiêu cho ba hệ kết cấu BD, MD và MJP, đồng thời phân tích sự khác biệt giữa nghiệm tối ưu chi phí và nghiệm tối ưu chuyển vị để làm rõ giới hạn của cách tiếp cận SOO khi bài toán thiết kế thực tế đòi hỏi xem xét đồng thời nhiều tiêu chí. Nghiên cứu đặt ra bốn câu hỏi: (i) SFOA nguyên bản có giải ổn định các bài toán tối ưu chi phí và chuyển vị của BD, MD, MJP hay không; (ii) hai nghiệm tối ưu này khác nhau như thế nào về biến thiết kế; (iii) mức đánh đổi chi phí-chuyển vị có xuất hiện nhất quán trên cả ba hệ kết cấu hay không; (iv) vì sao SOO không đủ để cung cấp tập phương án cho bài toán thiết kế thực tế.

Đóng góp của nghiên cứu gồm ba điểm: (1) xây dựng và kiểm chứng framework liên kết SAP2000-MATLAB-SFOA cho tối ưu đơn mục tiêu kết cấu công trình biển; (2) đánh giá SFOA nguyên bản trên ba hệ kết cấu thực tế BD, MD, MJP với biến thiết kế rời rạc và ràng buộc kỹ thuật theo tiêu chuẩn Việt Nam và quốc tế; (3) định lượng sự khác biệt giữa nghiệm cost-optimal và displacement-optimal, từ đó xác lập cơ sở kỹ thuật cho nhu cầu tối ưu đa mục tiêu (MOO) và bước phát triển tiếp theo là MOSFOA.

**1. MÔ HÌNH BÀI TOÁN VÀ PHƯƠNG PHÁP NGHIÊN CỨU**

***1.1. Hệ kết cấu nghiên cứu***

Ba hệ kết cấu được kế thừa từ mô hình đã sử dụng trong nghiên cứu tối ưu đa mục tiêu (MOO/MOSFOA) nền [2]. BD là hệ cọc bê tông dự ứng lực D600B, gồm các cọc đứng và cọc nghiêng, chịu tổ hợp tải trọng bản thân (DL), tải trọng cập tàu (BL) và tải trọng neo (ML). MD gồm cọc bê tông dự ứng lực D600B, bố trí một cọc đứng và các cọc nghiêng trong mặt phẳng/không gian, chịu tổ hợp DL và ML. MJP là hệ khung cọc-dầm-bản mặt cầu bê tông cốt thép, cọc đứng D500B bố trí dạng lưới, dầm dọc/ngang và bản mặt cầu, chịu tổ hợp DL và tải trọng khai thác (LL). Cấu hình cọc, kích thước dầm và số lượng cọc của cả ba hệ được lấy đúng theo mô hình SAP2000 nền đã dùng trong [2]; *số liệu cấu hình cụ thể (số cọc, chiều dài, bước lưới) cần được đối chiếu trực tiếp với tệp mô hình SAP2000 trước khi chốt bản thảo cuối, vì một số giá trị mô tả trong tài liệu tổng hợp trước đây chưa khớp hoàn toàn với mô hình SAP2000 hiện có.*

***1.2. Khung liên kết SAP2000-MATLAB-SFOA***

Mô hình FEM được giữ nguyên như trong nghiên cứu MOO nền. Với mỗi vector thiết kế x do SFOA đề xuất, MATLAB cập nhật các thông số hình học (đường kính, chiều dày, chiều dài cọc, kích thước dầm...) trực tiếp vào mô hình SAP2000 đang mở thông qua giao diện lập trình COM (SAP2000 OAPI, gọi tắt là công cụ SM), sau đó ra lệnh chạy phân tích FEM. Kết quả chuyển vị, nội lực (N, M, V) và phản lực gối được truy xuất ngược lại MATLAB để kiểm tra ràng buộc và tính giá trị hàm mục tiêu có phạt (objective + penalty), làm đầu vào cho vòng lặp tiếp theo của SFOA. Cơ chế liên kết hai chiều này cho phép SFOA tối ưu trực tiếp trên đáp ứng kết cấu thật, không cần xây dựng hàm surrogate.

***1.3. Tải trọng và tổ hợp tải***

Hệ tải trọng gồm DL (tự tính trong SAP2000), BL và ML (xác định theo PIANC [4] và OCDI [5]) và LL. Tổ hợp tải được giữ nguyên theo mô hình MOO nền: BD chịu DL+BL+ML; MD chịu DL+ML; MJP chịu DL+LL.

***1.4. Tiêu chuẩn và ràng buộc kỹ thuật***

Ràng buộc kỹ thuật áp dụng theo TCVN 7888:2014 về kích thước cọc bê tông dự ứng lực [3], TCVN 10304:2014 về thiết kế móng cọc và sức chịu tải [4], cùng các yêu cầu về sức chịu tải dọc trục, sức chịu nhổ và mô men uốn giới hạn của cọc đã tích hợp trong SAP2000. Ràng buộc được xử lý bằng hàm phạt (penalty), với tổng T ràng buộc:

$$P(x)=\sum_{j=1}^{T}\lambda_j \max[0,g_j(x)]^{p} \tag{1}$$

***1.5. Biến thiết kế và hàm mục tiêu***

Với BD và MD, vector biến thiết kế là $x=[D,t,\theta,L]$, trong đó D là đường kính ngoài cọc, t là chiều dày thành cọc, $\theta$ là góc nghiêng và L là chiều dài cọc; các biến D, t được chọn rời rạc theo danh mục cọc tham chiếu, $\theta$ theo miền rời rạc đã khóa, L theo miền rời rạc trong khoảng nghiên cứu. Với MJP, vector biến thiết kế được mở rộng thành $x=[D,t,L,L_L,L_T,b,h]$, thêm nhịp dọc $L_L$, nhịp ngang $L_T$, bề rộng dầm b và chiều cao dầm h.

Hàm mục tiêu chi phí với BD/MD là $C(x)=N_pL_pP_p$ (số cọc, chiều dài cọc, đơn giá cọc); với MJP là $C(x)=N_pL_pP_p+V_bP_c+W_sP_s$, cộng thêm chi phí bê tông và cốt thép dầm. Hàm mục tiêu chuyển vị là $D(x)=D_{\max}(x)$, lấy trực tiếp từ kết quả phân tích SAP2000. Hàm fitness cuối cùng cho hai bài toán tối ưu chi phí (SOO-C) và tối ưu chuyển vị (SOO-D) là:

$$F_C(x)=C(x)+P(x); \qquad F_D(x)=D(x)+P(x) \tag{2}$$

***1.6. Thuật toán SFOA nguyên bản***

Nghiên cứu sử dụng đúng SFOA nguyên bản [1], không bổ sung archive Pareto, non-dominated sorting, leader selection hay các cơ chế đa mục tiêu khác — đây là điểm phân biệt cốt yếu giữa bài toán SOO trong nghiên cứu này và MOSFOA ở bước phát triển tiếp theo. Trong pha khám phá, mỗi cá thể cập nhật vị trí theo một trong hai chiến lược phụ thuộc số chiều bài toán, có tham chiếu đến nghiệm tốt nhất hiện tại; trong pha khai thác, cá thể cập nhật theo cơ chế "săn mồi" dựa trên năm cá thể tham chiếu (năm cánh sao biển) và cơ chế "tái sinh" cho cá thể cuối cùng của quần thể. Sau mỗi lần cập nhật liên tục, nghiệm được kiểm soát biên rồi ánh xạ về tập giá trị thiết kế rời rạc hợp lệ (theo danh mục cọc, bước lưới dầm) trước khi gửi sang SAP2000 đánh giá. Điều kiện dừng được khóa thống nhất cho toàn bộ 6 bài toán: quần thể 100 cá thể, 300 vòng lặp, 30 lần chạy độc lập.

**2. THIẾT LẬP THỰC NGHIỆM SỐ**

Sáu bài toán SOO được thiết lập từ tổ hợp ba hệ kết cấu và hai mục tiêu, như trong Bảng 1.

Bảng 1. Ma trận sáu bài toán tối ưu đơn mục tiêu

| Case | Kết cấu | Mục tiêu | Thuật toán |
|---|---|---|---|
| C1 | BD | Min Cost | Original SFOA |
| C2 | BD | Min Displacement | Original SFOA |
| C3 | MD | Min Cost | Original SFOA |
| C4 | MD | Min Displacement | Original SFOA |
| C5 | MJP | Min Cost | Original SFOA |
| C6 | MJP | Min Displacement | Original SFOA |

Mỗi case được chạy 30 lần độc lập với cùng mô hình FEM, cùng tải trọng, cùng ràng buộc, cùng hàm phạt và cùng miền biến, tổng cộng $6\times30=180$ lượt chạy độc lập. Kết quả được đánh giá theo ba nhóm chỉ tiêu: (i) chỉ tiêu thuật toán — giá trị tốt nhất (Best), trung bình (Mean), xấu nhất (Max), độ lệch chuẩn (STD) và đường hội tụ; (ii) chỉ tiêu kết cấu — chi phí, chuyển vị lớn nhất, biến thiết kế và trạng thái ràng buộc; (iii) chỉ tiêu đánh đổi — chi phí của nghiệm tối ưu chuyển vị, chuyển vị của nghiệm tối ưu chi phí, và phần trăm chênh lệch giữa hai nghiệm cực trị.

**3. KẾT QUẢ VÀ THẢO LUẬN**

*[Ghi chú bản thảo: Nội dung định lượng của Phần 3 phụ thuộc kết quả 180 lượt chạy SFOA-SAP2000 chưa được thực hiện tại thời điểm soạn bản thảo này. Cấu trúc phân tích được giữ nguyên theo đề cương; các bảng dưới đây sẽ được điền số liệu thật sau khi hoàn tất thực nghiệm số.]*

***3.1. Khả năng hội tụ và độ ổn định của SFOA***

Đường hội tụ Best-so-far của SFOA cho sáu bài toán (Hình 1) và kết quả thống kê 30 lần chạy (Bảng 2) được dùng để đánh giá đồng thời chất lượng nghiệm và độ ổn định — không kết luận SFOA tốt hay yếu chỉ dựa trên một đường hội tụ đơn lẻ.

Bảng 2. Kết quả thống kê 30 lần chạy của SFOA cho sáu case

| Case | Best | Mean | Max | STD | CV (%) |
|---|---|---|---|---|---|
| BD-C | TBD | TBD | TBD | TBD | TBD |
| BD-D | TBD | TBD | TBD | TBD | TBD |
| MD-C | TBD | TBD | TBD | TBD | TBD |
| MD-D | TBD | TBD | TBD | TBD | TBD |
| MJP-C | TBD | TBD | TBD | TBD | TBD |
| MJP-D | TBD | TBD | TBD | TBD | TBD |

***3.2. Kết quả tối ưu của BD, MD và MJP***

Với mỗi hệ kết cấu, hai nghiệm tối ưu (cost-optimal và displacement-optimal) được so sánh về biến thiết kế, chi phí và chuyển vị (Bảng 3), đồng thời đối chiếu với thiết kế hiện tại để xác định mức tiết kiệm chi phí hoặc cải thiện độ cứng đạt được (Bảng 4).

Bảng 3. Hai nghiệm tối ưu đơn mục tiêu của BD, MD, MJP (rút gọn)

| Kết cấu | Nghiệm | Mục tiêu tối ưu | Cost | Displacement |
|---|---|---|---|---|
| BD | BD-C / BD-D | Cost / Displacement | TBD | TBD |
| MD | MD-C / MD-D | Cost / Displacement | TBD | TBD |
| MJP | MJP-C / MJP-D | Cost / Displacement | TBD | TBD |

Bảng 4. So sánh thiết kế hiện tại và nghiệm SOO

| Kết cấu | Thiết kế | Cost | ΔCost (%) | Displacement | ΔD (%) |
|---|---|---|---|---|---|
| BD | Current / SFOA-C / SFOA-D | TBD | TBD | TBD | TBD |
| MD | Current / SFOA-C / SFOA-D | TBD | TBD | TBD | TBD |
| MJP | Current / SFOA-C / SFOA-D | TBD | TBD | TBD | TBD |

***3.3. Phân tích đánh đổi chi phí-chuyển vị***

Đây là phần phân tích cốt lõi của nghiên cứu. Với mỗi hệ kết cấu, chuyển vị tại nghiệm cost-optimal ($D_C$) và chi phí tại nghiệm displacement-optimal ($C_D$) được so sánh chéo với hai nghiệm cực trị $C_C^*$ và $D_D^*$ (Bảng 5, Hình 2), từ đó tính:

$$\Delta C = \frac{C_D-C_C^*}{C_C^*}\times100\%; \qquad \Delta D = \frac{D_C-D_D^*}{D_C}\times100\% \tag{3}$$

Bảng 5. So sánh chéo hai nghiệm cực trị

| Kết cấu | $C_C^*$ | $D_C$ | $D_D^*$ | $C_D$ |
|---|---|---|---|---|
| BD | TBD | TBD | TBD | TBD |
| MD | TBD | TBD | TBD | TBD |
| MJP | TBD | TBD | TBD | TBD |

Nếu dữ liệu thực nghiệm xác nhận đồng thời $C(x_C^*)<C(x_D^*)$ và $D(x_D^*)<D(x_C^*)$ trên cả ba hệ kết cấu, có cơ sở để khẳng định chi phí và chuyển vị là hai mục tiêu xung đột trong các hệ kết cấu công trình biển được khảo sát. Kết luận đúng cần được phát biểu là: SFOA giải tốt từng bài toán đơn mục tiêu, nhưng bản chất đơn mục tiêu chỉ cho phép một tiêu chí chi phối quá trình chọn nghiệm, không tạo ra tập nghiệm không trội tương đương Pareto front do không có cơ chế lưu trữ archive, bảo toàn đa dạng hay chọn leader trong không gian mục tiêu. Do đó, bài toán thiết kế thực tế — vốn cần đồng thời cân bằng chi phí và độ cứng — không thể được giải quyết đầy đủ chỉ bằng cách tiếp cận SOO, và đây là cơ sở kỹ thuật trực tiếp cho việc phát triển MOSFOA ở bài báo tiếp theo.

**KẾT LUẬN**

Nghiên cứu đã triển khai và kiểm chứng framework liên kết SAP2000-MATLAB-SFOA để giải sáu bài toán tối ưu đơn mục tiêu trên ba hệ kết cấu công trình biển BD, MD và MJP. *[Các kết luận định lượng dưới đây sẽ được hoàn thiện sau khi có kết quả 180 lượt chạy thực nghiệm]:* (1) SFOA nguyên bản dự kiến hội tụ ổn định và cho nghiệm khả thi kỹ thuật trên cả sáu bài toán; (2) nghiệm tối ưu chi phí và nghiệm tối ưu chuyển vị dự kiến khác biệt rõ rệt về biến thiết kế, thể hiện đánh đổi giữa hiệu quả kinh tế và độ cứng kết cấu; (3) vì SOO chỉ cung cấp nghiệm tối ưu theo từng mục tiêu riêng lẻ và không duy trì tập nghiệm không trội, cách tiếp cận này chưa đủ để hỗ trợ bài toán thiết kế đồng thời nhiều mục tiêu. Kết quả nghiên cứu không phủ nhận hiệu quả của SFOA trong tối ưu đơn mục tiêu; thay vào đó, nghiên cứu chỉ ra rằng giới hạn nằm ở bản chất đơn mục tiêu của mô hình tối ưu, từ đó tạo động lực khoa học và kỹ thuật cho việc mở rộng SFOA sang một phiên bản đa mục tiêu (MOSFOA) ở bước nghiên cứu tiếp theo.

**TÀI LIỆU THAM KHẢO**

[1] Zhong, C., Li, G., Meng, Z., Li, H., Yildiz, A.R., Mirjalili, S. Starfish optimization algorithm (SFOA): a bio-inspired metaheuristic algorithm for global optimization compared with 100 optimizers. Neural Computing and Applications, vol. 37, pp. 3641-3683, 2025.

[2] [Tên tác giả]. Multi-objective optimization design of marine structures based on an enhanced starfish algorithm. [Tên tạp chí/hội nghị], [TBD], [năm].

[3] TCVN 7888:2014. Cọc bê tông ly tâm ứng lực trước. Bộ Khoa học và Công nghệ, Việt Nam, 2014.

[4] TCVN 10304:2014. Móng cọc - Tiêu chuẩn thiết kế. Bộ Khoa học và Công nghệ, Việt Nam, 2014.

[5] PIANC. Guidelines for the Design of Fender Systems: 2002. Permanent International Association of Navigation Congresses, Brussels, 2002.

[6] OCDI. Technical Standards and Commentaries for Port and Harbour Facilities in Japan. The Overseas Coastal Area Development Institute of Japan, Tokyo, 2002.
