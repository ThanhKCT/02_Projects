%% SOO_MD_run.m
% Single-objective SFOA (original algorithm) for the Mooring Dolphin (MD)
% structure. Adapted from the verified B-MOSFOA driver (BMOSFOA_MD_v3.m):
% same SAP2000-COM parallel worker infrastructure and Sap_MD_HL_v3 objective
% function, but WITHOUT any Pareto archive / repository / leader-selection
% mechanism. Only one objective column is optimized at a time (Cost or
% Displacement); the other is still logged for reporting.
%
% Usage (from MATLAB or `matlab -batch`):
%   objCol   = 1;              % 1 = Min Cost (case C3/MD-C), 2 = Min Displacement (case C4/MD-D)
%   runMode  = 'smoke';        % 'smoke' (tiny, for pipeline validation) or 'full' (paper spec)
%   Nrun     = 1;              % number of independent runs to execute in this call
%   runIdOffset = 0;           % label offset so repeated calls don't overwrite run indices
%   run('SOO_MD_run.m')
%
% Any of objCol/runMode/Nrun/runIdOffset not pre-set in the workspace fall
% back to the defaults below (objCol=1, runMode='smoke', Nrun=1, offset=0).

if ~exist('objCol','var');      objCol = 1;        end
if ~exist('runMode','var');     runMode = 'smoke';  end
if ~exist('Nrun','var');        Nrun = 1;           end
if ~exist('runIdOffset','var'); runIdOffset = 0;    end
assert(any(objCol==[1 2]), 'objCol must be 1 (Cost) or 2 (Displacement).');
objName = {'Cost','Displacement'}; objName = objName{objCol};

scriptDir = fileparts(mfilename('fullpath'));
cd(scriptDir);
addpath(fullfile(scriptDir,'Functions'));
addpath(fullfile(scriptDir,'MD_Sap'));
addpath(fullfile(scriptDir,'Pile_TCVN10304_2014'));
load('X1_X2.mat'); % loads: data  (pile catalogue, see MD_Sap/Prestress_Pile_TCVN7888_2014.xlsx)

fun = @Sap_MD_HL_v3;
   %X1: pile type (row index into data), X2: inclined-pile ratio, X3: pile length (m)
lb = [1            6   16];
ub = [size(data,1) 8   39];
st = [1            1   0.1];
D = NaN.*ones(500,length(lb));
for i = 1:length(lb)
    DD = lb(i):st(i):ub(i);
    D(1:length(DD),i) = DD';
end
nVar = length(lb);
GP = 0.5;

switch lower(runMode)
    case 'smoke'
        Max_it = 1;  Npop = 8;
    case 'pilot'
        Max_it = 150; Npop = 100; % convergence-check pilot, NOT paper data -- see SESSION_HANDOFF
    case 'full'
        Max_it = 300; Npop = 100;
    otherwise
        error('runMode must be ''smoke'', ''pilot'', or ''full''.');
end
fprintf('[SOO-MD-%s] Run mode: %s; Npop=%d; Max_it=%d; Nrun=%d; expected FEs=%d.\n', ...
    objName, upper(runMode), Npop, Max_it, Nrun, Nrun*Npop*(Max_it+1));

workerFraction = 0.8;
localCluster = parcluster('local');
try, detectedPhysicalCores = max(1,floor(double(feature('numcores')))); catch, detectedPhysicalCores = NaN; end
detectedLogicalProcessors = str2double(getenv('NUMBER_OF_PROCESSORS'));
if isnan(detectedLogicalProcessors) || detectedLogicalProcessors < 1
    detectedLogicalProcessors = localCluster.NumWorkers;
end
maxParallelSAP = min([detectedLogicalProcessors, localCluster.NumWorkers, Npop]);
Num_work = max(1, floor(workerFraction * maxParallelSAP));

DiagnosticColumns = {'RawCost','RawDisplacement','MaxAbsM2','MaxAbsM3', ...
    'MomentCapacity','MaxAbsAxialReaction','PileBearingCapacity','M2Violation', ...
    'M3Violation','BearingViolation','UpliftDemand','UpliftResistance', ...
    'UpliftViolation','TotalStructuralViolation','Penalty','LengthConditionOK', ...
    'TipSoilConditionOK','TipLayerThicknessOK','SAPAnalysisExecuted', ...
    'AllConstraintsSatisfied'};

outDir = fullfile(scriptDir,'results'); if ~exist(outDir,'dir'); mkdir(outDir); end
logFile = fullfile(outDir, sprintf('MD_%s_progress.log', objName));
flog = fopen(logFile,'a'); fprintf(flog,'\n=== Session start %s (mode=%s, Nrun=%d) ===\n', datestr(now), runMode, Nrun); fclose(flog);

system('taskkill /F /IM SAP2000.exe'); pause(2);
p = gcp('nocreate');
if isempty(p) || p.NumWorkers ~= Num_work
    delete(p); p = parpool('local', Num_work);
end
attachDirs = {scriptDir, fullfile(scriptDir,'Functions'), fullfile(scriptDir,'MD_Sap'), fullfile(scriptDir,'Pile_TCVN10304_2014')};
attachedFiles = {};
for k = 1:numel(attachDirs)
    dAttach = dir(fullfile(attachDirs{k},'*.m'));
    attachedFiles = [attachedFiles; fullfile({dAttach.folder}', {dAttach.name}')]; %#ok<AGROW>
end
addAttachedFiles(p, unique(attachedFiles));

spmd (Num_work)
    open_Sap2000(1); pause(2); SM.Hide;
    Sap_path0 = fullfile(pwd,'MD_Sap','MD_v3.sdb');
    SM.File.OpenFile(Sap_path0); try; SM.Hide; catch; end
    workerFolder = fullfile(pwd,'MD_Sap', sprintf('SOO_%s_W%02d', objName, spmdIndex));
    if ~exist(workerFolder,'dir'); mkdir(workerFolder); end
    SM.File.Save('FileName', fullfile(workerFolder, sprintf('MD_%d.sdb', spmdIndex)));
    try; SM.Hide; catch; end
    maxNumCompThreads(1);
end

for iloop = (1:Nrun) + runIdOffset
    runTag = sprintf('run%02d', iloop);
    runTimer = tic;
    Curve = nan(1,Max_it);
    RawCurve = nan(1,Max_it); % raw (un-penalized) value of the tracked objective at the running best
    FEcount = 0;

    Xpos = rand(Npop,nVar).*(ub-lb)+lb;
    for jj = 1:Npop
        for ii = 1:nVar
            [~,b] = min(abs(D(:,ii)-Xpos(jj,ii))); Xpos(jj,ii) = D(b,ii);
        end
    end
    idx = mod(0:Npop-1, Num_work) + 1;
    spmd (Num_work)
        Xpart = Xpos(idx == spmdIndex, :);
        [FitLoc, DiagLoc] = fun(Xpart, data);
    end
    FitAll = zeros(Npop,2); DiagAll = nan(Npop,numel(DiagnosticColumns));
    for i = 1:Num_work
        FitAll(idx==i,:) = FitLoc{i}; DiagAll(idx==i,:) = DiagLoc{i};
    end
    FEcount = FEcount + Npop;
    Fitness = FitAll(:,objCol);
    [fvalbest,order] = min(Fitness);
    xposbest = Xpos(order,:);
    rawbest = DiagAll(order, objCol); % DiagnosticColumns{1}=RawCost, {2}=RawDisplacement
    Curve(1) = fvalbest; RawCurve(1) = rawbest;
    BestDiag = DiagAll(order,:);

    newX = zeros(Npop,nVar);
    T = 1;
    while T <= Max_it
        theta = pi/2*T/Max_it; tEO = (Max_it-T)/Max_it*cos(theta);
        if rand < GP
            for i = 1:Npop
                jp2 = ceil(nVar*rand); im = randperm(Npop);
                r1 = 2*rand-1; r2 = 2*rand-1;
                newX(i,jp2) = tEO*Xpos(i,jp2) + r1*(Xpos(im(1),jp2)-Xpos(i,jp2)) + r2*(Xpos(im(2),jp2)-Xpos(i,jp2));
                if newX(i,jp2) > ub(jp2) || newX(i,jp2) < lb(jp2); newX(i,jp2) = Xpos(i,jp2); end
                newX(i,:) = max(min(newX(i,:),ub),lb);
            end
        else
            df = randperm(Npop,5);
            for k = 1:5; dm(k,:) = xposbest - Xpos(df(k),:); end %#ok<AGROW>
            for i = 1:Npop
                r1 = rand; r2 = rand; kp = randperm(5,2);
                newX(i,:) = Xpos(i,:) + r1*dm(kp(1),:) + r2*dm(kp(2),:);
                if i == Npop; newX(i,:) = exp(-T*Npop/Max_it).*Xpos(i,:); end
                newX(i,:) = max(min(newX(i,:),ub),lb);
            end
        end
        for jj = 1:Npop
            for ii = 1:nVar
                [~,b] = min(abs(D(:,ii)-newX(jj,ii))); newX(jj,ii) = D(b,ii);
            end
        end
        idx = mod(0:Npop-1, Num_work) + 1;
        spmd (Num_work)
            Xpart = newX(idx == spmdIndex, :);
            [FitLoc, DiagLoc] = fun(Xpart, data);
        end
        newFitAll = zeros(Npop,2); newDiagAll = nan(Npop,numel(DiagnosticColumns));
        for i = 1:Num_work
            newFitAll(idx==i,:) = FitLoc{i}; newDiagAll(idx==i,:) = DiagLoc{i};
        end
        FEcount = FEcount + Npop;
        newFitness = newFitAll(:,objCol);
        improved = newFitness < Fitness;
        Fitness(improved) = newFitness(improved);
        Xpos(improved,:) = newX(improved,:);
        [curBest,curOrder] = min(Fitness);
        if curBest < fvalbest
            fvalbest = curBest; xposbest = Xpos(curOrder,:);
            rowInNew = find(improved); % map back to diagnostics of the improving batch
            [~,relIdx] = min(newFitness(improved));
            if ~isempty(rowInNew)
                BestDiag = newDiagAll(rowInNew(relIdx),:);
            end
        end
        Curve(T) = fvalbest; RawCurve(T) = BestDiag(objCol);
        if mod(T,10)==0 || T==Max_it
            flog = fopen(logFile,'a');
            fprintf(flog,'[%s] %s it=%d/%d best(penalized)=%.4f raw=%.4f FEs=%d elapsed=%.1fs\n', ...
                datestr(now), runTag, T, Max_it, fvalbest, BestDiag(objCol), FEcount, toc(runTimer));
            fclose(flog);
        end
        T = T + 1;
    end

    RunResult.CaseStudy = 'MD';
    RunResult.Objective = objName;
    RunResult.ObjCol = objCol;
    RunResult.RunId = iloop;
    RunResult.Npop = Npop; RunResult.MaxIt = Max_it;
    RunResult.BestPenalized = fvalbest;
    RunResult.BestRaw = BestDiag(objCol);
    RunResult.BestX = xposbest;
    RunResult.BestDiagnostics = BestDiag;
    RunResult.DiagnosticColumns = DiagnosticColumns;
    RunResult.Curve = Curve;
    RunResult.RawCurve = RawCurve;
    RunResult.FEcount = FEcount;
    RunResult.ElapsedSeconds = toc(runTimer);
    RunResult.Timestamp = datestr(now,'yyyy-mm-dd HH:MM:SS');

    saveName = fullfile(outDir, sprintf('MD_SOO_%s_%s_%s.mat', objName, runTag, upper(runMode)));
    save(saveName,'RunResult');
    flog = fopen(logFile,'a');
    fprintf(flog,'[%s] %s DONE best(penalized)=%.4f raw=%.4f elapsed=%.1fs -> saved %s\n', ...
        datestr(now), runTag, fvalbest, BestDiag(objCol), RunResult.ElapsedSeconds, saveName);
    fclose(flog);
    fprintf('[SOO-MD-%s] %s complete: best(penalized)=%.4f raw=%.4f elapsed=%.1fs\n', ...
        objName, runTag, fvalbest, BestDiag(objCol), RunResult.ElapsedSeconds);
end

system('taskkill /F /IM SAP2000.exe');
fprintf('[SOO-MD-%s] All %d run(s) complete. Results in %s\n', objName, Nrun, outDir);
