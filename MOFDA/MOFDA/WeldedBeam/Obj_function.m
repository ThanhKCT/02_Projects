%______________________________________________________________________________________
%  Multi-Objective Multi-Verse Optimization (MOMVO) algorithm source codes version 1.0
%
%  Developed in MATLAB R2016a
%
%  Author and programmer: Seyedali Mirjalili
%
%         e-Mail: ali.mirjalili@gmail.com
%                 seyedali.mirjalili@griffithuni.edu.au
%
%       Homepage: http://www.alimirjalili.com
%
%   Main paper:
%   S. Mirjalili, P. Jangir, S. Z. Mirjalili, S. Saremi, and I. N. Trivedi
%   Optimization of problems with multiple objectives using the multi-verse optimization algorithm, 
%   Knowledge-based Systems, 2017, DOI: http://dx.doi.org/10.1016/j.knosys.2017.07.018
%______________________________________________________________________________________

function o=Obj_function(x)
o = [0, 0];
% Welded beam design optimization
 o(1)=1.10471*x(1)^2*x(2)+0.04811*x(3)*x(4)*(14.0+x(2));
 o(2)=65856000/(30*10^6*x(4)*x(3)^3);
o=o+getnonlinear(x);

function Z=getnonlinear(x)
Z=0;
% Penalty constant
lam=10^15;
% Welded beam design optimization
Q=6000*(14+x(2)/2);
D=sqrt(x(2)^2/4+(x(1)+x(3))^2/4);
J=2*(x(1)*x(2)*sqrt(2)*(x(2)^2/12+(x(1)+x(3))^2/4));
alpha=6000/(sqrt(2)*x(1)*x(2));
beta=Q*D/J;
tau=sqrt(alpha^2+2*alpha*beta*x(2)/(2*D)+beta^2);
sigma=504000/(x(4)*x(3)^2);
tmpf=4.013*(30*10^6)/196;
P=tmpf*sqrt(x(3)^2*x(4)^6/36)*(1-x(3)*sqrt(30/48)/28);

g(1)=tau-13600;
g(2)=sigma-30000;
g(3)=x(1)-x(4);
g(4)=6000-P;
% No equality constraint in this problem, so empty;
geq=[];

% Apply inequality constraints
for k=1:length(g),
    Z=Z+ lam*g(k)^2*getH(g(k));
end
% Apply equality constraints
for k=1:length(geq),
   Z=Z+lam*geq(k)^2*getHeq(geq(k));
end

% Test if inequalities hold
% Index function H(g) for inequalities
function H=getH(g)
if g<=0,
    H=0;
else
    H=1;
end
% Index function for equalities
function H=getHeq(geq)
if geq==0,
   H=0;
else
   H=1;
end
% ----------------- end ------------------------------

