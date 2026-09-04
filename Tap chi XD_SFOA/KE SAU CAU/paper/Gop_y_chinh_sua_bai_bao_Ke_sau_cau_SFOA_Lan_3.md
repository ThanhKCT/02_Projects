# GÓP Ý CHỈNH SỬA BÀI BÁO – LẦN 3
## Phiên bản rà soát trước khi gửi tạp chí

### Tên bài báo đã chốt

**TỐI ƯU KHỐI LƯỢNG BÊ TÔNG KẾT CẤU KÈ SAU CẦU BẰNG THUẬT TOÁN TỐI ƯU SAO BIỂN KẾT HỢP SAP2000–MATLAB**

---

# 1. ĐÁNH GIÁ TỔNG THỂ

Bản hiện tại đã ở trạng thái khá tốt và về cơ bản **có thể gửi tạp chí**.

Không cần:
- bổ sung case study;
- bổ sung thuật toán khác;
- benchmark SFOA;
- tối ưu đa mục tiêu;
- chạy lại quá trình SAP2000–MATLAB–SFOA chỉ vì thay đổi cách hậu kiểm chọc thủng.

Trọng tâm lần chỉnh sửa cuối là:
1. sửa một số câu chưa thật chặt;
2. làm thống nhất cách viện dẫn tiêu chuẩn;
3. hoàn thiện phần hậu kiểm EN 1992;
4. tạo khoảng đệm an toàn dưới giới hạn 3.500 từ.

---

# 2. ĐIỂM QUAN TRỌNG NHẤT: KIỂM TRA CHỌC THỦNG

Bản hiện tại đã có bước tiến tốt:

- Trong vòng lặp tối ưu vẫn giữ phép kiểm tra chọc thủng đang dùng trong mô hình.
- Nghiệm tối ưu được **hậu kiểm bổ sung theo EN 1992-1-1 [7]** cho toàn bộ 142 cọc.
- Có phân loại cọc trong/biên/góc:
  - 86 cọc trong;
  - 52 cọc biên;
  - 4 cọc góc.
- Hệ số \(\beta\):
  - 1,15;
  - 1,40;
  - 1,50.
- Không có cọc vi phạm.
- Tỷ số sử dụng lớn nhất theo EN 1992-1-1 là 0,43 tại một cọc biên.

Đây là cách xử lý hợp lý vì chưa cần chạy lại toàn bộ tối ưu.

## 2.1. Không được chỉ đổi tên tiêu chuẩn

Không nên sửa:

> TCVN 5574:2018

thành:

> EN 1992

mà vẫn giữ nguyên công thức chọc thủng nếu chưa đối chiếu nguồn công thức.

Phải đảm bảo công thức, cách xác định \(V_{Ed}\), chu vi kiểm tra, chiều cao làm việc, tỷ lệ cốt thép và hệ số \(\beta\) đúng với phương pháp EN 1992-1-1 thực tế đã dùng.

## 2.2. Sửa viện dẫn điều khoản

Hiện bài ghi:

> "EN 1992-1-1 [7] (Điều 6.4.4)"

Nên sửa thành:

> **"EN 1992-1-1 [7] (Điều 6.4.3–6.4.4)"**

vì bài đã sử dụng các hệ số \(\beta=1,15/1,40/1,50\).

## 2.3. Có phải chạy lại SAP–MATLAB không?

**Không, nếu hậu kiểm EN 1992-1-1 xác nhận nghiệm 232,48 m³ vẫn thỏa mãn.**

Nghiệm hiện tại:

\[
x^*=(0,20;\ 0,22;\ 0,25;\ 0,40;\ 0,71;\ 0,58)\;m
\]

với:

\[
V_{opt}=232,48\;m^3
\]

có thể giữ nguyên nếu kết quả hậu kiểm EN 1992-1-1 cho thấy toàn bộ 142 cọc đều đạt.

Chỉ phải chạy lại tối ưu nếu công thức/tiêu chuẩn mới làm nghiệm hiện tại không còn thỏa mãn.

---

# 3. TCVN 11820-5:2021 – GIỮ

Với việc làm rõ công trình là **kết cấu chắn đất phía sau công trình bến bệ cọc cao, tại khu vực tiếp giáp giữa công trình bến và bãi sau kè**, việc dùng TCVN 11820-5:2021 là phù hợp với cách định vị công trình trong bài.

Nên giữ cách mô tả hiện tại:

> "Kè sau cầu, trong nghiên cứu này, là kết cấu chắn đất phía sau công trình bến bệ cọc cao..."

Cách này giúp người đọc hiểu ngay vì sao TCVN 11820-5:2021 được sử dụng.

## 3.1. Mục 2.1

Nên tiếp tục nhấn mạnh:

> **"Loại kết cấu này được thiết kế theo TCVN 11820-5:2021 – tiêu chuẩn công trình bến, trong đó có các yêu cầu riêng đối với bến bệ cọc cao và kết cấu chắn đất phía sau bến..."**

Không cần giải thích dài hơn.

---

# 4. TCVN 5574:2018 – CHƯA CẦN XÓA

Không nên xóa TCVN 5574:2018 chỉ để danh mục tài liệu tham khảo "đẹp" hơn.

Bản hiện tại đang dùng:
- phép kiểm tra trong vòng lặp tối ưu;
- hậu kiểm độc lập theo EN 1992-1-1.

Cách này có thể giữ nếu mô tả đúng với chương trình thực tế.

Tuy nhiên nên tránh viết theo kiểu khẳng định TCVN 5574:2018 là tiêu chuẩn chuyên ngành chính thức cho toàn bộ kết cấu thủy công.

## 4.1. Câu nên sửa

Hiện:

> "Ràng buộc chọc thủng trong vòng lặp tối ưu sử dụng TCVN 5574:2018; hậu kiểm bổ sung theo EN 1992-1-1 [7]..."

Nên viết thận trọng hơn:

> **"Ràng buộc chọc thủng trong vòng lặp tối ưu được tính theo công thức đang sử dụng trong mô hình; nghiệm tối ưu được hậu kiểm bổ sung theo EN 1992-1-1 [7]..."**

Nếu vẫn muốn nêu TCVN 5574:2018 ngay tại đây thì chỉ nên làm khi chắc chắn công thức đang dùng đúng theo tài liệu đó.

---

# 5. MỤC 1 – ĐẶT VẤN ĐỀ

## 5.1. Câu về chi phí

Hiện bài có:

> "tăng chi phí vật liệu không cần thiết."

Bài không tính chi phí mà chỉ tối ưu thể tích bê tông.

Nên sửa thành:

> **"làm tăng lượng vật liệu sử dụng không cần thiết."**

Hoặc tốt hơn:

> **"làm tăng thể tích bê tông sử dụng không cần thiết."**

## 5.2. Câu "minh chứng thực nghiệm"

Hiện:

> "Đóng góp chính của nghiên cứu là minh chứng thực nghiệm..."

Nên sửa thành:

> **"Đóng góp chính của nghiên cứu là minh chứng qua một công trình thực tế về khả năng ứng dụng SFOA nguyên bản..."**

Lý do: bài là nghiên cứu tính toán trên công trình thực tế, không phải thí nghiệm thực nghiệm trong phòng.

## 5.3. Câu về 1,7 tỷ tổ hợp

Cách viết hiện tại đã phù hợp:

> "Với không gian thiết kế rời rạc có quy mô khoảng 1,7 tỷ tổ hợp, việc khảo sát toàn bộ bằng phương pháp vét cạn (brute-force) là không khả thi về mặt tính toán; do đó cần sử dụng một phương pháp tìm kiếm phù hợp."

Có thể giữ nguyên.

---

# 6. MỤC 2.3 – HÀM PHẠT

Phần này hiện đã khá chặt:

\[
f(x)=V(x)+C\,g(x)
\]

\[
g(x)=\sum_{j=1}^{5}\max(0,v_j(x))
\]

\[
v_j(x)=\max\left(0,\frac{R_j(x)}{R_{j,\mathrm{lim}}}-1\right)
\]

với \(v_j\) không thứ nguyên.

**Giữ nguyên**, với điều kiện đúng với code MATLAB thực tế.

Hệ số:

\[
C=10^6
\]

nên được mô tả như lựa chọn cụ thể của nghiên cứu:

> **"Trong nghiên cứu này, hệ số phạt được chọn bằng \(C=10^6\) nhằm ưu tiên các nghiệm thỏa mãn ràng buộc."**

Không cần giải thích dài hơn.

---

# 7. MỤC 2.4 – RÀNG BUỘC

Cách gọi:

> **"năm nhóm ràng buộc kỹ thuật"**

là đúng và nên giữ thống nhất toàn bài.

## 7.1. Chuyển vị

Giữ:

\[
U_{lim}=\min(H/300,100\,mm)=15\,mm
\]

với \(H=4,5m\).

Nên ghi:

> **"Theo TCVN 11820-5:2021, Bảng 12, giới hạn chuyển vị ngang là \(U_{lim}=\min(H/300,100\,mm)\). Với \(H=4,5m\), giới hạn sử dụng là 15 mm."**

## 7.2. Chịu cắt

Cách mô tả lọc nội lực tại khoảng cách không nhỏ hơn \(h_0\) là hợp lý.

Có thể giữ nguyên.

## 7.3. Chọc thủng

Nếu vẫn để TCVN 5574:2018 ở Bảng 1 trong khi hậu kiểm EN 1992 ở Mục 3.5, cần đảm bảo người đọc hiểu rõ:

> **đây là hai bước kiểm tra khác nhau**, trong đó EN 1992 là hậu kiểm bổ sung cho nghiệm cuối.

---

# 8. MỤC 2.6 – SFOA

Phần này hiện đã phù hợp với phạm vi bài.

Giữ:
- SFOA nguyên bản;
- \(N_{run}=1\);
- không benchmark;
- không Best/Mean/STD nhiều lần chạy;
- \(N_{pop}=50\);
- \(Maxit=50\);
- 2.550 lần đánh giá.

Không cần mở rộng.

---

# 9. MỤC 3.1 – HỘI TỤ

Cách viết hiện tại tốt:

> "Giá trị tốt nhất tích lũy không đổi từ vòng lặp 47 đến 50..."

và:

> "cho thấy nghiệm thu được đã ổn định ở giai đoạn cuối của lần chạy."

Nên giữ.

Không quay lại cách nói:

> "50 vòng lặp là đủ cho thuật toán"

vì chỉ có một lần chạy.

---

# 10. MỤC 3.2 – NGHIỆM TỐI ƯU

Câu hiện tại đã được sửa đúng hướng:

> "cho thấy chiều dày vùng này có thể giảm đáng kể mà vẫn thỏa mãn các ràng buộc kỹ thuật."

Nên giữ.

Bảng 2 đang rõ:
- 6 biến chiều dày;
- phương án hiện trạng;
- nghiệm tối ưu;
- thể tích bê tông;
- mức giảm 51,66 m³ (18,18%).

Không cần bổ sung thêm bảng mới.

---

# 11. MỤC 3.3 – KIỂM TRA RÀNG BUỘC

Cách diễn đạt hiện tại đã tốt:

> "Đối với sức chịu tải cọc, tỷ số sử dụng lớn nhất là 37,5%; chuyển vị ngang đỉnh tường đạt 27,1% giới hạn..."

Giữ nguyên.

## 11.1. Có thể cải thiện Bảng 3

Hiện:
- chịu cắt: "Không vi phạm";
- nứt: "Không vi phạm";
- chọc thủng: "Không vi phạm".

Nếu có sẵn số liệu, nên đổi riêng chọc thủng thành:

> **0,43 | ≤ 1,0 | Thỏa mãn**

vì đã có tỷ số sử dụng lớn nhất từ hậu kiểm EN 1992-1-1.

Không bắt buộc phải bổ sung tỷ số cho chịu cắt và nứt nếu chưa có dữ liệu.

---

# 12. MỤC 3.4 – HIỆU QUẢ TÍNH TOÁN

Nội dung số liệu hiện tại có thể giữ:

- 2.550 lần đánh giá;
- khoảng 15,4 giây/lần;
- khoảng 10 giờ 55 phút.

Để tiết kiệm từ, có thể viết ngắn hơn:

> **"Tổng số lần đánh giá là 2.550, gồm 50 đánh giá cho quần thể khởi tạo và 50 đánh giá mỗi vòng lặp. Thời gian trung bình khoảng 15,4 giây/lần, tổng thời gian khoảng 10 giờ 55 phút."**

Không cần nhắc lại "một phiên SAP2000 duy nhất" nếu đã nói rõ ở Mục 2.5.

---

# 13. MỤC 3.5 – HẠN CHẾ

Phần này hiện phù hợp.

Nên giữ:
- \(N_{run}=1\);
- chưa đánh giá độ ổn định thống kê;
- chịu cắt/nứt dựa trên \(A_{s,req}\);
- chưa hậu kiểm theo bản vẽ cốt thép;
- nghiệm là phương án tối ưu chiều dày;
- hậu kiểm chọc thủng theo EN 1992-1-1.

Đây là phần giúp bài **chủ động kiểm soát các giới hạn của nghiên cứu**.

---

# 14. KẾT LUẬN

Kết luận hiện tại đã đủ ngắn và đúng phạm vi.

Giữ ba ý:
1. xây dựng khung SAP2000–MATLAB–SFOA;
2. nghiệm 232,48 m³, giảm 18,18%;
3. còn phải hoàn thiện cốt thép trước thiết kế thi công.

Không cần thêm "hướng nghiên cứu tương lai" về đa mục tiêu, song song hoặc thuật toán mới.

---

# 15. TÀI LIỆU THAM KHẢO

Danh mục hiện có 7 tài liệu là **vừa đủ** cho bài 3.500 từ.

## Giữ:
- [1] Zhong et al. – SFOA.
- [2] Deb – penalty.
- [3] TCVN 10304:2025.
- [4] TCVN 11820-5:2021.
- [5] TCVN 4116:2023.
- [6] TCVN 5574:2018 – giữ tạm để phản ánh nguồn công thức đang sử dụng trong vòng lặp.
- [7] EN 1992-1-1:2004+A1:2014 – hậu kiểm chọc thủng.

Không cần bổ sung thêm các thuật toán metaheuristic khác.

---

# 16. GIỚI HẠN 3.500 TỪ

Bản Word hiện tại khoảng:

> **3.443 từ toàn bộ file**

Vì vậy đang nằm dưới giới hạn 3.500 từ nhưng **rất sát**.

Mục tiêu cuối nên đưa xuống khoảng:

> **3.390–3.420 từ**

để có khoảng đệm.

## Có thể cắt khoảng 30–50 từ tại:
- Mục 2.5;
- Mục 3.4;
- Mục 3.5.

Không cần cắt Tóm tắt hoặc Kết luận.

---

# 17. BỐN SỬA ĐỔI CUỐI CÙNG KHUYẾN NGHỊ THỰC HIỆN

### Sửa 1
> "tăng chi phí vật liệu không cần thiết"

→

> **"làm tăng thể tích bê tông sử dụng không cần thiết"**

### Sửa 2
> "minh chứng thực nghiệm"

→

> **"minh chứng qua một công trình thực tế"**

### Sửa 3
> "EN 1992-1-1 [7] (Điều 6.4.4)"

→

> **"EN 1992-1-1 [7] (Điều 6.4.3–6.4.4)"**

### Sửa 4
Giảm thêm khoảng 30–50 từ để bài không sát giới hạn 3.500 từ.

---

# 18. ĐÁNH GIÁ CUỐI CÙNG

## Trạng thái nghiên cứu

**Đủ để gửi.**

## Trạng thái phương pháp

**Đủ chặt trong phạm vi nghiên cứu.**

## Tài liệu tham khảo

**Đủ và không cần mở rộng.**

## Tiêu chuẩn

**TCVN 11820-5:2021 – giữ.**  
**TCVN 10304:2025 – giữ.**  
**TCVN 4116:2023 – giữ.**  
**TCVN 5574:2018 – giữ nếu phản ánh đúng công thức đang dùng trong vòng lặp; không cần xóa chỉ để thay bằng EN 1992.**  
**EN 1992-1-1 – giữ cho hậu kiểm chọc thủng.**

## Tối ưu

**Không cần chạy lại SAP–MATLAB–SFOA**, với điều kiện kết quả hậu kiểm EN 1992-1-1 của 142 cọc là đúng và nghiệm 232,48 m³ thực sự đạt.

## Mức độ sẵn sàng

> **Sau 4 chỉnh sửa cuối ở trên, có thể chốt bài để gửi tạp chí.**
