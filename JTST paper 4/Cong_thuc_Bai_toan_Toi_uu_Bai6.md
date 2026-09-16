# Công thức bài toán tối ưu — Bài 6 (JTST paper 4)

> Tài liệu đặc tả kỹ thuật, đóng vai trò tương đương `Cong_thuc_Bai_toan_Toi_uu.md` của Bài 2 (MOSFOA paper 2). Đây là bản **DRAFT cần bạn duyệt trước khi viết code SAP2000-OAPI**. Các mục đánh dấu **[OPEN]** là điểm tôi chưa đủ căn cứ để tự quyết, cần bạn xác nhận/bổ sung.

---

## 1. Biến thiết kế

| Ký hiệu | Ý nghĩa | SAP section | Baseline (t3) | Miền giá trị | Bước |
|---|---|---|---:|---:|---:|
| X1 | h_DN (chiều cao dầm ngang) | `DN`, t2=1,00m cố định | 1,55 m | [1,10 ; 2,00] m | 0,05 m |
| X2 | h_DD (chiều cao dầm dọc) | `DD`, t2=1,00m cố định | 1,55 m | [1,10 ; 2,00] m | 0,05 m |
| X3 | h_DCT (chiều cao dầm cần trục) | `DCT`, t2=1,30m cố định | 1,95 m | [1,40 ; 2,50] m | 0,05 m |
| X4 | t_BMC (chiều dày bản mặt cầu) | `BMC` (area) | 0,35 m | [0,25 ; 0,45] m | 0,05 m |

Nguồn baseline: xác nhận trực tiếp từ `Ben so 1 Chan May.s2k` dòng 92/95/98 (t3=chiều cao, t2=bề rộng cố định). Mỗi biến rời rạc thành danh sách cách đều 0,05 m trong miền → X1,X2: 19 giá trị; X3: 23 giá trị; X4: 5 giá trị. Không gian tìm kiếm = 19×19×23×5 = 41.515 tổ hợp (liên tục theo nghĩa MOSFOA, không vét cạn).

Cố định (không phải biến): cọc `Coc1` (D700/t12,6mm mô hình FEM), tiết diện `MR` (18 phần tử), bề rộng b của DN/DD/DCT, toạ độ hình học.

---

## 2. Hàm mục tiêu

**f1 — khối lượng bê tông nhóm kết cấu bên trên** (Tấn):

$$f_1(\mathbf{x}) = \rho_{DN}\cdot b_{DN}\cdot X_1\cdot L_{DN} + \rho_{DD}\cdot b_{DD}\cdot X_2\cdot L_{DD} + \rho_{DCT}\cdot b_{DCT}\cdot X_3\cdot L_{DCT} + \rho_{BMC}\cdot X_4\cdot A_{BMC}$$

Trong đó $L_{DN}=282$, $L_{DD}=210$, $L_{DCT}=140$ (số phần tử gán × chiều dài phần tử — sẽ lấy tổng chiều dài thật qua OAPI `FrameObj.GetPoints`, không giả định chiều dài đều nhau), $A_{BMC}$=tổng diện tích 1.750 phần tử area (qua `AreaObj.GetPoints`). $\rho$ theo vật liệu đã xác nhận (M400-DN: 1,935 T/m³; M400-DCT: 2,05 T/m³; M400: 2,50 T/m³ — mục 3 `FEM_Ben70000DWT_ChanMay.md`).

**f2 — hệ số khai thác lớn nhất** (không thứ nguyên):

$$f_2(\mathbf{x}) = \max\left(\eta_{DN}, \eta_{DD}, \eta_{DCT}, \eta_{BMC}\right), \quad \eta_i = \frac{M_{Ed,i}}{M_{u,i}(\mathbf{x})}$$

$M_{Ed,i}$ = mô-men bất lợi nhất trên cấu kiện loại i dưới tổ hợp bao `BAO-ULSB` (M2,M3 tổng hợp cho frame; M11/M22 cho area BMC). $M_{u,i}$ tính theo mục 3 dưới đây, là hàm của biến thiết kế (tiết diện thay đổi → Mu thay đổi).

---

## 3. Công thức Mu (TCVN 5574:2018, tiết diện chữ nhật đặt cốt đơn, As theo điều kiện cân bằng ξ=ξ_R)

Theo quyết định của bạn: As lấy theo điều kiện cân bằng (ξ=ξ_R) — tức Mu là **mô-men kháng uốn lớn nhất khả dĩ** của riêng tiết diện bê tông (không phụ thuộc As thật đã thi công, chỉ phụ thuộc b, h, Rb, Rs):

$$\xi_R = \dfrac{\omega}{1+\dfrac{\sigma_{sR}}{\sigma_{scu}}\left(1-\dfrac{\omega}{1{,}1}\right)}, \qquad \omega = \alpha_{R1} - 0{,}008\,R_b$$

$$\alpha_R = \xi_R\left(1-0{,}5\xi_R\right), \qquad M_u = \alpha_R\, R_b\, b\, h_0^2$$

- $\alpha_{R1}=0{,}85$ (bê tông nặng thường), $\sigma_{scu}=500$ MPa.
- $R_b$: cường độ chịu nén tính toán bê tông M400 — **[OPEN]** thuyết minh chỉ cho R=40MPa (cường độ mẫu lập phương/mác danh định), chưa có Rb tính toán theo TCVN 5574:2018 (cần quy đổi qua hệ số điều kiện làm việc γb và cấp độ bền B tương ứng). Tôi sẽ dùng quy đổi tiêu chuẩn M400≈B30 → Rb≈17 MPa (giá trị bảng TCVN 5574:2018) trừ khi bạn có số liệu khác — cần bạn xác nhận.
- $R_s$: cốt thép chịu kéo — dùng CB300-V (Rs=260 MPa tính toán, theo TCVN 5574:2018 bảng cho Rs=0,8÷0,9×Fy danh nghĩa) thay cho A615Gr60 mặc định SAP — **[OPEN]** cần xác nhận dùng CB300-V hay CB240-T (thuyết minh có cả 2 loại, không rõ loại nào dùng cho dầm DN/DD/DCT cụ thể).
- $h_0 = h - a$, lớp bảo vệ $a$=cover+ d_thanh/2 ≈ 0,065 m (cover 40mm theo SAP + giả định Ø25 → dùng 65mm tổng, có thể tinh chỉnh).
- $b$ = bề rộng cố định của từng loại dầm (1,00m cho DN/DD; 1,30m cho DCT).

**BMC (bản, area section)**: tính theo dải bản rộng 1m, $b=1$ m, $h=X_4$, Mu tính tương tự trên cho 1m dài, so sánh với M11/M22 lớn nhất trên 1m bề rộng (SAP2000 area output đã có sẵn đơn vị mô-men/m).

---

## 4. Ràng buộc (feasibility — phạt cứng, giống Bài 2)

| # | Ràng buộc | Công thức |
|---|---|---|
| g1 | Khai thác cấu kiện bên trên | $\eta_{DN},\eta_{DD},\eta_{DCT},\eta_{BMC} \le 1$ (đã là f2, nhưng vẫn gate feasibility riêng — 1 nghiệm η>1 luôn infeasible dù có bị MOSFOA tối thiểu hoá) |
| g2 | Chuyển vị ngang đỉnh bến | $U_{max} \le U_{allow} = L/240$, $L$=khoang cọc dọc bến ≈5,2m → $U_{allow}$≈21,7mm (quy ước, nêu rõ là giả thiết khi viết bài) |
| g3 | Sức chịu tải cọc theo đất nền | $\gamma_n \cdot N_{max,coc} \le R_d$ — **[OPEN xem mục 5]** |
| g4 | Ứng suất thép cọc | $\sigma_{coc} = N_{max}/A_{coc} \le F_y/\gamma$, $F_y$=3.150 kG/cm² (proxy, đã xác nhận Paper 2/FEM doc mục 11) |

---

## 5. Sức chịu tải cọc theo đất nền — ĐÃ TÍNH (nguồn dữ liệu: user + tự tra DXF/Excel)

Vì cọc **không đổi kích thước** (D/t/L cố định), $R_d$ là **một hằng số duy nhất**, tính 1 lần.

**Dữ liệu xác nhận**:
- Cao độ đáy đài = **+2,50 m** (Hải đồ) — user xác nhận trực tiếp, 2026-09-15.
- Chiều dài cọc thật $L_n$ = 44–49 m (sheet "L coc", `Thong so Ben 1 cang Chan May.xls` — KHÔNG phải chiều dài ngàm ảo Lu). Dùng $L_n$=49 m (giá trị lặp lại ở 2/3 lỗ khoan tra được, BH13/BH16) → **cao độ mũi cọc = 2,5 − 49 = −46,5 m** (Hải đồ).
- Cao độ mặt đất tự nhiên (đáy biển) suy từ $l_0$ (đáy đài→mặt đất, sheet "L coc", lỗ khoan LK2 ≈14,1–15,4m, TB≈14,75m): 2,5−14,75 ≈ **−12,25 m** — khớp gần như tuyệt đối với "cao trình đáy bến phía biển −12,50m (Hải đồ)" đã có sẵn ở mục 1 `FEM_Ben70000DWT_ChanMay.md` ⇒ điểm đối chiếu chéo tốt, tăng độ tin cậy của Ln=49m.
- Cao độ đỉnh đá gốc (Lớp 5, granit) tại Block V: **−51,5 m** (đọc trực tiếp từ DXF "10/11/12. Mặt bằng bố trí đệm và mối nối", mặt cắt "MẶT CẮT NGANG BẾN B-B" gắn với nhãn "PHÂN ĐOẠN (BLOCK) V" + lỗ khoan "LK2-02", số xuất hiện lặp lại nhất quán ở 2 vị trí). ⇒ Mũi cọc (−46,5m) nằm **trong Lớp 4 (Sét dẻo mềm)**, chưa chạm đá gốc — khớp với mục 8.1 (đáy Lớp 4 dao động −36,65 đến −51,6m).
- Chiều sâu ngàm trong đất (từ mặt đất tự nhiên đến mũi cọc) = −12,25 −(−46,5) = **34,25 m**, phân bổ theo tỷ lệ bề dày trung bình các lớp 1-4 (mục 8.1: TB 7,5/7,5/14,5/~7m) → L1≈7,0m; L2≈7,0m; L3≈13,5m; L4≈6,75m (ước lượng tỷ lệ, do không đủ dữ liệu khớp chính xác ranh giới từng lớp tại đúng LK2).

**Tính $R_{c,u}$** (TCVN 10304:2014 dạng tĩnh, D=0,70m ống thép, u=πD=2,199m, Ab=0,385m²):

| Lớp | Loại | f_i hoặc q_b (kPa) | l_i (m) | Đóng góp (kN) |
|---|---|---:|---:|---:|
| Mũi (Lớp 4, sét dẻo mềm) | q_b=Nc·Cu=9×21,5 | 193,5 | Ab=0,385m² | 74,5 |
| 1 (Bùn sét cát) | f=α·Cu, α=0,9, Cu=8,5 | 7,65 | 7,0 | 53,5×u |
| 2 (Sét cát) | f=α·Cu, α=0,85, Cu=11 | 9,35 | 7,0 | 65,5×u |
| 3 (Cát hạt trung) | f=K₀σ'ᵥtanφ, φ=31,27° | ≈47,3 | 13,5 | 638,6×u |
| 4 (Sét dẻo mềm, đoạn thân) | f=α·Cu, α=0,8, Cu=21,5 | 17,2 | 6,75 | 116,1×u |

Skin friction ≈ u×(53,5+65,5+638,6+116,1) = 2,199×873,7 ≈ **1.921 kN**. Tổng $R_{c,u}$ = 74,5+1.921 ≈ **1.996 kN ≈ 203,5 Tấn**.

$\gamma_k$=1,75 (thiên về an toàn do nhiều số liệu là ước lượng gián tiếp) → $R_d$ = 203,5/1,75 ≈ **116 Tấn**.

⚠️ **CẬP NHẬT (2026-09-15, sau khi chạy live trên FEM thật) — Rd=116 Tấn BỊ BÁC BỎ bởi dữ liệu thật:** `test_extreme_eval.m` (chạy trực tiếp `evaluate_superstructure_design.m` tại 2 điểm biên của miền X1-X4) cho thấy $N_{max,pile}$ dao động **210,0 – 229,7 Tấn trên TOÀN BỘ miền tìm kiếm** (tải cọc chủ yếu do hoạt tải tàu/cần trục/hàng hoá — gần như không đổi theo X1-X4, vì tự trọng siêu cấu trúc chỉ là phần nhỏ). Với $R_d$=116 Tấn, **100% không gian thiết kế sẽ bị đánh giá "không khả thi"** theo g3 — vô lý vì công trình thật đã vận hành ổn định nhiều năm với đúng tải này. Kết luận: chuỗi ước lượng địa kỹ thuật trên (γk=1,75, phân bổ chiều dày lớp theo tỷ lệ trung bình, Nc=9...) tính **thiên về an toàn quá mức so với thực tế** — không đủ tin cậy để dùng làm $R_d$.

**QUYẾT ĐỊNH NGƯỜI DÙNG (2026-09-15):** bỏ chuỗi suy luận địa kỹ thuật chi tiết ở trên, thay bằng **giá trị quy ước $R_d$=450 Tấn**, đại diện năng lực chịu tải thông thường của cọc ống thép D700 trong nền đất tốt (không suy ra riêng cho địa chất Chân Mây) — **phải nêu rõ đây là giả định nghiên cứu (không phải kiểm định địa kỹ thuật thật) khi viết bài báo**, nhất quán với việc Bài 6 không nhằm đánh giá công trình hiện hữu (mục 1.2 đề cương).

**Ràng buộc g3**: $\gamma_n \cdot N_{max} \le R_d$, với $\gamma_n$=1,15 (carry-over Bài 2), $R_d$=450 Tấn (quy ước) → $N_{max} \le 450/1{,}15 ≈ 391$ Tấn/cọc — dư margin thoải mái so với $N_{max}$ thật (210-230 Tấn), g3 gần như không khống chế trong miền X1-X4 đã chọn (hợp lý, vì cọc không phải biến thiết kế của Bài 6).

---

## 6. Xử lý tổ hợp tải trọng

Theo quyết định: dùng **`BAO-ULSB`** (bao 388 tổ hợp ULS) cho $M_{Ed}$ (g1/f2) và $N_{max}$ cọc (g3/g4); dùng **`BAO-SLSDH`** (bao 20 tổ hợp SLS) cho $U_{max}$ (g2). Cả 2 combo bao đã có sẵn trong model (`Ben so 1 Chan May.s2k`, mục 10 FEM doc) — không cần định nghĩa lại, chỉ chọn đúng tên qua `SetComboSelectedForOutput`.

Với các nghiệm Pareto đại diện cuối cùng (không phải trong vòng lặp tối ưu): chạy lại, tách riêng 388+20 tổ hợp để xác định tổ hợp chi phối cho bảng mục 13.7 đề cương.

---

## 7. Vấn đề mô hình cần xử lý trước khi chạy (kế thừa từ `FEM_Ben70000DWT_ChanMay.md` mục 7)

- **Nút 1945 thiếu ngàm**: 96 cọc nhưng chỉ 95 nút có `JOINT RESTRAINT`. Tôi sẽ **tự thêm ngàm 6 bậc tự do cho nút 1945** (giống 95 nút còn lại) khi build model làm việc — đây rõ ràng là thiếu sót khai báo (mọi cọc phải có ngàm ảo), không phải chủ ý thiết kế. Sẽ làm qua OAPI, giữ nguyên file gốc, chỉ sửa bản copy dùng cho tối ưu. Báo lại nếu bạn muốn giữ nguyên hiện trạng.

---

## 8. Kiến trúc code (tái dùng khung Bài 2)

`code/project_config_bai6.m` (hằng số: đường dẫn model, tên section/material, Rb/Rs, Rd đã tính sẵn, U_allow, γn...) · `code/evaluate_superstructure_design.m` (tương đương `evaluate_pile_design.m`: SetRectangle cho DN/DD/DCT, đổi Thickness cho BMC, RunAnalysis, trích M/N/U theo mục 6, tính Mu theo mục 3, chấm điểm f1/f2/feasibility) · `code/run_mosfoa6_parallel.m` (copy lõi thuật toán MOSFOA verbatim từ MOFDA/Bài 1, như Bài 2 đã làm) · `code/diagnose_bai6.m` (script chẩn đoán ĐẦU TIÊN, bắt buộc theo bài học Bài 2 mục 1.4: in tên section/combo/section-assignment thật, đối chiếu bằng tay, trước khi tin bất kỳ campaign nào).

---

## 9. Checklist trạng thái các quyết định

| Mục | Trạng thái |
|---|---|
| Biến thiết kế X1-X4, miền giá trị, bước rời rạc | ✅ Đã chốt |
| Objective 1 (khối lượng), Objective 2 (η_max) | ✅ Đã chốt |
| Xử lý 410 tổ hợp (2 combo bao) | ✅ Đã chốt |
| Ràng buộc cọc có đưa vào không | ✅ Đã chốt — có |
| Ràng buộc chuyển vị U_allow=L/240 | ✅ Đã chốt (quy ước, nêu rõ khi viết bài) |
| As cốt thép theo ξ=ξ_R | ✅ Đã chốt |
| Rb bê tông M400 (quy đổi sang TCVN 5574:2018) | 🟡 Đề xuất B30/Rb≈17MPa — cần xác nhận |
| Rs cốt thép CB300-V hay CB240-T cho dầm | 🟡 Đề xuất CB300-V — cần xác nhận |
| Cao độ mũi cọc / Rd | ✅ Đã tính — đáy đài +2,5m (user xác nhận) + Ln=49m (Excel) + đỉnh đá −51,5m (DXF) → Rd≈116 Tấn (chuỗi ước lượng, xem mục 5, cần user rà soát độ hợp lý) |
| γn = 1,15 (carry-over từ Bài 2) | 🟡 Đề xuất — cần xác nhận |
| Sửa nút 1945 thiếu ngàm | 🟡 Đề xuất tự sửa — báo nếu không đồng ý |
| Tham số MOSFOA (Npop/Max_it/Nrun) | ⚪ Chưa xác định — cần chạy pilot đo thời gian 1 eval trước (giống quy trình Bài 2 mục "3 bước xác thực") |
