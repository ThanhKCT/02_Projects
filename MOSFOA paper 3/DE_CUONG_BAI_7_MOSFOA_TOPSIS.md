# ĐỀ CƯƠNG BÀI BÁO 7

## Lựa chọn phương án kết cấu tối ưu từ tập nghiệm Pareto của MOSFOA bằng phương pháp TOPSIS

---

## 1. Định hướng và vai trò của bài báo

### 1.1. Vai trò trong chuỗi công bố

Bài báo này là một bài ứng dụng tiếp theo trong hệ thống nghiên cứu MOSFOA, với mục tiêu **không phát triển lại thuật toán MOSFOA**, mà tập trung vào bước ra quyết định sau tối ưu.

Chuỗi nghiên cứu được định hướng:

- **Bài Q3 đã công bố:** phát triển và kiểm chứng thuật toán MOSFOA.
- **Bài 5:** đối sánh MOFDA và MOSFOA trên bài toán kết cấu cầu tàu.
- **Bài 6:** kiểm chứng khả năng áp dụng/generalization của MOSFOA trên các công trình có đặc điểm khác nhau.
- **Bài 7:** sử dụng MOSFOA để tạo tập nghiệm Pareto, sau đó sử dụng TOPSIS để lựa chọn phương án phù hợp nhất từ tập nghiệm Pareto.

Logic của bài:

> **MOO giải quyết bài toán "tìm các phương án không trội"; MCDM giải quyết bài toán "chọn phương án phù hợp nhất".**

### 1.2. Đối tượng nghiên cứu

Sử dụng **dự án Chân Mây 70.000 DWT giảm tải** làm case study.

Không xem bài này là bài phát triển MOSFOA và không lặp lại phần benchmark thuật toán của công bố Q3.

---

# 2. Tên bài báo

### Tên khuyến nghị

> **LỰA CHỌN PHƯƠNG ÁN KẾT CẤU TỐI ƯU TỪ TẬP NGHIỆM PARETO CỦA MOSFOA BẰNG PHƯƠNG PHÁP TOPSIS**

### Tên tiếng Anh tham khảo

> **Selection of an Optimal Structural Design from the MOSFOA Pareto Set Using the TOPSIS Multi-Criteria Decision-Making Method**

---

# 3. Đặt vấn đề

## 3.1. Bối cảnh nghiên cứu

Trình bày:

- kết cấu cầu tàu phải đồng thời đáp ứng nhiều yêu cầu về khả năng chịu lực, chuyển vị và hiệu quả sử dụng vật liệu;
- bài toán tối ưu đa mục tiêu thường không cho một nghiệm duy nhất mà tạo ra một tập nghiệm Pareto;
- trong thực tế thiết kế, kỹ sư vẫn cần lựa chọn một phương án cuối cùng để áp dụng;
- do đó cần kết hợp tối ưu đa mục tiêu với phương pháp ra quyết định đa tiêu chí.

## 3.2. Khoảng trống nghiên cứu

> Các thuật toán MOO có thể xác định tập nghiệm Pareto, nhưng bản thân tập nghiệm Pareto chưa trực tiếp trả lời câu hỏi phương án nào nên được lựa chọn khi có nhiều tiêu chí kỹ thuật đồng thời.

Từ đó hình thành quy trình:

```text
Mô hình FEM 3D
      ↓
MOSFOA
      ↓
Tập nghiệm Pareto
      ↓
MCDM – TOPSIS
      ↓
Xếp hạng phương án
      ↓
Phương án khuyến nghị
```

## 3.3. Mục tiêu nghiên cứu

1. Sử dụng MOSFOA để xác định tập nghiệm Pareto cho bài toán tối ưu kết cấu cầu tàu.
2. Áp dụng TOPSIS để xếp hạng các nghiệm Pareto theo các tiêu chí kỹ thuật.
3. Phân tích độ ổn định của phương án được lựa chọn khi thay đổi trọng số các tiêu chí.

---

# 4. Công trình và mô hình nghiên cứu

## 4.1. Công trình Chân Mây 70.000 DWT

Giới thiệu ngắn gọn:

- công trình hiện hữu;
- quy mô và đặc điểm chính;
- hệ kết cấu bến;
- hệ cọc;
- các cấu kiện chủ yếu;
- điều kiện khai thác tàu 70.000 DWT giảm tải.

**Lưu ý:** không trình bày theo hướng thiết kế mới một bến 70.000 DWT. Bài toán là tối ưu/đánh giá cấu hình kết cấu hiện hữu dưới kịch bản khai thác nghiên cứu.

## 4.2. Mô hình phần tử hữu hạn 3D

Trình bày:

- mô hình SAP2000 3D;
- nút và phần tử;
- frame;
- shell;
- cọc;
- liên kết;
- điều kiện biên;
- mô hình tương tác đất – kết cấu nếu sử dụng.

## 4.3. Kiểm chứng mô hình

Kiểm tra các nội dung cần thiết:

- tải trọng;
- nội lực;
- chuyển vị;
- phản lực;
- tính hợp lý của mô hình.

Không mở rộng thành một bài kiểm định FEM độc lập.

---

# 5. Xây dựng bài toán tối ưu đa mục tiêu

## 5.1. Biến thiết kế

Xây dựng vector biến thiết kế:

\[
\mathbf{x}=[x_1,x_2,\ldots,x_n]
\]

Có thể lựa chọn khoảng **4–6 biến**, tùy cấu hình Chân Mây và tính khả thi của mô hình.

Các biến có thể gồm:

- đường kính cọc;
- chiều dày cọc;
- khoảng cách cọc;
- góc nghiêng cọc;
- các kích thước tiết diện chủ đạo.

Các miền biến phải được xác định dựa trên cấu hình thực tế và yêu cầu cấu tạo.

## 5.2. Hàm mục tiêu

Nên giữ hai mục tiêu chính:

### Mục tiêu 1 – tối thiểu khối lượng

\[
\min f_1(\mathbf{x})=W(\mathbf{x})
\]

### Mục tiêu 2 – tối thiểu chuyển vị

\[
\min f_2(\mathbf{x})=U_{max}(\mathbf{x})
\]

Ý nghĩa:

> giảm khối lượng vật liệu ↔ tăng độ mềm/chuyển vị.

Không nên đưa quá nhiều mục tiêu nếu không thực sự cần thiết.

## 5.3. Ràng buộc

Dạng tổng quát:

\[
g_i(\mathbf{x})\leq0
\]

Bao gồm:

### Ràng buộc cường độ

- ứng suất;
- lực dọc;
- lực cắt;
- moment;
- hệ số sử dụng.

### Ràng buộc chuyển vị

\[
U_{max}\leq U_{allow}
\]

### Ràng buộc cấu tạo

- giới hạn đường kính;
- giới hạn chiều dày;
- khoảng cách;
- góc cọc;
- các yêu cầu cấu tạo liên quan.

### Ràng buộc biến thiết kế

\[
x_i^{min}\leq x_i\leq x_i^{max}
\]

---

# 6. Tối ưu bằng MOSFOA

## 6.1. Giới thiệu MOSFOA

Chỉ giới thiệu ngắn gọn MOSFOA và **dẫn chiếu đến bài Q3 đã công bố**, nơi thuật toán được phát triển và kiểm chứng.

Không lặp lại:

- quá trình phát triển thuật toán;
- benchmark toán học;
- toàn bộ giả mã;
- các phân tích đã công bố trong bài Q3.

## 6.2. Liên kết MATLAB – SAP2000

```text
Khởi tạo quần thể
       ↓
MOSFOA tạo biến thiết kế
       ↓
MATLAB
       ↓
SAP2000 API
       ↓
Phân tích FEM 3D
       ↓
Khối lượng + chuyển vị + chỉ tiêu ràng buộc
       ↓
MOSFOA cập nhật quần thể
       ↓
Lặp đến điều kiện dừng
       ↓
Tập nghiệm Pareto
```

## 6.3. Kết quả đầu ra của MOSFOA

Thu thập:

- số lượng nghiệm Pareto;
- Pareto front;
- giá trị các hàm mục tiêu;
- biến thiết kế;
- hệ số sử dụng;
- chuyển vị;
- các chỉ tiêu kỹ thuật cần thiết.

---

# 7. Lựa chọn nghiệm Pareto bằng TOPSIS

## 7.1. Vai trò của TOPSIS

MOSFOA cung cấp:

> **tập nghiệm Pareto**

TOPSIS thực hiện:

> **xếp hạng các nghiệm Pareto để hỗ trợ lựa chọn phương án.**

Đây là phần phương pháp mới của bài báo.

## 7.2. Xác định tiêu chí MCDM

Đề xuất sử dụng 3 tiêu chí chính:

| Ký hiệu | Tiêu chí | Xu hướng |
|---|---|---|
| C1 | Khối lượng kết cấu | Min |
| C2 | Chuyển vị lớn nhất | Min |
| C3 | Hệ số sử dụng lớn nhất | Min |

Nếu chi phí vật liệu được tính hoàn toàn tuyến tính từ khối lượng thì **không đưa đồng thời chi phí và khối lượng** để tránh trùng thông tin.

## 7.3. Ma trận quyết định

Từ tập nghiệm Pareto:

\[
X=[x_{ij}]
\]

Trong đó:

- hàng \(i\): nghiệm Pareto thứ \(i\);
- cột \(j\): tiêu chí thứ \(j\).

## 7.4. Chuẩn hóa

Sử dụng phương pháp chuẩn hóa phù hợp với TOPSIS.

Ví dụ:

\[
r_{ij}=\frac{x_{ij}}{\sqrt{\sum_{i=1}^{m}x_{ij}^{2}}}
\]

## 7.5. Gán trọng số

\[
v_{ij}=w_jr_{ij}
\]

với:

\[
\sum_{j=1}^{n}w_j=1
\]

Trọng số phải được giải thích theo cơ sở kỹ thuật hoặc kịch bản quyết định, không chọn tùy tiện.

## 7.6. Xác định nghiệm lý tưởng và phản lý tưởng

Xác định:

\[
A^+
\]

và:

\[
A^-
\]

## 7.7. Tính khoảng cách

\[
S_i^+
\]

và:

\[
S_i^-
\]

## 7.8. Tính hệ số gần nghiệm lý tưởng

\[
C_i=\frac{S_i^-}{S_i^++S_i^-}
\]

Nghiệm có \(C_i\) lớn hơn được xếp hạng cao hơn.

---

# 8. Phân tích độ nhạy trọng số

## 8.1. Mục đích

Kiểm tra:

> phương án được lựa chọn có ổn định khi quan điểm ưu tiên giữa khối lượng, chuyển vị và khả năng chịu lực thay đổi hay không?

## 8.2. Các kịch bản

Có thể xây dựng 3–5 kịch bản trọng số.

Ví dụ:

### W1 – ưu tiên vật liệu

\[
w_M=0.5,\quad w_U=0.3,\quad w_R=0.2
\]

### W2 – ưu tiên chuyển vị

\[
w_M=0.3,\quad w_U=0.5,\quad w_R=0.2
\]

### W3 – ưu tiên an toàn

\[
w_M=0.3,\quad w_U=0.3,\quad w_R=0.4
\]

Các trọng số cuối cùng cần được lựa chọn phù hợp với bài toán và giải thích trong bài.

## 8.3. Phân tích ổn định thứ hạng

Đánh giá:

- phương án đứng thứ nhất;
- các phương án thường xuyên nằm trong nhóm đầu;
- sự thay đổi thứ hạng khi thay đổi trọng số;
- phương án có tính ổn định cao.

---

# 9. Xác định phương án khuyến nghị

Không nên chỉ kết luận:

> "TOPSIS chọn phương án có thứ hạng 1."

Nên xây dựng quy trình:

```text
Tập nghiệm Pareto
       ↓
TOPSIS ranking
       ↓
Phân tích độ nhạy trọng số
       ↓
Nhóm phương án ổn định
       ↓
Kiểm tra điều kiện kỹ thuật
       ↓
Phương án khuyến nghị
```

Phương án khuyến nghị cần:

- thuộc tập Pareto;
- đáp ứng đầy đủ ràng buộc;
- có thứ hạng TOPSIS cao;
- có độ ổn định tốt khi thay đổi trọng số;
- có cấu hình kỹ thuật hợp lý.

---

# 10. Kết quả và thảo luận

## 10.1. Kết quả hội tụ MOSFOA

Trình bày:

- đường hội tụ;
- số vòng lặp;
- tính ổn định;
- số nghiệm Pareto cuối cùng.

## 10.2. Pareto front

Phân tích quan hệ đánh đổi:

> khối lượng ↔ chuyển vị.

Xác định các vùng:

- phương án thiên về tiết kiệm vật liệu;
- phương án thiên về độ cứng;
- vùng cân bằng.

## 10.3. Kết quả TOPSIS

Bảng đề xuất:

| PA | Khối lượng | Chuyển vị | Hệ số sử dụng | \(C_i\) | Thứ hạng |
|---|---:|---:|---:|---:|---:|
| PA1 | ... | ... | ... | ... | ... |
| PA2 | ... | ... | ... | ... | ... |
| ... | ... | ... | ... | ... | ... |

## 10.4. Độ nhạy trọng số

Bảng:

| Phương án | W1 | W2 | W3 | Độ ổn định |
|---|---:|---:|---:|---|
| PA... | 1 | 2 | 1 | Cao |
| PA... | 2 | 1 | 3 | Trung bình |
| ... | ... | ... | ... | ... |

## 10.5. So sánh với hiện trạng

| Chỉ tiêu | Hiện trạng | Phương án Pareto đại diện | Phương án TOPSIS |
|---|---:|---:|---:|
| Khối lượng | ... | ... | ... |
| Chuyển vị | ... | ... | ... |
| Hệ số sử dụng | ... | ... | ... |
| Biến thiết kế | ... | ... | ... |

Mục tiêu là làm rõ phương án được lựa chọn cải thiện gì so với cấu hình hiện hữu và phải đánh đổi điều gì.

---

# 11. Kết luận

Kết luận tập trung vào 3 nội dung:

1. MOSFOA xác định được tập nghiệm Pareto thỏa mãn các yêu cầu của bài toán.
2. TOPSIS cho phép xếp hạng và lựa chọn một phương án từ tập nghiệm Pareto.
3. Phân tích độ nhạy cho thấy mức độ ổn định của phương án được lựa chọn trước sự thay đổi trọng số.

Không tuyên bố quá rộng rằng MOSFOA–TOPSIS phù hợp với mọi loại công trình.

---

# 12. Đóng góp khoa học dự kiến

### Đóng góp 1

Xây dựng quy trình hai tầng:

> **MOSFOA → Pareto → TOPSIS**

cho bài toán tối ưu kết cấu cầu tàu dựa trên mô hình FEM 3D.

### Đóng góp 2

Chuyển tập nghiệm Pareto thành **thứ hạng phương án**, qua đó hỗ trợ lựa chọn một phương án kỹ thuật cụ thể thay vì chỉ báo cáo Pareto front.

### Đóng góp 3

Đánh giá **độ ổn định của phương án được lựa chọn** khi thay đổi trọng số các tiêu chí.

---

# 13. Phân biệt với các công bố khác

## So với bài Q3

- Q3: phát triển và kiểm chứng MOSFOA.
- Bài 7: sử dụng MOSFOA như thuật toán đã được công bố và tập trung vào MCDM.

## So với Bài 5

- Bài 5: so sánh MOFDA và MOSFOA.
- Bài 7: không thực hiện đối sánh thuật toán.

## So với Bài 6

- Bài 6: kiểm chứng khả năng áp dụng MOSFOA trên nhiều bài toán/công trình.
- Bài 7: tập trung vào **bước lựa chọn nghiệm sau tối ưu** và độ ổn định của quyết định.

## Nguyên tắc chống trùng lặp

Không sao chép:

- bảng Pareto;
- bảng biến thiết kế;
- biểu đồ hội tụ;
- kết quả benchmark;
- phân tích thuật toán

đã công bố trong các bài trước nếu không cần thiết.

Nếu sử dụng lại kết quả hoặc dữ liệu đã công bố, phải xác định rõ nguồn và mục đích sử dụng, đồng thời bảo đảm bài mới có câu hỏi nghiên cứu và phân tích mới.

---

# 14. Hình và bảng dự kiến

## Hình

**Hình 1.** Quy trình FEM 3D – MOSFOA – TOPSIS.

**Hình 2.** Mô hình FEM 3D Chân Mây.

**Hình 3.** Sơ đồ biến thiết kế và ràng buộc.

**Hình 4.** Quá trình hội tụ MOSFOA.

**Hình 5.** Pareto front khối lượng – chuyển vị.

**Hình 6.** Phân bố/đặc trưng các nghiệm Pareto.

**Hình 7.** Thứ hạng TOPSIS.

**Hình 8.** Độ nhạy của thứ hạng theo trọng số.

**Hình 9.** So sánh hiện trạng và phương án TOPSIS.

## Bảng

**Bảng 1.** Thông số mô hình FEM.

**Bảng 2.** Biến thiết kế và miền biến.

**Bảng 3.** Hàm mục tiêu và ràng buộc.

**Bảng 4.** Các tiêu chí MCDM.

**Bảng 5.** Tập nghiệm Pareto.

**Bảng 6.** Kết quả TOPSIS.

**Bảng 7.** Phân tích độ nhạy trọng số.

**Bảng 8.** So sánh hiện trạng – Pareto – TOPSIS.

---

# 15. Thông điệp trung tâm của bài

Bài báo cần giữ một thông điệp đơn giản:

> **MOSFOA tìm ra "các phương án tốt"; TOPSIS hỗ trợ trả lời "nên chọn phương án nào".**

Do đó cấu trúc phương pháp của bài là:

\[
\boxed{
FEM\ 3D
\rightarrow
MOSFOA
\rightarrow
Pareto\ Set
\rightarrow
TOPSIS
\rightarrow
Recommended\ Design
}
\]

Đây là điểm khác biệt cốt lõi của Bài 7 so với các bài nghiên cứu trước trong chuỗi công bố MOSFOA.
