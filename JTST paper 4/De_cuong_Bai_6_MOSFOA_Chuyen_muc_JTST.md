# ĐỀ CƯƠNG CHI TIẾT BÀI BÁO 6

## Tên bài báo

### Tiếng Việt
**TỐI ƯU ĐA MỤC TIÊU HỆ KẾT CẤU BÊN TRÊN CẦU TÀU CHỊU NHIỀU TỔ HỢP TẢI TRỌNG SỬ DỤNG THUẬT TOÁN MOSFOA**

### Tiếng Anh
**MULTI-OBJECTIVE OPTIMIZATION OF PORT JETTY SUPERSTRUCTURE UNDER MULTIPLE LOAD COMBINATIONS USING MOSFOA**

---

# 1. ĐỊNH VỊ BÀI BÁO TRONG CHUỖI NGHIÊN CỨU

## 1.1. Vai trò của Bài 6

Bài 6 là một bài ứng dụng tiếp theo của **MOSFOA**, tập trung vào một lớp biến thiết kế khác với Bài 4.

- **Bài 4:** tối ưu đa mục tiêu hệ cọc, với trọng tâm là tiết diện cọc và các đáp ứng liên quan.
- **Bài 5:** đối sánh MOSFOA với MOFDA trên bài toán tối ưu đã xác định.
- **Bài 6:** sử dụng MOSFOA cho bài toán tối ưu **hệ kết cấu bên trên cầu tàu**, khai thác đặc điểm có nhiều tổ hợp tải trọng và hệ ràng buộc kết cấu.
- **Bài 7:** lựa chọn nghiệm Pareto bằng MCDM.
- **Bài 8:** đánh giá độ tin cậy/độ ổn định của nghiệm tối ưu nếu tiếp tục triển khai theo kế hoạch nghiên cứu.

## 1.2. Nguyên tắc tránh trùng lặp

Bài 6 không:
- lặp lại bài toán tối ưu tiết diện hệ cọc của Bài 4;
- lặp lại so sánh MOFDA–MOSFOA của Bài 5;
- nghiên cứu ảnh hưởng của quy mô – tải trọng – điều kiện địa kỹ thuật;
- đánh giá công trình hiện hữu;
- so sánh kết quả tối ưu với hồ sơ thiết kế gốc;
- sử dụng kết quả tối ưu để kết luận về công trình thực tế.

Chân Mây 70.000 DWT được sử dụng để xây dựng **một mô hình nghiên cứu giả định** có các thông số kỹ thuật đặc trưng tương ứng.

---

# 2. CÂU HỎI NGHIÊN CỨU

Bài báo cần trả lời câu hỏi trung tâm:

> **MOSFOA có thể giải hiệu quả bài toán tối ưu đa mục tiêu hệ kết cấu bên trên cầu tàu khi mỗi nghiệm phải đồng thời đáp ứng nhiều tổ hợp tải trọng và các ràng buộc kỹ thuật của mô hình FEM hay không?**

Các câu hỏi phụ:

1. Những biến thiết kế của hệ kết cấu bên trên ảnh hưởng như thế nào đến khối lượng và đáp ứng kết cấu?
2. Tập nghiệm Pareto thể hiện quan hệ đánh đổi giữa vật liệu và đáp ứng kết cấu như thế nào?
3. Các tổ hợp tải trọng nào có xu hướng chi phối tính khả thi của nghiệm tối ưu?
4. MOSFOA có tạo được các nghiệm Pareto khả thi và hội tụ ổn định hay không?

---

# 3. MỤC TIÊU NGHIÊN CỨU

## 3.1. Mục tiêu tổng quát

Xây dựng và giải bài toán tối ưu đa mục tiêu hệ kết cấu bên trên cầu tàu bằng MOSFOA, tích hợp với mô hình phân tích phần tử hữu hạn SAP2000 và xét đồng thời nhiều tổ hợp tải trọng.

## 3.2. Mục tiêu cụ thể

- Xây dựng mô hình nghiên cứu giả định cầu tàu 70.000 DWT.
- Xác định nhóm biến thiết kế thuộc hệ kết cấu bên trên.
- Xây dựng hàm mục tiêu đa mục tiêu.
- Thiết lập hệ ràng buộc kết cấu và chuyển vị.
- Đánh giá từng nghiệm thông qua các tổ hợp tải trọng của mô hình.
- Xác định tập nghiệm Pareto.
- Phân tích đặc điểm và ý nghĩa kỹ thuật của các nghiệm tối ưu.

---

# 4. ĐÓNG GÓP DỰ KIẾN

Bài báo dự kiến có 3 đóng góp chính:

1. **Xây dựng bài toán MOO cho hệ kết cấu bên trên cầu tàu**, khác với bài toán tối ưu hệ cọc đã nghiên cứu trước đó.
2. **Tích hợp MOSFOA–MATLAB–SAP2000** để tự động hóa quá trình tối ưu và phân tích kết cấu.
3. **Đánh giá nghiệm tối ưu dưới nhiều tổ hợp tải trọng**, qua đó xác định tập nghiệm Pareto khả thi và các trường hợp tải trọng chi phối.

> Không tuyên bố MOSFOA vượt trội so với các thuật toán khác trong Bài 6; nội dung đối sánh thuật toán thuộc Bài 5.

---

# 5. CẤU TRÚC BÀI BÁO THEO TEMPLATE JTST

## Tóm tắt

Độ dài mục tiêu: **150–200 từ**.

Tóm tắt theo 5 ý:
1. Bối cảnh/vấn đề.
2. Mục tiêu.
3. Phương pháp MOSFOA–SAP2000.
4. Mô hình cầu tàu 70.000 DWT và nhiều tổ hợp tải trọng.
5. Kết quả chính và ý nghĩa.

## Từ khóa

Dự kiến 5–7 từ khóa:
- Tối ưu đa mục tiêu;
- MOSFOA;
- cầu tàu;
- hệ kết cấu bên trên;
- SAP2000;
- tổ hợp tải trọng;
- tối ưu kết cấu.

## Abstract

150–200 từ, bám sát Tóm tắt tiếng Việt.

## Keywords

Multi-objective optimization; MOSFOA; port jetty; superstructure; SAP2000; load combinations; structural optimization.

---

# 6. GIỚI THIỆU

## 6.1. Bối cảnh nghiên cứu

Trình bày:
- vai trò của tối ưu kết cấu trong thiết kế công trình cảng;
- yêu cầu cân bằng giữa khối lượng vật liệu và đáp ứng kết cấu;
- tính phức tạp khi một phương án phải kiểm tra nhiều tổ hợp tải trọng;
- vai trò của các phương pháp metaheuristic trong bài toán tối ưu kết cấu.

## 6.2. Tổng quan nghiên cứu

Tập trung 3 nhóm:
1. tối ưu kết cấu bằng metaheuristic;
2. MOO cho kết cấu/công trình cảng;
3. tối ưu kết cấu khi phải kiểm tra nhiều tải trọng/tổ hợp tải trọng và phân tích FEM.

Không biến phần này thành tổng quan MOSFOA quá dài.

## 6.3. Khoảng trống nghiên cứu

Nêu ngắn gọn:

> Các nghiên cứu ứng dụng tối ưu đa mục tiêu cho kết cấu cầu tàu còn cần được mở rộng sang bài toán lựa chọn cấu hình hệ kết cấu bên trên trong điều kiện phải đồng thời đáp ứng nhiều tổ hợp tải trọng và ràng buộc kỹ thuật.

## 6.4. Mục tiêu và phạm vi

Khẳng định:
- MOSFOA là thuật toán sử dụng trong nghiên cứu;
- SAP2000 đảm nhiệm phân tích FEM;
- MATLAB điều khiển quá trình tối ưu;
- đối tượng là mô hình nghiên cứu giả định cầu tàu 70.000 DWT;
- không đánh giá công trình hiện hữu;
- không so sánh hồ sơ thiết kế gốc.

---

# 7. PHƯƠNG PHÁP NGHIÊN CỨU

## 7.1. Phát biểu bài toán tối ưu đa mục tiêu

Dạng tổng quát:

$$
\min \mathbf{F}(\mathbf{x})=[f_1(\mathbf{x}),f_2(\mathbf{x})]
$$

với:

$$
\mathbf{x}=[x_1,x_2,\ldots,x_n]
$$

và:

$$
g_j(\mathbf{x})\leq0
$$

## 7.2. Thuật toán MOSFOA

Trình bày ngắn gọn:
- khởi tạo quần thể;
- tạo/cập nhật cá thể;
- đánh giá fitness;
- xử lý ràng buộc;
- xác định nghiệm không trội;
- cập nhật archive;
- lựa chọn nghiệm dẫn hướng;
- tiêu chí dừng.

Không lặp lại toàn bộ phần phát triển thuật toán của công bố Q3.

## 7.3. Mô hình liên kết MOSFOA–MATLAB–SAP2000

```text
Design variables
       ↓
    MOSFOA
       ↓
    MATLAB
       ↓
   SAP2000
       ↓
Structural analysis
       ↓
Responses from load combinations
       ↓
Objectives + constraints
       ↓
Feasibility / Pareto
       ↓
    MOSFOA
```

## 7.4. Quy trình đánh giá một nghiệm

1. cập nhật section trong SAP2000;
2. chạy phân tích;
3. đọc kết quả;
4. xác định đáp ứng bất lợi;
5. kiểm tra ràng buộc;
6. tính các objective;
7. trả fitness về MOSFOA.

---

# 8. MÔ HÌNH NGHIÊN CỨU CẦU TÀU 70.000 DWT

## 8.1. Cơ sở xây dựng mô hình

Mô hình được xây dựng từ bộ thông số kỹ thuật của dự án Chân Mây 70.000 DWT nhưng được trình bày trong bài báo dưới dạng:

> **mô hình nghiên cứu giả định phục vụ bài toán tối ưu kết cấu.**

Không sử dụng ngôn ngữ đánh giá/kiểm định công trình hiện hữu.

## 8.2. Hình học mô hình

Trình bày:
- kích thước tổng thể;
- block nghiên cứu;
- bố trí cọc;
- dầm;
- bản;
- các cấu kiện thuộc nhóm biến thiết kế.

## 8.3. Vật liệu

Trình bày:
- bê tông;
- thép;
- thông số cơ học cần thiết cho FEM.

## 8.4. Mô hình SAP2000

Trình bày:
- loại phần tử;
- số lượng frame;
- số lượng area;
- liên kết;
- điều kiện biên;
- giả thiết mô hình.

## 8.5. Tải trọng

Phân loại các nhóm tải:
- tĩnh tải;
- hoạt tải;
- tải khai thác;
- tải thiết bị;
- gió;
- dòng chảy;
- tải môi trường;
- tải tàu/neo nếu có trong mô hình;
- các tải trọng khác đã được xác định trong bộ mô hình.

## 8.6. Tổ hợp tải trọng

Nếu giữ cấu trúc hiện tại của mô hình:

$$
N_{comb}=410
$$

gồm các nhóm ULS, SLS và envelope theo dữ liệu mô hình.

Cần lập **Bảng tổng hợp tổ hợp tải trọng** thay vì liệt kê toàn bộ 410 tổ hợp trong nội dung chính.

---

# 9. THIẾT LẬP BÀI TOÁN TỐI ƯU

## 9.1. Nguyên tắc lựa chọn biến

Các biến phải:
- thuộc hệ kết cấu bên trên;
- có khả năng thay đổi tự động trong SAP2000;
- có miền giá trị/nhóm tiết diện rõ ràng;
- không làm thay đổi bản chất mô hình;
- không trùng trọng tâm tối ưu tiết diện cọc của Bài 4.

## 9.2. Bộ biến thiết kế dự kiến

Bộ biến sơ bộ:

$$
\mathbf{x}=[h_{DN},h_{DD},h_{DCT},t_{BMC}]
$$

Trong đó cần xác nhận lại chính xác ý nghĩa của từng biến theo model cuối cùng trước khi viết bản thảo.

Có thể sử dụng tiết diện rời rạc:

$$
x_i\in\{x_i^1,x_i^2,\ldots,x_i^m\}
$$

## 9.3. Các cấu kiện giữ cố định

Hệ cọc được giữ cố định trong Bài 6 để tách biệt với Bài 4.

Các cấu kiện khác chỉ được đưa vào biến nếu có thể thay đổi một cách nhất quán trong mô hình.

## 9.4. Hàm mục tiêu

### Objective 1 – Khối lượng

$$
\min f_1(\mathbf{x})=W_{sup}
$$

Trong đó $W_{sup}$ là khối lượng nhóm kết cấu bên trên được tối ưu.

### Objective 2 – Đáp ứng kết cấu

Dạng dự kiến:

$$
\min f_2(\mathbf{x})=U_{max}
$$

Trong đó $U_{max}$ là chuyển vị lớn nhất phù hợp với phạm vi nghiên cứu.

> Objective 2 chỉ được khóa sau khi kiểm tra lại kết quả SAP2000 và xác nhận rằng chuyển vị là chỉ tiêu phù hợp nhất. Nếu cần, có thể thay bằng một chỉ tiêu đáp ứng khác nhưng phải bảo đảm không trùng mục tiêu của các bài trước.

---

# 10. HỆ RÀNG BUỘC

## 10.1. Ràng buộc cường độ

Ví dụ:

$$
\eta_M=\frac{M_{Ed}}{M_{Rd}}\leq1
$$

$$
\eta_N=\frac{N_{Ed}}{N_{Rd}}\leq1
$$

## 10.2. Ràng buộc ứng suất

$$
\frac{\sigma_{Ed}}{\sigma_{allow}}\leq1
$$

nếu phù hợp với phương pháp kiểm tra đã sử dụng.

## 10.3. Ràng buộc chuyển vị

$$
U_{max}\leq U_{allow}
$$

## 10.4. Ràng buộc khác

Chỉ đưa các ràng buộc thực sự được kiểm tra trong mô hình.

**Không tự thêm ràng buộc chưa có cơ sở từ mô hình/tiêu chuẩn áp dụng.**

---

# 11. XỬ LÝ NHIỀU TỔ HỢP TẢI TRỌNG

## 11.1. Nguyên tắc

Mỗi nghiệm thiết kế được kiểm tra trên toàn bộ tập tổ hợp:

$$
C=\{C_1,C_2,\ldots,C_{410}\}
$$

## 11.2. Giá trị bất lợi

Với mỗi đại lượng kiểm tra:

$$
R_{max}(\mathbf{x})=\max_{k=1,\ldots,410}R_k(\mathbf{x})
$$

hoặc sử dụng giá trị bất lợi tương ứng với đại lượng có dấu nếu cần.

## 11.3. Điều kiện nghiệm khả thi

Một nghiệm được coi là khả thi khi:

$$
g_j(\mathbf{x})\leq0
$$

với toàn bộ các ràng buộc được quy định.

## 11.4. Xác định tổ hợp chi phối

Sau tối ưu, xác định:
- tổ hợp chi phối mômen;
- tổ hợp chi phối lực dọc;
- tổ hợp chi phối chuyển vị;
- tổ hợp chi phối tỷ số kiểm tra.

Đây là một kết quả kỹ thuật quan trọng của Bài 6.

---

# 12. THIẾT LẬP THÍ NGHIỆM TÍNH TOÁN

## 12.1. Tham số MOSFOA

Cần lập bảng:

| Tham số | Giá trị |
|---|---:|
| Population size | ... |
| Maximum iterations | ... |
| Archive size | ... |
| Số biến | ... |
| Số giá trị/biến | ... |
| Số lần chạy độc lập | ... |

Các giá trị sẽ điền sau khi khóa cấu hình thực nghiệm.

## 12.2. Chạy độc lập

Nếu có đủ tài nguyên, thực hiện nhiều independent runs để đánh giá tính ổn định.

Không cần dùng cùng cấu hình với Bài 5 nếu mục đích thực nghiệm khác.

## 12.3. Tiêu chí đánh giá

Tối thiểu:
- convergence;
- Pareto front;
- số nghiệm khả thi;
- chất lượng nghiệm;
- tính ổn định giữa các lần chạy.

---

# 13. KẾT QUẢ VÀ THẢO LUẬN

## 13.1. Kiểm chứng mô hình FEM

Trình bày:
- kiểm tra hình học;
- kiểm tra vật liệu;
- kiểm tra điều kiện biên;
- kiểm tra phản ứng cơ bản.

## 13.2. Không gian thiết kế

Trình bày:
- số lượng tổ hợp thiết kế;
- miền biến;
- số nghiệm khả thi;
- số nghiệm không khả thi.

## 13.3. Khả năng hội tụ của MOSFOA

Hình đề xuất:
- **Hình 1:** Lưu đồ nghiên cứu.
- **Hình 2:** Hội tụ MOSFOA.

## 13.4. Tập nghiệm Pareto

**Hình 3:** Pareto front giữa $W_{sup}$ và $U_{max}$.

Phân tích:
- nghiệm nhẹ nhất;
- nghiệm có đáp ứng nhỏ nhất;
- nghiệm trung gian/knee.

## 13.5. Phân tích các nghiệm đại diện

Chọn tối thiểu 3 nghiệm:

| Nghiệm | Ý nghĩa |
|---|---|
| A | Khối lượng nhỏ nhất |
| B | Nghiệm cân bằng |
| C | Đáp ứng nhỏ nhất |

Lập bảng:
- biến thiết kế;
- khối lượng;
- chuyển vị;
- tỷ số kiểm tra lớn nhất;
- tổ hợp chi phối.

## 13.6. Ảnh hưởng của biến thiết kế

Phân tích:
- biến làm tăng/giảm khối lượng;
- biến làm tăng độ cứng;
- quan hệ giữa kích thước cấu kiện và chuyển vị;
- trade-off giữa vật liệu và đáp ứng.

## 13.7. Phân tích tổ hợp tải trọng chi phối

Đây là phần tạo bản sắc cho Bài 6.

Xác định:

$$
C_{critical}
$$

và lập bảng:

| Đại lượng | Tổ hợp chi phối | Giá trị | Nghiệm |
|---|---|---:|---|
| $M$ | ... | ... | ... |
| $N$ | ... | ... | ... |
| $U$ | ... | ... | ... |
| Ratio | ... | ... | ... |

## 13.8. Thảo luận

Tập trung vào:
1. MOSFOA có tạo được tập nghiệm khả thi hay không?
2. Trade-off giữa khối lượng và đáp ứng thể hiện như thế nào?
3. Việc xét đồng thời nhiều tổ hợp tải trọng ảnh hưởng như thế nào đến miền nghiệm khả thi?

Không mở rộng sang phân tích quy mô công trình, địa chất hoặc so sánh các dự án khác.

---

# 14. KẾT LUẬN

Kết luận dự kiến theo 4 ý:

1. MOSFOA có thể áp dụng để giải bài toán tối ưu đa mục tiêu hệ kết cấu bên trên cầu tàu.
2. Việc thay đổi các biến thiết kế phần trên tạo ra tập nghiệm Pareto thể hiện rõ trade-off giữa khối lượng và đáp ứng.
3. Việc kiểm tra nhiều tổ hợp tải trọng cho phép xác định các nghiệm khả thi và các trường hợp tải trọng chi phối.
4. Kết quả cung cấp một minh chứng bổ sung cho khả năng áp dụng MOSFOA vào các bài toán tối ưu kết cấu cảng.

Không kết luận vượt quá dữ liệu thực nghiệm.

---

# 15. CÁC HÌNH DỰ KIẾN

1. Sơ đồ quy trình MOSFOA–MATLAB–SAP2000.
2. Mô hình FEM cầu tàu 70.000 DWT.
3. Bố trí các nhóm cấu kiện/biến thiết kế.
4. Hội tụ MOSFOA.
5. Pareto front.
6. So sánh các nghiệm Pareto đại diện.
7. Phân bố/tần suất các tổ hợp tải trọng chi phối nếu dữ liệu đủ rõ.

> Không nên đưa quá nhiều hình; ưu tiên hình trực tiếp phục vụ câu hỏi nghiên cứu.

---

# 16. CÁC BẢNG DỰ KIẾN

1. Thông số hình học và vật liệu mô hình.
2. Các nhóm tải trọng.
3. Các nhóm tổ hợp tải trọng.
4. Biến thiết kế và miền giá trị.
5. Hàm mục tiêu và ràng buộc.
6. Tham số MOSFOA.
7. Các nghiệm Pareto đại diện.
8. Các tổ hợp tải trọng chi phối.

---

# 17. TÀI LIỆU THAM KHẢO

Cấu trúc theo IEEE và template JTST.

Các nhóm tài liệu cần có:
1. công bố gốc MOSFOA;
2. bài báo của chính tác giả về MOSFOA;
3. nghiên cứu MOO kết cấu;
4. nghiên cứu metaheuristic trong tối ưu kết cấu;
5. nghiên cứu tối ưu công trình/cầu tàu;
6. tài liệu SAP2000/API nếu cần;
7. tiêu chuẩn thiết kế được sử dụng.

Không trích dẫn các tài liệu không thực sự được sử dụng trong bài.

---

# 18. CÁC PHẦN CUỐI BÀI THEO TEMPLATE JTST

## Tuyên bố không xung đột lợi ích và cam kết bản quyền

Điền theo mẫu của JTST.

## Chia sẻ dữ liệu theo yêu cầu

Nêu chính sách dữ liệu phù hợp với bài báo.

## Lời cảm ơn

Chỉ đưa nếu có.

## Tài liệu tham khảo

IEEE.

## Đóng góp của các tác giả

Phân định rõ vai trò theo template.

---

# 19. CHECKLIST TRƯỚC KHI VIẾT BẢN THẢO

## Phải khóa trước

- [ ] Bộ biến thiết kế chính xác.
- [ ] Miền giá trị của từng biến.
- [ ] Objective 1.
- [ ] Objective 2.
- [ ] Toàn bộ ràng buộc.
- [ ] Cách xử lý 410 tổ hợp.
- [ ] Số lần chạy MOSFOA.
- [ ] Tiêu chí hội tụ.
- [ ] Tiêu chí lựa chọn nghiệm Pareto đại diện.

## Phải kiểm tra để tránh trùng Bài 4

- [ ] Không tối ưu lại riêng D–t cọc.
- [ ] Không dùng khối lượng cọc làm objective chính.
- [ ] Không biến bài thành phiên bản thứ ba của bài toán Bài 4.
- [ ] Cọc được giữ cố định nếu cần để tách bài toán.

## Phải kiểm tra để tránh trùng Bài 5

- [ ] Không so sánh MOFDA–MOSFOA.
- [ ] Không lấy benchmark/đối sánh thuật toán làm đóng góp chính.
- [ ] Không lặp lại cấu trúc thực nghiệm của Bài 5 nếu không cần thiết.

## Phải kiểm tra với Bài 7

- [ ] Bài 6 tạo tập Pareto.
- [ ] Không thực hiện MCDM/TOPSIS như một nội dung chính.
- [ ] Có thể cung cấp tập Pareto làm đầu vào cho Bài 7.

## Phải kiểm tra với Bài 8

- [ ] Không biến Bài 6 thành bài đánh giá độ tin cậy.
- [ ] Không thực hiện phân tích bất định chuyên sâu.
- [ ] Chỉ đánh giá khả thi và độ ổn định tính toán trong phạm vi bài.

---

# 20. LOGIC CHUỖI SẢN PHẨM

```text
SFOA
  │
  ▼
MOSFOA – Sản phẩm lõi luận án
  │
  ├── Bài 4
  │   Tối ưu hệ cọc
  │   30.000 + 100.000 DWT
  │
  ├── Bài 5
  │   MOFDA ↔ MOSFOA
  │   Đối sánh thuật toán
  │
  ├── Bài 6
  │   Hệ kết cấu bên trên
  │   Chân Mây 70.000 DWT
  │   Nhiều tổ hợp tải trọng
  │
  ├── Bài 7
  │   MCDM lựa chọn nghiệm Pareto
  │
  └── Bài 8
      Đánh giá độ tin cậy/độ ổn định nghiệm
```

## Định vị khoa học của Bài 6

Bài 6 không nhằm chứng minh:

> “MOSFOA tốt hơn thuật toán X”.

Bài 6 nhằm chứng minh một khía cạnh khác:

> **MOSFOA có khả năng xử lý một bài toán tối ưu đa mục tiêu kết cấu có nhiều biến thuộc hệ kết cấu bên trên và chịu đồng thời một hệ lớn các tổ hợp tải trọng/ràng buộc kỹ thuật.**

Đây là mắt xích bổ sung cho chuỗi nghiên cứu, đồng thời giữ **MOSFOA là thuật toán trung tâm** mà không lặp lại vai trò của Bài 4 và Bài 5.
