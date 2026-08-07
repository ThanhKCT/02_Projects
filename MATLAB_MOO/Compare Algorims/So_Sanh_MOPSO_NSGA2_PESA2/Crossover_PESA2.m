function [c1, c2] = Crossover_PESA2(p1, p2, params)

    % Giải nén các tham số truyền vào từ file pesa2.m
    gamma = params.gamma;
    VarMin = params.VarMin;
    VarMax = params.VarMax;
    
    % Tạo hệ số alpha ngẫu nhiên theo kích thước của vector bố mẹ
    alpha = rand(size(p1)) * (1 + 2*gamma) - gamma;
    
    % Tiến hành lai ghép tổ hợp tuyến tính
    y1 = alpha .* p1 + (1 - alpha) .* p2;
    y2 = alpha .* p2 + (1 - alpha) .* p1;
    
    % Ép biên cứng ngay lập tức để bảo vệ miền nghiệm [bc, hc, bd, hd, Rk]
    c1 = min(max(y1, VarMin), VarMax);
    c2 = min(max(y2, VarMin), VarMax);

end