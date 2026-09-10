function run_bruteforce_wharf100dwt(Num_work, ChunkSize, RestartEvery, SmokeLimit)
% =========================================================================
% LIỆT KÊ TOÀN BỘ (BRUTE-FORCE) không gian thiết kế rời rạc.
%
% MỞ RỘNG (07/09/2026, theo góp ý phản biện JMST V4 -> V5): lưới đã tăng
% từ 3x9x9=243 tổ hợp lên 5x51x16=4.080 tổ hợp (xem wharf100dwt_config.m).
% Ở quy mô này (~4.080 to hop, uoc tinh ~19h o thong luong that 0,06 FE/s
% da do voi 243 to hop cu -- xem README.md), BẮT BUỘC có checkpoint giữa
% chừng (khác bản 243-tổ-hợp cũ, chỉ lưu 1 lần ở cuối) -- theo đúng 3
% nguyên tắc đã chốt ở Cach ket noi_SAP2000_MATLAB_OPTIMIZATION.md muc 5:
% idempotent-skip, checkpoint (moi CHUNK, khong doi den cuoi), ghi atomic.
%
% Num_work (tuy chon, mac dinh 8): so tien trinh SAP2000 song song.
% ChunkSize (tuy chon, mac dinh 400): so to hop moi lan goi
%   batchEvaluateParallel truoc khi checkpoint -- ChunkSize=400, 8 worker
%   => ~50 lan goi SAP2000/worker/chunk => ~50*16s ~ 13 phut/checkpoint o
%   thong luong da do (khong ngoai suy, se in ra thoi gian that moi chunk).
% RestartEvery (tuy chon, mac dinh 5): sau moi RestartEvery CHUNK, dong va
%   mo lai SAP2000 cho tung worker (open_Sap2000_worker luon mo lai TU
%   TEMPLATE GOC cfg.sap.modelPath, khong phai tu ban .sdb cua worker --
%   xem Functions/open_Sap2000_worker.m) -- phong ngua file .sdb tu thoai
%   hoa sau nhieu gio RunAnalysis lien tuc (da gap o du an SFOA, xem
%   Cach ket noi_SAP2000_MATLAB_OPTIMIZATION.md muc 6.9). RestartEvery=5,
%   ChunkSize=400 => restart moi ~5*400/8*16s ~ 1,1 gio -- an toan hon
%   nhieu so nguong da gay thoai hoa o du an truoc (nhieu gio lien tuc).
% SmokeLimit (tuy chon): neu > 0, chi lay SmokeLimit to hop DAU TIEN cua
%   luoi that (khong tao luoi gia) de chay thu nhanh, kiem tra pipeline
%   (catalogue 5 dong, bounds moi, cache-key...) khong loi truoc khi cam
%   ket campaign day du ~19h. KHONG dung ket qua smoke de phan tich/cong bo.
%
% *** BẮT BUỘC chạy bằng `-r`, KHÔNG dùng `-batch` (xem README.md W.2). ***
% =========================================================================
    if nargin < 1 || isempty(Num_work), Num_work = 8; end
    if nargin < 2 || isempty(ChunkSize), ChunkSize = 400; end
    if nargin < 3 || isempty(RestartEvery), RestartEvery = 5; end
    if nargin < 4 || isempty(SmokeLimit), SmokeLimit = 0; end

    scriptDir = fileparts(mfilename('fullpath'));
    addpath(fullfile(scriptDir, 'Functions'));
    addpath(fullfile(fileparts(scriptDir), 'MOFDA', 'Functions')); % checkDomination

    cfg = wharf100dwt_config();

    resultsDir = fullfile(scriptDir, 'results');
    if ~exist(resultsDir, 'dir'), mkdir(resultsDir); end
    finalFile = fullfile(resultsDir, 'Wharf100DWT_BRUTEFORCE_FINAL.mat');
    ckptFile  = fullfile(resultsDir, 'Wharf100DWT_BRUTEFORCE_CKPT.mat');
    if SmokeLimit > 0
        finalFile = fullfile(resultsDir, 'Wharf100DWT_BRUTEFORCE_SMOKE.mat');
        ckptFile  = fullfile(resultsDir, 'Wharf100DWT_BRUTEFORCE_SMOKE_CKPT.mat');
    end
    if isfile(finalFile)
        fprintf('Da co file ket qua brute-force: %s -- BO QUA.\n', finalFile);
        return;
    end

    % --- Liệt kê toàn bộ lưới rời rạc (đúng theo cfg.bounds MỚI) ---
    catIdxVals = cfg.bounds.lb(1):cfg.bounds.roundStep(1):cfg.bounds.ub(1); % 1..5
    Dthep_vals = cfg.bounds.lb(2):cfg.bounds.roundStep(2):cfg.bounds.ub(2); % 51 gia tri
    tthep_vals = cfg.bounds.lb(3):cfg.bounds.roundStep(3):cfg.bounds.ub(3); % 16 gia tri
    [C, Dg, Tg] = ndgrid(catIdxVals, Dthep_vals, tthep_vals);
    Xall = [C(:), Dg(:), Tg(:)];
    if SmokeLimit > 0
        Xall = Xall(1:min(SmokeLimit, size(Xall,1)), :);
    end
    Ntotal = size(Xall, 1);
    fprintf('[Wharf100DWT BRUTE-FORCE] %d to hop can danh gia (CatIdx x D_thep x t_thep = %d x %d x %d), Num_work=%d, ChunkSize=%d, RestartEvery=%d chunk\n', ...
        Ntotal, numel(catIdxVals), numel(Dthep_vals), numel(tthep_vals), Num_work, ChunkSize, RestartEvery);

    % --- Idempotent-resume: nap checkpoint neu co ---
    fit = nan(Ntotal, 2);
    diagnostic = nan(Ntotal, 13);
    startIdx = 1;
    if isfile(ckptFile)
        S = load(ckptFile);
        if isfield(S,'Ntotal') && S.Ntotal == Ntotal
            fit = S.fit; diagnostic = S.diagnostic; startIdx = S.nextIdx;
            fprintf('Tim thay checkpoint %s -- resume tu to hop %d/%d.\n', ckptFile, startIdx, Ntotal);
        else
            warning('run_bruteforce_wharf100dwt:CkptSizeMismatch', ...
                'Checkpoint co Ntotal khac luoi hien tai -- BO QUA checkpoint, chay lai tu dau.');
        end
    end

    system('taskkill /F /IM SAP2000.exe');
    pause(2);

    p = gcp('nocreate');
    if isempty(p) || p.NumWorkers ~= Num_work
        delete(p);
        p = parpool('local', Num_work); %#ok<NASGU>
    end
    d = dir(fullfile(scriptDir, 'Functions', '*.m'));
    attachedFiles = [fullfile({d.folder}', {d.name}'); {mfilename('fullpath')}];
    addAttachedFiles(gcp, unique(attachedFiles));

    spmd (Num_work)
        maxNumCompThreads(1);
        [~, ~] = open_Sap2000_worker(cfg, spmdIndex);
    end

    expTimer = tic;
    try
        idxStart = startIdx;
        chunkCounter = 0;
        while idxStart <= Ntotal
            idxEnd = min(idxStart + ChunkSize - 1, Ntotal);
            [fitChunk, diagChunk] = batchEvaluateParallel(Xall(idxStart:idxEnd, :), cfg, Num_work);
            fit(idxStart:idxEnd, :) = fitChunk;
            diagnostic(idxStart:idxEnd, :) = diagChunk;

            chunkCounter = chunkCounter + 1;
            elapsedSoFar = toc(expTimer);
            fprintf('Da xong %d/%d to hop - Thoi gian luy ke: %.1f phut\n', idxEnd, Ntotal, elapsedSoFar/60);

            saveCheckpointAtomic(ckptFile, fit, diagnostic, idxEnd + 1, Ntotal);

            % --- Phong ngua .sdb thoai hoa: dong+mo lai SAP2000 dinh ky ---
            % SUA (07/09/2026, phat hien sau campaign 4080-to-hop lan 1):
            % SM.ApplicationExit() qua COM KHONG dam bao giai phong tien
            % trinh OS chac chan (dac thu COM/ActiveX) -- da xac nhan THAT
            % gay ro ri hang chuc tien trinh SAP2000.exe zombie qua nhieu
            % lan restart, vuot xa gioi han license 11 instance, lam SAI
            % LECH toan bo ket qua tu thoi diem do (RunAnalysis tra ve loi
            % hang loat, KHONG PHAI bat kha thi ket cau that). Them
            % `taskkill /F /IM SAP2000.exe` LUON LUON truoc khi mo lai --
            % dung CHINH XAC pattern da dung an toan luc mo dau script.
            if mod(chunkCounter, RestartEvery) == 0 && idxEnd < Ntotal
                fprintf('Restart dinh ky SAP2000 sau %d chunk (phong ngua .sdb thoai hoa)...\n', RestartEvery);
                spmd (Num_work)
                    try, SM.ApplicationExit(); catch, end
                end
                pause(2);
                system('taskkill /F /IM SAP2000.exe'); % luoi an toan -- dam bao KHONG con tien trinh zombie
                pause(2);
                spmd (Num_work)
                    maxNumCompThreads(1);
                    [~, ~] = open_Sap2000_worker(cfg, spmdIndex);
                end
            end

            idxStart = idxEnd + 1;
        end

        elapsedSec = toc(expTimer);

        DOM = checkDomination(fit);
        ParetoX = Xall(~DOM, :);
        ParetoFit = fit(~DOM, :);
        [~, order] = sort(ParetoFit(:,1));
        ParetoX = ParetoX(order, :);
        ParetoFit = ParetoFit(order, :);

        nInfeasible = sum(fit(:,1) >= 1e6);
        fprintf('HOAN THANH brute-force. %d/%d nghiem Pareto (trong %d to hop kha thi, %d bi phat cung). Thoi gian: %.1f phut\n', ...
            size(ParetoX,1), Ntotal, Ntotal - nInfeasible, nInfeasible, elapsedSec/60);

        tmpFinal = [finalFile '.tmp'];
        save(tmpFinal, 'Xall', 'fit', 'diagnostic', 'ParetoX', 'ParetoFit', 'elapsedSec', 'Ntotal', 'cfg', '-v7.3');
        movefile(tmpFinal, finalFile, 'f');
        if isfile(ckptFile), delete(ckptFile); end

    catch ME
        disp(['LOI trong qua trinh brute-force: ', ME.message]);
        disp(getReport(ME, 'extended'));
        disp('Checkpoint van con nguyen -- chay lai ham nay se tu dong resume tu to hop gan nhat.');
    end

    spmd (Num_work)
        try, SM.ApplicationExit(); catch, end
    end
end

%% ========================================================================
function [fitOut, diagOut] = batchEvaluateParallel(Xbatch, cfg, Num_work)
    N = size(Xbatch, 1);
    idx = mod(0:N-1, Num_work) + 1;
    spmd (Num_work)
        Xpart = Xbatch(idx == spmdIndex, :);
        if ~isempty(Xpart)
            [fitLoc, diagLoc] = wharf100dwt_evaluate(Xpart, cfg);
        else
            fitLoc = zeros(0,2);
            diagLoc = zeros(0,13);
        end
    end
    fitOut = zeros(N, 2);
    diagOut = nan(N, 13);
    for w = 1:Num_work
        fitOut(idx == w, :) = fitLoc{w};
        diagOut(idx == w, :) = diagLoc{w};
    end
end

%% ========================================================================
function saveCheckpointAtomic(ckptFile, fit, diagnostic, nextIdx, Ntotal) %#ok<INUSD>
    tmpFile = [ckptFile '.tmp'];
    save(tmpFile, 'fit', 'diagnostic', 'nextIdx', 'Ntotal', '-v7.3');
    movefile(tmpFile, ckptFile, 'f');
end
