
%%
clear; tic  % start to record the computation running time
clc;
Max_It=1000;        % Maximum Number of Iterations
nP = 30;           % Population Size

%%
Runs_times=1;

Obtained_Best_fitness=zeros(30,Runs_times);
Min_Best_fitness=zeros(30,1);
Min_Convergence_curve=zeros(30,Max_It);

j1=1;
for F1=1:30
  Min=inf;
  clear Best_X Best_Cost Convergence_curve
  for F2=1:Runs_times    
       fun =F1; 
       disp(['Function ' num2str(fun)]) 
       if j1==1
          [Lb,Ub,dim]=Get_Functions_detail2014(fun);   fobj=F1;
       else
           [Lb,Ub,dim]=Get_Functions_detail2014D50(fun);   fobj=F1;
       end
        [Convergence_curve,Best_Cost,Best_X]=WAA(nP,Max_It,Lb,Ub,dim,fobj);disp('WAA')
        Obtained_Best_fitness(F1,F2)=Best_Cost;
        if  Min>Best_Cost
            Min=Best_Cost;
			Min_Best_fitness(F1,1)=Best_Cost;
            Min_Best_X(F1,1:length(Best_X))=Best_X;   
			Min_Convergence_curve(F1,1:length(Convergence_curve))=Convergence_curve';
 		end 
 end
end
elapsedTime = toc; % record and save the running time in the variant elapsedTime
disp(['Computational running time: ', num2str(elapsedTime), ' second']);




