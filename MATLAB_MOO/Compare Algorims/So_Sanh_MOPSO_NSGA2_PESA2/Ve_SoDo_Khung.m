% =========================================================
% VẼ SƠ ĐỒ KHUNG THEO PHONG CÁCH SAP2000 (KHỚP SỐ HIỆU)
% =========================================================
clc; close all;

% 1. Tọa độ các nút
X0 = [0, 0, 0, 10, 10, 10]; 
Z0 = [0, 4, 8,  0,  4,  8]; 

% 2. Khởi tạo cửa sổ đồ họa trắng tinh
figure('Name', 'So do Khung SAP2000', 'Color', 'w', 'NumberTitle', 'off');
hold on; axis equal; axis off; % Tắt trục tọa độ và lưới mặc định

% 3. Vẽ các phần tử thanh (Màu xám đen, nét mỏng như SAP)
line_color = [0.3 0.3 0.3];
plot([X0(1) X0(2)], [Z0(1) Z0(2)], 'Color', line_color, 'LineWidth', 1); % Cột 1
plot([X0(2) X0(3)], [Z0(2) Z0(3)], 'Color', line_color, 'LineWidth', 1); % Cột 2
plot([X0(4) X0(5)], [Z0(4) Z0(5)], 'Color', line_color, 'LineWidth', 1); % Cột 3
plot([X0(5) X0(6)], [Z0(5) Z0(6)], 'Color', line_color, 'LineWidth', 1); % Cột 4
plot([X0(2) X0(5)], [Z0(2) Z0(5)], 'Color', line_color, 'LineWidth', 1); % Dầm 5
plot([X0(3) X0(6)], [Z0(3) Z0(6)], 'Color', line_color, 'LineWidth', 1); % Dầm 6

% 4. Đánh SỐ HIỆU NÚT (Góc trên bên phải của nút)
offset_x = 0.1; offset_z = 0.25;
for i = 1:6
    text(X0(i) + offset_x, Z0(i) + offset_z, num2str(i), ...
        'FontSize', 11, 'Color', 'k');
end

% 5. Đánh SỐ HIỆU PHẦN TỬ (Cột: Xoay dọc, Dầm: Nằm ngang)
% Text Cột (Xoay 90 độ, nằm bên trái cột)
text(-0.2, 2, '1', 'Rotation', 90, 'FontSize', 11, 'Color', 'k', 'HorizontalAlignment', 'center');
text(-0.2, 6, '2', 'Rotation', 90, 'FontSize', 11, 'Color', 'k', 'HorizontalAlignment', 'center');
text(9.8,  2, '3', 'Rotation', 90, 'FontSize', 11, 'Color', 'k', 'HorizontalAlignment', 'center');
text(9.8,  6, '4', 'Rotation', 90, 'FontSize', 11, 'Color', 'k', 'HorizontalAlignment', 'center');

% Text Dầm (Nằm ngay trên dầm)
text(5, 4.2, '5', 'FontSize', 11, 'Color', 'k', 'HorizontalAlignment', 'center');
text(5, 8.2, '6', 'FontSize', 11, 'Color', 'k', 'HorizontalAlignment', 'center');

% 6. Vẽ ký hiệu Ngàm (Fixed Support) tại chân cột (Nút 1 và 4)
sup_w = 1.0; sup_h = 0.6; % Kích thước hộp ngàm
% Ngàm trái
plot([-sup_w/2, sup_w/2, sup_w/2, -sup_w/2, -sup_w/2], [-sup_h, -sup_h, 0, 0, -sup_h], 'Color', line_color);
plot([0 0], [0 -sup_h], 'Color', line_color); % Dấu gạch giữa
% Ngàm phải
plot([10-sup_w/2, 10+sup_w/2, 10+sup_w/2, 10-sup_w/2, 10-sup_w/2], [-sup_h, -sup_h, 0, 0, -sup_h], 'Color', line_color);
plot([10 10], [0 -sup_h], 'Color', line_color);

% 7. Vẽ hệ trục tọa độ tổng thể (Global Axes - Màu Cyan)
cyan_col = [0 1 1];
origin_x = 4.5; origin_z = 0; % Vị trí gốc tọa độ
len_ax = 1.2; % Chiều dài mũi tên

% Trục X
plot([origin_x, origin_x + len_ax], [origin_z, origin_z], 'Color', cyan_col, 'LineWidth', 1.2);
plot([origin_x + len_ax - 0.2, origin_x + len_ax], [0.1, 0], 'Color', cyan_col, 'LineWidth', 1.2); % Mũi tên
plot([origin_x + len_ax - 0.2, origin_x + len_ax], [-0.1, 0], 'Color', cyan_col, 'LineWidth', 1.2);
text(origin_x + len_ax + 0.3, 0, 'X', 'Color', cyan_col, 'FontSize', 12, 'FontWeight', 'bold', 'HorizontalAlignment', 'center');

% Trục Z
plot([origin_x, origin_x], [origin_z, origin_z + len_ax], 'Color', cyan_col, 'LineWidth', 1.2);
plot([origin_x - 0.1, origin_x], [len_ax - 0.2, len_ax], 'Color', cyan_col, 'LineWidth', 1.2); % Mũi tên
plot([origin_x + 0.1, origin_x], [len_ax - 0.2, len_ax], 'Color', cyan_col, 'LineWidth', 1.2);
text(origin_x, origin_z + len_ax + 0.3, 'Z', 'Color', cyan_col, 'FontSize', 12, 'FontWeight', 'bold', 'HorizontalAlignment', 'center');

% Mở rộng khung nhìn để hiển thị đẹp không bị cắt viền
xlim([-2, 12]);
ylim([-1.5, 9.5]);
hold off;