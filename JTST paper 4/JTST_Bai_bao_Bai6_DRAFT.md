# TỐI ƯU ĐA MỤC TIÊU HỆ KẾT CẤU BÊN TRÊN CẦU TÀU CHỊU NHIỀU TỔ HỢP TẢI TRỌNG SỬ DỤNG THUẬT TOÁN MOSFOA

## MULTI-OBJECTIVE OPTIMIZATION OF PORT JETTY SUPERSTRUCTURE UNDER MULTIPLE LOAD COMBINATIONS USING MOSFOA

**[TÊN TÁC GIẢ — CẦN ĐIỀN, đối chiếu lại với các bài trước cùng nhóm]**

¹Trường Đại học Hàng hải Việt Nam

*Tác giả liên hệ: [CẦN ĐIỀN — email, địa chỉ]*

---

## Tóm tắt

Tối ưu hóa kết cấu là công cụ quan trọng để cân bằng giữa khối lượng vật liệu và khả năng chịu lực trong thiết kế công trình cảng, đặc biệt khi phương án thiết kế phải đồng thời thỏa mãn một hệ lớn các tổ hợp tải trọng. Nghiên cứu này áp dụng thuật toán tối ưu đa mục tiêu MOSFOA (đã công bố trước đó, không cải tiến/so sánh trong bài này) để giải bài toán tối ưu hệ kết cấu bên trên (dầm ngang, dầm dọc, dầm cần trục, bản mặt cầu) của một mô hình nghiên cứu giả định cầu tàu 70.000 DWT, xây dựng dựa trên bộ thông số kỹ thuật của Bến số 1 – Cảng Chân Mây, tích hợp MOSFOA–MATLAB–SAP2000 và xét đồng thời 410 tổ hợp tải trọng (388 tổ hợp trạng thái giới hạn cực hạn ULSB và 20 tổ hợp trạng thái giới hạn khai thác SLSDH). Bốn biến thiết kế (chiều cao dầm ngang, dầm dọc, dầm cần trục và chiều dày bản mặt cầu) được tối ưu đồng thời theo hai mục tiêu: cực tiểu hóa khối lượng bê tông và cực tiểu hóa hệ số khai thác lớn nhất của kết cấu. Campaign chính thức gồm 20 lần chạy độc lập (40.400 lần đánh giá) cho kết quả hội tụ ổn định tuyệt đối: khối lượng nhỏ nhất tìm được giống hệt nhau (2.311,93 tấn, độ lệch chuẩn bằng 0) ở cả 20 lần chạy, hình thành một mặt Pareto tổng thể gồm 90 nghiệm không bị trội. Phân tích hậu kỳ trên 3 nghiệm đại diện (tách riêng đầy đủ 410 tổ hợp) xác định bản mặt cầu là cấu kiện luôn chi phối hệ số khai thác, và xác định các tổ hợp tải trọng cụ thể chi phối nội lực cọc và chuyển vị ngang một cách nhất quán trên toàn dải Pareto. Kết quả cung cấp một minh chứng bổ sung cho khả năng áp dụng MOSFOA vào bài toán tối ưu kết cấu cảng có nhiều biến thiết kế và ràng buộc từ mô hình phần tử hữu hạn.

**Từ khóa**: Tối ưu đa mục tiêu; MOSFOA; cầu tàu; hệ kết cấu bên trên; SAP2000; tổ hợp tải trọng; tối ưu kết cấu.

## Abstract

Structural optimization is an important tool for balancing material mass and load-carrying capacity in port structure design, particularly when a design candidate must simultaneously satisfy a large set of load combinations. This study applies the multi-objective Starfish Optimization Algorithm (MOSFOA — a previously published algorithm, neither modified nor benchmarked against other methods in this work) to solve a superstructure optimization problem (transverse beams, longitudinal beams, crane beams, and deck slab) for an assumed research model of a 70,000 DWT port jetty, constructed from the technical parameters of Berth No. 1 — Chan May Port, integrating MOSFOA–MATLAB–SAP2000 and simultaneously considering 410 load combinations (388 Ultimate Limit State combinations, ULSB, and 20 Serviceability Limit State combinations, SLSDH). Four design variables (transverse beam height, longitudinal beam height, crane beam height, and deck slab thickness) were simultaneously optimized for two objectives: minimizing concrete mass and minimizing the maximum utilization ratio. The official campaign of 20 independent runs (40,400 evaluations) produced remarkably stable convergence: the minimum mass found was identical across all 20 runs (2,311.93 tons, standard deviation = 0), forming an overall non-dominated Pareto front of 90 solutions. Post-processing of three representative solutions (with all 410 combinations individually verified) identified the deck slab as the consistently governing member for the utilization ratio, and identified specific load combinations that consistently govern pile axial force and lateral displacement across the entire Pareto front. The results provide additional evidence for the applicability of MOSFOA to port structural optimization problems involving multiple design variables and finite-element-model-derived constraints.

**Keywords**: Multi-objective optimization; MOSFOA; port jetty; superstructure; SAP2000; load combinations; structural optimization.

---

## 1. Giới thiệu

### 1.1. Bối cảnh nghiên cứu

Tối ưu hóa kết cấu đóng vai trò ngày càng quan trọng trong thiết kế công trình cảng, nơi yêu cầu cân bằng giữa khối lượng vật liệu sử dụng và khả năng chịu lực của kết cấu dưới điều kiện khai thác phức tạp. Khác với nhiều bài toán tối ưu kết cấu dân dụng chỉ cần xét một số ít tổ hợp tải trọng tiêu chuẩn, kết cấu bến cảng — đặc biệt là cầu tàu tiếp nhận tàu trọng tải lớn — phải đồng thời chịu tác động của nhiều nhóm tải trọng có bản chất khác nhau (tĩnh tải, hoạt tải khai thác, tải trọng cần trục, va tàu, neo tàu, tải trọng môi trường: gió, dòng chảy, nhiệt độ), dẫn đến một hệ tổ hợp tải trọng rất lớn (có thể lên tới hàng trăm tổ hợp) mà mỗi phương án thiết kế đều phải thỏa mãn đồng thời. Điều này khiến bài toán tối ưu kết cấu cầu tàu trở thành một bài toán có ràng buộc phức tạp, đòi hỏi phương pháp giải hiệu quả để xử lý khối lượng tính toán lớn phát sinh từ việc lặp lại phân tích phần tử hữu hạn (FEM) cho mỗi phương án thiết kế qua toàn bộ hệ tổ hợp.

Các phương pháp metaheuristic (thuật toán tối ưu dựa trên tự nhiên/quần thể) đã chứng minh hiệu quả trong việc giải các bài toán tối ưu kết cấu phi tuyến, nhiều biến, có ràng buộc phức tạp mà các phương pháp giải tích truyền thống khó xử lý trực tiếp — đặc biệt khi hàm mục tiêu/ràng buộc phải được đánh giá gián tiếp thông qua một mô hình phân tích kết cấu (FEM) bên ngoài.

### 1.2. Tổng quan nghiên cứu

*(Cần bổ sung trích dẫn cụ thể — xem đề cương mục 6.2, gồm 3 nhóm: (1) tối ưu kết cấu bằng metaheuristic; (2) tối ưu đa mục tiêu cho kết cấu/công trình cảng; (3) tối ưu kết cấu khi phải kiểm tra nhiều tổ hợp tải trọng/phân tích FEM. Không mở rộng thành tổng quan riêng về MOSFOA.)*

### 1.3. Khoảng trống nghiên cứu

Các nghiên cứu ứng dụng tối ưu đa mục tiêu cho kết cấu cầu tàu còn cần được mở rộng sang bài toán lựa chọn cấu hình hệ kết cấu bên trên trong điều kiện phải đồng thời đáp ứng nhiều tổ hợp tải trọng và ràng buộc kỹ thuật rút ra trực tiếp từ mô hình phần tử hữu hạn.

### 1.4. Mục tiêu và phạm vi nghiên cứu

Nghiên cứu này sử dụng thuật toán MOSFOA (đã công bố) để giải bài toán tối ưu đa mục tiêu hệ kết cấu bên trên cầu tàu, với SAP2000 đảm nhiệm phân tích phần tử hữu hạn và MATLAB điều khiển toàn bộ quá trình tối ưu. Đối tượng nghiên cứu là một **mô hình nghiên cứu giả định** cầu tàu 70.000 DWT, xây dựng dựa trên bộ thông số kỹ thuật của Bến số 1 – Cảng Chân Mây. Nghiên cứu **không** nhằm đánh giá/kiểm định công trình hiện hữu, **không** so sánh với hồ sơ thiết kế gốc, và **không** sử dụng kết quả tối ưu để đưa ra kết luận về công trình thực tế.

---

## 2. Phương pháp nghiên cứu

### 2.1. Phát biểu bài toán tối ưu đa mục tiêu

Bài toán tối ưu đa mục tiêu có ràng buộc được phát biểu tổng quát:

$$\min \mathbf{F}(\mathbf{x}) = [f_1(\mathbf{x}), f_2(\mathbf{x})]$$

với $\mathbf{x} = [x_1, x_2, x_3, x_4]$ là vector biến thiết kế, chịu ràng buộc $g_j(\mathbf{x}) \le 0$, $j=1,\ldots,4$.

### 2.2. Thuật toán MOSFOA

MOSFOA (Multi-objective Starfish Optimization Algorithm) là thuật toán tối ưu đa mục tiêu đã được công bố trước đó bởi nhóm tác giả [1], không được phát triển lại hay cải tiến trong nghiên cứu này. Cấu trúc thuật toán gồm: khởi tạo quần thể ngẫu nhiên trong không gian thiết kế; luân phiên giữa pha khám phá (exploration, dựa trên cơ chế "energy-step" cho không gian ≤5 biến) và pha khai thác (exploitation, dựa trên cơ chế "preying/regeneration") theo một hệ số điều khiển pha phụ thuộc số vòng lặp; đánh giá độ trội (dominance) giữa quần thể hiện tại và quần thể mới; cập nhật kho lưu trữ (archive/Repository) các nghiệm không bị trội theo cơ chế lưới (grid-based diversity maintenance); lựa chọn nghiệm dẫn hướng (leader) từ archive cho vòng lặp kế tiếp; tinh chỉnh Gaussian quanh nghiệm tốt nhất ở giai đoạn cuối (>80% tổng số vòng lặp). Tiêu chí dừng là đạt số vòng lặp tối đa đã định trước.

### 2.3. Mô hình liên kết MOSFOA–MATLAB–SAP2000

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

*(Hình sơ đồ quy trình dạng khối — file ảnh chưa được chèn, xem ghi chú cuối bài.)*

### 2.4. Quy trình đánh giá một nghiệm

Với mỗi phương án thiết kế $\mathbf{x}$ đề xuất bởi MOSFOA: (1) làm tròn về lưới rời rạc bước 0,05 m gần nhất cho từng biến; (2) cập nhật tiết diện dầm ngang/dầm dọc/dầm cần trục (hình chữ nhật, `SetRectangle`) và chiều dày bản mặt cầu (`SetShell_1`) trong SAP2000; (3) chạy phân tích kết cấu; (4) trích mô-men uốn lớn nhất trên từng nhóm dầm (hợp $\sqrt{M_2^2+M_3^2}$) và bản mặt cầu (max$(|M_{11}|,|M_{22}|)$) theo tổ hợp bao `BAO-ULSB`, lực dọc trục lớn nhất trên cọc và chuyển vị ngang lớn nhất tại đỉnh bến (hợp $\sqrt{U_1^2+U_2^2}$) theo tổ hợp bao `BAO-SLSDH`; (5) kiểm tra ràng buộc; (6) tính hai hàm mục tiêu; (7) trả fitness về MOSFOA — nếu vi phạm bất kỳ ràng buộc nào, gán fitness bằng một giá trị phạt cứng lớn ($10^{12}$ cho cả hai mục tiêu) để loại nghiệm khỏi archive.

**Lưu ý phương pháp luận quan trọng**: việc sử dụng tổ hợp bao (envelope) `BAO-ULSB`/`BAO-SLSDH` trong vòng lặp tối ưu (thay vì tách riêng 410 tổ hợp cho mỗi lần đánh giá) là một lựa chọn có chủ đích nhằm giảm chi phí tính toán — tổ hợp bao được chính SAP2000 tính sẵn từ 388 (hoặc 20) tổ hợp cấu thành, cho một chỉ số **cận trên thiên về an toàn**. Với ba nghiệm Pareto đại diện cuối cùng, toàn bộ 410 tổ hợp được tách riêng và đánh giá độc lập để xác nhận giá trị chính xác và tổ hợp chi phối thực sự (mục 4.6).

---

## 3. Mô hình nghiên cứu cầu tàu 70.000 DWT

### 3.1. Cơ sở xây dựng mô hình

Mô hình được xây dựng từ bộ thông số kỹ thuật của dự án Chân Mây 70.000 DWT, trình bày dưới dạng **mô hình nghiên cứu giả định** phục vụ bài toán tối ưu kết cấu — không sử dụng ngôn ngữ đánh giá/kiểm định công trình hiện hữu.

### 3.2. Hình học và quy mô mô hình

Mô hình SAP2000 (đơn vị Tonf–m–°C) gồm 1.942 nút, 747 phần tử thanh (frame) và 1.750 phần tử tấm vỏ (shell), đại diện cho Phân đoạn V (60 m) của cầu chính (300 m, 5 phân đoạn) — bến nhô dạng cầu tàu trên cọc. Hệ cọc gồm 96 cọc ống thép D700 (giữ cố định trong nghiên cứu này, không thuộc phạm vi tối ưu).

### 3.3. Vật liệu

Bê tông M400 (E=3,3×10⁴ MPa, quy đổi Rb≈17 MPa theo TCVN 5574:2018 cho tính toán mô-men kháng uốn); dầm ngang/dầm dọc mác M400-DN (ρ=1,935 T/m³), dầm cần trục mác M400-DCT (ρ=2,05 T/m³), bản mặt cầu mác M400 (ρ=2,50 T/m³); cốt thép CB300-V (Rs≈260 MPa tính toán) theo TCVN 1651-2018; thép cọc ống D700/t12,6mm với Fy=3.150 kG/cm² (giá trị proxy theo TCVN 9245:2012, mượn từ dự án tham khảo cùng tiêu chuẩn áp dụng, do không có chứng chỉ vật liệu riêng cho lô thép đã thi công).

### 3.4. Tải trọng và tổ hợp tải trọng

Mô hình có 21 dạng tải trọng cơ bản (tĩnh tải, hoạt tải hàng hóa, cần trục, xe ô tô, va tàu, neo tàu, môi trường: nhiệt độ/dòng chảy) tổ hợp thành **410 tổ hợp tải trọng**: 388 tổ hợp trạng thái giới hạn cực hạn (ULSB-001…ULSB-388, hệ số riêng phần Eurocode "Set B"), 20 tổ hợp trạng thái giới hạn khai thác (SLSDH-01…SLSDH-20), và 2 tổ hợp bao (`BAO-ULSB`, `BAO-SLSDH`).

---

## 4. Thiết lập bài toán tối ưu

### 4.1. Biến thiết kế

Bốn biến thiết kế thuộc hệ kết cấu bên trên, rời rạc hóa bước đều 0,05 m:

$$\mathbf{x} = [X_1, X_2, X_3, X_4] = [h_{DN}, h_{DD}, h_{DCT}, t_{BMC}]$$

| Biến | Ký hiệu | Cấu kiện | Bề rộng cố định | Miền giá trị | Số mức |
|---|---|---|---:|---|---:|
| $X_1$ | $h_{DN}$ | Dầm ngang | 1,00 m | [1,10 ; 2,00] m | 19 |
| $X_2$ | $h_{DD}$ | Dầm dọc | 1,00 m | [1,10 ; 2,00] m | 19 |
| $X_3$ | $h_{DCT}$ | Dầm cần trục | 1,30 m | [1,40 ; 2,50] m | 23 |
| $X_4$ | $t_{BMC}$ | Bản mặt cầu | — | [0,25 ; 0,45] m | 5 |

Hệ cọc (D700, cố định) và tiết diện phụ trợ khác (MR) không thuộc phạm vi biến thiết kế, tránh trùng lặp với hướng nghiên cứu tối ưu hệ cọc đã công bố riêng.

### 4.2. Hàm mục tiêu

**Objective 1 — khối lượng bê tông kết cấu bên trên**:

$$f_1(\mathbf{x}) = \rho_{DN} b_{DN} X_1 L_{DN} + \rho_{DD} b_{DD} X_2 L_{DD} + \rho_{DCT} b_{DCT} X_3 L_{DCT} + \rho_{BMC} X_4 A_{BMC}$$

trong đó $L_{DN}$=273 m, $L_{DD}$=180 m, $L_{DCT}$=120 m (tổng chiều dài thật, đo qua OAPI), $A_{BMC}$=1.440 m² (=24 m × 60 m, khớp chính xác hình học mô hình) — các hằng số hình học này không đổi theo $\mathbf{x}$.

**Objective 2 — hệ số khai thác lớn nhất**:

$$f_2(\mathbf{x}) = \max(\eta_{DN}, \eta_{DD}, \eta_{DCT}, \eta_{BMC}), \qquad \eta_i = \frac{M_{Ed,i}}{M_{u,i}(\mathbf{x})}$$

Mô-men kháng uốn $M_u$ tính theo TCVN 5574:2018 với giả thiết cốt thép chịu kéo lấy theo điều kiện cân bằng ($\xi=\xi_R$) — phản ánh khả năng chịu uốn lớn nhất khả dĩ của riêng tiết diện bê tông đang xét, độc lập với hàm lượng cốt thép thực tế thi công (không xác định được từ mô hình FEM sẵn có):

$$\xi_R = \frac{\omega}{1+\dfrac{R_s}{\sigma_{scu}}\left(1-\dfrac{\omega}{1{,}1}\right)}, \quad \omega=\alpha_{R1}-0{,}008R_b, \quad M_u = \xi_R(1-0{,}5\xi_R)R_b\,b\,h_0^2$$

### 4.3. Hệ ràng buộc

| Ràng buộc | Công thức | Cơ sở |
|---|---|---|
| $g_1$ — Khai thác cấu kiện | $\eta_{DN},\eta_{DD},\eta_{DCT},\eta_{BMC} \le 1$ | TCVN 5574:2018 |
| $g_2$ — Chuyển vị | $U_{max} \le L/240 \approx 0{,}0217$ m | Quy ước (L≈5,2 m khoang cọc dọc bến) |
| $g_3$ — Sức chịu tải cọc | $\gamma_n N_{max} \le R_d = 450$ Tấn | Giá trị quy ước, đại diện năng lực thông thường cọc ống thép D700 trong đất tốt (xem mục 4.5) |
| $g_4$ — Ứng suất vật liệu cọc | $\sigma = N_{max}/A_{coc} \le F_y/\gamma$ | $F_y$=3.150 kG/cm² (TCVN 9245:2012, giá trị proxy) |

### 4.4. Tham số MOSFOA

| Tham số | Giá trị |
|---|---:|
| Kích thước quần thể (Npop) | 20 |
| Số vòng lặp tối đa (Max_it) | 100 |
| Kích thước archive (Nr) | 100 |
| Số biến | 4 |
| Số lần chạy độc lập (Nrun) | 20 |
| Số worker song song | 8 |
| Tổng số lần đánh giá | 20×2.020 = 40.400 |

Mỗi lần chạy độc lập sử dụng một seed số ngẫu nhiên riêng (khởi tạo bằng `rng('shuffle')`, lưu lại để có thể truy vết/tái lập), khác nhau tuyệt đối giữa 20 lần chạy — xác nhận đã loại trừ khả năng các lần chạy trùng lặp do cùng chuỗi ngẫu nhiên.

### 4.5. Giới hạn dữ liệu và giả định thiên về an toàn cần công bố minh bạch

Do hồ sơ sẵn có (thuyết minh sửa chữa 2023, không phải hồ sơ thiết kế/khảo sát địa chất đầy đủ) không cung cấp đủ dữ liệu độc lập, đáng tin cậy để xác định chính xác cao độ mũi cọc và sức chịu tải cọc theo đất nền riêng cho vị trí nghiên cứu, giá trị $R_d$=450 Tấn trong ràng buộc $g_3$ là **giá trị quy ước**, đại diện năng lực chịu tải thông thường của cọc ống thép D700 trong nền đất tốt — **không** được suy ra từ số liệu địa chất cụ thể của Chân Mây và **không** cấu thành một đánh giá địa kỹ thuật chính thức. Tương tự, $F_y$=3.150 kG/cm² (ràng buộc $g_4$) là giá trị mượn từ một dự án tham khảo cùng áp dụng TCVN 9245:2012, không phải số liệu xác nhận riêng cho lô thép đã thi công. Các giả định này phù hợp với định vị "mô hình nghiên cứu giả định" của bài báo (không đánh giá công trình hiện hữu) nhưng cần được nêu rõ để người đọc hiểu đúng phạm vi áp dụng của kết quả.

### 4.6. Xử lý 410 tổ hợp tải trọng

Trong vòng lặp tối ưu, $f_2$ và các ràng buộc liên quan được tính từ 2 tổ hợp bao (`BAO-ULSB`, `BAO-SLSDH`), vốn đã bao hàm giá trị lớn nhất của từng thành phần nội lực/chuyển vị trên toàn bộ 388/20 tổ hợp cấu thành. Với 3 nghiệm Pareto đại diện cuối cùng, toàn bộ 410 tổ hợp được tách riêng và trích xuất độc lập để: (i) xác nhận giá trị $\eta_{max}$ chính xác đạt được bởi một tổ hợp cụ thể (không phải giá trị tổng hợp từ 2 thành phần đến từ 2 tổ hợp khác nhau như trường hợp tổ hợp bao); (ii) xác định tổ hợp tải trọng nào chi phối từng đại lượng kiểm tra (mô-men từng nhóm dầm, lực dọc cọc, chuyển vị).

---

## 5. Kết quả và thảo luận

### 5.1. Kiểm chứng mô hình và pipeline tính toán

Trước campaign chính thức, mô hình liên kết MOSFOA–MATLAB–SAP2000 được kiểm chứng qua: (i) đối chiếu số lượng phần tử theo từng nhóm cấu kiện (96/282/210/140/1.750 cho cọc/DN/DD/DCT/bản) khớp tuyệt đối với dữ liệu mô hình gốc; (ii) kiểm tra riêng từng biến thiết kế thay đổi độc lập chỉ ảnh hưởng đúng nhóm cấu kiện tương ứng, không ảnh hưởng chéo; (iii) kiểm tra tính không "trễ" (stale) của kết quả — đánh giá lại cùng 1 phương án sau khi đã đánh giá phương án khác cho kết quả tái lập chính xác; (iv) kiểm tra tại 2 điểm biên của miền thiết kế để xác nhận toàn bộ pipeline hoạt động ổn định trên toàn miền tìm kiếm.

### 5.2. Khả năng hội tụ của MOSFOA

*Hình 1* trình bày đường cong hội tụ (giá trị $f_1$ nhỏ nhất tìm được theo vòng lặp) của cả 20 lần chạy độc lập chồng lớp. Cả 20/20 lần chạy hội tụ về đúng giá trị $f_1$=2.311,93 Tấn **ngay từ vòng lặp thứ 20/100** (20% tổng số vòng lặp) và giữ nguyên không đổi đến hết vòng lặp 100, không phân biệt seed khởi tạo. Đây là bằng chứng số liệu trực tiếp (không suy diễn) cho khả năng hội tụ ổn định của MOSFOA trên bài toán 4 biến với ràng buộc rút ra từ mô hình FEM.

*(Hình 1 — Đường cong hội tụ 20 lần chạy: `code/results/Hinh_hoitu_20runs.png`, đã tạo sẵn, cần chèn vào bản thảo.)*

### 5.3. Tập nghiệm Pareto

Từ 20 lần chạy độc lập (40.400 lần đánh giá), hợp nhất và loại bỏ các nghiệm bị trội cho một **mặt Pareto tổng thể gồm 90 nghiệm** không bị trội lẫn nhau, thể hiện quan hệ đánh đổi rõ ràng giữa khối lượng bê tông ($f_1$: 2.311,93 – 3.820,83 Tấn) và hệ số khai thác ($f_2$: 0,1550 – 0,4053). Cả 20/20 lần chạy đều đóng góp ít nhất một nghiệm vào mặt Pareto tổng thể, cho thấy mỗi lần chạy độc lập khám phá được những vùng khác nhau của không gian thiết kế trong khi vẫn hội tụ về cùng một vùng trade-off chung.

*(Hình 2 — Pareto front: `code/results/campaign_20runs_pareto_overlay.png`, đã có sẵn.)*

### 5.4. Phân tích các nghiệm đại diện

Ba nghiệm đại diện được chọn từ mặt Pareto tổng thể: A (khối lượng nhỏ nhất), B (nghiệm cân bằng, khoảng cách chuẩn hóa nhỏ nhất tới điểm lý tưởng), C (hệ số khai thác nhỏ nhất).

**Bảng 1. Ba nghiệm Pareto đại diện**

| Nghiệm | $h_{DN}$ (m) | $h_{DD}$ (m) | $h_{DCT}$ (m) | $t_{BMC}$ (m) | $f_1$ (Tấn) | $\eta_{max}$ (thật) |
|---|---:|---:|---:|---:|---:|---:|
| A — nhẹ nhất | 1,10 | 1,10 | 1,40 | 0,25 | 2.311,93 | 0,3538 |
| B — cân bằng | 1,15 | 1,45 | 1,40 | 0,35 | 2.820,25 | 0,2082 |
| C — đáp ứng tốt nhất | 2,00 | 2,00 | 1,40 | 0,45 | 3.820,83 | 0,1550 |

*(Hình 3 — So sánh 3 nghiệm đại diện: `code/results/Hinh_sosanh_ABC.png`, đã có sẵn.)*

Đáng chú ý, chiều cao dầm cần trục $h_{DCT}$ giữ nguyên giá trị nhỏ nhất (1,40 m) ở cả 3 nghiệm đại diện — cho thấy dầm cần trục không phải là yếu tố chi phối trong việc cải thiện $\eta_{max}$ trên phần lớn dải Pareto; sự cải thiện chủ yếu đến từ việc tăng $h_{DN}$, $h_{DD}$ và $t_{BMC}$.

### 5.5. Ảnh hưởng của biến thiết kế

Kết quả Bảng 1 cho thấy quan hệ đánh đổi rõ ràng: tăng đồng thời chiều cao dầm ngang/dầm dọc và chiều dày bản mặt cầu làm tăng khối lượng bê tông (2.311,93 → 3.820,83 Tấn, +65,3%) nhưng giảm mạnh hệ số khai thác lớn nhất (0,3538 → 0,1550, −56,2%). Chiều dày bản mặt cầu $t_{BMC}$ có ảnh hưởng đặc biệt lớn đến $\eta_{max}$ (xem mục 5.6) do bản mặt cầu là cấu kiện luôn chi phối hệ số khai thác.

### 5.6. Cấu kiện và tổ hợp tải trọng chi phối

**Bảng 2. Hệ số khai thác từng nhóm cấu kiện và tổ hợp chi phối tương ứng**

| Đại lượng | Nghiệm A | Nghiệm B | Nghiệm C | Tổ hợp chi phối |
|---|---:|---:|---:|---|
| $\eta_{DN}$ | 0,2183 | 0,1860 | 0,0937 | ULSB-044 (A,B) / ULSB-043 (C) |
| $\eta_{DD}$ | 0,1749 | 0,1162 | 0,0931 | ULSB-252 (A) / ULSB-024 (B,C) |
| $\eta_{DCT}$ | 0,1008 | 0,0931 | 0,0802 | **ULSB-024 (cả A, B, C)** |
| $\eta_{BMC}$ | **0,3538** | **0,2082** | **0,1550** | ULSB-038 (A) / ULSB-029 (B,C) |
| $N_{pile}$ (Tấn) | 210,00 | 218,01 | 227,62 | **ULSB-051 (cả A, B, C)** |
| $U_{max}$ (m) | 0,0491 | 0,0490 | 0,0487 | **ULSB-051 (cả A, B, C)** |

Hai phát hiện nhất quán trên toàn bộ dải Pareto (cả 3 nghiệm đại diện, không có ngoại lệ):

1. **Bản mặt cầu (BMC) luôn là cấu kiện chi phối hệ số khai thác lớn nhất** — không phải các dầm, dù dầm cần trục có tiết diện lớn nhất trong 3 loại dầm. Điều này gợi ý rằng, trong phạm vi mô hình và tải trọng đang xét, việc tăng chiều dày bản mặt cầu là biện pháp hiệu quả nhất để cải thiện $\eta_{max}$ tổng thể.
2. **Tổ hợp ULSB-051 chi phối đồng thời cả lực dọc trục cọc và chuyển vị ngang lớn nhất** ở cả 3 nghiệm, và **tổ hợp ULSB-024 luôn chi phối mô-men dầm cần trục**, không phụ thuộc vào việc kích thước hệ kết cấu bên trên thay đổi thế nào. Đây là bằng chứng trực tiếp trả lời câu hỏi nghiên cứu về việc xác định các tổ hợp tải trọng có xu hướng chi phối tính khả thi của nghiệm tối ưu.

### 5.7. Ghi chú phương pháp luận: chênh lệch giữa hệ số khai thác từ tổ hợp bao và từ tổ hợp riêng lẻ

Đối chiếu $f_2$ tính từ tổ hợp bao `BAO-ULSB` (dùng trong vòng lặp tối ưu) với giá trị $\eta_{max}$ xác nhận từ 410 tổ hợp riêng lẻ (Bảng 1) cho thấy: với nghiệm B và C, hai giá trị khớp chính xác tuyệt đối; với nghiệm A, giá trị từ tổ hợp bao (0,4053) cao hơn giá trị thật (0,3538) khoảng 13%. Nguyên nhân là tổ hợp bao (Envelope) trong SAP2000 báo cáo giá trị lớn nhất của từng thành phần mô-men ($M_2$, $M_3$) **độc lập với nhau**, có thể đến từ hai tổ hợp cơ bản khác nhau trong số 388 tổ hợp cấu thành — khi ghép $\sqrt{M_2^2+M_3^2}$ từ hai giá trị "lớn nhất riêng lẻ" này, kết quả có thể lớn hơn giá trị thực tế đạt được bởi bất kỳ một tổ hợp cụ thể nào. Đây là đặc tính vốn có của tổ hợp bao khi áp dụng cho một đại lượng tổng hợp (resultant), **không phải sai số tính toán hay hạn chế của thuật toán MOSFOA**. Do đó, $f_2$ dùng trong quá trình tìm kiếm cần được hiểu là một **chỉ số cận trên thiên về an toàn** (không bỏ sót nghiệm nguy hiểm trong quá trình tìm kiếm), còn giá trị $\eta_{max}$ báo cáo cho các nghiệm đại diện cuối cùng trong bài báo này đều đã được xác nhận qua tách riêng tổ hợp thật.

### 5.8. Thảo luận

**MOSFOA có tạo được tập nghiệm khả thi và hội tụ ổn định hay không?** Kết quả cho thấy câu trả lời khẳng định: 40.400 lần đánh giá qua 20 lần chạy độc lập không ghi nhận bất kỳ vi phạm hội tụ nào, giá trị $f_1$ nhỏ nhất giống hệt tuyệt đối (độ lệch chuẩn bằng 0) và $f_2$ nhỏ nhất gần như không đổi (độ lệch chuẩn ≈0,00005) giữa các lần chạy — dù mỗi lần chạy sử dụng seed ngẫu nhiên hoàn toàn khác nhau (đã xác nhận trực tiếp, không có hai lần chạy nào trùng seed).

**Trade-off giữa khối lượng và đáp ứng kết cấu thể hiện như thế nào?** Mặt Pareto tổng thể (90 nghiệm) thể hiện quan hệ đánh đổi liên tục và trơn tru trên toàn dải khảo sát, không có bước nhảy bất thường, phản ánh đúng bản chất vật lý của bài toán (tiết diện lớn hơn → khối lượng tăng, đáp ứng kết cấu tốt hơn).

**Việc xét đồng thời nhiều tổ hợp tải trọng ảnh hưởng thế nào đến miền nghiệm khả thi và các trường hợp tải trọng chi phối?** Kết quả tách riêng 410 tổ hợp cho thấy không phải mọi tổ hợp đều có vai trò như nhau: chỉ một số ít tổ hợp cụ thể (ULSB-024, ULSB-051, và một vài tổ hợp khác tùy cấu kiện) thực sự chi phối trên toàn dải Pareto, trong khi phần lớn 388+20 tổ hợp còn lại không bao giờ trở thành tổ hợp khống chế cho các cấu kiện đang xét. Đây là thông tin kỹ thuật hữu ích cho việc đơn giản hóa các phân tích tương tự trong tương lai (có thể tập trung kiểm tra một tập con nhỏ các tổ hợp đã xác định là hay chi phối, thay vì toàn bộ 410 tổ hợp, cho các bài toán có đặc điểm hình học/tải trọng tương tự).

Phạm vi nghiên cứu này **không** mở rộng sang phân tích ảnh hưởng của quy mô công trình, điều kiện địa chất, hay so sánh giữa các dự án khác — các nội dung này thuộc phạm vi các bài nghiên cứu khác trong cùng chuỗi.

---

## 6. Kết luận

1. MOSFOA có thể áp dụng hiệu quả để giải bài toán tối ưu đa mục tiêu hệ kết cấu bên trên cầu tàu với 4 biến thiết kế và ràng buộc rút ra trực tiếp từ mô hình phần tử hữu hạn chịu 410 tổ hợp tải trọng.
2. Việc thay đổi các biến thiết kế phần trên tạo ra một mặt Pareto liên tục gồm 90 nghiệm, thể hiện rõ quan hệ đánh đổi giữa khối lượng (2.311,93 – 3.820,83 Tấn) và hệ số khai thác lớn nhất (0,1550 – 0,4053).
3. Kết quả 20 lần chạy độc lập cho thấy MOSFOA hội tụ ổn định về cùng một nghiệm tối ưu về khối lượng (độ lệch chuẩn bằng 0) dù xuất phát từ các seed ngẫu nhiên hoàn toàn khác nhau — bằng chứng định lượng về tính ổn định của thuật toán trên bài toán này.
4. Việc tách riêng đầy đủ 410 tổ hợp tải trọng cho các nghiệm đại diện xác định bản mặt cầu là cấu kiện luôn chi phối hệ số khai thác, và xác định các tổ hợp tải trọng cụ thể (ULSB-024, ULSB-051) chi phối nhất quán trên toàn dải Pareto — cung cấp thông tin kỹ thuật có thể áp dụng cho việc đơn giản hóa các phân tích tương tự.

Các kết quả trên cung cấp một minh chứng bổ sung cho khả năng áp dụng MOSFOA vào các bài toán tối ưu kết cấu cảng có nhiều biến thiết kế và hệ ràng buộc phức tạp, đồng thời làm rõ vai trò của việc lựa chọn phương pháp xử lý tổ hợp tải trọng (tổ hợp bao trong tìm kiếm, tách riêng cho xác nhận cuối cùng) đối với độ chính xác của kết quả báo cáo. Kết luận không vượt quá dữ liệu thực nghiệm đã trình bày.

---

## Tuyên bố không xung đột lợi ích và cam kết bản quyền

*[Theo mẫu chuẩn của tạp chí — cần điền theo đúng văn bản JTST yêu cầu.]*

## Chia sẻ dữ liệu theo yêu cầu

Dữ liệu campaign (20 file kết quả `.mat`, mặt Pareto tổng thể, dữ liệu tổ hợp chi phối) có thể được cung cấp khi có yêu cầu chính đáng.

## Lời cảm ơn

*[Chỉ đưa nếu có — cần xác nhận nguồn tài trợ nếu có.]*

## Tài liệu tham khảo

*(Định dạng IEEE, cần bổ sung đầy đủ — tối thiểu các nhóm: (1) công bố gốc MOSFOA; (2) các bài trước trong cùng chuỗi nghiên cứu (Bài 4 hệ cọc, Bài 5 MOFDA-MOSFOA); (3) TCVN 5574:2018, TCVN 9245:2012, TCVN 1651-2018; (4) nghiên cứu MOO kết cấu/công trình cảng liên quan.)*

[1] *[Trích dẫn công bố gốc MOSFOA — cần điền chính xác, đối chiếu với các bài trước cùng nhóm tác giả.]*

## Đóng góp của các tác giả

*[Theo mẫu JTST — Methodology, Data management, Formal analysis, Investigation, Validation, Visualization... cần điền theo đúng vai trò thật của từng tác giả.]*

---

## GHI CHÚ CHO NGƯỜI VIẾT (xóa trước khi nộp)

**Hình còn thiếu, cần tự chèn** (dữ liệu/nội dung đã có sẵn, chỉ cần thao tác chèn hình vào đúng vị trí — đã đánh dấu trong bài):
1. **Hình 1** (đường hội tụ 20 run) — file đã có sẵn: `code/results/Hinh_hoitu_20runs.png`.
2. **Hình 2** (Pareto front) — file đã có sẵn: `code/results/campaign_20runs_pareto_overlay.png`.
3. **Hình 3** (so sánh A/B/C) — file đã có sẵn: `code/results/Hinh_sosanh_ABC.png`.
4. **Sơ đồ quy trình MOSFOA–MATLAB–SAP2000** (dạng khối, mục 2.3) — hiện chỉ có bản văn bản ASCII trong bài; cần bạn tự vẽ lại bằng PowerPoint/Visio/draw.io cho đẹp (nội dung 7 khối đã có sẵn trong mục 2.3, chỉ cần vẽ lại hình thức).
5. **Ảnh/render mô hình FEM cầu tàu** (SAP2000) — cần bạn tự mở SAP2000 và chụp màn hình mô hình 3D (tôi không tạo được ảnh này qua COM automation).
6. **Sơ đồ bố trí nhóm cấu kiện/biến thiết kế** trên mặt bằng — tương tự, cần vẽ tay hoặc trích từ bản vẽ CAD sẵn có.

**Việc còn cần điền/xác nhận trước khi nộp**:
- Tên tác giả, đơn vị công tác, email liên hệ (đối chiếu với các bài trước cùng nhóm — Bài 2 đã xác nhận: ĐỖ QUANG THÀNH, VŨ HỮU TRƯỜNG, LÊ THANH CƯỜNG, email thanhdq.ctt@vimaru.edu.vn — kiểm tra xem có áp dụng cho Bài 6 không).
- Mục 1.2 (Tổng quan nghiên cứu) — cần bổ sung trích dẫn tài liệu tham khảo cụ thể theo 3 nhóm đã nêu trong đề cương.
- Danh mục tài liệu tham khảo đầy đủ (định dạng IEEE) — đặc biệt trích dẫn chính xác công bố gốc MOSFOA.
- Tuyên bố xung đột lợi ích, lời cảm ơn (nguồn tài trợ nếu có), đóng góp tác giả — theo đúng mẫu JTST.
- Kiểm tra lại toàn bộ định dạng font/margin/style theo đúng `JTST_TemplatePaper_Vietnamese.docx` khi chuyển sang .docx cuối cùng (bài này viết ở dạng .md nháp, theo đúng quy ước đã dùng cho các bài trước trong chuỗi — viết nội dung trước, chuyển .docx sau khi nội dung đã chốt).
