% Tinh lai dung dinh nghia "Pareto coverage" = so nghiem PHAN BIET trong
% 59 nghiem Pareto tham chieu duoc tim thay trong repository, / 59 * 100%.
% KHAC voi "NumExactMatch" da tinh truoc do (dem so MUC repository khop
% VOI BAT KY diem tham chieu nao -- bi chan boi kich thuoc repository=100,
% KHONG bi chan boi 59, va KHONG dam bao la 59 diem PHAN BIET).
resultsDir = 'D:\ResearchLab\02_Projects\02_Projects\MOFDA\Wharf100DWT\results';
bf = load(fullfile(resultsDir, 'Wharf100DWT_BRUTEFORCE_FINAL.mat'), 'ParetoFit');
RefFront = bf.ParetoFit; % 59 x 2
nRef = size(RefFront,1);
fprintf('nRef = %d\n', nRef);

algos = struct('name', {'MOFDA','EMOSFOA'}, 'prefix', {'Wharf100DWT_MOFDA_FULL','Wharf100DWT_EMOSFOA_FULL'}, ...
    'maxit', {50, 250});
Np = 50; Nruns = 30;
covByAlgo = struct();

for a = 1:numel(algos)
    A = algos(a);
    coverage = nan(Nruns,1);
    repoMatchCount = nan(Nruns,1); % so sanh voi cach tinh CU
    repoSize = nan(Nruns,1);
    for r = 1:Nruns
        tag = sprintf('run%02d', r);
        fpath = fullfile(resultsDir, sprintf('%s_Np%d_Maxit%d_%s_FINAL.mat', A.prefix, Np, A.maxit, tag));
        if ~isfile(fpath); continue; end
        R = load(fpath, 'REP');
        fRun = R.REP.pos_fit;
        repoSize(r) = size(fRun,1);

        % Cach CU: dem so MUC repository khop voi BAT KY diem tham chieu
        oldCount = 0;
        for i = 1:size(fRun,1)
            if any(all(abs(RefFront - fRun(i,:)) < 1e-6, 2))
                oldCount = oldCount + 1;
            end
        end
        repoMatchCount(r) = oldCount;

        % Cach DUNG: dem so diem tham chieu PHAN BIET (trong 59) co it
        % nhat 1 nghiem trong repository khop
        covered = false(nRef,1);
        for j = 1:nRef
            if any(all(abs(fRun - RefFront(j,:)) < 1e-6, 2))
                covered(j) = true;
            end
        end
        coverage(r) = sum(covered);
    end
    valid = ~isnan(coverage);
    fprintf('\n=== %s (%d/%d runs) ===\n', A.name, sum(valid), Nruns);
    fprintf('Repo size: mean=%.2f\n', mean(repoSize(valid)));
    fprintf('Cach CU (so muc repository khop, /repo size): mean=%.2f std=%.2f\n', mean(repoMatchCount(valid)), std(repoMatchCount(valid)));
    fprintf('Pareto coverage DUNG (so diem PHAN BIET trong %d, /%d): mean=%.2f std=%.2f => %.2f%% +/- %.2f%%\n', ...
        nRef, nRef, mean(coverage(valid)), std(coverage(valid)), 100*mean(coverage(valid))/nRef, 100*std(coverage(valid))/nRef);
    covByAlgo.(A.name) = coverage(valid);
end

fprintf('\n=== Wilcoxon rank-sum tren Pareto coverage DUNG (MOFDA vs EMOSFOA, 30 vs 30) ===\n');
[p, h, stats] = ranksum(covByAlgo.MOFDA, covByAlgo.EMOSFOA);
fprintf('p=%.6g, h=%d (reject H0 tai alpha=0.05: %d)\n', p, h, h);

% Luu lai file CSV/mat de dung khi sua bai bao (KHONG ghi de file cu, luu
% file moi rieng de con doi chieu)
T = table((1:30)', covByAlgo.MOFDA, covByAlgo.EMOSFOA, 'VariableNames', {'Run','MOFDA_coverage_of_59','EMOSFOA_coverage_of_59'});
outDir = fullfile(resultsDir, 'analysis');
writetable(T, fullfile(outDir, 'pareto_coverage_corrected.csv'));
fid = fopen(fullfile(outDir, 'pareto_coverage_corrected_summary.txt'), 'w');
fprintf(fid, 'Pareto coverage (dung dinh nghia: so nghiem PHAN BIET trong 59 nghiem tham chieu duoc tim thay / 59)\n');
fprintf(fid, 'MOFDA: mean=%.2f/59 (%.2f%%) std=%.2f (%.2f%%)\n', mean(covByAlgo.MOFDA), 100*mean(covByAlgo.MOFDA)/nRef, std(covByAlgo.MOFDA), 100*std(covByAlgo.MOFDA)/nRef);
fprintf(fid, 'EMOSFOA: mean=%.2f/59 (%.2f%%) std=%.2f (%.2f%%)\n', mean(covByAlgo.EMOSFOA), 100*mean(covByAlgo.EMOSFOA)/nRef, std(covByAlgo.EMOSFOA), 100*std(covByAlgo.EMOSFOA)/nRef);
fprintf(fid, 'Wilcoxon rank-sum p=%.6g\n', p);
fclose(fid);
fprintf('Da luu: %s va %s\n', fullfile(outDir,'pareto_coverage_corrected.csv'), fullfile(outDir,'pareto_coverage_corrected_summary.txt'));
