<!--
GHI CHÚ NỘI BỘ CHO NGƯỜI VIẾT — XÓA TRƯỚC KHI CHUYỂN SANG WORD/NỘP BÀI.
Trạng thái: DRAFT v5 — 22/08/2026.
**ĐÃ KHÓA: Paper 1 chỉ dùng 4 phương pháp — M1, M2, M3, M6.** M4 (tiêu chuẩn Nga) và M5
(Budin–Demina) đã bị loại khỏi phạm vi (quyết định người dùng, 22/08/2026) vì thiếu căn
cứ số liệu đáng tin cậy: M4 không có bảng K gốc (phải mượn tạm bảng M2 — không đủ tin
cậy để công bố); M5 chỉ có hệ số β tra đồ thị 1979, không có ảnh đồ thị để số hóa. Công
thức đầy đủ của M4/M5 vẫn lưu trong DOI_CHIEU_CONG_THUC_M1_M6_FINAL.md để tham khảo,
nhưng KHÔNG đưa vào bài. Giữ nguyên nhãn M1/M2/M3/M6 (không đổi số liên tục) vì toàn bộ
CSV/script đã tính đều dùng nhãn này.
§1, §2, §4 đã viết đầy đủ, đã cập nhật "bốn phương pháp" xuyên suốt. §3 (Methods, M1/M2/
M3/M6) ĐÃ XÁC MINH ĐẦY ĐỦ với ảnh gốc từ "Giao trinh Cong trinh ben.doc" (PGS.TS. Nguyễn
Văn Ngọc) — xem DOI_CHIEU_CONG_THUC_M1_M6_FINAL.md. Không còn 🔶 công thức chưa xác minh.
§5.1 (biến thiên h_z/l_tt) ĐÃ CÓ SỐ LIỆU THẬT cho cả 4 phương pháp (178 cọc) — script
tính ở pile_hz_ltt_results_ALL.csv, thống kê ở table5_ltt_statistics.csv (cả 2 file đã
dọn sạch cột/dòng M4).
§5.2–5.4 (U_X/U_Y/M_max/V_max, S_R) và §6 (Conclusions) CHƯA VIẾT — chờ dựng & chạy 4
mô hình SAP2000 sensitivity thật (đổi fixity 178 cọc), đây là việc CHƯA làm — các số
liệu §5.1 chỉ là kết quả công thức/tính tay, không phải kết quả chạy FEM.
Còn 1 việc hình học chưa xử lý: 15/178 cọc có giao điểm mái dốc tính ra nằm ngoài đoạn
cọc mô hình (lệch ~14,5cm, do phương trình mái dốc tuyến tính z_s≈−0,335Y−7,84 chỉ là
xấp xỉ) — xem pile_hz_input_table.csv, cột on_segment=False. Không chặn tiến độ vì sai
số nhỏ, nhưng nên xử lý trước khi công bố số liệu cuối.
Tác giả/email hiện là placeholder (ABC / abc@gmail.com) theo yêu cầu tạm thời — cần thay
bằng thông tin chính thức trước khi nộp bài.
Định dạng (font, cỡ chữ, style JMST_*, vị trí tiêu đề bảng/hình...) áp dụng khi
convert sang .docx theo PAPER_1_DE_CUONG_CHI_TIET.md §27 — không cần lo trong bản .md này.
-->

# [TIÊU ĐỀ TIẾNG VIỆT — IN HOA KHI SANG WORD]

ẢNH HƯỞNG CỦA PHƯƠNG PHÁP XÁC ĐỊNH ĐIỂM NGÀM TƯƠNG ĐƯƠNG CỦA CỌC ĐẾN CHIỀU DÀI TÍNH TOÁN VÀ ĐÁP ỨNG KẾT CẤU BẾN CẢNG TRÊN NỀN CỌC: NGHIÊN CỨU SỐ BẰNG MÔ HÌNH SAP2000 3D CỦA MỘT PHÂN ĐOẠN BẾN ĐIỂN HÌNH

EFFECTS OF EQUIVALENT PILE FIXITY DETERMINATION METHODS ON EFFECTIVE BUCKLING LENGTH AND STRUCTURAL RESPONSE OF A PILED WHARF: A THREE-DIMENSIONAL SAP2000 NUMERICAL STUDY OF A STANDARD WHARF SEGMENT

ABC*

*Email liên hệ: abc@gmail.com

🔶 *[Placeholder theo yêu cầu tạm thời — chưa có học vị/chức danh/đơn vị công tác thật. Cần thay bằng thông tin chính thức trước khi nộp bài.]*

DOI: https://doi.org/10.65154/jmst.%ID *(tòa soạn cấp sau khi nộp)*

---

**Tóm tắt**

Cọc của bến cảng trên nền cọc thường được mô hình hóa bằng một điểm ngàm tương đương thay cho tương tác đất–cọc thực tế; vị trí điểm ngàm quyết định chiều dài tính toán của cọc và do đó ảnh hưởng đến độ cứng và nội lực của toàn hệ. Các phương pháp/tiêu chuẩn khác nhau có thể cho vị trí điểm ngàm khác nhau, nhưng mức độ khác biệt đó truyền vào đáp ứng kết cấu tổng thể đến đâu vẫn chưa được lượng hóa rõ trên một mô hình bến cảng 3D thực tế. Bài báo trình bày một thí nghiệm số có kiểm soát trên mô hình SAP2000 3D của một phân đoạn tiêu chuẩn (~75 m) thuộc bến 100.000 DWT, cảng cửa ngõ quốc tế Hải Phòng – Lạch Huyện, gồm 192 cọc; trong đó 178 cọc được thay đổi điểm ngàm theo bốn phương pháp/tiêu chuẩn xác định điểm ngàm tương đương (22TCN 207-92; 20TCN21-86/TCXD 205-1998; TCVN 10304:2014; phương pháp Nhật Bản), còn 14 cọc giữ nguyên điều kiện biên làm nhóm kiểm soát. Hình học, vật liệu, tải trọng và tổ hợp tải trọng được giữ cố định giữa bốn mô hình; chỉ điểm ngàm của nhóm cọc khảo sát thay đổi. 🔶 *[CẦN BỔ SUNG sau khi có kết quả: phạm vi biến thiên `h_z`, `l_tt`, mức biến thiên chuyển vị `U_X`/`U_Y`, nội lực cọc `M_max`/`V_max`, và chỉ số độ nhạy `S_R` — 1–2 câu tóm tắt số liệu chính]. Kết quả cho thấy 🔶 *[CẦN BỔ SUNG: kết luận định lượng — response nào nhạy nhất/ít nhạy nhất]*, có ý nghĩa tham khảo cho việc lựa chọn giả thiết điểm ngàm khi mô hình hóa bến cảng trên nền cọc.

*(Lưu ý độ dài: bản trên còn thiếu 2 câu Results/Conclusion; sau khi bổ sung, tổng đoạn Tóm tắt phải nằm trong 150–250 từ theo quy định JMST — hiện đang ước lượng ~180 từ phần đã viết.)*

**Từ khóa**: *bến cảng trên nền cọc, điểm ngàm tương đương của cọc, chiều dài tính toán, tương tác cọc–đất, độ nhạy kết cấu, SAP2000, nghiên cứu số.*

**Abstract**

Piles of a piled wharf are commonly modeled with a single equivalent fixity point that replaces the actual pile–soil interaction; the position of this point governs the pile's effective buckling length and therefore the stiffness and internal forces of the whole system. Different codes and methods may yield different fixity depths, but the extent to which this difference propagates into the structural response of a real three-dimensional wharf model has not been clearly quantified. This paper presents a controlled numerical experiment on a 3D SAP2000 model of one standard 75-m segment of the 100,000-DWT berth at the Lach Huyen International Gateway Port, Hai Phong, comprising 192 piles; fixity was varied for 178 piles using four equivalent-fixity determination methods (22TCN 207-92; 20TCN21-86/TCXD 205-1998; TCVN 10304:2014; and the Japanese method), while 14 piles were kept fixed as a control group. Geometry, material properties, loads, and load combinations were kept unchanged across the four models; only the fixity of the treatment piles was varied. 🔶 *[TO BE ADDED: quantitative range of `h_z`, `l_tt`, displacement and pile-force sensitivity, and the sensitivity index `S_R`]*. Results indicate 🔶 *[TO BE ADDED: which response is most/least sensitive]*, providing a quantitative basis for selecting fixity assumptions in the numerical modeling of piled wharves.

**Keywords**: *piled wharf, equivalent pile fixity, effective buckling length, pile–soil interaction, structural sensitivity, SAP2000, numerical analysis.*

---

## 1. Mở đầu

Bến cảng trên nền cọc là dạng kết cấu phổ biến tại các cảng nước sâu, trong đó hệ dầm – bản bê tông cốt thép trên đỉnh bến truyền toàn bộ tải trọng khai thác, tải trọng tàu và tải trọng môi trường xuống nền thông qua hệ cọc. Khác với cọc của công trình trên bờ, cọc của bến cảng vừa chịu tải trọng đứng vừa chịu tải trọng ngang và mô men đáng kể, phát sinh từ lực neo tàu, lực va tàu, tải trọng cần trục và tải trọng môi trường (sóng, dòng chảy, gió). Ứng xử chịu lực ngang của cọc phụ thuộc rất lớn vào điều kiện liên kết giữa cọc và nền đất xung quanh — đặc biệt tại các khu vực có địa chất yếu như vùng cửa sông, cửa biển.

Trong thực hành thiết kế và mô hình hóa kết cấu bến bằng phần tử hữu hạn 3D, việc mô phỏng đầy đủ tương tác đất–cọc phi tuyến (ví dụ bằng lò xo p–y phân bố dọc thân cọc) làm tăng đáng kể độ phức tạp của mô hình. Một cách tiếp cận thực dụng và được sử dụng rộng rãi trong thiết kế là thay thế toàn bộ ảnh hưởng của nền đất bằng một **điểm ngàm tương đương** (equivalent fixity point) tại một độ sâu `h_z` nào đó dưới mặt đất/đáy bến; phần cọc từ đỉnh đến điểm ngàm này được xem là chiều dài tính toán `l_tt` tham gia chịu lực ngang và ổn định của cọc. Vị trí điểm ngàm quyết định trực tiếp `l_tt`, từ đó ảnh hưởng đến độ cứng ngang của cọc, phân bố nội lực trong hệ, và chuyển vị của toàn bộ kết cấu bến.

Vấn đề đặt ra là: các tiêu chuẩn và tài liệu kỹ thuật khác nhau đưa ra các công thức và cách xác định `h_z` khác nhau. Tại Việt Nam và các tài liệu tham khảo phổ biến trong thiết kế công trình bến, có thể kể đến 22TCN 207-92, 20TCN21-86/TCXD 205-1998, TCVN 10304:2014, và phương pháp được sử dụng trong thực hành thiết kế của Nhật Bản. Do khác nhau về cơ sở lý thuyết, dữ liệu đầu vào và phạm vi áp dụng, các phương pháp này có thể cho các giá trị `h_z` (và do đó `l_tt`) khác nhau cho cùng một cọc, cùng một điều kiện địa chất.

Tuy nhiên, mức độ khác biệt giữa các phương pháp — và quan trọng hơn, mức độ khác biệt đó thực sự truyền vào đáp ứng kết cấu tổng thể (chuyển vị) và nội lực cọc đến đâu trên một mô hình bến cảng 3D thực tế — hiện chưa được lượng hóa một cách có kiểm soát. Phần lớn các nghiên cứu và tài liệu hiện có trình bày từng phương pháp một cách độc lập, hoặc so sánh công thức mà không đặt trong một mô hình kết cấu thống nhất để đánh giá ảnh hưởng thực tế đến đáp ứng công trình.

Từ đó, khoảng trống nghiên cứu được xác định là: **các phương pháp xác định điểm ngàm có thể cho các giá trị khác nhau, nhưng cần lượng hóa một cách có kiểm soát xem sự khác biệt về điểm ngàm và chiều dài tính toán có thực sự tạo ra sai khác đáng kể trong đáp ứng của một hệ bến cảng 3D thực tế hay không.**

Bài báo đặt ra ba câu hỏi nghiên cứu:

- **RQ1**: Các phương pháp xác định điểm ngàm khác nhau tạo ra mức độ khác biệt như thế nào về độ sâu điểm ngàm tương đương `h_z` và chiều dài tính toán `l_tt`?
- **RQ2**: Sự khác biệt đó ảnh hưởng như thế nào đến chuyển vị ngang của hệ (`U_X`, `U_Y`) và nội lực cọc (mô men `M_max`, lực cắt `V_max`)?
- **RQ3**: Trong số các đại lượng đáp ứng trên, đại lượng nào nhạy nhất với giả thiết điểm ngàm?

Tương ứng, hai mục tiêu nghiên cứu được đặt ra: (1) định lượng sự khác biệt về `h_z` và `l_tt` giữa bốn phương pháp trên cùng một nhóm cọc; và (2) định lượng ảnh hưởng của sự khác biệt đó đến chuyển vị hệ (`U_X`, `U_Y`) và nội lực cọc (`M_max`, `V_max`) trong một mô hình bến cảng 3D thực tế.

Đóng góp của bài báo gồm: (1) xây dựng một thí nghiệm số có kiểm soát trên mô hình bến cảng 3D thực tế, trong đó chỉ duy nhất giả thiết điểm ngàm được thay đổi; (2) so sánh thống nhất bốn phương pháp xác định điểm ngàm phổ biến trong cùng một mô hình kết cấu; (3) tách riêng ảnh hưởng của giả thiết fixity khỏi ảnh hưởng của hình học và tải trọng — hai yếu tố thường bị trộn lẫn trong các so sánh trước đây; (4) định lượng mối liên hệ nhân quả `Method → h_z → l_tt → Structural response`; và (5) cung cấp cơ sở định lượng, dựa trên một công trình thực, cho việc lựa chọn giả thiết điểm ngàm khi mô hình hóa bến cảng trên nền cọc.

Phạm vi bài báo giới hạn ở việc lượng hóa độ nhạy của đáp ứng kết cấu đối với phương pháp xác định điểm ngàm; bài báo không đề xuất phương pháp xác định điểm ngàm mới, không thực hiện tối ưu hóa kết cấu, và không mở rộng sang phân tích tương tác đất–cọc phi tuyến kiểu p–y hay mô hình hóa bằng phần mềm địa kỹ thuật chuyên dụng.

---

## 2. Công trình nghiên cứu và mô hình số

### 2.1. Công trình và phạm vi mô hình

Công trình nghiên cứu là cầu tàu 100.000 DWT thuộc Dự án đầu tư xây dựng cảng cửa ngõ quốc tế Hải Phòng (Lạch Huyện), Hợp phần B, gói thầu thiết kế XL01. Cầu tàu có tổng chiều dài tuyến bến 750 m, được chia thành 10 phân đoạn thi công/tính toán, mỗi phân đoạn dài khoảng 75 m.

**Mô hình số 3D sử dụng trong nghiên cứu này đại diện cho một phân đoạn tiêu chuẩn (~75 m) trong số 10 phân đoạn nêu trên, không phải toàn bộ tuyến bến 750 m.** Việc chọn một phân đoạn tiêu chuẩn làm đơn vị phân tích là phù hợp vì: (i) các phân đoạn có cấu tạo hình học, hệ cọc và tải trọng thiết kế tương tự nhau theo hồ sơ thiết kế; (ii) đây là quy mô mô hình FEM 3D chi tiết duy nhất hiện có của công trình; và (iii) mục tiêu của nghiên cứu là lượng hóa độ nhạy của đáp ứng kết cấu đối với giả thiết điểm ngàm — một hiện tượng cục bộ ở cấp độ cọc và cấp độ phân đoạn, không đòi hỏi mô hình toàn tuyến.

Kết cấu bến là dạng bến liền bờ, bệ cọc cao, đài mềm (hệ dầm – bản bê tông cốt thép trên hệ cọc). Bảng 1 tổng hợp các thông số chính của phân đoạn mô hình.

**Bảng 1. Thông số chính của mô hình một phân đoạn tiêu chuẩn bến 100.000 DWT**

| Thông số | Giá trị |
|---|---|
| Phạm vi mô hình | Một phân đoạn tiêu chuẩn, dài ~75 m (1/10 tuyến bến 750 m) |
| Loại kết cấu | Bến liền bờ, bệ cọc cao, đài mềm |
| Chiều rộng mặt cầu | 50 m |
| Cao trình đỉnh bến | +5,50 m (Hải đồ) |
| Cao trình đáy bến (hoàn thiện) | −16,0 m (Hải đồ) |
| Tổng số cọc của phân đoạn | 192 (132 cọc BTCT DƯL D800 + 60 cọc thép D1016) |
| Số cọc thuộc nhóm khảo sát điểm ngàm (treatment) | 178 (132 BTCT DƯL + 46 thép) |
| Số cọc giữ nguyên điều kiện biên (control) | 14 (thép, ngàm sâu vào lớp đá) |
| Module lưới cọc dọc bến | 5,1 m |
| Độ xiên cọc | 6:1 (đa số); hàng cọc thép biên ngoài cùng 7:1 theo hồ sơ thiết kế |
| Vật liệu bê tông dầm/bản | M400 |
| Vật liệu bê tông cọc BTCT DƯL | M800 |
| Vật liệu cọc thép | Thép ống D1016×16, Fy = 3.150 kG/cm² (theo hồ sơ thiết kế) |
| Phần mềm phân tích | SAP2000 v14.1.0, đơn vị Tonf–m–°C |
| Quy mô lưới phần tử hữu hạn | 4.913 nút; 1.734 phần tử thanh; 4.488 phần tử tấm vỏ |

*Nguồn: Thuyết minh thiết kế kỹ thuật gói thầu XL01 (Thuyet minh 06.12.doc); mô hình SAP2000 gốc (Ben 100.000DWT KT.s2k); bản vẽ thiết kế.*

### 2.2. Hệ cọc và điều kiện biên trong mô hình gốc

Trong 192 cọc của phân đoạn, 178 chân cọc (132 BTCT DƯL + 46 thép) được gán lò xo đất theo phương dọc trục cọc trong mô hình gốc (`JOINT SPRING ASSIGNMENTS`, phương local U3); đây là nhóm cọc được sử dụng để khảo sát ảnh hưởng của phương pháp xác định điểm ngàm trong nghiên cứu này. 14 chân cọc còn lại (thuộc nhóm cọc thép) được ngàm cứng trong mô hình gốc, tương ứng các vị trí cọc khoan ngàm sâu vào lớp đá gốc; nhóm này được giữ nguyên điều kiện biên trong toàn bộ bốn mô hình sensitivity, đóng vai trò nhóm kiểm soát (control group) để đảm bảo sự khác biệt quan sát được giữa các mô hình chỉ đến từ nhóm cọc khảo sát.

### 2.3. Địa chất đầu vào

Theo triết lý thí nghiệm có kiểm soát của nghiên cứu (mục 4.1), toàn bộ 178 cọc khảo sát sử dụng **một bộ thông số địa chất đại diện chung**, không mapping riêng theo vị trí từng cọc, để đảm bảo chỉ phương pháp xác định điểm ngàm là biến thay đổi giữa bốn mô hình. Bảng 2 trình bày các lớp đất chính được sử dụng, trích từ hồ sơ khảo sát địa chất của dự án (38 lỗ khoan).

**Bảng 2. Thông số địa chất đại diện dùng cho tính toán điểm ngàm**

| Lớp | Mô tả | γ (g/cm³) | Δ | e | C (kG/cm²) | φ |
|---|---|---:|---:|---:|---:|---:|
| 2 | Sét xám nâu kẹp cát, trạng thái chảy | 1,71 | 2,68 | 1,362 | 0,069 | 5°53′ |
| 7 | Sét pha xám nâu, dẻo mềm | 1,94 | 2,70 | 0,779 | 0,225 | 13°21′ |
| 8 | Sét xám nâu, dẻo cứng | 2,04 | 2,70 | 0,583 | 0,20 | 18°10′ |
| 9 | Sét xám xanh, dẻo chảy | 1,76 | 2,70 | 1,204 | 0,117 | 7°26′ |
| 10 | Đá sét kết phong hóa hoàn toàn | 2,51 | 2,74 | — | r_N(khô)=129 kG/cm² | — |

*Nguồn: Thuyết minh thiết kế kỹ thuật, mục II.3 (38 lỗ khoan).*

**Lựa chọn lớp đất đại diện theo từng nhóm công thức — ĐÃ KHÓA (22/08/2026):**

- **M2, M3, M6** (nhóm công thức dùng hệ số tỷ lệ `K`/`k`/`K_h`, đặc trưng cho phản ứng đàn hồi tổng thể của đất dọc thân cọc): dùng **Lớp 2** (sét dẻo chảy, yếu, chiều dày lớn, phân bố rộng — lớp chi phối gần mặt đất nhất theo hồ sơ địa chất).
- **M1** (nhóm công thức hình học mái dốc, `m_λ`, `m_θ`, cần góc ma sát trong `φ` của **vật liệu mặt mái dốc**, không phải đất yếu sâu dưới mũi cọc): dùng **Lớp 8** (sét dẻo cứng). Lý do: với góc nghiêng mái dốc thực tế của mô hình (`θ ≈ 18,5°`, từ phương trình `z_s≈−0,335Y−7,84`), công thức (5)–(6) trong §3.2 chỉ cho kết quả toán học hợp lệ (`Z>0`) khi `φ` của vật liệu đủ gần hoặc lớn hơn `θ` — Lớp 2 (`φ≈5,9°`) và Lớp 7 (`φ≈13,4°`) đều cho `Z<0` (vô nghĩa); chỉ Lớp 8 (`φ≈18,2°`) thỏa điều kiện này, dù ở mức rất sát ngưỡng.

**🔶 Phát hiện cần lưu ý:** ngay cả với Lớp 8, tỷ số `m_λ/m_θ ≈ 6,7 > 1`, khiến **Case 4** (lực hướng vào bờ, công thức `h_gđ=h_z√(1−m_λ/m_θ)`) **vô nghĩa toán học** (căn số âm) cho toàn bộ 178 cọc — không phải lỗi tính, mà là giới hạn áp dụng thực sự của công thức 22TCN 207-92 với tổ hợp góc mái dốc/góc ma sát trong của công trình này. Trong tính toán, Case 4 được loại khỏi tập case bất lợi (không lấy giá trị 0 thay thế); `h_z`/`l_tt` theo M1 chỉ lấy governing giữa Case 1 và Case 2.

### 2.4. Tải trọng và tổ hợp tải trọng

Mô hình gốc bao gồm 11 load pattern (tĩnh tải bản thân, lực va tàu, lực neo tàu theo hai kịch bản, tải trọng môi trường, tải trọng hàng hóa khai thác theo 6 kịch bản vị trí chất tải, và tải trọng cần trục theo các trạng thái làm việc/bão) và 36 tổ hợp tải trọng (`COMB1`…`COMB8.4`), cùng một tổ hợp bao (envelope) được đặt tên **`BAO KT`**. Toàn bộ load pattern và load combination được giữ nguyên, không thay đổi giữa bốn mô hình sensitivity — chỉ điểm ngàm của 178 cọc khảo sát thay đổi.

`BAO KT` (`ComboType = Envelope`) bao trùm toàn bộ các tổ hợp tải trọng chính của mô hình (COMB1, COMB2, COMB3.1–3.6, COMB4.1–4.6, COMB5.1–5.2, COMB6.1–6.12, COMB7.x, …), tương ứng đúng tổ hợp bao mà đơn vị thiết kế gốc đã sử dụng để kiểm tra kết cấu. Đây là **tổ hợp bao không đồng thời** (non-concurrent envelope): mỗi thành phần nội lực (`P`, `V2`, `V3`, `M2`, `M3`) tại mỗi vị trí có thể lấy giá trị cực trị từ các tổ hợp con khác nhau, không nhất thiết cùng một trạng thái tải vật lý. `BAO KT` được chọn làm tổ hợp bao chi phối (governing load envelope) cho toàn bộ thí nghiệm sensitivity của nghiên cứu này, với hai trạng thái Max và Min được khai thác cho cả hai phương X và Y.

---

## 3. Phương pháp xác định điểm ngàm tương đương của cọc

### 3.1. Khái niệm chung

Trong mô hình hóa cọc bến cảng bằng phần tử thanh (frame), tương tác đất–cọc được thay bằng một điểm ngàm tương đương tại độ sâu `h_z` tính từ một cao độ quy chiếu (mặt đất/đáy bến); đoạn cọc từ đỉnh cọc đến điểm ngàm này có chiều dài tính toán `l_tt`, là chiều dài cọc thực tế tham gia vào độ cứng ngang và ổn định của hệ. Sơ đồ khái niệm được trình bày ở Hình 2a.

Bốn phương pháp được xem xét trong nghiên cứu — 22TCN 207-92 (M1); 20TCN21-86/TCXD 205-1998 (M2); TCVN 10304:2014 (M3); phương pháp Nhật Bản (M6) — đều theo nguyên tắc chung nêu trên, nhưng khác nhau về cơ sở lý thuyết, dữ liệu đầu vào (đặc trưng đất, đường kính/độ cứng cọc, cao độ quy chiếu…) và công thức xác định `h_z`. Bảng 3 tổng hợp so sánh bốn phương pháp; công thức chi tiết của từng phương pháp được trình bày trong tài liệu tính toán kèm theo (supplement), không đưa đầy đủ vào thân bài do giới hạn số trang của tạp chí.

**Bảng 3. Tóm tắt bốn phương pháp xác định điểm ngàm tương đương của cọc**

**ĐÃ KHÓA (22/08/2026):** Loại M4 (tiêu chuẩn Nga) và M5 (Budin–Demina) khỏi phạm vi định lượng của Paper 1 — không đủ căn cứ để tính đúng: M4 không có bảng hệ số `K` gốc trong giáo trình tham khảo (chỉ có thể mượn tạm bảng của M2, không đủ tin cậy để công bố số liệu); M5 chỉ có hệ số `β` tra đồ thị (nguồn 1979), không có ảnh đồ thị gốc để số hóa. Giữ nguyên nhãn M1/M2/M3/M6 (không đổi số liên tục) để nhất quán với toàn bộ dữ liệu/script đã tính.

| Phương pháp | Tài liệu/tiêu chuẩn | Dữ liệu đầu vào chính | `h_z`/điểm ngàm | `l_tt` | Ghi chú áp dụng |
|---|---|---|---|---|---|
| M1 | 22TCN 207-92 [1] | Đặc trưng đất (`φ`, `C`, `γ`), cao độ mái dốc/hố đào theo hướng lực (`h_gđ`, theo Case), lớp đá đổ (`h_đ`) | `h_z = 0,82h'_z + Δh_z` (lặp, ngàm cứng) | `l = H0 ± h_gđ + h_z` | Tính lặp, hội tụ khi sai số ≤ 10%; `h_gđ` theo đúng Case 1/2/4/5 — xem 3.2; xét đầy đủ tải trọng, mái dốc, lớp đá đổ, khoảng cách cọc |
| M2 | 20TCN21-86 [2] / TCXD 205-1998 [3] | Loại đất quanh cọc (Bảng 3.5a), `E_b`, `I`, `b_c` | `α_bd = ⁵√(K·b_c / (E_b·I))` — **không có `γ_c`** | `l_tt = l_0 + 2/α_bd` | Chưa xét tải trọng, mái dốc, lớp đá đổ, khoảng cách cọc [2,3] |
| M3 | TCVN 10304:2014 [4] | Loại đất quanh cọc (Bảng 3.5b), `E`, `I`, `b_p`, `γ_c = 3` (cọc đơn) | `α_bd = ⁵√(k·b_p / (γ_c·E·I))` | `l_u = l_0 + 2/α_bd` | Cùng dạng với M2 nhưng **có `γ_c`**; chưa xét tải trọng/mái dốc/lớp đá đổ |
| M6 | Nhật Bản — Technical Standards for Port and Harbour Facilities in Japan, 2002 [5] | Hệ số phản lực ngang nền `K_h = 1,5N` (N/cm³), đường kính/bề rộng cọc `D`, độ cứng chống uốn `EI` | `β = ⁴√(K_h·D / (4·EI))`, cm⁻¹ | `l_tt = l_0 + 1/β` | Không dùng hệ số "2" như M2/M3; dùng hệ số "4" trong `β` và hệ số "1" trong `l_0 + 1/β` |

*Nguồn công thức và trích dẫn: `Giao trinh Cong trinh ben.doc` (PGS.TS. Nguyễn Văn Ngọc [6]), mục 3.3.3–3.3.4, trang 123–130 — đã đối chiếu trực tiếp với ảnh chụp công thức gốc (xem `DOI_CHIEU_CONG_THUC_M1_M6_FINAL.md`), không còn nội dung suy đoán. Số hiệu `[ ]` trong bảng và trong §3.2–3.4 là số thứ tự của bài báo này (xem §Tài liệu tham khảo cuối bài). M4, M5 đã đối chiếu công thức đầy đủ trong file trên nhưng bị loại khỏi Paper 1 vì thiếu số liệu đầu vào đáng tin cậy (xem hộp khóa phạm vi trên).*

**Lưu ý ký hiệu (giữ nguyên theo nguồn, không tự đồng nhất):** M2/M3 dùng chung ký hiệu `α_bd` nhưng khác nhau ở việc có/không có `γ_c` trong mẫu số — **đây là khác biệt quan trọng nhất giữa M2 và M3**, không được áp dụng ngược. Đơn vị của hệ số tỷ lệ (`K`, `k`, `K_h`) khác nhau giữa các phương pháp (t/m⁴, kN/m⁴, N/cm³...) — phải quy đổi về hệ đơn vị nhất quán trước khi tính số, không tự thay đổi đơn vị nguồn.

### 3.2. M1 — 22TCN 207-92

Chiều dài tính toán của cọc trong khung:

`l = H0 ± h_gđ + h_z` (1)

trong đó `H0` là khoảng cách từ trọng tâm mặt cắt ngang dầm đến giao điểm giữa đường mái dốc với tim cọc; `h_gđ` là chiều cao hiệu chỉnh từ giao điểm mái dốc–tim cọc đến mặt phẳng nằm ngang giả định, phụ thuộc Case; `h_z` là độ sâu điểm ngàm giả định. Dấu lấy "+" khi lực ngang hướng ra khu nước hoặc dọc mép bến, lấy "−" khi lực ngang hướng vào bờ.

**Xác định `h_gđ` theo Case — quy tắc chọn Case đã khóa ở mục 4.1 (theo vị trí/hướng hình học của cọc, độc lập với tổ hợp tải cụ thể, để tránh vòng lặp logic input↔kết quả):**

- **Case 1** (lực `P` vuông góc mép bến, hướng ra khu nước): `h_gđ = h_z(√(m_λ/m_θ) − 1)` (2)
- **Case 2** (lực `P` dọc mép bến): `h_gđ = 0,5·h_z(√(m_λ/m_θ) − 1)` (3)
- **Case 4** (lực `P` vuông góc mép bến, hướng vào bờ): `h_gđ = h_z·√(1 − m_λ/m_θ)` (4)
- **Case 5** (cọc gần đỉnh mái dốc, lực hướng vào bờ): xác định qua `Z = sinφ·sin(φ+θ_p)/cosθ_p` trước, sau đó tính theo trình tự riêng của nguồn.
- **Case 3** (cọc gần mái dốc, lực hướng ra khu nước, mặt phẳng giả định thấp hơn đáy bến): không có công thức riêng được đánh số trong nguồn — `h_z` khi đó đặt từ cao trình đáy bến.

trong đó `m_θ = cos²φ·[1/(1−√Z)² − 1/(1+√Z)²]` (5), với `Z = sinφ·sin(φ−θ_p)/cosθ_p` (6) và `θ_p = θ·cosφ` (7) (`θ` = góc nghiêng mái dốc, `φ` = góc ma sát trong của đất); `m_λ = tan²(45°+0,5φ) − tan²(45°−0,5φ)` (8).

Với 178 cọc của nghiên cứu này (đã phân loại hình học ở mục 2.2, đều thuộc diện "cọc trên mái dốc"), chỉ Case 1/2/4 được áp dụng — Case 3, 5 không phù hợp với phân loại hình học đã khóa.

**Xác định `h_z` theo điều kiện liên kết cọc–bệ:** với ngàm tuyệt đối cứng (giả thiết dùng trong nghiên cứu này — xem mục 2.2):

`h_z = 0,82·h'_z + Δh_z` (9)

hội tụ khi chênh lệch hai lần lặp liên tiếp ≤ 10%; `Δh_z = 0,8` m khi trên mặt không có lớp đá đổ và đất bề mặt là đất tơi/bị bào xói; và:

`h'_z = √( 2k_n·n_c·n·m_d·P / (γ^tc·m_λ·D·m_n) + C_0² ) − C_0` (10)

với `k_n` = hệ số đảm bảo (1,25/1,20/1,15/1,10 cho công trình cấp I/II/III/IV); `n_c` = hệ số tổ hợp tải trọng (1,0 cơ bản; 0,9 đặc biệt; 0,95 thi công); `n = 1,25` (hệ số vượt tải, công trình bến cảng biển); `m_d = 1,15`; `P` = lực ngang tác động lên cọc; `γ^tc` = dung trọng đất; `D` = đường kính ngoài cọc (hoặc cạnh, theo hướng vuông góc lực); `m_n = 1 + 0,0417·[8h_z³−(2h_z+D−L)³]/(D·h_z²)` khi `L ≤ 2h_z+D`, hoặc `m_n = 1 + h_z/(3D)` khi `L > 2h_z+D` (`L` = khoảng cách tim–tim cọc theo hướng dọc); `C_0 = C/(m_n·γ^tc·tanφ)` (`C` = lực dính đơn vị của đất).

Khi mặt đất được gia cố bằng lớp đá đổ (bề dày `h_k`), thay bằng `l = H0 − h_đ + h_gđ + h_z`, với `h_đ` xác định riêng cho trường hợp đáy nằm ngang/mái dốc theo tỷ số dung trọng đá/đất.

### 3.3. M2, M3 — nhóm phương pháp theo hệ số biến dạng

M2, M3 cùng coi cọc là dầm trên nền đàn hồi (Winkler), dùng dạng chung `l_tt = l_0 + 2/α_bd`, nhưng **khác nhau ở việc có/không có `γ_c` trong hệ số biến dạng**:

- **M2**: `l_tt = l_0 + 2/α_bd`, với `α_bd = ⁵√(K·b_c / (E_b·I))` — **không có `γ_c`**.
- **M3**: `l_u = l_0 + 2/α_bd`, với `α_bd = ⁵√(k·b_p / (γ_c·E·I))`, `γ_c = 3` cho cọc đơn.

`K`/`k` là hệ số tỷ lệ tra bảng theo loại đất (Bảng 3.5a cho M2, đơn vị t/m⁴; Bảng 3.5b cho M3, đơn vị kN/m⁴); `E`, `I` là mô đun đàn hồi và mô men quán tính tiết diện cọc; `b_c`/`b_p` là chiều rộng quy ước của cọc, lấy `b = d + 1,0` m khi `d ≥ 0,8` m hoặc `b = 1,5d + 0,5` m khi `d < 0,8` m; `l_0` là chiều dài đoạn cọc từ đáy đài đến mặt đất/cao độ san nền. Riêng M2 có thêm điều kiện: nếu `2/α_bd > l` (với `l` là độ sâu hạ cọc nhồi/cọc ống/cọc trụ) thì lấy `l_tt = l_0 + l`.

M2 và M3 đều **chưa xét đến** tải trọng ngang thực tế, mái dốc đất, lớp đá bảo vệ mái, và khoảng cách giữa các cọc trong nền cọc [2,3] — khác với M1 có xét đầy đủ các yếu tố này.

*(M4 — tiêu chuẩn Nga — và M5 — Budin–Demina — đã được đối chiếu công thức đầy đủ trong `DOI_CHIEU_CONG_THUC_M1_M6_FINAL.md` nhưng bị loại khỏi Paper 1 vì thiếu số liệu đầu vào đáng tin cậy — xem hộp khóa phạm vi ở Bảng 3.)*

### 3.4. M6 — Phương pháp Nhật Bản [5]

`β = ⁴√(K_h·D / (4·EI))`, cm⁻¹ (11)

với `K_h = 1,5·N` (N/cm³, `N` = giá trị SPT trung bình của đất đến độ sâu `1/β`), `D` = đường kính/bề rộng cọc (cm), `EI` = độ cứng chống uốn của cọc (N·cm²). Chiều dài tính toán:

`l_tt = l_0 + 1/β` (12)

M6 giữ nguyên hệ số "4" trong (11) và hệ số "1" (không phải "2") trong (12) — không được chuyển về dạng `l_0 + 2/β`.

### 3.5. Nhận xét chung của nguồn tài liệu

Giáo trình nguồn nhận xét: trong bốn phương pháp, chỉ 22TCN 207-92 (M1) xét khá đầy đủ các yếu tố tải trọng, mái dốc đất, lớp đá đổ, điều kiện địa chất, kích thước/vật liệu cọc và khoảng cách cọc trong nền cọc; các phương pháp còn lại (M2, M3) chủ yếu chỉ xét điều kiện địa chất, vật liệu và kích thước cọc. Nhận xét này được trích dẫn để làm rõ bối cảnh lý thuyết của bốn phương pháp, **không được dùng để kết luận trước phương pháp nào "đúng hơn"** trong phạm vi bài báo này — đây chính là điều nghiên cứu cần lượng hóa bằng thực nghiệm số, không giả định trước.

---

## 4. Thiết kế thí nghiệm số

### 4.1. Triết lý thí nghiệm có kiểm soát

```text
MASTER model (Master model gốc: hình học, vật liệu, tải trọng, điều kiện biên gốc)
        ↓
Bốn định nghĩa điểm ngàm thay thế (M1/M2/M3/M6), áp dụng cho 178 cọc khảo sát
        ↓
Bốn mô hình sensitivity (BASE + M1/M2/M3/M6), mọi yếu tố khác giữ nguyên
```

### 4.2. Ma trận thí nghiệm

**Bảng 4. Ma trận thí nghiệm số có kiểm soát**

| Model | Phương pháp fixity | Số cọc treatment (thay đổi fixity) | Số cọc control (giữ nguyên) | Hình học | Vật liệu | Tải trọng |
|---|---|---:|---:|---|---|---|
| BASE | Điều kiện biên gốc (lò xo đất mô hình gốc) | — | 192 | Không đổi | Không đổi | Không đổi |
| M1 | 22TCN 207-92 | 178 | 14 | Không đổi | Không đổi | Không đổi |
| M2 | 20TCN21-86 / TCXD 205-1998 | 178 | 14 | Không đổi | Không đổi | Không đổi |
| M3 | TCVN 10304:2014 | 178 | 14 | Không đổi | Không đổi | Không đổi |
| M6 | Phương pháp Nhật Bản | 178 | 14 | Không đổi | Không đổi | Không đổi |

### 4.3. Tổ hợp tải trọng chi phối

Toàn bộ đánh giá sensitivity sử dụng tổ hợp bao `BAO KT` (hai trạng thái Max/Min), phân tích đáp ứng theo cả hai phương X và Y từ cùng một tổ hợp bao. Không tạo tổ hợp tải trọng nhân tạo riêng cho mục đích sensitivity.

### 4.4. Đại lượng đáp ứng

- **Đáp ứng toàn hệ**: chuyển vị ngang `U_X`, `U_Y` tại đỉnh bến.
- **Đáp ứng cọc**: mô men lớn nhất `M_max`, lực cắt lớn nhất `V_max` trong số 178 cọc khảo sát. Lực dọc trục `N` có thể báo cáo như đại lượng phụ nếu cần, không phải mục tiêu chính.

### 4.5. Chỉ số độ nhạy

`S_R = (|R_max| − |R_min|) / |R_min| × 100%` (13)

trong đó `R` là đại lượng đáp ứng cần đánh giá (`U_X`, `U_Y`, `M_max`, hoặc `V_max`), luôn lấy theo trị tuyệt đối để đảm bảo `S_R` có ý nghĩa vật lý rõ ràng.

---

## 5. Kết quả và thảo luận

🔶 **[TỪNG PHẦN]** Mục 5.1 (biến thiên `h_z`/`l_tt`) đã có số liệu thật — không cần chạy lại SAP, chỉ cần công thức + input hình học/tải trọng đã có. Mục 5.2–5.4 (đáp ứng kết cấu `U_X`/`U_Y`/`M_max`/`V_max`, độ nhạy `S_R`) **vẫn chưa thể viết**, chờ dựng 4 mô hình SAP2000 sensitivity và chạy phân tích — đúng nguyên tắc đã khóa.

### 5.1. Biến thiên của điểm ngàm tương đương và chiều dài tính toán

Chiều dài tính toán `l_tt` được tính cho 178 cọc theo cả 4 phương pháp trong phạm vi Paper 1 (M1, M2, M3, M6).

**Bảng 5. Thống kê chiều dài tính toán `l_tt` (m) cho 178 cọc theo 4 phương pháp**

| Phương pháp | Min | Max | Mean | Median | SD |
|---|---:|---:|---:|---:|---:|
| M1 (22TCN 207-92) | 6,85 | 23,91 | 16,33 | 17,29 | 5,30 |
| M2 (20TCN21-86/TCXD 205-1998) | 10,69 | 26,43 | 18,65 | 19,57 | 4,92 |
| M3 (TCVN 10304:2014) | 8,17 | 23,92 | 16,03 | 16,69 | 4,94 |
| M6 (Nhật Bản, 2002) | 9,86 | 25,61 | 17,79 | 18,64 | 4,92 |
| *(tham chiếu)* Chiều dài mô hình FEM gốc | 20,23 | 28,71 | 24,54 | 24,78 | 2,68 |

*Hình 3 (dự kiến): biểu đồ hộp (boxplot) `l_tt` theo 4 phương pháp, chồng với dải chiều dài FEM gốc để đối chiếu trực quan.*

### Nhận xét ban đầu (chỉ về `h_z`/`l_tt`, chưa liên quan đáp ứng kết cấu)

- Cả 4 phương pháp đều cho `l_tt` **trung bình thấp hơn** chiều dài mô hình FEM gốc (24,54 m) — nghĩa là nếu áp dụng đúng theo công thức, điểm ngàm tương đương nằm **cao hơn** (nông hơn) so với giả thiết ngàm hiện tại của Master model. M2 cho `l_tt` gần chiều dài FEM gốc nhất (mean 18,65 m); M1 và M3 cho `l_tt` ngắn nhất.
- Độ phân tán (SD ≈ 4,9–5,3 m) tương đương nhau giữa các phương pháp, phản ánh cùng một nguồn biến thiên hình học/tải trọng giữa các cọc (không phải do phương pháp gây phân tán khác nhau).
- **Case 4 của M1 vô nghĩa toán học** với bộ dữ liệu góc mái dốc/góc ma sát trong hiện có (xem §2.3) — M1 trong bảng trên chỉ phản ánh governing giữa Case 1 và Case 2.

*(Dữ liệu chi tiết 178 dòng: `pile_hz_ltt_results_ALL.csv`, không đưa vào bài chính theo quy định giới hạn trang — xem §19 lưu ý bảng.)*

### 5.2. Độ nhạy của đáp ứng kết cấu (chuyển vị và nội lực cọc)

*(Hình 4; Bảng 6 — `U_X`, `U_Y`, `M_max`, `V_max` và `S_R` cho BASE và M1–M6.)*

### 5.3. Phân bố không gian của độ nhạy và chuỗi nhân quả

*(Vùng cọc nhạy/ít nhạy theo mặt bằng; tương quan `h_z`–`U`, `h_z`–`M`, `l_tt`–`M`, `l_tt`–`V` nếu dữ liệu cho phép.)*

### 5.4. Xếp hạng độ nhạy và hàm ý kỹ thuật

*(Xếp hạng `U_X`, `U_Y`, `M_max`, `V_max` theo mức độ nhạy; thảo luận hàm ý đối với việc lựa chọn giả thiết điểm ngàm trong mô hình hóa bến cảng 3D.)*

---

## 6. Kết luận

🔶 **[CHƯA THỂ VIẾT — CẦN KẾT QUẢ CHẠY SAU]** Dự kiến 4–6 kết luận, theo khung:

- C1 — mức khác biệt về `h_z` giữa 6 phương pháp;
- C2 — mức khác biệt về `l_tt`;
- C3 — ảnh hưởng đến `U_X`, `U_Y`;
- C4 — ảnh hưởng đến `M_max`, `V_max`;
- C5 — đại lượng đáp ứng nhạy nhất;
- C6 — hàm ý đối với mô hình hóa bến cảng trên nền cọc.

---

## Tài liệu tham khảo

*Đánh số theo thứ tự xuất hiện lần đầu trong bài (quy định JMST §27.3) — thứ tự dưới đây là tạm thời, sẽ sắp lại theo đúng trình tự trích dẫn khi hoàn thiện bản thảo cuối.*

[1] Tiêu chuẩn Ngành 22TCN 207-92 (1992), *Công trình bến cảng biển — Tiêu chuẩn thiết kế*, Hà Nội.

[2] Tiêu chuẩn thiết kế 20TCN 21-86, *Móng cọc*.

[3] Tiêu chuẩn xây dựng TCXD 205-1998, *Móng cọc — Tiêu chuẩn thiết kế*.

[4] Tiêu chuẩn Việt Nam TCVN 10304:2014, *Móng cọc — Tiêu chuẩn thiết kế*. 🔶 *[cần bổ sung năm/nhà xuất bản chuẩn khi hoàn thiện — không nằm trong danh mục tham khảo của giáo trình nguồn]*

[5] Overseas Coastal Area Development Institute of Japan (2002), *Technical Standards and Commentaries for Port and Harbour Facilities in Japan*, Vol. 1+2.

[6] Nguyễn Văn Ngọc, *Công trình bến* (giáo trình), Trường Đại học Hàng hải Việt Nam. 🔶 *[cần năm xuất bản/nhà xuất bản chính xác của bản giáo trình đang dùng]*

[7] Trung tâm Tư vấn Phát triển công nghệ xây dựng Hàng hải (12/2014), *Thuyết minh thiết kế kỹ thuật — Cầu tàu 100.000 DWT, Gói thầu XL01, Cảng cửa ngõ quốc tế Hải Phòng (Lạch Huyện)*.

*(Ghi chú nội bộ: [1]–[4] đúng số cũ. M4/M5 và tài liệu tham khảo riêng của chúng — Nguyễn Văn Ngọc 2005, SNiP 2.02.03-85, Budin–Demina 1979 — đã bị loại khỏi bài theo quyết định 22/08/2026; đánh số [5]/[6]/[7] ở trên đã dịch lại cho đúng, nhưng cần rà lại toàn bộ trích dẫn `[ ]` trong thân bài một lần cuối trước khi nộp để chắc chắn không còn số cũ.)*

> Ngày nhận bài: xx/xx/20xx
>
> Ngày nhận bản sửa: xx/xx/20xx
>
> Ngày duyệt đăng: xx/xx/20xx
