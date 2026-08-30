function cat = wharf100dwt_catalogue_btct()
% =========================================================================
% CATALOGUE CỌC BTCT LY TÂM (PHC) — ĐÃ CHỐT dùng thay cho quy đổi tỷ lệ.
% Nguồn: "Cataloge coc ly tam.md" (AMACCAO PILE, TCVN 7888:2014 & JIS A
% 5373:2016) — chỉ lấy 3 dòng D700/D800/D900 (nằm trong miền nghiên cứu
% D_BTCT 0,70-0,90 m đã chốt). Dùng CLASS A (thận trọng nhất — đã chốt,
% không thêm Class thành biến thứ 5).
%
% Đã kiểm chứng chéo: diện tích A trong catalogue KHỚP đúng công thức
% hình học vành khuyên A=pi/4*(D^2-(D-2t)^2) (vd D700/t110: tính tay
% 2038,7 cm^2 vs catalogue 2038,9 cm^2) -- xác nhận catalogue dùng đúng
% quy ước hình học, không phải số liệu rời rạc tuỳ ý.
%
% LƯU Ý QUAN TRỌNG: các giá trị Mcr/Mu/Pvl ở đây KHÁC với neo D800-540 lấy
% từ hồ sơ thiết kế gốc (Mcr=67,4 T.m, Mu=134,8 T.m, Pmax=658 T) vì hồ sơ
% gốc dùng thiết kế TÙY CHỈNH (D800, t=130mm, cấu hình cốt thép DƯL riêng
% của dự án Lạch Huyện) — KHÁC với D800 chuẩn của catalogue AMACCAO
% (t=120mm, Class A). Đây là lựa chọn CÓ CHỦ ĐÍCH của người dùng: chuyển
% từ "quy đổi tỷ lệ từ 1 thiết kế cụ thể" sang "chọn theo catalogue
% thương mại thật" cho bài toán tối ưu — không phải sai số/nhầm lẫn.
%
% Đơn vị trả về: D,t (m); A (m^2); Mcr,Mu (T.m); Pvl (T).
% Quy đổi kN.m -> T.m: x 0,101972 (1 kN = 1/9,80665 tonf).
% =========================================================================
    %       D(m)   t(m)   A(m^2)    Mcr(T.m) Mu(T.m)  Pvl(T)
    cat.D   = [0.700; 0.800; 0.900];
    cat.t   = [0.110; 0.120; 0.130];
    cat.A   = [0.203890; 0.256350; 0.314470]; % = A(cm^2)/10^4, theo catalogue muc 2
    cat.Mcr = [255.0; 362.8; 480.0] * 0.101972; % kN.m (Class A, muc 3) -> T.m
    cat.Mu  = [382.5; 544.3; 720.0] * 0.101972; % kN.m (Class A, muc 3) -> T.m
    cat.Pvl = [500; 680; 880]; % T -- lay CAN DUOI cua dai "PHC Class A/B" (muc 4, than trong nhat cho Class A)
    cat.n   = numel(cat.D);
end
