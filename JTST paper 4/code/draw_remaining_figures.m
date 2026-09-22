% DRAW_REMAINING_FIGURES  Ve 2 hinh con thieu (hoi tu 20 run + so sanh A/B/C)
% tu du lieu da co san (final_validation_convergence.mat, governing_combos_
% analysis.mat, campaign_pareto_tongthe_20runs.csv) - KHONG can chay lai gi.
resultsDir = 'D:\ResearchLab\02_Projects\02_Projects\JTST paper 4\code\results';

%% --- Hinh 1: Duong cong hoi tu (20 run chong lop, min-f1 theo vong lap) ---
f = figure('Visible','off','Position',[100 100 800 550]);
hold on;
cmap = lines(20);
for r = 1:20
    fname = fullfile(resultsDir, sprintf('Bai6_MOSFOA_Np20_Maxit100_run%02d_FINAL.mat', r));
    S = load(fname, 'History');
    plot(0:100, S.History.BestObjectives(:,1), 'Color', [cmap(r,:) 0.5], 'LineWidth', 1);
end
xlabel('Vong lap (iteration)');
ylabel('f_1 nho nhat tim duoc (Tan)');
title('Duong cong hoi tu f_1 qua 20 lan chay doc lap');
grid on; box on;
saveas(f, fullfile(resultsDir, 'Hinh_hoitu_20runs.png'));
close(f);
fprintf('Da luu Hinh_hoitu_20runs.png\n');

%% --- Hinh 2: So sanh 3 nghiem dai dien A/B/C (khoi luong + eta tung cau kien) ---
G = load(fullfile(resultsDir, 'governing_combos_analysis.mat'));
labels = {'sol_A','sol_B','sol_C'};
dispLabels = {'A (nhe nhat)','B (can bang)','C (dap ung tot nhat)'};
f1s = zeros(1,3); etaMat = zeros(3,4); % row=nghiem, col=[DN DD DCT BMC]
T = readtable(fullfile(resultsDir, 'campaign_pareto_tongthe_20runs.csv'));
[~, iA] = min(T.f1_khoiluong_Tan); [~, iC] = min(T.f2_eta_max);
f1n = (T.f1_khoiluong_Tan-min(T.f1_khoiluong_Tan))/(max(T.f1_khoiluong_Tan)-min(T.f1_khoiluong_Tan));
f2n = (T.f2_eta_max-min(T.f2_eta_max))/(max(T.f2_eta_max)-min(T.f2_eta_max));
[~, iB] = min(sqrt(f1n.^2+f2n.^2));
f1Vals = [T.f1_khoiluong_Tan(iA), T.f1_khoiluong_Tan(iB), T.f1_khoiluong_Tan(iC)];

for i = 1:3
    s = G.results.(labels{i});
    etaMat(i,:) = [s.etaDN, s.etaDD, s.etaDCT, s.etaBMC];
end

f = figure('Visible','off','Position',[100 100 950 420]);
subplot(1,2,1);
bar(f1Vals, 'FaceColor', [0.2 0.4 0.7]);
set(gca, 'XTickLabel', dispLabels);
ylabel('f_1 - Khoi luong (Tan)');
title('(a) Khoi luong 3 nghiem dai dien');
grid on;

subplot(1,2,2);
bar(etaMat);
set(gca, 'XTickLabel', dispLabels);
ylabel('\eta (he so khai thac)');
legend({'DN','DD','DCT','BMC'}, 'Location', 'northeast');
title('(b) \eta tung nhom cau kien (BMC luon chi phoi)');
grid on;

saveas(f, fullfile(resultsDir, 'Hinh_sosanh_ABC.png'));
close(f);
fprintf('Da luu Hinh_sosanh_ABC.png\n');
