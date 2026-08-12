%% DTLZ2
% K. Deb, L. Thiele, M. Laumanns and E. Zitzler, "Scalable multi-objective optimization test problems,...
% " Proceedings of the 2002 Congress on Evolutionary Computation. CEC'02 (Cat. No.02TH8600), 2002, pp. 825-830 vol.1,...
% doi: 10.1109/CEC.2002.1007032.
function fx = DTLZ2(x)
x=x';
% dim=12;
% lb=[0,0,0,0,0,0,0,0,0,0,0,0];
% ub=[1,1,1,1,1,1,1,1,1,1,1,1];
M=3; % number of objective function
k=10;
n = (M-1) + k;
xm = x(n-k+1:end,:); %xm contains the last k variables
g = sum((xm - 0.5).^2, 1);
% Compute the functions
fx(1,:) = (1 + g).*prod(cos(pi/2*x(1:M-1,:)),1);
for ii = 2:M-1
    fx(ii,:) = (1 + g) .* prod(cos(pi/2*x(1:M-ii,:)),1) .*sin(pi/2*x(M-ii+1,:));
end
fx(M,:) = (1 + g).*sin(pi/2*x(1,:));
end