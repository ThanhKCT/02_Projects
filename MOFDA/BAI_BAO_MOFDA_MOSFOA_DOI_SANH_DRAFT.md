TỐI ƯU ĐA MỤC TIÊU TIẾT DIỆN HỆ CỌC CẦU TÀU CONTAINER 100.000 DWT: ĐỐI SÁNH THUẬT TOÁN MOFDA VÀ MOSFOA

MULTI-OBJECTIVE OPTIMIZATION OF PILE-SYSTEM CROSS-SECTIONS FOR A 100,000-DWT CONTAINER WHARF: A COMPARISON BETWEEN MOFDA AND MOSFOA

> **BẢN NHÁP GHÉP — 10/09/2026, cập nhật sau khi xác nhận bài JMST V5 (243 tổ hợp) KHÔNG còn đăng nữa — nội dung đã gộp hẳn vào bài này.** File này gộp toàn bộ các mục đã viết theo đúng khung [`DE_CUONG_BAI_BAO_MOFDA_MOSFOA_SO_SANH_THUAT_TOAN.md`](DE_CUONG_BAI_BAO_MOFDA_MOSFOA_SO_SANH_THUAT_TOAN.md). Mục 2-3 kế thừa cấu trúc soạn thảo từ bản nháp 243-tổ-hợp trước đó ([`BAI_BAO_MOFDA_CAU_TAU_100000DWT.md`](BAI_BAO_MOFDA_CAU_TAU_100000DWT.md), `JMST V5.docx` — **đã rút, không còn là bài báo riêng, KHÔNG trích dẫn**), cập nhật số liệu cho không gian 4.080 tổ hợp + ràng buộc địa kỹ thuật TCVN 10304:2025 + chống nhổ cọc. **Đây vẫn là bản nháp nội bộ — cần bạn rà soát trước khi coi là bản nộp.**

---

## Tóm tắt

Cầu tàu container trên nền cọc có khối lượng vật liệu cho phần cọc lớn; việc lựa chọn tiết diện cọc ở giai đoạn thiết kế sơ bộ có thể được hỗ trợ bằng tối ưu đa mục tiêu có ràng buộc thay vì chỉ dựa vào kinh nghiệm. Nghiên cứu xây dựng bài toán tối ưu đa mục tiêu cho tiết diện hệ cọc bê tông ly tâm dự ứng lực và cọc ống thép của một cầu tàu container 100.000 DWT thực tế, với không gian thiết kế rời rạc gồm 4.080 tổ hợp (5 dòng catalogue cọc BTCT × 51 giá trị đường kính × 16 giá trị chiều dày cọc thép), ràng buộc đầy đủ, gồm cả sức chịu tải địa kỹ thuật theo TCVN 10304:2025 và ràng buộc chống nhổ cọc. Hai hàm mục tiêu — khối lượng vật liệu và chuyển vị ngang lớn nhất — được đánh giá bằng mô hình phần tử hữu hạn SAP2000 kết nối MATLAB qua OAPI. Nghiên cứu đối sánh hai thuật toán tối ưu đa mục tiêu đã được công bố của cùng nhóm nghiên cứu — MOFDA (hướng dòng chảy, chọn thủ lĩnh lai) và MOSFOA (sao biển, bản thực nghiệm E-MOSFOA với điều khiển pha cosine, đột biến kiểu DE dẫn hướng thủ lĩnh và tinh chỉnh Gaussian giai đoạn cuối) — trên cùng một hệ thống đánh giá, cùng ngân sách đánh giá mô hình FEM (12.550 lần/lượt chạy), 30 lần chạy độc lập/thuật toán, đối chiếu với mặt Pareto tham chiếu thu được bằng vét cạn toàn bộ 4.080 tổ hợp (59 nghiệm không bị trội). Kết quả cho thấy MOSFOA đạt IGD thấp hơn MOFDA khoảng 5 lần (0,000100 so với 0,000506, kiểm định Wilcoxon rank-sum p<10⁻¹⁰) và hội tụ nhanh hơn đáng kể (bão hoà giá trị hypervolume chỉ sau ~1.000-1.500 lần đánh giá FEM, so với ~5.000-7.000 lần của MOFDA), trong khi cả hai thuật toán đều tìm được gần như toàn bộ mặt Pareto tham chiếu (MOSFOA: 100% ở tất cả 30 lần chạy; MOFDA: trung bình 99,77%). Kết quả cung cấp cơ sở định lượng để lựa chọn thuật toán tối ưu phù hợp cho bài toán thiết kế tiết diện hệ cọc công trình cảng biển có ràng buộc phức hợp.

**Từ khóa:** tối ưu đa mục tiêu, thuật toán MOFDA, thuật toán MOSFOA, tiết diện cọc, cầu tàu trên nền cọc, kết nối SAP2000-MATLAB.

## Abstract

*(để trống)*

---

## 1. Mở đầu

Cầu tàu container trên nền cọc là dạng kết cấu phổ biến trong các bến cảng biển trọng tải lớn tại Việt Nam. Hệ cọc — thường kết hợp cọc bê tông cốt thép dự ứng lực (BTCT DƯL) ly tâm và cọc ống thép — là cấu kiện chịu lực chính, đồng thời chiếm tỷ trọng lớn trong khối lượng vật liệu và chi phí xây dựng. Tối ưu đa mục tiêu có ràng buộc, kết hợp trực tiếp với mô hình phần tử hữu hạn (FEM), cho phép khảo sát hệ thống hoá sự đánh đổi giữa khối lượng vật liệu và độ cứng/chuyển vị của hệ cọc, thay vì chỉ kiểm tra lại một phương án chọn trước theo kinh nghiệm.

Hai thuật toán tối ưu đa mục tiêu dựa trên metaheuristic đã được nhóm nghiên cứu phát triển và công bố gần đây: MOFDA — thuật toán hướng dòng chảy đa mục tiêu với cơ chế chọn thủ lĩnh lai, đã được kiểm chứng trên 31 hàm chuẩn, 11 bài toán kỹ thuật có ràng buộc và ứng dụng cho một công trình khung thép thực tế [1]; và MOSFOA — thuật toán đa mục tiêu dựa trên hành vi tìm kiếm của sao biển (Starfish Optimization Algorithm), với hai biến thể B-MOSFOA và E-MOSFOA, đã được kiểm chứng trên các bộ benchmark IMOP/UF/RM-MEDA và ứng dụng cho một công trình cảng biển thực tế khác (cảng xăng dầu Hải Linh) [2]. Mỗi thuật toán đã được kiểm chứng trên một đối tượng công trình riêng, theo các điều kiện đánh giá không hoàn toàn giống nhau, nên chưa có cơ sở để so sánh trực tiếp hiệu năng của hai thuật toán trên cùng một bài toán kết cấu cụ thể.

Câu hỏi trọng tâm của nghiên cứu này là: *hai thuật toán MOFDA và MOSFOA, khi được thiết lập trên cùng một hệ thống đánh giá MATLAB–SAP2000, cùng hàm mục tiêu, cùng ràng buộc, cùng ngân sách đánh giá mô hình FEM, thể hiện khác biệt như thế nào về chất lượng và tốc độ hội tụ khi giải cùng một bài toán thiết kế tiết diện hệ cọc cầu tàu thực tế có ràng buộc kết cấu và địa kỹ thuật?* Nghiên cứu khảo sát cầu tàu container 100.000 DWT thuộc dự án cảng cửa ngõ quốc tế Hải Phòng (Lạch Huyện, Mục 2), với không gian thiết kế rời rạc gồm 4.080 tổ hợp (5 dòng catalogue cọc BTCT, miền đường kính/chiều dày cọc thép, Mục 3.1) và ràng buộc đầy đủ, gồm cả sức chịu tải địa kỹ thuật theo TCVN 10304:2025 và ràng buộc chống nhổ cọc (Mục 3.4).

Đóng góp của bài báo gồm: (i) hình thành bài toán tối ưu rời rạc cho tiết diện hệ cọc với ràng buộc đầy đủ, gồm cả sức chịu tải địa kỹ thuật và chống nhổ cọc; (ii) xây dựng mặt Pareto tham chiếu bằng vét cạn toàn bộ 4.080 tổ hợp làm chuẩn đối chiếu bên ngoài, không phụ thuộc vào kết quả tìm kiếm của bất kỳ thuật toán nào; (iii) đối sánh định lượng MOFDA và MOSFOA (bản thực nghiệm E-MOSFOA) trên cùng điều kiện đánh giá — 30 lần chạy độc lập/thuật toán, cùng ngân sách đánh giá FEM — bằng các chỉ số IGD, hypervolume, tỷ lệ tìm được nghiệm Pareto tham chiếu và kiểm định Wilcoxon rank-sum, cùng đường cong hội tụ theo số lần đánh giá FEM. Bài báo không tuyên bố thuật toán nào vượt trội tuyệt đối trước khi trình bày kết quả; kết luận về sự khác biệt (nếu có) được rút ra trực tiếp từ số liệu thực nghiệm ở Mục 6.

## 2. Đối tượng nghiên cứu và mô hình phần tử hữu hạn

### 2.1. Mô tả công trình

Đối tượng nghiên cứu là cầu tàu container 100.000 DWT thuộc dự án cảng cửa ngõ quốc tế Hải Phòng (Lạch Huyện), kết cấu bến liền bờ dạng bệ cọc cao đài mềm (MOFDA [1] và MOSFOA [2] tự thân đã được kiểm chứng trên hai công trình khác, xem Mục 1). Mô hình phân tích đại diện cho một phân đoạn tiêu chuẩn dài khoảng 75 m, rộng mặt cầu 50 m, cao trình đỉnh bến +5,50 m và đáy bến sau nạo vét −16,0 m (Hải đồ). Tàu thiết kế 100.000 DWT có chiều dài 330 m, chiều rộng 45,5 m, mớn nước đầy tải 14,8 m.

### 2.2. Hệ cọc

Hệ cọc của một phân đoạn gồm 132 cọc ống BTCT DƯL (bố trí thẳng đứng và xiên 6:1) và 60 cọc ống thép D1016 (xiên 6:1 và 7:1), tổng cộng 192 cọc. Tiết diện cọc được coi là biến thiết kế áp dụng đồng nhất cho toàn bộ cọc cùng loại; vị trí, độ xiên được giữ cố định trong tất cả các phương án khảo sát. Chiều dài ngàm cọc cũng được giữ cố định theo đúng cao độ mũi cọc của thiết kế gốc khi đường kính thay đổi (cọc BTCT L=29 m, mũi cọc tại cao độ −23,50 m; cọc thép L=30 m, mũi cọc tại cao độ −24,50 m) — giả thiết cần thiết để có thể áp dụng nhất quán ràng buộc địa kỹ thuật theo địa tầng thực (Mục 3.4) cho mọi phương án tiết diện.

### 2.3. Mô hình SAP2000

Mô hình FEM tuyến tính tĩnh được xây dựng trong SAP2000, gồm 4.913 nút, 1.734 phần tử thanh và 4.488 phần tử tấm vỏ, đơn vị làm việc Tonf–m–°C. Vật liệu gồm bê tông M400 (dầm/bản), M800 (cọc BTCT), thép cọc (Fy = 3.150 kG/cm²), cốt thép A615Gr60 và tao dự ứng lực A416Gr270. Điều kiện biên gồm 192 nút ngàm biên phân đoạn và các nút gán lò xo nền theo phương dọc trục cọc. Kết quả trích xuất chuyển vị và nội lực dùng tổ hợp bao (combo envelope) "BAO KT", đã gộp sẵn các tổ hợp tải cơ bản trong mô hình tính toán; tổ hợp bão riêng nằm ngoài phạm vi đường bao này và chưa được đưa vào đợt tính toán tối ưu — giới hạn được nêu ở Mục 6.5.

**Hình 1.** Mô hình SAP2000 của cầu tàu container 100.000 DWT *(bạn tự chèn ảnh)*

### 2.4. Địa tầng và điều kiện mũi cọc

Địa tầng tại mặt cắt cọc (đọc từ bản vẽ mặt cắt ngang thiết kế gốc, cao độ so với Hải đồ, chỉ tính từ đáy nạo vét −16,00 m trở xuống) gồm: Lớp 9 (sét xám xanh, dẻo chảy, chỉ số sệt IL=0,87) từ khoảng −17,20 đến −21,91 m; Lớp 10 (sét pha cứng/đá sét kết phong hoá hoàn toàn, IL=−0,13) từ −21,91 đến khoảng −23,91 m; Lớp 11 (đá phong hoá mạnh, nứt nẻ) bên dưới. Mũi cọc BTCT (cao độ −23,50 m) nằm trong Lớp 10; mũi cọc thép (cao độ −24,50 m) nằm trong Lớp 11. Cọc được coi là bịt kín mũi cho cả hai loại (diện tích tính toán là diện tích đặc). Nghiên cứu không xét hiệu ứng nhóm cọc — mỗi cọc được kiểm tra sức chịu tải đơn lẻ (giới hạn nêu ở Mục 6.5).

## 3. Bài toán tối ưu đa mục tiêu

### 3.1. Biến thiết kế

Bài toán được xây dựng dưới dạng tối ưu rời rạc với ba biến thiết kế:

x = [CatIdx_BTCT, D_thép, t_thép]  (1)

CatIdx_BTCT ∈ {1, 2, 3, 4, 5} là chỉ số dòng trong catalogue cọc bê tông ly tâm dự ứng lực (PHC) của nhà sản xuất AMACCAO, theo TCVN 7888:2014 và JIS A 5373:2016 [3], Class A (Bảng 1) — 5 dòng D600–D1000, phạm vi được xác định đủ rộng để hạn chế nghiệm Pareto dồn cục sát biên miền khảo sát (kiểm chứng ở Mục 6.1). D_thép ∈ [0,800; 1,300] m, bước 0,01 m (51 giá trị); t_thép ∈ [0,010; 0,025] m, bước 0,001 m (16 giá trị). Không gian tìm kiếm là tích của ba miền rời rạc: 5×51×16 = **4.080 tổ hợp**.

**Bảng 1.** Catalogue cọc bê tông ly tâm AMACCAO sử dụng (Class A, TCVN 7888:2014)

| CatIdx | D (m) | t (m) | A (m²) | Mcr (T.m) | Mu (T.m) | Pvl (T) |
|---|---:|---:|---:|---:|---:|---:|
| 1 | 0,600 | 0,100 | 0,15708 | 17,00 | 25,51 | 380 |
| 2 | 0,700 | 0,110 | 0,20389 | 26,00 | 39,00 | 500 |
| 3 | 0,800 | 0,120 | 0,25635 | 37,00 | 55,50 | 680 |
| 4 | 0,900 | 0,130 | 0,31447 | 48,95 | 73,42 | 880 |
| 5 | 1,000 | 0,130 | 0,35531 | 62,22 | 93,32 | 1.100 |

Nguồn: Catalogue cọc bê tông ly tâm AMACCAO PILE [3], quy đổi mô men kN.m sang T.m; hai dòng D600 và D1000 lấy trực tiếp từ cùng bảng catalogue gốc dùng cho D700–D900, cùng quy ước Class A, không suy đoán/nội suy.

### 3.2. Hàm mục tiêu

Hai hàm mục tiêu được xét đồng thời:

f₁ = A(D,t)_BTCT × ΣL_BTCT × γ_bt + A(D,t)_thép × ΣL_thép × γ_thép  (2)

f₂ = max(√(U₁² + U₂²))  (3)

trong đó f₁ là tổng **khối lượng vật liệu** cọc (tấn, γ_bt = 2,5 T/m³, γ_thép = 7,85 T/m³); f₂ là chuyển vị ngang lớn nhất của cầu tàu trên tổ hợp bao "BAO KT", không xét thành phần đứng. *(Thuật ngữ "khối lượng vật liệu" dùng thống nhất xuyên suốt bài, không dùng "khối lượng kết cấu" — xem quyết định chốt tại đề cương Mục D.)*

### 3.3. Ràng buộc kết cấu

Ba nhóm ràng buộc kết cấu được áp dụng: (i) tương tác lực dọc trục – mô men cọc BTCT theo công thức do nhà sản xuất khuyến nghị cho cọc ly tâm dự ứng lực [3], dùng trực tiếp Mu/Pvl của từng dòng catalogue (Bảng 1):

N/Pvl + M/Mu − 1 ≤ 0  (4)

(ii) ứng suất cọc thép σ = N/A + M/W ≤ Fy/γM, với Fy = 3.150 kG/cm² (TCVN 9245:2012 [6], tiêu chuẩn vật liệu) và γM = 1,05; và (iii) chuyển vị ngang U_max/U_allow − 1 ≤ 0, với U_allow = 71,7 mm theo TCVN 11820-5:2021 [4], Điều 8.9, Bảng 12 (1/300 chiều cao bến, H = 21,5 m).

### 3.4. Ràng buộc địa kỹ thuật

Nghiên cứu này triển khai đầy đủ sức chịu tải địa kỹ thuật theo **TCVN 10304:2025 [5]** (Điều 7.1, 7.2), dựa trên địa tầng thực tại mặt cắt cọc (Mục 2.4) và chỉ tiêu cơ lý gốc của dự án. Cọc BTCT (mũi trong Lớp 10, đất dính) dùng công thức cọc ma sát Rk = γc(γR,R·qb·A + u·ΣγR,f·fi·hi) (công thức (9), Điều 7.2.2.1), qb tra theo độ sâu và chỉ số sệt IL (Bảng 2), fi tra theo loại đất (Bảng 3). Cọc thép (mũi trong Lớp 11, đá phong hoá mạnh nứt nẻ) dùng công thức cọc chống tựa đá Rk = γc·qb·A (công thức (5)/(6), Điều 7.2.1.1), với qb xác định từ cường độ kháng nén một trục bão hoà nước Rc,n và hệ số giảm cường độ theo mức độ nứt nẻ Ks (Bảng 1 TCVN 10304:2025) — Ks = 0,32 (ứng với hạng mục "nứt nẻ mạnh", RQD 50–75%, lấy cận dưới do không có số liệu RQD thật, là giả thiết thận trọng). Điều kiện đủ khả năng chịu tải: γn·Nd ≤ Rk/γk (công thức (2), Điều 7.1.6.1), với γk = 1,4 (xác định bằng tính toán theo bảng tra) và γn = 1,15 (công trình cấp hậu quả C2, đã xác nhận với hồ sơ phân cấp).

**Ràng buộc chống nhổ cọc (uplift)** được bổ sung sau khi rà soát trước campaign chính thức phát hiện 18/360 cọc thép bị kéo (lực dọc tới xấp xỉ 31 T) dưới tổ hợp bao "BAO KT" — do code trước đó chỉ dùng trị tuyệt đối lực dọc, không phân biệt nén/kéo (cọc BTCT trong toàn bộ dự án luôn chịu nén, 792/792 trường hợp kiểm tra). Sức chịu tải kéo dùng công thức chỉ tính ma sát thân theo Điều 7.2.2.4, với hệ số γc = 0,8 (do chiều dài ngàm cọc ≥ 4 m); hệ số γk cho trường hợp kéo tra riêng theo Điều 7.1.6.1 (phụ thuộc số lượng cọc trong móng, không phải theo phương pháp xác định như trường hợp nén) — với 192 cọc/phân đoạn (≥ 21 cọc), γk = 1,4, trùng giá trị số với trường hợp nén nhưng khác cơ sở xác định.

Vi phạm mọi ràng buộc được chuẩn hóa và tổng hợp thành hàm phạt nhân đồng thời lên cả hai mục tiêu:

Fk(x) = fk(x) × [1 + C×P(x)], k = 1,2  (5)

với C = 10.

### 3.5. Mặt Pareto tham chiếu — vét cạn toàn bộ không gian tìm kiếm

Không gian thiết kế 4.080 tổ hợp được đánh giá trực tiếp qua cùng mô hình FEM để xây dựng mặt Pareto tham chiếu — đóng vai trò chuẩn đối chiếu bên ngoài, không phụ thuộc vào kết quả tìm kiếm của bất kỳ thuật toán nào (Mục 5.1) — cho phép đối chiếu mỗi thuật toán với chuẩn này, không chỉ đối chiếu hai thuật toán với nhau. Toàn bộ 4.080 tổ hợp được đánh giá thành công, xác định 3.337 tổ hợp khả thi (743 tổ hợp bị loại do vi phạm ràng buộc cứng) và **59 nghiệm không bị trội**, trình bày và thảo luận chi tiết ở Mục 6.1.

## 4. Hai thuật toán đối sánh

### 4.1. MOFDA

Thuật toán Hướng dòng chảy đa mục tiêu (Multi-Objective Flow Direction Algorithm – MOFDA) [1] là một mở rộng đa mục tiêu của Flow Direction Algorithm (FDA) đơn mục tiêu — thuật toán vật lý mô phỏng dòng chảy nước mưa (runoff) di chuyển về điểm thấp nhất của lưu vực theo địa hình, dùng nguyên lý D8 để xác định hướng lân cận. Mỗi cá thể (dòng chảy) $X(i)$ sinh $\beta$ vị trí lân cận quanh nó; vị trí mới được cập nhật theo độ dốc cục bộ giữa cá thể và lân cận tốt nhất (leader), kết hợp trọng số suy giảm phi tuyến theo tiến độ vòng lặp để cân bằng thăm dò/khai thác.

MOFDA bổ sung vào khung FDA gốc hai cơ chế cho bài toán đa mục tiêu: (i) một **kho lưu trữ ngoài** (external archive) lưu các nghiệm không bị trội, với cơ chế kiểm soát vượt dung lượng dựa trên lưới thích nghi (adaptive grid) chia không gian mục tiêu thành các siêu lập phương (hypercube); (ii) một **chiến lược chọn thủ lĩnh lai** (hybrid leader selection) — đóng góp mới của [1] so với phiên bản MOFDA nguyên bản dùng roulette-wheel selection cổ điển. Chiến lược lai chấm điểm mỗi cá thể trong kho lưu trữ theo

$$s_i = GI_i + \frac{\varepsilon_i}{1+DE_i}$$

trong đó $GI_i$ là chỉ số ô lưới, $DE_i$ là mật độ cục bộ (số cá thể cùng chia sẻ ô lưới), $\varepsilon_i\in[0,1]$ là nhiễu ngẫu nhiên nhỏ duy trì đa dạng; thủ lĩnh được chọn là cá thể có điểm số thấp nhất, ưu tiên vùng thưa nghiệm nhưng có kiểm soát mức ngẫu nhiên nhằm giảm nguy cơ hội tụ sớm so với roulette-wheel selection thuần túy. Ràng buộc được xử lý bằng hàm phạt nhân (tương tự cách tiếp cận của nghiên cứu này, xem Mục 3.3).

MOFDA đã được kiểm chứng trên 31 hàm chuẩn (ZDT, DTLZ, MMF, UF) và 11 bài toán kỹ thuật có ràng buộc (giàn 10–942 thanh, dầm hàn, SRN, OSY), cho kết quả cạnh tranh hoặc vượt trội so với MOMVO, MOMSA, MSSA, MOGNDO trên phần lớn chỉ số IGD/GD/STE — nổi bật nhất là đạt Best-IGD tuyệt đối trên toàn bộ 12 bài toán MMF (CEC2020). MOFDA cũng đã được áp dụng cho một công trình thực tế — tối ưu khung thép nhà chờ bến phà Đồng Bài, đảo Cát Hải, Hải Phòng, kết nối MATLAB–SAP2000 qua SM Toolbox, giảm tới 71,4% chuyển vị hoặc 26,7% khối lượng tùy kịch bản đánh đổi được chọn trên mặt Pareto.

**Tham số MOFDA dùng trong nghiên cứu này**: quần thể $N_p=50$, $\beta=4$ hướng lân cận/cá thể, dung lượng kho lưu trữ $N_r=100$, số ô lưới $nGrid=10$, $maxiter=50$ vòng lặp — tổng ngân sách đánh giá FEM $FE=N_p[1+maxiter(\beta+1)]=12.550$.

### 4.2. MOSFOA (bản chạy: E-MOSFOA)

MOSFOA là biến thể đa mục tiêu của Starfish Optimization Algorithm (SFOA) [7] — thuật toán đơn mục tiêu mô phỏng hành vi tìm kiếm của sao biển, gồm cơ chế "arm-twist" (xoay cánh, thăm dò đa chiều), "energy-step" (bước năng lượng, thăm dò chiều thấp) và "preying" (bắt mồi, khai thác dựa trên 5 cá thể lân cận và thủ lĩnh). Nghiên cứu gốc [2] phát triển hai phiên bản đa mục tiêu: **B-MOSFOA** (Base) giữ nguyên các phương trình di chuyển gốc của SFOA, bổ sung kho lưu trữ Pareto ngoài, kiểm soát đa dạng dựa trên lưới thích nghi và chọn thủ lĩnh theo xác suất nghịch mật độ ô lưới $P_i=c/N_i$; và **E-MOSFOA** (Enhanced) — phiên bản dùng để chạy thực nghiệm trong nghiên cứu này — xây trên nền B-MOSFOA, bổ sung ba cơ chế:

1. **Điều khiển pha theo cosine** (cosine-phase control): thay xác suất thăm dò cố định $GP_0$ của SFOA gốc bằng lịch trình giảm mượt

$$GP = \frac{GP_0}{2}\left(1+\cos\left(\pi\cdot\frac{it}{Max\_it}\right)\right)$$

giúp chuyển đổi thăm dò→khai thác diễn ra liên tục thay vì đột ngột.

2. **Đột biến kiểu DE dẫn hướng bởi thủ lĩnh** (leader-guided DE-mutation) kết hợp lai ghép nhị thức (binomial crossover), kích hoạt trong pha thăm dò:

$$mutant_i = X_{r1} + F\cdot(X_{r2}-X_{r3}) + \lambda\cdot(X_{leader}-X_{r1}), \quad F=0{,}5\left(1-\frac{it}{Max\_it}\right)$$

với hệ số hút về thủ lĩnh $\lambda=0{,}3$, xác suất lai ghép $CR=0{,}5$ — hệ số khuếch đại đột biến $F$ giảm tuyến tính theo tiến độ vòng lặp (bước "energy-step" thích nghi).

3. **Tinh chỉnh Gaussian giai đoạn cuối dựa trên kho lưu trữ** (archive-based Gaussian refinement), chỉ kích hoạt trong 20% vòng lặp cuối ($it \ge 0{,}8\,Max\_it$): chọn cá thể tham chiếu $X^*=\arg\min\sum_j f_{i,j}$ trong kho lưu trữ rồi tái sinh một phần quần thể quanh $X^*$ bằng nhiễu Gauss, trong khi quy tắc trội Pareto vẫn quyết định nghiệm nào được giữ lại.

Trên các bộ benchmark IMOP/UF/RM-MEDA (30 lần chạy độc lập/bài toán, kiểm định Wilcoxon rank-sum hai phía hiệu chỉnh Holm), E-MOSFOA đạt hạng trung bình tổng thể tốt thứ 2 (2,58, sau MOMSA 2,52, trước B-MOSFOA 2,75) với chi phí đánh giá hàm thấp nhất trong nhóm so sánh (50.100 FE so với MOMSA 60.100, MOGNDO 100.100, NS-MFO 150.100). Trên công trình thực tế — cảng xăng dầu Hải Linh, Hải Phòng (bến cập tàu, bến neo, cầu tàu chính) — nghiệm Pareto chi phí thấp nhất giảm tới 81,5% chi phí và 42,4% chuyển vị so với hiện trạng ở bến neo, toàn bộ 6 kho lưu trữ cuối cùng đều khả thi 100%.

**Tham số E-MOSFOA dùng trong nghiên cứu này**: quần thể $N_p=50$, dung lượng kho lưu trữ $N_r=100$, số ô lưới $nGrid=10$, $GP_0=0{,}5$, $\lambda=0{,}3$, $CR=0{,}5$, $Max\_it=250$ vòng lặp — tổng ngân sách đánh giá FEM $FE=N_p(Max\_it+1)=12.550$, khớp chính xác với ngân sách MOFDA (Mục 4.1) do $Max\_it=5\times maxiter$.

### 4.3. Ngân sách đánh giá công bằng

Xem Bảng mục B của đề cương — hai thuật toán được thiết lập trên cùng hệ thống đánh giá MATLAB–SAP2000 (hàm mục tiêu, ràng buộc, cơ chế lưu trữ Pareto archive/grid, rời rạc hoá biến thiết kế), cùng $N_r=100$, cùng $nGrid=10$, cùng ngân sách $FE=12.550$/lần chạy, cùng $N=30$ lần chạy độc lập/thuật toán.

> **Ghi chú nội bộ (KHÔNG đưa vào bài)**: cả hai bài gốc [1] và [2] đều có case study kỹ thuật RIÊNG, KHÁC với cầu tàu container 100.000 DWT Lạch Huyện của bài này — [1] dùng khung thép nhà chờ bến phà Đồng Bài, [2] dùng cảng xăng dầu Hải Linh. Chỉ trích dẫn làm nguồn thuật toán gốc, không phải nguồn số liệu công trình cho bài này.

## 5. Phương pháp đối sánh

### 5.1. Mặt Pareto tham chiếu

Mặt Pareto thu được bằng vét cạn toàn bộ 4.080 tổ hợp (Mục 3.5) đóng vai trò **chuẩn đối chiếu độc lập** cho cả hai thuật toán — điểm mạnh trung tâm của phép đối sánh: cả MOFDA và MOSFOA đều được đối chiếu với cùng một mặt Pareto thật, thay vì chỉ so sánh trực tiếp hai tập kết quả với nhau.

### 5.2. Quy trình thực nghiệm

Mỗi thuật toán được chạy 30 lần độc lập (N=30, theo quy ước phổ biến của các bài báo đối sánh thuật toán tối ưu đa mục tiêu, giúp phân phối trung bình mẫu tiệm cận chuẩn và kiểm định Wilcoxon đáng tin cậy), cùng ngân sách đánh giá mô hình FEM FE = 12.550/lần chạy (MOFDA: Np=50, β=4, maxiter=50; MOSFOA/E-MOSFOA: Np=50, Max_it=250 — khớp chính xác vì Max_it = 5×maxiter, xem Mục 4.3), trên cùng hệ thống đánh giá MATLAB–SAP2000 (cùng hàm mục tiêu, cùng ràng buộc, cùng cơ chế lưu trữ nghiệm Pareto archive/grid, cùng cách rời rạc hoá biến thiết kế).

### 5.3. Bộ chỉ số đối sánh

Bộ chỉ số ưu tiên trong bài chính: **IGD** (inverted generational distance, chuẩn hoá theo min-max của mặt Pareto tham chiếu để tránh so sánh trực tiếp hai mục tiêu có thang đo khác nhau — khối lượng ~10³ tấn so với chuyển vị ~10⁻² m), **HV** (hypervolume, dùng điểm tham chiếu cố định chung cho mọi lần chạy và cả hai thuật toán — xem Mục 6, ghi chú kỹ thuật), **tỷ lệ tìm được nghiệm Pareto tham chiếu** theo tiêu chí so khớp chính xác trên fitness, ngưỡng 10⁻⁶ chống sai số dấu phẩy động (cố định trước khi chạy, không điều chỉnh theo kết quả quan sát được — xem đề cương Mục B.1), và **kiểm định Wilcoxon rank-sum** (α=0,05) để xác định ý nghĩa thống kê của khác biệt quan sát được. GD (generational distance) được giữ lại ở Mục 6 vì bổ sung thông tin không trùng lặp hoàn toàn với IGD trong trường hợp này (xem Mục 6.4.1).

## 6. Kết quả và thảo luận

### 6.1. Mặt Pareto tham chiếu

Vét cạn toàn bộ 4.080 tổ hợp thiết kế (bảng $q_b$ TCVN 10304:2025 đã sửa lỗi, đã bổ sung ràng buộc chống nhổ cọc — Mục 3.4) xác định được **3.337/4.080 tổ hợp khả thi** (743 tổ hợp bị loại do vi phạm hình học/ràng buộc cứng), trong đó **59 nghiệm không bị trội** tạo thành mặt Pareto tham chiếu chính thức. Khối lượng vật liệu dao động **3.317,3–5.189,4 tấn**, chuyển vị ngang lớn nhất dao động **9,83–16,27 mm** — đều thấp hơn nhiều giới hạn cho phép theo TCVN 11820-5:2021.

**Kiểm chứng hiện tượng "dồn biên" (boundary clustering)** — được nêu là giả thuyết cần kiểm chứng lại (Mục 3.1), kiểm tra trực tiếp trên dữ liệu chính thức, không giả định trước:

**Bảng 2.** Kiểm chứng hiện tượng dồn biên trên 59 nghiệm Pareto tham chiếu chính thức

| Biến thiết kế | Miền khảo sát | Số nghiệm tại đúng cận trên | Số nghiệm trong 5% dải sát cận trên | Số nghiệm tại/gần cận dưới |
|---|---|---:|---:|---:|
| CatIdx_BTCT (1=D600...5=D1000) | [1, 5] | 18/59 (30,5%) | 18/59 (30,5%) | 0 |
| D_thép (m) | [0,800; 1,300] | 17/59 (28,8%) | 41/59 (69,5%) | 0 |
| t_thép (m) | [0,010; 0,025] | 2/59 (3,4%) | 2/59 (3,4%) | 0 |

Số liệu chính thức **xác nhận hiện tượng dồn biên đối với đường kính cọc thép (D_thép)**: gần 70% nghiệm Pareto nằm trong 5% dải sát cận trên của miền khảo sát (1,275–1,300 m), và không có nghiệm nào gần cận dưới. Dồn biên tương tự nhưng yếu hơn quan sát được ở CatIdx_BTCT (30,5% tại cận trên, tức dòng D1000). Ngược lại, chiều dày cọc thép (t_thép) phân bố trải đều trong miền khảo sát, không thể hiện dồn biên rõ rệt. Đáng chú ý, miền khảo sát của D_thép và CatIdx_BTCT (Mục 3.1) đã được xác định đủ rộng nhằm hạn chế đúng hiện tượng này, nhưng dồn biên vẫn xuất hiện — cho thấy cận trên hiện tại của D_thép nhiều khả năng vẫn chưa đủ rộng để bao trọn vùng đánh đổi tối ưu giữa khối lượng và chuyển vị; thảo luận thêm ở Mục 6.5.

**Hình 2.** Mặt Pareto tham chiếu 59 nghiệm, trên nền các tổ hợp khả thi không bị phạt (`Wharf100DWT/results/analysis/reference_pareto_front.png`)

### 6.2–6.3. Kết quả từng thuật toán (30 lần chạy độc lập, Np=50, FE=12.550/lần)

**Bảng 3.** Thống kê 30 lần chạy độc lập của MOFDA và MOSFOA (E-MOSFOA)

| Chỉ số | MOFDA (Np=50, maxiter=50) | MOSFOA — E-MOSFOA (Np=50, Max_it=250) |
|---|---:|---:|
| GD (chuẩn hoá) | 0,000031 ± 0,000081 | 0,000000 ± 0,000000 |
| IGD (chuẩn hoá) | 0,000506 ± 0,000182 | 0,000100 ± 0,000074 |
| HV (W cố định = [70.340,29 tấn; 0,631374 m]) | 41.654,0150 ± 0,0064 | 41.654,0214 ± 0,0002 |
| Kích thước kho lưu trữ (repository) | 100,0 ± 0,0 | 100,0 ± 0,0 |
| Số nghiệm khớp chính xác mặt Pareto tham chiếu (/100 nghiệm repository) | 99,77 ± 0,63 | 100,00 ± 0,00 |

Cả hai thuật toán đều đạt kho lưu trữ đầy (100 nghiệm/lần chạy) và tìm được gần như toàn bộ mặt Pareto tham chiếu ở mọi lần chạy độc lập. **MOSFOA (E-MOSFOA) tìm được đúng 100% (59/59) nghiệm Pareto tham chiếu ở cả 30/30 lần chạy, không có độ lệch (std=0)** — kết quả hoàn toàn ổn định. MOFDA đạt trung bình 99,77/100 nghiệm khớp chính xác (tức trung bình còn sót lại chưa đến 1 nghiệm/lần chạy, độ lệch chuẩn 0,63), cho thấy độ ổn định thấp hơn một chút nhưng vẫn ở mức rất cao.

### 6.4. Đối sánh trực tiếp MOFDA và MOSFOA

#### 6.4.1. Kiểm định Wilcoxon rank-sum (30 vs 30, α = 0,05)

**Bảng 4.** Kiểm định Wilcoxon rank-sum MOFDA và MOSFOA

| Chỉ số | MOFDA (TB±ĐLC) | MOSFOA (TB±ĐLC) | p-value | Kết luận |
|---|---:|---:|---:|---|
| GD | 0,000031 ± 0,000081 | 0,000000 ± 0,000000 | 0,0419 | Khác biệt có ý nghĩa thống kê |
| IGD | 0,000506 ± 0,000182 | 0,000100 ± 0,000074 | 1,07×10⁻¹⁰ | Khác biệt có ý nghĩa thống kê (rất mạnh) |
| HV | 41.654,0150 ± 0,0064 | 41.654,0214 ± 0,0002 | 6,53×10⁻¹¹ | Khác biệt có ý nghĩa thống kê (rất mạnh) |
| Số nghiệm khớp chính xác | 99,77 ± 0,63 | 100,00 ± 0,00 | 0,0419 | Khác biệt có ý nghĩa thống kê |

Trong bài toán cầu tàu container 100.000 DWT được nghiên cứu, **MOSFOA đạt IGD trung bình thấp hơn MOFDA khoảng 5 lần** (0,000100 so với 0,000506) **và HV trung bình cao hơn** (dù chênh lệch tuyệt đối nhỏ do cả hai đều gần bão hoà), **trong khi** tỷ lệ khớp chính xác mặt Pareto tham chiếu đạt tuyệt đối 100% ở MOSFOA so với 99,77% ở MOFDA; theo cả 4 chỉ số, khác biệt đều có ý nghĩa thống kê (α=0,05). Khác biệt về IGD và HV có ý nghĩa thống kê rất mạnh (p < 10⁻¹⁰); khác biệt về GD và số nghiệm khớp chính xác có ý nghĩa ở mức α = 0,05 (p ≈ 0,042) nhưng yếu hơn — phù hợp vì cả hai chỉ số này gần đạt trần lý thuyết (GD→0, khớp→100%) ở cả hai thuật toán nên dư địa khác biệt bị thu hẹp. Đây cũng là lý do GD được giữ lại thay vì loại bỏ (Mục 5.3): dù tương quan chặt với IGD, GD vẫn cho thấy MOSFOA đạt giá trị 0 tuyệt đối (std=0) mà IGD chuẩn hoá không thể hiện rõ bằng.

#### 6.4.2. Tốc độ hội tụ theo số lần đánh giá FEM (FE)

Đường cong IGD/HV trung bình theo FE (30 lần chạy/thuật toán, dải ±1 độ lệch chuẩn) được dựng từ `History.ArchiveFitness` lưu mỗi vòng lặp, dùng cùng điểm tham chiếu HV cố định cho cả hai thuật toán để bảo đảm so sánh được trực tiếp (Hình 3).

**Hình 3.** Đường cong hội tụ IGD/HV theo số lần đánh giá FEM (`Wharf100DWT/results/analysis/convergence_IGD_HV_vs_FE.png`)

- **MOSFOA hội tụ nhanh hơn rõ rệt**: đạt vùng bão hoà HV (~41.654) chỉ sau khoảng FE ≈ 1.000–1.500 (tương đương 20–30 vòng lặp đầu trong tổng 250 vòng), trong khi MOFDA cần khoảng FE ≈ 5.000–7.000 (tương đương 20–28 vòng lặp trong tổng 50 vòng) mới đạt mức bão hoà tương đương.
- Đường IGD trung bình của MOSFOA nằm dưới đường của MOFDA trong suốt quá trình tìm kiếm, nhất quán với kết quả tổng hợp ở Mục 6.4.1.
- Cả hai thuật toán đều hội tụ về cùng một vùng nghiệm (HV cuối cùng chênh lệch không đáng kể về mặt tuyệt đối), nhưng **MOSFOA đạt được điều đó với ngân sách đánh giá FEM nhỏ hơn nhiều** trong giai đoạn đầu tìm kiếm — đây là khác biệt thực chất nhất giữa hai thuật toán trên bài toán này, hơn là chênh lệch ở kết quả cuối cùng (vốn đã gần bão hoà ở cả hai).

#### 6.4.3. Nhận xét cơ chế

Ưu thế hội tụ nhanh của MOSFOA phù hợp với đặc điểm cơ chế điều khiển pha cosine (Mục 4.2, Eq. 8) của E-MOSFOA — chuyển pha thăm dò→khai thác được điều khiển tường minh và mượt theo hàm cosine ngay từ đầu quá trình tìm kiếm, khác với trọng số suy giảm phi tuyến $(1-iter/Max_{iter})^{2\cdot randn}$ của MOFDA (Mục 4.1) vốn phụ thuộc nhiều vào thành phần ngẫu nhiên $randn$ ở mỗi vòng lặp. Đột biến kiểu DE dẫn hướng thủ lĩnh (Eq. 9-11) và tinh chỉnh Gaussian giai đoạn cuối (Eq. 12-13) của E-MOSFOA cũng có thể góp phần giúp thuật toán bám sát nhanh mặt Pareto một khi đã xác định được vùng lân cận tốt. Đây là nhận xét định hướng dựa trên đối chiếu cơ chế đã mô tả ở Mục 4 với số liệu thực nghiệm quan sát được — không phải một phân tích độ nhạy tham số tách biệt cho từng cơ chế, nên cần diễn đạt thận trọng (không khẳng định cơ chế nào là nguyên nhân duy nhất).

### 6.5. Giới hạn nghiên cứu

- Hiện tượng dồn biên xác nhận ở Mục 6.1 (D_thép, và ở mức độ thấp hơn là CatIdx_BTCT) cho thấy cận trên hiện tại của D_thép có thể vẫn chưa đủ rộng để mặt Pareto tham chiếu phản ánh đầy đủ vùng đánh đổi tối ưu lý thuyết. Kết quả đối sánh thuật toán (Mục 6.4) vẫn có giá trị vì cả hai thuật toán được đánh giá trên cùng mặt Pareto tham chiếu và cùng miền khảo sát, nhưng phạm vi khái quát hoá kết quả tuyệt đối (giá trị khối lượng/chuyển vị cụ thể) cần thận trọng.
- Ràng buộc địa kỹ thuật còn một giả thiết chưa được xác nhận đầy đủ bằng số liệu khảo sát thật: hệ số giảm cường độ theo nứt nẻ Ks = 0,32 cho Lớp 11 (giả thiết do thiếu số liệu RQD thật). Hệ số cấp hậu quả công trình γn = 1,15 (cấp C2) đã được xác nhận với hồ sơ phân cấp, không còn là giả thiết mở.
- Không xét hiệu ứng nhóm cọc — mỗi cọc được kiểm tra sức chịu tải địa kỹ thuật đơn lẻ.
- Tổ hợp bão riêng nằm ngoài phạm vi tổ hợp bao "BAO KT" được dùng trong đợt tính toán tối ưu.
- Mô hình chỉ xét phân tích tuyến tính tĩnh, chưa xét tương tác đất–cọc chi tiết kiểu p–y.

## 7. Kết luận

Bài báo đã đối sánh hai thuật toán tối ưu đa mục tiêu MOFDA [1] và MOSFOA (bản thực nghiệm E-MOSFOA) [2] — cả hai đã được công bố và kiểm chứng độc lập trên các công trình khác nhau — trên cùng một bài toán thiết kế tiết diện hệ cọc cầu tàu container 100.000 DWT thực tế, dưới cùng điều kiện đánh giá MATLAB–SAP2000. Các kết luận chính gồm:

(1) Đã hình thành bài toán tối ưu rời rạc cho tiết diện hệ cọc với không gian thiết kế gồm 4.080 tổ hợp và ràng buộc đầy đủ, gồm cả sức chịu tải địa kỹ thuật theo TCVN 10304:2025 và ràng buộc chống nhổ cọc.

(2) Vét cạn toàn bộ 4.080 tổ hợp xác định mặt Pareto tham chiếu chính thức gồm 59 nghiệm, dùng làm chuẩn đối chiếu bên ngoài — không phụ thuộc kết quả tìm kiếm của thuật toán nào — cho cả hai thuật toán. Số liệu chính thức xác nhận hiện tượng dồn biên (boundary clustering) đối với đường kính cọc thép — gần 70% nghiệm Pareto nằm sát cận trên miền khảo sát dù miền này đã được xác định đủ rộng nhằm hạn chế hiện tượng này; đây là một giới hạn cần lưu ý khi khái quát hoá kết quả tuyệt đối.

(3) Trong bài toán cầu tàu container 100.000 DWT được nghiên cứu, **MOSFOA đạt IGD thấp hơn MOFDA khoảng 5 lần** (0,000100 so với 0,000506; kiểm định Wilcoxon rank-sum p<10⁻¹⁰) và **hội tụ nhanh hơn đáng kể** (bão hoà hypervolume sau ~1.000-1.500 lần đánh giá FEM, so với ~5.000-7.000 lần của MOFDA); khác biệt này có ý nghĩa thống kê rõ rệt. Cả hai thuật toán đều tìm được gần như toàn bộ mặt Pareto tham chiếu với ngân sách đánh giá đã dùng (MOSFOA: 100% ở tất cả 30 lần chạy; MOFDA: trung bình 99,77%), cho thấy khác biệt thực chất nhất giữa hai thuật toán trên bài toán này là **tốc độ hội tụ**, không phải chất lượng nghiệm cuối cùng.

(4) Kết quả cung cấp cơ sở định lượng để lựa chọn thuật toán tối ưu phù hợp — với ngân sách đánh giá FEM hạn chế (chi phí tính toán SAP2000 lặp lại là yếu tố chi phối thời gian thực nghiệm), MOSFOA thể hiện ưu thế rõ rệt hơn nhờ tốc độ hội tụ; khi ngân sách đánh giá đủ lớn, cả hai thuật toán đều đạt chất lượng nghiệm tương đương trên bài toán kết cấu cọc cầu tàu cụ thể này.

Trước khi áp dụng kết quả tối ưu (khối lượng/chuyển vị cụ thể của các nghiệm Pareto) cho thiết kế chính thức, cần lưu ý các giới hạn nêu ở Mục 6.5, đặc biệt là hiện tượng dồn biên chưa được giải quyết triệt để, giả thiết Ks = 0,32 cho Lớp 11 (thiếu số liệu RQD thật) cần xác nhận lại với số liệu đầy đủ hơn, và giới hạn về hiệu ứng nhóm cọc chưa được xét.

## Lời cảm ơn

*(nếu có)*

## TÀI LIỆU THAM KHẢO

[1] Vu-Huu, T., S. Khatir, and T. Cuong-Le, *Real-World Steel Frame Optimization Using a Hybrid Leader Selection-Based Multi-Objective Flow Direction Algorithm.* International Journal for Numerical Methods in Engineering, 2025. **126**(15): p. e70098. https://doi.org/10.1002/nme.70098

[2] Do-Quang, T., T. Vu-Huu, and T. Cuong-Le, *Multi-objective Optimization Design of Marine Structures Based on An Enhanced Starfish Algorithm.* xxxxx.

[3] AMACCAO PILE (2014), *Catalogue và thông số kỹ thuật cọc bê tông ly tâm AMACCAO D300-D1200*, theo TCVN 7888:2014 và JIS A 5373:2016.

[4] Bộ Khoa học và Công nghệ (2021), *TCVN 11820-5:2021 — Công trình cảng biển – Yêu cầu thiết kế – Phần 5: Công trình bến*.

[5] Viện Tiêu chuẩn Chất lượng Việt Nam (2025), *TCVN 10304:2025 (Xuất bản lần 2) — Thiết kế móng cọc*.

[6] Bộ Khoa học và Công nghệ, *TCVN 9245:2012 — Cọc ống thép*.

[7] Zhong, C., et al., *Starfish optimization algorithm (SFOA): a bio-inspired metaheuristic algorithm for global optimization compared with 100 optimizers.* Neural Computing and Applications, 2025(5): p. 3641-3683.

---

Ngày nhận bài: xx/xx/2026
Ngày nhận bản sửa: xx/xx/2026
Ngày duyệt đăng: xx/xx/2026

---

## Ghi chú nội bộ — việc còn lại trước khi coi là bản nộp

1. ~~Ghép Mục 4 và Mục 6 vào file chính~~ — **XONG**.
2. ~~Dịch Abstract~~ — **CHỐT: để trống**, không dịch ở giai đoạn này.
3. ~~DOI/tên tạp chí bài MOSFOA gốc [2]~~ — **CHỐT: để placeholder `xxxxx`**, bài đang chờ sản xuất — bạn tự thay khi có DOI thật, không cần tôi làm gì thêm.
4. ~~Quyết định trích dẫn Khodadadi et al. (MOFDA gốc trước cải tiến)~~ — **CHỐT: KHÔNG thêm**.
5. ~~Vẽ Hình 2 (mặt Pareto tham chiếu 59 nghiệm)~~ — **XONG**: `Wharf100DWT/results/analysis/reference_pareto_front.png`. Hình 1 (mô hình SAP2000) — **bạn tự chèn**.
6. ~~Rà soát overclaim~~ — **XONG**: đã sửa các chỗ dùng "độc lập" thiếu ngữ cảnh, và câu "MOSFOA vượt trội MOFDA có ý nghĩa thống kê" ở Mục 6.4.1 (đúng khuôn mẫu đề cương Mục D.7 cảnh báo tránh dùng).
7. ~~Xác nhận cấp hậu quả công trình~~ — **XÁC NHẬN ĐÚNG**: γn=1,15 (cấp C2), đã bỏ nhãn "giả thiết"; chỉ còn Ks=0,32 (Lớp 11) là giả thiết mở.
8. ~~Bài JMST V5 (243 tổ hợp) đã rút, không đăng nữa~~ — **XỬ LÝ XONG 10/09/2026**: đã bỏ hẳn trích dẫn tự thân [3] (không còn là bài báo riêng để cite) và viết lại TOÀN BỘ các đoạn từng khung "so với nghiên cứu trước" (Mục 1, 2.1-2.3, 3.1-3.5, 6.1, 6.5, 7) thành trình bày trực tiếp nội dung của chính bài này, không còn ngụ ý có một bài báo khác đã công bố đứng sau. Danh mục tài liệu tham khảo đã đánh số lại: [1]=MOFDA, [2]=MOSFOA, [3]=AMACCAO, [4]=TCVN 11820-5:2021, [5]=TCVN 10304:2025, [6]=TCVN 9245:2012, [7]=SFOA gốc.
9. **Kiểm tra lại đánh số Bảng/Hình xuyên suốt bài** sau khi chèn ảnh thật (Bảng 1=catalogue BTCT §3.1, Bảng 2=dồn biên §6.1, Bảng 3=thống kê từng thuật toán §6.2-6.3, Bảng 4=Wilcoxon §6.4.1; Hình 1=SAP2000 §2.3, Hình 2=Pareto tham chiếu §6.1, Hình 3=hội tụ §6.4.2).
