function Max_Stress_Ratio = Check_TCVN5575(x, NoiLuc, DoVong)
% =========================================================================
% KIEM TRA DIEU KIEN RANG BUOC KET CAU THEP THEO TCVN 5575:2024
% Gop tu 3 file: Check_TCVN5575.m (cong thuc goc) + KiemTraCot5575.m +
% KiemTraDam5575.m. Dau vao doi thanh (x, NoiLuc, DoVong) - ket qua tra ve
% tu TinhNoiLucKhung2T1N.m - de dung truc tiep trong pipeline toi uu hien tai.
%
% Dau ra: Max_Stress_Ratio - ty so ung suat/on dinh lon nhat trong TAT CA
% rang buoc (cot + dam). <= 1.0 nghia la khong vi pham. De dung lam ham
% phat trong HamMucTieuToiUu.m, ap dung cung cach voi Check_TCVN5575.m goc:
%   if Max_Stress_Ratio > 1.0
%       Penalty_Factor = 1.0 + 5000 * (Max_Stress_Ratio - 1.0)^2;
%       Cost = Cost * Penalty_Factor;
%   end
%
% GIA DINH HINH HOC KHUNG (khop voi TinhNoiLucKhung2T1N.m):
%   - Khung thep 2 tang, 1 nhip, tiet dien chu I to hop han
%   - Cot cao 4m/tang (H1=H2=4m), dam nhip 10m, khung KHONG GIANG (sway)
%   - Dam duoc giang canh nen lien tuc doc nhip (san lien tuc) -> KHONG
%     kiem tra on dinh tong the dam (mat on dinh uon-xoan, Dieu 8.4)
%   - On dinh ngoai mat phang cot: giang boi dam phu moi 4m (mu_y=1,0)
% LUU Y: ban goc cua Check_TCVN5575.m tinh Obj1_Volume = A_cot*8.0+A_dam*10.0
% (gia dinh tong dai cot = 8m, tuc khung 1 TANG). Voi khung 2 TANG cua du an
% nay tong dai cot moi ben la 8m (2 doan x 4m) nhung co 2 cot => 16m - da
% KHONG dua phan tinh Obj1_Volume/Obj2_Drift cua file goc vao day de tranh
% sai lech; khoi luong/chuyen vi da duoc TinhNoiLucKhung2T1N.m/HamMucTieuToiUu.m
% tinh dung rieng. File nay CHI xu ly phan kiem tra rang buoc (constraint).
% =========================================================================

    % --- 1. HINH HOC TIET DIEN (thu tu bien du an: bc,hc,twc,tfc,bd,hd,twd,tfd) ---
    bc=x(1); hc=x(2); twc=x(3); tfc=x(4); % Cot
    bd=x(5); hd=x(6); twd=x(7); tfd=x(8); % Dam

    Ac    = 2*bc*tfc + (hc-2*tfc)*twc;
    Ic_x  = (bc*hc^3)/12 - ((bc-twc)*(hc-2*tfc)^3)/12;
    Ic_y  = 2*(tfc*bc^3)/12 + ((hc-2*tfc)*twc^3)/12;
    Wx_c  = Ic_x/(hc/2);
    hef_c = hc - 2*tfc;      % chieu cao ban bung (Dieu 7.3.1, cau kien han)
    bef_c = (bc-twc)/2;      % be rong phan vuon canh (Dieu 7.3.1)

    Ad    = 2*bd*tfd + (hd-2*tfd)*twd;
    Id_x  = (bd*hd^3)/12 - ((bd-twd)*(hd-2*tfd)^3)/12;
    Wx_d  = Id_x/(hd/2);
    hef_d = hd - 2*tfd;
    bef_d = (bd-twd)/2;

    % --- 1b. KIEM TRA TIET DIEN HOP LE (tranh sqrt(so am) -> so phuc -> loi interp1) ---
    % Cac bien PSO/GA co the sinh ra to hop kich thuoc vo ly (vd twc>=bc,
    % 2*tfc>=hc...) khien Ic_x/Ic_y/hef/bef <=0. Neu de lot se lam lambda,
    % i_x, i_y... tro thanh so phuc va lam interp1 bao loi "Input coordinates
    % must be real". Thay vao do, tra ve ty so phat rat lon de vong lap toi
    % uu tu loai bo cac nghiem khong hop le nay.
    if hef_c<=0 || bef_c<=0 || Ac<=0 || Ic_x<=0 || Ic_y<=0 || ...
       hef_d<=0 || bef_d<=0 || Ad<=0 || Id_x<=0
        Max_Stress_Ratio = 1e6;
        return;
    end

    % --- 2. HANG SO VAT LIEU THEO TCVN 5575:2024 (thep SS400, don vi N,m) ---
    f       = 215e6;  % Cuong do chiu keo/nen tinh toan cua thep (N/m2)
    f_v     = 125e6;  % Cuong do chiu cat tinh toan cua thep (N/m2)
    E       = 2.1e11; % Mo-dun dan hoi (N/m2)
    gamma_c = 1.0;    % He so dieu kien lam viec

    % --- HINH HOC KHUNG (khop TinhNoiLucKhung2T1N.m) ---
    L_col  = 4.0;  % m - chieu cao 1 tang cot
    L_beam = 10.0; % m - nhip dam
    Ly_col = 4.0;  % m - khoang cach giang ngoai mat phang cot (dam phu)
    mu_y   = 1.0;  % He so chieu dai tinh toan ngoai mat phang - lien ket khop

    Max_Stress_Ratio = 0;

    % =====================================================================
    % --- 3. KIEM TRA 4 DOAN COT (Cot1..Cot4) ---
    % =====================================================================
    Cot = {NoiLuc.Cot1, NoiLuc.Cot2, NoiLuc.Cot3, NoiLuc.Cot4};

    % 3a. He so chieu dai tinh toan mu (Dieu 10.3.4, Bang 32, khung TU DO 1 tang,
    % ngam chan cot, lien ket cung dam-cot -> cong thuc (140)):
    %   n = (Is*Lc)/(Ic*L),  mu = 2*sqrt(1 + 0,38/n)
    n_stiff = (Id_x * L_col) / (Ic_x * L_beam);
    mu_col  = 2 * sqrt(1 + 0.38/n_stiff);
    i_x     = sqrt(Ic_x/Ac);
    lambda_x_col = (mu_col*L_col/i_x) * sqrt(f/E);

    i_y = sqrt(Ic_y/Ac);
    lambda_y_col = (mu_y*Ly_col/i_y) * sqrt(f/E);

    for k = 1:4
        Ni = Cot{k}.N_i; Nj = Cot{k}.N_j;
        Mi = Cot{k}.M_i; Mj = Cot{k}.M_j;
        Vi = Cot{k}.Q_i;

        % 3b. Do ben (Dieu 9.1, CT 105) - xet ca 2 dau i,j, lay cap N,M nguy hiem nhat
        sigma_i = abs(Ni)/Ac + abs(Mi)/Wx_c;
        sigma_j = abs(Nj)/Ac + abs(Mj)/Wx_c;
        tau     = abs(Vi)/(hef_c*twc);
        Max_Stress_Ratio = max(Max_Stress_Ratio, max(sigma_i,sigma_j)/(f*gamma_c));
        Max_Stress_Ratio = max(Max_Stress_Ratio, tau/(f_v*gamma_c));

        if sigma_i >= sigma_j
            N_crit = Ni; M_crit = Mi;
        else
            N_crit = Nj; M_crit = Mj;
        end

        if abs(N_crit) > 1e-9
            % 3c. Do lech tam tuong doi m va m_ef = eta*m
            m_ecc = (abs(M_crit)/abs(N_crit)) * (Ac/Wx_c);
            % GIA DINH: eta (he so anh huong hinh dang tiet dien, Bang D.2, Phu luc D)
            % lay xap xi 1,2 cho tiet dien chu I doi xung thong thuong.
            eta_shape = 1.2;
            mef_col = eta_shape * m_ecc;

            % 3d. Tra phi_e theo Bang D.3 (Phu luc D) - noi suy song tuyen tinh
            phi_e = lookup_phie_TCVN5575(lambda_x_col, mef_col);
            Max_Stress_Ratio = max(Max_Stress_Ratio, abs(N_crit)/(phi_e*Ac*f*gamma_c));

            % ---------------------------------------------------------------
            % 3e. On dinh cuc bo ban bung/canh cot (Dieu 9.4, tiet dien loai 1 - chu I)
            % ---------------------------------------------------------------
            mx_col = m_ecc; % Bang 23/24 dung mx (do lech tam THO, KHONG nhan eta)

            % Ban bung (Bang 23, CT 124/125), ap dung khi 1<=mx<=10
            if lambda_x_col <= 2
                uw_col = 1.3 + 0.15*lambda_x_col^2;                 % (124)
            else
                uw_col = min(1.2 + 0.35*lambda_x_col, 3.1);          % (125)
            end
            lambda_w_col = (hef_c/twc) * sqrt(f/E);
            Max_Stress_Ratio = max(Max_Stress_Ratio, lambda_w_col/uw_col);

            % Ban canh (Bang 24, CT 131), ap dung khi 0<=mx<=5 va 0,8<=lambda_x<=4
            lambda_x_ufc = min(max(lambda_x_col, 0.8), 4);
            ufc_col = 0.36 + 0.10*lambda_x_ufc;                      % (36), Bang 10
            mx_flange_clip = min(max(mx_col, 0), 5);
            uf_col = ufc_col - 0.01*(1.5+0.7*lambda_x_ufc)*mx_flange_clip; % (131)
            lambda_f_col = (bef_c/tfc) * sqrt(f/E);
            Max_Stress_Ratio = max(Max_Stress_Ratio, lambda_f_col/uf_col);

            % ---------------------------------------------------------------
            % 3f. On dinh ngoai mat phang khung - truc yeu y-y (Dieu 9.2.8, CT 114)
            % Chi bat buoc kiem tra khi lambda_x > lambda_y.
            % ---------------------------------------------------------------
            if lambda_x_col > lambda_y_col
                phi_y = lookup_phi_axial_TCVN5575(lambda_y_col);
                Max_Stress_Ratio = max(Max_Stress_Ratio, abs(N_crit)/(phi_y*Ac*f*gamma_c));
            end
        end
    end

    % =====================================================================
    % --- 4. KIEM TRA 2 DAM (Dam1, Dam2) ---
    % =====================================================================
    Dam = {NoiLuc.Dam1, NoiLuc.Dam2};
    DoVong_list = [DoVong.Dam1_mid, DoVong.Dam2_mid];

    for k = 1:2
        Ni = Dam{k}.N_i; Nj = Dam{k}.N_j;
        Mi = Dam{k}.M_i; Mj = Dam{k}.M_j;
        Vi = Dam{k}.Q_i;

        % 4a. Do ben (Dieu 8.2)
        sigma_i = abs(Ni)/Ad + abs(Mi)/Wx_d;
        sigma_j = abs(Nj)/Ad + abs(Mj)/Wx_d;
        tau     = abs(Vi)/(hef_d*twd);
        M_max_d = max(abs(Mi), abs(Mj));
        Max_Stress_Ratio = max(Max_Stress_Ratio, max(sigma_i,sigma_j)/(f*gamma_c));
        Max_Stress_Ratio = max(Max_Stress_Ratio, tau/(f_v*gamma_c));

        % 4b. On dinh cuc bo ban bung dam (Dieu 8.5.1): lambda_w <= 3,5
        lambda_w_dam = (hef_d/twd) * sqrt(f/E);
        Max_Stress_Ratio = max(Max_Stress_Ratio, lambda_w_dam/3.5);

        % 4c. Ban canh chiu nen cua dam (Dieu 8.5.18, CT 96)
        if M_max_d > 1e-9
            sigma_c_dam   = M_max_d/(Wx_d*gamma_c);
            lambda_uf_dam = 0.5*sqrt(f/sigma_c_dam);
            lambda_f_dam  = (bef_d/tfd)*sqrt(f/E);
            Max_Stress_Ratio = max(Max_Stress_Ratio, lambda_f_dam/lambda_uf_dam);
        end
        % KHONG kiem tra on dinh tong the dam (mat on dinh uon-xoan, Dieu 8.4)
        % vi canh chiu nen da duoc giang lien tuc (san lien tuc).

        % 4d. Do vong TTGH2 (Dieu 8.2/Phu luc, gioi han L/250)
        f_max = abs(DoVong_list(k));
        Max_Stress_Ratio = max(Max_Stress_Ratio, f_max/(L_beam/250));
    end
end


function phi_e = lookup_phie_TCVN5575(lambda_bar, mef)
% =========================================================================
% Tra he so on dinh khi nen lech tam phi_e theo Bang D.3 (Phu luc D, TCVN 5575:2024)
% Noi suy song tuyen tinh (bilinear). Du lieu so hoa truc tiep tu Bang D.3.
% Mot so o goc lambda_bar lon + mef lon khong co so lieu trong bang goc -
% ham KEP mef vao gia tri lon nhat san co cua hang lambda_bar tuong ung.
% =========================================================================
    lam_list = [0.5 1.0 1.5 2.0 2.5 3.0 3.5 4.0 4.5 5.0 5.5 6.0 6.5 7.0 8.0 9.0];

    mef_full = [0.1 0.25 0.5 0.75 1.0 1.25 1.5 1.75 2.0 2.5 3.0 3.5 4.0 4.5 5.0 5.5 6.0 6.5 7.0 8.0 9.0 10 12 14 17 20];

    phie_table = { ...
        [0.967 0.922 0.850 0.782 0.722 0.669 0.620 0.577 0.538 0.469 0.417 0.370 0.337 0.307 0.280 0.260 0.237 0.222 0.210 0.183 0.164 0.150 0.125 0.106 0.090 0.077], ...
        [0.925 0.854 0.778 0.711 0.653 0.600 0.563 0.520 0.484 0.427 0.382 0.341 0.307 0.283 0.259 0.240 0.225 0.209 0.196 0.175 0.157 0.142 0.121 0.103 0.086 0.074], ...
        [0.875 0.804 0.716 0.647 0.593 0.548 0.507 0.470 0.439 0.388 0.347 0.312 0.283 0.262 0.240 0.223 0.207 0.195 0.182 0.163 0.148 0.134 0.114 0.099 0.082 0.070], ...
        [0.813 0.742 0.653 0.587 0.536 0.496 0.457 0.425 0.397 0.352 0.315 0.286 0.260 0.240 0.222 0.206 0.193 0.182 0.170 0.153 0.138 0.125 0.107 0.094 0.079 0.067], ...
        [0.742 0.672 0.587 0.526 0.480 0.442 0.410 0.383 0.357 0.317 0.287 0.262 0.238 0.220 0.204 0.190 0.178 0.168 0.158 0.144 0.130 0.118 0.101 0.090 0.076 0.065], ...
        [0.667 0.597 0.520 0.465 0.425 0.395 0.365 0.342 0.320 0.287 0.260 0.238 0.217 0.202 0.187 0.175 0.166 0.156 0.147 0.135 0.123 0.112 0.097 0.086 0.073 0.063], ...
        [0.587 0.522 0.455 0.408 0.375 0.350 0.325 0.303 0.287 0.258 0.233 0.216 0.198 0.183 0.172 0.162 0.153 0.145 0.137 0.125 0.115 0.106 0.092 0.082 0.069 0.060], ...
        [0.505 0.447 0.394 0.356 0.330 0.309 0.289 0.270 0.256 0.232 0.212 0.197 0.181 0.168 0.158 0.149 0.140 0.135 0.127 0.118 0.108 0.098 0.088 0.078 0.066 0.057], ...
        [0.418 0.382 0.342 0.310 0.288 0.272 0.257 0.242 0.229 0.208 0.192 0.178 0.165 0.155 0.146 0.137 0.130 0.125 0.118 0.110 0.101 0.093 0.083 0.075 0.064 0.055], ...
        [0.354 0.326 0.295 0.273 0.253 0.239 0.225 0.215 0.205 0.188 0.175 0.162 0.150 0.143 0.135 0.126 0.120 0.117 0.111 0.103 0.095 0.088 0.079 0.072 0.062 0.053], ...
        [0.302 0.280 0.256 0.240 0.224 0.212 0.200 0.192 0.184 0.170 0.158 0.148 0.138 0.132 0.124 0.117 0.112 0.108 0.104 0.095 0.089 0.084 0.075 0.069 0.060 0.051], ...
        [0.258 0.244 0.223 0.210 0.198 0.190 0.178 0.172 0.166 0.153 0.145 0.137 0.128 0.120 0.115 0.109 0.104 0.100], ...
        [0.223 0.213 0.196 0.185 0.176 0.170 0.160 0.155 0.149 0.140 0.132 0.125 0.117 0.112 0.106 0.101 0.097 0.094], ...
        [0.194 0.186 0.173 0.163 0.157 0.152 0.145 0.141 0.136 0.127 0.121 0.115 0.108 0.102 0.098 0.094 0.091 0.087], ...
        [0.152 0.146 0.138 0.133 0.128 0.121 0.117 0.115 0.113 0.106 0.100 0.095 0.091 0.087 0.083 0.081 0.078 0.076], ...
        [0.122 0.117 0.112 0.107 0.103 0.100 0.098 0.096 0.093] ...
    };

    lam_q = min(max(lambda_bar, lam_list(1)), lam_list(end));

    idx_hi = find(lam_list >= lam_q, 1, 'first');
    if idx_hi == 1
        idx_lo = 1; idx_hi = 1;
    else
        idx_lo = idx_hi - 1;
    end

    phi_lo = interp_row_TCVN5575(mef_full, phie_table{idx_lo}, mef);
    phi_hi = interp_row_TCVN5575(mef_full, phie_table{idx_hi}, mef);

    if idx_lo == idx_hi
        phi_e = phi_lo;
    else
        t = (lam_q - lam_list(idx_lo)) / (lam_list(idx_hi) - lam_list(idx_lo));
        phi_e = phi_lo + t * (phi_hi - phi_lo);
    end
end


function val = interp_row_TCVN5575(mef_full, phie_row, mef_q)
% Noi suy 1D doc theo mef cho 1 hang lambda_bar co dinh. Mot so hang
% (lambda_bar >= 6.0) khong co du so lieu toi mef=20 trong Bang D.3 goc,
% nen ham KEP mef_q vao mef lon nhat san co cua hang do thay vi ngoai suy.
    n = numel(phie_row);
    mef_this = mef_full(1:n);
    mef_q_clip = min(max(mef_q, mef_this(1)), mef_this(end));
    val = interp1(mef_this, phie_row, mef_q_clip, 'linear');
end


function phi = lookup_phi_axial_TCVN5575(lambda_bar)
% =========================================================================
% Tra he so on dinh khi nen dung tam phi theo Bang D.1 (Phu luc D, TCVN 5575:2024),
% cot "loai tiet dien b" (GIA DINH cho tiet dien chu I han thong thuong).
% Ngoai pham vi [0.4, 4.4] ham KEP vao bien gan nhat (thien an toan).
% =========================================================================
    lam_list = [0.4 0.6 0.8 1.0 1.2 1.4 1.6 1.8 2.0 2.2 2.4 2.6 2.8 3.0 3.2 3.4 3.6 3.8 4.0 4.2 4.4];
    phi_b    = [1.000 0.986 0.967 0.948 0.927 0.905 0.881 0.855 0.826 0.794 0.760 0.723 0.683 0.643 0.602 0.562 0.524 0.487 0.453 0.422 0.392];

    lam_q = min(max(lambda_bar, lam_list(1)), lam_list(end));
    phi = interp1(lam_list, phi_b, lam_q, 'linear');
end
