% ANALYZE_GOVERNING_COMBOS  Cho 3 nghiem Pareto dai dien (A/B/C, da chon o
% select_representative_solutions.m), tach rieng DAY DU 410 to hop tai
% trong (388 ULSB + 20 SLSDH, KHONG dung combo bao) de xac dinh to hop nao
% chi phoi M/N/U cho tung nghiem - theo dung de cuong muc 11.4/13.7.
scriptDir = fileparts(mfilename('fullpath'));
addpath(scriptDir);
cfg = project_config_bai6();

R = load(fullfile(scriptDir, 'results', 'representative_solutions.mat'));
idxs = [R.iA, R.iB, R.iC];

comboList = [arrayfun(@(i) sprintf('ULSB-%03d', i), 1:388, 'UniformOutput', false), ...
             arrayfun(@(i) sprintf('SLSDH-%02d', i), 1:20, 'UniformOutput', false)];

[~, ~] = open_Sap2000_v2(cfg.sdb_path, true);

results = struct();
for k = 1:3
    i = idxs(k);
    xi = [find(cfg.X1_list==R.T.h_DN_m(i)), find(cfg.X2_list==R.T.h_DD_m(i)), ...
          find(cfg.X3_list==R.T.h_DCT_m(i)), find(cfg.X4_list==R.T.t_BMC_m(i))];

    fprintf('\n=== Nghiem %s: x=%s ===\n', R.labels{k}, mat2str(xi));

    try, SM.SetModelIsLocked(false); catch, end
    SM.PropFrame.SetRectangle(cfg.sec.DN_name,  cfg.mat.DN_name,  R.T.h_DN_m(i),  cfg.sec.DN_b);
    SM.PropFrame.SetRectangle(cfg.sec.DD_name,  cfg.mat.DD_name,  R.T.h_DD_m(i),  cfg.sec.DD_b);
    SM.PropFrame.SetRectangle(cfg.sec.DCT_name, cfg.mat.DCT_name, R.T.h_DCT_m(i), cfg.sec.DCT_b);
    SM.PropArea.SetShell_1(cfg.sec.BMC_name, 1, false, cfg.mat.BMC_name, 0, R.T.t_BMC_m(i), R.T.t_BMC_m(i));
    SM.Analyze.SetRunCaseFlag('', true, true);
    SM.Analyze.RunAnalysis();

    % --- Chon TOAN BO 410 to hop (khong dung combo bao) ---
    SM.Results.Setup.DeselectAllCasesAndCombosForOutput();
    for c = 1:numel(comboList)
        SM.Results.Setup.SetComboSelectedForOutput(comboList{c}, true);
    end

    [MgovDN,  CgovDN]  = local_governing_frame_moment(cfg.sec.DN_name);
    [MgovDD,  CgovDD]  = local_governing_frame_moment(cfg.sec.DD_name);
    [MgovDCT, CgovDCT] = local_governing_frame_moment(cfg.sec.DCT_name);
    [MgovBMC, CgovBMC] = local_governing_area_moment(cfg.sec.BMC_name);
    [NgovPile, CgovPile] = local_governing_pile_axial(cfg.sec.pile_name);

    % --- U_max: rieng cho g2, CHI 20 to hop SLSDH (khop dung co so
    % BAO-SLSDH ma evaluate_superstructure_design.m dung that trong
    % campaign, xem dong 98) - KHONG dung ca 408 to hop gop nhu M/N o
    % tren, vi se lan mot to hop ULS (tai lon hon) vao ket qua
    % displacement SLS-only, cho ra Umax vuot gioi han g2 mot cach gia
    % tao (khong phai vi pham that).
    slsdhList = arrayfun(@(i) sprintf('SLSDH-%02d', i), 1:20, 'UniformOutput', false);
    SM.Results.Setup.DeselectAllCasesAndCombosForOutput();
    for c = 1:numel(slsdhList)
        SM.Results.Setup.SetComboSelectedForOutput(slsdhList{c}, true);
    end
    [Ugov, CgovU] = local_governing_disp(cfg.deck_top_Z);

    MuDN  = mu_beam_tcvn5574(cfg.sec.DN_b,  R.T.h_DN_m(i),  cfg);
    MuDD  = mu_beam_tcvn5574(cfg.sec.DD_b,  R.T.h_DD_m(i),  cfg);
    MuDCT = mu_beam_tcvn5574(cfg.sec.DCT_b, R.T.h_DCT_m(i), cfg);
    MuBMC = mu_beam_tcvn5574(1.0, R.T.t_BMC_m(i), cfg);

    fprintf('  M_DN=%.2f kNm (combo %s), eta=%.4f\n', MgovDN, CgovDN, MgovDN/MuDN);
    fprintf('  M_DD=%.2f kNm (combo %s), eta=%.4f\n', MgovDD, CgovDD, MgovDD/MuDD);
    fprintf('  M_DCT=%.2f kNm (combo %s), eta=%.4f\n', MgovDCT, CgovDCT, MgovDCT/MuDCT);
    fprintf('  M_BMC=%.2f kNm/m (combo %s), eta=%.4f\n', MgovBMC, CgovBMC, MgovBMC/MuBMC);
    fprintf('  N_pile=%.2f T (combo %s)\n', NgovPile, CgovPile);
    fprintf('  U_max=%.4f m (combo %s)\n', Ugov, CgovU);

    results.(sprintf('sol_%s', R.labels{k}(1))) = struct('x',xi,'MgovDN',MgovDN,'CgovDN',{CgovDN}, ...
        'MgovDD',MgovDD,'CgovDD',{CgovDD},'MgovDCT',MgovDCT,'CgovDCT',{CgovDCT}, ...
        'MgovBMC',MgovBMC,'CgovBMC',{CgovBMC},'NgovPile',NgovPile,'CgovPile',{CgovPile}, ...
        'Ugov',Ugov,'CgovU',{CgovU}, 'etaDN',MgovDN/MuDN,'etaDD',MgovDD/MuDD,'etaDCT',MgovDCT/MuDCT,'etaBMC',MgovBMC/MuBMC);
end

save(fullfile(scriptDir, 'results', 'governing_combos_analysis.mat'), 'results', 'R');
fprintf('\nDa luu governing_combos_analysis.mat\n');

try, SM.ApplicationExit(); catch, end

% =========================================================================
function [Mgov, Cgov] = local_governing_frame_moment(sectionName)
[~, nFrame, AllFrameNames] = SM.FrameObj.GetNameList();
AllFrameNames = cellstr(AllFrameNames);
Mgov = 0; Cgov = '';
for i = 1:nFrame
    [~, secName] = SM.FrameObj.GetSection(AllFrameNames{i});
    if ~strcmpi(secName, sectionName), continue; end
    [ret, NumberResults, ~, ~, ~, ~, LoadCase, ~, ~, ~, ~, ~, ~, M2, M3] = ...
        SM.Results.FrameForce(AllFrameNames{i}, SM.eItemTypeElm.ObjectElm); %#ok<ASGLU>
    if NumberResults > 0
        LoadCase = cellstr(LoadCase);
        M2v = double(M2(:)); M3v = double(M3(:));
        Mres = sqrt(M2v.^2 + M3v.^2);
        [mx, idx] = max(Mres);
        if mx > Mgov
            Mgov = mx; Cgov = LoadCase{idx};
        end
    end
end
Mgov = Mgov * 9.80665;
end

function [Mgov, Cgov] = local_governing_area_moment(sectionName)
[~, nArea, AllAreaNames] = SM.AreaObj.GetNameList();
AllAreaNames = cellstr(AllAreaNames);
Mgov = 0; Cgov = '';
for i = 1:nArea
    [~, secName] = SM.AreaObj.GetProperty(AllAreaNames{i}); %#ok<ASGLU>
    if ~strcmpi(secName, sectionName), continue; end
    try
        [ret, NumberResults, ~, ~, ~, LoadCase, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, M11, M22] = ...
            SM.Results.AreaForceShell(AllAreaNames{i}, SM.eItemTypeElm.ObjectElm); %#ok<ASGLU>
        if NumberResults > 0
            LoadCase = cellstr(LoadCase);
            M11v = double(M11(:)); M22v = double(M22(:));
            Mres = max(abs(M11v), abs(M22v));
            [mx, idx] = max(Mres);
            if mx > Mgov
                Mgov = mx; Cgov = LoadCase{idx};
            end
        end
    catch
    end
end
Mgov = Mgov * 9.80665;
end

function [Ngov, Cgov] = local_governing_pile_axial(pileSectionName)
[~, nFrame, AllFrameNames] = SM.FrameObj.GetNameList();
AllFrameNames = cellstr(AllFrameNames);
Ngov = 0; Cgov = '';
for i = 1:nFrame
    [~, secName] = SM.FrameObj.GetSection(AllFrameNames{i});
    if ~strcmpi(secName, pileSectionName), continue; end
    [ret, NumberResults, ~, ~, ~, ~, LoadCase, ~, ~, P, ~, ~, ~, ~, ~] = ...
        SM.Results.FrameForce(AllFrameNames{i}, SM.eItemTypeElm.ObjectElm); %#ok<ASGLU>
    if NumberResults > 0
        LoadCase = cellstr(LoadCase);
        Pv = abs(double(P(:)));
        [mx, idx] = max(Pv);
        if mx > Ngov
            Ngov = mx; Cgov = LoadCase{idx};
        end
    end
end
end

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
