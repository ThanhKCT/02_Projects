# ĐỀ CƯƠNG BÀI BÁO 7 – PHIÊN BẢN ĐIỀU CHỈNH

## LỰA CHỌN PHƯƠNG ÁN KẾT CẤU TỪ TẬP NGHIỆM PARETO CỦA MOSFOA BẰNG PHƯƠNG PHÁP TOPSIS

---

## 1. Định hướng nghiên cứu

### 1.1. Vai trò của Bài 7 trong chuỗi công bố MOSFOA

Bài 7 **không sử dụng dự án Chân Mây** và **không xây dựng một bài toán tối ưu MOSFOA mới**.

Dữ liệu đầu vào của Bài 7 là các kết quả Pareto đã thu được trong:

- **Bài 5:** đối sánh MOFDA và MOSFOA;
- **Bài 6:** ứng dụng/kiểm chứng MOSFOA trên các công trình nghiên cứu đã lựa chọn.

Bài 7 khai thác một vấn đề khác:

> Khi MOSFOA đã tạo ra nhiều nghiệm Pareto, làm thế nào lựa chọn một phương án kết cấu phù hợp nhất khi đồng thời xem xét nhiều tiêu chí kỹ thuật?

Do đó:

> **MOSFOA = tìm kiếm tập nghiệm Pareto.**

> **TOPSIS = xếp hạng và hỗ trợ lựa chọn nghiệm từ tập Pareto.**

Bài 7 tập trung vào **ra quyết định đa tiêu chí sau tối ưu**, không lặp lại việc chứng minh hiệu quả của MOSFOA.

### 1.2. Đối tượng nghiên cứu

Sử dụng **các kết quả của Bài 5 và Bài 6** làm dữ liệu đầu vào.

Không xem Bài 7 là bài phát triển MOSFOA và không lặp lại phần benchmark/đối sánh thuật toán của các công bố trước.

---

# 2. Tên bài báo

### Tên khuyến nghị

> **LỰA CHỌN PHƯƠNG ÁN KẾT CẤU TỪ TẬP NGHIỆM PARETO CỦA MOSFOA BẰNG PHƯƠNG PHÁP TOPSIS**

### Tên tiếng Anh tham khảo

> **Selection of Structural Design Alternatives from the MOSFOA Pareto Set Using the TOPSIS Multi-Criteria Decision-Making Method**

---

# 3. Câu hỏi nghiên cứu

### RQ1

Trong tập nghiệm Pareto do MOSFOA cung cấp, các phương án được xếp hạng như thế nào khi đồng thời xét nhiều tiêu chí kỹ thuật?

### RQ2

Phương án được lựa chọn có thay đổi khi thay đổi mức độ ưu tiên giữa các tiêu chí hay không?

### RQ3

Có thể xác định một nhóm phương án có tính ổn định cao để hỗ trợ quyết định kỹ thuật hay không?

**Không đặt lại câu hỏi "MOSFOA có tốt hơn MOFDA không?"** vì đây là nội dung của Bài 5.

**Không đặt lại câu hỏi "MOSFOA có tổng quát trên nhiều công trình không?"** vì đây là nội dung của Bài 6.

---

# 4. Dữ liệu nghiên cứu

## 4.1. Nguồn dữ liệu

Sử dụng các nghiệm Pareto được tạo ra từ các nghiên cứu trong Bài 5 và Bài 6.

Cần lập bảng nguồn dữ liệu:

| Nguồn | Công trình/case | Thuật toán | Dữ liệu sử dụng trong Bài 7 |
|---|---|---|---|
| Bài 5 | Case của Bài 5 | MOSFOA | Tập nghiệm Pareto |
| Bài 6 | Case 1 | MOSFOA | Tập nghiệm Pareto |
| Bài 6 | Case 2 | MOSFOA | Tập nghiệm Pareto |

**Chỉ sử dụng các dữ liệu cần thiết cho phân tích MCDM.**

Không sao chép toàn bộ nội dung kết quả của Bài 5 và Bài 6.

## 4.2. Nguyên tắc sử dụng lại kết quả

Các nghiệm Pareto của Bài 5–6 là **dữ liệu đầu vào** cho phân tích mới.

Bài 7 phải làm rõ:

> Kết quả mới không phải là một Pareto front mới, mà là **kết quả xếp hạng và lựa chọn phương án bằng MCDM**.

Nếu sử dụng số liệu đã công bố, phải dẫn chiếu rõ nguồn Bài 5/Bài 6 và bảo đảm tuân thủ yêu cầu của tạp chí về dữ liệu/kết quả đã công bố.

---

# 5. Không gộp trực tiếp các công trình khác quy mô

Đây là vấn đề phương pháp luận quan trọng.

**Không được lấy toàn bộ nghiệm của các công trình khác quy mô rồi coi chúng là các phương án cạnh tranh trực tiếp**, nếu các giá trị tuyệt đối về khối lượng, chuyển vị hoặc các chỉ tiêu kết cấu không cùng ý nghĩa.

### Hướng khuyến nghị

Thực hiện TOPSIS **riêng cho từng công trình/case**, sau đó so sánh:

- phương án TOPSIS của từng case;
- mức độ ổn định;
- xu hướng trọng số;
- đặc điểm phương án được lựa chọn.

Sơ đồ:

```text
Bài 5 – Case A
      ↓
Pareto Set A
      ↓
    TOPSIS
      ↓
Ranking A
      ↓
Recommended A

Bài 6 – Case B
      ↓
Pareto Set B
      ↓
    TOPSIS
      ↓
Ranking B
      ↓
Recommended B
```

Nếu Bài 6 có hai case thì thực hiện tương tự.

### Không khuyến nghị

Không gộp tất cả nghiệm của các công trình thành một Pareto/MCDM chung nếu chưa có cơ sở chuẩn hóa và so sánh liên công trình đủ chặt chẽ.

---

# 6. Các tiêu chí MCDM

Bài 7 sử dụng các tiêu chí đã có trong kết quả Bài 5–6.

Ưu tiên giữ:

| Ký hiệu | Tiêu chí | Xu hướng |
|---|---|---|
| C1 | Khối lượng kết cấu | Min |
| C2 | Chuyển vị lớn nhất | Min |
| C3 | Hệ số sử dụng lớn nhất | Min |

Nếu Bài 5–6 không có đầy đủ C3 thì **không tự tạo dữ liệu**; chỉ sử dụng các tiêu chí thực sự có trong dữ liệu nguồn.

## Lưu ý về chi phí

Không đưa đồng thời khối lượng và chi phí vật liệu nếu chi phí chỉ được tính tuyến tính từ khối lượng, vì hai tiêu chí gần như chứa cùng thông tin và có thể gây đếm trọng số hai lần.

---

# 7. Quy trình nghiên cứu

```text
Kết quả Bài 5 + Bài 6
          ↓
   Thu thập nghiệm Pareto
          ↓
  Lọc nghiệm hợp lệ
          ↓
 Chuẩn hóa dữ liệu từng case
          ↓
      Xây dựng ma trận
        quyết định
          ↓
       Gán trọng số
          ↓
        TOPSIS
          ↓
    Xếp hạng phương án
          ↓
 Phân tích độ nhạy trọng số
          ↓
Xác định phương án ổn định
          ↓
  Khuyến nghị kỹ thuật
```

---

# 8. Phương pháp TOPSIS

## 8.1. Ma trận quyết định

Với mỗi case:

\[
X=[x_{ij}]
\]

Trong đó:

- \(i\): nghiệm Pareto;
- \(j\): tiêu chí MCDM.

## 8.2. Chuẩn hóa

Sử dụng phương pháp chuẩn hóa phù hợp với TOPSIS:

\[
r_{ij}=\frac{x_{ij}}{\sqrt{\sum_{i=1}^{m}x_{ij}^{2}}}
\]

Cần thống nhất cách xử lý tiêu chí Min/Max và nêu rõ trong bài.

## 8.3. Gán trọng số

\[
v_{ij}=w_jr_{ij}
\]

với:

\[
\sum_{j=1}^{n}w_j=1
\]

Trọng số phải có cơ sở giải thích, chẳng hạn:

- ưu tiên kinh tế;
- ưu tiên độ cứng;
- ưu tiên khả năng chịu lực;
- kịch bản cân bằng.

## 8.4. Nghiệm lý tưởng và phản lý tưởng

Xác định:

\[
A^+
\]

và:

\[
A^-
\]

theo đặc tính của từng tiêu chí.

## 8.5. Khoảng cách đến nghiệm lý tưởng

Tính:

\[
S_i^+
\]

và:

\[
S_i^-
\]

## 8.6. Hệ số gần nghiệm lý tưởng

\[
C_i=\frac{S_i^-}{S_i^++S_i^-}
\]

Phương án có \(C_i\) lớn hơn được xếp hạng cao hơn.

---

# 9. Thiết kế các kịch bản trọng số

Nên sử dụng một số kịch bản rõ ràng thay vì tùy ý thay đổi trọng số.

Ví dụ với 3 tiêu chí:

### Kịch bản W1 – ưu tiên khối lượng

\[
w_M=0.5,\quad w_U=0.3,\quad w_R=0.2
\]

### Kịch bản W2 – ưu tiên chuyển vị

\[
w_M=0.3,\quad w_U=0.5,\quad w_R=0.2
\]

### Kịch bản W3 – ưu tiên khả năng chịu lực

\[
w_M=0.3,\quad w_U=0.3,\quad w_R=0.4
\]

### Kịch bản W4 – cân bằng

\[
w_M=w_U=w_R=\frac{1}{3}
\]

Các trọng số cuối cùng phải được điều chỉnh theo đúng dữ liệu và đặc điểm bài toán Bài 5–6.

---

# 10. Phân tích độ nhạy và độ ổn định

Đây là nội dung quan trọng để tạo giá trị mới cho Bài 7.

## 10.1. Xác định thứ hạng

Với mỗi kịch bản:

- tính \(C_i\);
- xếp hạng toàn bộ nghiệm Pareto;
- xác định nghiệm đứng đầu.

## 10.2. Phân tích thay đổi thứ hạng

Lập bảng:

| Phương án | W1 | W2 | W3 | W4 | Mức ổn định |
|---|---:|---:|---:|---:|---|
| PA1 | 1 | 2 | 1 | 1 | Cao |
| PA2 | 2 | 1 | 3 | 2 | Trung bình |
| PA3 | 3 | 4 | 2 | 3 | Thấp |

## 10.3. Phương án ổn định

Một phương án được xem xét là ứng viên khuyến nghị nếu:

- thường xuyên nằm trong nhóm xếp hạng cao;
- không nhạy quá mức với thay đổi trọng số;
- vẫn đáp ứng đầy đủ các ràng buộc kỹ thuật;
- nằm trong tập nghiệm Pareto.

---

# 11. Lựa chọn phương án cuối cùng

Không nên đồng nhất:

> **TOPSIS rank 1 = phương án cuối cùng trong mọi trường hợp.**

Nên sử dụng quy trình:

```text
TOPSIS ranking
      ↓
Sensitivity analysis
      ↓
Stable candidates
      ↓
Technical screening
      ↓
Recommended design
```

Phương án khuyến nghị cần được kiểm tra lại:

- khả năng chịu lực;
- chuyển vị;
- hệ số sử dụng;
- tính hợp lý của biến thiết kế;
- khả năng áp dụng thực tế.

---

# 12. So sánh với phương án hiện hữu

Nếu Bài 5–6 có dữ liệu hiện trạng, sử dụng phương án hiện trạng làm **mốc tham chiếu**, không nhất thiết đưa hiện trạng vào TOPSIS nếu nó không thuộc tập nghiệm Pareto.

| Chỉ tiêu | Hiện trạng | Phương án TOPSIS |
|---|---:|---:|
| Khối lượng | ... | ... |
| Chuyển vị | ... | ... |
| Hệ số sử dụng | ... | ... |
| Biến thiết kế | ... | ... |

Mục đích là đánh giá ý nghĩa kỹ thuật của phương án được lựa chọn.

---

# 13. Kết quả và thảo luận

## 13.1. Đặc điểm tập nghiệm Pareto

Chỉ mô tả ngắn gọn để làm cơ sở cho MCDM.

Không lặp lại toàn bộ phân tích Pareto của Bài 5–6.

## 13.2. Kết quả TOPSIS

Trình bày:

- ma trận chuẩn hóa;
- trọng số;
- hệ số \(C_i\);
- thứ hạng.

## 13.3. Ảnh hưởng của trọng số

Phân tích:

- khi ưu tiên kinh tế, phương án nào được lựa chọn;
- khi ưu tiên chuyển vị, phương án nào được lựa chọn;
- khi ưu tiên khả năng chịu lực, phương án nào được lựa chọn.

## 13.4. Độ ổn định của phương án

Xác định phương án hoặc nhóm phương án có thứ hạng ổn định.

## 13.5. So sánh giữa các case

Nếu sử dụng kết quả của nhiều công trình:

- không so sánh trực tiếp các giá trị tuyệt đối nếu không có cơ sở;
- tập trung so sánh **xu hướng lựa chọn và độ ổn định**.

---

# 14. Đóng góp khoa học dự kiến

### Đóng góp 1

Đề xuất quy trình:

\[
\boxed{MOSFOA\rightarrow Pareto\ Set\rightarrow TOPSIS\rightarrow Recommended\ Design}
\]

cho bài toán lựa chọn phương án kết cấu.

### Đóng góp 2

Chuyển tập nghiệm Pareto thành một **thứ hạng phương án có thể sử dụng trong quyết định kỹ thuật**.

### Đóng góp 3

Đánh giá **độ nhạy và độ ổn định của phương án được lựa chọn** trước sự thay đổi trọng số các tiêu chí.

---

# 15. Phân biệt với các bài đã công bố

## So với bài Q3

**Bài Q3:** phát triển và kiểm chứng MOSFOA.

**Bài 7:** sử dụng MOSFOA đã công bố để tạo đầu vào cho bài toán MCDM.

Không lặp lại benchmark thuật toán.

## So với Bài 5

**Bài 5:** MOFDA ↔ MOSFOA.

**Bài 7:** không thực hiện đối sánh MOFDA và MOSFOA; tập trung vào lựa chọn nghiệm Pareto.

## So với Bài 6

**Bài 6:** kiểm chứng MOSFOA trên các công trình/bài toán khác nhau.

**Bài 7:** không nghiên cứu lại tính tổng quát của MOSFOA; tập trung vào:

> **Pareto → MCDM → lựa chọn phương án.**

---

# 16. Các hình dự kiến

**Hình 1.** Quy trình kết hợp MOSFOA–TOPSIS.

**Hình 2.** Tập nghiệm Pareto được sử dụng làm đầu vào MCDM.

**Hình 3.** Quy trình tính TOPSIS.

**Hình 4.** Xếp hạng các nghiệm Pareto.

**Hình 5.** Ảnh hưởng của trọng số đến thứ hạng.

**Hình 6.** Độ ổn định của các phương án.

**Hình 7.** So sánh phương án hiện trạng và phương án được lựa chọn.

---

# 17. Các bảng dự kiến

**Bảng 1.** Nguồn dữ liệu từ Bài 5 và Bài 6.

**Bảng 2.** Các tiêu chí MCDM.

**Bảng 3.** Các kịch bản trọng số.

**Bảng 4.** Ma trận quyết định.

**Bảng 5.** Kết quả TOPSIS và thứ hạng.

**Bảng 6.** Phân tích độ nhạy.

**Bảng 7.** Độ ổn định của các phương án.

**Bảng 8.** So sánh phương án hiện trạng và phương án được khuyến nghị.

---

# 18. Nguyên tắc triển khai để tránh trùng lặp

1. **Không chạy lại toàn bộ MOSFOA chỉ để tạo lại các Pareto front đã có trong Bài 5–6.**
2. Không lặp lại benchmark MOFDA–MOSFOA.
3. Không lặp lại phân tích tính tổng quát của MOSFOA.
4. Không đưa toàn bộ kết quả Bài 5–6 vào Bài 7.
5. Chỉ trích xuất các nghiệm và chỉ tiêu cần thiết cho MCDM.
6. Dẫn chiếu rõ Bài 5 và Bài 6 là nguồn dữ liệu đầu vào.
7. Đóng góp mới phải nằm ở **TOPSIS + phân tích trọng số + lựa chọn/độ ổn định phương án**.
8. Với các công trình khác quy mô, ưu tiên **TOPSIS riêng từng case**, sau đó so sánh xu hướng, thay vì gộp các giá trị tuyệt đối.
9. Không đưa chi phí và khối lượng đồng thời nếu chúng mang cùng thông tin.
10. Không tuyên bố MOSFOA–TOPSIS là phương pháp tối ưu cho mọi loại công trình.

---

# 19. Thông điệp trung tâm

> **MOSFOA cung cấp tập nghiệm Pareto; TOPSIS cung cấp cơ chế lựa chọn một phương án phù hợp từ tập nghiệm đó.**

Hay biểu diễn:

\[
\boxed{Optimization\rightarrow Pareto\ alternatives\rightarrow Decision\ making}
\]

Trong đó:

\[
\boxed{MOSFOA\rightarrow Pareto\rightarrow TOPSIS\rightarrow Recommended\ Design}
\]

Bài 7 vì vậy đóng vai trò **tầng ra quyết định** trong chuỗi nghiên cứu MOSFOA, bổ sung cho hai tầng trước là **đối sánh thuật toán** và **kiểm chứng khả năng áp dụng**.
