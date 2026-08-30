function bp = get_equivalent_pile_width(D_pile)
% GET_EQUIVALENT_PILE_WIDTH - Calculate equivalent pile width (bp)
%   D_pile: pile diameter (m)
%   bp    : equivalent pile width (m)

if D_pile >= 0.8
    bp = D_pile + 1;
else
    bp = 1.5 * D_pile + 0.5;
end

end