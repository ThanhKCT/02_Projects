function cfg = project_config(proj)
% PROJECT_CONFIG  Thong so rieng cua tung cong trinh, da chot theo
% Cong_thuc_Bai_toan_Toi_uu.md va Danh_gia_kha_thi_Bai_2.md (09/09/2026).
%
%   cfg = project_config('A')   % Lach Huyen 100.000DWT
%   cfg = project_config('B')   % VIPGreenPort 30.000DWT
%
% ⚠️ CAC TRUONG DUONG DAN/TEN TIET DIEN ("TODO") CAN NGUOI DUNG XAC NHAN
%    LAI DUNG THEO MO HINH SAP THAT TRUOC KHI CHAY CHINH THUC - xem README.

switch upper(proj)
case 'A'
    cfg.name          = 'Lach Huyen 100.000DWT';
    % ✅ Da xac nhan VA KIEM CHUNG BANG SO (10/09/2026): mo thu qua MATLAB
    % actxserver, doi chieu PointObj.Count=4913, FrameObj.Count=1734,
    % AreaObj.Count=4488 - KHOP TUYET DOI voi hinh hoc da biet cua cong trinh
    % A ("Ben 100.000DWT KT" goc). File nay dung duoc, khong phai ban khac.
    cfg.sdb_path       = fullfile('D:\ResearchLab\02_Projects\MOSFOA paper 2\SapV14', 'Ben100kDWT_sensitivity.sdb');
    cfg.pile_section_name = 'COCBTCT';       % xac nhan truc tiep tu "Ben 100.000DWT KT.s2k": SectionName=COCBTCT, Shape=Pipe, D800-t130
    cfg.material_name     = 'Be tong M800';  % xac nhan truc tiep: Material="Be tong M800"
    cfg.steel_pile_section_name = 'COCTHEP'; % coc thep phu tro D1016-t16, GIU NGUYEN khong toi uu (muc 2.3 Danh_gia_kha_thi_Bai_2.md) - chi de tham chieu, KHONG dua vao vong loc SetPipe

    cfg.N_pile        = 132;           % so coc BTCT UST chinh / phan doan (khong doi theo x)
    cfg.L_pile_m      = 34.0;          % chieu dai che tao coc (m), mat cat 1-1, KHONG doi theo x
    cfg.rho_bt_Tm3    = 2.5;           % khoi luong rieng be tong (T/m3)

    % He so dong kin cong thuc Rk(D) = qc*( qb_tip*A_tip(D) + u(D)*sum_fi_hi )
    % (qb_tip, sum_fi_hi la hang so/cong trinh, da tinh san theo tru ho khoan
    %  tai mat cat 1-1 - xem SucChiuTai_Coc_TCVN10304_2025.md muc 2,6)
    cfg.qb_tip_kPa    = 11100;
    cfg.sum_fi_hi_kPa_m = 366.75;
    cfg.gamma_k       = 1.4;           % he so tin cay dat nen (nhom >=21 coc, tinh theo bang tra)
    cfg.gamma_n       = 1.0;           % Cap I -> C1 (TCVN 10304:2025 muc 7.1.6.1)

    cfg.U_limit_m     = 0.030;         % gioi han chuyen vi van hanh (Bang 12 + xac nhan nguoi dung)
    % ✅ ĐÃ CHỐT BẰNG FEM THẬT — ĐỦ 37/37 tổ hợp (xem chi tiết dưới):
    % Nguồn 1: "Ben 100.000DWT KT kq dau ra.s2k" (loc 4632 nut dinh ben Z=5.5m)
    %          -> 32 to hop, max = COMB2 = 13,41mm (nut 1).
    % Nguồn 2: "Chuyen vi du an A. s2k.s2k" (moi, xuat rieng 2 to hop bao,
    %          DAY DU 4913/4913 nut) -> "BAO (storm)"=3,27mm (nut 3026);
    %          "BAO KT"=13,81mm (nut 459, da xac nhan la nut dinh ben Z=5.5m).
    % Nguồn 3: COMB7.1, COMB8.1, COMB8.2 - da thu xuat ("Ben100kDWT_bs thop.s2k")
    %          nhung file RONG (khong co dong du lieu) - nhieu kha nang 3 to hop
    %          nay CHUA duoc chay phan tich (chua tick "Run") trong model goc.
    %          THEO QUYET DINH NGUOI DUNG (10/09/2026): BO QUA, coi nhu dong
    %          gop = 0/khong khong che (KHONG suy dien gia tri thay the).
    % => TONG HOP (37/37, 3 to hop coi = 0 theo quyet dinh tren): "BAO KT" la
    %    to hop khong che (max|U1| toan bo = 13,81mm), VUOT nhe COMB2 (13,41mm).
    %    Van << 30mm gioi han (dung ~46%).
    % LUU Y QUAN TRONG: phat hien "BAO KT" la 1 to hop THAT rieng biet voi
    % "BAO (storm)" (2 to hop bao khac nhau) - truoc do trich COMBINATION
    % DEFINITIONS tu file .s2k goc bi LOI ky tu (ten co dau ngoac kep + khoang
    % trang bi cat) khien 2 ten nay bi gop nham thanh 1 dong "36 to hop" - so
    % that su la 37 to hop. Danh sach duoi day da bo sung du ca 2:
    cfg.combo_governing_disp = '"BAO KT"';
    % Danh sach day du 37 to hop (36 tu COMBINATION DEFINITIONS + bo sung
    % "BAO KT" phat hien rieng qua file ket qua). Ten co dau ngoac kep +
    % khoang trang PHAI GIU NGUYEN dung nhu SapModel can.
    cfg.combo_list_for_axial = {'COMB1','"BAO (storm)"','"BAO KT"','COMB2', ...
        'COMB3.1','COMB3.2','COMB3.3','COMB3.4','COMB3.5','COMB3.6', ...
        'COMB4.1','COMB4.2','COMB4.3','COMB4.4','COMB4.5','COMB4.6', ...
        'COMB5.1','COMB5.2', ...
        'COMB6.1','COMB6.2','COMB6.3','COMB6.4','COMB6.5','COMB6.6', ...
        'COMB6.7','COMB6.8','COMB6.9','COMB6.10','COMB6.11','COMB6.12', ...
        'COMB7.1','COMB7.2','COMB7.3', ...
        'COMB8.1','COMB8.2','COMB8.3','COMB8.4'};

    cfg.deck_top_Z    = 5.50;          % cao do dinh ben (m, Hai do) - dung de loc nut can xet chuyen vi

case 'B'
    cfg.name          = 'VIPGreenPort 30.000DWT';
    % SUA (10/09/2026): "Cau tau.sdb" KHONG TON TAI trong thu muc - dung dung
    % "Cau tau dau vao.sdb" (da xac nhan ngay dau phien la CUNG 1 hinh hoc,
    % chi khac phien ban SAP2000 export 16 vs 24).
    cfg.sdb_path       = fullfile('D:\ResearchLab\02_Projects\MOSFOA paper 2\SapV14', 'Cau tau dau vao.sdb');
    cfg.pile_section_name = 'Coc';     % xac nhan: SAP2000v1 "FRAME SECTION PROPERTIES 01", SectionName=Coc, Shape=Pipe
    cfg.material_name     = 'M600';    % xac nhan tu file .s2k goc

    cfg.N_pile        = 132;
    cfg.L_pile_m      = 41.00;         % = 15.57 (tu do) + 25.43 (ngap dat), sheet Ltt(LK3)/Ltt(BH17)
    cfg.rho_bt_Tm3    = 2.5;

    cfg.qb_tip_kPa    = 8605;
    cfg.sum_fi_hi_kPa_m = 667.70;
    cfg.gamma_k       = 1.4;
    cfg.gamma_n       = 1.15;          % Cap II -> C2

    cfg.U_limit_m     = 0.030;
    cfg.combo_governing_disp = 'COMB14';   % = 'BAO' (2 ten, 1 ket qua) - da xac nhan bang FEM that (Chuyen vi. s2k.s2k)
    cfg.combo_list_for_axial = arrayfun(@(i) sprintf('COMB%d', i), 1:36, 'UniformOutput', false);
    cfg.combo_list_for_axial{end+1} = 'BAO';

    cfg.deck_top_Z    = 0.0;           % model B dung goc cuc bo Z=0 tai dinh coc (~ +4.07m Hai do thuc)

otherwise
    error('project_config: proj phai la ''A'' hoac ''B''.');
end

% --- Diem chuan (baseline) dung lam phuong an "goc" khi bao cao ket qua ---
% Ca 2 cong trinh deu chot dung catalogue AMACCAO, Class C (xem
% Cong_thuc_Bai_toan_Toi_uu.md muc 1):
%   A -> D800-t120-ClassC ; B -> D700-t110-ClassC
cfg.baseline_D_mm = ternary(strcmpi(proj,'A'), 800, 700);
cfg.baseline_Class = 'C';

end

function out = ternary(cond, a, b)
if cond, out = a; else, out = b; end
end
