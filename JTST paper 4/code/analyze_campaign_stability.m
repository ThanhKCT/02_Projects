% ANALYZE_CAMPAIGN_STABILITY  Doc toan bo 20 file FINAL cua campaign chinh
% thuc, tong hop thong ke on dinh giua cac lan chay doc lap: kich thuoc
% archive, min/max f1/f2, seed, thoi gian, va kiem tra cac Pareto front co
% hoi tu ve cung 1 vung nghiem hay khong (hop nhat toan bo diem khong bi
% tron lan giua run, roi tinh lai mat Pareto TONG THE tu hop nhat do lam
% chuan tham chieu).
resultsDir = 'D:\ResearchLab\02_Projects\02_Projects\JTST paper 4\code\results';
Nrun = 20;

allRunStats = struct('RunID',{},'Seed',{},'ArchiveSize',{},'ElapsedHr',{}, ...
    'MinF1',{},'MaxF1',{},'MinF2',{},'MaxF2',{}, 'TotalFeasible',{}, 'TotalInfeasible',{});
allPos = []; allFit = []; allRunTag = [];

for r = 1:Nrun
    fname = fullfile(resultsDir, sprintf('Bai6_MOSFOA_Np20_Maxit100_run%02d_FINAL.mat', r));
    if ~isfile(fname)
        fprintf('CANH BAO: khong tim thay %s\n', fname);
        continue;
    end
    S = load(fname);
    fit = S.REP.pos_fit;
    pos = S.REP.pos;

    st.RunID = r;
    if isfield(S, 'rngSeedUsed'), st.Seed = S.rngSeedUsed; else, st.Seed = NaN; end
    st.ArchiveSize = size(fit,1);
    st.ElapsedHr = S.elapsedSec/3600;
    st.MinF1 = min(fit(:,1)); st.MaxF1 = max(fit(:,1));
    st.MinF2 = min(fit(:,2)); st.MaxF2 = max(fit(:,2));
    if isfield(S, 'TotalFeasible'), st.TotalFeasible = S.TotalFeasible; else, st.TotalFeasible = NaN; end
    if isfield(S, 'TotalInfeasible'), st.TotalInfeasible = S.TotalInfeasible; else, st.TotalInfeasible = NaN; end
    allRunStats(end+1) = st; %#ok<SAGROW>

    allPos = [allPos; pos]; %#ok<AGROW>
    allFit = [allFit; fit]; %#ok<AGROW>
    allRunTag = [allRunTag; repmat(r, size(fit,1), 1)]; %#ok<AGROW>
end

fprintf('=== THONG KE TUNG RUN (%d/%d doc duoc) ===\n', numel(allRunStats), Nrun);
fprintf('%-5s %-12s %-6s %-8s %-10s %-10s %-10s %-10s %-9s %-9s\n', ...
    'Run','Seed','ArchSz','Hr','MinF1','MaxF1','MinF2','MaxF2','#Feas','#Infeas');
for i = 1:numel(allRunStats)
    s = allRunStats(i);
    fprintf('%-5d %-12d %-6d %-8.2f %-10.2f %-10.2f %-10.4f %-10.4f %-9d %-9d\n', ...
        s.RunID, s.Seed, s.ArchiveSize, s.ElapsedHr, s.MinF1, s.MaxF1, s.MinF2, s.MaxF2, s.TotalFeasible, s.TotalInfeasible);
end

archSizes = [allRunStats.ArchiveSize];
minF1s = [allRunStats.MinF1];
minF2s = [allRunStats.MinF2];
fprintf('\n=== TOM TAT DO ON DINH (%d runs) ===\n', numel(allRunStats));
fprintf('Kich thuoc archive: mean=%.1f std=%.2f min=%d max=%d\n', mean(archSizes), std(archSizes), min(archSizes), max(archSizes));
fprintf('Min f1 (khoi luong nho nhat tim duoc) moi run: mean=%.2f std=%.4f min=%.2f max=%.2f\n', mean(minF1s), std(minF1s), min(minF1s), max(minF1s));
fprintf('Min f2 (eta nho nhat tim duoc) moi run: mean=%.4f std=%.6f min=%.4f max=%.4f\n', mean(minF2s), std(minF2s), min(minF2s), max(minF2s));

% --- Xay dung mat Pareto TONG THE (hop nhat 20 run, loc non-dominated that su) ---
fprintf('\n=== HOP NHAT 20 RUN -> MAT PARETO TONG THE ===\n');
fprintf('Tong so diem tho hop nhat (co the trung lap giua cac run): %d\n', size(allFit,1));
dom = false(size(allFit,1),1);
for i = 1:size(allFit,1)
    for j = 1:size(allFit,1)
        if i==j, continue; end
        if all(allFit(j,:) <= allFit(i,:)) && any(allFit(j,:) < allFit(i,:))
            dom(i) = true; break;
        end
    end
end
paretoFit = allFit(~dom,:);
paretoPos = allPos(~dom,:);
paretoRunTag = allRunTag(~dom);
fprintf('So diem KHONG BI TROI (mat Pareto tong the tu 20 run): %d\n', size(paretoFit,1));

fprintf('\n--- Dong gop cua tung run vao mat Pareto TONG THE (bao nhieu diem cua run do con SONG SOT sau khi hop nhat) ---\n');
contribCount = zeros(Nrun,1);
for r = 1:Nrun
    contribCount(r) = sum(paretoRunTag == r);
end
for r = 1:Nrun
    fprintf('Run %2d: dong gop %d/%d diem vao mat Pareto tong the\n', r, contribCount(r), sum(allRunTag==r));
end
fprintf('\nSo run co it nhat 1 diem tren mat Pareto tong the: %d/%d\n', sum(contribCount>0), Nrun);

save(fullfile(resultsDir, 'campaign_stability_analysis.mat'), 'allRunStats', 'paretoFit', 'paretoPos', 'paretoRunTag', 'contribCount');
fprintf('\nDa luu campaign_stability_analysis.mat\n');
