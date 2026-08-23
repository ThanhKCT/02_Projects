# ✅ ĐÃ XONG — xem `DOI_CHIEU_CONG_THUC_M1_M6_FINAL.md`

Người dùng đã đối chiếu xong toàn bộ công thức M1 (h_gđ, trang 123) và M2–M6 (trang 127–130) trực tiếp từ ảnh gốc. Kết quả đã được đưa vào `Paper1_JMST_Draft_v1.md` §3 (DRAFT v3). File này giữ lại làm hồ sơ tra cứu trang/công thức, không cần làm gì thêm.

---

# TODO — Đối chiếu bằng mắt công thức M1 (h_gđ) và M2–M6 (làm thủ công)

*(Tên file giữ nguyên "M2_M6" để không hỏng các đường link đã gửi trước, nhưng nay đã gồm cả M1 — trang 123 — vì hgđ cũng thiếu.)*

**Lý do**: công thức (3.22)–(3.29) trong `Giao trinh Cong trinh ben.doc` là đối tượng ảnh/equation object nhúng, không trích được qua Word COM automation (đã thử 6 cách xuất file khác nhau, Word đều treo ở bước lưu/export trên máy này — không tiếp tục thử tự động nữa). Mở file trực tiếp và xem bằng mắt sẽ nhanh hơn nhiều.

**File cần mở**: `Giao trinh Cong trinh ben.doc` (cùng thư mục `Paper 1`).

## Việc cần làm — kéo tới đúng trang, đọc công thức, so với draft

| Trang | Công thức cần xem | Đang tạm dùng trong draft (`Paper1_JMST_Draft_v1.md`) | Cần xác nhận |
|---|---|---|---|
| **123** | (3.2)–(3.8) — `h_gđ` theo Case 1/2/4 và hệ số `mε` (22TCN 207-92, M1) | **Chưa tính được** — đây cũng là equation object, không trích được qua text. `pile_hz_input_table.csv` hiện chỉ có hình học thô (giao điểm mái dốc, `H0`), chưa có `h_gđ` thật vì thiếu công thức này | Cần chép công thức (3.2), (3.3), (3.7), (3.8) và `mε` (3.4)-(3.6) để tính `h_gđ` cho từng Case — **đây là formula quan trọng nhất còn thiếu**, chặn toàn bộ M1 |
| **127** | (3.22a), (3.23a) — 20TCN21-86/TCXD 205-1998 (M2) | `l_tt = l_0 + 2/α_bd`, `α_bd = ⁵√(K·b/(γ_c·E·I))` | Hệ số "2" trong `l_0 + 2/α_bd` đúng không? Có `γ_c` trong công thức `α_bd` của M2 không, hay chỉ M3/M4 mới có? |
| **128** | (3.22b), (3.23b) — TCVN 10304:2014 (M3) | Cùng dạng như M2, `γ_c = 3` | Xác nhận cùng hệ số "2"; kiểm tra vị trí đúng của `γ_c` trong công thức |
| **129 (trên)** | (3.24), (3.25) — Tiêu chuẩn Nga (M4) | Cùng dạng `l_0 + 2/α_bd` | Xác nhận công thức M4 thực sự cùng dạng M2/M3, không có khác biệt hệ số |
| **129 (dưới)** | (3.26), (3.27) — Budin–Demina (M5) | `l_tt = l_0 + l_1`, `l_1` phụ thuộc `β` (tra đồ thị), `k_g`, `d`, `EI` — **chưa có công thức đóng cho `l_1`** | Cần chép đúng công thức (3.26)/(3.27) liên hệ `l_1` với `β`, `k_g`, `d`, `EI` — đây là chỗ thiếu nhiều nhất, không đoán được từ dạng chuẩn vì M5 dùng đồ thị riêng |
| **130** | (3.28), (3.29) — Nhật Bản (M6) | `β = ⁴√(K_h·D/(4·EI))`, `l_tt = l_0 + 1/β` | Hệ số "4" dưới dấu căn trong (3.28) đúng không? |

## Sau khi xem xong, cập nhật trong `Paper1_JMST_Draft_v1.md`

1. Sửa công thức (4)–(8) ở §3.3–3.5 nếu hệ số khác với bản đang để tạm.
2. Xóa các đoạn đánh dấu 🔶 "Ghi chú xác minh (chưa đối chiếu ảnh gốc)" dưới Bảng 3 và trong §3.5 sau khi đã xác nhận đúng.
3. Nếu công thức M5 (Budin–Demina) khác nhiều so với mô tả tạm ở trên, viết lại toàn bộ §3.4 cho khớp — đây là phần có độ chắc chắn thấp nhất hiện tại.

## Không cần làm nếu không muốn

Nếu chấp nhận dùng luôn dạng chuẩn hiện tại (đây là dạng phổ biến, đúng theo TCVN 10304:2014 Annex G / SNiP 2.02.03-85, khớp với toàn bộ biến số đã xác nhận từ văn bản gốc), có thể bỏ qua bước này và chỉ nói rõ trong bài là "áp dụng dạng chuẩn của phương pháp hệ số biến dạng" — nhưng nên đối chiếu trước khi tính số thật cho 178 cọc, vì sai hệ số "2" sẽ làm sai toàn bộ `l_tt` của M2/M3/M4.
