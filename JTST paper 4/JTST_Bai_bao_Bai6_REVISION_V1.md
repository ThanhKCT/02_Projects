# ỨNG DỤNG THUẬT TOÁN MOSFOA TRONG TỐI ƯU ĐA MỤC TIÊU HỆ KẾT CẤU BÊN TRÊN CẦU TÀU CHỊU NHIỀU TỔ HỢP TẢI TRỌNG

## APPLICATION OF MOSFOA TO MULTI-OBJECTIVE OPTIMIZATION OF PORT JETTY SUPERSTRUCTURE UNDER MULTIPLE LOAD COMBINATIONS

**[TÊN TÁC GIẢ — TO BE VERIFIED, đối chiếu lại với các bài trước cùng nhóm]**

¹Trường Đại học Hàng hải Việt Nam

*Tác giả liên hệ: [TO BE VERIFIED — email, địa chỉ]*

---

## 1. Tóm tắt

Tối ưu hóa kết cấu là công cụ quan trọng để cân bằng giữa khối lượng vật liệu và khả năng chịu lực trong thiết kế công trình cảng, đặc biệt khi phương án thiết kế phải đồng thời thỏa mãn một hệ lớn các tổ hợp tải trọng. Nghiên cứu này áp dụng thuật toán tối ưu đa mục tiêu MOSFOA (đã công bố trước đó, không cải tiến/so sánh trong bài này) để giải bài toán tối ưu hệ kết cấu bên trên (dầm ngang, dầm dọc, dầm cần trục, bản mặt cầu) của một mô hình nghiên cứu giả định cầu tàu 70.000 DWT, xây dựng dựa trên bộ thông số kỹ thuật của Bến số 1 – Cảng Chân Mây, tích hợp MOSFOA–MATLAB–SAP2000 và xét đồng thời 410 tổ hợp tải trọng được mô hình hóa trong SAP2000 (408 tổ hợp cơ bản: 388 tổ hợp trạng thái giới hạn cực hạn ULSB và 20 tổ hợp trạng thái giới hạn khai thác SLSDH, cộng 2 tổ hợp bao dẫn xuất `BAO-ULSB`/`BAO-SLSDH`). Bốn biến thiết kế (chiều cao dầm ngang, dầm dọc, dầm cần trục và chiều dày bản mặt cầu) được tối ưu đồng thời theo hai mục tiêu: cực tiểu hóa khối lượng bê tông và cực tiểu hóa hệ số khai thác lớn nhất của kết cấu. Campaign chính thức gồm 20 lần chạy độc lập (40.400 lần đánh giá) cho kết quả hội tụ ổn định: khối lượng nhỏ nhất tìm được giống hệt nhau (2.311,93 tấn, độ lệch chuẩn bằng 0) ở cả 20 lần chạy, hình thành một mặt Pareto tổng thể gồm 90 nghiệm không bị trội. Phân tích hậu kỳ trên 3 nghiệm đại diện (tách riêng đầy đủ 408 tổ hợp cơ bản) xác định bản mặt cầu là cấu kiện chi phối hệ số khai thác ở cả ba nghiệm, và xác định các tổ hợp tải trọng cụ thể chi phối nội lực cọc và chuyển vị ngang một cách nhất quán ở cả ba nghiệm được kiểm tra. Kết quả cung cấp một minh chứng bổ sung cho khả năng áp dụng MOSFOA vào bài toán tối ưu kết cấu cảng có nhiều biến thiết kế và ràng buộc từ mô hình phần tử hữu hạn.

**Từ khóa**: Tối ưu đa mục tiêu; MOSFOA; cầu tàu; hệ kết cấu bên trên; SAP2000; tổ hợp tải trọng; tối ưu kết cấu.

## 2. Abstract

Structural optimization is an important tool for balancing material mass and load-carrying capacity in port structure design, particularly when a design candidate must simultaneously satisfy a large set of load combinations. This study applies the multi-objective Starfish Optimization Algorithm (MOSFOA — a previously published algorithm, neither modified nor benchmarked against other methods in this work) to solve a superstructure optimization problem (transverse beams, longitudinal beams, crane beams, and deck slab) for an assumed research model of a 70,000 DWT port jetty, constructed from the technical parameters of Berth No. 1 — Chan May Port, integrating MOSFOA–MATLAB–SAP2000 and simultaneously considering the 410 load combinations represented in the SAP2000 model (408 individual combinations — 388 Ultimate Limit State, ULSB, and 20 Serviceability Limit State, SLSDH — plus 2 derived envelope combinations, `BAO-ULSB`/`BAO-SLSDH`). Four design variables (transverse beam height, longitudinal beam height, crane beam height, and deck slab thickness) were simultaneously optimized for two objectives: minimizing concrete mass and minimizing the maximum utilization ratio, the latter evaluated during the search using the two envelope combinations as a conservative search-stage aggregation tool. The official campaign of 20 independent runs (40,400 evaluations) produced stable convergence: the minimum mass found was identical across all 20 runs (2,311.93 tons, standard deviation = 0), forming an overall non-dominated Pareto front of 90 solutions. For three representative solutions selected from this front, the 408 individual ULSB/SLSDH combinations were subsequently evaluated separately — independently of the envelope combinations used during the search — to verify the true maximum utilization ratio and its governing combination; this post-processing identified the deck slab as the governing member for the utilization ratio at all three representative solutions, and identified specific load combinations that consistently govern pile axial force and lateral displacement at all three solutions examined. The results provide additional evidence for the applicability of MOSFOA to port structural optimization problems involving multiple design variables and finite-element-model-derived constraints.

**Keywords**: Multi-objective optimization; MOSFOA; port jetty; superstructure; SAP2000; load combinations; structural optimization.

---

## 3. Introduction (Giới thiệu)

### 3.1. Bối cảnh nghiên cứu

Tối ưu hóa kết cấu đóng vai trò ngày càng quan trọng trong thiết kế công trình cảng, nơi yêu cầu cân bằng giữa khối lượng vật liệu sử dụng và khả năng chịu lực của kết cấu dưới điều kiện khai thác phức tạp. Khác với nhiều bài toán tối ưu kết cấu dân dụng chỉ cần xét một số ít tổ hợp tải trọng tiêu chuẩn, kết cấu bến cảng — đặc biệt là cầu tàu tiếp nhận tàu trọng tải lớn — phải đồng thời chịu tác động của nhiều nhóm tải trọng có bản chất khác nhau (tĩnh tải, hoạt tải khai thác, tải trọng cần trục, va tàu, neo tàu, tải trọng môi trường: gió, dòng chảy, nhiệt độ), dẫn đến một hệ tổ hợp tải trọng rất lớn (có thể lên tới hàng trăm tổ hợp) mà mỗi phương án thiết kế đều phải thỏa mãn đồng thời. Điều này khiến bài toán tối ưu kết cấu cầu tàu trở thành một bài toán có ràng buộc phức tạp, đòi hỏi phương pháp giải phù hợp để xử lý khối lượng tính toán lớn phát sinh từ việc lặp lại phân tích phần tử hữu hạn (FEM) cho mỗi phương án thiết kế qua toàn bộ hệ tổ hợp.

Các phương pháp metaheuristic (thuật toán tối ưu dựa trên tự nhiên/quần thể) đã cho thấy khả năng ứng dụng rộng rãi trong việc giải các bài toán tối ưu kết cấu phi tuyến, nhiều biến, có ràng buộc phức tạp mà các phương pháp giải tích truyền thống khó xử lý trực tiếp — đặc biệt khi hàm mục tiêu/ràng buộc phải được đánh giá gián tiếp thông qua một mô hình phân tích kết cấu (FEM) bên ngoài.

### 3.2. Tổng quan nghiên cứu

Các phương pháp metaheuristic đã được sử dụng rộng rãi trong tối ưu hóa kết cấu, đặc biệt cho các bài toán có biến thiết kế rời rạc, ràng buộc phi tuyến và không gian tìm kiếm lớn mà phương pháp giải tích cổ điển khó xử lý trực tiếp [4]. Trong tối ưu đa mục tiêu, các phương pháp dựa trên sắp xếp không trội (Pareto-based non-dominated sorting), tiêu biểu là NSGA-II, đã trở thành nền tảng phổ biến cho nhiều thuật toán tối ưu đa mục tiêu sau này, bao gồm cả các biến thể metaheuristic mới hơn sử dụng cơ chế lưu trữ/lưới để duy trì tính đa dạng của tập nghiệm không trội [5]. Khi hàm mục tiêu và ràng buộc được đánh giá trực tiếp thông qua mô hình phần tử hữu hạn (FEM) thay vì công thức giải tích đơn giản hóa, chi phí tính toán có thể tăng đáng kể khi số lượng phương án thiết kế và số lượng tổ hợp tải trọng cần kiểm tra tăng lên. Một số nghiên cứu gần đây đã áp dụng và so sánh nhiều thuật toán tối ưu đa mục tiêu (NSGA-II, NSGA-III, GDE3, OMOPSO, SPEA2, MOEA/D) cho bài toán tối ưu kết cấu giàn thép chịu đồng thời các ràng buộc cường độ và khai thác dưới nhiều tổ hợp tải trọng, dựa trên phân tích phi tuyến trực tiếp [6]. Các nghiên cứu này cho thấy khả năng ứng dụng của phương pháp tối ưu đa mục tiêu kết hợp FEM cho bài toán kết cấu có nhiều ràng buộc kỹ thuật đồng thời, nhưng phần lớn tập trung vào kết cấu giàn thép hoặc cấu kiện đơn lẻ; còn ít nghiên cứu áp dụng cho bài toán lựa chọn cấu hình hệ kết cấu bên trên cầu tàu chịu đồng thời số lượng lớn tổ hợp tải trọng như trong nghiên cứu này.

Trong các nghiên cứu trước đây, nhóm tác giả đã từng bước khảo sát khả năng ứng dụng các thuật toán tối ưu sao biển cho các bài toán kết cấu cảng dựa trên mô hình phần tử hữu hạn. Cụ thể, nhóm tác giả đã áp dụng SFOA cho bài toán tối ưu đơn mục tiêu thể tích bê tông của kết cấu tường chắn phía sau cầu tàu, trong đó các biến chiều dày kết cấu được tối ưu đồng thời dưới nhiều nhóm ràng buộc kỹ thuật [2]. Trên cơ sở phát triển MOSFOA [1], nghiên cứu tiếp theo mở rộng sang bài toán tối ưu đa mục tiêu hệ cọc cầu tàu, với hai mục tiêu khối lượng vật liệu và chuyển vị ngang, đồng thời kiểm chứng kết quả trên hai trường hợp cầu tàu có quy mô và điều kiện địa kỹ thuật khác nhau [3]. Các kết quả này tạo cơ sở để tiếp tục khảo sát MOSFOA trên một bộ phận kết cấu khác của cầu tàu trong nghiên cứu hiện tại, tập trung vào hệ kết cấu bên trên và ảnh hưởng của nhiều tổ hợp tải trọng đến khả năng khai thác của các cấu kiện. Khác với nghiên cứu về hệ cọc, nghiên cứu hiện tại tập trung vào các cấu kiện bên trên cầu tàu và xem xét đồng thời khối lượng bê tông với hệ số khai thác kết cấu dưới một số lượng lớn tổ hợp tải trọng trong mô hình phần tử hữu hạn.

### 3.3. Khoảng trống nghiên cứu

Các nghiên cứu ứng dụng tối ưu đa mục tiêu cho kết cấu cầu tàu còn cần được mở rộng sang bài toán lựa chọn cấu hình hệ kết cấu bên trên trong điều kiện phải đồng thời đáp ứng nhiều tổ hợp tải trọng và ràng buộc kỹ thuật rút ra trực tiếp từ mô hình phần tử hữu hạn.

### 3.4. Mục tiêu và phạm vi nghiên cứu

Nghiên cứu này sử dụng thuật toán MOSFOA (đã công bố) để giải bài toán tối ưu đa mục tiêu hệ kết cấu bên trên cầu tàu, với SAP2000 đảm nhiệm phân tích phần tử hữu hạn và MATLAB điều khiển toàn bộ quá trình tối ưu. Đối tượng nghiên cứu là một **mô hình nghiên cứu giả định** cầu tàu 70.000 DWT, xây dựng dựa trên bộ thông số kỹ thuật của Bến số 1 – Cảng Chân Mây. Nghiên cứu **không** nhằm đánh giá/kiểm định công trình hiện hữu, **không** so sánh với hồ sơ thiết kế gốc, và **không** sử dụng kết quả tối ưu để đưa ra kết luận về công trình thực tế.

---

## 4. Methodology (Phương pháp nghiên cứu)

### 4.1. Phát biểu bài toán tối ưu đa mục tiêu

Bài toán tối ưu đa mục tiêu có ràng buộc được phát biểu tổng quát:

$$\min \mathbf{F}(\mathbf{x}) = [f_1(\mathbf{x}), f_2(\mathbf{x})]$$

với $\mathbf{x} = [x_1, x_2, x_3, x_4]$ là vector biến thiết kế, chịu ràng buộc $g_j(\mathbf{x}) \le 0$, $j=1,\ldots,4$. Trong bài báo này, $f_1$ và $f_2$ (được định nghĩa chi tiết ở mục 6.2) là các **objective dùng trực tiếp trong quá trình tối ưu (search-stage)**; đại lượng $\eta_{max,true}$ dùng trong mục 7 là **kết quả kỹ thuật đã được xác nhận** (verified engineering quantity) từ hậu kiểm 408 tổ hợp riêng lẻ cho các nghiệm đại diện — hai loại đại lượng này được phân biệt rõ trong toàn bài, xem mục 4.4 và 7.7.

### 4.2. Thuật toán MOSFOA

MOSFOA (Multi-objective Starfish Optimization Algorithm) là thuật toán tối ưu đa mục tiêu đã được công bố trước đó bởi nhóm tác giả [1], không được phát triển lại hay cải tiến trong nghiên cứu này (sơ đồ khối đầy đủ xem Hình 1, chuyển thể từ [1]). Cấu trúc thuật toán gồm: khởi tạo quần thể (Xi) và tính đa mục tiêu Fit(Xi); khởi tạo kho lưu trữ A từ các nghiệm không bị trội và chia không gian mục tiêu thành các hypercube phục vụ duy trì đa dạng theo cơ chế lưới; trong mỗi vòng lặp, chọn nghiệm dẫn hướng (Xleader) từ A bằng kỹ thuật vòng quay roulette theo chất lượng từng hypercube, sau đó một hệ số điều khiển pha phụ thuộc số vòng lặp (GP) quyết định giữa pha khám phá (exploration) và pha khai thác (exploitation). Trong pha khám phá, thuật toán chọn giữa cơ chế đột biến thích nghi kiểu Differential Evolution có dẫn hướng bởi Xleader (áp dụng khi số biến thiết kế D>5) hoặc cơ chế "energy-step" giảm dần theo vòng lặp (áp dụng khi D≤5) — với D=4 biến thiết kế của nghiên cứu này, nhánh D≤5 (energy-step) luôn được sử dụng trên thực tế; nhánh đột biến DE (D>5) là một phần của thuật toán tổng quát đã công bố nhưng không được kích hoạt trong bài toán cụ thể này. Trong pha khai thác, các cá thể được cập nhật theo cơ chế tổ hợp hướng về Xleader, riêng cá thể cuối quần thể được cập nhật theo cơ chế suy giảm mũ riêng. Nghiệm mới chỉ được chấp nhận cập nhật vào quần thể và kho lưu trữ A khi hàm mục tiêu của nó tốt hơn cá thể cũ; ở giai đoạn cuối vòng lặp (>80% tổng số vòng lặp), một phần quần thể còn được tinh chỉnh Gaussian quanh nghiệm dẫn hướng tốt nhất trong kho lưu trữ. Tiêu chí dừng là đạt số vòng lặp tối đa (Max_it) đã định trước.

### 4.3. Mô hình liên kết MOSFOA–MATLAB–SAP2000

```text
Biến thiết kế X1-X4
       │
       ▼
    MOSFOA (MATLAB)
       │
       ▼
Cập nhật tiết diện SAP2000 (SetRectangle / SetShell_1)
       │
       ▼
   Chạy phân tích (RunAnalysis)
       │
       ▼
Trích M/N/U theo tổ hợp bao BAO-ULSB, BAO-SLSDH
       │
       ▼
Tính f1, f2 + kiểm tra ràng buộc
       │
       ▼
    Fitness → MOSFOA
       │
       └──── (lặp lại đến khi đạt Max_it)
```

*(Hình sơ đồ quy trình dạng khối — file ảnh chưa được chèn, xem mục "Hình và bảng cần chèn" cuối bài.)*

### 4.4. Quy trình đánh giá một nghiệm

Với mỗi phương án thiết kế $\mathbf{x}$ đề xuất bởi MOSFOA: (1) làm tròn về lưới rời rạc bước 0,05 m gần nhất cho từng biến; (2) cập nhật tiết diện dầm ngang/dầm dọc/dầm cần trục (hình chữ nhật, `SetRectangle`) và chiều dày bản mặt cầu (`SetShell_1`) trong SAP2000; (3) chạy phân tích kết cấu; (4) trích mô-men uốn lớn nhất trên từng nhóm dầm (hợp $\sqrt{M_2^2+M_3^2}$) và bản mặt cầu (max$(|M_{11}|,|M_{22}|)$) theo tổ hợp bao `BAO-ULSB`, lực dọc trục lớn nhất trên cọc và chuyển vị ngang lớn nhất tại đỉnh bến (hợp $\sqrt{U_1^2+U_2^2}$) theo tổ hợp bao `BAO-SLSDH`; (5) kiểm tra ràng buộc; (6) tính hai hàm mục tiêu; (7) trả fitness về MOSFOA — nếu vi phạm bất kỳ ràng buộc nào, gán fitness bằng một giá trị phạt cứng lớn ($10^{12}$ cho cả hai mục tiêu) để loại nghiệm khỏi archive.

**Lưu ý phương pháp luận quan trọng (phân biệt SEARCH và FINAL VERIFICATION)**: việc sử dụng tổ hợp bao (envelope) `BAO-ULSB`/`BAO-SLSDH` trong vòng lặp tối ưu (thay vì tách riêng 408 tổ hợp cơ bản cho mỗi lần đánh giá) là một lựa chọn có chủ đích nhằm giảm chi phí tính toán. Tổ hợp bao được chính SAP2000 tính sẵn từ 388 (hoặc 20) tổ hợp cấu thành, cho một **chỉ số cận trên thiên về an toàn dùng cho giai đoạn tìm kiếm** (search-stage conservative upper-bound indicator), không nhất thiết bằng giá trị đạt được bởi một tổ hợp cụ thể nào (xem mục 7.7). Với ba nghiệm Pareto đại diện cuối cùng, toàn bộ **408 tổ hợp cơ bản** (388 ULSB + 20 SLSDH) được tách riêng và đánh giá độc lập để xác nhận **giá trị khai thác lớn nhất đã được xác minh** (verified maximum utilization) và tổ hợp chi phối thực sự (mục 6.6); hai tổ hợp bao chỉ đóng vai trò công cụ tổng hợp trong giai đoạn tìm kiếm, không phải đối tượng được tách riêng trong bước hậu kiểm.

---

## 5. Model (Mô hình nghiên cứu cầu tàu 70.000 DWT)

### 5.1. Cơ sở xây dựng mô hình

Mô hình được xây dựng từ bộ thông số kỹ thuật của dự án Chân Mây 70.000 DWT, trình bày dưới dạng **mô hình nghiên cứu giả định** phục vụ bài toán tối ưu kết cấu — không sử dụng ngôn ngữ đánh giá/kiểm định công trình hiện hữu.

### 5.2. Hình học và quy mô mô hình

Mô hình SAP2000 (đơn vị Tonf–m–°C) gồm 1.942 nút, 747 phần tử thanh (frame) và 1.750 phần tử tấm vỏ (shell), đại diện cho Phân đoạn V (60 m) của cầu chính (300 m, 5 phân đoạn) — bến nhô dạng cầu tàu trên cọc. Hệ cọc gồm 96 cọc ống thép D700 (giữ cố định trong nghiên cứu này, không thuộc phạm vi tối ưu).

### 5.3. Vật liệu

Bê tông M400 (E=3,3×10⁴ MPa, quy đổi Rb≈17 MPa theo TCVN 5574:2018 [7] cho tính toán mô-men kháng uốn); dầm ngang/dầm dọc mác M400-DN (ρ=1,935 T/m³), dầm cần trục mác M400-DCT (ρ=2,05 T/m³), bản mặt cầu mác M400 (ρ=2,50 T/m³); cốt thép CB300-V (Rs≈260 MPa tính toán) theo TCVN 1651-2018 [9]; thép cọc ống D700/t12,6mm với Fy=3.150 kG/cm² (giá trị proxy theo TCVN 9245:2012 [8], mượn từ dự án tham khảo cùng tiêu chuẩn áp dụng, do không có chứng chỉ vật liệu riêng cho lô thép đã thi công — xem giới hạn dữ liệu, mục 6.5).

### 5.4. Tải trọng và tổ hợp tải trọng

Mô hình có 21 dạng tải trọng cơ bản (tĩnh tải, hoạt tải hàng hóa, cần trục, xe ô tô, va tàu, neo tàu, môi trường: nhiệt độ/dòng chảy). Trong SAP2000, các tải trọng này được tổ hợp thành **410 đối tượng tổ hợp**, gồm:
- **408 tổ hợp cơ bản** (individual combinations): 388 tổ hợp trạng thái giới hạn cực hạn ULSB-001…ULSB-388 (hệ số riêng phần Eurocode "Set B") + 20 tổ hợp trạng thái giới hạn khai thác SLSDH-01…SLSDH-20;
- **2 tổ hợp bao dẫn xuất** (derived envelope combinations): `BAO-ULSB` (bao 388 tổ hợp ULSB) và `BAO-SLSDH` (bao 20 tổ hợp SLSDH).

Quy ước ký hiệu này (408 tổ hợp cơ bản + 2 tổ hợp bao = 410 đối tượng) được dùng nhất quán trong toàn bài.

---

## 6. Optimization (Thiết lập bài toán tối ưu)

### 6.1. Biến thiết kế

Bốn biến thiết kế thuộc hệ kết cấu bên trên, rời rạc hóa bước đều 0,05 m:

$$\mathbf{x} = [X_1, X_2, X_3, X_4] = [h_{DN}, h_{DD}, h_{DCT}, t_{BMC}]$$

| Biến | Ký hiệu | Cấu kiện | Bề rộng cố định | Miền giá trị | Số mức |
|---|---|---|---:|---|---:|
| $X_1$ | $h_{DN}$ | Dầm ngang | 1,00 m | [1,10 ; 2,00] m | 19 |
| $X_2$ | $h_{DD}$ | Dầm dọc | 1,00 m | [1,10 ; 2,00] m | 19 |
| $X_3$ | $h_{DCT}$ | Dầm cần trục | 1,30 m | [1,40 ; 2,50] m | 23 |
| $X_4$ | $t_{BMC}$ | Bản mặt cầu | — | [0,25 ; 0,45] m | 5 |

Hệ cọc (D700, cố định) và tiết diện phụ trợ khác (MR) không thuộc phạm vi biến thiết kế, tránh trùng lặp với hướng nghiên cứu tối ưu hệ cọc đã công bố riêng.

### 6.2. Hàm mục tiêu

**Objective 1 — khối lượng bê tông kết cấu bên trên**:

$$f_1(\mathbf{x}) = \rho_{DN} b_{DN} X_1 L_{DN} + \rho_{DD} b_{DD} X_2 L_{DD} + \rho_{DCT} b_{DCT} X_3 L_{DCT} + \rho_{BMC} X_4 A_{BMC}$$

trong đó $L_{DN}$=273 m, $L_{DD}$=180 m, $L_{DCT}$=120 m (tổng chiều dài thật, đo qua OAPI), $A_{BMC}$=1.440 m² (=24 m × 60 m, khớp chính xác hình học mô hình) — các hằng số hình học này không đổi theo $\mathbf{x}$.

**Objective 2 — hệ số khai thác lớn nhất (search-stage, dựa trên tổ hợp bao)**:

$$f_2(\mathbf{x}) = \max(\eta_{DN}, \eta_{DD}, \eta_{DCT}, \eta_{BMC}), \qquad \eta_i = \frac{M_{Ed,i}}{M_{u,i}(\mathbf{x})}$$

Mô-men kháng uốn $M_u$ tính theo TCVN 5574:2018 [7] với giả thiết cốt thép chịu kéo lấy theo điều kiện cân bằng ($\xi=\xi_R$) — phản ánh khả năng chịu uốn lớn nhất khả dĩ của riêng tiết diện bê tông đang xét, độc lập với hàm lượng cốt thép thực tế thi công (không xác định được từ mô hình FEM sẵn có):

$$\xi_R = \frac{\omega}{1+\dfrac{R_s}{\sigma_{scu}}\left(1-\dfrac{\omega}{1{,}1}\right)}, \quad \omega=\alpha_{R1}-0{,}008R_b, \quad M_u = \xi_R(1-0{,}5\xi_R)R_b\,b\,h_0^2$$

### 6.3. Hệ ràng buộc

| Ràng buộc | Công thức | Cơ sở |
|---|---|---|
| $g_1$ — Khai thác cấu kiện | $\eta_{DN},\eta_{DD},\eta_{DCT},\eta_{BMC} \le 1$ | TCVN 5574:2018 [7] |
| $g_2$ — Chuyển vị | $U_{max} \le L/240 \approx 0{,}0217$ m | Quy ước (L≈5,2 m khoang cọc dọc bến) |
| $g_3$ — Sức chịu tải cọc | $\gamma_n N_{max} \le R_d = 450$ Tấn | Giá trị quy ước, đại diện năng lực thông thường cọc ống thép D700 trong đất tốt (xem mục 6.5) |
| $g_4$ — Ứng suất vật liệu cọc | $\sigma = N_{max}/A_{coc} \le F_y/\gamma$ | $F_y$=3.150 kG/cm² (TCVN 9245:2012 [8], giá trị proxy) |

### 6.4. Tham số MOSFOA

| Tham số | Giá trị |
|---|---:|
| Kích thước quần thể (Npop) | 20 |
| Số vòng lặp tối đa (Max_it) | 100 |
| Kích thước archive (Nr) | 100 |
| Số biến | 4 |
| Số lần chạy độc lập (Nrun) | 20 |
| Số worker song song (Num_work) | 8 |
| Tổng số lần đánh giá (TotalFE) | 20×2.020 = 40.400 |

Mỗi lần chạy độc lập sử dụng một seed số ngẫu nhiên riêng (khởi tạo bằng `rng('shuffle')`, lưu lại để có thể truy vết/tái lập), khác nhau tuyệt đối giữa 20 lần chạy — xác nhận đã loại trừ khả năng các lần chạy trùng lặp do cùng chuỗi ngẫu nhiên.

### 6.5. Giới hạn dữ liệu và giả định thiên về an toàn cần công bố minh bạch

Do hồ sơ sẵn có (thuyết minh sửa chữa 2023, không phải hồ sơ thiết kế/khảo sát địa chất đầy đủ) không cung cấp đủ dữ liệu độc lập, đáng tin cậy để xác định chính xác cao độ mũi cọc và sức chịu tải cọc theo đất nền riêng cho vị trí nghiên cứu, giá trị $R_d$=450 Tấn trong ràng buộc $g_3$ là **giá trị quy ước**, đại diện năng lực chịu tải thông thường của cọc ống thép D700 trong nền đất tốt — **không** được suy ra từ số liệu địa chất cụ thể của Chân Mây và **không** cấu thành một đánh giá địa kỹ thuật chính thức. Tương tự, $F_y$=3.150 kG/cm² (ràng buộc $g_4$) là giá trị mượn từ một dự án tham khảo cùng áp dụng TCVN 9245:2012, không phải số liệu xác nhận riêng cho lô thép đã thi công. Các giả định này phù hợp với định vị "mô hình nghiên cứu giả định" của bài báo (không đánh giá công trình hiện hữu, không so sánh với hồ sơ thiết kế gốc) nhưng cần được nêu rõ để người đọc hiểu đúng phạm vi áp dụng của kết quả — bài báo này **không** nhằm đánh giá an toàn thực tế của công trình Bến số 1 – Cảng Chân Mây.

### 6.6. Xử lý 410 tổ hợp tải trọng — phân biệt giai đoạn tìm kiếm và hậu kiểm

Trong vòng lặp tối ưu, $f_2$ và các ràng buộc liên quan được tính từ 2 tổ hợp bao (`BAO-ULSB`, `BAO-SLSDH`), vốn đã bao hàm giá trị lớn nhất của từng thành phần nội lực/chuyển vị trên toàn bộ 408 tổ hợp cơ bản cấu thành. Với 3 nghiệm Pareto đại diện cuối cùng, **408 tổ hợp cơ bản** (388 ULSB + 20 SLSDH) được tách riêng và trích xuất độc lập để: (i) xác nhận giá trị khai thác lớn nhất **đã được xác minh** đạt được bởi một tổ hợp cụ thể (không phải giá trị tổng hợp từ 2 thành phần đến từ 2 tổ hợp khác nhau như trường hợp tổ hợp bao); (ii) xác định tổ hợp tải trọng nào chi phối từng đại lượng kiểm tra (mô-men từng nhóm dầm, lực dọc cọc, chuyển vị). Hai tổ hợp bao **không** được tách riêng thêm trong bước hậu kiểm này — vai trò của chúng chỉ giới hạn ở giai đoạn tìm kiếm.

---

## 7. Results and Discussion (Kết quả và thảo luận)

### 7.1. Kiểm chứng mô hình và pipeline tính toán

Trước campaign chính thức, mô hình liên kết MOSFOA–MATLAB–SAP2000 được kiểm chứng qua: (i) đối chiếu số lượng phần tử theo từng nhóm cấu kiện (96/282/210/140/1.750 cho cọc/DN/DD/DCT/bản) khớp tuyệt đối với dữ liệu mô hình gốc; (ii) kiểm tra riêng từng biến thiết kế thay đổi độc lập chỉ ảnh hưởng đúng nhóm cấu kiện tương ứng, không ảnh hưởng chéo; (iii) kiểm tra tính không "trễ" (stale) của kết quả — đánh giá lại cùng 1 phương án sau khi đã đánh giá phương án khác cho kết quả tái lập chính xác; (iv) kiểm tra tại 2 điểm biên của miền thiết kế để xác nhận toàn bộ pipeline hoạt động ổn định trên toàn miền tìm kiếm.

### 7.2. Khả năng hội tụ của MOSFOA

*Hình 1* trình bày đường cong hội tụ (giá trị $f_1$ nhỏ nhất tìm được theo vòng lặp) của cả 20 lần chạy độc lập chồng lớp. Cả 20/20 lần chạy hội tụ về đúng giá trị $f_1$=2.311,93 Tấn **ngay từ vòng lặp thứ 20/100** (20% tổng số vòng lặp) và giữ nguyên không đổi đến hết vòng lặp 100, không phân biệt seed khởi tạo. Thống kê trên 20 lần chạy: $f_1$ nhỏ nhất giống hệt tuyệt đối (độ lệch chuẩn = 0), $f_2$ nhỏ nhất trung bình ≈0,154973 (độ lệch chuẩn ≈0,00004914), kích thước archive trung bình 77,80 nghiệm (dao động 72–84). Đây là bằng chứng số liệu trực tiếp (không suy diễn) cho khả năng hội tụ ổn định của MOSFOA **trên bài toán 4 biến cụ thể này**, không hàm ý một tính chất hội tụ được đảm bảo tổng quát cho mọi bài toán.

*(Hình 1 — Đường cong hội tụ 20 lần chạy: `code/results/Hinh_hoitu_20runs.png`, đã tạo sẵn, cần chèn vào bản thảo.)*

### 7.3. Tập nghiệm Pareto

Từ 20 lần chạy độc lập (40.400 lần đánh giá), hợp nhất và loại bỏ các nghiệm bị trội cho một **mặt Pareto tổng thể gồm 90 nghiệm** không bị trội lẫn nhau, thể hiện quan hệ đánh đổi rõ ràng giữa khối lượng bê tông (trong số 90 nghiệm, $f_1$ dao động 2.311,93 – 3.820,83 Tấn) và hệ số khai thác (trong số 90 nghiệm, $f_2$ dao động 0,1550 – 0,4053). Cả 20/20 lần chạy đều đóng góp ít nhất một nghiệm vào mặt Pareto tổng thể, cho thấy mỗi lần chạy độc lập khám phá được những vùng khác nhau của không gian thiết kế trong khi vẫn hội tụ về cùng một vùng trade-off chung.

*(Hình 2 — Pareto front: `code/results/campaign_20runs_pareto_overlay.png`, đã có sẵn.)*

### 7.4. Phân tích các nghiệm đại diện

Ba nghiệm đại diện được chọn từ mặt Pareto tổng thể: A (khối lượng nhỏ nhất), B (nghiệm cân bằng, khoảng cách chuẩn hóa nhỏ nhất tới điểm lý tưởng), C (hệ số khai thác nhỏ nhất, $\eta_{max}$ nhỏ nhất). Ba nghiệm này được chọn theo tiêu chí đơn mục tiêu/knee-point trên mặt Pareto — **không hàm ý C là nghiệm "tốt nhất" theo nghĩa tổng quát**, vì đây là bài toán đa mục tiêu và mỗi nghiệm trên mặt Pareto đều là nghiệm tối ưu theo một sự đánh đổi khác nhau giữa hai mục tiêu.

**Bảng 1. Ba nghiệm Pareto đại diện**

| Nghiệm | $h_{DN}$ (m) | $h_{DD}$ (m) | $h_{DCT}$ (m) | $t_{BMC}$ (m) | $f_1$ (Tấn) | $\eta_{max,true}$ (đã xác minh) |
|---|---:|---:|---:|---:|---:|---:|
| A — khối lượng nhỏ nhất | 1,10 | 1,10 | 1,40 | 0,25 | 2.311,93 | 0,3538 |
| B — nghiệm cân bằng | 1,15 | 1,45 | 1,40 | 0,35 | 2.820,25 | 0,2082 |
| C — $\eta_{max}$ nhỏ nhất | 2,00 | 2,00 | 1,40 | 0,45 | 3.820,83 | 0,1550 |

*(Hình 3 — So sánh 3 nghiệm đại diện: `code/results/Hinh_sosanh_ABC.png`, đã có sẵn. Lưu ý nhãn trong hình ghi "C (dap ung tot nhat)" — cần sửa nhãn thành "C (eta_max nho nhat)" khi chèn vào bản thảo cuối, xem mục "Hình và bảng cần chèn".)*

Đáng chú ý, chiều cao dầm cần trục $h_{DCT}$ giữ nguyên giá trị nhỏ nhất (1,40 m) ở cả 3 nghiệm đại diện — cho thấy, trong phạm vi 3 nghiệm được kiểm tra, dầm cần trục không phải là yếu tố chi phối trong việc cải thiện $\eta_{max}$; sự cải thiện chủ yếu đến từ việc tăng $h_{DN}$, $h_{DD}$ và $t_{BMC}$.

### 7.5. Ảnh hưởng của biến thiết kế

Kết quả Bảng 1 cho thấy quan hệ đánh đổi rõ ràng giữa 3 nghiệm đại diện: tăng đồng thời chiều cao dầm ngang/dầm dọc và chiều dày bản mặt cầu làm tăng khối lượng bê tông (2.311,93 → 3.820,83 Tấn, +65,3%) nhưng giảm mạnh hệ số khai thác lớn nhất đã xác minh (0,3538 → 0,1550, −56,2%). Chiều dày bản mặt cầu $t_{BMC}$ có ảnh hưởng đáng kể đến $\eta_{max}$ (xem mục 7.6) do bản mặt cầu là cấu kiện chi phối hệ số khai thác ở cả ba nghiệm đại diện.

### 7.6. Cấu kiện và tổ hợp tải trọng chi phối (ở ba nghiệm đại diện được hậu kiểm)

**Bảng 2. Hệ số khai thác từng nhóm cấu kiện và tổ hợp chi phối tương ứng (A/B/C)**

| Đại lượng | Nghiệm A | Nghiệm B | Nghiệm C | Tổ hợp chi phối |
|---|---:|---:|---:|---|
| $\eta_{DN}$ | 0,2183 | 0,1860 | 0,0937 | ULSB-044 (A,B) / ULSB-043 (C) |
| $\eta_{DD}$ | 0,1749 | 0,1162 | 0,0931 | ULSB-252 (A) / ULSB-024 (B,C) |
| $\eta_{DCT}$ | 0,1008 | 0,0931 | 0,0802 | **ULSB-024 (cả A, B, C)** |
| $\eta_{BMC}$ | **0,3538** | **0,2082** | **0,1550** | ULSB-038 (A) / ULSB-029 (B,C) |
| $N_{pile}$ (Tấn) | 210,00 | 218,01 | 227,62 | **ULSB-051 (cả A, B, C)** |
| $U_{max}$ (m) | 0,0049 | 0,0051 | 0,0059 | SLSDH-18 (A) / SLSDH-10 (B, C) |

*(Lưu ý kỹ thuật: $U_{max}$ tra cứu đúng theo phạm vi 20 tổ hợp SLSDH — cùng cơ sở mà ràng buộc $g_2$ trong campaign thực sự dùng qua tổ hợp bao `BAO-SLSDH`, xem mục 6.6. Ở một phiên bản hậu kiểm trước đó, tổ hợp chi phối $U_{max}$ bị tra cứu nhầm trên cả 408 tổ hợp gộp — gồm cả 388 tổ hợp ULS có tải trọng lớn hơn hẳn — cho ra giá trị 0,0491/0,0490/0,0487 m (combo ULSB-051), vượt giới hạn $g_2$ một cách giả tạo dù campaign thật chưa từng dùng đại lượng đó cho $g_2$. Đã phát hiện và sửa lỗi phạm vi tổ hợp này, tính lại trực tiếp trên SAP2000 chỉ với 20 tổ hợp SLSDH, cho kết quả ở trên — cả ba nghiệm đều thỏa mãn $g_2$ với biên độ lớn.)*

Các phát hiện nhất quán **ở cả ba nghiệm đại diện được hậu kiểm** (không có ngoại lệ trong phạm vi đã kiểm tra):

1. **Bản mặt cầu (BMC) là cấu kiện chi phối hệ số khai thác lớn nhất ở cả ba nghiệm Pareto đại diện** — không phải các dầm, dù dầm cần trục có tiết diện lớn nhất trong 3 loại dầm. Trong phạm vi mô hình và tải trọng đang xét, điều này gợi ý rằng việc tăng chiều dày bản mặt cầu có ảnh hưởng đáng kể đến việc cải thiện $\eta_{max}$ đối với các nghiệm đã kiểm tra.
2. **Tổ hợp ULSB-051 chi phối lực dọc trục cọc lớn nhất** ở cả 3 nghiệm, và **tổ hợp ULSB-024 chi phối mô-men dầm cần trục ở cả 3 nghiệm**, không phụ thuộc vào việc kích thước hệ kết cấu bên trên thay đổi thế nào **trong phạm vi ba nghiệm đã kiểm tra**. Đây là bằng chứng trực tiếp (giới hạn ở ba nghiệm đại diện) góp phần trả lời câu hỏi nghiên cứu về việc xác định các tổ hợp tải trọng có xu hướng chi phối tính khả thi của nghiệm tối ưu.
3. **Tổ hợp chi phối chuyển vị ngang lớn nhất không hoàn toàn nhất quán giữa ba nghiệm**: SLSDH-18 chi phối ở nghiệm A, còn SLSDH-10 chi phối ở cả nghiệm B và C — khác với $N_{pile}$/$M_{DCT}$ (luôn cùng 1 tổ hợp ở cả 3 nghiệm). Cả ba giá trị $U_{max}$ đều rất nhỏ so với giới hạn $g_2$ (0,0217 m), cho thấy chuyển vị ngang không phải yếu tố khống chế đối với các nghiệm đã kiểm tra.

**Lưu ý phạm vi**: hai phát hiện trên chỉ được xác nhận cho **ba nghiệm đại diện A/B/C** (đã hậu kiểm đầy đủ 408 tổ hợp cơ bản), **không phải** cho toàn bộ 90 nghiệm trên mặt Pareto tổng thể — việc hậu kiểm 408 tổ hợp cho toàn bộ 90 nghiệm chưa được thực hiện trong nghiên cứu này.

### 7.7. Ghi chú phương pháp luận: chênh lệch giữa chỉ số tìm kiếm (search) và giá trị đã xác minh (verified)

Đối chiếu $f_2$ tính từ tổ hợp bao `BAO-ULSB` (search-stage envelope-based indicator, dùng trong vòng lặp tối ưu) với giá trị khai thác lớn nhất đã xác minh (verified maximum utilization, $\eta_{max,true}$) từ 408 tổ hợp riêng lẻ (Bảng 1) cho thấy:

| Nghiệm | $f_{2,search}$ (tổ hợp bao) | $\eta_{max,true}$ (tổ hợp riêng lẻ) | Chênh lệch |
|---|---:|---:|---:|
| A | 0,4053 | 0,3538 | +0,0515 |
| B | 0,2082 | 0,2082 | 0,0000 |
| C | 0,1550 | 0,1550 | 0,0000 |

Với nghiệm B và C, hai giá trị khớp chính xác tuyệt đối. Với nghiệm A, chỉ số tìm kiếm dựa trên tổ hợp bao (0,4053) cao hơn giá trị đã xác minh (0,3538) khoảng 13%. Nguyên nhân là tổ hợp bao (Envelope) trong SAP2000 báo cáo giá trị lớn nhất của từng thành phần mô-men ($M_2$, $M_3$) **độc lập với nhau**, có thể đến từ hai tổ hợp cơ bản khác nhau trong số 388 tổ hợp ULSB cấu thành — khi ghép $\sqrt{M_2^2+M_3^2}$ từ hai giá trị "lớn nhất riêng lẻ" này, kết quả có thể lớn hơn giá trị thực tế đạt được bởi bất kỳ một tổ hợp cụ thể nào. Đây là đặc tính vốn có của tổ hợp bao khi áp dụng cho một đại lượng tổng hợp (resultant quantity), **không phải sai số tính toán và không phải một hạn chế của thuật toán MOSFOA**.

Vì vậy, cần phân biệt rõ hai loại chỉ số trong bài báo này:
- **(1) Search metric** — $f_2$ dùng trong vòng lặp MOSFOA: một **chỉ số cận trên thiên về an toàn** (conservative upper-bound indicator), mục đích là không bỏ sót nghiệm nguy hiểm trong quá trình tìm kiếm, **không** phải giá trị $\eta$ thực tế đạt được bởi một tổ hợp cụ thể.
- **(2) Final verification metric** — $\eta_{max,true}$ báo cáo cho ba nghiệm đại diện (Bảng 1): giá trị **lớn nhất thật sự đạt được**, xác nhận từ 408 tổ hợp tải trọng cơ bản riêng lẻ, có thể truy vết đến đúng một tổ hợp cụ thể.

Với nghiệm A, giá trị 0,4053 **không** được gọi là $\eta_{max,true}$ trong bài báo này — giá trị $\eta_{max,true}$ của nghiệm A luôn là 0,3538.

### 7.8. Thảo luận

**MOSFOA có tạo được tập nghiệm khả thi và hội tụ ổn định hay không (trên bài toán này)?** Kết quả cho thấy câu trả lời khẳng định trong phạm vi bài toán đã khảo sát: 40.400 lần đánh giá qua 20 lần chạy độc lập không ghi nhận bất kỳ vi phạm hội tụ nào, giá trị $f_1$ nhỏ nhất giống hệt tuyệt đối (độ lệch chuẩn bằng 0) và $f_2$ nhỏ nhất gần như không đổi (độ lệch chuẩn ≈0,00005) giữa các lần chạy — dù mỗi lần chạy sử dụng seed ngẫu nhiên hoàn toàn khác nhau (đã xác nhận trực tiếp, không có hai lần chạy nào trùng seed).

**Trade-off giữa khối lượng và đáp ứng kết cấu thể hiện như thế nào?** Mặt Pareto tổng thể (90 nghiệm) thể hiện quan hệ đánh đổi liên tục và trơn tru trên toàn dải khảo sát, không có bước nhảy bất thường, phản ánh đúng bản chất vật lý của bài toán (tiết diện lớn hơn → khối lượng tăng, hệ số khai thác giảm).

**Việc xét đồng thời nhiều tổ hợp tải trọng ảnh hưởng thế nào đến các trường hợp tải trọng chi phối?** Kết quả tách riêng 408 tổ hợp cơ bản cho ba nghiệm đại diện cho thấy không phải mọi tổ hợp đều đóng vai trò như nhau: một số tổ hợp cụ thể (ULSB-024 cho $M_{DCT}$, ULSB-051 cho $N_{pile}$) chi phối ổn định đối với cả ba nghiệm được kiểm tra, trong khi tổ hợp chi phối chuyển vị ngang ($U_{max}$) chỉ nhất quán giữa 2/3 nghiệm (SLSDH-10 cho B, C) và phần lớn các tổ hợp còn lại không xuất hiện là tổ hợp khống chế cho các cấu kiện đang xét, **trong phạm vi ba nghiệm đã kiểm tra**. Việc khái quát thành một tập tổ hợp rút gọn áp dụng cho các bài toán khác (hình học, tải trọng, hoặc phạm vi thiết kế khác) cần được đánh giá riêng và được dành cho các nghiên cứu tiếp theo.

Phạm vi nghiên cứu này **không** mở rộng sang phân tích ảnh hưởng của quy mô công trình, điều kiện địa chất, hay so sánh giữa các dự án khác — các nội dung này thuộc phạm vi các bài nghiên cứu khác trong cùng chuỗi.

---

## 8. Conclusion (Kết luận)

1. MOSFOA có thể áp dụng để giải bài toán tối ưu đa mục tiêu hệ kết cấu bên trên cầu tàu với 4 biến thiết kế và ràng buộc rút ra trực tiếp từ mô hình phần tử hữu hạn chịu 410 tổ hợp tải trọng, trong phạm vi mô hình nghiên cứu giả định đã khảo sát trong bài báo này.
2. Việc thay đổi các biến thiết kế phần trên tạo ra một mặt Pareto liên tục gồm 90 nghiệm không bị trội, thể hiện rõ quan hệ đánh đổi giữa khối lượng (dao động 2.311,93 – 3.820,83 Tấn trong số 90 nghiệm) và hệ số khai thác lớn nhất (dao động 0,1550 – 0,4053 trong số 90 nghiệm).
3. Kết quả 20 lần chạy độc lập (seed hoàn toàn khác nhau, đã xác nhận không trùng lặp) cho thấy khối lượng nhỏ nhất tìm được giống hệt nhau (độ lệch chuẩn bằng 0) và hệ số khai thác nhỏ nhất gần như không đổi (độ lệch chuẩn ≈0,00005) — bằng chứng định lượng về tính ổn định hội tụ của MOSFOA **trên bài toán cụ thể này**.
4. Hậu kiểm đầy đủ 408 tổ hợp tải trọng cơ bản cho ba nghiệm đại diện xác định bản mặt cầu là cấu kiện chi phối hệ số khai thác **ở cả ba nghiệm**, và xác định tổ hợp ULSB-051 chi phối lực dọc trục cọc, tổ hợp ULSB-024 chi phối mô-men dầm cần trục, **ở cả ba nghiệm đại diện được kiểm tra**; chuyển vị ngang lớn nhất (tra cứu đúng phạm vi 20 tổ hợp SLSDH khớp cơ sở ràng buộc $g_2$) đều rất nhỏ so với giới hạn cho phép ở cả ba nghiệm, không phải yếu tố khống chế. Việc khái quát các tổ hợp chi phối này cho các cấu hình hoặc công trình cầu tàu khác cần được đánh giá riêng ở các nghiên cứu tiếp theo.

Các kết quả trên cung cấp một minh chứng bổ sung cho khả năng áp dụng MOSFOA vào các bài toán tối ưu kết cấu cảng có nhiều biến thiết kế và hệ ràng buộc phức tạp, đồng thời làm rõ vai trò của việc phân biệt chỉ số tìm kiếm (search) và chỉ số đã xác minh (verification) khi lựa chọn phương pháp xử lý tổ hợp tải trọng, đối với độ chính xác của kết quả báo cáo. Kết luận không vượt quá dữ liệu thực nghiệm đã trình bày.

---

## 9. Declarations (Các tuyên bố)

### 9.1. Tuyên bố không xung đột lợi ích và cam kết bản quyền

*[Theo mẫu chuẩn của tạp chí — TO BE VERIFIED.]*

### 9.2. Chia sẻ dữ liệu theo yêu cầu

Dữ liệu campaign (20 file kết quả `.mat`, mặt Pareto tổng thể, dữ liệu tổ hợp chi phối) có thể được cung cấp khi có yêu cầu chính đáng.

### 9.3. Lời cảm ơn

*[Chỉ đưa nếu có — TO BE VERIFIED, nguồn tài trợ nếu có.]*

---

## 10. References (Tài liệu tham khảo)

*(Định dạng IEEE. [1]–[3]: hai bài trước của nhóm tác giả, xác nhận từ file bản thảo thật do người dùng cung cấp trực tiếp — KHÔNG tự tạo DOI/volume/issue/trang cho phần chưa được cấp. [4]–[6]: tài liệu quốc tế, đã xác minh qua tra cứu trực tuyến (tiêu đề, tác giả, năm, tạp chí/nhà xuất bản, volume/issue/số trang/DOI khớp nhiều nguồn độc lập). [7]–[9]: tiêu chuẩn Việt Nam thực sự được sử dụng trong mô hình/công thức của bài báo — xem trích dẫn trong thân bài mục 5.3, 6.2, 6.3, 6.5.)*

[1] T. Do-Quang, T. Vu-Huu, and C. T. Le, "Multi-objective Optimization of Marine Structures Using an Enhanced Starfish Algorithm," *Proceedings of the Institution of Civil Engineers – Structures and Buildings*, 2026, doi: 10.1680/jstbu.26.00159.

[2] Đ. Q. Thành, V. H. Trường, và L. T. Cường, "Tối ưu thể tích bê tông kết cấu tường chắn phía sau cầu tàu bằng thuật toán tối ưu Sao biển (SFOA)" ["Concrete Volume Optimization of the Retaining Wall Behind the Jetty Using the Starfish Optimization Algorithm (SFOA)"], *Tạp chí Xây dựng*, forthcoming.

[3] Đ. Q. Thành, V. H. Trường, và L. T. Cường, "Tối ưu đa mục tiêu hệ cọc cầu tàu trong công trình cảng biển bằng thuật toán Sao biển cải tiến (MOSFOA)" ["Multi-objective Optimization of Wharf Pile Systems in Marine Port Structures Using the Modified Starfish Optimization Algorithm (MOSFOA)"], *Journal of Marine Science and Technology (JMST)*, forthcoming.

[4] A. Kaveh, *Advances in Metaheuristic Algorithms for Optimal Design of Structures*, 2nd ed. Cham, Switzerland: Springer, 2017.

[5] K. Deb, A. Pratap, S. Agarwal, and T. Meyarivan, "A fast and elitist multiobjective genetic algorithm: NSGA-II," *IEEE Transactions on Evolutionary Computation*, vol. 6, no. 2, pp. 182–197, 2002, doi: 10.1109/4235.996017.

[6] T. S. Cao, T. T. T. Nguyen, V. S. Nguyen, V. H. Truong, and H. H. Nguyen, "Performance of Six Metaheuristic Algorithms for Multi-Objective Optimization of Nonlinear Inelastic Steel Trusses," *Buildings*, vol. 13, no. 4, art. 868, 2023, doi: 10.3390/buildings13040868.

[7] TCVN 5574:2018, *Kết cấu bê tông và bê tông cốt thép — Tiêu chuẩn thiết kế* [Concrete and reinforced concrete structures — Design standard]. Hà Nội: Bộ Khoa học và Công nghệ, 2018.

[8] TCVN 9245:2012, *Cọc ống thép* [Steel pipe piles]. Hà Nội: Bộ Khoa học và Công nghệ, 2012.

[9] TCVN 1651-2:2018, *Thép cốt bê tông — Phần 2: Thép thanh vằn* [Steel for the reinforcement of concrete — Part 2: Ribbed bars]. Hà Nội: Bộ Khoa học và Công nghệ, 2018.

---

## 11. Author Contributions (Đóng góp của các tác giả)

*[Theo mẫu JTST — Methodology, Data management, Formal analysis, Investigation, Validation, Visualization... — TO BE VERIFIED theo đúng vai trò thật của từng tác giả.]*

---

## Hình và bảng cần chèn (không phải nội dung khoa học — thao tác trình bày)

1. **Hình 1** (đường hội tụ 20 run) — `code/results/Hinh_hoitu_20runs.png` (đã có sẵn).
2. **Hình 2** (Pareto front) — `code/results/campaign_20runs_pareto_overlay.png` (đã có sẵn).
3. **Hình 3** (so sánh A/B/C) — `code/results/Hinh_sosanh_ABC.png` (đã có sẵn; **nhãn "C" trong hình ghi "dap ung tot nhat" — cần đổi thành "eta_max nho nhat" cho khớp thuật ngữ đã thống nhất trong bản REVISION này, hoặc ghi chú lại trong caption khi chèn**).
4. **Sơ đồ quy trình MOSFOA–MATLAB–SAP2000** — chưa vẽ dạng hình (chỉ có bản văn bản ASCII, mục 4.3); cần tự vẽ lại.
5. **Ảnh/render mô hình FEM cầu tàu** (SAP2000) — chưa có; cần chụp màn hình trực tiếp từ SAP2000.
6. **Sơ đồ bố trí nhóm cấu kiện/biến thiết kế** trên mặt bằng — chưa có; cần vẽ tay hoặc trích từ bản vẽ CAD sẵn có.

## Việc còn cần điền trước khi nộp (phi khoa học)

- Tên tác giả, đơn vị công tác, email liên hệ — [TO BE VERIFIED], đối chiếu với các bài trước cùng nhóm.
- Mục 3.2 (Tổng quan nghiên cứu) — cần bổ sung trích dẫn tài liệu tham khảo cụ thể.
- Danh mục tài liệu tham khảo đầy đủ (IEEE) — đặc biệt trích dẫn chính xác công bố gốc MOSFOA.
- Tuyên bố xung đột lợi ích, lời cảm ơn, đóng góp tác giả — theo đúng mẫu JTST.
- Định dạng font/margin/style theo `JTST_TemplatePaper_Vietnamese.docx` khi chuyển sang .docx cuối cùng.

---

# FINAL QA — REVISION V2

- [x] Không thay đổi số liệu campaign (Nrun=20, Npop=20, Max_it=100, Num_work=8, TotalFE=40.400)
- [x] Không thay đổi A/B/C (design variables, f1, eta_max_true — đối chiếu từng số với FINAL_VALIDATION_BAI6.md, khớp tuyệt đối)
- [x] Không thay đổi Pareto = 90
- [x] Không thay đổi 20 runs / 40.400 evaluations
- [x] Không thay đổi convergence results (hội tụ vòng 20/100, f1 std=0, f2 std≈0,00005, archive mean=77,80)
- [x] Search metric và true verification metric được phân biệt rõ (mục 4.1, 4.4, 6.2, 7.7)
- [x] A: 0,4053 search / 0,3538 true — nêu rõ ở Bảng đối chiếu mục 7.7, không còn chỗ nào gọi 0,4053 là eta_max_true
- [x] B: 0,2082 / 0,2082 — khớp
- [x] C: 0,1550 / 0,1550 — khớp
- [x] BMC claim giới hạn ở "ba nghiệm đại diện" (mục 7.6, không còn "toàn dải Pareto"/"luôn")
- [x] Không overclaim việc rút gọn load combinations (mục 7.8 đã sửa theo hướng "cần đánh giá riêng ở nghiên cứu tiếp theo")
- [x] C được gọi là "η_max nhỏ nhất" (Bảng 1, mục 7.4; ghi chú riêng về nhãn hình 3 cần sửa thủ công)
- [x] 410 combinations được định nghĩa nhất quán (408 tổ hợp cơ bản + 2 tổ hợp bao = 410 đối tượng, dùng xuyên suốt từ mục 5.4)
- [x] Không claim MOSFOA superior nếu không có benchmark (đã bỏ "hiệu quả"/"tốt nhất", giữ ngôn ngữ "stable convergence", "consistent results", "successfully" tương đương)
- [x] Không biến mô hình giả định thành đánh giá công trình thực tế (mục 3.4, 6.5 giữ nguyên tuyên bố minh bạch, bổ sung câu khẳng định trực tiếp ở mục 6.5)
- [x] Không bịa references — [1]–[3]: 2 bài của nhóm tác giả (forthcoming, không có DOI/volume/issue bịa ra); [4]–[6]: xác minh qua tra cứu trực tuyến (Kaveh 2017; Deb et al. 2002, doi 10.1109/4235.996017; Cao et al. 2023, doi 10.3390/buildings13040868); [7]–[9]: TCVN 5574:2018/9245:2012/1651-2:2018, xác nhận thực sự dùng trong thân bài (mục 5.3, 6.2, 6.3)
- [x] Citation audit: mọi [n] trong thân bài (n=1..9) đều có mục tương ứng trong References, và mọi mục References đều được trích dẫn ít nhất 1 lần trong thân bài — không có reference mồ côi
- [x] Không bịa số liệu (không có số liệu mới nào được thêm ngoài các thống kê đã có sẵn trong FINAL_VALIDATION_BAI6.md — f2 mean/std, archive mean được bổ sung vào mục 7.2, đều lấy nguyên từ nguồn đã khóa)
- [x] Không bịa hình (3 hình giữ nguyên file đã tạo, không chỉnh sửa dữ liệu hình)
- [x] **Umax constraint/value consistency — ĐÃ GIẢI QUYẾT (2026-09-24)**: xem mục RESOLVED bên dưới.

**Đối chiếu số liệu — không phát hiện mâu thuẫn nào giữa manuscript và FINAL_VALIDATION_BAI6.md.**

## RESOLVED — Umax constraint/value consistency (trước đây HIGH-PRIORITY TECHNICAL CHECK)

Root cause xác nhận đúng như nghi vấn ban đầu: script hậu kiểm `analyze_governing_combos.m` tra cứu tổ hợp chi phối $U_{max}$ trên **toàn bộ 408 tổ hợp gộp** (388 ULS + 20 SLS), trong khi ràng buộc $g_2$ thật trong campaign (`evaluate_superstructure_design.m`, dòng 98) chỉ dùng tổ hợp bao `BAO-SLSDH` (20 tổ hợp SLS). Đã sửa script (tách riêng lựa chọn 20 tổ hợp SLSDH cho riêng bước tính $U_{max}$, không dùng chung danh sách 408 tổ hợp với M/N) và **chạy lại trực tiếp trên SAP2000** (không suy diễn/ước tính) cho cả 3 nghiệm A/B/C. Kết quả mới: $U_{max}$ = 0,0049 m (A, combo SLSDH-18) / 0,0051 m (B, combo SLSDH-10) / 0,0059 m (C, combo SLSDH-10) — **tất cả đều thỏa mãn $g_2$ (≤0,0217 m) với biên độ lớn**, không có vi phạm ràng buộc nào. Giá trị cũ (0,0491/0,0490/0,0487 m, combo ULSB-051) là sản phẩm của bug phạm vi tổ hợp ở bước hậu xử lý, không phải kết quả thật của campaign — đã cập nhật Bảng 2 (mục 7.6), phát hiện #2 (mục 7.6), mục 7.8 và Kết luận (mục 8) cho khớp số liệu mới; giá trị cũ vẫn được lưu lại trong `results/governing_combos_analysis.mat` (trường `*_OLD_408combo_BUGGED`) để đối chiếu/kiểm tra lại nếu cần. Đã xác nhận thêm `cfg.deck_top_Z=0,0` (dùng để lọc đúng nút tính $U_{max}$) là đúng bằng cách quét toàn bộ 1.942 joint của model (Z=0,0 là cao độ lớn nhất, không có joint nào cao hơn) — không phải một nguồn sai số khác.

## FINAL STATUS

**SCIENTIFIC CONTENT: LOCKED — NO CHANGES TO RESULTS**

**REASON**: Toàn bộ số liệu khoa học cốt lõi (campaign 20 run, 90 nghiệm Pareto, A/B/C, hội tụ) giữ nguyên, khớp tuyệt đối với FINAL_VALIDATION_BAI6.md. Các sửa đổi trong revision này giới hạn ở: phạm vi kết luận (BMC/governing combo scoped về đúng "ba nghiệm đại diện" thay vì "toàn dải Pareto"/"luôn luôn"), thuật ngữ (408 tổ hợp cơ bản vs 410 đối tượng tổng, search metric vs verified metric), tên nghiệm C, loại bỏ ngôn ngữ overclaim ("hiệu quả", "tốt nhất") không có đối chứng, bổ sung/làm sạch phần Tổng quan nghiên cứu (mục 3.2) và Tài liệu tham khảo (mục 10, [4]–[9]), và sửa lại giá trị $U_{max}$/tổ hợp chi phối ở Bảng 2 sau khi phát hiện và vá bug phạm vi tổ hợp trong script hậu kiểm (không phải sửa số liệu campaign — campaign gốc chưa từng dùng sai phạm vi này). Không có số liệu campaign nào (A/B/C f1/eta_max_true, 90 Pareto, convergence) bị thay đổi trong bất kỳ vòng revision nào.

**REMAINING BEFORE SUBMISSION**:
1. Thông tin tác giả, đơn vị công tác, email, funding/lời cảm ơn — điền theo mẫu JTST thật.
2. Định dạng theo đúng template JTST (font, margin, style) khi chuyển sang .docx.
3. Chèn hình/bảng còn thiếu theo danh sách ở mục "Hình và bảng cần chèn" (đặc biệt sửa nhãn Hình 3: "C — đáp ứng tốt nhất" → "C — η_max nhỏ nhất").
4. Rà soát lần cuối metadata references (đặc biệt [2]/[3] khi có số báo/DOI chính thức, thay "forthcoming").

**REMAINING NON-SCIENTIFIC ITEMS**:
- authors (tên, đơn vị, email liên hệ)
- references (danh mục IEEE đầy đủ, đặc biệt trích dẫn gốc MOSFOA)
- declarations (xung đột lợi ích, lời cảm ơn/tài trợ)
- formatting (chuyển .md → .docx theo đúng `JTST_TemplatePaper_Vietnamese.docx`)
- figure insertion (3 hình đã có sẵn cần chèn; sơ đồ quy trình, ảnh mô hình FEM, sơ đồ bố trí cấu kiện cần tự tạo)
