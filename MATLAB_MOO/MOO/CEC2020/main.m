
%%
% close all
clear 
 tic % start to record the computation running time
clc
Max_iteration=1000; 
lb=-100;             
ub=100;              
dim=10;
Runs_times=3;
Obtained_Best_fitness=zeros(10,Runs_times);
Min_Best_fitness=zeros(10,1);
Min_Convergence_curve=zeros(10,Max_iteration);
Min_Best_X=zeros(dim,1);
Func_Num=[1:10];
SearchAgents_no=30;  
for i=1:10
   Min=inf;
   clear Best_X Best_Cost Convergence_curve
   for j=1:Runs_times     
        func_num=Func_Num(i);
        fhd=str2func('cec20_func');
        [Convergence_curve,Best_Cost,Best_X, Average_curve]=WAA(SearchAgents_no,Max_iteration,lb,ub,dim,fhd,func_num);
        Obtained_Best_fitness(i,j)=Best_Cost;
        if  Min>Best_Cost
            Min=Best_Cost;
			Min_Best_fitness(i,1)=Best_Cost;
            Min_Best_X(i,1:length(Best_X))=Best_X;   
			Min_Convergence_curve(i,1:length(Convergence_curve))=Convergence_curve';
        end 
    end
end

elapsedTime = toc; % record and save the running time in the variant elapsedTime
disp(['Computational running time: ', num2str(elapsedTime), ' second']);



