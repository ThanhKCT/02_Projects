function y = Mutate_PESA2(x, params)

    % Giải nén các tham số từ cấu trúc mutation_params truyền vào
    h = params.h;
    VarMin = params.VarMin;
    VarMax = params.VarMax;

    % Tính toán bước nhảy đột biến dựa trên độ lệch cấu trúc hình học
    sigma = h * (VarMax - VarMin);
    
    % Thực hiện đột biến Gauss chuẩn hệ thống
    y = x + sigma .* randn(size(x));
    
    % Ép biên cứng thích ứng tự động bảo vệ 5 biến [bc, hc, bd, hd, Rk]
    y = max(y, VarMin);
    y = min(y, VarMax);

end