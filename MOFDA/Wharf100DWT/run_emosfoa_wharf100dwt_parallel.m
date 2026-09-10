function run_emosfoa_wharf100dwt_parallel(Num_work, NpOverride, MaxitOverride, RunTag)
% =========================================================================
% BẢN CHẠY SONG SONG E-MOSFOA — đối xứng với run_mofda_wharf100dwt_parallel.m,
% dùng cho bài báo đối sánh MOFDA vs E-MOSFOA (08/09/2026).
%
% NGUỒN THUẬT TOÁN (lấy nguyên, KHÔNG chỉnh sửa lõi): cơ chế cập nhật vị
% trí trích trực tiếp từ code thật của người dùng
% "MOSFOA/Run_MOMSFOA_official/MOSFOA_BD/EMOSFOA_BD_v3.m" (bến va Hải
% Linh, bản thảo B-/E-MOSFOA đang chờ xuất bản) -- CHỈ thay: (1) hàm mục
% tiêu (fun) bằng wharf100dwt_evaluate.m, (2) bien thiet ke/bounds bang
% cfg.bounds, (3) bo BUOC "snap ve luoi catalog D(:,ii)" cua ban goc --
% wharf100dwt_evaluate.m TU LAM TRON noi bo (giong cach MOFDA da lam,
% xem run_mofda_wharf100dwt_parallel.m) de dam bao CONG BANG phuong phap
% tim kiem giua 2 thuat toan (ca 2 deu tim kiem LIEN TUC roi lam tron o
% buoc danh gia, khong ben nao duoc loi the "snap som" con ben kia khong),
% (4) THEM checkpoint/resume moi vong lap + ghi atomic (ban goc chi luu 1
% lan o cuoi, rui ro mat toan bo tien do ~vai gio neu bi ngat giua chung --
% ap dung dung ky luat da chot o Cach ket noi_SAP2000_MATLAB_OPTIMIZATION.md
% muc 5), (5) THEM RunTag de chay nhieu lan doc lap khong ghi de.
%
% NGAN SACH DANH GIA CONG BANG VOI MOFDA (da doi chieu, xem
% DE_CUONG_BAI_BAO_MOFDA_MOSFOA_SO_SANH_THUAT_TOAN.md muc B2):
%   MOFDA:    FE = Np*(1 + maxiter*(beta+1)), beta=4 -> FE = Np*(1+5*maxiter)
%   E-MOSFOA: FE = Npop*(Max_it+1)
%   => Cung Np, dat Max_it_EMOSFOA = 5 * maxiter_MOFDA la KHOP CHINH XAC
%      tong FE hai ben (vd Np=50,maxiter_MOFDA=50 <-> Np=50,Max_it=250,
%      ca hai FE=12.550).
%   Nr=100, nGrid=10, GP0=0,5 -- DA NHAT QUAN san co giua cfg.algo (MOFDA)
%   va ban goc E-MOSFOA, khong can dieu chinh.
%
% *** BẮT BUỘC chạy bằng `-r`, KHÔNG dùng `-batch` (COM automation). ***
% =========================================================================
    if nargin < 1 || isempty(Num_work), Num_work = 8; end
    if nargin < 2 || isempty(NpOverride), NpOverride = 50; end
    if nargin < 3 || isempty(MaxitOverride), MaxitOverride = 250; end % = 5 x maxiter_MOFDA=50 (khop FE)
    if nargin < 4 || isempty(RunTag), RunTag = ''; end

    scriptDir = fileparts(mfilename('fullpath'));
    addpath(fullfile(scriptDir, 'Functions'));
    addpath(fullfile(fileparts(scriptDir), 'MOFDA', 'Functions')); % checkDomination, dominates, updateGrid,
    % updateRepository, deleteFromRepository, selectLeader, hypervolume -- DUNG CHUNG voi MOFDA (khong sao chep lai)

    cfg = wharf100dwt_config();

    Npop = NpOverride; Max_it = MaxitOverride; Nr = 100;
    ngrid = cfg.algo.nGrid; % = 10, dung chung voi MOFDA
    GP0 = 0.5; % GP co ban cua SFOA, giong ban goc E-MOSFOA
    lb = cfg.bounds.lb; ub = cfg.bounds.ub; nVar = numel(lb); % nVar=3 -> dung nhanh "energy-step" (nVar<=5)

    resultsDir = fullfile(scriptDir, 'results');
    if ~exist(resultsDir, 'dir'), mkdir(resultsDir); end

    if isempty(RunTag), tagSuffix = ''; else, tagSuffix = ['_' RunTag]; end
    finalFile = fullfile(resultsDir, sprintf('Wharf100DWT_EMOSFOA_FULL_Np%d_Maxit%d%s_FINAL.mat', Npop, Max_it, tagSuffix));
    if isfile(finalFile)
        fprintf('Da co file ket qua cuoi: %s -- BO QUA, khong chay lai.\n', finalFile);
        return;
    end
    ckptFile = fullfile(resultsDir, sprintf('Wharf100DWT_EMOSFOA_FULL_Np%d_Maxit%d%s_CKPT.mat', Npop, Max_it, tagSuffix));

    fprintf('[Wharf100DWT E-MOSFOA - SONG SONG] Np=%d Max_it=%d Nr=%d Num_work=%d (FE uoc tinh=%d)\n', ...
        Npop, Max_it, Nr, Num_work, Npop*(Max_it+1));

    system('taskkill /F /IM SAP2000.exe');
    pause(2);

    p = gcp('nocreate');
    if isempty(p) || p.NumWorkers ~= Num_work
        delete(p);
        p = parpool('local', Num_work); %#ok<NASGU>
    end
    attachDirs = {scriptDir, fullfile(scriptDir,'Functions')};
    attachedFiles = {};
    for k = 1:numel(attachDirs)
        d = dir(fullfile(attachDirs{k}, '*.m'));
        attachedFiles = [attachedFiles; fullfile({d.folder}', {d.name}')]; %#ok<AGROW>
    end
    addAttachedFiles(gcp, unique(attachedFiles));

    spmd (Num_work)
        maxNumCompThreads(1);
        [~, ~] = open_Sap2000_worker(cfg, spmdIndex);
    end

    if isfile(ckptFile)
        fprintf('Tim thay checkpoint %s -- dang nap lai de tiep tuc...\n', ckptFile);
        S = load(ckptFile);
        Xpos = S.Xpos; Fitness = S.Fitness; REP = S.REP; History = S.History; %#ok<NASGU>
        Tstart = S.lastIter + 1;
        fprintf('Tiep tuc tu vong lap %d/%d.\n', Tstart, Max_it);
    else
        Xpos = lb + rand(Npop, nVar) .* (ub - lb); % KHONG snap ve luoi -- xem ghi chu cong bang o dau file
        Fitness = batchEvaluateParallel(Xpos, cfg, Num_work);

        DOM = checkDomination(Fitness);
        REP.pos = Xpos(~DOM, :);
        REP.pos_fit = Fitness(~DOM, :);
        REP = updateGrid(REP, ngrid);

        History.CumulativeFEs = zeros(Max_it+1, 1);
        History.BestObjectives = nan(Max_it+1, 2);
        History.RepositorySize = zeros(Max_it+1, 1);
        History.Hypervolume = nan(Max_it+1, 1);
        History.ArchiveX = cell(Max_it+1, 1);       % SUA 08/09/2026 -- luu snapshot archive
        History.ArchiveFitness = cell(Max_it+1, 1);  % moi vong lap, phuc vu duong cong hoi tu
        % (dung chung quy uoc voi run_mofda_wharf100dwt_parallel.m -- GD/
        % IGD/HV theo FE tinh SAU KHI co mat Pareto tham chieu)
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
            % --- Cosine phase-control (E-MOSFOA, cong thuc goc) ---
            theta = (pi/2) * (T/Max_it)^1.5;
            tEO = (Max_it-T)/Max_it * cos(theta);
            h = selectLeader(REP);
            Xposbest = REP.pos(h,:);
            GPt = GP0 * 0.5 * (1 + cos(pi*T/Max_it));

            newX = zeros(Npop, nVar);
            if rand < GPt
                % --- Kham pha (exploration) ---
                if nVar > 5
                    % DE mutation + leader-guided term + binomial crossover (khong dung o day, nVar=3)
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
                    % "Energy-step" -- nhanh dung cho bai toan nay (nVar=3<=5)
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

            % --- Tinh chinh archive giai doan cuoi (Gaussian refinement, E-MOSFOA rieng) ---
            if T > 0.8*Max_it
                [~, best_idx] = min(sum(REP.pos_fit, 2));
                bestX = REP.pos(best_idx,:);
                for i = 1:round(0.1*Npop)
                    newX(i,:) = bestX + 0.01*randn(1,nVar).*(ub - lb);
                    newX(i,:) = max(min(newX(i,:), ub), lb);
                end
            end

            newFit = batchEvaluateParallel(newX, cfg, Num_work);

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
                % hypervolume.m nhan f dang (nObj x N) -- CHUYEN VI REP.pos_fit (N x 2) -> (2 x N).
                % Diem tham chieu W = max moi muc tieu trong archive *1,1 (bien thien theo du lieu,
                % KHONG dung [1 1] co dinh nhu ban goc vi muc tieu o day khong chuan hoa [0,1]).
                History.Hypervolume(T+1) = hypervolume(REP.pos_fit', max(REP.pos_fit,[],1)*1.1);
            catch
                History.Hypervolume(T+1) = NaN; % khong de loi HV lam gian doan campaign
            end
            elapsedSoFar = toc(expTimer);
            fprintf('Vong lap %d/%d - Repository: %d - FE luy ke: %d - Thoi gian: %.1f phut\n', ...
                T, Max_it, size(REP.pos,1), History.CumulativeFEs(T+1), elapsedSoFar/60);

            saveCheckpointAtomic(ckptFile, Xpos, Fitness, REP, History, T);
        end

        elapsedSec = toc(expTimer); %#ok<NASGU>
        fprintf('HOAN THANH campaign E-MOSFOA. Tong thoi gian: %.2f gio. So nghiem Pareto: %d\n', ...
            elapsedSec/3600, size(REP.pos,1));

        tmpFinal = [finalFile '.tmp'];
        save(tmpFinal, 'REP','History','cfg','Npop','Max_it','Nr','Num_work','elapsedSec','-v7.3');
        movefile(tmpFinal, finalFile, 'f');
        if isfile(ckptFile), delete(ckptFile); end

    catch ME
        disp(['LOI trong qua trinh tien hoa E-MOSFOA (song song): ', ME.message]);
        disp(getReport(ME, 'extended'));
        disp('Checkpoint van con nguyen -- chay lai ham nay se tu dong resume tu vong lap gan nhat.');
    end

    spmd (Num_work)
        try, SM.ApplicationExit(); catch, end
    end
end

%% ========================================================================
function fitOut = batchEvaluateParallel(Xbatch, cfg, Num_work)
    N = size(Xbatch, 1);
    idx = mod(0:N-1, Num_work) + 1;
    spmd (Num_work)
        Xpart = Xbatch(idx == spmdIndex, :);
        if ~isempty(Xpart)
            fitLoc = wharf100dwt_evaluate(Xpart, cfg);
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
