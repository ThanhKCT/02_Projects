function run_mofda_wharf100dwt(runMode)
% =========================================================================
% ĐIỂM VÀO CHẠY MOFDA CHO BÀI TOÁN TỐI ƯU TIẾT DIỆN CỌC CẦU TÀU 100.000 DWT
%
% runMode: 'smoke' (mặc định, Np/maxiter rất nhỏ - kiểm tra pipeline không
%          lỗi) | 'pilot' (đo thời gian/vòng lặp thật, chưa chốt Np cuối
%          cùng) | 'full' (campaign chính - CHỈ chạy sau khi đã pilot và
%          hiệu chỉnh cfg.penalty.C_init).
%
% 1 lần chạy = 1 tiến trình SAP2000 mở xuyên suốt (không parallel/spmd -
% bản đơn giản nhất để kiểm chứng pipeline trước; song song hoá thêm sau
% nếu thời gian FEM cho phép, xem Cach ket noi_SAP2000_MATLAB_OPTIMIZATION.md).
% =========================================================================
    if nargin < 1 || isempty(runMode), runMode = 'smoke'; end
    runMode = lower(runMode);

    scriptDir = fileparts(mfilename('fullpath'));
    addpath(fullfile(scriptDir, 'Functions'));
    addpath(fullfile(fileparts(scriptDir), 'MOFDA', 'Functions')); % checkDomination, updateGrid(01), selectLeader, updateRepository, deleteFromRepository, dominates, plotting

    cfg = wharf100dwt_config();

    switch runMode
        case 'smoke'
            Np = 6;  maxiter = 1;  Nr = 6;
        case 'pilot'
            Np = 15; maxiter = 15; Nr = 30;
        case 'full'
            Np = 40; maxiter = 60; Nr = 100;
        otherwise
            error('run_mofda_wharf100dwt:BadRunMode', 'runMode phai la ''smoke'', ''pilot'', hoac ''full''.');
    end
    ngrid    = cfg.algo.nGrid;
    beta_dim = cfg.algo.beta; % SỬA: đặt tên beta_dim, KHÔNG dùng "beta" (trùng hàm dựng sẵn beta() của MATLAB)
    lb = cfg.bounds.lb; ub = cfg.bounds.ub; nVar = numel(lb);

    fprintf('[Wharf100DWT MOFDA] runMode=%s Np=%d maxiter=%d (FE uoc tinh=%d)\n', ...
        runMode, Np, maxiter, Np*(1 + maxiter*(beta_dim+1)));

    resultsDir = fullfile(scriptDir, 'results');
    if ~exist(resultsDir, 'dir'), mkdir(resultsDir); end
    timestamp = datestr(now, 'yyyymmdd_HHMMSS');
    saveFile = fullfile(resultsDir, sprintf('Wharf100DWT_MOFDA_%s_%s_Np%d_Maxit%d.mat', ...
        upper(runMode), timestamp, Np, maxiter));

    % Dọn tiến trình SAP2000 mồ côi từ lần chạy trước (kinh nghiệm SFOA/MPJ)
    system('taskkill /F /IM SAP2000.exe');
    pause(1);

    open_Sap2000(cfg);

    try
        expTimer = tic;

        X = lb + rand(Np, nVar) .* (ub - lb);
        fit = wharf100dwt_evaluate(X, cfg);

        DOM = checkDomination(fit);
        REP.pos     = X(~DOM, :);
        REP.pos_fit = fit(~DOM, :);
        REP = updateGrid(REP, ngrid);

        Vmax = max(0.1 * (ub - lb));
        Vmin = min(-0.1 * (ub - lb));

        History.CumulativeFEs    = zeros(maxiter+1, 1);
        History.BestObjectives   = nan(maxiter+1, 2);
        History.RepositorySize   = zeros(maxiter+1, 1);
        History.CumulativeFEs(1)  = Np;
        History.BestObjectives(1,:) = min(REP.pos_fit, [], 1);
        History.RepositorySize(1) = size(REP.pos, 1);
        fprintf('The he #0 - Kich thuoc Repository: %d\n', size(REP.pos,1));
        save(saveFile, 'REP','History','cfg','runMode','Np','maxiter','-v7.3');

        X_new = zeros(Np, nVar);
        for iter = 1:maxiter
            h = selectLeader(REP);
            W = (((1 - iter/maxiter)^(2*randn)) .* (rand(1,nVar).*iter/maxiter) .* rand(1,nVar));

            for i = 1:Np
                X_nei = zeros(beta_dim, nVar);
                for j = 1:beta_dim
                    Xrand = lb + rand(1,nVar) .* (ub - lb);
                    delta_m = W .* (rand*Xrand - rand*X(i,:)) .* norm(REP.pos(h,:) - X(i,:));
                    X_nei(j,:) = X(i,:) + randn(1,nVar) .* delta_m;
                    X_nei(j,:) = max(X_nei(j,:), lb);
                    X_nei(j,:) = min(X_nei(j,:), ub);
                end
                fit_nei = wharf100dwt_evaluate(X_nei, cfg);

                DOM1 = checkDomination(fit_nei);
                REP_nei.pos     = X_nei(~DOM1, :);
                REP_nei.pos_fit = fit_nei(~DOM1, :);
                if isempty(REP_nei.pos) % phong ho: tat ca bi coi la dominated lan nhau (hiem)
                    REP_nei.pos = X_nei; REP_nei.pos_fit = fit_nei;
                end
                REP_nei = updateGrid01(REP_nei, ngrid);
                h_nei = selectLeader(REP_nei);

                if dominates(REP_nei.pos_fit(h_nei,:), fit(i,:))
                    Sf = (REP_nei.pos_fit(h_nei,:) - fit(i,:)) ./ sqrt(norm(REP_nei.pos(h_nei,:) - X(i,:)));
                    V = mean(randn .* Sf);
                    if V < Vmin, V = -Vmin; elseif V > Vmax, V = -Vmax; end
                    X_new(i,:) = X(i,:) + V .* (X_nei(h_nei,:) - X(i,:)) ./ sqrt(norm(X_nei(h_nei,:) - X(i,:)));
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
            fit_new = wharf100dwt_evaluate(X_new, cfg);

            DOM3 = dominates(fit_new, fit);
            X(DOM3,:)   = X_new(DOM3,:);
            fit(DOM3,:) = fit_new(DOM3,:);

            REP = updateRepository(REP, X_new, fit_new, ngrid);
            if size(REP.pos,1) > Nr
                REP = deleteFromRepository(REP, size(REP.pos,1) - Nr, ngrid);
            end

            History.CumulativeFEs(iter+1)    = History.CumulativeFEs(iter) + Np*(beta_dim+1);
            History.BestObjectives(iter+1,:) = min(REP.pos_fit, [], 1);
            History.RepositorySize(iter+1)   = size(REP.pos, 1);
            fprintf('Vong lap #%d/%d - Kich thuoc Repository: %d\n', iter, maxiter, size(REP.pos,1));

            % Checkpoint moi vong lap (ghi de cung 1 file -- don gian, CHUA
            % phai co che atomic .tmp->movefile day du theo khuyen nghi
            % Cach ket noi_SAP2000_MATLAB_OPTIMIZATION.md muc 5 -- can bo
            % sung truoc khi chay campaign 'full' nhieu gio).
            save(saveFile, 'REP','History','cfg','runMode','Np','maxiter','-v7.3');
        end

        elapsedSec = toc(expTimer);
        fprintf('Hoan thanh MOFDA (%s). Thoi gian: %.1f s. So nghiem Pareto: %d\n', ...
            runMode, elapsedSec, size(REP.pos,1));
        save(saveFile, 'REP','History','cfg','runMode','Np','maxiter','elapsedSec','-v7.3');

    catch ME
        disp(['LOI trong qua trinh tien hoa MOFDA: ', ME.message]);
        disp(getReport(ME, 'extended'));
    end

    try
        SM.ApplicationExit();
    catch
        disp('Canh bao: SAP2000 da duoc dong truoc do hoac khong the dong.');
    end
end
