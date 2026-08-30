function [fit, diagnostic] = Sap_KeSauCau(X, timingOnly)
% Sap_KeSauCau  Fitness function for the "Ke sau cau" wall-volume SFOA
% project, driven through an already-open SAP2000 COM session (`SM`,
% injected by open_Sap2000.m -- same pattern as code/SOO_Ke/Ke_Sap/Sap_Ke.m).
%
% Objective: MINIMIZE concrete volume of the 6 wall/base-slab zones (m3),
% computed DIRECTLY from precomputed plan/elevation area x thickness (NOT
% read from SAP2000 -- geometry doesn't change with thickness). Piles are
% fixed (not a design variable) -- see KINH_NGHIEM_TU_DU_AN_KE_SFOA.md.
%
% X columns (thickness, m; DISCRETIZED to 0.01m/10mm multiples inside this
% function before use, per user instruction 2026-08-28 -- "khong the de
% 0,431m ma phai la 0,43; 0,44..."):
%   X1 = TUONGC30, X2 = TUONGM30, X3 = TUONGM43, X4 = TUONGM78 (4 wall zones)
%   X5 = DAY130, X6 = DAY60 (2 base-slab zones)
% GIOCHANXE and piles are NOT design variables -- left as-is in the model.
%
% Requires code/SOO_KeSauCau/Ke_Sap/wall_setup_data.mat (from
% precompute_wall_setup.m, run once 2026-08-28) and the SAP2000 model
% already having Groups TUONGC30/TUONGM30/TUONGM43/TUONGM78/DAY130/DAY60/
% Piles/WallTop (added by that same precompute script, in-place on
% Sap\ke pd 10.sdb -- re-verified against the pre-group ground-truth
% export, joint reaction sums unchanged, see precompute_wall_setup.m's
% header note).
%
% CONSTRAINTS (all sourced, cited by clause -- see the block below each):
%   1. Pile bearing capacity, TCVN 10304:2025 (NOT 2014 -- user explicitly
%      requested the 2025 "Xuat ban lan 2"; the two differ in the final
%      ULS check formula, see the PileCapacity block below). Per-pile,
%      each checked against its OWN capacity (C400 vs C500 differ).
%   2. Lateral (horizontal) displacement, TCVN 11820-5:2021 Bang 12 --
%      |U1| only (global X = the ALD/earth-pressure load direction,
%      confirmed against ke pd 10.s2k's own AREA LOADS - UNIFORM table;
%      NOT sqrt(U1^2+U2^2), U2 is dev tuyen ke / along-length, not wanted
%      per user 2026-08-28), evaluated ONLY at group WallTop (joints at
%      the top edge of the 4 TUONG zones, per user's explicit choice over
%      model-wide max).
%   3-4. Shear + crack width, TCVN 4116:2023 Dieu 8.2.12 / Dieu 9.2 --
%      SAME formulas as code/SOO_Ke/Ke_Sap/Sap_Ke.m (condition 57 for
%      DAY zones as slab-on-pile, condition 58-59 for TUONG zones as
%      cantilever wall), but summed across all 6 independent zones (not
%      "worst of 2 members" like the old 2-member code) since each zone
%      here has its own independent thickness variable.
%   5. Punching, TCVN 5574:2018 base case -- PER PILE, using the h0 of
%      whichever DAY zone (DAY130/DAY60) that specific pile's precomputed
%      dayZone mapping says it sits under (not a single global h0 -- this
%      model has 2 base-slab thicknesses, unlike the old Ke project's one).
%
% ASSUMPTIONS carried over unverified from the old Ke project (flag for
% review, same as that project's own STATUS block): concreteCover=0.05m,
% d_bar_mm=20mm, rebar grade AII (Rs/Es), phi_l=1.0. Crack limit UPDATED
% 2026-08-29 to TCVN 4116:2023 Dieu 9.1.1's own explicit rule (read from
% the actual 2023 PDF, not guessed): "cau kien ... nam trong vung co muc
% nuoc thay doi" (members in a variable-water-level zone, which a ke's
% wall/slab are) -> acr <= 0.2mm flat, replacing the old TCVN 4116-85
% dry/submerged split (0.08/0.10mm). Deliberately NOT using Dieu 9.2.4's
% Bang 23/24 (water-alkalinity/Cl-+SO4 dependent, for "ket cau khoi lon
% chiu ap luc nuoc") -- that needs water-chemistry + cong trinh cap data
% this project doesn't have; user confirmed 2026-08-29 to use the 0.2mm
% rule directly instead of guessing those inputs. Material M350 (Rb/Rbt via B25 mapping) IS confirmed
% for this project (matches "Tuong goc BTCT M350" in the thuyet minh doc
% and the model's own BTM350 material name) -- not carried over blind.
if nargin < 2 || isempty(timingOnly); timingOnly = false; end

WALL_SECTIONS = {'TUONGC30','TUONGM30','TUONGM43','TUONGM78'};
DAY_SECTIONS  = {'DAY130','DAY60'};
scriptDir = fileparts(mfilename('fullpath'));
S = load(fullfile(scriptDir,'wall_setup_data.mat'));
S.wallJointZ = containers.Map(S.wallJointNames_forSave, num2cell(S.wallJointZ_forSave)); % saved as parallel arrays, rebuilt here

%% --- TCVN 4116:2023 coefficients (identical sourcing to Sap_Ke.m's own
% STATUS block -- see that file for the exact clause citations) ---
gamma_n   = 1.10;
gamma_lc  = 1.0;
gamma_b7  = 1.1;
gamma_j   = 1.0;
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
phi_l     = 1.0;
sigma_s_bg_MPa = 20;
delta_crack = 1.0;
eta_crack   = 1.0;
DeltaCr_kho_mm  = 0.20; % TCVN 4116:2023 Dieu 9.1.1, "vung co muc nuoc thay doi" -> 0.2mm flat
DeltaCr_ngap_mm = 0.20; % same rule -- no dry/submerged split in the 2023 version

%% --- TCVN 11820-5:2021 lateral displacement limit (Bang 12, Dieu 8.9) ---
H_wall_m = 4.5; % SOURCED: Ke bao ve_thuyet minh ky thuat.doc, "Tuong goc cao 4.5m"
%   AND independently "Cao trinh dinh ke +5,50m / Cao trinh day tuong goc
%   +1.00m" = 4.5m -- two independent matches in the same doc, 2026-08-28.
DisplacementLimit_mm = min(H_wall_m*1000/300, 100);

%% --- Pile bearing capacity, TCVN 10304:2025 (Xuat ban lan 2) -- NOT the
% 2014 formula. Key difference (confirmed by reading the actual 2025 PDF,
% "TCVN 10304_2025- Thiet ke mong coc.pdf", 2026-08-28): the final ULS
% check (cong thuc 2) is gamma_n*Nd <= Rd = Rk/gamma_k, with NO separate
% "gamma_o" work-condition/redundancy factor like 2014 had (gamma_o=1.15);
% instead gamma_k itself depends on pile count in the group (>=21 piles,
% this model has 142 -> gamma_k=1.4). Rk itself (formula 9) is UNCHANGED
% from 2014's Rc,u, and Bang 2 (qb table) spot-checked identical.
%   D400: Rk=121.30T (SCT coc D400 22m.XLS) -> Rd=Rk/1.4=86.64T ->
%         [Nd]=Rd/gamma_n=86.64/1.10=78.76T
%   D500: Rk=173.17T (SCT coc D500 22m.XLS) -> Rd=173.17/1.4=123.69T ->
%         [Nd]=123.69/1.10=112.44T
% User-confirmed 2026-08-28 to use these 2025-corrected values (NOT the
% 90.58T/129.32T written directly in those XLS files, which are 2014-formula
% results).
PileCapacity_T = containers.Map({'C400','C500'}, {78.76, 112.44});
PileDiam_m     = containers.Map({'C400','C500'}, {0.4, 0.5});

penaltyCoefficient = 1e6;

nInd = size(X,1);
fit = zeros(nInd,1);
diagnostic = nan(nInd,17);
% [Vconcrete_m3, PileBearingViolation_T, PileMaxRatio, LateralDisp_mm, ...
%  DisplacementLimit_mm, LateralViolation_mm, ShearViolation_Tm, ...
%  CrackViolation_mm, PunchingViolation_T, TotalStructuralViolation, ...
%  Penalty, SAPAnalysisExecuted, AllConstraintsSatisfied, ...
%  t1,t2,t3,t4] -- t1..t4 reserved/unused for now (kept for column-count
% stability if more diagnostics are added later without renumbering).

for ix = 1:nInd
    thk = round(X(ix,:)/0.01)*0.01; % discretize to 10mm multiples

    % 2026-08-29 CRITICAL BUG FOUND + FIXED: every SetShell_1 call below
    % was silently FAILING (ret=1, i.e. error -- never checked before) for
    % the entire smoke test + pilot run, because the material name passed
    % was 'M350' but the model's actual material is 'BTM350' (confirmed
    % against ke pd 10.s2k's own AREA SECTION PROPERTIES table). The model
    % NEVER actually changed thickness across evaluations -- RunAnalysis
    % correctly re-solved the SAME unchanged model every time, which is
    % why JointReact/JointDisplAbs/AreaForceShell all returned byte-
    % identical raw results for wildly different X (confirmed via a direct
    % 2-eval test). Vconcrete (computed purely in MATLAB from thk) still
    % varied, and CrackViolation/ShearViolation appeared to vary too --
    % but only because h0 (from thk) feeds those formulas, not because the
    % underlying SAP2000 forces were real. THE ENTIRE SMOKE TEST + PILOT
    % RUN RESULTS ARE INVALID -- discard them, do not use for the paper.
    % Now checking every SetShell_1 return code explicitly so this class
    % of bug (wrong name, wrong material, model still locked, etc.) fails
    % LOUDLY instead of silently producing a frozen, wrong-looking-valid
    % campaign ever again.
    SM.SetModelIsLocked(false);
    SM.SetPresentUnits(SM.eUnits.Ton_m_C);
    for zi = 1:4
        r = SM.PropArea.SetShell_1(WALL_SECTIONS{zi}, 1, false, 'BTM350', 0, thk(zi), thk(zi));
        if r ~= 0
            error('Sap_KeSauCau:SetShellFailed', 'SetShell_1(%s) failed, ret=%d -- model did NOT update.', WALL_SECTIONS{zi}, r);
        end
    end
    for zi = 1:2
        r = SM.PropArea.SetShell_1(DAY_SECTIONS{zi}, 1, false, 'BTM350', 0, thk(4+zi), thk(4+zi));
        if r ~= 0
            error('Sap_KeSauCau:SetShellFailed', 'SetShell_1(%s) failed, ret=%d -- model did NOT update.', DAY_SECTIONS{zi}, r);
        end
    end

    try; SM.Hide; catch; end
    ra = SM.Analyze.RunAnalysis;
    if ra ~= 0
        error('Sap_KeSauCau:RunAnalysisFailed', 'RunAnalysis failed, ret=%d.', ra);
    end
    try; SM.Hide; catch; end

    SM.Results.Setup.DeselectAllCasesAndCombosForOutput;
    SM.Results.Setup.SetComboSelectedForOutput('BAO');

    %% --- Objective: concrete volume (direct, not via SAP2000) ---
    Vconcrete = 0;
    for zi = 1:4; Vconcrete = Vconcrete + S.zoneArea_m2.(WALL_SECTIONS{zi}) * thk(zi); end
    for zi = 1:2; Vconcrete = Vconcrete + S.zoneArea_m2.(DAY_SECTIONS{zi}) * thk(4+zi); end

    %% --- Constraint 1 + 5 shared read: pile axial reactions (Piles group) ---
    [~,~,Obj,~,~,~,~,~,~,PF3,~,~,~] = SM.Results.JointReact('Piles', SM.eItemTypeElm.GroupElm);
    bottomJointToIdx = containers.Map({S.pileInfo.bottomJoint}, num2cell(1:numel(S.pileInfo)));

    PileBearingViolation = 0;
    PileMaxRatio = 0;
    PunchingViolation = 0;
    for k = 1:numel(Obj)
        if ~isKey(bottomJointToIdx, Obj{k}); continue; end
        pIdx = bottomJointToIdx(Obj{k});
        sec = S.pileInfo(pIdx).section;
        cap = PileCapacity_T(sec);
        Nd = gamma_lc * gamma_n * abs(PF3(k));
        PileBearingViolation = PileBearingViolation + max(Nd - cap, 0);
        PileMaxRatio = max(PileMaxRatio, Nd/cap);

        dz = S.pileInfo(pIdx).dayZone;
        if strcmp(dz,'DAY130'); h0p = thk(5) - concreteCover - (d_bar_mm/1000)/2;
        elseif strcmp(dz,'DAY60'); h0p = thk(6) - concreteCover - (d_bar_mm/1000)/2;
        else; continue; % unmapped pile (none expected -- precompute found 0/142)
        end
        Dp = PileDiam_m(sec);
        u_perim = pi * (Dp + h0p);
        punchCap = gamma_c * Rbt_Tm2 * u_perim * h0p;
        PunchingViolation = PunchingViolation + max(abs(PF3(k)) - punchCap, 0);
    end

    %% --- Constraint 2: lateral displacement at wall top (WallTop group) ---
    [~,~,~,~,~,~,~,U1,~,~,~,~,~] = SM.Results.JointDisplAbs('WallTop', SM.eItemTypeElm.GroupElm);
    LateralDisp_mm = max(abs(U1)) * 1000;
    LateralViolation_mm = max(LateralDisp_mm - DisplacementLimit_mm, 0);

    %% --- Constraint 3+4: shear + crack, per zone, summed ---
    ShearViolation_Tm = 0;
    CrackViolation_mm = 0;

    % -- 4 TUONG zones: vertical cantilever, condition (58)-(59), formulas 60-62 --
    for zi = 1:4
        sec = WALL_SECTIONS{zi};
        t = thk(zi);
        h0 = t - concreteCover - (d_bar_mm/1000)/2;
        % 25-output AreaForceShell signature (verified against the real
        % SAP2000 "Element Forces - Area Shells" table column order, and
        % against code/SOO_Ke/Ke_Sap/Sap_Ke.m's own already-fixed call --
        % see that file's 2026-08-28 bug-fix comment for the full story):
        % ret,NumberResults,Obj,Elm,PointElm,LoadCase,StepType,StepNum,
        % F11,F22,F12,FMax,FMin,FAngle,FVM,M11,M22,M12,MMax,MMin,MAngle,
        % V13,V23,VMax,VAngle -- 25 total. An earlier version of this line
        % was missing 2 placeholders (23 tokens, not 25), silently shifting
        % M11/M22/V13/V23 onto FAngle/FVM/MMin/MAngle instead -- caught
        % 2026-08-28 by comparing against "Tinh toan BTCT pd10.xls"' own
        % "tong hop" governing-envelope sheet (Tuong mat ke M~1-3, V~3-7
        % Tonf/m; this bug was reading a flat 0.0000 for all 4 wall zones).
        [~,~,~,~,PointElm_t,~,~,~,~,~,~,~,~,~,~,M11,M22,~,~,~,~,V13,V23,~,~] = SM.Results.AreaForceShell(sec, SM.eItemTypeElm.GroupElm);

        % Base-junction shear exclusion (mục 6.11-style, same principle as
        % the DAY-zone pile exclusion below, applied here at the TUONG
        % zone's own base/junction with the slab): TUONGM78 was found
        % 2026-08-28 to have its shear peak sitting right at its own base
        % joints (z~5.1-5.5, its lowest elevation), ~3-6x the original
        % engineer's "tong hop" reference for zones further from the base
        % (TUONGM30/M43, whose peaks sit near the wall TOP and DO match
        % that reference closely) -- consistent with a plate/shell
        % boundary-layer stress concentration at a rigid, fully-fixed
        % edge, not a real governing section. Standard RC practice checks
        % shear at h0 from the face of a support for exactly this reason
        % (TCVN 4116:2023's own condition 57/58-59 machinery assumes a
        % representative section, not the discontinuity itself).
        % MOMENT is NOT excluded here -- a cantilever's true governing
        % moment legitimately IS at its fixed base (real mechanics, not an
        % artifact), so excluding it would hide the actual critical
        % section instead of a spurious one.
        zAtPoint = nan(numel(PointElm_t),1);
        for p = 1:numel(PointElm_t)
            if isKey(S.wallJointZ, PointElm_t{p}); zAtPoint(p) = S.wallJointZ(PointElm_t{p}); end
        end
        distAboveBase = zAtPoint - S.wallZoneBaseZ.(sec);
        farEnoughBase = distAboveBase >= h0;
        if ~any(farEnoughBase)
            % Zone shorter than h0 (shouldn't happen for real wall
            % thicknesses, but don't silently disable the exclusion --
            % that defeats its purpose, see the DAY-zone fix note below).
            % Fall back to the single point FARTHEST from the base instead.
            farEnoughBase = distAboveBase >= max(distAboveBase) - 1e-9;
        end

        Qdemand = max(sqrt(V13(farEnoughBase).^2 + V23(farEnoughBase).^2));
        Mdemand = max(sqrt(M11.^2 + M22.^2)); % unfiltered -- see note above

        alpha_m = Mdemand / (Rb_Tm2 * 1 * h0^2);
        xi = 1 - sqrt(max(1 - 2*alpha_m, 0));
        As_req = Rb_Tm2 * 1 * h0 * xi / Rs_Tm2;
        mu = min(As_req / (1*h0), 0.02);

        xi_shear = mu * (Rs_Tm2/Rb_Tm2);
        phi2 = 0.5 + 2*xi_shear;
        phi3 = (t >= 0.6)*0.83 + (t < 0.6)*1.0;
        tanBeta = 2 / (1 + Mdemand/max(Qdemand*h0, eps));
        Qb = phi2 * phi3 * gamma_j * Rbt_Tm2 * 1 * h0 * tanBeta;
        ShearDemand = gamma_lc * gamma_n * Qdemand;
        ShearCapacity = gamma_c * gamma_b7 * Qb;
        ShearViolation_Tm = ShearViolation_Tm + max(ShearDemand - ShearCapacity, 0);

        Z = h0 * (1 - 0.5*xi);
        sigma_s_Tm2 = Mdemand / max(As_req*Z, eps);
        sigma_s_MPa = sigma_s_Tm2 / MPa_to_Tm2;
        a_cr_mm = max(delta_crack * phi_l * eta_crack * ((sigma_s_MPa - 0)/Es_MPa) * ...
            7 * (4 - 100*mu) * sqrt(d_bar_mm), 0); % tuong: khong ngap nuoc lien tuc
        CrackViolation_mm = CrackViolation_mm + max(a_cr_mm - gamma_c*DeltaCr_kho_mm, 0);
    end

    % -- 2 DAY zones: slab on pile foundation, condition (57) -- with the
    % near-pile-head shear exclusion (mục 6.11), radius = h0 + D_pile/2
    % using the CORRECT nearest pile's own diameter (0.4 or 0.5m) since
    % this model (unlike the old Ke project) has 2 pile sizes. ---
    for zi = 1:2
        sec = DAY_SECTIONS{zi};
        t = thk(4+zi);
        h0 = t - concreteCover - (d_bar_mm/1000)/2;
        % Same 25-output signature/fix as the TUONG loop above.
        [~,~,~,~,PointElm,~,~,~,~,~,~,~,~,~,~,M11,M22,~,~,~,~,V13,V23,~,~] = SM.Results.AreaForceShell(sec, SM.eItemTypeElm.GroupElm);

        distById = containers.Map(S.dayJointNames, num2cell(S.distToNearestPile));
        diamById = containers.Map(S.dayJointNames, num2cell(S.nearestPileDiam));
        nPts = numel(PointElm);
        distAtPoint = nan(nPts,1); diamAtPoint = nan(nPts,1);
        for p = 1:nPts
            if isKey(distById, PointElm{p})
                distAtPoint(p) = distById(PointElm{p});
                diamAtPoint(p) = diamById(PointElm{p});
            end
        end
        exclusionRadius = h0 + diamAtPoint/2; % per-point, depends on nearest pile's own diameter
        marginToExclusion = distAtPoint - exclusionRadius;
        farEnough = marginToExclusion >= 0;
        if ~any(farEnough)
            % 2026-08-28 fix: for a small zone with dense pile spacing
            % (DAY130: h0=1.24m, exclusion radius ~1.4-1.5m > typical pile
            % spacing there), EVERY point can fall inside the exclusion
            % radius of its own nearest pile -- the old fallback
            % (farEnough=true(...), i.e. disable the filter entirely) was
            % silently defeating the whole exclusion for exactly the zone
            % that needs it most. Use the single point with the LARGEST
            % margin instead (least-excluded, i.e. farthest from being a
            % pure near-pile artifact) rather than giving up filtering.
            farEnough = marginToExclusion >= max(marginToExclusion) - 1e-9;
        end

        Qdemand = max(sqrt(V13(farEnough).^2 + V23(farEnough).^2));
        Mdemand = max(sqrt(M11.^2 + M22.^2)); % moment check unaffected by the pile-shear exclusion

        ShearDemand = gamma_lc * gamma_n * Qdemand;
        ShearCapacity = 0.25 * gamma_c * gamma_b7 * gamma_j * Rbt_Tm2 * 1 * h0;
        ShearViolation_Tm = ShearViolation_Tm + max(ShearDemand - ShearCapacity, 0);

        alpha_m = Mdemand / (Rb_Tm2 * 1 * h0^2);
        xi = 1 - sqrt(max(1 - 2*alpha_m, 0));
        As_req = Rb_Tm2 * 1 * h0 * xi / Rs_Tm2;
        mu = min(As_req / (1*h0), 0.02);
        Z = h0 * (1 - 0.5*xi);
        sigma_s_Tm2 = Mdemand / max(As_req*Z, eps);
        sigma_s_MPa = sigma_s_Tm2 / MPa_to_Tm2;
        a_cr_mm = max(delta_crack * phi_l * eta_crack * ((sigma_s_MPa - sigma_s_bg_MPa)/Es_MPa) * ...
            7 * (4 - 100*mu) * sqrt(d_bar_mm), 0); % day: ngap nuoc (thuy trieu)
        CrackViolation_mm = CrackViolation_mm + max(a_cr_mm - gamma_c*DeltaCr_ngap_mm, 0);
    end

    %% --- Total penalty + fitness ---
    totalStructuralViolation = PileBearingViolation + LateralViolation_mm + ...
        ShearViolation_Tm + CrackViolation_mm + PunchingViolation;
    penalty = penaltyCoefficient * totalStructuralViolation;

    fit(ix) = Vconcrete + penalty;
    diagnostic(ix,:) = [Vconcrete, PileBearingViolation, PileMaxRatio, LateralDisp_mm, ...
        DisplacementLimit_mm, LateralViolation_mm, ShearViolation_Tm, ...
        CrackViolation_mm, PunchingViolation, totalStructuralViolation, ...
        penalty, 1, totalStructuralViolation <= 1e-9, nan, nan, nan, nan];
end

end
