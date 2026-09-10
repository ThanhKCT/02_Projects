# ĐỀ CƯƠNG CHI TIẾT BÀI BÁO 2

## Tên bài báo dự kiến

**ỨNG DỤNG THUẬT TOÁN MOSFOA TỐI ƯU ĐA MỤC TIÊU HỆ CỌC CẦU TÀU: KIỂM CHỨNG TRÊN HAI CÔNG TRÌNH CÓ QUY MÔ VÀ ĐIỀU KIỆN ĐỊA KỸ THUẬT KHÁC NHAU**

---

## 1. Định hướng và câu hỏi nghiên cứu

### 1.1. Định hướng

Bài 2 sử dụng **MOSFOA** trên **hai công trình cầu tàu độc lập**, có cùng bản chất bài toán tối ưu hệ cọc nhưng khác nhau về quy mô, tải trọng và điều kiện địa kỹ thuật.

Bài này không phát triển thuật toán mới và không tiếp tục so sánh MOSFOA với MOFDA.

### 1.2. Câu hỏi nghiên cứu chính

> MOSFOA có duy trì được khả năng tìm kiếm và tính ổn định của nghiệm tối ưu khi áp dụng cho các bài toán cầu tàu có quy mô, tải trọng và điều kiện địa kỹ thuật khác nhau hay không?

### 1.3. Mục tiêu

1. Xây dựng hai bài toán tối ưu đa mục tiêu hệ cọc trên hai công trình thực tế.
2. Áp dụng cùng quy trình MOSFOA cho hai bài toán.
3. Đánh giá độ ổn định và khả năng tái lập kết quả của MOSFOA.
4. So sánh đặc điểm nghiệm tối ưu giữa hai công trình.
5. Xác định các khác biệt chính của hệ cọc tối ưu do điều kiện công trình thay đổi.

---

# 2. MỞ ĐẦU

## 2.1. Bối cảnh nghiên cứu

- Vai trò của hệ cọc trong kết cấu cầu tàu.
- Tính đa mục tiêu của thiết kế.
- Sự phức tạp khi kết hợp FEM, biến thiết kế rời rạc và các ràng buộc kết cấu – địa kỹ thuật.

## 2.2. Vấn đề của kiểm chứng thuật toán trên một công trình

- Kết quả trên một bài toán đơn lẻ chưa đủ để đánh giá khả năng áp dụng cho các điều kiện công trình khác.
- Quy mô, tải trọng và nền đất có thể làm thay đổi không gian nghiệm và nghiệm tối ưu.

## 2.3. Khoảng trống nghiên cứu

- Cần kiểm chứng thuật toán trên nhiều bài toán thực tế có điều kiện đầu vào khác nhau.
- Cần sử dụng một quy trình tối ưu thống nhất để hạn chế ảnh hưởng của các yếu tố ngoài thuật toán.

## 2.4. MOSFOA và mục tiêu nghiên cứu

- Giới thiệu ngắn MOSFOA.
- Nêu mục tiêu của bài báo.
- Nêu rõ phạm vi chỉ gồm hai công trình.

---

# 3. ĐỐI TƯỢNG NGHIÊN CỨU VÀ MÔ HÌNH TÍNH TOÁN

## 3.1. Công trình 1

Trình bày:

- loại công trình;
- quy mô;
- hệ kết cấu;
- hệ cọc;
- vật liệu;
- điều kiện tải trọng;
- điều kiện địa chất;
- các thông số chính của mô hình.

## 3.2. Công trình 2

Trình bày tương tự công trình 1.

## 3.3. So sánh điều kiện đầu vào của hai công trình

Lập bảng tổng hợp:

| Thông số | Công trình 1 | Công trình 2 |
|---|---:|---:|
| Quy mô | ... | ... |
| Tải trọng chính | ... | ... |
| Kích thước kết cấu | ... | ... |
| Hệ cọc | ... | ... |
| Điều kiện địa chất | ... | ... |
| Không gian thiết kế | ... | ... |

Mục đích của bảng là chứng minh hai case có cùng bản chất nhưng điều kiện đầu vào khác nhau.

## 3.4. Mô hình FEM

- Mô hình 3D.
- Phần tử sử dụng.
- Điều kiện biên.
- Mô hình tương tác kết cấu – cọc/nền theo phạm vi nghiên cứu.
- Tải trọng.
- Phương pháp phân tích.

## 3.5. Liên kết MATLAB – SAP2000

- MATLAB tạo phương án thiết kế.
- SAP2000 phân tích FEM.
- Kết quả FEM được trả về MATLAB.
- MATLAB tính hàm mục tiêu và kiểm tra ràng buộc.
- Archive Pareto được cập nhật sau mỗi vòng lặp.

---

# 4. XÂY DỰNG BÀI TOÁN TỐI ƯU

## 4.1. Biến thiết kế

Đối với từng công trình:

- xác định biến thiết kế;
- miền giá trị;
- số lượng phương án;
- phương pháp mã hóa;
- phương pháp rời rạc hóa.

Nếu hai công trình có cùng hệ biến thì giữ nguyên cấu trúc biến để thuận lợi cho so sánh.

## 4.2. Hàm mục tiêu

Sử dụng thống nhất:

### Mục tiêu 1
Tối thiểu hóa khối lượng vật liệu.

### Mục tiêu 2
Tối thiểu hóa chuyển vị ngang cực đại.

Biểu diễn bài toán:

\[
\min F(x)=\{f_1(x),f_2(x)\}
\]

với:

\[
f_1(x)=M(x)
\]

\[
f_2(x)=U_{\max}(x)
\]

## 4.3. Ràng buộc kết cấu

- Điều kiện chịu lực.
- Điều kiện ứng suất.
- Điều kiện chuyển vị.
- Các điều kiện thiết kế cần thiết khác.

## 4.4. Ràng buộc địa kỹ thuật

- Sức chịu tải cọc.
- Tính toán theo TCVN 10304:2025.
- Sử dụng điều kiện địa chất tương ứng của từng công trình.
- Kiểm tra riêng các loại cọc nếu cần.

## 4.5. Xử lý nghiệm không khả thi

- Quy định nghiệm khả thi/không khả thi.
- Cách xử lý vi phạm.
- Áp dụng thống nhất cho hai công trình.

---

# 5. ÁP DỤNG THUẬT TOÁN MOSFOA

## 5.1. Nguyên lý MOSFOA

Chỉ trình bày ngắn gọn các thành phần cần thiết để hiểu quá trình tối ưu.

Không lặp lại toàn bộ phần phát triển thuật toán của bài MOSFOA trước.

## 5.2. Quy trình tối ưu

Sơ đồ:

**Khởi tạo → đánh giá FEM → kiểm tra ràng buộc → cập nhật Pareto archive → sinh nghiệm MOSFOA → đánh giá → cập nhật → điều kiện dừng → nghiệm Pareto.**

## 5.3. Thiết lập tham số

Trình bày:

- kích thước quần thể;
- số vòng lặp;
- tham số thuật toán;
- kích thước archive;
- điều kiện dừng;
- số lần chạy độc lập.

## 5.4. Tính nhất quán giữa hai công trình

Ưu tiên giữ:

- cùng cấu hình MOSFOA;
- cùng nguyên tắc xử lý nghiệm;
- cùng tiêu chí dừng;
- cùng số lần chạy độc lập.

Nếu phải thay đổi tham số do quy mô bài toán thì phải ghi rõ lý do và tránh điều chỉnh theo kết quả.

---

# 6. THIẾT KẾ THỰC NGHIỆM VÀ ĐÁNH GIÁ

## 6.1. Các trường hợp tính toán

- Case 1: công trình 1.
- Case 2: công trình 2.

## 6.2. Số lần chạy độc lập

Thực hiện nhiều lần chạy độc lập cho mỗi case để đánh giá tính ổn định.

Khuyến nghị giữ **20 lần chạy/case** nếu chi phí tính toán cho phép và thống nhất với bài 1.

## 6.3. Mặt Pareto tham chiếu

Nếu không gian thiết kế của từng case đủ nhỏ để vét cạn:

- vét cạn toàn bộ không gian;
- xác định nghiệm khả thi;
- xác lập mặt Pareto thực;
- sử dụng làm chuẩn đánh giá MOSFOA.

Nếu không gian case 2 quá lớn để vét cạn thì phải xác định chuẩn đánh giá phù hợp dựa trên khả năng tính toán thực tế, không giả định trước.

## 6.4. Chỉ tiêu đánh giá

Ưu tiên:

- IGD;
- HV;
- tỷ lệ nghiệm Pareto tham chiếu được tìm thấy;
- độ phân tán giữa các lần chạy;
- tốc độ hội tụ.

Nếu có Pareto tham chiếu đáng tin cậy thì sử dụng cùng bộ chỉ tiêu với bài 1 để tạo tính nhất quán giữa các nghiên cứu.

---

# 7. KẾT QUẢ VÀ THẢO LUẬN

## 7.1. Đặc điểm hai bài toán

So sánh:

- quy mô;
- số biến;
- số tổ hợp;
- tỷ lệ nghiệm khả thi;
- mức độ ràng buộc;
- đặc điểm tải trọng;
- điều kiện địa kỹ thuật.

## 7.2. Kết quả tối ưu – Công trình 1

Trình bày:

- mặt Pareto;
- các nghiệm đại diện;
- khối lượng;
- chuyển vị;
- tiết diện/cấu hình cọc;
- mức độ hội tụ;
- độ ổn định giữa các lần chạy.

## 7.3. Kết quả tối ưu – Công trình 2

Trình bày tương tự công trình 1.

## 7.4. Kiểm tra độ ổn định của MOSFOA

So sánh giữa các lần chạy:

- IGD;
- HV;
- độ phân tán;
- nghiệm tốt nhất/trung vị;
- khả năng tái lập;
- hội tụ.

Mục đích là đánh giá MOSFOA có hoạt động ổn định khi chuyển từ case này sang case khác hay không.

## 7.5. So sánh nghiệm tối ưu giữa hai công trình

Tập trung vào:

- sự thay đổi khối lượng;
- sự thay đổi chuyển vị;
- sự thay đổi loại/tiết diện cọc;
- sự thay đổi vùng nghiệm Pareto;
- sự thay đổi tỷ lệ nghiệm khả thi.

Không biến phần này thành phân tích định lượng đầy đủ ảnh hưởng riêng của từng yếu tố.

## 7.6. Thảo luận

Giải thích sự khác biệt quan sát được dựa trên:

**quy mô + tải trọng + điều kiện địa kỹ thuật → yêu cầu thiết kế → nghiệm tối ưu.**

Chỉ giải thích ở mức phù hợp với dữ liệu của hai case.

Phần phân tích sâu về ảnh hưởng riêng của từng yếu tố được dành cho bài 3.

---

# 8. KẾT LUẬN

Kết luận theo các ý:

1. MOSFOA được áp dụng cho hai bài toán cầu tàu có điều kiện khác nhau.
2. Kết quả cho thấy mức độ ổn định của MOSFOA giữa hai case.
3. Mặt Pareto và cấu hình hệ cọc tối ưu thay đổi theo điều kiện công trình.
4. Các khác biệt chính được liên hệ với quy mô, tải trọng và điều kiện địa kỹ thuật trong phạm vi hai công trình nghiên cứu.

Không tuyên bố MOSFOA có tính ưu việt phổ quát.

---

# 9. Điểm mới cần giữ cho bài 2

**Điểm mới của bài 2 không phải là thuật toán MOSFOA.**

Điểm mới nằm ở:

> **Kiểm chứng khả năng áp dụng nhất quán của MOSFOA trên hai bài toán thiết kế cầu tàu thực tế có điều kiện đầu vào khác nhau, đồng thời phân tích sự thay đổi của nghiệm Pareto và cấu hình hệ cọc tối ưu.**

---

# 10. Ranh giới với bài 1 và bài 3

### Không trùng bài 1

Bài 1:
> MOFDA vs MOSFOA trên một công trình.

Bài 2:
> MOSFOA trên hai công trình.

### Không trùng bài 3

Bài 2 chỉ nhận diện và mô tả sự khác biệt giữa hai công trình.

Bài 3 mới thực hiện phân tích sâu:

> **quy mô – tải trọng – điều kiện địa kỹ thuật ảnh hưởng như thế nào đến nghiệm tối ưu của hệ cọc.**

Do đó bài 2 không nên đi quá sâu vào phân tích độ nhạy hay tách riêng tác động của từng yếu tố.

---

# 11. Trình tự thực hiện

1. Chốt hai công trình/case.
2. Chuẩn hóa mô hình FEM của hai case.
3. Chuẩn hóa hàm mục tiêu và ràng buộc.
4. Xác định không gian thiết kế từng case.
5. Kiểm tra khả năng vét cạn để tạo Pareto tham chiếu.
6. Chạy MOSFOA nhiều lần độc lập cho từng case.
7. Tính các chỉ tiêu đánh giá.
8. So sánh độ ổn định và nghiệm tối ưu.
9. Phân tích sự khác biệt ở mức tổng quát.
10. Viết bài theo cấu trúc trên.

# CHỐT

Bài 2 = **2 công trình + 1 thuật toán MOSFOA + kiểm chứng tính nhất quán/khả năng khái quát + so sánh nghiệm tối ưu giữa hai công trình.**

Không phát triển thuật toán mới.
Không thêm thuật toán đối chứng.
Không mở rộng thành nghiên cứu độ nhạy đầy đủ.
