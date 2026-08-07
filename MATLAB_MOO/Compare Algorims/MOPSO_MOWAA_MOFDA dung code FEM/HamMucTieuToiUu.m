function Cost = HamMucTieuToiUu(x)
    % Ho tro dem so lan goi ham (NFE - Number of Function Evaluations) de
    % kiem soat cong bang khi so sanh nhieu thuat toan:
    %   HamMucTieuToiUu('reset')  -> dat lai bo dem ve 0
    %   HamMucTieuToiUu()         -> doc so lan da goi ke tu lan reset gan nhat
    persistent nfe_count
    if isempty(nfe_count), nfe_count = 0; end

    if nargin == 0
        Cost = nfe_count;
        return;
    end
    if ischar(x) || isstring(x)
        nfe_count = 0;
        Cost = 0;
        return;
    end
    nfe_count = nfe_count + 1;

    % 1. Gọi động cơ FEM (Chuẩn đơn vị T-m)
    [U, NoiLuc, DoVong, TrongLuong] = TinhNoiLucKhung2T1N(x);

    % 2. Tính 2 hàm mục tiêu TRONG SẠCH (Chưa cộng phạt)
    f1 = TrongLuong * 1000;  % Đổi Tấn -> kg (Khung thực tế chỉ nặng 3000 - 8000 kg)
    f2 = abs(U(7));          % Đơn vị m (Thực tế chỉ 0.01 - 0.08 m)
    Cost = [f1; f2];

    % 3. Kiểm tra ràng buộc TCVN 5575:2024 (bền + ổn định tổng thể/cục bộ +
    % độ võng, xem chi tiết trong Check_TCVN5575.m) và áp dụng hàm phạt nhân
    Max_Stress_Ratio = Check_TCVN5575(x, NoiLuc, DoVong);
    if Max_Stress_Ratio > 1.0 || isnan(Max_Stress_Ratio) || isinf(Max_Stress_Ratio)
        Penalty_Factor = 1.0 + 5000 * (max(0, Max_Stress_Ratio) - 1.0)^2;
        Cost = Cost * Penalty_Factor;
    end
end
