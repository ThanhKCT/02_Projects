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

function eps = epsilon_matlab(PF, truePF)
% PF=PF.pos_fit;
%STEP 1. Obtain the maximum and minimum values of the Pareto front
m1 = size(PF, 1);
m = size(truePF, 1);

%STEP 2. find the epsilon value
for i = 1:m
    temp = PF - repmat(truePF(i,:), m1, 1);
    eps_k = max(temp, [], 2);
    eps_j = min(eps_k);
    
    if i == 1
        eps = eps_j;
    elseif eps < eps_j
        eps = eps_j;
    end
end

end