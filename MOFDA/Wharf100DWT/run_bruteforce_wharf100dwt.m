function run_bruteforce_wharf100dwt(Num_work)
% =========================================================================
% LIỆT KÊ TOÀN BỘ (BRUTE-FORCE) không gian thiết kế rời rạc — ĐÃ CHỐT
% (28/08/2026) sau khi phát hiện không gian chỉ có 3×9×9 = 243 tổ hợp
% (CatIdx_BTCT: 3, D_thep bước 25mm: 9, t_thep bước 1mm: 9) — quá nhỏ để
% dùng metaheuristic (MOFDA) làm công cụ tìm kiếm chính; brute-force cho
% ĐÚNG mặt Pareto thật 100%, dùng làm ground-truth đối chiếu với MOFDA
% (xem run_mofda_wharf100dwt_parallel.m, quy mô đã giảm Np=15/Maxit=15).
%
% *** BẮT BUỘC chạy bằng `-r`, KHÔNG dùng `-batch` (xem README.md W.2). ***
% =========================================================================
    if nargin < 1 || isempty(Num_work), Num_work = 8; end

    scriptDir = fileparts(mfilename('fullpath'));
    addpath(fullfile(scriptDir, 'Functions'));
    addpath(fullfile(fileparts(scriptDir), 'MOFDA', 'Functions')); % checkDomination

    cfg = wharf100dwt_config();

    resultsDir = fullfile(scriptDir, 'results');
    if ~exist(resultsDir, 'dir'), mkdir(resultsDir); end
    finalFile = fullfile(resultsDir, 'Wharf100DWT_BRUTEFORCE_FINAL.mat');
    if isfile(finalFile)
        fprintf('Da co file ket qua brute-force: %s -- BO QUA.\n', finalFile);
        return;
    end

    % --- Liệt kê toàn bộ lưới rời rạc (đúng theo cfg.bounds) ---
    catIdxVals = cfg.bounds.lb(1):cfg.bounds.roundStep(1):cfg.bounds.ub(1); % 1,2,3
    Dthep_vals = cfg.bounds.lb(2):cfg.bounds.roundStep(2):cfg.bounds.ub(2); % 9 gia tri
    tthep_vals = cfg.bounds.lb(3):cfg.bounds.roundStep(3):cfg.bounds.ub(3); % 9 gia tri
    [C, Dg, Tg] = ndgrid(catIdxVals, Dthep_vals, tthep_vals);
    Xall = [C(:), Dg(:), Tg(:)];
    Ntotal = size(Xall, 1);
    fprintf('[Wharf100DWT BRUTE-FORCE] %d to hop can danh gia (CatIdx x D_thep x t_thep = %d x %d x %d), Num_work=%d\n', ...
        Ntotal, numel(catIdxVals), numel(Dthep_vals), numel(tthep_vals), Num_work);

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

    try
        expTimer = tic;
        fit = batchEvaluateParallel(Xall, cfg, Num_work);
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
        save(tmpFinal, 'Xall', 'fit', 'ParetoX', 'ParetoFit', 'elapsedSec', 'Ntotal', 'cfg', '-v7.3');
        movefile(tmpFinal, finalFile, 'f');

    catch ME
        disp(['LOI trong qua trinh brute-force: ', ME.message]);
        disp(getReport(ME, 'extended'));
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
