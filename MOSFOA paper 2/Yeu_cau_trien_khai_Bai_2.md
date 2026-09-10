# YÊU CẦU TRIỂN KHAI BÀI BÁO 2 – MOSFOA TỐI ƯU HỆ CỌC CẦU TÀU

> **Tài liệu gốc, thẩm quyền cao nhất** cho Bài báo 2. Lưu nguyên văn theo bản người dùng cung cấp. Mọi file khác trong thư mục (`Bai_2.md`, `Danh_gia_kha_thi_Bai_2.md`, `So_sanh_2_du_an_Cau_tau.md`, `FEM_*.md`) phải tuân theo và không được mâu thuẫn với tài liệu này. Nếu phát sinh mâu thuẫn giữa các file, **tài liệu này là căn cứ quyết định cuối cùng**.

## 1. BỐI CẢNH NGHIÊN CỨU

Bài báo này là Bài 2 trong chuỗi nghiên cứu về thuật toán MOSFOA và tối ưu kết cấu hạ tầng cảng biển.

Thuật toán MOSFOA đã được phát triển và công bố trong một bài báo Q3 trước đó. Vì vậy:

- MOSFOA KHÔNG phải nội dung cần phát triển mới trong bài này.
- Không đề xuất thuật toán mới.
- Không cải tiến MOSFOA.
- Không đưa thêm thuật toán tối ưu khác nếu không thực sự cần thiết.
- Không biến bài báo thành bài nghiên cứu phát triển thuật toán.

Mục tiêu của Bài 2 là:

> KIỂM CHỨNG KHẢ NĂNG ÁP DỤNG VÀ TÍNH ỔN ĐỊNH CỦA MOSFOA KHI GIẢI BÀI TOÁN TỐI ƯU ĐA MỤC TIÊU HỆ CỌC CẦU TÀU TRÊN HAI CÔNG TRÌNH THỰC TẾ CÓ QUY MÔ, TẢI TRỌNG VÀ ĐIỀU KIỆN ĐỊA KỸ THUẬT KHÁC NHAU.

Tên bài báo dự kiến:

"ỨNG DỤNG THUẬT TOÁN MOSFOA TỐI ƯU ĐA MỤC TIÊU HỆ CỌC CẦU TÀU: KIỂM CHỨNG TRÊN HAI CÔNG TRÌNH CÓ QUY MÔ VÀ ĐIỀU KIỆN ĐỊA KỸ THUẬT KHÁC NHAU"

---

# 2. HAI CÔNG TRÌNH NGHIÊN CỨU

## Công trình A

Cầu tàu container 100.000 DWT tại Cảng cửa ngõ quốc tế Hải Phòng – Lạch Huyện.

Đây là mô hình đã được sử dụng trong Bài 1.

Mô hình FEM đại diện cho một phân đoạn tiêu chuẩn khoảng 75 m của cầu tàu.

## Công trình B

Cầu tàu VIPGreenPort/Viconship 30.000 DWT tại Đình Vũ, Hải Phòng.

Mô hình SAP2000 hiện có đại diện cho một phân đoạn tiêu chuẩn dài khoảng 75,44 m.

Nguồn dữ liệu chi tiết của Công trình B nằm trong file:

FEM_CauTau_VIPGreenPort_30000DWT.md

Phải đọc và sử dụng chính xác dữ liệu trong file này, không tự suy diễn các thông số chưa được xác nhận.

Hai công trình đều là cầu tàu bệ cọc cao, sử dụng hệ dầm – bản BTCT trên nền cọc, nhưng khác đáng kể về quy mô, tàu thiết kế, tải trọng và điều kiện địa chất.

Đây chính là cơ sở để thực hiện kiểm chứng MOSFOA trên hai bài toán thực tế khác nhau.

---

# 3. NGUYÊN TẮC QUAN TRỌNG NHẤT: GIỮ NGUYÊN HAI MÔ HÌNH FEM

KHÔNG chuẩn hóa cưỡng bức hai mô hình FEM thành một mô hình giống nhau.

KHÔNG thay mô hình nền của Công trình B để giống Công trình A.

KHÔNG thay mô hình nền của Công trình A để giống Công trình B.

KHÔNG sửa mô hình FEM gốc chỉ nhằm làm cho hai công trình có cùng cách mô hình hóa.

Lý do:

Bài 2 nghiên cứu khả năng áp dụng MOSFOA trên hai công trình thực tế, không nghiên cứu ảnh hưởng của phương pháp mô hình hóa FEM.

Cần tôn trọng đặc điểm mô hình gốc của từng công trình.

Ví dụ Công trình B hiện sử dụng chiều dài ngàm ảo và ngàm cứng tại đáy cọc, trong khi Công trình A có cách mô hình hóa nền khác. Đây là đặc điểm của dữ liệu FEM gốc và phải được mô tả minh bạch.

Nếu cần chuẩn hóa, chỉ chuẩn hóa ở cấp độ:

- cấu trúc bài toán tối ưu;
- hàm mục tiêu;
- nguyên tắc xử lý ràng buộc;
- cách đánh giá kết quả;
- tiêu chuẩn kiểm tra được lựa chọn cho nghiên cứu.

Không được biến hai mô hình FEM thành hai mô hình nhân tạo giống nhau.

---

# 4. KIỂM TRA ĐỊA KỸ THUẬT

Phần ràng buộc địa kỹ thuật phải được xây dựng thống nhất về NGUYÊN TẮC cho hai công trình.

Sử dụng TCVN 10304:2025 cho phần kiểm tra sức chịu tải cọc nếu dữ liệu và phạm vi tiêu chuẩn cho phép.

Cần:

1. Kiểm tra/xác minh dữ liệu địa chất của Công trình A.
2. Kiểm tra dữ liệu địa chất Công trình B.
3. Tính sức chịu tải cọc theo cơ sở tiêu chuẩn được lựa chọn.
4. Không lấy máy móc các giá trị sức chịu tải từ hồ sơ thiết kế cũ làm ràng buộc tối ưu nếu chưa xác minh.
5. Ghi rõ trong bài rằng mô hình FEM phục vụ nghiên cứu tối ưu, không phải hồ sơ thiết kế thi công được cập nhật lại.

Lưu ý:

KHÔNG tự tạo ra thông số địa chất còn thiếu.

Nếu tài liệu không đủ để xác định một thông số thì phải đánh dấu là "chưa xác định/cần kiểm tra", không được tự điền bằng giá trị giả định mà không có cơ sở.

---

# 5. BIẾN THIẾT KẾ – KHÔNG ĐƯỢC MỞ RỘNG QUÁ MỨC

Trọng tâm của bài là:

> TỐI ƯU HỆ CỌC CẦU TÀU

Không biến thành tối ưu toàn bộ kết cấu cầu tàu.

Bộ biến thiết kế dự kiến ưu tiên:

- D_cọc: đường kính ngoài cọc;
- t_cọc: chiều dày thành cọc;
- các biến liên quan đến bố trí cọc nếu có thể áp dụng hợp lý cho cả hai công trình.

Chưa được tự động chốt sx, sy là biến thiết kế.

Giải thích:

- sx = khoảng cách cọc theo phương ngang bến;
- sy = khoảng cách cọc theo phương dọc bến.

Nhưng chỉ đưa sx/sy vào bài toán nếu sau khi kiểm tra trực tiếp hai mô hình FEM thấy rằng chúng có thể tham số hóa mà không làm phá vỡ cấu tạo thực tế của từng công trình.

KHÔNG đưa ngay kích thước dầm, bản mặt cầu, toàn bộ cấu kiện khác vào biến thiết kế.

Mục tiêu là sử dụng số lượng biến vừa đủ để:

- bài toán có ý nghĩa kỹ thuật;
- hai công trình có thể so sánh;
- số lượng tổ hợp không quá lớn;
- có khả năng chạy FEM–MATLAB nhiều lần.

Nếu hai công trình không thể có hoàn toàn cùng bộ biến, phải ưu tiên tính trung thực của mô hình thực tế thay vì ép hai công trình phải giống nhau.

---

# 6. HÀM MỤC TIÊU

Giữ bài toán MOO gồm 2 mục tiêu:

f1 = MIN khối lượng vật liệu hệ kết cấu/cọc thuộc phạm vi tối ưu.

f2 = MIN chuyển vị ngang cực đại của cầu tàu.

Không thêm mục tiêu thứ ba.

Không thêm chi phí kinh tế nếu chưa có dữ liệu đơn giá đáng tin cậy.

Không thêm phát thải carbon, thời gian thi công, số nhóm cọc... vì các nội dung này không thuộc phạm vi Bài 2.

---

# 7. RÀNG BUỘC

Các phương án thiết kế phải thỏa mãn:

- điều kiện chịu lực kết cấu;
- điều kiện chuyển vị;
- điều kiện sức chịu tải địa kỹ thuật;
- các giới hạn vật liệu và tiết diện;
- các điều kiện cần thiết khác theo mô hình và tiêu chuẩn áp dụng.

Phải kiểm tra các tổ hợp tải trọng cần thiết của từng công trình.

Không được bỏ qua các tải trọng đặc trưng của từng công trình chỉ để tạo ra hai bài toán giống nhau.

---

# 8. MATLAB – SAP2000

Sử dụng quy trình:

MOSFOA
   ↓
Sinh phương án thiết kế
   ↓
MATLAB
   ↓
Tham số hóa mô hình SAP2000
   ↓
SAP2000/FEM
   ↓
Phân tích kết cấu
   ↓
Đọc kết quả
   ↓
Kiểm tra ràng buộc
   ↓
Tính f1, f2
   ↓
MOSFOA tiếp tục tìm kiếm

Hai mô hình SAP2000 phải được giữ riêng.

Không gộp hai mô hình thành một mô hình chung.

---

# 9. THIẾT KẾ THÍ NGHIỆM

Mục tiêu là đánh giá MOSFOA trên hai bài toán:

CASE A = Lạch Huyện 100.000 DWT

CASE B = VIPGreenPort 30.000 DWT

Nếu khả thi:

- chạy nhiều lần độc lập cho mỗi case;
- sử dụng cùng nguyên tắc thiết lập MOSFOA;
- không thay đổi tham số MOSFOA theo kết quả để làm đẹp kết quả;
- ghi nhận sự ổn định của thuật toán.

Có thể sử dụng khoảng 20 lần chạy độc lập/case nếu chi phí tính toán cho phép.

Các chỉ tiêu đánh giá ưu tiên:

- IGD;
- HV;
- tỷ lệ nghiệm khả thi;
- độ ổn định giữa các lần chạy;
- Pareto front thu được.

Nếu không gian thiết kế đủ nhỏ thì có thể vét cạn để xây dựng Pareto tham chiếu.

Nếu không đủ nhỏ thì không được ép buộc phải vét cạn.

---

# 10. CÂU HỎI KHOA HỌC CỦA BÀI 2

Bài báo phải xoay quanh câu hỏi:

> MOSFOA có duy trì được khả năng tìm kiếm nghiệm Pareto và tính ổn định khi áp dụng cho các bài toán tối ưu hệ cọc cầu tàu thực tế có quy mô, tải trọng và điều kiện địa kỹ thuật khác nhau hay không?

Do đó kết quả cần trả lời:

1. MOSFOA có tìm được các nghiệm khả thi trên cả hai công trình không?
2. Pareto front có ổn định giữa các lần chạy không?
3. Chất lượng nghiệm giữa hai công trình có thay đổi như thế nào?
4. Đặc điểm nghiệm tối ưu của hai công trình khác nhau ra sao?

Chỉ cần phân tích ở mức này.

---

# 11. KHÔNG ĐƯỢC LÀM TRONG BÀI 2

Không:

- phát triển MOSFOA mới;
- đề xuất MOSFOA cải tiến;
- đưa thêm thuật toán mới;
- thực hiện nghiên cứu độ nhạy tham số MOSFOA;
- phân tích sâu ảnh hưởng riêng biệt của quy mô;
- phân tích sâu ảnh hưởng riêng biệt của tải trọng;
- phân tích sâu ảnh hưởng riêng biệt của địa chất;
- cố chứng minh một quy luật tổng quát từ chỉ hai công trình;
- biến bài báo thành nghiên cứu so sánh nhiều thuật toán;
- tối ưu toàn bộ kết cấu cầu tàu;
- thay đổi bản chất hai mô hình FEM gốc.

Các phân tích sâu về:

> quy mô – tải trọng – điều kiện địa kỹ thuật → ảnh hưởng đến nghiệm tối ưu

để dành cho BÀI 3.

---

# 12. CẤU TRÚC BÀI BÁO DỰ KIẾN

## 1. MỞ ĐẦU

- Bài toán thiết kế hệ cọc cầu tàu.
- Sự cần thiết của tối ưu đa mục tiêu.
- Hạn chế của việc chỉ kiểm chứng thuật toán trên một công trình.
- Giới thiệu MOSFOA như công cụ đã được phát triển trước đó.
- Khoảng trống nghiên cứu: cần kiểm chứng trên nhiều công trình thực tế.
- Mục tiêu và phạm vi nghiên cứu.

## 2. ĐỐI TƯỢNG VÀ MÔ HÌNH FEM

### 2.1. Công trình A – Lạch Huyện 100.000 DWT

### 2.2. Công trình B – VIPGreenPort 30.000 DWT

### 2.3. So sánh đặc điểm hai công trình

### 2.4. Mô hình FEM và điều kiện biên

Giữ nguyên đặc điểm riêng của từng mô hình.

### 2.5. MATLAB–SAP2000

## 3. XÂY DỰNG BÀI TOÁN TỐI ƯU

### 3.1. Biến thiết kế

Chốt sau khi kiểm tra khả năng tham số hóa thực tế.

### 3.2. Hàm mục tiêu

f1 – khối lượng.

f2 – chuyển vị ngang cực đại.

### 3.3. Ràng buộc kết cấu

### 3.4. Ràng buộc địa kỹ thuật

### 3.5. Xử lý phương án không khả thi

## 4. ÁP DỤNG MOSFOA

Chỉ trình bày ngắn gọn nguyên lý MOSFOA đã được công bố trước đó.

Không lặp lại toàn bộ phần phát triển thuật toán của bài Q3.

## 5. THIẾT KẾ THÍ NGHIỆM VÀ CHỈ TIÊU ĐÁNH GIÁ

- cấu hình MOSFOA;
- số lần chạy;
- số vòng lặp;
- số nghiệm/quần thể;
- ngân sách đánh giá FEM;
- cách xây dựng Pareto tham chiếu nếu có;
- IGD;
- HV;
- tỷ lệ nghiệm khả thi;
- độ ổn định.

## 6. KẾT QUẢ VÀ THẢO LUẬN

### 6.1. Đặc điểm hai bài toán

### 6.2. Kết quả Công trình A

### 6.3. Kết quả Công trình B

### 6.4. Độ ổn định của MOSFOA

### 6.5. So sánh đặc điểm nghiệm Pareto giữa hai công trình

### 6.6. Thảo luận

Tập trung vào khả năng áp dụng MOSFOA trên hai bài toán thực tế khác nhau.

Không chuyển sang phân tích độ nhạy sâu.

## 7. KẾT LUẬN

Khẳng định:

- MOSFOA giải được bài toán tối ưu trên cả hai công trình;
- mức độ ổn định;
- đặc điểm chung/khác của nghiệm;
- ý nghĩa của việc kiểm chứng trên hai công trình.

Không tuyên bố MOSFOA là thuật toán tối ưu tốt nhất nói chung.

Chỉ kết luận trong phạm vi các bài toán nghiên cứu.

---

# 13. NGUYÊN TẮC KHI TRIỂN KHAI

Ưu tiên:

1. Tính đúng dữ liệu thực tế.
2. Giữ nguyên bản chất mô hình FEM.
3. Bộ biến tối ưu gọn.
4. Bài toán MOO rõ ràng.
5. Kết quả có thể tái lập.
6. Không mở rộng phạm vi nghiên cứu.

Nếu phát hiện một vấn đề dữ liệu chưa đủ hoặc mâu thuẫn:

> KHÔNG TỰ Ý SỬA VÀ KHÔNG TỰ ĐẶT GIẢ ĐỊNH.

Hãy đánh dấu vấn đề, nêu dữ liệu nào cần xác minh và chờ quyết định.

Đặc biệt, trước khi viết chính thức hoặc chạy tối ưu, cần xác định chắc chắn:

- bộ biến thiết kế cuối cùng;
- miền giá trị từng biến;
- cách tham số hóa hai mô hình SAP;
- các ràng buộc;
- dữ liệu địa chất;
- cách tính sức chịu tải cọc;
- khả năng xây dựng Pareto tham chiếu.

## MỤC TIÊU CUỐI CÙNG

Tạo một bài báo có thông điệp rất rõ:

> MOSFOA không chỉ được kiểm chứng trên một bài toán cầu tàu đơn lẻ mà còn được áp dụng thành công và ổn định trên hai công trình thực tế có quy mô, tải trọng và điều kiện địa kỹ thuật khác nhau.

Giữ bài báo GỌN – CHẶT – ĐÚNG PHẠM VI.

KHÔNG MỞ RỘNG SANG BÀI 3.
