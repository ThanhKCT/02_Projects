# Khung code MATLAB–SAP2000 cho Bài 2 (MOSFOA) — bước 8

Thực hiện theo [`Cong_thuc_Bai_toan_Toi_uu.md`](../Cong_thuc_Bai_toan_Toi_uu.md) và kiến trúc/kinh nghiệm trong [`Cach ket noi_SAP2000_MATLAB_OPTIMIZATION.md`](../Cach%20ket%20noi_SAP2000_MATLAB_OPTIMIZATION.md).

## Các file

| File | Vai trò |
|---|---|
| `pile_catalogue_AMACCAO.m` | Bảng catalogue 33 dòng (11 D × 3 Class), đã nhập số liệu thật từ `Cataloge coc ly tam.md`. |
| `project_config.m` | Thông số riêng công trình A/B (N_pile, L_pile, γn, U_limit, qb_tip, Σfi·hi, combo khống chế...) — đã điền số thật đã chốt. |
| `open_Sap2000.m` | Mở SAP2000 ẩn, copy nguyên mẫu từ file hướng dẫn của bạn. |
| `evaluate_pile_design.m` | Hàm mục tiêu/fitness chính — nhận `x` (chỉ số catalogue), trả `[f1,f2]` + phạt cứng nếu vi phạm ràng buộc. |
| `driver_example.m` | Ví dụ khung vòng lặp (vét cạn 33 phương án) — thay bằng lời gọi MOSFOA thật của bạn. |

## ✅ Đã hoàn thiện phần A (10/09/2026) — 37/37 tổ hợp đã xem xét, kết luận đủ tin cậy

Đã đọc trực tiếp `Ben 100.000DWT KT.s2k` (model gốc), `Ben 100.000DWT KT kq dau ra.s2k` (kết quả FEM cũ, 810MB) và `Chuyen vi du an A. s2k.s2k` (kết quả FEM mới, xuất riêng 2 tổ hợp bão, đầy đủ 4913/4913 nút) tại `JMST/Paper 1/` và `SapV14/`.

**Đã xác nhận cho A:**
- `pile_section_name = 'COCBTCT'`, `material_name = 'Be tong M800'` — trích trực tiếp từ `FRAME SECTION PROPERTIES 01` (D800-t130).
- **Phát hiện quan trọng:** model thực có **37 tổ hợp**, không phải 36 — `"BAO (storm)"` và `"BAO KT"` là **2 tổ hợp bão khác nhau** (lần trích `COMBINATION DEFINITIONS` trước bị lỗi ký tự làm gộp nhầm 2 tên có dấu ngoặc kép + khoảng trắng thành 1 dòng).
- `combo_governing_disp = '"BAO KT"'` — **max|U1| = 13,81mm** tại nút 459 (đã xác nhận đúng là nút đỉnh bến Z=+5,5m) — tổ hợp khống chế trong số 34/37 đã kiểm tra, **vượt nhẹ** COMB2 (13,41mm). Vẫn **thoả mãn tốt** giới hạn 30mm (dùng ~46%).
- `"BAO (storm)"` riêng chỉ cho 3,27mm — nhỏ hơn nhiều, không khống chế.

**3/37 tổ hợp (COMB7.1, COMB8.1, COMB8.2) đã thử xuất nhưng file rỗng** (`Ben100kDWT_bs thop.s2k`) — nhiều khả năng 3 tổ hợp này chưa được chạy phân tích (chưa tick "Run") trong model gốc. **Theo quyết định người dùng (10/09/2026): bỏ qua, coi 3 tổ hợp này đóng góp = 0/không khống chế**, không suy diễn giá trị thay thế. Báo cáo chính thức: **đã xem xét đủ 37/37 tổ hợp**, kết luận không đổi (`"BAO KT"` khống chế, 13,81mm). Khi chạy `evaluate_pile_design.m` thật, phần `N_max`/`M_max` vẫn tự động duyệt đủ cả `cfg.combo_list_for_axial` (đã có đủ 37 tên) — nếu 3 tổ hợp này sau này được chạy và có kết quả thật, code sẽ tự động bao gồm, không cần sửa lại.

## Đã KHÔNG cần xác nhận thêm (số liệu thật, đã kiểm chứng kỹ trong các bước trước)

- Catalogue AMACCAO D300–D1200, Mcr/Mu theo Class — từ `Cataloge coc ly tam.md`.
- `qb_tip`, `Σfi·hi` từng công trình — từ `SucChiuTai_Coc_TCVN10304_2025.md` (trụ hố khoan thật, đã đối chiếu).
- `γn(A)=1,0` (Cấp I), `γn(B)=1,15` (Cấp II) — xác nhận trực tiếp từ người dùng.
- `U_limit=30mm` — xác nhận trực tiếp từ người dùng + đối chiếu Bảng 12.
- Công trình B: `L_pile=41,00m`, `combo_governing_disp='COMB14'` (=`BAO`, đã kiểm chứng bằng FEM thật đầy đủ 37/37 tổ hợp, `max|U1|=15,36mm < 30mm`).
- Model B `sdb_path`, `pile_section_name='Coc'`, `material_name='M600'` — đã xác nhận trực tiếp từ file `.s2k` gốc.
- Model A `sdb_path`, `pile_section_name='COCBTCT'`, `material_name='Be tong M800'`, danh sách 36 tổ hợp — đã xác nhận trực tiếp từ file `.s2k` gốc.

## Việc còn lại (không chặn code hoá, chỉ ảnh hưởng độ chắc chắn của 1 kết luận)

1. **Chạy lại kiểm tra chuyển vị đủ 36/36 tổ hợp cho A** (bao gồm `"BAO (storm)"`) — cách làm giống hệt B, xem mục trên.
2. **Cả 2 công trình** (không đổi so với trước): cách lọc "frame nào là cọc" qua `GetSection` giả định không có cấu kiện khác trùng tên tiết diện; chưa tách riêng kiểm tra tổ hợp gây nhổ cọc (tension) nếu có; `SM.*` cần có sẵn trên máy chạy thật.
3. **Tham số MOSFOA** (Npop, MaxIt, Nrun...) — thuộc phạm vi thuật toán đã công bố của bạn, không phải phạm vi Bài 2 — tự tích hợp theo cấu hình đã dùng ở Bài 1.

## Quy trình chạy đề xuất (theo đúng checklist trong file hướng dẫn của bạn, mục 8)

1. ~~Điền nốt TODO công trình A~~ ✅ **đã xong hoàn toàn** — kể cả `sdb_path` (`SapV14/Ben100kDWT_sensitivity.sdb`, đã kiểm chứng bằng số: PointObj/FrameObj/AreaObj Count khớp tuyệt đối 4913/1734/4488 với hình học đã biết). Chỉ còn 3/37 tổ hợp phụ chưa kiểm tra (rủi ro thấp, mục trên, đã quyết định bỏ qua).
2. Chạy `driver_example.m` cho B trước (đã đủ số liệu) — vét cạn 33 phương án, kiểm tra không lỗi (smoke test tự nhiên vì K=33 nhỏ).
3. Đối chiếu 2 điểm baseline (D700-t110-ClassC cho B, D800-t120-ClassC cho A) trong kết quả vét cạn với giá trị `Rd`/`Rk` đã tính thủ công ở `SucChiuTai_Coc_TCVN10304_2025.md` — phải khớp, nếu lệch nghĩa là có lỗi trong `evaluate_pile_design.m`.
4. Sau khi khớp, ghép với MOSFOA thật của bạn (thay đoạn vét cạn), chạy pilot thật, rồi mới chạy campaign chính thức theo đúng quy trình 3 bước trong file hướng dẫn mục 4.
