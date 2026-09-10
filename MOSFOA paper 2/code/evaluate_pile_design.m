function [fit, diagnostic] = evaluate_pile_design(x, proj, SapModel, cat, cfg)
% EVALUATE_PILE_DESIGN  Ham muc tieu/fitness cho 1 phuong an thiet ke cua
% 1 cong trinh (A hoac B), theo dung dac ta trong Cong_thuc_Bai_toan_Toi_uu.md.
%
% INPUT
%   x         - chi so nguyen vao bang catalogue cat (1..numel(cat))
%   proj      - 'A' hoac 'B'
%   SapModel  - doi tuong SapModel da mo san (tu open_Sap2000 + OpenFile),
%               MO 1 LAN duy nhat cho ca campaign, KHONG mo lai moi lan goi
%               ham nay (dat trong vong lap chinh, xem README).
%   cat       - bang catalogue (pile_catalogue_AMACCAO())
%   cfg       - cau hinh cong trinh (project_config(proj))
%
% OUTPUT
%   fit        - [f1, f2] (khoi luong Tan, chuyen vi ngang max met)
%                = [1e12, 1e12] neu vi pham bat ky rang buoc cung (phat cung)
%   diagnostic - struct chua tat ca gia tri trung gian de kiem tra/ghi log
%
% Nguyen tac xu ly nghiem khong kha thi: PHAT CUNG (khong dung ham phat
% mem cong don), dung theo Danh_gia_kha_thi_Bai_2.md muc 4.4.

row = cat(x);
D_m = row.D_mm/1000;
t_m = row.t_mm/1000;

diagnostic = struct('x', x, 'D_mm', row.D_mm, 't_mm', row.t_mm, 'Class', row.Class);

% ---------------------------------------------------------------------
% 1) Tham so hoa: ghi tiet dien coc moi vao SAP2000 (chi doi D,t; GIU
%    NGUYEN toan bo bo tri/toa do coc - dung theo quyet dinh da chot).
% ---------------------------------------------------------------------
% QUAN TRONG (phat hien 10/09/2026 - xem README muc "Ket qua kiem thu live"):
% SAP2000 KHOA (lock) model sau khi da RunAnalysis mot lan. Neu vong lap
% toi uu goi lai evaluate_pile_design nhieu lan tren CUNG mot SapModel da
% phan tich, SetPipe se tra ve ret~=0 tru khi mo khoa truoc. Luon goi
% SetModelIsLocked(false) truoc SetPipe cho MOI lan danh gia.
try
    SM.SetModelIsLocked(false);
catch
    % Ham nay co the khong ton tai o mot so ban SM.*/OAPI cu - bo qua neu loi,
    % SetPipe ben duoi se tu bao that bai neu model van con khoa.
end

% TODO xac nhan: tham so cua SetPipe la (SectionName, MatProp, t3=D_ngoai,
% tw=chieu day) theo don vi mo hinh hien tai (m). Kiem tra lai dung ten
% material (cfg.material_name) da khai bao trong SapModel truoc khi chay
% chinh thuc - hien la placeholder cho cong trinh A.
ret = SM.PropFrame.SetPipe(cfg.pile_section_name, cfg.material_name, D_m, t_m);
if ret ~= 0
    warning('SetPipe that bai (ret=%d) cho x=%d - coi nhu khong kha thi.', ret, x);
    fit = [1e12, 1e12];
    diagnostic.error = 'SetPipe_failed';
    return;
end

% ---------------------------------------------------------------------
% 2) Chay phan tich
% ---------------------------------------------------------------------
% ⚠️ CANH BAO CHUA GIAI QUYET (10/09/2026): trong moi truong test cua tac
% gia, mot lan RunAnalysis THAT (tren model chua tung phan tich) qua SM.*
% qua COM tu dong hoa (khong tuong tac) bi TREO VINH VIEN (CPU dung yen,
% khong bao gio tra ket qua) - nghi ngo deadlock COM/message-pump khi chay
% headless, KHONG PHAI loi cu phap. Truoc khi dung ham nay cho toi uu that,
% BAT BUOC nguoi dung tu chay thu 1 lan tren may cua minh (mo MATLAB binh
% thuong, KHONG qua tool tu dong hoa) de xac nhan RunAnalysis tra ket qua
% trong thoi gian hop ly. Xem chi tiet: code/README_khung_code.md.
SM.Analyze.SetRunCaseFlag('', true, true);
ret = SM.Analyze.RunAnalysis();
if ret ~= 0
    warning('RunAnalysis that bai (ret=%d) cho x=%d.', ret, x);
    fit = [1e12, 1e12];
    diagnostic.error = 'RunAnalysis_failed';
    return;
end

% ---------------------------------------------------------------------
% 3) Trich N_max, M_max (bao cac to hop trong cfg.combo_list_for_axial)
%    tren cac frame dung tiet dien coc (cfg.pile_section_name).
% ---------------------------------------------------------------------
% TODO xac nhan: cach loc "frame nao la coc" dang gia dinh MOI frame dung
% dung section cfg.pile_section_name deu la coc can kiem tra - kiem tra
% lai neu section nay con dung cho cau kien khac.
[~, NumberNames, AllFrameNames] = SM.FrameObj.GetNameList();
AllFrameNames = local_tocellstr(AllFrameNames);
pileFrames = {};
for i = 1:NumberNames
    [~, secName] = SM.FrameObj.GetSection(AllFrameNames{i});
    if strcmpi(secName, cfg.pile_section_name)
        pileFrames{end+1} = AllFrameNames{i}; %#ok<AGROW>
    end
end
diagnostic.n_pile_frames_found = numel(pileFrames);

N_max = 0; M_max = 0; % gia tri tuyet doi lon nhat tim duoc
SM.Results.Setup.DeselectAllCasesAndCombosForOutput();
for k = 1:numel(cfg.combo_list_for_axial)
    SM.Results.Setup.SetComboSelectedForOutput(cfg.combo_list_for_axial{k}, true);
end
for i = 1:numel(pileFrames)
    [ret, NumberResults, ~, ~, ~, ~, ~, ~, P, ~, ~, M2, M3, ~, ~] = ...
        SM.Results.FrameForce(pileFrames{i}, SM.eItemTypeElm.ObjectElm); %#ok<ASGLU>
    if NumberResults > 0
        Pv  = local_tonumeric(P);
        M2v = local_tonumeric(M2);
        M3v = local_tonumeric(M3);
        N_max = max(N_max, max(abs(Pv)));
        Mres = sqrt(M2v.^2 + M3v.^2);
        M_max = max(M_max, max(Mres));
    end
end
diagnostic.N_max_T = N_max;
diagnostic.M_max_Tm = M_max;

% ---------------------------------------------------------------------
% 4) Trich U_max ngang tai to hop khong che chuyen vi (cfg.combo_governing_disp)
%    tai cac nut dinh ben (Z = cfg.deck_top_Z).
% ---------------------------------------------------------------------
SM.Results.Setup.DeselectAllCasesAndCombosForOutput();
SM.Results.Setup.SetComboSelectedForOutput(cfg.combo_governing_disp, true);
[~, NumberResults, ObjJ, ~, ~, ~, ~, U1, ~, ~, ~, ~, ~] = SM.Results.JointDispl('ALL', SM.eItemTypeElm.ObjectElm); %#ok<ASGLU>
ObjJ = local_tocellstr(ObjJ);
U1v  = local_tonumeric(U1);
U_max = 0;
for i = 1:NumberResults
    [~, ~, ~, z] = SM.PointObj.GetCoordCartesian(ObjJ{i}); %#ok<ASGLU>
    if abs(z - cfg.deck_top_Z) < 1e-3   % chi xet nut tai cao do dinh ben
        U_max = max(U_max, abs(U1v(i)));
    end
end
diagnostic.U_max_m = U_max;

% ---------------------------------------------------------------------
% 5) Tinh f1 (khoi luong), f2 (chuyen vi)
% ---------------------------------------------------------------------
f1 = cfg.N_pile * cfg.rho_bt_Tm3 * row.A_shaft_m2 * cfg.L_pile_m;   % Tan
f2 = U_max;                                                          % m
diagnostic.f1_T = f1;
diagnostic.f2_m = f2;

% ---------------------------------------------------------------------
% 6) Tinh Rd(D) theo cong thuc dong (TCVN 10304:2025) va kiem tra rang buoc
% ---------------------------------------------------------------------
Rk_kN = cfg.qb_tip_kPa * row.A_tip_m2 + row.u_m * cfg.sum_fi_hi_kPa_m; % qc=gR,R=gR,f=1.0
Rk_T  = Rk_kN * 0.101972;
Rd_T  = Rk_T / cfg.gamma_k;
diagnostic.Rk_T = Rk_T;
diagnostic.Rd_T = Rd_T;

g1_ok = (cfg.gamma_n * N_max) <= Rd_T;                       % dat nen
g2_ok = isnan(row.Pmax_T_lo) || (N_max <= row.Pmax_T_hi);    % vat lieu - nen (dung can tren neu co)
Mu_T_m  = row.Mu_kNm  * 0.101972;
Mcr_T_m = row.Mcr_kNm * 0.101972;
g3_ok = isnan(Mu_T_m)  || (M_max <= Mu_T_m);                 % ben (ULS)
g4_ok = true; % Mcr (SLS, tuy chon) - KHONG bat buoc theo dac ta, xem Cong_thuc_Bai_toan_Toi_uu.md muc 4.2
g5_ok = f2 <= cfg.U_limit_m;                                 % chuyen vi van hanh

diagnostic.g1_dat_nen_ok   = g1_ok;
diagnostic.g2_vatlieu_ok   = g2_ok;
diagnostic.g3_benULS_ok    = g3_ok;
diagnostic.g5_chuyenvi_ok  = g5_ok;
diagnostic.Mcr_check_Tm    = Mcr_T_m; % chi de tham khao, khong dung phat

feasible = g1_ok && g2_ok && g3_ok && g5_ok;
diagnostic.feasible = feasible;

if feasible
    fit = [f1, f2];
else
    fit = [1e12, 1e12];  % PHAT CUNG - loai khoi Pareto ngay
end

end
