# Ngữ cảnh phiên làm việc — Dự án Cầu tàu 100.000DWT (Lạch Huyện)
### File bàn giao để tiếp tục ở phiên chat mới — cập nhật lần cuối: phiên làm việc ngày hiện tại

---

## 0. Mục tiêu tổng thể của người dùng

Dùng mô hình FEM (SAP2000) của **1 phân đoạn tiêu chuẩn cầu tàu 100.000DWT** để chạy **bài toán tối ưu đa mục tiêu (MOO)** bằng **thuật toán MOO đã có sẵn code MATLAB**, lấy kết quả so sánh để **đăng bài trên tạp chí trong nước**. Đang ở bước chuẩn bị dữ liệu đầu vào + đánh giá tính khả thi tính toán, **chưa viết code ghép nối MATLAB↔SAP2000**.

---

## 1. Thư mục & danh mục file dự án (trên Google Drive, ổ H:)

Thư mục gốc: `H:\My Drive\Thanh Quang Do\Cau 1 2 _Lach Huyen\`

```
├── Thuyet minh\
│   ├── Thuyet minh 06.12.doc              ← Thuyết minh TKKT gói thầu XL01
│   ├── 1.Tai trong 100.000DWT..xls        ← Bảng tính tải trọng (16 sheet)
│   ├── Bang toa do coc.xls
│   ├── 02-05. Mat bang, mat dung.dxf      ← convert từ DWG gốc để đọc bằng Python
│   ├── 06. Mat ben.dxf
│   ├── 07..15. Mat cat ngang.dxf
│   ├── 16..28. Mat bang dam coc.dxf
│   ├── Ben 100.000DWT KT.s2k              ← Export text SAP2000 (v14.1.0) — mô hình FEM chính
│   └── FEM_PhanDoan_TieuChuan_100000DWT.md ← ★ FILE DỮ LIỆU TỔNG HỢP đã tạo ở phiên trước (xem mục 4)
├── DWG\
│   ├── 1. Quy hoach\                      (quy hoạch cảng Lạch Huyện, .dwg/.ppt)
│   ├── 2. DKTN\                           (điều kiện tự nhiên, địa hình/địa chất .dwg)
│   └── 3. Cau tau 100.000DWT\             (9 thư mục con: kết cấu tổng thể, cọc, dầm bản,
│                                            thiết bị/hạ tầng, bảo vệ nền cọc, biện pháp thi
│                                            công, nạo vét, xử lý mái dốc, bến sà lan — TOÀN
│                                            BỘ DẠNG .dwg GỐC, CHƯA ĐỌC CHI TIẾT)
└── Sap\
    ├── Ben 100.000DWT KT.SDB               (file gốc SAP2000, chưa mở trực tiếp)
    ├── Ben 100.000DWT KT (file chuan thay luc va).SDB
    ├── Chay bo lane kiem tra.SDB
    └── Ben 100.000DWT KT.s2k                (bản sao giống hệt file trong Thuyet minh\)
```

> ⚠️ Chỉ có **4 file DXF** (đại diện phân đoạn tiêu chuẩn) và **1 file .s2k** đã được đọc chi tiết. Toàn bộ thư mục `DWG\3. Cau tau 100.000DWT\` (9 mục con, bao gồm kết cấu cọc chi tiết, dầm bản chi tiết, bảo vệ chống ăn mòn, biện pháp thi công, bến sà lan...) **chưa được khai thác** — có thể cần nếu mở rộng phạm vi tối ưu.

---

## 2. Việc đã làm trong phiên (tóm tắt theo trình tự)

1. **Đọc Thuyết minh (.doc)**: dùng Microsoft Word COM automation qua PowerShell (`Word.Application` COM, có sẵn trên máy, version 16.0) — trích được toàn văn (~75.000 ký tự) chính xác dấu tiếng Việt. *(antiword không dùng được vì font Vietnamese cũ trong .doc không phải mã chuẩn — đã thử và bỏ)*.
2. **Đọc Excel tải trọng (.xls)**: dùng Excel COM automation, liệt kê 16 sheet (Ngoai le, So lieu, CD day, Va, Neo, Dongchay.Gio, L coc, Tai trong, To hop, COMB, Hinh hoc, Noi suy...) — **chưa đọc chi tiết nội dung số liệu từng sheet**, chỉ mới lấy cấu trúc.
3. **Đọc 4 file DXF bản vẽ**: dùng Python (`ezdxf`) để trích TEXT/MTEXT/ATTRIB. Font tiếng Việt trong DXF là **mã TCVN3 (.VnTime, kiểu ABC cũ)**, không phải Unicode chuẩn → đã **tự xây dựng bảng chuyển đổi TCVN3→Unicode** (lấy từ mapping PHP công khai trên GitHub Gist, xử lý case ambiguity upper/lower bằng heuristic) → giải mã thành công tiếng Việt có dấu.
4. **Đọc ảnh bản vẽ "01. Quy định hồ sơ"** do người dùng gửi trực tiếp trong chat (không phải file trên đĩa) — trích các thông số vật liệu/tải trọng khai thác quan trọng.
5. **Đọc & phân tích file SAP2000 `.s2k`** bằng Python (tự viết parser regex cho định dạng bảng text SAP2000, không cần cài SAP2000) — trích: hình học, vật liệu, tiết diện, số lượng cọc, tải trọng, tổ hợp tải trọng, điều kiện biên/lò xo đất.
6. **Xác định phân đoạn của mô hình `.s2k`**: kết luận đây là **mô hình TIÊU BIỂU cho 1 trong 10 phân đoạn** (750m ÷ 10 = 75m/đoạn), không gắn số hiệu cụ thể (metadata `PROJECT INFORMATION` trống). Cơ sở: chiều dài mô hình ≈75m, cao trình đỉnh bến khớp +5,50m, và đặc biệt **số cọc mô hình (132 BTCT DƯL + 60 thép) khớp CHÍNH XÁC** với tổng số cọc toàn cầu tàu chia đều 10 đoạn (1320/10=132; 600/10=60).
7. **Đối chiếu Thuyết minh ↔ Bản vẽ ↔ Mô hình SAP**: khớp tốt về hình học, tiết diện, vật liệu, số lượng cọc. **1 điểm chưa khớp cần xác minh**: Fy thép cọc trong SAP (quy đổi ≈2.531 kG/cm²) vs. giá trị thiết kế chính thức ghi trên bản vẽ (3.150 kG/cm²) — nghi ngờ là do bảng vật liệu phi tuyến SAP dùng giá trị mặc định chưa cập nhật.
8. **Tạo file dữ liệu tổng hợp `FEM_PhanDoan_TieuChuan_100000DWT.md`** (14 mục: tổng quan, hình học, vật liệu, tiết diện, hệ cọc, điều kiện biên/lò xo đất, địa chất, tải trọng, tổ hợp tải trọng, giới hạn chịu lực, tiêu chuẩn thiết kế, **đề xuất khung bài toán SOO/MOO**, ghi chú giới hạn dữ liệu). File đã lưu 2 nơi:
   - `H:\My Drive\Thanh Quang Do\Cau 1 2 _Lach Huyen\Thuyet minh\FEM_PhanDoan_TieuChuan_100000DWT.md` ← **dùng file này, đường dẫn ổn định trên Drive**
   - (bản sao trong thư mục tạm scratchpad của phiên trước — sẽ không còn truy cập được ở phiên mới)
9. **Tư vấn tính khả thi tính toán MOO**: kết luận mô hình (4.913 nút, 1.734 thanh, 4.488 tấm, tuyến tính tĩnh) **không nặng** cho 1 lần phân tích (vài giây). Cái quyết định độ nặng của cả campaign là: (a) loại biến thiết kế — biến *tiết diện* rất nhẹ (chỉ đổi property, không remesh), biến *hình học/bố trí cọc* nặng hơn nhiều (phải remesh 4.488 phần tử vỏ); (b) overhead kết nối COM MATLAB↔SAP2000 nếu code không tối ưu (nên giữ 1 session mở xuyên suốt); (c) số lần đánh giá của thuật toán MOO (pop×gen). Với quy mô "bài báo so sánh phương pháp" (không cần tối ưu công nghiệp), đề xuất pop~30–50, gen~50–100 (~1.500–5.000 lần gọi FEM) → khả thi trong ~1,5–11 giờ chạy trên máy thường, nếu giới hạn biến ở nhóm tiết diện.

---

## 3. Công cụ/môi trường đã thiết lập trên máy (để tái sử dụng ở phiên sau nếu cần)

- **Python**: `C:\Users\Admin\AppData\Local\Programs\Python\Python311\python.exe` (v3.11.6). Đã cài thêm: `ezdxf`, `xlrd`, `unidecode` (pip).
- **Microsoft Word/Excel COM** (Office 16.0) hoạt động tốt qua PowerShell `New-Object -ComObject Word.Application` / `Excel.Application` — dùng để đọc chính xác các file `.doc`/`.xls` cũ (giữ nguyên dấu tiếng Việt), thay vì antiword/xlrd (không xử lý đúng font Vietnamese cũ).
- **SAP2000**: ⚠️ **CHƯA XÁC NHẬN** có cài trên máy này hay không — phiên này chỉ đọc file `.s2k` dạng text thuần bằng Python, **không** dùng SAP2000 OAPI/COM. Nếu muốn ghép MATLAB↔SAP2000 OAPI thật, cần kiểm tra lại máy chạy MATLAB có cài SAP2000 + license hợp lệ.
- **Bảng mã TCVN3→Unicode**: đã tự xây dựng trong Python (dict ánh xạ 168 cặp ký tự, xử lý heuristic hoa/thường) để giải mã text tiếng Việt trong DXF — nếu cần đọc thêm các file DWG/DXF khác trong thư mục `DWG\` ở phiên sau, **nên yêu cầu tôi dựng lại đoạn code này** (không lưu thành module riêng ở phiên trước).
- **antiword** có sẵn tại `/mingw64/bin/antiword` (Git Bash) nhưng **không phù hợp** với font Vietnamese cũ (.VnTime/TCVN3) trong các file `.doc` — đã thử, kết quả bị lỗi dấu, chuyển sang dùng Word COM thay thế.

---

## 4. ★ Dữ liệu kỹ thuật tổng hợp chính (trích nhanh — chi tiết đầy đủ xem file `FEM_PhanDoan_TieuChuan_100000DWT.md`)

- Cầu tàu 100.000DWT dài **750m**, chia **10 phân đoạn ~75m**; rộng mặt cầu **50m**; cao trình đỉnh bến **+5,50m** (Hải đồ), đáy bến **−16,0m**.
- 1 phân đoạn tiêu chuẩn: **132 cọc BTCT DƯL D(800-540)** + **60 cọc ống thép D1016-T16** = 192 cọc; module dọc 5,1m; độ xiên 6:1 (trong)/7:1 (biên).
- Vật liệu: bê tông M400 (dầm/bản), M800 (cọc BTCT); thép cọc Fy=3.150 kG/cm² (theo bản vẽ, **SAP ghi 2.531 — cần xác minh**), Fu=4.900 kG/cm².
- Giới hạn chịu lực cọc BTCT: Mcr=67,4 T.m; Mu=134,8 T.m; Pmax dọc trục=658T.
- Tải trọng khai thác: hàng hoá q=2,0/4,0 T/m² (mép/sau bến); cần trục giàn 65T (khẩu độ ray 24m); tàu thiết kế 100.000DWT (330×45,5×14,8m).
- Địa chất: 12 lớp đất/đá (SPT N30 từ 1 đến >50); cấp động đất VI (a=0,0368).
- 11 load pattern (BT, Va, Neo1/2, MT, HH1-6, CT1/CT2...) và **36 tổ hợp tải trọng** trong SAP.
- **Khung đề xuất SOO/MOO** (mục 13 trong file .md): biến thiết kế (D/t cọc, khoảng cách, b×h dầm), ràng buộc (Mu, Pmax, Fy, chuyển vị, TCVN 10304/9386), hàm mục tiêu gợi ý (chi phí vật liệu vs. chuyển vị/an toàn).

---

## 5. Việc CHƯA làm / câu hỏi mở cho phiên tiếp theo

1. **Chưa viết code MATLAB** ghép nối với SAP2000 OAPI (tôi đã đề nghị cuối phiên, đang chờ bạn xác nhận có muốn làm tiếp không, và xác nhận SAP2000 có cài trên máy chạy MATLAB không).
2. **Chưa xác nhận thuật toán MOO cụ thể** bạn đã có sẵn code MATLAB (NSGA-II? MOPSO? MOEA/D? tên hàm/file ở đâu?) — cần biết để thiết kế hàm mục tiêu/ràng buộc tương thích đúng định dạng input/output thuật toán đó.
3. **Chưa chốt danh sách biến thiết kế cụ thể** muốn tối ưu (chỉ tiết diện cọc/dầm, hay cả bố trí/khoảng cách?) — khuyến nghị chốt ở nhóm "tiết diện" trước để nhẹ tính toán (xem mục 2.9 và mục 13.1 trong file .md).
4. **Chưa xác minh discrepancy Fy thép cọc** (2.531 vs 3.150 kG/cm²) — nên kiểm tra lại trong SAP2000 gốc (`.SDB`) hoặc hỏi đơn vị thiết kế trước khi dùng làm ràng buộc cứng.
5. **Chưa đối chiếu đầy đủ 12/12 lớp địa chất** (chỉ mới chắc chắn 5 lớp: 2,7,8,9,10) — cần lấy "Bảng 1: Bảng tổng hợp chỉ tiêu cơ lý" gốc trong thuyết minh nếu muốn hiệu chỉnh lò xo đất (p-y, t-z springs) chính xác cho FEM.
6. **Chưa xác nhận mục đích tiết diện tấm `ASEC1`/`ASEC2`/`BMC`/`BTT`** trong SAP — cần mở SAP2000 gốc để kiểm tra trực quan.
7. **Chưa đọc chi tiết** nội dung số liệu trong 16 sheet Excel `1.Tai trong 100.000DWT..xls` và toàn bộ thư mục `DWG\3. Cau tau 100.000DWT\` (9 mục con) — chỉ mới có tên sheet/tên file.

---

## 6. Gợi ý câu mở đầu cho phiên chat mới

> "Đọc file `NGU_CANH_PHIEN_LAM_VIEC.md` và `FEM_PhanDoan_TieuChuan_100000DWT.md` trong thư mục `Thuyet minh` để nắm ngữ cảnh, sau đó viết code MATLAB gọi SAP2000 OAPI cho bài toán tối ưu MOO với biến thiết kế là [...]."

(Điền cụ thể biến thiết kế / thuật toán MOO bạn muốn dùng vào chỗ [...] để tôi bắt đầu ngay không cần hỏi lại).
