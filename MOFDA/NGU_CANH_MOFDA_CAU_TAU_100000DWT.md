# Ngữ cảnh dự án MOFDA – Cầu tàu container 100.000 DWT

## 1. Mục tiêu

Áp dụng thuật toán **MOFDA** để tối ưu đa mục tiêu hệ cọc của cầu tàu container 100.000 DWT. Kết quả dùng để viết bài báo tiếng Việt theo định dạng tạp chí JMST, với phạm vi phù hợp cho nghiên cứu sinh năm đầu.

## 2. Dữ liệu và mô hình FEM

- Mô hình SAP2000: `D:\ResearchLab\02_Projects\JMST\Paper 2\Chieu dai ngam\Ben 100.000DWT KT.s2k`.
- Tài liệu tổng hợp: `D:\ResearchLab\02_Projects\JMST\Paper 2\Chieu dai ngam\FEM_PhanDoan_TieuChuan_100000DWT.md`.
- Template bài báo: `D:\ResearchLab\02_Projects\JMST\Paper 2\Chieu dai ngam\JMST-Template H.docx`.
- Quy mô FEM: 4.913 nút, 1.734 phần tử thanh, 4.488 phần tử tấm vỏ.
- Hệ cọc: 132 cọc BTCT dự ứng lực D800-540 và 60 cọc ống thép D1016-T16.
- Mô hình có chiều dài khoảng 75 m; trong bài viết chỉ gọi nhất quán là “cầu tàu container 100.000 DWT”, không dùng cụm “phân đoạn điển hình” trong tiêu đề và mục tiêu.

## 3. Bài toán tối ưu dự kiến

### Biến thiết kế

```text
x = [D_BTCT, t_BTCT, D_thep, t_thep]
```

Đơn vị là mét. Chỉ tối ưu tiết diện cọc; không thay đổi vị trí cọc, độ xiên, chiều dài, lò xo nền, dầm hoặc bản.

| Biến | Miền nghiên cứu ban đầu |
|---|---:|
| Đường kính ngoài cọc BTCT | 0,70–0,90 m |
| Chiều dày thành cọc BTCT | 0,11–0,15 m |
| Đường kính ngoài cọc thép | 0,90–1,10 m |
| Chiều dày thành cọc thép | 0,012–0,020 m |

### Mục tiêu

1. Tối thiểu hóa khối lượng vật liệu cọc quy đổi.
2. Tối thiểu hóa chuyển vị ngang lớn nhất của cầu tàu.

### Ràng buộc

- Lực dọc trục cọc BTCT.
- Mô men cọc BTCT.
- Ứng suất tương đương cọc thép.
- Chuyển vị ngang cho phép.
- Sức chịu tải địa kỹ thuật và các yêu cầu nền móng sẽ hoàn thiện theo tiêu chuẩn/hồ sơ dự án.

**Lưu ý:** giới hạn chuyển vị cần lấy từ yêu cầu khai thác, thiết bị hoặc hồ sơ dự án; không tự coi một giá trị giả thiết là yêu cầu tiêu chuẩn.

## 4. Tiêu chuẩn áp dụng

- TCVN 11820-1:2026 – Công trình cảng biển – Yêu cầu thiết kế – Phần 1: Nguyên tắc chung.
- TCVN 11820-2:2026 – Công trình cảng biển – Yêu cầu thiết kế – Phần 2: Tải trọng và tác động.
- TCVN 11820-4-1:2020 – Công trình cảng biển – Yêu cầu thiết kế – Phần 4-1: Nền móng.
- TCVN 11820-5:2021 – Công trình cảng biển – Yêu cầu thiết kế – Phần 5: Công trình bến.
- TCVN 10304:2025 – Thiết kế móng cọc.
- TCVN 5574:2018 – Thiết kế kết cấu bê tông và bê tông cốt thép.
- TCVN 5575:2024 – Thiết kế kết cấu thép.

Nguyên tắc: TCVN 11820-4-1:2020 dùng cho bối cảnh nền móng công trình cảng biển; TCVN 10304:2025 dùng cho tính chi tiết móng cọc. Không nhân chồng hệ số an toàn từ hai tiêu chuẩn.

## 5. Mã đã tạo

Thư mục mã: `D:\ResearchLab\02_Projects\JMST\Paper 2\MOFDA\Wharf100DWT`.

- `run_mofda_wharf100dwt.m`: điểm vào chạy MOFDA.
- `wharf100dwt_config.m`: cấu hình mô hình, biến và thông số thuật toán.
- `wharf100dwt_sap_response.m`: liên kết SAP2000 OAPI.
- `wharf100dwt_extract_response.m`: trích xuất chuyển vị/nội lực.
- Các hàm `evaluate`, `constraints`, `material_tonnage`, `pile_ids`, `generate`, `update_repository`.

Mã đã được kiểm tra:

- MATLAB R2023b sẵn có.
- SAP2000 v24 và v14 sẵn có.
- Chạy dry-run MOFDA 50 thế hệ thành công.
- Đọc tuần tự file `.s2k` thành công, nhận diện đúng 132 cọc BTCT và 60 cọc thép.

## 6. Trạng thái và việc cần làm tiếp theo

1. Hoàn tất/đánh giá lần chạy SAP2000 cơ sở qua OAPI để đo thời gian mỗi phân tích.
2. Kiểm tra chính xác tên tổ hợp tải trong SAP2000; mã đang để `BAO (storm)` và cần xác nhận.
3. Kiểm chứng lời gọi OAPI trích xuất kết quả trước khi chạy campaign tối ưu.
4. Chốt giới hạn chuyển vị và phương pháp xác định sức kháng cọc theo hồ sơ/tiêu chuẩn.
5. Chạy MOFDA thật với quy mô nhỏ trước, ví dụ 10–20 cá thể và 10–20 thế hệ; sau đó mới tăng quy mô nếu thời gian FEM cho phép.
6. Chỉ lập bảng/hình kết quả và viết phần kết quả của bài JMST sau khi có số liệu FEM thật. Không dùng kết quả dry-run để công bố.

## 7. Lưu ý kỹ thuật quan trọng

- Khối lượng vật liệu hiện dùng chiều dài cọc chế tạo trung bình; cần thay bằng tổng theo nhóm cọc nếu muốn báo cáo chi phí chính xác hơn.
- Sức kháng BTCT trong mã hiện được quy đổi tỷ lệ từ cọc cơ sở D800-540; đây chỉ là bước tiền xử lý. Cần thay bằng kiểm tra thiết kế chi tiết trước khi công bố.
- Chỉ tiêu chảy thép trong hồ sơ có chênh lệch giữa mô hình SAP và bản vẽ; cần xác minh giá trị chính thức trước khi dùng làm ràng buộc cứng.
- Không nên chạy ngay 30 cá thể × 50 thế hệ nếu mỗi lần phân tích SAP mất nhiều phút.

## 8. Yêu cầu chưa thực hiện

Yêu cầu “liệt kê các file không dùng đến để xóa thủ công” chưa được thực hiện.
