# ĐỀ CƯƠNG BÀI BÁO SOO -- SFOA CHO TỐI ƯU KẾT CẤU CÔNG TRÌNH BIỂN

## 0. THÔNG TIN KHÓA CỦA BÀI BÁO

**Mục đích:** xây dựng một bài báo nghiên cứu đơn mục tiêu
(Single-Objective Optimization -- SOO) dùng **SFOA nguyên bản** để tối
ưu hệ kết cấu **Main Jetty Platform (MJP)** — hệ kết cấu chính trong 3
hệ kết cấu biển đã được sử dụng trong bài MOO/MOSFOA (Berthing Dolphin
BD, Mooring Dolphin MD, MJP).

> **CẬP NHẬT 2026-08-17 — THU HẸP PHẠM VI:** ban đầu đề cương khóa cả 3
> hệ (6 case, 180 run). Do ràng buộc thời gian tính toán thực tế trên
> máy cơ quan (xem SESSION_HANDOFF 2026-08-15/2026-08-17 — một lần
> campaign 6-case đã chết giữa chừng, chỉ hoàn thành ~12% khối lượng
> sau 35 giờ không giám sát), phạm vi được thu hẹp còn **chỉ MJP, 2 case
> (Cost, Displacement)**. Đổi lại, toàn bộ ngân sách thời gian được dồn
> cho MJP để đạt **Nrun=30** (chuẩn vàng, thay vì Nrun=10 dự tính lúc
> đầu cho phương án 6-case rút gọn). Toàn bộ nội dung bên dưới vẫn giữ
> cấu trúc gốc cho 3 hệ (giá trị tham khảo lịch sử) nhưng bản thảo cuối
> ([02_Draft_SOO_SFOA_Marine_Jetty_TCXD.md](02_Draft_SOO_SFOA_Marine_Jetty_TCXD.md))
> đã được viết lại theo đúng phạm vi 1-hệ/2-case này.

**Vai trò trong chuỗi nghiên cứu:**

> **SFOA/SOO → khảo sát nghiệm cực trị → phát hiện xung đột
> Cost--Displacement → xác lập nhu cầu MOO → MOSFOA/MOO.**

Bài SOO **không** nhằm chứng minh SFOA là thuật toán kém. Ngược lại, mục
tiêu là chứng minh SFOA có khả năng giải tốt từng mục tiêu riêng lẻ,
nhưng cách tiếp cận SOO chỉ tạo ra một nghiệm tối ưu cho một mục tiêu và
không biểu diễn được tập nghiệm đánh đổi giữa các mục tiêu cạnh tranh.
Đây là cơ sở thực nghiệm để chuyển sang MOSFOA.

### 0.1. Tên bài báo tạm khóa

**Tiếng Việt:**

**Ứng dụng thuật toán tối ưu sao biển cho tối ưu đơn mục tiêu kết cấu
công trình biển**

**Tiếng Anh:**

**Application of the Starfish Optimization Algorithm to Single-Objective
Optimization of Marine Jetty Structures**

Tên tiếng Anh hiện có 13 từ, đáp ứng giới hạn dưới 20 từ theo thể lệ Tạp
chí Xây dựng.

### 0.2. Câu hỏi nghiên cứu chính

1.  SFOA nguyên bản có thể giải ổn định các bài toán tối ưu chi phí và
    chuyển vị của BD, MD và MJP hay không?
2.  Các nghiệm tối ưu chi phí và tối ưu chuyển vị khác nhau như thế nào
    về biến thiết kế và hiệu quả kết cấu?
3.  Mức độ đánh đổi giữa chi phí và chuyển vị có xuất hiện nhất quán ở
    cả ba hệ kết cấu hay không?
4.  Vì sao việc chỉ dùng SOO không đủ để cung cấp tập phương án thiết kế
    cho bài toán thực tế?
5.  Các quan sát từ SOO có tạo được cơ sở trực tiếp cho việc phát triển
    MOSFOA trong bài MOO hay không?

### 0.3. Giả thuyết nghiên cứu

-   **H1:** SFOA có khả năng hội tụ đến nghiệm tốt và ổn định khi tối ưu
    từng mục tiêu đơn lẻ.
-   **H2:** Nghiệm tối ưu chi phí và nghiệm tối ưu chuyển vị là hai
    nghiệm khác nhau về thiết kế và có xu hướng tạo ra sự đánh đổi giữa
    chi phí và độ cứng/chuyển vị.
-   **H3:** SOO không cung cấp một tập nghiệm không trội để hỗ trợ quyết
    định thiết kế khi đồng thời xét chi phí và chuyển vị.
-   **H4:** Do đó, nhu cầu chuyển từ SFOA/SOO sang một cơ chế
    Pareto-based MOO là có cơ sở từ chính bài toán kỹ thuật, không phải
    chỉ từ yêu cầu cải tiến thuật toán.

------------------------------------------------------------------------

# 1. QUY CÁCH BÀI BÁO THEO TẠP CHÍ XÂY DỰNG

## 1.1. Quy định hình thức chính

Theo tài liệu **"Cấu trúc, thể thức trình bày bài báo khoa học trên Tạp
chí Xây dựng"** được cung cấp, bài báo phải có:

1.  Tên bài báo.
2.  Tác giả.
3.  Đơn vị công tác và Email.
4.  TÓM TẮT.
5.  Từ khóa.
6.  ABSTRACT.
7.  Keywords.
8.  ĐẶT VẤN ĐỀ.
9.  Các mục nội dung chính.
10. KẾT LUẬN.
11. Lời cảm ơn nếu có.
12. TÀI LIỆU THAM KHẢO.

Tài liệu hướng dẫn yêu cầu mục chính viết hoa, đậm; tiểu mục 1.1, 1.2...
viết thường, đậm; tiểu mục con 1.1.1... viết thường, nghiêng. "ĐẶT VẤN
ĐỀ" là tên thống nhất, không dùng "Mở đầu" hoặc "Giới thiệu".

## 1.2. Quy cách kỹ thuật

Theo thể lệ đăng bài trên Tạp chí Xây dựng:

-   Khổ A4.
-   Font Myriad Pro, Unicode, cỡ 9.
-   Lề trên 3 cm; dưới 2 cm; phải 1,8 cm; trái 1,3 cm.
-   Công thức chế bản bằng MathType; thành phần công thức trên dòng văn
    bản dùng Symbol.
-   Hình vẽ phải rõ ràng, chuẩn xác; ảnh gốc nếu có cần độ phân giải 300
    dpi.
-   Chú thích bảng/hình viết chữ thường, căn trái; giữa số thứ tự và tên
    bảng/hình dùng dấu chấm.
-   Công thức đánh số liên tục từ (1) đến hết.
-   Trong bài dùng "Hình 1", "Bảng 1" với chữ Hình/Bảng viết hoa.
-   Số thập phân trong bản tiếng Việt dùng dấu phẩy.
-   Không tự ý in đậm/in nghiêng trong thân bài ngoài quy định của Tạp
    chí.

## 1.3. Quy cách nội dung

Thể lệ Tạp chí Xây dựng công bố yêu cầu:

-   Tiêu đề Việt + Anh, dưới 20 từ.
-   Tóm tắt Việt + Anh khoảng 150--300 từ.
-   Khoảng 5--10 từ khóa, phân cách bằng dấu chấm phẩy.
-   Công trình nghiên cứu/triển khai ứng dụng không quá 5.000 từ.
-   Bài phải có kết quả nghiên cứu mới hoặc ứng dụng mới; minh chứng
    phải cụ thể, rõ ràng và thuyết phục bằng phân tích, tính toán, mô
    phỏng, khảo sát, thực nghiệm hoặc số liệu thực tế.

**Mục tiêu bản thảo:** 4.500--5.000 từ, không tính tài liệu tham khảo và
phần thông tin đầu bài.

## 1.4. Tài liệu tham khảo

Tài liệu hướng dẫn được cung cấp yêu cầu tài liệu tham khảo theo chuẩn
IEEE về cách đánh số/trích dẫn, đồng thời thể lệ đăng bài trên website
nêu yêu cầu thông tin đầy đủ của tài liệu.

**Quy tắc làm việc cho bản thảo này:**

-   Trích dẫn trong thân bài: \[1\], \[2\], \[3\], \[1, 2\].
-   Không viết "Theo \[1\], \[2\]"; viết "Theo \[1, 2\]".
-   Danh mục tài liệu tham khảo phải được chuẩn hóa thống nhất trước khi
    nộp.
-   Với tài liệu Internet: ghi đầy đủ địa chỉ và ngày truy cập theo
    hướng dẫn của Tạp chí.

> **Lưu ý kiểm soát nguồn:** tài liệu hướng dẫn được cung cấp và trang
> "Thể lệ viết và gửi bài cho Tạp chí Xây dựng" trên website có một số
> khác biệt về cách mô tả thứ tự tài liệu tham khảo. Khi dàn bản cuối,
> ưu tiên **mẫu thể thức của file hướng dẫn do Tạp chí cung cấp** và
> kiểm tra lại yêu cầu hiện hành trước khi nộp.

------------------------------------------------------------------------

# 2. CẤU TRÚC KHOA HỌC CỦA BÀI BÁO

## 2.1. Kiến trúc tổng thể

``` text
ĐẶT VẤN ĐỀ
      ↓
Khoảng trống nghiên cứu
      ↓
SFOA cho SOO
      ↓
Ba hệ kết cấu biển thực tế
      ↓
6 bài toán SOO
      ↓
Kết quả hội tụ + thống kê
      ↓
Cost-optimal vs Displacement-optimal
      ↓
Định lượng trade-off
      ↓
Hạn chế của cách tiếp cận SOO
      ↓
Nhu cầu Pareto/MOO
      ↓
Cơ sở phát triển MOSFOA
```

## 2.2. Phân bổ dung lượng dự kiến

  Phần                                          Tỷ trọng          Từ dự kiến
  ------------------------------------------- ---------- -------------------
  1\. Đặt vấn đề                                 15--18%            700--850
  2\. Mô hình bài toán và phương pháp            30--33%        1.400--1.600
  3\. Thiết lập tính toán và thực nghiệm số      10--12%            450--550
  4\. Kết quả và thảo luận                       35--38%        1.600--1.850
  5\. Kết luận                                     5--7%            250--300
  **Tổng**                                      **100%**   **≈4.500--5.000**

------------------------------------------------------------------------

# 3. 1. ĐẶT VẤN ĐỀ

## 3.1. Bối cảnh kỹ thuật

Trình bày:

-   Kết cấu công trình biển có nhiều biến thiết kế và chịu tải trọng
    phức tạp.
-   Thiết kế thực tế phải đồng thời bảo đảm an toàn, độ cứng/chuyển vị
    và hiệu quả kinh tế.
-   Mô hình phần tử hữu hạn cho phép đánh giá trực tiếp đáp ứng kết cấu.
-   Tối ưu metaheuristic phù hợp với bài toán phi tuyến, rời rạc, nhiều
    ràng buộc.

## 3.2. SFOA và khoảng trống nghiên cứu

Giới thiệu ngắn:

-   SFOA là thuật toán metaheuristic lấy cảm hứng từ hành vi sao biển.
-   SFOA có hai pha chính: exploration và exploitation.
-   SFOA đã được kiểm chứng trên nhiều benchmark và bài toán kỹ thuật.
-   Tuy nhiên, bài báo này không khảo sát SFOA ở mức benchmark mà tập
    trung vào ứng dụng kết cấu biển thực tế.

**Thông điệp cần khóa:**

> Chưa cần tuyên bố SFOA yếu. Khoảng trống cần khảo sát là khả năng của
> SFOA khi giải các bài toán SOO có tính kỹ thuật cao, rời rạc, kết hợp
> FEM và nhiều ràng buộc.

## 3.3. Vấn đề nghiên cứu

Đặt hai bài toán:

\[ `\min `{=tex}C(x) \]

và

\[ `\min `{=tex}D(x) \]

trong cùng một không gian thiết kế.

Trong đó:

-   (C(x)): chi phí xây dựng;
-   (D(x)): chuyển vị lớn nhất;
-   (x): vector biến thiết kế.

## 3.4. Mục tiêu nghiên cứu

**Mục tiêu tổng quát:**

Đánh giá khả năng của SFOA nguyên bản trong tối ưu đơn mục tiêu cho ba
hệ kết cấu biển BD, MD và MJP, đồng thời phân tích sự khác biệt giữa
nghiệm tối ưu chi phí và nghiệm tối ưu chuyển vị để làm rõ giới hạn của
cách tiếp cận SOO.

## 3.5. Đóng góp của nghiên cứu

Khóa 3 đóng góp:

1.  Xây dựng và kiểm chứng framework SAP2000--MATLAB--SFOA cho SOO của
    kết cấu công trình biển.
2.  Đánh giá SFOA trên ba hệ kết cấu BD, MD và MJP với biến thiết kế rời
    rạc và các ràng buộc kỹ thuật.
3.  Định lượng sự khác biệt giữa nghiệm cost-optimal và
    displacement-optimal; từ đó xác lập cơ sở kỹ thuật cho nhu cầu
    MOO/Pareto và bước phát triển MOSFOA.

------------------------------------------------------------------------

# 4. 2. MÔ HÌNH BÀI TOÁN VÀ PHƯƠNG PHÁP NGHIÊN CỨU

## 4.1. Hệ kết cấu nghiên cứu

### 4.1.1. Berthing Dolphin (BD)

Mô hình cọc chịu tác động của tải trọng cập tàu và tải trọng neo.

Cấu hình hiện tại trong nghiên cứu nền:

-   9 cọc bê tông dự ứng lực D600B;
-   chiều dài cọc hiện tại 39 m;
-   hệ cọc gồm cọc đứng và các cọc nghiêng;
-   tải trọng gồm DL, BL, ML theo mô hình MOO đã xây dựng.

### 4.1.2. Mooring Dolphin (MD)

Cấu hình hiện tại:

-   9 cọc bê tông dự ứng lực D600B;
-   chiều dài 40 m;
-   1 cọc đứng;
-   4 cọc nghiêng trong mặt phẳng;
-   4 cọc nghiêng không gian;
-   tải trọng chủ yếu DL và ML.

### 4.1.3. Main Jetty Platform (MJP)

Cấu hình hiện tại:

-   15 cọc đứng D500B;
-   chiều dài hiện tại 39 m;
-   bố trí 3×5;
-   nhịp dọc 4,2 m;
-   nhịp ngang 4,5 m;
-   dầm 70×100 cm;
-   bản mặt cầu BTCT dày 30 cm;
-   tải trọng DL và LL.

## 4.2. Mô hình phần tử hữu hạn SAP2000

Giữ nguyên mô hình FEM đã dùng trong bài MOO:

``` text
Design vector x
      ↓
MATLAB
      ↓
Cập nhật thông số hình học
      ↓
SAP2000
      ↓
Phân tích FEM
      ↓
Displacement + N + M + V + phản lực
      ↓
Kiểm tra ràng buộc
      ↓
Objective + Penalty
      ↓
SFOA
```

**Nguyên tắc khóa:** không thay đổi mô hình FEM giữa bài SOO và bài MOO
nếu không có lý do kỹ thuật được công bố rõ ràng.

## 4.3. Tải trọng và tổ hợp tải

Giữ nguyên hệ tải:

-   DL: Dead Load;
-   BL: Berthing Load;
-   ML: Mooring Load;
-   LL: Live Load.

Giá trị nền trong bài MOO:

  ------------------------------------------------------------------------
  Load case            X (kN)          Y (kN)          Z (kN) Nguồn
  ----------- --------------- --------------- --------------- ------------
  DL          SAP2000 tự tính SAP2000 tự tính SAP2000 tự tính Mô hình FEM

  BL                   222,42          444,83               0 PIANC/OCDI

  ML                    99,05          118,07            71,2 PIANC/OCDI

  LL                        0               0            9,81 Mô hình
                                                              nghiên cứu
  ------------------------------------------------------------------------

Tổ hợp phải giữ nguyên theo bài MOO:

-   BD: DL + BL + ML theo các COMB đã khóa;
-   MD: DL + ML;
-   MJP: DL + LL.

## 4.4. Tiêu chuẩn và ràng buộc kỹ thuật

Giữ nguyên hệ tiêu chuẩn của mô hình MOO:

-   TCVN 7888:2014: kích thước cọc;
-   TCVN 10304:2014: thiết kế móng cọc và sức chịu tải;
-   PIANC-2002;
-   OCDI (2002);
-   các yêu cầu thiết kế kết cấu đã được tích hợp trong SAP2000.

## 4.5. Biến thiết kế

### 4.5.1. BD và MD

Vector:

\[ x=\[D,t,`\theta`{=tex},L\] \]

Trong đó:

-   (D): đường kính ngoài cọc;
-   (t): chiều dày thành cọc;
-   (`\theta`{=tex}): góc nghiêng;
-   (L): chiều dài cọc.

Các biến là **rời rạc**.

Miền:

-   (D): theo danh mục cọc tham chiếu;
-   (t): theo danh mục cọc tham chiếu;
-   (`\theta`{=tex}): miền rời rạc đã khóa;
-   (L): miền rời rạc 1--40 m theo bước nghiên cứu.

### 4.5.2. MJP

Vector:

\[ x=\[D,t,L,L_L,L_T,b,h\] \]

Trong đó:

-   (D): đường kính cọc;
-   (t): chiều dày;
-   (L): chiều dài cọc;
-   (L_L): nhịp dọc;
-   (L_T): nhịp ngang;
-   (b): bề rộng dầm;
-   (h): chiều cao dầm.

Miền biến giữ theo mô hình MOO:

-   (L_L): 3--6 m;
-   (L_T): 3--6 m;
-   (b): 0,5--2 m;
-   (h): 0,5--2 m;
-   (D,t,L): theo miền rời rạc đã khóa.

> **Việc đưa giá trị miền D/t chính xác vào bản thảo cuối phải lấy trực
> tiếp từ bảng catalogue cọc dùng trong mô hình, không tự suy đoán từ
> bài báo MOO.**

------------------------------------------------------------------------

# 5. 3. HÀM MỤC TIÊU VÀ XỬ LÝ RÀNG BUỘC

## 5.1. Objective 1 -- tối thiểu chi phí

### BD/MD

\[ C(x)=N_p L_p P_p \]

Trong đó:

-   (N_p): số lượng cọc;
-   (L_p): chiều dài cọc;
-   (P_p): đơn giá cọc trên một mét.

### MJP

\[ C(x)=N_pL_pP_p+V_bP_c+W_sP_s \]

Trong đó:

-   (V_b): thể tích bê tông dầm;
-   (P_c): đơn giá bê tông;
-   (W_s): khối lượng thép;
-   (P_s): đơn giá thép.

**SOO-C:**

\[ `\boxed{\min F_C(x)}`{=tex} \]

## 5.2. Objective 2 -- tối thiểu chuyển vị

\[ D(x)=D\_{`\max`{=tex}}(x) \]

với (D\_{`\max`{=tex}}) lấy từ kết quả phân tích SAP2000.

**SOO-D:**

\[ `\boxed{\min F_D(x)}`{=tex} \]

## 5.3. Penalty function

Giữ nguyên triết lý penalty của bài MOO.

Với tổng số (T) ràng buộc:

\[ P(x)=`\sum`{=tex}\_{j=1}\^{T}`\lambda`{=tex}\_j
`\max[0,g_j(x)]`{=tex}\^{p} \]

hoặc đúng công thức penalty đã khóa trong implementation của bài MOO.

**Nguyên tắc quan trọng:**

-   Không thay penalty giữa SOO và MOO.
-   Không thay hệ số phạt tùy ý giữa 6 case.
-   Nếu penalty có đơn vị khác nhau giữa Cost và Displacement, phải
    chuẩn hóa hoặc dùng đúng cơ chế penalty đã được kiểm chứng trong
    implementation.

## 5.4. Hàm fitness cuối cùng

### Cost optimization

\[ F_C(x)=C(x)+P(x) \]

### Displacement optimization

\[ F_D(x)=D(x)+P(x) \]

Nếu implementation thực tế dùng penalty chuẩn hóa, phải ghi đúng công
thức implementation và giải thích rõ đơn vị.

------------------------------------------------------------------------

# 6. 4. THUẬT TOÁN SFOA

## 6.1. SFOA nguyên bản

Sử dụng **Original SFOA**, không:

-   archive Pareto;
-   non-dominated sorting;
-   grid diversity;
-   leader selection;
-   mutation;
-   crossover;
-   adaptive phase control;
-   Gaussian perturbation.

Đây là điểm khóa để phân biệt bài SOO với MOSFOA.

## 6.2. Exploration

Mô tả ngắn cơ chế exploration của SFOA, bao gồm chiến lược cập nhật phụ
thuộc số chiều.

## 6.3. Exploitation

Mô tả:

-   preying;
-   regeneration;
-   cập nhật vị trí;
-   lựa chọn nghiệm tốt nhất theo một objective.

## 6.4. Rời rạc hóa biến

Mọi nghiệm sau cập nhật liên tục phải được ánh xạ về tập giá trị thiết
kế hợp lệ trước khi gửi sang SAP2000.

Pseudo-code:

``` text
Generate continuous candidate
        ↓
Boundary control
        ↓
Discrete mapping
        ↓
Check design catalogue
        ↓
SAP2000 evaluation
```

## 6.5. Điều kiện dừng

Khóa:

-   Population = 100;
-   Iterations = 300;
-   Independent runs = 30.

Nếu sau này implementation dùng tiêu chí dừng sớm, phải báo cáo riêng và
không được trộn với kết quả chuẩn 300 iteration.

------------------------------------------------------------------------

# 7. 5. THIẾT KẾ THỰC NGHIỆM SỐ

## 7.1. Sáu case study -- KHÓA

  Case   Structure   Objective          Algorithm
  ------ ----------- ------------------ ---------------
  C1     BD          Min Cost           Original SFOA
  C2     BD          Min Displacement   Original SFOA
  C3     MD          Min Cost           Original SFOA
  C4     MD          Min Displacement   Original SFOA
  C5     MJP         Min Cost           Original SFOA
  C6     MJP         Min Displacement   Original SFOA

## 7.2. Ma trận thực nghiệm

Mỗi case:

-   30 independent runs;
-   population = 100;
-   maximum iterations = 300;
-   cùng FEM;
-   cùng tải;
-   cùng constraint;
-   cùng penalty;
-   cùng miền biến;
-   cùng số đánh giá theo cấu hình.

Tổng:

\[ 6`\times30`{=tex}=180 \]

independent runs.

## 7.3. Chỉ tiêu đánh giá

### Thuật toán

-   Best;
-   Mean;
-   Worst/Max;
-   Standard Deviation;
-   convergence curve.

### Kết cấu

-   Cost;
-   Maximum displacement;
-   Design variables;
-   Constraint status;
-   Governing response.

### Phân tích trade-off

-   Cost của nghiệm tối ưu displacement;
-   Displacement của nghiệm tối ưu cost;
-   Phần trăm tăng/giảm;
-   Engineering interpretation.

------------------------------------------------------------------------

# 8. 6. KẾT QUẢ VÀ THẢO LUẬN

## 8.1. Khả năng hội tụ của SFOA

### Hình 1

**Hình 1. Đường hội tụ của SFOA cho sáu bài toán SOO**

Khuyến nghị:

-   6 đường trên 6 panel hoặc 6 hình riêng;
-   trục X: Iteration;
-   trục Y: Best-so-far fitness;
-   dùng cùng cách chuẩn hóa giữa các case.

**Không kết luận "SFOA tốt" chỉ dựa trên một đường hội tụ.** Phải kết
hợp với thống kê 30 lần chạy.

## 8.2. Độ ổn định qua 30 lần chạy

### Bảng 1. Kết quả thống kê 30 lần chạy của SFOA

  Case      Best   Mean   Max   STD   CV (%)
  ------- ------ ------ ----- ----- --------
  BD-C       TBD    TBD   TBD   TBD      TBD
  BD-D       TBD    TBD   TBD   TBD      TBD
  MD-C       TBD    TBD   TBD   TBD      TBD
  MD-D       TBD    TBD   TBD   TBD      TBD
  MJP-C      TBD    TBD   TBD   TBD      TBD
  MJP-D      TBD    TBD   TBD   TBD      TBD

**Thông điệp cần chứng minh:**

> Original SFOA có khả năng tạo nghiệm ổn định khi từng objective được
> tối ưu độc lập.

## 8.3. Kết quả tối ưu của BD

### Bảng 2. Thiết kế tối ưu của BD

  Design   Objective optimized       D     t     θ     L      Cost   Displacement
  -------- --------------------- ----- ----- ----- ----- --------- --------------
  BD-C     Cost                    TBD   TBD   TBD   TBD   **min**            TBD
  BD-D     Displacement            TBD   TBD   TBD   TBD       TBD        **min**

### Phân tích

-   So sánh thay đổi (D,t,`\theta`{=tex},L).
-   Xác định biến nào chi phối cost.
-   Xác định biến nào tạo thay đổi độ cứng/chuyển vị.
-   Kiểm tra nghiệm có thỏa tất cả constraint.

## 8.4. Kết quả tối ưu của MD

### Bảng 3. Thiết kế tối ưu của MD

  Design   Objective optimized       D     t     θ     L      Cost   Displacement
  -------- --------------------- ----- ----- ----- ----- --------- --------------
  MD-C     Cost                    TBD   TBD   TBD   TBD   **min**            TBD
  MD-D     Displacement            TBD   TBD   TBD   TBD       TBD        **min**

## 8.5. Kết quả tối ưu của MJP

### Bảng 4. Thiết kế tối ưu của MJP

  -------------------------------------------------------------------------------------------------
  Design   Objective           D      t      L     LL     LT      b      h      Cost   Displacement
           optimized                                                                 
  -------- -------------- ------ ------ ------ ------ ------ ------ ------ --------- --------------
  MJP-C    Cost              TBD    TBD    TBD    TBD    TBD    TBD    TBD   **min**            TBD

  MJP-D    Displacement      TBD    TBD    TBD    TBD    TBD    TBD    TBD       TBD        **min**
  -------------------------------------------------------------------------------------------------

## 8.6. So sánh với thiết kế hiện tại

### Bảng 5. So sánh thiết kế hiện tại và nghiệm SOO

  Structure   Design                Cost   ΔCost (%)     Displacement   ΔD (%)
  ----------- --------- ---------------- ----------- ---------------- --------
  BD          Current     lấy từ mô hình          --   lấy từ mô hình       --
  BD          SFOA-C                 TBD         TBD              TBD      TBD
  BD          SFOA-D                 TBD         TBD              TBD      TBD
  MD          Current     lấy từ mô hình          --   lấy từ mô hình       --
  MD          SFOA-C                 TBD         TBD              TBD      TBD
  MD          SFOA-D                 TBD         TBD              TBD      TBD
  MJP         Current     lấy từ mô hình          --   lấy từ mô hình       --
  MJP         SFOA-C                 TBD         TBD              TBD      TBD
  MJP         SFOA-D                 TBD         TBD              TBD      TBD

## 8.7. PHÂN TÍCH CỐT LÕI: COST--DISPLACEMENT TRADE-OFF

Đây là phần quan trọng nhất của bài.

### Bảng 6. So sánh chéo hai nghiệm cực trị

  ---------------------------------------------------------------------------------------
  Structure     Cost-optimal   Displacement   Displacement-optimal                Cost at
                        cost             at           displacement   displacement-optimal
                               cost-optimal                        
  ----------- -------------- -------------- ---------------------- ----------------------
  BD               (C_C\^\*)          (D_C)              (D_D\^\*)                  (C_D)

  MD               (C_C\^\*)          (D_C)              (D_D\^\*)                  (C_D)

  MJP              (C_C\^\*)          (D_C)              (D_D\^\*)                  (C_D)
  ---------------------------------------------------------------------------------------

Từ bảng này tính:

\[ `\Delta `{=tex}C = `\frac{C_D-C_C^*}{C_C^*}`{=tex}`\times100`{=tex}%
\]

\[ `\Delta `{=tex}D = `\frac{D_C-D_D^*}{D_C}`{=tex}`\times100`{=tex}% \]

### Hình 2

**Hình 2. Quan hệ giữa chi phí và chuyển vị của các nghiệm tối ưu đơn
mục tiêu**

Có thể biểu diễn 2 nghiệm:

-   Cost-optimal;
-   Displacement-optimal;

cho từng BD, MD, MJP.

**Mục tiêu của Hình 2:** trực quan hóa sự tồn tại của hai nghiệm cực trị
và khoảng cách giữa chúng.

------------------------------------------------------------------------

# 9. 7. LOGIC CHỨNG MINH HẠN CHẾ CỦA SOO VÀ NHU CẦU MOSFOA

## 9.1. Không được kết luận "SFOA thất bại"

Kết luận đúng:

> SFOA giải tốt từng bài toán đơn mục tiêu, nhưng bản chất SOO chỉ cho
> phép một objective chi phối quá trình lựa chọn nghiệm.

## 9.2. Bằng chứng 1 -- hai nghiệm cực trị khác nhau

Nếu:

\[ x_C\^*`\neq `{=tex}x_D\^* \]

và đồng thời:

\[ C(x_C\^*)\<C(x_D\^*) \]

\[ D(x_D\^*)\<D(x_C\^*) \]

thì tồn tại xung đột mục tiêu.

## 9.3. Bằng chứng 2 -- không có nghiệm duy nhất thỏa mọi ưu tiên

Nghiệm cost-optimal không phải nghiệm displacement-optimal.

Nghiệm displacement-optimal không phải nghiệm cost-optimal.

Do đó người thiết kế phải lựa chọn mức đánh đổi.

## 9.4. Bằng chứng 3 -- SOO không biểu diễn được vùng trung gian

Original SFOA trong bài này chỉ lưu/đánh giá nghiệm tốt nhất theo một
objective.

Nó không có:

-   Pareto dominance;
-   external archive;
-   diversity preservation;
-   density-based selection;
-   leader selection trong objective space.

Do đó một lần chạy SOO không thể tạo ra một tập nghiệm không trội tương
đương Pareto front.

## 9.5. Bằng chứng 4 -- cùng một bài toán nhưng hai mục tiêu cho hai quyết định thiết kế khác nhau

Đây là bằng chứng kỹ thuật quan trọng hơn việc chỉ nói về thuật toán.

``` text
Cost priority
     ↓
smaller/cheaper structural configuration
     ↓
higher displacement

Displacement priority
     ↓
stiffer/larger structural configuration
     ↓
higher cost
```

Nếu dữ liệu thực nghiệm xác nhận xu hướng này ở cả BD, MD và MJP thì lập
luận được củng cố mạnh.

## 9.6. Cầu nối sang MOSFOA

Phần kết của thảo luận phải dẫn tới:

> Bài toán thực tế không yêu cầu "một nghiệm tốt nhất" theo một tiêu chí
> duy nhất, mà cần một tập phương án cho phép cân bằng chi phí và đáp
> ứng kết cấu.

Từ đó:

``` text
SFOA/SOO
   ↓
Extreme solution 1: cost-optimal
Extreme solution 2: displacement-optimal
   ↓
Conflict
   ↓
Need multiple non-dominated solutions
   ↓
Pareto archive
   ↓
Diversity preservation
   ↓
Leader selection
   ↓
MOSFOA
```

**Không đưa toàn bộ thuật toán MOSFOA vào bài SOO.** Chỉ giới thiệu vừa
đủ ở cuối để giải thích hướng phát triển tiếp theo.

------------------------------------------------------------------------

# 10. 8. KẾT LUẬN

Kết luận dự kiến gồm 4 ý:

1.  SFOA nguyên bản đã được triển khai thành công trong framework
    SAP2000--MATLAB để giải sáu bài toán SOO của BD, MD và MJP.
2.  Kết quả 30 lần chạy cho thấy mức độ ổn định của SFOA trong từng bài
    toán đơn mục tiêu.
3.  Nghiệm tối ưu chi phí và nghiệm tối ưu chuyển vị thể hiện sự khác
    biệt rõ rệt về cấu hình thiết kế và tạo ra đánh đổi giữa hiệu quả
    kinh tế và độ cứng kết cấu.
4.  Vì SOO chỉ cung cấp nghiệm tối ưu theo từng objective và không duy
    trì tập nghiệm không trội, cách tiếp cận này chưa đủ để hỗ trợ bài
    toán thiết kế đồng thời nhiều mục tiêu. Đây là cơ sở nghiên cứu để
    phát triển MOSFOA cho tối ưu đa mục tiêu.

### Câu kết luận chiến lược

> **Kết quả nghiên cứu không phủ nhận hiệu quả của SFOA trong tối ưu đơn
> mục tiêu; thay vào đó, nghiên cứu chỉ ra rằng giới hạn nằm ở bản chất
> đơn mục tiêu của mô hình tối ưu, từ đó tạo động lực khoa học và kỹ
> thuật cho việc mở rộng SFOA sang MOSFOA.**

------------------------------------------------------------------------

# 11. MA TRẬN BẢNG/HÌNH CẦN CÓ

## 11.1. Bảng

    STT Bảng     Nội dung                      Trạng thái
  ----- -------- ----------------------------- ---------------------
      1 Bảng 1   Thống kê 30 runs của 6 case   Bắt buộc
      2 Bảng 2   BD -- 2 nghiệm SOO            Bắt buộc
      3 Bảng 3   MD -- 2 nghiệm SOO            Bắt buộc
      4 Bảng 4   MJP -- 2 nghiệm SOO           Bắt buộc
      5 Bảng 5   So sánh current vs SOO        Bắt buộc
      6 Bảng 6   Cross-objective trade-off     **Quan trọng nhất**

Có thể thêm:

  Bảng     Nội dung
  -------- -----------------------------------------------
  Bảng 7   Thống kê constraint violation
  Bảng 8   Số lần đạt nghiệm tốt nhất/độ ổn định nếu cần

Nhưng chỉ thêm nếu còn dung lượng dưới 5.000 từ.

## 11.2. Hình

    STT Hình     Nội dung
  ----- -------- --------------------------------------
      1 Hình 1   Framework SAP2000--MATLAB--SFOA
      2 Hình 2   Mô hình BD
      3 Hình 3   Mô hình MD
      4 Hình 4   Mô hình MJP
      5 Hình 5   Đường hội tụ 6 case
      6 Hình 6   Cost-optimal vs displacement-optimal
      7 Hình 7   Sơ đồ logic SFOA/SOO → MOSFOA/MOO

**Nếu bị giới hạn dung lượng:** gộp Hình 2--4 thành một hình gồm (a) BD,
(b) MD, (c) MJP; gộp Hình 5 thành một hình nhiều panel.

------------------------------------------------------------------------

# 12. MA TRẬN DỮ LIỆU PHẢI CHUẨN BỊ TRƯỚC KHI VIẾT

## 12.1. Dữ liệu dùng chung

-   SAP2000 MasterModel.
-   Load cases.
-   Load combinations.
-   Soil parameters.
-   Pile catalogue.
-   Material properties.
-   Unit prices.
-   Constraint equations.
-   Penalty parameters.
-   SFOA parameters.

## 12.2. Dữ liệu cho mỗi run

Mỗi run lưu tối thiểu:

``` text
case_id
run_id
iteration
fitness
objective_raw
penalty
objective_penalized
design_variables
constraint_status
SAP2000_displacement
governing_N
governing_M
governing_V
```

## 12.3. Dữ liệu cuối cùng cho mỗi case

``` text
best_solution
best_raw_objective
best_penalized_objective
mean
max
std
cv
best_design_variables
cost
displacement
constraint_status
runtime
FEA_evaluations
```

------------------------------------------------------------------------

# 13. CHỈ TIÊU ĐỂ CHỨNG MINH "SFOA TỐT TRONG SOO"

Không dùng một chỉ tiêu duy nhất.

Cần đồng thời:

### 13.1. Chất lượng nghiệm

Best objective.

### 13.2. Độ ổn định

STD và CV của 30 runs.

### 13.3. Khả năng hội tụ

Best-so-far curve.

### 13.4. Tính khả thi kỹ thuật

Tất cả constraint phải thỏa.

### 13.5. Hiệu quả tính toán

-   thời gian chạy;
-   số lần gọi SAP2000/FEA;
-   nếu đo được: thời gian trung bình mỗi evaluation.

------------------------------------------------------------------------

# 14. CHỈ TIÊU ĐỂ CHỨNG MINH "SOO CÓ GIỚI HẠN"

Không dùng "SFOA failed".

Dùng 4 chỉ tiêu:

  -----------------------------------------------------------------------
  Chỉ tiêu                            Ý nghĩa
  ----------------------------------- -----------------------------------
  (x_C\^*`\neq `{=tex}x_D\^*)         Hai ưu tiên tạo hai thiết kế khác
                                      nhau

  (C_C\^\*\<C_D)                      Cost-optimal thật sự rẻ hơn

  (D_D\^\*\<D_C)                      Displacement-optimal thật sự cứng
                                      hơn

  Không có archive/Pareto set         SOO không cung cấp tập phương án
                                      đánh đổi
  -----------------------------------------------------------------------

### Tiêu chuẩn kết luận mạnh

Nếu cả 3 hệ BD, MD và MJP đều xuất hiện:

\[ C(x_C\^*) \< C(x_D\^*) \]

và

\[ D(x_D\^*) \< D(x_C\^*) \]

thì có cơ sở rất mạnh để kết luận:

> **Cost and displacement constitute conflicting design objectives in
> the investigated marine structural systems.**

------------------------------------------------------------------------

# 15. KHÔNG ĐƯỢC LÀM TRONG BÀI SOO

## Không 1

Không thêm MOSFOA vào thực nghiệm của bài này.

## Không 2

Không dùng Pareto archive trong SFOA.

## Không 3

Không thay đổi thuật toán SFOA để "làm nó tốt hơn".

## Không 4

Không thêm quá nhiều thuật toán PSO/GWO/WOA... chỉ để benchmark.

## Không 5

Không dùng lại nguyên xi các Pareto front của bài MOO làm kết quả chính.

## Không 6

Không tuyên bố SFOA có "nhược điểm hội tụ" nếu 30 runs không chứng minh
được.

## Không 7

Không biến bài báo thành bài mô tả thuật toán.

**Trọng tâm phải là:**

> SFOA → ứng dụng kết cấu → nghiệm cực trị → trade-off → giới hạn SOO →
> động lực MOSFOA.

------------------------------------------------------------------------

# 16. QUAN HỆ VỚI BÀI MOO ĐÃ CÓ

## Paper SOO

**Câu hỏi:**

> What happens when SFOA optimizes each structural objective
> independently?

**Kết quả:**

-   cost-optimal design;
-   displacement-optimal design;
-   statistical stability;
-   trade-off diagnosis.

**Vai trò:**

> Diagnosis / foundation.

## Paper MOO

**Câu hỏi:**

> How can SFOA be extended to generate and maintain multiple
> Pareto-optimal marine structural designs?

**Kết quả:**

-   Pareto fronts;
-   B-MOSFOA;
-   E-MOSFOA;
-   convergence/diversity metrics;
-   engineering alternatives.

**Vai trò:**

> Algorithmic solution.

------------------------------------------------------------------------

# 17. SƠ ĐỒ CHUỖI NGHIÊN CỨU CHÍNH THỨC

``` text
                 SFOA ORIGINAL
                       │
                       ▼
        ┌──────────────────────────┐
        │  SINGLE-OBJECTIVE STUDY │
        └──────────────────────────┘
             │       │       │
             ▼       ▼       ▼
            BD      MD      MJP
             │       │       │
        ┌────┴───┐ ┌─┴────┐ ┌┴─────┐
        ▼        ▼ ▼      ▼ ▼      ▼
      Min C    Min D ...  ...    Min C/Min D
        │        │
        └────┬───┘
             ▼
     Extreme solutions
             │
             ▼
       Cost–Displacement
           conflict
             │
             ▼
     SOO limitation identified
             │
             ▼
   Need non-dominated solution set
             │
             ▼
       MOSFOA DEVELOPMENT
             │
             ▼
      MULTI-OBJECTIVE STUDY
             │
             ▼
       Pareto-optimal designs
```

------------------------------------------------------------------------

# 18. CHECKLIST TRƯỚC KHI VIẾT BẢN THẢO

## Phương pháp

-   [ ] Original SFOA, không sửa thuật toán.
-   [ ] 3 kết cấu: BD, MD, MJP.
-   [ ] 2 objective/case.
-   [ ] 6 cases.
-   [ ] 30 runs/case.
-   [ ] Population 100.
-   [ ] 300 iterations.
-   [ ] Cùng FEM với MOO.
-   [ ] Cùng tải và tổ hợp tải.
-   [ ] Cùng constraint.
-   [ ] Cùng penalty.

## Kết quả

-   [ ] 6 convergence curves.
-   [ ] Best/Mean/Max/STD/CV.
-   [ ] 6 optimal designs.
-   [ ] Current vs optimized.
-   [ ] Cross-objective evaluation.
-   [ ] Cost increase/decrease.
-   [ ] Displacement increase/decrease.
-   [ ] Constraint verification.
-   [ ] Runtime/FEA evaluations nếu có.

## Logic khoa học

-   [ ] Không nói SFOA thất bại.
-   [ ] Chứng minh SFOA tốt trong SOO.
-   [ ] Chứng minh 2 objective xung đột.
-   [ ] Chỉ ra SOO tạo nghiệm cực trị riêng biệt.
-   [ ] Chỉ ra không có Pareto set.
-   [ ] Dẫn tự nhiên sang MOSFOA.

## Quy cách Tạp chí

-   [ ] Tiêu đề Việt + Anh \<20 từ.
-   [ ] Tóm tắt Việt + Anh 150--300 từ.
-   [ ] 5--10 keywords.
-   [ ] "ĐẶT VẤN ĐỀ", không dùng "MỞ ĐẦU".
-   [ ] Mục chính viết hoa, đậm.
-   [ ] Tiểu mục đúng cấp.
-   [ ] Bảng/Hình chú thích đúng quy cách.
-   [ ] Công thức đánh số liên tục.
-   [ ] Dấu thập phân tiếng Việt dùng ",".
-   [ ] Tài liệu tham khảo chuẩn hóa.
-   [ ] Tổng nội dung ≤5.000 từ.

------------------------------------------------------------------------

# 19. NGUỒN CĂN CỨ

### \[S1\] Tài liệu quy cách Tạp chí Xây dựng

**CẤU TRÚC, THỂ THỨC TRÌNH BÀY BÀI BÁO KHOA HỌC TRÊN TẠP CHÍ XÂY DỰNG.**

File người nghiên cứu cung cấp, 4 trang.

### \[S2\] Thể lệ viết và gửi bài cho Tạp chí Xây dựng

Tạp chí Xây dựng, 26/08/2023.

Nội dung được kiểm tra trên website chính thức của Tạp chí Xây dựng:
tiêu đề Việt/Anh dưới 20 từ; tóm tắt 150--300 từ; 5--10 từ khóa; bài
nghiên cứu không quá 5.000 từ; A4, Myriad Pro 9; lề trên 3 cm, dưới 2
cm, phải 1,8 cm, trái 1,3 cm.

### \[S3\] SFOA gốc

Zhong, C., Li, G., Meng, Z., Li, H., Yildiz, A.R., Mirjalili, S.
*Starfish optimization algorithm (SFOA): a bio-inspired metaheuristic
algorithm for global optimization compared with 100 optimizers*. Neural
Computing and Applications, 37, 3641--3683, 2025.

### \[S4\] Bài MOSFOA/MOO nền

*Multi-objective Optimization Design of Marine Structures Based on An
Enhanced Starfish Algorithm.*

Case studies: BD, MD và MJP; mục tiêu: construction cost và maximum
displacement; framework SAP2000--MATLAB; B-MOSFOA và E-MOSFOA.

------------------------------------------------------------------------

# 20. QUYẾT ĐỊNH THIẾT KẾ CUỐI CÙNG

**Bài SOO này được khóa theo 5 nguyên tắc:**

1.  **Không thay đổi bài toán kết cấu nền.**
2.  **Không thay đổi Original SFOA.**
3.  **Không biến bài thành benchmark thuật toán.**
4.  **Tập trung vào sáu SOO cases và phân tích chéo hai nghiệm cực
    trị.**
5.  **Kết luận về hạn chế phải là hạn chế của cách tiếp cận SOO trong
    bài toán đa mục tiêu, không phải tuyên bố SFOA là thuật toán kém.**

### Câu chuyện khoa học cuối cùng

\[ `\boxed{
\text{SFOA works for SOO}
\rightarrow
\text{but SOO gives extreme solutions only}
\rightarrow
\text{Cost and displacement conflict}
\rightarrow
\text{A Pareto solution set is required}
\rightarrow
\text{MOSFOA is justified}
}`{=tex} \]

Đây là **logic nghiên cứu chính thức cần giữ nguyên trong toàn bộ quá
trình viết bài**.
