function run_mofda_wharf100dwt_parallel(Num_work, NpOverride, maxiterOverride)
% =========================================================================
% BẢN CHẠY SONG SONG — CAMPAIGN CHÍNH ĐÃ CHỐT (28/08/2026): Np=50, Maxit=100,
% Nr=100, 8 worker. Ước tính ~111,6 giờ (~4,65 ngày) theo thông lượng thật
% đã đo (0,0623 FE/s với 8 worker) -- đã so sánh với 10 worker (chỉ nhanh
% hơn 8,6%, không đáng đánh đổi rủi ro license) nên chốt 8, KHÔNG dùng 10.
% Num_work (tuỳ chọn): số SAP2000 instance chạy song song. Mặc định 8
% (license SAP2000 trên máy này đã xác nhận thật tối đa 11 instance đồng
% thời — xem Cach ket noi_SAP2000_MATLAB_OPTIMIZATION.md mục 3 — dùng 8 để
% chừa margin, khớp công thức workerFraction=0.8 x 11 ~ 8 đã dùng ở dự án
% MPJ/SFOA trước đây trên CHÍNH máy này).
%
% *** BẮT BUỘC chạy bằng `-r`, KHÔNG dùng `-batch` (xem README.md mục
% "LỖI ĐÃ GẶP" W.2 — đã xác nhận thật `-batch` làm crash không ổn định
% khi dùng SM.* COM automation). ***
%
% KIẾN TRÚC (theo đúng pattern đã chạy thật ở BMOSFOA_MPJ_v1.m):
% - Mỗi worker mở 1 tiến trình SAP2000 RIÊNG, lưu 1 file .sdb RIÊNG trong
%   thư mục con riêng — không worker nào chia sẻ file .sdb.
% - Mỗi thế hệ, các lần gọi SAP2000 (batch lân cận + batch cập nhật vị trí)
%   được CHIA ĐỀU cho các worker rồi tổng hợp lại — không đổi công thức
%   cập nhật gốc của MOFDA (MOFDA_2D.m), chỉ đổi THỨ TỰ tính để có thể
%   nhóm nhiều lần gọi SAP2000 lại và chạy song song.
%
% CƠ CHẾ CHỐNG MẤT DỮ LIỆU (bắt buộc theo Cach ket noi_SAP2000_MATLAB_
% OPTIMIZATION.md mục 5 — job có thể chạy 20-40 giờ):
% - Idempotent: nếu file kết quả CUỐI đã tồn tại, thoát ngay (không chạy lại).
% - Checkpoint MỖI vòng lặp (mỗi vòng ở quy mô này đã tốn hàng trăm lần gọi
%   SAP2000 -> đáng giá để lưu lại, không đợi nhiều vòng mới lưu).
% - Ghi atomic: lưu ra <file>.tmp rồi movefile sang tên thật.
% =========================================================================
    if nargin < 1 || isempty(Num_work), Num_work = 8; end
    if nargin < 2 || isempty(NpOverride), NpOverride = 50; end
    if nargin < 3 || isempty(maxiterOverride), maxiterOverride = 100; end
    % NpOverride/maxiterOverride CHỈ để chạy smoke test hạ tầng song song
    % (vd run_mofda_wharf100dwt_parallel(8,8,1)) trước khi cam kết campaign
    % chính -- gọi KHÔNG truyền gì để dùng đúng quy mô đã chốt (50/100).

    scriptDir = fileparts(mfilename('fullpath'));
    addpath(fullfile(scriptDir, 'Functions'));
    addpath(fullfile(fileparts(scriptDir), 'MOFDA', 'Functions'));

    cfg = wharf100dwt_config();

    % --- Quy mô: mac dinh la campaign chinh DA CHOT (Np=50, Maxit=100) ---
    Np = NpOverride; maxiter = maxiterOverride; Nr = 100;
    ngrid = cfg.algo.nGrid;
    beta_dim = cfg.algo.beta; % SỬA: khong dat ten "beta" (trung ham dung san beta() cua MATLAB)
    lb = cfg.bounds.lb; ub = cfg.bounds.ub; nVar = numel(lb);

    resultsDir = fullfile(scriptDir, 'results');
    if ~exist(resultsDir, 'dir'), mkdir(resultsDir); end

    % --- Idempotent: neu file KET QUA CUOI da co, thoat ngay ---
    finalFile = fullfile(resultsDir, sprintf('Wharf100DWT_MOFDA_FULL_Np%d_Maxit%d_FINAL.mat', Np, maxiter));
    if isfile(finalFile)
        fprintf('Da co file ket qua cuoi: %s -- BO QUA, khong chay lai. Xoa file nay neu muon chay lai tu dau.\n', finalFile);
        return;
    end

    % --- File checkpoint (ghi de moi vong lap, atomic qua .tmp) ---
    ckptFile = fullfile(resultsDir, sprintf('Wharf100DWT_MOFDA_FULL_Np%d_Maxit%d_CKPT.mat', Np, maxiter));

    fprintf('[Wharf100DWT MOFDA - SONG SONG] Np=%d maxiter=%d Nr=%d Num_work=%d (FE uoc tinh=%d)\n', ...
        Np, maxiter, Nr, Num_work, Np*(1 + maxiter*(beta_dim+1)));

    % --- Don tien trinh SAP2000 mo coi tu lan chay truoc ---
    system('taskkill /F /IM SAP2000.exe');
    pause(2);

    % --- Mo parpool khop Num_work ---
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

    % --- Moi worker mo 1 SAP2000 rieng, luu 1 .sdb rieng ---
    spmd (Num_work)
        maxNumCompThreads(1); % gioi han luong tinh toan PHIA MATLAB cua worker nay
        [~, ~] = open_Sap2000_worker(cfg, spmdIndex); %#ok<PFOUS>
    end

    % --- Idempotent-resume: neu co checkpoint, nap lai va tiep tuc ---
    if isfile(ckptFile)
        fprintf('Tim thay checkpoint %s -- dang nap lai de tiep tuc...\n', ckptFile);
        S = load(ckptFile);
        X = S.X; fit = S.fit; REP = S.REP; History = S.History; %#ok<NASGU>
        iterStart = S.lastIter + 1;
        fprintf('Tiep tuc tu vong lap %d/%d.\n', iterStart, maxiter);
    else
        X = lb + rand(Np, nVar) .* (ub - lb);
        fit = batchEvaluateParallel(X, cfg, Num_work);

        DOM = checkDomination(fit);
        REP.pos = X(~DOM, :);
        REP.pos_fit = fit(~DOM, :);
        REP = updateGrid(REP, ngrid);

        History.CumulativeFEs = zeros(maxiter+1, 1);
        History.BestObjectives = nan(maxiter+1, 2);
        History.RepositorySize = zeros(maxiter+1, 1);
        History.CumulativeFEs(1) = Np;
        History.BestObjectives(1,:) = min(REP.pos_fit, [], 1);
        History.RepositorySize(1) = size(REP.pos, 1);
        fprintf('The he #0 - Kich thuoc Repository: %d\n', size(REP.pos,1));

        iterStart = 1;
        saveCheckpointAtomic(ckptFile, X, fit, REP, History, 0);
    end

    Vmax = max(0.1 * (ub - lb));
    Vmin = min(-0.1 * (ub - lb));

    expTimer = tic;
    try
        for iter = iterStart:maxiter
            h = selectLeader(REP);
            W = (((1 - iter/maxiter)^(2*randn)) .* (rand(1,nVar).*iter/maxiter) .* rand(1,nVar));

            % --- Buoc 1: sinh TOAN BO ung vien lan can (Np*beta_dim hang) ---
            % Khong can SAP2000 cho buoc nay -- chi la phep toan MOFDA gom
            % vi tri hien tai X(i,:), leader REP.pos(h,:) -- KHONG doi cong
            % thuc goc cua MOFDA_2D.m, chi tach rieng phan "sinh" khoi phan
            % "danh gia" de gom lai chay song song 1 lan cho ca Np ca the.
            XneiAll = zeros(Np*beta_dim, nVar);
            for i = 1:Np
                for j = 1:beta_dim
                    Xrand = lb + rand(1,nVar) .* (ub - lb);
                    delta_m = W .* (rand*Xrand - rand*X(i,:)) .* norm(REP.pos(h,:) - X(i,:));
                    row = (i-1)*beta_dim + j;
                    XneiAll(row,:) = max(min(X(i,:) + randn(1,nVar).*delta_m, ub), lb);
                end
            end

            fitNeiAll = batchEvaluateParallel(XneiAll, cfg, Num_work); % <-- 1 batch SAP2000 song song

            % --- Buoc 2: voi moi ca the, chon lan can tot nhat + quyet dinh X_new ---
            X_new = zeros(Np, nVar);
            for i = 1:Np
                rows = (i-1)*beta_dim + (1:beta_dim);
                X_nei = XneiAll(rows,:);
                fit_nei = fitNeiAll(rows,:);

                DOM1 = checkDomination(fit_nei);
                REP_nei.pos = X_nei(~DOM1, :);
                REP_nei.pos_fit = fit_nei(~DOM1, :);
                if isempty(REP_nei.pos)
                    REP_nei.pos = X_nei; REP_nei.pos_fit = fit_nei;
                end
                REP_nei = updateGrid01(REP_nei, ngrid);
                h_nei = selectLeader(REP_nei);

                if dominates(REP_nei.pos_fit(h_nei,:), fit(i,:))
                    Sf = (REP_nei.pos_fit(h_nei,:) - fit(i,:)) ./ sqrt(norm(REP_nei.pos(h_nei,:) - X(i,:)));
                    V = mean(randn .* Sf);
                    if V < Vmin, V = -Vmin; elseif V > Vmax, V = -Vmax; end
                    X_new(i,:) = X(i,:) + V .* (REP_nei.pos(h_nei,:) - X(i,:)) ./ sqrt(norm(REP_nei.pos(h_nei,:) - X(i,:)));
                else
                    r = randi([1 Np]);
                    if dominates(fit(r,:), fit(i,:))
                        X_new(i,:) = X(i,:) + randn(1,nVar) .* (X(r,:) - X(i,:));
                    else
                        X_new(i,:) = X(i,:) + randn * (REP.pos(h,:) - X(i,:));
                    end
                end
            end
            X_new = max(X_new, lb);
            X_new = min(X_new, ub);

            fit_new = batchEvaluateParallel(X_new, cfg, Num_work); % <-- batch SAP2000 song song thu 2

            DOM3 = dominates(fit_new, fit);
            X(DOM3,:) = X_new(DOM3,:);
            fit(DOM3,:) = fit_new(DOM3,:);

            REP = updateRepository(REP, X_new, fit_new, ngrid);
            if size(REP.pos,1) > Nr
                REP = deleteFromRepository(REP, size(REP.pos,1) - Nr, ngrid);
            end

            History.CumulativeFEs(iter+1)    = History.CumulativeFEs(iter) + Np*(beta_dim+1);
            History.BestObjectives(iter+1,:) = min(REP.pos_fit, [], 1);
            History.RepositorySize(iter+1)   = size(REP.pos, 1);
            elapsedSoFar = toc(expTimer);
            fprintf('Vong lap %d/%d - Repository: %d - FE luy ke: %d - Thoi gian: %.1f phut\n', ...
                iter, maxiter, size(REP.pos,1), History.CumulativeFEs(iter+1), elapsedSoFar/60);

            saveCheckpointAtomic(ckptFile, X, fit, REP, History, iter); % checkpoint MOI vong lap
        end

        elapsedSec = toc(expTimer); %#ok<NASGU>
        fprintf('HOAN THANH campaign chinh. Tong thoi gian: %.2f gio. So nghiem Pareto: %d\n', ...
            elapsedSec/3600, size(REP.pos,1));

        % --- Ghi ket qua CUOI CUNG (atomic), roi xoa checkpoint ---
        tmpFinal = [finalFile '.tmp'];
        save(tmpFinal, 'REP','History','cfg','Np','maxiter','Nr','Num_work','elapsedSec','-v7.3');
        movefile(tmpFinal, finalFile, 'f');
        if isfile(ckptFile), delete(ckptFile); end

    catch ME
        disp(['LOI trong qua trinh tien hoa MOFDA (song song): ', ME.message]);
        disp(getReport(ME, 'extended'));
        disp('Checkpoint van con nguyen -- chay lai ham nay se tu dong resume tu vong lap gan nhat.');
    end

    % --- Dong het SAP2000 cua tung worker ---
    spmd (Num_work)
        try, SM.ApplicationExit(); catch, end
    end
end

%% ========================================================================
function fitOut = batchEvaluateParallel(Xbatch, cfg, Num_work)
% Chia Xbatch (N x nVar) deu cho Num_work worker (moi worker da mo san 1
% SAP2000 rieng qua open_Sap2000_worker), goi wharf100dwt_evaluate tren
% phan cua minh, roi gom lai DUNG THU TU hang ban dau.
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
function saveCheckpointAtomic(ckptFile, X, fit, REP, History, lastIter) %#ok<INUSD>
    tmpFile = [ckptFile '.tmp'];
    save(tmpFile, 'X','fit','REP','History','lastIter','-v7.3');
    movefile(tmpFile, ckptFile, 'f');
end
