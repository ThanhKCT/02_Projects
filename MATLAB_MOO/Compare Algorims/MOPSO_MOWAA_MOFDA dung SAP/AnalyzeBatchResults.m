% =========================================================================
% PHÂN TÍCH KẾT QUẢ CHẠY LẶP N LẦN (BatchResults/) - SO SÁNH THỐNG KÊ
%
% Đọc tất cả các lần chạy ĐÃ HOÀN THÀNH của mỗi thuật toán (không cần đợi
% đủ N lần - có thể chạy sớm để xem tiến độ), tính chỉ số hiệu năng cho
% TỪNG LẦN CHẠY, rồi tổng hợp trung bình +/- độ lệch chuẩn để so sánh có
% ý nghĩa thống kê (thay vì chỉ 1 lần chạy ngẫu nhiên).
%
% Đồng thời xuất 1 hình Pareto "gộp" cho bài báo: với mỗi thuật toán, hợp
% nhất toàn bộ nghiệm của N lần chạy rồi lọc lại còn nghiệm không trội ->
% mặt trận dày/mượt hơn hẳn 1 lần chạy đơn lẻ, vẫn công bằng vì áp dụng
% như nhau cho cả 3 thuật toán (cùng N lần).
% =========================================================================
clc;
addpath(fullfile(pwd, 'MOWAA'));  % Cần cho hypervolume.m, metric_of_spacing.m, GD_matlab.m, IGD_matlab.m

STEEL_DENSITY = 7850; % kg/m3
MM_PER_M = 1000;
resultsDir = 'BatchResults';
algNames = {'MOPSO', 'MOWAA', 'MOFDA'};
plotStyle = struct('MOPSO', {{'ro','r-'}}, 'MOWAA', {{'bs','b-'}}, 'MOFDA', {{'gd','g-'}});

%% 1. ĐỌC DỮ LIỆU
runData = struct();
for a = 1:numel(algNames)
    files = dir(fullfile(resultsDir, [algNames{a} '_run*.mat']));
    costsCell = cell(numel(files), 1);
    for k = 1:numel(files)
        d = load(fullfile(resultsDir, files(k).name));
        C = d.(['costs_' algNames{a}]);
        C(:,1) = C(:,1) * STEEL_DENSITY;   % kg
        C(:,2) = C(:,2) * MM_PER_M;        % mm
        costsCell{k} = C;
    end
    runData.(algNames{a}) = costsCell;
    fprintf('%s: %d lần chạy đã hoàn thành trong %s\n', algNames{a}, numel(files), resultsDir);
end

if any(structfun(@isempty, runData))
    error('Chưa có đủ dữ liệu batch cho ít nhất 1 thuật toán. Hãy chạy BatchRun_N.m trước.');
end

%% 2. MẶT TRẬN THAM CHIẾU CHUNG: hợp nhất TẤT CẢ lần chạy của CẢ 3 thuật toán
allCombined = [];
for a = 1:numel(algNames)
    allCombined = [allCombined; cat(1, runData.(algNames{a}){:})]; %#ok<AGROW>
end
refFront = ParetoFilterCosts(allCombined);
refPoint = max(allCombined, [], 1) * 1.05;

%% 3. CHỈ SỐ HIỆU NĂNG CHO TỪNG LẦN CHẠY CỦA TỪNG THUẬT TOÁN
metricNames = {'SoNghiemPareto','Hypervolume_pct','Spacing','GD','IGD'};
allMetrics = struct();
summary = table();
combinedFront = struct();

for a = 1:numel(algNames)
    name = algNames{a};
    runs = runData.(name);
    nR = numel(runs);
    M = nan(nR, numel(metricNames));
    for k = 1:nR
        P = runs{k};
        M(k,1) = size(P,1);
        M(k,2) = hypervolume(P, refPoint, 20000) * 100;
        if size(P,1) > 1
            M(k,3) = metric_of_spacing(P);
        end
        M(k,4) = GD_matlab(P, refFront);
        M(k,5) = IGD_matlab(P, refFront);
    end
    allMetrics.(name) = M;

    % Mặt trận "gộp" của thuật toán này (hợp nhất N lần chạy + lọc lại) - dùng để vẽ hình
    combinedFront.(name) = ParetoFilterCosts(cat(1, runs{:}));

    row = table({name}, nR, ...
        mean(M(:,1)), std(M(:,1)), ...
        mean(M(:,2)), std(M(:,2)), ...
        mean(M(:,3),'omitnan'), std(M(:,3),'omitnan'), ...
        mean(M(:,4)), std(M(:,4)), ...
        mean(M(:,5)), std(M(:,5)), ...
        'VariableNames', {'ThuatToan','SoLanChay', ...
        'SoNghiem_TB','SoNghiem_SD','HV_TB_pct','HV_SD', ...
        'Spacing_TB','Spacing_SD','GD_TB','GD_SD','IGD_TB','IGD_SD'});
    summary = [summary; row]; %#ok<AGROW>
end

disp(' ');
disp('=== SO SÁNH HIỆU NĂNG 3 THUẬT TOÁN QUA NHIỀU LẦN CHẠY (TRUNG BÌNH +/- ĐỘ LỆCH CHUẨN) ===');
disp('(Hypervolume: càng LỚN càng tốt | Spacing/GD/IGD: càng NHỎ càng tốt)');
disp(summary);
writetable(summary, 'SoSanh_HieuNang_NLan.csv');
disp('=> Đã xuất bảng tổng hợp ra SoSanh_HieuNang_NLan.csv');

%% 4. HÌNH PARETO GỘP CHO BÀI BÁO (mặt trận dày/mượt hơn 1 lần chạy đơn lẻ)
figure('Name', 'Mặt trận Pareto gộp (dùng cho bài báo)', 'Color', 'w');
hold on; grid on; box on;
xlabel('Khối lượng vật liệu khung thép (kg)', 'FontWeight', 'bold', 'FontSize', 11);
ylabel('Chuyển vị đỉnh thực tế U1 (mm)', 'FontWeight', 'bold', 'FontSize', 11);
title('Mặt trận Pareto gộp: MOPSO vs MOWAA vs MOFDA', 'FontSize', 13);

for a = 1:numel(algNames)
    name = algNames{a};
    P = sortrows(combinedFront.(name), 1);   % sắp xếp theo khối lượng để nối đường mượt
    sty = plotStyle.(name);
    plot(P(:,1), P(:,2), sty{2}, 'LineWidth', 1.2, 'HandleVisibility', 'off');
    plot(P(:,1), P(:,2), sty{1}, 'MarkerSize', 6, 'LineWidth', 1.3, 'DisplayName', ['Pareto ' name]);
end
legend('Location', 'northeast');
hold off;

disp('=> Đã vẽ hình Pareto gộp (mượt hơn, dùng để đưa vào bài báo).');

%% 5. BOXPLOT SO SÁNH (cần Statistics and Machine Learning Toolbox)
try
    figure('Name', 'So sánh Hypervolume qua nhiều lần chạy', 'Color', 'w');
    hvAll = []; hvGroupLabel = {};
    for a = 1:numel(algNames)
        hvAll = [hvAll; allMetrics.(algNames{a})(:,2)]; %#ok<AGROW>
        hvGroupLabel = [hvGroupLabel; repmat(algNames(a), size(allMetrics.(algNames{a}),1), 1)]; %#ok<AGROW>
    end
    boxplot(hvAll, hvGroupLabel);
    ylabel('Hypervolume (%)'); title('So sánh Hypervolume qua nhiều lần chạy'); grid on;

    figure('Name', 'So sánh IGD qua nhiều lần chạy', 'Color', 'w');
    igdAll = []; igdGroupLabel = {};
    for a = 1:numel(algNames)
        igdAll = [igdAll; allMetrics.(algNames{a})(:,5)]; %#ok<AGROW>
        igdGroupLabel = [igdGroupLabel; repmat(algNames(a), size(allMetrics.(algNames{a}),1), 1)]; %#ok<AGROW>
    end
    boxplot(igdAll, igdGroupLabel);
    ylabel('IGD (càng nhỏ càng tốt)'); title('So sánh IGD (độ phủ mặt trận tham chiếu) qua nhiều lần chạy'); grid on;

    disp('=> Đã vẽ boxplot so sánh Hypervolume và IGD.');
catch
    disp('=> (Bỏ qua vẽ boxplot: cần Statistics and Machine Learning Toolbox)');
end
