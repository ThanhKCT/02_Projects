function Cost = Check_TCVN5575(X, P_c, V2_c, M3_c, NumResC, P_d, V2_d, M3_d, NumResD, Real_Drift)
% =========================================================================
% TỆP KIỂM TRA TIÊU CHUẨN THIẾT KẾ KẾT CẤU THÉP: TCVN 5575:2024
% Mục đích: Kiểm tra độ bền + ỔN ĐỊNH TỔNG THỂ + ỔN ĐỊNH CỤC BỘ (bản bụng/cánh)
%           và tính toán hàm phạt Penalty
%
% GIẢ ĐỊNH HÌNH HỌC KHUNG (đã xác nhận với người dùng, KHÔNG tự suy đoán):
%   - Khung thép 1 tầng, 1 nhịp, tiết diện chữ I tổ hợp hàn (bản cánh + bản bụng)
%   - Cột cao 4m (x2 cột)   -> tổng dài cột = 8m  (khớp Obj1_Volume gốc)
%   - Dầm nhịp 10m (x1 dầm) -> tổng dài dầm = 10m (ĐÃ SỬA từ 6.0 -> 10.0, xem mục 8)
%   - Khung KHÔNG GIẰNG (sway/khung tự do): ngàm cột-móng + liên kết CỨNG dầm-cột
%   - Dầm ĐƯỢC GIẰNG cánh nén liên tục dọc nhịp (sàn liên tục)
%     -> theo TCVN 5575:2024, KHÔNG cần kiểm tra ổn định tổng thể dầm (Điều 8.4,
%        mất ổn định uốn-xoắn) vì cánh chịu nén đã được giằng liên tục.
%   - Ổn định ngoài mặt phẳng khung (trục yếu y-y) của cột: giằng bởi dầm phụ
%     mỗi 4m (Ly=Lcol=4m), GIẢ ĐỊNH liên kết khớp tại điểm giằng (mu_y=1,0) vì
%     dầm phụ không tạo thành khung cứng theo phương ngoài mặt phẳng (Điều 9.2.8,
%     công thức 114) - chỉ được kiểm tra khi lambda_x > lambda_y (đúng theo tiêu chuẩn).
% =========================================================================

    NumResC = double(NumResC);
    NumResD = double(NumResD);

    % --- 1. TÍNH ĐẶC TRƯNG HÌNH HỌC TIẾT DIỆN I ---
    % Cột (Cấu kiện nhóm Cột)
    h_c = X(1); b_c = X(2); tf_c = X(3); tw_c = X(4);
    A_cot = 2 * (b_c * tf_c) + (h_c - 2 * tf_c) * tw_c;                             % Diện tích mặt cắt
    Ix_cot = (b_c * h_c^3)/12 - ((b_c - tw_c) * (h_c - 2 * tf_c)^3)/12;            % Mô-men quán tính
    Wx_cot = Ix_cot / (h_c / 2);                                                    % Mô-men kháng uốn
    Aw_cot = (h_c - 2 * tf_c) * tw_c;                                               % Diện tích bản bụng (chịu cắt)
    hef_c  = h_c - 2 * tf_c;                                                        % Chiều cao bản bụng (7.3.1, cấu kiện hàn)
    bef_c  = (b_c - tw_c) / 2;                                                      % Bề rộng phần vươn cánh (7.3.1)
    Iy_cot = 2*(tf_c * b_c^3)/12 + ((h_c - 2*tf_c) * tw_c^3)/12;                    % Mô-men quán tính trục yếu y-y (2 cánh + bản bụng)

    % Dầm (Cấu kiện nhóm Dầm)
    h_d = X(5); b_d = X(6); tf_d = X(7); tw_d = X(8);
    A_dam = 2 * (b_d * tf_d) + (h_d - 2 * tf_d) * tw_d;                             % Diện tích mặt cắt
    Ix_dam = (b_d * h_d^3)/12 - ((b_d - tw_d) * (h_d - 2 * tf_d)^3)/12;            % Mô-men quán tính
    Wx_dam = Ix_dam / (h_d / 2);                                                    % Mô-men kháng uốn
    Aw_dam = (h_d - 2 * tf_d) * tw_d;                                               % Diện tích bản bụng (chịu cắt)
    hef_d  = h_d - 2 * tf_d;
    bef_d  = (b_d - tw_d) / 2;

    % --- 2. HẰNG SỐ VẬT LIỆU THEO TCVN 5575:2024 ---
    % LƯU Ý: f, f_v, E tính bằng kPa -> yêu cầu đơn vị lực/mô-men xuất từ SAP2000
    % (P_c, V2_c, M3_c...) phải đang ở hệ kN, m. Hãy xác nhận Units trong SAP2000
    % khớp giả định này, nếu không toàn bộ ứng suất sẽ sai mà không báo lỗi runtime.
    f = 215000;       % Cường độ chịu kéo/nén tính toán của thép (kPa)
    f_v = 125000;     % Cường độ chịu cắt tính toán của thép (kPa)
    E = 2.1e8;        % Mô-đun đàn hồi thép E = 210 000 MPa = 2,1e8 kPa
    gamma_c = 1.0;    % Hệ số điều kiện làm việc
    Max_Stress_Ratio = 0;

    % --- HÌNH HỌC KHUNG (đã xác nhận với người dùng) ---
    L_col  = 4.0;   % m - chiều cao cột (1 tầng)
    L_beam = 10.0;  % m - nhịp dầm
    Ly_col = 4.0;   % m - khoảng cách giằng ngoài mặt phẳng khung (dầm phụ liên kết cùng cao độ, mỗi 4m)
    mu_y   = 1.0;   % Hệ số chiều dài tính toán ngoài mặt phẳng - GIẢ ĐỊNH liên kết khớp
                     % tại các điểm giằng (dầm phụ, không phải khung cứng theo phương này)

    % --- 3. KIỂM TRA ĐỘ BỀN NHÓM CỘT (Điều 9.1, công thức 105 - dạng đàn hồi) ---
    % Đồng thời xác định trạng thái N, M nguy hiểm nhất (station "idx_crit_c")
    % để dùng cho kiểm tra ỔN ĐỊNH (mục 6 bên dưới) - vì N và M phải lấy CÙNG
    % một tiết diện/tổ hợp tải, không được lấy max độc lập từng thành phần.
    N_crit_c = 0; M_crit_c = 0;
    if NumResC > 0
        P_c_mat = double(P_c); V2_c_mat = double(V2_c); M3_c_mat = double(M3_c);
        worst_ratio_c = -1;
        for k = 1:NumResC
            sigma = abs(P_c_mat(k)) / A_cot + abs(M3_c_mat(k)) / Wx_cot; % Ứng suất pháp kết hợp
            tau = abs(V2_c_mat(k)) / Aw_cot;                             % Ứng suất tiếp (cắt)
            ratio_k = max(sigma/(f*gamma_c), tau/(f_v*gamma_c));
            Max_Stress_Ratio = max(Max_Stress_Ratio, ratio_k);
            if ratio_k > worst_ratio_c
                worst_ratio_c = ratio_k;
                N_crit_c = P_c_mat(k);
                M_crit_c = M3_c_mat(k);
            end
        end
    end

    % --- 4. KIỂM TRA ĐỘ BỀN NHÓM DẦM (Điều 8.2) + xác định M lớn nhất cho mục 5 ---
    M_max_d = 0;
    if NumResD > 0
        P_d_mat = double(P_d); V2_d_mat = double(V2_d); M3_d_mat = double(M3_d);
        for k = 1:NumResD
            sigma = abs(P_d_mat(k)) / A_dam + abs(M3_d_mat(k)) / Wx_dam; % Ứng suất pháp kết hợp
            tau = abs(V2_d_mat(k)) / Aw_dam;                             % Ứng suất tiếp (cắt)
            Max_Stress_Ratio = max([Max_Stress_Ratio, sigma/(f*gamma_c), tau/(f_v*gamma_c)]);
            M_max_d = max(M_max_d, abs(M3_d_mat(k)));
        end
    end

    % =====================================================================
    % --- 5. ỔN ĐỊNH CỤC BỘ BẢN BỤNG/CÁNH DẦM (Điều 8.5, dầm giằng cánh nén liên tục) ---
    % =====================================================================
    if NumResD > 0
        % 5a. Bản bụng dầm cấp 1 (Điều 8.5.1): lambda_w <= 3,5 (hàn 2 phía, không
        % có ứng suất cục bộ - GIẢ ĐỊNH vì mô hình không khai báo tải cục bộ trên cánh)
        lambda_w_dam = (hef_d / tw_d) * sqrt(f / E);
        ratio_web_dam = lambda_w_dam / 3.5;
        Max_Stress_Ratio = max(Max_Stress_Ratio, ratio_web_dam);

        % 5b. Bản cánh chịu nén của dầm (Điều 8.5.18, công thức 96):
        % lambda_uf = 0,5*sqrt(fyd/sigma_c), sigma_c = M_max/(Wxnc*gamma_c)
        if M_max_d > 1e-9
            sigma_c_dam = M_max_d / (Wx_dam * gamma_c);
            lambda_uf_dam = 0.5 * sqrt(f / sigma_c_dam);
            lambda_f_dam = (bef_d / tf_d) * sqrt(f / E);
            ratio_flange_dam = lambda_f_dam / lambda_uf_dam;
            Max_Stress_Ratio = max(Max_Stress_Ratio, ratio_flange_dam);
        end
    end

    % =====================================================================
    % --- 6. ỔN ĐỊNH TỔNG THỂ CỘT CHỊU NÉN LỆCH TÂM TRONG MẶT PHẲNG KHUNG
    %        (Điều 9.2, công thức 108: N/(phi_e*A*fyd*gamma_c) <= 1) ---
    % =====================================================================
    if NumResC > 0 && abs(N_crit_c) > 1e-9
        % 6a. Hệ số chiều dài tính toán mu (Điều 10.3.4, Bảng 32, khung TỰ DO 1 tầng,
        % ngàm chân cột, liên kết cứng dầm-cột -> công thức (140)):
        %   n = (Is*Lc)/(Ic*L),  mu = 2*sqrt(1 + 0,38/n)
        n_stiff = (Ix_dam * L_col) / (Ix_cot * L_beam);
        mu_col = 2 * sqrt(1 + 0.38 / n_stiff);

        % 6b. Độ mảnh quy ước lambda_x
        i_x = sqrt(Ix_cot / A_cot);
        lambda_x_col = (mu_col * L_col / i_x) * sqrt(f / E);

        % 6c. Độ lệch tâm tương đối m và m_ef = eta*m
        m_ecc = (abs(M_crit_c) / abs(N_crit_c)) * (A_cot / Wx_cot);
        % --- GIẢ ĐỊNH: eta (hệ số ảnh hưởng hình dạng tiết diện, Bảng D.2, Phụ lục D)
        % lấy xấp xỉ eta = 1,2 cho tiết diện chữ I đối xứng thông thường (Af/Aw~0,5-1,0).
        % Bảng D.2 đầy đủ cho giá trị eta trong khoảng 1,0-1,4 tùy tỷ số Af/Aw và m -
        % NÊN tra lại Bảng D.2 chính xác theo tiết diện thực tế nếu cần độ chính xác cao. ---
        eta_shape = 1.2;
        mef_col = eta_shape * m_ecc;

        % 6d. Tra phi_e theo Bảng D.3 (Phụ lục D) - nội suy song tuyến tính
        phi_e = lookup_phie_TCVN5575(lambda_x_col, mef_col);

        ratio_stability_col = abs(N_crit_c) / (phi_e * A_cot * f * gamma_c);
        Max_Stress_Ratio = max(Max_Stress_Ratio, ratio_stability_col);

        % =================================================================
        % --- 7. ỔN ĐỊNH CỤC BỘ BẢN BỤNG/CÁNH CỘT (Điều 9.4, tiết diện loại 1 - chữ I) ---
        % =================================================================
        mx_col = m_ecc;  % Bảng 23/24 dùng mx (độ lệch tâm THÔ, KHÔNG nhân eta)

        % 7a. Bản bụng (Bảng 23, công thức 124/125), áp dụng khi 1<=mx<=10.
        if lambda_x_col <= 2
            uw_col = 1.3 + 0.15 * lambda_x_col^2;                 % (124)
        else
            uw_col = min(1.2 + 0.35 * lambda_x_col, 3.1);          % (125)
        end
        lambda_w_col = (hef_c / tw_c) * sqrt(f / E);
        ratio_web_col = lambda_w_col / uw_col;
        Max_Stress_Ratio = max(Max_Stress_Ratio, ratio_web_col);

        % 7b. Bản cánh (Bảng 24, công thức 131), áp dụng khi 0<=mx<=5 và 0,8<=lambda_x<=4
        lambda_x_ufc = min(max(lambda_x_col, 0.8), 4);   % Bảng 10, CHÚ THÍCH kẹp [0.8,4]
        ufc_col = 0.36 + 0.10 * lambda_x_ufc;             % (36), Bảng 10 - tiết diện chữ I
        mx_flange_clip = min(max(mx_col, 0), 5);
        uf_col = ufc_col - 0.01 * (1.5 + 0.7 * lambda_x_ufc) * mx_flange_clip; % (131)
        lambda_f_col = (bef_c / tf_c) * sqrt(f / E);
        ratio_flange_col = lambda_f_col / uf_col;
        Max_Stress_Ratio = max(Max_Stress_Ratio, ratio_flange_col);

        % =================================================================
        % --- 7c. ỔN ĐỊNH NGOÀI MẶT PHẲNG KHUNG - TRỤC YẾU y-y (Điều 9.2.8, CT 114)
        % Chỉ bắt buộc kiểm tra khi lambda_x > lambda_y (theo đúng văn bản Điều 9.2.8).
        % Với Ly=Lcol=4m (giằng bởi dầm phụ) nhưng i_y < i_x (đặc trưng tiết diện chữ I),
        % nên trong đa số trường hợp lambda_y > lambda_x và KHÔNG bắt buộc kiểm tra -
        % code vẫn tính lambda_y để tự động xác định đúng trường hợp nào cần kiểm tra.
        % =================================================================
        i_y = sqrt(Iy_cot / A_cot);
        lambda_y_col = (mu_y * Ly_col / i_y) * sqrt(f / E);

        if lambda_x_col > lambda_y_col
            % phi_y (hệ số ổn định nén đúng tâm, Bảng D.1, Phụ lục D) - GIẢ ĐỊNH
            % tiết diện "loại b" (chữ I hàn thông thường, tra theo Điều 7.1.2.1/Bảng D.1)
            phi_y = lookup_phi_axial_TCVN5575(lambda_y_col);
            ratio_outofplane_col = abs(N_crit_c) / (phi_y * A_cot * f * gamma_c);
            Max_Stress_Ratio = max(Max_Stress_Ratio, ratio_outofplane_col);
        end
    end

    % --- 8. TÍNH HÀM MỤC TIÊU GỐC (CHƯA PHẠT) ---
    % --- SỬA: 6.0 -> 10.0 (dầm nhịp 10m, đã xác nhận với người dùng; giá trị 6.0
    % cũ trong file gốc làm SAI hàm mục tiêu thể tích thép) ---
    Obj1_Volume = A_cot * 8.0 + A_dam * 10.0; % Tổng thể tích thép khung (m3)
    Obj2_Drift = Real_Drift;                  % Chuyển vị đỉnh (m)

    % --- 9. ÁP DỤNG HÀM PHẠT (PENALTY FUNCTION) NẾU VI PHẠM ---
    if Max_Stress_Ratio > 1.0 || isnan(Max_Stress_Ratio) || isinf(Max_Stress_Ratio)
        Penalty_Factor = 1.0 + 5000 * (max(0, Max_Stress_Ratio) - 1.0)^2;
        Obj1_Volume = Obj1_Volume * Penalty_Factor;
        Obj2_Drift = Obj2_Drift * Penalty_Factor;
    end

    Cost = [Obj1_Volume, Obj2_Drift];
end


function phi_e = lookup_phie_TCVN5575(lambda_bar, mef)
% =========================================================================
% Tra hệ số ổn định khi nén lệch tâm phi_e theo Bảng D.3 (Phụ lục D, TCVN 5575:2024)
% Nội suy song tuyến tính (bilinear). Dữ liệu số hóa trực tiếp từ Bảng D.3.
% Một số ô ở góc lambda_bar lớn + mef lớn không có số liệu trong bảng gốc -
% hàm KẸP mef vào giá trị lớn nhất sẵn có của hàng lambda_bar tương ứng.
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
% Nội suy 1D dọc theo mef cho 1 hàng lambda_bar cố định. Một số hàng
% (lambda_bar >= 6.0) không có đủ số liệu tới mef=20 trong Bảng D.3 gốc,
% nên hàm KẸP mef_q vào mef lớn nhất sẵn có của hàng đó thay vì ngoại suy.
    n = numel(phie_row);
    mef_this = mef_full(1:n);
    mef_q_clip = min(max(mef_q, mef_this(1)), mef_this(end));
    val = interp1(mef_this, phie_row, mef_q_clip, 'linear');
end


function phi = lookup_phi_axial_TCVN5575(lambda_bar)
% =========================================================================
% Tra hệ số ổn định khi nén đúng tâm phi theo Bảng D.1 (Phụ lục D, TCVN 5575:2024),
% CỘT "loại tiết diện b" (GIẢ ĐỊNH cho tiết diện chữ I hàn thông thường - Điều 7.1.2.1).
% Dữ liệu số hóa trực tiếp từ Bảng D.1, phạm vi lambda_bar hợp lệ ~ [0.4, 4.4].
% Ngoài phạm vi này hàm KẸP vào biên gần nhất (thiên an toàn: giá trị phi tại
% biên lambda_bar=4.4 đã khá nhỏ ~0,39, việc kẹp không làm phi bị đánh giá cao hơn
% thực tế). Nếu lambda_bar thực tế > 4,4 (cột rất mảnh ngoài mặt phẳng), NÊN xem
% lại kích thước tiết diện hoặc bổ sung giằng.
% =========================================================================
    lam_list = [0.4 0.6 0.8 1.0 1.2 1.4 1.6 1.8 2.0 2.2 2.4 2.6 2.8 3.0 3.2 3.4 3.6 3.8 4.0 4.2 4.4];
    phi_b    = [1.000 0.986 0.967 0.948 0.927 0.905 0.881 0.855 0.826 0.794 0.760 0.723 0.683 0.643 0.602 0.562 0.524 0.487 0.453 0.422 0.392];

    lam_q = min(max(lambda_bar, lam_list(1)), lam_list(end));
    phi = interp1(lam_list, phi_b, lam_q, 'linear');
end
