# REVIEWER REPORT — PAPER 1 — BẢN SỬA LẦN 4

## 0. Phạm vi

Báo cáo này dùng để Claude thực hiện **final polishing** cho Paper 1 sau bản sửa lần 4.

Bối cảnh:
- Tác giả là NCS mới tiếp cận SOO.
- Bài bằng tiếng Việt, định hướng tạp chí Xây dựng trong nước.
- Paper 1 thuộc roadmap: **SFOA → SOO → trade-off → MOSFOA/MOO**.
- Không biến Paper 1 thành bài MOO.
- Không thêm benchmark PSO/GA/DE/GWO.
- Không thêm sensitivity analysis lớn.
- Mục tiêu vòng này: **đúng, minh bạch, nhất quán, không overclaim, sẵn sàng gửi**.

---

# 1. PHÁN QUYẾT

**MINOR REVISION — gần READY FOR SUBMISSION.**

Bản sửa lần 4 đã xử lý tốt các vấn đề chính của vòng trước, đặc biệt đã hậu kiểm DesignConcrete cho hai nghiệm được báo cáo:
- MJP-C: 29 dầm, không có phần tử không đạt.
- MJP-D: 80 dầm, không có phần tử không đạt.
- ErrorSummary/WarningSummary rỗng.

Điểm còn cần sửa chủ yếu là **logic diễn đạt**, không phải mở rộng nghiên cứu.

---

# 2. CÁC ĐIỂM ĐÃ PASS — KHÔNG MỞ RỘNG

## 2.1. DL+LL / Envelope
Đã làm rõ COMB1=DL, COMB2=DL+LL, BAO là Envelope; Dmax và constraint cọc lấy từ BAO; tải factor chỉ dùng cho DesignConcrete.

**PASS. Giữ nguyên.**

## 2.2. Dmax = 0,0000388 m
Đã giải thích nguồn JointDisplAbs, resultant, toàn bộ node, BAO và plateau. 30 vector tốt nhất cũng đã được kiểm tra.

**PASS. Không cần mở rộng.**

## 2.3. Beam verification
Đã hậu kiểm hai nghiệm được báo cáo và xác nhận toàn bộ dầm đạt.

**PASS, nhưng phải giữ đúng phạm vi: chỉ hậu kiểm hai nghiệm, không phải toàn bộ 60 run.**

## 2.4. TCVN/serviceability
Đã không còn khẳng định 1,02 mm nằm trong giới hạn TCVN.

**PASS. Không bổ sung giới hạn TCVN nếu chưa có dữ liệu/cơ sở.**

## 2.5. Pareto
Đã ghi rõ hai nghiệm cực trị không phải Pareto front.

**PASS. Không thêm Pareto front.**

## 2.6. Benchmark
Đã ghi rõ không so sánh PSO/GA/DE/GWO nên không xếp hạng SFOA.

**PASS. Không bổ sung benchmark.**

## 2.7. Sensitivity
Đã ghi rõ không thực hiện sensitivity analysis.

**PASS. Không bổ sung sensitivity.**

## 2.8. Computational cost
Đã có:
N_eval = 30 × (150+1) = 4.530 evaluation/run,
tổng 60 run khoảng 67,3 giờ.

**PASS. Giữ nguyên.**

---

# 3. ISSUE QUAN TRỌNG: BEAM VERIFICATION CHƯA LÀ CONSTRAINT

## Mức: P1

Bài đã minh bạch rằng:
- DesignConcrete được chạy để lấy Ws;
- VerifyPassed/VerifySections không được đưa vào vòng tìm kiếm;
- chỉ constraint cọc ảnh hưởng trực tiếp tới SFOA;
- hai nghiệm cuối cùng được hậu kiểm và đều đạt.

Điều này có thể chấp nhận cho Paper 1 nếu diễn đạt đúng.

### Không được viết như thể:
SFOA đã tối ưu trên toàn bộ không gian thiết kế có đầy đủ beam constraints.

### Phải giữ rõ:
> Beam verification chỉ được thực hiện hậu kiểm cho hai nghiệm được báo cáo.

### Không tự ý chạy lại 60 run chỉ vì vấn đề này.

---

# 4. ĐỔI “NGHIỆM TỐI ƯU” THÀNH “NGHIỆM TỐT NHẤT TÌM ĐƯỢC” Ở CÁC VỊ TRÍ CẦN THIẾT

Ưu tiên:
- “nghiệm tối ưu chi phí” → **“nghiệm tốt nhất tìm được theo mục tiêu chi phí”**
- “nghiệm tối ưu chuyển vị” → **“nghiệm tốt nhất tìm được theo mục tiêu chuyển vị”**

Tiếng Anh:
- **best-found cost solution**
- **best-found displacement solution**

Không cần thay máy móc mọi từ “optimal” nếu chỉ là tên case, nhưng trong các claim khoa học phải tránh hàm ý đã chứng minh global optimum.

---

# 5. ABSTRACT — PHẢI SỬA CLAIM

Không nên viết:

> “không có nghiệm nào vi phạm ràng buộc kỹ thuật.”

Đề nghị:

> **“Tất cả các nghiệm tốt nhất của 30 lần chạy đều thỏa các ràng buộc cọc được triển khai trong quá trình tối ưu; hai nghiệm tốt nhất được báo cáo tiếp tục được hậu kiểm và đều đạt yêu cầu thiết kế dầm.”**

Có thể rút gọn nếu cần giới hạn từ.

---

# 6. KẾT LUẬN — PHẢI SỬA CLAIM

Không nên viết:

> “SFOA nguyên bản hội tụ ổn định và cho nghiệm khả thi kỹ thuật trên cả hai bài toán...”

Đề nghị:

> **“SFOA nguyên bản cho các nghiệm tốt nhất thỏa các ràng buộc cọc được triển khai trong quá trình tối ưu; hai nghiệm tốt nhất được báo cáo đều đạt hậu kiểm thiết kế dầm.”**

---

# 7. GIẢM CLAIM “KHÔNG CÓ MỘT THIẾT KẾ TỐT NHẤT”

Câu hiện tại:

> “không có ‘một thiết kế tốt nhất’ duy nhất khi xét đồng thời hai tiêu chí.”

Câu này mạnh hơn bằng chứng.

Đề nghị:

> **“Kết quả cho thấy lựa chọn thiết kế phụ thuộc đáng kể vào tiêu chí ưu tiên khi đồng thời xem xét chi phí và chuyển vị.”**

Không suy diễn thành kết luận về toàn bộ Pareto front.

---

# 8. “HỘI TỤ TUYỆT ĐỐI” — NÊN GIẢM CLAIM

CV=0% chứng minh 30 giá trị Best-of-run giống nhau, không chứng minh:
- mọi trajectory giống nhau;
- một vector thiết kế duy nhất;
- global optimum.

Đề nghị thay:

> “hội tụ tuyệt đối trên cả 30 lần chạy”

bằng:

> **“giá trị mục tiêu tốt nhất có độ lặp lại tuyệt đối giữa 30 lần chạy”**

hoặc:

> **“30 lần chạy đều đạt cùng giá trị tốt nhất của hàm mục tiêu chuyển vị.”**

Giữ phần giải thích plateau hiện tại.

---

# 9. CV = 17,98% — DIỄN ĐẠT TRUNG TÍNH

Không cần viết:

> “mức biến động vừa phải, thường gặp ở các bài toán...”

nếu không có nguồn đối chiếu.

Đề nghị:

> **“MJP-Cost có mức phân tán giữa các lần chạy với CV = 17,98%, trong khi MJP-Displacement có CV = 0% về giá trị mục tiêu tốt nhất.”**

---

# 10. “DỮ LIỆU THỰC NGHIỆM” — PHẢI SỬA

Đây là nghiên cứu FEM số.

Thay:

> “Dữ liệu thực nghiệm xác nhận...”

bằng:

> **“Kết quả tính toán số cho thấy...”**

hoặc:

> **“Kết quả số cho thấy...”**

---

# 11. BẢNG 5 — KHUYẾN NGHỊ, KHÔNG BẮT BUỘC

Có thể thêm cột:

| Nghiệm | Cost | Disp. | Pile constraints | Beam verification |
|---|---:|---:|---|---|
| MJP-C | 5.291,86 | 0,00102 | Pass | Pass |
| MJP-D | 139.831,48 | 0,0000388 | Pass | Pass |

Nếu không muốn mở rộng bảng, giữ thông tin hậu kiểm ở đoạn văn hiện tại cũng được.

**Không tạo dữ liệu mới.**

---

# 12. PARALLEL COMPUTING TOOLBOX

Bảng 8 có “MATLAB R2023b + Parallel Computing Toolbox”.

Nếu thực tế không dùng parallel thì không cần mở rộng.

Nếu thực tế có dùng parallel, làm rõ mức sử dụng.

Chỉ ghi đúng thực tế, không suy đoán.

---

# 13. TUYỆT ĐỐI KHÔNG LÀM TRONG VÒNG NÀY

Không:
- thêm PSO;
- thêm GA;
- thêm DE;
- thêm GWO;
- thêm NSGA-II;
- thêm MOPSO;
- thêm Pareto front;
- thêm sensitivity analysis lớn;
- thêm nhiều case;
- thêm benchmark;
- tự tạo dữ liệu;
- tự sửa Cost/Dmax/design variables;
- khẳng định global optimum;
- biến Paper 1 thành Paper 2/MOSFOA.

---

# 14. REVISION MATRIX

| ID | Vấn đề | Mức | Hành động |
|---|---|---|---|
| R4-01 | Beam verification chưa là constraint | P1 | Giữ limitation, làm rõ hậu kiểm |
| R4-02 | “Nghiệm tối ưu” quá mạnh | P1 | Đổi sang “nghiệm tốt nhất tìm được” khi cần |
| R4-03 | Abstract claim quá rộng | P1 | Thu hẹp claim |
| R4-04 | Conclusion claim quá rộng | P1 | Thu hẹp claim |
| R4-05 | “Không có một thiết kế tốt nhất” | P1 | Đổi thành lựa chọn phụ thuộc tiêu chí |
| R4-06 | “Hội tụ tuyệt đối” | P2 | Đổi thành cùng giá trị mục tiêu tốt nhất |
| R4-07 | CV 17,98% “thường gặp” | P2 | Diễn đạt trung tính |
| R4-08 | “Dữ liệu thực nghiệm” | P1 | Đổi thành “kết quả tính toán số” |
| R4-09 | Beam verification trong Bảng 5 | P2 | Có thể thêm |
| R4-10 | Parallel Computing Toolbox | P2 | Làm rõ nếu thực tế có dùng |

---

# 15. CHECKLIST CUỐI

## Scientific claims
- [ ] Không claim global optimum.
- [ ] Không gọi hai nghiệm là Pareto solutions.
- [ ] Không nói SOO chứng minh toàn bộ trade-off.
- [ ] Không nói Cost và Displacement xung đột trên toàn bộ không gian.
- [ ] Không nói 1,02 mm đạt giới hạn TCVN.
- [ ] Không nói SFOA tốt hơn thuật toán khác.
- [ ] Không nói toàn bộ 60 run đã được beam verification.

## Numerical consistency
- [ ] MJP-C Cost = 5.291,8573 USD.
- [ ] MJP-C Dmax = 0,00102 m.
- [ ] MJP-D Cost = 139.831,4792 USD.
- [ ] MJP-D Dmax = 0,0000388 m.
- [ ] Baseline Cost = 25.708,9425 USD.
- [ ] Baseline Dmax = 0,00022445 m.
- [ ] 25,4 lần và 2.542,2% nhất quán.
- [ ] 96,2% nhất quán.
- [ ] -79,4%, +353,7%, +443,9%, -82,7% nhất quán.

## Model scope
- [ ] Beam DesignConcrete được mô tả đúng.
- [ ] Beam verification được xác định là hậu kiểm cho 2 nghiệm.
- [ ] Pile constraints được phân biệt với beam verification.
- [ ] Uplift limitation được giữ.
- [ ] Serviceability limitation được giữ.

## Terminology
- [ ] “Dữ liệu thực nghiệm” → “kết quả tính toán số”.
- [ ] “Optimal” → “best-found” khi cần.
- [ ] “Hội tụ tuyệt đối” → “cùng giá trị mục tiêu tốt nhất”.
- [ ] Không dùng “một thiết kế tốt nhất duy nhất” như kết luận tổng quát.

---

# 16. FINAL INSTRUCTION CHO CLAUDE

Hãy thực hiện **chỉ một vòng final polishing** dựa trên report này.

Quy trình:
1. Đọc toàn bộ manuscript hiện tại.
2. Đối chiếu R4-01 → R4-10.
3. Không mở rộng phạm vi.
4. Không tạo dữ liệu.
5. Không thay đổi các số liệu đã xác nhận.
6. Không chạy thêm nghiên cứu nếu không có dữ liệu/yêu cầu.
7. Sửa trực tiếp manuscript.
8. Sau khi sửa, thực hiện:
   - Claim Audit;
   - Numerical Consistency Audit;
   - Terminology Audit;
   - Scope Audit.
9. Báo cáo riêng các điểm chưa thể sửa vì cần tác giả xác minh.
10. Không tiếp tục cải thiện ngoài phạm vi report này.

## Mục tiêu cuối cùng

Đưa Paper 1 về trạng thái:

> **READY FOR SUBMISSION**

với một bài báo:

**Đúng — Minh bạch — Tái lập được — Không overclaim — Phù hợp phạm vi SOO — Phù hợp vai trò Paper 1 trong roadmap SFOA → MOSFOA.**
