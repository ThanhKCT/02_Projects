function gamma0 = get_gamma_0()
% GET_GAMMA0 - Hệ số điều kiện làm việc của móng (gamma0)
fprintf('\nChọn loại móng:\n');
fprintf('1. Móng đơn\n');
fprintf('2. Móng nhiều cọc (móng nhóm)\n');
found_type = input('Nhập số loại móng (1 hoặc 2): ');
if found_type == 1
    gamma0 = 1.0;
elseif found_type == 2
    gamma0 = 1.15;
else
    error('Loại móng không hợp lệ.');
end
end
