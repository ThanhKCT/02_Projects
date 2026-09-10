function gammak = get_gamma_k()
% GET_GAMMAK - Hệ số cọc theo loại trường hợp chịu lực
fprintf('\nChọn trường hợp xác định hệ số gamma_k:\n');
fprintf('a. Cọc treo chịu tải trọng nén trong móng cọc đài thấp/cao trên lớp đất tốt... (nhập ''a'')\n');
fprintf('b. Cọc treo chịu tải trọng nén trong móng cọc đài cao hoặc trường hợp móng cọc đài cao, tuỳ số lượng cọc... (nhập ''b'')\n');
fprintf('c. Bãi cọc > 100 cọc, đài cọc lớn, độ lún giới hạn nhỏ... (nhập ''c'')\n');
tr_case = input('Nhập ký tự trường hợp (a, b hoặc c): ', 's');

switch lower(tr_case)
    case 'a'
        big_pile = input('Cọc chịu tải >600kN hoặc cọc khoan nhồi >2500kN? (1: Có, 0: Không): ');
        if big_pile
            gammak = 1.6; % hoặc 1.4 trong ngoặc, tùy tiêu chuẩn chi tiết
        else
            gammak = 1.4;
        end
    case 'b'
        n_piles = input('Nhập số lượng cọc trong móng: ');
        if n_piles >= 21
            gammak = 1.4;
        elseif n_piles >= 11
            gammak = 1.55;
        elseif n_piles >= 6
            gammak = 1.65;
        elseif n_piles >= 1
            gammak = 1.75;
        else
            error('Số lượng cọc phải >= 1');
        end
    case 'c'
        gammak = 1.0;
    otherwise
        error('Trường hợp gamma_k không hợp lệ (phải là a, b hoặc c).');
end
end
