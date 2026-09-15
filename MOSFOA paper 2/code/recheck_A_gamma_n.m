% RECHECK_A_GAMMA_N  Tinh lai tinh kha thi cua 33 phuong an cong trinh A
% voi gamma_n MOI (1,15 thay vi 1,0) - KHONG can chay lai SAP2000, vi
% N_max_T va Rd_T da duoc luu san trong diagnostic cua Bruteforce_A_FINAL.mat
% (ca 2 gia tri nay KHONG phu thuoc gamma_n).

clear; clc;
resultsDir = fullfile(fileparts(mfilename('fullpath')), 'results');
S = load(fullfile(resultsDir, 'Bruteforce_A_FINAL.mat'));
cat = S.cat;
K = numel(cat);
gamma_n_new = 1.15;

fit_new = zeros(K,2);
feasMask_new = false(K,1);
for x = 1:K
    d = S.diagAll{x};
    row = cat(x);
    g1_ok_new = (gamma_n_new * d.N_max_T) <= d.Rd_T;
    % g2, g3, g5 khong phu thuoc gamma_n -> giu nguyen tu diagnostic cu
    feasible_new = g1_ok_new && d.g2_vatlieu_ok && d.g3_benULS_ok && d.g5_chuyenvi_ok;
    feasMask_new(x) = feasible_new;
    if feasible_new
        fit_new(x,:) = [d.f1_T, d.f2_m];
    else
        fit_new(x,:) = [1e12, 1e12];
    end
    changed = (feasible_new ~= d.feasible);
    fprintf('x=%2d D=%4dmm Class=%s  N_max=%.2fT M_max=%.3fTm nFrames=%d Rd=%.2fT (gn*N=%.2f)  g1_cu=%d g1_moi=%d  feasible_cu=%d feasible_moi=%d %s\n', ...
        x, row.D_mm, row.Class, d.N_max_T, d.M_max_Tm, d.n_pile_frames_found, d.Rd_T, gamma_n_new*d.N_max_T, d.g1_dat_nen_ok, g1_ok_new, d.feasible, feasible_new, ...
        ternary(changed, '<<< THAY DOI', ''));
end

fprintf('\n=== TONG KET ===\n');
nOld = 0; for x=1:K, if S.diagAll{x}.feasible, nOld=nOld+1; end; end
fprintf('So phuong an kha thi (gamma_n=1.0, CU)  : %d/%d\n', nOld, K);
fprintf('So phuong an kha thi (gamma_n=1.15, MOI): %d/%d\n', nnz(feasMask_new), K);

% Pareto tham chieu MOI
F = fit_new; F(~feasMask_new,:) = NaN;
paretoMask = false(K,1);
idxFeas = find(feasMask_new);
Ffeas = F(idxFeas,:);
for i = 1:numel(idxFeas)
    fi = Ffeas(i,:);
    dominated = any(all(Ffeas <= fi, 2) & any(Ffeas < fi, 2));
    paretoMask(idxFeas(i)) = ~dominated;
end
fprintf('\nMat Pareto tham chieu MOI (gamma_n=1.15), %d nghiem:\n', nnz(paretoMask));
paretoIdx = find(paretoMask);
for i = 1:numel(paretoIdx)
    x = paretoIdx(i);
    fprintf('  x=%2d D=%4dmm Class=%s  f1=%10.3fT  f2=%7.4fm\n', x, cat(x).D_mm, cat(x).Class, fit_new(x,1), fit_new(x,2));
end

function out = ternary(cond, a, b)
if cond, out = a; else, out = b; end
end
