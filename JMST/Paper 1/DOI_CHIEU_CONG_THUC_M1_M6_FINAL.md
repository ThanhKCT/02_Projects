# ĐỐI CHIẾU CÔNG THỨC M2–M6 — BẢN CHỐT SAU KHI ĐỐI CHIẾU ẢNH GỐC

## 1. Phạm vi đối chiếu

Đã đối chiếu trực tiếp các ảnh người dùng cung cấp cho toàn bộ nhóm phương pháp xác định điểm ngàm / chiều dài tính toán của cọc:

- **M2:** 20TCN21-86; TCXD 205-1998 — công thức (3.22a), (3.23a);
- **M3:** TCVN 10304:2014 — công thức (3.22b), (3.23b);
- **M4:** Tiêu chuẩn Nga — công thức (3.24), (3.25);
- **M5:** Budin A.Ya.; Demina G.A — công thức (3.26), (3.27);
- **M6:** Tiêu chuẩn Nhật Bản TCNB 2002 — công thức (3.28), (3.29).

Kết quả dưới đây được chép theo nội dung thể hiện trong ảnh gốc, không tự thay thế bằng công thức từ nguồn khác.

---


# 1. M1 — 22TCN 207-92: Xác định điểm ngàm của cọc trong đất

## 1.1. Chiều dài tính toán của cọc trong khung

Theo công thức (3.1):

$$
\boxed{
l=H_0\pm h_{gđ}+h_z
}
$$

Trong đó:

- $H_0$ — khoảng cách từ trọng tâm mặt cắt ngang dầm đến giao điểm giữa đường đáy (mái dốc) với tim cọc;
- $h_{gđ}$ — chiều cao từ giao điểm giữa đường mái dốc với tim cọc đến mặt phẳng nằm ngang giả định;
- $h_z$ — độ sâu tính toán của điểm ngàm giả định.

Dấu trong công thức (3.1) phụ thuộc hướng tác dụng của lực ngang $P$:

- lực ngang hướng về khu nước hoặc hướng dọc theo mép bến → lấy dấu **“+”**;
- lực ngang hướng vào bờ → lấy dấu **“−”**.

---

## 1.2. Xác định $h_{gđ}$ theo từng trường hợp

### Case 1 — Cọc đóng trên mái dốc, lực $P$ vuông góc với mép bến hướng ra phía khu nước

Theo công thức (3.2):

$$
\boxed{
h_{gđ}
=
h_z
\left(
\sqrt{\frac{m_\lambda}{m_\theta}}-1
\right)
}
$$

### Case 2 — Cọc đóng trên mái dốc, lực $P$ tác động dọc mép bến

Theo công thức (3.3):

$$
\boxed{
h_{gđ}
=
0,5h_z
\left(
\sqrt{\frac{m_\lambda}{m_\theta}}-1
\right)
}
$$

### Case 3 — Cọc đóng gần mái dốc, lực $P$ hướng ra khu nước

Nguồn quy định: khi mặt phẳng nằm ngang giả định được xác định bởi độ sâu $h_{gđ}$ nằm thấp hơn đáy bến, thì độ sâu $h_z$ được đặt từ cao trình đáy bến.

**Không có công thức riêng được đánh số trong đoạn ảnh cung cấp cho trường hợp này.**

### Case 4 — Cọc đóng trên mái dốc, lực $P$ vuông góc với mép bến hướng vào phía bờ

Theo công thức (3.7):

$$
\boxed{
h_{gđ}
=
h_z
\left(
\sqrt{1-\frac{m_\lambda}{m_\theta}}
\right)
}
$$

### Case 5 — Cọc đóng trên mái dốc gần đỉnh mái dốc, lực $P$ hướng vào phía bờ

Theo công thức (3.8), trước hết xác định:

$$
\boxed{
Z=
\frac{\sin\varphi\sin(\varphi+\theta_p)}
{\cos\theta_p}
}
$$

Sau đó sử dụng $Z$ để xác định các đại lượng liên quan theo trình tự của nguồn.

---

## 1.3. Hệ số $m_\theta$

Theo công thức (3.4):

$$
\boxed{
m_\theta
=
\lambda_{bđ}-\lambda_{cđ}
=
\cos^2\varphi
\left[
\frac{1}{(1-\sqrt Z)^2}
-
\frac{1}{(1+\sqrt Z)^2}
\right]
}
$$

Trong đó $m_\theta$ là hiệu số giữa các hệ số áp lực bị động và chủ động đối với tường thẳng đứng khi mặt đất nghiêng.

## 1.4. Xác định $Z$ và $\theta_p$

Theo công thức (3.5):

$$
\boxed{
Z=
\frac{\sin\varphi\sin(\varphi-\theta_p)}
{\cos\theta_p}
}
$$

Theo công thức (3.6):

$$
\boxed{
\theta_p=\theta\cos\varphi
}
$$

Trong đó:

- $\theta$ — góc nghiêng của mái dốc;
- $\varphi$ — góc ma sát trong của đất.

Đối với Case 1/2/4, cần xác định đúng hướng tác dụng của $P$ và cấu hình mái dốc trước khi chọn công thức tương ứng. Không được dùng một công thức $h_{gđ}$ duy nhất cho mọi trường hợp.

---

## 1.5. Xác định độ sâu $h_z$ theo điều kiện liên kết cọc–bệ

Ảnh nguồn tiếp tục cho hai trường hợp liên kết:

### Trường hợp liên kết khớp

Theo công thức (3.9):

$$
\boxed{
h_z=h'_z+\Delta h_z
}
$$

### Trường hợp ngàm tuyệt đối cứng

Theo công thức (3.10):

$$
\boxed{
h_z=0,82h'_z+\Delta h_z
}
$$

Trong đó $h'_z$ là độ sâu điểm ngàm giả định xác định theo công thức (3.11).

Theo công thức (3.11):

$$
\boxed{
h'_z=
\sqrt{
\frac{2k_n n_c n m_d P}
{\gamma^{tc}m_\lambda Dm_n}
+
C_0^2-C_0
}
}
$$

**Lưu ý:** các chỉ số trên tử và mẫu được giữ theo ký hiệu thể hiện trong ảnh nguồn. Khi đưa vào bản tính số, cần đối chiếu lại đúng ký hiệu font/chỉ số của tài liệu gốc nếu cần lập trình tự động.

Nguồn cho:

$$
\Delta h_z=0,8m
$$

trong trường hợp ở đáy (trên mái dốc) không có lớp đá dăm và đất trên mặt là đất tơi hoặc đất bị bào xói.

---

## 1.6. Các hệ số trong công thức (3.11)

### Hệ số đầm bảo $k_n$

Nguồn quy định:

- công trình cấp I: $k_n=1,25$;
- công trình cấp II: $k_n=1,20$;
- công trình cấp III: $k_n=1,15$;
- công trình cấp IV: $k_n=1,10$.

### Hệ số tổ hợp tải trọng $n_c$

- tổ hợp cơ bản: $n_c=1,0$;
- tổ hợp đặc biệt: $n_c=0,9$;
- tổ hợp tải trọng trong giai đoạn thi công: $n_c=0,95$.

### Hệ số vượt tải

Đối với công trình bến cảng biển:

$$
n=1,25
$$

### Hệ số điều kiện làm việc phụ

$$
m_d=1,15
$$

### Lực ngang

$P$ — lực ngang tác động lên cọc.

### Trọng lượng riêng của đất

$\gamma^{tc}$ — dung trọng của đất.

---

## 1.7. Hệ số $m_\lambda$

Theo công thức (3.12):

$$
\boxed{
m_\lambda
=
\lambda_b-\lambda_c
=
\tan^2(45^\circ+0,5\varphi)
-
\tan^2(45^\circ-0,5\varphi)
}
$$

## 1.8. Hệ số $m_n$

Theo công thức (3.13):

$$
\boxed{
m_n
=
1+
0,0417
\left[
\frac{8h_z^3-(2h_z+D-L)^3}
{Dh_z^2}
\right]
}
$$

Trong trường hợp:

$$
L>2h_z+D
$$

nguồn cho công thức (3.14):

$$
\boxed{
m_n=1+\frac{h_z}{3D}
}
$$

Trong đó:

- $L$ — khoảng cách từ tim đến tim cọc theo hướng dọc;
- $D$ — đường kính ngoài của cọc ống hoặc cạnh cọc chữ nhật theo hướng vuông góc với phương tác dụng của lực.

## 1.9. Hệ số $C_0$

Theo công thức (3.15):

$$
\boxed{
C_0=\frac{C}{m_n\gamma^{tc}\tan\varphi}
}
$$

Trong đó:

- $\varphi$ — góc ma sát trong của đất;
- $C$ — lực dính đơn vị của đất nền.

---

## 1.10. Bảng cập nhật trạng thái M1

| Phương pháp | Công thức đã xác minh | Trạng thái |
|---|---|---|
| **M1 — 22TCN 207-92** | (3.1)–(3.8) cho $l$, $h_{gđ}$, $m_\theta$, $Z$, $\theta_p$; (3.9)–(3.15) cho $h_z$ và các hệ số liên quan | **ĐÃ XÁC MINH TỪ ẢNH GỐC** |

### Các công thức quan trọng nhất để tính $h_{gđ}$

**Case 1:**

$$
h_{gđ}
=
h_z
\left(
\sqrt{\frac{m_\lambda}{m_\theta}}-1
\right)
$$

**Case 2:**

$$
h_{gđ}
=
0,5h_z
\left(
\sqrt{\frac{m_\lambda}{m_\theta}}-1
\right)
$$

**Case 4:**

$$
h_{gđ}
=
h_z
\sqrt{1-\frac{m_\lambda}{m_\theta}}
$$

**Case 5:**

$$
Z=
\frac{\sin\varphi\sin(\varphi+\theta_p)}
{\cos\theta_p}
$$

với:

$$
\theta_p=\theta\cos\varphi
$$

Đây chính là phần trước đây còn thiếu và là phần cần bổ sung vào mô hình tính M1.


# 2. M2 — 20TCN21-86; TCXD 205-1998

## 2.1. Chiều dài tính toán

Theo công thức (3.22a):

$$
\boxed{
l_{tt}=l_0+\frac{2}{\alpha_{bd}}
}
$$

**Kết luận:** hệ số **2** là đúng.

## 2.2. Hệ số biến dạng

Theo công thức (3.23a):

$$
\boxed{
\alpha_{bd}
=
\sqrt[5]{\frac{K b_c}{E_b I}}
}
$$

Trong công thức này:

- $K$ — hệ số tỷ lệ, t/m²;
- $b_c$ — chiều rộng quy ước của cọc, m;
- $E_b$ — mô đun đàn hồi ban đầu của bê tông cọc khi nén và kéo, t/m²;
- $I$ — mô men quán tính tiết diện ngang của cọc, m⁴.

### Kết luận quan trọng

**M2 không có $\gamma_c$ trong công thức (3.23a).**

Do đó không được dùng dạng:

$$
\sqrt[5]{\frac{K b_c}{\gamma_c E_b I}}
$$

cho M2.

## 2.3. Trường hợp đặc biệt

Nguồn cho điều kiện:

$$
\frac{2}{\alpha_{bd}}>l
$$

thì lấy:

$$
\boxed{
l_{tt}=l_0+l
}
$$

Trong đó $l$ là độ sâu hạ cọc nhồi, cọc ống hoặc cọc trụ.

## 2.4. Các tham số hình học theo ảnh gốc

Chiều rộng quy ước của cọc $b_c$ được lấy:

- Khi $d\geq0,8\,m$:

$$
b_c=d+1,0
$$

- Khi $d<0,8\,m$:

$$
b_c=1,5d+0,5
$$

Trong đó $d$ là đường kính đối với cọc ống hoặc cạnh đối với cọc lăng trụ.

## 2.5. Hệ số K

Nguồn cung cấp Bảng 3.5a — hệ số tỷ lệ $K$ theo 20TCN21-86; TCXD 205-1998.

Đơn vị:

$$
K:\;t/m^4
$$

Bảng chia theo loại đất và trạng thái đất, đồng thời phân biệt:

- Đóng;
- Nhồi, cọc ống và cọc chống.

Các khoảng giá trị phải được lấy đúng theo Bảng 3.5a của nguồn gốc khi tính toán.

---

# 3. M3 — TCVN 10304:2014

## 3.1. Chiều dài tính toán

Theo công thức (3.22b):

$$
\boxed{
l_u=l_0+\frac{2}{\alpha_e}
}
$$

**Kết luận:** hệ số **2** tiếp tục được xác nhận là đúng.

## 3.2. Hệ số biến dạng

Theo công thức (3.23b), ảnh thể hiện:

$$
\boxed{
\alpha_{bd}
=
\sqrt[5]{\frac{k b_p}{\gamma_c E I}}
}
$$

### Lưu ý về ký hiệu

Có một **bất nhất ký hiệu trong chính nguồn ảnh**:

- ngay trong phần mô tả, nguồn gọi hệ số biến dạng là $\alpha_e$;
- nhưng công thức (3.23b) lại in ký hiệu $\alpha_{bd}$.

Không nên tự sửa bất nhất này trong bản đối chiếu. Khi đưa vào bài báo cần thống nhất một ký hiệu và ghi chú rằng ký hiệu được chuẩn hóa từ nguồn.

## 3.3. Hệ số điều kiện làm việc

Nguồn ghi:

$$
\gamma_c=3
$$

đối với **cọc độc lập**.

Do đó, với trường hợp cọc độc lập, công thức tính toán có thể viết rõ:

$$
\boxed{
\alpha_{bd}
=
\sqrt[5]{\frac{k b_p}{3EI}}
}
$$

## 3.4. Chiều rộng quy ước

Theo nguồn:

- nếu đường kính thân cọc tối thiểu $0,8\,m$:

$$
b_p=d+1
$$

- các trường hợp còn lại:

$$
b_p=1,5d+0,5
$$

Trong đó $d$ là đường kính ngoài của cọc tròn hoặc cạnh của cọc vuông/chữ nhật theo mặt phẳng vuông góc với hướng tác dụng của lực.

## 3.5. Hệ số tỷ lệ k

Nguồn cung cấp Bảng 3.5b — hệ số tỷ lệ $k$ theo TCVN 10304:2014.

Đơn vị:

$$
k:\;kN/m^4
$$

Các khoảng giá trị trong ảnh:

| Nhóm đất | Hệ số tỷ lệ $k$ |
|---|---:|
| Cát to; sét và sét pha cứng | 18.000–30.000 |
| Cát hạt nhỏ, cát hạt vừa; cát pha cứng; sét, sét pha dẻo cứng và nửa cứng | 12.000–18.000 |
| Cát bụi; cát pha dẻo; sét và sét pha dẻo mềm | 7.000–12.000 |
| Sét và sét pha dẻo chảy | 4.000–7.000 |
| Cát sạn; đất hạt lớn lẫn cát | 50.000–100.000 |

---

# 4. M4 — Tiêu chuẩn Nga

## 4.1. Chiều dài tính toán

Theo công thức (3.24):

$$
\boxed{
l_{tt}=l_0+\frac{2}{l_\alpha}
}
$$

**Kết luận:** hệ số **2** là đúng.

## 4.2. Hệ số biến dạng

Theo công thức (3.25):

$$
\boxed{
l_\alpha
=
\sqrt[5]{\frac{K B_p}{\gamma_c EI}}
}
$$

Trong đó:

- $l_\alpha$ — hệ số biến dạng của nền tương tác với cọc, t/m;
- $K$ — hệ số tỷ lệ phụ thuộc loại đất;
- $E$ — mô đun đàn hồi ban đầu của bê tông cọc khi nén và kéo, t/m²;
- $I$ — mô men quán tính tiết diện ngang của cọc, m⁴;
- $\gamma_c$ — hệ số xét đến điều kiện làm việc của cọc.

Nguồn cho ví dụ:

$$
\gamma_c=3,0
$$

đối với cọc đóng vào nền san hô.

## 4.3. Kết luận M4

M4 có cấu trúc tương tự M3 ở hai điểm:

1. chiều dài tính toán có hệ số 2;
2. hệ số biến dạng có $\gamma_c$ trong mẫu số.

Tuy nhiên, **không nên đồng nhất M4 với M3 về ký hiệu và đơn vị**, vì nguồn sử dụng hệ ký hiệu riêng.

---

# 5. M5 — Budin A.Ya.; Demina G.A

## 5.1. Chiều dài tính toán

Theo công thức (3.26):

$$
\boxed{
l_{tt}=l_0+l_1
}
$$

Khác với M2, M3 và M4, công thức này **không dùng trực tiếp dạng $2/\alpha$**.

## 5.2. Chiều sâu tính toán $l_1$

Theo công thức (3.27):

$$
\boxed{
l_1=
\sqrt[4]{\frac{\beta EI}{k_g d}}
}
$$

Trong đó:

- $l_1$ — chiều sâu tính từ mặt đất tới điểm ngàm;
- $k_g$ — hệ số tỷ lệ phụ thuộc điều kiện địa chất, t/m⁴;
- $d$ — đường kính đối với cọc ống hoặc cạnh cọc đối với cọc lăng trụ, m;
- $E$ — mô đun đàn hồi ban đầu của bê tông cọc khi nén và kéo, t/m²;
- $I$ — mô men quán tính tiết diện ngang của cọc, m⁴;
- $\beta$ — hệ số phụ thuộc tỷ số $L'/l$.

## 5.3. Xác định β

Nguồn ghi:

- $L'$ — chiều cao tự do của cọc;
- $l$ — chiều sâu cọc trong đất;
- $\beta$ được tra trên đồ thị;
- giá trị $\beta$ trong khoảng:

$$
\beta=30\div120
$$

- với $L'=0$:

$$
\beta=140
$$

### Kết luận

M5 **đã được xác minh đầy đủ**. Không cần giữ mô tả cũ rằng M5 “chưa có công thức đóng cho $l_1$”.

Công thức chính thức cần dùng là:

$$
\boxed{
l_1=
\sqrt[4]{\frac{\beta EI}{k_g d}}
}
$$

---

# 6. M6 — Tiêu chuẩn Nhật Bản TCNB 2002

## 6.1. Hệ số β

Theo công thức (3.28):

$$
\boxed{
\beta=
\sqrt[4]{\frac{K_hD}{4EI}}
}
$$

Đơn vị của $\beta$:

$$
cm^{-1}
$$

**Kết luận:** hệ số **4** dưới dấu căn là **đúng**.

## 6.2. Các đại lượng

Theo nguồn:

- $K_h$ — hệ số phản lực ngang của nền, N/cm²;
- $K_n=1,5N$ (N/cm³);
- $D$ — đường kính hoặc bề rộng cọc, cm;
- $EI$ — độ cứng chống uốn của cọc, N·cm²;
- $N$ — giá trị trung bình của nền đất đến độ sâu $1/\beta$.

## 6.3. Chiều dài tính toán

Theo công thức (3.29):

$$
\boxed{
l_{tt}=l_0+\frac{1}{\beta}
}
$$

M6 **không dùng hệ số 2** như M2–M4.

---

# 8. Bảng tổng hợp M1–M6 — BẢN CHỐT

| PP | Tiêu chuẩn / nguồn | Công thức chính xác định chiều dài/điểm ngàm | Đặc trưng chính |
|---|---|---|---|
| **M1** | 22TCN 207-92 | $l=H_0\pm h_{gđ}+h_z$; $h_{gđ}$ phụ thuộc Case | Xác định $h_{gđ}$ theo hình học mái dốc và hướng lực; $h_z$ phụ thuộc liên kết cọc–bệ |
| **M2** | 20TCN21-86; TCXD 205-1998 | $l_{tt}=l_0+2/\alpha_{bd}$ | $\alpha_{bd}=\sqrt[5]{K b_c/(E_bI)}$; **không có $\gamma_c$** |
| **M3** | TCVN 10304:2014 | $l_u=l_0+2/\alpha_{bd}$ | $\alpha_{bd}=\sqrt[5]{k b_p/(\gamma_cEI)}$; **có $\gamma_c$** |
| **M4** | Tiêu chuẩn Nga | $l_{tt}=l_0+2/l_\alpha$ | $l_\alpha=\sqrt[5]{K B_p/(\gamma_cEI)}$; **có $\gamma_c$** |
| **M5** | Budin–Demina | $l_{tt}=l_0+l_1$ | $l_1=\sqrt[4]{\beta EI/(k_gd)}$; $\beta$ tra theo $L'/l$ |
| **M6** | Nhật Bản TCNB 2002 | $l_{tt}=l_0+1/\beta$ | $\beta=\sqrt[4]{K_hD/(4EI)}$ |


---

# 9. Nhận xét khoa học quan trọng cho Paper 1

## 8.1. Không được gộp M2–M6 thành một công thức chung

Sau khi đối chiếu ảnh gốc, có thể thấy năm phương pháp **không hoàn toàn tương đương về mặt biểu thức**.

### Nhóm 1 — dạng $l_0+2/\text{hệ số biến dạng}$

Gồm:

- M2;
- M3;
- M4.

Tuy nhiên, ngay cả trong nhóm này các ký hiệu, đơn vị và hệ số điều kiện làm việc khác nhau.

### Nhóm 2 — xác định trực tiếp chiều sâu điểm ngàm

M5:

$$
l_{tt}=l_0+l_1
$$

với $l_1$ được tính từ công thức bậc bốn và $\beta$ tra theo tỷ số hình học.

### Nhóm 3 — phương pháp Nhật Bản

M6:

$$
l_{tt}=l_0+\frac{1}{\beta}
$$

với:

$$
\beta=\sqrt[4]{\frac{K_hD}{4EI}}
$$

---

## 8.2. Điểm khác biệt quan trọng nhất giữa M2 và M3

M2:

$$
\alpha_{bd}
=
\sqrt[5]{\frac{K b_c}{E_bI}}
$$

M3:

$$
\alpha_e
=
\sqrt[5]{\frac{k b_p}{\gamma_cEI}}
$$

với $\gamma_c=3$ cho cọc độc lập theo nguồn.

Do đó, **không được lấy công thức M3 rồi áp dụng ngược cho M2**.

---

## 8.3. M5 có thể tạo ra sự khác biệt đáng kể

M5 không xác định điểm ngàm bằng $2/\alpha$ mà bằng:

$$
l_1=
\sqrt[4]{\frac{\beta EI}{k_gd}}
$$

và:

$$
l_{tt}=l_0+l_1
$$

Đặc biệt $\beta$ phụ thuộc vào tỷ số $L'/l$ và được tra đồ thị.

Đây là một cơ chế xác định điểm ngàm khác về cấu trúc so với M2–M4.

---

## 8.4. M6 có hệ số 4 và hệ số cộng 1

M6 sử dụng:

$$
\beta=
\sqrt[4]{\frac{K_hD}{4EI}}
$$

sau đó:

$$
l_{tt}=l_0+\frac{1}{\beta}
$$

Vì vậy cần giữ nguyên **cả hai đặc trưng**:

- số **4** trong công thức xác định $\beta$;
- số **1** trong $l_0+1/\beta$.

Không được chuyển M6 về dạng $l_0+2/\beta$.

---

# 10. Cập nhật đối với draft Paper 1

### M1

**ĐÃ CHỐT**

M1 phải được bổ sung vào phần phương pháp với chuỗi công thức:

$$
l=H_0\pm h_{gđ}+h_z
$$

Trong đó $h_{gđ}$ được xác định theo đúng Case của hình học mái dốc và hướng lực:

- Case 1: công thức (3.2);
- Case 2: công thức (3.3);
- Case 4: công thức (3.7);
- Case 5: công thức (3.8), kết hợp (3.5)–(3.6).

Độ sâu $h_z$ tiếp tục được xác định theo điều kiện liên kết cọc–bệ bằng (3.9)–(3.11).

Các nội dung tạm đánh dấu “chưa xác minh” trong bản draft trước đây có thể được xử lý như sau:

### M2

**ĐÃ CHỐT**

$$
l_{tt}=l_0+\frac{2}{\alpha_{bd}}
$$

$$
\alpha_{bd}
=
\sqrt[5]{\frac{K b_c}{E_bI}}
$$

Không có $\gamma_c$.

### M3

**ĐÃ CHỐT**

$$
l_u=l_0+\frac{2}{\alpha_{bd}}
$$

và:

$$
\alpha_{bd}
=
\sqrt[5]{\frac{k b_p}{\gamma_cEI}}
$$

với $\gamma_c=3$ cho cọc độc lập.

**Ký hiệu chuẩn sử dụng trong Paper 1: $\alpha_{bd}$. Không thay bằng $\alpha_e$.**

### M4

**ĐÃ CHỐT**

$$
l_{tt}=l_0+\frac{2}{l_\alpha}
$$

$$
l_\alpha
=
\sqrt[5]{\frac{KB_p}{\gamma_cEI}}
$$

### M5

**ĐÃ CHỐT**

$$
l_{tt}=l_0+l_1
$$

$$
l_1=
\sqrt[4]{\frac{\beta EI}{k_gd}}
$$

$\beta$ tra theo đồ thị phụ thuộc $L'/l$; $L'=0$ thì $\beta=140$.

### M6

**ĐÃ CHỐT**

$$
\beta=
\sqrt[4]{\frac{K_hD}{4EI}}
$$

$$
l_{tt}=l_0+\frac{1}{\beta}
$$

---

# 11. Kết luận cuối cùng

Sau khi đối chiếu toàn bộ ảnh được cung cấp, **M1–M6 đã có đủ công thức chính để cập nhật Paper 1**.

Các điểm cần đặc biệt khóa:

1. **M1:** phải tính $h_{gđ}$ theo đúng Case của mái dốc và hướng lực trước khi xác định $l$.
2. **M2:** không có $\gamma_c$.
3. **M2, M3, M4:** đều có hệ số 2 trong biểu thức chiều dài tính toán.
4. **M3 và M4:** có $\gamma_c$ trong công thức hệ số biến dạng.
5. **M5:** dùng $l_{tt}=l_0+l_1$, với $l_1$ là căn bậc 4; $\beta$ tra theo tỷ số $L'/l$.
6. **M6:** dùng $\beta=\sqrt[4]{K_hD/(4EI)}$ và $l_{tt}=l_0+1/\beta$.
7. **Không được tự đồng nhất ký hiệu giữa các tiêu chuẩn** nếu chưa chuẩn hóa trong phần phương pháp của bài báo.
8. **Không được tự thay đổi đơn vị** của các hệ số $K$, $k$, $k_g$, $K_h$; khi tính số phải đưa về hệ đơn vị nhất quán trước khi thế vào công thức.

## Trạng thái

**M2–M6: ĐÃ ĐỐI CHIẾU ẢNH GỐC — CÓ THỂ DÙNG ĐỂ CẬP NHẬT DRAFT PAPER 1.**
