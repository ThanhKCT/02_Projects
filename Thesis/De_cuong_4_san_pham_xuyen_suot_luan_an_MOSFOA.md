# ĐỀ CƯƠNG 04 SẢN PHẨM XUYÊN SUỐT LUẬN ÁN
## Rà soát Chuyên đề Tổng quan – Chuyên đề 1 và xây dựng lại Chuyên đề 2 – 3
### (Bản v2 — rà soát với vai trò Người hướng dẫn khoa học / Phản biện luận án)

**Đề tài luận án giữ nguyên:**

> **NGHIÊN CỨU PHÁT TRIỂN THUẬT TOÁN TỐI ƯU METAHEURISTIC CHO KẾT CẤU HẠ TẦNG CẢNG BIỂN**

---

# PHẦN A — NHẬN XÉT CỦA NGƯỜI HƯỚNG DẪN/PHẢN BIỆN

## A.1. Đánh giá bản đề cương trước rà soát

Bản đề cương v1 đã làm đúng việc quan trọng nhất: nhận ra bài báo MOSFOA
(Q3) không nên bị lặp lại nguyên trạng ở hai chuyên đề, mà phải được
**tách theo bản chất đóng góp** — thuật toán (CĐ2) và ứng dụng (CĐ3).
Đây là quyết định đúng và nên giữ.

Tuy nhiên, ở vai trò người sẽ ngồi hội đồng chấm, tôi nhìn thấy **bốn lỗ
hổng** sẽ bị hỏi ngay trong buổi bảo vệ nếu không xử lý trước:

1. **Chưa có chiến lược đầu ra công bố.** Đề cương v1 coi bài báo MOSFOA
   là sản phẩm khoa học duy nhất. Trong khi đó, NCS cho biết sẽ có thêm
   một số bài báo trong nước áp dụng các thuật toán SOO/MOO khác nhau
   cho kết cấu cảng biển, dùng để so sánh thuật toán và **đảm bảo đầu
   ra tốt nghiệp**. Đề cương phải xác định rõ các bài báo này đóng vai
   trò gì, nằm ở đâu trong luận án, tránh trở thành các bài "rời rạc"
   bị hội đồng đánh giá là không có tính hệ thống.
2. **Lập luận "tách 1 bài báo thành 2 chuyên đề" chưa đủ chặt.** Hội
   đồng chắc chắn sẽ hỏi: nếu CĐ2 và CĐ3 chỉ là hai nửa của cùng một bài
   báo đã công bố, thì "kết quả nghiên cứu của chuyên đề" (yêu cầu bắt
   buộc theo quy chế) nằm ở đâu? Cần một quy tắc **giá trị gia tăng**
   (value-added) rõ ràng cho từng chuyên đề so với bài báo gốc.
3. **Tiểu luận Tổng quan chưa khai thác mục bắt buộc "khả năng tiếp cận
   của nghiên cứu sinh".** Đây chính là chỗ tự nhiên nhất để đưa các bài
   báo trong nước đã công bố vào — chứng minh NCS đã có quá trình tích
   lũy trước khi đề xuất MOSFOA, thay vì MOSFOA xuất hiện đột ngột.
4. **Chưa có một phát biểu đóng góp khoa học (contribution statement)
   tổng hợp**, độc lập với nội dung bài báo, để dùng thống nhất trong
   Mở đầu luận án, Tóm tắt luận án và phần trả lời bảo vệ.

Bản v2 này xử lý cả bốn điểm trên, đồng thời giữ lại toàn bộ phần khung
xuyên suốt (logic 4 sản phẩm, cấu trúc chương, bảng phân bổ) vì phần đó
đã đúng hướng.

## A.2. Thay đổi chính so với bản v1

| Thay đổi | Lý do |
|---|---|
| Thêm **Phần C — Chiến lược công bố khoa học và đầu ra** | Xử lý lỗ hổng (1): định vị vai trò các bài báo trong nước |
| Thêm **Phần D — Đóng góp khoa học mới của luận án** | Xử lý lỗ hổng (4): một phát biểu đóng góp dùng xuyên suốt |
| Bổ sung nguyên tắc **"giá trị gia tăng"** vào B.1, G, H | Xử lý lỗ hổng (2): mỗi CĐ phải vượt khỏi nội dung bài báo |
| Bổ sung mục **"khả năng tiếp cận của NCS"** vào Tổng quan (Phần F) | Xử lý lỗ hổng (3): dùng track công bố trong nước làm minh chứng |
| Đổi khung xử lý Tổng quan/CĐ1 từ "cập nhật, không viết lại" sang **"viết lại hoàn toàn"** | Theo chỉ đạo mới của NCS: hai tài liệu cũ (viết trước khi có bài báo MOSFOA) được phép xóa và viết lại toàn bộ, không bị ràng buộc bởi cấu trúc cũ |
| Mở rộng bảng phân bổ, ma trận câu hỏi, checklist để gồm cả track công bố trong nước | Đảm bảo tính xuyên suốt định lượng, không chỉ định tính |

---

# PHẦN B — KẾT LUẬN ĐỊNH HƯỚNG TRƯỚC KHI KHÓA ĐỀ CƯƠNG

## B.1. Có thể tách bài báo MOSFOA thành Chuyên đề 2 và Chuyên đề 3 không?

**Có. Và đây là phương án nên chọn — với một điều kiện bắt buộc.**

Không tách cơ học bài báo thành hai nửa. Bài báo hiện tại là một sản
phẩm nghiên cứu tích hợp gồm:

1. Phát triển B-MOSFOA;
2. Phát triển E-MOSFOA;
3. Kiểm chứng trên IMOP, UF và RM-MEDA;
4. Phân tích độ nhạy tham số;
5. Tích hợp MATLAB–SAP2000;
6. Ứng dụng cho BD, MD và MJP;
7. Phân tích Pareto cost–displacement;
8. Kiểm tra tính khả thi theo cường độ, địa kỹ thuật và hình học;
9. Phân tích ý nghĩa kỹ thuật và giới hạn nghiên cứu.

Cách tách phù hợp với quy chế và logic luận án:

```text
BÀI BÁO MOSFOA (Q3 — sản phẩm khoa học lõi)
       |
       +----------------------------+
       |                            |
       v                            v
CHUYÊN ĐỀ 2                    CHUYÊN ĐỀ 3
Phát triển thuật toán         Ứng dụng + kiểm chứng
và kiểm chứng thuật toán     trong kết cấu cảng biển
       |                            |
       v                            v
B-MOSFOA/E-MOSFOA             MATLAB–SAP2000
Benchmark                     BD – MD – MJP
Sensitivity                   Pareto cost–displacement
Statistical validation        Feasibility/code checks
       |                            |
       +-------------+--------------+
                     |
                     v
                LUẬN ÁN TIẾN SĨ
```

### Điều kiện bắt buộc: quy tắc "giá trị gia tăng" (value-added rule)

Quy chế yêu cầu mỗi chuyên đề phải "trình bày chủ yếu **kết quả nghiên
cứu** của chuyên đề" — không phải trình bày lại một công bố đã có. Do
đó, **CĐ2 và CĐ3 không được phép là bản dịch/diễn giải lại bài báo**.
Mỗi chuyên đề phải bổ sung ít nhất một trong các lớp giá trị sau, vượt
ra ngoài nội dung đã công bố:

- **Mở rộng lý thuyết**: trình bày đầy đủ cơ sở toán học, lập luận từng
  bước cho mỗi cơ chế (điều mà một bài báo tạp chí luôn phải nén lại do
  giới hạn số trang);
- **Mở rộng đối chứng**: đưa thêm các thuật toán SOO/MOO từ chính các
  bài báo trong nước của NCS (xem Phần C) làm đối chứng bổ sung, ngoài
  MOMSA/NS-MFO/MOGNDO đã có trong bài báo Q3;
- **Mở rộng phân tích**: thảo luận sâu hơn về từng bảng kết quả, thêm
  góc nhìn thiết kế kỹ thuật (ví dụ discussion về ý nghĩa của utilization
  ratio đối với kỹ sư thiết kế thực tế) mà bài báo không có chỗ để khai
  triển;
- **Mở rộng phạm vi**: liên hệ kết quả với các hạng mục kết cấu cảng
  khác (tường chắn, dây neo phao...) đã được NCS thử nghiệm ở các công
  bố trong nước, để bàn về tính tổng quát của phương pháp.

Không cần làm cả bốn — nhưng mỗi chuyên đề phải có ít nhất **hai lớp**
để hội đồng nhìn thấy rõ "đây là chuyên đề nghiên cứu, không phải bản
sao bài báo".

## B.2. Vì sao cách tách này tốt hơn?

Quy chế yêu cầu mỗi Chuyên đề:

- cập nhật kiến thức mới liên quan trực tiếp đến đề tài;
- giúp nghiên cứu sinh giải quyết một số nội dung của luận án;
- nội dung được chia thành **03 chương**;
- trình bày **chủ yếu kết quả nghiên cứu của chính chuyên đề**.

Do đó, Chuyên đề 2 phải tạo ra **đóng góp thuật toán**, còn Chuyên đề 3
phải tạo ra **đóng góp ứng dụng và kiểm chứng kỹ thuật**.

Quy chế quy định rõ ba Chuyên đề tiến sĩ là các sản phẩm nghiên cứu phục
vụ trực tiếp luận án và mỗi chuyên đề có nội dung chia thành 3 chương;
độ dài không quá 80 trang, không kể phụ lục — xem chi tiết đầy đủ trong
[`Quy_che_Tieu_luan_Tong_quan_va_Chuyen_de_Tien_si.md`](Quy_che_Tieu_luan_Tong_quan_va_Chuyen_de_Tien_si.md),
tổng hợp từ `1796-Quy che dao tao.pdf`, Phụ lục 02.

## B.3. Vai trò của các bài báo trong nước (SOO/MOO ứng dụng khác)

NCS đã và sẽ có một số bài báo đăng tạp chí trong nước, áp dụng các
thuật toán tối ưu đơn mục tiêu (SOO) và đa mục tiêu (MOO) — không nhất
thiết là SFOA/MOSFOA — cho các hạng mục kết cấu cảng biển khác nhau
(ví dụ: tường chắn trọng lực, dây neo phao đơn...), nhằm áp dụng và so
sánh thuật toán. Đây là điểm mới quan trọng cần khóa dứt khoát ngay từ
đề cương, để tránh hai rủi ro đối lập:

- **Rủi ro 1 — bỏ quên**: nếu không nhắc đến, hội đồng có thể hỏi "các
  công bố khác của NCS liên quan gì đến luận án?" và câu trả lời không
  có cấu trúc.
- **Rủi ro 2 — lạm dụng**: nếu đưa các bài báo này vào làm "kết quả
  chính" của một chuyên đề, sẽ làm loãng câu chuyện MOSFOA và khiến
  luận án trông như tập hợp rời rạc thay vì một mạch nghiên cứu.

**Quyết định định hướng**: các bài báo trong nước được xếp vào **Track
B — track hỗ trợ và đầu ra**, tách biệt với **Track A — track lõi**
(bài báo MOSFOA Q3 → CĐ2/CĐ3). Track B có hai chức năng, cả hai đều hợp
lệ và không mâu thuẫn:

1. **Chức năng học thuật**: là bằng chứng cho mục bắt buộc "khả năng
   tiếp cận của nghiên cứu sinh đối với vấn đề nghiên cứu" trong Tiểu
   luận Tổng quan, và là dữ liệu đối chứng mở rộng trong Chương 2 của
   Chuyên đề 1 (so sánh SOO vs MOO trên kết cấu cảng biển thực tế, dùng
   chính kết quả của NCS thay vì chỉ trích dẫn tài liệu người khác).
2. **Chức năng hành chính**: đáp ứng điều kiện công bố khoa học bắt buộc
   trước khi luận án được đánh giá cấp đơn vị chuyên môn, theo **Điều 17**
   của quy chế đào tạo — xem chi tiết đầy đủ (đã đối chiếu) tại
   [`Quy_che_yeu_cau_Chuyen_de_Hoi_thao_Hoi_dong_Dau_ra_Tien_si.md`](Quy_che_yeu_cau_Chuyen_de_Hoi_thao_Hoi_dong_Dau_ra_Tien_si.md)
   mục 17–19, và bảng ánh xạ cụ thể ở C.2/C.3 bên dưới.

Chi tiết cách bố trí xem Phần C.

---

# PHẦN C — CHIẾN LƯỢC CÔNG BỐ KHOA HỌC VÀ ĐẦU RA

## C.1. Hai luồng sản phẩm khoa học

```text
                    ĐỀ TÀI LUẬN ÁN
                          |
        +-----------------+-----------------+
        |                                   |
        v                                   v
  TRACK A — LÕI                      TRACK B — HỖ TRỢ & ĐẦU RA
  Bài báo MOSFOA (Q3)                 Bài báo trong nước (SOO/MOO
  đã công bố                          áp dụng kết cấu cảng khác)
        |                                   |
        v                                   v
  CĐ2 + CĐ3                     Tổng quan (mục "khả năng tiếp cận")
  (nội dung chính                 + CĐ1 Chương 2 (đối chứng SOO/MOO)
   của luận án)                   + đáp ứng điều kiện đầu ra tốt nghiệp
        |                                   |
        +-----------------+-----------------+
                          |
                          v
                     LUẬN ÁN TIẾN SĨ
```

Nguyên tắc phân vai:

- **Track A quyết định câu chuyện khoa học của luận án** (research
  narrative): từ SFOA → hạn chế → B-MOSFOA/E-MOSFOA → benchmark →
  ứng dụng cảng biển thực tế.
- **Track B không kể một câu chuyện riêng.** Track B chỉ đóng vai trò
  minh chứng bổ sung cho câu chuyện của Track A ("NCS đã thử các thuật
  toán SOO/MOO khác trên các bài toán kết cấu cảng khác trước khi đi
  đến kết luận cần một thuật toán chuyên biệt hơn — đó là động lực dẫn
  đến MOSFOA") và đáp ứng yêu cầu đầu ra.

## C.2. Bảng ánh xạ công bố → cấu phần luận án (đã cập nhật với danh mục thực tế)

| # | Công bố | Loại | Vị trí tác giả (NCS) | Trạng thái | Vai trò trong luận án | Cờ rủi ro |
|---|---|---|---|---|---|---|
| 0 | **Bài báo MOSFOA** (Q3, ISI/Scopus) | Track A — lõi | Tác giả chính (Methodology/Software/Investigation) | Đã công bố | CĐ2 (thuật toán) + CĐ3 (ứng dụng) | Không |
| 1 | *Efficient Design of Single Mooring Buoy Lines: A MOMSA-Based Approach*, SHM&ES 2025, LNCE vol. 747, Springer Cham (2026) | Track B — Scopus (kỷ yếu HN quốc tế, LNCE) | **Tác giả thứ nhất** (Thanh Cuong-Le là tác giả liên hệ) | Đã chấp nhận | Tổng quan (khả năng tiếp cận) + CĐ1 §2.9 (đối chứng MOO trên dây neo phao) | Thấp |
| 2 | *On Optimization of Gravity Retaining Wall Considering the Dimension of the Stone Base*, VSOE 2024, LNCE 590, Springer Singapore (2025) | Track B — Scopus (kỷ yếu HN quốc tế, LNCE) | **Tác giả thứ hai** (Quoc Hoan Pham là tác giả thứ nhất/liên hệ) | Đã đăng | Tổng quan (khả năng tiếp cận) + CĐ1 §2.9 (đối chứng SOO trên tường chắn) | **Trung bình** — không phải tác giả chính, cần xác nhận có được tính vào Điều 17 |
| 3 | *(Dự kiến)* Tạp chí Xây dựng — "Nghiên cứu ứng dụng thuật toán SFOA cho tối ưu đơn mục tiêu kết cấu công trình biển" | Track B — tạp chí trong nước | **Tác giả thứ nhất** (đã xác nhận) | Dự kiến | Tổng quan (khả năng tiếp cận) + **CĐ1 §3.8 "Định hướng MOSFOA"** (bằng chứng thực nghiệm SOO trực tiếp cho luận điểm chọn SFOA làm nền tảng) | Thấp, nhưng **cơ hội cao** — nên khai thác mạnh ở CĐ1 vì đây là tiền đề trực tiếp nhất cho SFOA |
| 4 | *(Dự kiến)* Tạp chí Khoa học Công nghệ Hàng hải (JMST) — "Nghiên cứu ứng dụng thuật toán MOSFOA cho tối ưu đa mục tiêu kết cấu công trình bến cảng" — **dùng cho công trình bến bệ cọc cao ở một dự án khác Hải Linh** | Track B — tạp chí trong nước | **Tác giả thứ nhất** (đã xác nhận) | Dự kiến | CĐ1 §2.9 (đối chứng) + **CĐ3 §3.9.x nâng cấp thành bằng chứng tổng quát hóa chính thức** (dự án độc lập, không trùng BD/MD/MJP) | **Đã đóng, thấp** — case study khác dự án Hải Linh nên không còn rủi ro trùng lặp nội dung; xem cảnh báo (i) đã đóng dưới |
| 5 | *(Dự kiến)* ICERA 2026 — "Multi-objective optimization of I-section steel frames under TCVN 5575:2024: A comparative study of metaheuristic algorithms" — đối tượng là khung thép nhà điều hành cảng | Track B — Scopus (kỷ yếu HN quốc tế, LNCE) | **Tác giả thứ nhất** (đã xác nhận) | Dự kiến | Tổng quan (khả năng tiếp cận, mở rộng phạm vi) + CĐ1 §2.9 (minh chứng code-based MOO trên chuẩn thép TCVN 5575:2024, khác hệ chuẩn bê tông/cọc TCVN 7888, 10304 của luận án) | **Đã đóng, thấp** — nhà điều hành cảng thuộc nhóm "hậu phương/hạ tầng kỹ thuật" của kết cấu hạ tầng cảng biển, phù hợp phạm vi đề tài — xem cảnh báo (ii) đã đóng dưới |
| ~~6~~ | ~~ICERA 2026 — "Multi-objective Design Optimization of Offshore High-Pile Concrete Wharf Structures..."~~ | — | — | **Đã hủy, không nộp** (quyết định của NCS) | Không còn thuộc Track B | Đã đóng — xem cảnh báo (iii) đã đóng dưới |

> **Ghi chú thao tác**: bảng này là "sổ theo dõi công bố" sống, cập nhật
> mỗi khi có bài báo mới được chấp nhận đăng hoặc đổi tình trạng.

### Ba cảnh báo — đã xử lý theo xác nhận của NCS

**(i) Bài #4 (JMST) — ĐÃ ĐÓNG.** NCS xác nhận case study là **một dự án
bến bệ cọc cao khác, không phải Hải Linh** (dự án dùng trong bài Q3 và
CĐ3). Vì dữ liệu độc lập, không còn rủi ro trùng lặp nội dung/tự đạo
văn. Ngược lại, đây trở thành một tài sản có giá trị: một trường hợp
kiểm chứng MOSFOA thứ hai, hoàn toàn độc lập với BD/MD/MJP. **Khuyến
nghị nâng cấp vai trò trong CĐ3**: thay vì chỉ "thảo luận tổng quát
hóa" ở mục 3.9.x, nếu quy mô đủ (đủ dữ liệu, đủ so sánh B-MOSFOA/
E-MOSFOA), nên đưa thành **một mục kết quả bổ sung riêng** trong CĐ3
Chương 3 (ví dụ 3.4.x "Kiểm chứng bổ sung trên dự án độc lập"), làm tăng
đáng kể sức thuyết phục của luận án về tính tổng quát của MOSFOA —
tăng giá trị gia tăng theo đúng nguyên tắc B.1.

**(ii) Bài #5 (I-section steel frames) — ĐÃ ĐÓNG.** NCS xác nhận đối
tượng là khung thép của **nhà điều hành cảng** — đây thuộc nhóm kết cấu
"hậu phương/hạ tầng kỹ thuật" trong phân loại kết cấu hạ tầng cảng biển
(đã có sẵn trong khảo sát Tổng quan cũ), nên **thỏa điều kiện "liên
quan trực tiếp đến đề tài luận án"** của Điều 17. Giá trị gia tăng: bài
này minh chứng phương pháp code-based MOO của luận án áp dụng được trên
một hệ tiêu chuẩn khác (TCVN 5575:2024 — kết cấu thép) ngoài hệ tiêu
chuẩn bê tông/cọc chính (TCVN 7888:2014, TCVN 10304:2014), củng cố luận
điểm tổng quát hóa ở CĐ1 §2.9.

**(iii) Bài #6 (Offshore high-pile concrete wharf) — ĐÃ ĐÓNG.** NCS đã
quyết định **hủy, không nộp bài này**. Rủi ro trùng lặp nội dung với
bài báo Q3/CĐ3 (cùng đối tượng bến cọc cao, cùng mục tiêu so sánh
metaheuristic đa mục tiêu) theo đó không còn tồn tại. Đã loại khỏi bảng
C.2 và không tính vào Track B.

## C.3. Yêu cầu đầu ra theo quy chế (Điều 17/18, Phụ lục 12 — đã đối chiếu)

Theo `Quy_che_yeu_cau_Chuyen_de_Hoi_thao_Hoi_dong_Dau_ra_Tien_si.md`
mục 17–19, điều kiện công bố khoa học **bắt buộc** trước khi luận án
được đánh giá tại đơn vị chuyên môn gồm:

1. NCS phải là **tác giả chính** của báo cáo hội nghị/bài báo khoa học;
2. Công bố thuộc một trong bốn loại: (a) WoS/Scopus; (b) chương sách
   quốc tế uy tín; (c) tạp chí trong nước thuộc khung điểm HĐGSNN từ
   **0,75 điểm trở lên theo ngành**; (d) sách chuyên khảo uy tín;
3. **Tổng điểm công bố ≥ 2,0 điểm** theo khung điểm HĐGSNN (không chia
   điểm khi có đồng tác giả);
4. Công bố phải **liên quan** và **đóng góp quan trọng** cho kết quả
   luận án (Điều 17); nội dung chủ yếu của luận án còn phải được công bố
   theo yêu cầu riêng của Phụ lục 12.

### Áp dụng cho danh mục hiện tại (đã cập nhật: ngành xét HĐGSNN = Giao thông vận tải; các bài dự kiến NCS đứng tác giả thứ nhất)

| Công bố | Vị trí tác giả | Đạt "tác giả chính"? | Đóng góp điểm? |
|---|---|---|---|
| Bài báo MOSFOA (Q3) | Thứ nhất | ✓ | Có — mức điểm cụ thể phụ thuộc xếp hạng Scopus/quartile của tạp chí, cần tra khung điểm HĐGSNN **ngành Giao thông vận tải** hiện hành |
| #1 Mooring buoy (MOMSA) | Thứ nhất | ✓ | Có, mức điểm theo loại "kỷ yếu HN quốc tế có phản biện, Scopus" |
| #2 Gravity retaining wall | **Tác giả tham gia** (đã xác nhận, không phải tác giả chính) | ✗ | **Không tính vào tổng điểm Điều 17** — nhưng không ảnh hưởng vì ngưỡng 2,0 đã đạt qua các công bố khác; bài #2 vẫn dùng tốt cho Track B học thuật (Tổng quan/CĐ1 §2.9), vì trích dẫn học thuật không đòi hỏi vị trí tác giả chính |
| #3 (Tạp chí Xây dựng, SFOA-SOO) | **Thứ nhất** (đã xác nhận) | ✓ | Có |
| #4 (JMST, MOSFOA-MOO, dự án khác) | **Thứ nhất** (đã xác nhận) | ✓ | Có |
| #5 (ICERA, khung thép nhà điều hành cảng) | **Thứ nhất** (đã xác nhận) | ✓ | Có, mức điểm theo loại "kỷ yếu HN quốc tế có phản biện, Scopus" |
| ~~#6~~ | — | — | Đã hủy, không nộp |

**Trạng thái: ĐÃ KHÓA.** NCS xác nhận (1) chắc chắn đạt ngưỡng tổng điểm
≥ 2,0 và (2) bài #2 là **tác giả tham gia** (không phải tác giả chính,
do đó không tính vào tổng điểm Điều 17 — nhưng không ảnh hưởng vì ngưỡng
đã đạt qua các công bố còn lại, tất cả đều đứng tên tác giả thứ nhất).
Cả hai hạng mục mở của C.3, cùng ba cảnh báo trùng lặp/phạm vi (i)/(ii)/
(iii) ở C.2, nay đều đã đóng. Track B coi như khóa xong, trừ một hạng
mục mới phát sinh — xem C.4.

## C.4. Bài báo #7 (mới đề xuất) — thuần Track B, không sửa nội dung chuyên đề

**Đính chính của NCS**: bài báo #7 (dùng MOSFOA đã phát triển, theo
hướng tối ưu theo độ tin cậy **hoặc** MCDM dựa trên tập Pareto) chỉ là
một công bố khoa học **bổ sung phục vụ đầu ra** — giống vai trò của #1,
#2, #3, #5 — **không được đưa vào nội dung CĐ2/CĐ3**. Khung chương của
CĐ2/CĐ3 ở Phần H/I giữ nguyên như đã khóa, không chỉnh sửa vì bài này.

| # | Công bố | Loại | Vai trò | Vị trí tác giả |
|---|---|---|---|---|
| 7 | *(Dự kiến)* Bài dùng MOSFOA — hướng (A) tối ưu theo độ tin cậy **hoặc** (B) MCDM dựa trên Pareto (chọn 1 trong 2 khi triển khai) | Track B — đầu ra | Đầu ra bổ sung; không nằm trong nội dung bắt buộc của bất kỳ chuyên đề nào | Dự kiến tác giả thứ nhất |

Ghi chú ngắn (chỉ để NCS cân nhắc khi chọn hướng viết, không ràng buộc
nội dung luận án): phương án MCDM ít rủi ro trùng phạm vi hơn phương án
độ tin cậy, vì CĐ1 đã khóa cách tiếp cận tất định (code-based); nhưng
đây thuần là lựa chọn của NCS cho một bài báo Track B, không ảnh hưởng
đề cương các chuyên đề.

---

# PHẦN D — ĐÓNG GÓP KHOA HỌC MỚI CỦA LUẬN ÁN

Đây là đoạn NCS nên thuộc lòng và dùng nhất quán trong Mở đầu luận án,
Tóm tắt luận án, và phần trả lời hội đồng. Đóng góp được phát biểu ở
**4 tầng**, mỗi tầng ứng với một sản phẩm:

### Tầng 1 — Đóng góp phương pháp luận (CĐ1)
Xây dựng khung chuẩn hóa bài toán tối ưu đa mục tiêu **theo đúng tiêu
chuẩn thiết kế** (code-based) cho kết cấu cảng biển dạng cọc–bệ, làm cơ
sở yêu cầu kỹ thuật cho một thuật toán SI-MOO mới — thay vì áp dụng một
thuật toán MOO tổng quát không tính đến đặc thù ràng buộc ngành.

### Tầng 2 — Đóng góp thuật toán (CĐ2)
Đề xuất **B-MOSFOA** và **E-MOSFOA** — hai biến thể đa mục tiêu của
SFOA, với cơ chế archive-grid, leader selection, và (ở E-MOSFOA) LHS +
cosine-phase control + DE mutation + Gaussian refinement — được kiểm
chứng thống kê nghiêm ngặt (Wilcoxon-Holm, 30 lần lặp độc lập) trên 26
bài toán chuẩn, cho kết quả **cạnh tranh nhưng không tuyên bố vượt trội
tuyệt đối** so với MOMSA/NS-MFO/MOGNDO.

### Tầng 3 — Đóng góp kỹ thuật/ứng dụng (CĐ3)
Xây dựng quy trình tích hợp **MATLAB–SAP2000** vận hành được trên bài
toán kỹ thuật thực (dữ liệu dự án Hải Linh), tạo ra các tập Pareto
cost–displacement khả thi 100% theo tiêu chuẩn (TCVN 7888:2014, TCVN
10304:2014) cho ba hệ kết cấu BD/MD/MJP, có so sánh định lượng với
thiết kế hiện trạng.

### Tầng 4 — Đóng góp thực nghiệm mở rộng (Track B — bài báo trong nước)
Cung cấp bằng chứng thực nghiệm bổ sung, độc lập với bài báo lõi, về
việc **các thuật toán SOO/MOO khác nhau ứng xử ra sao trên các hạng mục
kết cấu cảng biển khác** (tường chắn, dây neo phao...) — củng cố lập
luận research-gap ở CĐ1/Tổng quan và cho thấy tính hệ thống trong toàn
bộ quá trình nghiên cứu của NCS, không chỉ dừng ở một bài báo đơn lẻ.

**Câu phát biểu đóng góp tổng hợp (dùng trong Mở đầu luận án):**

> *"Luận án đóng góp một khung phương pháp luận tối ưu đa mục tiêu theo
> tiêu chuẩn cho kết cấu cảng biển (CĐ1), phát triển và kiểm chứng thống
> kê hai thuật toán SI-MOO mới B-MOSFOA/E-MOSFOA (CĐ2), và chứng minh
> giá trị kỹ thuật của phương pháp thông qua một quy trình tích hợp
> MATLAB–SAP2000 áp dụng cho ba hệ kết cấu cảng biển thực tế (CĐ3), được
> củng cố bởi các nghiên cứu ứng dụng thuật toán tối ưu bổ sung trên các
> hạng mục kết cấu cảng khác."*

---

# PHẦN E — LOGIC XUYÊN SUỐT CỦA 04 SẢN PHẨM (+ TRACK B)

Từ nay không xem bốn tài liệu là bốn bài độc lập, và không xem các bài
báo trong nước là các phụ lục rời rạc.

```text
SẢN PHẨM 1
TIỂU LUẬN TỔNG QUAN
        |
        |  Tại sao phải nghiên cứu?           Track B minh chứng
        |  Khoảng trống ở đâu?          <----- "khả năng tiếp cận":
        |  Cần giải quyết vấn đề gì?           NCS đã thử SOO/MOO
        |  Vì sao cần phát triển thuật toán?   khác trước MOSFOA
        v
SẢN PHẨM 2
CHUYÊN ĐỀ TIẾN SĨ 1
        |
        |  Cơ sở khoa học là gì?               Track B làm đối chứng
        |  Bài toán được mô hình hóa thế nào?  mở rộng SOO vs MOO
        |  Tiêu chí đánh giá thuật toán là gì? <-----
        |  Cấu trúc bài toán cảng biển có gì đặc thù?
        v
SẢN PHẨM 3
CHUYÊN ĐỀ TIẾN SĨ 2
        |
        |  Phát triển thuật toán MOSFOA như thế nào?
        |  Vì sao các cải tiến là cần thiết?
        |  Thuật toán có thực sự tốt hơn/khả cạnh tranh?
        v
SẢN PHẨM 4
CHUYÊN ĐỀ TIẾN SĨ 3
        |
        |  Thuật toán có giải được bài toán kết cấu cảng?
        |  Có tạo được Pareto khả thi?
        |  Có ý nghĩa thiết kế?
        |  Có thể tích hợp thành quy trình?
        |  Có tổng quát hóa được không?        Track B thảo luận
        v                                <----- mở rộng ở đây
LUẬN ÁN TIẾN SĨ
```

---

# PHẦN F — RÀ SOÁT VÀ VIẾT LẠI TIỂU LUẬN TỔNG QUAN

## F.1. Định vị vai trò mới

Vì Tổng quan hiện tại được viết **trước khi có bài báo MOSFOA**, và NCS
đã xác nhận cho phép **xóa/viết lại hoàn toàn**, Tổng quan không còn là
một bản "cập nhật" mà là một **tài liệu mới**, dùng lại những phần khảo
sát còn giá trị (tổng quan MOO, tổng quan hạ tầng cảng biển, khảo sát
quốc tế/trong nước) nhưng tổ chức lại toàn bộ mạch lập luận để dẫn thẳng
tới MOSFOA và Track B, theo đúng logic quy chế:

```text
Bài toán tối ưu kết cấu
        ↓
Tối ưu dựa trên metaheuristic (SI-MOO)
        ↓
Khảo sát các thuật toán liên quan (bao gồm chính kinh nghiệm
của NCS qua các bài báo trong nước — Track B)
        ↓
SFOA — vì sao chọn SFOA làm nền tảng
        ↓
Hạn chế của SFOA đơn mục tiêu khi mở rộng sang MOO
        ↓
RESEARCH GAP (4 khoảng trống, xem F.3)
        ↓
Vấn đề khoa học cần giải quyết
        ↓
Mục tiêu luận án (chi phí – chuyển vị, đối tượng BD/MD/MJP)
        ↓
Thiết kế sơ bộ 03 chuyên đề tiến sĩ
        ↓
Luận án
```

## F.2. Khung nội dung bắt buộc (theo quy chế, Phụ lục 02, tr.29)

Bản viết lại **phải** có đủ, không thiếu mục nào:

**Mở đầu**: (1) tổng quan vấn đề nghiên cứu; (2) tính cần thiết; (3)
phân tích/đánh giá công trình trong và ngoài nước; (4) vấn đề còn tồn
tại; (5) vấn đề luận án cần giải quyết; **(6) khả năng tiếp cận của
NCS — đây là mục nên khai thác Track B**; (7) mục đích nghiên cứu; (8)
đối tượng và phạm vi; (9) nội dung nghiên cứu; (10) phương pháp nghiên
cứu; (11) ý nghĩa khoa học và thực tiễn.

**Nội dung**: cơ sở lý thuyết, giải pháp công nghệ, **thiết kế sơ bộ tên
và nội dung chính của 03 chuyên đề** (bắt buộc).

**Kết luận và kiến nghị**: dự kiến kết quả luận án, hạn chế, vấn đề cần
tiếp tục nghiên cứu, kiến nghị.

Độ dài khoảng 30 trang (xem quy cách trình bày đầy đủ trong file quy
chế).

## F.3. Dàn ý đề xuất cho bản viết lại

### Giữ và tổ chức lại (không cần khảo sát lại từ đầu, nhưng viết lại câu chữ để dẫn thẳng tới MOSFOA)

- Tổng quan tối ưu kết cấu; tổng quan MOO; tổng quan hạ tầng cảng biển;
  nghiên cứu quốc tế; nghiên cứu trong nước; code-based optimization;
  biến rời rạc; FEM/SSI.

### Viết mới hoàn toàn

- **SFOA và khoảng trống khi mở rộng sang đa mục tiêu** — đoạn riêng,
  nêu rõ: SFOA vốn đơn mục tiêu → chưa có Pareto archive → chưa có cơ
  chế duy trì đa dạng → chưa có leader selection từ archive → chưa thiết
  kế cho bài toán cost–displacement có ràng buộc kết cấu cảng → cần phát
  triển MOSFOA.
- **Mục "khả năng tiếp cận của nghiên cứu sinh"** — trình bày ngắn gọn
  các bài báo trong nước (Track B) đã thực hiện, như bằng chứng quá
  trình tích lũy dẫn đến đề xuất MOSFOA. Ví dụ mạch viết:
  > *"Trước khi đề xuất MOSFOA, NCS đã áp dụng và đối chứng một số thuật
  > toán tối ưu đơn/đa mục tiêu (MOMSA, ...) trên các bài toán kết cấu
  > cảng biển khác (dây neo phao, tường chắn trọng lực...) [trích dẫn
  > Track B]. Kết quả cho thấy [nhận định ngắn gọn về hạn chế quan sát
  > được], từ đó hình thành động lực phát triển một thuật toán SI-MOO
  > chuyên biệt hơn cho lớp bài toán kết cấu cảng biển."*
- **4 khoảng trống nghiên cứu** (giữ nguyên nội dung khung, chỉ viết lại
  câu chữ cho khớp Track B):
  ```text
  GAP 1: Bài toán kết cấu cảng chưa được chuẩn hóa đầy đủ theo code-based MOO
  GAP 2: SI-MOO hiện có (kể cả các thuật toán NCS đã thử ở Track B)
         chưa khai thác tốt cấu trúc bài toán kết cấu cảng
  GAP 3: SFOA chưa có cơ chế MOO phù hợp
  GAP 4: Chưa có cầu nối đầy đủ SFOA → MOO → FEM → SAP2000 → thiết kế cảng
  ```
- **Khóa tên sản phẩm nghiên cứu**: dùng nhất quán "MOSFOA – Multi-
  objective Starfish Optimization Algorithm", hai biến thể B-MOSFOA /
  E-MOSFOA. Không dùng lại tên "MOSFOAP" từng xuất hiện ở bản đề cương
  cũ.
- **Đối tượng trung tâm**: kết cấu bến cảng biển dạng cọc–bệ/bản công
  tác, đại diện bởi BD/MD/MJP; các đối tượng khác (tường cừ, trụ va, trụ
  neo, dây neo, đê chắn sóng — kể cả các đối tượng đã dùng ở Track B)
  chỉ là **khả năng mở rộng tương lai**, không phải phạm vi thực nghiệm
  bắt buộc.
- **Mục tiêu**: khóa "chi phí xây dựng – chuyển vị lớn nhất".
- **Thiết kế sơ bộ 3 chuyên đề** (bắt buộc theo quy chế) — dùng đúng tên
  đã chốt ở Phần K bên dưới.

---

# PHẦN G — RÀ SOÁT VÀ VIẾT LẠI CHUYÊN ĐỀ 1

## G.1. Định vị vai trò mới

Chuyên đề 1 bản cũ ("CHUYEN DE 1 HOAN CHINH") có nội dung khoa học tốt
nhưng có hai lỗi hình thức/nội dung nghiêm trọng cần sửa triệt để trong
bản viết lại:

1. **Toàn bộ trình bày dưới 1 chương** (mục 1.1–1.10) — vi phạm trực
   tiếp yêu cầu "chia thành 03 chương" của quy chế.
2. **Chưa chốt SFOA** — văn bản cũ để ngỏ lựa chọn giữa MPA/SFOA và dùng
   tên "MOSFOAP", không khớp với thuật toán đã công bố (SFOA →
   B-MOSFOA/E-MOSFOA).

Bản viết lại phải xử lý dứt điểm cả hai, đồng thời bổ sung **Track B**
làm lớp giá trị gia tăng cho Chương 2 (theo nguyên tắc ở B.1).

## G.2. Cấu trúc 3 chương bắt buộc (giữ nguyên khung đã đề xuất ở v1 — khung này đúng)

#### CHƯƠNG 1 — CƠ SỞ KHOA HỌC TỐI ƯU ĐA MỤC TIÊU VÀ METAHEURISTIC

1.1. Đặt vấn đề
1.2. Mục tiêu và câu hỏi nghiên cứu
1.3. Đối tượng, phạm vi, giả thiết và phương pháp
1.4. Bài toán tối ưu đa mục tiêu
1.5. Quan hệ Pareto và nghiệm không bị trội
1.6. Metaheuristic và Swarm Intelligence
1.7. NFL và yêu cầu phát triển thuật toán theo cấu trúc bài toán

#### CHƯƠNG 2 — ĐÁNH GIÁ THUẬT TOÁN VÀ TỐI ƯU KẾT CẤU THEO TIÊU CHUẨN

2.1. Nguyên tắc kiểm chứng thuật toán MOO
2.2. Benchmark IMOP, UF, RM-MEDA
2.3. Chỉ tiêu IGD/HV/Spread/Convergence
2.4. Kiểm định thống kê
2.5. Biến rời rạc và hỗn hợp
2.6. Xử lý ràng buộc
2.7. Tối ưu theo tiêu chuẩn
2.8. FEM/SSI và chi phí tính toán
**2.9. (MỚI) Đối chứng thực nghiệm SOO và MOO trên kết cấu cảng biển
từ các công bố của NCS (Track B)** — trình bày tóm tắt kết quả các bài
báo trong nước, dùng làm bằng chứng thực nghiệm bổ sung cho việc lựa
chọn hướng phát triển SI-MOO ở Chương 3, không lặp lại chi tiết
benchmark IMOP/UF/RM-MEDA của bài báo MOSFOA.

#### CHƯƠNG 3 — MÔ HÌNH BÀI TOÁN KẾT CẤU CẢNG VÀ ĐỊNH HƯỚNG PHÁT TRIỂN MOSFOA

3.1. Đặc trưng kết cấu bến cọc
3.2. Biến thiết kế
3.3. Hàm mục tiêu cost–displacement
3.4. Ràng buộc kết cấu và địa kỹ thuật
3.5. Mô hình FEM/SSI
3.6. Khoảng trống nghiên cứu
3.7. Yêu cầu đối với thuật toán mới
3.8. Định hướng MOSFOA (SFOA đã chốt, không còn để ngỏ MPA/SFOA)
3.9. Vị trí của CĐ2 và CĐ3 trong luận án
3.10. Kết luận Chuyên đề 1

## G.3. Nội dung phải loại bỏ / phải thêm khi viết lại

**Loại bỏ hoàn toàn** (so với bản cũ):
- Cách trình bày 1 chương với 10 mục con — phải tách vật lý thành 3
  chương;
- Tên gọi "MOSFOAP";
- Cách để ngỏ "chọn một thuật toán nền phù hợp từ danh mục như MPA/SFOA".

**Thêm mới**:
- Chốt dứt khoát SFOA làm nền tảng, có luận cứ (không chỉ là lựa chọn
  mà là quyết định có lý do khoa học, tham chiếu đặc điểm SFOA phù hợp
  với cấu trúc bài toán cost–displacement);
- Mục 2.9 (Track B) như đã nêu ở G.2;
- Kết thúc bằng "yêu cầu/đặc tả cho MOSFOA" (specification), **không**
  trình bày bất kỳ kết quả benchmark hay kết quả BD/MD/MJP nào — các kết
  quả đó thuộc về CĐ2/CĐ3.

---

# PHẦN H — CHUYÊN ĐỀ 2 (giữ khung v1, bổ sung yêu cầu giá trị gia tăng)

## Tên đề xuất

> **CHUYÊN ĐỀ TIẾN SĨ SỐ 2**
> **PHÁT TRIỂN VÀ KIỂM CHỨNG THUẬT TOÁN TỐI ƯU ĐA MỤC TIÊU MOSFOA**

## Mục tiêu Chuyên đề 2

1. SFOA đơn mục tiêu thiếu gì khi chuyển sang MOO?
2. Làm thế nào xây dựng B-MOSFOA?
3. E-MOSFOA cải tiến B-MOSFOA ở điểm nào?
4. Các cải tiến có thực sự tạo ra hiệu quả không?
5. MOSFOA có cạnh tranh với các thuật toán MOO hiện có không?
6. Hiệu quả có ổn định trên nhiều loại bài toán không?

## Đề cương chi tiết

**CHƯƠNG 1 — CƠ SỞ PHÁT TRIỂN MOSFOA**
1.1. Mở đầu
1.2. SFOA đơn mục tiêu (nguyên lý, biểu diễn nghiệm, fitness,
     exploration, exploitation, regeneration, hạn chế đối với MOO)
1.3. Yêu cầu chuyển SFOA sang MOO (Pareto dominance, external archive,
     diversity preservation, leader selection, constraint handling,
     discrete variables)
1.4. Cơ sở xây dựng B-MOSFOA
1.5. Cơ sở xây dựng E-MOSFOA
1.6. Giả thuyết và câu hỏi nghiên cứu
1.7. Kết luận Chương 1

**CHƯƠNG 2 — PHÁT TRIỂN THUẬT TOÁN B-MOSFOA VÀ E-MOSFOA**
2.1. Kiến trúc tổng thể MOSFOA
2.2. B-MOSFOA (Pareto dominance, external archive, adaptive grid,
     crowding-distance truncation, archive-based leader selection,
     boundary handling, cập nhật vị trí theo SFOA)
2.3. E-MOSFOA (LHS, cosine phase control, leader-guided mutation, DE
     mutation, binomial crossover, Gaussian perturbation, archive-guided
     refinement)
2.4. Cấu trúc xử lý ràng buộc
2.5. Pseudocode MOSFOA
2.6. Phân tích độ phức tạp tính toán
2.7. Phân tích vai trò của từng cơ chế cải tiến
2.8. Khung triển khai MATLAB
2.9. Kết luận Chương 2

**CHƯƠNG 3 — KIỂM CHỨNG VÀ ĐÁNH GIÁ MOSFOA**
3.1. Thiết kế thực nghiệm (IMOP, UF, RM-MEDA, population, iterations,
     archive, independent runs)
3.2. Chỉ tiêu đánh giá (convergence, IGD, distribution, HV, rank)
3.3. Kiểm định thống kê (Wilcoxon rank-sum, Holm, W/D/L, stability)
3.4. So sánh B-MOSFOA và E-MOSFOA
3.5. So sánh với MOMSA / NS-MFO / MOGNDO
**3.6. (MỚI) Đối chiếu định tính với các thuật toán SOO/MOO đã thử
nghiệm ở Track B** — không chạy lại benchmark, chỉ thảo luận nhất quán:
vì sao MOSFOA được kỳ vọng phù hợp hơn cho lớp bài toán kết cấu cảng
biển so với các lựa chọn đã thử trước đó của NCS.
3.7. Phân tích độ nhạy tham số
3.8. Phân tích chi phí tính toán
3.9. Tổng hợp kết quả
3.10. Đóng góp của Chuyên đề 2
3.11. Kết luận Chuyên đề 2

## Sản phẩm đầu ra của Chuyên đề 2

1. Thuật toán B-MOSFOA; 2. Thuật toán E-MOSFOA; 3. Pseudocode; 4.
Workflow; 5. MATLAB implementation; 6. Benchmark dataset; 7. Bộ chỉ
tiêu đánh giá; 8. Kết quả thống kê; 9. Phân tích sensitivity; 10. Kết
luận về năng lực MOSFOA.

Bài báo đã cho thấy MOMSA có average rank 2.52, E-MOSFOA 2.58 và
B-MOSFOA 2.75 trên tổng thể benchmark; B-MOSFOA tốt nhất ở IMOP với rank
2.28. Kết quả này phải được trình bày như **bằng chứng kiểm chứng**,
không được diễn giải thành tuyên bố "MOSFOA luôn tốt nhất".

---

# PHẦN I — CHUYÊN ĐỀ 3 (giữ khung v1, bổ sung mục tổng quát hóa qua Track B)

## Tên đề xuất

> **CHUYÊN ĐỀ TIẾN SĨ SỐ 3**
> **ỨNG DỤNG VÀ KIỂM CHỨNG THUẬT TOÁN MOSFOA CHO TỐI ƯU ĐA MỤC TIÊU KẾT CẤU HẠ TẦNG CẢNG BIỂN**

## Mục tiêu Chuyên đề 3

1. MOSFOA có giải được bài toán kết cấu cảng thực tế không?
2. Quy trình MATLAB–SAP2000 hoạt động như thế nào?
3. Pareto cost–displacement có ý nghĩa kỹ thuật không?
4. Các nghiệm Pareto có thực sự khả thi theo tiêu chuẩn không?
5. MOSFOA tạo ra lợi ích gì so với thiết kế hiện trạng?
6. Có thể chuyển kết quả thành quy trình hỗ trợ kỹ sư thiết kế không?
7. Những giới hạn nào còn tồn tại và đâu là hướng phát triển luận án?

## Đề cương chi tiết

**CHƯƠNG 1 — MÔ HÌNH BÀI TOÁN TỐI ƯU KẾT CẤU CẢNG BIỂN**
1.1. Mở đầu
1.2. Đối tượng nghiên cứu (BD, MD, MJP)
1.3. Mô hình kết cấu (geometry, material, pile system, cap/deck, soil)
1.4. Tải trọng và tổ hợp tải trọng (DL, BL, ML, LL)
1.5. Biến thiết kế (pile diameter, wall thickness, rake, length, MJP
     beam variables)
1.6. Hàm mục tiêu (construction cost, maximum displacement, Pareto
     formulation)
1.7. Ràng buộc (geometric, strength, pile compression, uplift, bending,
     geotechnical, feasibility)
1.8. Kết luận Chương 1

**CHƯƠNG 2 — TÍCH HỢP MOSFOA–MATLAB–SAP2000 VÀ THỰC NGHIỆM**
2.1. Kiến trúc hệ thống
2.2. Mô hình FEM (BD, MD, MJP)
2.3. Mô hình địa kỹ thuật
2.4. Constraint handling
2.5. Thiết lập tối ưu
2.6. Thiết kế sáu bài toán kỹ thuật (BD/MD/MJP × B-MOSFOA/E-MOSFOA)
2.7. Kiểm chứng quy trình
2.8. Kết luận Chương 2

**CHƯƠNG 3 — KẾT QUẢ TỐI ƯU VÀ Ý NGHĨA KỸ THUẬT**
3.1. Kết quả BD
3.2. Kết quả MD
3.3. Kết quả MJP
**3.3.x (MỚI — nâng cấp từ Track B) Kiểm chứng bổ sung trên dự án độc
lập** — trình bày tóm tắt kết quả bài báo #4 (JMST), áp dụng MOSFOA cho
một công trình bến bệ cọc cao thuộc dự án khác Hải Linh. Vì đây là dữ
liệu độc lập với BD/MD/MJP, mục này đóng vai trò **bằng chứng tổng quát
hóa chính thức** (không chỉ là thảo luận ở 3.9.x), làm tăng đáng kể sức
thuyết phục về khả năng áp dụng rộng của MOSFOA ngoài phạm vi một dự án
duy nhất.
3.4. So sánh B-MOSFOA và E-MOSFOA trong bài toán kỹ thuật
3.5. Phân tích Pareto (cost–displacement trade-off, ideal point,
     compromise solution, engineering meaning)
3.6. Kiểm chứng tính khả thi
3.7. Hiệu quả kinh tế–kỹ thuật
3.8. Quy tắc lựa chọn nghiệm Pareto
3.9. Phân tích giới hạn và khả năng mở rộng
**3.9.x (MỚI trong mục này) Thảo luận tổng quát hóa qua Track B** —
liên hệ ngắn gọn với các hạng mục kết cấu cảng khác (tường chắn, dây
neo phao...) mà NCS đã tối ưu ở các bài báo trong nước, để lập luận về
khả năng mở rộng phương pháp sang các đối tượng ngoài BD/MD/MJP — đây
là "future work" có bằng chứng đi kèm, không phải suy đoán.
3.10. Đóng góp của Chuyên đề 3
3.11. Kết luận Chuyên đề 3

Bài báo hiện tại ghi nhận toàn bộ sáu final archives đều thỏa các điều
kiện đã triển khai, với utilization lớn nhất 0.9971; MD cho thấy nghiệm
chi phí thấp nhất giảm 81.5% chi phí và 42.4% chuyển vị so với thiết kế
hiện trạng — dùng nguyên các con số này, không làm tròn/phóng đại.

Bài báo đã xác định hai giới hạn chính: mô hình sức chịu tải và khống
chế ngang của cọc vẫn là mô hình code-based/equivalent-support, chưa mô
tả đầy đủ tương tác đất–cọc phi tuyến; và việc đánh giá mọi nghiệm bằng
SAP2000 vẫn có chi phí tính toán lớn.

---

# PHẦN J — BẢNG PHÂN BỔ TỔNG THỂ (Bài báo MOSFOA + Track B → 4 sản phẩm)

## J.1. Phân bổ nội dung bài báo MOSFOA (Track A)

| Nội dung bài báo | CĐ2 | CĐ3 |
|---|:---:|:---:|
| SFOA baseline | ✓ | |
| B-MOSFOA | ✓ | |
| E-MOSFOA | ✓ | |
| Pareto archive | ✓ | |
| Adaptive grid | ✓ | |
| Leader selection | ✓ | |
| LHS | ✓ | |
| Cosine phase | ✓ | |
| DE mutation/crossover | ✓ | |
| Gaussian refinement | ✓ | |
| Pseudocode | ✓ | |
| Complexity | ✓ | |
| IMOP / UF / RM-MEDA | ✓ | |
| Wilcoxon-Holm | ✓ | |
| Sensitivity | ✓ | |
| MATLAB–SAP2000 | | ✓ |
| BD / MD / MJP | | ✓ |
| Cost–displacement | | ✓ |
| Structural / geotechnical constraints | | ✓ |
| Pareto engineering interpretation | | ✓ |
| Current-design comparison | | ✓ |
| Engineering decision | | ✓ |
| Limitations/application | | ✓ |

## J.2. Phân bổ Track B (bài báo trong nước)

| Vai trò Track B | Tổng quan | CĐ1 | CĐ3 |
|---|:---:|:---:|:---:|
| Minh chứng "khả năng tiếp cận của NCS" | ✓ | | |
| Đối chứng SOO vs MOO (mục 2.9 CĐ1) | | ✓ | |
| Thảo luận tổng quát hóa (mục 3.9.x CĐ3) | | | ✓ |
| Đáp ứng điều kiện đầu ra tốt nghiệp | *(ngoài phạm vi Tiểu luận/Chuyên đề — xem C.3)* | | |

---

# PHẦN K — CẤU TRÚC CUỐI CÙNG CỦA 04 SẢN PHẨM

## SẢN PHẨM 1 — TIỂU LUẬN TỔNG QUAN

> **NGHIÊN CỨU TỔNG QUAN BÀI TOÁN TỐI ƯU ĐA MỤC TIÊU CHO KẾT CẤU HẠ TẦNG CẢNG BIỂN**

**Vai trò**: Xác lập vấn đề và research gap; trình bày khả năng tiếp
cận của NCS qua Track B.

**Kết quả bắt buộc**: State of the art; Research gap; Research problem;
Research objectives; Research questions; Scope; Methodology; khả năng
tiếp cận (Track B); Preliminary 3-specialty plan.

## SẢN PHẨM 2 — CHUYÊN ĐỀ TIẾN SĨ SỐ 1

> **CƠ SỞ KHOA HỌC BÀI TOÁN TỐI ƯU ĐA MỤC TIÊU CHO KẾT CẤU CÔNG TRÌNH CẢNG BIỂN**

**Vai trò**: Xây dựng nền tảng khoa học, mô hình hóa bài toán, đối
chứng SOO/MOO bằng Track B.

**Kết quả**: MOO framework; SI-MOO framework; benchmark/evaluation
framework; code-based optimization; discrete design; FEM/SSI; port
structural problem; đối chứng SOO/MOO thực nghiệm; requirements for
MOSFOA.

## SẢN PHẨM 3 — CHUYÊN ĐỀ TIẾN SĨ SỐ 2

> **PHÁT TRIỂN VÀ KIỂM CHỨNG THUẬT TOÁN TỐI ƯU ĐA MỤC TIÊU MOSFOA**

**Vai trò**: Đóng góp thuật toán.

**Kết quả**: B-MOSFOA; E-MOSFOA; benchmark validation; sensitivity;
statistical validation; computational assessment.

## SẢN PHẨM 4 — CHUYÊN ĐỀ TIẾN SĨ SỐ 3

> **ỨNG DỤNG VÀ KIỂM CHỨNG THUẬT TOÁN MOSFOA CHO TỐI ƯU ĐA MỤC TIÊU KẾT CẤU HẠ TẦNG CẢNG BIỂN**

**Vai trò**: Đóng góp ứng dụng, chứng minh giá trị kỹ thuật, thảo luận
tổng quát hóa qua Track B.

**Kết quả**: MATLAB–SAP2000 framework; BD; MD; MJP; Pareto
cost–displacement; code-based feasibility; economic/technical
interpretation; engineering decision support; thảo luận mở rộng.

---

# PHẦN L — MỐI LIÊN KẾT VỚI LUẬN ÁN (6 CHƯƠNG) + VỊ TRÍ TRACK B

```text
CHƯƠNG 1 — TỔNG QUAN VÀ ĐẶT VẤN ĐỀ
        ↑── Tiểu luận Tổng quan (gồm mục "khả năng tiếp cận" trích Track B)

CHƯƠNG 2 — CƠ SỞ KHOA HỌC VÀ MÔ HÌNH BÀI TOÁN
        ↑── Chuyên đề 1 (gồm mục 2.9 đối chứng Track B)

CHƯƠNG 3 — PHÁT TRIỂN THUẬT TOÁN MOSFOA
        ↑── Chuyên đề 2

CHƯƠNG 4 — KIỂM CHỨNG TRÊN BÀI TOÁN CHUẨN
        ↑── Chuyên đề 2

CHƯƠNG 5 — ỨNG DỤNG MOSFOA CHO KẾT CẤU CẢNG
        ↑── Chuyên đề 3 (gồm mục 3.9.x thảo luận tổng quát hóa qua Track B)

CHƯƠNG 6 — THẢO LUẬN, ĐÓNG GÓP, GIỚI HẠN
        ↑── CĐ2 + CĐ3 + kết quả tổng hợp + Phần D (đóng góp 4 tầng)
```

> **CĐ2 và CĐ3 không phải hai tài liệu phụ trợ cho luận án; chúng là hai
> khối kết quả nghiên cứu chính cấu thành phần đóng góp của luận án.
> Track B không tạo ra chương riêng trong luận án — nó chỉ xuất hiện như
> minh chứng bổ sung trong Chương 1, 2 và 6.**

---

# PHẦN M — MA TRẬN "CÂU HỎI → SẢN PHẨM → KẾT QUẢ → LUẬN ÁN"

| Câu hỏi | Sản phẩm | Kết quả |
|---|---|---|
| Tại sao phải nghiên cứu MOO cho cảng? | Tổng quan | Research gap |
| Khoảng trống hiện nay là gì? | Tổng quan | Research problem |
| NCS đã có kinh nghiệm gì trước MOSFOA? | Tổng quan (Track B) | Khả năng tiếp cận |
| Bài toán MOO cảng có cấu trúc gì? | CĐ1 | Mathematical/code-based formulation |
| Thuật toán cần đáp ứng gì? | CĐ1 | Algorithm requirements |
| SOO/MOO khác đã bộc lộ hạn chế gì? | CĐ1 (Track B) | Đối chứng thực nghiệm |
| SFOA có hạn chế gì? | CĐ2 | Motivation for MOSFOA |
| MOSFOA được phát triển thế nào? | CĐ2 | B-MOSFOA/E-MOSFOA |
| MOSFOA có tốt không? | CĐ2 | Benchmark evidence |
| Cải tiến nào có tác dụng? | CĐ2 | Sensitivity/component evidence |
| MOSFOA có giải được bài toán cảng? | CĐ3 | Engineering evidence |
| Pareto có ý nghĩa gì? | CĐ3 | Engineering trade-off |
| Nghiệm có khả thi? | CĐ3 | Code/geotechnical verification |
| Có giá trị thực tiễn? | CĐ3 | Decision framework |
| Có tổng quát hóa được không? | CĐ3 (Track B) | Thảo luận mở rộng |
| Đóng góp khoa học là gì? | Luận án | Integrated contribution (Phần D) |
| Đầu ra công bố có đủ điều kiện bảo vệ? | Track B | Số lượng/loại bài báo (xem C.3) |

---

# PHẦN N — NHỮNG GÌ KHÔNG NÊN LÀM

## Không nên 1
Không biến CĐ2 thành một bản sao bài báo. CĐ2 phải là **chuyên đề
nghiên cứu**, áp dụng quy tắc giá trị gia tăng ở B.1.

## Không nên 2
Không biến CĐ3 thành phần "case study" vài trang. CĐ3 phải chứng minh:
**MOSFOA → bài toán thực → FEM → tiêu chuẩn → Pareto → quyết định thiết
kế.**

## Không nên 3
Không lặp lại toàn bộ lý thuyết MOO trong CĐ2. Lý thuyết nền đã nằm ở
CĐ1.

## Không nên 4
Không đưa tất cả kết cấu cảng vào phạm vi luận án. BD, MD, MJP là bộ
case hiện tại; các đối tượng khác (kể cả các đối tượng ở Track B) chỉ
là hướng mở rộng/thảo luận.

## Không nên 5
Không tuyên bố "E-MOSFOA tốt nhất". MOMSA có average rank tổng thể
2.52, E-MOSFOA 2.58, B-MOSFOA 2.75; kết luận khoa học phải là **MOSFOA
competitive và có ưu thế theo từng lớp bài toán**, không phải universal
superiority.

## Không nên 6 (mới)
Không để Track B "kể chuyện riêng". Các bài báo trong nước không được
trình bày như một hướng nghiên cứu song song có mục tiêu/kết luận độc
lập trong luận án — chúng chỉ đóng vai trò minh chứng và đầu ra, xuất
hiện đúng ba chỗ đã định vị (Tổng quan, CĐ1 §2.9, CĐ3 §3.9.x). Đưa
Track B vào nhiều hơn sẽ khiến luận án mất trọng tâm.

## Không nên 7 (mới)
Không công bố số lượng/tỷ lệ đầu ra "cho đủ" mà bỏ qua việc xác nhận
đúng điều khoản quy chế (xem C.3). Cần xác nhận bằng văn bản/điều khoản
cụ thể trước khi xem Track B là "đã đủ".

---

# PHẦN O — HƯỚNG DẪN VIẾT LẠI HOÀN TOÀN TỔNG QUAN VÀ CĐ1

NCS đã xác nhận hai file cũ — `CHUYEN DE TONG QUAN.docx` và `CHUYEN DE 1
HOAN CHINH.docx` — được phép **xóa và viết lại hoàn toàn**, không bị
ràng buộc bởi cấu trúc/câu chữ cũ. Khi triển khai bước viết chi tiết
(sau khi khóa đề cương này), áp dụng quy trình sau:

1. **Không copy nguyên văn** các đoạn cũ — dùng làm tham khảo nội dung
   khảo sát (đặc biệt phần khảo sát quốc tế/trong nước, vì phần đó vẫn
   còn giá trị), nhưng viết lại câu dẫn để khớp mạch lập luận ở Phần F/G.
2. Với Tổng quan: bắt đầu từ dàn ý F.3, viết theo đúng 11 mục bắt buộc
   trong Mở đầu (F.2), kết thúc bằng thiết kế sơ bộ 3 chuyên đề đã chốt
   ở Phần K.
3. Với CĐ1: bắt đầu từ khung 3 chương ở G.2, đặc biệt đảm bảo tách vật
   lý thành Chương 1/2/3 (không còn viết dạng "mục 1.1–1.10" như bản
   cũ), và chốt SFOA ngay từ Chương 1 (không để ngỏ như bản cũ).
4. Sau khi có bản thảo, đối chiếu lại với Checklist ở Phần Q trước khi
   gửi người hướng dẫn.

---

# PHẦN P — KIẾN TRÚC KHOA HỌC CUỐI CÙNG

```text
                         LUẬN ÁN
                           │
        NGHIÊN CỨU PHÁT TRIỂN THUẬT TOÁN
        TỐI ƯU METAHEURISTIC CHO KẾT CẤU
                 HẠ TẦNG CẢNG BIỂN
                           │
        ┌──────────────────┼──────────────────┐
        │                  │                  │
        ▼                  ▼                  ▼
     GAP/WHY           ALGORITHM           APPLICATION
        │                  │                  │
        ▼                  ▼                  ▼
    TỔNG QUAN             CĐ2                CĐ3
   (+Track B)              │                  │
        │             B-MOSFOA             BD
        │             E-MOSFOA             MD
        │             Benchmark            MJP
        │             Sensitivity           │
        │             Statistics       (+Track B thảo luận)
        │                  │                  │
        └──────────────┐   │   ┌──────────────┘
                       ▼   ▼   ▼
                         CĐ1
                     (+Track B §2.9)
                          │
              NỀN TẢNG KHOA HỌC
              MOO + SI + CODE
              + DISCRETE + FEM/SSI
                          │
                          ▼
                 MOSFOA REQUIREMENTS
                          │
             ┌────────────┴────────────┐
             ▼                         ▼
         ALGORITHM                 ENGINEERING
         EVIDENCE                   EVIDENCE
             │                         │
             └────────────┬────────────┘
                          ▼
                  SCIENTIFIC CONTRIBUTION
                     (xem Phần D)
                          │
                          ▼
                     LUẬN ÁN
```

---

# PHẦN Q — CHECKLIST TUÂN THỦ QUY CHẾ

> Checklist đầy đủ (khổ giấy, font, lề, thứ tự trình bày, hội đồng đánh
> giá, số bản nộp...) đã tổng hợp chi tiết trong
> [`Quy_che_Tieu_luan_Tong_quan_va_Chuyen_de_Tien_si.md`](Quy_che_Tieu_luan_Tong_quan_va_Chuyen_de_Tien_si.md)
> mục 15. Dưới đây chỉ nhắc lại các mục **có thay đổi/bổ sung** trong
> bản v2 này.

## Tiểu luận Tổng quan

- [ ] Khoảng 30 trang.
- [ ] Có đủ 11 mục bắt buộc trong Mở đầu (F.2), **bao gồm mục "khả năng
      tiếp cận của NCS" trích dẫn Track B**.
- [ ] Dẫn trực tiếp tới MOSFOA (không dừng ở "SI-MOO cải tiến" chung
      chung, không dùng tên "MOSFOAP").
- [ ] Có thiết kế sơ bộ 03 Chuyên đề đúng tên đã chốt (Phần K).

## Chuyên đề 1

- [ ] Không quá 80 trang.
- [ ] **Đủ 03 chương, tách vật lý** — không còn dạng "mục 1.1–1.10".
- [ ] Chốt SFOA làm nền tảng ngay từ Chương 1, có luận cứ.
- [ ] Có mục 2.9 đối chứng SOO/MOO bằng Track B.
- [ ] Không trình bày kết quả MOSFOA/benchmark/BD-MD-MJP (thuộc CĐ2/CĐ3).
- [ ] Kết thúc bằng đặc tả yêu cầu cho MOSFOA.

## Chuyên đề 2

- [ ] Không quá 80 trang, đủ 03 chương.
- [ ] Có mục 3.6 đối chiếu định tính với Track B.
- [ ] Không tuyên bố universal superiority (Không nên 5).

## Chuyên đề 3

- [ ] Không quá 80 trang, đủ 03 chương.
- [ ] Có mục 3.9.x thảo luận tổng quát hóa qua Track B.
- [ ] Track B không chiếm quá 1 mục nhỏ trong toàn chuyên đề (Không nên 6).

## Track B / Đầu ra

- [x] Đã đối chiếu Điều 17/18, Phụ lục 12 (C.3) — điều kiện: tác giả
      chính, tổng điểm ≥ 2,0, liên quan trực tiếp đến luận án.
- [ ] Đã tra khung điểm HĐGSNN ngành Giao thông vận tải hiện hành để
      tính điểm quy đổi thực tế cho bài Q3 + 5 công bố Track B — **chưa
      làm, cần làm trước khi khóa đề cương** (hạng mục mở duy nhất còn
      lại cùng với mục dưới).
- [ ] Đã xác nhận vị trí "tác giả thứ hai" ở bài #2 có được công nhận là
      tác giả chính hay không.
- [x] Đã xử lý 3 cảnh báo (i)/(ii)/(iii) ở C.2 — bài #4 dùng dự án khác
      Hải Linh (không trùng lặp), bài #5 xác nhận thuộc phạm vi hạ tầng
      cảng biển, bài #6 đã hủy không nộp.
- [ ] Bảng ánh xạ công bố (C.2) được cập nhật mỗi khi có bài báo mới.

---

# PHẦN R — KẾT LUẬN KHÓA ĐỀ CƯƠNG

### Câu trả lời cho các yêu cầu đặt ra

**1. Có cần thay đổi Tổng quan và CĐ1 không?**

**Có, và lần này viết lại hoàn toàn** (không còn giữ khung "cập nhật,
không viết lại từ đầu" như bản v1) — theo đúng chỉ đạo mới của NCS. Nội
dung khảo sát cũ (quốc tế/trong nước) vẫn dùng được làm tư liệu, nhưng
toàn bộ mạch lập luận, cách chốt thuật toán, và cấu trúc chương phải
làm lại theo Phần F/G.

**2. Có thể tách bài báo thành CĐ2 và CĐ3 không?**

**Có**, với điều kiện bắt buộc là quy tắc **giá trị gia tăng** (B.1):
mỗi chuyên đề phải vượt ra ngoài nội dung bài báo đã công bố, không chỉ
trình bày lại.

**3. Các bài báo trong nước (SOO/MOO ứng dụng khác) nằm ở đâu?**

**Track B** — không tạo chương riêng, chỉ xuất hiện ở ba điểm neo:
Tổng quan (khả năng tiếp cận), CĐ1 §2.9 (đối chứng), CĐ3 §3.9.x (thảo
luận mở rộng) — đồng thời phục vụ điều kiện đầu ra tốt nghiệp (cần xác
nhận số lượng theo C.3).

**4. Bốn sản phẩm (+ Track B) có xuyên suốt thành luận án không?**

**Có.** Cấu trúc khóa lại:

```text
TỔNG QUAN (+ Track B)
     ↓
CĐ1 — CƠ SỞ KHOA HỌC (+ Track B)
     ↓
CĐ2 — PHÁT TRIỂN MOSFOA
     ↓
CĐ3 — ỨNG DỤNG MOSFOA (+ Track B)
     ↓
LUẬN ÁN (Đóng góp khoa học 4 tầng — Phần D)
```

> **Tổng quan chứng minh "WHY" (và "NCS đã chuẩn bị gì").**
> **CĐ1 chứng minh "WHAT PROBLEM" (và "đã thử gì trước MOSFOA").**
> **CĐ2 chứng minh "HOW TO SOLVE".**
> **CĐ3 chứng minh "DOES IT WORK IN ENGINEERING" (và "có tổng quát hóa
> được không").**
> **Luận án tích hợp toàn bộ thành "SCIENTIFIC CONTRIBUTION", được phát
> biểu thống nhất ở Phần D.**

**Việc còn lại trước khi viết chi tiết** (đã cập nhật sau khi NCS xác
nhận ngành xét HĐGSNN, vị trí tác giả các bài dự kiến, và xử lý dứt
điểm 3 cảnh báo trùng lặp/phạm vi — Track B nay còn đúng **5 công bố**:
Q3 + #1 + #2 + #3 + #4 + #5, đã loại bỏ #6):

1. Tra khung điểm HĐGSNN **ngành Giao thông vận tải** hiện hành để xác
   nhận tổng điểm công bố ≥ 2,0 (C.3) — **hạng mục mở duy nhất còn lại**;
2. Xác nhận vị trí đồng tác giả (tác giả thứ hai) của bài #2 có được
   tính là "tác giả chính" hay không (C.3) — **hạng mục mở thứ hai**;
3. Khi viết CĐ3 Chương 3, cân nhắc nâng mục 3.3.x (kết quả bài #4 trên
   dự án độc lập) từ "thảo luận" thành một mục kết quả chính thức, tùy
   mức độ đầy đủ của dữ liệu khi bài báo #4 hoàn thành;
4. Sau khi xử lý (1)–(2), bắt đầu viết chi tiết Tổng quan và CĐ1 theo
   Phần F/G, cập nhật CĐ2/CĐ3 theo Phần H/I với dữ liệu Track B đã chốt.
