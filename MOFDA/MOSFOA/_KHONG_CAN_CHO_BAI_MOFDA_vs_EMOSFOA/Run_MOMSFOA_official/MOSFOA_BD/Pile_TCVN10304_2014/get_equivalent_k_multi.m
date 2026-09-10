function kq = get_equivalent_k_multi(h, k)
% GET_EQUIVALENT_K_MULTI - Calculate stepwise equivalent k for multi-layer soil
%   kq = get_equivalent_k_multi(h, k)
%   h : vector of soil layer thicknesses [h1 h2 ... hn]
%   k : vector of corresponding k values [k1 k2 ... kn]
%   kq: vector of equivalent k after each step (kq(2): 2 layers, kq(3): 3 layers, ...)

n = length(h);
kq = zeros(1, n); % Preallocate for speed and clarity

for i = 2:n
    if i == 2
        kq(i) = (k(1)*h(1)*(h(1)+2*h(2)) + k(2)*h(2)^2) / (h(1)+h(2))^2;
    elseif i == 3
        kq(i) = (k(1)*h(1)*(h(1)+2*(h(2)+h(3))) + k(2)*h(2)*(h(2)+2*h(3)) + k(3)*h(3)^2) / (h(1)+h(2)+h(3))^2;
    else % i > 3
        h_new = [sum(h(1:i-1)), h(i)];
        k_new = [kq(i-1), k(i)];
        kq_new = get_equivalent_k_multi(h_new, k_new);
        kq(i) = kq_new(end);
    end
end

kq(1) = k(1); % Remove the initial zero value for output clarity
end