function run_mosfoa2_parallel(proj, RunTag, Num_work, Npop, Max_it)
% RUN_MOSFOA2_PARALLEL  1 lan chay MOSFOA song song cho 1 cong trinh (A/B)
% cua Bai 2 - dung lai NGUYEN VEN loi thuat toan E-MOSFOA da chay that va
% cong bo o Bai 1 (MOFDA vs MOSFOA), CHI thay:
%   (1) ham muc tieu -> mosfoa2_evaluate_batch.m (Bai 2: 1 bien catalogue,
%       khong phai 3 bien BTCT+thep nhu Bai 1),
%   (2) bien thiet ke/bounds -> [1, K] voi K = so dong catalogue,
%   (3) duong dan model/cfg -> project_config(proj) cua Bai 2.
% KHONG sua doi co che cap nhat vi tri (exploration/exploitation, cosine
% phase-control, Gaussian refinement cuoi campaign) - nguon:
% MOFDA/Wharf100DWT/run_emosfoa_wharf100dwt_parallel.m (Bai 1), chinh no
% lay tu "MOSFOA/Run_MOMSFOA_official/MOSFOA_BD/EMOSFOA_BD_v3.m" (thuat
% toan da cong bo, xem Yeu_cau_trien_khai_Bai_2.md muc 1: KHONG duoc sua
% MOSFOA trong Bai 2).
%
%   run_mosfoa2_parallel('A', 'run01', 8, 8, 20)
%   run_mosfoa2_parallel('B', 'run01', 8, 8, 20)
%
% Checkpoint/resume + ghi atomic + RunTag de chay nhieu lan doc lap khong
% ghi de - dung theo ky luat Cach ket noi_SAP2000_MATLAB_OPTIMIZATION.md
% muc 5.
%
% *** BAT BUOC chay bang `-r`, KHONG dung `-batch` (COM automation). ***

if nargin < 3 || isempty(Num_work), Num_work = 8; end
if nargin < 4 || isempty(Npop), Npop = 8; end
if nargin < 5 || isempty(Max_it), Max_it = 20; end

scriptDir = fileparts(mfilename('fullpath'));
addpath(scriptDir);
mofdaFunctionsDir = fullfile(fileparts(fileparts(scriptDir)), 'MOFDA', 'MOFDA', 'Functions');
addpath(mofdaFunctionsDir); % checkDomination, dominates, updateGrid, updateRepository,
% deleteFromRepository, selectLeader, hypervolume - DUNG CHUNG voi Bai 1, KHONG sao chep lai

cfg = project_config(proj);
cat = pile_catalogue_AMACCAO();
K = numel(cat);

Nr = 100;      % dung chung gia tri Bai 1 (khong anh huong - K=33 << Nr)
ngrid = 10;    % dung chung Bai 1
GP0 = 0.5;     % dung chung Bai 1 (E-MOSFOA goc)
lb = 1; ub = K; nVar = 1;

resultsDir = fullfile(scriptDir, 'results');
if ~exist(resultsDir, 'dir'), mkdir(resultsDir); end

tagSuffix = ['_' RunTag];
finalFile = fullfile(resultsDir, sprintf('MOSFOA2_%s_Np%d_Maxit%d%s_FINAL.mat', upper(proj), Npop, Max_it, tagSuffix));
if isfile(finalFile)
    fprintf('Da co file ket qua cuoi: %s - BO QUA, khong chay lai.\n', finalFile);
    return;
end
ckptFile = fullfile(resultsDir, sprintf('MOSFOA2_%s_Np%d_Maxit%d%s_CKPT.mat', upper(proj), Npop, Max_it, tagSuffix));

fprintf('[MOSFOA2 %s - %s - SONG SONG] Np=%d Max_it=%d Nr=%d Num_work=%d K=%d (FE uoc tinh=%d)\n', ...
    proj, RunTag, Npop, Max_it, Nr, Num_work, K, Npop*(Max_it+1));

system('taskkill /F /IM SAP2000.exe');
pause(2);

p = gcp('nocreate');
if isempty(p) || p.NumWorkers ~= Num_work
    delete(p);
    p = parpool('local', Num_work); %#ok<NASGU>
end
d = dir(fullfile(scriptDir, '*.m'));
attachedFiles = fullfile({d.folder}', {d.name}');
addAttachedFiles(gcp, unique(attachedFiles));

sdbPath = cfg.sdb_path;
spmd (Num_work)
    maxNumCompThreads(1);
    [~, ~] = open_Sap2000_worker_v2(sdbPath, spmdIndex);
end

if isfile(ckptFile)
    fprintf('Tim thay checkpoint %s - dang nap lai de tiep tuc...\n', ckptFile);
    S = load(ckptFile);
    Xpos = S.Xpos; Fitness = S.Fitness; REP = S.REP; History = S.History; %#ok<NASGU>
    Tstart = S.lastIter + 1;
    fprintf('Tiep tuc tu vong lap %d/%d.\n', Tstart, Max_it);
else
    Xpos = lb + rand(Npop, nVar) .* (ub - lb); % KHONG snap ve luoi - tim kiem lien tuc, lam tron o buoc danh gia
    Fitness = batchEvaluateParallel(Xpos, proj, cat, cfg, Num_work);

    DOM = checkDomination(Fitness);
    REP.pos = Xpos(~DOM, :);
    REP.pos_fit = Fitness(~DOM, :);
    REP = updateGrid(REP, ngrid);

    History.CumulativeFEs = zeros(Max_it+1, 1);
    History.BestObjectives = nan(Max_it+1, 2);
    History.RepositorySize = zeros(Max_it+1, 1);
    History.Hypervolume = nan(Max_it+1, 1);
    History.ArchiveX = cell(Max_it+1, 1);
    History.ArchiveFitness = cell(Max_it+1, 1);
    History.CumulativeFEs(1) = Npop;
    History.BestObjectives(1,:) = min(REP.pos_fit, [], 1);
    History.RepositorySize(1) = size(REP.pos, 1);
    History.ArchiveX{1} = REP.pos;
    History.ArchiveFitness{1} = REP.pos_fit;
    fprintf('The he #0 - Kich thuoc Repository: %d\n', size(REP.pos,1));

    Tstart = 1;
    saveCheckpointAtomic(ckptFile, Xpos, Fitness, REP, History, 0);
end

expTimer = tic;
try
    for T = Tstart:Max_it
        theta = (pi/2) * (T/Max_it)^1.5;
        tEO = (Max_it-T)/Max_it * cos(theta);
        h = selectLeader(REP);
        Xposbest = REP.pos(h,:);
        GPt = GP0 * 0.5 * (1 + cos(pi*T/Max_it));

        newX = zeros(Npop, nVar);
        if rand < GPt
            % --- Kham pha (exploration) ---
            if nVar > 5
                for i = 1:Npop
                    r = randperm(Npop,3);
                    F = 0.5 * (1 - T/Max_it);
                    mutant = Xpos(r(1),:) + F*(Xpos(r(2),:) - Xpos(r(3),:));
                    mutant = mutant + 0.3*(Xposbest - Xpos(r(1),:));
                    cross_points = rand(1,nVar) < 0.5;
                    trial = Xpos(i,:);
                    trial(cross_points) = mutant(cross_points);
                    newX(i,:) = max(min(trial, ub), lb);
                end
            else
                % "Energy-step" - nVar=1 <= 5 -> nhanh nay duoc dung
                for i = 1:Npop
                    jp2 = randi(nVar);
                    im = randperm(Npop);
                    rand1 = 2*rand-1; rand2 = 2*rand-1;
                    newX(i,:) = Xpos(i,:);
                    newX(i,jp2) = Xpos(i,jp2) + tEO*(Xposbest(jp2) - Xpos(i,jp2)) + ...
                        rand1*(Xpos(im(1),jp2)-Xpos(i,jp2)) + rand2*(Xpos(im(2),jp2)-Xpos(i,jp2));
                    newX(i,:) = max(min(newX(i,:), ub), lb);
                end
            end
        else
            % --- Khai thac (exploitation): preying + regeneration ---
            df = randperm(Npop,5);
            for i = 1:Npop
                kp = randperm(5,2);
                dm_comb = 0.6*(Xposbest - Xpos(df(kp(1)),:)) + 0.4*(Xposbest - Xpos(df(kp(2)),:));
                newX(i,:) = Xpos(i,:) + dm_comb;
                if rand < 0.1
                    newX(i,:) = newX(i,:) + 0.01*randn(1,nVar).*(ub - lb);
                end
                if i == Npop
                    newX(i,:) = exp(-T*Npop/Max_it) .* Xpos(i,:);
                end
                newX(i,:) = max(min(newX(i,:), ub), lb);
            end
        end

        if T > 0.8*Max_it
            [~, best_idx] = min(sum(REP.pos_fit, 2));
            bestX = REP.pos(best_idx,:);
            for i = 1:round(0.1*Npop)
                newX(i,:) = bestX + 0.01*randn(1,nVar).*(ub - lb);
                newX(i,:) = max(min(newX(i,:), ub), lb);
            end
        end

        newFit = batchEvaluateParallel(newX, proj, cat, cfg, Num_work);

        DOM3 = dominates(newFit, Fitness);
        Xpos(DOM3,:) = newX(DOM3,:);
        Fitness(DOM3,:) = newFit(DOM3,:);

        REP = updateRepository(REP, newX, newFit, ngrid);
        if size(REP.pos,1) > Nr
            REP = deleteFromRepository(REP, size(REP.pos,1) - Nr, ngrid);
        end

        History.CumulativeFEs(T+1)    = History.CumulativeFEs(T) + Npop;
        History.BestObjectives(T+1,:) = min(REP.pos_fit, [], 1);
        History.RepositorySize(T+1)   = size(REP.pos, 1);
        History.ArchiveX{T+1} = REP.pos;
        History.ArchiveFitness{T+1} = REP.pos_fit;
        try
            History.Hypervolume(T+1) = hypervolume(REP.pos_fit', max(REP.pos_fit,[],1)*1.1);
        catch
            History.Hypervolume(T+1) = NaN;
        end
        elapsedSoFar = toc(expTimer);
        fprintf('[%s-%s] Vong lap %d/%d - Repository: %d - FE luy ke: %d - Thoi gian: %.1f phut\n', ...
            proj, RunTag, T, Max_it, size(REP.pos,1), History.CumulativeFEs(T+1), elapsedSoFar/60);

        saveCheckpointAtomic(ckptFile, Xpos, Fitness, REP, History, T);
    end

    elapsedSec = toc(expTimer); %#ok<NASGU>
    fprintf('[%s-%s] HOAN THANH. Tong thoi gian: %.2f phut. So nghiem Pareto: %d\n', ...
        proj, RunTag, elapsedSec/60, size(REP.pos,1));

    tmpFinal = [finalFile '.tmp'];
    save(tmpFinal, 'REP','History','cfg','cat','Npop','Max_it','Nr','Num_work','elapsedSec','proj','RunTag','-v7.3');
    movefile(tmpFinal, finalFile, 'f');
    if isfile(ckptFile), delete(ckptFile); end

catch ME
    disp(['LOI trong qua trinh tien hoa MOSFOA2 (' proj '-' RunTag '): ', ME.message]);
    disp(getReport(ME, 'extended'));
    disp('Checkpoint van con nguyen - chay lai ham nay se tu dong resume tu vong lap gan nhat.');
end

spmd (Num_work)
    try, SM.ApplicationExit(); catch, end
end
end

%% ========================================================================
function fitOut = batchEvaluateParallel(Xbatch, proj, cat, cfg, Num_work)
N = size(Xbatch, 1);
idx = mod(0:N-1, Num_work) + 1;
spmd (Num_work)
    Xpart = Xbatch(idx == spmdIndex, :);
    if ~isempty(Xpart)
        fitLoc = mosfoa2_evaluate_batch(Xpart, proj, cat, cfg);
    else
        fitLoc = zeros(0,2);
    end
end
fitOut = zeros(N, 2);
for w = 1:Num_work
    fitOut(idx == w, :) = fitLoc{w};
end
end

%% ========================================================================
function saveCheckpointAtomic(ckptFile, Xpos, Fitness, REP, History, lastIter) %#ok<INUSD>
tmpFile = [ckptFile '.tmp'];
save(tmpFile, 'Xpos','Fitness','REP','History','lastIter','-v7.3');
movefile(tmpFile, ckptFile, 'f');
end
