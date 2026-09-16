function Mu_kNm = mu_beam_tcvn5574(b_m, h_m, cfg)
% MU_BEAM_TCVN5574  Mo-men khang uon LON NHAT kha di (TCVN 5574:2018) cua
% 1 tiet dien chu nhat dat cot don, VOI As theo dieu kien can bang (xi=xiR)
% - xem Cong_thuc_Bai_toan_Toi_uu_Bai6.md muc 3. Mu KHONG phu thuoc As that
% da thi cong (vi cot thep khai bao trong SAP chi la mac dinh module tu
% dong thiet ke, khong phai cot thep thuc te - xem FEM_Ben70000DWT_ChanMay.md
% muc 4/11), chi phu thuoc b, h, Rb, Rs.
%
%   Mu_kNm = mu_beam_tcvn5574(b_m, h_m, cfg)
%
% b_m, h_m : be rong, chieu cao tiet dien (m)
% cfg      : project_config_bai6() - dung cfg.mu.*

Rb = cfg.mu.Rb_kPa;           % kPa
Rs = cfg.mu.Rs_kPa;           % kPa
alphaR1 = cfg.mu.alphaR1;
sigma_scu = cfg.mu.sigma_scu_kPa;
a = cfg.mu.cover_m;

h0 = h_m - a;
if h0 <= 0
    Mu_kNm = 0;
    return;
end

omega = alphaR1 - 0.008*(Rb/1000); % Rb quy doi ve MPa cho dung dang cong thuc TCVN 5574:2018
xiR = omega / (1 + (Rs/sigma_scu)*(1 - omega/1.1));
alphaR = xiR*(1 - 0.5*xiR);

Mu_kNm = alphaR * Rb * b_m * h0^2; % Rb (kPa) * b*h0^2 (m^3) = kN.m

end
