# PAPER 1 — ĐỀ CƯƠNG CHI TIẾT

## Tên bài báo làm việc

**Ảnh hưởng của phương pháp xác định điểm ngàm tương đương của cọc đến chiều dài tính toán và đáp ứng kết cấu bến cảng trên nền cọc: nghiên cứu số bằng mô hình SAP2000 3D**

> Tên tiếng Anh làm việc:
>
> **Effects of Equivalent Pile Fixity Determination Methods on Effective Buckling Length and Structural Response of a Piled Wharf: A Three-Dimensional SAP2000 Numerical Study**

---

# 0. TRẠNG THÁI THIẾT KẾ BÀI BÁO

## 0.1. Vai trò trong chương trình nghiên cứu

Paper 1 là bài báo nền tảng của chuỗi nghiên cứu.

Mục tiêu chính:

- xây dựng baseline 3D cho một bến cảng thực;
- xác định điểm ngàm tương đương của cọc theo 4 phương pháp;
- lượng hóa sự khác biệt về `h_z` và `l_tt`;
- kiểm tra mức độ ảnh hưởng của sự khác biệt đó đến đáp ứng kết cấu;
- tạo cơ sở phương pháp luận cho các nghiên cứu tối ưu hóa kết cấu ở các paper tiếp theo.

## 0.2. Không thuộc phạm vi Paper 1

Không nghiên cứu:

- tối ưu hóa;
- PSO/SFOA/MOSFOA;
- tối ưu đa mục tiêu;
- tối ưu hình học kết cấu;
- tối ưu chi phí;
- đề xuất một phương pháp xác định điểm ngàm mới;
- thay đổi tải trọng giữa các mô hình sensitivity;
- thay đổi hình học giữa các mô hình sensitivity.

---

# 1. TITLE

## Tên tiếng Việt đề xuất

**Ảnh hưởng của phương pháp xác định điểm ngàm tương đương của cọc đến chiều dài tính toán và đáp ứng kết cấu bến cảng trên nền cọc: nghiên cứu số bằng mô hình SAP2000 3D**

## Tên tiếng Anh đề xuất

**Effects of Equivalent Pile Fixity Determination Methods on Effective Buckling Length and Structural Response of a Piled Wharf: A Three-Dimensional SAP2000 Numerical Study**

> Tên bài sẽ được rà soát lần cuối sau khi có kết quả thực nghiệm số.

---

# 2. ABSTRACT

## 2.1. Background

Nêu vấn đề:

- cọc của bến cảng trên nền cọc thường được mô hình hóa với một điểm ngàm tương đương;
- vị trí điểm ngàm ảnh hưởng đến chiều dài tính toán của cọc;
- các tiêu chuẩn/tài liệu khác nhau có thể cho các giá trị khác nhau;
- chưa rõ mức độ khác biệt đó truyền vào đáp ứng kết cấu tổng thể và nội lực cọc đến mức nào.

## 2.2. Objective

Nêu rõ hai mục tiêu:

1. So sánh vị trí điểm ngàm tương đương và chiều dài tính toán của cọc theo 4 phương pháp.
2. Định lượng ảnh hưởng của sự khác biệt này đến chuyển vị kết cấu và nội lực cọc trong mô hình bến cảng 3D.

## 2.3. Method

- mô hình SAP2000 3D của bến 100.000 DWT;
- 192 cọc;
- 178 cọc được sử dụng cho sensitivity study;
- 14 cọc giữ nguyên điều kiện biên làm nhóm kiểm soát;
- bốn phương pháp xác định điểm ngàm;
- giữ nguyên geometry, material, load cases và load combinations;
- chỉ thay đổi vị trí fixity của nhóm 178 cọc.

## 2.4. Results

Sau khi có kết quả, báo cáo:

- phạm vi biến thiên `h_z`;
- phạm vi biến thiên `l_tt`;
- mức biến thiên chuyển vị;
- mức biến thiên nội lực cọc;
- chỉ số sensitivity.

## 2.5. Conclusion

Kết luận:

- mức độ khác biệt giữa các phương pháp;
- response nào nhạy nhất;
- response nào ít nhạy;
- ý nghĩa đối với mô hình hóa bến cảng trên nền cọc.

---

# 3. KEYWORDS

Dự kiến:

- piled wharf;
- pile fixity;
- equivalent fixity depth;
- effective length;
- pile-soil interaction;
- structural sensitivity;
- SAP2000;
- numerical analysis.

---

# 4. 1. INTRODUCTION

## 4.1. Bối cảnh nghiên cứu

Trình bày:

- vai trò của bến cảng trên nền cọc;
- đặc điểm chịu lực của hệ kết cấu bến;
- cọc vừa chịu tải đứng vừa chịu tải ngang và mô men;
- ứng xử của cọc phụ thuộc đáng kể vào điều kiện liên kết với nền đất.

## 4.2. Vấn đề mô hình hóa điểm ngàm

Giải thích:

- mô hình 3D kết cấu thực tế cần biểu diễn ảnh hưởng của nền đất;
- một cách tiếp cận thực dụng là thay thế tương tác đất–cọc bằng điểm ngàm tương đương;
- vị trí điểm ngàm quyết định chiều dài phần cọc tham gia tính toán;
- thay đổi điểm ngàm có thể làm thay đổi độ cứng và nội lực của hệ.

## 4.3. Sự khác biệt giữa các phương pháp

Giới thiệu ngắn:

- 22TCN 207-92;
- 20TCN21-86 / TCXD 205-1998;
- TCVN 10304:2014;
- phương pháp Nhật Bản.

Không đi sâu công thức ở Introduction.

## 4.4. Research gap

Khoảng trống cần khóa:

> Các phương pháp xác định điểm ngàm có thể cho các giá trị khác nhau, nhưng cần lượng hóa một cách có kiểm soát xem sự khác biệt về điểm ngàm và chiều dài tính toán có thực sự tạo ra sai khác đáng kể trong đáp ứng của một hệ bến cảng 3D thực tế hay không.

## 4.5. Research questions

### RQ1

Các phương pháp xác định điểm ngàm khác nhau tạo ra mức độ khác biệt như thế nào về `h_z` và `l_tt`?

### RQ2

Sự khác biệt đó ảnh hưởng như thế nào đến:

- chuyển vị ngang của hệ;
- mô men cọc;
- lực cắt cọc?

### RQ3

Đại lượng đáp ứng nào nhạy nhất với giả thiết điểm ngàm?

## 4.6. Objectives

### Objective 1

Định lượng sự khác biệt về:

`h_z` và `l_tt`

giữa bốn phương pháp.

### Objective 2

Định lượng ảnh hưởng của sự khác biệt đó đến:

`U_X`, `U_Y`, `M_max`, `V_max`.

## 4.7. Contributions

Bài báo đóng góp:

1. Xây dựng một thí nghiệm số có kiểm soát trên mô hình bến cảng 3D thực tế.
2. So sánh thống nhất bốn phương pháp xác định điểm ngàm trong cùng một mô hình.
3. Tách riêng ảnh hưởng của giả thiết fixity khỏi ảnh hưởng của hình học và tải trọng.
4. Định lượng mối liên hệ:

   `Method → h_z → l_tt → Structural response`.
5. Cung cấp cơ sở định lượng cho việc lựa chọn giả thiết điểm ngàm trong mô hình số bến cảng.

---

# 5. 2. CASE STUDY AND NUMERICAL MODEL

## 5.1. Mô tả công trình

Giới thiệu:

- bến 100.000 DWT;
- hệ kết cấu bến;
- kích thước chính;
- bố trí cọc;
- điều kiện địa chất có liên quan.

Chỉ đưa thông tin cần thiết để tái lập nghiên cứu.

### Phạm vi mô hình — ĐÃ KHÓA (21/08/2026)

Mô hình 3D SAP2000 dùng trong Paper 1 đại diện cho **một phân đoạn tiêu chuẩn (~75 m)**, một trong 10 phân đoạn cấu thành toàn tuyến bến 750 m. Đây **không phải** mô hình toàn tuyến.

Phải nói rõ điều này ngay trong:

- Abstract — Method (§2.3);
- Case study — mô tả công trình (§5.1, đoạn mở đầu);
- Table 1 (ghi rõ "one standard 75-m segment" trong tiêu đề/nội dung bảng).

Câu diễn đạt chuẩn tiếng Anh: *"The 3D SAP2000 model represents one standard 75-m segment of the 750-m, 10-segment berth, used as the analysis unit for the fixity-sensitivity experiment."*

## 5.2. Hệ cọc

Khóa các thông tin:

- tổng số cọc: 192;
- cọc PHC D800: 132;
- cọc thép D1016: 60;
- 14 cọc giữ nguyên điều kiện biên;
- 178 cọc thuộc sensitivity study.

## 5.3. Mô hình SAP2000 3D

Trình bày:

- mô hình hình học;
- hệ tọa độ;
- frame elements;
- pile elements;
- connection;
- diaphragm/constraint nếu có;
- vật liệu;
- tiết diện.

## 5.4. Load cases

Mô tả các tải trọng sử dụng trong Master model.

Không thay đổi load cases giữa các sensitivity models.

## 5.5. Load combinations

Liệt kê các nhóm combination có trong mô hình.

Đặc biệt xác định:

`BAO KT`

là governing load envelope được sử dụng để đánh giá sensitivity.

## 5.6. Kiểm tra baseline model

Kiểm tra:

- geometry;
- số lượng cọc;
- vật liệu;
- tiết diện;
- tải trọng;
- reaction;
- nội lực.

Mục tiêu là chứng minh Master model là cơ sở chung cho tất cả sensitivity models.

---

# 6. 3. METHODS FOR DETERMINING EQUIVALENT PILE FIXITY

## 6.1. Khái niệm điểm ngàm tương đương

Định nghĩa:

- `h_z`: độ sâu điểm ngàm tương đương;
- `l_tt`: chiều dài tính toán tương ứng.

Sơ đồ:

`ground level → equivalent fixity point → pile tip`

## 6.2. Tổng quan bốn phương pháp — ĐÃ RÚT GỌN (21/08/2026, để phù hợp giới hạn 7 trang JMST, xem §27)

Không còn 6 mục con riêng (6.2–6.7 cũ) cho M1–M6. Thay bằng:

- **một đoạn văn ngắn chung** nêu nguyên tắc chia sẻ của cả 4 phương pháp (đều quy công trình về `h_z` rồi suy ra `l_tt`; khác nhau ở cơ sở lý thuyết/dữ liệu đầu vào);
- **Table 2 (bảng so sánh 4 phương pháp)** mang toàn bộ nội dung so sánh: Method, Reference, Input parameters, công thức `h_z` (dạng rút gọn), `l_tt`, phạm vi áp dụng — xem §19;
- **chỉ M1 (22TCN 207-92) được diễn giải riêng, ngắn**, vì đây là phương pháp duy nhất cần giải thích thêm quy tắc chọn Case — các phương pháp còn lại không có nhánh case nên không cần đoạn văn riêng.

### M1 — quy tắc chọn Case 1/2/4 — ĐÃ KHÓA (21/08/2026)

`BAO KT` là một **envelope không đồng thời** (bao trùm ~30+ combo, mỗi thành phần nội lực có thể lấy từ combo khác nhau). Vì vậy Case áp dụng cho M1 **không được chọn theo hướng gây đáp ứng lớn nhất của cọc** (sẽ tạo vòng lặp logic: dùng kết quả đáp ứng để chọn input tính đáp ứng).

Quy tắc khóa:

- Case (1/2/4) được xác định **theo vị trí/hướng hình học của cọc so với mái dốc**, độc lập với combo hoặc phương pháp fixity đang xét.
- Nếu một cọc thuộc diện phải xét nhiều Case, tính `h_z` cho từng Case liên quan rồi lấy giá trị **bất lợi nhất (governing)** làm `h_z` chính thức của cọc đó.
- Mỗi cọc chỉ có **đúng một `h_z`** theo M1, dùng thống nhất cho toàn bộ mô hình SAP (nhất quán với việc mỗi cọc chỉ có một điểm ngàm vật lý/một lần chạy).

Nội dung chi tiết công thức đầy đủ của cả 4 phương pháp (nếu cần cho reviewer hoặc cho tác giả tự kiểm tra) giữ trong **file tính toán/supplement**, không đưa toàn bộ vào thân bài.

## 6.3. Chuẩn hóa đầu vào

Tất cả phương pháp phải sử dụng cùng:

- geometry;
- soil parameters;
- pile properties;
- ground elevation;
- reference elevation.

Mục tiêu:

> Chỉ phương pháp xác định fixity được phép thay đổi.

### Địa chất đầu vào — ĐÃ KHÓA (21/08/2026)

Dùng **một bộ thông số địa chất đại diện chung** (một mặt cắt/lỗ khoan đại diện cho phân đoạn) cho toàn bộ 178 cọc, áp dụng thống nhất cho cả 4 phương pháp.

Lý do:

- đúng triết lý controlled experiment (mục 22): chỉ phương pháp fixity thay đổi, mọi input khác — kể cả đất — giữ cố định;
- tránh biến Paper 1 thành nghiên cứu địa chất/mapping borehole (ngoài phạm vi theo mục 0.2);
- dữ liệu đối chiếu địa chất hiện chỉ chắc chắn 5/12 lớp — mapping riêng theo từng cọc sẽ mở rộng phạm vi việc cần làm trước khi tính `h_z`.

---

# 7. 4. NUMERICAL EXPERIMENT DESIGN

## 7.1. Triết lý controlled experiment

Sơ đồ:

`MASTER`

↓

`Four alternative fixity definitions`

↓

`Four sensitivity models`

Các yếu tố khác giữ nguyên.

## 7.2. Master model

BASE model chứa:

- geometry;
- material;
- loads;
- original boundary conditions.

## 7.3. Four sensitivity models

**ĐÃ KHÓA (22/08/2026):** Bỏ M4 (tiêu chuẩn Nga) và M5 (Budin–Demina) khỏi phạm vi Paper 1 — thiếu căn cứ để tính đúng: M4 không có bảng hệ số `K` gốc trong tài liệu tham khảo (đã phải mượn tạm bảng của M2 — không đủ tin cậy để công bố); M5 chỉ có hệ số `β` tra đồ thị (1979), không có ảnh đồ thị gốc để số hóa. Giữ nguyên nhãn M1/M2/M3/M6 (không đổi số để tránh phải sửa lại toàn bộ dữ liệu/script đã có), không đổi thành M1–M4 liên tục.

| Model | Method |
|---|---|
| M1 | 22TCN 207-92 |
| M2 | 20TCN21-86 / TCXD 205-1998 |
| M3 | TCVN 10304:2014 |
| M6 | Japanese method |

## 7.4. Control group

14 cọc được giữ nguyên điều kiện biên trong cả bốn sensitivity models.

Mục đích:

- kiểm soát sự thay đổi mô hình;
- bảo đảm sensitivity không bị nhầm với thay đổi toàn bộ hệ kết cấu.

## 7.5. Treatment group

178 cọc được cập nhật fixity theo từng phương pháp.

## 7.6. Governing load envelope

Sử dụng:

`BAO KT`

với hai trạng thái:

- Max;
- Min.

Phân tích đáp ứng theo X/Y từ cùng envelope.

Không tạo ra các combination nhân tạo chỉ để phục vụ sensitivity.

## 7.7. Response indicators

### Global response

`U_X`

`U_Y`

### Pile response

`M_max`

`V_max`

Có thể báo cáo `N` như response phụ nếu cần.

## 7.8. Sensitivity metric

Sử dụng:

`S_R = (R_max - R_min) / R_min × 100%`

Trong đó `R` là response cần đánh giá.

### Quy ước dấu — ĐÃ KHÓA (21/08/2026)

`R` luôn lấy theo **trị tuyệt đối / biên độ** (`|R|`, hoặc biên độ `max−min` của bao) trước khi đưa vào công thức `S_R`. Đảm bảo `R_min > 0` và `S_R` có ý nghĩa vật lý rõ ràng, không bị vô nghĩa khi `R` đổi dấu hoặc `R_min` gần 0.

Có thể bổ sung:

- absolute difference;
- normalized difference;
- coefficient of variation.

Chỉ bổ sung nếu thực sự cần sau khi xem dữ liệu.

---

# 8. 5. RESULTS AND DISCUSSION — ĐÃ RÚT GỌN TỪ 9 MỤC CON XUỐNG 4 MỤC (21/08/2026, xem §27)

Lý do gộp: bài mẫu JMST đã đăng chỉ có ~7 trang cho 1 case study/1 phương pháp; Paper 1 so sánh 4 phương pháp nên buộc phải gộp các mục con Results để không vượt trang. Nội dung khoa học không bị cắt — chỉ gộp cách trình bày.

## 8.1. Variation of equivalent fixity depth and effective calculation length

Gộp nội dung cũ của "5.1 Variation of `h_z`" + "5.2 Variation of `l_tt`" (vì `l_tt = f(h_z)`, hai đại lượng luôn đọc cùng nhau).

### Kết quả cần báo cáo (cho 178 cọc, cả `h_z` và `l_tt`, mỗi đại lượng theo 4 phương pháp)

- min; max; mean; median; SD; percentile nếu cần.

### Hình & bảng

- **Fig. 3 — Distribution of `h_z` and `l_tt` for the 178 sensitivity piles (four methods).**
- **Table 3 — Statistics of `h_z` and `l_tt`.**

### Discussion

- phương pháp nào tạo `h_z`/`l_tt` lớn hơn, nhỏ hơn;
- độ phân tán;
- khác biệt trong `h_z` chuyển thành khác biệt trong `l_tt` như thế nào;
- sự khác biệt có mang tính hệ thống hay không.

---

## 8.2. Structural response sensitivity (displacement and pile forces)

Gộp nội dung cũ của "5.3 Global displacement" + "5.4 Pile bending moment" + "5.5 Pile shear force" — trình bày `U_X`, `U_Y`, `M_max`, `V_max` trong cùng một mục, so sánh giữa BASE và M1/M2/M3/M6.

Nếu dữ liệu cho thấy `V_max` rất nhỏ hoặc không có ý nghĩa so sánh, báo cáo như response phụ (footnote/câu ngắn), không dành riêng một đoạn thảo luận.

### Báo cáo

- absolute response; percentage difference; sensitivity index (`S_R`, quy ước trị tuyệt đối theo §7.8);
- với `M_max`/`V_max`: thêm maximum, mean, median, distribution, governing pile.

### Hình & bảng

- **Fig. 4 — Comparison of global displacement and pile internal-force responses (multi-panel: a. `U_X`/`U_Y`; b. `M_max`/`V_max`).**
- **Table 4 — Sensitivity of global and pile responses to the fixity method.**

### Discussion

- các phương pháp fixity có làm thay đổi đáng kể chuyển vị toàn hệ / nội lực cọc không;
- method gây response lớn nhất/nhỏ nhất;
- vị trí cọc nhạy (governing pile).

---

## 8.3. Spatial distribution and the fixity-to-response chain

Gộp nội dung cũ của "5.6 Spatial distribution" + "5.7 From fixity assumption to structural response" — đây là phần quan trọng nhất về mặt khoa học, nhưng trình bày ngắn gọn (đoạn văn + 1 hình nếu cần, không thêm bảng riêng).

Phân tích:

- vùng cọc nhạy / ít nhạy theo mặt bằng, theo hướng, theo loại tiết diện — mục tiêu: xác định sensitivity mang tính cục bộ hay toàn hệ;
- chuỗi `Method → h_z → l_tt → U_X/U_Y → M_max/V_max`; tương quan `h_z` vs `U`, `h_z` vs `M`, `l_tt` vs `M`, `l_tt` vs `V` nếu dữ liệu cho phép (scatter plot có thể lồng vào Fig. 4 nếu không đủ chỗ cho hình riêng).

Không ép hồi quy nếu dữ liệu không thể hiện quan hệ rõ.

---

## 8.4. Sensitivity ranking and engineering implications

Gộp nội dung cũ của "5.8 Sensitivity ranking" + "5.9 Engineering implications" — kết thúc Results bằng xếp hạng + hàm ý kỹ thuật, không cần bảng riêng (dùng lại Table 4 ở §8.2, chỉ thêm cột/ghi chú xếp hạng nếu cần).

Xếp hạng response theo mức nhạy (`U_X`, `U_Y`, `M_max`, `V_max` hoặc thứ tự thực tế theo kết quả) → xác định đại lượng nào nhạy nhất với giả thiết điểm ngàm.

Thảo luận ngắn:

- lựa chọn điểm ngàm có ảnh hưởng đáng kể hay không; khi nào dùng phương pháp đơn giản đủ; khi nào cần kiểm tra nhiều phương pháp; nguy cơ đánh giá sai độ cứng/nội lực; ý nghĩa đối với mô hình hóa bến cảng 3D.

Không đưa ra khuyến nghị vượt quá dữ liệu.

---

# 17. 6. CONCLUSIONS

Dự kiến 4–6 kết luận.

## C1 — Fixity depth

Bốn phương pháp tạo ra mức độ khác biệt về `h_z` như thế nào.

## C2 — Effective length

Mức khác biệt về `l_tt`.

## C3 — Global response

Ảnh hưởng đến `U_X`, `U_Y`.

## C4 — Pile response

Ảnh hưởng đến `M_max`, `V_max`.

## C5 — Sensitivity

Response nào nhạy nhất.

## C6 — Engineering implication

Hàm ý cho mô hình hóa bến cảng trên nền cọc.

> Chỉ đưa số liệu cụ thể sau khi hoàn thành bốn sensitivity runs.

---

# 18. FIGURES — BỘ HÌNH KHÓA

## Figure 1

**3D SAP2000 model of the 100,000-DWT piled wharf.**

Nội dung:

- toàn bộ mô hình;
- bố trí cọc;
- hệ kết cấu chính.

## Figure 2

**Pile-soil system, equivalent fixity concept, and comparison of the six determination approaches (multi-panel).**

Nội dung (gộp Figure 2 + Figure 3 cũ, 2 panel a/b, để tiết kiệm 1 slot hình theo §27):

- panel a: mặt đất; cọc; đất; `h_z`; `l_tt`; điểm ngàm tương đương;
- panel b: sơ đồ so sánh 4 phương pháp — không nhồi toàn bộ công thức nếu quá khó đọc, chi tiết công thức đầy đủ để trong Table 2 và supplement.

## Figure 3

**Distribution of `h_z` and `l_tt` for the 178 sensitivity piles (four methods).**

Dùng cho §8.1 (gộp Figure 4 cũ + phần `l_tt` không có hình riêng trước đây).

## Figure 4

**Comparison of global displacement and pile internal-force responses (multi-panel: a. `U_X`/`U_Y`; b. `M_max`/`V_max`).**

Gộp Figure 5 + Figure 6 cũ thành 1 hình 2 panel, dùng cho §8.2. Nếu dữ liệu tương quan (§8.3) cần scatter plot, có thể thêm panel c vào chính hình này thay vì tạo hình riêng.

> Tổng bộ hình chính văn: **4 hình** (giảm từ 6), phù hợp khung 7 trang JMST (§27). Không tạo thêm hình ngoài 4 hình này trừ khi dữ liệu thực tế bắt buộc.

---

# 19. TABLES — BỘ BẢNG KHÓA

## Table 1

**Main characteristics of the case-study wharf and numerical model.**

Gộp thông tin công trình + hệ cọc + (nếu ngắn) thông số địa chất đại diện đã khóa ở §6.3 vào cùng một bảng, để tránh tách riêng "Table 2 — Soil and pile parameters" cũ thành bảng độc lập. Phải ghi rõ "one standard 75-m segment" trong tiêu đề/nội dung (xem §5.1).

## Table 2

**Summary of the six equivalent pile-fixity determination methods.**

Các cột:

- Method;
- Reference;
- Input parameters;
- `h_z`;
- `l_tt`;
- Applicable case (chỉ M1 có cột này khác trống).

Bảng này mang toàn bộ nội dung so sánh 4 phương pháp — thay cho 6 mục con Methods cũ (§6.2 đã rút gọn).

## Table 3

**Statistics of equivalent fixity depth and effective calculation length.**

## Table 4

**Sensitivity of global and pile responses to the fixity method.**

Có thể thêm cột xếp hạng (rank) để phục vụ §8.4, tránh phải tạo bảng ranking riêng.

> Tổng bộ bảng chính văn: **4 bảng** (giảm từ 6). Nội dung "Controlled numerical experiment matrix" cũ (Model/method/treated/control piles) giữ dưới dạng bảng nhỏ đã có sẵn trong §7.3, không lặp lại thành bảng riêng trong bộ bảng khóa. Dữ liệu chi tiết 192 dòng/cọc giữ trong file supplement, không đưa vào bảng chính văn (đã khóa từ đầu).

---

# 20. DATA PIPELINE

## Step 1

Master model:

`Ben 100.000DWT KT nl coc.s2k`

## Step 2

Extract:

- geometry;
- pile coordinates;
- pile type;
- pile length;
- soil information.

## Step 3

Calculate:

`h_z(M1,M2,M3,M6)`

cho 178 cọc.

## Step 4

Calculate:

`l_tt(M1,M2,M3,M6)`

## Step 5

Create four SAP2000 models.

## Step 6

Update only pile fixity.

## Step 7

Run analysis.

## Step 8

Extract:

- displacement;
- pile P;
- pile V;
- pile M;
- reactions if needed.

## Step 9

Build unified result database.

## Step 10

Calculate sensitivity.

## Step 11

Generate figures/tables.

## Step 12

Write Results & Discussion.

## Step 13

Finalize Abstract and Conclusions.

---

# 21. DATA VALIDATION CHECKLIST

Trước khi chạy sensitivity:

- [ ] 192 piles đúng.
- [ ] 178 piles đúng treatment group.
- [ ] 14 piles đúng control group.
- [ ] Geometry không thay đổi.
- [ ] Material không thay đổi.
- [ ] Section không thay đổi.
- [ ] Loads không thay đổi.
- [ ] Load combinations không thay đổi.
- [ ] Chỉ fixity thay đổi.
- [ ] `BAO KT` tồn tại trong cả 7 models.
- [ ] Units thống nhất.
- [ ] SAP2000 version thống nhất.

Sau khi chạy:

- [ ] model converged;
- [ ] no unintended missing elements;
- [ ] reaction balance;
- [ ] displacement available;
- [ ] pile forces available;
- [ ] governing pile identified.

---

# 22. LOGIC CỦA PAPER — PHẢI GIỮ XUYÊN SUỐT

Bài báo phải luôn trả lời một câu hỏi duy nhất:

> **Nếu cùng một bến cảng, cùng hình học, cùng vật liệu và cùng tải trọng, nhưng thay đổi phương pháp xác định điểm ngàm tương đương của cọc, thì đáp ứng kết cấu thay đổi bao nhiêu?**

Chuỗi logic:

```text
Four fixity methods
        ↓
Different h_z
        ↓
Different l_tt
        ↓
Different pile stiffness / boundary condition
        ↓
Different structural response
        ↓
Quantified sensitivity
        ↓
Engineering implication
```

Không được để bài chuyển thành bài:

- so sánh tiêu chuẩn;
- nghiên cứu đất;
- nghiên cứu tải trọng;
- tối ưu kết cấu;
- nghiên cứu thuật toán.

---

# 23. NOVELTY STATEMENT — BẢN KHÓA

> This study provides a controlled three-dimensional numerical assessment of how alternative code- and literature-based methods for determining equivalent pile fixity affect the effective calculation length and structural response of a real-world piled wharf. By keeping geometry, material properties, loading, and analysis settings unchanged while varying only the pile fixity assumption, the study isolates and quantifies the structural sensitivity associated with equivalent fixity determination.

---

# 24. PAPER POSITION TRONG CHUỖI NGHIÊN CỨU

```text
PAPER 1
Fixity sensitivity
        ↓
PAPER 2
Single-objective optimization
        ↓
PAPER 3
Multi-objective optimization
        ↓
MOSFOA / broader optimization framework
```

Paper 1 phải hoàn thành trước khi khóa các giả thiết nền tảng cho Paper 2.

---

# 25. TRẠNG THÁI HIỆN TẠI

## Đã khóa

- [x] Research question
- [x] Objectives
- [x] Case study
- [x] 3D SAP2000 baseline
- [x] 192 piles
- [x] 178 treatment piles
- [x] 14 control piles
- [x] Four fixity methods
- [x] Controlled experiment
- [x] Governing envelope: BAO KT
- [x] Response variables
- [x] Sensitivity metric (absolute-value convention locked 21/08/2026)
- [x] M1 Case 1/2/4 selection rule (geometry-based, governing case per pile — locked 21/08/2026)
- [x] Soil input for h_z (one representative profile for all 178 piles — locked 21/08/2026)
- [x] Paper structure
- [x] Figure plan (rút gọn 6 → 4 hình, khóa 21/08/2026 theo giới hạn 7 trang JMST — §27)
- [x] Table plan (rút gọn 6 → 4 bảng, khóa 21/08/2026)
- [x] One-segment scope stated explicitly in Abstract/Case study/Table 1 (locked 21/08/2026)
- [x] JMST format requirements (§27, from official template + accepted sample paper)
- [x] Novelty direction

## Đã hoàn thành thêm (23/08/2026)

- [x] Calculate `h_z` for M1,M2,M3,M6
- [x] Calculate `l_tt` for M1,M2,M3,M6
- [x] Build four sensitivity models (SAP2000 OAPI, mở file 1 lần, lặp qua BASE+M1/M2/M3/M6)
- [x] Run four analyses (+ BASE) — xem scripts/run_sensitivity_full.log
- [x] Extract results (JointDispl 192 joints, FrameForce 178 piles, envelope BAO KT)
- [x] Perform sensitivity analysis (`S_R` cho U_X, U_Y, M_max, V_max — table6_FINAL.csv)
- [x] Write final Results (§5.2–5.4 draft)
- [x] Write final Abstract (Tóm tắt/Abstract, trong giới hạn từ JMST)
- [x] Write final Conclusions (§6 draft)

## Đã hoàn thành thêm (24/08/2026) — rà soát tuân thủ JMST §27

- [x] Rà toàn bài so với quy định định dạng JMST — phát hiện rủi ro vượt 7 trang là có thật
- [x] Cắt gọt thân bài (6.841 → 4.862 từ, giảm 29%); dồn công thức chi tiết M1/M2/M3/M6 về Bảng 3 + supplement (thực thi đúng quyết định đã khóa §6.2 nhưng trước đó chưa áp dụng)

## Chưa thực hiện

- [ ] Generate Figure 1 (tổng thể mô hình 3D), Figure 2 (khái niệm điểm ngàm + so sánh phương pháp), Figure 3 (boxplot `l_tt`), Figure 4 (U_X/U_Y/M_max/V_max) — dữ liệu Hình 3/4 đã có, chỉ cần vẽ; Hình 1/2 chưa có mô tả trong thân bài
- [ ] Sửa lỗi thứ tự trích dẫn `[ ]`: tài liệu [7] (Thuyết minh) dùng làm nguồn Bảng 1/2 (§2) nhưng chưa có bracket, trong khi [1]-[6] (Bảng 3, §3, xuất hiện sau) đã đánh số trước — vi phạm quy định "đánh số theo thứ tự xuất hiện lần đầu"
- [ ] Bổ sung năm/nhà xuất bản thiếu cho [4] TCVN 10304:2014 và [6] giáo trình Nguyễn Văn Ngọc
- [ ] Chuyển toàn bộ sang .docx với style JMST thật (font Times New Roman, cỡ chữ, thụt lề công thức 0,5cm...) — hiện chưa có bản .docx nào
- [ ] Xác nhận số trang thật sau khi có bản .docx layout (chưa thể chắc chắn chỉ dựa vào số từ ở .md)
- [ ] Xử lý 15/178 cọc có on_segment=False trước khi công bố số liệu cuối (không chặn tiến độ)
- [ ] Thay placeholder tác giả/email trước khi nộp bài

---

# 26. NGUYÊN TẮC KHÓA TỪ ĐÂY

1. Không thay đổi research question nếu chưa có bằng chứng từ numerical results.
2. Không thêm objective thứ ba.
3. Không đưa optimization vào Paper 1.
4. Không thay đổi load model giữa các sensitivity cases.
5. Không thay đổi geometry giữa các sensitivity cases.
6. Không thay đổi material giữa các sensitivity cases.
7. Chỉ thay đổi pile fixity của 178 treatment piles.
8. 14 control piles giữ nguyên.
9. `BAO KT` là governing load envelope cho sensitivity experiment.
10. Không gọi `BAO KT` là governing displacement case nếu chưa kiểm chứng displacement.
11. Không kết luận phương pháp nào "tốt nhất" nếu không có tiêu chí đánh giá tương ứng.
12. Không overclaim novelty.
13. Chỉ viết kết luận định lượng sau khi có kết quả chạy SAP.

---

# 27. QUY ĐỊNH ĐỊNH DẠNG TẠP CHÍ JMST (từ `JMST-Template Lĩnh vực 01 final-OTH.docx` và bài mẫu đã đăng `JMST-22091_Final - Hoan.docx`)

## 27.1. Giới hạn quan trọng nhất

> **Bản thảo không quá 07 trang.**

Bài mẫu đã đăng (Lê Thị Lệ & Phạm Quốc Hoàn, JMST-22091) fit đúng ~7 trang với: 1 case study, 6 công thức, 1 bảng, 6 hình, 14 tài liệu tham khảo, cấu trúc 5 mục lớn.

So với quy mô hiện tại của đề cương Paper 1 (4 phương pháp × mục riêng đầy đủ ở §6, 9 mục con Results §8–16, 6 hình, 6 bảng) — **rủi ro vượt trang là có thật và cần xử lý trước khi viết chi tiết**. Xem mục 27.5.

## 27.2. Trang đầu

- Tiêu đề tiếng Việt IN HOA, cỡ 13, Times New Roman.
- Tiêu đề tiếng Anh IN HOA, cỡ 13, Times New Roman, ngay dưới tiêu đề Việt.
- Tên tác giả cỡ 12, căn giữa; ghi chú khoa/viện + trường; email liên hệ có dấu `*`.
- Tóm tắt tiếng Việt: **150–250 từ**. Abstract tiếng Anh: **150–300 từ** (theo template) — bài mẫu ghi "no more than 300 words". Không chèn hình/công thức trong abstract. Dòng đầu không thụt lề.
- Từ khóa tiếng Việt và tiếng Anh, ngăn cách bằng dấu phẩy.

## 27.3. Định dạng nội dung

- Font Times New Roman toàn bài; nội dung chính cỡ **10**, căn đều hai bên.
- Tiêu đề mục lớn (style JMST-Section): Times New Roman, cỡ **11, đậm**.
- Hạn chế viết tắt; **tránh chú thích chân trang** — dùng trích dẫn số thứ tự thay thế; hạn chế trích dẫn nguyên văn trong `"..."`.
- Bảng: tiêu đề **ở trên** bảng ("Bảng x. ..."), có đường kẻ ngang dưới tiêu đề, nguồn trích dẫn (nếu có) ghi dưới bảng.
- Hình: tiêu đề **ở dưới** hình ("Hình x. ..."), căn giữa; chữ/ký hiệu trong hình cỡ 10, Times New Roman.
- Công thức toán thụt vào 0,5 cm, có dòng trống trước/sau, đánh số thứ tự trong `()` căn lề phải.
- Trích dẫn tài liệu tham khảo: số Ả Rập trong `[ ]`, đánh số **theo thứ tự xuất hiện lần đầu trong bài** (không phải theo alphabet tác giả). Ví dụ cách trích nhiều nguồn: `[2,3]`.
- Cuối bài: Kết luận → Lời cảm ơn (nếu có) → TÀI LIỆU THAM KHẢO. Không bắt đầu tài liệu tham khảo ở trang mới.
- Cuối cùng có 3 dòng do tòa soạn điền: Ngày nhận bài / Ngày nhận bản sửa / Ngày duyệt đăng.

## 27.4. Cấu trúc thực tế bài đã đăng (tham chiếu, không bắt buộc rập khuôn)

`1. Đặt vấn đề → 2. Phương pháp nghiên cứu (tóm tắt) → 3. Lý thuyết (2 phương pháp so sánh) → 4. Kết quả tính toán và thảo luận (gộp số liệu đầu vào + kết quả) → 5. Kết luận và kiến nghị → Lời cảm ơn → Tài liệu tham khảo.`

Điểm đáng chú ý: bài mẫu **không tách riêng một chương "Case study" lớn** — số liệu công trình được gộp thẳng vào đầu mục Kết quả (§4.1 "Số liệu xuất phát"), giúp bài ngắn gọn.

## 27.5. Việc cần làm trước khi viết chi tiết — CHƯA KHÓA, cần quyết định

Cấu trúc hiện tại của Paper 1 (mục 4–19 trong đề cương) dài hơn đáng kể so với khuôn khổ 7 trang đã cho thấy ở bài mẫu. Cần rút gọn theo một trong các hướng — xem câu hỏi gửi kèm.
