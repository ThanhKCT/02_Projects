% RECOMPUTE_UMAX_SLSDH  Tinh lai U_max/to hop chi phoi cho 3 nghiem dai
% dien A/B/C, CHI dung 20 to hop SLSDH (khop dung co so BAO-SLSDH ma
% evaluate_superstructure_design.m dung that trong campaign cho rang buoc
% g2) - thay vi 408 to hop gop (388 ULSB + 20 SLSDH) ma
% analyze_governing_combos.m ban dau da dung nham cho displacement.
%
% KHONG tinh lai M_DN/M_DD/M_DCT/M_BMC/N_pile (khong bi anh huong boi bug
% nay, vi rang buoc that cua chung (g1/g3/g4) da dung dung co so ULS qua
% BAO-ULSB, va ket qua thuc te da luon ra to hop ULS thang du search co
% gop them SLSDH). Chi cap nhat truong Ugov/CgovU trong
% results/governing_combos_analysis.mat, giu nguyen moi truong khac.
scriptDir = fileparts(mfilename('fullpath'));
addpath(scriptDir);
cfg = project_config_bai6();

R = load(fullfile(scriptDir, 'results', 'representative_solutions.mat'));
idxs = [R.iA, R.iB, R.iC];

old = load(fullfile(scriptDir, 'results', 'governing_combos_analysis.mat'));
results = old.results;

slsdhList = arrayfun(@(i) sprintf('SLSDH-%02d', i), 1:20, 'UniformOutput', false);

[~, ~] = open_Sap2000_v2(cfg.sdb_path, true);

for k = 1:3
    i = idxs(k);
    fprintf('\n=== Nghiem %s: tinh lai U_max (chi 20 to hop SLSDH) ===\n', R.labels{k});

    try, SM.SetModelIsLocked(false); catch, end
    SM.PropFrame.SetRectangle(cfg.sec.DN_name,  cfg.mat.DN_name,  R.T.h_DN_m(i),  cfg.sec.DN_b);
    SM.PropFrame.SetRectangle(cfg.sec.DD_name,  cfg.mat.DD_name,  R.T.h_DD_m(i),  cfg.sec.DD_b);
    SM.PropFrame.SetRectangle(cfg.sec.DCT_name, cfg.mat.DCT_name, R.T.h_DCT_m(i), cfg.sec.DCT_b);
    SM.PropArea.SetShell_1(cfg.sec.BMC_name, 1, false, cfg.mat.BMC_name, 0, R.T.t_BMC_m(i), R.T.t_BMC_m(i));
    SM.Analyze.SetRunCaseFlag('', true, true);
    SM.Analyze.RunAnalysis();

    SM.Results.Setup.DeselectAllCasesAndCombosForOutput();
    for c = 1:numel(slsdhList)
        SM.Results.Setup.SetComboSelectedForOutput(slsdhList{c}, true);
    end

    [Ugov, CgovU] = local_governing_disp(cfg.deck_top_Z);
    fprintf('  U_max=%.4f m (combo %s) [g2 limit = %.4f m]\n', Ugov, CgovU, cfg.U_allow_m);

    fld = sprintf('sol_%s', R.labels{k}(1));
    results.(fld).Ugov_OLD_408combo_BUGGED = results.(fld).Ugov; %#ok<STRNU>
    results.(fld).CgovU_OLD_408combo_BUGGED = results.(fld).CgovU; %#ok<STRNU>
    results.(fld).Ugov = Ugov;
    results.(fld).CgovU = CgovU;
end

save(fullfile(scriptDir, 'results', 'governing_combos_analysis.mat'), 'results', 'R');
fprintf('\nDa cap nhat governing_combos_analysis.mat (U_max/CgovU sua lai, gia tri cu luu vao truong _OLD_408combo_BUGGED de doi chieu).\n');

try, SM.ApplicationExit(); catch, end

function [Ugov, Cgov] = local_governing_disp(deckTopZ)
[~, NumberResults, ObjJ, ~, LoadCase, ~, ~, U1, U2, ~, ~, ~, ~] = ...
    SM.Results.JointDispl('ALL', SM.eItemTypeElm.GroupElm); %#ok<ASGLU>
ObjJ = cellstr(ObjJ);
LoadCase = cellstr(LoadCase);
U1v = double(U1(:)); U2v = double(U2(:));
Ugov = 0; Cgov = '';
for i = 1:NumberResults
    [~, ~, ~, z] = SM.PointObj.GetCoordCartesian(ObjJ{i}); %#ok<ASGLU>
    if abs(z - deckTopZ) < 1e-3
        Uh = sqrt(U1v(i)^2 + U2v(i)^2);
        if Uh > Ugov
            Ugov = Uh; Cgov = LoadCase{i};
        end
    end
end
end
