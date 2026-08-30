# REVIEWER REPORT – PAPER 1 – REVISION 6

## Vai trò phản biện

Tôi đọc bản Revision 6 với vai trò **phản biện xây dựng cho một NCS mới tiếp cận lĩnh vực tối ưu đơn mục tiêu (SOO)**, bài báo dự kiến gửi **tạp chí khoa học xây dựng trong nước**.

Mục tiêu phản biện không phải yêu cầu bài báo đạt chuẩn của một bài báo quốc tế về thuật toán tối ưu, mà là kiểm tra:

1. Câu hỏi nghiên cứu có rõ và vừa sức với một bài SOO đầu tiên hay không.
2. Phương pháp có đủ minh bạch để người đọc kỹ thuật xây dựng hiểu và tái lập ở mức hợp lý hay không.
3. Kết quả có thực sự chứng minh đúng những gì tác giả tuyên bố hay không.
4. Có lỗi phương pháp luận nào đủ nghiêm trọng để phải sửa trước khi gửi tạp chí hay không.
5. Các hạn chế có được thừa nhận đúng mức hay chưa.

---

# 1. ĐÁNH GIÁ TỔNG QUAN

## Đánh giá chung

Bản Revision 6 đã tiến bộ rõ rệt so với các phiên bản trước.

Điểm mạnh nổi bật:

- Phạm vi nghiên cứu đã được khóa vào **SOO**, không còn cố biến bài báo thành bài MOO.
- Hai bài toán `Min Cost` và `Min Displacement` được định nghĩa rõ.
- Framework SAP2000–MATLAB–SFOA được mô tả khá đầy đủ.
- Có 30 lần chạy độc lập cho mỗi case.
- Có Best/Mean/Max/STD/CV.
- Đã giải thích hiện tượng `CV = 0%` của displacement không đồng nghĩa với 30 lần chạy tạo ra cùng một vector thiết kế.
- Đã phân biệt rõ “trade-off tại hai nghiệm cực trị” với Pareto front.
- Đã thận trọng hơn khi nói về giới hạn chuyển vị.
- Đã thừa nhận không có cơ sở xếp hạng SFOA vì chưa so sánh PSO/GA/DE/GWO.
- Đã nêu rõ chỉ có một hệ MJP được khảo sát.
- Đã cung cấp môi trường tính toán và thời gian chạy.

Đây là những chỉnh sửa đúng hướng và phù hợp với một bài báo SOO đầu tiên.

Tuy nhiên, **bản Revision 6 vẫn chưa nên được coi là bản final**. Có một vấn đề phương pháp luận cần xử lý dứt điểm trước khi gửi: **hàm phạt đang được cộng trực tiếp vào hai objective có đơn vị hoàn toàn khác nhau**.

---

# 2. VẤN ĐỀ QUAN TRỌNG NHẤT – HÀM PHẠT VÀ THỨ NGUYÊN

## Mức độ: MAJOR – cần xác minh trước khi submit

Manuscript hiện viết:

> P(x) = Σ λj [max(0, gj(x))]^p

và:

> FC(x) = C(x) + P(x); FD(x) = D(x) + P(x)

Đồng thời manuscript thừa nhận:

- `g1, g1'` có đơn vị kN·m;
- `g2` có đơn vị kN;
- `C(x)` có đơn vị USD;
- `D(x)` có đơn vị m;
- một hệ số `λ = 10^6` được dùng chung cho cả hai objective.

Bản Revision 6 đã chủ động đưa vấn đề này ra ánh sáng, đây là điểm tốt. Tuy nhiên, từ góc độ reviewer, **việc thừa nhận vấn đề chưa đủ để formulation trở thành chặt chẽ**.

### Reviewer yêu cầu tác giả làm rõ một việc duy nhất nhưng bắt buộc:

**Đối chiếu formulation trong manuscript với code MATLAB thực tế.**

Cụ thể cần xác nhận:

- Code thực sự tính `g1`, `g1'`, `g2` như thế nào?
- Code có normalize từng constraint trước khi nhân penalty hay không?
- `P(x)` trong code có thực sự được cộng trực tiếp vào `C(x)` và `D(x)` hay không?
- Giá trị fitness được SFOA sử dụng trong từng case chính xác là gì?
- Với một cá thể vi phạm nhỏ, penalty có thể lớn đến mức nào?
- Trong quá trình search, có cá thể vi phạm nào được dùng để so sánh với cá thể khả thi hay không?

### Hai trường hợp:

#### Trường hợp A – code đúng như manuscript

Nếu code thực sự dùng:

`FC = Cost + 1e6*(g1 + g1' + g2)`

và:

`FD = Disp + 1e6*(g1 + g1' + g2)`

thì formulation có vấn đề về thứ nguyên.

Không nên cố “biện hộ” bằng cách nói rằng `λ` rất lớn.

Cách xử lý an toàn cho Paper 1:

- giữ nguyên kết quả đã chạy;
- mô tả đây là **một penalty heuristic cố định phục vụ bài toán SOO hiện tại**;
- không gọi đây là formulation penalty chuẩn hóa;
- nêu rõ đây là hạn chế phương pháp;
- tuyệt đối không khẳng định tính tổng quát của `λ = 10^6`;
- không dùng kết quả penalty để đưa ra kết luận vượt quá những gì campaign đã kiểm chứng.

#### Trường hợp B – code thực tế đã normalize

Nếu code có normalize constraint nhưng manuscript chưa mô tả, phải sửa manuscript cho đúng code.

**Không được sửa manuscript theo hướng “đẹp hơn” nếu code thực tế không làm như vậy.**

---

# 3. VẤN ĐỀ THỨ HAI – CÓ THỂ GỌI LÀ “TỐI ƯU CHI PHÍ” HAY KHÔNG?

Hàm chi phí:

`C(x)=NpLpPp + VbPc + WsPs`

đã được giải thích là chi phí vật liệu quy ước của:

- cọc;
- bê tông dầm;
- cốt thép dầm.

Manuscript cũng đã nói rõ:

- không gồm bản mặt cầu;
- không gồm nhân công;
- không gồm thi công;
- không gồm đóng cọc;
- không gồm vận chuyển;
- không gồm chi phí gián tiếp.

Điều này là tốt.

Reviewer đề nghị giữ thuật ngữ:

**“chi phí vật liệu quy ước”**

hoặc:

**“chi phí vật liệu trong phạm vi nghiên cứu”**

thay vì gọi đơn giản là:

**“chi phí xây dựng”**

Hiện manuscript phần lớn đã làm đúng. Chỉ cần rà lại toàn bài để tránh một câu nào đó vô tình nâng `Cost` thành “construction cost”.

---

# 4. VẤN ĐỀ THỨ BA – “ĐỘ CỨNG” VÀ “CHUYỂN VỊ”

Objective thứ hai thực tế là:

`D(x) = Dmax(x)`

với Dmax là chuyển vị tổng hợp lớn nhất.

Do đó:

- đại lượng được tối ưu trực tiếp là **chuyển vị**;
- “độ cứng” là cách diễn giải cơ học gián tiếp.

Reviewer đề nghị dùng nhất quán:

**“tối thiểu chuyển vị lớn nhất”**

thay vì:

**“tối ưu độ cứng”**

trong các vị trí mô tả objective.

Có thể viết:

> “tối thiểu chuyển vị lớn nhất, qua đó hướng tới cấu hình có độ cứng tổng thể cao hơn”

nhưng không nên đồng nhất:

`min displacement = max stiffness`

vì hai đại lượng không hoàn toàn tương đương trong mọi bài toán.

---

# 5. VẤN ĐỀ THỨ TƯ – KẾT QUẢ “CV = 0%”

Đây là một điểm hiện tác giả xử lý khá tốt.

Manuscript đã giải thích:

- 30 Best-of-run của displacement có cùng giá trị Dmax;
- nhưng 25/30 run về 1200-C;
- 4/30 và 1/30 về các cấp cọc khác cùng D=1200;
- cùng nhịp 3.0×3.0 m;
- cùng kích thước dầm 1.4×2.0 m;
- Dmax không thay đổi trong độ phân giải được ghi nhận.

Đây là cách giải thích hợp lý.

### Tuy nhiên reviewer đề nghị đổi cách diễn đạt:

Không nên viết:

> “SFOA hội tụ ổn định hoàn toàn”

chỉ dựa vào CV=0%.

Nên viết:

> “SFOA cho giá trị Best-of-run của objective chuyển vị ổn định giữa 30 lần chạy, trong khi các vector thiết kế có thể khác nhau.”

Điều này chính xác hơn và phù hợp với bản chất bài toán rời rạc.

---

# 6. VẤN ĐỀ THỨ NĂM – KẾT QUẢ MJP-COST CV = 17,98%

CV = 17,98% là một kết quả quan trọng.

Reviewer khuyến nghị tác giả **không né tránh con số này**.

Nó cho thấy:

- bài toán cost khó hơn displacement;
- SFOA không cho cùng một kết quả Best-of-run trong tất cả các run;
- độ ổn định của thuật toán phụ thuộc objective.

Đây thực ra là một kết quả tốt cho bài báo vì tác giả đang đánh giá khả năng áp dụng của SFOA chứ không phải quảng bá SFOA.

Nên nhấn mạnh:

> “Kết quả cho thấy độ ổn định của SFOA phụ thuộc vào bản chất của objective và không đồng nhất giữa hai bài toán SOO.”

Không cần gọi 17,98% là “thất bại”.

---

# 7. VẤN ĐỀ THỨ SÁU – “HỘI TỤ” CẦN DIỄN ĐẠT THẬN TRỌNG

Manuscript viết cost hội tụ khoảng vòng 125–130 và dùng 150 vòng.

Điều này có thể chấp nhận nếu có dữ liệu pilot hỗ trợ.

Tuy nhiên:

- không nên gọi đó là “điểm hội tụ tuyệt đối”;
- nên gọi là “vùng hội tụ quan sát được trong khảo sát thực nghiệm”.

Reviewer đề nghị thay:

> “hội tụ tuyệt đối”

bằng:

> “giá trị Best-so-far ổn định trong vùng từ khoảng vòng 125–130 trở đi”

nếu muốn giữ cách diễn đạt an toàn.

---

# 8. VẤN ĐỀ THỨ BẢY – 30 RUN NHƯNG RANDOM SEED KHÔNG CỐ ĐỊNH

Điều này không phải lỗi.

Thậm chí việc không dùng cùng seed là hợp lý cho independent runs.

Nhưng để tăng khả năng tái lập, reviewer đề nghị ghi rõ:

> “Các lần chạy sử dụng các trạng thái ngẫu nhiên độc lập; seed không được cố định trước.”

Nếu có thể, trong code nên log seed/state của từng run.

Không cần chạy lại campaign chỉ vì vấn đề này, trừ khi tác giả muốn nâng mức reproducibility.

---

# 9. VẤN ĐỀ THỨ TÁM – HẬU KIỂM DẦM

Đây là điểm reviewer đánh giá tích cực.

Manuscript đã nói rất rõ:

- DesignConcrete được chạy trong quá trình đánh giá;
- nhưng VerifyPassed/VerifySections không được lưu thành constraint trong campaign;
- chỉ hai nghiệm cuối được post-hoc verify;
- MJP-C có 29 dầm;
- MJP-D có 80 dầm;
- cả hai nghiệm đều đạt.

Cách trình bày này **trung thực và khoa học hơn rất nhiều** so với việc nói toàn bộ campaign đều thỏa thiết kế dầm.

Không nên mở rộng claim.

Nên giữ nguyên logic:

> “Các nghiệm được báo cáo đã được hậu kiểm và đạt yêu cầu thiết kế dầm.”

Không nên viết:

> “Tất cả các nghiệm trong 60 run đều đạt thiết kế dầm.”

---

# 10. VẤN ĐỀ THỨ CHÍN – “THỎA MỌI RÀNG BUỘC”

Cụm này hiện vẫn xuất hiện ở một số nơi.

Reviewer đề nghị phân biệt:

### “Ràng buộc được đưa vào tối ưu”

với:

### “Yêu cầu thiết kế được kiểm tra hậu kiểm”

Trong bài này:

- constraint cọc → được đưa trực tiếp vào optimization;
- design verification của dầm → hậu kiểm cho hai nghiệm báo cáo;
- serviceability limit → chưa đưa vào.

Do đó cách viết chính xác nhất là:

> “thỏa các ràng buộc được triển khai trong quá trình tối ưu và đạt hậu kiểm thiết kế dầm đối với hai nghiệm được báo cáo.”

Tránh câu chung chung:

> “thỏa mọi ràng buộc”

nếu không nói rõ phạm vi.

---

# 11. VẤN ĐỀ THỨ MƯỜI – GIỚI HẠN CHUYỂN VỊ

Phần này hiện đã được sửa tốt.

Tác giả đã thừa nhận không có giới hạn serviceability cụ thể theo TCVN trong constraint.

Vì vậy:

- không được nói 1,02 mm “an toàn theo TCVN”;
- không nên nói “đạt giới hạn cho phép”;
- chỉ có thể nói giá trị tuyệt đối nhỏ trong phạm vi mô hình khảo sát.

Reviewer đề nghị giữ nguyên sự thận trọng hiện tại.

---

# 12. VẤN ĐỀ THỨ MƯỜI MỘT – “TRADE-OFF” VÀ PARETO

Đây là một trong những phần tốt nhất của Revision 6.

Tác giả đã nói rõ:

- hai nghiệm cực trị cho thấy quan hệ đánh đổi;
- nhưng đây không phải Pareto front;
- không đại diện cho toàn bộ không gian thiết kế;
- chưa thực hiện MOO.

Reviewer đồng ý hoàn toàn.

Đặc biệt nên giữ câu:

> “Đường nét đứt chỉ nối hình học ba điểm thiết kế, không phải Pareto front.”

Đây là cách phòng tránh một hiểu nhầm phổ biến khi reviewer nhìn Hình 2.

---

# 13. VẤN ĐỀ THỨ MƯỜI HAI – HÌNH 2

Hình 2 hiện chỉ có:

- Current;
- MJP-C;
- MJP-D.

Với phạm vi bài báo SOO, điều này có thể chấp nhận.

Không cần tạo Pareto front giả.

Reviewer chỉ đề nghị:

- giữ chú thích “không phải Pareto front”;
- trục Cost và Displacement phải ghi rõ đơn vị;
- nếu dùng logarithmic scale thì ghi rõ;
- tránh đường nối khiến người đọc tưởng đó là đường Pareto.

---

# 14. VẤN ĐỀ THỨ MƯỜI BA – CLAIM “SỰ CẦN THIẾT PHÁT TRIỂN MOSFOA”

Cần giữ mức độ vừa phải.

Bài báo hiện có cơ sở để nói:

> “Kết quả cho thấy SOO không cung cấp được tập phương án cân bằng giữa cost và displacement.”

Nhưng không nên nói:

> “Do đó MOSFOA chắc chắn tốt hơn SFOA.”

Bài hiện tại **chưa chứng minh MOSFOA tốt hơn**, vì MOSFOA chưa được xây dựng.

Cách đúng:

> “Kết quả cung cấp động lực và cơ sở thực nghiệm cho nghiên cứu tiếp theo về MOSFOA.”

Reviewer đánh giá cách diễn đạt hiện tại cơ bản đã đúng.

---

# 15. VẤN ĐỀ THỨ MƯỜI BỐN – ĐÓNG GÓP CỦA BÀI BÁO

Đối với một NCS mới tiếp cận SOO, đóng góp hiện tại là **đủ hợp lý nếu không quảng bá quá mức**.

Không nên tuyên bố:

> “SFOA được chứng minh là hiệu quả nhất.”

Không có benchmark đối chứng.

Nên định vị bài báo là:

> “một nghiên cứu ứng dụng và đánh giá khả năng của SFOA nguyên bản trong bài toán SOO kết cấu công trình biển có FEM-in-the-loop.”

Đây là positioning phù hợp hơn với tạp chí xây dựng trong nước.

---

# 16. ĐIỂM CÓ THỂ BỊ REVIEWER TẠP CHÍ HỎI

Nếu tôi là reviewer của tạp chí, tôi có khả năng hỏi 5 câu sau:

### Q1.
Tại sao chọn SFOA mà không có PSO/GA/DE làm benchmark?

**Câu trả lời nên chuẩn bị:**

Nghiên cứu tập trung vào đánh giá khả năng ứng dụng của SFOA nguyên bản trong một bài toán kết cấu FEM-in-the-loop, không nhằm xếp hạng thuật toán. So sánh metaheuristic sẽ được thực hiện ở nghiên cứu tiếp theo.

### Q2.
Tại sao chọn 30 cá thể và 150 vòng lặp?

Đã có khảo sát hội tụ thực nghiệm; 150 vòng được chọn sau khi quan sát vùng ổn định. Npop=30 là thỏa hiệp giữa đa dạng tìm kiếm và chi phí FEM.

### Q3.
Tại sao displacement-optimal có CV=0%?

Không phải tất cả vector thiết kế giống nhau; objective displacement có plateau do biến rời rạc.

### Q4.
Tại sao chi phí tăng 25,4 lần để giảm displacement?

Vì hai nghiệm nằm ở hai cực của không gian thiết kế khảo sát; đây là kết quả số của hai nghiệm cực trị, không phải quy luật kinh tế tổng quát.

### Q5.
Các dầm có thực sự thỏa thiết kế không?

Hai nghiệm được báo cáo đã post-hoc verify; toàn bộ campaign không sử dụng VerifyPassed của dầm làm constraint trực tiếp.

---

# 17. CÁC SỬA ĐỔI NÊN THỰC HIỆN TRƯỚC KHI GỬI

## P0 – BẮT BUỘC

### P0.1. Xác minh penalty với code

Đây là việc duy nhất reviewer yêu cầu **phải kiểm tra bằng code trước khi khóa bài**.

Không sửa số liệu bằng suy đoán.

## P1 – NÊN SỬA

### P1.1.
Rà toàn bài các cụm:

- “độ cứng”;
- “thỏa mọi ràng buộc”;
- “hội tụ tuyệt đối”;
- “hiệu quả SFOA”;
- “tối ưu độ cứng”.

Chuẩn hóa theo đúng phạm vi đã chứng minh.

### P1.2.
Thống nhất thuật ngữ:

- cost-optimal;
- displacement-optimal;
- Best-of-run;
- Best-so-far;
- SOO-C;
- SOO-D.

### P1.3.
Kiểm tra lại toàn bộ số liệu:

- 5.291,8573;
- 8.012,5085;
- 10.073,9390;
- 1.440,4557;
- CV=17,98%;
- 0,0000388;
- 139.831,4792;
- 25,4 lần;
- 2.542,2%;
- 96,2%;
- 79,4%;
- 443,9%;
- 82,7%;
- 242.133,2 s;
- 67,3 h.

Các số này đang nhất quán nội bộ theo manuscript.

---

# 18. NHỮNG THỨ KHÔNG NÊN THÊM Ở REVISION 6

Để tránh làm bài báo phình to hoặc vượt phạm vi SOO, **không nên tự thêm**:

- Pareto front;
- NSGA-II;
- MOPSO;
- PSO benchmark;
- GA benchmark;
- DE benchmark;
- sensitivity analysis lớn;
- Sobol analysis;
- ablation study;
- surrogate model;
- nhiều case study mới;
- MOSFOA implementation;
- archive;
- non-dominated sorting.

Những nội dung này phù hợp hơn với Paper 2/MOSFOA.

---

# 19. ĐÁNH GIÁ THEO TIÊU CHÍ REVIEWER

| Tiêu chí | Đánh giá |
|---|---|
| Chủ đề phù hợp tạp chí xây dựng | Tốt |
| Tính rõ ràng của câu hỏi nghiên cứu | Tốt |
| Phạm vi SOO | Rõ |
| Mô hình FEM | Khá tốt |
| Framework SAP2000–MATLAB | Tốt |
| Mô tả biến thiết kế | Tốt |
| Mô tả ràng buộc | Khá tốt |
| Thống kê 30 runs | Tốt |
| Phân tích convergence | Khá tốt |
| Phân tích trade-off | Tốt trong phạm vi SOO |
| Tính trung thực về limitation | Tốt |
| Khả năng tái lập | Khá |
| Formulation penalty | **Cần xử lý** |
| Benchmark thuật toán | Không có – chấp nhận nếu định vị đúng |
| MOO/Pareto | Không có – phù hợp phạm vi bài |
| Mức độ claim | Cơ bản phù hợp |
| Tính sẵn sàng gửi tạp chí | **Gần đạt, nhưng chưa khóa do P0** |

---

# 20. RECOMMENDATION

## Quyết định đề xuất của reviewer

**MINOR REVISION / MAJOR TECHNICAL CLARIFICATION BEFORE SUBMISSION**

Tôi **không đề nghị viết lại bài báo**.

Bản Revision 6 đã đạt mức mà một bài báo SOO đầu tiên của NCS có thể hướng tới. Vấn đề còn lại chủ yếu là:

> **xác minh và trình bày chính xác formulation penalty.**

Nếu formulation trong code đúng với manuscript, tác giả nên giữ nguyên kết quả, trình bày penalty như một heuristic cố định của nghiên cứu và nêu limitation rõ ràng.

Nếu code thực tế khác manuscript, phải sửa manuscript theo code thực tế và kiểm tra lại các kết quả chịu ảnh hưởng.

Sau khi xử lý P0 và rà lại P1, **không nên tiếp tục mở rộng phạm vi bài báo**.

---

# 21. KẾT LUẬN CỦA REVIEWER

Revision 6 đã chuyển bài báo từ một bản có nguy cơ “khoe thuật toán” thành một bài **đánh giá ứng dụng SOO tương đối thận trọng và có giới hạn rõ ràng**.

Điểm đáng ghi nhận nhất là tác giả đã không còn cố chứng minh:

> “SFOA là thuật toán tốt.”

mà chuyển sang câu hỏi phù hợp hơn:

> “SFOA nguyên bản hoạt động như thế nào khi được đưa vào bài toán tối ưu SOO của một hệ MJP thực tế, và SOO bộc lộ giới hạn gì khi phải cân bằng cost và displacement?”

Đây là câu hỏi phù hợp hơn với một nghiên cứu đầu tiên của NCS.

**Reviewer recommendation: Có thể tiến tới bản final sau khi xử lý dứt điểm vấn đề penalty và một vòng technical proofreading cuối cùng.**
