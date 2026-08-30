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

function MS=metric_of_maximum_spread(pareto_fun,Factual)
% pareto_fun = pareto_fun.pos_fit;
[~,col]=size(Factual);

ms=0;
for i=1:col
   ms=ms+((max(pareto_fun(:,i))-min(pareto_fun(:,i)))/(max(Factual(:,i))-min(Factual(:,i))))^2;
   % ms=ms+((max(Fmin(:,i))-min(Fmin(:,i)))^2);
end
 
MS=sqrt(ms/col);
% MS=sqrt(ms);  

end