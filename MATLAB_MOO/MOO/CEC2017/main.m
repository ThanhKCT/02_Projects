 clear all
 tic % start to record the computation running time
 clc
% mex cec17_func.cpp -DWINDOWS
func_num=1;
D=10;
Xmin=-100;
Xmax=100;
pop_size=30;
iter_max=1000;
Runs_times=3;
fhd=str2func('cec17_func');

Obtained_Best_fitness=zeros(23,Runs_times);
Min_Best_fitness=zeros(23,1);
Min_Convergence_curve=zeros(23,iter_max);
Min_Best_X=zeros(D,1);
for i=1:29
   func_num=i;
   Min=inf;
   clear Best_X Best_Cost Convergence_curve
   for j=1:Runs_times
       [Convergence_curve,Best_Cost,Best_X]=WAA(pop_size,iter_max,Xmin,Xmax,D,fhd,func_num);
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
