% EXPORT_CONVERGENCE_DATA  Xuat du lieu hoi tu f1 (BestObjectives cot 1) cua
% ca 20 run, tu dung cac file FINAL.mat da khoa (KHONG tinh lai gi), ra 1
% file CSV de ve hinh (Python) - moi cot la 1 run, moi hang la 1 iteration
% (0..Max_it).
resultsDir = 'D:\ResearchLab\02_Projects\02_Projects\JTST paper 4\code\results';
Nrun = 20;
Max_it = 100;

M = nan(Max_it+1, Nrun);
for r = 1:Nrun
    fname = fullfile(resultsDir, sprintf('Bai6_MOSFOA_Np20_Maxit100_run%02d_FINAL.mat', r));
    S = load(fname, 'History');
    M(:, r) = S.History.BestObjectives(:, 1);
end

iter = (0:Max_it)';
T = array2table([iter, M], 'VariableNames', [{'iteration'}, arrayfun(@(r) sprintf('run%02d', r), 1:Nrun, 'UniformOutput', false)]);
outCsv = fullfile(resultsDir, 'convergence_f1_20runs.csv');
writetable(T, outCsv);
fprintf('Da xuat %s (%d hang x %d run)\n', outCsv, height(T), Nrun);
