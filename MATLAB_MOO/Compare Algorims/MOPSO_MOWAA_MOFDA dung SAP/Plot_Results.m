% =========================================================================
% TỆP VẼ BIỂU ĐỒ TỔNG HỢP TỪ DỮ LIỆU ĐÃ LƯU (MOPSO - MOWAA - MOFDA)
% =========================================================================
clc; clear; close all;

disp('Đang đọc dữ liệu và vẽ biểu đồ so sánh...');

% --- SỬA: Cost lưu trong các Data_*.mat là [Thể tích thép (m3), Chuyển vị (m)].
% Quy đổi cột 1 sang Khối lượng (kg) chỉ để HIỂN THỊ (nhân với khối lượng
% riêng thép), không ảnh hưởng tới quan hệ trội (dominance) giữa các nghiệm
% vì đây chỉ là phép nhân hằng số trên 1 trục -> không cần chạy lại MOPSO/MOWAA/MOFDA. ---
STEEL_DENSITY = 7850; % kg/m3
MM_PER_M = 1000;      % Quy đổi Chuyển vị từ m sang mm (chỉ để hiển thị)

% Tạo cửa sổ biểu đồ
figure('Name', 'So sánh Hiệu suất Tối ưu hóa Khung 2 Tầng', 'Color', 'w');
hold on; grid on; box on;

% Cấu hình nhãn trục và tiêu đề
xlabel('Khối lượng vật liệu khung thép (kg)', 'FontWeight', 'bold', 'FontSize', 11);
ylabel('Chuyển vị đỉnh thực tế U1 (mm)', 'FontWeight', 'bold', 'FontSize', 11);
title('Mặt trận Pareto: MOPSO vs MOWAA vs MOFDA', 'FontSize', 13);

%% 1. ĐỌC VÀ VẼ DỮ LIỆU MOPSO (MÀU ĐỎ)
if isfile('Data_MOPSO.mat')
    data_mopso = load('Data_MOPSO.mat');
    % Lấy dữ liệu (hỗ trợ cả tên biến costs_MOPSO hoặc Pareto_Costs_MOPSO)
    if isfield(data_mopso, 'costs_MOPSO')
        P_mopso = data_mopso.costs_MOPSO;
    else
        P_mopso = data_mopso.Pareto_Costs_MOPSO;
    end
    K_mopso = data_mopso.Knee_MOPSO;

    % --- SỬA: sắp xếp theo khối lượng rồi nối đường (đường "mượt" thay vì
    % chỉ chấm rời rạc) - đúng phong cách trình bày hình Pareto trong bài báo ---
    P_mopso_sorted = sortrows([P_mopso(:,1) * STEEL_DENSITY, P_mopso(:,2) * MM_PER_M], 1);
    plot(P_mopso_sorted(:,1), P_mopso_sorted(:,2), 'r-', 'LineWidth', 1.2, 'HandleVisibility', 'off');
    plot(P_mopso_sorted(:,1), P_mopso_sorted(:,2), 'ro', 'MarkerSize', 7, 'DisplayName', 'Pareto MOPSO');
    plot(K_mopso(1) * STEEL_DENSITY, K_mopso(2) * MM_PER_M, 'rp', 'MarkerSize', 13, 'MarkerFaceColor', 'y', 'DisplayName', 'Knee MOPSO');
end

%% 2. ĐỌC VÀ VẼ DỮ LIỆU MOWAA (MÀU XANH DƯƠNG)
if isfile('Data_MOWAA.mat')
    data_mowaa = load('Data_MOWAA.mat');
    P_mowaa = data_mowaa.costs_MOWAA;
    K_mowaa = data_mowaa.Knee_MOWAA;

    P_mowaa_sorted = sortrows([P_mowaa(:,1) * STEEL_DENSITY, P_mowaa(:,2) * MM_PER_M], 1);
    plot(P_mowaa_sorted(:,1), P_mowaa_sorted(:,2), 'b-', 'LineWidth', 1.2, 'HandleVisibility', 'off');
    plot(P_mowaa_sorted(:,1), P_mowaa_sorted(:,2), 'bs', 'MarkerSize', 7, 'DisplayName', 'Pareto MOWAA');
    plot(K_mowaa(1) * STEEL_DENSITY, K_mowaa(2) * MM_PER_M, 'bp', 'MarkerSize', 13, 'MarkerFaceColor', 'c', 'DisplayName', 'Knee MOWAA');
end

%% 3. ĐỌC VÀ VẼ DỮ LIỆU MOFDA (MÀU XANH LÁ CÂY)
if isfile('Data_MOFDA.mat')
    data_mofda = load('Data_MOFDA.mat');
    if isfield(data_mofda, 'costs_MOFDA')
        P_mofda = data_mofda.costs_MOFDA;
    else
        P_mofda = data_mofda.Pareto_Costs_MOFDA;
    end

    if isfield(data_mofda, 'Knee_MOFDA')
        K_mofda = data_mofda.Knee_MOFDA;
    else
        K_mofda = data_mofda.Knee_Cost_MOFDA;
    end

    P_mofda_sorted = sortrows([P_mofda(:,1) * STEEL_DENSITY, P_mofda(:,2) * MM_PER_M], 1);
    plot(P_mofda_sorted(:,1), P_mofda_sorted(:,2), 'g-', 'LineWidth', 1.2, 'HandleVisibility', 'off');
    plot(P_mofda_sorted(:,1), P_mofda_sorted(:,2), 'gd', 'MarkerSize', 7, 'DisplayName', 'Pareto MOFDA');
    plot(K_mofda(1) * STEEL_DENSITY, K_mofda(2) * MM_PER_M, 'gp', 'MarkerSize', 13, 'MarkerFaceColor', 'm', 'DisplayName', 'Knee MOFDA');
end

% Bật chú thích (Legend)
legend('Location', 'northeast');
hold off;

disp('=> Đã vẽ biểu đồ thành công!');
