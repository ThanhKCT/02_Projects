# ĐỀ CƯƠNG CHI TIẾT — CHUYÊN ĐỀ TIẾN SĨ SỐ 1
## Tài liệu độc lập để triển khai viết chi tiết (phiên làm việc riêng)

> **Cách dùng file này**: brief tự thân để viết trọn vẹn Chuyên đề 1 mà
> không cần mở lại các file khác. Cần tra cứu sâu hơn → xem mục 9 cuối
> file.

---

## 0. Bối cảnh đề tài

**Đề tài luận án:**
> NGHIÊN CỨU PHÁT TRIỂN THUẬT TOÁN TỐI ƯU METAHEURISTIC CHO KẾT CẤU HẠ TẦNG CẢNG BIỂN

**Tên Chuyên đề 1 (đã chốt):**
> **CƠ SỞ KHOA HỌC BÀI TOÁN TỐI ƯU ĐA MỤC TIÊU CHO KẾT CẤU CÔNG TRÌNH CẢNG BIỂN**

**Vai trò trong tổng thể 4 sản phẩm**: CĐ1 chứng minh **"WHAT PROBLEM"**
— xây dựng nền tảng khoa học và mô hình hóa bài toán, kết thúc bằng đặc
tả yêu cầu cho một thuật toán mới (MOSFOA). CĐ1 **không trình bày** bất
kỳ kết quả benchmark hay kết quả kỹ thuật BD/MD/MJP nào — các phần đó
thuộc CĐ2 và CĐ3.

**Đóng góp khoa học tương ứng (Tầng 1/4)**: *"Xây dựng khung chuẩn hóa
bài toán tối ưu đa mục tiêu theo đúng tiêu chuẩn thiết kế (code-based)
cho kết cấu cảng biển dạng cọc–bệ, làm cơ sở yêu cầu kỹ thuật cho một
thuật toán SI-MOO mới — thay vì áp dụng một thuật toán MOO tổng quát
không tính đến đặc thù ràng buộc ngành."*

**Tình trạng bản thảo cũ**: đã có bản viết **trước khi có bài báo
MOSFOA** (`CHUYEN DE 1 HOAN CHINH.docx`). NCS đã xác nhận **được phép
xóa và viết lại hoàn toàn**. Bản cũ có 2 lỗi bắt buộc phải sửa triệt để
(xem mục 4 dưới): (a) trình bày dưới 1 chương duy nhất (mục 1.1–1.10),
vi phạm quy chế "chia thành 03 chương"; (b) chưa chốt SFOA, còn để ngỏ
"chọn một thuật toán nền phù hợp từ danh mục như MPA/SFOA" và dùng tên
sai "MOSFOAP".

---

## 1. Quy cách trình bày bắt buộc

| Nội dung | Yêu cầu |
|---|---|
| Khổ giấy | A4 |
| Độ dài | **Không quá 80 trang**, không kể phụ lục |
| Font | Times New Roman 14, giãn dòng 1,5 |
| Lề trên/dưới/trái/phải | 3 / 3,5 / 3,5 / 2 cm |
| Cấu trúc bắt buộc | Mở đầu → **Nội dung chia đúng 03 chương** → Kết luận (bàn luận) và kiến nghị → Tài liệu tham khảo → Phụ lục (nếu có) |
| Nội dung trọng tâm | **Chủ yếu là kết quả nghiên cứu của chuyên đề**, không phải một bài tổng quan tài liệu độc lập |

**Quy tắc hình thức tối quan trọng (vi phạm ở bản cũ, phải sửa)**: *"Mỗi
Chuyên đề phải có 03 chương"* — đây là yêu cầu bắt buộc, tách vật lý
thành Chương 1/2/3, không phải các mục 1.1–1.10 dưới một chương.

---

## 2. Quy tắc "giá trị gia tăng" áp dụng cho CĐ1

CĐ1 không dựa trực tiếp trên bài báo Q3 (bài báo không có nội dung cơ sở
lý thuyết MOO/Pareto/NFL chi tiết — phần đó bài báo nén gọn trong vài
dòng). Vì vậy giá trị gia tăng của CĐ1 chủ yếu đến từ:

- **Mở rộng lý thuyết**: trình bày đầy đủ, có lập luận từng bước, các
  khái niệm mà bài báo chỉ nêu ngắn gọn (Pareto dominance, NFL, kiến
  trúc SI-MOO, benchmark suites, các chỉ tiêu đánh giá).
- **Mở rộng đối chứng**: dùng chính các công bố Track B của NCS (mục 5
  dưới) làm bằng chứng thực nghiệm SOO/MOO trên kết cấu cảng biển khác,
  thay vì chỉ trích dẫn tài liệu người khác.
- **Mở rộng phạm vi**: mô hình hóa đầy đủ bài toán bến bệ cọc cao BTCT
  theo tiêu chuẩn (biến rời rạc, ràng buộc địa kỹ thuật/BTCT, FEM/SSI)
  — đây là nội dung KHÔNG có trong bài báo Q3 (bài báo trình bày trực
  tiếp bài toán BD/MD/MJP đã hình thành, không trình bày quá trình xây
  dựng khung mô hình hóa tổng quát).

---

## 3. Cấu trúc 3 chương bắt buộc (dàn ý chi tiết)

### CHƯƠNG 1 — CƠ SỞ KHOA HỌC TỐI ƯU ĐA MỤC TIÊU VÀ METAHEURISTIC

- **1.1. Đặt vấn đề**
- **1.2. Mục tiêu và câu hỏi nghiên cứu** (của riêng CĐ1, không lặp lại
  mục tiêu luận án)
- **1.3. Đối tượng, phạm vi, giả thiết và phương pháp**
- **1.4. Bài toán tối ưu đa mục tiêu**
  - Mô hình toán tổng quát: $\min_{\mathbf{X}} F(\mathbf{X}) = \{f_1(\mathbf{X}), ..., f_m(\mathbf{X})\}$
  - Biến thiết kế, hàm mục tiêu, ràng buộc — phân loại tổng quát
- **1.5. Quan hệ Pareto và nghiệm không bị trội**
  - Định nghĩa trội Pareto (dominance), tập Pareto (PS), mặt Pareto (PF)
  - Các phương pháp giải MOO: trọng số, ε-constraint, goal programming,
    Pareto trực tiếp (ưu tiên trình bày sâu nhánh Pareto trực tiếp vì
    đây là nền cho MOSFOA)
- **1.6. Metaheuristic và Swarm Intelligence**
  - Phân loại: gradient cổ điển → heuristic → metaheuristic
    (trajectory-based vs population-based; cảm hứng sinh học/bầy
    đàn/vật lý/xã hội)
  - MOEA kinh điển: NSGA-II, SPEA2, PAES, RM-MEDA, DE
  - SI-MOO hiện đại: MOMVO, MOMGA, MOALO, NS-MFO, MOMSA, MOGNDO
  - Nhóm đơn mục tiêu tiềm năng mở rộng: SSA, FDA, MPA, **SFOA**
- **1.7. NFL và yêu cầu phát triển thuật toán theo cấu trúc bài toán**
  - Định lý No Free Lunch (Wolpert–Macready) — hệ quả: không thuật toán
    nào vượt trội tuyệt đối trên mọi lớp bài toán → cần thuật toán khai
    thác cấu trúc riêng của bài toán kết cấu cảng biển

### CHƯƠNG 2 — ĐÁNH GIÁ THUẬT TOÁN VÀ TỐI ƯU KẾT CẤU THEO TIÊU CHUẨN

- **2.1. Nguyên tắc kiểm chứng thuật toán MOO**
- **2.2. Benchmark IMOP, UF, RM-MEDA** (chỉ giới thiệu nguyên tắc/đặc
  điểm bộ chuẩn — KHÔNG trình bày kết quả benchmark MOSFOA, đó là CĐ2)
- **2.3. Chỉ tiêu IGD/HV/Spread/Convergence** — GD/IGD (hội tụ),
  spacing/Δ (phân bố), hypervolume (đa dạng+hội tụ), MS (độ phủ)
- **2.4. Kiểm định thống kê** — Wilcoxon rank-sum, Holm adjustment,
  nguyên tắc W/D/L
- **2.5. Biến rời rạc và hỗn hợp** — biến thiết kế dạng $x_i \in \Omega_i$
  rời rạc theo catalogue (hình học, vật liệu, hệ cọc)
- **2.6. Xử lý ràng buộc** — nguyên tắc penalty, feasibility-first,
  repair
- **2.7. Tối ưu theo tiêu chuẩn** — công thức hóa ULS/SLS tổng quát;
  ràng buộc địa kỹ thuật (sức chịu tải đứng, trượt, lật, ổn định tổng
  thể, lún/chuyển vị ngang); ràng buộc BTCT (uốn/cắt/kéo nén, tương tác
  N–M, khe nứt/ứng suất)
- **2.8. FEM/SSI và chi phí tính toán** — tích hợp lò xo nền tương
  đương, chi phí tính toán cao khi FEM lặp trong vòng lặp tối ưu
- **2.9. (MỚI — bắt buộc, đây là điểm khác biệt lớn nhất so với bản cũ)
  Đối chứng thực nghiệm SOO và MOO trên kết cấu cảng biển từ các công
  bố của NCS** — xem dàn ý chi tiết ở mục 5 dưới

### CHƯƠNG 3 — MÔ HÌNH BÀI TOÁN KẾT CẤU CẢNG VÀ ĐỊNH HƯỚNG PHÁT TRIỂN MOSFOA

- **3.1. Đặc trưng kết cấu bến cọc** — hệ cọc–bệ/bản công tác, đại diện
  BD/MD/MJP (chỉ mô tả đặc trưng chung, không đi vào số liệu cụ thể của
  từng dự án — số liệu đó thuộc CĐ3)
- **3.2. Biến thiết kế** — loại biến (đường kính/chiều dày cọc, độ xiên,
  chiều dài, biến dầm MJP), miền giá trị rời rạc
- **3.3. Hàm mục tiêu cost–displacement** — công thức tổng quát (không
  cần số liệu đơn giá cụ thể)
- **3.4. Ràng buộc kết cấu và địa kỹ thuật** — tổng hợp lại từ 2.7,
  cụ thể hóa cho bài toán cọc–bệ
- **3.5. Mô hình FEM/SSI** — nguyên tắc mô hình hóa (không đi vào chi
  tiết phần mềm SAP2000 cụ thể — đó là CĐ3)
- **3.6. Khoảng trống nghiên cứu** — nhắc lại 4 GAP đã nêu ở Tổng quan,
  triển khai sâu hơn ở mức học thuật
- **3.7. Yêu cầu đối với thuật toán mới** — đặc tả yêu cầu: Pareto
  archive, duy trì đa dạng, leader selection, xử lý biến rời rạc, xử lý
  ràng buộc theo tiêu chuẩn
- **3.8. Định hướng MOSFOA** — **chốt dứt khoát SFOA** làm nền tảng
  (không để ngỏ MPA/SFOA như bản cũ), có luận cứ khoa học (xem mục 6 —
  cơ chế SFOA — để viết phần luận cứ này); trích dẫn bài báo Track B #3
  (SFOA-SOO) làm bằng chứng thực nghiệm bổ sung
- **3.9. Vị trí của CĐ2 và CĐ3 trong luận án**
- **3.10. Kết luận Chuyên đề 1**

---

## 4. Những điều bắt buộc phải sửa so với bản thảo cũ

| Lỗi ở bản cũ | Yêu cầu ở bản mới |
|---|---|
| Trình bày 1 chương, mục 1.1–1.10 | Tách vật lý thành 3 chương như mục 3 |
| Để ngỏ "chọn một thuật toán nền phù hợp từ danh mục như MPA/SFOA" | Chốt dứt khoát SFOA, có luận cứ (mục 3.8) |
| Dùng tên "MOSFOAP" | Dùng đúng "MOSFOA" (B-MOSFOA/E-MOSFOA) |
| Không có mục đối chứng thực nghiệm | Thêm mục 2.9 (Track B) |
| Không trình bày kết quả gì thuộc CĐ2/CĐ3 | Giữ nguyên — CĐ1 chỉ dừng ở "yêu cầu/đặc tả cho MOSFOA", không được có bất kỳ số liệu benchmark hay BD/MD/MJP nào |

---

## 5. Mục 2.9 — Đối chứng thực nghiệm SOO/MOO từ Track B (dàn ý chi tiết)

Mục này KHÔNG lặp lại benchmark IMOP/UF/RM-MEDA (đó thuộc CĐ2). Nó dùng
kết quả **của chính NCS** trên các kết cấu cảng biển KHÁC để minh chứng
cho luận điểm "cần một thuật toán chuyên biệt hơn cho lớp bài toán kết
cấu cảng" — nói cách khác, đây là dữ liệu thực nghiệm hỗ trợ GAP 2/GAP 3.

| Công bố | Đối tượng | Thuật toán | Nhận định rút ra cho CĐ1 |
|---|---|---|---|
| #1 *Efficient Design of Single Mooring Buoy Lines: A MOMSA-Based Approach* (SHM&ES 2025, LNCE 747) | Dây neo phao đơn | MOMSA | MOMSA giải được nhưng không có cơ chế chuyên biệt hóa cho ràng buộc cọc–bệ |
| #2 *On Optimization of Gravity Retaining Wall...* (VSOE 2024, LNCE 590) | Tường chắn trọng lực | Thuật toán SOO | Minh chứng thêm dạng bài toán tối ưu theo tiêu chuẩn khác, cùng logic ràng buộc code-based |
| #5 *Multi-objective optimization of I-section steel frames under TCVN 5575:2024...* (ICERA 2026) | Khung thép nhà điều hành cảng | So sánh nhiều metaheuristic | Minh chứng khung đánh giá thuật toán (2.1–2.4) áp dụng được trên hệ tiêu chuẩn khác (thép, TCVN 5575:2024) |

**Cách viết**: với mỗi công bố — 1 đoạn mô tả bài toán, 1 đoạn tóm tắt
phát hiện chính, 1 câu kết nối rõ ràng với luận điểm của CĐ1 (không sa
vào trình bày lại phương pháp/kết quả chi tiết của các bài này).

---

## 6. Cơ chế SFOA — dữ liệu tham chiếu để viết mục 1.6/3.8 (trích từ bài báo Q3, khỏi cần đọc lại)

**SFOA (Starfish Optimization Algorithm)** — nguyên bản là thuật toán
đơn mục tiêu, mô phỏng hành vi tìm kiếm của sao biển, gồm các cơ chế
chính (theo đúng bài báo Q3, mục 2.2):

- **Exploration**: dùng "arm-twist rule" (cập nhật nhiều chiều) và
  "energy-step rule" (cập nhật ít chiều), điều khiển bởi tham số xác
  suất $GP$ (exploration probability).
- **Exploitation**: dùng "preying rule" để cập nhật vị trí ứng viên.
- **Regeneration**: áp dụng cho cá thể cuối cùng (kém nhất) để làm mới
  quần thể.

**Hạn chế của SFOA khi mở rộng sang MOO** (đây chính là luận cứ cho mục
1.7 và 3.7/3.8):
1. Chỉ có một giá trị fitness — không xử lý được vector mục tiêu;
2. Không có external archive lưu nghiệm không bị trội;
3. Không có cơ chế duy trì đa dạng (grid/crowding) trên mặt Pareto;
4. Không có leader selection từ archive (SFOA gốc chỉ có "global best"
   đơn mục tiêu);
5. Không thiết kế sẵn cho biến rời rạc và ràng buộc theo tiêu chuẩn kỹ
   thuật (cost–displacement với ràng buộc kết cấu cảng biển).

**Yêu cầu đặc tả cho MOSFOA (kết luận mục 3.7, dẫn thẳng sang CĐ2)**:
(1) Pareto dominance; (2) external archive; (3) adaptive
grid/crowding-distance để duy trì đa dạng; (4) archive-based leader
selection; (5) cơ chế xử lý ràng buộc theo mức vi phạm; (6) khả năng xử
lý biến rời rạc.

---

## 7. Những gì không nên làm (áp dụng riêng cho CĐ1)

- Không lặp lại toàn bộ lý thuyết MOO một cách dàn trải không có trọng
  tâm — mọi mục lý thuyết phải dẫn tới yêu cầu đặc tả MOSFOA ở cuối
  Chương 3.
- Không trình bày bất kỳ kết quả benchmark (IMOP/UF/RM-MEDA cho MOSFOA)
  hay kết quả kỹ thuật (BD/MD/MJP) nào — thuộc CĐ2/CĐ3.
- Không để mục 2.9 (Track B) lấn át nội dung chính — tối đa 3-4 trang.
- Không dùng lại tên "MOSFOAP" hay để ngỏ lựa chọn thuật toán nền.

---

## 8. Checklist tự kiểm tra trước khi hoàn thành bản thảo

- [ ] Không quá 80 trang, không kể phụ lục.
- [ ] **Đủ 03 chương, tách vật lý** — không còn dạng "mục 1.1–1.10".
- [ ] Chốt SFOA làm nền tảng ngay từ Chương 1/kết luận ở Chương 3, có
      luận cứ dựa trên hạn chế cụ thể (mục 6).
- [ ] Có mục 2.9 đối chứng SOO/MOO bằng Track B (mục 5).
- [ ] Không trình bày kết quả MOSFOA/benchmark/BD-MD-MJP.
- [ ] Kết thúc bằng đặc tả yêu cầu cho MOSFOA (mục 3.7).
- [ ] Có Mở đầu, Kết luận (bàn luận) và kiến nghị, Tài liệu tham khảo.
- [ ] Nội dung chủ yếu là "kết quả nghiên cứu của chuyên đề" (mô hình
      hóa, khung đánh giá, đối chứng thực nghiệm) — không phải một bài
      tổng quan tài liệu thuần túy.

---

## 9. Nguồn tham chiếu (chỉ cần khi cần tra cứu sâu hơn)

- `CHUYEN DE 1 HOAN CHINH.docx` — bản cũ, dùng để lấy lại phần trình bày
  chi tiết công thức ràng buộc BTCT/địa kỹ thuật (mục 1.7 cũ) nếu cần
  tham khảo cách diễn đạt, nhưng phải viết lại theo cấu trúc 3 chương ở
  đây.
- `02_MOSFOA__VN.docx` — bài báo Q3 gốc, dùng nếu cần trích dẫn chính
  xác công thức/mô tả SFOA (mục Methodology, phần 2.1–2.2) ngoài phần
  đã tóm tắt ở mục 6.
- `De_cuong_4_san_pham_xuyen_suot_luan_an_MOSFOA.md` — đề cương tổng thể
  đã chốt (Phần G là nguồn gốc của file này).
