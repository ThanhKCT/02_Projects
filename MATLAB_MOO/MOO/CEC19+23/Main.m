

%%
clear; tic % start to record the computation running time
clc;

Max_It=1000;        % Maximum Number of Iterations
nP = 50;         % Population Size
Runs_times=30;

Obtained_Best_fitness=zeros(23,Runs_times);
Min_Best_fitness=zeros(23,1);
Min_Convergence_curve=zeros(23,Max_It);
%%
for F2=30
  Min=inf;
  clear Best_X Best_Cost Convergence_curve
  for  F1=1:Runs_times
       fun =F2; 
       disp(['Function ' num2str(fun)])
       [Lb,Ub,dim,fobj]=Get_Functions_details(fun);   
       [Convergence_curve,Best_Cost,Best_X]=WAA(nP,Max_It,Lb,Ub,dim,fobj);
        Obtained_Best_fitness(F2,F1)=Best_Cost;
         if  Min>Best_Cost
             Min=Best_Cost;
			 Min_Best_fitness(F2,1)=Best_Cost;
             Min_Best_X(F2,1:length(Best_X))=Best_X;   
			 Min_Convergence_curve(F2,1:length(Convergence_curve))=Convergence_curve';
 		 end 
 end
end
elapsedTime = toc; % record and save the running time in the variant elapsedTime
disp(['Computational running time: ', num2str(elapsedTime), ' second']);

