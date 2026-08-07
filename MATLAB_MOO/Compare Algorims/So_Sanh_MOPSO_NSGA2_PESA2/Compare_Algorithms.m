% =========================================================================
% KỊCH BẢN TỔNG HỢP SO SÁNH 3 THUẬT TOÁN: MOPSO - NSGA-II - PESA-II
% TÍCH HỢP XUẤT EXCEL TỰ ĐỘNG (THỜI GIAN & THÔNG SỐ TIẾT DIỆN)
%
% ĐẢM BẢO CÔNG BẰNG (không thiên vị) giữa 3 thuật toán bằng cách:
%   1. Cân bằng theo SỐ LẦN GỌI HÀM MỤC TIÊU (NFE), KHÔNG phải theo số
%      vòng lặp (MaxIt) - mỗi thuật toán tốn số lần gọi hàm khác nhau MỖI
%      vòng lặp (NSGA-II/PESA-II sinh ra ~nPop cá thể con/vòng lặp, MOPSO
%      chỉ cập nhật nPop cá thể + đột biến xác suất giảm dần) nên cùng
%      MaxIt KHÔNG đồng nghĩa cùng khối lượng tính toán.
%   2. Đặt lại rng('default') TRƯỚC MỖI thuật toán.
%   3. In rõ toàn bộ tham số điều khiển của từng thuật toán.
%   4. Thêm chỉ số định lượng khách quan (Hypervolume, Spacing, số nghiệm
%      Pareto) với CÙNG 1 điểm tham chiếu (nadir) cho cả 3 thuật toán.
% =========================================================================

clc; close all;

nPop = 100; nRep = 100;      % Quần thể / kích thước kho lưu trữ - GIỐNG NHAU cho cả 3
NFE_Target = 30000;          % Ngân sách số lần gọi hàm mục tiêu DÙNG CHUNG cho cả 3
MaxIt_Calib = [3 8];         % 2 mốc vòng lặp nhỏ để hiệu chỉnh (đo NFE/vòng lặp)

disp('====================================================');
disp('BƯỚC 0: HIỆU CHỈNH SỐ VÒNG LẶP (MaxIt) THEO NGÂN SÁCH NFE DÙNG CHUNG');
disp('====================================================');

%% 0. HIỆU CHỈNH MaxIt CHO TỪNG THUẬT TOÁN THEO NGÂN SÁCH NFE CHUNG
MaxIt_mopso = CalibrateMaxIt(@(it) mopso(it, nPop, nRep), MaxIt_Calib, NFE_Target);
MaxIt_nsga2 = CalibrateMaxIt(@(it) nsga2(it, nPop), MaxIt_Calib, NFE_Target);
MaxIt_pesa2 = CalibrateMaxIt(@(it) pesa2(it, nPop, nRep), MaxIt_Calib, NFE_Target);

fprintf('\n>> Ngân sách NFE dùng chung: %d lần gọi hàm mục tiêu\n', NFE_Target);
fprintf('>> MaxIt sau hiệu chỉnh -  MOPSO: %d | NSGA-II: %d | PESA-II: %d\n\n', ...
    MaxIt_mopso, MaxIt_nsga2, MaxIt_pesa2);

%% 1. CHẠY VÀ ĐO THỜI GIAN + NFE THỰC TẾ CỦA 3 THUẬT TOÁN
disp('====================================================');
disp('BẮT ĐẦU TIẾN TRÌNH KHẢO SÁT (đã cân bằng NFE)...');
disp('====================================================');

disp(' '); disp('====== GIAI ĐOẠN 1: KÍCH HOẠT THUẬT TOÁN MOPSO ======');
rng('default'); HamMucTieuToiUu('reset');
tic; rep = mopso(MaxIt_mopso, nPop, nRep); thoi_gian_mopso = toc;
nfe_mopso = HamMucTieuToiUu();
fprintf('>> HOÀN THÀNH MOPSO. Thời gian: %.2f giây | NFE thực tế: %d\n', thoi_gian_mopso, nfe_mopso);
mopso_costs = [rep.Cost];

disp(' '); disp('====== GIAI ĐOẠN 2: KÍCH HOẠT THUẬT TOÁN NSGA-II ======');
rng('default'); HamMucTieuToiUu('reset');
tic; F1 = nsga2(MaxIt_nsga2, nPop); thoi_gian_nsga2 = toc;
nfe_nsga2 = HamMucTieuToiUu();
fprintf('>> HOÀN THÀNH NSGA-II. Thời gian: %.2f giây | NFE thực tế: %d\n', thoi_gian_nsga2, nfe_nsga2);
nsga2_costs = [F1.Cost];

disp(' '); disp('====== GIAI ĐOẠN 3: KÍCH HOẠT THUẬT TOÁN PESA-II ======');
rng('default'); HamMucTieuToiUu('reset');
tic; archive = pesa2(MaxIt_pesa2, nPop, nRep); thoi_gian_pesa2 = toc;
nfe_pesa2 = HamMucTieuToiUu();
fprintf('>> HOÀN THÀNH PESA-II. Thời gian: %.2f giây | NFE thực tế: %d\n', thoi_gian_pesa2, nfe_pesa2);
pesa2_costs = [archive.Cost];

%% 2. IN BẢNG TỔNG HỢP THAM SỐ & THỜI GIAN
fprintf('\n====================================================\n');
fprintf('   BẢNG THAM SỐ CHUNG (giống nhau cho cả 3 thuật toán)\n');
fprintf('====================================================\n');
fprintf(' nPop / ArchiveSize (nRep) : %d / %d\n', nPop, nRep);
fprintf(' Ngân sách NFE mục tiêu    : %d\n', NFE_Target);
fprintf('====================================================\n');
fprintf('   BẢNG TỔNG HỢP THỜI GIAN & NFE THỰC TẾ\n');
fprintf('====================================================\n');
fprintf(' %-8s | MaxIt | NFE thực tế | Thời gian (s)\n', 'Thuật toán');
fprintf(' %-8s | %5d | %11d | %.2f\n', 'MOPSO', MaxIt_mopso, nfe_mopso, thoi_gian_mopso);
fprintf(' %-8s | %5d | %11d | %.2f\n', 'NSGA-II', MaxIt_nsga2, nfe_nsga2, thoi_gian_nsga2);
fprintf(' %-8s | %5d | %11d | %.2f\n', 'PESA-II', MaxIt_pesa2, nfe_pesa2, thoi_gian_pesa2);
fprintf('====================================================\n');
disp('(Tham số riêng của từng thuật toán - w/c1/c2, pCrossover/pMutation... - đã được in ở trên khi mỗi thuật toán bắt đầu chạy)');

%% 3. CHỈ SỐ ĐỊNH LƯỢNG KHÁCH QUAN (Hypervolume, Spacing, số nghiệm) - CÙNG 1 ĐIỂM THAM CHIẾU
all_costs = [mopso_costs, nsga2_costs, pesa2_costs];
RefPoint = max(all_costs, [], 2)' .* 1.05; % điểm tham chiếu (nadir) DÙNG CHUNG, worse hơn mọi điểm 5%

HV_mopso = Hypervolume2D(mopso_costs, RefPoint);
HV_nsga2 = Hypervolume2D(nsga2_costs, RefPoint);
HV_pesa2 = Hypervolume2D(pesa2_costs, RefPoint);

SP_mopso = SpacingMetric(mopso_costs);
SP_nsga2 = SpacingMetric(nsga2_costs);
SP_pesa2 = SpacingMetric(pesa2_costs);

fprintf('\n====================================================\n');
fprintf('   CHỈ SỐ ĐỊNH LƯỢNG (điểm tham chiếu chung: Mass=%.1f kg, Drift=%.5f m)\n', RefPoint(1), RefPoint(2));
fprintf('====================================================\n');
fprintf(' %-8s | Số nghiệm Pareto | Hypervolume | Spacing (càng nhỏ càng đều)\n', 'Thuật toán');
fprintf(' %-8s | %16d | %11.2f | %.4f\n', 'MOPSO', numel(rep), HV_mopso, SP_mopso);
fprintf(' %-8s | %16d | %11.2f | %.4f\n', 'NSGA-II', numel(F1), HV_nsga2, SP_nsga2);
fprintf(' %-8s | %16d | %11.2f | %.4f\n', 'PESA-II', numel(archive), HV_pesa2, SP_pesa2);
fprintf('====================================================\n');
disp('(Hypervolume càng LỚN = vùng không gian mục tiêu bao phủ càng nhiều = càng tốt)');

%% 4. TÍNH TOÁN ĐIỂM KNEE POINT & VẼ ĐỒ THỊ PARETO
c1 = mopso_costs(1,:); c2 = mopso_costs(2,:);
c1_n = (c1-min(c1))/(max(c1)-min(c1)+1e-10); c2_n = (c2-min(c2))/(max(c2)-min(c2)+1e-10);
[~, k_mopso] = min(sqrt(c1_n.^2 + c2_n.^2));

c1 = nsga2_costs(1,:); c2 = nsga2_costs(2,:);
c1_n = (c1-min(c1))/(max(c1)-min(c1)+1e-10); c2_n = (c2-min(c2))/(max(c2)-min(c2)+1e-10);
[~, k_nsga2] = min(sqrt(c1_n.^2 + c2_n.^2));

c1 = pesa2_costs(1,:); c2 = pesa2_costs(2,:);
c1_n = (c1-min(c1))/(max(c1)-min(c1)+1e-10); c2_n = (c2-min(c2))/(max(c2)-min(c2)+1e-10);
[~, k_pesa2] = min(sqrt(c1_n.^2 + c2_n.^2));

figure('Name', 'Pareto Comparison', 'Position', [100, 100, 850, 650]);
hold on; box on; grid on;

p1 = plot(mopso_costs(1,:), mopso_costs(2,:)*1000, 'ro', 'MarkerSize', 5, ...
    'MarkerFaceColor', 'r', 'DisplayName', 'MOPSO');
p2 = plot(nsga2_costs(1,:), nsga2_costs(2,:)*1000, 'bs', 'MarkerSize', 5, ...
    'MarkerFaceColor', 'b', 'DisplayName', 'NSGA-II');
p3 = plot(pesa2_costs(1,:), pesa2_costs(2,:)*1000, 'g^', 'MarkerSize', 5, ...
    'MarkerFaceColor', 'g', 'DisplayName', 'PESA-II');

pk1 = plot(mopso_costs(1,k_mopso), mopso_costs(2,k_mopso)*1000, 'p', ...
    'MarkerSize', 14, 'MarkerEdgeColor', 'k', 'MarkerFaceColor', 'r', 'LineWidth', 1.5, 'DisplayName', 'Knee MOPSO');
pk2 = plot(nsga2_costs(1,k_nsga2), nsga2_costs(2,k_nsga2)*1000, '^', ...
    'MarkerSize', 10, 'MarkerEdgeColor', 'k', 'MarkerFaceColor', 'b', 'LineWidth', 1.5, 'DisplayName', 'Knee NSGA-II');
pk3 = plot(pesa2_costs(1,k_pesa2), pesa2_costs(2,k_pesa2)*1000, 'd', ...
    'MarkerSize', 10, 'MarkerEdgeColor', 'k', 'MarkerFaceColor', 'g', 'LineWidth', 1.5, 'DisplayName', 'Knee PESA-II');

xlabel('Total Structure Mass (kg)', 'FontWeight', 'bold', 'FontSize', 11);
ylabel('Roof Lateral Displacement (mm)', 'FontWeight', 'bold', 'FontSize', 11);
legend([p1, p2, p3, pk1, pk2, pk3], 'Location', 'northeast', 'FontSize', 10);

%% 5. TỔNG HỢP DỮ LIỆU ĐỂ IN VÀ XUẤT EXCEL
Algorithms = {'MOPSO'; 'NSGA-II'; 'PESA-II'};
PopData = {rep, F1, archive};
ThoiGian = [thoi_gian_mopso, thoi_gian_nsga2, thoi_gian_pesa2];
MaxItUsed = [MaxIt_mopso, MaxIt_nsga2, MaxIt_pesa2];
NFEUsed = [nfe_mopso, nfe_nsga2, nfe_pesa2];
HVUsed = [HV_mopso, HV_nsga2, HV_pesa2];
SPUsed = [SP_mopso, SP_nsga2, SP_pesa2];

Alg_Col = {}; Time_Col = []; PointType_Col = {};
Mass_Col = []; Disp_Col = [];
bc_Col = []; hc_Col = []; twc_Col = []; tfc_Col = [];
bd_Col = []; hd_Col = []; twd_Col = []; tfd_Col = [];
MaxIt_Col = []; NFE_Col = []; HV_Col = []; SP_Col = [];

for k = 1:3
    alg_name = Algorithms{k};
    pop_k = PopData{k};
    time_k = ThoiGian(k);

    Costs = [pop_k.Cost];
    Pos = reshape([pop_k.Position], 8, [])';

    [~, idx_min_mass] = min(Costs(1, :));
    [~, idx_min_disp] = min(Costs(2, :));

    c1 = Costs(1,:); c2 = Costs(2,:);
    c1_norm = (c1 - min(c1)) / (max(c1) - min(c1) + 1e-10);
    c2_norm = (c2 - min(c2)) / (max(c2) - min(c2) + 1e-10);
    dist = sqrt(c1_norm.^2 + c2_norm.^2);
    [~, idx_knee] = min(dist);

    Indices = [idx_min_mass, idx_min_disp, idx_knee];
    PointNames = {'1. Nhe Nhat (Min Mass)', '2. Cung Nhat (Min Disp)', '3. Thoa Hiep (Knee Point)'};

    for p = 1:3
        idx = Indices(p);
        Alg_Col{end+1,1} = alg_name;
        Time_Col(end+1,1) = round(time_k, 2);
        PointType_Col{end+1,1} = PointNames{p};
        Mass_Col(end+1,1) = round(Costs(1, idx), 2);
        Disp_Col(end+1,1) = round(Costs(2, idx) * 1000, 4);
        MaxIt_Col(end+1,1) = MaxItUsed(k);
        NFE_Col(end+1,1) = NFEUsed(k);
        HV_Col(end+1,1) = round(HVUsed(k), 2);
        SP_Col(end+1,1) = round(SPUsed(k), 4);

        x_opt = Pos(idx, :) * 1000;
        bc_Col(end+1,1) = round(x_opt(1), 1); hc_Col(end+1,1) = round(x_opt(2), 1);
        twc_Col(end+1,1) = round(x_opt(3), 1); tfc_Col(end+1,1) = round(x_opt(4), 1);
        bd_Col(end+1,1) = round(x_opt(5), 1); hd_Col(end+1,1) = round(x_opt(6), 1);
        twd_Col(end+1,1) = round(x_opt(7), 1); tfd_Col(end+1,1) = round(x_opt(8), 1);
    end
end

Table_Results = table(Alg_Col, Time_Col, MaxIt_Col, NFE_Col, HV_Col, SP_Col, PointType_Col, Mass_Col, Disp_Col, ...
    bc_Col, hc_Col, twc_Col, tfc_Col, bd_Col, hd_Col, twd_Col, tfd_Col, ...
    'VariableNames', {'Thuat_Toan', 'Thoi_Gian_Giay', 'MaxIt', 'NFE_Thuc_Te', 'Hypervolume', 'Spacing', 'Diem_Toi_Uu', 'Khoi_Luong_kg', 'Chuyen_Vi_mm', ...
    'Cot_bc_mm', 'Cot_hc_mm', 'Cot_twc_mm', 'Cot_tfc_mm', ...
    'Dam_bd_mm', 'Dam_hd_mm', 'Dam_twd_mm', 'Dam_tfd_mm'});

filename_opt = 'BaoCao_SoSanh_ThuatToan.xlsx';
full_path = fullfile(pwd, filename_opt);

if exist(full_path, 'file') == 2
    try delete(full_path); catch, disp('LỖI: Hãy đóng file Excel cũ trước khi chạy lại!'); return; end
end
writetable(Table_Results, full_path);

disp('====================================================');
disp(['ĐÃ HOÀN THÀNH VẼ ĐỒ THỊ VÀ XUẤT EXCEL TẠI: ', full_path]);
disp('====================================================');

try
    if ispc; winopen(full_path);
    elseif ismac; system(['open "', full_path, '"']);
    else; system(['xdg-open "', full_path, '"']); end
catch
end
% --- XỬ LÝ KHOẢNG TRẮNG ---
set(gca, 'LooseInset', get(gca, 'TightInset'));

% --- XUẤT ẢNH CHẤT LƯỢNG CAO ---
exportgraphics(gcf, 'Pareto_Plot.png', 'Resolution', 300);

disp('>> Đã xử lý khoảng trắng và xuất file Pareto_Plot.png chất lượng 300 DPI.');


%% ========================= CÁC HÀM PHỤ TRỢ =============================

function MaxIt = CalibrateMaxIt(algoFn, MaxIt_Calib, NFE_Target)
% Chạy thuật toán ở 2 mốc MaxIt nhỏ để đo CHÍNH XÁC số lần gọi hàm mục
% tiêu (NFE) tiêu tốn MỖI VÒNG LẶP, rồi suy ra MaxIt cần thiết để đạt
% đúng ngân sách NFE_Target dùng chung cho cả 3 thuật toán.
    HamMucTieuToiUu('reset');
    algoFn(MaxIt_Calib(1));
    nfe1 = HamMucTieuToiUu();

    HamMucTieuToiUu('reset');
    algoFn(MaxIt_Calib(2));
    nfe2 = HamMucTieuToiUu();

    slope = (nfe2 - nfe1) / (MaxIt_Calib(2) - MaxIt_Calib(1));
    intercept = nfe1 - slope*MaxIt_Calib(1);

    MaxIt = round((NFE_Target - intercept) / slope);
    MaxIt = max(MaxIt, 5);
end


function hv = Hypervolume2D(F, RefPoint)
% Hypervolume 2 chieu chuan (bai toan minimization) so voi 1 diem tham
% chieu (nadir) RefPoint (phai TOI HON moi diem trong F o ca 2 truc).
    [~, idx] = sort(F(1,:));
    F = F(:, idx);
    hv = 0;
    prev_f2 = RefPoint(2);
    for i = 1:size(F,2)
        f1 = F(1,i); f2 = F(2,i);
        if f1 < RefPoint(1) && f2 < prev_f2
            hv = hv + (RefPoint(1)-f1)*(prev_f2-f2);
            prev_f2 = f2;
        end
    end
end


function S = SpacingMetric(F)
% Chi so Spacing (Schott, 1995): do lech chuan cua khoang cach toi lang
% gieng gan nhat giua cac nghiem Pareto.
    N = size(F,2);
    if N < 2, S = 0; return; end
    Fn = (F - min(F,[],2)) ./ (max(F,[],2) - min(F,[],2) + 1e-10);
    d = zeros(1,N);
    for i = 1:N
        dist_others = sqrt(sum((Fn - Fn(:,i)).^2,1));
        dist_others(i) = inf;
        d(i) = min(dist_others);
    end
    S = std(d);
end
