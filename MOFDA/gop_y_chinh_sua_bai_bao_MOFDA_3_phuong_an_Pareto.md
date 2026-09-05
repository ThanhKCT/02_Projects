# HƯỚNG DẪN CHỈNH SỬA BÀI BÁO – CHỐT PHƯƠNG ÁN 3 NGHIỆM ĐẠI DIỆN

## 1. Định hướng đã chốt

Giữ nguyên phạm vi nghiên cứu:

- Bài báo **ứng dụng MOFDA**, không phát triển hay cải tiến thuật toán.
- Không so sánh MOFDA với GA, PSO, NSGA-II, GWO, WOA...
- Không bổ sung benchmark functions, GD/HV, 30 lần chạy, Best/Mean/SD/CV...
- Không đưa hồ sơ thiết kế kỹ thuật, thiết kế gốc hoặc phương án thiết kế hiện hữu vào bài báo.
- **Không so sánh kết quả tối ưu với thiết kế hiện hữu.**
- Giữ cách kiểm chứng bằng cách liệt kê toàn bộ 243 tổ hợp để xây dựng **mặt Pareto tham chiếu**.
- Bổ sung **3 phương án đại diện trên mặt Pareto** để thể hiện rõ giá trị kỹ thuật của tối ưu đa mục tiêu.

---

# 2. Sửa mục 4.3

### Đổi tên mục

Đổi:

> 4.3. Phương án đại diện trên mặt Pareto

thành:

> **4.3. Lựa chọn các phương án đại diện trên mặt Pareto**

### Thay toàn bộ nội dung mục 4.3 hiện tại bằng

> Mặt Pareto không xác định một nghiệm tối ưu duy nhất mà cung cấp các phương án thiết kế tương ứng với những mức độ đánh đổi khác nhau giữa khối lượng vật liệu cọc và chuyển vị ngang. Trong nghiên cứu này, ba phương án đại diện được lựa chọn theo ba xu hướng: ưu tiên giảm khối lượng, cân bằng giữa hai mục tiêu và ưu tiên kiểm soát chuyển vị. Việc lựa chọn này nhằm minh họa khả năng khai thác kết quả Pareto trong giai đoạn thiết kế sơ bộ, thay vì xác định một phương án tối ưu duy nhất cho công trình.
>
> Phương án 1 là phương án có khối lượng vật liệu nhỏ nhất trên mặt Pareto, với CatIdx = 1, đường kính cọc thép D_thép = 1,100 m và chiều dày t_thép = 0,018 m; khối lượng vật liệu đạt 3.030,6 tấn và chuyển vị ngang lớn nhất là 13,88 mm. Phương án này phù hợp khi ưu tiên giảm khối lượng vật liệu trong khi vẫn bảo đảm yêu cầu chuyển vị của bài toán.
>
> Phương án 2 là phương án có mức cân bằng tương đối giữa hai mục tiêu, với CatIdx = 2, D_thép = 1,100 m và t_thép = 0,019 m; khối lượng vật liệu là 3.634,5 tấn và chuyển vị ngang lớn nhất là 12,86 mm. Đây là phương án trung gian được lựa chọn để minh họa sự đánh đổi giữa hai mục tiêu.
>
> Phương án 3 là phương án có chuyển vị ngang nhỏ nhất trên mặt Pareto, với CatIdx = 3, D_thép = 1,100 m và t_thép = 0,020 m; khối lượng vật liệu là 4.298,3 tấn và chuyển vị ngang lớn nhất là 11,92 mm. Phương án này thể hiện xu hướng ưu tiên tăng độ cứng và kiểm soát chuyển vị ngang.
>
> Ba phương án trên không được xem là ba phương án tối ưu độc lập mà là các điểm đại diện cho ba mức độ ưu tiên khác nhau trên cùng một mặt Pareto. Việc lựa chọn phương án cụ thể trong thực tế cần căn cứ vào yêu cầu kỹ thuật, mức độ ưu tiên về vật liệu và các điều kiện thiết kế bổ sung của dự án.

---

# 3. Bổ sung Bảng 3

Đặt ngay sau phần trình bày ba phương án ở mục 4.3.

### Bảng 3. Ba phương án đại diện trên mặt Pareto

| Phương án | Tiêu chí lựa chọn | CatIdx | D_thép (m) | t_thép (m) | Khối lượng f₁ (tấn) | Chuyển vị f₂ (mm) |
|---|---|---:|---:|---:|---:|---:|
| PA1 | Khối lượng nhỏ nhất | 1 | 1,100 | 0,018 | 3.030,6 | 13,88 |
| PA2 | Cân bằng tương đối | 2 | 1,100 | 0,019 | 3.634,5 | 12,86 |
| PA3 | Chuyển vị nhỏ nhất | 3 | 1,100 | 0,020 | 4.298,3 | 11,92 |

**Không cần chạy thêm SAP2000/FEM** để tạo Bảng 3. Các giá trị đều lấy từ 16 nghiệm của mặt Pareto tham chiếu đã có trong Bảng 2.

---

# 4. Đoạn thảo luận sau Bảng 3

Có thể thêm:

> Bảng 3 cho thấy khi chuyển từ PA1 sang PA3, khối lượng vật liệu tăng từ 3.030,6 lên 4.298,3 tấn, trong khi chuyển vị ngang giảm từ 13,88 xuống 11,92 mm. PA2 nằm giữa hai xu hướng này và thể hiện một mức đánh đổi trung gian. Như vậy, kết quả tối ưu đa mục tiêu không chỉ cung cấp một giá trị đơn lẻ mà còn cho phép người thiết kế xem xét nhiều phương án theo mức độ ưu tiên khác nhau.

Không cần tính thêm các chỉ số mới nếu không thực sự cần thiết.

---

# 5. Mục 4.1 và 4.2

Giữ logic hiện tại:

**243 tổ hợp → 16 nghiệm Pareto tham chiếu → MOFDA tìm 14 nghiệm → 8/16 nghiệm Pareto được nhận diện chính xác.**

Có thể giữ cách diễn đạt:

> Kết quả cho thấy MOFDA nhận diện được một phần đáng kể mặt Pareto tham chiếu trong giới hạn số lần đánh giá FEM được sử dụng.

Và:

> MOFDA có khả năng hội tụ về vùng nghiệm Pareto của bài toán trong giới hạn số lần đánh giá được sử dụng.

Không dùng các khẳng định như “MOFDA tốt nhất”, “MOFDA vượt trội” hoặc “tối ưu tuyệt đối”, vì nghiên cứu không thực hiện so sánh thuật toán.

---

# 6. Hình 3

Giữ Hình 3 hiện tại:

> **Hình 3. Đối chiếu mặt Pareto MOFDA (14 nghiệm) với mặt Pareto tham chiếu (16 nghiệm)**

Nếu thuận tiện, có thể đánh dấu PA1–PA3 trên mặt Pareto tham chiếu bằng ký hiệu khác biệt. Đây là cải thiện tốt nhưng **không bắt buộc**.

Chú giải nếu có:

- PA1 – khối lượng nhỏ nhất;
- PA2 – cân bằng;
- PA3 – chuyển vị nhỏ nhất.

**Không thêm điểm thiết kế hiện hữu.**

---

# 7. Sửa phần kết luận

Có thể thay ý (5) bằng:

> **(5)** Mặt Pareto cung cấp cơ sở để lựa chọn phương án sơ bộ theo các mức độ ưu tiên khác nhau. Ba phương án đại diện được lựa chọn tương ứng với xu hướng giảm khối lượng, cân bằng hai mục tiêu và kiểm soát chuyển vị, qua đó minh họa khả năng sử dụng kết quả tối ưu đa mục tiêu trong hỗ trợ quyết định ở giai đoạn thiết kế sơ bộ. Trước khi áp dụng cho thiết kế chính thức, cần bổ sung các kiểm tra còn thiếu, đặc biệt là kiểm tra sức chịu tải địa kỹ thuật.

---

# 8. Những nội dung KHÔNG thêm

1. Không đưa thiết kế gốc/hồ sơ thiết kế vào bảng so sánh.
2. Không đưa “phương án hiện hữu” lên Hình 3.
3. Không bàn về hồ sơ thiết kế có đúng hay không.
4. Không bàn về trách nhiệm thiết kế, thẩm tra, phê duyệt.
5. Không so sánh MOFDA với thuật toán khác.
6. Không thêm AHP, TOPSIS hoặc phương pháp ra quyết định mới.
7. Không thêm benchmark functions.
8. Không thêm GD/HV nếu không thuộc mục tiêu nghiên cứu.
9. Không thêm 30 lần chạy độc lập.
10. Không thêm phân tích Best/Mean/SD/CV.
11. Không thêm tải bão nếu chưa nằm trong phạm vi tính toán hiện tại.
12. Không tuyên bố kết quả tối ưu có thể thay thế thiết kế thi công.

---

# 9. Kiểm tra câu chữ toàn bài

### Nên dùng

- tối ưu đa mục tiêu
- hàm mục tiêu
- biến thiết kế
- không gian thiết kế
- ràng buộc
- hàm phạt
- nghiệm khả thi
- nghiệm không bị trội
- nghiệm bị trội
- mặt Pareto
- mặt Pareto tham chiếu
- lần đánh giá FEM
- quần thể
- cá thể
- vòng lặp
- chuyển vị ngang
- khối lượng vật liệu cọc
- mô hình phần tử hữu hạn
- phương pháp phần tử hữu hạn
- thiết kế sơ bộ
- phương án đại diện
- sự đánh đổi

### Sửa nếu còn xuất hiện

- “pilot runs” → **các lần chạy thử**
- “campaign” → **đợt tính toán**
- “file” → **tệp**
- “catalog” → **catalogue**
- “true Pareto” → **mặt Pareto tham chiếu**
- “nghiệm tối ưu duy nhất” → **phương án đại diện trên mặt Pareto**
- “xác nhận MOFDA tối ưu” → **cho thấy khả năng hội tụ về vùng nghiệm Pareto**

---

# 10. Kiểm tra cuối trước khi gửi tạp chí

- [ ] Hình 1 đã thay placeholder bằng hình SAP2000 3D thực tế.
- [ ] Tên tác giả, đơn vị và email đã điền.
- [ ] DOI placeholder `10.65154/jmst.%ID` đã xóa/thay đúng theo quy định tạp chí.
- [ ] Tài liệu tham khảo [1] đã kiểm tra lại thông tin thư mục.
- [ ] Bảng 2 có đủ 16 nghiệm Pareto.
- [ ] Bảng 3 có 3 phương án PA1–PA3.
- [ ] Hình 3 không chứa điểm thiết kế hiện hữu.
- [ ] Không có câu nào nhắc đến thiết kế gốc theo hướng so sánh/đánh giá.
- [ ] Giữ rõ giới hạn: chưa kiểm tra đầy đủ sức chịu tải địa kỹ thuật theo TCVN 10304:2025 do thiếu dữ liệu đất.
- [ ] Giữ rõ giới hạn: chưa xét tổ hợp tải trọng bão.
- [ ] Giữ rõ giới hạn: cọc thép được rời rạc hóa theo lưới giả định do chưa có catalogue phù hợp.
- [ ] Giữ rõ giới hạn: mô hình tuyến tính tĩnh, chưa xét tương tác đất–cọc phi tuyến kiểu p–y.
- [ ] Kiểm tra lại con số 1.140 lần đánh giá FEM theo mã chạy thực tế.
- [ ] Kiểm tra thống nhất dấu phẩy/dấu chấm trong số liệu tiếng Việt.
- [ ] Kiểm tra tổng số từ theo giới hạn của tạp chí.

---

## Chốt phương án

**Không cần viết lại bài báo.** Trọng tâm chỉnh sửa là:

> **16 nghiệm Pareto → chọn 3 phương án đại diện → thể hiện ba mức ưu tiên → hỗ trợ lựa chọn phương án sơ bộ.**

Đây là thay đổi nhỏ nhưng làm phần “Kết quả và thảo luận” có giá trị kỹ thuật rõ hơn, đồng thời **không mở rộng đối tượng nghiên cứu, không cần thêm thuật toán, không cần chạy thêm FEM và không cần đưa thiết kế gốc vào bài.**
