 clear
clc
              
TestProblem='UF10';drawing_flag = 1;
nVar=30;

fobj = cec09(TestProblem);

xrange = xboundary(TestProblem, nVar);

% Lower bound and upper bound
lb=xrange(:,1)';
ub=xrange(:,2)';

VarSize=[1 nVar];

Population_num=100;
MaxIt=3000;  % Maximum Number of Iterations
Archive_size=100;   % Repository Size

alpha=0.1;  % Grid Inflation Parameter
nGrid=10;   % Number of Grids per each Dimension
beta=4; %=4;    % Leader Selection Pressure Parameter
gamma1=2;    % Extra (to be deleted) Repository Member Selection Pressure

% Initialization

Population=CreateEmptyParticle(Population_num);
Population_personalbest=CreateEmptyParticle(Population_num); %record personal best position and cost

for i=1:Population_num
    Population(i).Velocity=0;
    Population(i).Position=zeros(1,nVar);
    for j=1:nVar
        Population(i).Position(1,j)=unifrnd(lb(j),ub(j),1);
    end
    Population(i).Cost=fobj(Population(i).Position')';
    Population(i).Best.Position=Population(i).Position;
    Population(i).Best.Cost=Population(i).Cost;   
end

Population=DetermineDomination(Population);

Archive=GetNonDominatedParticles(Population);

Archive_costs=GetCosts(Archive);
Population_costs=GetCosts(Population);

G=CreateHypercubes(Archive_costs,nGrid,alpha);

for i=1:numel(Archive)
    [Archive(i).GridIndex Archive(i).GridSubIndex]=GetGridIndex(Archive(i),G);
end

% MOGWO main loop

for it=1:MaxIt
    a=2-it*((2)/MaxIt);
    
    % calculate the weighted average position
    clear Cost Cost2 Cost3 min_Cost max_Cost
    for i1=1:numel( Population)
        Cost(i1,:)= Population_costs(:,i1);%Archive_costs(:,i1);
    end
    
    for i2=1:min(size(Cost))
        max_Cost(i2)=max(Cost(:,i2));
        min_Cost(i2)=min(Cost(:,i2));
    end 
    n =(numel(Population)-4)*(it-1)/(1-MaxIt)+numel( Population);%nP;  
    for i3=1:n
        for i2=1:min(size(Cost))
            Cost2(i3,i2)=(Cost(i3,i2)-min_Cost(1,i2))/(max_Cost(1,i2)-min_Cost(1,i2));
        end
    end
    Cost3=sum(Cost2, 2);  
    miu=zeros(1,nVar); 
    sum_Cost=sum(Cost3);
    for i=1:n
		 miu(1,:)=miu(1,:)+Population(i).Position*(sum_Cost-Cost3(i))/(sum_Cost*(n-1));
    end
        
    for i=1:Population_num
        
        clear rep2
        clear rep3
        
        % Choose the alpha, beta, and delta grey wolves
        Best_X(1,:)=SelectLeader(Archive,beta);

        k1= (10*rand-1)*sin(pi*it/MaxIt); %2*(2*rand-1)*(1-it/Max_It); 
        k2= randi([1,3],1,1);   
        k3= rand;

        if  k1<0.5  
            switch k2
                case 1
                    Best_X_Position= Best_X.Position;
                   for j=1:nVar
                       beta=1.5+rand*0.5;
		               sigma1=gamma(1+beta)*sin(pi*beta/2)/(beta*gamma(0.5+0.5*beta)*2^(0.5*beta-0.5));
		               levy(j)=normrnd(0,sigma1^2)/abs(normrnd(0,1))^(-beta);
		               Population_tem_Position(1,j)= Best_X_Position(1,j)+levy(j);
                   end
                   Population(i).Position=Population_tem_Position;
                case 2
                   parent_index1 =  randi([1,size(Archive, 2)]);
                   parent1 = Archive(parent_index1).Position;
                   parent_index2 =  randi([1,size(Archive, 1)]);
                   parent2= Archive(parent_index2).Position;
                   crossoverPoint = randi([1, numel(parent1)]);
                   Population(i).Position= [parent1(1:crossoverPoint), parent2(crossoverPoint+1:end)];
                case 3
                  mutation_rate  = 0.1;    
                  parent_index =  randi([1,size(Archive, 1)]);
                  parent = Archive(parent_index).Position; 
                  Population(i).Position= parent + rand(1,numel(parent)).* mutation_rate;    
             end
       else
           switch k2
              case 1
                 Population(i).Position =rand*(miu(1,:)-Best_X(1,:).Position)+rand*(miu(1,:)-Population(i).Best.Position)+rand*miu(1,:) ;
              case 2
                 Population(i).Position =rand*(miu(1,:)-Best_X(1,:).Position)+rand*Best_X(1,:).Position;   
              case 3
                 Population(i).Position =rand*(miu(1,:)-Population(i).Best.Position)+rand*Population(i).Best.Position ;
           end 
        end

        % Boundary checking
        Population(i).Position=min(max(Population(i).Position,lb),ub);
        
        Population(i).Cost=fobj(Population(i).Position')';
        
        % Personal best position
        pos_best = dominates1(Population(i).Cost, Population(i).Best.Cost);
        if(sum(pos_best)>=1)
            Population(i).Best.Position=Population(i).Position; 
            Population(i).Best.Cost =Population(i).Cost; 
        end
         
    end
    
    % record personal best and update
    for i=1: Population_num
      Population_personalbest(i).Position= Population(i).Best.Position; 
      Population_personalbest(i).Cost=Population(i).Best.Cost;  
      Population_personalbest(i).Velocity=0;
    end 
    Population_personalbest=DetermineDomination(Population_personalbest);
    non_dominated_wolves1=GetNonDominatedParticles(Population_personalbest); 
    
    
    Population=DetermineDomination(Population);% comfirm the relation of the dominance
    non_dominated_wolves=GetNonDominatedParticles(Population); %receive the non-sorted solution
    
    Archive=[Archive(:);
        non_dominated_wolves(:);
        non_dominated_wolves1(:)].';
    
    Archive=DetermineDomination(Archive);% comfirm the relation of the dominance
    Archive=GetNonDominatedParticles(Archive);%receive the non-sorted solution
    
	
    for i=1:numel(Archive)
        [Archive(i).GridIndex Archive(i).GridSubIndex]=GetGridIndex(Archive(i),G);
    end
    
    if numel(Archive)>Archive_size
        EXTRA=numel(Archive)-Archive_size;
        Archive=DeleteFromRep(Archive,EXTRA,gamma1);
        
        Archive_costs=GetCosts(Archive);
        G=CreateHypercubes(Archive_costs,nGrid,alpha);
        
    end
    
               
    if exist('Archive1', 'var') == 1
       clear Archive
       Archive=Archive1;
       clear Archive1
    end
    
    Archive=DetermineDomination(Archive);
    Archive=GetNonDominatedParticles(Archive);

    disp(['In iteration ' num2str(it) ': Number of solutions in the archive = ' num2str(numel(Archive))]);

    
    % Results    
    costs=GetCosts(Population);
    Archive_costs=GetCosts(Archive);
    
    if drawing_flag==1
        hold off
        plot(costs(1,:),costs(2,:),'k.');
        hold on
        plot(Archive_costs(1,:),Archive_costs(2,:),'rd');
        legend('MOWAA','Non-dominated solutions');
        drawnow
    end
    
end

load('initial-non-sorted-solution.mat')

eval(['True_Pareto= ', TestProblem, ';'])

figure(2);
scatter3(True_Pareto(:,1),True_Pareto(:,2),True_Pareto(:,3),50, 'o', 'filled','MarkerEdgeColor', 'g', 'MarkerFaceColor', 'g');
hold on
scatter3(Archive_costs(1,:),Archive_costs(2,:),Archive_costs(3,:),50, 'o', 'filled','MarkerEdgeColor', 'b', 'MarkerFaceColor', 'r');

clear Archive2
for i=1:numel(Archive)
   Archive2(i,:)= Archive(i).Cost;
   Archive2_Position(i,:)= Archive(i).Position;
end

IGD = IGD_matlab(Archive2, True_Pareto);%IGD
GD = GD_matlab(Archive2, True_Pareto);%GD
spread = Spread_matlab(Archive2, True_Pareto);%SP
MS=metric_of_maximum_spread(True_Pareto,Archive2);%MS
S=metric_of_spacing(Archive2);%

Nadir=max(Archive_costs')'; % the worsest reference point
hv = hypervolume(Archive_costs', Nadir'); %hv

elapsedTime = toc; 
disp(['Total running time: ', num2str(elapsedTime), ' ']);


