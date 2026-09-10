# Nháp bổ sung mục 2.3 — Bảng tóm tắt tải trọng (số liệu THẬT, trích "1.Tai trong 100.000DWT..xls")

Nguồn: `Cau tau Lach Huyen/1.Tai trong 100.000DWT..xls`, đọc qua Excel COM (xlrd bị lỗi parse
supbook trên file này — không dùng được), sheet "Tai trong" và "Moi truong".

## Số liệu trích xuất (đã xác nhận, không suy đoán)

- **Hoạt tải mặt bến (q):** 4,0 T/m² (mục 2.1, hàng 51 sheet "Tai trong")
- **Tải trọng cần trục (P_max, 1 bánh xe):** theo Bảng 4 (đã xét lực ngang do gió + độ lệch tâm,
  sheet "Tai trong" hàng 93-104) — governing case "Cần trục di chuyển làm hàng", tải đứng
  **76,73 T/bánh xe (phía trước bến)**, 59,23 T/bánh xe (phía sau bến). Các trường hợp khác:
  đứng yên làm hàng 40,63/43,6 T; động đất 63,25/46,38 T; gió bão 58,91/62,04 T — tất cả THẤP HƠN
  giá trị governing 76,73T.
- **Lực va tàu (F_va):** Nx = 187 T (vuông góc tuyến bến), Ny = 37,4 T (song song tuyến bến)
  (mục 3.1, hàng 135-136).
- **Lực neo tàu (F_neo), tàu đầy tải:** Sq = 54,11 T (vuông góc), Sn = 93,72 T (song song),
  Sv = 39,39 T (thẳng đứng) (mục 3.2, hàng 140-142). Tàu không tải (ballast): Sq=39,35T,
  Sn=68,15T, Sv=66,03T (hàng 144-146) — thấp hơn tàu đầy tải ở 2/3 thành phần.
- **Dòng chảy:** vận tốc thiết kế U = 1,55 m/s (sheet "Moi truong" hàng 18, theo BS 6349-1:2000);
  tải trọng phân bố trên cọc FD = 0,130 T/m (cọc BTCT D800) và FD = 0,161 T/m (cọc thép D1016)
  (sheet "Tai trong" hàng 152-153; sheet "Moi truong" cho giá trị hơi khác do có kể chiều dày
  hà bám +0,1m: FD=1,207 kN/m và 1,410 kN/m ~ 0,123/0,144 T/m — cùng bậc độ lớn, khác giả thiết
  hà bám, KHÔNG mâu thuẫn).
- **Gió:** áp dụng BS 5400-2:1978, phân biệt "bình thường"/"gió bão", tác dụng ngang lên 1md cầu
  chính 0,134/0,500 T/m, lên cọc thép D1016 0,044/0,165 T/m, lên cọc BTCT D700 0,038/0,143 T/m
  (sheet "Tai trong" hàng 157-166).
- **Động đất:** hệ số gia tốc ngang Kh=0,0368 theo TCVN 9386:2012 (Phụ lục H, khu vực Lạch
  Huyện — Cát Hải — Hải Phòng), k1=k2=1 (đất loại 2) (hàng 183-185).
- **Thuỷ triều/mực nước:** phạm vi áp dụng tải dòng chảy "từ MNC +3,55 đến đáy nạo vét"
  (sheet "Moi truong" hàng 44) — cùng hệ quy chiếu cao độ với đỉnh bến +5,50/đáy bến -16,0 đã
  nêu ở mục 2.1 bài báo.

## Câu văn đề xuất chèn vào mục 2.3 (sau đoạn "Mô hình bao gồm 36 tổ hợp tải...")

> Mô hình xét các nhóm tải trọng chính theo hồ sơ thiết kế dự án và TCVN 11820-2:2019, gồm: tĩnh
> tải bản thân kết cấu và lớp phủ mặt bến (tính tự động trong SAP2000); hoạt tải khai thác mặt bến
> phân bố đều q = 4,0 T/m²; tải trọng cần trục container qua bánh xe, giá trị chi phối 76,73 T/bánh
> xe (trường hợp cần trục di chuyển làm hàng); lực va tàu thiết kế 100.000 DWT qua hệ đệm chống va
> (thành phần vuông góc tuyến bến 187 T, song song 37,4 T); lực neo tàu (tàu đầy tải: vuông góc
> 54,11 T, song song 93,72 T, thẳng đứng 39,39 T); tải trọng dòng chảy (vận tốc thiết kế 1,55 m/s,
> theo BS 6349-1:2000) và tải trọng gió (theo BS 5400-2:1978, phân biệt điều kiện bình thường và
> gió bão) tác dụng lên cọc và kết cấu bến.

(English) *The model accounts for the principal load groups per the project design dossier and
TCVN 11820-2:2019: structural self-weight and deck surfacing (computed automatically in SAP2000);
uniformly distributed live load q = 4.0 T/m² on the deck; container-crane wheel loads, governing
value 76.73 T/wheel (crane travelling while handling cargo); the design berthing force for the
100,000-DWT vessel through the fender system (187 T perpendicular, 37.4 T parallel to the wharf
line); mooring force (loaded vessel: 54.11 T perpendicular, 93.72 T parallel, 39.39 T vertical);
current load (design velocity 1.55 m/s per BS 6349-1:2000); and wind load (per BS 5400-2:1978,
distinguishing normal and storm conditions) acting on the piles and wharf structure.*

## Việc CẦN làm khi ghép vào bài (chưa làm ở bước này)
- Xác nhận các giá trị trên có thực sự nằm trong tổ hợp "BAO KT" (envelope dùng cho FEM) hay
  không — hiện chỉ xác nhận chúng có trong HỒ SƠ TẢI TRỌNG gốc của dự án, chưa đối chiếu ngược
  lại với danh sách 35/36 tổ hợp cơ bản đã gộp trong model SAP2000. Cần mở model kiểm tra tên tổ
  hợp tải trước khi khẳng định "đây là các tải trọng trong BAO KT".
- Làm rõ ký hiệu "MNC" (nghi là mực nước chân triều hoặc mực nước cao — CHƯA xác nhận, không tự
  suy đoán khi viết vào bài).
