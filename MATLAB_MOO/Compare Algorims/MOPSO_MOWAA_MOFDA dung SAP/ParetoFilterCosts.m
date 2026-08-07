function frontCosts = ParetoFilterCosts(costs)
% =========================================================================
% LỌC MẶT TRẬN PARETO TỪ MA TRẬN CHI PHÍ THÔ (không cần bọc struct)
% Input: costs (N x M) - mỗi hàng là 1 nghiệm, mỗi cột là 1 mục tiêu CẦN
% TỐI THIỂU HÓA. Trả về các hàng không bị trội (non-dominated).
%
% Dùng để xây "mặt trận tham chiếu"/"mặt trận gộp" khi so sánh hiệu năng
% nhiều thuật toán hoặc gộp nhiều lần chạy: hợp nhất tất cả nghiệm rồi lọc
% lại còn đúng các nghiệm tốt nhất (không trội).
% =========================================================================
    n = size(costs, 1);
    isDominated = false(n, 1);
    for i = 1:n
        if isDominated(i), continue; end
        for j = 1:n
            if i == j || isDominated(j), continue; end
            if all(costs(j,:) <= costs(i,:)) && any(costs(j,:) < costs(i,:))
                isDominated(i) = true;
                break;
            end
        end
    end
    frontCosts = costs(~isDominated, :);
end
