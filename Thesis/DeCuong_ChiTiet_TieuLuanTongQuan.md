# ĐỀ CƯƠNG CHI TIẾT — TIỂU LUẬN TỔNG QUAN
## Tài liệu độc lập để triển khai viết chi tiết (phiên làm việc riêng)

> **Cách dùng file này**: đây là brief đầy đủ, tự thân (self-contained)
> để viết trọn vẹn Tiểu luận Tổng quan mà không cần mở lại các file khác
> trong dự án. Nếu cần tra cứu sâu hơn phần khảo sát tài liệu cũ, xem
> mục 10 (Nguồn tham chiếu) ở cuối file.

---

## 0. Bối cảnh đề tài (bắt buộc phải nắm trước khi viết)

**Đề tài luận án:**
> NGHIÊN CỨU PHÁT TRIỂN THUẬT TOÁN TỐI ƯU METAHEURISTIC CHO KẾT CẤU HẠ TẦNG CẢNG BIỂN

**Sản phẩm khoa học lõi đã công bố (Track A)**: bài báo *"Multi-objective
Optimization Design of Marine Structures Based on An Enhanced Starfish
Algorithm"* (tạp chí Q3, ISI/Scopus), đề xuất **B-MOSFOA** và **E-MOSFOA**
— hai biến thể đa mục tiêu của **SFOA (Starfish Optimization Algorithm)**
— kiểm chứng trên 3 bộ benchmark (IMOP/UF/RM-MEDA) và ứng dụng cho ba hệ
kết cấu bến cảng thực tế: **BD (Berthing Dolphin)**, **MD (Mooring
Dolphin)**, **MJP (Main Jetty Platform)**, tích hợp MATLAB–SAP2000, hai
mục tiêu **chi phí xây dựng – chuyển vị lớn nhất**.

**Vai trò của Tiểu luận Tổng quan trong tổng thể 4 sản phẩm**: đây là
tài liệu đầu tiên, có nhiệm vụ dẫn dắt từ hiện trạng nghiên cứu → khoảng
trống → quyết định phát triển MOSFOA → thiết kế sơ bộ 3 Chuyên đề. Tổng
quan **không trình bày kết quả MOSFOA** (đó là việc của CĐ2/CĐ3) — nó
chỉ chứng minh **"WHY"** (tại sao phải nghiên cứu) và xác lập hướng đi.

**Tình trạng bản thảo cũ**: đã có một bản Tổng quan viết **trước khi có
bài báo MOSFOA** (`CHUYEN DE TONG QUAN.docx`, còn trong repo, ~70-80
trang gốc). NCS đã xác nhận **được phép xóa và viết lại hoàn toàn** —
không bị ràng buộc bởi cấu trúc/câu chữ cũ, nhưng phần khảo sát tài liệu
quốc tế/trong nước trong đó vẫn còn giá trị tham khảo (xem mục 7 và mục
10 dưới đây).

---

## 1. Quy cách trình bày bắt buộc (trích quy chế — chỉ áp dụng cho Tổng quan)

| Nội dung | Yêu cầu |
|---|---|
| Khổ giấy | A4 (210×297 mm) |
| Độ dài | **Khoảng 30 trang** |
| Font | Times New Roman, cỡ 14 |
| Giãn dòng | 1,5 lines |
| Lề trên/dưới/trái/phải | 3 / 3,5 / 3,5 / 2 cm |
| Số trang | Giữa, phía dưới |
| Trình bày | Khoa học, logic, ngắn gọn, rõ ràng, mạch lạc, sạch sẽ |

**Thứ tự trình bày bắt buộc**: Trang bìa → Mục lục → Danh mục chữ viết
tắt (nếu có) → Danh mục bảng (nếu có) → Danh mục hình (nếu có) → **Mở
đầu** → **Nội dung** → **Kết luận và kiến nghị** → Tài liệu tham khảo.

*(Nguồn: Phụ lục 02 quy chế đào tạo, trang 29–30 — đã tổng hợp đầy đủ
trong `Quy_che_yeu_cau_Chuyen_de_Hoi_thao_Hoi_dong_Dau_ra_Tien_si.md`
mục 3–5 nếu cần đối chiếu lại.)*

---

## 2. Khung 13 mục bắt buộc trong phần MỞ ĐẦU (không được thiếu mục nào)

1. Tổng quan vấn đề nghiên cứu;
2. Tính cần thiết của vấn đề nghiên cứu;
3. Phân tích và đánh giá công trình **trong nước**;
4. Phân tích và đánh giá công trình **quốc tế**;
5. Những vấn đề còn tồn tại;
6. Những vấn đề luận án cần tập trung giải quyết;
7. **Khả năng tiếp cận của nghiên cứu sinh** — *(mục hay bị bỏ sót nhất;
   đây là chỗ trình bày các công bố Track B của NCS — xem mục 6 dưới)*;
8. Mục đích nghiên cứu;
9. Đối tượng nghiên cứu;
10. Phạm vi nghiên cứu;
11. Nội dung nghiên cứu;
12. Phương pháp nghiên cứu;
13. Ý nghĩa khoa học và thực tiễn.

Phần **NỘI DUNG** (sau Mở đầu) phải có thêm: khả năng tiếp cận cơ sở lý
thuyết, giải pháp công nghệ, và **bắt buộc**: "thiết kế sơ bộ tên và nội
dung chính của 03 Chuyên đề tiến sĩ" (xem mục 8 dưới, đã chốt sẵn).

Phần **KẾT LUẬN VÀ KIẾN NGHỊ** phải nêu: dự kiến kết quả luận án, hạn
chế, vấn đề cần tiếp tục nghiên cứu, kiến nghị.

---

## 3. Mạch lập luận xuyên suốt (bắt buộc viết theo đúng trình tự này)

```text
Bài toán tối ưu kết cấu
        ↓
Tối ưu dựa trên metaheuristic (SI-MOO)
        ↓
Khảo sát các thuật toán liên quan
(kết hợp minh chứng "khả năng tiếp cận" — Track B của chính NCS)
        ↓
SFOA — vì sao chọn SFOA làm nền tảng
        ↓
Hạn chế của SFOA đơn mục tiêu khi mở rộng sang MOO
        ↓
RESEARCH GAP (4 khoảng trống — mục 5 dưới)
        ↓
Vấn đề khoa học cần giải quyết
        ↓
Mục tiêu luận án: chi phí – chuyển vị, đối tượng BD/MD/MJP
        ↓
Thiết kế sơ bộ 03 Chuyên đề tiến sĩ (mục 8 dưới)
        ↓
Luận án
```

**Nguyên tắc tối quan trọng**: Tổng quan không phải một bản liệt kê tài
liệu. Nó phải trả lời được 9 câu hỏi: (1) đã có gì? (2) đã giải quyết
được gì? (3) phương pháp nào đang dùng? (4) kết quả ra sao? (5) hạn chế
gì? (6) khoảng trống là gì? (7) luận án giải quyết khoảng trống nào?
(8) vì sao hướng nghiên cứu là cần thiết? (9) ba chuyên đề đóng góp khối
nào?

---

## 4. Đối tượng, phạm vi, mục tiêu (đã khóa — không tự ý mở rộng)

- **Đối tượng trung tâm**: kết cấu bến cảng biển dạng **cọc–bệ/bản công
  tác**, đại diện bởi ba hệ: **BD, MD, MJP**.
- **Đối tượng mở rộng tương lai** (không phải phạm vi thực nghiệm bắt
  buộc): tường cừ, tường chắn trọng lực, trụ va, trụ neo, dây neo phao,
  đê chắn sóng, kết cấu thép hạ tầng cảng (nhà điều hành...). *(Các đối
  tượng này đã có minh chứng thực nghiệm riêng qua Track B — xem mục 6.)*
- **Mục tiêu tối ưu**: khóa đúng hai mục tiêu — **chi phí xây dựng** và
  **chuyển vị lớn nhất**. Không thêm mục tiêu thứ ba (CO2, thời gian thi
  công...) trừ khi có lý do khoa học rất mạnh.
- **Phương pháp**: MATLAB điều phối vòng lặp SI-MOO ↔ FEM/SSI (SAP2000).

---

## 5. Bốn khoảng trống nghiên cứu (viết đúng theo khung này)

```text
GAP 1: Bài toán kết cấu cảng chưa được chuẩn hóa đầy đủ theo code-based MOO
GAP 2: SI-MOO hiện có (kể cả các thuật toán NCS đã thử ở Track B)
       chưa khai thác tốt cấu trúc bài toán kết cấu cảng
GAP 3: SFOA chưa có cơ chế MOO phù hợp
GAP 4: Chưa có cầu nối đầy đủ SFOA → MOO → FEM → SAP2000 → thiết kế cảng
```

**Đoạn bắt buộc phải có** — SFOA và khoảng trống khi mở rộng đa mục
tiêu (viết thành một mục riêng, không gộp chung chung vào SI-MOO):
SFOA vốn đơn mục tiêu → chưa có Pareto archive → chưa có cơ chế duy trì
đa dạng Pareto → chưa có leader selection từ archive → chưa thiết kế
trực tiếp cho bài toán cost–displacement có ràng buộc kết cấu cảng biển
→ do đó cần phát triển MOSFOA (dẫn thẳng vào Chuyên đề 1/2).

**Khóa tên thuật toán, dùng nhất quán trong toàn bài**: *"MOSFOA –
Multi-objective Starfish Optimization Algorithm"*, hai biến thể
**B-MOSFOA** (Base) và **E-MOSFOA** (Enhanced). **Không dùng lại** tên
"MOSFOAP" từng xuất hiện ở bản đề cương phụ lục cũ.

---

## 6. Mục "Khả năng tiếp cận của nghiên cứu sinh" — dàn ý cụ thể (mục 7 của phần Mở đầu)

Đây là mục dùng để trình bày **Track B** — các công bố của NCS chứng
minh quá trình tích lũy trước khi đề xuất MOSFOA. Viết theo mạch: *"Trước
khi đề xuất MOSFOA, NCS đã áp dụng và đối chứng một số thuật toán tối ưu
đơn/đa mục tiêu trên các bài toán kết cấu cảng biển khác, từ đó hình
thành động lực phát triển một thuật toán SI-MOO chuyên biệt hơn."*

| # | Công bố | Đối tượng | Thuật toán | Vai trò trong lập luận |
|---|---|---|---|---|
| 1 | *Efficient Design of Single Mooring Buoy Lines: A MOMSA-Based Approach*, SHM&ES 2025, LNCE vol. 747, Springer (2026) | Dây neo phao đơn | MOMSA (SOO/MOO) | Cho thấy MOMSA áp dụng được cho kết cấu cảng nhưng chưa chuyên biệt hóa cho lớp bài toán cọc–bệ |
| 2 | *On Optimization of Gravity Retaining Wall Considering the Dimension of the Stone Base*, VSOE 2024, LNCE 590, Springer (2025) | Tường chắn trọng lực | Thuật toán tối ưu SOO | Minh chứng thêm về ứng dụng tối ưu cho kết cấu cảng khác BD/MD/MJP |
| 3 | *(Dự kiến)* Tạp chí Xây dựng — "Nghiên cứu ứng dụng thuật toán SFOA cho tối ưu đơn mục tiêu kết cấu công trình biển" | Kết cấu công trình biển | SFOA (đơn mục tiêu) | **Tiền đề trực tiếp nhất** cho việc chọn SFOA làm nền tảng MOSFOA — nên trích dẫn ngay tại đoạn "vì sao chọn SFOA" ở mục 5 |
| 4 | *(Dự kiến)* JMST — "Nghiên cứu ứng dụng thuật toán MOSFOA cho tối ưu đa mục tiêu kết cấu công trình bến cảng" (dự án khác Hải Linh) | Bến bệ cọc cao (dự án độc lập) | MOSFOA | Minh chứng thêm, không phải sản phẩm lõi |
| 5 | *(Dự kiến)* ICERA 2026 — "Multi-objective optimization of I-section steel frames under TCVN 5575:2024..." | Khung thép nhà điều hành cảng | So sánh nhiều metaheuristic | Mở rộng phạm vi minh chứng sang hệ tiêu chuẩn thép (TCVN 5575:2024), khác hệ tiêu chuẩn bê tông/cọc chính của luận án |

**Lưu ý khi viết**: chỉ tóm tắt 2–4 câu mỗi công bố (kết cấu gì, thuật
toán gì, nhận định rút ra) — không trình bày chi tiết phương pháp/kết
quả của các bài này (đó không phải nội dung của Tổng quan).

---

## 7. Phần khảo sát tài liệu (tái sử dụng có chọn lọc từ bản cũ)

Bản Tổng quan cũ (`CHUYEN DE TONG QUAN.docx`) đã có khảo sát khá đầy đủ,
**nên tái sử dụng làm tư liệu** (không copy nguyên văn, viết lại câu dẫn
để khớp mạch lập luận ở mục 3):

- **Tổng quan thiết kế tối ưu kết cấu**: mô hình toán bài toán đơn/đa
  mục tiêu; phân loại thuật toán (gradient cổ điển → heuristic →
  metaheuristic: trajectory-based vs population-based).
- **Tổng quan MOO**: định nghĩa trội Pareto, tập/mặt Pareto, các phương
  pháp giải (trọng số, ε-constraint, goal programming, Pareto trực
  tiếp), No Free Lunch.
- **Tổng quan hạ tầng cảng biển**: 5 nhóm công trình (khu nước, bảo
  vệ-chỉnh trị, công trình bến, hậu phương, hạ tầng kỹ thuật); công
  trình bến chia thành bến trọng lực/tường cừ/**bến bệ cọc cao**; hệ
  tiêu chuẩn TCVN 11820 đối chiếu OCDI, BS 6349, PIANC.
- **Nghiên cứu quốc tế** (~16 công bố sau lọc, khảo sát Scopus): các
  hướng chính đã ghi nhận — hệ số động đất tường bến, DLO, SQP bến
  trọng lực, xử lý nền chống hóa lỏng, bến tường cừ sàn giảm tải, độ tin
  cậy mục tiêu, đê nổi, kè sinh thái, LCC bền vững, MOMPA móng cọc...
  *(danh sách đầy đủ + trích dẫn xem file cũ, mục 10 dưới)*.
- **Nghiên cứu trong nước** (~10 nhóm tác giả): tối ưu giàn/khung/composite
  bằng DE và biến thể, Bat/FDA/MPA/MSA, NSGA-II, IGA+MOPSO, RBDO,
  Rao/DE-Rao, LightGBM... — nhận định chung: nghiên cứu tối ưu "đúng
  nghĩa" cho kết cấu cảng còn ít, đa số làm nền trên kết cấu khác.

**Việc cần làm khi viết lại**: giữ nội dung khảo sát, nhưng (a) thêm hẳn
một đoạn riêng về SFOA (không có trong bản cũ — bản cũ hoàn toàn không
trích dẫn SFOA), (b) kết thúc phần khảo sát bằng research gap dẫn thẳng
tới MOSFOA thay vì "một thuật toán SI-MOO cải tiến" chung chung.

---

## 8. Thiết kế sơ bộ 03 Chuyên đề tiến sĩ (bắt buộc phải có trong phần Nội dung — đã chốt tên)

### SẢN PHẨM 2 — CHUYÊN ĐỀ TIẾN SĨ SỐ 1
> **CƠ SỞ KHOA HỌC BÀI TOÁN TỐI ƯU ĐA MỤC TIÊU CHO KẾT CẤU CÔNG TRÌNH CẢNG BIỂN**
Vai trò: xây dựng nền tảng khoa học, mô hình hóa bài toán, đối chứng
SOO/MOO bằng Track B.

### SẢN PHẨM 3 — CHUYÊN ĐỀ TIẾN SĨ SỐ 2
> **PHÁT TRIỂN VÀ KIỂM CHỨNG THUẬT TOÁN TỐI ƯU ĐA MỤC TIÊU MOSFOA**
Vai trò: đóng góp thuật toán (B-MOSFOA/E-MOSFOA, benchmark, sensitivity,
statistical validation).

### SẢN PHẨM 4 — CHUYÊN ĐỀ TIẾN SĨ SỐ 3
> **ỨNG DỤNG VÀ KIỂM CHỨNG THUẬT TOÁN MOSFOA CHO TỐI ƯU ĐA MỤC TIÊU KẾT CẤU HẠ TẦNG CẢNG BIỂN**
Vai trò: đóng góp ứng dụng, chứng minh giá trị kỹ thuật qua MATLAB–SAP2000,
BD/MD/MJP, thảo luận tổng quát hóa qua Track B.

*(Chỉ cần nêu tên + 1 đoạn ngắn vai trò + 3-4 gạch đầu dòng kết quả dự
kiến cho mỗi chuyên đề trong Tổng quan — KHÔNG viết dàn ý chi tiết từng
chương ở đây, việc đó thuộc về 3 file đề cương riêng của CĐ1/CĐ2/CĐ3.)*

---

## 9. Đóng góp khoa học — đoạn cần dẫn trong "Ý nghĩa khoa học và thực tiễn" (mục 13)

> *"Luận án đóng góp một khung phương pháp luận tối ưu đa mục tiêu theo
> tiêu chuẩn cho kết cấu cảng biển (CĐ1), phát triển và kiểm chứng thống
> kê hai thuật toán SI-MOO mới B-MOSFOA/E-MOSFOA (CĐ2), và chứng minh
> giá trị kỹ thuật của phương pháp thông qua một quy trình tích hợp
> MATLAB–SAP2000 áp dụng cho ba hệ kết cấu cảng biển thực tế (CĐ3), được
> củng cố bởi các nghiên cứu ứng dụng thuật toán tối ưu bổ sung trên các
> hạng mục kết cấu cảng khác."*

---

## 10. Checklist tự kiểm tra trước khi hoàn thành bản thảo

- [ ] Đủ 13 mục bắt buộc trong Mở đầu (mục 2).
- [ ] Có mục "khả năng tiếp cận của NCS" trích Track B (mục 6), không bỏ sót.
- [ ] Dẫn trực tiếp tới MOSFOA — không dừng ở "SI-MOO cải tiến" chung
      chung, không dùng tên "MOSFOAP".
- [ ] Có đủ 4 khoảng trống nghiên cứu (mục 5), có đoạn riêng về SFOA.
- [ ] Có thiết kế sơ bộ 3 Chuyên đề đúng tên đã chốt (mục 8).
- [ ] Khoảng 30 trang, đúng khổ giấy/font/lề (mục 1).
- [ ] Đối tượng trung tâm là BD/MD/MJP, không mở rộng phạm vi thực
      nghiệm sang các kết cấu khác (mục 4).
- [ ] Mục tiêu khóa đúng "chi phí – chuyển vị" (mục 4).
- [ ] Có đủ Mở đầu / Nội dung / Kết luận và kiến nghị / Tài liệu tham khảo.

---

## 11. Nguồn tham chiếu (chỉ cần khi cần tra cứu sâu hơn — không bắt buộc phải mở lại)

- `CHUYEN DE TONG QUAN.docx` — bản cũ, dùng để lấy lại phần khảo sát chi
  tiết + danh mục 87 tài liệu tham khảo gốc (cần bổ sung trích dẫn SFOA
  — bản cũ không có).
- `02_MOSFOA__VN.docx` — bài báo Q3 gốc, dùng nếu cần trích dẫn số liệu
  cụ thể của MOSFOA (thường không cần cho Tổng quan, việc đó thuộc CĐ2/CĐ3).
- `De_cuong_4_san_pham_xuyen_suot_luan_an_MOSFOA.md` — đề cương tổng thể
  đã chốt (Phần F là nguồn gốc của file này), dùng nếu cần đối chiếu lại
  logic toàn luận án.
