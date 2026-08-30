# REVIEWER REPORT — PAPER 1

## Ứng dụng thuật toán tối ưu sao biển cho tối ưu đơn mục tiêu kết cấu công trình biển

**Vai trò phản biện:** Phản biện khoa học theo hướng xây dựng  
**Bối cảnh đánh giá:** NCS mới tiếp cận lĩnh vực tối ưu đơn mục tiêu (SOO), bài báo tiếng Việt, định hướng tạp chí chuyên ngành Xây dựng trong nước.  
**Nguồn đánh giá:** Bản thảo 7 trang được cung cấp trong phiên làm việc.

---

# 1. Kết luận phản biện tổng quát

### Khuyến nghị: MAJOR REVISION — Sửa chữa lớn

Bản thảo có một hướng nghiên cứu hợp lý, câu hỏi nghiên cứu tương đối rõ và có giá trị ứng dụng đối với lĩnh vực kết cấu công trình biển. Nghiên cứu sử dụng SFOA nguyên bản để giải hai bài toán tối ưu đơn mục tiêu trên hệ Main Jetty Platform (MJP): tối thiểu chi phí và tối thiểu chuyển vị lớn nhất. Sau đó, tác giả so sánh hai nghiệm cực trị để định lượng sự đánh đổi giữa chi phí và độ cứng, từ đó tạo cơ sở cho bước phát triển tiếp theo sang tối ưu đa mục tiêu/MOSFOA.

Điểm mạnh của bản thảo là không cố gắng tuyên bố SFOA là thuật toán vượt trội so với các metaheuristic khác. Thay vào đó, nghiên cứu tập trung vào khả năng áp dụng SFOA nguyên bản trong một bài toán kết cấu thực tế có mô hình FEM và biến thiết kế rời rạc. Đây là phạm vi phù hợp với một nghiên cứu nền tảng/SOO đầu tiên.

Tuy nhiên, trước khi công bố, bản thảo cần được củng cố ở một số điểm cốt lõi:

1. Làm rõ và minh bạch hệ ràng buộc kỹ thuật.
2. Kiểm chứng kỹ kết quả chuyển vị tối ưu rất nhỏ 0,0388 mm.
3. Kiểm tra bản chất của kết quả CV = 0% trong 30 lần chạy đối với bài toán MJP-Displacement.
4. Làm rõ hàm chi phí và phạm vi ý nghĩa của từ "chi phí xây dựng".
5. Tiết chế một số phát biểu có thể vượt quá phạm vi bằng chứng.
6. Tăng khả năng tái lập mô hình mà không phụ thuộc quá nhiều vào tài liệu [2].
7. Làm rõ vai trò của nghiên cứu: đây là nghiên cứu SOO ứng dụng và xây dựng baseline cho MOSFOA, không phải nghiên cứu phát triển một thuật toán metaheuristic mới.

Nhìn chung, tôi đánh giá bản thảo **có khả năng phát triển thành một bài báo phù hợp với tạp chí chuyên ngành Xây dựng trong nước sau khi sửa chữa**, và không đề nghị thay đổi hướng nghiên cứu chính.

---

# 2. Đánh giá theo các tiêu chí chính

| Tiêu chí | Đánh giá |
|---|---:|
| Sự phù hợp với lĩnh vực xây dựng/kết cấu | 9/10 |
| Ý nghĩa thực tiễn | 8/10 |
| Câu hỏi nghiên cứu | 8/10 |
| Logic nghiên cứu | 8,5/10 |
| Mô hình tính toán | 7,5/10 |
| Thiết lập SOO | 7,5/10 |
| Thiết kế thực nghiệm | 7/10 |
| Phân tích kết quả | 7,5/10 |
| Tính tái lập | 6/10 |
| Mức độ mới ở phạm vi bài báo ứng dụng | 7/10 |
| Văn phong và cấu trúc | 7,5/10 |
| Đánh giá tổng thể | ~7,5/10 |

---

# 3. Nhận xét tích cực

## 3.1. Câu chuyện nghiên cứu tương đối rõ

Bài có một chuỗi lập luận dễ theo dõi:

```text
Bài toán thiết kế MJP
        ↓
Hai tiêu chí quan trọng:
Cost và Displacement
        ↓
Giải độc lập hai bài toán SOO
        ↓
Cost-optimal và Displacement-optimal
        ↓
So sánh hai nghiệm cực trị
        ↓
Định lượng trade-off
        ↓
Nhận diện giới hạn của SOO
        ↓
Động lực phát triển MOSFOA
```

Đây là cấu trúc phù hợp cho một bài nghiên cứu nền tảng.

## 3.2. Việc lựa chọn MJP làm đối tượng nghiên cứu là hợp lý

Bản thảo giải thích rằng MJP là hệ kết cấu chính trong ba hệ đã khảo sát trước đó và có không gian biến thiết kế phong phú. Việc thu hẹp phạm vi từ ba hệ xuống MJP giúp tập trung nguồn lực tính toán.

Đây là một quyết định hợp lý đối với bài toán có FEM-in-the-loop với chi phí tính toán cao.

## 3.3. Framework SAP2000–MATLAB–SFOA là điểm mạnh

Việc cập nhật biến thiết kế trong SAP2000 thông qua COM, chạy FEM, truy xuất chuyển vị/nội lực/phản lực và đưa kết quả trở lại MATLAB là một workflow có ý nghĩa ứng dụng trực tiếp.

Đây là phần có giá trị đối với độc giả ngành xây dựng vì kết nối được thuật toán tối ưu với mô hình kết cấu thực tế.

## 3.4. Thực nghiệm 30 independent runs là điểm tích cực

Việc không chỉ báo cáo một lần chạy mà thực hiện 30 lần độc lập cho mỗi objective giúp đánh giá độ ổn định tốt hơn.

Các chỉ tiêu Best, Mean, Max, STD, CV và đường hội tụ là phù hợp với mục tiêu hiện tại.

## 3.5. Phân tích hai nghiệm cực trị khá trực quan

Kết quả:

- Cost-optimal: 5.291,86 USD và 0,00102 m.
- Displacement-optimal: 139.831,48 USD và 0,0000388 m.
- Current design: 25.708,94 USD và 0,00022445 m.

tạo ra một hình ảnh trực quan về sự đánh đổi giữa kinh tế và độ cứng.

Đây là một trong những phần thuyết phục nhất của bài.

---

# 4. MAJOR COMMENTS — Các vấn đề cần sửa trước khi gửi

## Major Comment 1 — Cần điều chỉnh mức độ khẳng định về "xung đột mục tiêu"

### Vấn đề

Bài viết hiện khẳng định:

> "đúng điều kiện cần để khẳng định chi phí và chuyển vị là hai mục tiêu xung đột."

Hai nghiệm cực trị thực sự cho thấy:

\[
C(x_C^*) < C(x_D^*)
\]

và

\[
D(x_D^*) < D(x_C^*)
\]

Do đó, kết quả là bằng chứng tốt cho quan hệ đánh đổi giữa hai tiêu chí tại hai nghiệm cực trị.

Tuy nhiên, hai điểm cực trị chưa mô tả toàn bộ không gian mục tiêu hoặc toàn bộ feasible design space.

### Kiến nghị

Không cần bổ sung Pareto front trong Paper 1.

Nên thay các phát biểu quá mạnh bằng cách diễn đạt thận trọng hơn:

> "Kết quả cho thấy chi phí và chuyển vị có quan hệ đánh đổi rõ rệt trên hai nghiệm cực trị của bài toán MJP."

và:

> "Kết quả này cung cấp cơ sở thực nghiệm cho việc xem xét bài toán đa mục tiêu trong nghiên cứu tiếp theo."

### Mức độ

**Bắt buộc sửa về cách diễn đạt. Không bắt buộc mở rộng thực nghiệm.**

---

## Major Comment 2 — Cần mô tả đầy đủ các ràng buộc kỹ thuật

### Vấn đề

Bản thảo đề cập đến:

- sức chịu tải dọc trục;
- sức chịu nhổ;
- mô men;
- khoảng cách cọc-dầm;

nhưng chưa trình bày đầy đủ:

- đại lượng kiểm tra;
- công thức/tiêu chí;
- giá trị giới hạn;
- cách chuẩn hóa constraint;
- cách xác định vi phạm;
- cách penalty được áp dụng cho từng constraint.

Hiện tại, độc giả chủ yếu được thông báo rằng nghiệm có:

`AllConstraintsSatisfied = 1`.

Điều này chưa đủ để tái lập.

### Kiến nghị

Bổ sung một bảng:

| STT | Ràng buộc | Đại lượng kiểm tra | Điều kiện |
|---|---|---|---|
| 1 | Sức chịu tải nén | ... | ≤ 1 |
| 2 | Sức chịu nhổ | ... | ≤ 1 |
| 3 | Mô men | ... | ≤ 1 |
| 4 | Khoảng cách cọc | ... | ≥ giới hạn |
| ... | ... | ... | ... |

Đồng thời mô tả:

\[
P(x)=\sum_j \lambda_j[\max(0,g_j(x))]^p
\]

và giải thích rõ \(g_j(x)\), \(\lambda_j\), \(p\).

### Mức độ

**Bắt buộc.**

---

## Major Comment 3 — Cần kiểm tra độc lập kết quả Displacement = 0,0388 mm

### Vấn đề

Nghiệm displacement-optimal cho:

\[
D_{\max}=0,0000388\,m=0,0388\,mm
\]

Đây là giá trị rất nhỏ so với:

- Current: 0,22445 mm;
- Cost-optimal: 1,02 mm.

Giá trị này có thể hoàn toàn đúng, nhưng đủ bất thường để reviewer yêu cầu xác minh.

### Cần kiểm tra

1. Node được dùng để xác định \(D_{\max}\).
2. DOF được sử dụng.
3. Định nghĩa chính xác của \(D_{\max}\).
4. Load combination.
5. Boundary conditions.
6. Đơn vị trong SAP2000.
7. Có lấy displacement tuyệt đối hay displacement tương đối.
8. Có đúng mô hình MJP cần nghiên cứu hay không.
9. Có hiện tượng cơ học đặc biệt nào làm chuyển vị nhỏ bất thường hay không.

### Kiến nghị

Không sửa số liệu chỉ vì nó "quá đẹp".

Nếu kiểm tra độc lập xác nhận kết quả, giữ nguyên và bổ sung mô tả cách xác định \(D_{\max}\).

Nếu phát hiện lỗi, phải sửa toàn bộ Bảng 2, Bảng 3, Bảng 4, Bảng 5, Hình 2, Abstract và Kết luận theo kết quả mới.

### Mức độ

**Ưu tiên kiểm tra cao nhất.**

---

## Major Comment 4 — Cần xác minh CV = 0% của MJP-Displacement

### Vấn đề

30 lần chạy độc lập cho MJP-D đều có:

- Best = 0,0000388;
- Mean = 0,0000388;
- Max = 0,0000388;
- STD = 0;
- CV = 0%.

Kết quả này rất tốt nhưng cũng dễ khiến reviewer đặt câu hỏi về tính ngẫu nhiên của thuật toán.

### Kiến nghị

Kiểm tra nội bộ toàn bộ 30 nghiệm cuối:

\[
x^*=[D,t,L,LL,LT,b,h]
\]

Không chỉ kiểm tra objective value.

Cần xác định:

- 30 nghiệm có cùng vector thiết kế hay không;
- nếu khác nhau nhưng có cùng objective thì vì sao;
- random seed có thực sự thay đổi giữa các run hay không;
- initialization có thực sự độc lập hay không.

Nếu 30 run thực sự hội tụ về cùng một vector thiết kế, đây là kết quả mạnh và có thể được giải thích như một đặc điểm của bài toán rời rạc này.

### Mức độ

**Bắt buộc kiểm tra; không nhất thiết phải đưa toàn bộ 30 vector vào bài.**

---

## Major Comment 5 — Cần làm rõ ý nghĩa của "Cost"

### Vấn đề

Hàm chi phí:

\[
C(x)=N_pL_pP_p+V_bP_c+W_sP_s
\]

đang được gọi là "chi phí xây dựng".

Tuy nhiên, từ mô tả hiện tại chưa rõ có bao gồm:

- vật liệu cọc;
- bê tông;
- cốt thép;
- thi công;
- đóng cọc;
- nối cọc;
- bản mặt cầu;
- nhân công;
- thiết bị;
- vận chuyển;
- các chi phí khác.

### Kiến nghị

Nếu đây thực chất là hàm chi phí vật liệu, nên gọi:

> "chi phí vật liệu" hoặc "hàm chi phí quy ước"

thay vì "construction cost".

Nếu thực sự là construction cost, cần định nghĩa rõ thành phần và đơn giá.

### Mức độ

**Bắt buộc làm rõ.**

---

## Major Comment 6 — Cần giảm sự phụ thuộc vào tài liệu [2]

### Vấn đề

Bản thảo sử dụng [2] để:

- lấy cấu hình MJP;
- lấy baseline;
- đối chiếu Bảng 12;
- xác nhận Cost;
- xác nhận Displacement;
- xác nhận mô hình.

Trong khi [2] đang được ghi là:

> "Bản thảo đang chuẩn bị nộp / in preparation."

Reviewer không thể dễ dàng kiểm tra tài liệu này.

### Kiến nghị

Giữ việc sử dụng [2] để mô tả quan hệ giữa các nghiên cứu trong chuỗi, nhưng các thông tin cần thiết cho tái lập Paper 1 phải xuất hiện ngay trong Paper 1:

- hình học;
- vật liệu;
- tải trọng;
- biến thiết kế;
- tập giá trị rời rạc;
- constraint;
- cost model;
- boundary conditions.

### Mức độ

**Bắt buộc bổ sung thông tin cốt lõi; không nhất thiết loại [2].**

---

# 5. MAJOR COMMENT 7 — Cần làm rõ vai trò khoa học của SFOA

Bản thảo hiện tại cơ bản đã tránh tuyên bố SFOA vượt trội, đây là hướng đúng.

Tuy nhiên, cần duy trì nhất quán.

Nghiên cứu không có:

- PSO;
- GA;
- DE;
- GWO;
- thuật toán baseline khác.

Do đó không nên dùng các cụm:

> "hiệu quả vượt trội"

hoặc:

> "ưu việt".

### Nên sử dụng

> "khả năng áp dụng"

> "khả năng tìm kiếm nghiệm khả thi"

> "tính ổn định giữa các lần chạy"

> "hiệu quả trong phạm vi bài toán khảo sát"

### Lý do

Đây là một bài SOO ứng dụng, không phải bài benchmark thuật toán.

Đối với Paper 1 của NCS, phạm vi này là hợp lý.

---

# 6. MAJOR COMMENT 8 — Không cần mở rộng Paper 1 thành bài MOO

Từ góc độ phản biện, tôi **không yêu cầu** tác giả:

- xây dựng Pareto front;
- bổ sung archive;
- non-dominated sorting;
- benchmark nhiều thuật toán;
- bổ sung BD và MD;
- phát triển MOSFOA ngay trong bài này.

Các nội dung đó thuộc bước nghiên cứu tiếp theo.

Paper 1 nên giữ vai trò:

> **SOO baseline → hai nghiệm cực trị → trade-off → cơ sở cho MOSFOA.**

Đây là phạm vi phù hợp và có tính hệ thống trong lộ trình nghiên cứu.

---

# 7. MINOR COMMENTS — Các sửa chữa nhỏ nhưng nên thực hiện

## Minor 1 — Diễn đạt mức tăng chi phí

Thay:

> "chi phí tăng 2.542% (~25,4 lần)"

bằng:

> "chi phí tăng khoảng 25,4 lần, tương đương tăng 2.542,2%."

Cách diễn đạt này dễ hiểu hơn.

---

## Minor 2 — Làm rõ "Best"

Nên định nghĩa rõ:

> Best là giá trị tốt nhất thu được trong 30 independent runs.

Nếu Best là Best-of-run hay Best-so-far cần thống nhất thuật ngữ.

---

## Minor 3 — Thống nhất thuật ngữ

Nên thống nhất:

- chuyển vị lớn nhất;
- displacement;
- \(D_{\max}\);

tránh thay đổi cách gọi trong các phần khác nhau.

---

## Minor 4 — Làm rõ Npop = 30

Không cần viện dẫn rằng 30 là "giá trị phổ biến" nếu không có tài liệu mạnh.

Nên giải thích:

> Npop = 30 được lựa chọn trên cơ sở cân bằng giữa số lượng mẫu tìm kiếm và chi phí tính toán FEM.

---

## Minor 5 — Bổ sung môi trường tính toán

Nên bổ sung một bảng nhỏ:

| Thông số | Giá trị |
|---|---|
| MATLAB version | ... |
| SAP2000 version | ... |
| CPU | ... |
| RAM | ... |
| OS | ... |
| Npop | 30 |
| Max iteration | 150 |
| Independent runs | 30/case |

---

## Minor 6 — Random seed

Nên ghi rõ:

- cách sinh seed;
- có dùng seed cố định hay không;
- các run có độc lập về initialization hay không.

---

## Minor 7 — Hình 1

Hình hội tụ nên đảm bảo:

- chú giải rõ;
- đơn vị;
- trục y dễ đọc;
- giải thích vì sao dùng logarithmic scale;
- phân biệt Best-so-far và Mean/đường khác nếu có.

---

## Minor 8 — Hình 2

Nên bổ sung chú thích rõ hơn:

> Đây là sơ đồ vị trí của ba thiết kế trong không gian Cost–Displacement, không phải Pareto front.

---

## Minor 9 — Bảng 3

Nên căn chỉnh lại đơn vị trong tiêu đề cột:

- D (mm)
- t (mm)
- L (m)
- LL (m)
- LT (m)
- b (m)
- h (m)
- Cost (USD)
- \(D_{\max}\) (m)

---

## Minor 10 — Phần hiệu quả tính toán

Thông tin 4.530 lần gọi SAP2000/run là hữu ích.

Nên trình bày rõ:

\[
N_{\text{eval}}=N_{\text{pop}}(N_{\text{it}}+1)
\]

nếu thực tế workflow có initial evaluation tương ứng.

---

# 8. Những nội dung KHÔNG nên bổ sung vào Paper 1

Để giữ bài gọn và phù hợp với vai trò Paper 1, không nên mở rộng không cần thiết sang:

- Pareto optimization;
- NSGA-II;
- MOPSO;
- benchmark hàng loạt metaheuristic;
- sensitivity analysis quá sâu;
- ablation study của MOSFOA;
- BD và MD;
- nhiều dạng tải không thuộc phạm vi MJP;
- phát triển thuật toán SFOA mới.

Nếu có yêu cầu của phản biện sau này, mới xem xét bổ sung.

---

# 9. Các yêu cầu kiểm tra trước khi khóa bài

## Checklist A — Mô hình kết cấu

- [ ] Kiểm tra lại hình học MJP.
- [ ] Kiểm tra đơn vị.
- [ ] Kiểm tra vật liệu.
- [ ] Kiểm tra boundary conditions.
- [ ] Kiểm tra tải DL.
- [ ] Kiểm tra tải LL.
- [ ] Kiểm tra load combination DL+LL.
- [ ] Xác nhận mô hình baseline tái tạo đúng kết quả đã công bố trước.

## Checklist B — SOO

- [ ] Kiểm tra vector biến thiết kế.
- [ ] Kiểm tra toàn bộ miền giá trị.
- [ ] Kiểm tra mapping continuous → discrete.
- [ ] Kiểm tra boundary handling.
- [ ] Kiểm tra random initialization.
- [ ] Kiểm tra random seed.
- [ ] Kiểm tra stopping criterion.

## Checklist C — Constraint

- [ ] Liệt kê toàn bộ constraint.
- [ ] Kiểm tra công thức từng constraint.
- [ ] Kiểm tra giới hạn.
- [ ] Kiểm tra penalty.
- [ ] Kiểm tra nghiệm cuối cùng.
- [ ] Lưu mức độ vi phạm lớn nhất của mỗi constraint.

## Checklist D — MJP-D

- [ ] Kiểm tra \(D_{\max}=0,0000388m\).
- [ ] Kiểm tra node.
- [ ] Kiểm tra DOF.
- [ ] Kiểm tra load combination.
- [ ] Kiểm tra đơn vị.
- [ ] Kiểm tra 30 vector nghiệm.
- [ ] Xác nhận CV = 0%.

## Checklist E — Cost

- [ ] Kiểm tra công thức Cost.
- [ ] Kiểm tra đơn giá.
- [ ] Kiểm tra đơn vị.
- [ ] Xác định rõ Cost là material cost hay construction cost.
- [ ] Kiểm tra tính nhất quán giữa baseline và nghiệm tối ưu.

---

# 10. Các câu hỏi reviewer có khả năng đặt ra

### Q1.
Tại sao chọn hai objective Cost và Displacement?

### Q2.
Tại sao tối thiểu displacement lại là một objective độc lập thay vì đặt displacement làm constraint?

### Q3.
Giá trị displacement 0,0388 mm có ý nghĩa vật lý như thế nào?

### Q4.
Các ràng buộc kỹ thuật cụ thể gồm những gì?

### Q5.
Tại sao Npop = 30 và Max_it = 150 là đủ?

### Q6.
30 independent runs có thực sự độc lập về random initialization không?

### Q7.
Tại sao MJP-Displacement có CV = 0%?

### Q8.
Cost trong nghiên cứu có phải construction cost thực tế không?

### Q9.
Nếu không so sánh với PSO/GA/DE thì cơ sở nào để đánh giá SFOA?

### Q10.
Tại sao chỉ khảo sát MJP mà không khảo sát BD và MD?

### Q11.
Tại sao không xây dựng Pareto front ngay trong nghiên cứu này?

### Q12.
Kết quả trade-off giữa hai nghiệm cực trị có đủ để kết luận hai objective xung đột không?

---

# 11. Cách trả lời các câu hỏi trên theo phạm vi Paper 1

## Q1 — Hai objective

Trả lời theo hướng:

> Chi phí đại diện cho hiệu quả kinh tế, trong khi chuyển vị lớn nhất đại diện cho yêu cầu độ cứng/khả năng làm việc của hệ kết cấu. Hai tiêu chí có ý nghĩa kỹ thuật trực tiếp và có khả năng dẫn đến các lựa chọn thiết kế khác nhau.

## Q2 — Vì sao tối thiểu displacement

Mục tiêu của Paper 1 là khảo sát độc lập hai hướng ưu tiên cực trị trước khi chuyển sang bài toán cân bằng nhiều mục tiêu.

## Q3 — Displacement rất nhỏ

Không giải thích bằng suy đoán. Phải dựa trên kiểm tra SAP2000 và định nghĩa chính xác của \(D_{\max}\).

## Q4 — Constraint

Bổ sung bảng constraint.

## Q5 — Npop và iteration

Giải thích bằng khảo sát hội tụ và chi phí FEM.

## Q6 — Independent runs

Công bố cơ chế random seed/initialization.

## Q7 — CV = 0%

Kiểm tra vector thiết kế của 30 runs và giải thích dựa trên kết quả thực tế.

## Q8 — Cost

Định nghĩa rõ phạm vi của hàm Cost.

## Q9 — Không benchmark

Nghiên cứu không nhằm xếp hạng SFOA so với các metaheuristic khác mà đánh giá khả năng áp dụng SFOA nguyên bản vào bài toán MJP và xây dựng baseline SOO cho nghiên cứu tiếp theo.

## Q10 — Chỉ MJP

Do chi phí tính toán FEM lớn và MJP có không gian biến thiết kế phong phú; đây là lựa chọn có chủ đích.

## Q11 — Không Pareto

Pareto optimization là phạm vi của nghiên cứu MOSFOA tiếp theo.

## Q12 — Conflict

Dùng cách diễn đạt "quan hệ đánh đổi rõ rệt trên hai nghiệm cực trị" thay vì khẳng định conflict trên toàn bộ không gian thiết kế.

---

# 12. Đánh giá riêng về vị trí của bài trong lộ trình NCS

Tôi đánh giá Paper 1 có vai trò rất phù hợp nếu được đặt trong chuỗi:

```text
PAPER 1
SOO + Original SFOA
        ↓
Baseline
        ↓
Cost-optimal
Displacement-optimal
        ↓
Trade-off
        ↓
Giới hạn của SOO
        ↓
────────────────────────
PAPER 2
MOO + MOSFOA
        ↓
Pareto front
        ↓
Trade-off solutions
        ↓
Decision making
```

Do đó, Paper 1 **không cần giải quyết bài toán MOO**.

Nó chỉ cần làm tốt nhiệm vụ:

> **Xây dựng baseline SOO đáng tin cậy và chỉ ra bằng thực nghiệm tại sao bài toán thiết kế này cần được mở rộng sang MOO.**

---

# 13. Đánh giá cuối cùng của Reviewer

### Điểm mạnh

1. Đề tài phù hợp với lĩnh vực kết cấu công trình biển.
2. Có mô hình FEM thực tế.
3. Có kết nối SAP2000–MATLAB.
4. Sử dụng SFOA nguyên bản, phù hợp mục tiêu khảo sát SOO.
5. Có 30 independent runs cho mỗi objective.
6. Có phân tích Best/Mean/Max/STD/CV.
7. Có so sánh Current–Cost-optimal–Displacement-optimal.
8. Có định lượng trade-off rất trực quan.
9. Có logic rõ ràng để chuyển tiếp sang MOSFOA.
10. Phạm vi nghiên cứu phù hợp với một Paper 1 của NCS.

### Điểm yếu chính

1. Constraint chưa đủ minh bạch.
2. Cost model cần định nghĩa rõ hơn.
3. Displacement-optimal 0,0388 mm cần kiểm chứng.
4. CV = 0% cần xác minh bằng vector thiết kế.
5. Một số claim về "xung đột" cần tiết chế.
6. Phụ thuộc hơi nhiều vào tài liệu [2].
7. Chưa mô tả đầy đủ môi trường tính toán và reproducibility.

---

# 14. Recommendation

**MAJOR REVISION**

Tuy nhiên, đây là:

> **Major Revision có khả năng chấp nhận**, không phải đề nghị viết lại từ đầu.

Tôi **không đề nghị thay đổi:**

- đối tượng MJP;
- hai objective;
- SFOA nguyên bản;
- framework SAP2000–MATLAB;
- 30 runs;
- logic SOO → trade-off → MOSFOA.

Tôi chỉ đề nghị **siết chặt bằng chứng và cách diễn đạt**.

---

# 15. Thứ tự sửa bài được khuyến nghị

### Giai đoạn 1 — Kiểm chứng kỹ thuật

1. Kiểm tra MJP-D = 0,0388 mm.
2. Kiểm tra 30 nghiệm MJP-D.
3. Kiểm tra 30 nghiệm MJP-C.
4. Kiểm tra toàn bộ constraint.
5. Kiểm tra penalty.
6. Kiểm tra Cost.

### Giai đoạn 2 — Khóa phương pháp

7. Khóa bảng biến thiết kế.
8. Khóa bảng constraint.
9. Khóa computational settings.
10. Khóa definition của \(D_{\max}\).
11. Khóa definition của Cost.

### Giai đoạn 3 — Sửa bài

12. Sửa Abstract.
13. Sửa Đặt vấn đề.
14. Sửa Mô hình bài toán.
15. Sửa Thiết lập thực nghiệm.
16. Sửa Kết quả.
17. Sửa Discussion.
18. Sửa Kết luận.

### Giai đoạn 4 — Kiểm tra cuối

19. Kiểm tra tất cả số liệu chéo giữa bảng/hình/text.
20. Kiểm tra thuật ngữ.
21. Kiểm tra citation.
22. Kiểm tra tính tái lập.
23. Kiểm tra claim không vượt quá bằng chứng.

---

# 16. Phán quyết cuối cùng

> **Bản thảo có nền tảng khoa học và kỹ thuật phù hợp để trở thành một bài báo SOO ứng dụng kết cấu cho tạp chí Xây dựng trong nước. Hướng nghiên cứu không cần thay đổi. Các sửa chữa quan trọng tập trung vào tính minh bạch của mô hình, kiểm chứng kết quả tối ưu, tính tái lập và tiết chế các kết luận vượt quá phạm vi dữ liệu. Sau khi các điểm này được xử lý, bài có thể được xem xét lại để gửi tạp chí.**

**Reviewer recommendation: MAJOR REVISION — Có thể chấp nhận sau sửa.**
