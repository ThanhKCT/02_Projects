# ĐỀ CƯƠNG CHI TIẾT — Bài báo MOFDA / Cầu tàu container 100.000 DWT

## Tên bài báo làm việc

**Tối ưu hóa đa mục tiêu tiết diện cọc cầu tàu container 100.000 DWT bằng thuật toán Flow Direction đa mục tiêu (MOFDA) theo tiêu chuẩn TCVN hiện hành**

> Tên tiếng Anh làm việc:
> **Multi-Objective Optimization of Pile Cross-Sections for a 100,000-DWT Container Wharf Using the Multi-Objective Flow Direction Algorithm (MOFDA) under Current Vietnamese Standards**

---

# 0. TRẠNG THÁI BÀI BÁO

## 0.1. Vị trí của bài báo

Đây là **bài báo độc lập**, không thuộc chuỗi/roadmap nhiều bài nào khác (không phụ thuộc, không nối tiếp Paper 1 hay bất kỳ paper nào khác trong thư mục JMST). Việc dùng chung công trình case-study (cầu tàu 100.000 DWT) với các tài liệu khác trong ổ đĩa chỉ là trùng dữ liệu nguồn, không tạo ràng buộc thứ tự xuất bản hay nội dung.

Bản chất bài báo: **ứng dụng thuật toán MOFDA** (đã có sẵn, đã công bố, đã kiểm chứng) để giải một bài toán MOO kỹ thuật cụ thể — tối ưu tiết diện hệ cọc của cầu tàu 100.000 DWT theo TCVN hiện hành. Không phát triển thuật toán mới.

## 0.2. Không thuộc phạm vi bài báo (đã được người dùng chốt — KHÓA)

Không nghiên cứu / không làm:

- **so sánh MOFDA với các thuật toán MOO khác** (NSGA-II, MOPSO, MOEA/D...) — MOFDA dùng như công cụ đã kiểm chứng, không phải đối tượng nghiên cứu;
- **đánh giá/phê bình hồ sơ thiết kế gốc** — hồ sơ (thuyết minh, bản vẽ, `.s2k`) chỉ dùng để **dựng mô hình FEM** (hình học, vật liệu, tải trọng, điều kiện biên), không dùng để kết luận thiết kế gốc đúng/sai/thừa/thiếu;
- thay đổi vị trí cọc, độ xiên, chiều dài cọc, bố trí dầm/bản;
- đề xuất phương pháp xác định điểm ngàm mới;
- kiểm định độ chính xác của MOFDA bằng benchmark toán học (đã có trong bài gốc MOFDA, không lặp lại ở đây).

---

# 1. TITLE

## Phương án tên tiếng Việt (đề xuất 3 phương án, khuyến nghị PA1)

1. **(Khuyến nghị)** Tối ưu hóa đa mục tiêu tiết diện cọc cầu tàu container 100.000 DWT bằng thuật toán Flow Direction đa mục tiêu (MOFDA) theo tiêu chuẩn TCVN hiện hành
2. Ứng dụng thuật toán tối ưu đa mục tiêu MOFDA trong thiết kế tiết diện hệ cọc công trình bến cảng
3. Tối ưu đa mục tiêu khối lượng vật liệu và chuyển vị ngang cầu tàu 100.000 DWT trên nền cọc bằng thuật toán MOFDA

## Tên tiếng Anh làm việc

**Multi-Objective Optimization of Pile Cross-Sections for a 100,000-DWT Container Wharf Using the Multi-Objective Flow Direction Algorithm (MOFDA) under Current Vietnamese Standards**

> Tên bài sẽ rà soát lại lần cuối sau khi có Pareto front thật (đặc biệt nếu tỷ lệ giảm khối lượng/chuyển vị đủ ấn tượng để đưa vào tên).

---

# 2. ABSTRACT (khung — điền số liệu sau khi có kết quả)

## 2.1. Background

- cầu tàu container trên nền cọc là kết cấu tốn kém vật liệu, hệ cọc (BTCT dự ứng lực + thép) chiếm tỷ trọng chi phí lớn;
- thiết kế hiện hành thường theo phương pháp thử-sai (trial and error) trên cơ sở kinh nghiệm, chưa khai thác đầy đủ không gian thiết kế khả thi theo tiêu chuẩn;
- các thuật toán tối ưu đa mục tiêu (MOO) dựa trên metaheuristic đã được áp dụng rộng rãi cho kết cấu thép/khung nhà, nhưng ứng dụng cho **hệ cọc công trình bến cảng theo hệ tiêu chuẩn TCVN cập nhật (2020–2026)** còn hạn chế.

## 2.2. Objective

1. Xây dựng bài toán MOO cho tiết diện hệ cọc (BTCT dự ứng lực D-t, ống thép D-t) của một cầu tàu 100.000 DWT thực tế, với ràng buộc theo TCVN 11820/10304/5574/5575.
2. Ứng dụng MOFDA — kết nối trực tiếp với mô hình FEM SAP2000 qua OAPI — để tìm tập nghiệm Pareto tối ưu giữa khối lượng vật liệu cọc và chuyển vị ngang lớn nhất của cầu tàu.

## 2.3. Method

- mô hình FEM SAP2000 3D của cầu tàu 100.000 DWT (4.913 nút, 1.734 thanh, 4.488 tấm; 132 cọc BTCT D800‑540 + 60 cọc thép D1016‑T16), lấy nguyên trạng từ hồ sơ thiết kế làm cơ sở dựng FEM (không chỉnh sửa hình học/điều kiện biên);
- biến thiết kế: `x = [D_BTCT, t_BTCT, D_thep, t_thep]`;
- 2 hàm mục tiêu: min khối lượng vật liệu cọc quy đổi, min chuyển vị ngang lớn nhất;
- ràng buộc: lực dọc trục, mô men cọc BTCT, ứng suất cọc thép, chuyển vị cho phép, sức chịu tải địa kỹ thuật — theo TCVN hiện hành;
- vòng lặp tối ưu: MOFDA (MATLAB) ↔ SAP2000 OAPI, đánh giá từng cá thể bằng phân tích FEM tuyến tính tĩnh dưới tổ hợp tải bao (governing envelope).

## 2.4. Results (điền sau khi có campaign thật — KHÔNG dùng số liệu dry-run)

- hình dạng/số lượng nghiệm Pareto;
- khoảng biến thiên khối lượng vật liệu và chuyển vị trên Pareto front;
- so sánh nghiệm đại diện (ví dụ knee point) với tiết diện gốc trong hồ sơ, như một điểm neo tham chiếu (không phải đánh giá đúng/sai hồ sơ gốc);
- kiểm tra ràng buộc của (các) nghiệm được chọn.

## 2.5. Conclusion

- MOFDA khả thi để giải bài toán MOO tiết diện cọc bến cảng gắn trực tiếp với FEM thật (không xấp xỉ surrogate);
- mức đánh đổi định lượng giữa khối lượng vật liệu và chuyển vị;
- hàm ý cho thiết kế sơ bộ/thiết kế tối ưu hệ cọc bến cảng theo TCVN hiện hành.

---

# 3. KEYWORDS

- multi-objective optimization;
- flow direction algorithm;
- pile cross-section optimization;
- piled wharf;
- SAP2000–MATLAB coupling;
- Pareto front;
- Vietnamese port design standards (TCVN 11820).

---

# 4. 1. INTRODUCTION

## 4.1. Bối cảnh nghiên cứu

- vai trò cầu tàu container trọng tải lớn (100.000 DWT) trong hạ tầng cảng biển Việt Nam;
- hệ cọc (BTCT dự ứng lực + ống thép) là cấu kiện chịu lực chính, khối lượng vật liệu lớn → dư địa tối ưu chi phí đáng kể;
- thiết kế truyền thống: chọn tiết diện theo catalogue/kinh nghiệm rồi kiểm tra lại (forward design), chưa hệ thống hóa như bài toán tối ưu có ràng buộc.

## 4.2. Tối ưu hóa kết cấu bằng metaheuristic — tổng quan ngắn

- các thuật toán metaheuristic (GA, PSO, GWO, WOA, FDA...) đã ứng dụng rộng cho tối ưu khung thép, giàn, dầm;
- MOFDA (Multi-Objective Flow Direction Algorithm) — thuật toán gốc đã công bố, cơ chế hybrid leader selection, kiểm chứng trên 31 benchmark + 11 bài toán kỹ thuật ràng buộc + 1 công trình thực (khung thép bến phà Đồng Bài) — dẫn nguồn [MOFDA/02_MOFDA_revise02.docx](MOFDA/02_MOFDA_revise02.docx).
- Không lặp lại phần kiểm chứng thuật toán — bài báo này **kế thừa** MOFDA đã kiểm chứng, mở rộng ứng dụng sang đối tượng kết cấu mới: **hệ cọc bến cảng (2 loại vật liệu, chịu tải phức hợp: đứng, ngang, mô men, va/neo tàu)**.

## 4.3. Research gap

> Việc ứng dụng thuật toán tối ưu đa mục tiêu (cụ thể MOFDA) kết hợp trực tiếp với mô hình FEM thật (không phải hàm mục tiêu giải tích/surrogate) cho bài toán tiết diện hệ cọc công trình bến cảng — theo đúng ràng buộc của hệ tiêu chuẩn TCVN thiết kế công trình cảng biển hiện hành (TCVN 11820, TCVN 10304:2025) — chưa được công bố trong tài liệu tiếng Việt.

## 4.4. Research questions

### RQ1
Bài toán MOO tiết diện cọc (2 loại vật liệu) cho một cầu tàu thực tế, với ràng buộc theo TCVN hiện hành, có thể hình thành và giải trực tiếp bằng MOFDA kết hợp FEM thật (SAP2000) hay không?

### RQ2
Tập nghiệm Pareto thu được thể hiện mức đánh đổi (trade-off) như thế nào giữa khối lượng vật liệu cọc và chuyển vị ngang lớn nhất của cầu tàu?

### RQ3
Các ràng buộc kỹ thuật (lực dọc trục, mô men, ứng suất, chuyển vị cho phép) có vai trò/mức độ chi phối như thế nào đến hình dạng Pareto front?

## 4.5. Objectives

### Objective 1
Xây dựng bài toán MOO tiết diện cọc: biến thiết kế, hàm mục tiêu, ràng buộc — theo TCVN 11820‑1/2/4‑1/5, TCVN 10304:2025, TCVN 5574:2018, TCVN 5575:2024.

### Objective 2
Xây dựng khung kết nối MOFDA (MATLAB) ↔ SAP2000 OAPI để đánh giá từng cá thể bằng FEM thật.

### Objective 3
Chạy campaign tối ưu thật, trích xuất và phân tích Pareto front; chọn nghiệm đại diện, kiểm tra ràng buộc.

## 4.6. Contributions

1. Hình thành bài toán MOO cho hệ cọc bến cảng 2 vật liệu (BTCT DƯL + ống thép) theo đúng hệ tiêu chuẩn TCVN cập nhật 2020–2026.
2. Xây dựng và kiểm thử khung kết nối MOFDA↔SAP2000 OAPI cho bài toán MOO gắn FEM thật (không surrogate).
3. Cung cấp tập nghiệm Pareto và phân tích đánh đổi khối lượng–chuyển vị cho một công trình bến cảng cỡ lớn thực tế tại Việt Nam, làm cơ sở tham khảo cho thiết kế sơ bộ/tối ưu hệ cọc bến cảng.

---

# 5. 2. CASE STUDY AND FINITE ELEMENT MODEL

## 5.1. Mục đích của mục này (nhắc lại — tránh lệch trọng tâm)

Hồ sơ thiết kế **chỉ dùng để dựng mô hình FEM đầu vào** (hình học, vật liệu, tiết diện gốc, tải trọng, điều kiện biên/lò xo nền). Không đánh giá, không phê bình hồ sơ.

## 5.2. Mô tả công trình

- cầu tàu container 100.000 DWT, bến liền bờ, bệ cọc cao đài mềm (dầm–bản BTCT trên nền cọc);
- kích thước chính: dài ~75 m (mô hình), rộng mặt cầu 50 m, cao trình đỉnh bến +5,50 m, đáy bến −16,0 m;
- tàu thiết kế 100.000 DWT (330×45,5×14,8 m).

## 5.3. Hệ cọc

- 132 cọc ống BTCT dự ứng lực D800‑540 (tiết diện gốc dùng làm **điểm khởi tạo/tham chiếu**, không phải kết quả tối ưu);
- 60 cọc ống thép D1016‑T16;
- module dọc 5,1 m; độ xiên 6:1 (trong)/7:1 (biên) — **giữ nguyên, không tối ưu**.

## 5.4. Mô hình FEM SAP2000

- 4.913 nút, 1.734 phần tử thanh, 4.488 phần tử tấm vỏ;
- vật liệu: Be tong M400/M800, Coc thep, A615Gr60, A992Fy50, A416Gr270 (tao DƯL);
- điều kiện biên: 192 nút ngàm biên phân đoạn, 178 nút có lò xo trục cọc (K33);
- 14 load case tĩnh cơ bản (BT, Va, Neo1, Neo2, MT, HH1‑6, CT1(di dong), CT2(Bao), CT1(tinh Z), CT2(tinh X), CT1(tinh Y));
- File FEM đã xác nhận khớp chuẩn với hồ sơ: `Sap/Ben100kDWT_sensitivity.sdb` (xem xác nhận đối chiếu ở phiên làm việc trước).

### 5.4.1. Xác nhận 36 tổ hợp tải (đã đọc trực tiếp từ `COMBINATION DEFINITIONS` trong file mô hình)

Đã parse toàn bộ bảng tổ hợp tải trong `Sap/Ben100kDWT_sensitivity.$2k` — xác nhận đúng 36 tổ hợp cơ bản như liệt kê trong [FEM_PhanDoan_TieuChuan_100000DWT.md](Cau tau Lach Huyen/FEM_PhanDoan_TieuChuan_100000DWT.md) mục 10: `COMB1, COMB2, COMB3.1‑3.6, COMB4.1‑4.6, COMB5.1‑5.2, COMB6.1‑6.12, COMB7.1‑7.3, COMB8.1‑8.4, "BAO (storm)"`.

**Phát hiện quan trọng — đã xử lý cả 2 điểm:**

1. **Đơn giản hoá tính f2/ràng buộc theo envelope (đã chốt — "lấy từ Bao cho nhanh"):** dùng trực tiếp tổ hợp Envelope có sẵn **`"BAO KT"`** (bao 35/36 tổ hợp cơ bản, trừ `"BAO (storm)"`) cho cả f2 và các ràng buộc nội lực/ứng suất — chỉ 1 lần trích xuất OAPI, **không** ghép thêm `"BAO (storm)"` riêng như đề xuất ban đầu. **Hệ quả cần ghi rõ trong bài (Limitations):** tổ hợp `"BAO (storm)"` (BT + 1,25×CT2(Bao) + 1,25×CT2(tinh X) — kịch bản cần trục khi có bão) nằm ngoài phạm vi kiểm tra của campaign tối ưu; đây là đơn giản hoá có chủ đích vì lý do tốc độ tính toán (mỗi cá thể chỉ cần 1 lần đọc envelope thay vì 2), chấp nhận được cho phạm vi NCS năm đầu nhưng không phải kiểm tra đầy đủ tuyệt đối 36/36 tổ hợp.
2. **Sửa COMB6.2 (đã chốt):** `COMB6.2` được hiệu chỉnh thành `BT + MT + Neo1 + HH2` (thay vì trùng `COMB6.1 = BT+MT+Neo1+HH1` như hồ sơ gốc) để nhóm `Neo1` đối xứng đủ HH1‑HH6 giống nhóm `Neo2`. **Đây là hiệu chỉnh của nhóm tác giả**, cần nêu rõ trong bài (ví dụ ghi chú ở Bảng liệt kê tổ hợp tải): "COMB6.2 điều chỉnh từ hồ sơ gốc (vốn trùng COMB6.1) để hoàn thiện ma trận tổ hợp Neo1×HH1‑6 theo đúng cấu trúc đối xứng với nhóm Neo2". Vì `"BAO KT"` (mục 1 ở trên) đã tham chiếu `COMB6.2` trong danh sách envelope, sửa nội dung COMB6.2 sẽ tự động cập nhật đúng vào kết quả envelope — không cần sửa gì thêm ở định nghĩa `"BAO KT"`.

## 5.5. Kiểm tra baseline model

Kiểm tra nhanh geometry/vật liệu/tiết diện/số lượng cọc/tải trọng khớp hồ sơ — **đã thực hiện, đạt** (xem bảng đối chiếu đã lập).

---

# 6. 3. OPTIMIZATION PROBLEM FORMULATION

## 6.1. Biến thiết kế

```text
x = [CatIdx_BTCT, D_thep, t_thep]     (ĐÃ CHỐT LẠI 28/08/2026 — còn 3 biến, không phải 4)
```

| Biến | Miền | Kiểu |
|---|---:|---|
| CatIdx_BTCT — chỉ số dòng catalogue cọc BTCT | 1–3 (số nguyên) | Rời rạc — tra bảng |
| D_thep — đường kính ngoài cọc thép | 0,90–1,10 m, bước 25mm | Rời rạc — lưới cố định |
| t_thep — chiều dày thành cọc thép | 0,012–0,020 m, bước 1mm | Rời rạc — lưới cố định |

Chỉ tối ưu tiết diện; không đổi vị trí, độ xiên, chiều dài, lò xo nền, dầm/bản.

**Kiểu biến — ĐÃ CHỐT LẠI LẦN CUỐI (28/08/2026, thay toàn bộ các quyết định "liên tục" trước đó):**

- **Cọc BTCT — rời rạc theo catalogue thương mại thật** (không còn liên tục, không còn quy đổi tỷ lệ từ neo D800‑540). Nguồn: [Cataloge coc ly tam.md](Cataloge%20coc%20ly%20tam.md) — catalogue AMACCAO PILE thật (TCVN 7888:2014, JIS A 5373:2016), lấy 3 dòng nằm trong miền nghiên cứu ban đầu (0,70–0,90m): **D700(t=110mm), D800(t=120mm), D900(t=130mm)**, dùng **Class A** (thận trọng nhất, không thêm Class thành biến thứ 5). D và t của BTCT KHÔNG còn là 2 biến độc lập — mỗi D catalogue đi kèm đúng 1 t cố định → gộp thành 1 biến `CatIdx_BTCT` duy nhất. Đã kiểm chứng chéo: diện tích A trong catalogue khớp đúng công thức hình học vành khuyên. Xem `Wharf100DWT/wharf100dwt_catalogue_btct.m`.
- **Cọc ống thép — rời rạc theo lưới cố định** (không còn liên tục): D_thep bước 25mm, t_thep bước 1mm, trong dải TCVN 9245:2012/JIS A5525 tham chiếu (D 318,5–2.000mm, t 6,9–25mm — không có catalogue thật cho cọc thép, chỉ có bản vẽ chế tạo cho cọc BTCT).

**Lưu ý quan trọng:** Mcr/Mu/Pvl của catalogue AMACCAO (D800, Class A: Mcr=37,0 T.m, Mu=55,5 T.m, Pvl=680 T) **khác** với neo D800‑540 lấy từ hồ sơ thiết kế gốc dự án Lạch Huyện (Mcr=67,4 T.m, Mu=134,8 T.m, Pmax=658 T) — vì hồ sơ gốc dùng thiết kế tuỳ chỉnh (t=130mm, cấu hình cốt thép DƯL riêng của dự án), khác với D800 chuẩn của AMACCAO (t=120mm). Đây là lựa chọn có chủ đích: chuyển từ "quy đổi tỷ lệ từ 1 thiết kế cụ thể" sang "chọn theo catalogue thương mại thật" cho bài toán tối ưu.

## 6.2. Hàm mục tiêu

- **f1 = min(tổng khối lượng vật lý cọc, tấn)** — thể tích mặt cắt vành khuyên (D,t) × **tổng chiều dài chế tạo thực tế của từng cọc** × khối lượng riêng vật liệu, cộng BTCT + thép cùng đơn vị tấn, không quy đổi chi phí. Chiều dài chế tạo **không lấy từ `Bang toa do coc.xls`** (đã kiểm tra: file chỉ có toạ độ mặt bằng x,y, không có chiều dài).
  - **Cọc BTCT — đã xác nhận bằng bản vẽ chế tạo thật `01..09. Coc DUL.dxf`** (đọc bằng `ezdxf`): có đúng **7 chiều dài chế tạo tiêu chuẩn thật** cho cọc D800‑540: **28, 29, 30, 31, 32, 34, 37 m** (không liên tục). Bản vẽ này còn xác nhận chéo, khớp chính xác 100%, với 3 giá trị neo sức kháng đang dùng: Mcr=67,40 T.m, Mu=134,80 T.m, Pmax=658 T. **Biên trên chiều dài chế tạo thật là 37m** (không phải 34m như giả thiết ban đầu — đã sửa).
  - **Cọc thép D1016 — chưa có bản vẽ chế tạo riêng** — dải [28,32]m vẫn là giả thiết chưa xác nhận.
  - Suy ra chiều dài từng cọc trong 192 cọc bằng quy đổi tuyến tính (affine) từ `fem_length_m` thật của từng cọc (khai thác từ kết quả Paper 1 — `pile_master_table.csv`, cùng mô hình FEM gốc) sao cho khớp đúng min/max của dải chế tạo đã xác nhận (BTCT) / giả thiết (thép). Tổng chiều dài dùng cho f1: **BTCT = 4.243,0 m** (132 cọc), **thép = 1.806,8 m** (60 cọc, chưa đổi) — xem `Wharf100DWT/pile_length_table.csv`. Vẫn là **nội suy liên tục xấp xỉ** (không snap về đúng 7 giá trị rời rạc — snap cho kết quả dồn cục bất thường, kém tin cậy hơn), nhưng phản ánh đúng phân bố tương đối thật giữa các cọc, cải thiện đáng kể so với dùng 1 giá trị trung bình phẳng.
- f2 = min(chuyển vị ngang lớn nhất của cầu tàu) — lấy trên **tổ hợp Envelope `"BAO KT"`** (bao 35/36 tổ hợp cơ bản, đã chốt dùng riêng combo này cho tốc độ — không ghép thêm `"BAO (storm)"`, xem mục 5.4.1).

## 6.3. Ràng buộc

- **ràng buộc N-M cọc BTCT — ĐÃ CHỐT LẠI (28/08/2026): dùng đúng công thức tương tác `N/Nmax + M/Mu ≤ 1,0`** (theo khuyến nghị mục 5.1 của [Cataloge coc ly tam.md](Cataloge%20coc%20ly%20tam.md)) — thay cho kiểm tra N và M riêng lẻ, cộng dồn 2 vi phạm độc lập (bản trước). Kiểm tra trên tổ hợp Envelope `"BAO KT"`;
- ứng suất tương đương cọc thép ≤ Fy/γ, với **Fy = 3.150 kG/cm² (theo bản vẽ/TCVN 9245:2012, đã chốt — không dùng giá trị quy đổi 2.531 kG/cm² trong bảng vật liệu phi tuyến SAP)** — tổ hợp Envelope `"BAO KT"`;
- **chuyển vị ngang ≤ giới hạn — ĐÃ CHỐT SỐ LIỆU CỤ THỂ.** Nguồn: **TCVN 11820‑5:2021, Điều 8.9, Bảng 12 — "Giới hạn chuyển vị khi khai thác đối với kết cấu bến"** (bạn cung cấp trực tiếp ảnh chụp bảng). Hàng áp dụng — **phương ngang, vị trí "đỉnh bến trên nền cọc, đỉnh trụ"**: giới hạn chuyển vị = **1/300 chiều cao bến, nhưng không vượt quá 100 mm** (không có quy định riêng bổ sung cho hàng này).

  Áp dụng cho công trình: chiều cao bến `H` = cao trình đỉnh bến − cao trình đáy bến (hoàn thiện) = (+5,50) − (−16,0) = **21,5 m**.
  → `H/300` = 21.500 mm / 300 = **71,7 mm**; so với trần 100 mm → **giới hạn chuyển vị ngang cho phép = 71,7 mm** (≈ 7,17 cm), do `H/300` nhỏ hơn trần nên là giá trị chi phối.

  ⚠️ Giả thiết cần bạn xác nhận lại: "chiều cao bến" trong Bảng 12 hiểu là khoảng cách đỉnh bến–đáy bến hoàn thiện (21,5 m) — nếu định nghĩa chính thức trong TCVN 11820‑5 (mục thuật ngữ, Điều 3) khác (ví dụ tính từ cao độ đáy biển tự nhiên, hoặc từ điểm ngàm cọc), cần đổi lại `H` và tính lại giới hạn.
- sức chịu tải địa kỹ thuật của cọc theo TCVN 10304:2025 — **đưa vào đầy đủ ngay từ đầu (đã chốt)**, trong bối cảnh nền móng công trình cảng biển theo TCVN 11820‑4‑1:2020 (không nhân chồng hệ số hai tiêu chuẩn).

> ⚠️ **Lưu ý số hiệu/năm ban hành TCVN 11820 (phát hiện khi tra cứu):** bản đã xác nhận **được công bố chính thức** là **TCVN 11820‑1:2017** (Nguyên tắc chung) và **TCVN 11820‑2:2017** (Tải trọng và tác động) — không phải "...:2026" như liệt kê trong ngữ cảnh dự án ban đầu. Có tìm thấy thông báo lấy ý kiến "soát xét, bổ sung" cho cả 2 phần này (moc.gov.vn), tức bản sửa đổi đang được xây dựng, nhưng tôi **chưa xác nhận được bản 2026 chính thức đã ban hành**. Bạn kiểm tra lại xem đã có bản 2026 chính thức chưa (nếu bạn có quyền truy cập trực tiếp/đã mua), hoặc tạm dùng trích dẫn 2017 cho 2 phần này trong bài — TCVN 11820‑4‑1:2020 và TCVN 11820‑5:2021 đã xác nhận đúng như ngữ cảnh ban đầu.

**Sức kháng cọc BTCT (Mcr, Mu, Pmax) theo D,t (ĐÃ CHỐT LẠI):** quy đổi TỶ LỆ diện tích mặt cắt vành khuyên (Pmax) và mô men kháng uốn đàn hồi tiết diện vành khuyên (Mcr, Mu) từ neo D800‑540 — KHÔNG dùng catalogue PHC (quyết định đã bỏ), KHÔNG dùng công thức giải tích TCVN 5574:2018 tính lại từ đầu. Đây là tiền xử lý, đã cài đặt trong [wharf100dwt_pile_capacity_btct.m](Wharf100DWT/wharf100dwt_pile_capacity_btct.m). Bộ neo Mcr=67,40 T.m / Mu=134,80 T.m / Pmax=658 T đã xác nhận chéo khớp chính xác 100% với bản vẽ chế tạo `01..09. Coc DUL.dxf`.

## 6.4. Xử lý ràng buộc trong MOFDA (đã chốt: penalty function)

**Công thức đề xuất (bản nháp — cần chốt hệ số qua pilot):**

Với mỗi ràng buộc `g_j(x)`, định nghĩa mức vi phạm chuẩn hoá (không thứ nguyên):

```text
Ràng buộc dạng "≤ giới hạn" (lực dọc, mô men, ứng suất, chuyển vị):
    v_j(x) = max(0, g_j(x)/g_j,lim − 1)

Ràng buộc dạng "≥ giới hạn" (sức chịu tải địa kỹ thuật ≥ tải trọng tác dụng):
    v_j(x) = max(0, tải trọng tác dụng/sức chịu tải cho phép − 1)
```

Tổng vi phạm chuẩn hoá của cá thể:

```text
P(x) = Σ_j v_j(x)          (j = 1..m, m = số ràng buộc)
```

Áp phạt **nhân** đồng thời lên cả 2 mục tiêu (giữ nguyên hướng tìm kiếm Pareto, không thiên vị f1 hay f2):

```text
F1(x) = f1(x) × [1 + C × P(x)]
F2(x) = f2(x) × [1 + C × P(x)]
```

- `C`: hằng số khuếch đại phạt (đề xuất giá trị khởi tạo **C = 10**) — hiệu chỉnh qua pilot sao cho: (a) mọi cá thể vi phạm luôn bị trội hơn (dominated) bởi cá thể khả thi tốt nhất trong quần thể; (b) không làm sai lệch hình dạng phần Pareto front khả thi khi P(x)=0 (lúc đó F_k=f_k, không đổi).
- Cách nhân (thay vì cộng tuyệt đối) tránh vấn đề khác thứ nguyên giữa f1 (tấn) và f2 (mm/m).
- Không dùng constraint-domination kiểu Deb (đã loại ở bước chốt này) để tránh phải sửa lại cơ chế repository/domination gốc của MOFDA — chỉ thay `fit(i,:) = obj(X(i,:))` trong `MOFDA_2D.m`/`MOFDA_3D.m` bằng `[F1,F2] = evaluate_with_penalty(X(i,:))`.

---

# 7. 4. MOFDA — THUẬT TOÁN TỐI ƯU ĐA MỤC TIÊU SỬ DỤNG

## 7.1. Vì sao chọn MOFDA (1 đoạn ngắn, không so sánh)

- đã kiểm chứng trên benchmark toán học + bài toán kỹ thuật ràng buộc + 1 công trình thực (khung thép);
- có sẵn code MATLAB, đã tích hợp khung MATLAB–SAP2000;
- phù hợp mở rộng sang bài toán kết cấu bến cảng có FEM thật (không cần hàm mục tiêu giải tích).

> Không đưa nội dung so sánh MOFDA với NSGA-II/MOPSO/MOEA-D vào bài — nếu ban biên tập JMST yêu cầu, để lại cho phần Discussion/Limitations như hướng nghiên cứu tiếp theo, không làm nội dung chính.

## 7.2. Tóm tắt cơ chế thuật toán (ngắn gọn, trích dẫn bài gốc)

- quần thể "dòng chảy" (flow), cập nhật vị trí theo hướng dốc giảm mô phỏng dòng nước;
- cơ chế hybrid leader selection thay roulette wheel truyền thống — tăng hội tụ/đa dạng nghiệm Pareto;
- repository lưu nghiệm không bị trội (non-dominated), cập nhật lưới (grid) để duy trì đa dạng.

## 7.3. Tham số thuật toán dùng trong bài

Bảng tham số: Np (population), Nr (repository size), beta (số lân cận), maxiter, số lần chạy độc lập (Nrun) — điền sau khi chốt từ pilot.

---

# 8. 5. MATLAB–SAP2000 OAPI COUPLING FRAMEWORK

## 8.1. Kiến trúc pipeline

```text
x (MOFDA đề xuất, liên tục)
   ↓
D_BTCT/t_BTCT → làm tròn về mm (biến liên tục, không catalogue PHC — đã sửa quyết định)
D_thep/t_thep → làm tròn về mm (biến liên tục, trong dải JIS A5525)
   ↓
Ghi D, t vào Frame Section Properties (COCBTCT, COCTHEP) qua SAP2000 OAPI
   ↓
Chạy phân tích FEM (RunAnalysis) — 14 load case cơ bản + tổ hợp Envelope "BAO KT"
   ↓
Trích xuất chuyển vị, nội lực cọc trên "BAO KT" (1 lần đọc OAPI/cá thể)
   ↓
Tính g_j(x) (ràng buộc), f1(x) [khối lượng], f2(x) [chuyển vị envelope]
   ↓
Áp penalty function nếu vi phạm ràng buộc
   ↓
Trả (f1, f2) về MOFDA
```

## 8.2. Thành phần mã (kế thừa kinh nghiệm SAP2000-MATLAB, xem [Cach ket noi_SAP2000_MATLAB_OPTIMIZATION.md](Cach ket noi_SAP2000_MATLAB_OPTIMIZATION.md))

- mở SAP2000 headless (`SM.ApplicationStart('Visible', false)`);
- 1 file `.sdb` việc làm riêng, không chia sẻ giữa các lần đánh giá song song nếu chạy `spmd`;
- pilot đo thời gian/vòng lặp thật trước khi cam kết campaign chính;
- checkpoint + ghi atomic nếu campaign chạy nhiều giờ.

## 8.3. Kiểm thử pipeline

- smoke test (Np nhỏ, 1 thế hệ) — đã thực hiện ở phiên trước (dry-run 50 thế hệ, **kết quả dry-run không dùng để công bố**, chỉ xác nhận pipeline chạy được);
- cần làm lại/khẳng định lại: tên tổ hợp tải đúng, OAPI trích xuất đúng, trước khi chạy campaign thật.

---

# 9. 6. NUMERICAL EXPERIMENT DESIGN

## 9.1. Ba bước bắt buộc

1. **Smoke test**: Np nhỏ, 1 thế hệ — kiểm tra pipeline không lỗi.
2. **Pilot thật**: đúng Np dự kiến cho campaign, đo thời gian/vòng lặp thật (không ngoại suy).
3. **Campaign chính**: Np×maxiter đã chốt từ pilot, Nrun đủ lặp lại (nếu cần đánh giá ổn định thuật toán).

## 9.2. Quy mô dự kiến ban đầu

- pilot: Np ~ 10–20, maxiter ~ 10–20;
- campaign: tăng dần theo thời gian FEM đo được ở pilot — **không chốt số trước khi có pilot thật**.

## 9.3. Phạm vi tổ hợp tải (đã chốt, đơn giản hoá để tăng tốc)

Dùng trực tiếp tổ hợp Envelope có sẵn **`"BAO KT"`** (bao 35/36 tổ hợp cơ bản, trừ `"BAO (storm)"`) cho cả f2 và các ràng buộc nội lực/ứng suất — 1 lần trích xuất OAPI mỗi cá thể ("lấy từ Bao cho nhanh", đã chốt). `"BAO (storm)"` không được kiểm tra trong campaign tối ưu — ghi rõ là giới hạn/đơn giản hoá có chủ đích trong phần Limitations của bài. `COMB6.2` đã hiệu chỉnh thành `BT+MT+Neo1+HH2` (mục 5.4.1) nên nội dung `"BAO KT"` dùng bản đã sửa.

---

# 10. 7. RESULTS AND DISCUSSION (khung — điền sau khi có dữ liệu thật)

## 10.1. Hội tụ và tính khả thi của campaign

- đường hội tụ theo thế hệ;
- tỷ lệ cá thể khả thi qua các thế hệ.

## 10.2. Pareto front

- Hình: Pareto front (f1 = khối lượng, f2 = chuyển vị);
- số nghiệm không bị trội thu được;
- hình dạng front (lồi/lõm, liên tục/rời rạc).

## 10.3. Phân tích đánh đổi (trade-off)

- knee point / nghiệm đại diện;
- % giảm khối lượng ứng với mỗi mức tăng chuyển vị cho phép;
- so sánh nghiệm đại diện với tiết diện gốc trong hồ sơ (D800‑540 / D1016‑T16) — **chỉ là điểm neo tham chiếu để người đọc hình dung độ lớn, không kết luận thiết kế gốc đúng/sai**.

## 10.4. Kiểm tra ràng buộc của nghiệm được chọn

- lực dọc trục, mô men, ứng suất, chuyển vị — đối chiếu giới hạn TCVN.

## 10.5. Vai trò của ràng buộc trong định hình Pareto front

- ràng buộc nào chi phối (active) tại các vùng khác nhau của front.

## 10.6. Engineering implications

- ý nghĩa cho thiết kế sơ bộ/tối ưu hệ cọc bến cảng;
- giới hạn của nghiên cứu (chỉ tối ưu tiết diện, chưa tối ưu bố trí/hình học; FEM tuyến tính tĩnh).

---

# 11. 8. CONCLUSIONS (dự kiến 4–5 kết luận, điền số liệu sau)

## C1 — Formulation
Bài toán MOO tiết diện cọc bến cảng (2 vật liệu) theo TCVN hiện hành đã được hình thành và giải được bằng MOFDA kết hợp FEM thật.

## C2 — Pipeline
Khung kết nối MOFDA↔SAP2000 OAPI hoạt động ổn định cho bài toán này (nêu thời gian/độ tin cậy thực đo).

## C3 — Pareto front
Đặc điểm tập nghiệm Pareto và mức đánh đổi khối lượng–chuyển vị.

## C4 — Ràng buộc chi phối
Ràng buộc nào quyết định biên khả thi của bài toán.

## C5 — Hàm ý kỹ thuật
Gợi ý áp dụng cho thiết kế sơ bộ hệ cọc bến cảng tương tự.

---

# 12. FIGURES — BỘ HÌNH KHÓA (dự kiến)

1. **Fig. 1** — 3D SAP2000 model của cầu tàu 100.000 DWT.
2. **Fig. 2** — Sơ đồ biến thiết kế trên mặt cắt cọc (D, t của 2 loại cọc).
3. **Fig. 3** — Sơ đồ kiến trúc pipeline MOFDA↔SAP2000 OAPI.
4. **Fig. 4** — Đường hội tụ của campaign tối ưu.
5. **Fig. 5** — Pareto front (khối lượng vs chuyển vị).
6. **Fig. 6** — So sánh nghiệm đại diện với tiết diện gốc trên biểu đồ.

---

# 13. TABLES — BỘ BẢNG KHÓA (dự kiến)

1. **Table 1** — Đặc trưng chính công trình và mô hình FEM.
2. **Table 2** — Biến thiết kế, miền giá trị.
3. **Table 3** — Ràng buộc và tiêu chuẩn áp dụng tương ứng.
4. **Table 4** — Tham số thuật toán MOFDA dùng trong campaign.
5. **Table 5** — Thống kê Pareto front (min/max/mean của f1, f2).
6. **Table 6** — Kiểm tra ràng buộc của (các) nghiệm đại diện được chọn.

---

# 14. DATA PIPELINE

1. Base FEM model: `Sap/Ben100kDWT_sensitivity.sdb` (đã xác nhận khớp hồ sơ).
2. Viết/khẳng định lại các hàm MATLAB: `evaluate`, `constraints`, `material_tonnage`, `pile_ids`, `generate`, `update_repository` (mục 5 ngữ cảnh MOFDA — cần dựng lại vì thư mục mã trước đó không tồn tại trên máy này).
3. Xác nhận tên tổ hợp tải bao đúng trong SAP2000.
4. Kiểm chứng lời gọi OAPI trích xuất kết quả (displacement, frame forces).
5. Smoke test → Pilot thật → Campaign chính (mục 9).
6. Trích xuất Pareto front, tính chỉ số MOO (nếu cần: hypervolume, spacing — đã có sẵn hàm trong `MOFDA/Functions`).
7. Chọn nghiệm đại diện, kiểm tra ràng buộc đầy đủ.
8. Dựng hình/bảng, viết Results & Discussion.
9. Hoàn thiện Abstract, Conclusions.

---

# 15. VALIDATION CHECKLIST

Trước khi chạy campaign chính:

- [x] Tên/định nghĩa đầy đủ của cả 36 tổ hợp tải xác nhận đúng trong SAP2000 (đã đọc trực tiếp từ file mô hình, mục 5.4.1).
- [ ] OAPI ghi đúng D, t (biến liên tục, cả 2 loại cọc) vào COCBTCT/COCTHEP và đọc đúng kết quả `"BAO KT"` — cần chạy `run_mofda_wharf100dwt('smoke')` thật để xác nhận.
- [x] Sức kháng BTCT: quy đổi tỷ lệ từ neo D800‑540 (không catalogue) — neo đã xác nhận chéo khớp bản vẽ `01..09. Coc DUL.dxf` (mục 6.3).
- [x] Đã tra và chốt giá trị số cụ thể của giới hạn chuyển vị theo TCVN 11820 (71,7mm, mục 6.3).
- [x] Fy thép cọc = 3.150 kG/cm² (đã chốt, dùng giá trị bản vẽ/TCVN 9245, không dùng 2.531 kG/cm² của SAP).
- [ ] Công thức penalty function cụ thể đã xác định và hiệu chỉnh hệ số phạt.
- [ ] Smoke test qua, Pilot thật đã đo thời gian/vòng lặp.
- [ ] Cơ chế checkpoint/atomic-save đã có nếu campaign chạy nhiều giờ.

Sau khi chạy:

- [ ] Tỷ lệ cá thể khả thi hợp lý qua các thế hệ.
- [ ] Pareto front không suy biến (không phải toàn bộ 1 điểm).
- [ ] Nghiệm đại diện thỏa toàn bộ ràng buộc khi kiểm tra lại độc lập.

---

# 16. LOGIC CỦA BÀI — PHẢI GIỮ XUYÊN SUỐT

Bài báo phải luôn trả lời một câu hỏi duy nhất:

> **Với đúng hình học, tải trọng và điều kiện biên của một cầu tàu 100.000 DWT thực tế, nếu cho phép tiết diện cọc (BTCT + thép) thay đổi trong miền hợp lý theo TCVN hiện hành, thì MOFDA tìm được tập nghiệm đánh đổi khối lượng–chuyển vị như thế nào?**

Không được để bài chuyển thành bài:

- so sánh thuật toán tối ưu;
- đánh giá/phê bình hồ sơ thiết kế gốc;
- nghiên cứu điểm ngàm/fixity của cọc;
- tối ưu hình học/bố trí cọc (ngoài phạm vi biến thiết kế đã chốt).

---

# 17. NOVELTY STATEMENT — BẢN NHÁP

> This study applies the previously validated Multi-Objective Flow Direction Algorithm (MOFDA), coupled directly with a full-scale SAP2000 finite-element model via OAPI, to solve a multi-objective pile cross-section optimization problem for a real 100,000-DWT container wharf under current Vietnamese port-design standards (TCVN 11820, TCVN 10304:2025, TCVN 5574:2018, TCVN 5575:2024). By evaluating candidate designs through genuine finite-element analysis rather than analytical or surrogate objective functions, the study demonstrates the practical applicability of MOFDA to a composite (prestressed-concrete and steel) piled-wharf pile system and quantifies the material–displacement trade-off relevant to preliminary/optimal design practice.

---

# 18. TRẠNG THÁI HIỆN TẠI

## Đã khóa (theo yêu cầu người dùng)

- [x] Mục đích: ứng dụng MOFDA để tối ưu MOO tiết diện cọc, không so sánh thuật toán, không đánh giá hồ sơ thiết kế.
- [x] Bài báo độc lập, không thuộc chuỗi/roadmap nhiều bài nào khác.
- [x] Case study: cầu tàu 100.000 DWT, FEM đã xác nhận khớp hồ sơ (`Sap/Ben100kDWT_sensitivity.sdb`).
- [x] Tên bài: **PA1** — Tối ưu hóa đa mục tiêu tiết diện cọc cầu tàu container 100.000 DWT bằng thuật toán Flow Direction đa mục tiêu (MOFDA) theo tiêu chuẩn TCVN hiện hành.
- [x] f1 = tổng khối lượng vật lý (tấn), dùng **chiều dài chế tạo thực tế TỪNG CỌC** (suy ra từ fem_length_m thật qua quy đổi affine, khai thác kết quả Paper 1 + bản vẽ `01..09. Coc DUL.dxf` để xác nhận biên thật của BTCT là 28–37m — xem `Wharf100DWT/pile_length_table.csv`), không quy đổi chi phí. Tổng: BTCT=4.243,0 m, thép=1.806,8 m (chưa xác nhận).
- [x] f2 = chuyển vị ngang lớn nhất trên tổ hợp Envelope **`"BAO KT"`** (đơn giản hoá tốc độ, không ghép `"BAO (storm)"`).
- [x] Ràng buộc sức chịu tải địa kỹ thuật (TCVN 10304:2025) đưa vào đầy đủ ngay từ đầu.
- [x] **Giới hạn chuyển vị ngang = 71,7 mm** (chi phối bởi 1/300×H, H=21,5m; trần 100mm không chi phối) — theo TCVN 11820‑5:2021, Điều 8.9, Bảng 12 (bạn cung cấp trực tiếp, đã chốt).
- [x] Sức kháng cọc BTCT (Mcr/Mu/Pmax): quy đổi TỶ LỆ diện tích/mô men kháng uốn từ neo D800‑540 (không dùng catalogue PHC — quyết định sau đã thay quyết định "nội suy catalogue" ban đầu). **Neo Mcr=67,40 T.m / Mu=134,80 T.m / Pmax=658 T đã xác nhận chéo khớp chính xác 100%** với bản vẽ `01..09. Coc DUL.dxf`.
- [x] Fy thép cọc = 3.150 kG/cm² (theo bản vẽ/TCVN 9245:2012).
- [x] Biến thiết kế: **cả 2 loại cọc đều LIÊN TỤC** (quyết định sau — bỏ hẳn catalogue PHC cho BTCT, không chỉ riêng cọc thép) trong miền nghiên cứu ban đầu; cọc thép trong dải TCVN 9245:2012/JIS A5525 (D 318,5–2.000mm, t 6,9–25mm, SKK400/SKK490).
- [x] Xử lý ràng buộc trong MOFDA: penalty function nhân đồng thời `F_k = f_k×[1+C·P(x)]`, C khởi tạo = 10 (mục 6.4).
- [x] Thuật toán: MOFDA (đã có code MATLAB nền tảng trong [MOFDA/MOFDA/Functions](MOFDA/MOFDA/Functions)).
- [x] Cấu trúc đề cương bài báo (mục 1–17 ở trên).
- [x] 36 tổ hợp tải đã đọc trực tiếp từ file mô hình, xác nhận khớp mục 10 tài liệu FEM.
- [x] Phạm vi tổ hợp tải dùng cho tối ưu: chỉ `"BAO KT"` (35/36 tổ hợp) — `"BAO (storm)"` ngoài phạm vi, ghi rõ trong Limitations (mục 5.4.1, 9.3).
- [x] `COMB6.2` hiệu chỉnh thành `BT+MT+Neo1+HH2` (khác hồ sơ gốc — hiệu chỉnh của nhóm tác giả, ghi chú rõ trong bài, mục 5.4.1).

## Mã MATLAB (đã xây dựng — bản nháp đầu tiên, CHƯA chạy thử thật)

Thư mục: [Wharf100DWT/](Wharf100DWT/) — xem [Wharf100DWT/README.md](Wharf100DWT/README.md) để biết thứ tự chạy đầy đủ và toàn bộ giả thiết/stub cần xử lý. Đã tận dụng lại code đã chạy thật trên chính máy này (dự án SFOA/MPJ tại `Tap chi XD_SFOA/code/...MOSFOA_MPJ`) làm khung mẫu (`open_Sap2000.m`, cách gọi `SM.*` OAPI, penalty function) và code MOFDA gốc tại [MOFDA/MOFDA/Functions](MOFDA/MOFDA/Functions) cho vòng lặp thuật toán.

**Đơn giản hoá biến thiết kế (đã chốt, thay cho bảng catalogue PHC):** không lập bảng catalogue PHC (TCVN 7888) — cả 2 loại cọc (BTCT và thép) đều xử lý là **biến liên tục** trong miền nghiên cứu ban đầu, chỉ làm tròn nhẹ về mm khi ghi OAPI. Sức kháng cọc BTCT tính bằng quy đổi tỷ lệ diện tích/mô men kháng uốn từ tiết diện gốc D800‑540 (không phải catalogue, không phải TCVN 5574:2018 chi tiết).

**Chưa thực hiện / cần bạn xác nhận:**

- [ ] **Xác nhận định nghĩa chính thức "chiều cao bến" H trong TCVN 11820‑5** (đoạn Mục 4.6 bạn gửi quy định *cao độ mặt bến* — một mốc cao độ tuyệt đối tính từ mực nước, không phải định nghĩa trực tiếp *chiều cao bến* — một khoảng cách/hiệu số cao độ. Hai khái niệm không hoàn toàn giống nhau. Đang tạm dùng giả thiết H = đỉnh bến(+5,50)−đáy bến(−16,0) = 21,5 m; nếu tài liệu gốc có định nghĩa khác cho "chiều cao bến" trong Bảng 12, cần sửa lại 71,7mm).
- [ ] **Xác nhận số hiệu/năm TCVN 11820‑1 và ‑2** — bản đã xác nhận công bố chính thức là **:2017** (không phải ":2026" như trong ngữ cảnh ban đầu); có bản soát xét/bổ sung đang lấy ý kiến nhưng chưa xác nhận đã ban hành 2026 hay chưa.
- [ ] Chạy `wharf100dwt_fix_comb62.m` (sửa COMB6.2), sau đó `run_mofda_wharf100dwt('smoke')` để kiểm chứng pipeline thật — code hiện là bản nháp đầu tiên, chưa tự chạy thử.
- [ ] 6 giả thiết/stub liệt kê trong `Wharf100DWT/README.md` — đặc biệt **ràng buộc địa kỹ thuật TCVN 10304 đang là STUB** (luôn "không vi phạm") và **chiều dài chế tạo cọc cho f1 đang dùng giá trị trung bình dải**, chưa phải bảng thật theo từng cọc.
- [ ] Hiệu chỉnh hệ số phạt C qua pilot thật (giá trị 10 chỉ là khởi tạo).
- [ ] Chạy smoke test → pilot → campaign chính.
- [ ] Viết Results/Discussion/Conclusions bằng số liệu thật.
