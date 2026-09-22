% EXPORT_CAMPAIGN_REVIEW  Ve bieu do 20 mat Pareto chong len nhau + mat
% Pareto tong the noi bat, xuat bang CSV mat Pareto tong the (90 diem, gia
% tri X1-X4 that).
resultsDir = 'D:\ResearchLab\02_Projects\02_Projects\JTST paper 4\code\results';
codeDir = 'D:\ResearchLab\02_Projects\02_Projects\JTST paper 4\code';
addpath(codeDir);
cfg = project_config_bai6();

A = load(fullfile(resultsDir, 'campaign_stability_analysis.mat'));
Nrun = 20;

f = figure('Visible','off','Position',[100 100 900 650]);
hold on;
cmap = lines(Nrun);
for r = 1:Nrun
    fname = fullfile(resultsDir, sprintf('Bai6_MOSFOA_Np20_Maxit100_run%02d_FINAL.mat', r));
    S = load(fname);
    scatter(S.REP.pos_fit(:,1), S.REP.pos_fit(:,2), 10, cmap(r,:), 'filled', 'MarkerFaceAlpha', 0.35);
end
scatter(A.paretoFit(:,1), A.paretoFit(:,2), 60, 'k', 'x', 'LineWidth', 1.5);
xlabel('f1 - Khoi luong be tong (Tan)');
ylabel('f2 - \eta_{max}');
title(sprintf('20 lan chay doc lap (mau nhat) + mat Pareto tong the hop nhat (%d diem, X den)', size(A.paretoFit,1)));
grid on;
legend({'20 runs (mau nhat)','Mat Pareto tong the'}, 'Location', 'northeast');
saveas(f, fullfile(resultsDir, 'campaign_20runs_pareto_overlay.png'));
close(f);
fprintf('Da luu bieu do overlay 20 runs.\n');

% Bang mat Pareto tong the, gia tri X that
xi = round(A.paretoPos);
xi = max(cfg.lb, min(cfg.ub, xi));
h_DN  = cfg.X1_list(xi(:,1))';
h_DD  = cfg.X2_list(xi(:,2))';
h_DCT = cfg.X3_list(xi(:,3))';
t_BMC = cfg.X4_list(xi(:,4))';
T = table(h_DN, h_DD, h_DCT, t_BMC, A.paretoFit(:,1), A.paretoFit(:,2), A.paretoRunTag, ...
    'VariableNames', {'h_DN_m','h_DD_m','h_DCT_m','t_BMC_m','f1_khoiluong_Tan','f2_eta_max','TuRun'});
T = sortrows(T, 'f1_khoiluong_Tan');
[~, uidx] = unique(T(:,1:4), 'rows', 'stable');
Tu = T(uidx,:);
outCsv = fullfile(resultsDir, 'campaign_pareto_tongthe_20runs.csv');
writetable(Tu, outCsv);
fprintf('Da xuat %d nghiem Pareto tong the (sau loai trung luoi 0.05m) ra: %s\n', height(Tu), outCsv);
