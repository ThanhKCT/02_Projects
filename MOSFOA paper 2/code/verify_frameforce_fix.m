clear; clc;
addpath(fileparts(mfilename('fullpath')));
cfg = project_config('B');
cat = pile_catalogue_AMACCAO();

system('taskkill /F /IM SAP2000.exe');
pause(2);
open_Sap2000_v2(cfg.sdb_path, true);

x = 21; % baseline D700-t110-ClassC
[fit, diag] = evaluate_pile_design(x, 'B', [], cat, cfg);
fprintf('x=%d  f1=%.3fT f2=%.4fm feasible=%d\n', x, fit(1), fit(2), diag.feasible);
fprintf('N_max=%.3fT  M_max=%.3fTm  Rd=%.3fT  gamma_n*N_max=%.3f\n', ...
    diag.N_max_T, diag.M_max_Tm, diag.Rd_T, cfg.gamma_n*diag.N_max_T);
fprintf('g1(dat nen)=%d g2(vat lieu)=%d g3(ben ULS)=%d g5(chuyen vi)=%d\n', ...
    diag.g1_dat_nen_ok, diag.g2_vatlieu_ok, diag.g3_benULS_ok, diag.g5_chuyenvi_ok);

try, SM.ApplicationExit(false); catch, end
