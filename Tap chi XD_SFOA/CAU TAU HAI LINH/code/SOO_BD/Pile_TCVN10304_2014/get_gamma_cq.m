function gamma_cq = get_gamma_cq(pile_type, method)
% GET_GAMMA_CQ - Chọn hệ số điều kiện làm việc của đất dưới mũi cọc (gamma_cq)
% Theo tiêu chuẩn 7.2.3.1: chỉ đặc biệt cho trường hợp dùng bê tông cứng dưới nước (pile_type=3, method='underwater')

if pile_type == 3 && strcmpi(method, 'underwater')
    gamma_cq = 0.9;
else
    gamma_cq = 1.0;
end
end
