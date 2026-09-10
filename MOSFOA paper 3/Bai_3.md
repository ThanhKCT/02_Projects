# ĐỀ CƯƠNG CHI TIẾT BÀI BÁO 3

## Tên bài báo dự kiến

**ẢNH HƯỞNG CỦA QUY MÔ, TẢI TRỌNG VÀ ĐIỀU KIỆN ĐỊA KỸ THUẬT ĐẾN TỐI ƯU HỆ CỌC CẦU TÀU SỬ DỤNG THUẬT TOÁN MOSFOA**

---

## 1. Định hướng và câu hỏi nghiên cứu

### 1.1. Định hướng

Bài 3 sử dụng **kết quả tối ưu của hai công trình trong bài 2** để phân tích về mặt kỹ thuật:

> Các đặc điểm của công trình và điều kiện làm việc làm thay đổi như thế nào đến cấu hình hệ cọc tối ưu?

Bài 3 **không phát triển thuật toán mới** và không tập trung vào việc xếp hạng MOSFOA với các thuật toán khác.

### 1.2. Câu hỏi nghiên cứu chính

> Khi quy mô công trình, tải trọng và điều kiện địa kỹ thuật thay đổi, các đặc trưng của hệ cọc tối ưu thay đổi như thế nào?

### 1.3. Mục tiêu

1. Tổng hợp kết quả tối ưu của hai công trình.
2. Xác định sự khác biệt về cấu hình hệ cọc tối ưu.
3. Phân tích mối liên hệ giữa quy mô, tải trọng, địa kỹ thuật và các biến thiết kế tối ưu.
4. Xác định các xu hướng thiết kế có thể rút ra từ hai công trình nghiên cứu.

---

# 2. MỞ ĐẦU

## 2.1. Bài toán thiết kế hệ cọc cầu tàu

- Hệ cọc chịu đồng thời tải trọng đứng và ngang.
- Thiết kế phải thỏa mãn điều kiện kết cấu và địa kỹ thuật.
- Tối ưu đa mục tiêu tạo ra nhiều phương án cân bằng giữa vật liệu và chuyển vị.

## 2.2. Sự phụ thuộc của nghiệm tối ưu vào điều kiện công trình

Nêu rằng nghiệm tối ưu không chỉ phụ thuộc vào thuật toán mà còn phụ thuộc vào:

- quy mô;
- tải trọng;
- đặc điểm nền đất;
- yêu cầu chuyển vị;
- khả năng chịu tải cọc.

## 2.3. Khoảng trống

Các nghiên cứu tối ưu thường tập trung vào tìm nghiệm tốt nhưng ít khai thác kết quả Pareto để rút ra ý nghĩa thiết kế khi điều kiện công trình thay đổi.

## 2.4. Mục tiêu nghiên cứu

Nêu rõ bài báo sử dụng hai case đã được tối ưu bằng MOSFOA để phân tích sự thay đổi của hệ cọc tối ưu.

---

# 3. CƠ SỞ DỮ LIỆU VÀ HAI CÔNG TRÌNH NGHIÊN CỨU

## 3.1. Công trình 1

Tóm tắt:

- quy mô;
- tải trọng;
- hệ kết cấu;
- hệ cọc;
- điều kiện địa kỹ thuật;
- không gian thiết kế.

## 3.2. Công trình 2

Trình bày tương tự.

## 3.3. Bảng đối chiếu hai công trình

| Nhóm yếu tố | Công trình 1 | Công trình 2 |
|---|---|---|
| Quy mô | ... | ... |
| Tải trọng | ... | ... |
| Kích thước kết cấu | ... | ... |
| Điều kiện địa kỹ thuật | ... | ... |
| Hệ cọc | ... | ... |
| Không gian thiết kế | ... | ... |

Mục đích là thiết lập cơ sở để giải thích sự khác biệt của nghiệm tối ưu.

---

# 4. PHƯƠNG PHÁP TỐI ƯU VÀ XỬ LÝ KẾT QUẢ

## 4.1. MOSFOA

Chỉ giới thiệu ngắn:

- MOSFOA được sử dụng để tìm mặt Pareto;
- cùng quy trình đánh giá FEM;
- cùng hàm mục tiêu và ràng buộc theo từng công trình.

Không trình bày lại quá trình phát triển thuật toán.

## 4.2. Hàm mục tiêu

Hai mục tiêu:

- khối lượng vật liệu;
- chuyển vị ngang cực đại.

## 4.3. Ràng buộc

- kết cấu;
- chuyển vị;
- địa kỹ thuật theo TCVN 10304:2025;
- các điều kiện thiết kế tương ứng.

## 4.4. Xác định tập nghiệm dùng cho phân tích

Từ kết quả MOSFOA:

- mặt Pareto;
- nghiệm tối ưu theo các mức đánh đổi;
- nghiệm đại diện;
- nghiệm có khối lượng nhỏ nhất;
- nghiệm có chuyển vị nhỏ nhất;
- nghiệm cân bằng nếu xác định được.

Không chỉ sử dụng một nghiệm duy nhất để kết luận.

---

# 5. PHƯƠNG PHÁP PHÂN TÍCH ẢNH HƯỞNG

## 5.1. So sánh trực tiếp hai công trình

So sánh:

- khối lượng tối ưu;
- chuyển vị;
- loại cọc;
- tiết diện;
- cấu hình hệ cọc;
- phạm vi mặt Pareto.

## 5.2. Ảnh hưởng của quy mô

Phân tích sự thay đổi của:

- kích thước kết cấu;
- số lượng/chiều dài cọc nếu có;
- tiết diện cọc;
- khối lượng vật liệu;
- chuyển vị.

Mục tiêu là xác định xu hướng thay đổi khi quy mô công trình khác nhau.

## 5.3. Ảnh hưởng của tải trọng

Phân tích mối liên hệ giữa:

- tải trọng đứng;
- tải trọng ngang;
- tác động khai thác;
- yêu cầu chuyển vị;

với:

- tiết diện cọc;
- vật liệu;
- cấu hình hệ cọc;
- vị trí nghiệm trên mặt Pareto.

## 5.4. Ảnh hưởng của điều kiện địa kỹ thuật

Phân tích:

- sức chịu tải cọc;
- đặc điểm các lớp đất;
- chiều sâu mũi cọc;
- khả năng huy động sức chịu tải;
- thay đổi lựa chọn tiết diện/cấu hình cọc.

Nhấn mạnh vai trò của ràng buộc địa kỹ thuật trong việc giới hạn miền nghiệm.

## 5.5. Quan hệ giữa ba nhóm yếu tố

Tổng hợp theo chuỗi:

> **Quy mô + tải trọng + địa kỹ thuật → yêu cầu chịu lực/chuyển vị → không gian nghiệm khả thi → cấu hình hệ cọc tối ưu.**

Không tách rời các yếu tố một cách tuyệt đối nếu dữ liệu hai công trình không cho phép xác định quan hệ nhân quả riêng biệt.

---

# 6. KẾT QUẢ VÀ THẢO LUẬN

## 6.1. So sánh mặt Pareto của hai công trình

Trình bày chung trên cùng hệ quy chiếu khi phù hợp.

Phân tích:

- vị trí;
- hình dạng;
- độ rộng;
- mức đánh đổi khối lượng – chuyển vị.

## 6.2. So sánh các nghiệm đại diện

Lập bảng:

| Đại lượng | Công trình 1 | Công trình 2 |
|---|---:|---:|
| Nghiệm khối lượng nhỏ nhất | ... | ... |
| Nghiệm chuyển vị nhỏ nhất | ... | ... |
| Nghiệm cân bằng | ... | ... |
| Khối lượng | ... | ... |
| Chuyển vị | ... | ... |
| Tiết diện cọc | ... | ... |
| Chiều dài cọc | ... | ... |

Chỉ sử dụng những biến thực sự có trong hai bài toán.

## 6.3. Ảnh hưởng của quy mô

- Trình bày kết quả định lượng.
- Hình/bảng thể hiện xu hướng.
- Giải thích cơ học kết cấu ở mức phù hợp.

## 6.4. Ảnh hưởng của tải trọng

- Liên hệ tải trọng với yêu cầu tiết diện và chuyển vị.
- Chỉ sử dụng các tải trọng thực sự khác nhau giữa hai case.

## 6.5. Ảnh hưởng của địa kỹ thuật

- So sánh sức chịu tải.
- So sánh chiều sâu/mũi cọc.
- Xác định vai trò của địa kỹ thuật trong việc loại bỏ các phương án không khả thi.
- Phân tích tác động lên nghiệm Pareto.

## 6.6. Tổng hợp xu hướng thiết kế

Từ hai công trình, xác định:

- xu hướng chung;
- điểm khác biệt;
- điều kiện làm thay đổi lựa chọn tiết diện/cọc;
- các đặc điểm có tính lặp lại trong hai case.

Phải phân biệt rõ:

> **xu hướng quan sát được từ hai case**

với

> **quy luật tổng quát cho mọi cầu tàu**.

Không được khái quát quá mức từ chỉ hai công trình.

---

# 7. THẢO LUẬN KỸ THUẬT

## 7.1. Vai trò của tối ưu đa mục tiêu

Giải thích tại sao không có một nghiệm duy nhất tối ưu đồng thời cả:

- khối lượng;
- chuyển vị.

## 7.2. Vai trò của ràng buộc địa kỹ thuật

Làm rõ:

- địa kỹ thuật có thể loại bỏ các phương án có tiết diện nhỏ;
- nghiệm tối ưu có thể bị chi phối bởi sức chịu tải;
- kết quả tối ưu không thể chỉ giải thích bằng điều kiện vật liệu.

## 7.3. Ý nghĩa đối với thiết kế

Rút ra các nhận xét kỹ thuật từ hai công trình:

- lựa chọn tiết diện;
- lựa chọn cấu hình cọc;
- cân bằng giữa vật liệu và chuyển vị;
- tầm quan trọng của việc đưa ràng buộc địa kỹ thuật vào bài toán tối ưu.

Không chuyển phần này thành hướng thiết kế mới hoặc đề xuất tiêu chuẩn mới.

---

# 8. KẾT LUẬN

Kết luận tập trung vào:

1. Quy mô công trình làm thay đổi yêu cầu và miền nghiệm tối ưu.
2. Tải trọng ảnh hưởng đến yêu cầu chịu lực và chuyển vị, từ đó ảnh hưởng đến cấu hình cọc.
3. Điều kiện địa kỹ thuật có vai trò quan trọng trong xác định nghiệm khả thi và nghiệm tối ưu.
4. Mặt Pareto cho phép lựa chọn phương án theo mức đánh đổi giữa khối lượng và chuyển vị.
5. Các xu hướng rút ra chỉ có giá trị trong phạm vi hai công trình nghiên cứu và cần được kiểm chứng thêm nếu muốn khái quát rộng hơn.

---

# 9. Điểm mới của bài 3

Điểm mới không nằm ở MOSFOA.

Điểm mới nằm ở:

> **Khai thác kết quả tối ưu đa mục tiêu của hai công trình thực để phân tích mối liên hệ giữa điều kiện công trình và cấu hình hệ cọc tối ưu, đặc biệt đối với quy mô, tải trọng và điều kiện địa kỹ thuật.**

---

# 10. Ranh giới với bài 1 và bài 2

### Bài 1

**Đối sánh MOFDA – MOSFOA.**

### Bài 2

**Kiểm chứng MOSFOA trên hai công trình.**

### Bài 3

**Phân tích ý nghĩa kỹ thuật của sự khác biệt giữa hai công trình.**

Không:

- phát triển thuật toán mới;
- so sánh thuật toán;
- chạy thêm một thuật toán khác;
- tạo một hướng nghiên cứu mới ngoài ba yếu tố quy mô – tải trọng – địa kỹ thuật.

---

# 11. Trình tự thực hiện

1. Hoàn thành kết quả tối ưu của hai case ở bài 2.
2. Chuẩn hóa dữ liệu đầu ra của hai case.
3. Xác định các nghiệm Pareto và nghiệm đại diện.
4. Lập bảng đối chiếu hai công trình.
5. Phân tích ảnh hưởng của quy mô.
6. Phân tích ảnh hưởng của tải trọng.
7. Phân tích ảnh hưởng của địa kỹ thuật.
8. Tổng hợp các xu hướng chung và khác biệt.
9. Viết kết luận trong phạm vi dữ liệu thực tế.

# CHỐT

Bài 3 = **2 công trình + kết quả MOSFOA đã có + phân tích kỹ thuật về quy mô, tải trọng và địa kỹ thuật → thay đổi của hệ cọc tối ưu.**

Không phát triển thuật toán.
Không so sánh thuật toán.
Không mở rộng sang các yếu tố ngoài ba nhóm yếu tố đã chốt.
