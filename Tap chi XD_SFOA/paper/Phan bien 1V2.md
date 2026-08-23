# REVIEW REPORT — PAPER 1 (BẢN RÀ SOÁT SAU SỬA)

## Ứng dụng thuật toán tối ưu sao biển cho tối ưu đơn mục tiêu kết cấu công trình biển

**Phiên bản:** Rà soát lần 2  
**Bối cảnh:** NCS mới tiếp cận SOO, bài báo tiếng Việt, định hướng tạp chí Xây dựng trong nước.  
**Cơ sở:** Bản thảo 9 trang đã sửa.

---

# 1. KẾT LUẬN PHẢN BIỆN

### Recommendation hiện tại: MINOR REVISION / MAJOR REVISION NHẸ

Bản sửa đã cải thiện rõ rệt so với phiên bản trước. Các vấn đề lớn về định nghĩa chi phí, minh bạch ràng buộc, reproducibility, CV = 0%, cách diễn đạt quan hệ đánh đổi và phân biệt ba điểm thiết kế với Pareto front đã được xử lý tốt.

Bản thảo hiện đã có cấu trúc và mức độ minh bạch phù hợp với một bài SOO ứng dụng kết cấu cho tạp chí chuyên ngành Xây dựng trong nước.

**Không đề nghị thay đổi hướng nghiên cứu.**

Không cần bổ sung:
- PSO/GA/DE/GWO;
- Pareto front;
- NSGA-II/MOPSO;
- BD/MD;
- phát triển MOSFOA trong chính bài này.

Tuy nhiên, trước khi khóa bài cần kiểm tra 5 vấn đề kỹ thuật dưới đây. Trong đó **hai vấn đề đầu tiên là ưu tiên cao nhất**.

---

# 2. CÁC ĐIỂM ĐÃ ĐƯỢC SỬA TỐT

## 2.1. Định nghĩa "chi phí vật liệu"

Bản mới đã chuyển từ "construction cost" sang **chi phí vật liệu quy ước của cọc và dầm**, đồng thời nêu rõ các thành phần không bao gồm.

**Đánh giá: Đã đạt.**

## 2.2. Quan hệ đánh đổi

Bản mới đã giới hạn kết luận ở **hai nghiệm cực trị** và nói rõ đây chưa phải Pareto front.

**Đánh giá: Đã đạt. Giữ nguyên logic này.**

## 2.3. CV = 0%

Bản mới đã giải thích 30 Best đều bằng nhau, không cố định seed và liên hệ kết quả với không gian thiết kế rời rạc.

**Đánh giá: Đã đạt ở mức bài báo hiện tại.**

## 2.4. Tính tái lập

Bảng môi trường tính toán đã có MATLAB, SAP2000, CPU, RAM, OS, Npop, số vòng, số run và random seed.

**Đánh giá: Đã đạt.**

## 2.5. Constraint và penalty

Bảng ràng buộc đã có hard gate, soft penalty, moment, axial force, điều kiện địa chất, khe hở, hệ số phạt và tolerance.

**Đánh giá: Cải thiện rất mạnh.**

---

# 3. MAJOR ISSUE 1 — PHẢI KIỂM TRA DẦM CÓ THỰC SỰ ĐƯỢC KIỂM TRA AN TOÀN HAY KHÔNG

## Vấn đề

Hàm chi phí lấy khối lượng cốt thép dầm từ SAP2000 DesignConcrete, trong khi `b, h` là biến thiết kế.

Tuy nhiên Bảng 1 hiện mới thể hiện rõ các ràng buộc liên quan đến cọc, đất, khe hở, mô men cọc và sức chịu tải cọc.

Chưa thấy rõ constraint riêng cho:
- sức chịu lực dầm;
- cốt thép dầm;
- moment dầm;
- shear dầm;
- trạng thái DesignConcrete.

## Cần kiểm tra

### Nếu DesignConcrete thực sự được chạy ở mỗi evaluation

Bổ sung mô tả và constraint tương ứng:

> Sau khi cập nhật kích thước dầm, SAP2000 thực hiện thiết kế cấu kiện bê tông cốt thép; cấu hình chỉ được xem là khả thi khi các cấu kiện dầm thỏa yêu cầu thiết kế.

### Nếu DesignConcrete chỉ dùng để lấy lượng thép

Đây là **lỗi phương pháp quan trọng**; phải bổ sung kiểm tra dầm trước khi khóa kết quả.

**Trạng thái:** [ ] CHƯA XÁC MINH  
**Mức độ:** BẮT BUỘC KIỂM TRA

---

# 4. MAJOR ISSUE 2 — PHẢI THỐNG NHẤT DL+LL VÀ "ENVELOPE CỦA DL VÀ LL"

Mục 2.3 mô tả tổ hợp `DL+LL`, trong khi mục 2.5 mô tả Dmax dưới "tổ hợp bao (envelope) của DL và LL".

Hai cách này không hoàn toàn tương đương.

## Cần kiểm tra trực tiếp trong SAP2000

- Load Case;
- Load Combination;
- Envelope;
- hoặc Combination DL+LL

đang được truy xuất bởi `JointDisplAbs`.

### Nếu thực tế là DL+LL

Thống nhất toàn bài thành:

> "dưới tổ hợp DL+LL".

### Nếu thực tế là Envelope

Mô tả rõ envelope gồm những case/combo nào và vì sao sử dụng.

**Trạng thái:** [ ] CHƯA XÁC MINH  
**Mức độ:** BẮT BUỘC KIỂM TRA

---

# 5. MAJOR ISSUE 3 — KIỂM TRA LẠI Dmax = 0,0000388 m

Giá trị hiện tại:

`0,0000388 m = 0,0388 mm`

rất nhỏ so với:
- Cost-optimal: 1,02 mm;
- Current: 0,22445 mm.

Không tự động coi là sai, nhưng phải xác minh.

## Kiểm tra

- [ ] Node;
- [ ] DOF;
- [ ] đơn vị;
- [ ] load combination;
- [ ] định nghĩa resultant;
- [ ] boundary condition;
- [ ] mô hình đất/nền;
- [ ] `JointDisplAbs`;
- [ ] baseline.

Nếu đúng: giữ số liệu và mô tả rõ cách xác định Dmax.

Nếu sai: cập nhật Abstract, Bảng 4–7, Hình 2 và Kết luận.

**Trạng thái:** [ ] CHƯA XÁC MINH  
**Mức độ:** ƯU TIÊN RẤT CAO

---

# 6. MAJOR ISSUE 4 — KIỂM TRA SỨC CHỊU TẢI NÉN VÀ NHỔ

Bản thảo dùng `|F3,i|` để bao gồm cả nén và nhổ và so sánh với `Np`.

Cần kiểm tra theo TCVN xem có được dùng chung một giới hạn cho:
- sức chịu tải nén;
- sức chịu tải nhổ.

Nếu hai giới hạn khác nhau, phải tách constraint.

**Trạng thái:** [ ] CẦN KIỂM TRA THEO TCVN  
**Mức độ:** BẮT BUỘC XÁC MINH, nhưng chưa kết luận là sai.

---

# 7. MAJOR ISSUE 5 — GIẢM CÁC CLAIM CƠ HỌC QUÁ MẠNH

## 7.1. "Gần như cứng tuyệt đối"

Không nên viết:

> "tạo ra một hệ gần như cứng tuyệt đối".

Nên viết:

> "cấu hình có độ cứng lớn nhất trong không gian thiết kế được khảo sát"

hoặc:

> "cấu hình cho chuyển vị nhỏ nhất trong tập phương án khả thi".

## 7.2. Quan hệ I ~ D^4

Với tiết diện ống:

`I = π/64 (Do^4 - Di^4)`

Do `t` cũng là biến thiết kế, không nên viết đơn giản `I ∝ D^4`.

Nên viết:

> "Độ cứng uốn của cọc tăng mạnh khi đường kính ngoài tăng do mô men quán tính của tiết diện ống phụ thuộc vào hiệu Do^4 - Di^4."

## 7.3. Quan hệ chuyển vị theo L^3

Không nên viết:

> "giảm mạnh theo lập phương nhịp cột"

Nên viết:

> "việc giảm nhịp làm tăng đáng kể độ cứng tổng thể của hệ."

**Trạng thái:** [ ] CHƯA SỬA  
**Mức độ:** NÊN SỬA

---

# 8. MAJOR ISSUE 6 — BỎ TỪ "ĐỘ NHẠY"

Bản thảo hiện dùng cụm "độ nhạy của chi phí..." nhưng hai nghiệm cực trị chưa phải sensitivity analysis.

Nên sửa thành:

> "Kết quả cho thấy mức tăng chi phí giữa hai nghiệm cực trị lớn hơn đáng kể so với mức tăng tương đối của chuyển vị."

**Trạng thái:** [ ] CHƯA SỬA  
**Mức độ:** NÊN SỬA

---

# 9. MAJOR ISSUE 7 — KIỂM TRA CÂU "1,02 mm TRONG GIỚI HẠN TCVN"

Bản thảo nói 1,02 mm nằm trong giới hạn an toàn của TCVN đối với chuyển vị cầu cảng.

Cần xác định chính xác tiêu chuẩn và điều khoản quy định giới hạn chuyển vị này.

Nếu có nguồn:
- bổ sung citation;
- ghi rõ điều khoản.

Nếu chưa có:
- bỏ cụm "trong giới hạn an toàn của TCVN";
- dùng cách diễn đạt thận trọng hơn.

**Trạng thái:** [ ] CHƯA XÁC MINH  
**Mức độ:** BẮT BUỘC KIỂM TRA NGUỒN

---

# 10. MAJOR ISSUE 8 — KẾT LUẬN "SFOA GIẢI TỐT"

Không nên viết quá mạnh:

> "SFOA giải tốt từng bài toán đơn mục tiêu"

Nên viết:

> "SFOA nguyên bản cho nghiệm khả thi và có tính ổn định giữa các lần chạy đối với hai bài toán đơn mục tiêu khảo sát."

Lý do: nghiên cứu không có benchmark với thuật toán khác.

**Trạng thái:** [ ] CHƯA SỬA  
**Mức độ:** NÊN SỬA

---

# 11. NHỮNG NỘI DUNG KHÔNG CẦN LÀM THÊM

Không cần mở rộng Paper 1 bằng:

- [ ] PSO;
- [ ] GA;
- [ ] DE;
- [ ] GWO;
- [ ] NSGA-II;
- [ ] MOPSO;
- [ ] Pareto front;
- [ ] BD;
- [ ] MD;
- [ ] phát triển MOSFOA trong bài này;
- [ ] sensitivity analysis lớn;
- [ ] statistical tests phức tạp.

Paper 1 nên giữ logic:

`SOO baseline → hai nghiệm cực trị → trade-off → cơ sở cho MOSFOA`.

---

# 12. CHECKLIST RÀ SOÁT MÔ HÌNH SAP2000

## Hình học
- [ ] MJP đúng hình học.
- [ ] Dầm dọc/ngang đúng.
- [ ] Bản mặt cầu đúng.
- [ ] Số lượng cọc đúng.
- [ ] Khoảng cách cọc đúng.
- [ ] Chiều dài cọc đúng.

## Vật liệu
- [ ] Vật liệu cọc đúng.
- [ ] Bê tông dầm đúng.
- [ ] Cốt thép đúng.
- [ ] Đơn vị đúng.

## Tải
- [ ] DL đúng.
- [ ] LL đúng.
- [ ] Tổ hợp sử dụng đúng.
- [ ] Dmax dùng đúng tổ hợp.

## Boundary conditions
- [ ] Đầu cọc.
- [ ] Liên kết cọc-dầm.
- [ ] Liên kết dầm-bản.
- [ ] Điều kiện đất/nền.

---

# 13. CHECKLIST RÀ SOÁT SOO

- [ ] Vector thiết kế đúng.
- [ ] Miền thiết kế đúng.
- [ ] Tập giá trị rời rạc đúng.
- [ ] Mapping continuous → discrete đúng.
- [ ] Hard gate đúng.
- [ ] Soft penalty đúng.
- [ ] Objective Cost đúng.
- [ ] Objective Displacement đúng.
- [ ] Best-of-run đúng.
- [ ] Mean/STD/CV đúng.
- [ ] 30 runs thực sự độc lập.
- [ ] Random seed đúng.
- [ ] Npop = 30.
- [ ] Nit = 150.
- [ ] Điều kiện dừng đúng.

---

# 14. CHECKLIST RÀ SOÁT COST

`C(x) = Np Lp Pp + Vb Pc + Ws Ps`

- [ ] Số lượng cọc Np.
- [ ] Chiều dài Lp.
- [ ] Đơn giá cọc Pp.
- [ ] Thể tích dầm Vb.
- [ ] Đơn giá bê tông Pc.
- [ ] Khối lượng thép Ws.
- [ ] Đơn giá thép Ps.
- [ ] Density 7.849 kg/m3.
- [ ] DesignConcrete thực sự được gọi.
- [ ] Cốt thép dầm là lượng thiết kế hay lượng bố trí.
- [ ] Dầm có kiểm tra đạt/không đạt hay chưa.
- [ ] Cost được gọi đúng là material cost.

---

# 15. CHECKLIST RÀ SOÁT DISPLACEMENT

`D(x) = Dmax(x)`

- [ ] Di là resultant ba phương.
- [ ] Node set đúng.
- [ ] `JointDisplAbs` đúng.
- [ ] Load combination đúng.
- [ ] DL+LL hay Envelope đã được thống nhất.
- [ ] Dmax lấy trên toàn bộ nút.
- [ ] Đơn vị m.
- [ ] 0,0000388 m đã được xác minh.
- [ ] 0,00102 m đã được xác minh.
- [ ] 0,00022445 m baseline đã được xác minh.

---

# 16. CHECKLIST RÀ SOÁT CONSTRAINT

## Hard gate
- [ ] Chiều dài cọc.
- [ ] Điều kiện đất.
- [ ] IL.
- [ ] Chiều dày đất dưới mũi.
- [ ] Khe hở cọc-dầm.
- [ ] Các điều kiện hình học khác nếu có.

## Soft penalty
- [ ] M2.
- [ ] M3.
- [ ] Axial compression.
- [ ] Uplift.
- [ ] Dầm nếu có.

## Penalty
- [ ] Hard penalty = 10^9.
- [ ] Soft penalty λ = 10^6.
- [ ] p = 1.
- [ ] Tolerance = 10^-9.
- [ ] Không có sai đơn vị giữa objective và penalty.

---

# 17. CHECKLIST RÀ SOÁT KẾT QUẢ

## MJP-C

- [ ] Cost = 5.291,8573 USD.
- [ ] D = 300 mm.
- [ ] t = 60 mm.
- [ ] L = 37,8 m.
- [ ] LL = 5,3 m.
- [ ] LT = 5,6 m.
- [ ] b = 0,5 m.
- [ ] h = 0,5 m.
- [ ] Dmax = 0,00102 m.
- [ ] Tất cả constraint đạt.

## MJP-D

- [ ] Cost = 139.831,4792 USD.
- [ ] D = 1.200 mm.
- [ ] t = 150 mm.
- [ ] L = 16,8 m.
- [ ] LL = 3,0 m.
- [ ] LT = 3,0 m.
- [ ] b = 1,4 m.
- [ ] h = 2,0 m.
- [ ] Dmax = 0,0000388 m.
- [ ] Tất cả constraint đạt.

## Baseline

- [ ] Cost = 25.708,9425 USD.
- [ ] Dmax = 0,00022445 m.
- [ ] Cấu hình 500-B.
- [ ] Kết quả được tái tạo trực tiếp.

---

# 18. CHECKLIST RÀ SOÁT TRADE-OFF

`ΔC = (CD - CC*) / CC* × 100%`

- [ ] ΔC = 2.542,2%.
- [ ] Chi phí tăng khoảng 25,4 lần.

`ΔD = (DC - DD*) / DC × 100%`

- [ ] ΔD = 96,2%.

Baseline:
- [ ] Cost giảm 79,4% ở MJP-C.
- [ ] Displacement tăng 353,7%.
- [ ] Cost tăng 443,9% ở MJP-D.
- [ ] Displacement giảm 82,7%.

---

# 19. CÁC CÂU NÊN SỬA

## Câu 1

**Hiện tại:**

> SFOA giải tốt từng bài toán đơn mục tiêu.

**Đề nghị:**

> SFOA nguyên bản cho nghiệm khả thi và có tính ổn định giữa các lần chạy đối với hai bài toán đơn mục tiêu khảo sát.

## Câu 2

**Hiện tại:**

> cấu hình cọc lớn nhất/nhịp nhỏ nhất tạo ra một hệ gần như cứng tuyệt đối...

**Đề nghị:**

> cấu hình cọc lớn nhất/nhịp nhỏ nhất cho độ cứng lớn nhất và chuyển vị nhỏ nhất trong không gian thiết kế khả thi được khảo sát.

## Câu 3

**Hiện tại:**

> độ nhạy của chi phí với yêu cầu độ cứng lớn hơn nhiều...

**Đề nghị:**

> mức tăng chi phí giữa hai nghiệm cực trị lớn hơn đáng kể so với mức tăng tương đối của chuyển vị.

## Câu 4

**Hiện tại:**

> mô men quán tính tiết diện tỉ lệ D^4

**Đề nghị:**

> mô men quán tính của tiết diện ống phụ thuộc vào hiệu Do^4 - Di^4, do đó độ cứng uốn tăng mạnh khi đường kính ngoài tăng.

## Câu 5

**Hiện tại:**

> giảm mạnh theo lập phương nhịp cột

**Đề nghị:**

> việc giảm nhịp làm tăng đáng kể độ cứng tổng thể của hệ.

---

# 20. PHÁN QUYẾT SAU CÙNG

## Nếu 5 kiểm tra quan trọng đều đạt

Nếu xác nhận:

1. Dầm được kiểm tra đầy đủ;
2. DL+LL/envelope được thống nhất;
3. Dmax = 0,0000388 m đúng;
4. nén/nhổ được xử lý đúng theo TCVN;
5. claim về giới hạn chuyển vị có nguồn phù hợp hoặc được bỏ;

thì:

> **Recommendation: MINOR REVISION**

và bài có thể chuyển sang bước hoàn thiện cuối.

## Nếu phát hiện lỗi ở dầm hoặc load combination

Nếu phát hiện:
- dầm chưa được kiểm tra; hoặc
- Dmax dùng sai tổ hợp tải;

thì:

> **Recommendation: MAJOR REVISION**

nhưng vẫn là sửa phương pháp, không phải thay đổi hướng nghiên cứu.

---

# 21. ĐÁNH GIÁ CUỐI CÙNG

Bản sửa hiện tại đã chuyển từ một bản thảo có nhiều khoảng trống về phương pháp thành một nghiên cứu SOO tương đối hoàn chỉnh, có:

- mô hình kết cấu;
- biến thiết kế;
- hàm mục tiêu;
- constraint;
- penalty;
- 30 independent runs;
- đánh giá thống kê;
- kiểm tra hội tụ;
- phân tích trade-off;
- computational cost;
- môi trường tính toán;
- giới hạn nghiên cứu.

Điểm quan trọng là **không cần mở rộng phạm vi nghiên cứu**.

Việc còn lại chủ yếu là **kiểm chứng mô hình và làm sạch một số phát biểu khoa học**.

### Recommendation:

> **MINOR REVISION — sau khi xác minh các điểm kỹ thuật nêu trên.**

---

# 22. THỨ TỰ LÀM VIỆC KHUYẾN NGHỊ

### Bước 1 — Kiểm tra mô hình SAP2000

**Dầm → Load combination → Dmax → Constraint nén/nhổ**

### Bước 2 — Kiểm tra dữ liệu output

**30 runs → nghiệm MJP-C → nghiệm MJP-D → baseline**

### Bước 3 — Sửa các claim

**Cứng tuyệt đối → D^4 → L^3 → độ nhạy → TCVN chuyển vị**

### Bước 4 — Kiểm tra chéo bảng/hình/text

### Bước 5 — Chốt Paper 1
