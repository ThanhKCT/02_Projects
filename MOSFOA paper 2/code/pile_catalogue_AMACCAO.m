function cat = pile_catalogue_AMACCAO()
% PILE_CATALOGUE_AMACCAO  Bang catalogue coc PHC/PC AMACCAO D300-D1200.
%
% Nguon: "Cataloge coc ly tam.md" (AMACCAO, TCVN 7888:2014 & JIS A 5373:2016)
% Doi chieu: D700 (B) va D800 (A) da chon lam baseline, Class C (theo quyet
%   dinh nguoi dung 09/09/2026 - xem Cong_thuc_Bai_toan_Toi_uu.md muc 1,4).
%
% Tra ve: mang struct 1xN, moi phan tu = 1 dong catalogue (1 gia tri D, 1
% Class). N = 11 duong kinh x 3 Class = 33 dong.
%
% Truong cua moi dong:
%   D_mm      - duong kinh ngoai (mm)
%   t_mm      - chieu day thanh coc (mm)  [co dinh theo D, KHONG doc lap]
%   Class     - 'A' | 'B' | 'C'
%   A_shaft_m2   - dien tich vanh khuyen (m^2)  -> dung cho f1 (khoi luong)
%   A_tip_m2     - dien tich tron dac = pi/4*D^2 (m^2) -> dung cho qb*A trong Rk
%                  (CHI dung khi mui coc BIT KIN, da chot cho ca 2 cong trinh)
%   u_m          - chu vi ngoai = pi*D (m)
%   I_m4         - momen quan tinh (m^4)
%   W_m3         - momen khang uon (m^3)
%   mass_per_m_kg - khoi luong/m theo catalogue (kg/m)
%   Mcr_kNm, Mu_kNm - momen nut / momen pha huy (kN.m)
%   Pmax_T_lo, Pmax_T_hi - khoang suc chiu tai vat lieu (T) [catalogue chi
%                  cho dang khoang, chua tach theo Class - xem README]

geom = struct( ...
    'D_mm',   {300, 350, 400, 450, 500, 600, 700, 800, 900, 1000, 1200}, ...
    't_mm',   {60,  65,  75,  80,  90,  100, 110, 120, 130, 130,  150}, ...
    'A_cm2',  {452.4, 582.0, 765.8, 929.9, 1159.2, 1570.8, 2038.9, 2563.5, 3144.7, 3553.1, 4948.0}, ...
    'I_cm4',  {43197, 76013, 134810, 207740, 318340, 628320, 1123800, 1833200, 2752100, 3923600, 8011800}, ...
    'W_cm3',  {2880, 4344, 6741, 9233, 12734, 20944, 32109, 45830, 61158, 78472, 133530}, ...
    'mass_kgm', {113, 146, 191, 232, 290, 393, 510, 641, 786, 888, 1237} ...
);

% Mcr/Mu (kN.m) theo D va Class - chi co day du tu D500 tro len trong
% catalogue da doc (D300-D450 KHONG co trong bang Mcr/Mu da trich - de
% trong, danh dau NaN, khong tu dien so).
mcrmu = struct( ...
    'D500',  struct('A',[103.0 154.5], 'B',[147.1 220.6], 'C',[186.3 279.5]), ...
    'D600',  struct('A',[166.7 250.1], 'B',[245.2 367.7], 'C',[304.0 456.0]), ...
    'D700',  struct('A',[255.0 382.5], 'B',[372.7 559.0], 'C',[470.7 706.1]), ...
    'D800',  struct('A',[362.8 544.3], 'B',[539.4 809.0], 'C',[676.7 1015.0]), ...
    'D900',  struct('A',[480.0 720.0], 'B',[710.0 1065.0], 'C',[890.0 1335.0]), ...
    'D1000', struct('A',[610.0 915.0], 'B',[900.0 1350.0], 'C',[1130.0 1695.0]) ...
);
% Pmax (T), dang khoang, chua tach Class (theo catalogue muc 4)
pmax_range = struct('D700',[500 680], 'D800',[680 900], 'D900',[880 1150], 'D1000',[1100 1400]);

classes = {'A','B','C'};
cat = struct([]);
idx = 0;
for i = 1:numel(geom)
    Dkey = sprintf('D%d', geom(i).D_mm);
    D_m = geom(i).D_mm/1000;
    for c = 1:3
        idx = idx + 1;
        cls = classes{c};
        row.D_mm = geom(i).D_mm;
        row.t_mm = geom(i).t_mm;
        row.Class = cls;
        row.A_shaft_m2 = geom(i).A_cm2 * 1e-4;
        row.A_tip_m2   = pi/4 * D_m^2;
        row.u_m        = pi * D_m;
        row.I_m4       = geom(i).I_cm4 * 1e-8;
        row.W_m3       = geom(i).W_cm3 * 1e-6;
        row.mass_per_m_kg = geom(i).mass_kgm;
        if isfield(mcrmu, Dkey)
            row.Mcr_kNm = mcrmu.(Dkey).(cls)(1);
            row.Mu_kNm  = mcrmu.(Dkey).(cls)(2);
        else
            row.Mcr_kNm = NaN;
            row.Mu_kNm  = NaN;
        end
        if isfield(pmax_range, Dkey)
            row.Pmax_T_lo = pmax_range.(Dkey)(1);
            row.Pmax_T_hi = pmax_range.(Dkey)(2);
        else
            row.Pmax_T_lo = NaN;
            row.Pmax_T_hi = NaN;
        end
        cat = [cat, row]; %#ok<AGROW>
    end
end
end
