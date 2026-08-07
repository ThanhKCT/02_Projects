function y = Mutate_NSGA2(x, mu, sigma, VarMin, VarMax)
    % HÀM ĐỘT BIẾN CHUẨN: MUTATE CHO NSGA-II

    nVar = numel(x);
    y = x;

    % Duyệt qua từng gen để tiến hành đột biến
    for j = 1:nVar
        if rand <= mu
            y(j) = x(j) + sigma(j) * randn();
        end
    end

    % Khống chế biên an toàn cho cấu kiện chữ I
    y = max(y, VarMin);
    y = min(y, VarMax);
end