# GÓP Ý CHỈNH SỬA BÀI BÁO – LẦN 2

## Tên bài báo đã chốt

**TỐI ƯU KHỐI LƯỢNG BÊ TÔNG KẾT CẤU KÈ SAU CẦU BẰNG THUẬT TOÁN TỐI ƯU SAO BIỂN KẾT HỢP SAP2000–MATLAB**

> Lưu ý: sau khi làm rõ đối tượng là **kết cấu chắn đất phía sau công trình bến bệ cọc cao, tại khu vực tiếp giáp giữa công trình bến và bãi sau kè**, cần cân nhắc trong thân bài có nên dùng thuật ngữ kỹ thuật chính xác hơn là **"kết cấu chắn đất phía sau bến bệ cọc cao"** hay không. Không nhất thiết đổi tên bài nếu "kè sau cầu" là tên gọi thống nhất trong hồ sơ công trình.

---

# I. Đánh giá lại sau khi làm rõ bản chất công trình

Thông tin mới cho thấy đối tượng nghiên cứu không phải kè sau cầu đường bộ thông thường, mà là:

> **kết cấu chắn đất phía sau công trình bến bệ cọc cao, nằm ở khu vực tiếp giáp giữa công trình bến và bãi sau kè.**

Điều này làm cơ sở lựa chọn tiêu chuẩn rõ hơn.

Cấu trúc tiêu chuẩn nên định hướng như sau:

| Nội dung | Tiêu chuẩn dự kiến |
|---|---|
| Loại công trình, bến bệ cọc cao, kết cấu chắn đất phía sau bến | **TCVN 11820-5:2021** |
| Giới hạn chuyển vị | **TCVN 11820-5:2021, Bảng 12** |
| Sức chịu tải cọc | **TCVN 10304:2025** |
| Kiểm tra BTCT thủy công, chịu cắt, nứt | **TCVN 4116:2023** |
| Chọc thủng | **Chưa đổi ngay**; cần đối chiếu công thức đang dùng với **EN 1992** trước khi quyết định |

---

# II. Đối với TCVN 11820-5:2021: NÊN GIỮ

Với mô tả công trình mới, việc sử dụng TCVN 11820-5:2021 là có cơ sở hơn rõ rệt.

Tiêu chuẩn này được sử dụng cho công trình bến và có nội dung riêng đối với **bến bệ cọc cao**, trong đó có **kết cấu chắn đất phía sau bến** và các yêu cầu về chuyển vị.

Do đó không nên xem TCVN 11820-5:2021 chỉ là nguồn cho một giá trị giới hạn chuyển vị đơn lẻ.

## Khuyến nghị sửa Mục 2.1

Thay:

> "Đối tượng nghiên cứu là kè sau cầu..."

bằng:

> **"Đối tượng nghiên cứu là kết cấu chắn đất phía sau công trình bến bệ cọc cao, bố trí tại khu vực tiếp giáp giữa công trình bến và bãi sau kè. Kết cấu gồm tường chắn cao 4,5 m liên kết với bản đáy đặt trên hệ cọc..."**

Sau đó trong các phần sau có thể dùng ngắn gọn:

> **"kết cấu kè sau bến"**

hoặc giữ "kè sau cầu" nếu đây là thuật ngữ chính thức của hồ sơ công trình.

---

# III. TCVN 11820-5:2021 và giới hạn chuyển vị

Bảng 1 hiện sử dụng:

> TCVN 11820-5:2021, Bảng 12

với:

\[
U_{lim}=\min(H/300,100\,mm)=15\,mm
\]

Cách tính này có thể giữ nếu:

1. \(H=4,5m\) chính là chiều cao dùng theo định nghĩa của Bảng 12;
2. đối tượng tính chuyển vị đúng với phạm vi áp dụng của điều khoản;
3. công trình thực tế thuộc loại bến bệ cọc cao đang xét.

Nên viết rõ hơn trong bài:

> **"Theo TCVN 11820-5:2021, Bảng 12, giới hạn chuyển vị ngang được xác định theo \(U_{lim}=\min(H/300,100\,mm)\). Với \(H=4,5m\), giới hạn chuyển vị được sử dụng là 15 mm."**

Không cần diễn giải dài hơn.

---

# IV. TCVN 5574:2018 – KHÔNG ĐỔI NGAY

Đây là điểm quan trọng nhất của lần rà soát thứ hai.

## 4.1. Không nên làm cách sau

Không được chỉ sửa:

> TCVN 5574:2018

thành:

> EN 1992

mà vẫn giữ nguyên công thức:

\[
|N_d|\leq\gamma_c R_{bt} u h_0
\]

Bởi công thức đó phải được đối chiếu với **đúng nguồn tiêu chuẩn**.

EN 1992 sử dụng hệ ký hiệu và cách kiểm tra chọc thủng khác, nên cần xác minh công thức thực tế trước khi thay tiêu chuẩn.

## 4.2. Hướng đúng

**Chưa cần chạy lại SAP–MATLAB ngay.**

Trước tiên lấy chính nghiệm tối ưu hiện tại:

\[
x^*=
(0,20;\;0,22;\;0,25;\;0,40;\;0,71;\;0,58)\;m
\]

và hậu kiểm chọc thủng cho toàn bộ 142 cọc theo phương pháp EN 1992 dự kiến sử dụng.

### Nếu nghiệm 232,48 m³ vẫn đạt toàn bộ 142 cọc:

> **Không cần chạy lại quá trình tối ưu.**

Chỉ cần:
- cập nhật nguồn tiêu chuẩn;
- cập nhật công thức/chú thích kiểm tra;
- cập nhật Bảng 1 và Bảng 3 nếu cần.

### Nếu có cọc không đạt:

> **Phải chạy lại SAP–MATLAB–SFOA**, vì chọc thủng là một thành phần của bài toán ràng buộc trong quá trình tối ưu.

Khi đó miền nghiệm khả thi thay đổi và nghiệm tối ưu có thể thay đổi.

---

# V. TCVN 4116:2023 – NÊN GIỮ

TCVN 4116:2023 là tiêu chuẩn phù hợp với phần kết cấu bê tông và bê tông cốt thép thủy công.

Tiếp tục sử dụng cho:
- khả năng chịu cắt;
- bề rộng vết nứt;
- các kiểm tra BTCT thủy công hiện đang dùng trong bài.

Không cần thay chỉ để làm số lượng tiêu chuẩn nhỏ hơn.

---

# VI. Hướng xử lý chọc thủng: ưu tiên đối chiếu EN 1992

TCVN 11820-5:2021 có viện dẫn hệ tiêu chuẩn EN 1992 trong hệ thống tiêu chuẩn tham chiếu.

Vì vậy, nếu phương pháp chọc thủng đang sử dụng có thể quy đổi/đối chiếu trực tiếp sang EN 1992 phù hợp với mô hình bản đáy–cọc, thì đây là hướng có cơ sở hơn việc giữ TCVN 5574:2018 như một nguồn độc lập.

## Nhưng phải kiểm tra công thức trước

Cần đối chiếu:
- phản lực cọc dùng làm \(V_{Ed}\) hay tương đương;
- chu vi kiểm tra \(u\);
- chiều cao làm việc \(d/h_0\);
- tỷ lệ cốt thép;
- cường độ bê tông;
- ảnh hưởng lệch tâm/tải không đối xứng;
- vị trí và chu vi kiểm tra phù hợp với EN 1992.

Chỉ sau khi đối chiếu mới quyết định danh mục tài liệu tham khảo cuối cùng.

---

# VII. Nếu đổi sang EN 1992 thì có phải chạy lại SAP–MATLAB không?

## Câu trả lời: KHÔNG nhất thiết

Trình tự nên là:

### Bước 1
Giữ nguyên nghiệm tối ưu hiện tại:

\[
V=232,48\,m^3
\]

### Bước 2
Dùng kết quả SAP2000 của nghiệm này:
- phản lực 142 cọc;
- kích thước bản đáy;
- chiều dày các vùng;
- cốt thép dùng trong kiểm tra.

### Bước 3
Hậu kiểm chọc thủng theo EN 1992.

### Bước 4
Quyết định:

**Nếu 142/142 cọc đều đạt:**
- không chạy lại SFOA;
- không thay đổi nghiệm tối ưu;
- chỉ cập nhật tiêu chuẩn và cách kiểm tra.

**Nếu có cọc không đạt:**
- cập nhật hàm ràng buộc trong MATLAB;
- chạy lại SAP–MATLAB–SFOA;
- cập nhật nghiệm tối ưu, hội tụ, Bảng 2, Bảng 3 và kết luận.

Đây là phương án tiết kiệm thời gian và chặt chẽ về phương pháp luận.

---

# VIII. Tài liệu tham khảo – lần rà soát 2

## [1] SFOA

Giữ nguyên:

> Zhong, C., Li, G., Meng, Z., Li, H., Yildiz, A.R., Mirjalili, S. Starfish optimization algorithm (SFOA): a bio-inspired metaheuristic algorithm for global optimization compared with 100 optimizers. Neural Computing and Applications, vol. 37, pp. 3641–3683, 2025, doi: 10.1007/s00521-024-10694-1.

Đây là tài liệu nguồn chính của thuật toán SFOA.

## [2] Deb

Giữ nguyên:

> Deb, K. An efficient constraint handling method for genetic algorithms. Computer Methods in Applied Mechanics and Engineering, vol. 186, no. 2–4, pp. 311–338, 2000, doi: 10.1016/S0045-7825(99)00389-8.

Phù hợp làm nguồn phương pháp cho hàm phạt.

## [3] TCVN 10304:2025

Giữ nguyên.

Dùng cho kiểm tra sức chịu tải cọc.

## [4] TCVN 11820-5:2021

Giữ nguyên và **nên coi đây là tiêu chuẩn nền của đối tượng công trình**, không chỉ là nguồn cho chuyển vị.

## [5] TCVN 4116:2023

Giữ nguyên.

Dùng cho các kiểm tra BTCT thủy công đang có trong bài.

## [6] TCVN 5574:2018

**Tạm thời giữ trong file cho tới khi đối chiếu xong công thức chọc thủng.**

Không nên tự động xóa và cũng không nên tự động thay bằng EN 1992 chỉ ở phần danh mục tài liệu.

Sau khi hậu kiểm xác định phương pháp EN 1992 thực sự được sử dụng, mới chốt tài liệu [6].

---

# IX. Giữ nguyên số lượng tài liệu tham khảo hiện tại là hợp lý

Không cần bổ sung thêm hàng loạt tài liệu về:
- PSO;
- GA;
- các metaheuristic khác;
- benchmark;
- tối ưu FEM nói chung.

Lý do: bài này là **nghiên cứu ứng dụng SFOA cho một công trình cụ thể**, không phải bài tổng quan hay bài đánh giá thuật toán.

Sáu tài liệu hiện tại là gọn và phù hợp với giới hạn 3.500 từ.

---

# X. Từ ngữ cần tiếp tục sửa

## 10.1. "Khối lượng bê tông"

Nếu đơn vị là m³ thì dùng:

> **"thể tích bê tông"**

Tên bài hiện tại vẫn giữ cụm "Tối ưu khối lượng bê tông" theo yêu cầu đã chốt, nhưng trong nội dung và bảng tính nên dùng **"thể tích bê tông"** khi nói về đại lượng \(V\).

## 10.2. "Kè sau cầu"

Trong phần mô tả công trình nên ưu tiên:

> **"kết cấu chắn đất phía sau bến bệ cọc cao"**

để thể hiện đúng bản chất công trình.

## 10.3. "Ràng buộc"

Nên dùng thống nhất:

> **"năm nhóm ràng buộc kỹ thuật"**

## 10.4. "Ràng buộc chi phối"

Không sử dụng nếu chưa có tỷ số sử dụng cụ thể của từng nhóm ràng buộc.

---

# XI. Một câu ở Mục 3.2 vẫn cần sửa

Câu:

> "cho thấy dư thừa khả năng chịu lực đáng kể ở vùng này trong thiết kế ban đầu."

Nên đổi thành:

> **"cho thấy chiều dày của vùng này có thể được giảm đáng kể trong nghiệm tối ưu mà vẫn thỏa mãn các ràng buộc kỹ thuật."**

Đây là kết luận trực tiếp hơn từ kết quả.

---

# XII. Bảng 3 cần sửa một câu

Hiện bản thảo viết:

> "ràng buộc sức chịu tải cọc có tỷ số sử dụng thấp nhất (37,5%)"

Nên sửa thành:

> **"Đối với sức chịu tải cọc, tỷ số sử dụng lớn nhất là 37,5%; chuyển vị ngang đỉnh tường đạt 27,1% giới hạn cho phép (4,06 mm so với 15 mm)."**

Không nên dùng "thấp nhất", vì bài chưa có số liệu tỷ số sử dụng của toàn bộ nhóm ràng buộc để thực hiện phép so sánh đó.

---

# XIII. Giới hạn 3.500 từ

Bản .md hiện tại khoảng:
- hơn 3.300 từ phần nội dung;
- tổng cả tài liệu tham khảo ở quanh/ngay trên giới hạn 3.500 từ tùy cách đếm của tạp chí.

## Mục tiêu nên chốt:

> **Khoảng 3.300–3.400 từ toàn bài**

Không cần cắt sâu.

Có thể rút:
1. Mục 1 – Đặt vấn đề: 30–40 từ.
2. Mục 2.6 – Thiết lập SFOA: 40–50 từ.
3. Mục 3.4 – Hiệu quả tính toán: 20–25 từ.
4. Mục 3.5 – Hạn chế: 20–30 từ.

Không cần cắt Tóm tắt, Bảng kết quả và Kết luận.

---

# XIV. Phương án chốt trước khi gửi

## Bước 1
**Không chạy lại tối ưu.**

## Bước 2
Xác minh công thức chọc thủng hiện tại:

\[
|N_d|\leq\gamma_cR_{bt}uh_0
\]

đang lấy chính xác từ đâu và đối chiếu với EN 1992.

## Bước 3
Hậu kiểm nghiệm 232,48 m³ theo EN 1992.

## Bước 4
Nếu đạt → giữ nguyên toàn bộ kết quả tối ưu hiện tại.

## Bước 5
Nếu không đạt → mới chạy lại SAP–MATLAB–SFOA.

---

# XV. Thông điệp khoa học nên giữ

Bài không cần chứng minh SFOA "tốt hơn" thuật toán khác.

Thông điệp nên là:

> **Nghiên cứu đánh giá khả năng sử dụng SFOA nguyên bản như một công cụ tìm kiếm để tối ưu đồng thời sáu vùng chiều dày của kết cấu chắn đất phía sau bến bệ cọc cao, trong đó phản hồi kết cấu được đánh giá trực tiếp bằng SAP2000 và các nhóm ràng buộc kỹ thuật được kiểm tra theo hệ tiêu chuẩn phù hợp với công trình.**

Đây là mức khẳng định phù hợp với phạm vi nghiên cứu và không tạo yêu cầu phải mở rộng sang benchmark hoặc so sánh thuật toán.

---

# XVI. Kết luận rà soát lần 2

**Bản bài hiện tại đã ở trạng thái khá tốt.**

Các điểm nên chốt:

- **TCVN 11820-5:2021: GIỮ.**
- **TCVN 10304:2025: GIỮ.**
- **TCVN 4116:2023: GIỮ.**
- **TCVN 5574:2018: CHƯA ĐỔI NGAY.**
- **EN 1992: chỉ thay/đưa vào sau khi đối chiếu chính xác công thức chọc thủng.**
- **Không chạy lại SAP–MATLAB chỉ vì đổi tài liệu tham khảo.**
- **Chỉ chạy lại nếu công thức chọc thủng mới làm nghiệm 232,48 m³ không còn thỏa mãn.**
- **Mục tiêu độ dài: 3.300–3.400 từ toàn bài.**
- **Không mở rộng phạm vi nghiên cứu.**

### Ưu tiên cuối cùng

Điểm cần làm tiếp theo không phải là viết thêm bài, mà là:

> **kiểm tra chính xác công thức chọc thủng hiện tại và hậu kiểm nghiệm 232,48 m³ theo EN 1992.**

Nếu nghiệm vẫn đạt, bài sẽ được giữ gần như toàn bộ kết quả hiện tại và chỉ cần chỉnh lại phần tiêu chuẩn, thuật ngữ và một số câu chữ.
