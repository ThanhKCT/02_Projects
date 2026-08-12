# MATH FOUNDATION ROADMAP
## Nền tảng toán học cho nghiên cứu Metaheuristic → SFOA → MOO → Structural Optimization

**Dự án:** Phát triển thuật toán metaheuristic cho tối ưu đa mục tiêu kết cấu cảng biển  
**Mục tiêu:** Học lại toàn bộ nền tảng toán học từ đầu, có định hướng trực tiếp tới nghiên cứu SFOA/MOSFOA và A/B-MOSFOA.

---

# 0. CÁCH SỬ DỤNG

Chuỗi học:

```text
Toán cơ sở
↓
Đại số tuyến tính
↓
Giải tích
↓
Xác suất + Thống kê
↓
Không gian tìm kiếm
↓
Tối ưu hóa toán học
↓
Tối ưu có ràng buộc
↓
Tối ưu rời rạc
↓
Tối ưu phi lồi
↓
Tối ưu ngẫu nhiên
↓
Metaheuristic
↓
SFOA
↓
Multi-objective Optimization
↓
MOSFOA
↓
Structural Optimization
↓
FEM / SAP2000
↓
A/B-MOSFOA
```

Mỗi chủ đề phải trả lời được:

1. Nó là gì?
2. Công thức toán học là gì?
3. Trực giác hình học/vật lý là gì?
4. Nó xuất hiện ở đâu trong metaheuristic?
5. Nó liên quan thế nào tới bài toán kết cấu?

---

# PHẦN I — ĐẠI SỐ CƠ SỞ

# 1. SỐ, TẬP HỢP VÀ KHOẢNG

Phân biệt:

\[
\mathbb{N},\mathbb{Z},\mathbb{Q},\mathbb{R}
\]

Trong optimization:

- \(\mathbb{R}\): biến liên tục;
- \(\mathbb{Z}\): biến nguyên;
- tập hữu hạn: biến rời rạc.

Ví dụ:

\[
x\in[0,10]
\]

là biến liên tục.

\[
x\in\{1,2,\ldots,10\}
\]

là biến rời rạc.

---

# 2. VECTOR

\[
\mathbf{x}
=
[x_1,x_2,\ldots,x_n]^T
\]

Trong tối ưu, vector này có thể là một thiết kế kết cấu:

\[
\mathbf{x}=[I_1,I_2,I_3,I_4]
\]

## Tích vô hướng

\[
\mathbf{x}^T\mathbf{y}
=
\sum_i x_i y_i
\]

## Chuẩn

\[
\|\mathbf{x}\|_2
=
\sqrt{\sum_i x_i^2}
\]

\[
\|\mathbf{x}\|_1
=
\sum_i|x_i|
\]

\[
\|\mathbf{x}\|_\infty
=
\max_i|x_i|
\]

## Khoảng cách

\[
d(\mathbf{x},\mathbf{y})
=
\|\mathbf{x}-\mathbf{y}\|_2
\]

Trong metaheuristic, khoảng cách liên quan trực tiếp tới diversity.

---

# 3. MA TRẬN

Cần nắm:

- kích thước;
- cộng;
- nhân;
- transpose;
- inverse;
- determinant;
- rank.

Hệ phương trình:

\[
A\mathbf{x}=\mathbf{b}
\]

Nếu \(A\) khả nghịch:

\[
\mathbf{x}=A^{-1}\mathbf{b}
\]

Trong kết cấu:

\[
oxed{\mathbf K\mathbf u=\mathbf F}
\]

với \(\mathbf K\) là ma trận độ cứng, \(\mathbf u\) là chuyển vị và \(\mathbf F\) là tải.

---

# 4. EIGENVALUE VÀ EIGENVECTOR

\[
A\mathbf v=\lambda\mathbf v
\]

Cần hiểu ý nghĩa của:

- eigenvalue;
- eigenvector;
- eigenproblem.

Ứng dụng quan trọng trong động lực học kết cấu: mode shape và natural frequency.

---

# PHẦN II — GIẢI TÍCH

# 5. HÀM MỘT BIẾN

\[
y=f(x)
\]

Cần hiểu:

- miền xác định;
- miền giá trị;
- liên tục;
- đơn điệu;
- cực trị.

---

# 6. ĐẠO HÀM

\[
f'(x)=rac{df}{dx}
\]

Điều kiện:

\[
f'(x)=0
\]

thường xuất hiện tại điểm cực trị, nhưng không tự động đồng nghĩa với global optimum.

---

# 7. ĐẠO HÀM RIÊNG

Với:

\[
f(x_1,x_2)
\]

có:

\[
rac{\partial f}{\partial x_1},
\qquad
rac{\partial f}{\partial x_2}
\]

Mỗi đạo hàm thể hiện độ nhạy của objective theo một biến.

---

# 8. GRADIENT

\[

abla f(\mathbf{x})
=
egin{bmatrix}
rac{\partial f}{\partial x_1}\
dots\
rac{\partial f}{\partial x_n}
\end{bmatrix}
\]

Gradient chỉ hướng tăng nhanh nhất của hàm trong điều kiện phù hợp.

Do đó:

\[
-
abla f
\]

là hướng giảm nhanh nhất.

Phải hiểu gradient để phân biệt gradient-based optimization với metaheuristic.

---

# 9. JACOBIAN

Với:

\[
\mathbf F(\mathbf x)
=
[f_1(\mathbf x),...,f_m(\mathbf x)]^T
\]

Jacobian:

\[
J=
egin{bmatrix}
rac{\partial f_1}{\partial x_1}&\cdots&rac{\partial f_1}{\partial x_n}\
dots&&dots\
rac{\partial f_m}{\partial x_1}&\cdots&rac{\partial f_m}{\partial x_n}
\end{bmatrix}
\]

Liên quan tới sensitivity, vector objectives và constraints.

---

# 10. HESSIAN

\[
H_f(\mathbf{x})=
abla^2 f(\mathbf{x})
\]

Hessian chứa đạo hàm cấp hai và giúp phân tích curvature, local minimum, local maximum và saddle point.

---

# 11. TAYLOR

\[
f(\mathbf{x}+\Delta\mathbf{x})
pprox
f(\mathbf{x})+
abla f^T\Delta\mathbf{x}
\]

Cần hiểu Taylor để nắm:

- local approximation;
- gradient;
- sensitivity;
- step.

---

# PHẦN III — XÁC SUẤT VÀ THỐNG KÊ

# 12. BIẾN NGẪU NHIÊN

Trong metaheuristic thường gặp:

\[
r\sim U(0,1)
\]

Cần hiểu:

- random variable;
- probability distribution;
- sampling;
- stochasticity.

---

# 13. KỲ VỌNG, PHƯƠNG SAI

\[
E[X]
\]

\[
Var(X)=E[(X-E[X])^2]
\]

\[
\sigma=\sqrt{Var(X)}
\]

Với nhiều lần chạy thuật toán, đây là cơ sở để đánh giá ổn định.

---

# 14. THỐNG KÊ MẪU

Với \(n\) lần chạy:

\[
ar{x}=rac{1}{n}\sum_{i=1}^{n}x_i
\]

\[
s^2=
rac{1}{n-1}
\sum_{i=1}^{n}(x_i-ar{x})^2
\]

Cần biết:

- Best;
- Mean;
- Median;
- Std;
- Worst.

---

# 15. PHÂN PHỐI

Cần nhận biết:

- Uniform;
- Normal/Gaussian;
- Bernoulli;
- Binomial;
- khái niệm phân phối đuôi dài.

Không cần học xác suất thuần túy quá sâu nếu không phục vụ nghiên cứu.

---

# PHẦN IV — KHÔNG GIAN TÌM KIẾM

# 16. DESIGN SPACE

\[
\mathbf{x}=[x_1,\ldots,x_n]
\]

với:

\[
\mathbf{x}\in\Omega
\]

Ví dụ:

\[
\Omega=[L_1,U_1]	imes\cdots	imes[L_n,U_n]
\]

---

# 17. CONTINUOUS SPACE

\[
x_i\in[L_i,U_i]
\]

Có vô hạn giá trị.

---

# 18. DISCRETE SPACE

\[
x_i\in\{x_{i1},x_{i2},...,x_{ik}\}
\]

Ví dụ:

\[
x_i\in\{I300,I350,I400,I450\}
\]

Đây là dạng rất quan trọng trong tối ưu kết cấu.

---

# 19. COMBINATORIAL SPACE

Nếu có \(n\) biến, mỗi biến có \(k\) lựa chọn:

\[
|\Omega|=k^n
\]

Ví dụ:

\[
20^{10}=10,240,000,000,000
\]

Điều này cho thấy vì sao duyệt toàn bộ không gian thường không khả thi.

---

# PHẦN V — TỐI ƯU HÓA TOÁN HỌC

# 20. FORMULATION

\[
oxed{\min_{\mathbf x} f(\mathbf x)}
\]

subject to:

\[
g_i(\mathbf x)\le0
\]

\[
h_j(\mathbf x)=0
\]

\[
\mathbf x_L\le\mathbf x\le\mathbf x_U
\]

Phải hiểu:

- decision variable;
- objective;
- constraint;
- feasible region;
- optimum.

---

# 21. FEASIBLE REGION

\[
\Omega_f=
\{\mathbf{x}\in\Omega:
g_i(\mathbf{x})\le0,\,
h_j(\mathbf{x})=0\}
\]

Mục tiêu constrained optimization là tìm:

\[
\mathbf{x}^*\in\Omega_f
\]

---

# 22. LOCAL VÀ GLOBAL OPTIMUM

Local optimum: tốt nhất trong một vùng lân cận.

Global optimum: tốt nhất trên toàn miền khả thi.

Metaheuristic hướng tới nghiệm gần global optimum mà không cần duyệt toàn bộ không gian.

---

# 23. CONVEX VÀ NON-CONVEX

Cần hiểu:

- convex set;
- convex function;
- convex optimization;
- non-convex optimization.

Bài toán kết cấu thực thường có đặc điểm:

- phi tuyến;
- rời rạc;
- không trơn;
- nhiều cực trị;
- constraint phức tạp;
- black-box FEA.

---

# 24. OPTIMIZATION LANDSCAPE

Có thể hình dung:

```text
Objective
   ↑
   |       /\      /   |  /\  /  \____/     |_/  \/            \__
   +----------------------→ Design variable
```

Các cực trị cục bộ tạo khó khăn cho optimization.

---

# PHẦN VI — TỐI ƯU KHÔNG RÀNG BUỘC

# 25. UNCONSTRAINED OPTIMIZATION

\[
\min_{\mathbf{x}}f(\mathbf{x})
\]

---

# 26. GRADIENT DESCENT

\[
\mathbf{x}_{t+1}
=
\mathbf{x}_t-lpha
abla f(\mathbf{x}_t)
\]

Trong đó \(lpha\) là step size.

Mục tiêu học: hiểu nguyên lý gradient-based search.

---

# 27. NEWTON METHOD

Dạng khái niệm:

\[
\mathbf{x}_{t+1}
=
\mathbf{x}_t-H^{-1}
abla f
\]

Dùng curvature thông qua Hessian.

---

# 28. GRADIENT-BASED VS METAHEURISTIC

| Gradient-based | Metaheuristic |
|---|---|
| Thường dùng đạo hàm | Không nhất thiết cần đạo hàm |
| Local information mạnh | Population/global search |
| Phù hợp hàm trơn | Có thể phù hợp black-box |
| Có thể nhanh | Có thể cần nhiều evaluation |
| Khó với discrete | Có thể xử lý discrete |
| Có thể gặp local optimum | Có cơ chế exploration |

Không được hiểu rằng metaheuristic luôn tốt hơn; công cụ phải phù hợp bài toán.

---

# PHẦN VII — TỐI ƯU CÓ RÀNG BUỘC

# 29. INEQUALITY

\[
g_i(\mathbf{x})\le0
\]

Ví dụ:

\[
rac{\sigma}{f_y}-1\le0
\]

---

# 30. EQUALITY

\[
h_j(\mathbf{x})=0
\]

---

# 31. BOUND

\[
L_i\le x_i\le U_i
\]

---

# 32. LAGRANGE

Với:

\[
\min f(x)
\]

subject to:

\[
g(x)=0
\]

Lagrangian:

\[
\mathcal L(x,\lambda)
=
f(x)+\lambda g(x)
\]

Điều kiện:

\[

abla_x\mathcal L=0
\]

---

# 33. KKT

Cần hiểu bốn nhóm:

- stationarity;
- primal feasibility;
- dual feasibility;
- complementary slackness.

Không học thuộc máy móc; mục tiêu là hiểu constrained optimization theory.

---

# 34. PENALTY

\[
F(\mathbf{x})
=
f(\mathbf{x})+\lambda P(\mathbf{x})
\]

Ví dụ:

\[
P(\mathbf{x})
=
\sum_i\max(0,g_i(\mathbf{x}))^2
\]

Feasible:

\[
P=0
\]

Infeasible:

\[
P>0
\]

---

# 35. NHƯỢC ĐIỂM PENALTY

\(\lambda\) quá nhỏ:

> nghiệm vi phạm vẫn có thể hấp dẫn.

\(\lambda\) quá lớn:

> search bị penalty chi phối.

Đây là nền tảng để nghiên cứu constraint-aware search.

---

# PHẦN VIII — TỐI ƯU RỜI RẠC

# 36. CONTINUOUS VS DISCRETE

Continuous:

\[
x\in[0,1]
\]

Discrete:

\[
x\in\{0,0.1,\ldots,1\}
\]

Structural:

\[
x\in\{I300,I350,I400,\ldots\}
\]

---

# 37. MAPPING

Nếu thuật toán sinh:

\[
x=3.72
\]

nhưng cần:

\[
x\in\{1,2,3,4,5\}
\]

có thể dùng:

\[
x_d=round(x)
\]

Nhưng rounding không phải lúc nào cũng là cách tốt nhất.

---

# 38. REPAIR

Nếu:

\[
x
otin\Omega
\]

thì:

\[
xightarrow Repair(x)
\]

Repair đưa nghiệm về miền hợp lệ.

---

# PHẦN IX — METAHEURISTIC

# 39. METAHEURISTIC

Metaheuristic là nhóm phương pháp tìm nghiệm chất lượng cao bằng các chiến lược heuristic/stochastic cấp cao.

Không đảm bảo luôn tìm global optimum.

Mục tiêu:

> nghiệm tốt với chi phí tính toán chấp nhận được.

---

# 40. POPULATION

\[
P^t=
\{\mathbf{x}_1^t,\ldots,\mathbf{x}_N^t\}
\]

Mỗi cá thể có:

- position;
- objective;
- constraint status;
- evaluation information.

---

# 41. ITERATION

\[
t=1,2,\ldots,T
\]

Một vòng:

```text
Population
 ↓
Evaluate
 ↓
Select / Update
 ↓
New population
```

---

# 42. EXPLORATION

Khảo sát các vùng khác nhau.

Diversity cao thường giúp tránh tập trung quá sớm.

---

# 43. EXPLOITATION

Khai thác vùng đang có nghiệm tốt.

Nếu quá mạnh:

```text
Convergence nhanh
 ↓
Diversity giảm
 ↓
Premature convergence
```

---

# 44. EXPLORATION–EXPLOITATION

\[
oxed{Exploration\leftrightarrow Exploitation}
\]

Đây là một vấn đề trung tâm của metaheuristic.

---

# PHẦN X — SFOA DƯỚI GÓC NHÌN TOÁN HỌC

# 45. CÁCH HỌC SFOA

Không học chỉ bằng cách nhớ công thức.

Với update tổng quát:

\[
\mathbf{x}_i^{t+1}
=
\mathbf{x}_i^t+\Delta\mathbf{x}_i^t
\]

phải phân tích:

```text
Current position
 ↓
Reference / leader
 ↓
Search direction
 ↓
Step size
 ↓
Random component
 ↓
New position
```

---

# 46. PHÂN TÍCH OPERATOR

Với từng operator SFOA, phải trả lời:

1. Nó thay đổi position thế nào?
2. Nó tạo exploration hay exploitation?
3. Có random component không?
4. Step size thay đổi thế nào?
5. Có làm mất diversity không?
6. Có gây boundary violation không?
7. Có phù hợp discrete variables không?

Đây là cách học để sau này tự phát triển biến thể.

---

# PHẦN XI — MULTI-OBJECTIVE OPTIMIZATION

# 47. SOO → MOO

Single-objective:

\[
\min f(x)
\]

Multi-objective:

\[
oxed{
\min F(x)=[f_1(x),f_2(x),...,f_m(x)]
}
\]

---

# 48. CONFLICTING OBJECTIVES

Ví dụ:

\[
f_1(x)=Weight(x)
\]

\[
f_2(x)=Displacement(x)
\]

Hai mục tiêu có thể xung đột.

---

# 49. PARETO DOMINANCE

A dominates B nếu:

\[
f_k(A)\le f_k(B)
\]

với mọi \(k\),

và:

\[
f_j(A)<f_j(B)
\]

ít nhất một \(j\).

---

# 50. PARETO OPTIMAL

Không có nghiệm khác dominate nghiệm đang xét.

Tập các nghiệm:

\[
PS
\]

là Pareto set.

Ánh xạ sang objective space:

\[
PF
\]

là Pareto front.

---

# 51. NON-DOMINATED SORTING

Population được chia:

\[
F_1,F_2,F_3,\ldots
\]

\(F_1\) chứa các nghiệm non-dominated.

---

# 52. ARCHIVE

Archive:

\[
A^t
\]

lưu nghiệm Pareto tốt.

Cần xử lý:

- update;
- removal of dominated solutions;
- archive size;
- diversity preservation.

---

# 53. DIVERSITY

Cần cả:

```text
Convergence
+
Diversity
```

Một thuật toán có thể hội tụ tốt nhưng Pareto front bị tập trung.

---

# 54. HYPERVOLUME

\[
HV
\]

đo thể tích vùng objective space được tập Pareto chiếm lĩnh so với reference point.

Cần dùng cùng reference point khi so sánh.

---

# 55. IGD

\[
IGD=
rac{1}{|P^*|}
\sum_{y\in P^*}d(y,P)
\]

Trong đó \(P^*\) là reference Pareto set.

Mục tiêu:

\[
IGDightarrow0
\]

---

# PHẦN XII — THỐNG KÊ THỰC NGHIỆM METAHEURISTIC

# 56. NHIỀU LẦN CHẠY

Vì thuật toán stochastic:

\[
Result=f(seed)
\]

nên:

\[
Run_1
e Run_2
\]

Cần nhiều independent runs.

---

# 57. METRICS

Single-objective:

- Best;
- Mean;
- Median;
- Std;
- Worst;
- Runtime.

Multi-objective:

- HV;
- IGD;
- convergence;
- diversity;
- runtime;
- robustness.

---

# 58. STATISTICAL SIGNIFICANCE

Không chỉ nhìn:

\[
Mean_A<Mean_B
\]

mà cần kiểm tra sự khác biệt có ý nghĩa thống kê không.

Có thể học:

- Wilcoxon signed-rank;
- Mann–Whitney;
- Friedman;
- post-hoc;
- effect size.

---

# PHẦN XIII — CƠ HỌC KẾT CẤU VÀ FEM

# 59. PHƯƠNG TRÌNH CƠ BẢN

\[
oxed{\mathbf K\mathbf u=\mathbf F}
\]

Từ:

\[
\mathbf K,\mathbf F
\]

tìm:

\[
\mathbf u
\]

Sau đó:

\[
\mathbf u
ightarrow
\mathbf N,\mathbf M,\mathbf V,\ldots
ightarrow
Design\ Checks
\]

---

# 60. STRUCTURAL MODEL AS A FUNCTION

Có thể xem SAP2000 như evaluator:

\[
\mathbf{x}
ightarrow
SAP2000
ightarrow
\mathbf R
\]

với:

\[
\mathbf R=
[\mathbf u,\mathbf N,\mathbf M,\mathbf V,\ldots]
\]

Sau đó:

\[
\mathbf Rightarrow f(\mathbf{x})
\]

và:

\[
\mathbf Rightarrow g_i(\mathbf{x})
\]

Đây là nền tảng của black-box structural optimization.

---

# 61. STRUCTURAL OPTIMIZATION

Ví dụ:

\[
\min_{\mathbf x}W(\mathbf x)
\]

subject to:

\[
g_i(\mathbf x)\le0
\]

\[
\mathbf x\in\Omega_d
\]

trong đó \(\Omega_d\) là discrete design space.

---

# 62. MULTI-OBJECTIVE STRUCTURAL OPTIMIZATION

Ví dụ:

\[
\min
F(\mathbf x)
=
[W(\mathbf x),D_{\max}(\mathbf x)]
\]

subject to:

\[
g_i(\mathbf x)\le0
\]

\[
\mathbf x\in\Omega_d
\]

Đây là dạng formulation gần với hướng nghiên cứu cuối cùng.

---

# PHẦN XIV — BLACK-BOX VÀ EXPENSIVE FEA

# 63. BLACK-BOX

\[
y=f(x)
\]

Ta không cần biết hoặc không có biểu thức giải tích của \(f\).

Chỉ có:

```text
Input x
 ↓
Black box
 ↓
Output y
```

SAP2000 có thể được xem là black-box evaluator trong optimization framework.

---

# 64. EXPENSIVE EVALUATION

Nếu:

\[
T_{eval}\gg0
\]

và:

\[
N_{eval}=10^4
\]

thì:

\[
T_{total}pprox N_{eval}T_{eval}
\]

Vì vậy số lần gọi FEA là một đại lượng nghiên cứu quan trọng.

---

# 65. EVALUATION CACHE

Nếu cùng \(\mathbf x\) xuất hiện nhiều lần:

\[
Cache[\mathbf x]=f(\mathbf x)
\]

có thể tránh chạy FEA lặp lại.

Đây là cơ chế kỹ thuật; chưa mặc định là novelty.

---

# PHẦN XV — CẦU NỐI TOÀN BỘ TOÁN HỌC VỚI A/B-MOSFOA

# 66. VECTOR → THIẾT KẾ

\[
\mathbf{x}=[x_1,x_2,\ldots,x_n]
\]

là design vector.

# 67. THIẾT KẾ → SAP2000

\[
\mathbf{x}ightarrow Model(\mathbf{x})
\]

# 68. SAP2000 → RESPONSE

\[
Model(\mathbf{x})ightarrow\mathbf R
\]

# 69. RESPONSE → OBJECTIVES

\[
\mathbf Rightarrow F(\mathbf x)
\]

Ví dụ:

\[
F(\mathbf x)=[Weight,Displacement]
\]

# 70. RESPONSE → CONSTRAINTS

\[
\mathbf Rightarrow g_i(\mathbf x)
\]

# 71. OBJECTIVES → PARETO

\[
F(\mathbf x)
ightarrow
Dominance
ightarrow
Archive
ightarrow
Pareto\ Front
\]

# 72. PARETO → METAHEURISTIC

```text
Population
 ↓
Evaluate
 ↓
Dominance
 ↓
Archive
 ↓
Leader / Selection
 ↓
Search
 ↓
New population
```

# 73. METAHEURISTIC → A/B-MOSFOA

A/B-MOSFOA phải trả lời:

> Làm thế nào thiết kế search mechanism tốt hơn cho structural MOO?

Một hướng nghiên cứu:

```text
Structural state
      ↓
Feasibility
      ↓
Diversity
      ↓
Convergence
      ↓
Improvement
      ↓
Adaptive control
      ↓
Search update
```

---

# PHẦN XVI — ROADMAP HỌC LẠI

| Module | Nội dung | Mức |
|---|---|---|
| M01 | Số, tập hợp, hàm cơ bản | CORE |
| M02 | Vector, ma trận | CORE |
| M03 | Giải tích một biến | CORE |
| M04 | Giải tích nhiều biến | CORE |
| M05 | Gradient, Jacobian, Hessian | CORE |
| M06 | Xác suất | CORE |
| M07 | Thống kê | CORE |
| M08 | Optimization theory | CORE |
| M09 | Constraint + KKT + Penalty | CORE |
| M10 | Discrete/Combinatorial optimization | CORE |
| M11 | Metaheuristic mathematics | RESEARCH |
| M12 | MOO + Pareto + Structural/FEM | RESEARCH |

Trình tự:

```text
M01 → M02 → M03 → M04 → M05
                         ↓
M06 → M07 → M08 → M09 → M10
                         ↓
                    M11 → M12
```

---

# PHẦN XVII — CHECKPOINT

Sau mỗi module, kiểm tra 5 cấp:

1. **Nhận biết:** biết khái niệm.
2. **Giải thích:** giải thích bằng lời.
3. **Tính toán:** giải bài đơn giản.
4. **Lập trình:** triển khai Python/MATLAB.
5. **Nghiên cứu:** hiểu ảnh hưởng tới metaheuristic.

Mục tiêu:

- CORE: tối thiểu Level 4.
- RESEARCH: hướng tới Level 5.

---

# PHẦN XVIII — BÀI TẬP TỔNG HỢP

## Bài 1 — SOO

Formulate:

\[
\min W(x)
\]

với 5 design variables, discrete sections và 3 structural constraints.

## Bài 2 — Constraint

Xây dựng:

\[
P(x)=\sum_i\max(0,g_i(x))^2
\]

và so sánh feasible/infeasible.

## Bài 3 — Pareto

Cho:

\[
A=(1,5),\quad B=(2,4),\quad C=(3,6)
\]

với tất cả mục tiêu minimize. Xác định dominance.

## Bài 4 — Population

Tạo:

\[
P=\{\mathbf x_1,\ldots,\mathbf x_{20}\}
\]

Tính pairwise distance và một chỉ báo diversity.

## Bài 5 — MOO

Cho population gồm các objective vectors. Thực hiện:

```text
Dominance
 ↓
Non-dominated sorting
 ↓
Archive
```

## Bài 6 — Structural

Xây dựng:

\[
\mathbf x
ightarrow
SAP2000
ightarrow
R
ightarrow
F(\mathbf x)
\]

và:

\[
Rightarrow g_i(\mathbf x)
\]

## Bài 7 — Research

Phân tích một operator SFOA:

- phương trình;
- random terms;
- exploration/exploitation;
- boundary;
- discrete handling;
- possible failure mode.

---

# PHẦN XIX — KIẾN THỨC PHẢI ĐẠT TRƯỚC A/B-MOSFOA

Có thể tự viết:

\[
oxed{
\min_{\mathbf x}F(\mathbf x)
}
\]

subject to:

\[
g_i(\mathbf x)\le0
\]

\[
h_j(\mathbf x)=0
\]

\[
\mathbf x\in\Omega_d
\]

và giải thích:

- \(\mathbf x\);
- \(F\);
- feasible region;
- Pareto dominance;
- archive;
- diversity;
- exploration;
- exploitation;
- constraint violation;
- FEA evaluation.

Pipeline phải hiểu được:

```text
x
 ↓
Structural model
 ↓
FEA
 ↓
Objectives + Constraints
 ↓
Pareto evaluation
 ↓
Archive
 ↓
Search update
 ↓
x_new
```

Nếu chưa giải thích được pipeline này bằng toán học thì chưa nên khóa A-MOSFOA/B-MOSFOA.

---

# PHẦN XX — CHECKLIST

## Đại số

- [ ] Số/tập hợp
- [ ] Vector
- [ ] Matrix
- [ ] Norm
- [ ] Distance
- [ ] Linear system
- [ ] Eigenvalue/eigenvector

## Giải tích

- [ ] Function
- [ ] Derivative
- [ ] Partial derivative
- [ ] Gradient
- [ ] Jacobian
- [ ] Hessian
- [ ] Taylor expansion

## Probability/Statistics

- [ ] Random variable
- [ ] Distribution
- [ ] Expectation
- [ ] Variance
- [ ] Standard deviation
- [ ] Sampling
- [ ] Statistical comparison

## Optimization

- [ ] Objective
- [ ] Decision variable
- [ ] Search space
- [ ] Feasible region
- [ ] Local optimum
- [ ] Global optimum
- [ ] Convex/non-convex
- [ ] Constraint
- [ ] Penalty
- [ ] KKT
- [ ] Discrete optimization
- [ ] Combinatorial optimization

## Metaheuristic

- [ ] Population
- [ ] Initialization
- [ ] Exploration
- [ ] Exploitation
- [ ] Search step
- [ ] Randomness
- [ ] Convergence
- [ ] Diversity
- [ ] Premature convergence
- [ ] SFOA mathematical mechanism

## MOO

- [ ] Multi-objective formulation
- [ ] Dominance
- [ ] Pareto optimality
- [ ] Pareto set
- [ ] Pareto front
- [ ] Non-dominated sorting
- [ ] Archive
- [ ] Diversity
- [ ] Hypervolume
- [ ] IGD

## Structural Optimization

- [ ] K u = F
- [ ] FEM concept
- [ ] Structural response
- [ ] Structural objective
- [ ] Structural constraint
- [ ] Discrete section
- [ ] FEA evaluation
- [ ] Black-box optimization
- [ ] Expensive evaluation
- [ ] SAP2000 optimization loop

---

# 21. ĐÍCH CUỐI CÙNG

Mục tiêu không phải là “biết nhiều công thức”.

Mục tiêu là:

> **Có thể nhìn một bài toán kỹ thuật, chuyển nó thành formulation toán học, hiểu không gian tìm kiếm và ràng buộc, lựa chọn chiến lược optimization phù hợp, phân tích cơ chế metaheuristic và tự đề xuất cải tiến có cơ sở.**

Đích cuối:

\[
oxed{
Engineering\ Problem
ightarrow
Mathematical\ Formulation
ightarrow
Optimization\ Model
ightarrow
Metaheuristic
ightarrow
MOO
ightarrow
Structural\ FEA
ightarrow
A/B	ext{-}MOSFOA
}
\]

Đây là nền tảng để chuyển từ **người sử dụng metaheuristic** sang **người phát triển thuật toán metaheuristic**.
