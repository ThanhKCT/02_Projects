function [XYZ, X] = pile_create(P0, alpha, theta, t, k)
    %   alpha - góc nghiêng so với trục z (radian)
    %   theta - góc quay quanh trục z (radian)
    %   t     - vector 1x2, tham số dọc đường thẳng (thường [0, chiều dài])
    %   k     - hệ số ±1, chiều đi lên (k=1) hoặc xuống (k=-1)
    x = t .* sin(alpha) .* cos(theta);
    y = t .* sin(alpha) .* sin(theta);
    
    z = k .* t .* cos(alpha); % k=1 đi lên và k=-1 ngược lại
    
    % Cộng điểm gốc P0 để dịch chuyển đường thẳng
    X = [x', y', z'] + P0;
    XYZ=X(2,:);
end