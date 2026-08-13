function [Nk_pile, N_pile,Ili] = pile_bearing_capacity(gamma,LP_in_soil,A_tip,C_p,SKs,ILs,segment,f_r,t_r,itip)
%% Tính toán sức kháng thân cọc 
% 1) Khi xác định trị số cường độ sức kháng fi trên thân cọc phải chia từng lớp đất thành các lớp phân tố đất đồng
% nhất dày tối đa 2 m, chiều sâu trung bình của các lớp phân tố tính theo cách như ở chú thích Bảng 2. Đối với
% các phép tính sơ bộ có thể lấy cả chiều dày mỗi lớp đất trong phạm vi chiều dài cọc.
% 2) Đối với những trường hợp chiều sâu lớp đất và chỉ số sệt IL của đất dính có giá trị trung gian, trị số cường độ
% sức kháng fi được xác định bằng nội suy.
% 3) Cường độ sức kháng fi đối với cát chặt lấy tăng thêm 30 % so với trị số ghi trong bảng này.
% 4) Cường độ sức kháng fi của cát pha và sét pha có hệ số rỗng e < 0,5 và của sét có hệ số rỗng e < 0,6 đều lấy
% tăng 15 % so với trị số trong Bảng 3 cho chỉ số sệt bất kỳ.
% 5) Đối với đất cát pha ứng với chỉ số dẻo IP ≤ 4 và hệ số rỗng e < 0,8 sức kháng tính toán qb và fi được xác định
% như đối với cát bụi chặt vừa.
% 6) Trong tính toán, chỉ số sệt của đất lấy theo giá trị dự báo ở giai đoạn sử dụng của công trình.
%% Tính sức kháng ở mũi cọc
% 4) Đối với cát chặt, khi độ chặt được xác định bằng xuyên tĩnh, còn cọc hạ không dùng phương pháp xói nước
% hoặc khoan dẫn trị số qb ghi trong Bảng 2 được phép tăng lên 100 %. Khi độ chặt của đất được xác định
% qua số liệu khảo sát công trình bằng những phương pháp khác mà không xuyên tĩnh, trị số qb đối với cát
% chặt ghi trong Bảng 2 đựơc phép tăng lên 60 %, nhưng không vượt quá 20 Mpa.
% 5) Cường độ sức kháng qb trong Bảng 2 được phép sử dụng với điều kiện nếu chiều sâu hạ cọc tối thiểu
% xuống nền đất không bị xói và không bị đào xén nhỏ hơn:
% 4 m - đối với cầu và công trình thuỷ;
% 3 m - đối với nhà và công trình khác.
% 6) Đối với những cọc đóng có tiết diện ngang 150 mm x 150 mm và nhỏ hơn, dùng làm móng dưới tường ngăn
% bên trong của những ngôi nhà sản xuất một tầng, trị số qb được phép tăng lên 20 %.
% 7) Đối với đất cát pha ứng với chỉ số dẻo IP ≤ 4 và hệ số rỗng e < 0,8 sức kháng tính toán qb và fi được xác
% định như đối với cát bụi chặt vừa.
%% Sức chịu tải cọc
% gamma.c % Hệ số điều kiện làm việc
% gamma.cq % Hệ số điều kiện làm việc của đất ở vị trí mũi cọc
% gamma.cf % Hệ số điều kiện làm việc của đất xung quanh thân cọc
% A_tip % diện tích mũi cọc
% C_p % Chu vi thân cọc
% LP_in_soil % Length of pile in soil
% segment = 1;
% SKs = [4.8 5.3 9.6 1.7 4.9 2.3]; % Soil thickness of each layers
% ILs = [0.76 0.31 0.63 0.31 0.67 0.3]; % IL of each soil layers
% gamma.O = 1.15;
% gamma.k = 1.4;
% gamma.n = 1.1;
% frise=1 % hệ số tăng sức kháng thân cọc nếu là cát chặt
% trise % Hệ số tăng sức kháng mũi cọc
%
load Table_Fi_friction.mat
load Table_Fi_tip.mat
SLs = length(SKs); % Number of soil layers
[zi_bed,zi_mi,Ili,li,f_r,gamma.cf] = segment_pile01(SLs,SKs,LP_in_soil,ILs,segment,f_r,gamma.cf);
% Nôi suy giá trị sức kháng thân cọc
Fi_fric = f_r.*interp2(IL_fric, d_fric, F_fric, max(min(Ili,1),0.2), max(min(zi_mi,35),1), 'linear', NaN); % đơn vị kPa =  1kN/m2
% Nội suy giá trị sức kháng mũi cọc
Fi_tip = t_r.*interp2(IL_tip, d_tip, F_tip{itip}, max(min(Ili(end),0.6),0), max(min(zi_bed(end),35),3), 'linear');
R_pile = gamma.c*(gamma.cq*Fi_tip*A_tip+C_p*sum(gamma.cf.*Fi_fric.*li)).*[1 0.102]; % [kN Tons]
Rk_pile = gamma.ck*(C_p*sum(gamma.cf.*Fi_fric.*li)).*[1 0.102]; % [kN Tons]
N_pile = R_pile*gamma.O/(gamma.k*gamma.n);
Nk_pile = Rk_pile*gamma.O/(gamma.k*gamma.n);
end