function gamma_cf = get_gamma_cf(pile_type, soil_type, method)
% GET_GAMMA_CF - Chọn hệ số điều kiện làm việc của cọc trong đất (gamma_cf)
%   pile_type: integer (1-7)
%   soil_type: 'cat', 'catpha', 'setpha', 'set'
%   method: 'default', 'underwater', 'hard_concrete' (áp dụng cho pile_type 3)

soil_idx = find(strcmpi(soil_type, {'cat','catpha','setpha','set'}));
if isempty(soil_idx)
    error('Soil type must be one of: ''cat'', ''catpha'', ''setpha'', ''set''.');
end

gamma_cf_table = [
    0.8 0.8 0.8 0.7;  % 1
    0.9 0.9 0.9 0.9;  % 2
    0.7 0.7 0.7 0.7;  % 3a
    0.6 0.6 0.6 0.6;  % 3b
    0.8 0.8 0.8 0.8;  % 3c
    0.5 0.5 0.5 0.5;  % 4
    1.0 1.0 0.9 0.9;  % 5
    0.7 0.7 0.7 0.7;  % 6
    0.9 0.8 0.8 0.8   % 7 (phun nhồi, actually row 9)
];

if pile_type == 3
    switch lower(method)
        case 'default'
            row = 3;
        case 'underwater'
            row = 4;
        case 'hard_concrete'
            row = 5;
        otherwise
            error('For pile_type 3, method must be ''default'', ''underwater'', or ''hard_concrete''.');
    end
elseif pile_type == 4
    row = 6;
elseif pile_type == 5
    row = 7;
elseif pile_type == 6
    row = 8;
elseif pile_type == 7
    row = 9;
else
    row = pile_type; % fallback cho 1,2
end

gamma_cf = gamma_cf_table(row, soil_idx);
end
