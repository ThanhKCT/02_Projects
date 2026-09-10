%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% run_MOSFOA_script.m
% Multiobjective Starfish Optimization Algorithm (MOSFOA) for Engineering Design and Optimal Power Flow Problems
% MATLAB R2024a
% Author and programmer: Mohammed Jameel (E-mail: moh.jameel@su.edu.ye; mohjameel555@gmail.com)
%
% This script is self-contained for running a MOSFOA test on ZDT3 problem
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

clc;close all;clear all;
global INF ub lb M dim 
 INF = 1.0e4;
fun='ZDT3';    
True_Pareto=load('ZDT3-PF.txt');
dim = 30;               % number of decision variables
M = 2;                  % number of objectives
ub = ones(1,dim);       % upper bounds
lb = zeros(1,dim);      % lower bounds

Npop   = 100;           % population size
Max_it = 300;           % max iterations
ishow  = 10;            % print every ishow iterations

ncon=0;                % Number of constraints
nreal=dim;             % Number of real variables
nbin=0;                % Number of binary variables
% Algorithm-specific parameter
GP=0.5;     
% Initialization
ncolumn =M+ncon+nreal+nbin+1+1+1; % cons_viol+rank+crowd_dist
pop = zeros(Npop,ncolumn);
for i=1:Npop
    pop(i,(M+1):(M+dim))=unifrnd(lb,ub,[1 dim]);
    pop(i,1:M) = [mo_test_function(pop(i,(M+1):(M+dim)),M,fun)]';
end
% Compute ranks and crowding distances and store in last two columns
pop = Rank_and_Crowding_Distance_Calculation(pop, M, ncon, nreal, nbin);
% Initialization of other parameters
temp_g=[];
for i=1:Npop
    if(pop(i,(ncolumn-1))==1)
        temp_g=[temp_g i];
    end
end
rep=pop(temp_g,:);
% ------------------- Main loop ------------------
for T= 1:Max_it 
     newStarfish=zeros(Npop,ncolumn);
    theta = pi/2*T./Max_it;
    tEO = (Max_it-T)/Max_it*cos(theta);
    sz=size(rep,1);
    if (sz==1)
            bestStarfish=rep;
        elseif (sz==2)
            bestStarfish=rep(randi(2),:);
        else
            bestStarfish=SelectBestStarfish(rep,ncolumn);
    end
    
     if rand < GP    % exploration of starfish
        for i = 1:Npop
            if dim > 5
                % for nD is larger than 5
                jp1 = randperm(dim,5);
                for j = 1:5
                    pm = (2*rand-1)*pi;
                    if rand < GP
                      newStarfish(i,M+jp1(j)) = pop(i,M+jp1(j)) + pm*(bestStarfish(1,M+jp1(j))-pop(i,M+jp1(j)))*cos(theta);
                    else
                        newStarfish(i,M+jp1(j)) = pop(i,M+jp1(j)) - pm*(bestStarfish(1,M+jp1(j))-pop(i,M+jp1(j)))*sin(theta);
                    end
                    if newStarfish(i,M+jp1(j))>ub(jp1(j)) || newStarfish(i,M+jp1(j))<lb(jp1(j))
                        newStarfish(i,M+jp1(j)) = pop(i,M+jp1(j));
                    end
                end
            else
                % for dim is not larger than 5
                jp2 = ceil(dim*rand);
                im = randperm(Npop);
                rand1 = 2*rand-1;
                rand2 = 2*rand-1;
                newStarfish(i,M+jp2) = tEO*pop(i,M+jp2) + rand1*(pop(im(1),M+jp2)-pop(i,M+jp2))+rand2*(pop(im(2),M+jp2)-pop(i,M+jp2));
                if newStarfish(i,M+jp2)>ub(jp2) || newStarfish(i,M+jp2)<lb(jp2)
                    newStarfish(i,M+jp2) = pop(i,M+jp2);
                end  
            end
            newStarfish(i,M+1:M+dim) = max(min(newStarfish(i,M+1:M+dim),ub),lb);  % boundary check
        newStarfish(i,1:M)= [mo_test_function(newStarfish(i,M+1:M+dim),M,fun)]'; % New cost evaluation
        end
    else % exploitation of starfish
        df = randperm(Npop,5);
        dm(1,M+1:M+dim) = bestStarfish(M+1:M+dim) - pop(df(1),M+1:M+dim);
        dm(2,M+1:M+dim) = bestStarfish(M+1:M+dim) - pop(df(2),M+1:M+dim);
        dm(3,M+1:M+dim) = bestStarfish(M+1:M+dim) - pop(df(3),M+1:M+dim);
        dm(4,M+1:M+dim) = bestStarfish(M+1:M+dim) - pop(df(4),M+1:M+dim);
        dm(5,M+1:M+dim) = bestStarfish(M+1:M+dim) - pop(df(5),M+1:M+dim);  % five arms of starfish
        for i = 1:Npop
            r1 = rand; r2 = rand;
            kp = randperm(length(df),2);
            newStarfish(i,M+1:M+dim) = pop(i,M+1:M+dim) + r1*dm(kp(1),M+1:M+dim) + r2*dm(kp(2),M+1:M+dim);   % exploitation
            if i == Npop
                newStarfish(i,M+1:M+dim) = exp(-T*Npop/Max_it).*pop(i,M+1:M+dim);  % regeneration of starfish
            end
            newStarfish(i,M+1:M+dim) = max(min(newStarfish(i,M+1:M+dim),ub),lb);  % boundary check
        newStarfish(i,1:M)= [mo_test_function(newStarfish(i,M+1:M+dim),M,fun)]'; % New cost evaluation
        end
     end
    mixedpop=[pop; newStarfish];
    mixedpop = Rank_and_Crowding_Distance_Calculation(mixedpop, M, ncon, nreal, nbin);
    pop = NondominatedSort_and_filling(mixedpop, M, ncon, nreal, nbin);
    temp_g=[];
    for i=1:Npop
        if(pop(i,(ncolumn-1))==1)
            temp_g=[temp_g i];
        end
    end
      rep=pop(temp_g,:);
    Front=rep(:,1:M);
    if rem(T, ishow) == 0
    fprintf('Generation: %d\n',T);        
    end
end
 %% ------------------- Plot results -------------------%%
plot(Front(:,1),Front(:,2),'bo','LineWidth',0.0001,...
          'MarkerEdgeColor','k',...
           'MarkerFaceColor','[0 0.7 0.7]',...
           'MarkerSize',15);
hold on
plot(True_Pareto(:,1),True_Pareto(:,2),'.','color',[1 0.5 0],'MarkerSize',25);
legend('MOSFOA','True PF','FontSize',10);
    xlabel('Obj_1','FontSize',10);
    ylabel('Obj_2','FontSize',10);
 set(gca,'FontSize',10)
  title('ZDT3 problem','FontSize', 15)
%% ------------------- Metrics -------------------
M_IGD=IGD_matlab(Front,True_Pareto);
M_HV=HV(Front,True_Pareto);
display(['The IGD Metric obtained by MOSFOA is : ', num2str(M_IGD)]);
display(['The HV Metric obtained by MOSFOA is  : ', num2str(M_HV)]);
