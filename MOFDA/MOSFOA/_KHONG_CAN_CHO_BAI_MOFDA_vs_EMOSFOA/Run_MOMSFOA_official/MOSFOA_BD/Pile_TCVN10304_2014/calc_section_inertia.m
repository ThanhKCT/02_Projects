function I = calc_section_inertia(section_type, dims)
% CALC_SECTION_INERTIA - Calculate moment of inertia (I) for pile/beam sections
%   section_type: 'solid_round', 'hollow_round', 'square', 'rectangle'
%   dims:
%       - 'solid_round' : [D]           (D: diameter, m)
%       - 'hollow_round': [D, d]        (D: outer, d: inner, m)
%       - 'square'      : [b]           (b: edge, m)
%       - 'rectangle'   : [b, h]        (b: width, h: height, m)
%   I: moment of inertia (m^4)
% Cọc tròn đặc D = 0.4m
% I1 = calc_section_inertia('solid_round', [0.4]);
% Cọc ống tròn D=0.5m, d=0.4m
% I2 = calc_section_inertia('hollow_round', [0.5, 0.4]);
% Cọc vuông b=0.3m
% I3 = calc_section_inertia('square', [0.3]);
% Dầm hình chữ nhật b=0.25m, h=0.45m
% I4 = calc_section_inertia('rectangle', [0.25, 0.45]);
switch lower(section_type)
    case 'solid_round'
        D = dims(1);
        I = (pi/64) * D^4;
    case 'hollow_round'
        D = dims(1);
        d = dims(2);
        I = (pi/64) * (D^4 - d^4);
    case 'square'
        b = dims(1);
        I = b^4 / 12;
    case 'rectangle'
        b = dims(1);
        h = dims(2);
        I = b * h^3 / 12;
    otherwise
        error(['Invalid section type! Use ''solid_round'', ''hollow_round'', ',...
               '''square'', or ''rectangle''.']);
end

end