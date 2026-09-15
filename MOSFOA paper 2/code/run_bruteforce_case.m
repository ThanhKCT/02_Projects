function run_bruteforce_case(proj)
% RUN_BRUTEFORCE_CASE  Vet can toan bo K=33 phuong an catalogue cho 1 cong
% trinh (A hoac B). Day VUA la smoke-test dau tien (K nho, don luong,
% khong can song song), VUA la cach dung nhat de dung Pareto THAT (khong
% phai uoc luong) lam Pareto tham chieu cho campaign MOSFOA sau nay - dung
% theo dung tinh than muc 6.3 de cuong Bai_2.md ("neu khong gian du nho
% thi vet can de xay dung Pareto tham chieu").
%
%   run_bruteforce_case('B')   % chay truoc (theo dung thu tu README)
%   run_bruteforce_case('A')
%
% KHONG gop 2 model - chay rieng tung cong trinh, dung 1 SAP2000 instance
% mo 1 lan duy nhat cho ca 33 phuong an (dung theo dieu khoan bat buoc
% Danh_gia_kha_thi_Bai_2.md muc 2.1/8).
%
% Ket qua luu: code/results/Bruteforce_<proj>_FINAL.mat (X, fit, diagnostic,
% feasMask, paretoMask) - dung lam Pareto tham chieu khi tinh IGD/HV cho
% campaign MOSFOA.

addpath(fileparts(mfilename('fullpath')));
resultsDir = fullfile(fileparts(mfilename('fullpath')), 'results');
if ~exist(resultsDir, 'dir'), mkdir(resultsDir); end
finalFile = fullfile(resultsDir, sprintf('Bruteforce_%s_FINAL.mat', upper(proj)));
if isfile(finalFile)
    fprintf('Da co ket qua vet can: %s - BO QUA, khong chay lai.\n', finalFile);
    return;
end
% BO SUNG (11/09/2026): checkpoint/resume - phat hien SAP2000 COM co the
% treo giua chung (nguyen nhan chua ro, xem sap2000-matlab-optimization-
% lessons) sau ~20 phuong an lien tuc; truoc day mat toan bo tien do neu
% bi kill giua chung vi chi luu 1 lan o cuoi. Gio luu checkpoint sau MOI
% phuong an (ghi atomic tmp-then-movefile).
ckptFile = fullfile(resultsDir, sprintf('Bruteforce_%s_CKPT.mat', upper(proj)));

cfg = project_config(proj);
cat = pile_catalogue_AMACCAO();
K = numel(cat);
fprintf('=== VET CAN cong trinh %s (%s): %d phuong an ===\n', proj, cfg.name, K);

system('taskkill /F /IM SAP2000.exe');
pause(2);

fit = zeros(K,2);
diagAll = cell(K,1);
xStart = 1;
if isfile(ckptFile)
    Sckpt = load(ckptFile);
    fit = Sckpt.fit;
    diagAll = Sckpt.diagAll;
    xStart = Sckpt.lastX + 1;
    fprintf('Tim thay checkpoint - tiep tuc tu x=%d/%d.\n', xStart, K);
end

open_Sap2000_v2(cfg.sdb_path, true);

t0 = tic;
for x = xStart:K
    tEval = tic;
    [fitRow, diag] = evaluate_pile_design(x, proj, [], cat, cfg);
    fit(x,:) = fitRow;
    diagAll{x} = diag;
    fprintf('x=%2d  D=%4dmm t=%3dmm Class=%s  f1=%10.3fT  f2=%7.4fm  feasible=%d  (%.1fs)\n', ...
        x, cat(x).D_mm, cat(x).t_mm, cat(x).Class, fitRow(1), fitRow(2), diag.feasible, toc(tEval));
    tmpCkpt = [ckptFile '.tmp'];
    lastX = x; %#ok<NASGU>
    save(tmpCkpt, 'fit', 'diagAll', 'lastX', '-v7.3');
    movefile(tmpCkpt, ckptFile, 'f');
end
elapsedSec = toc(t0);

feasMask = false(K,1);
for x = 1:K, feasMask(x) = diagAll{x}.feasible; end
F = fit;
F(~feasMask,:) = NaN; % loai infeasible khoi tinh Pareto

paretoMask = false(K,1);
idxFeas = find(feasMask);
Ffeas = F(idxFeas,:);
for i = 1:numel(idxFeas)
    fi = Ffeas(i,:);
    dominated = any(all(Ffeas <= fi, 2) & any(Ffeas < fi, 2));
    paretoMask(idxFeas(i)) = ~dominated;
end

fprintf('\n=== KET QUA VET CAN %s ===\n', proj);
fprintf('So phuong an kha thi: %d / %d\n', nnz(feasMask), K);
fprintf('So nghiem Pareto (tham chieu THAT): %d\n', nnz(paretoMask));
paretoIdx = find(paretoMask);
for i = 1:numel(paretoIdx)
    x = paretoIdx(i);
    fprintf('  Pareto x=%2d D=%4dmm Class=%s  f1=%10.3fT  f2=%7.4fm\n', ...
        x, cat(x).D_mm, cat(x).Class, fit(x,1), fit(x,2));
end

X = (1:K)';
save(finalFile, 'proj', 'cfg', 'cat', 'X', 'fit', 'diagAll', 'feasMask', 'paretoMask', 'elapsedSec', '-v7.3');
fprintf('\nDa luu: %s (%.1f phut)\n', finalFile, elapsedSec/60);
if isfile(ckptFile), delete(ckptFile); end

try, SM.ApplicationExit(false); catch, end
end
