# ĐỌC TRƯỚC KHI XOÁ — đây KHÔNG phải rác

Gom vào đây ngày 08/09/2026 theo yêu cầu người dùng, để tách phần **không
cần trực tiếp** cho bài báo mới "TỐI ƯU ĐA MỤC TIÊU TIẾT DIỆN HỆ CỌC CẦU
TÀU CONTAINER 100.000 DWT: ĐỐI SÁNH THUẬT TOÁN MOFDA VÀ E-MOSFOA".

## ⚠️ Đây là toàn bộ code + dữ liệu thật của một bài báo KHÁC của bạn

`Run_MOMSFOA_official/` chứa **code B-MOSFOA/E-MOSFOA thật** (không phải
nháp) cho **3 hệ kết cấu bến cảng lỏng Hải Linh** (BD/MD/MPJ) — đúng bài
báo `02_MOSFOA.docx`/`MOSFOAV2.pdf` đang chờ xuất bản, kèm theo:
- Code thuật toán thật: `BMOSFOA_*_v3.m`/`v1.m`, `EMOSFOA_*_v3.m`/`v1.m`
- Model SAP2000 thật của bến Hải Linh (`BD_Sap/`, `MD_Sap/`, `MPJ_Sap/`)
- **Hàng chục file kết quả `.mat` thật**, trải dài 08/2025 → 07/2026 —
  đây là **toàn bộ lịch sử thực nghiệm** dùng để viết bài báo đó
- Module tính sức chịu tải cọc TCVN 10304:2014 đầy đủ (`Pile_TCVN10304_2014/`,
  3 bản sao cho 3 hệ kết cấu) — bao gồm bảng `Table_Fi_tip.mat`/
  `Table_Fi_friction.mat` đã số hoá sẵn (dùng để đối chiếu và **sửa được
  1 lỗi lệch cột trong bảng qb của dự án này**, xem
  `Wharf100DWT/wharf100dwt_geotech_capacity_tcvn10304.m`)

`Problems/`, `Public/` là thư viện benchmark chuẩn kiểu PlatEMO (IMOP, UF,
RM-MEDA, ZDT, DTLZ, WFG...) dùng cho phần kiểm chứng thuật toán trên hàm
chuẩn của CHÍNH bài báo B-/E-MOSFOA đó, không liên quan bài container wharf.

`tools/` là script PowerShell cập nhật riêng cho bến Hải Linh.

`Functions_root_da_sao_chep_can_dung/` (đổi tên từ `Functions/`) — thư
viện tiện ích chung (archive/grid/GD/IGD/HV...). **4 file cần dùng đã
được sao chép sang** `MOFDA/MOFDA/Functions/` trước khi gom vào đây
(`hypervolume.m`, `epsilon_matlab.m`, `spacing_to_extent.m`,
`metric_of_maximum_spread.m`) — các file archive/grid còn lại
(`checkDomination.m`, `updateGrid.m`, `updateRepository.m`,
`deleteFromRepository.m`, `selectLeader.m`, `dominates.m`) **không cần
sao chép** vì `MOFDA/MOFDA/Functions/` đã có sẵn bản tương đương (dùng
chung cho MOFDA từ trước).

## Lý do KHÔNG cần cho bài báo mới

Bài báo mới chỉ cần **cơ chế cập nhật vị trí của E-MOSFOA** (công thức
cosine phase-control, energy-step/DE-mutation, preying/regeneration,
Gaussian refinement) — đã trích xuất và viết lại thành
`Wharf100DWT/run_emosfoa_wharf100dwt_parallel.m`, nối với đúng mô hình
SAP2000 cầu tàu container 100.000 DWT (không phải bến Hải Linh) và đúng
ràng buộc TCVN 10304:2025 đã có sẵn của dự án này. Không cần chạy lại
model/code Hải Linh.

## Khuyến nghị

- **KHÔNG xoá `Run_MOMSFOA_official/`** nếu còn cần dữ liệu thực nghiệm
  cho bài báo B-/E-MOSFOA đang chờ xuất bản (đây là kết quả của ~1 năm
  chạy thử).
- Có thể xoá an toàn: `Functions a.zip`, `OneDrive_1_9-8-2026.zip` (bản
  nén/backup trùng lặp với những gì đã giải nén), và
  `Functions_root_da_sao_chep_can_dung/` (đã sao chép phần cần dùng).
- `Problems/`, `Public/`, `tools/` — chỉ xoá nếu chắc chắn không cần
  chạy lại phần benchmark/cập nhật Hải Linh nữa.

Đường dẫn đầy đủ để xoá (nếu bạn quyết định xoá toàn bộ):
`D:\ResearchLab\02_Projects\02_Projects\MOFDA\MOSFOA\_KHONG_CAN_CHO_BAI_MOFDA_vs_EMOSFOA\`
