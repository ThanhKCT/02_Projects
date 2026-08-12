%% DTLZ1
% K. Deb, L. Thiele, M. Laumanns and E. Zitzler, "Scalable multi-objective optimization test problems,...
% " Proceedings of the 2002 Congress on Evolutionary Computation. CEC'02 (Cat. No.02TH8600), 2002, pp. 825-830 vol.1,...
% doi: 10.1109/CEC.2002.1007032.
function fx = DTLZ1(x)
x=x';
% dim=7;
% lb=[0,0,0,0,0,0,0];
% ub=[1,1,1,1,1,1,1];
M=3; % number of objective function
k=5;
n = (M-1) + k;   % dimension
xm = x(M:end,:); %xm contains the last k variables
g = 100*(k + sum((xm - 0.5).^2 - cos(20*pi*(xm - 0.5)),1));
% Compute the functions
% The first and the last will be written separately to facilitate things
fx(1,:) = 1/2*prod(x(1:M-1,:),1).*(1 + g);
for ii = 2:M-1
    fx(ii,:) = 1/2*prod(x(1:M-ii,:),1).*(1 - x(M-ii+1,:)).*(1 + g);
end
fx(M,:) = 1/2*(1 - x(1,:)).*(1 + g);
end