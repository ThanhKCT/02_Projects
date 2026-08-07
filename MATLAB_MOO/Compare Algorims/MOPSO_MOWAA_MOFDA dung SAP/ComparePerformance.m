% =========================================================================
% SO SÁNH HIỆU NĂNG 3 THUẬT TOÁN TỪ 1 LẦN CHẠY (Data_MOPSO/MOWAA/MOFDA.mat)
% Dùng để kiểm tra nhanh sau mỗi lần chạy đơn lẻ. Để có kết luận thống kê
% chắc chắn cho bài báo, hãy dùng BatchRun_N.m + AnalyzeBatchResults.m
% (chạy lặp nhiều lần độc lập).
%
% Các chỉ số:
%  - SoNghiemPareto  : số nghiệm Pareto tìm được
%  - Hypervolume(%)  : % thể tích không gian mục tiêu bị chiếm ưu (so với
%                      1 điểm mốc chung) - CÀNG LỚN CÀNG TỐT
%  - Spacing         : độ đồng đều phân bố nghiệm trên mặt trận - CÀNG NHỎ CÀNG TỐT
%  - GD              : khoảng cách trung bình tới mặt trận tham chiếu
%                      ("độ chính xác") - CÀNG NHỎ CÀNG TỐT
%  - IGD             : độ phủ mặt trận tham chiếu ("độ đầy đủ") - CÀNG NHỎ CÀNG TỐT
%
% Mặt trận tham chiếu = hợp nhất + lọc lại Pareto của CẢ 3 thuật toán (vì
% không biết mặt trận Pareto thật của bài toán kỹ thuật này).
% =========================================================================
clc;
addpath(fullfile(pwd, 'MOWAA'));  % Cần cho hypervolume.m, metric_of_spacing.m, GD_matlab.m, IGD_matlab.m

STEEL_DENSITY = 7850; % kg/m3 - quy đổi Thể tích(m3) sang Khối lượng(kg), đồng bộ với Plot_Results.m

algNames = {};
allCosts = {};

if isfile('Data_MOPSO.mat')
    d = load('Data_MOPSO.mat'); algNames{end+1} = 'MOPSO'; allCosts{end+1} = d.costs_MOPSO; %#ok<SAGROW>
end
if isfile('Data_MOWAA.mat')
    d = load('Data_MOWAA.mat'); algNames{end+1} = 'MOWAA'; allCosts{end+1} = d.costs_MOWAA; %#ok<SAGROW>
end
if isfile('Data_MOFDA.mat')
    d = load('Data_MOFDA.mat'); algNames{end+1} = 'MOFDA'; allCosts{end+1} = d.costs_MOFDA; %#ok<SAGROW>
end

if numel(allCosts) < 2
    error('Cần ít nhất 2 thuật toán đã có dữ liệu (Data_*.mat) để so sánh.');
end

% Quy đổi đơn vị hiển thị: cột 1 -> kg, cột 2 -> mm (giống Plot_Results.m)
for k = 1:numel(allCosts)
    allCosts{k}(:,1) = allCosts{k}(:,1) * STEEL_DENSITY;
    allCosts{k}(:,2) = allCosts{k}(:,2) * 1000;
end

% --- Mặt trận tham chiếu: hợp nhất + lọc Pareto của tất cả thuật toán ---
combined = cat(1, allCosts{:});
refFront = ParetoFilterCosts(combined);

% --- Điểm mốc Hypervolume (nadir): lớn hơn giá trị tệ nhất quan sát được ---
refPoint = max(combined, [], 1) * 1.05;

nAlg = numel(algNames);
SoNghiemPareto = zeros(nAlg,1); Hypervolume_pct = zeros(nAlg,1);
Spacing = nan(nAlg,1); GD = zeros(nAlg,1); IGD = zeros(nAlg,1);

for k = 1:nAlg
    P = allCosts{k};
    SoNghiemPareto(k) = size(P,1);
    Hypervolume_pct(k) = hypervolume(P, refPoint, 20000) * 100;
    if size(P,1) > 1
        Spacing(k) = metric_of_spacing(P);
    end
    GD(k) = GD_matlab(P, refFront);
    IGD(k) = IGD_matlab(P, refFront);
end

T = table(algNames', SoNghiemPareto, Hypervolume_pct, Spacing, GD, IGD, ...
    'VariableNames', {'ThuatToan','SoNghiemPareto','Hypervolume_pct','Spacing','GD','IGD'});

disp('=== SO SÁNH HIỆU NĂNG 3 THUẬT TOÁN (1 lần chạy) ===');
disp('(Hypervolume: càng LỚN càng tốt | Spacing/GD/IGD: càng NHỎ càng tốt)');
disp(T);

writetable(T, 'SoSanh_HieuNang_1Lan.csv');
disp('=> Đã xuất bảng so sánh ra SoSanh_HieuNang_1Lan.csv');
