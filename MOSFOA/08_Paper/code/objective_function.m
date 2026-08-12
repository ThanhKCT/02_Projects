function [F_hat, info] = objective_function(X, catalog, soil, penalty_coef)
% OBJECTIVE_FUNCTION  Ham muc tieu + ham phat cho bai toan toi uu hoa
% ket cau tru va (BD), dung cho SFOA/PSO/GWO/WOA/HHO.
%
% INPUT:
%   X            - vector bien thiet ke lien tuc do thuat toan sinh ra
%                  X(1) = Dp (duong kinh, se duoc snap ve catalog)
%                  X(2) = tp (do day vach, se duoc snap ve catalog)
%                  X(3) = theta (goc nghieng, se duoc snap ve {6,7,8})
%                  X(4) = Lp (chieu dai coc, m)
%   catalog      - struct/table danh muc coc TCVN 7888:2014, co cac field:
%                  catalog.Dp   (vector duong kinh, mm)
%                  catalog.tp   (vector do day vach, mm)
%                  catalog.Price (vector don gia, $/m) - cung chi so voi Dp/tp
%                  catalog.Mcr  (vector mo men gay nut, kN.m) - cung chi so
%   soil         - struct thong so dia chat (qb, fi theo lop, chi so set IB...)
%                  ** CAN ANH/CHI CUNG CAP DE DIEN DAY DU **
%   penalty_coef - vector he so phat alpha_i cho 4 rang buoc g1..g4
%
% OUTPUT:
%   F_hat  - gia tri ham muc tieu co phat (dung cho thuat toan toi uu)
%   info   - struct luu lai: cost, constraints g1..g4, X_actual (da snap)

    if nargin < 4
        penalty_coef = [1e3, 1e3, 1e5, 1e5]; % TODO: dieu chinh theo ty le
    end

    %% 1. Snap bien roi rac ve gia tri catalog gan nhat
    [Dp_actual, idx] = snap_to_catalog(X(1), catalog.Dp);
    tp_actual        = catalog.tp(idx);      % tp gan voi Dp da chon (theo cung ma coc)
    price_pm         = catalog.Price(idx);   % don gia $/m
    Mcr              = catalog.Mcr(idx);     % mo men gay nut cua tiet dien da chon

    theta_actual = snap_to_catalog(X(3), [6, 7, 8]);
    Lp_actual    = round(X(4), 1);            % buoc 0.1 m theo Bang 1
    Lp_actual    = max(1, min(40, Lp_actual));

    X_actual = [Dp_actual, tp_actual, theta_actual, Lp_actual];

    %% 2. Goi mo hinh FEM (SAP2000) qua OAPI - xem update_BD_model_SAP2000.m
    % LUU Y: ham nay se cham (vai giay/lan goi) vi phai chay phan tich SAP2000.
    % Nen dung co che cache ben ngoai (xem run_SFOA_BD.m) de tranh goi lai
    % cho cung mot to hop X_actual.
    FEM = update_BD_model_SAP2000(X_actual);
    % FEM.Rc_FEA  - luc doc truc lon nhat trong coc (kN)
    % FEM.M_FEA   - mo men lon nhat trong coc (kN.m)
    % FEM.disp_max- chuyen vi lon nhat cua ket cau (m) - de tham khao/bao cao

    %% 3. Tinh chi phi (ham muc tieu goc) - Cong thuc (10)
    Np = 19; % TODO: xac nhan lai tong so coc BD (hien trang = 19 coc)
    cost = Np * Lp_actual * price_pm;

    %% 4. Tinh cac rang buoc g1..g4 - Cong thuc (11)-(14)
    Nc_d  = compute_Nc_d(Dp_actual, tp_actual, Lp_actual, soil);  % TCVN 10304:2014
    IB_tip  = soil.IB_at_depth(Lp_actual);                        % chi so set tai mui coc
    htip    = soil.bearing_layer_thickness(Lp_actual);            % do day lop chiu luc tai mui

    g1 = FEM.Rc_FEA - Nc_d;
    g2 = FEM.M_FEA  - Mcr;
    g3 = IB_tip - 0.35;
    g4 = 2 - htip;

    g = [g1, g2, g3, g4];

    %% 5. Ham phat - Cong thuc (15)-(16)
    P = sum(penalty_coef .* max(0, g));
    F_hat = cost + P;

    %% 6. Luu thong tin de xuat ket qua sau nay
    info.X_actual = X_actual;
    info.cost = cost;
    info.disp_max = FEM.disp_max;
    info.g = g;
    info.feasible = all(g <= 0);
end

function [val_snapped, idx] = snap_to_catalog(val, catalog_vals)
    [~, idx] = min(abs(catalog_vals - val));
    val_snapped = catalog_vals(idx);
end
