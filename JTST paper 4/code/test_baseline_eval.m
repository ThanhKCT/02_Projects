% TEST_BASELINE_EVAL  Danh gia 1 phuong an baseline (cfg.baseline_idx) va in
% toan bo diagnostic - buoc bat buoc TRUOC khi tin bat ky campaign nao (xem
% README_khung_code_bai6.md muc "Quy trinh chay de xuat", buoc 4).
scriptDir = fileparts(mfilename('fullpath'));
addpath(scriptDir);
cfg = project_config_bai6();

[~, ~] = open_Sap2000_v2(cfg.sdb_path, true);

[fit, diag] = evaluate_superstructure_design(cfg.baseline_idx, cfg);

fprintf('\n=== KET QUA BASELINE (x=%s -> h_DN=%.2f h_DD=%.2f h_DCT=%.2f t_BMC=%.2f) ===\n', ...
    mat2str(cfg.baseline_idx), diag.h_DN, diag.h_DD, diag.h_DCT, diag.t_BMC);
fprintf('fit = [%.4f, %.4f]\n', fit(1), fit(2));
disp(diag);

try, SM.ApplicationExit(); catch, end
