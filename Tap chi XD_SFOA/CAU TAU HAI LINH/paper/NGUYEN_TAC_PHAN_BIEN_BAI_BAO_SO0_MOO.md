# NGUYÊN TẮC & QUY TRÌNH PHẢN BIỆN BÀI BÁO
## Đúc rút từ quá trình phản biện Paper 1 — dùng làm chuẩn cho các bài tiếp theo

---

# 1. VAI TRÒ PHẢN BIỆN

## 1.1. Tinh thần chung

Phản biện theo nguyên tắc:

> **Khắt khe với logic khoa học, nhưng xây dựng với tác giả.**

Mục tiêu không phải tìm càng nhiều lỗi càng tốt, mà là:

1. xác định bài báo có câu chuyện khoa học rõ hay không;
2. kiểm tra tác giả thực sự chứng minh được điều gì;
3. phát hiện claim vượt quá bằng chứng;
4. kiểm tra tính nhất quán giữa mục tiêu → phương pháp → kết quả → kết luận;
5. phân biệt lỗi bắt buộc sửa với điểm có thể chấp nhận;
6. không yêu cầu tác giả làm thêm nghiên cứu nếu không cần thiết cho câu hỏi hiện tại.

---

# 2. PHẢI XÁC ĐỊNH “VỊ THẾ” CỦA BÀI TRƯỚC KHI PHẢN BIỆN

Không dùng một chuẩn duy nhất cho mọi bài.

Trước khi đọc chi tiết phải xác định:

- tác giả là ai;
- bài dành cho tạp chí nào;
- ngôn ngữ nào;
- lĩnh vực nào;
- bài là Paper 1/Paper 2 hay nghiên cứu độc lập;
- tác giả đang ở giai đoạn nào;
- mục tiêu bài là:
  - phương pháp mới;
  - ứng dụng;
  - benchmark;
  - case study;
  - framework;
  - MOO/SOO;
  - thực nghiệm;
  - tổng quan.

### Với NCS mới tiếp cận SOO

Không nên dùng chuẩn:

> “phải đánh bại PSO/GA/DE/GWO”

nếu bài không đặt câu hỏi đó.

Cần đánh giá bài theo đúng **research scope** đã công bố.

---

# 3. NGUYÊN TẮC QUAN TRỌNG NHẤT:
# CLAIM ↔ EVIDENCE

Mỗi claim quan trọng phải trả lời được:

> **Bằng chứng nào trong bài chứng minh câu này?**

Phân loại:

### A. Claim được chứng minh

Giữ.

### B. Claim có bằng chứng nhưng diễn đạt quá mạnh

→ giảm mức khẳng định.

Ví dụ:

> “kiểm chứng framework”

nếu chưa có benchmark/ground truth

→

> “xây dựng và đánh giá framework”.

### C. Claim chưa có đủ bằng chứng

→ yêu cầu bổ sung bằng chứng **chỉ khi claim đó là trung tâm của bài**.

### D. Claim không cần thiết

→ xóa hoặc viết lại.

---

# 4. KHÔNG ĐƯỢC ĐỒNG NHẤT:
# “KHÔNG CHỨNG MINH ĐƯỢC” = “SAI”

Ví dụ:

- không có benchmark → không thể kết luận SFOA tốt hơn PSO;
- nhưng điều đó **không làm sai** nghiên cứu SOO nếu mục tiêu chỉ là đánh giá khả năng áp dụng SFOA.

Cần viết:

> “Bài chưa có cơ sở để kết luận X.”

không viết:

> “Bài sai vì chưa làm X.”

---

# 5. PHÂN BIỆT 4 MỨC ĐỘ CỦA KẾT QUẢ

Khi gặp từ:

- tối ưu;
- tốt nhất;
- hội tụ;
- ổn định;
- khả thi;
- hiệu quả;
- chính xác;
- tối ưu toàn cục;

phải kiểm tra bằng chứng.

### Ví dụ

Không có proof global optimum:

> “nghiệm tối ưu”

nên ưu tiên:

> “nghiệm tốt nhất tìm được”.

Không có toàn bộ lịch sử population:

> “tất cả quá trình đều khả thi”

không được suy ra từ:

> “best-of-run đều khả thi”.

---

# 6. ĐẶC BIỆT CẨN THẬN VỚI METAHEURISTIC

Không được suy luận:

> CV thấp → thuật toán tốt.

Cần phân biệt:

- stability;
- repeatability;
- convergence;
- solution quality;
- diversity;
- global optimality.

### Một bài metaheuristic tốt nên được xem xét:

- số run;
- population;
- iteration/evaluation budget;
- seed nếu có;
- Best;
- Mean;
- STD;
- CV;
- convergence;
- feasibility;
- computational cost;
- cách xử lý constraint.

Không nhất thiết tất cả đều phải có trong mọi bài, nhưng reviewer phải kiểm tra xem **chỉ số được báo cáo có đủ để hỗ trợ claim hay không**.

---

# 7. CV = 0% KHÔNG TỰ ĐỘNG CÓ NGHĨA:
# “30 RUN CÙNG MỘT NGHIỆM”

Đây là bài học quan trọng từ Paper 1.

Có thể xảy ra:

- nhiều vector thiết kế khác nhau;
- nhưng cùng objective;
- do objective plateau;
- hoặc nhiều nghiệm tương đương.

Vì vậy cần phân biệt:

> **objective repeatability**

và

> **design-vector repeatability**.

Nếu CV = 0%:

- kiểm tra Best value;
- kiểm tra vector thiết kế;
- kiểm tra có plateau/equivalent solutions hay không.

---

# 8. KHÔNG GỌI “PARETO FRONT” KHI CHỈ CÓ VÀI ĐIỂM

Nếu bài SOO có:

- cost-optimal;
- displacement-optimal;

thì có thể nói:

> “hai nghiệm cực trị cho thấy trade-off”.

Không được tự động gọi:

> “Pareto front”.

Muốn nói Pareto phải có phân tích MOO/non-dominated set phù hợp.

---

# 9. TRADE-OFF PHẢI ĐƯỢC DIỄN GIẢI ĐÚNG

Nếu:

- Cost tăng 2.542,2%;
- tương đương 26,4 lần;

phải kiểm tra cả:

> percentage increase

và:

> ratio.

Không được nhầm:

> 25,4 lần

với:

> tăng 2.542,2%.

### Quy tắc

Nếu:

A = nghiệm cơ sở  
B = nghiệm so sánh

thì:

> % tăng = (B − A)/A × 100%

> số lần = B/A

Hai đại lượng khác nhau.

---

# 10. CONSTRAINT & PENALTY

Đây thường là điểm yếu của các bài metaheuristic.

Reviewer phải kiểm tra:

1. constraint là gì;
2. hard constraint hay soft constraint;
3. penalty ở đâu;
4. penalty có scale/normalize không;
5. penalty có cùng thứ nguyên với objective không;
6. λ được chọn thế nào;
7. có sensitivity với λ không;
8. có lưu violation history không;
9. kết luận feasibility dựa trên toàn population hay chỉ best-of-run.

### Không được yêu cầu quá mức

Nếu penalty là một hạn chế nhưng không phá hỏng câu hỏi nghiên cứu:

> yêu cầu tác giả **khai báo limitation**

thay vì bắt buộc chạy lại toàn bộ campaign.

---

# 11. ĐƠN VỊ LÀ “BỘ LỌC LỖI” RẤT MẠNH

Khi phản biện optimization:

hãy kiểm tra:

- Cost: USD;
- Displacement: m/mm;
- Force: kN;
- Moment: kN·m;
- penalty;
- normalized constraint.

Nếu tác giả cộng trực tiếp các đại lượng khác thứ nguyên:

> phải hỏi cách chuẩn hóa hoặc yêu cầu giải thích.

Không nhất thiết kết luận ngay là sai, nhưng phải xác định:

> penalty có thực sự có vai trò như tác giả tuyên bố không?

---

# 12. TIÊU CHUẨN THIẾT KẾ

Phải kiểm tra:

### 12.1. Tiêu chuẩn nào?

- tiêu chuẩn tải;
- tiêu chuẩn kết cấu;
- tiêu chuẩn cọc;
- tiêu chuẩn bê tông;
- tiêu chuẩn thép;
- tiêu chuẩn cảng.

### 12.2. Phiên bản nào?

Đặc biệt:

> tiêu chuẩn đã hết hiệu lực hay chưa?

Nếu mô hình thực tế chạy theo phiên bản cũ:

**không được ép tác giả đổi sang phiên bản mới nếu chưa chạy lại mô hình.**

Yêu cầu đúng là:

> khai báo phiên bản đã sử dụng;

> ghi rõ trạng thái;

> nêu giới hạn;

> xem cập nhật là hướng tiếp theo.

### 12.3. Không được suy diễn nguồn

Nếu đơn giá là giả định nghiên cứu:

> không được viết “theo TCVN”.

TCVN cung cấp quy cách/kích thước thì chỉ gắn citation cho phần đó.

---

# 13. KIỂM TRA “MODEL ↔ MANUSCRIPT”

Đây là một trong những bước quan trọng nhất khi bài có SAP2000/MATLAB/Python/FEA.

Phải đối chiếu:

- biến thiết kế;
- giới hạn biến;
- load case;
- load combination;
- objective;
- constraint;
- design code;
- output được đọc;
- hard gate;
- penalty;
- số evaluation;
- số run;
- population;
- iteration.

### Nguyên tắc

> **Manuscript phải mô tả đúng model đã chạy, không phải model “đáng lẽ nên chạy”.**

---

# 14. KHÔNG ĐÁNH GIÁ CHỈ BẰNG PHẦN CHỮ

Phải xem:

- bảng;
- hình;
- caption;
- công thức;
- đơn vị;
- legend;
- số liệu trong hình;
- quan hệ giữa bảng và phần thảo luận.

### Đặc biệt

Nếu bài nói:

> “CV = 0%”

hãy kiểm tra bảng.

Nếu bài nói:

> “chi phí tăng 26,4 lần”

hãy tính lại từ bảng.

Nếu bài nói:

> “không vi phạm”

hãy kiểm tra phạm vi dữ liệu được lưu.

---

# 15. PHẢI TỰ TÍNH LẠI CÁC CON SỐ QUAN TRỌNG

Reviewer không nên chỉ đọc narrative.

Các phép kiểm tra nhanh:

- % tăng/giảm;
- ratio;
- CV;
- STD;
- mean;
- max/min;
- số evaluations;
- computational time;
- objective values;
- penalty magnitude.

Nếu một con số sai:

> yêu cầu sửa ngay.

---

# 16. REFERENCES & CITATIONS

Không đánh giá bibliography bằng số lượng.

Nguyên tắc:

> **Mỗi citation phải có chức năng.**

Kiểm tra 4 chiều:

### Claim → Citation

Claim có nguồn chưa?

### Citation → Claim

Nguồn có thực sự hỗ trợ claim không?

### In-text → Reference

Mọi [n] có trong References không?

### Reference → In-text

Mọi reference có được trích ít nhất một lần không?

### Không thêm tài liệu “trang trí”

8–10 tài liệu đúng chức năng tốt hơn 20 tài liệu không cần thiết.

---

# 17. TÀI LIỆU THAM KHẢO CHO METAHEURISTIC

Nếu bài nói:

> metaheuristic phù hợp với nonlinear/discrete/constrained optimization

thường cần ít nhất một nguồn nền.

Nếu bài bàn:

> penalty/constraint handling

nên có nguồn nền phù hợp.

Nếu bài dùng một thuật toán cụ thể:

> phải có bài gốc của thuật toán.

Không cần biến Introduction thành systematic review nếu đó không phải mục tiêu bài.

---

# 18. KIỂM TRA ABSTRACT

Abstract phải trả lời 6 câu:

1. Vấn đề gì?
2. Mục tiêu gì?
3. Phương pháp gì?
4. Dữ liệu/thí nghiệm gì?
5. Kết quả định lượng chính là gì?
6. Ý nghĩa gì?

### Tránh

- claim mạnh hơn phần Results;
- gọi global optimum khi không chứng minh;
- gọi Pareto khi chưa có Pareto;
- đưa quá nhiều chi tiết implementation;
- kết luận vượt phạm vi.

### Tóm tắt phải nhất quán với title.

Nếu title là:

> “đánh giá khả năng ứng dụng”

Abstract cũng phải nói về:

> “đánh giá khả năng ứng dụng”

chứ không biến thành:

> “chứng minh thuật toán tối ưu”.

---

# 19. KIỂM TRA CONCLUSION

Kết luận phải được map ngược về Objectives.

Mỗi objective:

> phải có một finding tương ứng.

Không đưa vào Conclusion:

- kết quả chưa trình bày;
- claim mới;
- future work như thể đã hoàn thành;
- kết luận global;
- superiority chưa được benchmark.

---

# 20. PHÂN BIỆT “LIMITATION” VÀ “FAILURE”

Không nên xem limitation là lỗi chết người.

Ví dụ:

- một case study;
- không benchmark;
- penalty chưa normalize;
- dùng tiêu chuẩn cũ;
- chưa có serviceability constraint;

có thể là:

> **limitation phù hợp với scope**

nếu tác giả:

1. khai báo;
2. không overclaim;
3. nêu hướng tiếp theo.

Reviewer không nên biến mọi limitation thành Major Revision.

---

# 21. QUY TẮC PHÂN LOẠI COMMENT

## P0 — Critical

Chỉ dùng khi:

- sai phương pháp;
- kết quả không thể tái lập;
- dữ liệu không hỗ trợ kết luận chính;
- sai công thức nghiêm trọng;
- sai đơn vị làm thay đổi kết quả;
- có vấn đề đạo đức/trùng lặp nghiêm trọng.

→ Có thể yêu cầu Major Revision.

## P1 — Required

- sai số liệu;
- sai citation;
- tiêu chuẩn sai;
- claim quá mạnh;
- inconsistency model/manuscript;
- lỗi ảnh hưởng khả năng hiểu hoặc tái lập.

→ Phải sửa.

## P2 — Recommended

- wording;
- clarity;
- bổ sung giải thích;
- cách trình bày.

→ Nên sửa nhưng không cần thay đổi nghiên cứu.

## P3 — Optional

- cải thiện phong cách;
- thêm thảo luận không thiết yếu.

→ Không ép tác giả.

---

# 22. KHÔNG YÊU CẦU THÍ NGHIỆM MỚI CHỈ VÌ “CÓ THỂ HAY HƠN”

Trước khi yêu cầu:

> chạy thêm;

> benchmark thêm;

> sensitivity;

> Pareto;

> thêm thuật toán;

phải hỏi:

> **Nếu không có thí nghiệm này, câu hỏi nghiên cứu hiện tại có còn được trả lời không?**

Nếu:

> Có

→ không bắt buộc.

Chỉ đề nghị như future work.

Đây là nguyên tắc đặc biệt quan trọng với Paper 1.

---

# 23. QUY TẮC “KHÔNG MỞ RỘNG SCOPE”

Khi bài đã đủ để trả lời research question:

> **không mở rộng scope chỉ để bài trông lớn hơn.**

Ví dụ:

Paper SOO không nhất thiết phải thêm:

- MOO;
- Pareto;
- PSO;
- GA;
- DE;
- GWO.

Nếu MOO là Paper 2:

> phải bảo vệ ranh giới Paper 1.

---

# 24. REVIEW THEO VÒNG

Khi tác giả sửa nhiều phiên bản:

### Vòng 1
Tìm vấn đề định hướng:

- title;
- research question;
- objectives;
- novelty;
- methodology.

### Vòng 2
Tập trung:

- logic;
- model;
- experiment;
- results.

### Vòng 3
Tập trung:

- overclaim;
- limitations;
- trade-off;
- statistics.

### Vòng cuối
Chỉ còn:

- wording;
- references;
- standards;
- consistency;
- formatting.

### Không quay lại mở Major Issue cũ

Nếu đã chấp nhận một thiết kế hợp lý ở vòng trước và không có bằng chứng mới cho thấy nó sai:

> không tự ý mở lại.

---

# 25. NGUYÊN TẮC “3 CÂU HỎI REVIEWER”

Đối với mỗi claim quan trọng, hỏi:

### Câu 1
> Tác giả nói gì?

### Câu 2
> Bằng chứng nào chứng minh?

### Câu 3
> Mức kết luận có lớn hơn bằng chứng không?

Nếu câu 3 là “có”:

> giảm claim.

Đây là cách nhanh nhất để phát hiện overclaim.

---

# 26. NGUYÊN TẮC “MỘT CON SỐ — MỘT CÂU CHUYỆN”

Mỗi con số quan trọng phải:

- xuất hiện đúng;
- tính lại được;
- nhất quán giữa Abstract, Results, Conclusion;
- không đổi cách diễn giải.

Ví dụ:

> 2.542,2% → 26,4 lần

phải thống nhất toàn bài.

---

# 27. KHI PHẢN BIỆN BÀI SOO

Checklist nhanh:

- [ ] Objective có rõ không?
- [ ] Objective có đúng là SOO không?
- [ ] Design variables rõ không?
- [ ] Search space rõ không?
- [ ] Constraints rõ không?
- [ ] Penalty rõ không?
- [ ] Population rõ không?
- [ ] Iteration/evaluation budget rõ không?
- [ ] Số runs đủ để đánh giá repeatability không?
- [ ] Best/Mean/STD/CV có được báo cáo không?
- [ ] Có convergence analysis không?
- [ ] Có feasibility check không?
- [ ] Có phân biệt objective stability và design stability không?
- [ ] Có overclaim global optimum không?
- [ ] Nếu có trade-off: có gọi nhầm Pareto không?
- [ ] Nếu so sánh thuật toán: có cùng budget không?
- [ ] Nếu không benchmark: có tránh superiority claim không?

---

# 28. KHI PHẢN BIỆN BÀI MOO/MOSFOA

Checklist bổ sung:

- [ ] Objective có conflict thực sự không?
- [ ] Pareto dominance được định nghĩa đúng không?
- [ ] Constraint handling nhất quán không?
- [ ] Có archive không?
- [ ] Có diversity preservation không?
- [ ] Có convergence/diversity metrics không?
- [ ] Hypervolume/IGD/Spacing có phù hợp không?
- [ ] Reference set/reference point có giải thích không?
- [ ] Pareto front có được kiểm chứng không?
- [ ] Có benchmark với MOO algorithms không?
- [ ] Có sensitivity population/iterations không?
- [ ] Có statistical comparison không?

Không áp checklist MOO vào bài SOO.

---

# 29. QUY TRÌNH PHẢN BIỆN CHUẨN CHO NGÀY MAI

## Bước 1 — Đọc title + abstract

Trong 5 phút trả lời:

> Bài này đang cố chứng minh điều gì?

## Bước 2 — Đọc Introduction

Xác định:

- problem;
- gap;
- objective;
- contribution.

## Bước 3 — Đọc Method

Vẽ trong đầu:

> Input → Model → Algorithm → Constraint → Objective → Output.

Nếu không vẽ được:

> Methodology chưa rõ.

## Bước 4 — Đọc Results

Kiểm tra:

> Objective → Experiment → Data → Claim.

## Bước 5 — Tự tính lại số liệu

Chỉ tập trung số liệu quan trọng.

## Bước 6 — Kiểm tra limitations

Xem tác giả có biết mình chưa chứng minh được gì không.

## Bước 7 — References

Kiểm tra:

> claim ↔ citation.

## Bước 8 — Formatting

Chỉ làm sau khi khoa học đã ổn.

---

# 30. MẪU REVIEWER REPORT CHUẨN

## I. Đánh giá chung

Viết 1–2 đoạn:

- bài làm gì;
- điểm mạnh;
- đóng góp;
- trạng thái tổng thể.

## II. Các điểm chính

Chỉ liệt kê những vấn đề thực sự ảnh hưởng bài.

Mỗi comment:

> **Issue → Evidence → Why it matters → Proposed fix**

Không chỉ viết:

> “Cần làm rõ.”

Mà phải viết:

> “Mục X hiện viết A, trong khi B ở Bảng Y cho thấy..., vì vậy đề nghị sửa thành...”

## III. Các điểm nhỏ

- wording;
- citation;
- typo;
- formatting.

## IV. Recommendation

Một trong:

- Accept;
- Minor Revision;
- Major Revision;
- Reject.

---

# 31. CÁCH VIẾT COMMENT TỐT

### Không nên

> “Phần penalty sai.”

### Nên

> “Hàm phạt hiện cộng trực tiếp các đại lượng có thứ nguyên khác nhau vào objective. Nếu giữ cách triển khai này, đề nghị tác giả làm rõ cơ sở lựa chọn λ và phạm vi mà penalty được kỳ vọng chi phối; đồng thời nêu đây là hạn chế của mô hình nếu chưa có chuẩn hóa.”

---

# 32. NGUYÊN TẮC CUỐI CÙNG

> **Reviewer không phải là đồng tác giả của bài báo.**

Không sửa bài theo ý mình.

Không biến bài thành nghiên cứu mình muốn đọc.

Nhiệm vụ là xác định:

> **Với câu hỏi nghiên cứu mà tác giả đã đặt ra, bằng chứng hiện tại có đủ để chấp nhận kết luận hay không?**

Nếu đủ:

> **đề nghị chấp nhận.**

Nếu chưa đủ nhưng có thể sửa mà không thay đổi nghiên cứu:

> **Minor Revision.**

Nếu phải làm lại phần lõi:

> **Major Revision.**

Nếu câu hỏi không có giá trị hoặc phương pháp không thể cứu:

> **Reject.**

---

# 33. NGUYÊN TẮC RIÊNG CHO CHÚNG TA

Khi phản biện các bài tiếp theo của bạn, tôi sẽ mặc định:

> **1. Đứng ở vị trí reviewer độc lập.**

> **2. Không bảo vệ bài của tác giả chỉ vì đã biết quá trình xây dựng bài.**

> **3. Không cố tìm lỗi để “làm khó”.**

> **4. Phân biệt rõ lỗi khoa học, lỗi diễn đạt và giới hạn nghiên cứu.**

> **5. Ưu tiên kiểm tra claim–evidence.**

> **6. Tự tính lại các con số quan trọng.**

> **7. Kiểm tra model–manuscript consistency.**

> **8. Không yêu cầu thí nghiệm mới nếu research question hiện tại vẫn được trả lời.**

> **9. Không mở rộng scope ngoài câu hỏi nghiên cứu.**

> **10. Khi bài đạt trạng thái đủ tốt: phải dám nói “CHỐT”.**

---

# 34. CHECKLIST 1 TRANG — DÙNG NHANH

## SCIENTIFIC

- [ ] Title đúng scope
- [ ] Research question rõ
- [ ] Gap không overclaim
- [ ] Objective rõ
- [ ] Method tái lập được
- [ ] Variables rõ
- [ ] Constraints rõ
- [ ] Objective function đúng
- [ ] Experimental budget rõ
- [ ] Results hỗ trợ objectives
- [ ] Statistics phù hợp
- [ ] Conclusion không vượt evidence

## METAHEURISTIC

- [ ] Runs
- [ ] Population
- [ ] Iterations/evaluations
- [ ] Best
- [ ] Mean
- [ ] STD
- [ ] CV
- [ ] Convergence
- [ ] Feasibility
- [ ] Computational cost
- [ ] Constraint handling
- [ ] Không overclaim global optimum

## NUMERICAL

- [ ] Units
- [ ] Percentage
- [ ] Ratio
- [ ] Formula
- [ ] Table ↔ text
- [ ] Figure ↔ text
- [ ] Abstract ↔ Results
- [ ] Conclusion ↔ Results

## REFERENCES

- [ ] Algorithm original paper
- [ ] Standards
- [ ] Methodological foundations
- [ ] Claim ↔ citation
- [ ] Citation ↔ reference
- [ ] No orphan references

## PUBLISHING

- [ ] Journal scope
- [ ] Title format
- [ ] Abstract word limit
- [ ] Keywords
- [ ] Headings
- [ ] Figures
- [ ] Tables
- [ ] Equations
- [ ] References
- [ ] Page/word limit

---

# 35. QUY TẮC “FINAL LOCK”

Một bài được **FINAL LOCK** khi:

1. research question rõ;
2. methodology đủ để trả lời;
3. results nhất quán;
4. các claim không vượt evidence;
5. các con số quan trọng đã kiểm tra;
6. limitations đã khai báo;
7. references/citations đúng;
8. thể thức phù hợp journal;
9. không còn lỗi P0/P1;
10. các điểm còn lại chỉ là P2/P3.

Khi đạt điều kiện này:

> **Không tiếp tục phản biện vô hạn.**

Chuyển sang:

> **submission / nghiên cứu tiếp theo.**

---

# KẾT LUẬN

Kinh nghiệm quan trọng nhất rút ra từ Paper 1 là:

> **Một bài báo tốt không phải bài không có hạn chế.**

Mà là bài:

> **biết chính xác mình đang chứng minh điều gì, có bằng chứng phù hợp cho điều đó, và trung thực về những gì mình chưa chứng minh.**

Đây sẽ là nguyên tắc trung tâm để phản biện các bài tiếp theo.
