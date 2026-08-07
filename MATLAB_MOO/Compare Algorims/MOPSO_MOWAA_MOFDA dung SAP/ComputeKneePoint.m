function Knee = ComputeKneePoint(costs)
% =========================================================================
% XÁC ĐỊNH ĐIỂM GỐI (KNEE POINT) TRÊN MẶT TRẬN PARETO
% Phương pháp: chuẩn hóa 2 mục tiêu về [0,1], tìm điểm có khoảng cách vuông
% góc lớn nhất tới đường thẳng nối 2 điểm cực trị (min f1, min f2).
% Dùng chung cho MOPSO, MOWAA, MOFDA để đảm bảo tiêu chí so sánh nhất quán.
% =========================================================================
    f1 = costs(:,1); f2 = costs(:,2);
    f1_n = (f1 - min(f1)) / (max(f1) - min(f1) + eps);
    f2_n = (f2 - min(f2)) / (max(f2) - min(f2) + eps);

    [~, i1] = min(f1); [~, i2] = min(f2);
    A = f2_n(i2) - f2_n(i1);
    B = f1_n(i1) - f1_n(i2);
    C = f1_n(i2)*f2_n(i1) - f1_n(i1)*f2_n(i2);

    [~, knee_idx] = max(abs(A * f1_n + B * f2_n + C) / sqrt(A^2 + B^2 + eps));
    Knee = costs(knee_idx, :);
end
