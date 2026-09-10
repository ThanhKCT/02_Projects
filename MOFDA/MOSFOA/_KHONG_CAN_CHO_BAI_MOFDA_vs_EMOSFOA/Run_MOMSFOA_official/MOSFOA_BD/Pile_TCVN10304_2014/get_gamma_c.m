function gamma_c = get_gamma_c()
% GET_GAMMA_C - Chọn hệ số điều kiện làm việc của cọc (gamma_c)

gamma_c = 1.0; % cọc treo các loại, kể cả cọc ống có lõi đất hạ bằng phương pháp đóng hoặc ép
ask_1 = input('Tính toán sức chịu kéo? (1=Yes, 0=No): ');
ask_2 = input('Chiều sâu cọc lớn hơn 4m? (1=Yes, 0=No): ');
if ask_1 == 1 && ask_2 == 1
    gamma_c = 0.8;
elseif ask_1 == 1 && ask_2 == 0
    gamma_c = 0.6;
end
end
