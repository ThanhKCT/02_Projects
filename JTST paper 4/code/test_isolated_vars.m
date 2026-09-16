% TEST_ISOLATED_VARS  Thay doi TUNG BIEN MOT (giu 3 bien con lai o baseline),
% xac nhan SAP2000 thuc su thay doi dung nhom cau kien tuong ung - yeu cau
% ra soat muc 3 "MUST TEST".
scriptDir = fileparts(mfilename('fullpath'));
addpath(scriptDir);
cfg = project_config_bai6();
[~, ~] = open_Sap2000_v2(cfg.sdb_path, true);

base = cfg.baseline_idx; % [10 10 12 3]

fprintf('--- Baseline ---\n');
[fitBase, dBase] = evaluate_superstructure_design(base, cfg);
fprintf('M_DN=%.2f M_DD=%.2f M_DCT=%.2f M_BMC=%.2f f1=%.2f\n', ...
    dBase.M_DN_kNm, dBase.M_DD_kNm, dBase.M_DCT_kNm, dBase.M_BMC_kNm_per_m, fitBase(1));

fprintf('\n--- Chi doi X1 (h_DN): 10 -> 19 (max) ---\n');
x = base; x(1) = 19;
[fitX1, dX1] = evaluate_superstructure_design(x, cfg);
fprintf('h_DN: %.2f->%.2f | Mu_DN: %.2f->%.2f | f1: %.2f->%.2f\n', ...
    dBase.h_DN, dX1.h_DN, dBase.Mu_DN_kNm, dX1.Mu_DN_kNm, fitBase(1), fitX1(1));
if abs(dX1.Mu_DN_kNm - dBase.Mu_DN_kNm) < 1 || abs(fitX1(1)-fitBase(1)) < 1
    fprintf('CANH BAO: doi X1 nhung Mu_DN/f1 khong doi dang ke -> nghi SAP2000 khong cap nhat dung section DN!\n');
else
    fprintf('OK: X1 thay doi dung lam Mu_DN va f1 thay doi.\n');
end

fprintf('\n--- Chi doi X2 (h_DD): 10 -> 19 (max) ---\n');
x = base; x(2) = 19;
[fitX2, dX2] = evaluate_superstructure_design(x, cfg);
fprintf('h_DD: %.2f->%.2f | Mu_DD: %.2f->%.2f | f1: %.2f->%.2f\n', ...
    dBase.h_DD, dX2.h_DD, dBase.Mu_DD_kNm, dX2.Mu_DD_kNm, fitBase(1), fitX2(1));
if abs(dX2.Mu_DD_kNm - dBase.Mu_DD_kNm) < 1 || abs(fitX2(1)-fitBase(1)) < 1
    fprintf('CANH BAO: doi X2 nhung Mu_DD/f1 khong doi dang ke -> nghi SAP2000 khong cap nhat dung section DD!\n');
else
    fprintf('OK: X2 thay doi dung lam Mu_DD va f1 thay doi.\n');
end

fprintf('\n--- Chi doi X4 (t_BMC): 3 -> 5 (max) ---\n');
x = base; x(4) = 5;
[fitX4, dX4] = evaluate_superstructure_design(x, cfg);
fprintf('t_BMC: %.2f->%.2f | Mu_BMC: %.2f->%.2f | f1: %.2f->%.2f\n', ...
    dBase.t_BMC, dX4.t_BMC, dBase.Mu_BMC_kNm, dX4.Mu_BMC_kNm, fitBase(1), fitX4(1));
if abs(dX4.Mu_BMC_kNm - dBase.Mu_BMC_kNm) < 1 || abs(fitX4(1)-fitBase(1)) < 1
    fprintf('CANH BAO: doi X4 nhung Mu_BMC/f1 khong doi dang ke -> nghi SAP2000 khong cap nhat dung do day BMC!\n');
else
    fprintf('OK: X4 thay doi dung lam Mu_BMC va f1 thay doi.\n');
end

% Kiem tra CHEO: doi X1 khong duoc lam thay doi Mu_DD/Mu_DCT/Mu_BMC (khong
% anh huong nham nhom cau kien khac)
fprintf('\n--- Kiem tra CHEO: doi X1 co lam nham anh huong DD/DCT/BMC khong? ---\n');
if abs(dX1.Mu_DD_kNm - dBase.Mu_DD_kNm) > 1 || abs(dX1.Mu_DCT_kNm - dBase.Mu_DCT_kNm) > 1 || abs(dX1.Mu_BMC_kNm - dBase.Mu_BMC_kNm) > 1
    fprintf('CANH BAO: doi X1 (DN) nhung Mu cua DD/DCT/BMC cung doi theo -> co the bi nham section/mapping!\n');
else
    fprintf('OK: doi X1 CHI anh huong DN, khong lam thay doi DD/DCT/BMC.\n');
end

try, SM.ApplicationExit(); catch, end
