# GÓP Ý VÀ ĐỀ XUẤT HOÀN THIỆN BẢN THẢO BÀI BÁO GỬI JMST

## 1. Đánh giá tổng quan

Bản thảo có nền tảng khoa học tốt và **phù hợp với hướng Xây dựng công trình thủy – Cảng biển của JMST**. Bài đã có câu hỏi nghiên cứu rõ, mô hình SAP2000 3D thực tế, thí nghiệm số có kiểm soát và bộ kết quả định lượng tương đối mạnh.

Đánh giá hiện tại:

- Nội dung khoa học: khoảng **7/10**.
- Mức độ sẵn sàng để nộp: khoảng **5,5–6/10**.
- Không nên viết lại từ đầu; nên tập trung chỉnh logic lập luận, hình minh họa, thuật ngữ, tài liệu tham khảo và dàn trang.

Điểm mạnh nhất của bài là không chỉ so sánh công thức xác định điểm ngàm mà xây dựng được chuỗi:

> **Phương pháp → h_z → l_tt → độ cứng cọc → tái phân bố nội lực → đáp ứng kết cấu.**

Đặc biệt, kết quả cho thấy **chuyển vị toàn hệ tương đối ít nhạy, trong khi nội lực cực trị tại một số cọc có thể rất nhạy**. Đây nên là thông điệp khoa học chính của bài.

---

# 2. Điểm mạnh cần giữ nguyên

## 2.1. Câu hỏi nghiên cứu

Ba câu hỏi RQ1–RQ3 hiện tại khá rõ:

- RQ1: Bốn phương pháp tạo mức khác biệt như thế nào về h_z và l_tt?
- RQ2: Sự khác biệt đó ảnh hưởng thế nào đến U_X, U_Y, M_max, V_max?
- RQ3: Đại lượng đáp ứng nào nhạy nhất với giả thiết điểm ngàm?

Hai mục tiêu nghiên cứu cũng bám khá sát câu hỏi.

## 2.2. Thiết kế thí nghiệm số có kiểm soát

Đây là một trong những điểm mạnh nhất.

Bài giữ nguyên:

- hình học;
- vật liệu;
- tải trọng;
- điều kiện chung của mô hình;

và chỉ thay đổi giả thiết điểm ngàm của 178 cọc treatment.

Cách làm này giúp tách ảnh hưởng của phương pháp xác định điểm ngàm khỏi các biến khác.

## 2.3. Kết quả định lượng

Bảng 6 là phần rất có giá trị:

| Đại lượng | S_R |
|---|---:|
| U_X,max | 18,5% |
| U_Y,max | 26,5% |
| M_max | 86,3% |
| V_max | 199,4% |

Kết quả này cho phép hình thành một thông điệp rõ:

> **Sai khác trong giả thiết điểm ngàm có ảnh hưởng vừa phải đến chuyển vị toàn hệ nhưng có thể gây biến động rất lớn đối với nội lực cực trị của một số cọc.**

Đây nên là trọng tâm của phần Kết quả và thảo luận.

---

# 3. Những vấn đề khoa học cần sửa

## 3.1. Không nên coi MASTER là nghiệm chuẩn

MASTER nên được gọi là:

> **mô hình gốc (MASTER)**

hoặc:

> **mô hình tham chiếu số**

Không nên diễn đạt MASTER như một nghiệm đúng hoặc chuẩn vật lý.

Lý do: chiều dài FEM gốc trong mô hình chỉ là khoảng cách đến điểm ngàm/lò xo theo giả thiết ban đầu, không phải một nghiệm chuẩn đã được kiểm chứng bằng quan trắc hoặc mô hình tương tác đất–cọc đầy đủ.

Cần duy trì lập luận:

> MASTER chỉ là mô hình gốc để đánh giá mức thay đổi khi thay điểm ngàm; bài báo không dùng MASTER làm nghiệm chuẩn để kết luận phương pháp nào chính xác hơn.

## 3.2. Thận trọng với quan hệ k ∝ 1/l_tt³

Bản thảo đang dùng:

> k ∝ 1/l_tt³

để giải thích việc giảm l_tt làm tăng độ cứng ngang.

Về mặt cơ học định tính, lập luận này hợp lý. Tuy nhiên, mô hình nghiên cứu là hệ bến 3D gồm cọc + dầm + bản + liên kết, không phải một console đơn giản.

Nên sửa cách diễn đạt thành:

> Độ cứng ngang hiệu dụng của cọc có xu hướng tăng mạnh khi chiều dài làm việc giảm; trong mô hình console lý tưởng, độ cứng có quan hệ theo bậc ba với chiều dài, trong khi ở hệ bến 3D quan hệ này còn chịu ảnh hưởng của độ cứng dầm–bản và sự tái phân bố tải giữa các cọc.

Không nên dùng k ∝ 1/l_tt³ như một công thức chính xác cho toàn hệ.

## 3.3. Làm rõ ý nghĩa của S_R

Bản thảo sử dụng:

S_R = (|R_max| − |R_min|) / |R_min| × 100%

Cần nói rõ đây là:

> **chỉ số biến thiên tương đối giữa các phương pháp**

chứ không phải hệ số độ nhạy vi phân theo nghĩa toán học.

Có thể giữ ký hiệu S_R để không phải thay đổi toàn bộ bài, nhưng nên bổ sung:

> Trong nghiên cứu này, S_R là chỉ số quy ước dùng để lượng hóa biên độ biến thiên của đáp ứng giữa bốn phương pháp M1–M6, không phải hệ số độ nhạy vi phân.

## 3.4. Không nên kết luận “một phương pháp là đủ”

Câu:

> “đánh giá chuyển vị tổng thể, một phương pháp đơn giản là đủ”

hơi mạnh so với dữ liệu.

Nên đổi thành:

> “Đối với đánh giá chuyển vị toàn hệ, ảnh hưởng của lựa chọn phương pháp nhỏ hơn đáng kể so với ảnh hưởng đến nội lực cực trị cọc.”

Sau đó mới nêu hàm ý:

> “Trong bước đánh giá chuyển vị sơ bộ có thể lựa chọn một phương pháp phù hợp với tiêu chuẩn thiết kế; trong kiểm tra nội lực cọc cần xem xét độ nhạy giữa các phương pháp.”

---

# 4. Hình vẽ cần bổ sung

Hiện bản thảo chưa có hình thật. Đây là một trong những việc bắt buộc trước khi nộp.

## Hình 1

**Sơ đồ phân đoạn bến 75 m và vị trí của phân đoạn trong tuyến bến 750 m.**

Mục đích:

- chứng minh phạm vi mô hình;
- giúp người đọc hiểu đây là 1/10 tuyến bến;
- tránh hiểu nhầm nghiên cứu mô hình toàn tuyến.

## Hình 2

**Sơ đồ nguyên lý điểm ngàm tương đương của cọc.**

Nên thể hiện:

- H0;
- h_gđ;
- h_z;
- l_tt;
- mái dốc;
- hướng lực;
- đỉnh cọc;
- điểm ngàm tương đương.

## Hình 3

**Boxplot chiều dài tính toán l_tt của 178 cọc theo M1, M2, M3, M6.**

Có thể thêm đường tham chiếu chiều dài FEM gốc.

Không cần đưa quá nhiều thông tin vào hình.

## Hình 4 — quan trọng nhất

Nên làm một hình gồm 4 panel:

(a) vị trí 178 cọc trên mặt bằng;

(b) phân bố l_tt theo cọc;

(c) M_max theo cọc;

(d) V_max theo cọc.

Đánh dấu cọc thép D1016 số 140.

Hình này sẽ trực tiếp chứng minh kết luận ở §5.3 về tính cục bộ của độ nhạy.

---

# 5. Phần 2 cần rút gọn

§2.3 hiện hơi dài so với giới hạn 7 trang.

Đặc biệt phần giải thích Case 4 của M1:

> m_λ/m_θ ≈ 6,7 > 1 khiến Case 4 vô nghĩa toán học...

là thông tin kỹ thuật quan trọng nhưng không cần trình bày quá dài trong thân bài.

Có thể giữ kết luận chính:

> Với bộ thông số địa chất và hình học của công trình, Case 4 của M1 không thỏa điều kiện toán học của công thức và được loại khỏi tập case governing; kết quả M1 được xác định từ Case 1 và Case 2.

Chi tiết tính toán đưa về supplement.

---

# 6. Phần 3 nên giữ cấu trúc hiện tại

Việc chỉ trình bày công thức chính trong thân bài và đưa hệ công thức chi tiết về supplement là hợp lý đối với bài tối đa 7 trang.

Bảng 3 cần bảo đảm có:

- phương pháp;
- tài liệu/tiêu chuẩn;
- dữ liệu đầu vào;
- đại lượng trung gian;
- h_z;
- l_tt;
- đơn vị;
- ghi chú phạm vi áp dụng.

Không nên đưa toàn bộ hệ công thức M1/M2/M3/M6 vào thân bài vì sẽ làm bài quá tải.

---

# 7. Phần 5 là trung tâm của bài

## 7.1. §5.1

Bảng 5 hiện tốt.

Số liệu:

- M1: mean = 16,33 m;
- M2: mean = 18,65 m;
- M3: mean = 16,03 m;
- M6: mean = 17,79 m;
- MASTER: mean = 24,54 m.

Nên viết chính xác:

> M3 có l_tt trung bình nhỏ nhất (16,03 m), tiếp đến M1 (16,33 m), trong khi M2 có giá trị lớn nhất (18,65 m).

Không nên chỉ viết “M1 và M3 ngắn nhất”.

## 7.2. §5.2

Đây là phần định lượng chính.

Nên nhấn mạnh:

- chuyển vị giảm so với MASTER;
- mức biến thiên giữa bốn phương pháp nhỏ hơn nhiều so với nội lực cực trị;
- nội lực trung bình có mức biến thiên thấp hơn nội lực cực trị.

## 7.3. §5.3

Đây là phần có giá trị khoa học nhất.

Nên làm nổi bật chuỗi:

> **Phương pháp → l_tt giảm tại một số cọc → tăng độ cứng ngang tương đối → tái phân bố lực → nội lực tập trung tại cọc biên.**

Đặc biệt cọc thép D1016 số 140 cần được minh họa trên Hình 4.

## 7.4. §5.4

Không cần viết quá dài.

Có thể chốt bằng thông điệp:

> Chuyển vị toàn hệ là đáp ứng ít nhạy hơn; nội lực cực trị, đặc biệt lực cắt tại cọc governing, là đáp ứng nhạy nhất.

---

# 8. Thuật ngữ tiếng Anh trong tiêu đề

Tiêu đề tiếng Anh hiện dùng:

> effective buckling length

Thuật ngữ này có thể khiến người đọc hiểu sang chiều dài tính toán ổn định Euler.

Trong bài này nên cân nhắc:

> effective pile length

hoặc:

> effective calculation length

Tôi nghiêng về **effective pile length** nếu muốn ngắn gọn.

---

# 9. Tiêu đề bài báo nên rút gọn

Tiêu đề hiện tại quá dài.

Đề xuất:

> **ẢNH HƯỞNG CỦA PHƯƠNG PHÁP XÁC ĐỊNH ĐIỂM NGÀM CỌC ĐẾN ĐÁP ỨNG KẾT CẤU BẾN CẢNG TRÊN NỀN CỌC**

Nếu cần phụ đề:

> **Nghiên cứu số bằng mô hình SAP2000 3D**

Tiêu đề này tập trung trực tiếp vào biến nghiên cứu và đáp ứng kết cấu.

---

# 10. Abstract

Abstract hiện khá tốt nhưng hơi nhiều thông tin.

Nên giữ các số liệu quan trọng:

- 178 cọc;
- l_tt trung bình 16,0–18,6 m;
- chuyển vị giảm 18–49%;
- S_R của chuyển vị 18,5–26,5%;
- S_R của M_max và V_max lần lượt 86,3% và 199,4%.

Không cần nhồi quá nhiều chi tiết về toàn bộ cấu hình mô hình.

---

# 11. Kết luận

C1–C6 hiện hơi nhiều đối với bài 7 trang.

Nên rút xuống 4 kết luận:

### C1 — Chiều dài tính toán

Bốn phương pháp cho l_tt khác biệt đáng kể, với giá trị trung bình 16,0–18,6 m.

### C2 — Chuyển vị

Chuyển vị toàn hệ giảm 18–49% so với MASTER và có mức biến thiên vừa phải giữa các phương pháp.

### C3 — Nội lực

Nội lực cực trị cọc nhạy mạnh; S_R đạt 86,3% đối với M_max và 199,4% đối với V_max.

### C4 — Hàm ý kỹ thuật

Ảnh hưởng của điểm ngàm mang tính cục bộ; cần đặc biệt rà soát các cọc biên và cọc có l_tt thay đổi lớn khi kiểm tra nội lực.

---

# 12. Validation — cần chủ động giải thích hạn chế

Bài không có số liệu quan trắc hoặc mô hình p–y để xác định phương pháp nào “đúng” hơn.

Đây không phải lỗi chết bài nếu mục tiêu được giữ là sensitivity study.

Nên bổ sung rõ:

> Do không có số liệu quan trắc biến dạng hoặc nội lực của công trình để hiệu chỉnh, nghiên cứu không sử dụng kết quả của bất kỳ phương pháp nào làm nghiệm chuẩn. Mục tiêu của nghiên cứu là lượng hóa ảnh hưởng của lựa chọn giả thiết điểm ngàm đến đáp ứng kết cấu.

Câu này nên xuất hiện ở cuối §1 và nhắc lại ngắn ở §6.

---

# 13. Tài liệu tham khảo

Cần rà lại toàn bộ thứ tự trích dẫn.

Vấn đề hiện tại:

> [7] Thuyết minh thiết kế

được sử dụng sớm trong §2 nhưng lại đánh số sau [1]–[6].

Cần đánh số theo **lần xuất hiện đầu tiên**:

1. Xuất hiện đầu tiên → [1]
2. Nguồn mới tiếp theo → [2]
3. ...
4. Sau khi khóa số mới lập danh mục tài liệu tham khảo.

Đồng thời bổ sung đầy đủ:

- năm xuất bản TCVN 10304:2014;
- năm xuất bản giáo trình Nguyễn Văn Ngọc;
- thông tin xuất bản chính xác nếu có.

---

# 14. Kiểm tra giới hạn 7 trang

Không thể kết luận chắc chắn bài đã vừa 7 trang từ Markdown.

Cần thực hiện sau khi chuyển sang Word:

- A4;
- Times New Roman 10 pt theo mẫu JMST;
- căn lề đúng mẫu;
- công thức đúng style;
- bảng đúng style;
- hình đúng kích thước;
- caption đúng vị trí;
- tài liệu tham khảo đúng quy định.

Chỉ sau khi dàn Word thật mới chốt được số trang.

---

# 15. Thứ tự sửa đề xuất

## Ưu tiên 1 — bắt buộc

- [ ] Vẽ Hình 1.
- [ ] Vẽ Hình 2.
- [ ] Vẽ Hình 3.
- [ ] Vẽ Hình 4.

## Ưu tiên 2 — rất quan trọng

- [ ] Thống nhất cách gọi MASTER là “mô hình gốc/tham chiếu”.
- [ ] Không coi MASTER là nghiệm chuẩn.
- [ ] Làm rõ bản chất của S_R.
- [ ] Giảm mức khẳng định của câu “một phương pháp là đủ”.

## Ưu tiên 3

- [ ] Rút §2.3.
- [ ] Rút §3.2–§3.3.
- [ ] Dành dung lượng cho §5.3–§5.4.

## Ưu tiên 4

- [ ] Rút Abstract.
- [ ] Rút Kết luận C1–C6 xuống 4 kết luận.
- [ ] Rà thuật ngữ “effective buckling length”.

## Ưu tiên 5

- [ ] Rà toàn bộ số thứ tự tài liệu tham khảo.
- [ ] Bổ sung thông tin thư mục còn thiếu.
- [ ] Thay thông tin tác giả/email placeholder.

## Ưu tiên 6

- [ ] Chuyển sang Word theo mẫu JMST.
- [ ] Kiểm tra đúng 7 trang.
- [ ] Kiểm tra lần cuối hình, bảng, công thức và tài liệu tham khảo.

---

# 16. Kết luận đánh giá

**Không nên viết lại bài từ đầu.**

Bản thảo đã có:

- câu hỏi nghiên cứu rõ;
- mô hình 3D thực tế;
- thiết kế thí nghiệm có kiểm soát;
- dữ liệu thật từ SAP2000;
- kết quả định lượng rõ;
- phát hiện khoa học đáng chú ý về sự khác biệt giữa độ nhạy chuyển vị và độ nhạy nội lực.

Trục bài nên được giữ:

> **4 phương pháp → h_z → l_tt → mô hình 3D → chuyển vị + nội lực → phát hiện nội lực cực trị nhạy mạnh và có tính cục bộ.**

Thông điệp khoa học chính nên là:

> **Sự khác biệt trong giả thiết điểm ngàm tương đương có ảnh hưởng vừa phải đến chuyển vị toàn hệ nhưng có thể gây biến động rất lớn đối với nội lực cực trị tại một số cọc, đặc biệt các cọc biên.**

Đây là điểm có khả năng tạo giá trị nhất cho bài báo JMST.

Nguồn bản thảo được rà soát: bản DRAFT v7 ngày 24/08/2026, gồm các mục 1–6, Bảng 1–6 và danh mục tài liệu tham khảo. 
