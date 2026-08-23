# REVIEWER COMMENTS — PAPER 1 — REVISION 8

## Đối tượng rà soát

**Tên bài:**

> Nghiên cứu đánh giá khả năng ứng dụng thuật toán tối ưu sao biển trong bài toán tối ưu đơn mục tiêu kết cấu công trình biển

**Bản rà soát:** Revision 8

**Vai trò:** Reviewer xây dựng, theo hướng phản biện tích cực cho một NCS mới tiếp cận lĩnh vực Single-Objective Optimization (SOO), bài dự kiến đăng tạp chí khoa học xây dựng bằng tiếng Việt.

---

# 1. KẾT LUẬN TỔNG QUAN

### Đánh giá

Revision 8 đã tiến bộ rõ rệt so với các phiên bản trước.

Logic nghiên cứu hiện tương đối mạch lạc:

> SFOA nguyên bản → SOO → hai mục tiêu độc lập → 30 lần chạy/case → đánh giá hội tụ và độ ổn định → hai nghiệm cực trị → phân tích trade-off → chỉ ra giới hạn của SOO → tạo cơ sở cho MOSFOA.

Bài hiện **không còn mắc lỗi lớn về định hướng nghiên cứu**.

### Khuyến nghị

Nếu tôi là reviewer của tạp chí, tôi sẽ xếp bài ở mức:

> **Minor Revision / Chấp nhận sau khi sửa chữa nhỏ.**

Không khuyến nghị mở rộng phạm vi nghiên cứu ở Revision 8.

---

# 2. ĐIỂM MẠNH CẦN GIỮ

## 2.1. Tên bài

Tên hiện tại phù hợp với nội dung:

> **Nghiên cứu đánh giá khả năng ứng dụng thuật toán tối ưu sao biển trong bài toán tối ưu đơn mục tiêu kết cấu công trình biển**

Tên này tốt hơn tên cũ vì thể hiện đúng bản chất:

- nghiên cứu đánh giá;
- không tuyên bố SFOA là thuật toán tốt nhất;
- không yêu cầu benchmark với PSO/GA/DE/GWO;
- phù hợp với phạm vi Paper 1.

**Giữ tên tiếng Việt.**

---

## 2.2. Logic SOO → MOSFOA

Đây là trục logic quan trọng nhất của bài.

Bài không tuyên bố:

> “SFOA tốt hơn các thuật toán khác.”

Mà cho thấy:

1. SFOA nguyên bản có thể được áp dụng cho SOO;
2. hai objective độc lập tạo ra hai nghiệm cực trị khác nhau;
3. chi phí và chuyển vị có trade-off rõ;
4. SOO không cung cấp tập nghiệm cân bằng;
5. đây là cơ sở để nghiên cứu tiếp theo phát triển MOSFOA.

Cách lập luận này phù hợp với phạm vi của Paper 1 và cần được giữ nguyên.

---

## 2.3. Phân tích CV = 0% là điểm mạnh

Revision 8 đã làm rõ:

- 30/30 run của bài toán displacement có cùng giá trị Best;
- nhưng không phải 30 run đều hội tụ về cùng một vector thiết kế;
- 25/30 dùng 1200-C;
- 4/30 và 1/30 dùng các loại cọc lân cận;
- các cấu hình vẫn đạt cùng Dmax;
- nguyên nhân được giải thích bằng hiện tượng objective plateau.

Đây là cách phân tích tốt hơn nhiều so với kết luận đơn giản:

> CV = 0% → thuật toán hoàn toàn ổn định.

### Khuyến nghị

**Giữ nguyên phần giải thích plateau.**

Đây là một trong những đoạn có giá trị phương pháp luận tốt nhất của Paper 1.

---

## 2.4. Phân tích trade-off được trình bày thận trọng

Bài đã chủ động phân biệt:

- trade-off tại hai nghiệm cực trị;
- với Pareto front thực sự.

Câu:

> “đây chưa phải bằng chứng bao trùm toàn bộ không gian thiết kế hay tương đương một Pareto front”

là rất phù hợp.

### Khuyến nghị

**Giữ nguyên.**

Không cần bổ sung Pareto analysis vào Paper 1.

---

## 2.5. Tác giả đã chủ động nêu giới hạn

Các giới hạn đã được nhận diện khá tốt:

- chỉ một hệ kết cấu MJP;
- chưa so sánh SFOA với các metaheuristic khác;
- penalty chưa chuẩn hóa;
- sức chịu tải nhổ chưa được tách riêng;
- DesignConcrete không phải ràng buộc trực tiếp của optimization;
- chưa có giới hạn serviceability displacement trong hệ constraint;
- TCVN 10304:2014 đã được thay thế bởi TCVN 10304:2025.

Đây là điểm cộng.

---

# 3. CÁC SỬA ĐỔI BẮT BUỘC TRƯỚC KHI KHÓA BÀI

## ISSUE 1 — Sai/không nhất quán về tỷ số chi phí

### Hiện tại

Abstract và phần thảo luận nói:

> “chi phí ... cao hơn khoảng 25,4 lần”

Trong khi số liệu:

- Cost-optimal = 5.291,8573 USD
- Displacement-optimal = 139.831,4792 USD
- ΔC = 2.542,2%

Tỷ số:

> 139.831,4792 / 5.291,8573 ≈ **26,42 lần**

Còn:

> (139.831,4792 − 5.291,8573) / 5.291,8573 = **2.542,2%**

### Cách sửa

Thống nhất thành:

> **“chi phí tăng 2.542,2%, tương đương khoảng 26,4 lần.”**

Áp dụng cho:

- Tóm tắt tiếng Việt;
- Abstract tiếng Anh;
- Mục 4.3;
- Kết luận nếu có nhắc lại.

### Mức độ

**P1 — Bắt buộc sửa.**

---

# 4. ISSUE 2 — “Kiểm chứng framework” hơi mạnh

### Hiện tại

Kết luận viết:

> “Nghiên cứu đã triển khai và kiểm chứng framework liên kết SAP2000-MATLAB-SFOA...”

### Vấn đề

Bài:

- chỉ khảo sát một hệ MJP;
- không có benchmark độc lập;
- không có nghiệm exact/global optimum;
- không so sánh với thuật toán đối chứng;
- không có validation bằng mô hình/giải pháp độc lập.

Do đó “kiểm chứng framework” có thể khiến reviewer hỏi:

> Framework được kiểm chứng với reference nào?

### Đề xuất

Thay bằng:

> **“Nghiên cứu đã xây dựng và đánh giá framework liên kết SAP2000-MATLAB-SFOA...”**

hoặc:

> “Nghiên cứu đã triển khai và đánh giá framework...”

### Khuyến nghị

Tôi ưu tiên:

> **“xây dựng và đánh giá framework”**

### Mức độ

**P1 — Nên sửa.**

---

# 5. ISSUE 3 — TCVN 10304:2014 và TCVN 10304:2025

Revision 8 đã xử lý vấn đề này tốt hơn trước.

Bài đã nói rõ:

- mô hình hiện tại dùng TCVN 10304:2014;
- 2014 đã được thay thế bởi 2025;
- cập nhật sang 2025 là hướng nghiên cứu tiếp theo.

### Tuy nhiên

Câu:

> “phiên bản hiện hành tại thời điểm xây dựng mô hình”

nên tránh nếu không có căn cứ cụ thể về thời điểm.

### Đề xuất

Viết:

> “Mô hình tính sức chịu tải cọc trong nghiên cứu được xây dựng theo TCVN 10304:2014; do đó các kết quả cần được hiểu trong phạm vi bộ tiêu chuẩn này. Việc cập nhật mô hình theo TCVN 10304:2025 được xác định là hướng hoàn thiện trong các nghiên cứu tiếp theo.”

### Không được

- đổi [3] sang TCVN 10304:2025 nếu campaign chưa chạy lại;
- tuyên bố kết quả hiện tại tuân thủ TCVN 10304:2025;
- gọi 10304:2014 là “tiêu chuẩn hiện hành”.

### Mức độ

**P1 — Bắt buộc kiểm tra/sửa câu chữ.**

---

# 6. ISSUE 4 — Tải trọng LL

Revision 8 đã minh bạch hơn:

> LL = 9,81 kN/m² là giả định của mô hình, không lấy trực tiếp từ một tiêu chuẩn tải trọng cụ thể.

Đây là cách trình bày trung thực.

### Tuy nhiên

Cần tránh gọi:

> “tổ hợp chi phối”

nếu không có khảo sát đầy đủ các tổ hợp tải trọng thực tế.

Hiện bài viết:

> “COMB2 = DL+LL — tổ hợp chi phối cho cầu cảng chính trong điều kiện khai thác thông thường”

Đây là một claim hơi mạnh.

### Đề xuất

Đổi thành:

> **“COMB2 = DL+LL được sử dụng làm tổ hợp khai thác chính trong mô hình nghiên cứu.”**

Cách này chính xác hơn.

### Mức độ

**P1 — Nên sửa.**

---

# 7. ISSUE 5 — Bảng 2: không được hiểu rằng TCVN cung cấp đơn giá

Hiện tiêu đề:

> “Đơn giá cọc bê tông ly tâm dự ứng lực tham chiếu ... theo TCVN 7888:2014”

Trong khi TCVN 7888 chủ yếu cung cấp:

- quy cách;
- kích thước;
- cấp cọc.

Không cung cấp đơn giá USD/m.

### Đề xuất đổi tiêu đề

> **Bảng 2. Danh mục loại cọc và đơn giá vật liệu tham chiếu sử dụng trong nghiên cứu**

### Chú thích

> “Thông số hình học và cấp cọc được lựa chọn theo TCVN 7888:2014 [2]; đơn giá Pp là dữ liệu kinh tế quy ước sử dụng trong mô hình nghiên cứu.”

### Mức độ

**P1 — Nên sửa.**

---

# 8. ISSUE 6 — Penalty function

Đây vẫn là hạn chế phương pháp luận đáng chú ý nhất.

Bài hiện dùng:

- g1: kN·m;
- g2: kN;
- cộng trực tiếp;
- λ = 10^6;
- sau đó cộng penalty vào Cost (USD) hoặc Displacement (m).

Về mặt thứ nguyên, đây không phải penalty đã chuẩn hóa.

### Điểm tốt

Revision 8 đã tự nhận rõ hạn chế này.

### Khuyến nghị

**Không sửa thuật toán trong Paper 1.**

Không chạy lại campaign chỉ vì vấn đề này.

Chỉ cần:

1. giữ mô tả đúng implementation;
2. giữ citation về constraint handling;
3. gọi đây là hạn chế;
4. đưa chuẩn hóa penalty thành hướng cải tiến cho MOSFOA.

### Mức độ

**P2 — Không cần mở rộng thêm.**

---

# 9. ISSUE 7 — DesignConcrete và tiêu chuẩn CSA A23.3-14

Revision 8 đã làm rõ một vấn đề quan trọng:

> DesignConcrete thực tế dùng **CSA A23.3-14**, không phải TCVN 5574.

Đây là một điểm rất tốt vì đã tránh được việc trích dẫn sai tiêu chuẩn.

### Khuyến nghị

Không thêm TCVN 5574:2018 chỉ để làm bài “đẹp”.

Nếu campaign thực tế dùng CSA A23.3-14 thì:

- giữ đúng CSA A23.3-14;
- nêu rõ đây là thiết lập kế thừa;
- coi sự không đồng nhất TCVN/CSA là giới hạn.

### Nhưng cần kiểm tra

Nếu bài ghi:

> “tiêu chuẩn thiết kế bê tông cốt thép được gán trong mô hình là CSA A23.3-14”

thì nên có tài liệu tham khảo chính thức của CSA nếu tạp chí yêu cầu bibliography đầy đủ.

Nếu không có bản tiêu chuẩn/nguồn chính thức trong hồ sơ nghiên cứu, ít nhất phải bảo đảm tên và phiên bản chính xác.

### Mức độ

**P1/P2 — Kiểm tra lại nguồn thực tế.**

---

# 10. ISSUE 8 — Tài liệu tham khảo

Revision 8 đã bổ sung:

- [4] Turgut et al. (2023) — metaheuristic review;
- [5] Deb (2000) — constraint handling.

Đây là hướng đúng.

Danh mục hiện có:

1. SFOA;
2. TCVN 7888:2014;
3. TCVN 10304:2014;
4. Turgut et al. (2023);
5. Deb (2000).

### Đánh giá

**Đủ cho phạm vi Paper 1**, nếu các tiêu chuẩn khác không thực sự được dùng.

Không cần cố bổ sung 10–20 tài liệu.

### Tuy nhiên

Cần kiểm tra lần cuối:

- [1] được trích đúng nơi;
- [2] đúng nơi;
- [3] đúng nơi;
- [4] đúng nơi;
- [5] đúng nơi;
- không có reference không được trích dẫn;
- không có citation không tồn tại trong References.

---

# 11. ISSUE 9 — Câu “SFOA đã được kiểm chứng tốt”

Hiện:

> “SFOA đã được kiểm chứng tốt trên nhiều hàm benchmark và một số bài toán kỹ thuật...”

### Đề xuất

Đổi thành:

> **“Bài báo gốc của SFOA đã đánh giá thuật toán trên nhiều hàm benchmark và một số bài toán kỹ thuật [1].”**

Lý do:

- ít chủ quan hơn;
- citation [1] hỗ trợ trực tiếp;
- tránh claim “tốt” mang tính đánh giá.

### Mức độ

**P2 — Proofreading học thuật.**

---

# 12. ISSUE 10 — Tên tiếng Anh

Tên tiếng Việt:

> Nghiên cứu đánh giá khả năng ứng dụng thuật toán tối ưu sao biển trong bài toán tối ưu đơn mục tiêu kết cấu công trình biển

**Giữ nguyên.**

Tên tiếng Anh hiện tại:

> A study evaluating the applicability of the starfish optimization algorithm to single-objective optimization of marine structures

### Đề xuất

> **Study on the Applicability of the Starfish Optimization Algorithm to Single-Objective Optimization of Marine Structures**

Không cần viết “A study evaluating...”.

---

# 13. ABSTRACT — Đánh giá

Abstract Revision 8 đã tốt.

Cấu trúc hiện tại đúng:

1. mục tiêu;
2. đối tượng;
3. phương pháp;
4. experimental design;
5. kết quả;
6. trade-off;
7. giới hạn SOO;
8. động lực MOSFOA.

### Chỉ sửa

**25,4 lần → 26,4 lần**, và nên diễn đạt cùng với 2.542,2%.

Đề nghị câu:

> “chi phí của nghiệm displacement-optimal cao hơn 2.542,2%, tương đương khoảng 26,4 lần so với nghiệm cost-optimal...”

English:

> “the cost of the displacement-optimal solution is 2,542.2% higher, equivalent to approximately 26.4 times the cost-optimal solution...”

---

# 14. KẾT LUẬN — Đánh giá

Kết luận hiện khá tốt.

Điểm mạnh:

- không nói SFOA tốt nhất;
- không nói Pareto;
- nhắc đúng CV;
- nhắc trade-off;
- chỉ ra giới hạn SOO;
- mở sang MOSFOA;
- thừa nhận chỉ một MJP.

### Chỉ sửa

> “kiểm chứng framework”

→

> **“xây dựng và đánh giá framework”**

Và:

> “chi phí tăng khoảng 25,4 lần”

→

> **“chi phí tăng 2.542,2%, tương đương khoảng 26,4 lần.”**

---

# 15. CÁC NỘI DUNG KHÔNG NÊN THÊM Ở REVISION 8

Không mở rộng:

- PSO;
- GA;
- DE;
- GWO;
- benchmark 100 thuật toán;
- sensitivity analysis;
- Pareto front;
- thêm objective;
- thêm case study;
- chạy lại 30 × 2;
- phát triển MOSFOA ngay trong Paper 1;
- thay penalty hiện tại bằng penalty mới;
- cập nhật toàn bộ mô hình sang TCVN 10304:2025.

Các nội dung trên thuộc Paper 2 hoặc nghiên cứu tiếp theo.

---

# 16. CHECKLIST FINAL LOCK

## Nội dung

- [ ] Giữ tên tiếng Việt.
- [ ] Sửa tên tiếng Anh.
- [ ] Sửa 25,4 lần → 26,4 lần.
- [ ] Giữ 2.542,2%.
- [ ] Giữ phân tích plateau.
- [ ] Giữ cảnh báo “không phải Pareto front”.
- [ ] Giữ cảnh báo “không xếp hạng SFOA”.
- [ ] Sửa “kiểm chứng framework” → “xây dựng và đánh giá framework”.
- [ ] Sửa “tổ hợp chi phối” → “tổ hợp khai thác chính trong mô hình” nếu không có khảo sát đầy đủ.
- [ ] Làm rõ 10304:2014/2025.
- [ ] Sửa tiêu đề/chú thích Bảng 2.
- [ ] Kiểm tra CSA A23.3-14.

## References

- [ ] [1] SFOA — đúng.
- [ ] [2] TCVN 7888:2014 — đúng.
- [ ] [3] TCVN 10304:2014 — giữ nếu campaign dùng 2014.
- [ ] [4] Turgut et al. 2023 — citation đúng claim metaheuristic.
- [ ] [5] Deb 2000 — citation đúng claim penalty.
- [ ] Không thêm tài liệu chỉ để tăng số lượng.

## Hình/bảng

- [ ] Hình 1: ghi rõ Best run + Min-Max band.
- [ ] Hình 2: ghi rõ đường nối không phải Pareto front.
- [ ] Bảng 2: tách TCVN khỏi nguồn đơn giá.
- [ ] Bảng 5: thống nhất cách ghi “min”.
- [ ] Bảng 6: kiểm tra dấu ΔCost và ΔD.
- [ ] Bảng 7: kiểm tra công thức và số liệu 2.542,2%.
- [ ] Bảng 8: giữ thông tin môi trường để tái lập.

---

# 17. ĐÁNH GIÁ CUỐI CÙNG

### Revision 8 hiện tại

**Nội dung nghiên cứu:** 9/10  
**Logic khoa học:** 9/10  
**Phương pháp:** 8/10  
**Kết quả:** 9/10  
**Thảo luận:** 9/10  
**Tính trung thực/không overclaim:** 9,5/10  
**References:** 8/10  
**Trình bày:** 8,5/10

### Mức sẵn sàng

> **Khoảng 90–95% để gửi tạp chí.**

Chỉ cần một vòng **Final Polish**, không cần mở rộng nghiên cứu.

---

# 18. REVIEWER DECISION ĐỀ XUẤT

> **Khuyến nghị: Minor Revision — Chấp nhận sau khi sửa chữa nhỏ.**

### Lý do

Bài có:

- vấn đề nghiên cứu rõ;
- mục tiêu rõ;
- framework rõ;
- experimental design có lặp 30 lần;
- phân tích thống kê cơ bản;
- phân tích trade-off;
- nhận diện đúng giới hạn của SOO;
- định hướng MOSFOA hợp lý.

Các vấn đề còn lại chủ yếu thuộc:

- consistency;
- wording;
- tiêu chuẩn;
- citation;
- một sai lệch nhỏ trong cách diễn đạt tỷ số chi phí.

Không có lý do để mở rộng phạm vi nghiên cứu ở Paper 1.

---

# 19. QUAN ĐIỂM CHIẾN LƯỢC

Paper 1 nên được khóa với thông điệp:

> **“Nghiên cứu này không nhằm chứng minh SFOA là thuật toán tối ưu tốt nhất; nghiên cứu nhằm đánh giá khả năng áp dụng SFOA nguyên bản cho SOO kết cấu công trình biển, định lượng tính ổn định và chỉ ra rằng việc tối ưu độc lập chi phí và chuyển vị dẫn đến các nghiệm cực trị khác biệt rõ rệt. Kết quả đó tạo cơ sở để chuyển sang bài toán MOO/MOSFOA.”**

Đây là vị trí khoa học phù hợp cho Paper 1.

**Không nên cố biến Paper 1 thành một bài benchmark thuật toán.**

---

# FINAL ACTION

Thực hiện đúng các sửa đổi P1:

1. **26,4 lần / 2.542,2%.**
2. **“xây dựng và đánh giá framework”.**
3. **Làm rõ TCVN 10304:2014/2025.**
4. **“COMB2 là tổ hợp khai thác chính trong mô hình” thay cho “tổ hợp chi phối” nếu không có khảo sát đầy đủ.**
5. **Sửa Bảng 2 để không hiểu TCVN cung cấp đơn giá.**
6. **Kiểm tra CSA A23.3-14 và citation.**
7. Proofread cuối toàn bài.

Sau đó:

> **KHÓA PAPER 1.**

Không mở rộng thêm nội dung nghiên cứu.
