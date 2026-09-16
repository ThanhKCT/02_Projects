function cfg = project_config_bai6()
% PROJECT_CONFIG_BAI6  Thong so bai toan toi uu he ket cau ben tren cau tau
% (Bai 6 / JTST paper 4), da chot theo Cong_thuc_Bai_toan_Toi_uu_Bai6.md
% (2026-09-15). Doc file do truoc khi sua bat ky hang so nao o day.
%
% ⚠️ Cac gia tri danh dau "DE XUAT/UOC LUONG" trong file spec da duoc
% nguoi dung duyet (Rb, Rs, Rd...) nhung van la CHUOI SUY LUAN/XAP XI, KHONG
% phai so lieu kiem dinh chinh thuc - xem muc 5 file spec truoc khi dua vao
% bai bao chinh thuc.

cfg.name = 'Ben so 1 Chan May 70.000DWT (mo hinh nghien cuu gia dinh) - Bai 6';

% --- Duong dan model (BAN LAM VIEC, KHONG phai file goc trong "Mo hinh SAP")
cfg.sdb_path = fullfile('D:\ResearchLab\02_Projects\02_Projects\JTST paper 4\code\model', 'Ben so 1 Chan May.sdb');
cfg.sdb_baseline_path = fullfile('D:\ResearchLab\02_Projects\02_Projects\JTST paper 4\Mo hinh SAP', 'Ben so 1 Chan May.sdb'); % PRISTINE - khong bao gio ghi de

% --- Ten tiet dien/vat lieu (xac nhan truc tiep tu Ben so 1 Chan May.s2k dong 92/95/98/101) ---
cfg.sec.DN_name  = 'DN';   cfg.sec.DN_b  = 1.00;  cfg.mat.DN_name  = 'M400-DN';  cfg.mat.DN_rho_Tm3  = 1.935;
cfg.sec.DD_name  = 'DD';   cfg.sec.DD_b  = 1.00;  cfg.mat.DD_name  = 'M400-DN';  cfg.mat.DD_rho_Tm3  = 1.935;
cfg.sec.DCT_name = 'DCT';  cfg.sec.DCT_b = 1.30;  cfg.mat.DCT_name = 'M400-DCT'; cfg.mat.DCT_rho_Tm3 = 2.05;
cfg.sec.BMC_name = 'BMC';  cfg.mat.BMC_name = 'M400'; cfg.mat.BMC_rho_Tm3 = 2.50;
cfg.sec.pile_name = 'Coc1'; % D700 t12.6mm trong model FEM (KHONG doi, xem muc 1 spec)

% --- Bien thiet ke X1..X4 (h_DN, h_DD, h_DCT, t_BMC) - roi rac deu buoc 0.05m ---
% Dung dang "danh sach catalogue" + chi so nguyen, GIONG CACH Bai 2 da lam
% (round(x) o buoc danh gia) de dam bao cong bang phuong phap tim kiem voi
% thuat toan MOSFOA (tim lien tuc trong [1,N_i], lam tron khi danh gia).
cfg.X1_list = 1.10:0.05:2.00;  % h_DN  (m), baseline 1.55 -> index 10
cfg.X2_list = 1.10:0.05:2.00;  % h_DD  (m), baseline 1.55 -> index 10
cfg.X3_list = 1.40:0.05:2.50;  % h_DCT (m), baseline 1.95 -> index 12
cfg.X4_list = 0.25:0.05:0.45;  % t_BMC (m), baseline 0.35 -> index 3
cfg.lb = [1 1 1 1];
cfg.ub = [numel(cfg.X1_list) numel(cfg.X2_list) numel(cfg.X3_list) numel(cfg.X4_list)];
cfg.baseline_idx = [10 10 12 3]; % de doi chieu voi model goc (h=1.55,1.55,1.95, t=0.35)

% --- Vat lieu tinh Mu (TCVN 5574:2018), DA DUOC NGUOI DUNG DUYET 2026-09-15 ---
% Rb: be tong M400 quy doi ~B30 (DE XUAT, chua co so lieu Rb rieng cho Chan May)
% Rs: CB300-V tinh toan (DE XUAT, chua xac nhan rieng CB300-V hay CB240-T dung cho DN/DD/DCT)
cfg.mu.Rb_kPa = 17000;      % 17 MPa
cfg.mu.Rs_kPa = 260000;     % 260 MPa (CB300-V, Rs tinh toan ~0.87*300)
cfg.mu.alphaR1 = 0.85;
cfg.mu.sigma_scu_kPa = 500000; % 500 MPa
cfg.mu.cover_m = 0.065;     % a = lop bao ve + duong kinh thanh/2 (uoc luong)

% --- Coc: rang buoc ung suat vat lieu (g4) + dia ky thuat (g3) ---
cfg.pile.D_m = 0.70;
cfg.pile.t_m = 0.0126;      % t=12.6mm nhu trong model FEM (khong phai 14mm danh dinh)
cfg.pile.A_m2 = pi/4*(cfg.pile.D_m^2 - (cfg.pile.D_m-2*cfg.pile.t_m)^2);
cfg.pile.Fy_kGcm2 = 3150;   % proxy muon tu du an Lach Huyen, TCVN 9245:2012 (xem FEM_Ben70000DWT_ChanMay.md muc 11)
cfg.pile.gamma_steel = 1.05; % he so an toan vat lieu thep (uoc luong thuong quy)
% SUA (2026-09-15, phat hien qua test_extreme_eval.m): Rd=116T (tinh tu chuoi
% uoc luong dia ky thuat muc 5) THAP HON gan 2 LAN so voi N_max_pile THAT tu
% FEM (210-229T tren toan bo mien X1-X4, gan nhu khong doi vi tai cong chu
% yeu tu hoat tai tau/can truc, khong phai tu trong sieu cau truc) - neu
% dung 116T thi 100% khong gian tim kiem se "khong kha thi", vo nghia. Cong
% trinh that da van hanh on dinh voi tai nay nhieu nam => Rd that phai lon
% hon nhieu. QUYET DINH NGUOI DUNG (2026-09-15): dung gia tri QUY UOC lon
% hon, dai dien nang luc coc ong thep D700 trong dat tot (400-500 Tan la
% dai dien hop ly) - KHONG suy ra tu dia chat cu the cua Chan May, chi la
% gia dinh nghien cuu - PHAI neu ro dieu nay khi viet bai.
cfg.pile.Rd_Tan = 450;
cfg.gamma_n = 1.15;         % carry-over Bai 2 (cap hau qua C2, QCVN 03:2022/BXD Phu luc A)

% --- Rang buoc chuyen vi (g2) ---
cfg.U_allow_m = 5.2/240;    % quy uoc L/240, L=khoang coc doc ben ~5.2m (neu ban dung)
cfg.deck_top_Z = 0.0;       % TODO xac nhan: cao do dinh ben trong toa do Z cua model FEM nay (can kiem tra qua diagnose_bai6.m)

% --- To hop tai trong (da co san trong model, KHONG can dinh nghia lai) ---
cfg.combo_ULSB  = 'BAO-ULSB';   % bao 388 to hop ULS -> dung cho M_Ed, N_max coc
cfg.combo_SLSDH = 'BAO-SLSDH';  % bao 20 to hop SLS  -> dung cho U_max

% --- Hang so hinh hoc (TONG chieu dai/dien tich moi nhom cau kien) ---
% KHONG doi theo x (chi h/t thay doi, khong doi so luong/vi tri phan tu) ->
% do 1 LAN qua diagnose_bai6.m (GetPoints+toa do), luu vao geom_constants_bai6.mat
% de evaluate_superstructure_design.m khong phai truy van hinh hoc moi lan chay.
geomFile = fullfile(fileparts(mfilename('fullpath')), 'model', 'geom_constants_bai6.mat');
if isfile(geomFile)
    G = load(geomFile);
    cfg.geom = G.geom;
else
    warning('project_config_bai6:NoGeom', ...
        'Chua co geom_constants_bai6.mat - chay diagnose_bai6.m truoc de do L_DN/L_DD/L_DCT/A_BMC that.');
    cfg.geom.L_DN_total_m  = NaN;
    cfg.geom.L_DD_total_m  = NaN;
    cfg.geom.L_DCT_total_m = NaN;
    cfg.geom.A_BMC_total_m2 = NaN;
end

end
