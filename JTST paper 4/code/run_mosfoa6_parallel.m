function run_mosfoa6_parallel(Num_work, NpOverride, MaxitOverride, RunTag)
% =========================================================================
% BAN CHAY SONG SONG MOSFOA CHO BAI 6 (he ket cau ben tren cau tau).
%
% NGUON THUAT TOAN (lay nguyen, KHONG chinh sua loi): copy tu
% MOFDA/Wharf100DWT/run_emosfoa_wharf100dwt_parallel.m (thuat toan
% E-MOSFOA da dung cho Bai 1 va Bai 2, chinh la thuat toan cua nguoi dung -
% xem code/MOSFOA_core/*.m, cung copy nguyen tu MOFDA/MOFDA/Functions/).
% CHI THAY: (1) ham muc tieu = evaluate_superstructure_design.m qua
% mosfoa6_evaluate_batch.m, (2) bien thiet ke/bounds = cfg.lb/cfg.ub (4
% bien, giong catalogue index cach Bai 2 da lam), (3) checkpoint/resume +
% ghi atomic (giu nguyen ky luat da chot).
%
% *** BAT BUOC chay bang `-r`, KHONG dung `-batch` (COM automation). ***
% Xem Kinh nghiem MOSFOA Paper 2.md va sap2000-matlab-optimization-lessons
% truoc khi chay campaign that.
% =========================================================================
    if nargin < 1 || isempty(Num_work), Num_work = 4; end
    if nargin < 2 || isempty(NpOverride), NpOverride = 30; end
    if nargin < 3 || isempty(MaxitOverride), MaxitOverride = 100; end
    if nargin < 4 || isempty(RunTag), RunTag = ''; end

    scriptDir = fileparts(mfilename('fullpath'));
    addpath(scriptDir);
    addpath(fullfile(scriptDir, 'MOSFOA_core'));

    cfg = project_config_bai6();

    Npop = NpOverride; Max_it = MaxitOverride; Nr = 100;
    ngrid = 10; GP0 = 0.5;
    lb = cfg.lb; ub = cfg.ub; nVar = numel(lb); % nVar=4 -> "energy-step" (nVar<=5)

    resultsDir = fullfile(scriptDir, 'results');
    if ~exist(resultsDir, 'dir'), mkdir(resultsDir); end

    if isempty(RunTag), tagSuffix = ''; else, tagSuffix = ['_' RunTag]; end
    finalFile = fullfile(resultsDir, sprintf('Bai6_MOSFOA_Np%d_Maxit%d%s_FINAL.mat', Npop, Max_it, tagSuffix));
    if isfile(finalFile)
        fprintf('Da co file ket qua cuoi: %s -- BO QUA, khong chay lai.\n', finalFile);
        return;
    end
    ckptFile = fullfile(resultsDir, sprintf('Bai6_MOSFOA_Np%d_Maxit%d%s_CKPT.mat', Npop, Max_it, tagSuffix));

    fprintf('[Bai 6 MOSFOA - SONG SONG] Np=%d Max_it=%d Nr=%d Num_work=%d (FE uoc tinh=%d)\n', ...
        Npop, Max_it, Nr, Num_work, Npop*(Max_it+1));

    system('taskkill /F /IM SAP2000.exe');
    pause(2);

    p = gcp('nocreate');
    if isempty(p) || p.NumWorkers ~= Num_work
        delete(p);
        p = parpool('local', Num_work); %#ok<NASGU>
    end
    attachDirs = {scriptDir, fullfile(scriptDir,'MOSFOA_core')};
    attachedFiles = {};
    for k = 1:numel(attachDirs)
        d = dir(fullfile(attachDirs{k}, '*.m'));
        attachedFiles = [attachedFiles; fullfile({d.folder}', {d.name}')]; %#ok<AGROW>
    end
    addAttachedFiles(gcp, unique(attachedFiles));

    spmd (Num_work)
        maxNumCompThreads(1);
        [~, ~] = open_Sap2000_worker_v2(cfg.sdb_path, spmdIndex);
    end

    if isfile(ckptFile)
        fprintf('Tim thay checkpoint %s -- dang nap lai de tiep tuc...\n', ckptFile);
        S = load(ckptFile);
        Xpos = S.Xpos; Fitness = S.Fitness; REP = S.REP; History = S.History; %#ok<NASGU>
        Tstart = S.lastIter + 1;
        rngSeedUsed = S.rngSeedUsed;
        rng(S.rngStateAtResume); % KHOI PHUC DUNG trang thai RNG da luu, KHONG tao seed moi khi resume
        fprintf('Tiep tuc tu vong lap %d/%d (seed=%d).\n', Tstart, Max_it, rngSeedUsed);
    else
        % SUA (2026-09-16, phat hien qua ra soat truoc campaign - BUG NGHIEM
        % TRONG): MOI lan chay doc lap la 1 tien trinh MATLAB RIENG (kien
        % truc watchdog), va MATLAB mac dinh dung CUNG 1 seed khoi dong cho
        % moi tien trinh moi (da kiem chung thuc nghiem: 2 tien trinh
        % `matlab -batch` doc lap cho DUNG CUNG 1 gia tri rand()/randperm()
        % - xem Kinh nghiem SAP2000-MATLAB muc 6.4). NEU KHONG SUA, toan bo
        % Nrun "independent runs" se chay CHINH XAC cung 1 chuoi ngau nhien,
        % cho ket qua giong het nhau - vo nghia doi voi muc dich danh gia do
        % on dinh giua cac lan chay. Seed duoc LUU LAI (khong chi rng('shuffle')
        % roi bo qua) de co the truy vet/tai lap tung run rieng theo dung yeu
        % cau (RunID, Seed, co the tai lap).
        rng('shuffle');
        s0 = rng();
        rngSeedUsed = s0.Seed;
        fprintf('KHOI TAO SEED MOI cho run nay: %d (da luu, xem ket qua .mat truong rngSeedUsed).\n', rngSeedUsed);
        Xpos = lb + rand(Npop, nVar) .* (ub - lb);
        [Fitness, feasVec0] = batchEvaluateParallel(Xpos, cfg, Num_work);

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
        % THEM (2026-09-16, theo yeu cau ra soat truoc campaign muc 16): dem
        % so nghiem kha thi/khong kha thi MOI THE HE (khong phai tich luy),
        % de biet ty le quan the bi phat cung qua thoi gian.
        History.NumFeasible = zeros(Max_it+1, 1);
        History.NumInfeasible = zeros(Max_it+1, 1);
        History.CumulativeFEs(1) = Npop;
        History.BestObjectives(1,:) = min(REP.pos_fit, [], 1);
        History.RepositorySize(1) = size(REP.pos, 1);
        History.ArchiveX{1} = REP.pos;
        History.ArchiveFitness{1} = REP.pos_fit;
        History.NumFeasible(1) = sum(feasVec0);
        History.NumInfeasible(1) = sum(~feasVec0);
        fprintf('The he #0 - Kich thuoc Repository: %d (kha thi: %d/%d)\n', size(REP.pos,1), sum(feasVec0), Npop);

        Tstart = 1;
        saveCheckpointAtomic(ckptFile, Xpos, Fitness, REP, History, 0, rngSeedUsed);
    end

    RunStartTime = datestr(now, 'yyyy-mm-dd HH:MM:SS'); %#ok<TNOW1,DATST>
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

            [newFit, feasVecT] = batchEvaluateParallel(newX, cfg, Num_work);

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
            History.NumFeasible(T+1)   = sum(feasVecT);
            History.NumInfeasible(T+1) = sum(~feasVecT);
            try
                History.Hypervolume(T+1) = hypervolume(REP.pos_fit', max(REP.pos_fit,[],1)*1.1);
            catch
                History.Hypervolume(T+1) = NaN;
            end
            elapsedSoFar = toc(expTimer);
            fprintf('Vong lap %d/%d - Repository: %d - FE luy ke: %d - Thoi gian: %.1f phut\n', ...
                T, Max_it, size(REP.pos,1), History.CumulativeFEs(T+1), elapsedSoFar/60);

            saveCheckpointAtomic(ckptFile, Xpos, Fitness, REP, History, T, rngSeedUsed);
        end

        elapsedSec = toc(expTimer); %#ok<NASGU>
        RunEndTime = datestr(now, 'yyyy-mm-dd HH:MM:SS'); %#ok<TNOW1,DATST>
        fprintf('HOAN THANH campaign MOSFOA Bai 6. Tong thoi gian: %.2f gio. So nghiem Pareto: %d. Seed=%d\n', ...
            elapsedSec/3600, size(REP.pos,1), rngSeedUsed);

        % THEM (2026-09-16, yeu cau ra soat muc 16 - RunLog): luu day du
        % RunID/Seed/StartTime/EndTime/Npop/Max_it/Nr/so lan danh gia/so
        % nghiem kha thi-khong kha thi/FinalArchiveSize/BestObjective cung
        % voi REP/History nhu truoc, khong chi luu fitness tho.
        RunID = RunTag; %#ok<NASGU>
        TotalFE = History.CumulativeFEs(end); %#ok<NASGU>
        TotalFeasible = sum(History.NumFeasible); %#ok<NASGU>
        TotalInfeasible = sum(History.NumInfeasible); %#ok<NASGU>
        FinalArchiveSize = size(REP.pos,1); %#ok<NASGU>
        BestObjective1 = min(REP.pos_fit(:,1)); %#ok<NASGU>
        BestObjective2 = min(REP.pos_fit(:,2)); %#ok<NASGU>
        tmpFinal = [finalFile '.tmp'];
        save(tmpFinal, 'REP','History','cfg','Npop','Max_it','Nr','Num_work','elapsedSec', ...
            'RunID','rngSeedUsed','RunStartTime','RunEndTime','TotalFE','TotalFeasible','TotalInfeasible', ...
            'FinalArchiveSize','BestObjective1','BestObjective2','-v7.3');
        movefile(tmpFinal, finalFile, 'f');
        if isfile(ckptFile), delete(ckptFile); end

    catch ME
        disp(['LOI trong qua trinh tien hoa MOSFOA Bai 6 (song song): ', ME.message]);
        disp(getReport(ME, 'extended'));
        disp('Checkpoint van con nguyen -- chay lai ham nay se tu dong resume tu vong lap gan nhat.');
    end

    spmd (Num_work)
        try, SM.ApplicationExit(); catch, end
    end
end

%% ========================================================================
function [fitOut, feasOut] = batchEvaluateParallel(Xbatch, cfg, Num_work)
    N = size(Xbatch, 1);
    idx = mod(0:N-1, Num_work) + 1;
    spmd (Num_work)
        Xpart = Xbatch(idx == spmdIndex, :);
        if ~isempty(Xpart)
            [fitLoc, feasLoc] = mosfoa6_evaluate_batch(Xpart, cfg);
        else
            fitLoc = zeros(0,2);
            feasLoc = false(0,1);
        end
    end
    fitOut = zeros(N, 2);
    feasOut = false(N, 1);
    for w = 1:Num_work
        fitOut(idx == w, :) = fitLoc{w};
        feasOut(idx == w) = feasLoc{w};
    end
end

%% ========================================================================
function saveCheckpointAtomic(ckptFile, Xpos, Fitness, REP, History, lastIter, rngSeedUsed) %#ok<INUSD>
    tmpFile = [ckptFile '.tmp'];
    rngStateAtResume = rng(); %#ok<NASGU> % luu TRANG THAI RNG HIEN TAI (khong chi seed goc) de resume tiep tuc DUNG chuoi ngau nhien, khong lap lai tu dau
    save(tmpFile, 'Xpos','Fitness','REP','History','lastIter','rngSeedUsed','rngStateAtResume','-v7.3');
    movefile(tmpFile, ckptFile, 'f');
end
