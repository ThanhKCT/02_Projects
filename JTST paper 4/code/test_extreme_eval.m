% TEST_EXTREME_EVAL  Kiem tra N_max_pile tai 2 diem bien (nho nhat/lon nhat)
% de xem tai trong cot co thay doi dang ke theo X1-X4 hay khong - phuc vu
% chan doan ràng buoc g3 (216-09-15).
scriptDir = fileparts(mfilename('fullpath'));
addpath(scriptDir);
cfg = project_config_bai6();
[~, ~] = open_Sap2000_v2(cfg.sdb_path, true);

fprintf('--- Diem NHO NHAT (x=[1 1 1 1]) ---\n');
[fitMin, diagMin] = evaluate_superstructure_design([1 1 1 1], cfg);
fprintf('h_DN=%.2f h_DD=%.2f h_DCT=%.2f t_BMC=%.2f -> N_max_pile=%.2f T, f1=%.1f T, eta_max=%.3f\n', ...
    diagMin.h_DN, diagMin.h_DD, diagMin.h_DCT, diagMin.t_BMC, diagMin.N_max_pile_T, diagMin.f1_T, diagMin.f2_eta_max);

fprintf('\n--- Diem LON NHAT (x=[19 19 23 5]) ---\n');
[fitMax, diagMax] = evaluate_superstructure_design([19 19 23 5], cfg);
fprintf('h_DN=%.2f h_DD=%.2f h_DCT=%.2f t_BMC=%.2f -> N_max_pile=%.2f T, f1=%.1f T, eta_max=%.3f\n', ...
    diagMax.h_DN, diagMax.h_DD, diagMax.h_DCT, diagMax.t_BMC, diagMax.N_max_pile_T, diagMax.f1_T, diagMax.f2_eta_max);

try, SM.ApplicationExit(); catch, end
