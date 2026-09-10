# BÀN GIAO PHIÊN LÀM VIỆC — 10/09/2026 (sau khi vét cạn 4.080 tổ hợp HOÀN THÀNH)

> Đọc file này trước khi làm bất cứ gì trong phiên Claude mới (sau `/clear` hoặc khởi động lại máy). File này THAY THẾ [`BAN_GIAO_PHIEN_LAM_VIEC_08_09_2026.md`](BAN_GIAO_PHIEN_LAM_VIEC_08_09_2026.md) (vẫn giữ lại làm lịch sử — mục 2-4 của file đó đã xong, không cần đọc lại trừ khi cần tra cứu chi tiết bug đã sửa).

## 0. Việc CẦN LÀM NGAY khi mở phiên mới

1. Kiểm tra sạch tiến trình trước khi làm gì (không nên có gì sau khi máy khởi động lại):
   ```bash
   tasklist | grep -iE "sap2000|matlab"
   ```
   Nếu có sót thì `taskkill //F //PID <pid>` (dùng Bash tool + PID cụ thể, KHÔNG dùng PowerShell + `/IM` — hay bị chặn bởi classifier, xem [[sap2000-matlab-optimization-lessons]]).
2. **Vét cạn 4.080 tổ hợp ĐÃ XONG** (xem mục 1 dưới) — không cần chạy lại. Việc tiếp theo là mục 2.

---

## 1. Trạng thái: Vét cạn 4.080 tổ hợp — ✅ HOÀN THÀNH 10/09/2026 09:18

- File kết quả CHÍNH THỨC: `Wharf100DWT/results/Wharf100DWT_BRUTEFORCE_FINAL.mat`
- **59/4.080 nghiệm Pareto** (3.337 tổ hợp khả thi, 743 bị phạt cứng)
- Đây là **mặt Pareto tham chiếu CHÍNH THỨC duy nhất** dùng cho toàn bộ bài báo.
- Log đầy đủ: `results/campaign_bruteforce_4080_FINAL.log` (đã kết thúc, có dòng `HOAN THANH brute-force`).

**Hành trình vận hành (chỉ để tham khảo, KHÔNG liên quan nội dung khoa học)**: chạy từ 08/09 16:28 đến 10/09 09:18 (~41 giờ đồng hồ tường so với ETA lý thuyết ~19 giờ), gặp 10 lần gián đoạn (SAP2000 deadlock 1 worker ghim CPU cao, hoặc mất kết nối IPC hàng loạt worker) — tất cả đã tự phục hồi qua checkpoint mỗi chunk (100 tổ hợp), **không mất tổ hợp nào**. Watchdog tự động (`ops/watchdog_bruteforce.sh`) đã xử lý toàn bộ, không cần can thiệp thủ công cho phần lớn các lần. Chi tiết kỹ thuật các bug đã sửa TRƯỚC KHI chạy (TCVN 2025, bug bảng $q_b$, thiếu ràng buộc kéo/nhổ cọc, rò rỉ tiến trình SAP2000) xem mục 4 của file bàn giao 08/09.

**Script vận hành còn lại trong `Wharf100DWT/ops/`** (không cần dùng nữa nhưng giữ lại làm tham khảo cho campaign MOFDA/MOSFOA tiếp theo nếu cần watchdog tương tự): `relaunch_bruteforce.ps1`, `watchdog_bruteforce.sh` (watchdog v2: phát hiện treo bằng độ trễ log >40 phút + xác nhận khởi động nhanh sau relaunch + tối đa 20 lần tự khôi phục — xem [[sap2000-matlab-optimization-lessons]] để biết chi tiết pattern này).

---

## 2. Việc TIẾP THEO (ưu tiên số 1 khi mở phiên mới)

### 2.1. Chạy MOFDA 30 lần + MOSFOA 30 lần

`run_mosfoa_stats_wharf100dwt.m` đã viết xong (09/09/2026), đã qua `checkcode` sạch (0 lỗi, 0 cảnh báo), phỏng theo đúng `run_mofda_stats_wharf100dwt.m` đã có sẵn, dùng đúng tiêu chí so khớp chính xác ngưỡng $10^{-6}$ đã chốt.

**CHƯA CHẠY** — chạy trong MATLAB (không cần watchdog phức tạp như vét cạn vì nhờ cache Bước A, dự kiến chạy rất nhanh — vài phút/lần thay vì hàng giờ, do lưới thiết kế đã phủ 100% từ vét cạn):

```matlab
cd('D:\ResearchLab\02_Projects\02_Projects\MOFDA\Wharf100DWT');
run_mofda_stats_wharf100dwt(30, 8, 50, 50);      % 30 lan MOFDA, Np=50 maxiter=50, FE=12.550
run_mosfoa_stats_wharf100dwt(30, 8, 50, 250);    % 30 lan E-MOSFOA, Np=50 Max_it=250, FE=12.550
```

Có thể chạy tuần tự trong 1 lệnh `matlab -r` (không cần Start-Process riêng biệt như vét cạn, vì mỗi lần chạy dự kiến chỉ vài phút — nhưng NẾU cache miss nhiều hơn dự kiến và chạy lâu, vẫn nên dùng watchdog theo đúng pattern đã validate ở mục 1, xem `sap2000-matlab-optimization-lessons`).

Nếu cache KHÔNG phủ tốt như kỳ vọng (một trong hai script chạy hàng giờ thay vì vài phút) — dừng lại kiểm tra `wharf100dwt_evaluate.m` có đang nạp đúng `Wharf100DWT_BRUTEFORCE_FINAL.mat` không trước khi để chạy tiếp lâu.

### 2.2. Sau khi có kết quả 30+30 lần

Theo đúng thứ tự mục 6 của bàn giao 08/09 (đánh số lại ở đây cho rõ, các mục 1-2 ở đó đã ✅ xong):

1. Tính IGD/HV/tỷ lệ trùng khớp chính xác (ngưỡng $10^{-6}$)/Wilcoxon (theo đề cương mục D.5.3 — GD chỉ giữ nếu bổ sung thông tin).
2. Dựng đường cong IGD/HV theo FE từ `History.ArchiveFitness`/`History.Hypervolume` (đã có sẵn trong cả 2 connector từ 08/09) cho Mục 6.4 bài báo.
3. Kiểm chứng lại hiện tượng "dồn biên" (boundary clustering) từ mặt Pareto vét cạn CHÍNH THỨC 59 nghiệm — **không giả định trước, kiểm tra thật với dữ liệu mới** (mặt Pareto này khác mặt 16-nghiệm của bài cũ 243 tổ hợp).
4. Viết bài theo khung đề cương Mục D (`DE_CUONG_BAI_BAO_MOFDA_MOSFOA_SO_SANH_THUAT_TOAN.md`) — nhớ tách nội dung hạ tầng/code khỏi nội dung khoa học; dùng thống nhất thuật ngữ "khối lượng vật liệu".

---

## 3. Quyết định/giả thiết đã chốt — GIỮ NGUYÊN, không tự ý đổi

(Giống hệt mục 7 của bàn giao 08/09, chép lại đây cho đầy đủ)

- Thuật ngữ hàm mục tiêu: CHỈ "khối lượng vật liệu" (không dùng "khối lượng kết cấu").
- Tiêu chí "tìm được nghiệm Pareto tham chiếu": so khớp CHÍNH XÁC trên fitness, ngưỡng $10^{-6}$.
- Chiều dài ngàm cọc GIỮ CỐ ĐỊNH khi D thay đổi (BTCT L=29m, thép L=30m).
- Mũi BTCT trong Lớp 10 (đất dính); mũi thép trong Lớp 11 (đá, cọc chống). Cọc bịt kín mũi.
- Không xét hiệu ứng nhóm cọc (giới hạn nghiên cứu, nêu ở Mục 6.5).
- $\gamma_k=1{,}4$ (nén), $\gamma_n=1{,}15$ (GIẢ THIẾT cấp C2), $K_s=0{,}32$ Lớp 11 (GIẢ THIẾT).
- Tên bài: "MOSFOA" ở tiêu đề/tóm tắt, "E-MOSFOA" khi mô tả kỹ thuật cụ thể (Mục 4.2). B-MOSFOA chỉ nhắc ngắn ở Mở đầu.

---

## 4. Bản đồ file quan trọng (cập nhật)

| File | Vai trò | Trạng thái |
|---|---|---|
| `Wharf100DWT/results/Wharf100DWT_BRUTEFORCE_FINAL.mat` | Mặt Pareto tham chiếu CHÍNH THỨC (59 nghiệm) | ✅ Hoàn thành 10/09 |
| `Wharf100DWT/run_mofda_stats_wharf100dwt.m` | Chạy 30 lần MOFDA + GD/IGD | Có sẵn, CHƯA chạy 30 lần chính thức |
| `Wharf100DWT/run_mosfoa_stats_wharf100dwt.m` | Chạy 30 lần E-MOSFOA + GD/IGD | **Mới viết 09/09**, checkcode sạch, CHƯA chạy |
| `Wharf100DWT/run_mofda_wharf100dwt_parallel.m` | MOFDA + SAP2000 + History hội tụ | ✅ Sẵn sàng |
| `Wharf100DWT/run_emosfoa_wharf100dwt_parallel.m` | E-MOSFOA + SAP2000 + History hội tụ | ✅ Sẵn sàng |
| `Wharf100DWT/ops/watchdog_bruteforce.sh` + `relaunch_bruteforce.ps1` | Watchdog tự động cho campaign dài | Đã dùng xong cho vét cạn, có thể tái dùng mẫu này nếu bước 2 cần |
| `DE_CUONG_BAI_BAO_MOFDA_MOSFOA_SO_SANH_THUAT_TOAN.md` | Đề cương bài báo | ĐÃ CHỐT |
