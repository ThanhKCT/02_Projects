
%__________________________________________________________________     %
%        Multi-Objective Flow Direction Algorithm  (MOFDA)              %
%                                                                       %
%                                                                       %
%                  Developed in MATLAB R2024b (MacOs)                   %
%                                                                       %
%                      Author and programmer                            %
%                ---------------------------------                      %
%                Nima Khodadadi (ʘ‿ʘ)   University of Miami             %
%                             e-Mail                                    %
%                ---------------------------------                      %
%                      Nima.khodadadi@miami.edu                         %
%                                                                       %
%                                                                       %
%                            Homepage                                   %
%                ---------------------------------                      %
%                    https://nimakhodadadi.com                          %
%                                                                       %
%                                                                       %
%                                                                       %
%                                                                       %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


% ----------------------------------------------------------------------- %

function [Archive_F]=MOFDA(max_iter,Archive_size,alpha,dim,method,m)

if method==3
    TestProblem=sprintf('P%d',m);
    fhd= Ptest(TestProblem);
    xrange  = xboundaryP(TestProblem);
    dim=max(size(xrange));
    % Lower bound and upper bound
    lb=xrange(:,1)';
    ub=xrange(:,2)';
end
% Repository Size

Alpha=0.1;  % Grid Inflation Parameter
nGrid=10;   % Number of Grids per each Dimension
Beta=4; %=4;    % Leader Selection Pressure Parameter
gamma=2; 

%  FunctioNumber=60;

beta=dim;
maxiter=max_iter;%maximum iteration
flow_x=CreateEmptyParticle(alpha);
%% define fitness function
%%initializing
for i=1:alpha

    flow_x(i).Velocity=0;
    flow_x(i).Position=zeros(1,dim);
%     flow_x(i).Cost=fhd(flow_x(i).Position');
%     fitness_sorted(i,:)=norm(Moth_pos(i).Cost);
flow_x(i).Best.Position=flow_x(i).Position;
flow_x(i).Best.Cost=flow_x(i).Cost;
    flow_x(i,:).Position=lb+rand(1,dim).*(ub-lb);
    flow_x(i).Cost=fhd(flow_x(i,:).Position');
%     fitness_flow(i,:)=norm(flow_x(i).Cost);
end

flow_x=DetermineDominations(flow_x);
Archive=GetNonDominatedParticles(flow_x);

Archive_costs=GetCosts(Archive);
G=CreateHypercubes(Archive_costs,nGrid,Alpha);

for i=1:numel(Archive)
    [Archive(i).GridIndex Archive(i).GridSubIndex]=GetGridIndex(Archive(i),G);
end
%sorting
% [~,indx]=sort(fitness_flow);
% flow_x=flow_x(indx,:);
% fitness_flow=fitness_flow(indx);
% Best_fitness=fitness_flow(1);
% BestX=flow_x(1,:);
iter=0;
Vmax=max(0.1*(ub-lb));
Vmin=min(-0.1*(ub-lb));
% [Worst_fitnes,indx]=max(fitness_flow);
% Worst_flow=flow_x(indx,:);
%% main loop
for iter=1:maxiter
     Leader=SelectLeader(Archive,Beta);
    delta=(((1-1*iter/maxiter+eps)^(2*randn)).*(rand(1,dim).*iter/maxiter).*rand(1,dim));%for 56
    for i=1:alpha
        for j=1:beta
            Xrand=lb+rand(1,dim).*(ub-lb);
            neighbor_x(j,:).Position=flow_x(i,:).Position+randn(1,dim).*delta.*(rand*Xrand-rand*flow_x(i,:).Position).*norm(Leader.Position-flow_x(i,:).Position);%*norm(BestX-Worst_flow).*norm(ub-lb);
            neighbor_x(j,:).Position=max(neighbor_x(j,:).Position,lb);
            neighbor_x(j,:).Position=min(neighbor_x(j,:).Position,ub);
            neighbor_x(j).Cost=fhd(neighbor_x(j,:).Position');
           Funeval(j,:)=norm(neighbor_x(j).Cost); 
        end
          [~,indx]=sort(Funeval);
          if neighbor_x(indx(1)).Cost<flow_x(i).Cost
              Sf=(neighbor_x(indx(1)).Cost-flow_x(i).Cost)./sqrt(norm(neighbor_x(indx(1),:).Position-flow_x(i,:).Position));%calculating slope

              V=randn.*(norm(Sf));%calculating velocity
              if V<Vmin
                  V=-Vmin;
              elseif V>Vmax
                  V=-Vmax;
              end
              flow_x(i,:).Position=flow_x(i,:).Position+V.*(neighbor_x(indx(1),:).Position-flow_x(i,:).Position)./sqrt(norm(neighbor_x(indx(1),:).Position-flow_x(i,:).Position));
          else
              r=randi([1 alpha]);
             if flow_x(r).Cost<=flow_x(i).Cost
                 flow_x(i,:).Position=flow_x(i,:).Position+randn(1,dim).*(flow_x(r,:).Position-flow_x(i,:).Position);
              else
                 flow_x(i,:).Position=flow_x(i,:).Position+randn*(Leader.Position-flow_x(i,:).Position);
             end
          end
              flow_x(i,:).Position=max(flow_x(i,:).Position,lb);
              flow_x(i,:).Position=min(flow_x(i,:).Position,ub);
              flow_x(i).Cost=fhd(flow_x(i,:).Position');
%           if newflow_x(i).Cost<flow_x(i).Cost
%               flow_x(i,:).Position=newflow_x(i,:).Position;
%               flow_x(i).Cost=newflow_x(i).Cost;
%           end
         
%          if fitness_flow(i)<Best_fitness
%              BestX=flow_x(i,:);
%              Best_fitness=fitness_flow(i);
%          end 
%          fitness_history(i,iter)=fitness_flow(i);
%          position_history(i,iter,:)=1;%position_history(i,iter,:)=flow_x(i,:);
%           Trajectories(:,iter)=1;%Trajectories(:,iter)=flow_x(:,1);
    end 
    
    
    flow_x=DetermineDominations(flow_x);
    non_dominated_flow_x=GetNonDominatedParticles(flow_x);
    
    Archive=[Archive
        non_dominated_flow_x];
    
    Archive=DetermineDominations(Archive);
    Archive=GetNonDominatedParticles(Archive);
    
    
    for i=1:numel(Archive)
        [Archive(i).GridIndex Archive(i).GridSubIndex]=GetGridIndex(Archive(i),G);
    end
    
    if numel(Archive)>Archive_size
        EXTRA=numel(Archive)-Archive_size;
        Archive=DeleteFromRep(Archive,EXTRA,gamma);
        
        Archive_costs=GetCosts(Archive);
        G=CreateHypercubes(Archive_costs,nGrid,Alpha);
        
    end
%     [Worst_fitnes,indx]=max(fitness_flow);
%     Worst_flow=flow_x(indx,:);
%     ConvergenceCurve(iter)=Best_fitness;
    disp(['In iteration ' num2str(iter) ': Number of solutions in the archive = ' num2str(numel(Archive))]);
    save results
    
    % Results
    
    costs=GetCosts(flow_x);
    Archive_F=GetCosts(Archive);
%         disp(['MaxIter= ' ,num2str(iter), 'BestFit= ', num2str(Best_fitness)])%disply results


end