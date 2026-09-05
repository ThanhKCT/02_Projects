%% SOO_KeSauCau_run_SAP.m
% Single-objective SFOA (custom inline version, same as
% code/SOO_Ke/SOO_Ke_run_SAP.m) for the "Ke sau cau" wall-volume project,
% SAP2000-in-the-loop. Objective = concrete volume of 6 wall/slab zones
% (m3), penalized by TCVN 10304:2025/11820-5:2021/4116:2023/5574:2018
% constraint violations -- see Sap_KeSauCau.m's header for full sourcing.
%
% t_FE measured 2026-08-28: ~15-26s/evaluation (faster than the old Ke
% project's ~35s).
%
% Usage:
%   runMode = 'smoke';  % 'timing' (1 eval) | 'smoke' | 'pilot' | 'paper'
%   Nrun = 1; runIdOffset = 0;
%   run('SOO_KeSauCau_run_SAP.m')
% For a watchdog-supervised run, use watchdog_run.ps1 (in Ke_Sap\) instead
% of calling this directly -- SAP2000 OpenFile on this machine has been
% observed to intermittently balloon memory for 100-150s before settling;
% the watchdog tolerates that (see its header comment), a bare call does not.

if ~exist('runMode','var');     runMode = 'timing'; end
if ~exist('Nrun','var');        Nrun = 1;           end
if ~exist('runIdOffset','var'); runIdOffset = 0;    end
objName = 'WallVolume_SAP';

scriptDir = fileparts(mfilename('fullpath'));
cd(scriptDir);
addpath(fullfile(scriptDir,'..','..','..','code','Functions'));
addpath(fullfile(scriptDir,'Ke_Sap'));

sdbPath = fullfile(scriptDir,'..','..','Sap','ke pd 10.sdb');
if ~isfile(sdbPath)
    error('SOO_KeSauCau_run_SAP:MissingFile', ['ke pd 10.sdb not found at %s -- this must be the ' ...
        'GROUPED + verified model (Groups TUONGC30/.../Piles/WallTop), see precompute_wall_setup.m.'], sdbPath);
end

fun = @Sap_KeSauCau;
% Bounds (m). As-built (2026-08-28 as-modeled thicknesses): 0.30/0.30/0.43/
% 0.78/1.30/0.60. ub kept close to/above as-built as a safety margin.
%
% lb WIDENED 2026-09-04 (no longer first-pass): the official 'paper'
% campaign run 2026-08-30 against the ORIGINAL first-pass lb (0.20/0.20/
% 0.25/0.40/0.70/0.30, see git history) converged to BestX=[0.20 0.22 0.25
% 0.40 0.71 0.58] -- 3 of 6 variables (TUONGC30, TUONGM43, TUONGM78) sitting
% EXACTLY on that lb, and a 4th (TUONGM30=0.22) only 1 discretization step
% (0.01m) above its lb=0.20. That is the signature of a search-box
% limitation, not a converged interior optimum against the real TCVN
% constraints -- the optimizer wanted to go lower but the box stopped it.
% Widened to give every variable real room below where v1 settled:
% TUONGC30/TUONGM30/TUONGM43 lb 0.20->0.15 (v1 settled at/near 0.20-0.22),
% TUONGM78 lb 0.40->0.20 (v1 settled exactly at 0.40, largest headroom
% given), DAY130 lb 0.70->0.45 (v1 settled at 0.71, just above old lb).
% DAY60 lb left at 0.30 unchanged -- v1's DAY60=0.58 already sat comfortably
% above its old lb (28cm of margin), no evidence of a box limit there.
% ub/st unchanged from v1 -- only lb revisited per user instruction.
%              TUONGC30 TUONGM30 TUONGM43 TUONGM78 DAY130 DAY60
lb = [          0.15     0.15     0.15     0.20     0.45   0.30];
ub = [          0.40     0.40     0.50     0.90     1.40   0.70];
st = [          0.01     0.01     0.01     0.01     0.01   0.01];
D = NaN.*ones(500,length(lb));
for i = 1:length(lb)
    DD = lb(i):st(i):ub(i);
    D(1:length(DD),i) = DD';
end
nVar = length(lb);
GP = 0.5;

switch lower(runMode)
    case 'timing'
        Max_it = 0;   Npop = 1;
    case 'smoke'
        Max_it = 1;   Npop = 4;
    case 'pilot'
        Max_it = 5;   Npop = 10;
    case 'convpilot'
        % 2026-08-29: dedicated convergence-diagnostic pilot (single run) --
        % the 'pilot' run above (Max_it=5) showed NO plateau in its Curve
        % (still improving at the last iteration), so before locking the
        % 'paper' campaign's Max_it we need one real run at the intended
        % campaign Npop with a much larger Max_it, purely to see where the
        % convergence curve actually flattens. See dump_pilot_curve.m to
        % inspect the resulting Curve/RawCurve.
        Max_it = 40;  Npop = 15;
    case 'paper'
        % 2026-08-29: user's explicit final decision (application paper, not
        % an algorithm-comparison/development paper -> Nrun=1 is acceptable,
        % no need for multi-run mean/std statistics). Npop=50, Max_it=50
        % chosen deliberately ABOVE the convergence evidence from 'convpilot'
        % (Npop=15, Max_it=40 already plateaued hard by T~26-30, see that
        % case's comment) -- larger Npop=50 explores more per iteration, so
        % Max_it=50 gives a comfortable safety margin on top of already-
        % demonstrated convergence, not a guess. FE=50*(50+1)=2550/run;
        % at measured ~14.5-18s/FE (serial, 1 SAP2000 session) this is
        % ~10-13h wall-clock for the single run -- run via watchdog_run.ps1,
        % NOT directly (see Ke_Sap/run_paper.m).
        Max_it = 50;  Npop = 50;
    otherwise
        error('runMode must be ''timing'', ''smoke'', ''pilot'', ''convpilot'', or ''paper''.');
end
fprintf('[SOO-KeSauCau-SAP-%s] Run mode: %s; Npop=%d; Max_it=%d; Nrun=%d; expected FEs=%d; est. total time ~%.1f h (at t_FE~20s).\n', ...
    objName, upper(runMode), Npop, Max_it, Nrun, Nrun*Npop*(Max_it+1), Nrun*Npop*(Max_it+1)*20/3600);

DiagnosticColumns = {'Vconcrete_m3','PileBearingViolation_T','PileMaxRatio','LateralDisp_mm', ...
    'DisplacementLimit_mm','LateralViolation_mm','ShearViolation_Tm', ...
    'CrackViolation_mm','PunchingViolation_T','TotalStructuralViolation', ...
    'Penalty','SAPAnalysisExecuted','AllConstraintsSatisfied','t1','t2','t3','t4'};

outDir = fullfile(scriptDir,'results_SAP'); if ~exist(outDir,'dir'); mkdir(outDir); end
logFile = fullfile(outDir, sprintf('KeSauCau_%s_progress.log', objName));
flog = fopen(logFile,'a'); fprintf(flog,'\n=== Session (re)start %s (mode=%s, Nrun=%d) ===\n', datestr(now), runMode, Nrun); fclose(flog);

if strcmpi(runMode,'timing')
    fprintf('[SOO-KeSauCau-SAP] Opening SAP2000 session for timing check...\n');
    try
        open_Sap2000(1); pause(2); SM.Hide;
        ret = SM.File.OpenFile(sdbPath);
        if ret ~= 0; error('SOO_KeSauCau_run_SAP:OpenFileFailed', 'OpenFile ret=%d.', ret); end
        SM.SetPresentUnits(SM.eUnits.Ton_m_C);
        SM.Analyze.SetRunCaseFlag('MODAL', false);
        fprintf('[SOO-KeSauCau-SAP] SAP2000 session ready.\n');

        tTest = tic;
        Xtest = [0.30 0.30 0.43 0.78 1.30 0.60];
        [fitTest, diagTest] = Sap_KeSauCau(Xtest);
        tFE = toc(tTest);
        fprintf('[SOO-KeSauCau-SAP] Timing sanity call: X=%s -> fit=%.4f, Vconcrete=%.4fm3, t_FE=%.2fs\n', ...
            mat2str(Xtest), fitTest, diagTest(1), tFE);
        disp(array2table(diagTest, 'VariableNames', DiagnosticColumns));

        system('taskkill /F /IM SAP2000.exe');
    catch ME
        fprintf('[SOO-KeSauCau-SAP] CAUGHT ERROR: %s\n', ME.message);
        system('taskkill /F /IM SAP2000.exe');
        rethrow(ME);
    end
    return
end

%% --- Real SFOA runs: fresh SAP2000 session PER independent run, with
% checkpoint/resume so an external watchdog can kill+restart this whole
% MATLAB process at any point without losing more than one in-flight
% batch call (same discipline as SOO_Ke_run_SAP.m). ---
for iloop = (1:Nrun) + runIdOffset
    runTag = sprintf('run%02d', iloop);
    finalName = fullfile(outDir, sprintf('KeSauCau_SOO_%s_%s_%s.mat', objName, runTag, upper(runMode)));
    ckptName  = fullfile(outDir, sprintf('checkpoint_%s_%s.mat', runTag, upper(runMode)));

    if isfile(finalName)
        fprintf('[SOO-KeSauCau-SAP] %s: final result already exists (%s) -- skipping.\n', runTag, finalName);
        continue
    end

    runTimer = tic;
    try
        fprintf('[SOO-KeSauCau-SAP] %s: opening fresh SAP2000 session...\n', runTag);
        open_Sap2000(1); pause(2); SM.Hide;
        ret = SM.File.OpenFile(sdbPath);
        if ret ~= 0; error('SOO_KeSauCau_run_SAP:OpenFileFailed', 'OpenFile ret=%d.', ret); end
        SM.SetPresentUnits(SM.eUnits.Ton_m_C);
        SM.Analyze.SetRunCaseFlag('MODAL', false);
        fprintf('[SOO-KeSauCau-SAP] %s: session ready.\n', runTag);

        if isfile(ckptName)
            fprintf('[SOO-KeSauCau-SAP] %s: resuming from checkpoint %s\n', runTag, ckptName);
            S = load(ckptName);
            Xpos = S.Xpos; Fitness = S.Fitness; xposbest = S.xposbest; fvalbest = S.fvalbest;
            BestDiag = S.BestDiag; Curve = S.Curve; RawCurve = S.RawCurve; FEcount = S.FEcount;
            Tstart = S.T_next;
            fprintf('[SOO-KeSauCau-SAP] %s: resumed at T=%d/%d, current best(penalized)=%.6f\n', runTag, Tstart, Max_it, fvalbest);
        else
            fprintf('[SOO-KeSauCau-SAP] %s: starting SFOA fresh (Npop=%d, Max_it=%d)...\n', runTag, Npop, Max_it);
            Curve = nan(1,Max_it);
            RawCurve = nan(1,Max_it);
            FEcount = 0;

            Xpos = rand(Npop,nVar).*(ub-lb)+lb;
            for jj = 1:Npop
                for ii = 1:nVar
                    [~,b] = min(abs(D(:,ii)-Xpos(jj,ii))); Xpos(jj,ii) = D(b,ii);
                end
            end
            [FitAll, DiagAll] = fun(Xpos);
            FEcount = FEcount + Npop;
            Fitness = FitAll;
            [fvalbest,order] = min(Fitness);
            xposbest = Xpos(order,:);
            BestDiag = DiagAll(order,:);
            if Max_it >= 1; Curve(1) = fvalbest; RawCurve(1) = BestDiag(1); end
            Tstart = 1;

            flog = fopen(logFile,'a');
            fprintf(flog,'[%s] %s init Npop=%d done best(penalized)=%.6f raw=%.6f elapsed=%.2fs\n', ...
                datestr(now), runTag, Npop, fvalbest, BestDiag(1), toc(runTimer));
            fclose(flog);
            T_next = 1; %#ok<NASGU>
            save(ckptName,'Xpos','Fitness','xposbest','fvalbest','BestDiag','Curve','RawCurve','FEcount','T_next','Npop','Max_it');
        end

        newX = zeros(Npop,nVar);
        T = Tstart;
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
                df = randperm(Npop,min(5,Npop));
                dm = zeros(numel(df),nVar);
                for k = 1:numel(df); dm(k,:) = xposbest - Xpos(df(k),:); end
                for i = 1:Npop
                    r1 = rand; r2 = rand; kp = randperm(numel(df),min(2,numel(df)));
                    k2 = kp(min(2,numel(kp)));
                    newX(i,:) = Xpos(i,:) + r1*dm(kp(1),:) + r2*dm(k2,:);
                    if i == Npop; newX(i,:) = exp(-T*Npop/Max_it).*Xpos(i,:); end
                    newX(i,:) = max(min(newX(i,:),ub),lb);
                end
            end
            for jj = 1:Npop
                for ii = 1:nVar
                    [~,b] = min(abs(D(:,ii)-newX(jj,ii))); newX(jj,ii) = D(b,ii);
                end
            end
            [newFitAll, newDiagAll] = fun(newX);
            FEcount = FEcount + Npop;
            newFitness = newFitAll;
            improved = newFitness < Fitness;
            Fitness(improved) = newFitness(improved);
            Xpos(improved,:) = newX(improved,:);
            [curBest,curOrder] = min(Fitness);
            if curBest < fvalbest
                fvalbest = curBest; xposbest = Xpos(curOrder,:);
                rowInNew = find(improved);
                [~,relIdx] = min(newFitness(improved));
                if ~isempty(rowInNew)
                    BestDiag = newDiagAll(rowInNew(relIdx),:);
                end
            end
            Curve(T) = fvalbest; RawCurve(T) = BestDiag(1);
            flog = fopen(logFile,'a');
            fprintf(flog,'[%s] %s it=%d/%d best(penalized)=%.6f raw=%.6f FEs=%d elapsed=%.2fs\n', ...
                datestr(now), runTag, T, Max_it, fvalbest, BestDiag(1), FEcount, toc(runTimer));
            fclose(flog);

            T_next = T + 1; %#ok<NASGU>
            save(ckptName,'Xpos','Fitness','xposbest','fvalbest','BestDiag','Curve','RawCurve','FEcount','T_next','Npop','Max_it');
            T = T + 1;
        end

        RunResult = struct();
        RunResult.CaseStudy = 'KeSauCau';
        RunResult.Objective = objName;
        RunResult.RunId = iloop;
        RunResult.Npop = Npop; RunResult.MaxIt = Max_it;
        RunResult.BestPenalized = fvalbest;
        RunResult.BestRaw = BestDiag(1);
        RunResult.BestX = xposbest;
        RunResult.BestDiagnostics = BestDiag;
        RunResult.DiagnosticColumns = DiagnosticColumns;
        RunResult.Curve = Curve;
        RunResult.RawCurve = RawCurve;
        RunResult.FEcount = FEcount;
        RunResult.ElapsedSeconds = toc(runTimer);
        RunResult.Timestamp = datestr(now,'yyyy-mm-dd HH:MM:SS');

        save(finalName,'RunResult');
        if isfile(ckptName); delete(ckptName); end
        fprintf('[SOO-KeSauCau-SAP-%s] %s complete: best(penalized)=%.6f raw=%.6f elapsed=%.2fs -> %s\n', ...
            objName, runTag, fvalbest, BestDiag(1), RunResult.ElapsedSeconds, finalName);

        system('taskkill /F /IM SAP2000.exe');
    catch ME
        fprintf('[SOO-KeSauCau-SAP] %s CAUGHT ERROR (checkpoint preserved, will resume on next launch): %s\n', runTag, ME.message);
        flog = fopen(logFile,'a');
        fprintf(flog,'[%s] %s ERROR: %s\n', datestr(now), runTag, ME.message);
        fclose(flog);
        system('taskkill /F /IM SAP2000.exe');
        rethrow(ME);
    end
end

fprintf('[SOO-KeSauCau-SAP-%s] All %d requested run(s) attempted. Results in %s\n', objName, Nrun, outDir);
