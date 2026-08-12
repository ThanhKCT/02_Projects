%% DTLZ6
% K. Deb, L. Thiele, M. Laumanns and E. Zitzler, "Scalable multi-objective optimization test problems,...
% " Proceedings of the 2002 Congress on Evolutionary Computation. CEC'02 (Cat. No.02TH8600), 2002, pp. 825-830 vol.1,...
% doi: 10.1109/CEC.2002.1007032.
function fx = DTLZ6(x)
x=x';
% dim=12;
% lb=[0,0,0,0,0,0,0,0,0,0,0,0];
% ub=[1,1,1,1,1,1,1,1,1,1,1,1];
M=3; % number of objective function
k = 10;
n = (M-1) + k;
% There is a gr in the article. But, as used in the file from the authors,
% gr = g
xm = x(n-k+1:end,:); %xm contains the last k variables
g = sum(xm.^0.1,1);
theta(1,:) = pi/2*x(1,:);
gr = g(ones(M-2,1),:); %replicates gr for the multiplication below
theta(2:M-1,:) = pi./(4*(1+gr)) .* (1 + 2*gr.*x(2:M-1,:));
% Finally, writes down the functions (there was a mistake in the article.
% There is no pi/2 multiplication inside the cosine and sine functions)
fx(1,:) = (1 + g).*prod(cos(theta(1:M-1,:)),1);
for ii = 2:M-1
    fx(ii,:) = (1 + g) .* prod(cos(theta(1:M-ii,:)),1) .*sin(theta(M-ii+1,:));
end
fx(M,:) = (1 + g).*sin(theta(1,:));
end
