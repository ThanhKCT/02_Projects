% FINAL_VALIDATION_BAI6  Kiem tra doc lai TU DAU tu du lieu nguon (KHONG
% dung lai so lieu da tom tat truoc do), phuc vu FINAL_VALIDATION_BAI6.md.
% Chi doc file .mat/.csv da co san - KHONG chay lai optimization, KHONG
% goi SAP2000/COM.
resultsDir = 'D:\ResearchLab\02_Projects\02_Projects\JTST paper 4\code\results';
Nrun = 20;

%% ===================== TASK 1: CAMPAIGN 20 RUNS =====================
fprintf('\n========== TASK 1: CAMPAIGN 20 RUNS ==========\n');
runData = struct('RunID',{},'Npop',{},'Maxit',{},'Seed',{},'TotalFE',{}, ...
    'TotalFeasible',{},'TotalInfeasible',{},'ArchiveSize',{},'BestF1',{},'BestF2',{}, ...
    'StartTime',{},'EndTime',{},'HasHistory',{},'HasArchiveXY',{});

allSeeds = [];
for r = 1:Nrun
    fname = fullfile(resultsDir, sprintf('Bai6_MOSFOA_Np20_Maxit100_run%02d_FINAL.mat', r));
    if ~isfile(fname)
        fprintf('  MISSING: %s\n', fname);
        continue;
    end
    S = load(fname);
    d.RunID = r;
    d.Npop = S.Npop;
    d.Maxit = S.Max_it;
    d.Seed = S.rngSeedUsed;
    d.TotalFE = S.TotalFE;
    d.TotalFeasible = S.TotalFeasible;
    d.TotalInfeasible = S.TotalInfeasible;
    d.ArchiveSize = S.FinalArchiveSize;
    d.BestF1 = S.BestObjective1;
    d.BestF2 = S.BestObjective2;
    d.StartTime = S.RunStartTime;
    d.EndTime = S.RunEndTime;
    d.HasHistory = isfield(S,'History');
    d.HasArchiveXY = isfield(S,'REP') && isfield(S.REP,'pos') && isfield(S.REP,'pos_fit');
    runData(end+1) = d; %#ok<SAGROW>
    allSeeds(end+1) = d.Seed; %#ok<AGROW>
end

fprintf('So run doc duoc: %d/%d\n', numel(runData), Nrun);
fprintf('Tat ca Npop=20? %d   Tat ca Max_it=100? %d\n', ...
    all([runData.Npop]==20), all([runData.Maxit]==100));
totalFEsum = sum([runData.TotalFE]);
fprintf('Tong FE thuc te (tong TotalFE cua 20 run) = %d  (ky vong 20x2020=40400)\n', totalFEsum);
fprintf('So seed KHAC NHAU trong 20 run: %d/%d (phai =20 neu khong trung)\n', numel(unique(allSeeds)), numel(allSeeds));

fprintf('\n--- Bang chi tiet 20 run ---\n');
fprintf('%-5s %-12s %-8s %-9s %-9s %-7s %-10s %-8s\n','Run','Seed','TotalFE','Feasible','Infeas','ArchSz','BestF1','BestF2');
for i = 1:numel(runData)
    d = runData(i);
    fprintf('%-5d %-12d %-8d %-9d %-9d %-7d %-10.2f %-8.4f\n', d.RunID, d.Seed, d.TotalFE, d.TotalFeasible, d.TotalInfeasible, d.ArchiveSize, d.BestF1, d.BestF2);
end

f1s = [runData.BestF1]; f2s = [runData.BestF2]; archs = [runData.ArchiveSize];
fprintf('\n--- FINAL_CAMPAIGN_STATISTICS ---\n');
fprintf('f1_min qua 20 run: min=%.6f max=%.6f mean=%.6f std=%.8f median=%.6f\n', min(f1s), max(f1s), mean(f1s), std(f1s), median(f1s));
fprintf('f2_min qua 20 run: min=%.6f max=%.6f mean=%.6f std=%.8f median=%.6f\n', min(f2s), max(f2s), mean(f2s), std(f2s), median(f2s));
fprintf('ArchiveSize qua 20 run: min=%d max=%d mean=%.2f std=%.4f median=%.1f\n', min(archs), max(archs), mean(archs), std(archs), median(archs));
n2311 = sum(abs(f1s - 2311.93) < 0.01);
fprintf('So run co f1_min = 2311,93 (sai so <0.01): %d/%d\n', n2311, numel(f1s));
fprintf('Gia tri f1_min CHINH XAC tung run (de doi chieu bang mat, khong lam tron):\n');
disp(f1s');

save(fullfile(resultsDir, 'final_validation_task1.mat'), 'runData', 'allSeeds');

%% ===================== TASK 2: PARETO FRONT =====================
fprintf('\n========== TASK 2: PARETO FRONT ==========\n');
T = readtable(fullfile(resultsDir, 'campaign_pareto_tongthe_20runs.csv'));
fprintf('So dong trong CSV (mat Pareto tong the da luu): %d\n', height(T));

% Kiem tra duplicate (theo 4 bien thiet ke, da lam tron luoi 0.05m khi xuat)
[~, uidx] = unique(T(:,{'h_DN_m','h_DD_m','h_DCT_m','t_BMC_m'}), 'rows');
fprintf('So dong SAU KHI loai duplicate (theo X1-X4): %d (neu < %d nghia la CSV van con duplicate)\n', numel(uidx), height(T));

% Kiem tra lai dominance TREN CHINH 90 diem nay (khong doi voi du lieu tho)
f1v = T.f1_khoiluong_Tan; f2v = T.f2_eta_max;
n = height(T);
domFlag = false(n,1);
for i = 1:n
    for j = 1:n
        if i==j, continue; end
        if f1v(j) <= f1v(i) && f2v(j) <= f2v(i) && (f1v(j) < f1v(i) || f2v(j) < f2v(i))
            domFlag(i) = true; break;
        end
    end
end
fprintf('So diem BI TROI trong chinh file CSV da xuat (phai =0 neu CSV dung la mat Pareto that): %d/%d\n', sum(domFlag), n);

[~, iA] = min(f1v);
[~, iC] = min(f2v);
f1n = (f1v - min(f1v)) / (max(f1v) - min(f1v));
f2n = (f2v - min(f2v)) / (max(f2v) - min(f2v));
dist = sqrt(f1n.^2 + f2n.^2);
[~, iB] = min(dist);
fprintf('\nA (min f1) = dong %d: h_DN=%.2f h_DD=%.2f h_DCT=%.2f t_BMC=%.2f f1=%.2f f2=%.4f\n', iA, T.h_DN_m(iA), T.h_DD_m(iA), T.h_DCT_m(iA), T.t_BMC_m(iA), f1v(iA), f2v(iA));
fprintf('B (knee)   = dong %d: h_DN=%.2f h_DD=%.2f h_DCT=%.2f t_BMC=%.2f f1=%.2f f2=%.4f\n', iB, T.h_DN_m(iB), T.h_DD_m(iB), T.h_DCT_m(iB), T.t_BMC_m(iB), f1v(iB), f2v(iB));
fprintf('C (min f2) = dong %d: h_DN=%.2f h_DD=%.2f h_DCT=%.2f t_BMC=%.2f f1=%.2f f2=%.4f\n', iC, T.h_DN_m(iC), T.h_DD_m(iC), T.h_DCT_m(iC), T.t_BMC_m(iC), f1v(iC), f2v(iC));

%% ===================== TASK 3: CONVERGENCE =====================
fprintf('\n========== TASK 3: CONVERGENCE ==========\n');
S1 = load(fullfile(resultsDir, 'Bai6_MOSFOA_Np20_Maxit100_run01_FINAL.mat'));
hasConv = isfield(S1,'History') && isfield(S1.History,'BestObjectives') && isfield(S1.History,'RepositorySize');
fprintf('File FINAL.mat co luu History.BestObjectives + History.RepositorySize theo tung vong lap? %d\n', hasConv);
if hasConv
    fprintf('So diem du lieu hoi tu/run (Max_it+1): %d\n', numel(S1.History.RepositorySize));
    % Tong hop hoi tu qua 20 run: gia tri f1_min tai vong lap 20,50,100 cua MOI run
    milestones = [1 21 51 101];
    fprintf('\nHoi tu min-f1 tai cac moc vong lap (tat ca 20 run):\n');
    fprintf('%-6s','Run');
    for m = milestones, fprintf('iter%-5d', m-1); end
    fprintf('\n');
    convF1 = nan(Nrun, numel(milestones));
    for r = 1:Nrun
        fname = fullfile(resultsDir, sprintf('Bai6_MOSFOA_Np20_Maxit100_run%02d_FINAL.mat', r));
        if ~isfile(fname), continue; end
        Sr = load(fname, 'History');
        fprintf('%-6d', r);
        for mi = 1:numel(milestones)
            m = milestones(mi);
            if m <= numel(Sr.History.BestObjectives)
                v = Sr.History.BestObjectives(m,1);
                convF1(r,mi) = v;
                fprintf('%-9.2f', v);
            else
                fprintf('%-9s','NA');
            end
        end
        fprintf('\n');
    end
    save(fullfile(resultsDir, 'final_validation_convergence.mat'), 'convF1', 'milestones');
else
    fprintf('KHONG du du lieu convergence - se ghi ro trong bao cao, KHONG suy dien.\n');
end

%% ===================== TASK 7 data: reproducibility fields =====================
fprintf('\n========== TASK 7: REPRODUCIBILITY FIELDS (kiem tra tren run01) ==========\n');
flds = fieldnames(S1);
fprintf('Cac truong co trong file FINAL.mat: %s\n', strjoin(flds, ', '));

fprintf('\n===== HOAN THANH SCRIPT PHAN TICH (Task 1,2,3,7 data) =====\n');
