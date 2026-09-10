# MỤC 4 — HAI THUẬT TOÁN ĐỐI SÁNH (bản nháp, 10/09/2026)

> Viết theo khung Mục D.4 của [`DE_CUONG_BAI_BAO_MOFDA_MOSFOA_SO_SANH_THUAT_TOAN.md`](DE_CUONG_BAI_BAO_MOFDA_MOSFOA_SO_SANH_THUAT_TOAN.md), dựa trên nội dung đọc lại từ 2 bài báo GỐC (coi là đã chấp nhận đăng, đang sản xuất bài): [`02_MOFDA.docx`](02_MOFDA.docx) và [`02_MOSFOA.docx`](02_MOSFOA.docx). **Lưu ý quan trọng**: cả hai bài gốc đều có case study kỹ thuật RIÊNG, KHÁC với cầu tàu container 100.000 DWT Lạch Huyện của bài đối sánh này — MOFDA gốc dùng khung thép nhà chờ bến phà Đồng Bài, MOSFOA gốc dùng cảng xăng dầu Hải Linh (bến cập tàu/bến neo/cầu tàu chính). Hai bài đó chỉ được trích dẫn ở đây làm **nguồn thuật toán gốc**, không phải nguồn số liệu công trình.

---

## 4.1. MOFDA

Thuật toán Hướng dòng chảy đa mục tiêu (Multi-Objective Flow Direction Algorithm – MOFDA) [1] là một mở rộng đa mục tiêu của Flow Direction Algorithm (FDA) đơn mục tiêu — thuật toán vật lý mô phỏng dòng chảy nước mưa (runoff) di chuyển về điểm thấp nhất của lưu vực theo địa hình, dùng nguyên lý D8 để xác định hướng lân cận. Mỗi cá thể (dòng chảy) $X(i)$ sinh $\beta$ vị trí lân cận quanh nó; vị trí mới được cập nhật theo độ dốc cục bộ giữa cá thể và lân cận tốt nhất (leader), kết hợp trọng số suy giảm phi tuyến theo tiến độ vòng lặp để cân bằng thăm dò/khai thác.

MOFDA bổ sung vào khung FDA gốc hai cơ chế cho bài toán đa mục tiêu: (i) một **kho lưu trữ ngoài** (external archive) lưu các nghiệm không bị trội, với cơ chế kiểm soát vượt dung lượng dựa trên lưới thích nghi (adaptive grid) chia không gian mục tiêu thành các siêu lập phương (hypercube); (ii) một **chiến lược chọn thủ lĩnh lai** (hybrid leader selection) — đóng góp mới của [1] so với phiên bản MOFDA nguyên bản dùng roulette-wheel selection cổ điển. Chiến lược lai chấm điểm mỗi cá thể trong kho lưu trữ theo

$$s_i = GI_i + \frac{\varepsilon_i}{1+DE_i}$$

trong đó $GI_i$ là chỉ số ô lưới, $DE_i$ là mật độ cục bộ (số cá thể cùng chia sẻ ô lưới), $\varepsilon_i\in[0,1]$ là nhiễu ngẫu nhiên nhỏ duy trì đa dạng; thủ lĩnh được chọn là cá thể có điểm số thấp nhất, ưu tiên vùng thưa nghiệm nhưng có kiểm soát mức ngẫu nhiên nhằm giảm nguy cơ hội tụ sớm so với roulette-wheel selection thuần túy. Ràng buộc được xử lý bằng hàm phạt nhân (tương tự cách tiếp cận của nghiên cứu này, xem Mục 3.1).

MOFDA đã được kiểm chứng trên 31 hàm chuẩn (ZDT, DTLZ, MMF, UF) và 11 bài toán kỹ thuật có ràng buộc (giàn 10–942 thanh, dầm hàn, SRN, OSY), cho kết quả cạnh tranh hoặc vượt trội so với MOMVO, MOMSA, MSSA, MOGNDO trên phần lớn chỉ số IGD/GD/STE — nổi bật nhất là đạt Best-IGD tuyệt đối trên toàn bộ 12 bài toán MMF (CEC2020). MOFDA cũng đã được áp dụng cho một công trình thực tế — tối ưu khung thép nhà chờ bến phà Đồng Bài, đảo Cát Hải, Hải Phòng, kết nối MATLAB–SAP2000 qua SM Toolbox, giảm tới 71,4% chuyển vị hoặc 26,7% khối lượng tùy kịch bản đánh đổi được chọn trên mặt Pareto.

**Tham số MOFDA dùng trong nghiên cứu này**: quần thể $N_p=50$, $\beta=4$ hướng lân cận/cá thể, dung lượng kho lưu trữ $N_r=100$, số ô lưới $nGrid=10$, $maxiter=50$ vòng lặp — tổng ngân sách đánh giá FEM $FE=N_p[1+maxiter(\beta+1)]=12.550$.

## 4.2. MOSFOA (bản chạy: E-MOSFOA)

MOSFOA là biến thể đa mục tiêu của Starfish Optimization Algorithm (SFOA) [2] — thuật toán đơn mục tiêu mô phỏng hành vi tìm kiếm của sao biển, gồm cơ chế "arm-twist" (xoay cánh, thăm dò đa chiều), "energy-step" (bước năng lượng, thăm dò chiều thấp) và "preying" (bắt mồi, khai thác dựa trên 5 cá thể lân cận và thủ lĩnh). Nghiên cứu gốc [3] phát triển hai phiên bản đa mục tiêu: **B-MOSFOA** (Base) giữ nguyên các phương trình di chuyển gốc của SFOA, bổ sung kho lưu trữ Pareto ngoài, kiểm soát đa dạng dựa trên lưới thích nghi và chọn thủ lĩnh theo xác suất nghịch mật độ ô lưới $P_i=c/N_i$; và **E-MOSFOA** (Enhanced) — phiên bản dùng để chạy thực nghiệm trong nghiên cứu này — xây trên nền B-MOSFOA, bổ sung ba cơ chế:

1. **Điều khiển pha theo cosine** (cosine-phase control): thay xác suất thăm dò cố định $GP_0$ của SFOA gốc bằng lịch trình giảm mượt

$$GP = \frac{GP_0}{2}\left(1+\cos\left(\pi\cdot\frac{it}{Max\_it}\right)\right)$$

giúp chuyển đổi thăm dò→khai thác diễn ra liên tục thay vì đột ngột.

2. **Đột biến kiểu DE dẫn hướng bởi thủ lĩnh** (leader-guided DE-mutation) kết hợp lai ghép nhị thức (binomial crossover), kích hoạt trong pha thăm dò:

$$mutant_i = X_{r1} + F\cdot(X_{r2}-X_{r3}) + \lambda\cdot(X_{leader}-X_{r1}), \quad F=0{,}5\left(1-\frac{it}{Max\_it}\right)$$

với hệ số hút về thủ lĩnh $\lambda=0{,}3$, xác suất lai ghép $CR=0{,}5$ — hệ số khuếch đại đột biến $F$ giảm tuyến tính theo tiến độ vòng lặp (bước "energy-step" thích nghi).

3. **Tinh chỉnh Gaussian giai đoạn cuối dựa trên kho lưu trữ** (archive-based Gaussian refinement), chỉ kích hoạt trong 20% vòng lặp cuối ($it \ge 0{,}8\,Max\_it$): chọn cá thể tham chiếu $X^*=\arg\min\sum_j f_{i,j}$ trong kho lưu trữ rồi tái sinh một phần quần thể quanh $X^*$ bằng nhiễu Gauss, trong khi quy tắc trội Pareto vẫn quyết định nghiệm nào được giữ lại.

Trên các bộ benchmark IMOP/UF/RM-MEDA (30 lần chạy độc lập/bài toán, kiểm định Wilcoxon rank-sum hai phía hiệu chỉnh Holm), E-MOSFOA đạt hạng trung bình tổng thể tốt thứ 2 (2,58, sau MOMSA 2,52, trước B-MOSFOA 2,75) với chi phí đánh giá hàm thấp nhất trong nhóm so sánh (50.100 FE so với MOMSA 60.100, MOGNDO 100.100, NS-MFO 150.100). Trên công trình thực tế — cảng xăng dầu Hải Linh, Hải Phòng (bến cập tàu, bến neo, cầu tàu chính) — nghiệm Pareto chi phí thấp nhất giảm tới 81,5% chi phí và 42,4% chuyển vị so với hiện trạng ở bến neo, toàn bộ 6 kho lưu trữ cuối cùng đều khả thi 100%.

**Tham số E-MOSFOA dùng trong nghiên cứu này**: quần thể $N_p=50$, dung lượng kho lưu trữ $N_r=100$, số ô lưới $nGrid=10$, $GP_0=0{,}5$, $\lambda=0{,}3$, $CR=0{,}5$, $Max\_it=250$ vòng lặp — tổng ngân sách đánh giá FEM $FE=N_p(Max\_it+1)=12.550$, khớp chính xác với ngân sách MOFDA (Mục 4.1) do $Max\_it=5\times maxiter$.

## 4.3. Ngân sách đánh giá công bằng

Xem Bảng mục B của đề cương — hai thuật toán được thiết lập trên cùng hệ thống đánh giá MATLAB–SAP2000 (hàm mục tiêu, ràng buộc, cơ chế lưu trữ Pareto archive/grid, rời rạc hoá biến thiết kế), cùng $N_r=100$, cùng $nGrid=10$, cùng ngân sách $FE=12.550$/lần chạy, cùng $N=30$ lần chạy độc lập/thuật toán.

---

## Nguồn trích dẫn (dùng nguyên văn khi hoàn thiện danh mục tài liệu tham khảo)

> **[1]** cho MOFDA lấy đúng theo bài báo gốc 243-tổ-hợp đã công bố trước đó (khớp với ref [10] trong chính danh mục tài liệu tham khảo của bài MOSFOA — xác nhận chéo, không cần đoán): 
> Vu-Huu, T., S. Khatir, and T. Cuong-Le, *Real-World Steel Frame Optimization Using a Hybrid Leader Selection-Based Multi-Objective Flow Direction Algorithm.* International Journal for Numerical Methods in Engineering, 2025. **126**(15): p. e70098. https://doi.org/10.1002/nme.70098

> **[2]** SFOA gốc: Zhong, C., et al., *Starfish optimization algorithm (SFOA): a bio-inspired metaheuristic algorithm for global optimization compared with 100 optimizers.* Neural Computing and Applications, 2025(5): p. 3641-3683.

> **[3]** MOSFOA (B-MOSFOA/E-MOSFOA) — bài gốc, **DOI/tên tạp chí/volume CHƯA CÓ trong file đọc được** (bản thảo giai đoạn sản xuất, chưa lên khuôn — cần bạn bổ sung thủ công từ email chấp nhận hoặc cổng nộp bài):
> Do-Quang, T., T. Vu-Huu, and T. Cuong-Le, *Multi-objective Optimization Design of Marine Structures Based on An Enhanced Starfish Algorithm.* [Tên tạp chí], [năm]. **[volume]**([issue]): p. [trang].

**Lưu ý khi hoàn thiện**: bài MOFDA gốc [1] cũng tự nó CHƯA có DOI/tên tạp chí trong file `02_MOFDA.docx` đọc trực tiếp — nhưng số DOI/volume nêu trên được xác nhận CHÉO qua chính danh mục tài liệu tham khảo của bài MOSFOA (ref [10]), và trùng khớp với ref [1] đã dùng trong bài báo MOFDA 243-tổ-hợp đã hoàn thiện trước đó (`BAI_BAO_MOFDA_CAU_TAU_100000DWT.md`) — độ tin cậy cao. Với MOSFOA [3], chưa tìm được nguồn xác nhận chéo tương tự — cần bạn cung cấp DOI/tên tạp chí trước khi nộp bản thảo cuối.
