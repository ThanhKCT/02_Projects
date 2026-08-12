function Nc_d = compute_Nc_d(Dp, tp, Lp, soil)
% COMPUTE_NC_D  Tinh kha nang chiu tai doc truc thiet ke cua coc theo
% TCVN 10304:2014 (cong thuc (23) trong bai chinh MOSFOAV2):
%
%   Nc,d = (gamma0 / (gamman*gammak)) * Rc,u
%   Rc,u = gammac * (gammacq*qb*Ab + u * SUM(gammacf * fi * li))
%
% *** CAN ANH/CHI CUNG CAP THONG SO DIA CHAT CHI TIET DE HOAN THIEN HAM NAY ***
% Cu the can:
%   - qb(z)  : suc chong mui don vi theo do sau z (kPa) - tra theo lop dat
%   - fi(z)  : ma sat ben don vi theo do sau z (kPa) - tra theo lop dat
%   - gamma0, gamman, gammak, gammac, gammacq, gammacf : cac he so theo
%     dieu kien lam viec / do tin cay / muc do quan trong cong trinh,
%     tra Bang trong TCVN 10304:2014 muc 7.1.
%
% Duoi day la khung tinh toan (placeholder) - CAN THAY BANG SO LIEU THAT.

    Ab = pi/4 * (Dp/1000)^2;      % dien tich mui coc (m2), Dp: mm -> m
    u  = pi * (Dp/1000);          % chu vi coc (m)

    % ---- TODO: THAY BANG DU LIEU DIA CHAT THAT (theo tung lop dat) ----
    soil_layers = soil.layers;    % struct array: [thickness_m, fi_kPa]
    qb = soil.qb_at_tip(Lp);      % suc chong mui tai cao do mui coc Lp (kPa)

    shaft_resistance = 0;
    depth_from_top = 0;
    for k = 1:numel(soil_layers)
        li = min(soil_layers(k).thickness_m, max(0, Lp - depth_from_top));
        if li <= 0
            continue;
        end
        shaft_resistance = shaft_resistance + soil_layers(k).fi_kPa * li;
        depth_from_top = depth_from_top + soil_layers(k).thickness_m;
        if depth_from_top >= Lp
            break;
        end
    end

    % He so - TODO: xac nhan gia tri chinh xac theo TCVN 10304:2014
    gamma0  = 1.0;
    gamman  = 1.15;   % vi du: cong trinh cap II
    gammak  = 1.4;    % vi du: he so tin cay theo dat
    gammac  = 1.0;
    gammacq = 1.0;
    gammacf = 1.0;

    Rc_u = gammac * (gammacq * qb * Ab + u * gammacf * shaft_resistance);
    Nc_d = (gamma0 / (gamman * gammak)) * Rc_u;
end
