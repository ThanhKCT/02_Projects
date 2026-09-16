% ANALYZE_PILOT  Doc file FINAL cua pilot, in duong cong hoi tu (Repository
% size, BestObjectives) tai cac moc iteration de danh gia Max_it=100 co du
% khong, va in 10 nghiem Pareto dai dien.
S = load('D:\ResearchLab\02_Projects\02_Projects\JTST paper 4\code\results\Bai6_MOSFOA_Np20_Maxit100_run01_FINAL.mat');
H = S.History;

fprintf('=== TONG QUAN ===\n');
fprintf('Npop=%d Max_it=%d elapsedSec=%.1f (%.2f gio)\n', S.Npop, S.Max_it, S.elapsedSec, S.elapsedSec/3600);
fprintf('So nghiem Pareto cuoi: %d\n', size(S.REP.pos,1));

fprintf('\n=== REPOSITORY SIZE & BEST OBJECTIVES theo moc iteration ===\n');
milestones = [1 5 10 20 30 40 50 60 70 80 90 95 99 100 101];
fprintf('%-6s %-6s %-12s %-10s %-10s\n', 'Iter', 'RepSz', 'CumFE', 'min_f1(T)', 'min_f2(eta)');
for m = milestones
    idx = m + 1; % History arrays are 1-indexed with idx=1 = generation 0
    if idx > numel(H.RepositorySize), continue; end
    fprintf('%-6d %-6d %-12d %-10.2f %-10.4f\n', m, H.RepositorySize(idx), H.CumulativeFEs(idx), ...
        H.BestObjectives(idx,1), H.BestObjectives(idx,2));
end

fprintf('\n=== 10 NGHIEM PARETO DAI DIEN (sap theo f1 tang dan) ===\n');
[~, ord] = sort(S.REP.pos_fit(:,1));
posSorted = S.REP.pos(ord,:);
fitSorted = S.REP.pos_fit(ord,:);
n = size(fitSorted,1);
pick = unique(round(linspace(1, n, min(10,n))));
fprintf('%-20s %-10s %-10s\n', 'x(idx)', 'f1(Tan)', 'f2(eta)');
for i = pick
    fprintf('%-20s %-10.2f %-10.4f\n', mat2str(posSorted(i,:)), fitSorted(i,1), fitSorted(i,2));
end

fprintf('\n=== HYPERVOLUME (theo doi tuong, W thich ung noi bo - CHI de xem xu huong) ===\n');
hvIdx = ~isnan(H.Hypervolume);
if any(hvIdx)
    hvVals = H.Hypervolume(hvIdx);
    fprintf('HV dau=%.4f HV cuoi=%.4f (tang %.1f%%)\n', hvVals(1), hvVals(end), 100*(hvVals(end)-hvVals(1))/max(abs(hvVals(1)),eps));
end
