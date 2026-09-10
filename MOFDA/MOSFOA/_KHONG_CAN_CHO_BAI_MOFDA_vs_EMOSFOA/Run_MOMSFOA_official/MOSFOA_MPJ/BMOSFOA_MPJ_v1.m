clear all; close all; clc
scriptDir = fileparts(mfilename('fullpath'));
addpath(fullfile(scriptDir,'Functions'));
addpath(fullfile(scriptDir,'MPJ_Sap'));
addpath(fullfile(scriptDir,'Pile_TCVN10304_2014'));
% data = readmatrix('Prestress_Pile_TCVN7888_2014.xlsx'); 
% save X1_X2.mat data
load('X1_X2.mat');

fun    = @Sap_MPJ;
   %X1,X2        X3    X4-stepx   X5stepy   X6-D   X7-W
lb=[1            16    3          3         0.5    0.5];
ub=[size(data,1) 39    6          6         2      2];

st=[1            0.1   0.1        0.1       0.1    0.1];
D=NaN.*ones(500,length(lb));
for i=1:length(lb)
    DD=[lb(i):st(i):ub(i)];
    D(1:length(DD),i) = DD';
end

nVar   = length(lb);
numObj = 2;

GP=0.5;
runMode = 'full'; % Use 'smoke' for a quick integration test or 'full' for final results.
switch lower(runMode)
    case 'smoke'
        Max_it = 1;
        Nr = 8;
        ngrid = 10;
        Nrun = 1;
        Npop = 8;
    case 'full'
        Max_it = 300;
        Nr = 100;
        ngrid = 10;
        Nrun = 1;
        Npop = 100;
    otherwise
        error('runMode must be either ''smoke'' or ''full''.');
end
fprintf('[B-MOSFOA MPJ] Run mode: %s; Npop=%d; Max_it=%d; expected FEs=%d.\n', ...
    upper(runMode),Npop,Max_it,Npop*(Max_it+1));

% Select the fraction of maximum logical workers used as parallel SAP2000 instances.
% Allowed values: 1.0 (maximum), 0.9, 0.8, 0.7, 0.6, or 0.5.
workerFraction = 0.8;
allowedWorkerFractions = [1.0 0.9 0.8 0.7 0.6 0.5];
if ~any(abs(workerFraction - allowedWorkerFractions) < 1e-12)
    error('workerFraction must be one of: 1.0, 0.9, 0.8, 0.7, 0.6, 0.5.');
end

localCluster = parcluster('local');
try
    detectedPhysicalCores = feature('numcores');
catch
    detectedPhysicalCores = NaN;
end
detectedPhysicalCores = max(1, floor(double(detectedPhysicalCores)));
detectedLogicalProcessors = str2double(getenv('NUMBER_OF_PROCESSORS'));
if isnan(detectedLogicalProcessors) || detectedLogicalProcessors < 1
    detectedLogicalProcessors = localCluster.NumWorkers;
end
detectedLogicalProcessors = max(1, floor(double(detectedLogicalProcessors)));
maxParallelSAP = min([detectedLogicalProcessors, localCluster.NumWorkers, Npop]);
Num_work = max(1, floor(workerFraction * maxParallelSAP));

ParallelConfig = struct( ...
    'WorkerFraction', workerFraction, ...
    'DetectedPhysicalCores', detectedPhysicalCores, ...
    'DetectedLogicalProcessors', detectedLogicalProcessors, ...
    'LocalClusterMaxWorkers', localCluster.NumWorkers, ...
    'MaxParallelSAP', maxParallelSAP, ...
    'NumSAPInstances', Num_work, ...
    'PopulationSize', Npop);
fprintf('[B-MOSFOA MPJ] Using %d SAP2000 instances (%.0f%% of %d max logical workers; physical cores: %d).\n', ...
    Num_work, 100*workerFraction, maxParallelSAP, detectedPhysicalCores);

DiagnosticColumns = {'RawCost','RawDisplacement','MaxAbsM2','MaxAbsM3', ...
    'MomentCapacity','MaxAbsAxialReaction','PileCapacity','M2Violation', ...
    'M3Violation','BearingViolation','TotalStructuralViolation','Penalty', ...
    'LengthConditionOK','TipSoilConditionOK','TipLayerThicknessOK', ...
    'BeamPileClearanceOK','SAPAnalysisExecuted','AllConstraintsSatisfied'};
RunInfo = struct;
RunInfo.Algorithm = 'B-MOSFOA';
RunInfo.CaseStudy = 'MJP';
RunInfo.RunMode = runMode;
RunInfo.StartTime = char(datetime('now','Format','yyyy-MM-dd HH:mm:ss Z'));
RunInfo.MATLABVersion = version;
RunInfo.MATLABRelease = version('-release');
RunInfo.ComputerArchitecture = computer;
RunInfo.HostName = getenv('COMPUTERNAME');
RunInfo.CPU = getenv('PROCESSOR_IDENTIFIER');
RunInfo.OS = getenv('OS');
try
    [~, systemMemory] = memory;
    RunInfo.TotalRAMGB = systemMemory.PhysicalMemory.Total/1024^3;
catch
    RunInfo.TotalRAMGB = NaN;
end
RunInfo.Parameters = struct('Npop',Npop,'MaxIterations',Max_it, ...
    'RepositorySize',Nr,'GridSize',ngrid,'GP0',GP,'Nrun',Nrun);
RunInfo.PenaltyCoefficient = 1e6;
RunInfo.HardInfeasibilityPenalty = 1e9;
RunInfo.FunctionEvaluationsPerRun = Npop*(Max_it+1);
RunInfo.FEDefinition = 'One candidate evaluated by Sap_MPJ counts as one FE.';
RunInfo.RuntimeDefinition = ['Elapsed wall-clock time measured by tic/toc. ', ...
    'SAPBatchWallTime is the maximum worker time per parallel evaluation batch.'];
experimentTimer = tic;
setupTimer = tic;
%% ng ton b ca s SAP2000 ang m (nu c)
system('taskkill /F /IM SAP2000.exe');
pause(2);

% Xpos = rand(Npop,nVar).*(ub-lb)+lb;
% for jj=1:size(Xpos,1)    
%     for ii=1:nVar
%         [~,b]=min(abs(D(:,ii)-Xpos(jj,ii))); 
%         Xpos(jj,ii)=D(b,ii);
%     end
% end
% FitLoc = fun(Xpos, data);
%% Bo m Parallel Pool khp vi Num_work
p = gcp('nocreate');
if isempty(p) || p.NumWorkers ~= Num_work
    delete(p);
    p = parpool('local', Num_work);
else
    p = gcp;
end
attachDirs = {scriptDir, fullfile(scriptDir,'Functions'), fullfile(scriptDir,'MPJ_Sap'), fullfile(scriptDir,'Pile_TCVN10304_2014')};
attachedFiles = {};
for iAttachDir = 1:numel(attachDirs)
    if exist(attachDirs{iAttachDir},'dir')
        dAttach = dir(fullfile(attachDirs{iAttachDir},'*.m'));
        attachedFiles = [attachedFiles; fullfile({dAttach.folder}', {dAttach.name}')]; %#ok<AGROW>
    end
end
if ~isempty(attachedFiles)
    addAttachedFiles(p, unique(attachedFiles));
end
spmd (Num_work)
    open_Sap2000(1);
    pause(2);
    SM.Hide;
    Sap_name0 = 'MPJ.sdb';
    Sap_path0 = fullfile(pwd,'MPJ_Sap',Sap_name0);
    SM.File.OpenFile(Sap_path0);
    try; SM.Hide; catch; end
    Sap_name_new = sprintf('MPJ_%d.sdb', spmdIndex);
    workerFolder = fullfile(pwd,'MPJ_Sap', sprintf('W%02d',spmdIndex));
    if ~exist(workerFolder,'dir'); mkdir(workerFolder); end
    Sap_path_save = fullfile(workerFolder, Sap_name_new);
    SM.File.Save('FileName', Sap_path_save);
    try; SM.Hide; catch; end
    maxNumCompThreads(1);
end
RunInfo.SAPSetupElapsedSeconds = toc(setupTimer);
Fitness = zeros(Npop, numObj);
newFit = zeros(Npop, numObj);
evaluatedDiagnostics = nan(Npop, numel(DiagnosticColumns));
newDiagnostics = nan(Npop, numel(DiagnosticColumns));
History = cell(Nrun,1);
EvaluationLog = cell(Nrun,1);
FinalValidation = cell(Nrun,1);
RunSummary = repmat(struct, Nrun, 1);
for iloop=1:Nrun
    runTimer = tic;
    totalFEs = Npop*(Max_it+1);
    evalCursor = 0;
    EvaluationLog{iloop}.X = nan(totalFEs,nVar);
    EvaluationLog{iloop}.Fitness = nan(totalFEs,numObj);
    EvaluationLog{iloop}.Diagnostics = nan(totalFEs,numel(DiagnosticColumns));
    EvaluationLog{iloop}.Generation = zeros(totalFEs,1,'uint32');
    EvaluationLog{iloop}.DiagnosticColumns = DiagnosticColumns;
    History{iloop}.Generation = (0:Max_it)';
    History{iloop}.CumulativeFEs = zeros(Max_it+1,1);
    History{iloop}.ElapsedWallTimeSeconds = zeros(Max_it+1,1);
    History{iloop}.SAPBatchWallTimeSeconds = zeros(Max_it+1,1);
    History{iloop}.SAPAggregateWorkerTimeSeconds = zeros(Max_it+1,1);
    History{iloop}.RepositorySize = zeros(Max_it+1,1);
    History{iloop}.BestObjectives = nan(Max_it+1,numObj);
    History{iloop}.ArchiveX = cell(Max_it+1,1);
    History{iloop}.ArchiveFitness = cell(Max_it+1,1);
    Xpos = rand(Npop,nVar).*(ub-lb)+lb;
    for jj=1:size(Xpos,1)    
        for ii=1:nVar
            [~,b]=min(abs(D(:,ii)-Xpos(jj,ii))); 
            Xpos(jj,ii)=D(b,ii);
        end
    end

    % Gi d liu n cc worker
    idx = mod(0:Npop-1, Num_work) + 1;
    
    spmd (Num_work)
        Xpart = Xpos(idx == spmdIndex, :);
        sapBatchTimer = tic;
        [FitLoc, DiagnosticLoc] = fun(Xpart, data);
        SAPBatchElapsedLoc = toc(sapBatchTimer);
    end
    sapWorkerTimes = zeros(Num_work,1);
    for i=1:Num_work
        Fitness(idx==i,:) = FitLoc{i};
        evaluatedDiagnostics(idx==i,:) = DiagnosticLoc{i};
        sapWorkerTimes(i) = SAPBatchElapsedLoc{i};
    end
DOM2            = checkDomination(Fitness); % 0 vt tri (tt hn); 1 b vt tri - (t hn)
REP{iloop}.Xpos                 = Xpos(~DOM2,:); % Lu nhng c th vt tri (tt hn)
REP{iloop}.Fitness             = Fitness(~DOM2,:); % Lu nhng fitness vt tri (tt hn)
REP{iloop}                     = updateGrid(REP{iloop},ngrid);
rows = evalCursor + (1:Npop);
EvaluationLog{iloop}.X(rows,:) = Xpos;
EvaluationLog{iloop}.Fitness(rows,:) = Fitness;
EvaluationLog{iloop}.Diagnostics(rows,:) = evaluatedDiagnostics;
EvaluationLog{iloop}.Generation(rows) = 0;
evalCursor = evalCursor + Npop;
History{iloop}.CumulativeFEs(1) = evalCursor;
History{iloop}.ElapsedWallTimeSeconds(1) = toc(runTimer);
History{iloop}.SAPBatchWallTimeSeconds(1) = max(sapWorkerTimes);
History{iloop}.SAPAggregateWorkerTimeSeconds(1) = sum(sapWorkerTimes);
History{iloop}.RepositorySize(1) = size(REP{iloop}.Xpos,1);
History{iloop}.BestObjectives(1,:) = min(REP{iloop}.Fitness,[],1);
History{iloop}.ArchiveX{1} = REP{iloop}.Xpos;
History{iloop}.ArchiveFitness{1} = REP{iloop}.Fitness;
plotting(REP{iloop},Fitness)
display(['Generation #0 - Repository size: ' num2str(size(REP{iloop}.Xpos,1))]);
newX = zeros(Npop,nVar);
%% Evolution
T = 1;
while T <= Max_it
    theta = pi/2*T./Max_it;
    tEO = (Max_it-T)/Max_it*cos(theta);
    h = selectLeader(REP{iloop});
    xposbest = REP{iloop}.Xpos(h,:);
    if rand < GP %  exploration of starfish
        for i = 1:Npop
            if nVar > 5
                % for nD is larger than 5
                jp1 = randperm(nVar,5);
                for j = 1:5
                    pm = (2*rand-1)*pi;
                    if rand < GP
                        newX(i,jp1(j)) = Xpos(i,jp1(j)) + pm*(xposbest(jp1(j))-Xpos(i,jp1(j)))*cos(theta);
                    else
                        newX(i,jp1(j)) = Xpos(i,jp1(j)) - pm*(xposbest(jp1(j))-Xpos(i,jp1(j)))*sin(theta);
                    end
                    if newX(i,jp1(j))>ub(jp1(j)) || newX(i,jp1(j))<lb(jp1(j))
                        newX(i,jp1(j)) = Xpos(i,jp1(j));
                    end
                end
            else
                % for nD is not larger than 5
                jp2 = ceil(nVar*rand);
                im = randperm(Npop);
                rand1 = 2*rand-1;
                rand2 = 2*rand-1;
                newX(i,jp2) = tEO*Xpos(i,jp2) + rand1*(Xpos(im(1),jp2)-Xpos(i,jp2))+rand2*(Xpos(im(2),jp2)-Xpos(i,jp2));
                if newX(i,jp2)>ub(jp2) || newX(i,jp2)<lb(jp2)
                    newX(i,jp2) = Xpos(i,jp2);
                end  
            end
            newX(i,:) = max(min(newX(i,:),ub),lb);  % boundary check
        end
    else % exploitation of starfish
        df = randperm(Npop,5);
        dm(1,:) = xposbest - Xpos(df(1),:);
        dm(2,:) = xposbest - Xpos(df(2),:);
        dm(3,:) = xposbest - Xpos(df(3),:);
        dm(4,:) = xposbest - Xpos(df(4),:);
        dm(5,:) = xposbest - Xpos(df(5),:);  % five arms of starfish
        for i = 1:Npop
            r1 = rand; r2 = rand;
            kp = randperm(length(df),2);
            newX(i,:) = Xpos(i,:) + r1*dm(kp(1),:) + r2*dm(kp(2),:);   % exploitation
            if i == Npop
                newX(i,:) = exp(-T*Npop/Max_it).*Xpos(i,:);  % regeneration of starfish
            end
            newX(i,:) = max(min(newX(i,:),ub),lb);  % boundary check
        end
    end
    for jj=1:size(newX,1)    
        for ii=1:nVar
            [~,b]=min(abs(D(:,ii)-newX(jj,ii))); 
            newX(jj,ii)=D(b,ii);
        end
    end
    idx = mod(0:Npop-1, Num_work) + 1;
    
    spmd (Num_work)
        Xpart = newX(idx == spmdIndex, :);
        sapBatchTimer = tic;
        [FitLoc, DiagnosticLoc] = fun(Xpart, data);
        SAPBatchElapsedLoc = toc(sapBatchTimer);
    end
    sapWorkerTimes = zeros(Num_work,1);
    for i=1:Num_work
        newFit(idx==i,:) = FitLoc{i};
        newDiagnostics(idx==i,:) = DiagnosticLoc{i};
        sapWorkerTimes(i) = SAPBatchElapsedLoc{i};
    end
    rows = evalCursor + (1:Npop);
    EvaluationLog{iloop}.X(rows,:) = newX;
    EvaluationLog{iloop}.Fitness(rows,:) = newFit;
    EvaluationLog{iloop}.Diagnostics(rows,:) = newDiagnostics;
    EvaluationLog{iloop}.Generation(rows) = T;
    evalCursor = evalCursor + Npop;
    DOM3=dominates(newFit,Fitness);
    Xpos(DOM3,:)=newX(DOM3,:);
    Fitness(DOM3,:)=newFit(DOM3,:);
    REP{iloop} = updateRepository(REP{iloop},newX,newFit,ngrid);
    if(size(REP{iloop}.Xpos,1)>Nr)
        REP{iloop} = deleteFromRepository(REP{iloop},size(REP{iloop}.Xpos,1)-Nr,ngrid);
    end
    historyIndex = T+1;
    History{iloop}.CumulativeFEs(historyIndex) = evalCursor;
    History{iloop}.ElapsedWallTimeSeconds(historyIndex) = toc(runTimer);
    History{iloop}.SAPBatchWallTimeSeconds(historyIndex) = max(sapWorkerTimes);
    History{iloop}.SAPAggregateWorkerTimeSeconds(historyIndex) = sum(sapWorkerTimes);
    History{iloop}.RepositorySize(historyIndex) = size(REP{iloop}.Xpos,1);
    History{iloop}.BestObjectives(historyIndex,:) = min(REP{iloop}.Fitness,[],1);
    History{iloop}.ArchiveX{historyIndex} = REP{iloop}.Xpos;
    History{iloop}.ArchiveFitness{historyIndex} = REP{iloop}.Fitness;
    plotting(REP{iloop},Fitness)
    hold on;
    display(['Iteration #' num2str(T) ' - Repository size: ' num2str(size(REP{iloop}.Xpos,1))]);
    elapsed = toc(runTimer)/60;
    if T>1
        time_left = (elapsed - time_consumption)*(Max_it - T);
        time_left = max(0, time_left/60); % gi
        fprintf('Estimated time left: %.2f hours\n', time_left);
    end
    time_consumption = elapsed;
   T = T+1;
end
assert(evalCursor == totalFEs, 'Recorded FE count does not match the evaluation budget.');
[foundFinal, finalRows] = ismember(REP{iloop}.Xpos, EvaluationLog{iloop}.X, 'rows');
assert(all(foundFinal), 'Some final repository solutions are missing from EvaluationLog.');
finalDiagnostics = EvaluationLog{iloop}.Diagnostics(finalRows,:);
designNames = arrayfun(@(k) sprintf('X%d',k),1:nVar,'UniformOutput',false);
validationNames = [designNames, {'PenalizedCost','PenalizedDisplacement'}, DiagnosticColumns];
FinalValidation{iloop} = array2table( ...
    [REP{iloop}.Xpos, REP{iloop}.Fitness, finalDiagnostics], ...
    'VariableNames', validationNames);
RunSummary(iloop).Run = iloop;
RunSummary(iloop).ElapsedWallTimeSeconds = toc(runTimer);
RunSummary(iloop).SAPBatchWallTimeSeconds = sum(History{iloop}.SAPBatchWallTimeSeconds);
RunSummary(iloop).SAPAggregateWorkerTimeSeconds = sum(History{iloop}.SAPAggregateWorkerTimeSeconds);
RunSummary(iloop).OptimizationOverheadSeconds = max(0, ...
    RunSummary(iloop).ElapsedWallTimeSeconds-RunSummary(iloop).SAPBatchWallTimeSeconds);
RunSummary(iloop).OptimizationFEs = evalCursor;
RunSummary(iloop).FinalRepositorySize = size(REP{iloop}.Xpos,1);
RunSummary(iloop).FeasibleFinalSolutions = sum(finalDiagnostics(:,18) > 0.5);
RunSummary(iloop).AllFinalSolutionsFeasible = all(finalDiagnostics(:,18) > 0.5);
end % end Nrun
RunInfo.EndTime = char(datetime('now','Format','yyyy-MM-dd HH:mm:ss Z'));
RunInfo.TotalElapsedSeconds = toc(experimentTimer);
RunInfo.ParallelConfig = ParallelConfig;
RunInfo.DiagnosticColumns = DiagnosticColumns;
system('taskkill /F /IM SAP2000.exe');
timestamp = datestr(now, 'yyyymmdd_HHMMSS');  % v d: 20250621_143015
Name_res = sprintf('MPJ_BMOSFOA_%s_%s_WF%03d_Npop%d_Nvar%d_Maxit%d.mat', ...
    upper(runMode),timestamp,round(100*workerFraction),Npop,nVar,Max_it);
save(Name_res,'REP','History','EvaluationLog','FinalValidation', ...
    'RunSummary','RunInfo','ParallelConfig','-v7.3')
% system('shutdown /s /t 0'); % Disabled: keep the computer running after completion.





