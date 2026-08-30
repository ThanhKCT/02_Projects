function f1_tonnage = wharf100dwt_material_tonnage(D_BTCT, t_BTCT, D_thep, t_thep, cfg)
% =========================================================================
% f1 = tổng khối lượng vật lý cọc (tấn) -- ĐÃ CHỐT: dùng chiều dài chế tạo
% thực tế (không dùng chiều dài mô hình SAP đến điểm ngàm ảo), cộng khối
% lượng BTCT + thép cùng đơn vị tấn, không quy đổi chi phí.
%
% cfg.pile.sumLfab_BTCT_m / sumLfab_Thep_m = TỔNG chiều dài chế tạo của
% TỪNG CỌC trong nhóm (132 cọc BTCT, 60 cọc thép), suy ra từ fem_length_m
% thật của từng cọc (xem wharf100dwt_config.m + pile_length_table.csv) --
% không còn dùng "số cọc x chiều dài trung bình" như bản trước.
% (Tiết diện D,t giả định giống nhau cho mọi cọc cùng loại trong bài toán
% tối ưu này -- nên tổng khối lượng = A(D,t) x tổng chiều dài, không cần
% lặp qua từng cọc riêng lẻ.)
% =========================================================================
    A_btct = annulusArea(D_BTCT, t_BTCT);
    A_thep = annulusArea(D_thep, t_thep);

    mass_btct = A_btct * cfg.pile.sumLfab_BTCT_m * cfg.material.gammaConcrete; % tấn
    mass_thep = A_thep * cfg.pile.sumLfab_Thep_m * cfg.material.gammaSteel;    % tấn

    f1_tonnage = mass_btct + mass_thep;
end

function A = annulusArea(D, t)
    Din = D - 2*t;
    A = pi/4 * (D^2 - Din^2);
end
