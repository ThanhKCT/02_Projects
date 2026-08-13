function E = select_concrete_E_by_grade(fc)
% SELECT_CONCRETE_E_BY_GRADE - Returns modulus of elasticity (E) for concrete based on grade (fc)
%   fc: concrete compressive strength (MPa)
%   E : modulus of elasticity (kPa)

% ==== Tra bảng tiêu chuẩn (có thể mở rộng thêm) ====
table_fc = [200, 250, 300, 350, 400, 450, 500]; % MPa
table_E_MPa = [27000, 29000, 30500, 32000, 34000, 36000, 37500]; % MPa

idx = find(table_fc == fc, 1);

if ~isempty(idx)
    E = table_E_MPa(idx) * 1000; % đổi MPa -> kPa
else
    % Nếu không có trong bảng, dùng công thức gần đúng:
    % E (MPa) = 9500 * sqrt(fc)
    % Đổi sang kPa: nhân 1000
    E = 9500 * sqrt(fc) * 1000;
end

end