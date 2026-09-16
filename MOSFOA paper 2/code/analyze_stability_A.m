% ANALYZE_STABILITY_A  Kiem tra nhanh do on dinh cua 20 lan chay A: so
% sanh Repository size va tap nghiem Pareto voi mat Pareto tham chieu that
% (Bruteforce_A_FINAL.mat).

clear; clc;
resultsDir = fullfile(fileparts(mfilename('fullpath')), 'results');
Sref = load(fullfile(resultsDir, 'Bruteforce_A_FINAL.mat'));
refParetoFit = Sref.fit(Sref.paretoMask, :);
refParetoFit = sortrows(refParetoFit, 1);
K = 20;

repoSizes = zeros(K,1);
matchCounts = zeros(K,1); % so diem trong REP khop voi 1 diem tham chieu (dung sai nho)
elapsedMin = zeros(K,1);

for r = 1:K
    f = fullfile(resultsDir, sprintf('MOSFOA2_A_Np8_Maxit20_run%02d_FINAL.mat', r));
    if ~isfile(f)
        fprintf('run%02d: KHONG TIM THAY FILE %s\n', r, f);
        continue;
    end
    S = load(f, 'REP', 'elapsedSec');
    repoSizes(r) = size(S.REP.pos_fit, 1);
    elapsedMin(r) = S.elapsedSec/60;
    % dem so diem trong REP khop voi tap tham chieu (sai so tuong doi <0.1%)
    nMatch = 0;
    for i = 1:size(refParetoFit,1)
        d = abs(S.REP.pos_fit - refParetoFit(i,:)) ./ max(abs(refParetoFit(i,:)), eps);
        found = any(all(d < 1e-3, 2));
        if found, nMatch = nMatch + 1; end
    end
    matchCounts(r) = nMatch;
    fprintf('run%02d: Repository=%2d  khop_tham_chieu=%d/%d  thoi_gian=%.1f phut\n', ...
        r, repoSizes(r), nMatch, size(refParetoFit,1), elapsedMin(r));
end

fprintf('\n=== TONG KET DO ON DINH - CONG TRINH A (20 lan chay) ===\n');
fprintf('Mat Pareto tham chieu (that, vet can): %d diem\n', size(refParetoFit,1));
fprintf('Repository size: mean=%.2f  std=%.3f  min=%d  max=%d\n', mean(repoSizes), std(repoSizes), min(repoSizes), max(repoSizes));
fprintf('So diem tham chieu tim duoc/lan chay: mean=%.2f/%d  std=%.3f  min=%d  max=%d\n', ...
    mean(matchCounts), size(refParetoFit,1), std(matchCounts), min(matchCounts), max(matchCounts));
fprintf('Ty le lan chay tim DU 100%% mat Pareto tham chieu: %d/%d (%.1f%%)\n', ...
    nnz(matchCounts == size(refParetoFit,1)), K, 100*nnz(matchCounts == size(refParetoFit,1))/K);
fprintf('Thoi gian chay: mean=%.1f phut  std=%.1f  min=%.1f  max=%.1f\n', ...
    mean(elapsedMin), std(elapsedMin), min(elapsedMin), max(elapsedMin));
