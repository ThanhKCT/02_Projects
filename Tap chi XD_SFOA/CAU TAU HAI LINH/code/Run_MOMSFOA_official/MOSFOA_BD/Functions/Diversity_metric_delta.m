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

function DELTA= Diversity_metric_delta(pareto_fun,Factual)
% pareto_fun = pareto_fun.pos_fit;
%-----------------2D--------------
[~,index]=sort(pareto_fun(:,1));

B=pareto_fun(index,:);
row=size(B,1);

for i=1:row-1
      Distance(i)=norm(B(i,:)-B(i+1,:));    
end

d_average= (1/row)*sum(Distance);
%----------------------3D------------
% row=size(pareto_fun,1);
% for i=1:row
%     D1=repmat(pareto_fun(i,:),row,1);
%     D2=D1-pareto_fun;
%     for j=1:row
%         D3(j)=norm(D2(j,:));        
%     end
%     D3(i)=[];
%     Distance(i)=min(D3);    
% end

% d_average= (1/row)*sum(Distance);
%--------------------------------------
total_distance=0;
for i=1:row-1
 total_distance=total_distance+abs((Distance(i)-d_average)); 
end
%------------------------------------2D-------------------
[~,index]=sort(Factual(:,1));
BB=Factual(index,:);

dF=norm(B(1,:)-BB(1,:));
dL=norm(B(end,:)-BB(end,:));

DELTA=(dF+dL+total_distance)/(dF+dL+((row-1)*d_average));
%----------------------------3D--------------------
% for j=1:size(Fmin,2)
%    [~,index1]=max(Factual(:,j));FF=Factual(index1,:);
%    [~,index1]=max(Fmin(:,j));ff=Fmin(index1,:);
%     DFL(j)=norm(FF-ff);
% end
% 
% DELTA=(sum(DFL)+total_distance)/(sum(DFL)+((row)*d_average));
end

