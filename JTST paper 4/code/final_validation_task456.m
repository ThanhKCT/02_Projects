% FINAL_VALIDATION_TASK456  Doc lai TRUC TIEP governing_combos_analysis.mat
% (khong dung lai so da tom tat truoc do) de xac nhan Task 4,5,6.
resultsDir = 'D:\ResearchLab\02_Projects\02_Projects\JTST paper 4\code\results';
G = load(fullfile(resultsDir, 'governing_combos_analysis.mat'));

labels = fieldnames(G.results);
fprintf('Cac nghiem co trong governing_combos_analysis.mat: %s\n', strjoin(labels, ', '));

fprintf('\n========== TASK 4: XAC NHAN A/B/C ==========\n');
for i = 1:numel(labels)
    s = G.results.(labels{i});
    etas = [s.etaDN, s.etaDD, s.etaDCT, s.etaBMC];
    [maxEta, maxIdx] = max(etas);
    etaNames = {'DN','DD','DCT','BMC'};
    fprintf('\n--- %s ---\n', labels{i});
    fprintf('  x = %s\n', mat2str(s.x));
    fprintf('  eta_DN=%.4f  eta_DD=%.4f  eta_DCT=%.4f  eta_BMC=%.4f\n', s.etaDN, s.etaDD, s.etaDCT, s.etaBMC);
    fprintf('  eta_max_true = %.4f (cau kien chi phoi: %s)\n', maxEta, etaNames{maxIdx});
    fprintf('  N_pile = %.2f T (combo %s)\n', s.NgovPile, s.CgovPile);
    fprintf('  U_max = %.4f m (combo %s)\n', s.Ugov, s.CgovU);
    fprintf('  Combo chi phoi: M_DN=%s M_DD=%s M_DCT=%s M_BMC=%s\n', s.CgovDN, s.CgovDD, s.CgovDCT, s.CgovBMC);
end

fprintf('\n========== TASK 5: KIEM TRA GOVERNING COMBO CO NGOAI LE KHONG ==========\n');
DCTcombos = cellfun(@(l) G.results.(l).CgovDCT, labels, 'UniformOutput', false);
Pilecombos = cellfun(@(l) G.results.(l).CgovPile, labels, 'UniformOutput', false);
Ucombos = cellfun(@(l) G.results.(l).CgovU, labels, 'UniformOutput', false);
fprintf('M_DCT governing combos (A,B,C): %s -> tat ca giong nhau? %d\n', strjoin(DCTcombos,','), numel(unique(DCTcombos))==1);
fprintf('N_pile governing combos (A,B,C): %s -> tat ca giong nhau? %d\n', strjoin(Pilecombos,','), numel(unique(Pilecombos))==1);
fprintf('U_max governing combos (A,B,C): %s -> tat ca giong nhau? %d\n', strjoin(Ucombos,','), numel(unique(Ucombos))==1);

bmcGoverns = true;
for i = 1:numel(labels)
    s = G.results.(labels{i});
    etas = [s.etaDN, s.etaDD, s.etaDCT, s.etaBMC];
    [~, maxIdx] = max(etas);
    if maxIdx ~= 4
        bmcGoverns = false;
        fprintf('  NGOAI LE: %s KHONG phai BMC chi phoi eta_max (chi phoi boi chi so %d)\n', labels{i}, maxIdx);
    end
end
fprintf('BMC chi phoi eta_max o CA 3 nghiem? %d\n', bmcGoverns);

fprintf('\n========== TASK 6: ENVELOPE vs INDIVIDUAL ==========\n');
% doi chieu voi f2 "search" (tu campaign CSV, cot f2_eta_max) cho dung 3 diem A/B/C
T = readtable(fullfile(resultsDir, 'campaign_pareto_tongthe_20runs.csv'));
[~, iA] = min(T.f1_khoiluong_Tan);
[~, iC] = min(T.f2_eta_max);
f1n = (T.f1_khoiluong_Tan - min(T.f1_khoiluong_Tan)) / (max(T.f1_khoiluong_Tan) - min(T.f1_khoiluong_Tan));
f2n = (T.f2_eta_max - min(T.f2_eta_max)) / (max(T.f2_eta_max) - min(T.f2_eta_max));
[~, iB] = min(sqrt(f1n.^2+f2n.^2));
searchF2 = [T.f2_eta_max(iA), T.f2_eta_max(iB), T.f2_eta_max(iC)];
trueF2 = zeros(1,3);
for i = 1:3
    s = G.results.(labels{i});
    trueF2(i) = max([s.etaDN, s.etaDD, s.etaDCT, s.etaBMC]);
end
fprintf('%-6s %-15s %-15s %-12s\n', 'Nghiem','f2_search(bao)','f2_true(combo)','Chenh lech');
for i = 1:3
    fprintf('%-6s %-15.4f %-15.4f %-12.4f\n', labels{i}, searchF2(i), trueF2(i), searchF2(i)-trueF2(i));
end
