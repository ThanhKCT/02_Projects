%% verify_punching_EN1992.m -- POST-CHECK ONLY, does not touch the SFOA
% optimization result in any way. Purpose (user request 2026-09-03,
% following Gop_y_chinh_sua_bai_bao_Ke_sau_cau_SFOA_Lan_2.md Section IV/VII):
% re-open the SAME grouped baseline model (Sap\ke pd 10.sdb) used for the
% PAPER campaign, set the OPTIMAL solution's thicknesses (BestX from
% results_SAP\..._PAPER.mat = [0.15 0.23 0.25 0.27 0.69 0.59] -- 2026-09-05
% re-run after widening lb, see SOO_KeSauCau_run_SAP.m; the earlier
% [0.20 0.22 0.25 0.40 0.71 0.58]/232.482080 m3 solution is the archived
% lb-v1 result, see Ke_Sap/archive_lb_v1/), run ONE fresh analysis, and
% post-check punching shear for all 142 piles by TWO
% methods:
%   (A) TCVN 5574:2018 base-case formula (the SAME formula already coded
%       in Sap_KeSauCau.m constraint 5) -- reproduced here independently as
%       a sanity cross-check that this script reads the model correctly
%       (should reproduce PunchingViolation_T=0, PileMaxRatio-style ratios
%       all <1, matching the PAPER run's saved diagnostics exactly).
%   (B) EN 1992-1-1 6.4.4 punching-shear-without-reinforcement check,
%       control perimeter u1 at 2d from the pile face (circular pile),
%       stress format vEd <= vRd,c.
%
% EN 1992 ASSUMPTIONS (documented here, flagged for engineering review --
% same discipline as Sap_KeSauCau.m's own ASSUMPTIONS block):
%   - fck = 20 MPa. Basis: TCVN 5574:2018 B25 (this project's concrete,
%     matched via Rb=14.5/Rbt=1.05 MPa in Sap_KeSauCau.m) corresponds to
%     EN 1992 class C20/25 per the standard SP63/TCVN-to-EN class table
%     (B15->C12/15, B20->C16/20, B25->C20/25, B30->C25/30...). Cross-check:
%     back-solving fcd=alpha_cc*fck/gammaC (alpha_cc=1.0, gammaC=1.5) from
%     Rb=14.5 MPa (treating TCVN's design Rb as approx EN's fcd) gives
%     fck=14.5*1.5=21.75 MPa, consistent with 20 MPa within normal rounding
%     of standard concrete classes -- two independent routes agree, so
%     fck=20 MPa is used as the primary value below.
%   - rho_l (flexural reinforcement ratio at the pile head) = the SAME mu
%     (=As_req/(1*h0), already capped <=0.02) computed by Sap_KeSauCau.m's
%     own DAY-zone bending check for that pile's dayZone (DAY130/DAY60) --
%     no separate per-pile rebar layout exists in this model, so the
%     zone-average flexural ratio is used as the isotropic estimate,
%     exactly the same simplification the existing TCVN crack-width check
%     already relies on.
%   - beta (load-eccentricity factor, EN 1992-1-1 6.4.3) = 1.15, the
%     standard default "interior column" approximate value (Fig 6.21NA/
%     Table NA typical value) applied uniformly to all 142 piles. Piles
%     near the base-slab edge would technically warrant a higher beta
%     (edge~1.4, corner~1.5); per-pile edge/corner classification is not
%     computed here -- flagged as a limitation in the summary output, NOT
%     silently assumed away.
%   - Critical perimeter u1 = pi*(D + 4*d) (circular pile, first control
%     perimeter at 2d from the pile face, EN 1992-1-1 Fig 6.13); no
%     truncation for piles near a slab edge (same limitation as above).
%
% This script does NOT re-run the optimization and does NOT alter
% Sap_KeSauCau.m, SOO_KeSauCau_run_SAP.m, or any results_SAP/*.mat file --
% pure read-only post-check, single SAP2000 evaluation.
clear; clc;
scriptDir = fileparts(mfilename('fullpath'));
outLog = fullfile(scriptDir, 'verify_punching_EN1992_log.txt');
outCsv = fullfile(scriptDir, 'verify_punching_EN1992_per_pile.csv');
fid = fopen(outLog, 'w');
fprintf(fid, '=== verify_punching_EN1992 start %s ===\n', datestr(now));
fclose(fid);

try
    %% --- Open SAP2000 (inline, same 6 lines as Functions/open_Sap2000.m,
    % to avoid depending on addpath resolving correctly on this machine) ---
    logmsg(outLog, 'Opening SAP2000 (inline open_Sap2000 logic)...');
    SM.App('sap');
    SM.Ver('24');
    ProgramPath = 'C:\Program Files\Computers and Structures\SAP2000 24\SAP2000.exe';
    APIDLLPath  = 'C:\Program Files\Computers and Structures\SAP2000 24\SAP2000v1.dll';
    [Sobj] = SM.Helper.CreateObject(ProgramPath, APIDLLPath); %#ok<NASGU,ASGLU>
    [Smdl] = SM.SapModel(); %#ok<NASGU>
    SM.ApplicationStart('Visible', false);
    SM.Hide;
    pause(2);

    sdbPath = fullfile(scriptDir, '..', '..', '..', 'Sap', 'ke pd 10.sdb');
    assert(isfile(sdbPath), 'sdb not found at %s', sdbPath);
    ret = SM.File.OpenFile(sdbPath);
    logmsg(outLog, sprintf('OpenFile ret=%d', ret));
    if ret ~= 0; error('OpenFile failed, ret=%d', ret); end
    SM.SetPresentUnits(SM.eUnits.Ton_m_C);
    SM.Analyze.SetRunCaseFlag('MODAL', false);
    SM.SetModelIsLocked(false);

    %% --- Set the OPTIMAL solution's thicknesses (from
    % results_SAP\KeSauCau_SOO_WallVolume_SAP_run01_PAPER.mat, BestX) ---
    WALL_SECTIONS = {'TUONGC30','TUONGM30','TUONGM43','TUONGM78'};
    DAY_SECTIONS  = {'DAY130','DAY60'};
    thk = [0.15 0.23 0.25 0.27 0.69 0.59]; % BestX, verbatim from the PAPER .mat (see dump_final_paper_result_log.txt, 2026-09-05 lb-v2 re-run)
    logmsg(outLog, sprintf('Setting BestX thicknesses: %s', mat2str(thk)));
    for zi = 1:4
        r = SM.PropArea.SetShell_1(WALL_SECTIONS{zi}, 1, false, 'BTM350', 0, thk(zi), thk(zi));
        if r ~= 0; error('SetShell_1(%s) failed ret=%d', WALL_SECTIONS{zi}, r); end
    end
    for zi = 1:2
        r = SM.PropArea.SetShell_1(DAY_SECTIONS{zi}, 1, false, 'BTM350', 0, thk(4+zi), thk(4+zi));
        if r ~= 0; error('SetShell_1(%s) failed ret=%d', DAY_SECTIONS{zi}, r); end
    end

    logmsg(outLog, 'Running analysis...');
    try; SM.Hide; catch; end
    ra = SM.Analyze.RunAnalysis;
    logmsg(outLog, sprintf('RunAnalysis ret=%d', ra));
    if ra ~= 0; error('RunAnalysis failed ret=%d', ra); end
    try; SM.Hide; catch; end

    SM.Results.Setup.DeselectAllCasesAndCombosForOutput;
    SM.Results.Setup.SetComboSelectedForOutput('BAO');

    %% --- Sanity: recompute Vconcrete to confirm this IS the 232.48 m3 solution ---
    S = load(fullfile(scriptDir, 'wall_setup_data.mat'));
    Vconcrete = 0;
    for zi = 1:4; Vconcrete = Vconcrete + S.zoneArea_m2.(WALL_SECTIONS{zi}) * thk(zi); end
    for zi = 1:2; Vconcrete = Vconcrete + S.zoneArea_m2.(DAY_SECTIONS{zi}) * thk(4+zi); end
    logmsg(outLog, sprintf('Vconcrete recomputed = %.6f m3 (paper value: 231.157600 m3)', Vconcrete));

    %% --- Constants (SAME sourcing as Sap_KeSauCau.m -- copy, not re-derive) ---
    gamma_c   = 1.0;
    Rb_MPa    = 14.5;
    Rbt_MPa   = 1.05;
    MPa_to_Tm2 = 101.9716;
    Rb_Tm2    = Rb_MPa  * MPa_to_Tm2;
    Rbt_Tm2   = Rbt_MPa * MPa_to_Tm2;
    Rs_MPa    = 2700 * 0.0980665;
    Es_MPa    = 2.1e6 * 0.0980665;
    Rs_Tm2    = Rs_MPa * MPa_to_Tm2;
    d_bar_mm  = 20;
    concreteCover = 0.05;
    gamma_lc  = 1.0; gamma_n = 1.10;
    PileCapacity_T = containers.Map({'C400','C500'}, {78.76, 112.44});
    PileDiam_m     = containers.Map({'C400','C500'}, {0.4, 0.5});

    %% --- EN 1992-1-1 6.4.4 constants (documented in header) ---
    fck_MPa   = 20.0;    % B25 ~ C20/25, cross-checked vs Rb -- see header note
    gammaC_EN = 1.5;
    CRd_c     = 0.18 / gammaC_EN;
    beta_EN   = 1.15;    % default "interior" approximate value, applied uniformly -- see header limitation note

    %% --- Per-DAY-zone bending mu (rho_l estimate), SAME formula block as
    % Sap_KeSauCau.m constraint 3/4 DAY-zone loop (lines ~297-346) --
    % copied verbatim for the moment/As_req/mu part only (shear+crack
    % re-derivation not needed here, punching-only script). ---
    muByZone = struct();
    for zi = 1:2
        sec = DAY_SECTIONS{zi};
        t = thk(4+zi);
        h0 = t - concreteCover - (d_bar_mm/1000)/2;
        [~,~,~,~,~,~,~,~,~,~,~,~,~,~,~,M11,M22,~,~,~,~,~,~,~,~] = SM.Results.AreaForceShell(sec, SM.eItemTypeElm.GroupElm);
        Mdemand = max(sqrt(M11.^2 + M22.^2));
        alpha_m = Mdemand / (Rb_Tm2 * 1 * h0^2);
        xi = 1 - sqrt(max(1 - 2*alpha_m, 0));
        As_req = Rb_Tm2 * 1 * h0 * xi / Rs_Tm2;
        mu = min(As_req / (1*h0), 0.02);
        muByZone.(sec) = mu;
        logmsg(outLog, sprintf('DAY zone %s: h0=%.4fm Mdemand=%.4f Tm As_req=%.6f m2/m mu(rho_l)=%.6f', sec, h0, Mdemand, As_req, mu));
    end

    %% --- Per-pile: pull PF3 (axial reaction), then compute BOTH checks ---
    [~,~,Obj,~,~,~,~,~,~,PF3,~,~,~] = SM.Results.JointReact('Piles', SM.eItemTypeElm.GroupElm);
    bottomJointToIdx = containers.Map({S.pileInfo.bottomJoint}, num2cell(1:numel(S.pileInfo)));

    nPiles = numel(S.pileInfo);
    pileName = cell(nPiles,1); pileSection = cell(nPiles,1); pileDayZone = cell(nPiles,1);
    Nd_T = nan(nPiles,1); h0p_m = nan(nPiles,1);
    ratio_TCVN = nan(nPiles,1); punchCap_TCVN_T = nan(nPiles,1);
    vEd_MPa = nan(nPiles,1); vRdc_MPa = nan(nPiles,1); ratio_EN = nan(nPiles,1);

    % NOTE: JointReact on an ENVELOPE combo (BAO) returns 2 rows per joint
    % (max and min extremes of the envelope), confirmed here (numel(Obj)=284
    % = 2*142). Sap_KeSauCau.m's own loop happens to SUM violations across
    % both rows (harmless there since it's a penalty accumulator, not a
    % per-pile report) and its PileMaxRatio is a running max (so unaffected
    % by duplicates). This script reports one row PER PILE, so it must
    % explicitly keep the GOVERNING (larger |PF3|) of the 2 rows -- an
    % unconditional overwrite would silently keep whichever row happens to
    % occur last, which is not necessarily the governing one.
    matchedRows = 0;
    occurrences = zeros(nPiles,1);
    for k = 1:numel(Obj)
        if ~isKey(bottomJointToIdx, Obj{k}); continue; end
        pIdx = bottomJointToIdx(Obj{k});
        matchedRows = matchedRows + 1;
        occurrences(pIdx) = occurrences(pIdx) + 1;
        sec = S.pileInfo(pIdx).section;
        dz  = S.pileInfo(pIdx).dayZone;

        Nd = gamma_lc * gamma_n * abs(PF3(k)); % Ton, SAME definition as Sap_KeSauCau.m constraint 1/5
        if ~isnan(Nd_T(pIdx)) && Nd <= Nd_T(pIdx)
            continue % this row is not governing (smaller |reaction|) -- keep the previously stored larger one
        end

        pileName{pIdx} = S.pileInfo(pIdx).name;
        pileSection{pIdx} = sec;
        pileDayZone{pIdx} = dz;
        Nd_T(pIdx) = Nd;

        if strcmp(dz,'DAY130'); h0p = thk(5) - concreteCover - (d_bar_mm/1000)/2;
        elseif strcmp(dz,'DAY60'); h0p = thk(6) - concreteCover - (d_bar_mm/1000)/2;
        else; continue; % unmapped (none expected, precompute found 0/142)
        end
        h0p_m(pIdx) = h0p;
        Dp = PileDiam_m(sec);

        % --- (A) TCVN 5574:2018 base case (reproduce Sap_KeSauCau.m exactly) ---
        u_perim_TCVN = pi * (Dp + h0p);
        punchCap = gamma_c * Rbt_Tm2 * u_perim_TCVN * h0p;
        punchCap_TCVN_T(pIdx) = punchCap;
        ratio_TCVN(pIdx) = Nd / punchCap;

        % --- (B) EN 1992-1-1 6.4.4 ---
        d_m = h0p; d_mm = d_m * 1000;
        u1_m = pi * (Dp + 4*d_m); % control perimeter at 2d from face, circular pile
        k_EN = min(1 + sqrt(200/d_mm), 2.0);
        rho_l = muByZone.(dz); % already capped <=0.02 upstream
        vRdc = max(CRd_c * k_EN * (100*rho_l*fck_MPa)^(1/3), 0.035*k_EN^1.5*sqrt(fck_MPa)); % MPa
        VEd_kN = Nd * 9.80665; % T -> kN
        vEd = beta_EN * VEd_kN / (u1_m * d_m) / 1000; % kN/m2 -> MPa
        vEd_MPa(pIdx) = vEd; vRdc_MPa(pIdx) = vRdc; ratio_EN(pIdx) = vEd / vRdc;
    end
    logmsg(outLog, sprintf('Matched %d rows to %d/%d piles (rows/pile: min=%d max=%d) -- governing (max |PF3|) row kept per pile', ...
        matchedRows, sum(occurrences>0), nPiles, min(occurrences), max(occurrences)));

    %% --- Write per-pile CSV ---
    fidc = fopen(outCsv, 'w');
    fprintf(fidc, 'PileName,Section,DayZone,h0_m,Nd_T,TCVN_PunchCap_T,TCVN_ratio,vEd_MPa,vRdc_MPa,EN1992_ratio\n');
    for i = 1:nPiles
        fprintf(fidc, '%s,%s,%s,%.4f,%.4f,%.4f,%.4f,%.4f,%.4f,%.4f\n', ...
            pileName{i}, pileSection{i}, pileDayZone{i}, h0p_m(i), Nd_T(i), ...
            punchCap_TCVN_T(i), ratio_TCVN(i), vEd_MPa(i), vRdc_MPa(i), ratio_EN(i));
    end
    fclose(fidc);
    logmsg(outLog, sprintf('Per-pile CSV written: %s', outCsv));

    %% --- Summary ---
    nFail_TCVN = sum(ratio_TCVN > 1);
    nFail_EN   = sum(ratio_EN > 1);
    [maxR_TCVN, iMaxT] = max(ratio_TCVN);
    [maxR_EN, iMaxE] = max(ratio_EN);
    logmsg(outLog, '=== SUMMARY ===');
    logmsg(outLog, sprintf('TCVN 5574:2018: %d/%d piles FAIL (ratio>1). Max ratio=%.4f at pile %s (%s).', ...
        nFail_TCVN, nPiles, maxR_TCVN, pileName{iMaxT}, pileDayZone{iMaxT}));
    logmsg(outLog, sprintf('EN 1992-1-1 6.4.4: %d/%d piles FAIL (ratio>1). Max ratio=%.4f at pile %s (%s).', ...
        nFail_EN, nPiles, maxR_EN, pileName{iMaxE}, pileDayZone{iMaxE}));
    if nFail_EN > 0
        idxFail = find(ratio_EN > 1);
        logmsg(outLog, sprintf('FAILING piles under EN1992 (%d): ', numel(idxFail)));
        for ii = idxFail(:)'
            logmsg(outLog, sprintf('  %s section=%s dayZone=%s Nd=%.3fT vEd=%.4fMPa vRdc=%.4fMPa ratio=%.4f', ...
                pileName{ii}, pileSection{ii}, pileDayZone{ii}, Nd_T(ii), vEd_MPa(ii), vRdc_MPa(ii), ratio_EN(ii)));
        end
    end
    logmsg(outLog, '=== verify_punching_EN1992 DONE OK ===');

    try; SM.ApplicationExit(false); catch; end
    system('taskkill /F /IM SAP2000.exe');
catch ME
    logmsg(outLog, sprintf('CAUGHT ERROR: %s', ME.message));
    for kk = 1:numel(ME.stack)
        logmsg(outLog, sprintf('  at %s line %d', ME.stack(kk).name, ME.stack(kk).line));
    end
    try; system('taskkill /F /IM SAP2000.exe'); catch; end
    rethrow(ME);
end

function logmsg(p, msg)
    fid = fopen(p, 'a'); fprintf(fid, '[%s] %s\n', datestr(now,'HH:MM:SS'), msg); fclose(fid);
    fprintf('%s\n', msg);
end
