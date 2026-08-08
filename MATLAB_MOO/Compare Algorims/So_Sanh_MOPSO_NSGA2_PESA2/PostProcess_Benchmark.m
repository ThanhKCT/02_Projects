function PostProcess_Benchmark()
% =========================================================================
% HAU XU LY KET QUA 30 LAN CHAY DOC LAP (Final_Benchmark_Results.mat):
%   - Diem tham chieu (nadir) CHUNG cho ca 3 thuat toan (tinh tu TOAN BO
%     30x3 lan chay), dung de tinh Hypervolume cong bang.
%   - Hypervolume & Spacing: tinh RIENG cho tung lan chay, roi lay
%     trung binh +/- do lech chuan qua 30 lan (khong chi 1 lan chay).
%   - Diem "nhe nhat"/"cung nhat": lay BEST cua 30 lan (quy uoc chuan trong
%     benchmark metaheuristic) + trung binh/do lech chuan de biet do on dinh.
%   - Knee-point: tinh moi lan chay, roi lay trung binh +/- do lech chuan.
%   - Front Pareto tong hop (Fig. 2): hop nhat (pool) toan bo diem cua 30
%     lan chay/thuat toan, sau do LOC LAI non-dominated -> "reference
%     front" dai dien, on dinh hon nhieu so voi 1 lan chay don le.
%   - Xuat: BangKetQua_30Lan.xlsx, Pareto_Plot.png (ghi de), va in ra
%     console cac so lieu can dua vao bai bao (Bang 3, muc 3.2/3.3, KL).
% =========================================================================
clc;
S = load('Final_Benchmark_Results.mat');

algos = {'mopso','nsga2','pesa2'};
names = {'MOPSO','NSGA-II','PESA-II'};
costsField = struct('mopso','CostsCell_mopso','nsga2','CostsCell_nsga2','pesa2','CostsCell_pesa2');
timeField  = struct('mopso','time_mopso','nsga2','time_nsga2','pesa2','time_pesa2');

% --- 1. POOL TOAN BO DIEM CUA 30 LAN CHAY / THUAT TOAN ---
Pooled = struct();
for a = 1:3
    key = algos{a};
    C = S.(costsField.(key));
    Pooled.(key) = [C{:}];
end
allPooled = [Pooled.mopso, Pooled.nsga2, Pooled.pesa2];
RefPoint = max(allPooled, [], 2)' .* 1.05;
fprintf('Diem tham chieu (nadir) CHUNG: Mass=%.2f kg, Drift=%.5f m\n', RefPoint(1), RefPoint(2));

% --- 2. CHI SO PER-RUN (HV, Spacing, min-mass, min-disp, knee) ---
Stats = struct();
for a = 1:3
    key = algos{a};
    C = S.(costsField.(key));
    nR = numel(C);
    HV = zeros(nR,1); SP = zeros(nR,1);
    minMass = zeros(nR,2); minDisp = zeros(nR,2); knee = zeros(nR,2);
    for r = 1:nR
        c = C{r};
        HV(r) = Hypervolume2D(c, RefPoint);
        SP(r) = SpacingMetric(c);
        [~,i1] = min(c(1,:)); minMass(r,:) = [c(1,i1), c(2,i1)*1000];
        [~,i2] = min(c(2,:)); minDisp(r,:) = [c(1,i2), c(2,i2)*1000];
        c1n = (c(1,:)-min(c(1,:)))/(max(c(1,:))-min(c(1,:))+1e-10);
        c2n = (c(2,:)-min(c(2,:)))/(max(c(2,:))-min(c(2,:))+1e-10);
        [~,ik] = min(sqrt(c1n.^2+c2n.^2));
        knee(r,:) = [c(1,ik), c(2,ik)*1000];
    end
    Stats.(key).HV = HV; Stats.(key).SP = SP;
    Stats.(key).minMass = minMass; Stats.(key).minDisp = minDisp; Stats.(key).knee = knee;
    [~, ibest] = min(minMass(:,1));
    Stats.(key).minMass_best = minMass(ibest,:);
    [~, ibest2] = min(minDisp(:,2));
    Stats.(key).minDisp_best = minDisp(ibest2,:);
end

% --- 3. FRONT PARETO TONG HOP (pool 30 lan -> loc non-dominated) ---
NDFront = struct();
for a = 1:3
    key = algos{a};
    NDFront.(key) = FilterNonDominated(Pooled.(key));
end

% --- 4. KNEE-POINT TREN FRONT TONG HOP (dai dien, on dinh) ---
KneePooled = struct();
for a = 1:3
    key = algos{a};
    c = NDFront.(key);
    c1n = (c(1,:)-min(c(1,:)))/(max(c(1,:))-min(c(1,:))+1e-10);
    c2n = (c(2,:)-min(c(2,:)))/(max(c(2,:))-min(c(2,:))+1e-10);
    [~,ik] = min(sqrt(c1n.^2+c2n.^2));
    KneePooled.(key) = [c(1,ik), c(2,ik)*1000];
end

% --- 5. IN KET QUA RA CONSOLE (de doi chieu voi bai bao) ---
fprintf('\n=== 5.1 MIN-MASS (best cua 30 lan; TB +/- SD qua 30 lan) ===\n');
for a = 1:3
    key = algos{a};
    m = Stats.(key).minMass;
    fprintf('%-8s best=%.2f kg (drift=%.3f mm) | TB=%.2f+/-%.2f kg, drift TB=%.3f+/-%.3f mm\n', ...
        names{a}, Stats.(key).minMass_best(1), Stats.(key).minMass_best(2), ...
        mean(m(:,1)), std(m(:,1)), mean(m(:,2)), std(m(:,2)));
end

fprintf('\n=== 5.2 MIN-DISPLACEMENT (best cua 30 lan; TB +/- SD) ===\n');
for a = 1:3
    key = algos{a};
    d = Stats.(key).minDisp;
    fprintf('%-8s best drift=%.3f mm (mass=%.2f kg) | TB drift=%.3f+/-%.3f mm, mass TB=%.2f+/-%.2f kg\n', ...
        names{a}, Stats.(key).minDisp_best(2), Stats.(key).minDisp_best(1), ...
        mean(d(:,2)), std(d(:,2)), mean(d(:,1)), std(d(:,1)));
end

fprintf('\n=== 5.3 KNEE-POINT (per-run TB +/- SD | tren front tong hop 30 lan) ===\n');
for a = 1:3
    key = algos{a};
    k = Stats.(key).knee;
    fprintf('%-8s per-run TB=%.2f+/-%.2f kg, %.3f+/-%.3f mm | pooled-front=%.2f kg, %.3f mm\n', ...
        names{a}, mean(k(:,1)), std(k(:,1)), mean(k(:,2)), std(k(:,2)), ...
        KneePooled.(key)(1), KneePooled.(key)(2));
end

fprintf('\n=== 5.4 HYPERVOLUME & SPACING (TB +/- SD qua 30 lan) ===\n');
for a = 1:3
    key = algos{a};
    fprintf('%-8s HV=%.2f+/-%.2f | Spacing=%.4f+/-%.4f | so nghiem TB/lan=%.1f\n', ...
        names{a}, mean(Stats.(key).HV), std(Stats.(key).HV), ...
        mean(Stats.(key).SP), std(Stats.(key).SP), ...
        mean(cellfun(@(c) size(c,2), S.(costsField.(key)))));
end

fprintf('\n=== 5.5 THOI GIAN CHAY (giay, qua 30 lan) ===\n');
TimeTable = table();
for a = 1:3
    key = algos{a};
    t = S.(timeField.(key));
    fprintf('%-8s mean=%.2f | std=%.2f | min=%.2f | max=%.2f\n', ...
        names{a}, mean(t), std(t), min(t), max(t));
end

% --- 6. XUAT EXCEL TONG HOP ---
Alg_Col = {}; Metric_Col = {}; Value_Col = [];
for a = 1:3
    key = algos{a};
    rows = {
        'MinMass_best_kg',        Stats.(key).minMass_best(1);
        'MinMass_best_disp_mm',   Stats.(key).minMass_best(2);
        'MinMass_mean_kg',        mean(Stats.(key).minMass(:,1));
        'MinMass_std_kg',         std(Stats.(key).minMass(:,1));
        'MinDisp_best_mm',        Stats.(key).minDisp_best(2);
        'MinDisp_best_mass_kg',   Stats.(key).minDisp_best(1);
        'MinDisp_mean_mm',        mean(Stats.(key).minDisp(:,2));
        'MinDisp_std_mm',         std(Stats.(key).minDisp(:,2));
        'Knee_mean_mass_kg',      mean(Stats.(key).knee(:,1));
        'Knee_std_mass_kg',       std(Stats.(key).knee(:,1));
        'Knee_mean_disp_mm',      mean(Stats.(key).knee(:,2));
        'Knee_std_disp_mm',       std(Stats.(key).knee(:,2));
        'Knee_pooled_mass_kg',    KneePooled.(key)(1);
        'Knee_pooled_disp_mm',    KneePooled.(key)(2);
        'HV_mean',                mean(Stats.(key).HV);
        'HV_std',                 std(Stats.(key).HV);
        'Spacing_mean',           mean(Stats.(key).SP);
        'Spacing_std',            std(Stats.(key).SP);
        'Time_mean_s',            mean(S.(timeField.(key)));
        'Time_std_s',             std(S.(timeField.(key)));
        'Time_min_s',             min(S.(timeField.(key)));
        'Time_max_s',             max(S.(timeField.(key)));
    };
    for i = 1:size(rows,1)
        Alg_Col{end+1,1} = names{a}; %#ok<AGROW>
        Metric_Col{end+1,1} = rows{i,1}; %#ok<AGROW>
        Value_Col(end+1,1) = rows{i,2}; %#ok<AGROW>
    end
end
T = table(Alg_Col, Metric_Col, Value_Col, 'VariableNames', {'Algorithm','Metric','Value'});
if exist('BangKetQua_30Lan.xlsx', 'file'), delete('BangKetQua_30Lan.xlsx'); end
writetable(T, 'BangKetQua_30Lan.xlsx');
disp('>> Da xuat BangKetQua_30Lan.xlsx');

% --- 7. VE LAI HINH 2 (Pareto_Plot.png) TU FRONT TONG HOP 30 LAN ---
figure('Name', 'Pareto Comparison (30 runs, pooled)', 'Position', [100, 100, 850, 650]);
hold on; box on; grid on;

p1 = plot(NDFront.mopso(1,:), NDFront.mopso(2,:)*1000, 'ro', 'MarkerSize', 4, ...
    'MarkerFaceColor', 'r', 'DisplayName', 'MOPSO');
p2 = plot(NDFront.nsga2(1,:), NDFront.nsga2(2,:)*1000, 'bs', 'MarkerSize', 4, ...
    'MarkerFaceColor', 'b', 'DisplayName', 'NSGA-II');
p3 = plot(NDFront.pesa2(1,:), NDFront.pesa2(2,:)*1000, 'g^', 'MarkerSize', 4, ...
    'MarkerFaceColor', 'g', 'DisplayName', 'PESA-II');

pk1 = plot(KneePooled.mopso(1), KneePooled.mopso(2), 'p', ...
    'MarkerSize', 14, 'MarkerEdgeColor', 'k', 'MarkerFaceColor', 'r', 'LineWidth', 1.5, 'DisplayName', 'Knee MOPSO');
pk2 = plot(KneePooled.nsga2(1), KneePooled.nsga2(2), '^', ...
    'MarkerSize', 10, 'MarkerEdgeColor', 'k', 'MarkerFaceColor', 'b', 'LineWidth', 1.5, 'DisplayName', 'Knee NSGA-II');
pk3 = plot(KneePooled.pesa2(1), KneePooled.pesa2(2), 'd', ...
    'MarkerSize', 10, 'MarkerEdgeColor', 'k', 'MarkerFaceColor', 'g', 'LineWidth', 1.5, 'DisplayName', 'Knee PESA-II');

xlabel('Total Structure Mass (kg)', 'FontWeight', 'bold', 'FontSize', 11);
ylabel('Roof Lateral Displacement (mm)', 'FontWeight', 'bold', 'FontSize', 11);
legend([p1, p2, p3, pk1, pk2, pk3], 'Location', 'northeast', 'FontSize', 10);
set(gca, 'LooseInset', get(gca, 'TightInset'));
exportgraphics(gcf, 'Pareto_Plot_30Runs.png', 'Resolution', 300);
disp('>> Da xuat Pareto_Plot_30Runs.png');

save('PostProcess_Results.mat', 'Stats', 'NDFront', 'KneePooled', 'RefPoint');
disp('>> Da luu PostProcess_Results.mat');
end

% ============================= HAM PHU TRO =============================
function hv = Hypervolume2D(F, RefPoint)
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

function nd = FilterNonDominated(F)
% F: 2 x N (minimization). Tra ve cac cot khong bi nguoi khac lam troi (dominated).
    N = size(F,2);
    keep = true(1,N);
    for i = 1:N
        if ~keep(i), continue; end
        for j = 1:N
            if i==j || ~keep(j), continue; end
            % j dominates i neu j <= i o ca 2 truc va < o it nhat 1 truc
            if all(F(:,j) <= F(:,i)) && any(F(:,j) < F(:,i))
                keep(i) = false;
                break;
            end
        end
    end
    nd = F(:, keep);
end
