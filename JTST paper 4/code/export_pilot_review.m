% EXPORT_PILOT_REVIEW  Xuat bang day du 76 nghiem Pareto (gia tri X1-X4 THAT,
% khong phai chi so) ra CSV + ve Pareto front (f1 vs f2) ra PNG, phuc vu
% nguoi dung xem lai ky truoc khi chot campaign dai ngay.
S = load('D:\ResearchLab\02_Projects\02_Projects\JTST paper 4\code\results\Bai6_MOSFOA_Np20_Maxit100_run01_FINAL.mat');
addpath('D:\ResearchLab\02_Projects\02_Projects\JTST paper 4\code');
cfg = project_config_bai6();

pos = S.REP.pos;
fit = S.REP.pos_fit;
n = size(pos,1);

xi = round(pos);
xi = max(cfg.lb, min(cfg.ub, xi));
h_DN  = cfg.X1_list(xi(:,1))';
h_DD  = cfg.X2_list(xi(:,2))';
h_DCT = cfg.X3_list(xi(:,3))';
t_BMC = cfg.X4_list(xi(:,4))';

T = table(h_DN, h_DD, h_DCT, t_BMC, fit(:,1), fit(:,2), ...
    'VariableNames', {'h_DN_m','h_DD_m','h_DCT_m','t_BMC_m','f1_khoiluong_Tan','f2_eta_max'});
T = sortrows(T, 'f1_khoiluong_Tan');
% loai trung lap sau khi lam tron (nhieu diem lien tuc co the trung 1 luoi 0.05m)
[~, uidx] = unique(T(:,1:4), 'rows', 'stable');
Tu = T(uidx,:);

outCsv = 'D:\ResearchLab\02_Projects\02_Projects\JTST paper 4\code\results\pilot_pareto_review.csv';
writetable(Tu, outCsv);
fprintf('Da xuat %d nghiem Pareto (sau khi loai trung lap luoi 0.05m tu %d diem tho) ra: %s\n', height(Tu), n, outCsv);

f = figure('Visible','off');
scatter(fit(:,1), fit(:,2), 40, 'filled');
xlabel('f1 - Khoi luong be tong (Tan)');
ylabel('f2 - \eta_{max} (he so khai thac)');
title(sprintf('Pareto front pilot Bai 6 (Npop=%d, Max\\_it=%d, %d nghiem)', S.Npop, S.Max_it, n));
grid on;
outPng = 'D:\ResearchLab\02_Projects\02_Projects\JTST paper 4\code\results\pilot_pareto_front.png';
saveas(f, outPng);
fprintf('Da luu hinh Pareto front: %s\n', outPng);
close(f);
