function [fit, diagnostic] = evaluate_superstructure_design(x, cfg)
% EVALUATE_SUPERSTRUCTURE_DESIGN  Ham muc tieu/fitness cho 1 phuong an thiet
% ke he ket cau ben tren cau tau (Bai 6), theo dung dac ta trong
% Cong_thuc_Bai_toan_Toi_uu_Bai6.md.
%
%   x   - [x1,x2,x3,x4] chi so catalogue LIEN TUC (MOSFOA tim trong
%         [cfg.lb, cfg.ub], lam tron o day - giong cach Bai 2 da lam) ->
%         tra ve X1=h_DN, X2=h_DD, X3=h_DCT, X4=t_BMC that (m).
%   cfg - project_config_bai6()
%
% OUTPUT
%   fit        - [f1, f2] = [khoi luong be tong (Tan), eta_max (khong thu nguyen)]
%                = [1e12, 1e12] neu vi pham bat ky rang buoc cung (phat cung,
%                KHONG dung ham phat mem) - dung theo quy uoc da dung o Bai 2.
%   diagnostic - struct chua tat ca gia tri trung gian de kiem tra/ghi log.
%
% Gia dinh: SAP2000 da duoc mo san (open_Sap2000_v2/open_Sap2000_worker_v2)
% tren cfg.sdb_path (BAN LAM VIEC, da fix nut 1945 - xem fix_model_bai6.m)
% TRUOC khi goi ham nay, dung trong vong lap chinh (khong mo lai moi lan goi).

% ---------------------------------------------------------------------
% 0) Lam tron chi so catalogue -> gia tri thuc (m)
% ---------------------------------------------------------------------
xi = round(x);
xi = max(cfg.lb, min(cfg.ub, xi));
X1 = cfg.X1_list(xi(1)); % h_DN
X2 = cfg.X2_list(xi(2)); % h_DD
X3 = cfg.X3_list(xi(3)); % h_DCT
X4 = cfg.X4_list(xi(4)); % t_BMC

diagnostic = struct('x_rounded', xi, 'h_DN', X1, 'h_DD', X2, 'h_DCT', X3, 't_BMC', X4);

% ---------------------------------------------------------------------
% 1) Tham so hoa: ghi tiet dien moi vao SAP2000
% ---------------------------------------------------------------------
try
    SM.SetModelIsLocked(false);
catch
end

ret1 = SM.PropFrame.SetRectangle(cfg.sec.DN_name,  cfg.mat.DN_name,  X1, cfg.sec.DN_b);
ret2 = SM.PropFrame.SetRectangle(cfg.sec.DD_name,  cfg.mat.DD_name,  X2, cfg.sec.DD_b);
ret3 = SM.PropFrame.SetRectangle(cfg.sec.DCT_name, cfg.mat.DCT_name, X3, cfg.sec.DCT_b);
% XAC NHAN LIVE (2026-09-15, test_baseline_eval.m ret4=0, khong loi): chu ky
% SetShell_1(Name,ShellType=1,IncludeDrillingDOF=false,MatProp,MatAngle,X4,X4)
% chay dung tren model nay.
try
    ret4 = SM.PropArea.SetShell_1(cfg.sec.BMC_name, 1, false, cfg.mat.BMC_name, 0, X4, X4);
catch ME4
    ret4 = -1;
    diagnostic.SetShell_error = ME4.message;
end

if ret1 ~= 0 || ret2 ~= 0 || ret3 ~= 0 || ret4 ~= 0
    warning('evaluate_superstructure_design:SetSectionFailed', ...
        'SetRectangle/SetShell that bai (ret=[%d %d %d %d]) cho x=[%s].', ...
        ret1, ret2, ret3, ret4, mat2str(xi));
    fit = [1e12, 1e12];
    diagnostic.error = 'SetSection_failed';
    diagnostic.feasible = false; % SUA 2026-09-16: thieu truong nay o duong return som, gay loi khi mosfoa6_evaluate_batch doc diagI.feasible
    return;
end

% ---------------------------------------------------------------------
% 2) Chay phan tich
% ---------------------------------------------------------------------
SM.Analyze.SetRunCaseFlag('', true, true);
retA = SM.Analyze.RunAnalysis();
if retA ~= 0
    warning('evaluate_superstructure_design:RunAnalysisFailed', 'RunAnalysis that bai (ret=%d) cho x=[%s].', retA, mat2str(xi));
    fit = [1e12, 1e12];
    diagnostic.error = 'RunAnalysis_failed';
    diagnostic.feasible = false; % SUA 2026-09-16: xem ghi chu o nhanh SetSection_failed o tren
    return;
end

% ---------------------------------------------------------------------
% 3) Trich M_Ed lon nhat tren DN/DD/DCT (frame) va BMC (area), to hop BAO-ULSB
% ---------------------------------------------------------------------
SM.Results.Setup.DeselectAllCasesAndCombosForOutput();
SM.Results.Setup.SetComboSelectedForOutput(cfg.combo_ULSB, true);

M_DN  = local_max_frame_moment(cfg.sec.DN_name);
M_DD  = local_max_frame_moment(cfg.sec.DD_name);
M_DCT = local_max_frame_moment(cfg.sec.DCT_name);
[M_BMC_per_m, N_max_pile] = local_area_and_pile(cfg.sec.BMC_name, cfg.sec.pile_name);

diagnostic.M_DN_kNm  = M_DN;
diagnostic.M_DD_kNm  = M_DD;
diagnostic.M_DCT_kNm = M_DCT;
diagnostic.M_BMC_kNm_per_m = M_BMC_per_m;
diagnostic.N_max_pile_T = N_max_pile;

% ---------------------------------------------------------------------
% 4) Trich U_max tai nut dinh ben, to hop BAO-SLSDH
% ---------------------------------------------------------------------
SM.Results.Setup.DeselectAllCasesAndCombosForOutput();
SM.Results.Setup.SetComboSelectedForOutput(cfg.combo_SLSDH, true);
% 'ALL' la TEN NHOM co san cua SAP2000 -> BAT BUOC dung GroupElm (khong phai
% ObjectElm) - loi da gap va sua o Bai 2, xem Kinh nghiem MOSFOA Paper 2.md muc 1.1.
% SUA (2026-09-16, phat hien qua ra soat truoc campaign muc 5): ban truoc
% CHI doc U1 (mot phuong ngang) - neu luc neo tau (NEO1/NEO2) hoac va tau
% theo phuong Y cung nam trong to hop BAO-SLSDH, chuyen vi ngang thuc te co
% the lon hon o phuong U2, bi BO SOT hoan toan. Doc CA U1 va U2, lay hop
% chuyen vi ngang sqrt(U1^2+U2^2) - dung nhat quan voi cach da dung cho
% mo-men (sqrt(M2^2+M3^2)).
[~, NumberResults, ObjJ, ~, ~, ~, ~, U1, U2, ~, ~, ~, ~] = SM.Results.JointDispl('ALL', SM.eItemTypeElm.GroupElm); %#ok<ASGLU>
ObjJ = local_tocellstr(ObjJ);
U1v  = local_tonumeric(U1);
U2v  = local_tonumeric(U2);
U_max = 0;
for i = 1:NumberResults
    [~, ~, ~, z] = SM.PointObj.GetCoordCartesian(ObjJ{i}); %#ok<ASGLU>
    if abs(z - cfg.deck_top_Z) < 1e-3
        Uh = sqrt(U1v(i)^2 + U2v(i)^2);
        U_max = max(U_max, Uh);
    end
end
diagnostic.U_max_m = U_max;

% ---------------------------------------------------------------------
% 4b) KIEM TRA BAO VE - phat hien loi trich xuat COM "im lang" (2026-09-21,
% phat hien qua run20/20 cua campaign chinh thuc: SAP2000 tra ve
% NumberResults=0 cho TOAN BO cac dai luong do 1 truc trac COM thoang qua,
% khong bao loi gi - khien M_DN=M_DD=M_DCT=M_BMC=N_max_pile=U_max=0 dong
% thoi, tao ra fitness "hoan hao gia" (eta_max=0) khien MOSFOA hoi tu sai
% huong, sup archive tu 60 xuong con 2-3 nghiem trong phan con lai cua run).
% Voi 1 ket cau dang chiu tai (tu trong + hoat tai luon > 0), viec CA 6 dai
% luong nay dong thoi bang dung 0 la VO LY VE VAT LY - phai coi la loi
% trich xuat, KHONG phai ket qua that.
if M_DN == 0 && M_DD == 0 && M_DCT == 0 && M_BMC_per_m == 0 && N_max_pile == 0 && U_max == 0
    warning('evaluate_superstructure_design:AllZeroResults', ...
        'M/N/U DEU BANG 0 dong thoi cho x=[%s] - nghi loi trich xuat COM (SAP2000 glitch), coi la infeasible.', mat2str(xi));
    fit = [1e12, 1e12];
    diagnostic.error = 'AllZeroResults_suspected_COM_glitch';
    diagnostic.feasible = false;
    return;
end

% ---------------------------------------------------------------------
% 5) f1 (khoi luong be tong) - dung hang so hinh hoc da do san (khong doi theo x)
% ---------------------------------------------------------------------
f1 = cfg.mat.DN_rho_Tm3  * cfg.sec.DN_b  * X1 * cfg.geom.L_DN_total_m + ...
     cfg.mat.DD_rho_Tm3  * cfg.sec.DD_b  * X2 * cfg.geom.L_DD_total_m + ...
     cfg.mat.DCT_rho_Tm3 * cfg.sec.DCT_b * X3 * cfg.geom.L_DCT_total_m + ...
     cfg.mat.BMC_rho_Tm3 * X4 * cfg.geom.A_BMC_total_m2;
diagnostic.f1_T = f1;

% ---------------------------------------------------------------------
% 6) f2 (eta_max) - Mu theo TCVN 5574:2018 (mu_beam_tcvn5574.m)
% ---------------------------------------------------------------------
Mu_DN  = mu_beam_tcvn5574(cfg.sec.DN_b,  X1, cfg);
Mu_DD  = mu_beam_tcvn5574(cfg.sec.DD_b,  X2, cfg);
Mu_DCT = mu_beam_tcvn5574(cfg.sec.DCT_b, X3, cfg);
Mu_BMC = mu_beam_tcvn5574(1.0, X4, cfg); % dai ban rong 1m

eta_DN  = M_DN  / Mu_DN;
eta_DD  = M_DD  / Mu_DD;
eta_DCT = M_DCT / Mu_DCT;
eta_BMC = M_BMC_per_m / Mu_BMC;

f2 = max([eta_DN, eta_DD, eta_DCT, eta_BMC]);
diagnostic.Mu_DN_kNm = Mu_DN; diagnostic.Mu_DD_kNm = Mu_DD; diagnostic.Mu_DCT_kNm = Mu_DCT; diagnostic.Mu_BMC_kNm = Mu_BMC;
diagnostic.eta_DN = eta_DN; diagnostic.eta_DD = eta_DD; diagnostic.eta_DCT = eta_DCT; diagnostic.eta_BMC = eta_BMC;
diagnostic.f2_eta_max = f2;

% ---------------------------------------------------------------------
% 7) Rang buoc (feasibility) - phat cung
% ---------------------------------------------------------------------
g1_ok = f2 <= 1.0;                                   % khai thac cau kien ben tren
g2_ok = U_max <= cfg.U_allow_m;                      % chuyen vi
% SUA (2026-09-16, phat hien qua ra soat don vi muc 20): 1 Tonf (T) = 1000
% kgf THEO DINH NGHIA (khong can chia them cho g=9,80665 - ca hai deu da
% dung cung gia toc trong dinh nghia). Ban truoc chia thua cho 9,80665 khien
% sigma_pile_kGcm2 SAI THAP HON ~9,81 LAN so voi gia tri that (da xac nhan
% bang so: N_max=220,4T, A=272,1cm2 -> dung phai la ~810 kG/cm2, khong phai
% 82,6 kG/cm2 nhu code cu tra ve).
sigma_pile_kGcm2 = (N_max_pile*1000) / (cfg.pile.A_m2*1e4); % Tonf -> kgf (x1000), m2 -> cm2 (x1e4)
g4_ok = sigma_pile_kGcm2 <= cfg.pile.Fy_kGcm2/cfg.pile.gamma_steel;  % ung suat vat lieu coc
g3_ok = (cfg.gamma_n * N_max_pile) <= cfg.pile.Rd_Tan;               % dia ky thuat (uoc luong, xem spec muc 5)

diagnostic.g1_eta_ok = g1_ok;
diagnostic.g2_chuyenvi_ok = g2_ok;
diagnostic.g3_diakythuat_ok = g3_ok;
diagnostic.g4_ungsuatcoc_ok = g4_ok;
diagnostic.sigma_pile_kGcm2 = sigma_pile_kGcm2;

feasible = g1_ok && g2_ok && g3_ok && g4_ok;
diagnostic.feasible = feasible;

if feasible
    fit = [f1, f2];
else
    fit = [1e12, 1e12];
end

end

% =========================================================================
function Mmax = local_max_frame_moment(sectionName)
% Duyet toan bo frame dung dung sectionName, tra ve max sqrt(M2^2+M3^2)
% (kN.m) tren to hop dang duoc chon o Results.Setup.
% Thu tu cot FrameForce DA XAC NHAN DUNG (Bai 2, sua loi off-by-one):
%   NumberResults,Obj,ObjSta,Elm,ElmSta,LoadCase,StepType,StepNum,P,V2,V3,T,M2,M3
[~, NumberNames, AllFrameNames] = SM.FrameObj.GetNameList();
AllFrameNames = local_tocellstr(AllFrameNames);
Mmax = 0;
for i = 1:NumberNames
    [~, secName] = SM.FrameObj.GetSection(AllFrameNames{i});
    if ~strcmpi(secName, sectionName)
        continue;
    end
    [ret, NumberResults, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, M2, M3] = ...
        SM.Results.FrameForce(AllFrameNames{i}, SM.eItemTypeElm.ObjectElm); %#ok<ASGLU>
    if NumberResults > 0
        M2v = local_tonumeric(M2);
        M3v = local_tonumeric(M3);
        Mres = sqrt(M2v.^2 + M3v.^2);
        Mmax = max(Mmax, max(Mres));
    end
end
% SAP2000 don vi noi bo cua model nay la Tonf-m (xem FEM_Ben70000DWT_ChanMay.md
% muc 2) -> quy doi sang kN.m de dong bo voi Rb/Rs (kPa) trong mu_beam_tcvn5574.
Mmax = Mmax * 9.80665;
end

% =========================================================================
function [M_BMC_per_m, N_max_pile] = local_area_and_pile(bmcSectionName, pileSectionName)
% M_BMC_per_m: max(|M11|,|M22|) tren BMC (kN.m/m). N_max_pile: max |P| tren
% frame Coc1 (Tan).
[~, nArea, AllAreaNames] = SM.AreaObj.GetNameList();
AllAreaNames = local_tocellstr(AllAreaNames);
M_BMC_per_m = 0;
for i = 1:nArea
    [~, secName] = SM.AreaObj.GetProperty(AllAreaNames{i}); %#ok<ASGLU>
    if ~strcmpi(secName, bmcSectionName)
        continue;
    end
    % SUA (2026-09-15, xac nhan LIVE qua diagnose_areaforceshell.m): ham nay
    % co DUNG 25 output that (khong phai 22 nhu suy doan tu tai lieu - khop
    % voi canh bao rieng o "Kinh nghiem SFOA.md" muc 1.3 "AreaForceShell co
    % dung 25 output", co 3 truong them ngoai tai lieu CSI thong thuong).
    % Thu tu 22 truong dau (da doi chieu bang so lieu live, M11 tai vi tri
    % bracket 17, M22 tai 18): NumberResults,Obj,Elm,PointElm,LoadCase,
    % StepType,StepNum,F11,F22,F12,FMax,FMin,FAngle,VMax,VAngle,M11,M22,M12,
    % MMax,MMin,MAngle,(+3 truong chua ro nghia, khong can dung o day).
    try
        [ret, NumberResults, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, M11, M22] = ...
            SM.Results.AreaForceShell(AllAreaNames{i}, SM.eItemTypeElm.ObjectElm); %#ok<ASGLU>
        if NumberResults > 0
            M11v = local_tonumeric(M11);
            M22v = local_tonumeric(M22);
            Mres = max(abs(M11v), abs(M22v));
            M_BMC_per_m = max(M_BMC_per_m, max(Mres));
        end
    catch
        % bo qua neu chua xac nhan dung signature - se bao infeasible o buoc kiem tra ret ben ngoai
    end
end
M_BMC_per_m = M_BMC_per_m * 9.80665; % Tonf.m/m -> kN.m/m

[~, nFrame, AllFrameNames] = SM.FrameObj.GetNameList();
AllFrameNames = local_tocellstr(AllFrameNames);
N_max_pile = 0;
for i = 1:nFrame
    [~, secName] = SM.FrameObj.GetSection(AllFrameNames{i});
    if ~strcmpi(secName, pileSectionName)
        continue;
    end
    % SUA (2026-09-15, phat hien qua test_baseline_eval.m - N_max_pile_T=0):
    % thieu 1 dau ~ truoc P (P la field thu 9: NumberResults,Obj,ObjSta,Elm,
    % ElmSta,LoadCase,StepType,StepNum,P,... - ban truoc chi co 6 dau ~ truoc
    % P nen P bi doc nham tu o cua StepNum, giong het bug da gap o Bai 2).
    [ret, NumberResults, ~, ~, ~, ~, ~, ~, ~, P, ~, ~, ~, ~] = ...
        SM.Results.FrameForce(AllFrameNames{i}, SM.eItemTypeElm.ObjectElm); %#ok<ASGLU>
    if NumberResults > 0
        Pv = local_tonumeric(P);
        N_max_pile = max(N_max_pile, max(abs(Pv)));
    end
end
% N_max_pile da o don vi Tan (Tonf, don vi noi bo model)
end

% =========================================================================
function out = local_tocellstr(x)
if iscellstr(x) %#ok<ISCLSTR>
    out = x;
elseif isstring(x) || ischar(x)
    out = cellstr(x);
else
    try
        out = cellstr(x);
    catch
        out = arrayfun(@char, x, 'UniformOutput', false);
    end
end
end

function out = local_tonumeric(x)
out = double(x);
out = out(:);
end
