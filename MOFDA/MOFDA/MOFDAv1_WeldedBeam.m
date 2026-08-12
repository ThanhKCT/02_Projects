clear all; close all; clc;
addpath Functions
addpath WeldedBeam\
PF=load('weldedbeam.txt');

fun    = @Obj_function;
nVar   = 4;
numObj = 2;

lb=[0.125 0.1  0.1 0.125];
ub=[5.0 10.0 10.0 5.0];

Vmax        = 0.1*(ub(1)-lb(1));
Vmin        = -0.1*(ub(1)-lb(1));

% Parameters
Np          = 100;        % Population size
beta        = 2; %Number of neighborhoods

Nr          = 200;    % Repository size
maxiter     = 500;    % Maximum number of generations
ngrid       = 10;
Nrun=30;
for iloop = 1:Nrun
X               = initialization(Np,nVar,ub,lb);
% fit = fun(X);

for i=1:Np
    fit(i,:)             = fun(X(i,:));
end

X_nei        = zeros(beta,nVar);
fit_nei      = inf.*ones(beta,size(fit,2));

X_new           = inf(1,nVar);
fit_new         = inf(1,size(fit,2));

X_best                 = X;
fit_best               = fit;

DOM2                    = checkDomination(fit); % 0 vượt trội (tốt hơn); 1 bị vượt trội - (tệ hơn)
REP{iloop}.pos                 = X(~DOM2,:); % Lưu những cá thể vượt trội (tốt hơn)
REP{iloop}.pos_fit             = fit(~DOM2,:); % Lưu những fitness vượt trội (tốt hơn)
REP{iloop}                     = updateGrid(REP{iloop},ngrid);

iter      = 1;
% plotting(REP{iloop},fit)
% display(['Generation #0 - Repository size: ' num2str(size(REP{iloop}.pos,1))]);

for iter=1:maxiter
% Select leader
h = hybridSelectLeader(REP{iloop});
% Update W
W=(((1-iter/maxiter)^(2*randn)).*(rand(1,nVar).*iter/maxiter).*rand(1,nVar));
for i=1:Np
    for j=1:beta
        Xrand                       = lb+rand(1,nVar).*(ub-lb);
        delta_m                     = W.*(rand*Xrand-rand*X(i,:)).*norm(REP{iloop}.pos(h,:)-X(i,:));
        X_nei(j,:)      = X(i,:)+randn(1,nVar).*delta_m;
        X_nei(j,:)      = max(X_nei(j,:),lb);
        X_nei(j,:)      = min(X_nei(j,:),ub);
        fit_nei(j,:)    = fun(X_nei(j,:));
    end
    DOM1                   = checkDomination(fit_nei); % 0 vượt trội (tốt hơn); 1 bị vượt trội - (tệ hơn)
    REP_nei.pos                = X_nei(~DOM1,:); % Lưu những cá thể vượt trội (tốt hơn)
    REP_nei.pos_fit            = fit_nei(~DOM1,:); % Lưu những fitness vượt trội (tốt hơn)
    REP_nei                    = updateGrid01(REP_nei,ngrid);
    h_nei = hybridSelectLeader(REP_nei);
    %% Define X_new
    if dominates(REP_nei.pos_fit(h_nei,:),fit(i,:))
      % Calculate slope to neighborhood
      Sf=(REP_nei.pos_fit(h_nei,:)-fit(i,:))./sqrt(norm(REP_nei.pos(h_nei,:)-X(i,:)));%calculating slope
      % Update velocity of each flow
      V=mean(randn.*(Sf));
      % V=randn.*(Sf);
      if V<Vmin
          V= Vmin;
      elseif V>Vmax
          V= Vmax;
      end
      %Flow moves to best neighborhood
      X_new(i,:)=X(i,:)+V.*(X_nei(h_nei,:)-X(i,:))./sqrt(norm(X_nei(h_nei,:)-X(i,:)));
    else
      %Generate integer random number (r)
      r=randi([1 Np]);
      % Flow moves to r th flow if the fitness of r th flow is less than current flow
      if dominates(fit(r,:),fit(i,:))
         X_new(i,:)=X(i,:)+randn(1,nVar).*(X(r,:)-X(i,:));
      else
         X_new(i,:)=X(i,:)+randn*(REP{iloop}.pos(h,:)-X(i,:));
      end
    end
end
    X_new=max(X_new,lb);
    X_new=min(X_new,ub);
    % [fit_new, ~,~] = fun(X_new, numObj);
    for ij=1:Np
        fit_new(ij,:)=fun(X_new(ij,:));
    end

    DOM3=dominates(fit_new,fit);
    X(DOM3,:)=X_new(DOM3,:);
    fit(DOM3,:)=fit_new(DOM3,:);
    % fit=fit_new;
    REP{iloop} = updateRepository(REP{iloop},X_new,fit_new,ngrid);
    
    if(size(REP{iloop}.pos,1)>Nr)
        REP{iloop} = deleteFromRepository(REP{iloop},size(REP{iloop}.pos,1)-Nr,ngrid);
    end
% plotting(REP{iloop},fit)
% hold on;
% display(['Iteration #' num2str(iter) ' - Repository size: ' num2str(size(REP{iloop}.pos,1))]);

% % Update generation and check for termination
Indi.GD(iloop,iter)        = generational_distance(REP{iloop}.pos_fit',PF');
Indi.IGD(iloop,iter)       = inverted_generational_distance(REP{iloop}.pos_fit',PF');
Indi.STE(iloop,iter)       = spacing_to_extent(REP{iloop}.pos_fit');

Indi.SP(iloop,iter)        = Spread_matlab(REP{iloop}.pos_fit,PF);
Indi.MS(iloop,iter)        = metric_of_maximum_spread(REP{iloop}.pos_fit,PF);
Indi.GDS(iloop,iter)       = GeneralizedSpread_matlab(REP{iloop}.pos_fit,PF);
Indi.GD_01(iloop,iter)     = GD_matlab(REP{iloop}.pos_fit,PF);
Indi.EPS(iloop,iter)       = epsilon_matlab(REP{iloop}.pos_fit,PF);
Indi.DELTA(iloop,iter)     = Diversity_metric_delta(REP{iloop}.pos_fit,PF);
[Indi.HV(iloop,iter), ~]   = hypeIndicatorExact8(REP{iloop}.pos_fit, ones(1,size(fit,2)), size(fit,2));
% [HV(iter), ~]   = hypeIndicatorExact8(REP.pos_fit, ones(1,size(fit,2)), size(fit,2));

iter            = iter + 1;
end
end

resultFolder = fullfile(pwd, 'Results_MOFDA_new');
if ~exist(resultFolder, 'dir')
    mkdir(resultFolder);
end
fileName = sprintf('%s_MOFDAv01_%d.mat', 'WeldedBeam', nVar);
save(fullfile(resultFolder, fileName), 'REP', 'Indi')