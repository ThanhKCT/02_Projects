# CHIẾN LƯỢC XUẤT BẢN CÁC BÀI BÁO BỔ TRỢ CHO ĐỀ TÀI TIẾN SĨ

**Bài chính (flagship):** MOSFOAV2 — B-MOSFOA & E-MOSFOA, ứng dụng tối ưu kết cấu bến cảng (BD/MD/MJP), dự kiến nộp/đăng **12/2026**.
**Mục tiêu:** Bố trí 1 bài trong nước đăng **trước** bài chính, và 1 bài (trong/ngoài nước) đăng **sau** bài chính, hỗ trợ luận án mà không làm loãng/tranh chấp tính mới của bài chính.

---

## 0. Nguyên tắc chọn đề tài bổ trợ (rất quan trọng)

Để tránh **tự trùng lặp (self-plagiarism)** và không làm mất tính mới của bài chính khi phản biện:

1. **Bài trước bài chính** → KHÔNG được dùng thuật toán mới (B-MOSFOA/E-MOSFOA) làm trọng tâm. Chỉ nên dùng **SFOA gốc (đơn mục tiêu)** hoặc một dạng đơn giản hoá, áp dụng cho **một tiểu hệ kết cấu** (ví dụ chỉ riêng BD). Đây sẽ là bài "đặt nền" (baseline/pilot study) cho framework FEM–tối ưu hoá, sau đó bài chính "kế thừa và mở rộng" thành đa mục tiêu.
2. **Bài sau bài chính** → có thể khai thác sâu hơn dữ liệu/kết quả đã có (Pareto front, mô hình FEM) theo hướng khác — ra quyết định (decision-making), mở rộng sang kết cấu khác, hoặc RBDO (thiết kế theo độ tin cậy) — miễn là **không lặp lại đóng góp thuật toán cốt lõi**.
3. Bài trong nước và bài chính phải khác nhau rõ về: (a) phạm vi thuật toán, (b) mức độ chi tiết/so sánh, (c) văn phong triển khai — để không vi phạm chính sách "duplicate submission" khi các phản biện bài chính tra chéo.
4. Trong bài chính, hãy **trích dẫn bài trong nước** như một nghiên cứu tiền đề ("preliminary study") — điều này hợp lệ hoá trình tự công bố và cho thấy tính logic phát triển của đề tài.

---

## 1. BÀI #1 — Trong nước, đăng TRƯỚC bài chính

### Đề xuất tên bài
**VN:** "Tối ưu hóa thiết kế kết cấu trụ va (Berthing Dolphin) bến cảng lỏng bằng thuật toán tối ưu hóa Sao biển (SFOA) kết hợp mô hình phần tử hữu hạn"
**EN (nếu journal song ngữ):** "Cost-based Structural Design Optimization of a Berthing Dolphin Using the Starfish Optimization Algorithm Coupled with a Finite Element Model"

### Phạm vi & ý tưởng cốt lõi
- **Thuật toán:** dùng **SFOA gốc** (đơn mục tiêu, đã công bố — Zhong et al. 2024) — không đụng đến B/E-MOSFOA.
- **Đối tượng:** chỉ **1 tiểu hệ** — Berthing Dolphin (BD) của bến Hải Linh (hoặc dữ liệu tương tự) — không mở rộng ra MD/MJP (để dành cho bài chính).
- **Hàm mục tiêu:** đơn mục tiêu — có thể chọn 1 trong 2 hướng:
  - (a) **Minimize cost** `f(X) = Σ L_p × P_p`, ràng buộc chuyển vị max theo tiêu chuẩn (dạng constraint, không phải objective) — đơn giản, rõ ràng, dễ trình bày.
  - (b) Hoặc **weighted-sum** của cost + displacement (`f = w1·f1_norm + w2·f2_norm`) để vẫn thể hiện được sự đánh đổi 2 mục tiêu nhưng KHÔNG dùng khung Pareto/archive — về bản chất vẫn là SOO, khác hẳn cách tiếp cận Pareto-based của bài chính.
  - → Khuyến nghị chọn **(a)** vì tách bạch rõ nhất với bài chính (đa mục tiêu Pareto).
- **Biến thiết kế:** đường kính cọc, độ dày vách, góc nghiêng, chiều dài cọc (X1–X4, giống Table 7 nhưng chỉ cho BD).
- **Ràng buộc:** TCVN 7888:2014, TCVN 10304:2014, PIANC (2002), OCDI (2002) — xử lý bằng hàm phạt (penalty method) — **tái sử dụng gần như toàn bộ** phần mô hình hoá kỹ thuật đã có trong bài chính (Section 5.1a, 5.4) nhưng viết lại/diễn giải theo hướng đơn mục tiêu.
- **So sánh:** SFOA vs. một vài thuật toán đơn mục tiêu phổ biến (PSO, GWO, WOA, HHO — đã có sẵn dữ liệu tương tự từ 10 bài toán kỹ thuật gốc, dễ tái dùng khung code).
- **Đóng góp chính của bài:** (1) xây dựng **khung liên kết SAP2000–MATLAB** để tối ưu hóa kết cấu bến cảng theo tiêu chuẩn Việt Nam — đây là đóng góp kỹ thuật/ứng dụng thực tế, phù hợp văn phong tạp chí trong nước; (2) chứng minh SFOA hiệu quả hơn PSO/GWO/... cho lớp bài toán kết cấu cảng biển — mở đường lý luận cho việc "cần" phát triển thêm bản đa mục tiêu (chính là bài chính) khi có nhiều mục tiêu xung đột (cost vs. displacement) cần xử lý đồng thời.

### Vì sao an toàn, không lấn bài chính?
| | Bài #1 (trong nước) | Bài chính (MOSFOAV2) |
|---|---|---|
| Thuật toán | SFOA gốc (đơn mục tiêu) | B-MOSFOA & E-MOSFOA (đa mục tiêu, archive+grid, DE mutation...) |
| Kết cấu | Chỉ BD | BD + MD + MJP |
| Số mục tiêu | 1 | 2 (Pareto front) |
| Benchmark thuật toán | Không cần (hoặc chỉ so vài SOO) | IMOP/UF/RM-MEDA đầy đủ |
| Điểm mới | Khung FEM-tối ưu cho công trình cảng VN | Thuật toán MOO mới + ứng dụng toàn diện 3 tiểu hệ |

### Tạp chí trong nước gợi ý (xếp theo độ phù hợp)
1. **Tạp chí Khoa học Công nghệ Xây dựng (JSTCE – Trường ĐH Xây dựng Hà Nội / IBST)** — phù hợp nhất, có hội đồng phản biện chuyên kết cấu công trình.
2. **Tạp chí Xây dựng (Bộ Xây dựng)**
3. **Tạp chí Giao thông Vận tải** — phù hợp vì bến cảng thuộc hạ tầng giao thông.
4. **Tạp chí Khoa học Kỹ thuật Thủy lợi và Môi trường (ĐH Thủy lợi)** — nếu muốn nhấn thêm yếu tố địa kỹ thuật/nền móng.

### Mốc thời gian đề xuất
- **Viết & hoàn thiện bản thảo:** 4–6 tuần (tái sử dụng ~60-70% nội dung mô hình hóa từ bài chính, chỉ cần chạy lại SFOA đơn mục tiêu cho BD + viết phần so sánh SOO).
- **Nộp:** trong 1–2 tháng tới (để kịp phản biện 3–6 tháng của tạp chí trong nước và **đăng xong trước tháng 12/2026**).
- **Timeline rủi ro:** nếu tạp chí trong nước phản biện chậm (>6 tháng là phổ biến ở VN), nên nộp **ngay trong quý này** để chắc chắn có kết quả trước khi nộp bài chính.

---

## 2. BÀI #2 — Đăng SAU bài chính (linh hoạt trong/ngoài nước)

Đưa ra 3 lựa chọn, xếp theo mức độ khuyến nghị:

### 🥇 Lựa chọn A (khuyến nghị chính): Bài ra quyết định đa tiêu chí (MCDM) hậu-Pareto
**Tên gợi ý:** "A Fuzzy Multi-Criteria Decision-Making Approach for Best-Compromise Selection from Pareto-Optimal Marine Jetty Designs"

- **Ý tưởng:** dùng lại **toàn bộ Pareto front** đã có từ bài chính (BD/MD/MJP), áp dụng thêm một lớp **ra quyết định** (Fuzzy TOPSIS, AHP, hoặc Entropy Weight + VIKOR) để chọn ra nghiệm "best-compromise" thay vì để kỹ sư tự chọn cảm tính.
- **Ưu điểm chiến lược:**
  - Tận dụng **dữ liệu đã có sẵn** (không cần chạy lại tối ưu hóa) → viết nhanh, ít rủi ro kỹ thuật.
  - **Không đụng đến thuật toán MOO cốt lõi** → không tranh chấp tính mới với bài chính, mà còn "tôn" giá trị ứng dụng của bài chính (dùng Pareto front của bài chính làm input).
  - Có giá trị thực tiễn cao (kỹ sư/chủ đầu tư cần 1 phương án cụ thể, không phải cả tập Pareto).
  - Dễ mở rộng thành 1 chương riêng trong luận án (Chapter: Decision Support).
- **Tạp chí gợi ý:** Ocean Engineering, Journal of Marine Science and Engineering (MDPI), Structures, hoặc Engineering with Computers (nếu muốn giữ tính "computational").

### 🥈 Lựa chọn B: Mở rộng độ tin cậy (Reliability-Based Design Optimization – RBDO)
**Tên gợi ý:** "Reliability-Based Multi-objective Optimization of Marine Jetty Structures under Soil and Loading Uncertainties Using E-MOSFOA"

- **Ý tưởng:** thêm mục tiêu/ràng buộc thứ 3 — chỉ số độ tin cậy (reliability index β) — xét đến bất định của thông số đất nền (chỉ số sệt Ib, sức chịu tải) và tải trọng va/neo (BL/ML) — bài toán 3 mục tiêu (cost, displacement, reliability).
- **Ưu điểm:** đào sâu học thuật, thể hiện năng lực mở rộng khung MOSFOA, rất hợp với hướng "future work" đã nêu trong bài chính (mục 6: "Extending the framework to handle uncertainty... is also a promising direction").
- **Nhược điểm:** cần thêm thời gian mô hình hóa uncertainty (Monte Carlo/FORM) + chạy lại E-MOSFOA 3 mục tiêu → tốn công hơn Lựa chọn A.
- **Tạp chí gợi ý:** Structural Safety, Reliability Engineering & System Safety, Ocean Engineering.

### 🥉 Lựa chọn C: Bài thuật toán thuần (algorithm-focused)
**Tên gợi ý:** "Comprehensive Benchmarking of B-MOSFOA/E-MOSFOA Against Recent Multi-objective Metaheuristics on CEC Test Suites"

- **Ý tưởng:** mở rộng phần benchmark (IMOP/UF/RM-MEDA) của bài chính thành một bài "thuần thuật toán", so sánh với nhiều thuật toán MOO mới hơn (2024-2026), không gắn với ứng dụng công trình biển.
- **Rủi ro:** dễ bị đánh giá là **trùng lặp một phần** với phần benchmark đã có trong bài chính (Section 4) — cần viết lại hoàn toàn khác về khung so sánh (thêm bộ test mới, thêm thuật toán đối chứng mới) để tránh tự trùng. Độ rủi ro tự-trùng-lặp cao nhất trong 3 lựa chọn.
- Chỉ nên chọn nếu Lựa chọn A/B không khả thi về thời gian, và cần thêm 1 bài thuần "Q1 algorithm journal" (Swarm and Evolutionary Computation, Applied Soft Computing) cho hồ sơ học thuật.

**→ Khuyến nghị: chọn Lựa chọn A làm bài #2**, vì nhanh, an toàn, tăng giá trị ứng dụng cho toàn bộ luận án, và tạo mạch truyện logic: *SFOA đơn mục tiêu (bài #1) → MOSFOA đa mục tiêu (bài chính) → Ra quyết định hậu-Pareto (bài #2)* — một trục phát triển rất thuyết phục cho hội đồng luận án.

---

## 3. Sơ đồ tổng thể (timeline đề xuất)

```
Hiện tại (08/2026)
   │
   ├─► [Bài #1 - Trong nước] SFOA đơn mục tiêu cho BD
   │     Viết: ~1-1.5 tháng │ Nộp: ngay trong Q3/2026 │ Kỳ vọng đăng: trước 12/2026
   │
   ├─► [Bài chính] B-MOSFOA/E-MOSFOA + case study BD/MD/MJP
   │     Nộp/đăng: 12/2026 (như kế hoạch)
   │
   └─► [Bài #2 - Sau bài chính] MCDM hậu-Pareto (Lựa chọn A)
         Viết: sau khi bài chính được accept (~Q1-Q2/2027)
         Nộp: Q2/2027
```

## 4. Danh sách việc cần làm (checklist)

- [ ] Chốt hàm mục tiêu đơn (cost hoặc weighted-sum) cho Bài #1.
- [ ] Chạy lại SFOA gốc (đơn mục tiêu) chỉ cho BD, so với PSO/GWO/HHO.
- [ ] Viết Bài #1, nộp tạp chí trong nước (ưu tiên JSTCE hoặc Tạp chí Xây dựng).
- [ ] Trong bài chính, thêm 1 câu trích dẫn Bài #1 ở phần Introduction/Related Work làm "preliminary study".
- [ ] Sau khi bài chính accept, chuẩn bị dữ liệu Pareto front (BD/MD/MJP) để tái sử dụng cho Bài #2 (MCDM).
- [ ] Rà soát chính sách "prior publication/self-plagiarism" của tạp chí đích cho bài chính trước khi nộp Bài #1 (đảm bảo % trùng nội dung ở mức cho phép, thường <20-25% theo Turnitin/iThenticate).
