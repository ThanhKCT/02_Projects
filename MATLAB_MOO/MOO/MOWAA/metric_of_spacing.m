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

function S=metric_of_spacing(pareto_fun)

npf=size(pareto_fun,1);

for i=1:npf
    D1=repmat(pareto_fun(i,:),npf,1);
    D2=D1-pareto_fun;
    for j=1:npf
        % D3(j)=norm(D2(j,:)); 
        D3(j)=sum(abs(D2(j,:)));   
    end
    D3(i)=[];
    Distance(i)=min(D3);    
end

d_average=(1/npf)*sum(Distance);

total_distance=0;
for i=1:npf
 total_distance=total_distance+((Distance(i)-d_average)^2); 
end

%S=(sqrt(total_distance/npf))/d_average;
 S=(sqrt(total_distance/(npf-1)));
% S=(sqrt(total_distance/(npf)));

end
