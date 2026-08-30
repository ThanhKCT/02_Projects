# Kinh nghiệm viết & phản biện Paper 1 (SOO-SFOA) — đúc rút để dùng cho bài mới

> Đúc kết sau ~8 vòng phản biện (V1→V8, cả tự phản biện lẫn mô phỏng ChatGPT/Gemini) cho bài
> "Nghiên cứu đánh giá khả năng ứng dụng thuật toán tối ưu sao biển trong bài toán tối ưu đơn
> mục tiêu kết cấu công trình biển" (Tạp chí Xây dựng, 2026). Đọc file này **trước khi bắt đầu
> bài mới** (MOO/MOSFOA) để không lặp lại đúng những lỗi/độ trễ đã gặp ở đây.

---

## 1. Quy trình phản biện nhiều vòng — cái gì hiệu quả

Quy trình đã dùng và nên lặp lại:

```
Draft → Phản biện (tự viết hoặc mô phỏng persona ChatGPT/Gemini)
      → Claude xác minh từng claim bằng CODE THẬT/DATA THẬT (không suy đoán)
      → Sửa đúng phạm vi reviewer chỉ ra (không mở rộng nghiên cứu)
      → Rebuild docx, grep lại toàn bộ để confirm sạch
      → Gửi lại cho vòng phản biện tiếp theo
```

Ba vai trò phản biện tách biệt hoạt động tốt hơn một phản biện chung chung:
- **Reviewer A (kiểu ChatGPT)**: METHOD → LOGIC → EVIDENCE → CLAIM → RESEARCH POSITIONING. Không đi sâu tiêu chuẩn kỹ thuật.
- **Reviewer B (kiểu Gemini)**: kỹ thuật kết cấu thuần túy — FEM, tải trọng, constraint, đơn vị, tiêu chuẩn. Không bàn văn phong.
- **Claude = tác giả + revision editor**: phân loại comment thành CONFIRMED / NEEDS VERIFICATION / OPTIONAL / NOT ADOPTED, không tự động sửa theo mọi ý kiến, không chọn theo "đa số" khi hai reviewer bất đồng.

**Nguyên tắc sống còn xuyên suốt cả 8 vòng**: *"Không tự bịa dữ liệu. Nếu cần kiểm tra
SAP2000/MATLAB/TCVN mà không có dữ liệu, phải ghi 'CẦN TÁC GIẢ XÁC MINH', không suy đoán."*
Nguyên tắc này chỉ có giá trị nếu **thực sự dừng lại và verify**, không phải nói suông — xem mục 2.

---

## 2. Những lỗi thật đã bắt được nhờ verify bằng code/data — không phải suy đoán

Đây là danh sách các phát hiện **chỉ lộ ra khi mở code/data thật**, không thể đoán được từ đọc
manuscript. Bài học chung: **luôn grep/đọc trực tiếp file .m và file .mat gốc trước khi viết bất
kỳ câu mô tả phương pháp nào — kể cả khi nó "nghe có vẻ đúng".**

| # | Điều tưởng đúng ban đầu | Sự thật sau khi mở code/data | Cách phát hiện |
|---|---|---|---|
| 1 | Bảng đơn giá cọc lấy từ `Bang_don_gia_coc_ly_tam.xlsx` | Code thực tế đọc giá từ `X1_X2.mat` ← `Prestress_Pile_TCVN7888_2014.xlsx` — file kia **không hề được gọi** trong `SOO_MPJ_run.m` | `grep` tên file trong toàn bộ `code/SOO_MPJ/*.m` |
| 2 | CV=0% nghĩa là 30 lần chạy ra đúng 1 vector thiết kế | 25/30 ra đúng 1200-C, 4/30 và 1/30 ra 2 loại cọc khác — cùng span/dầm, cùng D_max do objective bị *plateau* | Load 30 file `.mat` bằng Python (`scipy.io.loadmat`), so `BestX` từng run, không chỉ so `BestRaw` |
| 3 | Ràng buộc nén/nhổ dùng đúng theo TCVN | Code chỉ tính 1 giá trị `N_p` (nén, gồm ma sát+mũi) dùng chung cho cả nén và nhổ; `Nk_p` (nhổ, chỉ ma sát) được tính ra rồi **bỏ không dùng** | Đọc từng dòng `pile_bearing_capacity.m` + `Sap_MPJ.m` |
| 4 | Penalty P(x) hợp lý về mặt thứ nguyên | `g1` (kN·m) + `g2` (kN) cộng trực tiếp, λ=10⁶ cộng y hệt vào Cost (USD) và Displacement (m) — không normalize ở bất kỳ đâu | `grep "normali\|scale\|/Mcr\|/N_p"` toàn bộ thư mục code — 0 kết quả liên quan |
| 5 | DesignConcrete dùng tiêu chuẩn bê tông phù hợp (ngầm hiểu TCVN) | Model SAP2000 gán **CSA A23.3-14 (Canada)**, không phải TCVN 5574 | Đọc trực tiếp `TABLE: "PREFERENCES - CONCRETE DESIGN - ..."` trong file `.$2k` |
| 6 | TCVN 10304:2014 là bản hiện hành | Đã bị thay bằng **TCVN 10304:2025** (Bộ Xây dựng, 7/2025), đổi hẳn phương pháp (hệ số an toàn → trạng thái giới hạn) | WebSearch — không thể biết nếu chỉ dựa vào training data |
| 7 | Giá cọc USD đã sẵn trong catalog, không cần hỏi thêm | Giá gốc là VNĐ, quy đổi ở tỷ giá **23.500 VNĐ/USD** — suy ngược chính xác từ số liệu (`VNĐ / USD = 23500.00` khớp mọi dòng) | Chia thử `cột_VNĐ / cột_USD` trên vài dòng catalog bằng Python |
| 8 | "Tăng 2.542,2%" ⇒ "tăng 25,4 lần" | Tăng X% nghĩa là **nhân (1+X/100)**, không phải nhân X. 2.542,2% ⇒ ×26,42, không phải ×25,4 — lỗi này **sống sót qua 4 vòng sửa liên tiếp** | Tính lại bằng Python (`Decimal`, không tính nhẩm) mỗi khi có tỷ lệ % và "lần" xuất hiện cùng câu |
| 9 | `VerifyPassed`/`VerifySections` của dầm chắc đã "ổn" vì DesignConcrete có chạy | Không giá trị nào trong 2 hàm này được lưu vào diagnostic/log suốt 60 run — phải viết script hậu kiểm riêng, chạy thật trên máy có SAP2000 mới biết | Bản sao `Sap_MPJ_VerifyBeam.m` (không sửa file gốc), chạy qua `matlab -batch` |

**Bài học tổng quát**: mọi câu trong bài dạng "X được tính theo TCVN Y" / "Z được lấy từ file
W" / "hệ số λ đủ lớn" đều là **claim cần bằng chứng dòng-code cụ thể**, không phải điều hiển
nhiên. Thói quen đúng: trước khi viết câu mô tả, tự hỏi "dòng code nào chứng minh câu này?", rồi
`Grep`/`Read` đúng dòng đó trước khi gõ.

---

## 3. Kỹ thuật hữu ích: viết bản sao instrument hóa thay vì sửa code gốc

Khi cần trả lời một câu hỏi thực nghiệm mà campaign đã chạy không lưu lại (ví dụ
`VerifyPassed`/`VerifySections` của dầm), **không sửa file `.m` đang dùng cho kết quả đã công
bố**. Thay vào đó:

1. `cp Sap_MPJ.m Sap_MPJ_VerifyBeam.m`
2. Thêm output/instrumentation cần thiết vào bản sao (ví dụ thêm output thứ 3, thêm `fprintf`)
3. Chạy bản sao trên **đúng 1-2 vector thiết kế đã biết kết quả** (đối chiếu Cost/Displacement
   khớp số liệu đã báo cáo) để chắc chắn không chạy nhầm cấu hình
4. Không bao giờ suy diễn kết quả — nếu môi trường không có SAP2000/MATLAB, phải nói rõ và đưa
   script cho người dùng tự chạy (kèm hướng dẫn `addpath`/`cd` chính xác dựa trên cách
   `SOO_MPJ_run.m` gốc tự thiết lập path)

File `Sap_MPJ_VerifyBeam.m` và `run_verify_beam.m` hiện **chưa commit git** — cân nhắc commit
nếu muốn giữ làm bằng chứng tái lập cho phản biện tạp chí sau này.

---

## 4. Danh sách từ/cụm dễ bị soi ở một bài SOO đầu tay — chuẩn bị trước, đừng để phản biện bắt từng cái

Qua 8 vòng, các cụm sau **chắc chắn sẽ bị hỏi lại** nếu dùng không cẩn thận. Nên tự rà theo
checklist này **trước khi gửi bản đầu tiên**, thay vì để lộ dần qua từng vòng phản biện:

- "chứng minh", "khẳng định" (trừ dạng phủ định: "không nhằm khẳng định...")
- "tối ưu toàn cục" / "global optimum" — không dùng trừ khi có bằng chứng exact solution
- "vượt trội", "hiệu quả cao", "hiệu quả vượt trội" — không dùng nếu không có benchmark đối chứng
- "độ nhạy" / "sensitivity" — chỉ dùng nếu có sensitivity analysis thật, không dùng cho quan sát tại 2 điểm cực trị
- "xung đột mục tiêu" (conflict) trên toàn không gian thiết kế — chỉ nói "đánh đổi tại hai nghiệm cực trị"
- "hội tụ tuyệt đối" — phân biệt "đường Best-so-far ổn định trong vùng quan sát được" (hội tụ số) với "30 lần chạy giống hệt nhau" (không đúng nếu chỉ CV=0% ở giá trị mục tiêu)
- "thỏa mọi ràng buộc" — luôn ghi rõ **ràng buộc nào** (đã triển khai trong optimization) vs **yêu cầu nào** (chỉ hậu kiểm, không phải constraint)
- "kiểm chứng framework/kết quả" — "kiểm chứng" ngụ ý có reference/ground-truth đối chứng độc lập; nếu không có, dùng "xây dựng và đánh giá"
- "nghiệm tối ưu" khi nói về MỘT giải pháp cụ thể tìm được — đổi thành "nghiệm tốt nhất tìm được theo mục tiêu X" trừ khi đang dùng như **tên case** (MJP-C, cost-optimal là nhãn, được phép giữ)
- "an toàn theo TCVN" / "đạt giới hạn cho phép" — chỉ được nói nếu ràng buộc đó **thực sự có trong hệ constraint đang tối ưu**, không phải nhận xét định tính bên ngoài
- Mọi câu "tăng X%" đi kèm "Y lần" trong cùng câu — **luôn tính lại bằng code**, đừng suy luận nhẩm

---

## 5. Cạm bẫy số học cụ thể — luôn tính lại bằng script, không nhẩm

```
tăng X%  ⇔  giá trị mới = giá trị cũ × (1 + X/100)
                                        ^^^^^^^^^^^^ đây mới là "số lần", KHÔNG PHẢI X/100 hay X
```
Ví dụ thật đã sai suốt 4 vòng: ΔC = 2.542,2% bị diễn giải nhầm thành "25,4 lần" (lấy đúng phần
2542,2/100 = 25,42 rồi quên +1). Số lần đúng = 1 + 25,42 = 26,42 ≈ **26,4 lần**.

Luôn verify bằng:
```python
from decimal import Decimal
ratio = Decimal(new) / Decimal(old)
pct   = (Decimal(new) - Decimal(old)) / Decimal(old) * 100
```
dùng **giá trị full-precision từ file `.mat`/kết quả gốc**, không dùng số đã làm tròn hiển thị
trong bảng (chênh lệch làm tròn có thể tạo ra sai số nhỏ tích lũy — ví dụ 2.542,2% vs 2.542,4%
tính từ full-precision, chấp nhận được vì rất nhỏ, nhưng phải biết là có sai số đó, không phải
giả vờ khớp tuyệt đối).

---

## 6. Quy tắc "tường lửa thông tin" giữa hai bài trong cùng chuỗi nghiên cứu

Paper 1 (SOO) phải xuất bản **trước** Paper 2 (MOO/MOSFOA), và Paper 2 hiện đã có mã số bản thảo
thật (STBU-2026-159, đang phản biện vòng 2) nhưng **Paper 1 tuyệt đối không được nhắc đến nó**,
kể cả gián tiếp. Việc này tốn nhiều vòng sửa vì bị phát hiện dần:

- Xóa toàn bộ citation `[2]` trỏ tới bài kia
- Xóa mọi nhắc đến "MOO nền", "bài MOO trước", ba hệ kết cấu BD/MD/MJP cùng lúc — Paper 1 chỉ
  được nói về MJP như một đối tượng độc lập, không phải "một trong ba hệ đã khảo sát ở bài khác"
- Viết lại toàn bộ baseline/danh mục cọc thành tự-đứng-vững (self-contained), không dựa vào
  "đối chiếu với bài kia" để validate
- Softening cách nói về MOSFOA: không phải "bước tiếp theo đã có sẵn", mà "hướng phát triển
  trong tương lai, hiện chưa được xây dựng"

**Bài học cho lần sau**: nếu biết trước sẽ có 2 bài trong 1 chuỗi, **thiết lập tường lửa thông
tin ngay từ bản draft đầu tiên** (checklist: không citation chéo, không nhắc tên hệ kết cấu của
bài kia, không dùng dữ liệu "đối chiếu" bài kia để validate) thay vì phát hiện và gỡ dần qua
nhiều vòng.

---

## 7. Quy cách trình bày tạp chí — chốt trước, đừng để sửa cuối

Từ `Quy cach bai bao khoa hoc-TCXD.docx`, các điểm hay bị quên/làm sai lúc đầu:

- ĐẶT VẤN ĐỀ và KẾT LUẬN phải nằm **trong cùng dãy số** với các mục nội dung khác (1. ĐẶT VẤN ĐỀ
  ... 5. KẾT LUẬN), không để rời số như tiêu đề phụ
- Tít dịch tiếng Anh: **chữ thường (sentence case), không đậm** — theo đúng ví dụ mẫu của tạp
  chí, **không phải Title Case** dù một phản biện AI từng đề xuất Title Case (đã kiểm tra lại
  quy cách gốc và giữ sentence case, ưu tiên quy định gốc hơn gợi ý reviewer khi hai cái mâu thuẫn)
- Số thập phân dùng dấu phẩy, phân cách hàng nghìn dùng dấu chấm (tiếng Việt); ngược lại cho bản
  tiếng Anh
- Không in đậm/nghiêng theo chủ quan trong thân bài — chỉ đậm cho tiêu đề mục, TÓM TẮT/ABSTRACT,
  Từ khóa/Keywords theo đúng quy định
- Trích dẫn không có dấu chấm sau `[n]`; nhiều nguồn trong 1 câu viết `[1, 2]` không viết `[1],[2]`
- Hình/Bảng viết hoa chữ "Hình"/"Bảng" trong toàn bài, không chỉ ở caption

**Bài học**: đọc kỹ file quy cách tạp chí **ngay vòng đầu tiên**, làm 1 pass format-only trước
khi đi vào nội dung khoa học — rẻ hơn nhiều so với sửa rải rác ở vòng 6-8.

---

## 8. Vấn đề kỹ thuật hạ tầng: .md và build_docx.js phải sync tay — dễ lệch

`02_Draft_..._TCXD.md` là bản nháp đọc được, nhưng file **thật sự sinh ra bản nộp** là
`paper/build_docx.js` (dùng `docx` npm package, hard-code toàn bộ nội dung dưới dạng
`P()`/`run()`/`makeTable()`). Mọi chỉnh sửa nội dung phải làm **hai lần** — 1 lần ở `.md`, 1 lần
ở `build_docx.js` — rồi `node build_docx.js` rebuild, rồi `pandoc -t plain` + `grep` để confirm
không còn cụm từ cũ sót lại ở bản build thật (bản `.md` không phải bản nộp, chỉ là tài liệu làm
việc).

**Rủi ro đã gặp**: dễ sửa `.md` mà quên sync `build_docx.js`, hoặc ngược lại. Quy trình an toàn
đã hình thành: sau mỗi vòng sửa, luôn kết thúc bằng:
```bash
node build_docx.js
pandoc -t plain 02_Draft_....docx | grep -inE "<các_cụm_cũ_cần_biến_mất>"
# exit code phải = 1 (không tìm thấy) mới coi là sạch
```

**Đề xuất cho bài mới**: cân nhắc dùng pandoc trực tiếp từ `.md` → `.docx` với reference-doc
template khớp format tạp chí, thay vì duy trì song song 2 nguồn nội dung — giảm hẳn một lớp lỗi
đồng bộ. Nếu vẫn giữ `build_docx.js` (vì cần kiểm soát chi tiết sub/superscript, equation tab-
stop...), nên viết 1 script parse `.md` → gọi các hàm `P()/eq()/makeTable()` tự động thay vì
copy tay từng đoạn.

---

## 9. Tra cứu ngoại vi — luôn WebSearch, không suy đoán từ trí nhớ

Các thông tin **bắt buộc phải tra cứu thật**, không được đoán từ kiến thức nền:
- DOI của mọi citation mới thêm (Deb 2000, Turgut et al. 2023, SFOA gốc) — dùng Semantic Scholar
  API (`api.semanticscholar.org/graph/v1/paper/DOI:...`) khi Springer/ACM chặn bằng auth-wall
- Tình trạng hiệu lực của tiêu chuẩn (TCVN 10304:2025 đã thay thế 2014 — thông tin này **sau**
  knowledge cutoff của model, chỉ có được qua WebSearch)
- Tên/version chính xác của design code SAP2000 gán trong model (`CSA A23.3-14`) — chỉ xác nhận
  được bằng cách đọc trực tiếp `TABLE: "PREFERENCES - CONCRETE DESIGN - ..."` trong file `.$2k`,
  không thể đoán

---

## 10. Checklist khởi động cho bài mới (MOO/MOSFOA)

Trước khi viết dòng đầu tiên của bài mới, làm các việc sau (rút từ toàn bộ kinh nghiệm trên):

- [ ] Đọc lại `Quy cach bai bao khoa hoc-TCXD.docx`, làm sẵn khung format (số mục, sentence-case
      tít tiếng Anh, dấu thập phân...) trước khi viết nội dung
- [ ] Kiểm tra ngay từ đầu: design code thực tế của `DesignConcrete` trong **cả 3 model** BD/MD/MJP
      (khả năng cao cả 3 đều gán CSA A23.3-14 giống MJP — xác nhận bằng cách đọc file `.$2k`
      tương ứng, đừng giả định giống nhau mà không kiểm tra)
- [ ] Kiểm tra nguồn LL/DL của cả BD, MD (không chỉ MJP) — khả năng cao cũng là giả định mô hình
      không trích dẫn tiêu chuẩn, cần công bố minh bạch ngay từ bản đầu
- [ ] Xác nhận lại tỷ giá VNĐ/USD dùng cho từng loại đơn giá (cọc, bê tông, thép) của cả BD/MD —
      khả năng có cùng vấn đề thiếu nhất quán như MJP
- [ ] Vì đây là bài MOO thật (có Pareto front, archive, non-dominated sorting...), chuẩn bị sẵn
      cách diễn đạt đúng mực cho các thuật ngữ MOO tương ứng: "Pareto-optimal" chỉ dùng khi có
      chứng minh non-dominance thật; "hypervolume/GD/IGD tốt hơn" cần chỉ rõ so với baseline nào
- [ ] Vì Paper 1 giờ có thể trích dẫn được (đã hoàn thiện), kiểm tra tình trạng nộp/xuất bản thật
      của Paper 1 trước khi đưa vào reference list của Paper 2 (đừng lặp lại tình trạng "in
      preparation" mơ hồ mà Paper 1 từng bị chính reviewer của nó phê bình đối với bài kia)
- [ ] Dùng lại nguyên bộ 3 prompt persona phản biện (Reviewer A/B + Claude-editor) làm sẵn từ đầu
      thay vì tạo lại
- [ ] Mọi câu "X% ⇔ Y lần" viết ra đều phải kèm 1 lần chạy Python xác minh, không nhẩm
- [ ] Mọi câu "theo TCVN/tiêu chuẩn Z" đều phải trỏ được đến dòng code cụ thể tính theo tiêu
      chuẩn đó — nếu không trỏ được, đừng viết câu đó
