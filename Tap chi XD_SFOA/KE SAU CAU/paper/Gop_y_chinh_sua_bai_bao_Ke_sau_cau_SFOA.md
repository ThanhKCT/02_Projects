# GÓP Ý CHỈNH SỬA BÀI BÁO

## Tên bài báo đã chốt

**TỐI ƯU KHỐI LƯỢNG BÊ TÔNG KẾT CẤU KÈ SAU CẦU BẰNG THUẬT TOÁN TỐI ƯU SAO BIỂN KẾT HỢP SAP2000–MATLAB**

---

## I. Định hướng chỉnh sửa chung

Bài báo hiện có cấu trúc và câu chuyện nghiên cứu rõ. Khi chỉnh sửa, **không mở rộng phạm vi nghiên cứu** và không bổ sung các nội dung như:
- So sánh SFOA với các thuật toán khác.
- Benchmark thuật toán.
- Bổ sung thêm công trình/case study.
- Tối ưu đa mục tiêu.
- Bổ sung phân tích song song hoặc tối ưu hiệu năng máy tính như một hướng nghiên cứu chính.

Trọng tâm cần giữ nguyên:

> **SFOA nguyên bản → ghép trực tiếp SAP2000–MATLAB → tối ưu 6 chiều dày → kiểm tra 5 nhóm ràng buộc kỹ thuật → áp dụng cho một công trình kè sau cầu thực tế → giảm thể tích bê tông so với phương án hiện trạng.**

Mục tiêu chỉnh sửa là:
1. Làm câu chữ chính xác, gọn và có tính khoa học hơn.
2. Làm chặt logic giữa mô hình – thuật toán – ràng buộc – kết quả – kết luận.
3. Chỉ khẳng định những gì số liệu trong bài thực sự chứng minh.
4. Thống nhất thuật ngữ và cách gọi đại lượng.
5. Làm rõ những điểm phản biện có thể hỏi, nhưng không mở rộng nghiên cứu.

---

# II. Góp ý theo từng mục

## 1. TÓM TẮT

### 1.1. Sửa thuật ngữ quan trọng

Cụm:

> "tối thiểu hóa khối lượng bê tông"

nên đổi thành:

> **"tối thiểu hóa thể tích bê tông"**

Lý do: hàm mục tiêu được tính theo:

\[
V(x)=\sum_{i=1}^{6}A_i x_i
\]

và có đơn vị m³. Đây là **thể tích**, không phải khối lượng.

Các cụm:
- "khối lượng bê tông 232,48 m³"
- "giảm 51,66 m³ khối lượng bê tông"

nên sửa thành:

> **"thể tích bê tông 232,48 m³"**

và:

> **"giảm 51,66 m³ thể tích bê tông"**

hoặc tự nhiên hơn:

> **"giảm thể tích bê tông 51,66 m³ (18,18%)"**.

### 1.2. Làm mềm kết luận cuối Tóm tắt

Câu hiện tại:

> "Kết quả cho thấy SFOA nguyên bản, kết hợp trực tiếp với FEM, có khả năng khai thác dư thừa khả năng chịu lực giữa các vùng kết cấu có nội lực khác nhau mà thiết kế theo kinh nghiệm khó nhận diện đầy đủ."

Nên sửa thành:

> **"Kết quả cho thấy phương pháp tối ưu có khả năng phân bổ lại chiều dày giữa các vùng kết cấu theo mức độ yêu cầu chịu lực, qua đó giảm thể tích bê tông so với phương án hiện trạng."**

Lý do: bài có thể chứng minh sự thay đổi chiều dày và mức giảm thể tích, nhưng chưa có phân tích riêng đủ để khẳng định mạnh về "dư thừa khả năng chịu lực".

---

# III. 1. ĐẶT VẤN ĐỀ

## 2.1. Làm gọn đoạn mở đầu

Giữ logic:

**đặc điểm kết cấu → nhiều vùng chiều dày → nhiều biến → khó tối ưu đồng thời → cần phương pháp tìm kiếm.**

Không cần mở rộng thêm lý thuyết tối ưu.

## 2.2. Sửa câu "buộc phải dùng metaheuristic"

Câu hiện tại:

> "phần lớn cấu hình khả dĩ (khoảng 1,7 tỷ tổ hợp rời rạc) vượt xa khả năng liệt kê toàn bộ (brute-force), buộc phải dùng công cụ tìm kiếm metaheuristic."

Nên sửa thành:

> **"Với không gian thiết kế rời rạc có quy mô khoảng 1,7 tỷ tổ hợp, việc khảo sát toàn bộ bằng phương pháp vét cạn (brute-force) là không khả thi về mặt tính toán; do đó cần sử dụng một phương pháp tìm kiếm phù hợp."**

Không dùng từ **"buộc phải"**, vì có thể bị phản biện rằng vẫn tồn tại những cách tiếp cận tính toán khác.

## 2.3. Làm mềm tuyên bố về khoảng trống nghiên cứu

Câu:

> "chưa được khảo sát trong các nghiên cứu trước."

Nên đổi thành:

> **"Trong phạm vi nghiên cứu được khảo sát, việc áp dụng SFOA nguyên bản kết hợp trực tiếp với SAP2000 cho bài toán tối ưu thể tích bê tông của kè sau cầu với nhiều vùng chiều dày độc lập và các ràng buộc theo TCVN chưa được xem xét."**

Điểm quan trọng là thêm:

> **"Trong phạm vi nghiên cứu được khảo sát"**

để tránh tuyên bố quá rộng.

## 2.4. Mục tiêu nghiên cứu

Có thể giữ nguyên 2 mục tiêu nhưng nên thống nhất thuật ngữ:

> **(1) xây dựng khung tính toán SAP2000–MATLAB–SFOA cho bài toán tối ưu thể tích bê tông của sáu vùng chiều dày kè sau cầu, chịu đồng thời năm nhóm ràng buộc kỹ thuật; (2) áp dụng khung tính toán cho một công trình kè sau cầu thực tế và đánh giá mức giảm thể tích bê tông so với phương án hiện trạng.**

---

# IV. 2. MÔ HÌNH BÀI TOÁN VÀ PHƯƠNG PHÁP

## 3.1. Mục 2.1. Hệ kết cấu

Nội dung hiện tại cơ bản tốt, giữ nguyên.

Chỉ cần thống nhất cách gọi:
- "kè sau cầu" dùng xuyên suốt.
- "vùng chiều dày độc lập" dùng xuyên suốt.
- "phần tử vỏ (shell)" ở lần đầu; sau đó có thể dùng "phần tử vỏ".
- "phần tử thanh (frame)" tương tự.

Không cần bổ sung mô hình mới.

---

# V. 2.2. Tải trọng và tổ hợp tải

Nội dung hiện tại rõ.

Nên giữ cách trình bày:

- DEAD
- Gdat
- Pdat
- ALD
- HH
- TH1
- TH2
- BAO

Cần rà soát để bảo đảm mọi ký hiệu viết trong phần này xuất hiện đúng như trong mô hình SAP2000.

Không cần giải thích dài thêm về bản chất các tải nếu bản thảo hiện tại đã đủ cho việc tái hiện nghiên cứu.

---

# VI. 2.3. Biến thiết kế và hàm mục tiêu

## 4.1. Sửa "khối lượng" thành "thể tích"

Đổi:

> "Hàm mục tiêu là tổng khối lượng bê tông..."

thành:

> **"Hàm mục tiêu là tổng thể tích bê tông của sáu vùng..."**

Công thức giữ nguyên:

\[
V(x)=\sum_{i=1}^{6}A_i x_i
\]

Trong đó:
- \(A_i\): diện tích vùng \(i\), m²;
- \(x_i\): chiều dày vùng \(i\), m;
- \(V(x)\): thể tích bê tông, m³.

## 4.2. Cần làm rõ hàm phạt

Đây là một trong các điểm cần chỉnh quan trọng nhất.

Bản thảo hiện dùng:

\[
f(x)=V(x)+C\,g(x)
\]

\[
g(x)=\sum_{j=1}^{5}\max(0,v_j(x))
\]

với \(C=10^6\).

Cần **viết rõ \(v_j(x)\) được định nghĩa như thế nào**.

Nếu trong chương trình tính toán thực tế đang dùng dạng chuẩn hóa theo tỷ số sử dụng, nên thể hiện rõ dạng:

\[
v_j(x)=\max\left(0,\frac{R_j(x)}{R_{j,\mathrm{lim}}}-1\right)
\]

khi đó mức vi phạm là không thứ nguyên.

Nếu code hiện tại dùng định nghĩa khác thì bài phải mô tả đúng theo code, không được tự thay đổi công thức chỉ để làm đẹp bài.

## 4.3. Cách diễn đạt về hệ số phạt

Không nên viết:

> "hệ số phạt tuyến tính theo cách tiếp cận phạt tĩnh hệ số lớn thường dùng..."

nếu không có phân tích riêng về lựa chọn hệ số.

Nên viết:

> **"Trong nghiên cứu này, hệ số phạt được chọn bằng \(C=10^6\) nhằm ưu tiên các nghiệm thỏa mãn ràng buộc."**

---

# VII. 2.4. Ràng buộc kỹ thuật

## 5.1. Thống nhất gọi là "năm nhóm ràng buộc"

Nên dùng:

> **"năm nhóm ràng buộc kỹ thuật"**

thay cho chỉ "năm ràng buộc", vì:
- chịu cắt được kiểm tra theo 6 vùng;
- bề rộng vết nứt được kiểm tra theo các vùng;
- chọc thủng được kiểm tra theo 142 cọc.

Bảng 1 nên đổi tiêu đề:

> **Bảng 1. Năm nhóm ràng buộc kỹ thuật của bài toán tối ưu**

## 5.2. Câu về lọc đỉnh nội lực FEM

Nội dung hiện tại đúng hướng nhưng hơi dài.

Có thể thay bằng:

> **"Đối với kiểm tra chịu cắt, nội lực được trích xuất tại các vị trí cách mặt gối tựa hoặc mép cọc một khoảng không nhỏ hơn \(h_0\), nhằm hạn chế ảnh hưởng của đỉnh nội lực cục bộ tại vùng biên phần tử vỏ. Bộ lọc này chỉ áp dụng cho lực cắt; mô men uốn cực đại tại chân công-xôn được giữ nguyên vì phản ánh trạng thái chịu lực thực tế."**

Giữ ý nghĩa kỹ thuật hiện tại, chỉ làm câu gọn và rõ hơn.

## 5.3. Chọc thủng

Giữ nguyên việc kiểm tra riêng cho từng cọc trong 142 cọc.

Có thể viết ngắn:

> **"Kiểm tra chọc thủng được thực hiện riêng cho từng cọc, với \(h_0\) tương ứng vùng bản đáy tại vị trí cọc."**

---

# VIII. 2.5. Khung tính toán SAP2000–MATLAB–SFOA

Nội dung hiện tại tốt và là một trong những phần nên giữ.

Có thể viết gọn lại thành chuỗi:

> **"Mỗi cá thể trong SFOA được đánh giá qua các bước: (1) rời rạc hóa biến thiết kế; (2) cập nhật chiều dày các vùng shell trong SAP2000; (3) thực hiện phân tích FEM; (4) trích xuất phản lực, chuyển vị và nội lực; (5) kiểm tra các ràng buộc, tính hàm mục tiêu và hàm thích nghi; (6) trả kết quả về SFOA để cập nhật quần thể."**

Phần nói về việc chỉ dùng một phiên SAP2000 nên giữ vì đây là chi tiết thực thi hữu ích.

---

# IX. 2.6. Thuật toán SFOA nguyên bản và thiết lập tính toán

## 7.1. Giữ nguyên SFOA nguyên bản

Đây là điểm mạnh của bài, phải giữ:

> **SFOA nguyên bản, không bổ sung cơ chế lai ghép hay cải tiến thuật toán.**

## 7.2. Không khẳng định đường cong hội tụ "thay thế" thống kê nhiều lần chạy

Câu:

> "đường cong hội tụ ổn định ... được dùng làm minh chứng thay thế cho thống kê đa lần chạy."

Nên sửa thành:

> **"Do mục tiêu của nghiên cứu là đánh giá khả năng ứng dụng của SFOA cho một bài toán thiết kế cụ thể, nghiên cứu chỉ thực hiện một lần chạy. Đường cong hội tụ được sử dụng để đánh giá diễn biến và mức độ ổn định của nghiệm trong quá trình tối ưu."**

Điều này giúp bảo vệ lựa chọn \(N_{run}=1\) mà không nói quá.

## 7.3. Npop và Maxit

Giữ:

\[
N_{pop}=50,\qquad Maxit=50
\]

Nhưng đoạn mô tả khảo sát sơ bộ nên viết ngắn gọn hơn.

Không cần biến khảo sát sơ bộ thành một "thí nghiệm" mới.

Có thể viết:

> **"Khảo sát sơ bộ với \(N_{pop}=15\), 40 vòng lặp cho thấy nghiệm cải thiện rất ít trong các vòng lặp cuối; do đó nghiên cứu sử dụng \(N_{pop}=50\) và \(Maxit=50\) cho lần chạy chính thức."**

---

# X. 3. KẾT QUẢ VÀ THẢO LUẬN

## 8.1. Mục 3.1. Sự hội tụ

Hình 1 là cần thiết và nên giữ.

Không nên viết:

> "cho thấy 50 vòng lặp là đủ để thuật toán đạt trạng thái ổn định"

Nên viết:

> **"cho thấy nghiệm thu được đã ổn định trong các vòng lặp cuối của lần chạy được khảo sát."**

Cũng có thể viết:

> **"Giá trị tốt nhất tích lũy không thay đổi từ vòng lặp 47 đến 50, cho thấy nghiệm đã ổn định ở giai đoạn cuối của quá trình tối ưu."**

Cách này bám sát đúng dữ liệu hình.

---

# XI. 3.2. Nghiệm tối ưu

## 9.1. Sửa thuật ngữ trong bảng

Tên:

> "Khối lượng bê tông V (m³)"

nên đổi thành:

> **"Thể tích bê tông V (m³)"**

## 9.2. Nhận xét về 6 vùng

Có thể giữ phân tích:

- DAY130 giảm mạnh nhất;
- DAY60 giảm ít nhất.

Nhưng tránh suy luận:

> "thuật toán thận trọng hơn khi giảm chiều dày ở đây."

Nên viết:

> **"Trong nghiệm tối ưu, DAY60 giảm từ 0,60 m xuống 0,58 m. Kết quả cho thấy chiều dày vùng này chỉ được giảm ở mức hạn chế trong khi các ràng buộc kỹ thuật vẫn phải được thỏa mãn."**

Không suy diễn trực tiếp về cơ chế của thuật toán nếu chưa có số liệu riêng chứng minh.

---

# XII. 3.3. Kiểm tra ràng buộc kỹ thuật

## 10.1. Đây là điểm cần chỉnh đáng kể

Bảng 3 hiện có các mục:

- Sức chịu tải cọc: 0,375
- Chuyển vị: 4,06/15
- Chịu cắt: "Không vi phạm"
- Nứt: "Không vi phạm"
- Chọc thủng: "Không vi phạm"

Nếu không có tỷ số sử dụng cụ thể cho ba nhóm cuối thì **không nên kết luận rằng chịu cắt và bề rộng vết nứt là "ràng buộc chi phối"**.

### Phương án tốt nhất

Nếu dữ liệu tính toán có sẵn, bổ sung vào Bảng 3:

| Ràng buộc | Tỷ số sử dụng lớn nhất | Giới hạn |
|---|---:|---:|
| Sức chịu tải cọc | ... | 1,0 |
| Chuyển vị ngang | 0,271 | 1,0 |
| Khả năng chịu cắt | ... | 1,0 |
| Bề rộng vết nứt | ... | 1,0 |
| Chọc thủng | ... | 1,0 |

Như vậy mới đủ căn cứ để nói ràng buộc nào chi phối.

### Nếu không muốn bổ sung số liệu

Xóa cụm:

> "ràng buộc chịu cắt và bề rộng vết nứt ... là ràng buộc chi phối"

và thay bằng:

> **"Trong nghiệm tối ưu, các điều kiện chịu cắt và bề rộng vết nứt vẫn cần được kiểm soát khi tiếp tục giảm chiều dày các vùng kết cấu."**

## 10.2. "Biên an toàn dương"

Chỉ nên dùng cụm này khi giá trị dư thực sự được xác định.

Nếu chỉ có kết luận đạt/không đạt thì có thể viết:

> **"toàn bộ các nhóm ràng buộc đều được thỏa mãn"**

thay vì khẳng định "biên an toàn dương" cho mọi ràng buộc.

---

# XIII. 3.4. Hiệu quả tính toán

Giữ phần này vì có giá trị mô tả chi phí tính toán.

Nên diễn đạt số lần đánh giá:

> **"Tổng số lần đánh giá là 2.550, gồm 50 đánh giá cho quần thể khởi tạo và 50 đánh giá cho mỗi vòng trong 50 vòng lặp."**

Sau đó giữ:
- khoảng 15,4 s/đánh giá;
- khoảng 10 giờ 55 phút;
- chạy tuần tự, không song song.

Không cần phân tích sâu hơn.

---

# XIV. 3.5. Hạn chế

Nên giữ mục này.

## 11.1. Cách diễn đạt nên thận trọng

Câu:

> "nghiệm được đề xuất cần được hậu kiểm chi tiết trước khi triển khai thi công."

Nên sửa thành:

> **"Nghiệm tối ưu được xem là phương án đề xuất ở cấp độ tối ưu chiều dày; trước khi sử dụng trong thiết kế thi công cần tiếp tục kiểm tra và hoàn thiện chi tiết cốt thép theo hồ sơ thiết kế."**

Điều này phản ánh đúng phạm vi nghiên cứu hiện tại.

---

# XV. 4. KẾT LUẬN

Nên rút gọn, tránh lặp lại nguyên văn Tóm tắt.

## Đề xuất cấu trúc kết luận

### Đoạn 1 – Phương pháp

> **"Nghiên cứu đã xây dựng và áp dụng khung tính toán kết hợp SAP2000–MATLAB và SFOA nguyên bản để tối ưu sáu biến chiều dày của tường chắn và bản đáy kè sau cầu, đồng thời kiểm tra năm nhóm ràng buộc kỹ thuật theo các tiêu chuẩn được lựa chọn."**

### Đoạn 2 – Kết quả

> **"Đối với công trình khảo sát, nghiệm tối ưu cho thể tích bê tông 232,48 m³, giảm 51,66 m³, tương đương 18,18% so với phương án hiện trạng. Nghiệm thu được thỏa mãn toàn bộ các ràng buộc kiểm tra và ổn định ở các vòng lặp cuối của quá trình tối ưu."**

### Đoạn 3 – Giới hạn

> **"Kết quả hiện mới dừng ở tối ưu chiều dày và kiểm tra các ràng buộc trong mô hình tính toán. Việc hoàn thiện chi tiết cốt thép cần được thực hiện ở bước thiết kế tiếp theo trước khi áp dụng cho thiết kế thi công."**

## Không cần giữ phần mở rộng

Có thể bỏ đoạn:

- tối ưu đa mục tiêu;
- chi phí thi công;
- độ nhạy;
- tính toán song song.

Vì những nội dung này nằm ngoài phạm vi nghiên cứu hiện tại và làm loãng thông điệp chính.

---

# XVI. THỐNG NHẤT THUẬT NGỮ TOÀN BÀI

Nên rà soát và dùng thống nhất:

| Nên dùng | Hạn chế dùng |
|---|---|
| **kè sau cầu** | kè chắn đất / kè sau cầu xen kẽ |
| **thể tích bê tông** | khối lượng bê tông khi đơn vị là m³ |
| **năm nhóm ràng buộc kỹ thuật** | năm ràng buộc |
| **nghiệm tối ưu thu được** | nghiệm tốt nhất tìm được |
| **phương án hiện trạng** | as-built nếu không cần dùng tiếng Anh |
| **thỏa mãn ràng buộc** | không vi phạm nếu có thể diễn đạt trực tiếp |
| **phần tử hữu hạn (FEM)** | dùng FEM ngay lần đầu |
| **thuật toán tối ưu sao biển (SFOA)** | thay đổi cách dịch giữa các phần |
| **SFOA nguyên bản** | Original SFOA / SFOA gốc dùng lẫn nhau |

---

# XVII. 7 VIỆC ƯU TIÊN PHẢI SỬA TRƯỚC KHI GỬI

### 1.
Đổi toàn bộ **"khối lượng bê tông" → "thể tích bê tông"** ở những nơi đại lượng có đơn vị m³.

### 2.
Làm rõ định nghĩa \(v_j(x)\) trong hàm phạt và bảo đảm mô tả đúng với code thực tế.

### 3.
Làm mềm tuyên bố về "chưa được khảo sát trong các nghiên cứu trước".

### 4.
Bỏ cách nói đường cong hội tụ "thay thế" cho thống kê đa lần chạy.

### 5.
Không gọi chịu cắt và bề rộng vết nứt là "ràng buộc chi phối" nếu chưa có tỷ số sử dụng chứng minh.

### 6.
Làm mềm các suy luận nhân quả chưa được chứng minh trực tiếp bằng số liệu.

### 7.
Rút gọn Kết luận và bỏ phần mở rộng sang đa mục tiêu/song song.

---

# XVIII. THÔNG ĐIỆP KHOA HỌC NÊN CHỐT

Thông điệp trung tâm của bài nên được giữ ở mức:

> **Nghiên cứu không nhằm chứng minh SFOA tốt hơn các thuật toán tối ưu khác, mà đánh giá khả năng sử dụng SFOA nguyên bản như một công cụ tìm kiếm để tối ưu đồng thời sáu vùng chiều dày của kết cấu kè sau cầu thực tế, trong đó phản hồi kết cấu được đánh giá trực tiếp bằng SAP2000 và các nhóm ràng buộc kỹ thuật được kiểm tra theo các tiêu chuẩn Việt Nam được lựa chọn.**

Thông điệp này vừa đủ mạnh, đúng với phạm vi nghiên cứu và hạn chế nguy cơ phản biện yêu cầu bổ sung các nghiên cứu ngoài mục tiêu ban đầu.

---

# XIX. TÊN BÀI BÁO CHÍNH THỨC

> **TỐI ƯU KHỐI LƯỢNG BÊ TÔNG KẾT CẤU KÈ SAU CẦU BẰNG THUẬT TOÁN TỐI ƯU SAO BIỂN KẾT HỢP SAP2000–MATLAB**

Tên này được sử dụng thống nhất ở tiêu đề, tên file và các phiên bản chỉnh sửa tiếp theo.
