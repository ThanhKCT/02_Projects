**Tối ưu thể tích bê tông kết cấu kè sau cầu bằng thuật toán tối ưu sao
biển**

Concrete Volume Optimization of the Bridge-Abutment Revetment Structure
Using the Starfish Optimization Algorithm (SFOA)

**TÓM TẮT**

Nghiên cứu áp dụng thuật toán tối ưu sao biển gốc (Original Starfish
Optimization Algorithm -- SFOA) để tối thiểu hóa thể tích bê tông kết
cấu tường chắn và bản đáy của một công trình kè sau cầu thực tế, chịu
đồng thời năm nhóm ràng buộc kỹ thuật theo tiêu chuẩn Việt Nam hiện
hành. Mô hình phần tử hữu hạn SAP2000 được liên kết trực tiếp với MATLAB
qua giao diện COM, cho phép SFOA cập nhật sáu biến chiều dày độc lập
(bốn vùng tường, hai vùng bản đáy) và đánh giá phản hồi kết cấu bằng
phân tích FEM trong từng bước lặp. Các nhóm ràng buộc gồm sức chịu tải
cọc (TCVN 10304:2025), chuyển vị ngang đỉnh tường (TCVN 11820-5:2021),
khả năng chịu cắt và bề rộng vết nứt (TCVN 4116:2023), và chọc thủng bản
đáy theo từng cọc; nghiệm tối ưu được hậu kiểm theo EN 1992-1-1. Kết quả
tối ưu với quần thể 50 cá thể, 50 vòng lặp cho thể tích bê tông 231,16
m³, giảm thể tích bê tông 52,98 m³ (18,65%) so với thiết kế hiện trạng
(284,14 m³), đồng thời thỏa mãn toàn bộ năm nhóm ràng buộc kỹ thuật.
Đường cong hội tụ ổn định từ khoảng vòng lặp thứ 34. Kết quả cho thấy
phương pháp tối ưu có khả năng phân bổ lại chiều dày giữa các vùng kết
cấu theo mức độ yêu cầu chịu lực, qua đó giảm thể tích bê tông so với
phương án hiện trạng.

**Từ khóa:** Thuật toán tối ưu sao biển; tối ưu thể tích bê tông; kè sau
cầu; SAP2000--MATLAB; TCVN 10304:2025; TCVN 4116:2023.

**ABSTRACT**

This study applies the original Starfish Optimization Algorithm (SFOA)
to minimize the concrete volume of the retaining wall and base slab of
an actual bridge-abutment revetment structure, subject to five groups of
simultaneous technical constraints under current Vietnamese standards. A
SAP2000 finite-element model is directly coupled with MATLAB through a
COM interface, allowing SFOA to update six independent thickness
variables (four wall zones, two base-slab zones) and evaluate the
structural response through FEM analysis at every iteration. The
constraint groups comprise pile bearing capacity (TCVN 10304:2025),
lateral displacement at the wall top (TCVN 11820-5:2021), shear capacity
and crack width (TCVN 4116:2023), and base-slab punching shear at each
pile; the optimal solution is additionally verified according to EN
1992-1-1. With a population of 50 individuals over 50 iterations, the
optimal solution reaches a concrete volume of 231.16 m³, a reduction of
52.98 m³ (18.65%) compared with the as-built design (284.14 m³), while
satisfying all five groups of constraints. The convergence curve
stabilizes from around iteration 34. The results indicate that the
proposed optimization approach can reallocate the thickness of the
structural zones according to their structural demand, thereby reducing
the concrete volume relative to the as-built design.

**Keywords:** Starfish Optimization Algorithm; concrete volume
optimization; bridge-abutment revetment; SAP2000--MATLAB; TCVN
10304:2025; TCVN 4116:2023.

# **1. ĐẶT VẤN ĐỀ**

Kè sau cầu, trong nghiên cứu này, là kết cấu chắn đất phía sau công
trình bến bệ cọc cao, bố trí tại khu vực tiếp giáp giữa công trình bến
và bãi sau kè, có chức năng giữ ổn định khối đất đắp và bảo vệ mặt bãi
sau bến. Do tường chắn và bản đáy thường được chia thành nhiều vùng
chiều dày khác nhau theo cao trình và vị trí để phù hợp với sự phân bố
nội lực thực tế, thể tích bê tông của kết cấu phụ thuộc đồng thời vào
nhiều biến thiết kế độc lập. Thiết kế theo kinh nghiệm, dựa trên kiểm
tra tuần tự từng tiết diện, khó xác định đồng thời tổ hợp chiều dày tối
thiểu cho tất cả các vùng sao cho vẫn thỏa mãn mọi ràng buộc kỹ thuật,
dẫn đến dư thừa khả năng chịu lực cục bộ và làm tăng thể tích bê tông sử
dụng không cần thiết.

Các thuật toán tối ưu metaheuristic, kết hợp trực tiếp với mô hình phần
tử hữu hạn (FEM) để đánh giá phản hồi kết cấu trong vòng lặp tối ưu, phù
hợp với lớp bài toán tối ưu kết cấu có tính phi tuyến cao, biến thiết kế
rời rạc và nhiều ràng buộc kỹ thuật đồng thời mà phương pháp giải tích
truyền thống khó xử lý \[1\]. Thuật toán tối ưu sao biển (Starfish
Optimization Algorithm - SFOA) là thuật toán metaheuristic được đề xuất
gần đây, lấy cảm hứng từ hành vi săn mồi và tái sinh của sao biển, đã
được đánh giá hiệu quả trên nhiều hàm kiểm thử chuẩn và một số bài toán
kỹ thuật \[1\]. Nghiên cứu này không đánh giá SFOA trên các hàm kiểm thử
chuẩn mà tập trung vào khả năng ứng dụng SFOA gốc cho bài toán tối ưu
kết cấu thực tế, kết hợp trực tiếp với FEM và các ràng buộc theo tiêu
chuẩn Việt Nam hiện hành.

Việc kết hợp SFOA với SAP2000 cho bài toán tối ưu thể tích bê tông kết
cấu kè sau cầu, chịu đồng thời năm nhóm ràng buộc kỹ thuật theo hệ tiêu
chuẩn phù hợp với công trình bến bệ cọc cao -- trong đó có hai tiêu
chuẩn mới ban hành gần đây (xem Mục 2.4) -- trong phạm vi nghiên cứu
được khảo sát, chưa được xem xét. Mục tiêu của nghiên cứu là: (1) xây
dựng khung tính toán SAP2000-MATLAB-SFOA cho bài toán tối ưu thể tích bê
tông của sáu vùng chiều dày kè sau cầu, chịu đồng thời năm nhóm ràng
buộc kỹ thuật theo hệ tiêu chuẩn được lựa chọn; (2) áp dụng khung tính
toán này cho một công trình thực tế và đánh giá mức giảm thể tích bê
tông so với hiện trạng. Đóng góp chính của nghiên cứu là minh chứng qua
một công trình thực tế về khả năng ứng dụng SFOA gốc, không cần điều
chỉnh hay lai ghép thêm cơ chế nào, cho một bài toán tối ưu kết cấu chắn
đất thực tế có nhiều nhóm ràng buộc kỹ thuật đồng thời. Với sáu biến
thiết kế được rời rạc hóa theo bước 0,01 m, không gian thiết kế chứa số
lượng lớn các phương án có thể lựa chọn, khiến việc khảo sát toàn bộ đòi
hỏi chi phí tính toán cao. Do đó, nghiên cứu sử dụng SFOA để tìm kiếm
nghiệm tối ưu.

# **2. MÔ HÌNH BÀI TOÁN VÀ PHƯƠNG PHÁP**

## **2.1. Hệ kết cấu**

Đối tượng nghiên cứu, như mô tả ở Mục 1, là hệ kết cấu có tường chắn cao
4,5 m, chia thành bốn vùng chiều dày độc lập theo cao trình và vị trí
dọc tuyến, liên kết với bản đáy đặt trên hệ 142 cọc bê tông ly tâm ứng
suất trước (đường kính D400 và D500); bản đáy được chia thành hai vùng
chiều dày độc lập. Hệ kết cấu thuộc loại bến bệ cọc cao, với kết cấu
chắn đất phía sau bến, được kiểm tra theo hệ tiêu chuẩn trình bày ở Mục
2.4. Tường chắn và bản đáy được mô hình hóa bằng phần tử vỏ (shell)
trong SAP2000, sử dụng bê tông mác M350; hệ cọc được mô hình bằng phần
tử thanh (frame), với kích thước và bố trí được giữ nguyên trong suốt
quá trình tối ưu.

## **2.2. Tải trọng và tổ hợp tải**

Hệ kết cấu chịu bốn trường hợp tải cơ bản: Tĩnh tải bản thân (DEAD);
trọng lượng khối đất đắp sau tường (Gdat); áp lực đất chủ động dạng lực
tập trung (Pdat) và dạng phân bố (ALD).

Hai tổ hợp tải được xét:

TH1 = DEAD + Gdat + Pdat + ALD (không xét đến hoạt tải khai thác)

TH2 = TH1 + HH (có bổ sung hoạt tải chất xếp/khai thác trên mặt bãi).

Tổ hợp bao BAO, lấy giá trị bao trùm của TH1 và TH2, được dùng để trích
xuất nội lực và chuyển vị cho toàn bộ quá trình kiểm tra ràng buộc.

![](media/image1.emf){width="4.858333333333333in"
height="3.837794181977253in"}

Hình 1. Mô hình phần tử hữu hạn 3D của kết cấu kè sau bến bệ cọc cao

## **2.3. Biến thiết kế và hàm mục tiêu**

Sáu biến thiết kế x = \[x~1~, x~2~, \..., x~6~\] là chiều dày của bốn
vùng tường chắn và hai vùng bản đáy. Các biến được rời rạc hóa theo bước
0,01 m trước khi cập nhật vào mô hình SAP2000. Miền giá trị khảo sát (m)
là x~1~, x~2~ ∈ \[0,15; 0,40\]; x~3~ ∈ \[0,15; 0,50\]; x~4~ ∈ \[0,20;
0,90\]; x~5~ ∈ \[0,45; 1,40\]; x~6~ ∈ \[0,30; 0,70\], xác định dựa trên
chiều dày hiện trạng (Bảng 2) và kinh nghiệm thiết kế sơ bộ. Hàm mục
tiêu là tổng thể tích bê tông của sáu vùng, được xác định trực tiếp từ
diện tích tương ứng và chiều dày thiết kế:

  -----------------------------------------------------------------------
  $$V(x) = \sum_{i = 1}^{6}A_{i} \cdot x_{i}$$                 \(1\)
  ------------------------------------------------------------ ----------

  -----------------------------------------------------------------------

Với A~i~ là diện tích vùng i (m²), x~i~ là chiều dày vùng i (m) và V(x)
là thể tích bê tông (m³).

Hàm thích nghi dùng cho SFOA kết hợp hàm mục tiêu với hàm phạt tuyến
tính theo tổng mức vi phạm ràng buộc g(x) (mục 2.4) \[2\]:

  -----------------------------------------------------------------------
                 $$f(x) = V(x) + C \cdot g(x)$$                  \(2\)
  ------------------------------------------------------------ ----------
   $$g(x) = \sum_{j = 1}^{5}{\max\left( 0,v_{j}(x) \right)}$$    \(3\)

  -----------------------------------------------------------------------

Với v~j~(x) là mức vi phạm không thứ nguyên của nhóm ràng buộc thứ j,
xác định theo tỷ số giữa đại lượng kiểm tra R~j~(x) và giới hạn cho phép
R~j,lim~:

  --------------------------------------------------------------------------------------
  $$v_{j}(x) = \max\left( 0,\frac{R_{j}(x)}{R_{j,\text{lim}}} - 1 \right)$$   \(4\)
  --------------------------------------------------------------------------- ----------

  --------------------------------------------------------------------------------------

(v~j~(x) = 0 nếu ràng buộc được thỏa mãn).

Trong nghiên cứu này, hệ số phạt được chọn bằng C = 10^6^ nhằm ưu tiên
các nghiệm thỏa mãn ràng buộc.

## **2.4. Ràng buộc kỹ thuật**

Các nhóm ràng buộc kỹ thuật được kiểm tra tại mỗi lần đánh giá, cùng
nguồn tiêu chuẩn và cách xử lý trong vòng lặp tối ưu được thể hiện trong
Bảng 1.

Bảng 1. Nhóm ràng buộc kỹ thuật của bài toán tối ưu

+:-------:+:--------:+:----------------:+:------------------:+:-------------:+
| **STT** | **Ràng   | **Đại lượng kiểm | **Điều kiện thỏa   | **Ghi chú**   |
|         | buộc**   | tra**            | mãn**              |               |
+---------+----------+------------------+--------------------+---------------+
| 1       | Sức chịu | N~d~ xác định từ | N~d~ ≤ \[N~d~\]    | TCVN          |
|         | tải cọc  | phản lực đầu cọc |                    | 10304:2025    |
|         |          |                  | (D400: 78,76T;     |               |
|         |          |                  | D500: =112,44T)    |               |
+---------+----------+------------------+--------------------+---------------+
| 2       | Chuyển   | max\|U~1~\| tại  | ≤ min(H/300,       | TCVN          |
|         | vị ngang | các nút thuộc    | 100mm) = 15mm      | 11820-5:2021, |
|         | đỉnh     | nhóm đỉnh tường  |                    | Bảng 12       |
|         | tường    |                  |                    |               |
+---------+----------+------------------+--------------------+---------------+
| 3       | Khả năng | Lực cắt Q tại    | γ~lc~·γ~n~·Q ≤     | TCVN          |
|         | chịu cắt | tiết diện cách   | γ~c~·γ~b7~·Q~b~    | 4116:2023,    |
|         |          | mặt gối tựa một  |                    | Điều 8.2.12   |
|         |          | đoạn h~0~        |                    |               |
+---------+----------+------------------+--------------------+---------------+
| 4       | Bề rộng  | a~cr~ tính từ    | a~cr~ ≤ γ~c~ ·     | TCVN          |
|         | vết nứt  | ứng suất cốt     | 0,2mm              | 4116:2023,    |
|         |          | thép σ~s~        |                    | Điều          |
|         |          |                  |                    | 9.2/9.1.1     |
+---------+----------+------------------+--------------------+---------------+
| 5       | Chọc     | Phản lực đầu cọc | \|N~d~\| ≤         | TCVN          |
|         | thủng    | so với khả năng  | γ~c~·R~bt~·u·h~0~  | 5574:2018     |
|         | bản đáy  | chống chọc thủng |                    |               |
|         |          | theo chu vi tháp |                    |               |
|         |          | chọc thủng       |                    |               |
+---------+----------+------------------+--------------------+---------------+

Theo TCVN 11820-5:2021, Bảng 12, giới hạn chuyển vị ngang là U~lim~ =
min(H/300, 100mm); với H = 4,5 m, giới hạn sử dụng là 15 mm. Nhóm ràng
buộc 3 và 4 được kiểm tra riêng cho từng vùng, sử dụng nội lực bao (M,
V) trích xuất từ SAP2000 theo tổ hợp bao BAO. Đối với kiểm tra chịu cắt,
nội lực được trích xuất tại các vị trí cách mặt gối tựa hoặc mép cọc một
khoảng không nhỏ hơn h~0~, nhằm hạn chế đỉnh nội lực cục bộ tại biên
phần tử vỏ. Kiểm tra chọc thủng được thực hiện riêng cho từng cọc, với
h~0~ của vùng bản đáy tương ứng.

## **2.5. Khung tính toán SAP2000--MATLAB--SFOA**

Quá trình đánh giá mỗi cá thể được thực hiện tuần tự. Trước hết, các
biến thiết kế được rời rạc hóa theo bước 0,01 m và cập nhật vào mô hình
SAP2000 thông qua hàm OAPI SetShell_1. Sau đó, mô hình được phân tích
bằng phương pháp phần tử hữu hạn để xác định phản lực đầu cọc, chuyển vị
và nội lực vỏ theo tổ hợp bao BAO. Các kết quả này được sử dụng để kiểm
tra các nhóm ràng buộc, tính thể tích bê tông và hàm thích nghi, rồi trả
về SFOA để cập nhật quần thể.

## **2.6. Thuật toán SFOA gốc và thiết lập tính toán**

Nghiên cứu sử dụng thuật toán SFOA gốc \[1\], gồm hai giai đoạn khám phá
và khai thác dựa trên hành vi tìm mồi và tái sinh của sao biển, không bổ
sung cơ chế nào khác. Do mục tiêu là đánh giá khả năng ứng dụng SFOA cho
một bài toán thiết kế cụ thể, không nhằm so sánh hay phát triển thuật
toán, quá trình tối ưu chỉ thực hiện một lần chạy duy nhất (Nrun = 1),
không yêu cầu thống kê giá trị tốt nhất, giá trị trung bình và độ lệch
chuẩn qua nhiều lần chạy như các nghiên cứu đánh giá thuật toán. Khảo
sát sơ bộ với N~pop~=15, 40 vòng lặp cho thấy nghiệm cải thiện rất ít ở
các vòng lặp cuối; do đó nghiên cứu chọn N~pop~=50, Maxit=50 (2.550 lần
đánh giá) cho lần chạy chính thức, lớn hơn đáng kể ngưỡng hội tụ quan
sát được để tạo biên an toàn.

# **3. KẾT QUẢ VÀ THẢO LUẬN**

## **3.1. Sự hội tụ của thuật toán**

Hình 2 thể hiện đường cong hội tụ (giá trị tốt nhất tích lũy theo vòng
lặp) của lần chạy chính thức. Giá trị hàm mục tiêu giảm theo từng nấc
trong quá trình tối ưu, từ 248,67 m³ ở vòng lặp thứ nhất xuống 238,87 m³
ở vòng lặp thứ 2, tiếp tục giảm xuống 237,77 m³ ở vòng lặp 17 và 231,81
m³ ở vòng lặp 24, sau đó không đổi từ vòng lặp 34 đến 50 (231,16 m³
trong 17 vòng lặp cuối), cho thấy nghiệm thu được đã ổn định ở giai đoạn
cuối của lần chạy.

![](media/image2.png){width="5.725in" height="3.9572648731408573in"}

Hình 2. Đường cong hội tụ của SFOA (giá trị tốt nhất tích lũy theo vòng
lặp)

## **3.2. Nghiệm tối ưu**

Bảng 2. So sánh nghiệm tối ưu với thiết kế hiện trạng

  ----------------------- ---------------------- -------------------------
     **Biến thiết kế**    **Chiều dày hiện trạng  **Chiều dày tối ưu thu
                                  (m)**                 được (m)**

     x~1~ -- TUONGC30              0,30                    0,15

     x~2~ -- TUONGM30              0,30                    0,23

     x~3~ -- TUONGM43              0,43                    0,25

     x~4~ -- TUONGM78              0,78                    0,27

      x~5~ -- DAY130               1,30                    0,69

       x~6~ -- DAY60               0,60                    0,59

  Thể tích bê tông V (m³)         284,14             231,16 (nhỏ nhất)

       Chênh lệch ΔV                                -52,98 m³ (-18,65%)
  ----------------------- ---------------------- -------------------------

Nghiệm tối ưu giảm chiều dày ở cả sáu vùng so với hiện trạng, với mức
giảm tương đối lớn nhất thuộc về vùng tường TUONGM78 (65,4%, từ 0,78 m
xuống 0,27 m) và nhỏ nhất thuộc về vùng bản đáy DAY60 (1,7%, từ 0,60 m
xuống 0,59 m) -- hai vùng lần lượt có diện tích nhỏ nhất và lớn nhất
trong sáu vùng (12,35 m² và 290,27 m²). Kết quả cho thấy mức giảm chiều
dày giữa các vùng là khác nhau, phản ánh sự khác biệt về hình học và yêu
cầu chịu lực của từng vùng trong quá trình tối ưu.

## **3.3. Kiểm tra ràng buộc kỹ thuật của nghiệm tối ưu**

Bảng 3. Kiểm tra ràng buộc của nghiệm tối ưu

  ------------------------------ ---------------- ----------- -------------
          **Ràng buộc**            **Giá trị/tỷ     **Giới    **Kết luận**
                                       số**          hạn**    

     Sức chịu tải cọc (tỷ số          0,372          ≤ 1,0      Thỏa mãn
          N~d~/\[N~d~\])                                      

    Chuyển vị ngang đỉnh tường       4,15 mm        ≤ 15 mm     Thỏa mãn

        Khả năng chịu cắt         Không vi phạm       \--       Thỏa mãn

         Bề rộng vết nứt          Không vi phạm    ≤ 0,2 mm     Thỏa mãn

        Chọc thủng bản đáy             0,41          ≤ 1,0      Thỏa mãn
  ------------------------------ ---------------- ----------- -------------

Toàn bộ năm nhóm ràng buộc kỹ thuật đều được thỏa mãn (hàm phạt bằng 0).
Đối với sức chịu tải cọc, tỷ số sử dụng lớn nhất là 37,2%; chuyển vị
ngang đỉnh tường đạt 27,7% giới hạn (4,15 mm so với 15 mm); chọc thủng
(mục 3.5) đạt tối đa 41,0%. Các điều kiện chịu cắt và bề rộng vết nứt
vẫn cần được kiểm soát khi tiếp tục giảm chiều dày các vùng kết cấu.

## **3.4. Hiệu quả tính toán**

Thời gian tính toán trung bình khoảng 14,2 giây cho mỗi lần đánh giá
trong tổng số 2.550 lần đánh giá, tương ứng tổng thời gian khoảng 10 giờ
02 phút cho toàn bộ quá trình tối ưu.

## **3.5. Hạn chế**

Nghiên cứu chỉ thực hiện một lần chạy tối ưu (Nrun = 1), phù hợp với mục
tiêu đánh giá khả năng ứng dụng SFOA cho một công trình cụ thể thay vì
đánh giá độ ổn định thống kê của thuật toán. Đường cong hội tụ ở Mục 3.1
được sử dụng để đánh giá sự ổn định của nghiệm trong quá trình tối ưu.
Trong vòng lặp tối ưu, các ràng buộc về chịu cắt và bề rộng vết nứt được
kiểm tra trên cơ sở tỷ lệ cốt thép ước tính từ mô men yêu cầu, chưa xét
đến cấu tạo cốt thép cụ thể trong bản vẽ thiết kế. Đối với chọc thủng,
nghiệm tối ưu được kiểm tra bổ sung độc lập với vòng lặp theo EN
1992-1-1 \[7\], Điều 6.4.3--6.4.4, cho toàn bộ 142 cọc, phân loại theo
vị trí trong, biên và góc bản đáy, sử dụng các hệ số β lần lượt là 1,15;
1,40 và 1,50. Kết quả cho thấy không có cọc nào vi phạm, tỷ số sử dụng
lớn nhất bằng 0,41 tại một cọc biên. Ngoài ra, biến chiều dày x1 hội tụ
đúng tại cận dưới của phạm vi khảo sát trong bài toán tối ưu; việc xem
xét giảm thêm chiều dày vùng này, nếu khả thi, cần dựa trên các yêu cầu
cấu tạo tối thiểu (lớp bê tông bảo vệ, bố trí cốt thép) ngoài phạm vi
các ràng buộc chịu lực đã kiểm tra trong nghiên cứu này. Do đó, nghiệm
thu được xem là phương án đề xuất ở cấp độ tối ưu chiều dày; trước khi
áp dụng cho thiết kế thi công, cần tiếp tục hoàn thiện và kiểm tra chi
tiết cốt thép theo hồ sơ thiết kế.

# **4. KẾT LUẬN**

Nghiên cứu đã xây dựng và áp dụng khung tính toán kết hợp
SAP2000--MATLAB và thuật toán SFOA gốc để tối ưu sáu biến chiều dày của
tường chắn và bản đáy kè sau cầu, đồng thời kiểm tra năm nhóm ràng buộc
kỹ thuật theo hệ tiêu chuẩn phù hợp với công trình bến cảng biển.

Đối với công trình khảo sát, nghiệm tối ưu cho thể tích bê tông 231,16
m³, giảm 52,98 m³, tương đương 18,65% so với phương án hiện trạng.
Nghiệm thu được thỏa mãn toàn bộ các ràng buộc kiểm tra và ổn định ở các
vòng lặp cuối của quá trình tối ưu.

Kết quả hiện mới dừng ở tối ưu chiều dày và kiểm tra ràng buộc trong mô
hình tính toán; hậu kiểm bổ sung cho thấy nghiệm tối ưu cũng thỏa mãn
điều kiện chọc thủng theo EN 1992-1-1 với tỷ số sử dụng lớn nhất 0,41.
Việc hoàn thiện chi tiết cốt thép cần được thực hiện ở bước thiết kế
tiếp theo trước khi áp dụng cho thiết kế thi công.

Kết quả nghiên cứu là cơ sở cho các nghiên cứu tiếp theo phát triển SFOA
theo hướng MOSFOA nhằm xem xét bài toán tối ưu đa mục tiêu đối với các
kết cấu tương tự.

# **TÀI LIỆU THAM KHẢO**

\[1\] Zhong, C., Li, G., Meng, Z., Li, H., Yildiz, A.R., Mirjalili, S.
Starfish optimization algorithm (SFOA): a bio-inspired metaheuristic
algorithm for global optimization compared with 100 optimizers. Neural
Computing and Applications, vol. 37, pp. 3641-3683, 2025, doi:
10.1007/s00521-024-10694-1.

\[2\] Deb, K. An efficient constraint handling method for genetic
algorithms. Computer Methods in Applied Mechanics and Engineering, vol.
186, no. 2-4, pp. 311-338, 2000, doi: 10.1016/S0045-7825(99)00389-8.

\[3\] TCVN 10304:2025. Thiết kế móng cọc. Bộ Xây dựng, Việt Nam, 2025.

\[4\] TCVN 11820-5:2021. Công trình cảng biển - Yêu cầu thiết kế - Phần
5: Công trình bến. Bộ Khoa học và Công nghệ, Việt Nam, 2021.

\[5\] TCVN 4116:2023. Công trình thủy lợi - Kết cấu bê tông và bê tông
cốt thép thủy công - Yêu cầu thiết kế. Bộ Khoa học và Công nghệ, Việt
Nam, 2023.

\[6\] TCVN 5574:2018. Thiết kế kết cấu bê tông và bê tông cốt thép. Bộ
Khoa học và Công nghệ, Việt Nam, 2018.

\[7\] EN 1992-1-1:2004+A1:2014. Eurocode 2: Design of concrete
structures - Part 1-1: General rules and rules for buildings. European
Committee for Standardization (CEN), Brussels, 2014.
