function k = get_k_from_IL(IL)
%   GET_K_FROM_IL - Returns vector of k values based on liquidity index (IL)
%   k = get_k_from_IL(IL)
%   IL: vector of liquidity index values
%   k : vector of average k value for each soil layer (kN/m^4)
% IL 	                k_range (kN/m^4)	Mô tả đất chính (tham khảo bảng mô tả của bạn)
%-----------------------------------------------------------------------------------------
% IL < 0	            [18000 30000]	    Cát to, sét, sét pha cứng
% 0 ≤ IL ≤ 0.5	        [12000 18000]	    Cát hạt nhỏ/vừa/cát pha cứng, sét nửa cứng/đèo cứng
% 0 < IL ≤ 1	        [7000 12000]	    Cát bụi, cát pha dẻo, sét dẻo, sét pha dẻo mềm
% 0.5 < IL ≤ 0.75	    [7000 12000]	    Sét pha dẻo mềm
% 0.75 < IL ≤ 1	        [4000 7000]	        Sét dẻo chảy
% Đất hạt lớn, cát sạn	[50000 100000]	    (loại riêng, không phụ thuộc IL)
k = zeros(size(IL));
for i = 1:length(IL)
    il = IL(i);
    if il < 0
        k_range = [18000 30000];
    elseif il >= 0 && il <= 0.5
        k_range = [12000 18000];
    elseif il > 0.5 && il <= 0.75
        k_range = [7000 12000];
    elseif il > 0.75 && il <= 1
        k_range = [4000 7000];
    elseif il > 1
        k_range = [50000 100000]; % Gravelly soil, coarse sand (special case)
    else
        error('Invalid IL value!');
    end
    k(i) = mean(k_range);
end

end