function [D, t, A, Mcr, Mu, Pmax] = wharf100dwt_pile_capacity_btct(catIdx, cfg) %#ok<INUSD>
% =========================================================================
% ĐÃ CHỐT LẠI: tra trực tiếp catalogue AMACCAO (Class A) theo CatIdx_BTCT
% -- KHÔNG còn quy đổi tỷ lệ từ neo D800-540 (bản cũ). Xem
% wharf100dwt_catalogue_btct.m để biết nguồn số liệu + đối chiếu hình học.
%
% catIdx: giá trị liên tục do MOFDA đề xuất (miền [1,3]) -- được làm tròn
% về số nguyên gần nhất TRONG HÀM NÀY để chọn đúng 1 dòng catalogue.
% =========================================================================
    cat = wharf100dwt_catalogue_btct();
    idx = round(catIdx);
    idx = max(1, min(cat.n, idx)); % kep trong [1, so dong catalogue]

    D    = cat.D(idx);
    t    = cat.t(idx);
    A    = cat.A(idx);
    Mcr  = cat.Mcr(idx);
    Mu   = cat.Mu(idx);
    Pmax = cat.Pvl(idx);
end
