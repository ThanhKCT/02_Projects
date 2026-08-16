# Tối ưu hóa Đa mục tiêu Thiết kế Công trình Biển Dựa trên Thuật toán Sao biển Cải tiến

**(Multi-objective Optimization Design of Marine Structures Based on An Enhanced Starfish Algorithm)**

> *Bản dịch tiếng Việt phục vụ Chuyên đề 2, 3 của Luận án Tiến sĩ. Các phần không thể dịch sang tiếng Việt (công thức toán học, hình vẽ, bảng số liệu thô, tài liệu tham khảo) được giữ nguyên như bản gốc tiếng Anh.*

---

## TÓM TẮT (ABSTRACT)

Thiết kế bến cảng (jetty) trên biển là một bài toán đánh đổi có ràng buộc. Việc giảm kích thước cọc, chiều dài cọc, hoặc chi phí xây dựng có thể làm giảm nhu cầu vật liệu, nhưng đồng thời cũng có thể làm tăng chuyển vị và nhu cầu lực cục bộ dưới tác động của tải trọng cập tàu (berthing), tải trọng neo tàu (mooring) và tải trọng khai thác; lựa chọn ngược lại sẽ dịch chuyển sự thỏa hiệp theo hướng khác. Bối cảnh thiết kế này là động lực cho hai phiên bản đa mục tiêu của Thuật toán Tối ưu hóa Sao biển (Starfish Optimization Algorithm - SFOA): phiên bản đa mục tiêu cơ bản (B-MOSFOA) và phiên bản đa mục tiêu cải tiến (E-MOSFOA). B-MOSFOA thích ứng thuật toán SFOA đơn mục tiêu bằng cách bổ sung một kho lưu trữ Pareto (Pareto archive), cơ chế kiểm soát đa dạng dựa trên lưới (grid-based diversity control), và cơ chế lựa chọn thủ lĩnh (leader selection) từ kho lưu trữ. E-MOSFOA duy trì kho lưu trữ ngoài này đồng thời thay đổi động lực tìm kiếm thông qua điều khiển pha theo hàm cosine, đột biến có định hướng thủ lĩnh (leader-guided mutation), và tinh chỉnh giai đoạn cuối. Việc đánh giá được thực hiện trên các bộ bài toán chuẩn (benchmark) IMOP, UF, và RM-MEDA bằng các chỉ số hội tụ và đa dạng, tổng hợp xếp hạng, và kiểm định Wilcoxon rank-sum hai phía với hiệu chỉnh Holm qua 30 lần chạy độc lập cho mỗi bài toán. Thuật toán Tìm kiếm Bọ ngựa Đa mục tiêu (Multi-objective Mantis Search Algorithm - MOMSA), Tối ưu hóa Ngọn lửa Bướm đêm có Sắp xếp Không trội (Non-dominated Sorting Moth-Flame Optimization - NS-MFO), và Tối ưu hóa Phân phối Chuẩn Tổng quát Đa mục tiêu (Multi-objective Generalized Normal Distribution Optimization - MOGNDO) đóng vai trò là các thuật toán so sánh đã công bố, dưới cùng một điều kiện về kích thước quần thể, dung lượng kho lưu trữ, số vòng lặp, và số lần chạy. Tuy nhiên, các quy trình gốc của chúng vẫn giữ tổng số lần đánh giá hàm mục tiêu khác nhau. Không có phương pháp nào là tốt nhất trong mọi trường hợp: MOMSA cho xếp hạng trung bình tổng thể thấp nhất (2.52), tiếp theo là E-MOSFOA (2.58) và B-MOSFOA (2.75), trong khi B-MOSFOA có kết quả tốt nhất trên bộ IMOP theo xếp hạng trung bình (2.28). Nghiên cứu kỹ thuật sau đó áp dụng khung phương pháp này cho một bến cảng chất lỏng rời (liquid-bulk marine jetty) gồm trụ va cập tàu (berthing dolphin), trụ neo tàu (mooring dolphin) và sàn cầu tàu chính (main jetty platform), với MATLAB điều phối các biến thiết kế và SAP2000 đánh giá từng phương án ứng viên. Cải thiện đồng thời lớn nhất xảy ra tại trụ neo tàu, nơi thiết kế Pareto chi phí thấp nhất giảm chi phí 81.5% và chuyển vị lớn nhất 42.4% so với thiết kế hiện trạng. Cả sáu kho lưu trữ cuối cùng đều thỏa mãn các ràng buộc về cường độ, địa kỹ thuật và hình học đã triển khai, với tỷ số sử dụng cọc lớn nhất là 0.9971.

**TỪ KHÓA:** Thiết kế kết cấu; Mô hình hóa phần tử hữu hạn; Cảng, bến, và bến cảng; Cọc và đóng cọc; Tối ưu hóa đa mục tiêu; Thuật toán Tối ưu hóa Sao biển; Trội Pareto (Pareto dominance).

---

## 1. Giới thiệu (Introduction)

Thiết kế công trình cảng, đặc biệt là các bến cảng trên hệ cọc (pile-supported marine jetties), thường liên quan đến nhiều yêu cầu cạnh tranh nhau hơn là một tiêu chí chi phối duy nhất. Việc lựa chọn cọc ngắn hơn hoặc nhỏ hơn có thể làm giảm chi phí xây dựng. Tuy nhiên, điều này cũng có thể làm tăng chuyển vị sàn, mô-men uốn cọc, lực cắt cọc, lực dọc trục cọc, hoặc nguy cơ mũi cọc nằm trong lớp đất không phù hợp. Trong một bến cảng trên hệ cọc, các kiểm tra này không tách biệt nhau. Sự thay đổi đường kính cọc hoặc chiều sâu chôn cọc sẽ làm thay đổi phản ứng của sàn, dầm, và nhóm cọc dưới tải trọng thường xuyên, hoạt tải, tải va cập tàu, và tải neo tàu; cùng một bố trí kết cấu sau đó phải thỏa mãn các kiểm tra công trình cảng và nền móng cọc liên quan. Vì lý do này, các hướng dẫn thiết kế cho các tác động như tải va cập tàu và neo tàu, khả năng chịu lực của nền móng cọc, và cấu tạo kết cấu công trình biển thường được lấy từ PIANC [1], OCDI [2], TCVN 7888:2014 [3], và TCVN 10304:2014 [4]. Vì lý do này, thiết kế bến cảng trên biển được xây dựng thành một tập hợp các phương án thỏa hiệp khả thi thay vì một điểm tối ưu duy nhất được quy định trước.

Tối ưu hóa đa mục tiêu phù hợp với bài toán thiết kế này bởi vì các phương án phải được đánh giá dựa trên nhiều tiêu chí cạnh tranh nhau thay vì một hàm mục tiêu tổng trọng số cố định duy nhất. Trội Pareto (Pareto dominance) cung cấp một cơ sở phù hợp hơn để so sánh các phương án như vậy. Các khái niệm về tập Pareto (Pareto Set - $PS$), biên Pareto (Pareto Front - $PF$), và quan hệ trội mô tả các tình huống mà việc cải thiện một mục tiêu có thể đòi hỏi sự thỏa hiệp ở mục tiêu khác [5-7]. Trong bối cảnh kỹ thuật hiện tại, chi phí, chuyển vị, nội lực thành phần, và khả năng chịu lực của nền móng cọc thường không biến đổi cùng một hướng. Do đó, công thức tối ưu hóa đa mục tiêu rất phù hợp cho bài toán tối ưu hóa kết cấu, trong đó mỗi phương án ứng viên được đánh giá bằng mô hình phân tích. Đồng thời, các ràng buộc về khả năng sử dụng (serviceability), cường độ (strength), và nền móng địa kỹ thuật được xem xét đồng thời [8].

Các thuật toán metaheuristic dựa trên quần thể (population-based metaheuristics) được sử dụng rộng rãi cho các bài toán kết cấu phi tuyến và nhiều chiều bởi vì chúng có thể tìm kiếm mà không cần thông tin đạo hàm và có thể làm việc với các mô hình phần tử hữu hạn (Finite Element Models - FEM) dạng hộp đen [9-12]. Các thuật toán đa mục tiêu gần đây minh họa các cách khác nhau để bảo toàn tính hội tụ và đa dạng. NS-MFO kết hợp tìm kiếm ngọn lửa bướm đêm với sắp xếp không trội và bao gồm các đánh giá trên bài toán chuẩn và bài toán kỹ thuật [13]. MOMSA kết hợp tìm kiếm bọ ngựa với sắp xếp không trội ưu tú (elitist non-dominated sorting) và khoảng cách chen chúc (crowding distance); đánh giá gốc của nó bao gồm 20 bài toán chuẩn, chín bài toán thiết kế kỹ thuật, và các trường hợp phân bố công suất tối ưu [14]. MOGNDO sử dụng kho lưu trữ ngoài, kiểm soát đa dạng dựa trên lưới, và lựa chọn thủ lĩnh dựa trên kho lưu trữ, với các đánh giá được báo cáo trên 35 trường hợp toán học và kỹ thuật [9]. Tiến hóa Vi phân (Differential Evolution) cũng vẫn là một tài liệu tham khảo quan trọng cho các toán tử đột biến và lai ghép trong tìm kiếm dựa trên quần thể [15]. Cùng nhau, các nghiên cứu này cho thấy rằng việc quản lý kho lưu trữ, lựa chọn thủ lĩnh, chiến lược sắp xếp, và các toán tử biến đổi ảnh hưởng mạnh mẽ đến chất lượng xấp xỉ $PF$.

Tuy nhiên, đối với các ứng dụng tối ưu hóa kết cấu thực tế phức tạp, hiệu năng tìm kiếm thuật toán phải được hỗ trợ bởi một quy trình phân tích nhất quán và đáng tin cậy. Các quy trình như vậy có thể kết hợp trực tiếp phần mềm phân tích với các thuật toán tối ưu hóa hoặc sử dụng các mô hình trí tuệ nhân tạo, học máy, và mô hình thay thế (surrogate models) để xấp xỉ phản ứng kết cấu. Các ví dụ bao gồm tối ưu hóa dựa trên mô hình thay thế của khung bê tông cốt thép ba chiều được phân tích bằng SAP2000 [16] và một mô hình thay thế mạng nơ-ron thông tin vật lý (physics-informed neural-network) được huấn luyện bằng dữ liệu SAP2000 kết hợp với tìm kiếm bầy đàn [17]. Trong nghiên cứu này, SAP2000, một chương trình phân tích đáng tin cậy được áp dụng cho các hệ kết cấu với vật liệu và cấu hình khác nhau [18, 19], được chọn làm nền tảng phân tích phần tử hữu hạn. Theo cách này, MATLAB được kết nối trực tiếp với SAP2000 [10, 20-22] thông qua các hàm của SM Toolbox [23] để điều khiển chương trình và trao đổi dữ liệu phân tích. MATLAB quản lý các biến thiết kế và quá trình tìm kiếm B-MOSFOA/E-MOSFOA, trong khi SAP2000 trả về các phản ứng cần thiết để đánh giá các mục tiêu và ràng buộc. Do đó, việc triển khai hiện tại sử dụng phân tích trực tiếp thay vì mô hình thay thế trí tuệ nhân tạo hoặc học máy.

SFOA [24] ban đầu được phát triển như một phương pháp đơn mục tiêu dựa trên hành vi tìm kiếm lấy cảm hứng từ sao biển. Việc áp dụng trực tiếp nó cho bài toán thiết kế kết cấu công trình biển hiện tại bị hạn chế vì nó thiếu một số thành phần cần thiết để xử lý các mục tiêu cạnh tranh, bao gồm một kho lưu trữ các nghiệm không trội, một cơ chế để duy trì biên Pareto phân bố tốt, và một quy tắc để lựa chọn các thủ lĩnh tìm kiếm từ các ứng viên chất lượng cao. Vì lý do này, hai phiên bản cải tiến được xem xét. B-MOSFOA thiết lập cấu trúc đa mục tiêu cơ bản bằng cách kết hợp trội Pareto, kho lưu trữ ngoài, quản lý đa dạng dựa trên lưới, và lựa chọn thủ lĩnh xuất phát từ kho lưu trữ. E-MOSFOA sau đó được xây dựng dựa trên phiên bản này bằng cách đưa vào lấy mẫu siêu khối Latin (Latin hypercube sampling) ở giai đoạn khởi tạo, các pha tìm kiếm điều chỉnh theo hàm cosine, đột biến có định hướng thủ lĩnh, lai ghép, và một quy trình tinh chỉnh dựa trên kho lưu trữ gần cuối quá trình tối ưu hóa.

Việc kiểm định các thuật toán đề xuất cần bao quát nhiều hơn một họ bài toán vì không có thuật toán nào là tốt nhất một cách đồng nhất trên mọi lớp bài toán, theo định lý "Không có bữa trưa miễn phí" (No Free Lunch - NFL) [25]. Vì lý do này, nghiên cứu này sử dụng bộ bài toán chuẩn IMOP [26], bộ bài toán kiểm tra UF từ cuộc thi đa mục tiêu CEC 2009 [27], và các hàm kiểm tra RM-MEDA gắn với khung ước lượng phân phối đa mục tiêu dựa trên mô hình tính đều đặn (regularity model) [28]; cùng nhau, các bộ bài toán này cung cấp các hình dạng $PF$, tương tác biến quyết định, và cài đặt khả năng mở rộng (scalability) khác nhau. Chất lượng nghiệm cũng không thể được tóm tắt bằng một chỉ số duy nhất. Do đó, $IGD$, $\epsilon$, $\Delta$, và $MS$ được sử dụng để đo độ chính xác hội tụ, chất lượng xấp xỉ, tính đồng đều phân bố, và độ bao phủ đa dạng từ các góc nhìn bổ sung cho nhau [6, 29-32]. Các giá trị chỉ số này được bổ sung thêm bởi tổng hợp xếp hạng và kiểm định Wilcoxon rank-sum hai phía với hiệu chỉnh Holm [33-36]. Nói cách khác, các bộ bài toán chuẩn, chỉ số, xếp hạng, và lựa chọn kiểm định thống kê này cung cấp một cơ sở rộng hơn để đánh giá liệu các biến thể MOSFOA có cải thiện chỉ ở các trường hợp riêng lẻ hay vẫn duy trì tính cạnh tranh trên các cấu trúc bài toán khác nhau.

Tổng thể, nghiên cứu đánh giá liệu B-MOSFOA và E-MOSFOA có cung cấp một khung phương pháp thực tiễn cho tối ưu hóa đa mục tiêu có ràng buộc trong thiết kế bến cảng biển hay không. Ở cấp độ bài toán chuẩn, IMOP, UF, và RM-MEDA được sử dụng để so sánh hai biến thể với MOMSA, NS-MFO, và MOGNDO dưới cùng điều kiện về kích thước quần thể, dung lượng kho lưu trữ, số vòng lặp, và số lần chạy, trong khi vẫn giữ tổng số lần đánh giá hàm đặc trưng riêng của từng thuật toán; các chỉ số nghiệm, xếp hạng, kiểm định Wilcoxon-Holm, nỗ lực tính toán, và độ nhạy tham số cung cấp các bằng chứng bổ sung cho nhau. Ở cấp độ kỹ thuật, quy trình kết hợp MATLAB-SAP2000 tối thiểu hóa chi phí xây dựng và chuyển vị lớn nhất cho ba hệ con của bến cảng, trong khi các yêu cầu về cường độ, địa kỹ thuật, và hình học vẫn là các ràng buộc tường minh. Toàn bộ trình tự, từ công thức hóa phương pháp luận đến đánh giá bài toán chuẩn và đánh giá kỹ thuật, được tóm tắt trong [Hình A1.](#_Ref234868514) Mục [2](#_Ref234855228) mô tả các phương pháp, Mục [3](#_Ref234855239) trình bày nghiên cứu bài toán chuẩn, Mục [4](#_Ref234855250) khảo sát ứng dụng kỹ thuật, và Mục [5](#_Ref235084474) đưa ra các kết luận, hạn chế, và hướng phát triển tương lai.

---

## 2. Phương pháp luận (Methodology)

### 2.1. Cơ sở của Tối ưu hóa Đa mục tiêu (Foundations of Multi-objective Optimization)

Tối ưu hóa đa mục tiêu giải quyết các bài toán liên quan đến nhiều mục tiêu xung đột nhau, trong đó việc cải thiện một tiêu chí có thể làm suy giảm các tiêu chí khác [5, 37, 38]. Khái niệm hiệu quả (efficiency) nền tảng bắt nguồn từ Edgeworth và Pareto [39, 40], trong khi các công thức dựa trên ràng buộc cung cấp một giải pháp thay thế cho việc quy giản tất cả các mục tiêu về một tổng trọng số cố định [41]. Không giống như tối ưu hóa đơn mục tiêu, vốn tìm kiếm một điểm tối ưu duy nhất, tối ưu hóa đa mục tiêu nhằm xác định một tập hợp các nghiệm thỏa hiệp tạo thành $PS$ và $PF$ tương ứng [6]. Một nghiệm được gọi là trội một nghiệm khác nếu nó không tệ hơn ở tất cả các mục tiêu và tốt hơn hẳn ở ít nhất một mục tiêu. Các nghiệm không trội tạo thành $PS$, trong khi ánh xạ của chúng trong không gian mục tiêu tạo thành $PF$ [7].

$$\underset{\mathbf{X}}{Minimize}{F\left( \mathbf{X} \right)} = \left\{ f_{1}\left( \mathbf{X} \right),f_{2}\left( \mathbf{X} \right),\ldots,f_{m}\left( \mathbf{X} \right) \right\},\quad (1)$$

trong đó $\mathbf{X}$ biểu thị véc-tơ thiết kế, $f_{m}\left( \mathbf{X} \right)$ là mục tiêu thứ $m$, và $m$ là số lượng mục tiêu. Các mục tiêu được giữ dưới dạng véc-tơ để các phương án cạnh tranh có thể được so sánh thông qua trội Pareto. Điều này tránh việc gán một tập trọng số cố định trước khi tìm kiếm, điều có thể nén các thỏa hiệp thiết kế thành một mục tiêu vô hướng duy nhất.

Một $PF$ hữu ích không chỉ là một tập hợp các điểm gần với giá trị tối ưu; nó còn cần đủ độ trải rộng để so sánh thiết kế. Điều này trở nên khó khăn khi không gian tìm kiếm phi tuyến, gián đoạn, hoặc nhiều chiều. Trong bài toán bến cảng, một quá trình tìm kiếm dịch chuyển quá mạnh về phía chi phí có thể lấp đầy kho lưu trữ bằng các bố trí chi phí thấp tương tự nhau. Ngược lại, một quá trình tìm kiếm trải rộng quá mức có thể bỏ lỡ các thiết kế cứng hơn nhưng vẫn có giá thành hợp lý. Do đó, thuật toán giữ các thiết kế không trội trong một kho lưu trữ ngoài, chọn các thủ lĩnh từ các vùng ít mật độ hơn, và tinh chỉnh các vùng triển vọng sau khi biên trở nên ổn định hơn. Trong bối cảnh này, B-MOSFOA cung cấp một cấu trúc dựa trên kho lưu trữ, trong khi E-MOSFOA tăng cường cấu trúc này thông qua tìm kiếm thích ứng và tinh chỉnh giai đoạn cuối.

### 2.2. Đề xuất B-MOSFOA (Proposed B-MOSFOA)

B-MOSFOA giữ nguyên các phương trình chuyển động của SFOA [24] nhưng thay đổi cách một ứng viên được đánh giá sau khi các giá trị mục tiêu của nó được xác định. Trong SFOA đơn mục tiêu, một giá trị độ thích nghi (fitness) duy nhất là đủ để xác định nghiệm tốt nhất hiện tại. Trong bài toán đa mục tiêu hiện tại, mỗi thiết kế cho ra một véc-tơ giá trị mục tiêu, do đó thuật toán trước tiên kiểm tra trội Pareto [5-7] và đặt các thiết kế còn tồn tại vào một kho lưu trữ ngoài, phù hợp với các phương pháp tiến hóa dựa trên kho lưu trữ đã được thiết lập [42-44]. Kho lưu trữ này không được xử lý như một danh sách đơn giản các điểm tốt. Theo cơ chế kiểm soát đa dạng dựa trên kho lưu trữ được sử dụng trong các thuật toán metaheuristic đa mục tiêu gần đây [9], nó được chia thành các ô lưới (grid cells) trong không gian mục tiêu, và các thành viên kho lưu trữ từ các ô có ít nghiệm hơn sẽ có khả năng được sử dụng làm thủ lĩnh cao hơn. Kết quả là, các phần bị cô lập của biên thỏa hiệp vẫn có thể định hướng bước tiếp theo trong chuyển động, thay vì bị mất đi phía sau các nhóm nghiệm tương tự dày đặc.

Bước cập nhật vị trí tuân theo hành vi tìm kiếm gốc của SFOA nhưng được đánh giá trong bối cảnh đa mục tiêu. Một tham số điều khiển xác suất phân công mỗi vòng lặp cho khai phá (exploration) hoặc khai thác (exploitation). Trong khai phá, B-MOSFOA sử dụng quy tắc xoắn-cánh-tay (arm-twist rule) cho các cập nhật chiều cao và quy tắc bước-năng-lượng (energy-step rule) cho chuyển động chiều thấp hơn. Trong khai thác, các vị trí ứng viên được cập nhật bằng quy tắc săn mồi (preying rule), và tái sinh (regeneration) được áp dụng cho cá thể cuối cùng để làm mới quần thể. Trước khi đánh giá mục tiêu, bất kỳ tọa độ nào ngoài giới hạn được trả về giá trị trước đó của nó, sau đó toàn bộ véc-tơ ứng viên được chiếu lên khoảng biến cho phép.

$$\mathbf{Y}_{i} = \mathbf{X}_{i} + a_{1}\left( X_{leader} - X_{i} \right) \cdot \left\{ \begin{matrix} \cos(\theta),\ \ \ r \leq 0.5 \\ \sin(\theta),\ \ \ r > 0.5 \end{matrix} \right.\ ,\quad (2)$$

$$\mathbf{Y}_{i} = E{\bullet \mathbf{X}}_{i} + A_{1} \bullet \left( \mathbf{X}_{k_{1}} - \mathbf{X}_{i} \right) + A_{2} \bullet \left( \mathbf{X}_{k_{2}} - \mathbf{X}_{i} \right),\quad (3)$$

$$\mathbf{Y}_{i} = \mathbf{X}_{i} + r_{1}d_{m1} + r_{2}d_{m2},\quad (4)$$

$$d_{m} = \mathbf{X}_{leader} - \mathbf{X}_{m}\ (\forall m = 1,...,5),\quad (5)$$

$$\mathbf{Y}_{N} = e^{\left( - \frac{it \times N}{Max\_ it}\  \right)}\mathbf{X}_{N}.\quad (6)$$

Các phương trình (2)-(6) thích ứng các quy tắc cập nhật vị trí của SFOA [24] cho bối cảnh đa mục tiêu định hướng bởi kho lưu trữ. Các phương trình (2) và (3) xây dựng các vị trí thử khai phá, trong khi các phương trình (4) và (5) di chuyển các ứng viên tương ứng với các cá thể lân cận và thủ lĩnh kho lưu trữ được chọn. Phương trình (6) đưa ra quy tắc tái sinh cho cá thể cuối cùng. Trong các phương trình này, $\mathbf{X}_{i}$ và $\mathbf{Y}_{i}$ là các véc-tơ vị trí hiện tại và vị trí thử của ứng viên $i$; $\mathbf{X}_{leader}$ là thủ lĩnh kho lưu trữ được chọn; $\mathbf{X}_{k1}$, $\mathbf{X}_{k2}$, và $\mathbf{X}_{m}$ là các thành viên quần thể được lấy mẫu; $a_{1}$, $E$, $A_{1}$, và $A_{2}$ là các hệ số chuyển động của SFOA; $\theta$ là tham số góc; $r$, $r_{1}$, và $r_{2}$ là các số ngẫu nhiên; $d_{m}$, $d_{m1}$ và $d_{m2}$ là các véc-tơ hướng; $N$ là kích thước quần thể; và $it$/$Max\_it$ chỉ tiến trình của lần chạy hiện tại.

Sau khi quần thể mới được đánh giá, các thành viên không trội của nó được kết hợp với kho lưu trữ hiện tại. Các thành viên kho lưu trữ bị trội bị loại bỏ. Nếu kho lưu trữ vượt quá dung lượng quy định, phép cắt bớt theo khoảng cách chen chúc (crowding-distance truncation) loại bỏ các ứng viên từ các phần dày đặc của biên trước khi lưới thích ứng được xây dựng lại. Mật độ ô sau đó xác định xác suất lựa chọn thủ lĩnh theo phương trình (7); các ô có mật độ thưa thớt nhận xác suất lớn hơn và do đó đóng góp thường xuyên hơn với vai trò thủ lĩnh tìm kiếm.

$$P_{i} = \frac{c}{N_{i}},\quad (7)$$

trong đó $N_{i}$ là mật độ của ô lưới $i$, $c$ là hằng số chuẩn hóa, và $P_{i}$ là xác suất lựa chọn một thành viên từ ô đó. Quan hệ nghịch mật độ cho các ô có mật độ thưa thớt xác suất lựa chọn lớn hơn.

### 2.3. Đề xuất E-MOSFOA (Proposed E-MOSFOA)

E-MOSFOA được xây dựng dựa trên logic chuyển động của SFOA [24] và cấu trúc kho lưu trữ Pareto được sử dụng trong B-MOSFOA [5-7]. Nó đưa vào các cơ chế thích ứng để cải thiện tính hội tụ và phân bố nghiệm trong khi vẫn duy trì chi phí tính toán thấp. Đầu tiên, lấy mẫu siêu khối Latin (Latin hypercube sampling) [45] tạo ra quần thể ban đầu trong giới hạn biến quyết định quy định và cung cấp độ bao phủ phân tầng của mỗi chiều biến quyết định. Sau đó, một lịch trình dựa trên hàm cosine thay thế xác suất khai phá cố định, giảm dần một cách trơn tru về 0, nhấn mạnh khai phá toàn cục ở giai đoạn đầu, và dần dần chuyển nỗ lực sang khai thác.

$$GP = \frac{GP_{0}}{2}\left( {1 + cos}\left( \pi \bullet \frac{it}{Max\_ it}\  \right) \right)\ \ \ \quad (8)$$

Phương trình (8) làm giảm xác suất khai phá $GP$ một cách trơn tru từ $GP_{0}$ về 0 khi $it$ tiến đến $Max\_it$, nhờ đó tránh sự chuyển đổi đột ngột giữa khai phá và khai thác.

Trong quá trình khai phá, E-MOSFOA bổ sung chuyển động SFOA bằng đột biến Tiến hóa Vi phân có định hướng thủ lĩnh (leader-guided Differential Evolution mutation) và lai ghép nhị thức (binomial crossover) [15], như định nghĩa trong các phương trình (9)-(11). Trong quá trình khai thác, một nhiễu Gauss riêng biệt được kích hoạt với xác suất 0.1 và sử dụng 1% khoảng biến quyết định làm tỷ lệ độ lệch chuẩn. Tất cả các véc-tơ thử được chiếu lên giới hạn quy định trước khi đánh giá mục tiêu.

$${mutant}_{i} = \mathbf{X}_{r1} + F \bullet \left( \mathbf{X}_{r2} - \mathbf{X}_{r3} \right) + \lambda \bullet \left( \mathbf{X}_{leader} - \mathbf{X}_{r1} \right),\quad (9)$$

$$F = 0.5\left( 1 - \frac{it}{Max\_ it} \right),\quad (10)$$

$$Y_{i,j} = \left\{ \begin{matrix} {mutant}_{i,j}, & r_{i,j} < CR, \\ X_{i,j}, & \text{ngược lại}, \end{matrix} \right.\ \quad\quad CR = 0.5\quad (11)$$

Phương trình (9) kết hợp véc-tơ sai khác Tiến hóa Vi phân với sự hấp dẫn về phía $\mathbf{X}_{leader}$. Trong biểu thức này, $\mathbf{X}_{r1}$, $\mathbf{X}_{r2}$, và $\mathbf{X}_{r3}$ là các thành viên quần thể được lấy mẫu riêng biệt, ${mutant}_i$ là véc-tơ đột biến thử, $F$ là tỷ lệ đột biến, và $\lambda = 0.3$ là hệ số hấp dẫn thủ lĩnh. Phương trình (10) làm giảm $F$ từ 0.5 về 0. Phương trình (11) đưa ra phép lai ghép nhị thức theo từng thành phần, trong đó $j$ là chỉ số biến quyết định và $r_{i,j} \sim U(0,1)$; tọa độ đột biến được chọn khi $r_{i,j} < CR$, với $CR = 0.5$.

Đối với tăng cường cục bộ (local intensification), thuật toán chọn một thành viên tham chiếu trong kho lưu trữ bằng tổng không trọng số của các giá trị mục tiêu. Trong 20% số vòng lặp cuối cùng, nhiễu Gauss tái sinh 10% quần thể xung quanh thành viên tham chiếu này. Điều quan trọng là, thành viên tham chiếu chỉ đóng vai trò là tâm tìm kiếm cục bộ; trội Pareto và kho lưu trữ ngoài vẫn chi phối việc giữ lại nghiệm cuối cùng.

$$\mathbf{X}^{*} = argmin\left( \sum_{j = 1}^{M}{f_{i,j}\ } \right)\ \ \ \ \quad (12)$$

$$\mathbf{Y}_{i} = \mathbf{X}^{*} + \sigma \bullet N(0,\sigma^{2})\ \ \ \ \quad (13)$$

Phương trình (12) chọn thành viên tham chiếu kho lưu trữ được sử dụng làm tâm tìm kiếm cục bộ trong bước tinh chỉnh dựa trên kho lưu trữ [9]. Tại đây, $\mathbf{X}^{*}$ là thành viên tham chiếu được chọn, $k$ là chỉ số thành viên kho lưu trữ, $i$ là chỉ số mục tiêu, và $f_{k,i}$ là giá trị của mục tiêu $i$ cho thành viên kho lưu trữ $k$. Phương trình (13) tạo ra các điểm thử giai đoạn cuối thông qua nhiễu Gauss, trong đó $\sigma$ là tỷ lệ và $N\left( 0,\sigma^{2} \right)$ biểu thị véc-tơ ngẫu nhiên chuẩn trung bình 0. Thành viên tham chiếu không thay thế trội Pareto [5-7] với vai trò quy tắc giữ lại nghiệm cuối cùng.

+-----------------------------------------------------------------------+
| ![](media/image2.svg){width="6.415534776902887in" height="3.239316491688539in"} |
+=======================================================================+
| **Hình 1.** Quy trình thuật toán của B-MOSFOA và E-MOSFOA đề xuất. |
+-----------------------------------------------------------------------+

Thuật toán 1 tóm tắt toàn bộ quy trình của B-MOSFOA và E-MOSFOA, bao gồm khởi tạo quần thể, cập nhật kho lưu trữ, lựa chọn thủ lĩnh, cập nhật chuyển động, và các toán tử thích ứng bổ sung được sử dụng trong E-MOSFOA. Hình 1 cung cấp một biểu diễn trực quan của quy trình này và làm rõ cách vòng lặp tối ưu hóa chính, các thao tác kho lưu trữ, và các bước tinh chỉnh đặc thù của E-MOSFOA được kết nối trong quá trình thực thi.

**Thuật toán 1. Mã giả (Pseudo-code) của B-MOSFOA và E-MOSFOA**

**Đầu vào (Input):**

Véc-tơ mục tiêu $\mathbf{F}\left( \mathbf{X} \right) = \left\{ f_{1}\left( \mathbf{X} \right),\ ...,\ f_{M}\left( \mathbf{X} \right) \right\}$, số hạng phạt $P\left( \mathbf{X} \right)$ theo phương trình (23),

giới hạn $\left\lbrack l_{b},\ u_{b} \right\rbrack$, kích thước quần thể $N$, số vòng lặp tối đa $Max\_it$,

dung lượng kho lưu trữ $N_{r}$, kích thước lưới $n_{grid}$, và xác suất khai phá ban đầu $GP_{0}$.

**Đầu ra (Output):**

Kho lưu trữ ngoài cuối cùng $A_f$ của các thiết kế không trội được giữ lại.

Khởi tạo quần thể $Pop = \left\{ \mathbf{X}_{i} \right\}_{i=1}^{N}$ trong $\left\lbrack l_{b},\ u_{b} \right\rbrack$.

  - B-MOSFOA: dùng lấy mẫu ngẫu nhiên đều.
  - E-MOSFOA: dùng lấy mẫu siêu khối Latin.

Đánh giá $\mathbf{F}\left( \mathbf{X}_{i} \right)$ và $P\left( \mathbf{X}_{i} \right)$ cho mọi $\mathbf{X}_{i} \in Pop$.

Khởi tạo kho lưu trữ $A$ sau khi xử lý ràng buộc và xét trội Pareto.

Xây dựng cấu trúc lưới thích ứng và khoảng cách chen chúc cho kho lưu trữ $A$.

**for** $it = 1$ đến $Max\_it$ **do**

&nbsp;&nbsp;Đặt xác suất khai phá $GP$.

&nbsp;&nbsp;- B-MOSFOA: đặt $GP = GP_0$ như trong cài đặt SFOA cơ bản.
&nbsp;&nbsp;- E-MOSFOA: cập nhật $GP$ theo quy tắc điều khiển pha cosine trong phương trình (8).

&nbsp;&nbsp;Chọn $\mathbf{X}_{leader}$ từ vùng lưới/chen chúc thưa của $A$.

&nbsp;&nbsp;**for** mỗi ứng viên $\mathbf{X}_{i} \in Pop$ **do**

&nbsp;&nbsp;&nbsp;&nbsp;**if** rand $< GP$ **then**

&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Tạo véc-tơ thử $\mathbf{Y}_{i}$ bằng các quy tắc khai phá SFOA trong phương trình (2)-(3).

&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;**if** dùng E-MOSFOA **then**

&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Tạo ${mutant}_i$ và cập nhật $\mathbf{Y}_i$ bằng đột biến định hướng thủ lĩnh và lai ghép nhị thức theo phương trình (9)-(11).

&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;**end if**

&nbsp;&nbsp;&nbsp;&nbsp;**else**

&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Tạo véc-tơ thử $\mathbf{Y}_i$ bằng các quy tắc khai thác SFOA trong phương trình (4)-(6).

&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;**if** dùng E-MOSFOA **then**

&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Áp dụng nhiễu Gauss thích ứng khi được kích hoạt.

&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;**end if**

&nbsp;&nbsp;&nbsp;&nbsp;**end if**

&nbsp;&nbsp;&nbsp;&nbsp;Áp dụng xử lý biên.

&nbsp;&nbsp;**end for**

&nbsp;&nbsp;Đánh giá $\mathbf{F}(\mathbf{X}_i)$ và $P(\mathbf{X}_i)$ cho quần thể $Pop$ đã cập nhật.

&nbsp;&nbsp;Kết hợp $Pop$ với $A$ và cập nhật $A$ bằng xử lý ràng buộc, xét trội Pareto, cắt bớt theo khoảng cách chen chúc, và đánh chỉ số lưới thích ứng theo phương trình (7).

&nbsp;&nbsp;**if** dùng E-MOSFOA và $it \geq 0.8 Max\_it$ **then**

&nbsp;&nbsp;&nbsp;&nbsp;Chọn thành viên tham chiếu kho lưu trữ $\mathbf{X}^{*}$ theo phương trình (12).

&nbsp;&nbsp;&nbsp;&nbsp;Tinh chỉnh các ứng viên theo phương trình (13).

&nbsp;&nbsp;&nbsp;&nbsp;Chiếu các ứng viên đã tinh chỉnh về $\left\lbrack l_{b},\ u_{b} \right\rbrack$, đánh giá chúng, và cập nhật $A$.

&nbsp;&nbsp;**end if**

**end for**

**return** $A$

---

Bậc tính toán của cả hai biến thể chủ yếu được chi phối bởi cập nhật quần thể, đánh giá mục tiêu, cập nhật kho lưu trữ, kiểm tra trội, và cắt bớt kho lưu trữ. Với kích thước quần thể $N$, số chiều biến quyết định $D$, số chiều mục tiêu $M$, dung lượng kho lưu trữ $N_r$, và chi phí đánh giá mục tiêu $C_f$, các thao tác chi phối là $O(ND)$, $O(NC_f)$, $O\left( \left( N + N_{r} \right)2M \right)$, và $O\left( MN_{r}\log N_{r} \right)$ tương ứng. Các toán tử thích ứng được đưa vào trong E-MOSFOA chỉ thêm các thao tác cấp quần thể tuyến tính trong mỗi vòng lặp và không làm thay đổi bậc tiệm cận so với B-MOSFOA. Do đó, thời gian chạy thực tế được báo cáo riêng trong phần bài toán chuẩn vì nó cũng phụ thuộc vào cách triển khai hàm mục tiêu và môi trường tính toán.

---

## 3. Thiết lập Thực nghiệm và Kết quả Bài toán Chuẩn (Experimental Setup and Benchmark Results)

### 3.1. Các Bộ Bài toán Chuẩn và Chỉ số Đánh giá Hiệu năng (Benchmark Suites and Performance Metrics)

Việc đánh giá bài toán chuẩn dựa trên ba bộ bài toán kiểm tra đã được thiết lập: IMOP [26], UF [27], và RM-MEDA [28]. Các bộ bài toán này bao gồm các bài toán hai và ba mục tiêu, không gian biến quyết định 10 và 30 chiều, và một số hình dạng biên Pareto cùng các dạng liên kết biến khác nhau. Do đó, các bài toán được lựa chọn cung cấp các điều kiện bổ sung cho nhau để đánh giá tính hội tụ, phân bố, và khả năng bảo toàn đa dạng. [Bảng 1](#_Ref105764331) tóm tắt số chiều mục tiêu, số chiều biến quyết định, khoảng tìm kiếm, và nguồn tham khảo cho từng nhóm bài toán chuẩn.

**Bảng 1. Các bộ bài toán chuẩn (Benchmark suites).**

| Bài toán | Số mục tiêu ($M$) | Số biến ($D$) | Khoảng | Tài liệu tham khảo |
|---|---|---|---|---|
| IMOP1-3 | 2 | 30 | $x_{i} \in \lbrack 0,1\rbrack$ | [26] |
| IMOP4-8 | 3 | 10 | $x_{i} \in \lbrack 0,1\rbrack$ | [26] |
| UF1,2 | 2 | 30 | $x_{i} \in \lbrack -1,1\rbrack$ | [27] |
| UF3 | 2 | 30 | $x_{i} \in \lbrack 0,1\rbrack$ | [27] |
| UF4 | 2 | 30 | $x_{1} \in \lbrack 0,1\rbrack$ & $x_{i=2..D} \in \lbrack -2,2\rbrack$ | [27] |
| UF5-7 | 2 | 30 | $x_{1} \in \lbrack 0,1\rbrack$ & $x_{i=2..D} \in \lbrack -1,1\rbrack$ | [27] |
| UF8-9 | 3 | 30 | $x_{1,2} \in \lbrack 0,1\rbrack$ & $x_{i=3..D} \in \lbrack -2,2\rbrack$ | [27] |
| RM-MEDA-P1,2,3,5,6,7 | 2 | 10 | $x_{1} \in \lbrack 0,1\rbrack$ | [28] |
| RM-MEDA-P9 | 2 | 10 | $x_{1} \in \lbrack 0,1\rbrack$ & $x_{i=2..D} \in \lbrack 0,10\rbrack$ | [28] |
| RM-MEDA-P4,8 | 3 | 10 | $x_{1} \in \lbrack 0,1\rbrack$ | [28] |

Bốn chỉ số được sử dụng vì một chỉ số duy nhất không thể mô tả mọi khía cạnh của phép xấp xỉ $PF$. $IGD$ [29] và $\varepsilon$ [30] chủ yếu phản ánh độ chính xác hội tụ hoặc xấp xỉ, $\Delta$ [6] mô tả tính đồng đều phân bố, và $MS$ [6] mô tả mức độ bao phủ của biên. Hướng ưu tiên được báo cáo trong [Bảng 2](#_Ref202951888): $IGD$, $\varepsilon$, $\Delta$ được tối thiểu hóa, trong khi $MS$ được tối đa hóa. Các hướng chỉ số này được sử dụng nhất quán trong tất cả các xếp hạng, so sánh thống kê, và số liệu tổng hợp.

Một quy trình thực nghiệm chung được sử dụng cho tất cả các so sánh bài toán chuẩn. Bộ thuật toán so sánh gồm NS-MFO [13], MOMSA [14], và MOGNDO [9], đại diện tương ứng cho sắp xếp không trội, sắp xếp khoảng cách chen chúc ưu tú, và lựa chọn thủ lĩnh dựa trên lưới kho lưu trữ. Tất cả các thuật toán sử dụng cùng định nghĩa bài toán, kích thước quần thể 100, số vòng lặp tối đa 500, và 30 lần chạy độc lập cho mỗi bài toán. Các thuật toán có kho lưu trữ ngoài sử dụng dung lượng kho lưu trữ 200. Đối với cả B-MOSFOA và E-MOSFOA, $N_{r} = 200$, $n_{grid} = 10$; và $GP_{0} = 0.5$. Các cài đặt này tạo thành đường cơ sở (baseline) bài toán chuẩn chính, và độ nhạy của chúng được khảo sát riêng.

**Bảng 2. Các chỉ số đánh giá hiệu năng (Performance metrics).**

| Chỉ số | Đo lường | Mục đích | Giá trị ưu tiên | Tài liệu tham khảo |
|---|---|---|---|---|
| $\varepsilon$ | Độ dịch chuyển tối thiểu để trội biên tham chiếu | Hội tụ | Thấp | [30] |
| $IGD$ | Khoảng cách trung bình từ biên tham chiếu đến phép xấp xỉ | Hội tụ và Đa dạng | Thấp | [29] |
| $\Delta$ | Sự đồng đều khoảng cách giữa các nghiệm liên tiếp | Phân bố | Thấp | [46] |
| $MS$ | Mức độ bao phủ lớn nhất trong không gian mục tiêu | Đa dạng | Cao | [46] |

Đối với mỗi bài toán và chỉ số, Tốt nhất (Best), Trung bình (Mean), và Độ lệch chuẩn (Std) được thu được từ 30 lần chạy độc lập. Giá trị Trung bình được sử dụng để xếp hạng, trong khi Std chỉ được diễn giải như một thước đo ổn định giữa các lần chạy. Vì các mẫu từ các thuật toán khác nhau là độc lập, các kiểm định Wilcoxon rank-sum hai phía được sử dụng [33-35], tiếp theo là hiệu chỉnh Holm trên bốn so sánh cặp trong mỗi họ bài toán-chỉ số ở mức $\alpha = 0.05$ [36]. Trong các bảng chi tiết, các ký hiệu Wilcoxon-Holm được viết với E-MOSFOA là tham chiếu: +, -, và = có nghĩa là E-MOSFOA tốt hơn, tệ hơn, hoặc không khác biệt có ý nghĩa thống kê so với thuật toán được so sánh, tương ứng; Ref. đánh dấu cột tham chiếu E-MOSFOA. Tương tự, W/D/L (Thắng/Hòa/Thua) trong Bảng 4 cho biết số trường hợp mà thuật toán được liệt kê tốt hơn, không khác biệt có ý nghĩa, hoặc tệ hơn E-MOSFOA về mặt thống kê.

### 3.2. Tổng hợp Bài toán Chuẩn và Chi phí Tính toán (Benchmark Summary and Computational Cost)

Bằng chứng bài toán chuẩn được diễn giải từ hai góc nhìn bổ sung cho nhau: nỗ lực tính toán và chất lượng biên Pareto. Nỗ lực tính toán được đặc trưng bởi thời gian chạy, số lần đánh giá hàm (Function Evaluations - FEs), và kích thước kho lưu trữ cuối cùng, trong khi đánh giá chất lượng dựa trên các xếp hạng và so sánh Wilcoxon-Holm đã giới thiệu ở trên. Sự phân tách này là cần thiết vì một giá trị chỉ số thấp hơn tự nó không mô tả chi phí tính toán cần thiết để đạt được nó.

Tất cả các tính toán bài toán chuẩn được thực hiện bằng MATLAB trên một trạm làm việc trang bị CPU Intel Xeon E5-2667 v2 3.30 GHz, 16 lõi vật lý, 32 luồng xử lý logic, và 64 GB RAM; các lần chạy song song sử dụng 30 worker. Vì các lần chạy độc lập được thực thi song song, thời gian chạy trong [Bảng 3](#_Ref234512765) biểu thị thời gian tính toán trung bình của một lần chạy chứ không phải thời gian trôi qua của toàn bộ lô song song.

[Bảng 3](#_Ref234512765) cho thấy hai biến thể MOSFOA sử dụng ngân sách đánh giá nhỏ nhất, với 50,100 FEs mỗi lần chạy. Ngược lại, MOMSA sử dụng khoảng 60,100 FEs, MOGNDO sử dụng 100,100 FEs, và NS-MFO sử dụng 150,100 FEs. B-MOSFOA cũng cho thời gian chạy tổng thể thấp nhất, 28.3 giây mỗi lần chạy. E-MOSFOA làm tăng thời gian chạy tổng thể lên 33.9 giây do cơ chế điều khiển thích ứng và tinh chỉnh cuối cùng của nó, việc này đưa vào các thao tác bổ sung. Tuy nhiên, giá trị này vẫn gần với MOMSA (29.7 giây) và thấp hơn đáng kể so với NS-MFO (65.8 giây) và MOGNDO (143 giây).

**Bảng 3. Cài đặt tính toán và thống kê thời gian chạy cho các lần chạy bài toán chuẩn đã hiệu chỉnh.**

| Bộ bài toán | Thuật toán | Số bài toán | Số lần chạy | TB thời gian chạy/lần (s) | TB FEs/lần | TB kích thước kho lưu trữ |
|---|---|---|---|---|---|---|
| IMOP | MOMSA | 8 | 240 | 35.8 | 60142 | 162 |
| | NS-MFO | 8 | 240 | 72.4 | 150100 | 158 |
| | MOGNDO | 8 | 240 | 53.8 | 100100 | 61.5 |
| | B-MOSFOA | 8 | 240 | 19.2 | 50100 | 109 |
| | E-MOSFOA | 8 | 240 | 36.3 | 50100 | 168 |
| UF | MOMSA | 9 | 270 | 30.5 | 60111 | 125 |
| | NS-MFO | 9 | 270 | 70.5 | 150100 | 139 |
| | MOGNDO | 9 | 270 | 90.1 | 100100 | 92.2 |
| | B-MOSFOA | 9 | 270 | 19.4 | 50100 | 119 |
| | E-MOSFOA | 9 | 270 | 19.8 | 50100 | 130 |
| RM-MEDA | MOMSA | 9 | 270 | 23.6 | 60053 | 187 |
| | NS-MFO | 9 | 270 | 55.4 | 150100 | 174 |
| | MOGNDO | 9 | 270 | 275 | 100100 | 200 |
| | B-MOSFOA | 9 | 270 | 45.2 | 50100 | 200 |
| | E-MOSFOA | 9 | 270 | 45.8 | 50100 | 200 |
| **Tổng thể** | MOMSA | 26 | 780 | 29.7 | 60100 | 158 |
| | NS-MFO | 26 | 780 | 65.8 | 150100 | 157 |
| | MOGNDO | 26 | 780 | 143 | 100100 | 120 |
| | B-MOSFOA | 26 | 780 | 28.3 | 50100 | 144 |
| | E-MOSFOA | 26 | 780 | 33.9 | 50100 | 166 |

Kích thước kho lưu trữ cuối cùng cung cấp thêm một góc nhìn về khả năng bảo toàn đa dạng. E-MOSFOA giữ lại nhiều ứng viên không trội hơn B-MOSFOA trung bình (166 so với 144), và cả hai biến thể đều đạt đến giới hạn kho lưu trữ trên RM-MEDA. Sự bão hòa trên RM-MEDA cho thấy rằng nhiều ứng viên không trội được giữ lại trong dung lượng kho lưu trữ được áp dụng. Hành vi này nhất quán với thời gian chạy dài hơn một chút của E-MOSFOA và với độ bao phủ rộng hơn của nó trong một số so sánh chất lượng.

[Bảng 4](#_Ref234599257) trình bày các xếp hạng trung bình, số lần dẫn đầu, và các giá trị p Wilcoxon-Holm trong một bảng tổng hợp duy nhất, cho phép mức độ hiệu năng và tính nhất quán thống kê được xem xét cùng nhau. Phần tổng thể của [Bảng 4](#_Ref234599257) cho thấy các xếp hạng trung bình gần nhau cho ba phương pháp dẫn đầu: MOMSA xếp hạng nhất (2.52), tiếp theo là E-MOSFOA (2.58) và B-MOSFOA (2.75). E-MOSFOA đạt 31 trường hợp xếp hạng 1, cùng số lượng với MOMSA, và 52 trường hợp top-2. B-MOSFOA có ít trường hợp xếp hạng 1 hơn (22), nhưng nó vẫn xuất hiện trong top hai ở 50 trường hợp. Do đó, hai biến thể MOSFOA vẫn nằm trong nhóm thuật toán cạnh tranh chính.

**Bảng 4. Xếp hạng hiệu năng bài toán chuẩn và so sánh thống kê Wilcoxon-Holm.**

| Bộ bài toán | So sánh với E-MOSFOA | W/D/L | Số phép kiểm định | $p_{adj}<0.05$ | Xếp hạng TB | Số ca hạng 1 | Số ca top-2 |
|---|---|---|---|---|---|---|---|
| IMOP | MOMSA | 9/1/22 | 32 | 31 | 2.81 | 7 | 11 |
| | NS-MFO | 10/1/21 | 32 | 31 | 3.34 | 3 | 8 |
| | MOGNDO | 8/2/22 | 32 | 30 | 4.12 | 1 | 6 |
| | B-MOSFOA | 13/4/15 | 32 | 28 | 2.28 | 8 | 21 |
| | E-MOSFOA | Ref. | Ref. | Ref. | 2.44 | 13 | 18 |
| UF | MOMSA | 11/13/12 | 36 | 23 | 2.44 | 8 | 22 |
| | NS-MFO | 10/5/20 | 35 | 30 | 3.42 | 5 | 9 |
| | MOGNDO | 6/11/19 | 36 | 25 | 3.69 | 3 | 7 |
| | B-MOSFOA | 14/1/20 | 35 | 34 | 2.81 | 11 | 17 |
| | E-MOSFOA | Ref. | Ref. | Ref. | 2.64 | 9 | 16 |
| RM-MEDA | MOMSA | 18/4/14 | 36 | 32 | 2.33 | 16 | 22 |
| | NS-MFO | 12/4/18 | 34 | 30 | 3.25 | 4 | 11 |
| | MOGNDO | 5/5/24 | 34 | 29 | 3.64 | 4 | 7 |
| | B-MOSFOA | 6/11/16 | 33 | 22 | 3.12 | 3 | 12 |
| | E-MOSFOA | Ref. | Ref. | Ref. | 2.65 | 9 | 18 |
| **Tổng thể** | MOMSA | 38/18/48 | 104 | 86 | 2.52 | 31 | 55 |
| | NS-MFO | 32/10/59 | 101 | 91 | 3.34 | 12 | 28 |
| | MOGNDO | 19/18/65 | 102 | 84 | 3.81 | 8 | 20 |
| | B-MOSFOA | 33/16/51 | 100 | 84 | 2.75 | 22 | 50 |
| | E-MOSFOA | Ref. | Ref. | Ref. | 2.58 | 31 | 52 |

Ngoài ra, số liệu W/D/L còn làm rõ thêm cách diễn giải các xếp hạng trung bình. Trong mỗi hàng thuật toán so sánh, mục thứ ba cho biết số trường hợp có ý nghĩa thống kê mà E-MOSFOA vượt trội hơn thuật toán ở hàng đó. E-MOSFOA có nhiều kết quả thuận lợi hơn bất lợi so với MOMSA (48 so với 38), NS-MFO (59 so với 32), MOGNDO (65 so với 19), và B-MOSFOA (51 so với 33). Do đó, lợi thế nhỏ của MOMSA về xếp hạng trung bình không phải là sự vượt trội thống kê đồng nhất so với E-MOSFOA.

Kết quả cấp bộ bài toán chuẩn phân tách vai trò của hai biến thể MOSFOA. B-MOSFOA mạnh nhất trên IMOP, nơi nó có xếp hạng trung bình tốt nhất (2.28) và 21 trường hợp top-2 trong số 32 tổ hợp bài toán-chỉ số. E-MOSFOA có nhiều trường hợp xếp hạng 1 hơn trên IMOP và xếp hạng trung bình thấp hơn B-MOSFOA trên UF và RM-MEDA. Do đó, các toán tử thích ứng được bổ sung không cải thiện mọi họ bài toán theo cùng một cách; lợi ích của chúng thể hiện rõ hơn trên các bộ bài toán UF và RM-MEDA rộng hơn. Hình 2-7 cung cấp bằng chứng trực quan về biên và $IGD$, trong khi Phụ lục Bảng A2-A4 cung cấp các số liệu thống kê chi tiết cấp bài toán.

Hình 2 và 3 tóm tắt các phép xấp xỉ $PF$ và phân bố $IGD$ cho bộ IMOP, trong khi Phụ lục Bảng A2 cung cấp số liệu thống kê chi tiết cấp chỉ số. Trong số 32 tổ hợp bài toán-chỉ số IMOP, B-MOSFOA đạt xếp hạng trung bình cấp bộ bài toán thấp nhất, trong khi E-MOSFOA ghi nhận nhiều trường hợp xếp hạng 1 riêng lẻ hơn. E-MOSFOA xếp hạng nhất cho cả IGD và Ε trên nhiều bài toán IMOP, trong khi B-MOSFOA xếp hạng nhất cho cả hai chỉ số trên các trường hợp được chọn như IMOP5 và IMOP7.

+---------------------------------------------------+---------------------------------------------------+
| ![](media/image3.png) ![](media/image4.png) ![](media/image5.png) |
| ![](media/image6.png) ![](media/image7.png) ![](media/image8.png) |
| ![](media/image9.png) ![](media/image10.png) |
+---------------------------------------------------+---------------------------------------------------+
| **Hình 2.** Các biên Pareto xấp xỉ cho các bài toán IMOP. |
+---------------------------------------------------+---------------------------------------------------+

Các chỉ số đa dạng phân biệt sâu hơn giữa hai biến thể. B-MOSFOA hoạt động tốt trên $MS$ trong các trường hợp được chọn, trong khi E-MOSFOA cho kết quả $\Delta$ mạnh và các giá trị $MS$ cạnh tranh bổ sung. Kết quả IMOP ưu tiên B-MOSFOA về xếp hạng trung bình nhưng vẫn giữ E-MOSFOA là một nguồn quan trọng của các trường hợp tốt nhất riêng lẻ.

Bộ UF cho một thứ tự khác. Hình 4 và 5 cho thấy các hình dạng biên và phân bố $IGD$ đa dạng hơn, và Phụ lục Bảng A3 báo cáo đầy đủ các giá trị cấp chỉ số. MOMSA có xếp hạng trung bình UF tốt nhất, nhưng E-MOSFOA là biến thể MOSFOA tốt hơn trên bộ bài toán này. Các kết quả xếp hạng nhất của nó cho $IGD$ và $\varepsilon$ trên nhiều bài toán nhất quán với độ chính xác hội tụ được cải thiện.

B-MOSFOA vẫn có ý nghĩa trong các chỉ số đa dạng, với kết quả $\Delta$ và $MS$ xếp hạng nhất trên nhiều bài toán UF. Do đó, bộ UF cho thấy lợi thế phụ thuộc bài toán của tìm kiếm cải tiến. E-MOSFOA cải thiện kết quả tổng thể, trong khi cơ chế kho lưu trữ cơ bản vẫn cung cấp độ bao phủ hữu ích cho các bài toán cụ thể.

**Hình 3.** So sánh $IGD$ trên các bài toán IMOP.

Bộ RM-MEDA củng cố thêm sự phụ thuộc theo họ bài toán của xếp hạng. Hình 6 và 7 cho thấy các mẫu $PF$ và $IGD$ tương ứng, và Phụ lục Bảng A4 cung cấp số liệu thống kê chi tiết. MOMSA một lần nữa có xếp hạng trung bình cấp bộ bài toán tốt nhất. E-MOSFOA xếp hạng nhì, trước B-MOSFOA, NS-MFO, và MOGNDO, và nó ghi nhận nhiều trường hợp xếp hạng 1 và top-2 hơn B-MOSFOA.

Các kiểm định hiệu chỉnh Holm hỗ trợ một cách đọc thận trọng về sự khác biệt này. Nhiều so sánh RM-MEDA ưu tiên E-MOSFOA hơn B-MOSFOA, trong khi các trường hợp khác vẫn không thể phân biệt về mặt thống kê. B-MOSFOA vẫn cho các giá trị hội tụ tốt hơn trong các bài toán được chọn, nhưng E-MOSFOA có xếp hạng RM-MEDA tổng hợp thấp hơn (tốt hơn).

Kết quả bài toán chuẩn không xác định một phương pháp chi phối duy nhất cho mọi bộ bài toán và chỉ số. MOMSA có xếp hạng trung bình tổng thể tốt nhất, E-MOSFOA đạt số lượng trường hợp xếp hạng 1 cao nhất và có số liệu Wilcoxon-Holm thuận lợi so với mỗi thuật toán so sánh, và B-MOSFOA có thời gian chạy thấp nhất và xếp hạng trung bình IMOP tốt nhất. Theo quy trình này, B-MOSFOA là biến thể dựa trên kho lưu trữ kinh tế hơn. Ngược lại, E-MOSFOA phải chịu một sự gia tăng nhỏ về thời gian chạy để đạt được hỗ trợ thống kê tổng hợp mạnh hơn trên các bộ bài toán chuẩn rộng hơn.

**Hình 4.** Các biên Pareto xấp xỉ cho các bài toán UF.

### 3.3. Phân tích Độ nhạy Tham số (Parameter Sensitivity Analysis)

Một phân tích độ nhạy một-yếu-tố-tại-một-thời-điểm (one-factor-at-a-time) được thực hiện xung quanh cài đặt cơ sở $GP_{0}=0.5$, $N_{r}=200$, và $n_{grid}=10$. Ba tham số này ảnh hưởng đến các phần khác nhau của quá trình tìm kiếm. $GP_{0}$ kiểm soát sự cân bằng ban đầu giữa khai phá và khai thác, $N_{r}$ giới hạn dung lượng kho lưu trữ ngoài, và $n_{grid}$ xác định phân vùng mật độ được sử dụng cho lựa chọn thủ lĩnh dựa trên kho lưu trữ. Bộ độ nhạy sử dụng sáu bài toán chuẩn đại diện, 30 lần chạy độc lập cho mỗi cấu hình, và cùng ngân sách đánh giá như nghiên cứu bài toán chuẩn chính. Đối với mỗi cài đặt tham số, xếp hạng rút gọn được tính từ 24 kết quả, hình thành bởi sáu bài toán và bốn chỉ số. [Bảng 5](#_Ref234608561) báo cáo bản tóm tắt rút gọn này cùng với so sánh Wilcoxon-Holm với đường cơ sở và thời gian chạy trung bình mỗi lần chạy. Phụ lục Bảng A1 cung cấp các giá trị cấp chỉ số tương ứng cho mỗi cài đặt tham số-bài toán chuẩn, với B-MOSFOA và E-MOSFOA được trình bày song song.

**Hình 5.** So sánh $IGD$ trên các bài toán UF.

[Bảng 5](#_Ref234608561) cho thấy phản ứng tham số ở mức vừa phải và khác nhau giữa hai biến thể MOSFOA. Đối với B-MOSFOA, $GP_0=0.3$ cho xếp hạng trung bình thấp nhất (3.25) và sáu trường hợp xếp hạng 1, nhưng cài đặt này không thể phân biệt về mặt thống kê so với đường cơ sở trong tất cả 24 so sánh Wilcoxon-Holm. Việc tăng $GP_{0}$ lên 0.7 làm suy yếu xếp hạng rút gọn. Đối với E-MOSFOA, $GP_{0}$=0.7 cho xếp hạng rút gọn tốt nhất, trong khi $GP_{0}$=0.3 có kết quả kém nhất. Do đó, mức khai phá ưu tiên thấp hơn đối với B-MOSFOA và cao hơn đối với E-MOSFOA.

**Hình 6.** Các biên Pareto xấp xỉ cho các bài toán RM-MEDA.

**Bảng 5. Xếp hạng độ nhạy tham số rút gọn cho B-MOSFOA và E-MOSFOA.**

| Thuật toán | $GP_0$ | $N_r$ | $n_{grid}$ | Xếp hạng TB | Số lần tốt nhất/24 | Wilcoxon-Holm so với đường cơ sở (+/=/-) | TB thời gian chạy/lần (s) |
|---|---|---|---|---|---|---|---|
| B-MOSFOA | 0.5 | 200 | 10 | 3.38 | 3 | Đường cơ sở | 27.90 |
| | **0.3** | 200 | 10 | 3.25 | 6 | 0/24/0 | 29.25 |
| | **0.7** | 200 | 10 | 4.71 | 2 | 1/17/6 | 23.64 |
| | 0.5 | **100** | 10 | 3.96 | 4 | 1/19/4 | 16.32 |
| | 0.5 | **300** | 10 | 4.00 | 2 | 2/19/3 | 38.75 |
| | 0.5 | 200 | **15** | 3.88 | 2 | 0/24/0 | 27.25 |
| | 0.5 | 200 | **5** | 4.83 | 3 | 2/18/4 | 25.89 |
| | **Tổng phụ không-khác-biệt Wilcoxon-Holm** | | | | | **121/144** | - |
| E-MOSFOA | 0.5 | 200 | 10 | 4.33 | 0 | Đường cơ sở | 33.52 |
| | **0.7** | 200 | 10 | 3.50 | 5 | 4/18/2 | 33.21 |
| | **0.3** | 200 | 10 | 5.13 | 0 | 3/13/8 | 32.39 |
| | 0.5 | **300** | 10 | 3.71 | 5 | 4/19/1 | 50.84 |
| | 0.5 | **100** | 10 | 4.13 | 4 | 2/17/5 | 20.47 |
| | 0.5 | 200 | **5** | 3.58 | 6 | 2/22/0 | 32.33 |
| | 0.5 | 200 | **15** | 3.63 | 2 | 1/22/1 | 34.17 |
| | **Tổng phụ không-khác-biệt Wilcoxon-Holm** | | | | | **111/144** | - |

**Hình 7.** So sánh $IGD$ trên các bài toán RM-MEDA.

Kích thước kho lưu trữ chủ yếu ảnh hưởng đến chi phí tính toán. $N_{r}$=100 cho thời gian chạy ngắn nhất cho cả hai biến thể, trong khi $N_{r}$=300 là cài đặt tốn kém nhất và không mang lại lợi thế xếp hạng nhất quán. Các tổng phụ Wilcoxon-Holm cho thấy thêm rằng 121 trong số 144 so sánh B-MOSFOA và 111 trong số 144 so sánh E-MOSFOA vẫn không thể phân biệt về mặt thống kê so với đường cơ sở. Do đó, cài đặt cơ sở được giữ lại cho so sánh bài toán chuẩn chính như một lựa chọn ổn định, không cực đoan, trong khi kết quả độ nhạy gợi ý $GP_{0}$ là tham số hữu ích nhất để tinh chỉnh thêm (tùy chọn).

---

## 4. Nghiên cứu Điển hình: Bến cảng Chất lỏng Rời (Case Study: Liquid Bulk Jetty)

### 4.1. Cơ sở Dự án và Mô hình Kết cấu (Project Baseline and Structural Models)

Ứng dụng kỹ thuật xem xét ba hệ con tương tác của bến cảng chất lỏng rời Hải Linh: trụ va cập tàu (Berthing Dolphin - BD), một trụ neo tàu (Mooring Dolphin - MD), và một sàn cầu tàu chính (Main Jetty Platform - MJP). Bố trí cọc, mô hình hóa phần tử hữu hạn, và mặt cắt ngang của chúng được tập hợp trong [Hình 8](#_Ref227695276), trong khi các Bảng 6 và 7 định nghĩa các tổ hợp tải trọng và biến thiết kế. Ứng dụng này có tính thách thức vì các tiết diện cọc rời rạc, các biến hình học liên tục, khả năng chịu lực của cọc phụ thuộc vào đất nền, và các thỏa hiệp phi tuyến chi phí-độ cứng phải được đánh giá thông qua các phân tích SAP2000 lặp lại nhiều lần.

Các trụ va cập tàu (BD) hấp thụ và phân phối lại động năng và lực ngang phát sinh trong quá trình tàu cập bến, đồng thời cung cấp hỗ trợ cho các hoạt động neo tàu. BD hiện tại gồm 19 cọc bê tông ứng lực trước D600 với chiều dài danh nghĩa 39m: chín cọc thẳng đứng, sáu cọc xiên trong mặt phẳng với độ dốc 1:6, và bốn cọc xiên không gian với cùng độ dốc, định hướng mặt bằng 30° hoặc 60°. Bố trí này phát triển khả năng chịu lực theo cả phương chính và phương chéo, như thể hiện trong [Hình 8](#_Ref227695276)(b) và (e).

Các trụ neo tàu (MD) neo giữ các dây neo và chịu các tác động ngang và kéo phát sinh từ chuyển động của tàu dưới tác động của gió, sóng, và thủy triều. MD hiện tại gồm chín cọc bê tông ứng lực trước D600: một cọc thẳng đứng, bốn cọc xiên trong mặt phẳng với độ dốc 1:6, và bốn cọc xiên không gian với cùng độ dốc, định hướng mặt bằng 45°. Sự kết hợp giữa cọc thẳng đứng và cọc xiên cung cấp khả năng chịu lực đa hướng đối với các tác động neo tàu, như thể hiện trong [Hình 8](#_Ref227695276)(f).

Cả hệ cọc BD và MD đều hỗ trợ các đài cọc bê tông cốt thép đổ tại chỗ mác C40/50. Đài cọc BD có kích thước 8.4×9.6 m và có chiều sâu thay đổi từ 2.0 đến 3.0 m; vùng lắp đặt phớt va tàu được làm sâu cục bộ giúp tăng cường khả năng chịu uốn và chịu cắt, đồng thời cung cấp diện tích neo giữ lớn hơn. Đài cọc MD kích thước 4.5×4.5×2.0 m kết nối đầu cọc và truyền các tác động neo tàu xuống nền móng. Các mô hình SAP2000 trong [Hình 8](#_Ref227695276) (b) và (c) biểu diễn hình học đầy đủ của hệ cọc và đài cọc. Đối với mỗi phương án thiết kế ứng viên, các tổ hợp tải trọng áp dụng của tĩnh tải (Dead Load - DL), tải va cập tàu (Berthing Load - BL), và tải neo tàu (Mooring Load - ML) trong Bảng 6 được phân tích, và chuyển vị lớn nhất cùng các nội lực và mô-men uốn cọc chi phối được trả về MATLAB để đánh giá mục tiêu và ràng buộc.

+--------------------------------------------------------------------------------------------------------------------------------------------------------------------+
| ![](media/image55.jpeg) |
| a) Hình ảnh Google Earth của khu vực nghiên cứu © 2026 Google; ngày chụp ảnh 13/03/2026; truy cập 11/07/2026; dải bản quyền/ghi công dữ liệu gốc của Google được giữ nguyên trong ảnh. |
+========================================================+========================================================+========================================================+
| ![](media/image56.tiff) | ![](media/image57.tiff) | ![](media/image58.tiff) |
+--------------------------------------------------------+--------------------------------------------------------+--------------------------------------------------------+
| b) Mô hình FEM của BD; | c) Mô hình FEM của MD; | d) Mô hình FEM của MJP; |
+--------------------------------------------------------+--------------------------------------------------------+--------------------------------------------------------+
| ![](media/image59.tiff) | ![](media/image60.tiff) | ![](media/image61.tiff) |
+--------------------------------------------------------+--------------------------------------------------------+--------------------------------------------------------+
| e) Mặt cắt ngang BD; | f) Mặt cắt ngang MD; | g) Mặt cắt ngang MJP; |
+--------------------------------------------------------+--------------------------------------------------------+--------------------------------------------------------+
| **Hình 8.** Vị trí và mô hình hóa kết cấu của bến cảng chất lỏng rời Hải Linh. |
+--------------------------------------------------------------------------------------------------------------------------------------------------------------------+

MJP là một kết cấu sàn bê tông cốt thép kết nối các BD và MD, đóng vai trò là nền tảng khai thác chính cho việc vận chuyển dầu mỏ và đỡ thiết bị. Các cọc bê tông ứng lực trước thẳng đứng đỡ MJP, bao gồm các dầm ngang, dầm dọc, và sàn bê tông cốt thép đổ tại chỗ. Không giống như BD và MD, MJP không chịu tác động va đập trực tiếp từ tàu; thiết kế của nó xem xét tĩnh tải và hoạt tải (Live Load - LL) từ thiết bị và người vận hành.

**Bảng 6. Các trường hợp tải và tổ hợp cho các hệ con của bến cảng.**

| Kết cấu | Trường hợp tải | COMB1 | COMB2 | COMB3 |
|---|---|---|---|---|
| BD | DL | 1.0 | 1.0 | 1.0 |
| | BL | --- | 1.0 | --- |
| | ML | --- | --- | 1.0 |
| | Tổ hợp bao (EV-COMB) | Có | Có | Có |
| MD | DL | 1.0 | 1.0 | --- |
| | ML | --- | 1.0 | --- |
| | EV-COMB | Có | Có | --- |
| MJP | DL | 1.0 | 1.0 | --- |
| | LL | --- | 1.0 | --- |
| | EV-COMB | Có | Có | --- |

*(Tổ hợp: cộng tuyến tính - Linear Add)*

Các cơ sở dữ liệu kỹ thuật được thiết lập từ các hồ sơ dự án không công khai được cung cấp cho các tác giả để phục vụ mục đích kiểm chứng nghiên cứu. Hồ sơ bản vẽ hoàn công năm 2020 ghi lại cấu hình BD và MD đã hoàn thành [47], trong khi hồ sơ tính toán kiểm định định kỳ năm 2023 mô tả cả ba hệ con, bao gồm hình học, điều kiện đất nền, tác động thiết kế, và bố trí kết cấu [48]. Trên cơ sở này, các cơ sở dữ liệu số được xây dựng lại trong cùng quy trình MATLAB-SAP2000 áp dụng xuyên suốt nghiên cứu. Đối với BD và MD, độ xiên cọc là 1:6, biểu thị bằng $n_{\theta} = 6$, và chiều dài cọc danh nghĩa là 39 m; cơ sở MJP sử dụng cọc thẳng đứng D500 với chiều dài danh nghĩa 38 m. Việc phân tích lại dưới cùng một mô hình đảm bảo rằng sự khác biệt phát sinh từ các biến thiết kế chứ không phải từ các giả định mô hình hóa hoặc tải trọng không nhất quán.

[Bảng 6](#_Ref227706165) báo cáo các hệ số tổ hợp tuyến tính và xác định các tổ hợp được đưa vào tổ hợp bao SAP2000, trong khi [Bảng 8](#_Ref227768510) đưa ra các thành phần tải trọng số được nhập vào mô hình phân tích. Do đó, các giá trị đơn vị trong [Bảng 6](#_Ref227706165) là hệ số tỷ lệ tổ hợp, không phải độ lớn tải trọng hay hệ số an toàn. Các hệ số đặc thù theo tác động được áp dụng khi thiết lập các tải va cập tàu, neo tàu, và khai thác, trong khi các hệ số độ tin cậy, quá tải, điều kiện làm việc, và khả năng chịu lực được áp dụng trong các kiểm tra khả năng chịu lực tương ứng. EV-COMB là một tổ hợp bao chứ không phải tổ hợp tuyến tính: nó đánh giá riêng từng tổ hợp được liệt kê và giữ lại các phản ứng lớn nhất và nhỏ nhất chi phối cho mỗi hệ con.

### 4.2. Các Hàm Mục tiêu (Objective Functions)

Bài toán kỹ thuật xem xét hai mục tiêu cần tối thiểu hóa: chi phí xây dựng $\left( f_{1}\left( \mathbf{X} \right) \right)$ và chuyển vị kết cấu lớn nhất $\left( f_{2}\left( \mathbf{X} \right) \right)$. Chi phí đo lường nhu cầu vật liệu và nền móng, trong khi chuyển vị lớn nhất biểu thị độ cứng tổng thể và phản ứng khả năng sử dụng của mỗi hệ con. Việc xử lý chuyển vị như một mục tiêu thay vì gán một trọng số ưu tiên tùy ý cho thấy chi phí bổ sung để đạt được một thiết kế cứng hơn. Các yêu cầu về cường độ, địa kỹ thuật, và hình học vẫn là các ràng buộc tường minh và không được đánh đổi với tính kinh tế.

$$\underset{\mathbf{X}}{minimize}{\mathbf{F}\left( \mathbf{X} \right)} = \left\{ f_{1}\left( \mathbf{X} \right),f_{2}\left( \mathbf{X} \right) \right\},\quad (14)$$

$$Trong\ đó:\ f_{1}\left( \mathbf{X} \right) = \left\{ \begin{matrix} \sum_{i = 1}^{n_{p}}{L_{p,i}P_{p}} & \text{với } MD,\ BD, \\ \sum_{i = 1}^{n_{p}}{L_{p,i}P_{p}} + \sum{}{}V_{beam,i}P_{cr} + \sum{}{}M_{s,i}P_{st} & \text{với } MJP. \end{matrix} \right.\ \quad (15)$$

Trong đó $\mathbf{X}$ là véc-tơ thiết kế chứa các biến được liệt kê trong [Bảng 7](#_Ref204095675) cho hệ con tương ứng. Trong phương trình (15), $n_{p}$ là tổng số cọc; $L_{p,i}$ là chiều dài cọc; và $P_{p}$ là đơn giá cọc theo mét; $V_{beam,i}$ và $M_{s,i}$ là thể tích bê tông và khối lượng cốt thép của dầm $i$; và $P_{cr}$ và $P_{st}$ là đơn giá bê tông và cốt thép.

Phương trình (15) định nghĩa $f_{1}$ theo từng hệ con: nhánh đầu tiên cho chi phí cọc đối với BD và MD, trong khi nhánh thứ hai bổ sung chi phí bê tông dầm và cốt thép cho MJP. Đối với MJP, SAP2000 thiết kế các dầm bê tông cốt thép theo CSA A23.3-14 [49]; thể tích bê tông và khối lượng cốt thép kết quả cung cấp các số lượng được sử dụng trong nhánh thứ hai của phương trình (15), trong khi các yêu cầu về cường độ liên quan được định nghĩa trong Mục 4.4.

**Bảng 7. Các biến thiết kế cho các kết cấu BD, MD, và MJP.**

| Kết cấu | Biến | Mô tả | Loại | Khoảng & Tài liệu tham khảo |
|---|---|---|---|---|
| BD, MD | $X_1$ | $D_p$ - Đường kính ngoài cọc (m) | Rời rạc | Theo [3] |
| | $X_2$ | $t_p$ - Chiều dày thành cọc (m) | Rời rạc | Theo [3] |
| | $X_3$ | $n_\theta$ - Tham số độ xiên cọc theo tỷ lệ 1:$n_\theta$ | Rời rạc | [6,7,8] |
| | $X_4$ | $L_p$ - Chiều dài cọc (m) | Rời rạc | [1:0.1:40] |
| MJP | $X_1$ | $D_p$ - Đường kính ngoài cọc (m) | Rời rạc | Theo [3] |
| | $X_2$ | $t_p$ - Chiều dày thành cọc (m) | Rời rạc | Theo [3] |
| | $X_3$ | $L_p$ - Chiều dài cọc (m) | Rời rạc | [1-40] |
| | $X_4$ | $l_1$ - Nhịp dầm dọc (m) | Rời rạc | [3-6] |
| | $X_5$ | $l_2$ - Nhịp dầm ngang (m) | Rời rạc | [3-6] |
| | $X_6$ | $b$ - Bề rộng dầm (m) | Rời rạc | [0.5-2] |
| | $X_7$ | $h$ - Chiều cao dầm (m) | Rời rạc | [0.5-2] |

Một cơ sở đơn giá chỉ thị năm 2025 được áp dụng để so sánh các kết quả tối ưu hóa chứ không phải để lập dự toán đấu thầu. Các thông báo chính thức của Hải Phòng cung cấp tài liệu tham khảo chính cho cọc bê tông ứng lực trước, bê tông, và cốt thép [50, 51], trong khi các bảng giá nhà cung cấp công khai bổ sung cho các đường kính và mác cọc chưa được liệt kê. Cơ sở giá có thể truy vết này được cố định như nhau cho mọi ứng viên trong nghiên cứu này và không thay thế các báo giá đặc thù theo dự án. Quy đổi VND sử dụng tỷ giá tính toán 1 USD = 24,500 VND. Chi phí BD và MD phụ thuộc vào chiều dài cọc và đơn giá; MJP bổ sung thêm bê tông dầm và cốt thép, với $P_{cr}$=46.25 USD/m³ và $P_{st}$=0.57 USD/kg. Các đầu vào này và khoảng đơn giá cọc theo mác tương ứng nhất quán về bậc độ lớn với giá chính thức Hải Phòng năm 2025.

### 4.3. Tải trọng Thiết kế và Mô hình hóa Địa kỹ thuật (Design Loads and Geotechnical Modeling)

Mô hình kỹ thuật tuân theo các tiêu chuẩn được sử dụng để xác định thiết kế hiện tại và việc phân tích lại: TCVN 7888:2014 cho cọc ứng lực trước [3], TCVN 10304:2014 cho nền móng cọc [4], PIANC và OCDI cho tác động va cập tàu [1, 2], và 22 TCN 222-95 cho tác động neo tàu do tàu gây ra [52]. Tính toán va cập tàu bao gồm khối lượng thủy động, độ lệch tâm, cấu hình bến, và hệ số mềm của phớt va; phản lực phớt va được chọn được tăng thêm 10% theo khuyến nghị của nhà sản xuất được ghi trong hồ sơ tính toán dự án [48].

**Bảng 8. Các trường hợp tải và giá trị tải trọng tương ứng.**

| Trường hợp tải | Loại | Loại thiết kế | X (kN) | Y (kN) | Z | Tài liệu tham khảo |
|---|---|---|---|---|---|---|
| DL | Tĩnh | Tĩnh tải | --- | --- | --- | Tính toán nội bộ bởi SAP2000 |
| BL | Tĩnh | Hoạt tải | 222.42 | 444.83 | 0 | [1, 2] |
| ML | Tĩnh | Hoạt tải | 99.05 | 118.07 | 71.2 | [1, 2] |
| LL | Tĩnh | Hoạt tải | 0 | 0 | 9.81 (kN/m²) | [1, 2] |

[Bảng 8](#_Ref227768510) báo cáo các đầu vào thực tế cho các mô hình SAP2000. Tĩnh tải được sinh ra từ hệ số nhân trọng lượng bản thân. Các thành phần tải va cập tàu là 222.42, 444.83, và 0 kN theo các phương tổng thể $X$, $Y$, và $Z$; các thành phần tải neo tàu là 99.05, 118.07, và 71.20 kN. Hoạt tải của MJP là cường độ phân bố thẳng đứng 9.81 kN/m². Các giá trị này giữ cố định cho mọi ứng viên.

**Bảng 9. Đặc trưng đất nền (Soil properties).**

| Lớp số | Loại đất | Trạng thái | Chiều dày (m) | Chỉ số độ sệt ($I_L$) |
|---|---|---|---|---|
| 1 | Sét | Chảy đến rất dẻo chảy | 4.8 | 0.76 |
| 2 | Sét | Dẻo cứng đến cứng | 5.3 | 0.31 |
| 3 | Sét | Dẻo chảy | 9.6 | 0.63 |
| 4 | Sét | Dẻo cứng đến cứng | 1.7 | 0.35 |
| 5 | Sét | Dẻo chảy | 4.9 | 0.67 |
| 6 | Cát | Hạt trung | 2.3 | 0.20 |

Địa tầng chủ yếu gồm các lớp đất dính, với các lớp cát sâu hơn; [Bảng 9](#_Ref234757755) liệt kê các tham số được sử dụng trong hai tính toán liên quan đến đất riêng biệt. Khả năng chịu nén dọc trục và khả năng chịu nhổ được đánh giá trên toàn bộ chiều dài cọc chôn theo TCVN 10304:2014 [4], và các phản lực cọc SAP2000 được kiểm tra so với các khả năng chịu lực này. Sự ràng buộc ngang của đất được biểu diễn thông qua một mô hình hóa gối tựa tương đương dựa trên chiều sâu uốn tính toán. Đối với địa tầng nhiều lớp, hệ số nền tương đương $k_{eq}$ cho $\alpha_{e} = \left\lbrack \frac{b_{p}k_{eq}}{\gamma_{c}E_{0}I} \right\rbrack^{\frac{1}{5}}$ và chiều sâu uốn hoạt động là $l_{u} = \frac{2}{\alpha_{e}}$, trong đó $b_{p}$ là bề rộng cọc tương đương, $E_{0}I$ là độ cứng chống uốn của cọc, và $\gamma_{c}$ là hệ số điều kiện làm việc. Trong SAP2000, hiệu ứng đất được thay thế bằng một gối tựa định hướng (guided support) nằm trong đất tại $l_{u}$, cùng với gối tựa con lăn (roller support) tại mũi cọc. Chiều dài vật lý của cọc được giữ nguyên trong các kiểm tra khả năng chịu lực và mũi cọc, xem [Hình 8](#_Ref227695276) (b), (c) và (d).

### 4.4. Xử lý Ràng buộc và Kiểm tra Tính khả thi (Constraint Handling and Feasibility Verification)

Tính khả thi được đánh giá ở ba cấp độ. Đầu tiên, các điều kiện chấp nhận được về địa kỹ thuật và hình học được kiểm tra trước khi phân tích FEM. Sau đó SAP2000 cung cấp các nội lực thành phần và phản lực gối tựa cần thiết cho các kiểm tra khả năng chịu lực. Cuối cùng, các chẩn đoán được lưu trữ của mỗi thành viên kho lưu trữ cuối cùng được kiểm tra lại sau khi tối ưu hóa. Trình tự này phân biệt một ứng viên không thỏa mãn các điều kiện chấp nhận được của mô hình với một thiết kế có thể phân tích được nhưng vi phạm một hoặc nhiều giới hạn khả năng chịu lực.

Các điều kiện tiền phân tích yêu cầu $L_{p} \geq l_{u}$, $I_{L,tip} < 0.40$, và $h_{bearing} \geq 2.0$m. Đối với MJP, điều kiện tương thích bổ sung là $B_{beam} \geq D_{p} + 0.20$m. Các kiểm tra này đảm bảo rằng cọc vật lý không ngắn hơn chiều dài uốn tính toán của nó, rằng mũi cọc nằm trong khoảng đất tốt được áp dụng, rằng lớp đất chứa mũi cọc có chiều dày đủ, và rằng dầm đỡ có thể chứa được cọc. Việc không thỏa mãn bất kỳ điều kiện nào sẽ gán $10^{9}$ cho cả hai mục tiêu; một phân tích SAP2000 hoàn chỉnh là bắt buộc trước khi các kiểm tra còn lại được đánh giá.

Đối với MJP, quy trình thiết kế bê tông của SAP2000 thiết kế các dầm bê tông cốt thép theo CSA A23.3-14 [49]. Lượng cốt thép yêu cầu được trả về bởi SAP2000 được sử dụng trong tính toán chi phí xây dựng. Vì các kết quả thiết kế dầm theo tiêu chuẩn không được công thức hóa thành các số dư phạt (penalty residuals) tường minh trong MATLAB, các phương trình dưới đây chỉ giới hạn ở các ràng buộc cọc được triển khai trực tiếp trong quy trình tối ưu hóa.

Đối với cả ba hệ con, các kiểm tra cọc được viết dưới dạng số dư không âm, do đó giá trị bằng 0 biểu thị sự thỏa mãn và giá trị dương đo lường mức độ vượt quá.

$$g_{ax}\left( \mathbf{X} \right) = \sum_{j = 1}^{n_{p}}{\max\left( \left| R_{z,j}^{FEA} \right| - N_{c,d},\, 0 \right)},\quad (16)$$

$$g_{M,k}\left( \mathbf{X} \right) = \max\left( \left| M_{k}^{FEA} \right| - M_{c,r},\, 0 \right),\quad\quad k \in \left\{ 2,3 \right\},\quad (17)$$

$$g_{up}\left( \mathbf{X} \right) = \max\left( U_{d} - U_{r},\, 0 \right),\quad (18)$$

$$U_{r} = R_{DL}^{FEA} + n_{p}N_{u,d},\quad (19)$$

$$N_{u,d} = \frac{\gamma_{0}\gamma_{ck}}{\gamma_{n}\gamma_{k}}\, u\sum_{i}{}\gamma_{cf}f_{i}l_{i}\quad (20)$$

$$N_{c,d} = \frac{\gamma_{0}\gamma_{c}}{\gamma_{n}\gamma_{k}}\left( \gamma_{cq}q_{b}A_{b} + u\sum_{i}{}\gamma_{cf}f_{i}l_{i} \right).\quad (21)$$

Các phương trình (16)-(20) định nghĩa các số dư ràng buộc cọc và các số hạng được sử dụng để xác định khả năng chịu nhổ. Phương trình (16) tính tổng trên tất cả $n_{p}$ cọc, mức độ mà phản lực dọc trục tuyệt đối $\left| R_{z,j}^{FEA} \right|$ vượt quá khả năng chịu nén thiết kế $N_{c,d}$ và FEA biểu thị phân tích phần tử hữu hạn. Phương trình (17) so sánh mô-men cọc lớn nhất $\left| M_{k}^{FEA} \right|$ quanh mỗi trục cục bộ $k = 2,\ 3$ với khả năng chịu uốn của cọc $M_{c,r}$. Phương trình (18) so sánh nhu cầu chịu nhổ $U_{d}$ với tổng khả năng chịu nhổ $U_{r}$. Mỗi số dư ràng buộc bằng 0 khi nhu cầu tương ứng không vượt quá khả năng chịu lực và ngược lại bằng mức vượt quá dương. Ràng buộc chịu nhổ áp dụng cho BD và MD và được lấy bằng 0 đối với MJP.

Trong phương trình (19), $R_{DL}^{FEA}$ là phản lực tĩnh tải ổn định thu được từ SAP2000, và $N_{u,d}$ là khả năng chịu nhổ thân cọc thiết kế của một cọc; do đó, $U_{r}$ bao gồm đóng góp của tĩnh tải và khả năng chịu lực thân cọc của tất cả các cọc. Các phương trình (20) và (21) đánh giá khả năng chịu nhổ thân cọc và khả năng chịu nén tương ứng theo TCVN 10304:2014 [4]. Các giá trị được áp dụng là $\gamma_{0} = 1.15$ cho điều kiện làm việc của nền móng, $\gamma_{n} = 1.15$ cho tầm quan trọng kết cấu, và $\gamma_{k} = 1.55$ cho độ tin cậy khả năng chịu lực của cọc. Hệ số điều kiện làm việc của cọc là $\gamma_{c} = 1.00$ khi nén và $\gamma_{ck} = 0.80$ khi nhổ; các hệ số điều kiện làm việc của đất là $\gamma_{cq} = 1.00$ tại mũi cọc và $\gamma_{cf} = 0.80$ dọc theo thân cọc. Ở đây, $q_{b}$ là khả năng chịu lực đơn vị tại mũi cọc, $A_{b}$ là diện tích mũi cọc, $u$ là chu vi cọc, và $f_{i}$ và $l_{i}$ là khả năng chịu lực đơn vị thân cọc và chiều dài cọc chôn trong lớp đất $i$, tương ứng.

Nếu một hoặc nhiều điều kiện khả năng chịu lực trên bị vi phạm, các mức vượt quá tương ứng được kết hợp thành số hạng phạt $P(\mathbf{X})$ và được cộng vào cả hai mục tiêu. Véc-tơ mục tiêu gốc $\mathbf{F}(\mathbf{X})$ trong phương trình (14) khi đó trở thành véc-tơ có phạt $\mathbf{F}^{p}(\mathbf{X})$ sau đây

$$\underset{\mathbf{X}}{minimize}{\mathbf{F}^{p}\left( \mathbf{X} \right) = \left\lbrack f_{1}\left( \mathbf{X} \right) + P\left( \mathbf{X} \right),\mspace{6mu} f_{2}\left( \mathbf{X} \right) + P\left( \mathbf{X} \right) \right\rbrack},\quad (22)$$

$$P\left( \mathbf{X} \right) = \alpha\left\lbrack g_{M,2}\left( \mathbf{X} \right) + g_{M,3}\left( \mathbf{X} \right) + g_{ax}\left( \mathbf{X} \right) + g_{up}\left( \mathbf{X} \right) \right\rbrack,\quad\quad\alpha = 10^{9}.\quad (23)$$

Các phương trình (22) và (23) áp dụng hệ số chung $\alpha = 10^{9}$ cho các mức vượt quá giới hạn khả năng chịu lực của cọc để tạo thành một số hạng phạt, sau đó được cộng vào cả hai mục tiêu. Ràng buộc chịu nhổ áp dụng cho BD và MD và được đặt bằng 0 đối với MJP. Số hạng phạt làm tăng cả hai giá trị mục tiêu tỷ lệ thuận với mức vượt quá ràng buộc, nhờ đó giúp loại trừ các ứng viên vi phạm khỏi kho lưu trữ Pareto. Nếu một điều kiện tiền phân tích cứng bị vi phạm, phân tích SAP2000 bị bỏ qua, và cả hai giá trị mục tiêu được đặt trực tiếp bằng $10^{9}$. Do đó, một ứng viên được coi là khả thi khi $P(\mathbf{X}) = 0$ và tất cả các điều kiện tiền phân tích cứng được thỏa mãn. Sau khi tối ưu hóa, mỗi thành viên kho lưu trữ cuối cùng được đối chiếu với dữ liệu chẩn đoán được lưu trữ của nó để xác nhận số hạng phạt bằng 0, sự thỏa mãn tất cả các điều kiện cứng, và các tỷ số nhu cầu/khả năng chịu lực không vượt quá 1.0.

### 4.5. Kết quả Tối ưu hóa và Diễn giải Kỹ thuật (Optimization Results and Engineering Interpretation)

Trong mục này, sáu bài toán tối ưu hóa kỹ thuật kết hợp MATLAB-SAP2000 được thực hiện bằng cùng một quy trình số, bao gồm quần thể 100, 300 vòng lặp, kho lưu trữ ngoài 100 nghiệm, lưới thích ứng chia 10, và $GP_{0} = 0.5$. Cài đặt này tạo ra 30,100 lần đánh giá hàm mục tiêu cho mỗi cặp thuật toán-trường hợp. Tất cả các lần chạy được thực hiện trên cùng một trạm làm việc (Intel Xeon E5-2667 v2, 16 lõi vật lý, 32 luồng xử lý logic, và 64 GB RAM), với 25 phiên bản SAP2000 song song được kích hoạt cho mỗi bài toán. Trong mỗi hệ con, $HV$ chuẩn hóa [53] được tính từ cùng khoảng chi phí-chuyển vị và điểm tham chiếu (1.1, 1.1).

**Hình 9.** Kết quả tối ưu hóa cho kết cấu BD: (a) hội tụ $HV$; (b) các $PF$ thu được bởi B-MOSFOA và E-MOSFOA so với thiết kế hiện tại.

Sau mỗi lần tối ưu hóa, ba thiết kế đại diện được trích xuất từ kho lưu trữ cuối cùng: thiết kế chi phí nhỏ nhất, thiết kế chuyển vị nhỏ nhất, và thiết kế thỏa hiệp. Thiết kế thỏa hiệp là nghiệm Pareto gần nhất với điểm lý tưởng sau khi chi phí và chuyển vị được chuẩn hóa về cùng thang đo [6, 54]. Vì mỗi cặp thuật toán-trường hợp được biểu diễn bởi một lần chạy kỹ thuật được ghi nhận duy nhất, các thiết kế này được diễn giải như các phương án Pareto khả thi chứ không phải bằng chứng thống kê về tính vượt trội thuật toán. Đường kính và chiều dày thành cọc được mã hóa cùng nhau bởi một biến loại cọc rời rạc; do đó, MJP có sáu biến được mã hóa mặc dù đường kính và chiều dày được báo cáo riêng biệt.

**Bảng 10. Các thiết kế BD tối ưu đại diện và thiết kế hiện tại.**

| Thuật toán | Thiết kế | Loại cọc ($D_p×t_p$; $P_p$ USD/m) | $n_\theta$ | $L_p$ (m) | $f_1$ (USD) | $f_2$ (m) |
|---|---|---|---|---|---|---|
| B-MOSFOA | A | 700-A (0.70×0.10; 32.16) | 6 | 16.9 | 10,164.82 | 0.01941 |
| | B | 1000-A (1.00×0.13; 63.88) | 6 | 16.1 | 19,221.93 | 0.006097 |
| | C | 1200-AB (1.20×0.15; 132.05) | 6 | 16.8 | 41,491.17 | 0.003496 |
| E-MOSFOA | I | 700-A (0.70×0.10; 32.16) | 6 | 16.9 | 10,164.82 | 0.01941 |
| | II | 1000-A (1.00×0.13; 63.88) | 6 | 16.1 | 19,221.93 | 0.006097 |
| | III | 1200-C (1.20×0.15; 190.72) | 6 | 16.8 | 59,924.15 | 0.003496 |
| Thiết kế hiện tại | - | 600-C (0.60×0.10; 39) | 6 | 39.0 | 31,640.22 | 0.03329 |

[Hình 9](#_Ref227779174) và [Bảng 10](#_Ref234860590) tóm tắt lịch sử $HV$ BD được ghi nhận và kho lưu trữ chi phí-chuyển vị cuối cùng. Cả hai thuật toán xác định cùng thiết kế chi phí nhỏ nhất A/I và thiết kế thỏa hiệp B/II. So với thiết kế hiện tại, A/I giảm chi phí 67.9% và chuyển vị 41.7%; B/II giảm chúng lần lượt 39.2% và 81.7%. Các thiết kế chuyển vị nhỏ nhất C và III đều giảm chuyển vị 89.5%, nhưng C có chi phí thấp hơn III 30.8%. Vì A/I cải thiện đồng thời cả hai mục tiêu, thiết kế hiện tại bị trội trong không gian thiết kế được khảo sát.

**Hình 10.** Các $PF$ cho (a) kết cấu MD và (b) kết cấu MJP thu được bởi B-MOSFOA và E-MOSFOA, so với các thiết kế hiện tại.

Ngoài ra, hai thuật toán đề xuất trả về cùng biến thiết kế và giá trị mục tiêu tại A/I và B/II. Do đó, trong các lần chạy này, cả hai phương pháp đều dẫn đến cùng phương án BD chi phí nhỏ nhất và thỏa hiệp. Tại điểm cuối chuyển vị nhỏ nhất, C và III đều đạt 0.003496 m; tuy nhiên, C có chi phí 41,491.17 USD so với 59,924.15 USD cho III. Do đó, B-MOSFOA cung cấp nghiệm ít tốn kém hơn ở cùng chuyển vị được báo cáo.

**Bảng 11. Các thiết kế MD tối ưu đại diện và thiết kế hiện tại.**

| Thuật toán | Thiết kế | Loại cọc ($D_p×t_p$; $P_p$ USD/m) | $n_\theta$ | $L$ (m) | $f_1$ (USD) | $f_2$ (m) |
|---|---|---|---|---|---|---|
| B-MOSFOA | A | 450-A (0.45×0.07; 16.82) | 7 | 16.0 | 2,422.23 | 0.02459 |
| | B | 700-A (0.70×0.10; 32.16) | 6 | 16.0 | 4,630.61 | 0.004941 |
| | C | 1200-A (1.20×0.15; 100.95) | 6 | 16.8 | 15,263.70 | 0.001003 |
| E-MOSFOA | I | 450-A (0.45×0.07; 16.82) | 7 | 16.0 | 2,422.23 | 0.02459 |
| | II | 800-A (0.80×0.11; 40.42) | 6 | 16.0 | 5,821.09 | 0.003261 |
| | III | 1200-C (1.20×0.15; 190.72) | 6 | 16.8 | 28,836.83 | 0.001003 |
| Thiết kế hiện tại | - | 600-B (0.60×0.09; 38) | 6 | 39.0 | 13,121.12 | 0.04268 |

Quy tắc lựa chọn tương tự sau đó được áp dụng cho MD và MJP. [Hình 10](#_Ref227779511) so sánh kho lưu trữ cuối cùng của chúng, và các Bảng 11 và 12 báo cáo các thiết kế đại diện tương ứng. Đối với MD, cả hai thuật toán trả về cùng thiết kế chi phí nhỏ nhất A/I. A/I giảm chi phí 81.5% và chuyển vị 42.4%. Các thiết kế thỏa hiệp khác nhau: B giảm chi phí và chuyển vị lần lượt 64.7% và 88.4%, trong khi II giảm chúng lần lượt 55.6% và 92.4%. Tại điểm cuối chuyển vị nhỏ nhất, C và III đều giảm chuyển vị 97.6%; C có chi phí thấp hơn III 47.1%. Do đó, II ưu tiên độ cứng hơn chi phí tại vùng thỏa hiệp, trong khi C cung cấp điểm cuối độ cứng kinh tế hơn.

**Bảng 12. Các thiết kế MJP tối ưu đại diện và thiết kế hiện tại.**

| Thuật toán | Thiết kế | Loại cọc ($D_p×t_p$; $P_p$ USD/m) | $L_p$ (m) | $l_1$ (m) | $l_2$ (m) | $b×h$ (m) | $f_1$ (USD) | $f_2$ (m) |
|---|---|---|---|---|---|---|---|---|
| B-MOSFOA | A | 300-A (0.30×0.06; 8.12) | 38.7 | 5.3 | 5.6 | 0.5×0.5 | 5,350.32 | 0.001019 |
| | B | 300-A (0.30×0.06; 8.12) | 19.9 | 3.0 | 3.0 | 0.8×0.5 | 11,539.33 | 0.00007103 |
| | C | 1200-B (1.20×0.15; 163.16) | 16.8 | 3.0 | 3.0 | 1.4×2.0 | 126,865.66 | 0.00003877 |
| E-MOSFOA | I | 300-A (0.30×0.06; 8.12) | 37.4 | 5.3 | 3.7 | 0.5×0.5 | 6,935.46 | 0.0005024 |
| | II | 300-B (0.30×0.06; 10.56) | 19.8 | 3.0 | 3.0 | 0.8×0.5 | 12,866.98 | 0.00007101 |
| | III | 1200-C (1.20×0.15; 190.72) | 16.8 | 3.0 | 3.0 | 1.4×2.0 | 139,831.48 | 0.00003877 |
| Thiết kế hiện tại | - | 500-B (0.50×0.08; 27.26) | 38.0 | 4.2 | 4.5 | 0.7×1.0 | 25,708.94 | 0.0002244 |

[Bảng 12](#_Ref234860606) phân biệt ba loại thiết kế MJP. A và I cho chi phí thấp nhất, nhưng chuyển vị của chúng (0.001019 và 0.0005024 m) vượt quá thiết kế hiện tại (0.0002244 m); do đó việc giảm chi phí của chúng đi kèm với độ cứng kết cấu thấp hơn. B và II cải thiện cả hai mục tiêu: chúng giảm chi phí lần lượt 55.1% và 50.0%, và chuyển vị 68.3% và 68.4%. C và III cho chuyển vị nhỏ nhất, cả hai đều đạt mức giảm 82.7%, nhưng chi phí của chúng lần lượt gấp 4.93 và 5.44 lần thiết kế hiện tại. Ở cùng chuyển vị được báo cáo, C có chi phí thấp hơn III 9.3%. Theo đó, A/I là các phương án hướng chi phí, B/II cung cấp các phương án cân bằng, và C/III là các phương án hướng độ cứng.

Các kết quả trong Bảng 10-12 mô tả sự thỏa hiệp chi phí-chuyển vị thông qua các thiết kế đại diện. Tuy nhiên, các so sánh chỉ dựa trên các thiết kế được chọn không cho biết liệu các cải thiện có đạt được với nỗ lực tính toán tương đương hay không, hoặc liệu mọi nghiệm trong kho lưu trữ cuối cùng có thỏa mãn các ràng buộc hay không. Do đó, [Bảng 13](#_Ref234844266) mở rộng đánh giá từ các thiết kế đại diện sang toàn bộ kho lưu trữ cuối cùng. Nó tóm tắt số lần đánh giá hàm, thời gian tính toán, $HV$ chuẩn hóa, số nghiệm khả thi so với kích thước kho lưu trữ, và các tỷ số sử dụng chi phối, cho phép hiệu năng tính toán và tính khả thi toàn kho lưu trữ được xem xét cùng nhau.

Trong [Bảng 13](#_Ref234844266), khả thi/$A_f$ cho biết số thành viên thỏa mãn $P(\mathbf{X}) = 0$ và tất cả các kiểm tra tiền phân tích cứng so với kích thước kho lưu trữ cuối cùng. Các tỷ số sử dụng được báo cáo là $\eta_{M,\max} = \max_{\mathbf{X} \in A_{f}}\frac{\max\left( \left| M_{2}^{FEA} \right|,\left| M_{3}^{FEA} \right| \right)}{M_{c,r}}$, $\eta_{N,\max} = \max_{\mathbf{X} \in A_{f}}\frac{\left| R_{z}^{FEA} \right|}{N_{c,d}}$, và $\eta_{U,\max} = \max_{\mathbf{X} \in A_{f}}\frac{U_{d}}{U_{r}}$ trong đó $A_f$ là kho lưu trữ cuối cùng và các giá trị lớn nhất bao gồm mọi cọc áp dụng được (giá trị không vượt quá 1.0 thỏa mãn giới hạn khả năng chịu lực tương ứng).

**Bảng 13. Nỗ lực tính toán, chất lượng tập Pareto, và tính khả thi kho lưu trữ cuối cùng.**

| Trường hợp | Thuật toán | FEs | Thời gian tính toán (h) | Khả thi/$A_f$ | $HV$ | $\eta_{M,\max}$ | $\eta_{N,\max}$ | $\eta_{U,\max}$ |
|---|---|---|---|---|---|---|---|---|
| BD | B-MOSFOA | 30,100 | 12.92 | 7/7 | 1.0833 | 0.7854 | 0.9908 | 0.0108 |
| | E-MOSFOA | 30,100 | 12.87 | 9/9 | 1.0833 | 0.7854 | 0.9908 | 0.0108 |
| MD | B-MOSFOA | 30,100 | 6.91 | 9/9 | 1.1450 | 0.9971 | 0.9486 | 0.0495 |
| | E-MOSFOA | 30,100 | 6.73 | 10/10 | 1.1450 | 0.9971 | 0.9486 | 0.0495 |
| MJP | B-MOSFOA | 30,100 | 4.32 | 80/80 | 1.1836 | 0.9930 | 0.9955 | - |
| | E-MOSFOA | 30,100 | 5.09 | 100/100 | 1.1735 | 0.9795 | 0.9955 | - |

Các số liệu toàn kho lưu trữ trong [Bảng 13](#_Ref234844266) xác nhận rằng số nghiệm khả thi bằng với kích thước kho lưu trữ cuối cùng trong cả sáu đánh giá. Tỷ số sử dụng chi phối là nén dọc trục đối với BD (0.9908), uốn cọc đối với MD (0.9971), và nén dọc trục đối với MJP (0.9955), với tỷ số uốn thứ cấp MJP tương ứng bằng 0.9930. Tỷ số sử dụng chịu nhổ vẫn thấp đối với BD và MD (0.0108 và 0.0495, tương ứng) và không áp dụng cho MJP. Do đó, tất cả các kho lưu trữ cuối cùng đều thỏa mãn các điều kiện cứng và giới hạn khả năng chịu lực cọc đã triển khai; các tỷ số kiểm soát tiệm cận nhưng không vượt quá 1.

Nỗ lực tính toán được so sánh ở cùng 30,100 lần đánh giá cho mỗi cặp thuật toán-trường hợp. B-MOSFOA và E-MOSFOA yêu cầu thời gian tính toán tương tự cho BD (12.92 và 12.87 giờ) và MD (6.91 và 6.73 giờ). Đối với MJP, B-MOSFOA hoàn thành ở 4.32 giờ và đạt $HV$ chuẩn hóa lớn hơn một chút so với E-MOSFOA (1.1836 so với 1.1735), trong khi E-MOSFOA đạt đến dung lượng kho lưu trữ 100 thành viên ở 5.09 giờ. Do đó, kho lưu trữ E-MOSFOA lớn hơn không chuyển thành $HV$ lớn hơn trong đánh giá đơn-lần-chạy này. Vì mỗi cặp thuật toán-trường hợp được biểu diễn bởi một lần chạy kỹ thuật hoàn chỉnh, các kết quả thời gian và $HV$ mang tính mô tả và không nên được diễn giải là sự vượt trội thống kê.

---

## 5. Kết luận, Hạn chế, và Hướng phát triển Tương lai (Conclusions, Limitations, and Future Work)

Nghiên cứu này mở rộng SFOA sang thiết kế đa mục tiêu với B-MOSFOA, giới thiệu lưu trữ Pareto và lựa chọn thủ lĩnh dựa trên mật độ, và E-MOSFOA, bổ sung tìm kiếm thích ứng và tinh chỉnh giai đoạn cuối. Trên 104 tổ hợp bài toán-chỉ số, E-MOSFOA và B-MOSFOA xếp hạng nhì (2.58) và ba (2.75), gần với MOMSA (2.52); B-MOSFOA cũng cho xếp hạng bộ IMOP tốt nhất (2.28). Do đó, hai biến thể thể hiện hiệu năng cạnh tranh và bổ sung cho nhau chứ không phải sự vượt trội tuyệt đối. Đối với BD, MD, và MJP, quy trình MATLAB-SAP2000 xác định các tập Pareto khả thi định lượng sự thỏa hiệp giữa chi phí xây dựng và chuyển vị. Các thiết kế chi phí thấp hơn thường sử dụng cọc nhỏ hơn hoặc ngắn hơn, trong khi các thiết kế cứng hơn đòi hỏi tiết diện nặng hơn và chi phí cao hơn. Cả sáu kho lưu trữ cuối cùng đều thỏa mãn các ràng buộc đã triển khai, với tỷ số sử dụng lớn nhất là 0.9971.

**Hạn chế:** Trong nghiên cứu này, còn tồn tại hai hạn chế. Thứ nhất, khả năng chịu lực của cọc và ràng buộc ngang được biểu diễn bằng các tính toán truyền thống theo tiêu chuẩn và các gối tựa định hướng-con lăn tương đương. Mặc dù cách tiếp cận này nhất quán với các tiêu chuẩn thiết kế được áp dụng, nó không nắm bắt đầy đủ tương tác đất-cọc phi tuyến hoặc các hiệu ứng nhóm cọc qua trung gian đất. Thứ hai, việc đánh giá mọi ứng viên thông qua SAP2000 đòi hỏi chi phí tính toán đáng kể.

**Hướng phát triển tương lai:** Các nghiên cứu tiếp theo nên khảo sát các mô hình tương tác đất-kết cấu có độ tin cậy cao hơn và giảm số lần đánh giá SAP2000 đầy đủ thông qua các mô hình thay thế (surrogate models) hoặc lấy mẫu thích ứng. Bên cạnh đó, như một khuyến nghị thực tiễn, cơ sở đơn giá tham chiếu được áp dụng nhất quán cho mọi ứng viên và thuật toán, nhờ đó bảo toàn tính nhất quán nội tại của so sánh phương pháp luận. Các ứng dụng dự án nên thay thế các giá trị tham chiếu này bằng các báo giá hiện hành cho vị trí, thời kỳ mua sắm, và điều kiện hợp đồng liên quan.

---

## Đóng góp của các Tác giả (Author Contributions)

**Thanh Do-Quang:** Phương pháp luận, Phần mềm, Điều tra, Viết - Bản thảo gốc; **T. Vu-Huu:** Ý tưởng, Điều tra, Kiểm chứng và Hiệu đính;

**Thanh Cuong-Le**: Ý tưởng, Viết - Xem xét & Hiệu đính.

## Tuyên bố về Sự sẵn có của Dữ liệu (Data Availability Statement)

Dữ liệu hỗ trợ các phát hiện của nghiên cứu này có sẵn từ tác giả liên hệ khi có yêu cầu hợp lý. Các hồ sơ dự án chứa tài liệu của bên thứ ba vẫn phải tuân theo sự cho phép của chủ sở hữu tương ứng.

---

## Phụ lục A (Appendix A)

![](media/image66.png)

**Hình A1.** Quy trình nghiên cứu tổng thể cho việc phát triển thuật toán, đánh giá bài toán chuẩn, và tối ưu hóa thiết kế bến cảng biển.

<!-- -->

**Bảng A1. Kết quả độ nhạy tham số đầy đủ.**

*Ghi chú: Bảng dưới đây giữ nguyên toàn bộ số liệu gốc; chỉ tiêu đề cột được dịch sang tiếng Việt. A1-A5 (nếu xuất hiện trong các bảng khác) không áp dụng cho bảng này — đây là so sánh giữa B-MOSFOA và E-MOSFOA theo từng cấu hình tham số.*

| Thuật toán | Bài toán | $GP_0$ | $N_r$ | $n_{grid}$ | TB $IGD$ | TB $\varepsilon$ | TB $\Delta$ | TB $MS$ | Thời gian chạy/lần (s) |
|---|---|---|---|---|---|---|---|---|---|
| B-MOSFOA | IMOP1 | 0.5 | 200 | 10 | 0.01551 | 0.5835 | 1.117 | 0.7536 | 4.90 |
| | | 0.3 | 200 | 10 | 0.01594 | 0.5756 | 1.109 | 0.6285 | 2.50 |
| | | 0.5 | 100 | 10 | 0.01657 | 0.6169 | 1.085 | 0.7662 | 2.74 |
| | | 0.5 | 200 | 15 | 0.01855 | 0.6709 | 1.080 | 0.5604 | 2.52 |
| | | 0.5 | 200 | 5 | 0.01988 | 0.7448 | 1.079 | 0.5992 | 2.60 |
| | | 0.5 | 300 | 10 | 0.01672 | 0.6168 | 1.097 | 0.7003 | 2.60 |
| | | 0.7 | 200 | 10 | 0.02050 | 0.7511 | 1.064 | 0.5858 | 3.19 |
| | IMOP4 | 0.5 | 200 | 10 | 0.02897 | 1.046 | 1.291 | 1.707 | 6.92 |
| | | 0.3 | 200 | 10 | 0.02679 | 0.9709 | 1.319 | 1.625 | 5.31 |
| | | 0.5 | 100 | 10 | 0.02900 | 1.046 | 1.315 | 1.676 | 5.02 |
| | | 0.5 | 200 | 15 | 0.02889 | 1.036 | 1.330 | 1.642 | 5.01 |
| | | 0.5 | 200 | 5 | 0.03163 | 1.132 | 1.216 | 1.918 | 5.20 |
| | | 0.5 | 300 | 10 | 0.02941 | 1.062 | 1.283 | 1.714 | 4.97 |
| | | 0.7 | 200 | 10 | 0.03223 | 1.139 | 1.259 | 1.850 | 5.07 |
| | RMMEDA_F1 | 0.5 | 200 | 10 | 0.0001667 | 0.01124 | 0.2813 | 1.000 | 33.01 |
| | | 0.3 | 200 | 10 | 0.0001385 | 0.009562 | 0.2673 | 1.000 | 35.77 |
| | | 0.5 | 100 | 10 | 0.0002185 | 0.01409 | 0.2642 | 1.000 | 19.11 |
| | | 0.5 | 200 | 15 | 0.0001499 | 0.01007 | 0.2728 | 1.000 | 33.49 |
| | | 0.5 | 200 | 5 | 0.0001551 | 0.01112 | 0.2869 | 1.000 | 31.59 |
| | | 0.5 | 300 | 10 | 0.0001559 | 0.01082 | 0.3493 | 1.000 | 48.48 |
| | | 0.7 | 200 | 10 | 0.0002490 | 0.01616 | 0.3484 | 1.000 | 29.21 |
| | RMMEDA_F4 | 0.5 | 200 | 10 | 0.001673 | 0.09187 | 0.6283 | 1.139 | 60.23 |
| | | 0.3 | 200 | 10 | 0.001646 | 0.09096 | 0.6316 | 1.044 | 64.91 |
| | | 0.5 | 100 | 10 | 0.002363 | 0.1184 | 0.6310 | 1.058 | 32.68 |
| | | 0.5 | 200 | 15 | 0.001649 | 0.09508 | 0.6302 | 1.049 | 63.49 |
| | | 0.5 | 200 | 5 | 0.001657 | 0.09540 | 0.6302 | 1.020 | 56.60 |
| | | 0.5 | 300 | 10 | 0.001345 | 0.07773 | 0.6238 | 1.045 | 92.57 |
| | | 0.7 | 200 | 10 | 0.001657 | 0.09226 | 0.6237 | 1.044 | 54.34 |
| | UF3 | 0.5 | 200 | 10 | 0.01157 | 0.3525 | 1.073 | 1.000 | 40.72 |
| | | 0.3 | 200 | 10 | 0.01168 | 0.3572 | 1.090 | 1.000 | 41.42 |
| | | 0.5 | 100 | 10 | 0.01167 | 0.3605 | 1.012 | 1.000 | 21.92 |
| | | 0.5 | 200 | 15 | 0.01150 | 0.3490 | 1.066 | 1.000 | 37.63 |
| | | 0.5 | 200 | 5 | 0.01199 | 0.3807 | 1.193 | 1.000 | 39.13 |
| | | 0.5 | 300 | 10 | 0.01179 | 0.3608 | 1.185 | 1.000 | 59.90 |
| | | 0.7 | 200 | 10 | 0.01171 | 0.3630 | 1.133 | 1.000 | 33.52 |
| | UF8 | 0.5 | 200 | 10 | 0.01357 | 0.7362 | 1.339 | 2.179 | 21.62 |
| | | 0.3 | 200 | 10 | 0.01469 | 0.7113 | 1.336 | 2.226 | 25.59 |
| | | 0.5 | 100 | 10 | 0.01462 | 0.7352 | 1.089 | 1.954 | 16.45 |
| | | 0.5 | 200 | 15 | 0.01431 | 0.7478 | 1.349 | 1.911 | 21.38 |
| | | 0.5 | 200 | 5 | 0.01474 | 0.7471 | 1.417 | 2.365 | 20.24 |
| | | 0.5 | 300 | 10 | 0.01361 | 0.7163 | 1.485 | 1.903 | 23.98 |
| | | 0.7 | 200 | 10 | 0.01376 | 0.7275 | 1.343 | 2.144 | 16.51 |
| E-MOSFOA | IMOP1 | 0.5 | 200 | 10 | 0.005999 | 0.02769 | 1.218 | 0.8403 | 16.25 |
| | | 0.3 | 200 | 10 | 0.006324 | 0.03981 | 1.198 | 0.8342 | 7.09 |
| | | 0.5 | 100 | 10 | 0.006090 | 0.02911 | 1.143 | 0.8454 | 11.79 |
| | | 0.5 | 200 | 15 | 0.005822 | 0.02944 | 1.206 | 0.8554 | 13.36 |
| | | 0.5 | 200 | 5 | 0.006061 | 0.02482 | 1.223 | 0.8383 | 15.04 |
| | | 0.5 | 300 | 10 | 0.006047 | 0.03083 | 1.214 | 0.8403 | 12.88 |
| | | 0.7 | 200 | 10 | 0.005661 | 0.02099 | 1.152 | 0.8509 | 21.91 |
| | IMOP4 | 0.5 | 200 | 10 | 0.006628 | 0.3075 | 0.9741 | 1.042 | 10.35 |
| | | 0.3 | 200 | 10 | 0.007051 | 0.3319 | 1.051 | 1.063 | 8.56 |
| | | 0.5 | 100 | 10 | 0.006223 | 0.2901 | 0.9418 | 1.035 | 9.75 |
| | | 0.5 | 200 | 15 | 0.006113 | 0.2858 | 0.9578 | 1.031 | 10.09 |
| | | 0.5 | 200 | 5 | 0.006022 | 0.2831 | 0.9707 | 1.035 | 9.04 |
| | | 0.5 | 300 | 10 | 0.006472 | 0.3027 | 0.9829 | 1.042 | 8.95 |
| | | 0.7 | 200 | 10 | 0.009210 | 0.3918 | 1.015 | 1.135 | 8.96 |
| | RMMEDA_F1 | 0.5 | 200 | 10 | 0.0001225 | 0.009078 | 0.2625 | 1.000 | 41.83 |
| | | 0.3 | 200 | 10 | 0.0001339 | 0.008553 | 0.2550 | 1.000 | 41.23 |
| | | 0.5 | 100 | 10 | 0.0002499 | 0.02046 | 0.3198 | 1.000 | 23.98 |
| | | 0.5 | 200 | 15 | 0.0001231 | 0.008492 | 0.2647 | 1.000 | 41.34 |
| | | 0.5 | 200 | 5 | 0.0001206 | 0.008335 | 0.2576 | 1.000 | 40.06 |
| | | 0.5 | 300 | 10 | 0.00009187 | 0.005767 | 0.2489 | 1.000 | 71.50 |
| | | 0.7 | 200 | 10 | 0.0001194 | 0.009122 | 0.2758 | 1.000 | 40.71 |
| | RMMEDA_F4 | 0.5 | 200 | 10 | 0.001813 | 0.09989 | 0.6166 | 1.003 | 62.02 |
| | | 0.3 | 200 | 10 | 0.001808 | 0.1061 | 0.6289 | 1.003 | 63.68 |
| | | 0.5 | 100 | 10 | 0.002500 | 0.1225 | 0.5978 | 1.004 | 34.64 |
| | | 0.5 | 200 | 15 | 0.001782 | 0.09202 | 0.6135 | 1.003 | 66.27 |
| | | 0.5 | 200 | 5 | 0.001824 | 0.09978 | 0.6125 | 1.005 | 60.04 |
| | | 0.5 | 300 | 10 | 0.001513 | 0.08638 | 0.6193 | 1.003 | 109.69 |
| | | 0.7 | 200 | 10 | 0.001802 | 0.09800 | 0.6100 | 1.003 | 60.18 |
| | UF3 | 0.5 | 200 | 10 | 0.01038 | 0.3166 | 1.489 | 1.000 | 35.15 |
| | | 0.3 | 200 | 10 | 0.01083 | 0.3395 | 1.424 | 1.000 | 42.07 |
| | | 0.5 | 100 | 10 | 0.01041 | 0.3162 | 1.179 | 1.000 | 20.93 |
| | | 0.5 | 200 | 15 | 0.01036 | 0.3158 | 1.480 | 1.000 | 36.65 |
| | | 0.5 | 200 | 5 | 0.01056 | 0.3229 | 1.496 | 1.000 | 36.43 |
| | | 0.5 | 300 | 10 | 0.01037 | 0.3152 | 1.631 | 1.000 | 53.32 |
| | | 0.7 | 200 | 10 | 0.009454 | 0.3002 | 1.632 | 1.000 | 27.76 |
| | UF8 | 0.5 | 200 | 10 | 0.01708 | 0.7167 | 0.7792 | 0.9083 | 35.49 |
| | | 0.3 | 200 | 10 | 0.01550 | 0.7433 | 1.046 | 1.032 | 31.72 |
| | | 0.5 | 100 | 10 | 0.01675 | 0.7211 | 0.7145 | 0.9106 | 21.72 |
| | | 0.5 | 200 | 15 | 0.01856 | 0.7179 | 0.7039 | 0.8886 | 37.30 |
| | | 0.5 | 200 | 5 | 0.01438 | 0.6975 | 0.8680 | 1.231 | 33.35 |
| | | 0.5 | 300 | 10 | 0.01738 | 0.7167 | 0.8272 | 0.9321 | 48.68 |
| | | 0.7 | 200 | 10 | 0.01825 | 0.7097 | 0.7492 | 0.9856 | 39.73 |

---

**Bảng A2. Kết quả chỉ số chi tiết trên các bài toán chuẩn IMOP sau hiệu chỉnh thống kê.**

*Ghi chú: Thứ tự thuật toán cố định A1-A5: A1=MOMSA, A2=NS-MFO, A3=MOGNDO, A4=B-MOSFOA, A5=E-MOSFOA. Các chỉ số thống kê: Tốt nhất (Best), Trung bình (Mean), Độ lệch chuẩn (Std), Hạng (Rank), và Wilcoxon. Ký hiệu +, -, và = biểu thị E-MOSFOA tốt hơn, tệ hơn, hoặc không khác biệt có ý nghĩa thống kê so với thuật toán được so sánh, tương ứng; Ref. xác định cột tham chiếu E-MOSFOA.*

**IMOP 1**

| Chỉ số TK | IGD-A1 | IGD-A2 | IGD-A3 | IGD-A4 | IGD-A5 | ε-A1 | ε-A2 | ε-A3 | ε-A4 | ε-A5 | Δ-A1 | Δ-A2 | Δ-A3 | Δ-A4 | Δ-A5 | MS-A1 | MS-A2 | MS-A3 | MS-A4 | MS-A5 |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| Tốt nhất | 0.01544 | 0.02203 | 0.02818 | 0.00720 | 0.00439 | 0.34478 | 0.72280 | 0.98340 | 0.18023 | 0.00454 | 0.94806 | 0.94530 | 0.99957 | 0.89116 | 1.04795 | 0.40996 | 0.15129 | 0.00363 | 1.03968 | 0.91271 |
| Trung bình | 0.01651 | 0.02379 | 0.02829 | 0.01233 | 0.00582 | 0.42157 | 0.80154 | 0.98712 | 0.45221 | 0.02638 | 1.00636 | 1.00213 | 0.99993 | 1.12925 | 1.15819 | 0.26314 | 0.04840 | 0.00099 | 0.84844 | 0.85172 |
| Độ lệch chuẩn | 0.00067 | 0.00079 | 2.95E-5 | 0.00691 | 0.00055 | 0.04469 | 0.03487 | 0.00100 | 0.25463 | 0.01404 | 0.03825 | 0.01850 | 0.00025 | 0.10149 | 0.03493 | 0.09380 | 0.03934 | 0.00070 | 0.33795 | 0.02533 |
| Hạng | 3 | 4 | 5 | 2 | 1 | 2 | 4 | 5 | 3 | 1 | 3 | 2 | 1 | 4 | 5 | 3 | 4 | 5 | 2 | 1 |
| Wilcoxon | + | + | + | + | Ref. | + | + | + | + | Ref. | - | - | - | = | Ref. | + | + | + | - | Ref. |

**IMOP 2**

| Chỉ số TK | IGD-A1 | IGD-A2 | IGD-A3 | IGD-A4 | IGD-A5 | ε-A1 | ε-A2 | ε-A3 | ε-A4 | ε-A5 | Δ-A1 | Δ-A2 | Δ-A3 | Δ-A4 | Δ-A5 | MS-A1 | MS-A2 | MS-A3 | MS-A4 | MS-A5 |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| Tốt nhất | 0.01733 | 0.02260 | 0.02278 | 0.01143 | 0.02810 | 0.98442 | 1.00113 | 0.99930 | 0.38354 | 1.00000 | 0.93279 | 0.95357 | 0.98888 | 0.95773 | 1.00000 | 0.34346 | 0.11703 | 0.04604 | 0.91520 | 5.17E-5 |
| Trung bình | 0.01933 | 0.02421 | 0.02293 | 0.02467 | 0.02810 | 0.99300 | 1.00256 | 1.00138 | 0.99289 | 1.00000 | 0.98082 | 0.99710 | 0.99604 | 0.99514 | 1.00000 | 0.27118 | 0.06236 | 0.02501 | 0.07715 | 2.01E-6 |
| Độ lệch chuẩn | 0.00171 | 0.00107 | 0.00015 | 0.00272 | 3.31E-7 | 0.00419 | 0.00108 | 0.00295 | 0.11527 | 1.29E-7 | 0.03468 | 0.01804 | 0.00439 | 0.06985 | 2.61E-6 | 0.05721 | 0.03160 | 0.00839 | 0.16032 | 9.43E-6 |
| Hạng | 1 | 3 | 2 | 4 | 5 | 2 | 5 | 4 | 1 | 3 | 1 | 4 | 3 | 2 | 5 | 1 | 3 | 4 | 2 | 5 |
| Wilcoxon | - | - | - | - | Ref. | - | + | = | + | Ref. | - | = | - | - | Ref. | - | - | - | - | Ref. |

**IMOP 3**

| Chỉ số TK | IGD-A1 | IGD-A2 | IGD-A3 | IGD-A4 | IGD-A5 | ε-A1 | ε-A2 | ε-A3 | ε-A4 | ε-A5 | Δ-A1 | Δ-A2 | Δ-A3 | Δ-A4 | Δ-A5 | MS-A1 | MS-A2 | MS-A3 | MS-A4 | MS-A5 |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| Tốt nhất | 0.03537 | 0.04603 | 0.04933 | 0.01939 | 0.01435 | 0.74226 | 0.86500 | 0.95455 | 0.59346 | 0.46932 | 0.84469 | 0.93545 | 0.98544 | 0.55408 | 0.99731 | 0.28788 | 0.10902 | 0.05925 | 1.01841 | 0.99886 |
| Trung bình | 0.03620 | 0.05042 | 0.05043 | 0.02636 | 0.01713 | 0.78050 | 0.88430 | 0.96074 | 0.70377 | 0.53702 | 0.90574 | 0.97890 | 0.99617 | 1.08622 | 1.57929 | 0.26334 | 0.04718 | 0.02181 | 0.98727 | 0.96803 |
| Độ lệch chuẩn | 0.00086 | 0.00164 | 0.00076 | 0.00575 | 0.00468 | 0.01385 | 0.00794 | 0.00258 | 0.08931 | 0.04323 | 0.02706 | 0.01752 | 0.00458 | 0.18993 | 0.12476 | 0.02106 | 0.02242 | 0.01352 | 0.00777 | 0.14791 |
| Hạng | 3 | 4 | 5 | 2 | 1 | 3 | 4 | 5 | 2 | 1 | 1 | 2 | 3 | 4 | 5 | 3 | 4 | 5 | 1 | 2 |
| Wilcoxon | + | + | + | + | Ref. | + | + | + | + | Ref. | - | - | - | - | Ref. | + | + | + | + | Ref. |

**IMOP 4**

| Chỉ số TK | IGD-A1 | IGD-A2 | IGD-A3 | IGD-A4 | IGD-A5 | ε-A1 | ε-A2 | ε-A3 | ε-A4 | ε-A5 | Δ-A1 | Δ-A2 | Δ-A3 | Δ-A4 | Δ-A5 | MS-A1 | MS-A2 | MS-A3 | MS-A4 | MS-A5 |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| Tốt nhất | 0.01852 | 0.00574 | 0.01606 | 0.00328 | 0.00352 | 0.70688 | 0.25534 | 0.60133 | 0.18634 | 0.17697 | 0.79863 | 1.03782 | 0.91523 | 1.04910 | 0.97507 | 0.70316 | 1.76696 | 1.27450 | 1.04695 | 1.01555 |
| Trung bình | 0.02184 | 0.01023 | 0.02777 | 0.00699 | 0.00622 | 0.80346 | 0.42567 | 0.94288 | 0.31682 | 0.27351 | 0.92033 | 1.28627 | 1.00006 | 1.15146 | 1.04076 | 0.32880 | 1.50625 | 0.25435 | 1.02138 | 1.00244 |
| Độ lệch chuẩn | 0.00171 | 0.00181 | 0.00310 | 0.00134 | 0.00078 | 0.04337 | 0.06114 | 0.08359 | 0.04691 | 0.02835 | 0.09152 | 0.10474 | 0.15037 | 0.05015 | 0.03337 | 0.13420 | 0.17590 | 0.34505 | 0.01114 | 0.00305 |
| Hạng | 4 | 3 | 5 | 2 | 1 | 4 | 3 | 5 | 2 | 1 | 1 | 5 | 2 | 4 | 3 | 4 | 1 | 5 | 2 | 3 |
| Wilcoxon | + | + | + | + | Ref. | + | + | + | + | Ref. | - | + | - | + | Ref. | + | - | + | - | Ref. |

**IMOP 5**

| Chỉ số TK | IGD-A1 | IGD-A2 | IGD-A3 | IGD-A4 | IGD-A5 | ε-A1 | ε-A2 | ε-A3 | ε-A4 | ε-A5 | Δ-A1 | Δ-A2 | Δ-A3 | Δ-A4 | Δ-A5 | MS-A1 | MS-A2 | MS-A3 | MS-A4 | MS-A5 |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| Tốt nhất | 0.01135 | 0.01235 | 0.01294 | 0.00353 | 0.01093 | 0.43222 | 0.50721 | 0.56417 | 0.18889 | 0.39366 | 0.65807 | 0.76013 | 0.66289 | 0.70373 | 0.66331 | 0.71161 | 0.69313 | 0.63830 | 0.87165 | 0.76520 |
| Trung bình | 0.01306 | 0.01406 | 0.02278 | 0.00866 | 0.01120 | 0.49195 | 0.60324 | 0.83787 | 0.36639 | 0.41952 | 0.76513 | 0.89111 | 0.89128 | 0.79194 | 0.73573 | 0.60435 | 0.57583 | 0.21035 | 0.78009 | 0.72139 |
| Độ lệch chuẩn | 0.00072 | 0.00075 | 0.00408 | 0.00263 | 0.00016 | 0.04933 | 0.04903 | 0.09973 | 0.07536 | 0.02676 | 0.04356 | 0.04678 | 0.11818 | 0.07122 | 0.03494 | 0.04751 | 0.06843 | 0.15951 | 0.05370 | 0.02449 |
| Hạng | 3 | 4 | 5 | 1 | 2 | 3 | 4 | 5 | 1 | 2 | 2 | 4 | 5 | 3 | 1 | 3 | 4 | 5 | 1 | 2 |
| Wilcoxon | + | + | + | - | Ref. | + | + | + | - | Ref. | + | + | + | + | Ref. | + | + | + | - | Ref. |

**IMOP 6**

| Chỉ số TK | IGD-A1 | IGD-A2 | IGD-A3 | IGD-A4 | IGD-A5 | ε-A1 | ε-A2 | ε-A3 | ε-A4 | ε-A5 | Δ-A1 | Δ-A2 | Δ-A3 | Δ-A4 | Δ-A5 | MS-A1 | MS-A2 | MS-A3 | MS-A4 | MS-A5 |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| Tốt nhất | 0.01914 | 0.02087 | 0.01661 | 0.00539 | 0.00880 | 0.38879 | 0.35607 | 0.34308 | 0.17283 | 0.18299 | 0.64137 | 0.78586 | 0.71311 | 0.62342 | 0.60249 | 1.97593 | 1.75274 | 2.15338 | 1.17442 | 1.02034 |
| Trung bình | 0.02495 | 0.02422 | 0.03045 | 0.00982 | 0.01006 | 0.70071 | 0.48233 | 0.81770 | 0.22261 | 0.22253 | 0.79020 | 0.90070 | 1.06554 | 0.70406 | 0.68183 | 0.90660 | 1.45968 | 1.20835 | 1.07344 | 1.00786 |
| Độ lệch chuẩn | 0.00267 | 0.00107 | 0.00528 | 0.00135 | 0.00263 | 0.09359 | 0.08250 | 0.19710 | 0.02593 | 0.05946 | 0.06110 | 0.04093 | 0.20235 | 0.03979 | 0.04328 | 0.27791 | 0.15583 | 0.46057 | 0.03569 | 0.00500 |
| Hạng | 4 | 3 | 5 | 1 | 2 | 4 | 3 | 5 | 2 | 1 | 3 | 4 | 5 | 2 | 1 | 5 | 1 | 2 | 3 | 4 |
| Wilcoxon | + | + | + | + | Ref. | + | + | + | = | Ref. | + | + | + | + | Ref. | + | - | = | - | Ref. |

**IMOP 7**

| Chỉ số TK | IGD-A1 | IGD-A2 | IGD-A3 | IGD-A4 | IGD-A5 | ε-A1 | ε-A2 | ε-A3 | ε-A4 | ε-A5 | Δ-A1 | Δ-A2 | Δ-A3 | Δ-A4 | Δ-A5 | MS-A1 | MS-A2 | MS-A3 | MS-A4 | MS-A5 |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| Tốt nhất | 0.04001 | 0.02150 | 0.04453 | 0.01528 | 0.01046 | 0.92405 | 0.37884 | 0.99792 | 0.24570 | 0.22106 | 0.68538 | 0.83769 | 0.83919 | 0.85826 | 0.70348 | 0.99127 | 1.91146 | 1.68876 | 1.09099 | 1.38789 |
| Trung bình | 0.04252 | 0.02772 | 0.05245 | 0.01717 | 0.03389 | 0.94747 | 0.57286 | 1.00065 | 0.29329 | 0.74784 | 0.77925 | 1.06062 | 1.06201 | 1.24977 | 1.30803 | 0.38202 | 1.46621 | 0.44704 | 1.04484 | 1.03354 |
| Độ lệch chuẩn | 0.00112 | 0.00485 | 0.00193 | 0.00115 | 0.01229 | 0.01015 | 0.19319 | 0.00536 | 0.02434 | 0.29589 | 0.05944 | 0.08951 | 0.12255 | 0.11233 | 0.23827 | 0.13913 | 0.18282 | 0.40543 | 0.02573 | 0.18354 |
| Hạng | 4 | 2 | 5 | 1 | 3 | 4 | 2 | 5 | 1 | 3 | 1 | 2 | 3 | 4 | 5 | 5 | 1 | 4 | 2 | 3 |
| Wilcoxon | + | - | + | - | Ref. | = | - | + | - | Ref. | - | - | - | - | Ref. | + | - | + | = | Ref. |

**IMOP 8**

| Chỉ số TK | IGD-A1 | IGD-A2 | IGD-A3 | IGD-A4 | IGD-A5 | ε-A1 | ε-A2 | ε-A3 | ε-A4 | ε-A5 | Δ-A1 | Δ-A2 | Δ-A3 | Δ-A4 | Δ-A5 | MS-A1 | MS-A2 | MS-A3 | MS-A4 | MS-A5 |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| Tốt nhất | 0.02301 | 0.03159 | 0.03436 | 0.02099 | 0.01488 | 0.49542 | 0.63430 | 0.73837 | 0.49859 | 0.34130 | 0.66763 | 0.72507 | 0.61607 | 0.66474 | 0.58901 | 1.39706 | 1.02245 | 1.33149 | 1.01476 | 1.00716 |
| Trung bình | 0.02948 | 0.03826 | 0.04074 | 0.02358 | 0.01782 | 0.62916 | 0.68623 | 0.82128 | 0.63324 | 0.46703 | 0.74093 | 0.80451 | 0.72258 | 0.73205 | 0.65138 | 1.30188 | 0.93613 | 1.11645 | 0.98172 | 0.98747 |
| Độ lệch chuẩn | 0.00316 | 0.00193 | 0.00677 | 0.00208 | 0.00107 | 0.06516 | 0.03430 | 0.19430 | 0.14514 | 0.08285 | 0.04427 | 0.04361 | 0.04480 | 0.03482 | 0.02750 | 0.04529 | 0.03658 | 0.09905 | 0.01967 | 0.01225 |
| Hạng | 3 | 4 | 5 | 2 | 1 | 2 | 4 | 5 | 3 | 1 | 4 | 5 | 2 | 3 | 1 | 1 | 5 | 2 | 4 | 3 |
| Wilcoxon | + | + | + | + | Ref. | + | + | + | + | Ref. | + | + | + | + | Ref. | - | + | - | = | Ref. |

---

**Bảng A3. Kết quả chỉ số chi tiết trên các bài toán chuẩn UF sau hiệu chỉnh thống kê.**

*Ghi chú: Thứ tự thuật toán cố định A1-A5: A1=MOMSA, A2=NS-MFO, A3=MOGNDO, A4=B-MOSFOA, A5=E-MOSFOA. Các chỉ số thống kê: Tốt nhất, Trung bình, Độ lệch chuẩn, Hạng, và Wilcoxon. Ký hiệu +, -, và = biểu thị E-MOSFOA tốt hơn, tệ hơn, hoặc không khác biệt có ý nghĩa thống kê so với thuật toán được so sánh, tương ứng; Ref. xác định cột tham chiếu E-MOSFOA.*

**UF 1**

| Chỉ số TK | IGD-A1 | IGD-A2 | IGD-A3 | IGD-A4 | IGD-A5 | ε-A1 | ε-A2 | ε-A3 | ε-A4 | ε-A5 | Δ-A1 | Δ-A2 | Δ-A3 | Δ-A4 | Δ-A5 | MS-A1 | MS-A2 | MS-A3 | MS-A4 | MS-A5 |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| Tốt nhất | 0.00273 | 0.00339 | 0.00575 | 0.00399 | 0.00238 | 0.13422 | 0.17863 | 0.24563 | 0.18554 | 0.10670 | 0.98649 | 1.43796 | 0.71222 | 0.59543 | 0.76326 | 1.89647 | 1.39721 | 1.21212 | 1.86216 | 1.31664 |
| Trung bình | 0.00363 | 0.00420 | 0.00690 | 0.00509 | 0.00287 | 0.19716 | 0.23601 | 0.32074 | 0.22675 | 0.15111 | 1.25653 | 1.66074 | 0.99865 | 0.80280 | 0.95637 | 1.15032 | 1.00280 | 0.97272 | 1.24539 | 1.05885 |
| Độ lệch chuẩn | 0.00035 | 0.00021 | 0.00067 | 0.00049 | 0.00026 | 0.03791 | 0.01985 | 0.04415 | 0.02786 | 0.02596 | 0.11323 | 0.10872 | 0.11477 | 0.11353 | 0.11335 | 0.21985 | 0.17863 | 0.18274 | 0.26945 | 0.12927 |
| Hạng | 2 | 3 | 5 | 4 | 1 | 2 | 4 | 5 | 3 | 1 | 4 | 5 | 3 | 1 | 2 | 2 | 4 | 5 | 1 | 3 |
| Wilcoxon | + | + | + | + | Ref. | + | + | + | + | Ref. | + | + | + | - | Ref. | = | + | = | - | Ref. |

**UF 2**

| Chỉ số TK | IGD-A1 | IGD-A2 | IGD-A3 | IGD-A4 | IGD-A5 | ε-A1 | ε-A2 | ε-A3 | ε-A4 | ε-A5 | Δ-A1 | Δ-A2 | Δ-A3 | Δ-A4 | Δ-A5 | MS-A1 | MS-A2 | MS-A3 | MS-A4 | MS-A5 |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| Tốt nhất | 0.00137 | 0.00284 | 0.00293 | 0.00291 | 0.00157 | 0.08058 | 0.15899 | 0.14625 | 0.14329 | 0.08199 | 0.46006 | 0.59474 | 0.63918 | 1.15351 | 0.89107 | 1.23442 | 1.28209 | 1.85771 | 1.78554 | 1.29754 |
| Trung bình | 0.00162 | 0.00347 | 0.00333 | 0.00380 | 0.00186 | 0.10087 | 0.21435 | 0.17853 | 0.20069 | 0.10142 | 0.58011 | 0.82816 | 0.82849 | 1.33018 | 0.99840 | 1.08900 | 1.09994 | 1.42271 | 1.27562 | 1.10914 |
| Độ lệch chuẩn | 0.00012 | 0.00030 | 0.00021 | 0.00047 | 0.00013 | 0.01198 | 0.01930 | 0.01627 | 0.02620 | 0.00936 | 0.07678 | 0.08715 | 0.09442 | 0.07344 | 0.06214 | 0.05426 | 0.10371 | 0.19760 | 0.19090 | 0.07634 |
| Hạng | 1 | 4 | 3 | 5 | 2 | 1 | 5 | 3 | 4 | 2 | 1 | 2 | 3 | 5 | 4 | 5 | 4 | 1 | 2 | 3 |
| Wilcoxon | - | + | + | + | Ref. | = | + | + | + | Ref. | - | - | - | + | Ref. | = | = | - | - | Ref. |

**UF 3**

| Chỉ số TK | IGD-A1 | IGD-A2 | IGD-A3 | IGD-A4 | IGD-A5 | ε-A1 | ε-A2 | ε-A3 | ε-A4 | ε-A5 | Δ-A1 | Δ-A2 | Δ-A3 | Δ-A4 | Δ-A5 | MS-A1 | MS-A2 | MS-A3 | MS-A4 | MS-A5 |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| Tốt nhất | 0.00804 | 0.00939 | 0.01142 | 0.01101 | 0.00799 | 0.26036 | 0.30618 | 0.35157 | 0.32676 | 0.27899 | 0.95598 | 0.84904 | 1 | 0.91361 | 1.34719 | 2.22602 | 1 | 1.33591 | 1 | 1 |
| Trung bình | 0.00990 | 0.01019 | 0.01287 | 0.01167 | 0.00946 | 0.29244 | 0.33872 | 0.43785 | 0.35539 | 0.29792 | 1.10721 | 1.33915 | 1.60113 | 1.09338 | 1.63032 | 1.29862 | 1 | 0.91120 | 1 | 1 |
| Độ lệch chuẩn | 0.00083 | 0.00041 | 0.00323 | 0.00037 | 0.00069 | 0.01206 | 0.02589 | 0.19217 | 0.01547 | 0.00935 | 0.09371 | 0.33459 | 0.21092 | 0.09252 | 0.10712 | 0.32972 | 0 | 0.31493 | 0 | 0 |
| Hạng | 2 | 3 | 5 | 4 | 1 | 1 | 3 | 5 | 4 | 2 | 2 | 3 | 4 | 1 | 5 | 1 | 3 | 5 | 3 | 3 |
| Wilcoxon | = | + | + | + | Ref. | = | + | + | + | Ref. | - | - | = | - | Ref. | - | n/a | = | n/a | Ref. |

**UF 4**

| Chỉ số TK | IGD-A1 | IGD-A2 | IGD-A3 | IGD-A4 | IGD-A5 | ε-A1 | ε-A2 | ε-A3 | ε-A4 | ε-A5 | Δ-A1 | Δ-A2 | Δ-A3 | Δ-A4 | Δ-A5 | MS-A1 | MS-A2 | MS-A3 | MS-A4 | MS-A5 |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| Tốt nhất | 0.00374 | 0.00287 | 0.00197 | 0.00169 | 0.00163 | 0.11213 | 0.12680 | 0.08662 | 0.05911 | 0.06078 | 0.67511 | 1.16957 | 0.60323 | 0.48938 | 0.48682 | 1.11491 | 1.02270 | 1.08324 | 1.07201 | 1.03958 |
| Trung bình | 0.00391 | 0.00299 | 0.00295 | 0.00207 | 0.00191 | 0.11815 | 0.13375 | 0.11788 | 0.08082 | 0.07585 | 0.74131 | 1.25910 | 0.89291 | 0.72655 | 0.75359 | 1.06757 | 1.00414 | 1.02607 | 1.03007 | 1.01605 |
| Độ lệch chuẩn | 9.03E-5 | 6.26E-5 | 0.00039 | 0.00017 | 0.00016 | 0.00358 | 0.00381 | 0.01430 | 0.00590 | 0.00710 | 0.03439 | 0.04348 | 0.14456 | 0.09336 | 0.12874 | 0.02344 | 0.00662 | 0.02381 | 0.01530 | 0.01038 |
| Hạng | 5 | 4 | 3 | 2 | 1 | 4 | 5 | 3 | 2 | 1 | 2 | 5 | 4 | 1 | 3 | 1 | 5 | 3 | 2 | 4 |
| Wilcoxon | + | + | + | + | Ref. | + | + | + | + | Ref. | = | + | + | = | Ref. | - | + | = | - | Ref. |

**UF 5**

| Chỉ số TK | IGD-A1 | IGD-A2 | IGD-A3 | IGD-A4 | IGD-A5 | ε-A1 | ε-A2 | ε-A3 | ε-A4 | ε-A5 | Δ-A1 | Δ-A2 | Δ-A3 | Δ-A4 | Δ-A5 | MS-A1 | MS-A2 | MS-A3 | MS-A4 | MS-A5 |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| Tốt nhất | 0.11829 | 0.08304 | 0.44929 | 0.26359 | 0.07493 | 0.61446 | 0.46513 | 1.73492 | 1.13581 | 0.52026 | 0.85710 | 0.89154 | 0.79313 | 0.73796 | 0.85678 | 2.75046 | 3.46901 | 2.27339 | 4.28868 | 2.13927 |
| Trung bình | 0.23036 | 0.13230 | 0.51549 | 0.38203 | 0.17392 | 1.03457 | 0.74742 | 2.00741 | 1.52169 | 0.99368 | 0.97958 | 1.16363 | 0.86296 | 0.85271 | 1.07979 | 1.60912 | 1.43323 | 1.66016 | 2.56926 | 1.45011 |
| Độ lệch chuẩn | 0.06962 | 0.02957 | 0.03476 | 0.06998 | 0.06055 | 0.22991 | 0.17632 | 0.17586 | 0.21786 | 0.32560 | 0.06847 | 0.10368 | 0.04119 | 0.05727 | 0.10609 | 0.49068 | 0.57107 | 0.44130 | 0.73012 | 0.45402 |
| Hạng | 3 | 1 | 5 | 4 | 2 | 3 | 1 | 5 | 4 | 2 | 3 | 5 | 2 | 1 | 4 | 3 | 5 | 2 | 1 | 4 |
| Wilcoxon | + | - | + | + | Ref. | = | - | + | + | Ref. | - | + | - | - | Ref. | = | = | = | - | Ref. |

**UF 6**

| Chỉ số TK | IGD-A1 | IGD-A2 | IGD-A3 | IGD-A4 | IGD-A5 | ε-A1 | ε-A2 | ε-A3 | ε-A4 | ε-A5 | Δ-A1 | Δ-A2 | Δ-A3 | Δ-A4 | Δ-A5 | MS-A1 | MS-A2 | MS-A3 | MS-A4 | MS-A5 |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| Tốt nhất | 0.01817 | 0.01750 | 0.03657 | 0.02442 | 0.00751 | 0.52078 | 0.47236 | 0.82041 | 0.57893 | 0.27255 | 0.92798 | 1.21505 | 0.76147 | 0.76912 | 0.87994 | 2.60678 | 2.61879 | 1.75534 | 5.56791 | 4.47558 |
| Trung bình | 0.02358 | 0.01971 | 0.05133 | 0.03160 | 0.01829 | 0.60084 | 0.55840 | 1.18935 | 0.70277 | 0.49799 | 1.18257 | 1.39831 | 0.91141 | 0.90883 | 1.04082 | 1.41422 | 1.27661 | 0.88151 | 1.96385 | 1.17913 |
| Độ lệch chuẩn | 0.00340 | 0.00085 | 0.00515 | 0.00389 | 0.00440 | 0.09264 | 0.06728 | 0.25809 | 0.12370 | 0.15194 | 0.10449 | 0.07558 | 0.06372 | 0.08084 | 0.08116 | 0.58001 | 0.52774 | 0.38498 | 1.04529 | 0.71081 |
| Hạng | 3 | 2 | 5 | 4 | 1 | 3 | 2 | 5 | 4 | 1 | 4 | 5 | 2 | 1 | 3 | 2 | 3 | 5 | 1 | 4 |
| Wilcoxon | + | = | + | + | Ref. | + | + | + | + | Ref. | + | + | - | - | Ref. | = | = | = | - | Ref. |

**UF 7**

| Chỉ số TK | IGD-A1 | IGD-A2 | IGD-A3 | IGD-A4 | IGD-A5 | ε-A1 | ε-A2 | ε-A3 | ε-A4 | ε-A5 | Δ-A1 | Δ-A2 | Δ-A3 | Δ-A4 | Δ-A5 | MS-A1 | MS-A2 | MS-A3 | MS-A4 | MS-A5 |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| Tốt nhất | 0.00238 | 0.00267 | 0.00533 | 0.00299 | 0.00162 | 0.15326 | 0.19592 | 0.28792 | 0.15385 | 0.08747 | 0.82538 | 1.08053 | 0.78039 | 0.59778 | 0.78648 | 1.43259 | 1.47406 | 1.34506 | 1.34981 | 1.27077 |
| Trung bình | 0.00283 | 0.00415 | 0.00965 | 0.00413 | 0.00242 | 0.18620 | 0.25606 | 0.47667 | 0.20952 | 0.14967 | 0.99619 | 1.20772 | 0.90194 | 0.74706 | 0.97622 | 1.06385 | 1.03207 | 0.88797 | 1.19030 | 1.04071 |
| Độ lệch chuẩn | 0.00046 | 0.00298 | 0.00385 | 0.00064 | 0.00069 | 0.01356 | 0.12452 | 0.21853 | 0.02561 | 0.02298 | 0.07987 | 0.06590 | 0.07009 | 0.06777 | 0.12922 | 0.13242 | 0.23130 | 0.36094 | 0.07333 | 0.05834 |
| Hạng | 2 | 4 | 5 | 3 | 1 | 2 | 4 | 5 | 3 | 1 | 4 | 5 | 2 | 1 | 3 | 2 | 4 | 5 | 1 | 3 |
| Wilcoxon | + | + | + | + | Ref. | + | + | + | + | Ref. | = | + | = | - | Ref. | = | = | = | - | Ref. |

**UF 8**

| Chỉ số TK | IGD-A1 | IGD-A2 | IGD-A3 | IGD-A4 | IGD-A5 | ε-A1 | ε-A2 | ε-A3 | ε-A4 | ε-A5 | Δ-A1 | Δ-A2 | Δ-A3 | Δ-A4 | Δ-A5 | MS-A1 | MS-A2 | MS-A3 | MS-A4 | MS-A5 |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| Tốt nhất | 0.01130 | 0.01120 | 0.00870 | 0.00906 | 0.01102 | 0.70792 | 0.70726 | 0.33745 | 0.36826 | 0.65192 | 0.61773 | 0.60807 | 0.66600 | 0.93771 | 0.65318 | 3.32057 | 2.95364 | 4.52971 | 11.01168 | 1.05376 |
| Trung bình | 0.01141 | 0.01156 | 0.01202 | 0.01537 | 0.01761 | 0.71466 | 0.70927 | 0.63450 | 0.69121 | 0.71088 | 0.69875 | 0.66669 | 0.86618 | 1.39001 | 0.73531 | 2.71572 | 2.26413 | 1.59104 | 2.56107 | 0.84665 |
| Độ lệch chuẩn | 7.72E-5 | 0.00033 | 0.00224 | 0.00363 | 0.00218 | 0.00677 | 0.00267 | 0.12299 | 0.14103 | 0.01127 | 0.04203 | 0.03259 | 0.13936 | 0.17584 | 0.08301 | 0.32792 | 0.44348 | 0.71149 | 2.27949 | 0.04824 |
| Hạng | 1 | 2 | 3 | 4 | 5 | 5 | 3 | 1 | 2 | 4 | 2 | 1 | 4 | 5 | 3 | 1 | 3 | 4 | 2 | 5 |
| Wilcoxon | - | - | - | - | Ref. | = | - | = | + | Ref. | = | - | + | + | Ref. | - | - | - | - | Ref. |

**UF 9**

| Chỉ số TK | IGD-A1 | IGD-A2 | IGD-A3 | IGD-A4 | IGD-A5 | ε-A1 | ε-A2 | ε-A3 | ε-A4 | ε-A5 | Δ-A1 | Δ-A2 | Δ-A3 | Δ-A4 | Δ-A5 | MS-A1 | MS-A2 | MS-A3 | MS-A4 | MS-A5 |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| Tốt nhất | 0.00845 | 0.00495 | 0.01518 | 0.01652 | 0.01121 | 0.25353 | 0.16716 | 0.43336 | 0.45800 | 0.32859 | 0.82197 | 0.79823 | 0.55817 | 0.84267 | 0.64937 | 6.12593 | 3.58862 | 3.84660 | 11.50925 | 6.99851 |
| Trung bình | 0.01454 | 0.01131 | 0.02160 | 0.02387 | 0.01803 | 0.44153 | 0.36977 | 0.60308 | 0.66804 | 0.52548 | 0.94193 | 1.01218 | 0.86934 | 1.16722 | 0.88616 | 4.02457 | 1.70767 | 2.20514 | 6.35779 | 3.12729 |
| Độ lệch chuẩn | 0.00291 | 0.00610 | 0.00435 | 0.00352 | 0.00356 | 0.08759 | 0.17145 | 0.12074 | 0.10527 | 0.10858 | 0.07098 | 0.09961 | 0.17339 | 0.16333 | 0.16269 | 0.86385 | 0.62299 | 0.66919 | 2.64436 | 1.22238 |
| Hạng | 2 | 1 | 4 | 5 | 3 | 2 | 1 | 4 | 5 | 3 | 3 | 4 | 1 | 5 | 2 | 2 | 5 | 4 | 1 | 3 |
| Wilcoxon | - | - | + | + | Ref. | - | - | = | + | Ref. | + | + | = | + | Ref. | - | + | + | - | Ref. |

---

**Bảng A4. Kết quả chỉ số chi tiết trên các bài toán chuẩn RM-MEDA sau hiệu chỉnh thống kê.**

*Ghi chú: Thứ tự thuật toán cố định A1-A5: A1=MOMSA, A2=NS-MFO, A3=MOGNDO, A4=B-MOSFOA, A5=E-MOSFOA. Các chỉ số thống kê: Tốt nhất, Trung bình, Độ lệch chuẩn, Hạng, và Wilcoxon. Ký hiệu +, -, và = biểu thị E-MOSFOA tốt hơn, tệ hơn, hoặc không khác biệt có ý nghĩa thống kê so với thuật toán được so sánh, tương ứng; Ref. xác định cột tham chiếu E-MOSFOA.*

**RM-MEDA F1**

| Chỉ số TK | IGD-A1 | IGD-A2 | IGD-A3 | IGD-A4 | IGD-A5 | ε-A1 | ε-A2 | ε-A3 | ε-A4 | ε-A5 | Δ-A1 | Δ-A2 | Δ-A3 | Δ-A4 | Δ-A5 | MS-A1 | MS-A2 | MS-A3 | MS-A4 | MS-A5 |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| Tốt nhất | 9.44E-5 | 9.99E-5 | 0.00034 | 8.74E-5 | 0.00012 | 0.00543 | 0.00632 | 0.02148 | 0.00555 | 0.00722 | 0.23920 | 0.22883 | 1.00024 | 0.22237 | 0.23786 | 2.55144 | 1 | 1 | 1 | 1 |
| Trung bình | 0.00010 | 0.00011 | 0.00040 | 0.00013 | 0.00012 | 0.00702 | 0.00743 | 0.02900 | 0.00907 | 0.00932 | 0.76027 | 0.26323 | 1.09180 | 0.26558 | 0.26492 | 1.67586 | 1 | 1 | 1 | 1 |
| Độ lệch chuẩn | 6.56E-6 | 3.74E-6 | 4.98E-5 | 2.90E-5 | 2.78E-6 | 0.00164 | 0.00094 | 0.00557 | 0.00194 | 0.00144 | 0.34983 | 0.01708 | 0.06238 | 0.01977 | 0.01497 | 0.55385 | 0 | 0 | 0 | 0 |
| Hạng | 1 | 2 | 5 | 4 | 3 | 1 | 2 | 5 | 3 | 4 | 4 | 1 | 5 | 3 | 2 | 1 | 3.5 | 3.5 | 3.5 | 3.5 |
| Wilcoxon | - | - | + | = | Ref. | - | - | + | = | Ref. | + | = | + | = | Ref. | - | = | = | = | Ref. |

**RM-MEDA F2**

| Chỉ số TK | IGD-A1 | IGD-A2 | IGD-A3 | IGD-A4 | IGD-A5 | ε-A1 | ε-A2 | ε-A3 | ε-A4 | ε-A5 | Δ-A1 | Δ-A2 | Δ-A3 | Δ-A4 | Δ-A5 | MS-A1 | MS-A2 | MS-A3 | MS-A4 | MS-A5 |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| Tốt nhất | 9.11E-5 | 0.00010 | 0.00057 | 8.37E-5 | 0.00011 | 0.00637 | 0.00605 | 0.02508 | 0.00552 | 0.00663 | 0.23479 | 0.23618 | 1.15063 | 0.28422 | 0.25364 | 4.29536 | 1 | 1 | 1 | 1 |
| Trung bình | 0.00012 | 0.00013 | 0.00082 | 9.66E-5 | 0.00013 | 0.01485 | 0.00703 | 0.03555 | 0.00731 | 0.00795 | 0.57571 | 0.26444 | 1.25038 | 0.33096 | 0.28850 | 1.41113 | 1 | 1 | 1 | 1 |
| Độ lệch chuẩn | 2.35E-5 | 3.42E-5 | 0.00013 | 9.12E-6 | 1.09E-5 | 0.00964 | 0.00079 | 0.00528 | 0.00135 | 0.00107 | 0.31684 | 0.01563 | 0.05309 | 0.02467 | 0.01980 | 0.68395 | 0 | 0 | 0 | 0 |
| Hạng | 2 | 3 | 5 | 1 | 4 | 4 | 1 | 5 | 2 | 3 | 4 | 1 | 5 | 3 | 2 | 1 | 3.5 | 3.5 | 3.5 | 3.5 |
| Wilcoxon | - | - | + | - | Ref. | + | - | + | - | Ref. | + | - | + | + | Ref. | - | = | = | = | Ref. |

**RM-MEDA F3**

| Chỉ số TK | IGD-A1 | IGD-A2 | IGD-A3 | IGD-A4 | IGD-A5 | ε-A1 | ε-A2 | ε-A3 | ε-A4 | ε-A5 | Δ-A1 | Δ-A2 | Δ-A3 | Δ-A4 | Δ-A5 | MS-A1 | MS-A2 | MS-A3 | MS-A4 | MS-A5 |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| Tốt nhất | 0.00025 | 0.00105 | 0.00651 | 0.01315 | 0.00657 | 0.01253 | 0.05405 | 0.26799 | 0.64390 | 0.21746 | 0.47429 | 0.73548 | 1.36512 | 1.31327 | 1.35408 | 2.15050 | 3.83847 | 7.41632 | 4.63437 | 3.35055 |
| Trung bình | 0.00064 | 0.00527 | 0.01038 | 0.01319 | 0.00832 | 0.02520 | 0.23539 | 0.42508 | 0.69880 | 0.27858 | 0.72933 | 1.03008 | 1.43349 | 1.36277 | 1.42329 | 1.35858 | 1.66758 | 3.95808 | 2.85145 | 1.65147 |
| Độ lệch chuẩn | 0.00037 | 0.00210 | 0.00279 | 6.69E-5 | 0.00089 | 0.01159 | 0.09988 | 0.09960 | 0.01970 | 0.03574 | 0.18916 | 0.15908 | 0.03888 | 0.03329 | 0.05335 | 0.34289 | 0.54128 | 1.58230 | 0.63274 | 0.43368 |
| Hạng | 1 | 2 | 4 | 5 | 3 | 1 | 2 | 4 | 5 | 3 | 1 | 2 | 5 | 3 | 4 | 5 | 3 | 1 | 2 | 4 |
| Wilcoxon | - | - | + | + | Ref. | - | - | + | + | Ref. | - | - | = | - | Ref. | + | = | - | - | Ref. |

**RM-MEDA F4**

| Chỉ số TK | IGD-A1 | IGD-A2 | IGD-A3 | IGD-A4 | IGD-A5 | ε-A1 | ε-A2 | ε-A3 | ε-A4 | ε-A5 | Δ-A1 | Δ-A2 | Δ-A3 | Δ-A4 | Δ-A5 | MS-A1 | MS-A2 | MS-A3 | MS-A4 | MS-A5 |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| Tốt nhất | 0.00270 | 0.00204 | 0.00249 | 0.00155 | 0.00169 | 0.14337 | 0.08517 | 0.10148 | 0.06430 | 0.06750 | 0.63456 | 0.56799 | 0.66880 | 0.57760 | 0.54793 | 3.61566 | 3.12496 | 5.13214 | 1.33197 | 1.01129 |
| Trung bình | 0.00311 | 0.00225 | 0.00300 | 0.00165 | 0.00181 | 0.16931 | 0.10422 | 0.14505 | 0.08911 | 0.09495 | 0.73125 | 0.63549 | 0.75121 | 0.63096 | 0.61202 | 2.68817 | 1.53087 | 1.53313 | 1.04243 | 1.00452 |
| Độ lệch chuẩn | 0.00020 | 0.00017 | 0.00034 | 5.75E-5 | 7.77E-5 | 0.01809 | 0.01207 | 0.04775 | 0.01552 | 0.01541 | 0.04272 | 0.04572 | 0.06741 | 0.03606 | 0.03113 | 0.48325 | 0.64159 | 0.89920 | 0.07781 | 0.00369 |
| Hạng | 5 | 3 | 4 | 1 | 2 | 5 | 3 | 4 | 1 | 2 | 4 | 3 | 5 | 2 | 1 | 1 | 3 | 2 | 4 | 5 |
| Wilcoxon | + | + | + | - | Ref. | + | + | + | = | Ref. | + | = | + | = | Ref. | - | - | - | = | Ref. |

**RM-MEDA F5**

| Chỉ số TK | IGD-A1 | IGD-A2 | IGD-A3 | IGD-A4 | IGD-A5 | ε-A1 | ε-A2 | ε-A3 | ε-A4 | ε-A5 | Δ-A1 | Δ-A2 | Δ-A3 | Δ-A4 | Δ-A5 | MS-A1 | MS-A2 | MS-A3 | MS-A4 | MS-A5 |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| Tốt nhất | 0.00017 | 0.00012 | 0.00041 | 0.00047 | 0.00015 | 0.01041 | 0.00851 | 0.02251 | 0.02550 | 0.00911 | 0.27159 | 0.23609 | 1.07412 | 0.35091 | 0.25359 | 1.72671 | 1 | 1.00039 | 1 | 1 |
| Trung bình | 0.00028 | 0.00202 | 0.00047 | 0.00076 | 0.00018 | 0.02602 | 0.09832 | 0.03037 | 0.04105 | 0.01149 | 0.59190 | 0.61505 | 1.19342 | 0.63358 | 0.28830 | 1.24035 | 0.94402 | 1.00001 | 1 | 1 |
| Độ lệch chuẩn | 0.00012 | 0.00343 | 3.51E-5 | 0.00016 | 1.66E-5 | 0.01370 | 0.12591 | 0.00415 | 0.00858 | 0.00128 | 0.23679 | 0.25512 | 0.06065 | 0.12969 | 0.01947 | 0.25207 | 0.15956 | 7.08E-5 | 0 | 0 |
| Hạng | 2 | 5 | 3 | 4 | 1 | 2 | 5 | 3 | 4 | 1 | 2 | 3 | 5 | 4 | 1 | 1 | 5 | 2 | 3.5 | 3.5 |
| Wilcoxon | + | + | + | + | Ref. | + | + | + | + | Ref. | + | + | + | + | Ref. | - | = | = | = | Ref. |

**RM-MEDA F6**

| Chỉ số TK | IGD-A1 | IGD-A2 | IGD-A3 | IGD-A4 | IGD-A5 | ε-A1 | ε-A2 | ε-A3 | ε-A4 | ε-A5 | Δ-A1 | Δ-A2 | Δ-A3 | Δ-A4 | Δ-A5 | MS-A1 | MS-A2 | MS-A3 | MS-A4 | MS-A5 |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| Tốt nhất | 0.00017 | 0.00028 | 0.00048 | 0.00036 | 0.00021 | 0.02545 | 0.02866 | 0.03152 | 0.02325 | 0.01583 | 0.35461 | 0.40942 | 1.24131 | 0.33457 | 0.30255 | 1.98919 | 1 | 1 | 1 | 1 |
| Trung bình | 0.00095 | 0.00922 | 0.00067 | 0.00150 | 0.00244 | 0.15571 | 0.60787 | 0.04092 | 0.10654 | 0.20380 | 0.60363 | 0.78300 | 1.35054 | 0.47266 | 0.45613 | 1.11606 | 0.53279 | 1 | 0.94487 | 0.85488 |
| Độ lệch chuẩn | 0.00048 | 0.00523 | 0.00015 | 0.00287 | 0.00329 | 0.06393 | 0.32409 | 0.00788 | 0.20953 | 0.26903 | 0.23054 | 0.16136 | 0.06349 | 0.12132 | 0.13472 | 0.35189 | 0.29288 | 0 | 0.16881 | 0.21198 |
| Hạng | 2 | 5 | 1 | 3 | 4 | 3 | 5 | 1 | 2 | 4 | 3 | 4 | 5 | 2 | 1 | 1 | 5 | 2 | 3 | 4 |
| Wilcoxon | = | + | = | + | Ref. | = | + | = | + | Ref. | + | + | + | = | Ref. | = | + | - | = | Ref. |

**RM-MEDA F7**

| Chỉ số TK | IGD-A1 | IGD-A2 | IGD-A3 | IGD-A4 | IGD-A5 | ε-A1 | ε-A2 | ε-A3 | ε-A4 | ε-A5 | Δ-A1 | Δ-A2 | Δ-A3 | Δ-A4 | Δ-A5 | MS-A1 | MS-A2 | MS-A3 | MS-A4 | MS-A5 |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| Tốt nhất | 0.00516 | 0.00708 | 0.01107 | 0.01315 | 0.00571 | 0.17794 | 0.26856 | 0.38037 | 0.63339 | 0.19147 | 0.88686 | 0.79273 | 1.34703 | 1.25508 | 1.19726 | 5.43433 | 2.58865 | 7.41645 | 4.48894 | 2.45702 |
| Trung bình | 0.00591 | 0.00899 | 0.01314 | 0.01317 | 0.00658 | 0.20466 | 0.34152 | 0.59824 | 0.69480 | 0.22655 | 1.04165 | 0.97182 | 1.43207 | 1.30766 | 1.28388 | 2.17705 | 1.88168 | 5.05375 | 2.86172 | 1.55431 |
| Độ lệch chuẩn | 0.00038 | 0.00106 | 0.00117 | 1.55E-5 | 0.00047 | 0.01226 | 0.04282 | 0.10308 | 0.01861 | 0.01906 | 0.07002 | 0.09472 | 0.03939 | 0.02974 | 0.04835 | 0.80204 | 0.27343 | 1.66941 | 0.65088 | 0.31858 |
| Hạng | 1 | 3 | 4 | 5 | 2 | 1 | 3 | 4 | 5 | 2 | 2 | 1 | 5 | 4 | 3 | 3 | 4 | 1 | 2 | 5 |
| Wilcoxon | - | + | + | + | Ref. | - | + | + | + | Ref. | - | - | + | = | Ref. | - | - | - | - | Ref. |

**RM-MEDA F8**

| Chỉ số TK | IGD-A1 | IGD-A2 | IGD-A3 | IGD-A4 | IGD-A5 | ε-A1 | ε-A2 | ε-A3 | ε-A4 | ε-A5 | Δ-A1 | Δ-A2 | Δ-A3 | Δ-A4 | Δ-A5 | MS-A1 | MS-A2 | MS-A3 | MS-A4 | MS-A5 |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| Tốt nhất | 0.00277 | 0.00235 | 0.00276 | 0.00177 | 0.00177 | 0.14845 | 0.10118 | 0.11853 | 0.08522 | 0.08323 | 0.67773 | 0.60816 | 0.71960 | 0.53946 | 0.53579 | 4.35859 | 4.31463 | 3.92198 | 5.01355 | 1.06934 |
| Trung bình | 0.00324 | 0.00358 | 0.00315 | 0.00216 | 0.00199 | 0.17312 | 0.15881 | 0.17151 | 0.11564 | 0.10258 | 0.74916 | 0.75899 | 0.80961 | 0.61898 | 0.60784 | 3.11804 | 1.87353 | 1.36883 | 1.21288 | 1.00442 |
| Độ lệch chuẩn | 0.00022 | 0.00123 | 0.00023 | 0.00034 | 0.00011 | 0.01891 | 0.04436 | 0.04892 | 0.01742 | 0.01218 | 0.04325 | 0.23130 | 0.03712 | 0.03728 | 0.03659 | 0.63740 | 1.04610 | 0.65671 | 0.78311 | 0.01269 |
| Hạng | 4 | 5 | 3 | 2 | 1 | 5 | 3 | 4 | 2 | 1 | 3 | 4 | 5 | 2 | 1 | 1 | 2 | 3 | 4 | 5 |
| Wilcoxon | + | + | + | + | Ref. | + | + | + | + | Ref. | + | + | + | = | Ref. | - | - | - | = | Ref. |

**RM-MEDA F9**

| Chỉ số TK | IGD-A1 | IGD-A2 | IGD-A3 | IGD-A4 | IGD-A5 | ε-A1 | ε-A2 | ε-A3 | ε-A4 | ε-A5 | Δ-A1 | Δ-A2 | Δ-A3 | Δ-A4 | Δ-A5 | MS-A1 | MS-A2 | MS-A3 | MS-A4 | MS-A5 |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| Tốt nhất | 0.00012 | 0.00049 | 0.00022 | 0.00035 | 0.00014 | 0.00673 | 0.04379 | 0.01402 | 0.02406 | 0.00966 | 0.23692 | 0.30341 | 0.63367 | 0.33832 | 0.25507 | 4.61140 | 0.97893 | 0.99987 | 0.98460 | 0.99852 |
| Trung bình | 0.00013 | 0.00090 | 0.00025 | 0.00089 | 0.00019 | 0.00807 | 0.07998 | 0.01921 | 0.06044 | 0.01466 | 0.59420 | 0.40028 | 0.71469 | 0.41972 | 0.30429 | 1.55104 | 0.92701 | 0.99053 | 0.96871 | 0.99425 |
| Độ lệch chuẩn | 9.29E-6 | 0.00036 | 2.95E-5 | 0.00028 | 3.29E-5 | 0.00084 | 0.02289 | 0.00428 | 0.01987 | 0.00375 | 0.37785 | 0.04410 | 0.04191 | 0.06878 | 0.02600 | 0.88463 | 0.03561 | 0.00711 | 0.00938 | 0.00257 |
| Hạng | 1 | 5 | 3 | 4 | 2 | 1 | 5 | 3 | 4 | 2 | 4 | 2 | 5 | 3 | 1 | 1 | 5 | 3 | 4 | 2 |
| Wilcoxon | - | + | + | + | Ref. | - | + | + | + | Ref. | = | + | + | + | Ref. | - | + | = | + | Ref. |

---

## Tài liệu Tham khảo (References)

*Ghi chú: Danh mục tài liệu tham khảo được giữ nguyên bằng tiếng Anh theo đúng thông lệ trích dẫn học thuật quốc tế (không dịch tên sách, tên bài báo, tên tạp chí, và tên nhà xuất bản).*

1. International Navigation Association (PIANC), *Guidelines for the Design of Fender Systems*. 2002, PIANC: Brussels, Belgium.

2. The Overseas Coastal Area Development Institute of Japan - OCDI, *Technical Standards for Port and Harbour Facilities in Japan*. 2002, Tokyo, Japan: The Overseas Coastal Area Development Institute of Japan (OCDI).

3. Ministry of Science and Technology, *TCVN 7888:2014 - Pre-Stressed Concrete Piles -- Vietnamese National Design Standard*. Vol. TCVN 7888:2014. 2014, Hanoi, Vietnam: Ministry of Science and Technology.

4. Ministry of Science and Technology of Vietnam, *TCVN 10304:2014 - Pile Foundation -- Vietnamese National Design Standard*. Vol. TCVN 10304:2014. 2014, Hanoi, Vietnam: Ministry of Science and Technology of Vietnam.

5. Deb, K., *Multi-Objective Optimization using Evolutionary Algorithms*. 2001: Wiley.

6. Miettinen, K., *Nonlinear multiobjective optimization*. Vol. 12. 1999: Springer Science & Business Media.

7. Zitzler, E. and L. Thiele, *Multiobjective evolutionary algorithms: a comparative case study and the strength Pareto approach.* IEEE Transactions on Evolutionary Computation, 1999. **3**(4): p. 257-271.

8. Marler, R.T. and J.S. Arora, *Survey of multi-objective optimization methods for engineering.* Structural and Multidisciplinary Optimization, 2004. **26**(6): p. 369-395.

9. Khodadadi, N., et al., *Multi-objective generalized normal distribution optimization: a novel algorithm for multi-objective problems.* Cluster Computing, 2024. **27**: p. 10589-10631.

10. Vu-Huu, T., S. Khatir, and T. Cuong-Le, *Real-World Steel Frame Optimization Using a Hybrid Leader Selection-Based Multi-Objective Flow Direction Algorithm.* International Journal for Numerical Methods in Engineering, 2025. **126**(15): p. e70098.

11. Mirjalili, S., et al., *Salp Swarm Algorithm: A bio-inspired optimizer for engineering design problems.* Advances in Engineering Software, 2017. **114**: p. 163-191.

12. Rajwar, K., K. Deep, and S. Das, *An exhaustive review of the metaheuristic algorithms for search and optimization: taxonomy, applications, and open challenges.* Artificial Intelligence Review, 2023. **56**(11): p. 13187-13257.

13. Savsani, V. and M.A. Tawhid, *Non-dominated sorting moth flame optimization (NS-MFO) for multi-objective problems.* Engineering Applications of Artificial Intelligence, 2017. **63**: p. 20-32.

14. Jameel, M. and M. Abouhawwash, *Multi-objective Mantis Search Algorithm (MOMSA): A novel approach for engineering design problems and validation.* Computer Methods in Applied Mechanics and Engineering, 2024. **422**: p. 116840.

15. Storn, R. and K. Price, *Differential Evolution -- A Simple and Efficient Heuristic for global Optimization over Continuous Spaces.* Journal of Global Optimization, 1997. **11**(4): p. 341-359.

16. Mergos, P.E., *Surrogate-based optimum design of 3D reinforced concrete building frames to Eurocodes.* Developments in the Built Environment, 2022. **11**: p. 100079.

17. Xu, A., et al., *Structural Optimization of a Multi-Story Frame Structure Based on a Pre-Trained Physics-Informed Neural Network (PINN) Surrogate Model.* Computer Modeling in Engineering & Sciences, 2026. **147**(1): p. 9.

18. Seixas, M., et al., *Analysis of a self-supporting bamboo structure with flexible joints.* International Journal of Space Structures, 2021. **36**(2): p. 137-151.

19. Takva, Y., C. Takva, and F. Goksen, *A Contemporary House Proposal: Structural Analysis of Wood and Steel Bungalows.* Engineering, Technology & Applied Science Research, 2023. **13**(3): p. 11032-11035.

20. Vu, H.T., *A Real-World Application of Multi-Optimization for a Berthing Structure Using the MOMVO Algorithm.* International Journal of Marine Science and Technology, 2026. **2**(1): p. 16-22.

21. Do, Q.T., et al. *Efficient Design of Single Mooring Buoy Lines: A MOMSA-Based Approach*. 2026. Cham: Springer Nature Switzerland.

22. Vu-Huu, T. and T. Cuong-Le. *A Novel Approach to Multi-objective Topology Optimization of Pile Foundations: The MOMPA Algorithm*. 2026. Cham: Springer Nature Switzerland.

23. Ahmadi-Nedushan, B. and R. Javanmardi, *SM Toolbox Version 6.9. 7 Instructions.* 2021.

24. Zhong, C., et al., *Starfish optimization algorithm (SFOA): a bio-inspired metaheuristic algorithm for global optimization compared with 100 optimizers.* Neural Computing and Applications, 2025(5): p. 3641-3683.

25. Wolpert, D.H. and W.G. Macready, *No free lunch theorems for optimization.* IEEE Transactions on Evolutionary Computation, 1997. **1**(1): p. 67-82.

26. Tian, Y., et al., *Diversity Assessment of Multi-Objective Evolutionary Algorithms: Performance Metric and Benchmark Problems [Research Frontier].* IEEE Computational Intelligence Magazine, 2019. **14**(3): p. 61-74.

27. Zhang, Q., et al., *Multiobjective optimization Test Instances for the CEC 2009 Special Session and Competition*. 2009, University of Essex and Nanyang Technological University: Colchester, UK and Singapore. p. 1-30.

28. Zhang, Q., A. Zhou, and Y. Jin, *RM-MEDA: A Regularity Model-Based Multiobjective Estimation of Distribution Algorithm.* IEEE Transactions on Evolutionary Computation, 2008. **12**(1): p. 41-63.

29. Knowles, J.D., L. Thiele, and E. Zitzler, *A tutorial on the performance assessment of stochastic multiobjective optimizers*. 2006, ETH Zurich, Computer Engineering and Networks Laboratory (TIK): Zurich, Switzerland.

30. Zitzler, E., K. Deb, and L. Thiele, *Comparison of Multiobjective Evolutionary Algorithms: Empirical Results.* Evolutionary Computation, 2000. **8**(2): p. 173-195.

31. Riquelme, N., C.V. Lücken, and B. Baran. *Performance metrics in multi-objective optimization*. in *2015 Latin American Computing Conference (CLEI)*. 2015.

32. Abouhawwash, M., M. Jameel, and K. Deb, *A smooth proximity measure for optimality in multi-objective optimization using Benson's method.* Computers & Operations Research, 2020. **117**: p. 104900.

33. Wilcoxon, F., *Individual comparisons by ranking methods*, in *Breakthroughs in statistics*. 1992, Springer. p. 196-202.

34. Mann, H.B. and D.R. Whitney, *On a Test of Whether one of Two Random Variables is Stochastically Larger than the Other.* The Annals of Mathematical Statistics, 1947. **18**(1): p. 50-60.

35. Derrac, J., et al., *A practical tutorial on the use of nonparametric statistical tests as a methodology for comparing evolutionary and swarm intelligence algorithms.* Swarm and Evolutionary Computation, 2011. **1**(1): p. 3-18.

36. Holm, S., *A Simple Sequentially Rejective Multiple Test Procedure.* Scandinavian Journal of Statistics, 1979. **6**(2): p. 65-70.

37. Benson, H.P., *Multicriteria Optimization, Matthias Ehrgott, Springer (2005), 323 pages, ISBN: 3-540-21398-8*. 2007, Elsevier.

38. Miettinen, K., F. Ruiz, and A.P. Wierzbicki, *Introduction to Multiobjective Optimization: Interactive Approaches*, in *Multiobjective Optimization: Interactive and Evolutionary Approaches*, J. Branke, et al., Editors. 2008, Springer Berlin Heidelberg: Berlin, Heidelberg. p. 27-57.

39. Edgeworth, F.Y., *Mathematical psychics: An essay on the application of mathematics to the moral sciences*. 1881, London: C. Kegan Paul & Co.

40. Pareto, V., *Cours d'économie politique*. Vol. 1. 1964: Librairie Droz.

41. Mavrotas, G., *Effective implementation of the ε-constraint method in Multi-Objective Mathematical Programming problems.* Applied Mathematics and Computation, 2009. **213**(2): p. 455-465.

42. Knowles, J.D. and D.W. Corne, *Approximating the Nondominated Front Using the Pareto Archived Evolution Strategy.* Evolutionary Computation, 2000. **8**(2): p. 149-172.

43. Zitzler, E., M. Laumanns, and L. Thiele, *SPEA2: Improving the strength Pareto evolutionary algorithm*. 2001, ETH Zurich, Computer Engineering and Networks Laboratory (TIK).

44. Coello, C.A.C., G.T. Pulido, and M.S. Lechuga, *Handling Multiple Objectives with Particle Swarm Optimization.* IEEE Transactions on Evolutionary Computation, 2004. **8**(3): p. 256-279.

45. McKay, M.D., R.J. Beckman, and W.J. Conover, *A Comparison of Three Methods for Selecting Values of Input Variables in the Analysis of Output from a Computer Code.* Technometrics, 1979. **21**(2): p. 239-245.

46. Deb, K., et al., *A fast and elitist multiobjective genetic algorithm: NSGA-II.* IEEE Transactions on Evolutionary Computation, 2002. **6**(2): p. 182-197.

47. Hai Linh Hai Phong Petroleum One Member Company Limited, *As-built drawings for the repair of berthing dolphins for a 10,000-DWT vessel at Hai Linh Petroleum Port, Hai Phong*. 2020, Hai Linh Hai Phong Petroleum One Member Company Limited: Hai Phong, Vietnam.

48. Hai Linh Hai Phong Petroleum One Member Company Limited, *Periodic inspection calculations for the marine structural system of Hai Linh Petroleum Port, Hai Phong*. 2023, Hai Linh Hai Phong Petroleum One Member Company Limited: Hai Phong, Vietnam.

49. C. S. A. Group, *CSA A23.3-14: Design of concrete structures*. 2014, CSA Group: Mississauga, Ontario, Canada. p. 1-297.

50. Hai Phong Department of Construction, *Construction-material price announcement applicable from January 2025, including prestressed spun concrete piles*. 2025, Hai Phong Department of Construction: Hai Phong, Vietnam.

51. Hai Phong Department of Construction, *Announcement of construction-material prices in Hai Phong City, May 2025*. 2025, Hai Phong Department of Construction: Hai Phong, Vietnam.

52. Ministry of Transport of Vietnam, *22 TCN 222-95: Loads and actions due to waves and vessels on hydraulic structures*. 1995, Ministry of Transport of Vietnam: Hanoi, Vietnam.

53. Audet, C., et al., *Performance indicators in multiobjective optimization.* European Journal of Operational Research, 2021. **292**(2): p. 397-422.

54. Zelany, M., *A concept of compromise solutions and the method of the displaced ideal.* Computers & Operations Research, 1974. **1**(3): p. 479-496.

---

*Hết bản dịch. Tài liệu này được dịch từ bản gốc tiếng Anh [02_MOSFOA__VN.docx](02_MOSFOA__VN.docx) phục vụ mục đích biên soạn Chuyên đề 2 và 3 của Luận án Tiến sĩ. Các hình vẽ (Hình 1-10, A1) tham chiếu đến các tệp ảnh gốc trong thư mục `media/` của tài liệu Word gốc và cần được chèn lại thủ công nếu xuất bản riêng file Markdown này.*


