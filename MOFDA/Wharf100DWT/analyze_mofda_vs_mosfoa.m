function analyze_mofda_vs_mosfoa()
% =========================================================================
% Muc 2.2 cua BAN_GIAO_PHIEN_LAM_VIEC_10_09_2026.md -- tong hop doi sanh
% MOFDA vs MOSFOA (E-MOSFOA) sau khi da chay xong 30+30 lan doc lap:
%   (1) IGD/HV/ty le trung khop chinh xac (nguong 1e-6)/Wilcoxon rank-sum
%       cho tung thuat toan, tren cung mat Pareto tham chieu CHINH THUC
%       (59 nghiem, vet can 4.080 to hop) -- xem de cuong Muc D.5.3, B.1.
%   (2) Duong cong hoi tu IGD/HV theo FE (History.ArchiveFitness luu moi
%       vong lap trong 2 script *_parallel.m) -- Muc 6.4 bai bao.
%   (3) Kiem chung lai hien tuong "don bien" (boundary clustering) tren
%       mat Pareto tham chieu CHINH THUC -- KHONG gia dinh truoc (Muc C).
%
% HV dung reference point CO DINH (KHONG doi theo tung lan chay/thuat
% toan) de dam bao HV so sanh duoc giua 60 lan chay: W = nadir cua toan
% bo khong gian thiet ke KHA THI (khong tinh 743 to hop bi phat cung) *
% 1.05 -- dam bao KHONG mot nghiem kha thi nao (ca trong 59 Pareto that
% lan trong repository cua 2 thuat toan) vuot qua W o ca 2 truc.
% =========================================================================
    scriptDir = fileparts(mfilename('fullpath'));
    addpath(fullfile(scriptDir, 'Functions'));
    addpath(fullfile(fileparts(scriptDir), 'MOFDA', 'Functions'));
    resultsDir = fullfile(scriptDir, 'results');
    outDir = fullfile(resultsDir, 'analysis');
    if ~isfolder(outDir); mkdir(outDir); end

    Np = 50; maxiterMOFDA = 50; MaxItMOSFOA = 250; Nruns = 30;

    % --- 0. Mat Pareto tham chieu CHINH THUC ---
    bf = load(fullfile(resultsDir, 'Wharf100DWT_BRUTEFORCE_FINAL.mat'), ...
        'ParetoFit', 'ParetoX', 'fit', 'cfg');
    RefFront = bf.ParetoFit;   % 59 x 2
    RefX     = bf.ParetoX;     % 59 x 3  [CatIdx_BTCT, D_thep, t_thep]
    bounds   = bf.cfg.bounds;

    fMin = min(RefFront, [], 1); fMax = max(RefFront, [], 1);
    fRange = fMax - fMin; fRange(fRange == 0) = 1;
    normalize = @(F) (F - fMin) ./ fRange;
    RefFrontNorm = normalize(RefFront)';

    % --- W co dinh cho HV: nadir tren toan bo khong gian kha thi (khong
    % tinh cac to hop bi phat cung fit>=1e6), *1.05, giong het cho ca 60
    % lan chay va ca mat Pareto tham chieu -> HV so sanh duoc truc tiep.
    hardMask = bf.fit(:,1) >= 1e6 | bf.fit(:,2) >= 1e6;
    feasFitAll = bf.fit(~hardMask, :);
    W = max(feasFitAll, [], 1) * 1.05;
    fprintf('W (reference point HV co dinh) = [%.4f, %.6f]\n', W(1), W(2));

    algos = struct( ...
        'name',    {'MOFDA',   'EMOSFOA'}, ...
        'label',   {'MOFDA',   'MOSFOA (E-MOSFOA)'}, ...
        'prefix',  {'Wharf100DWT_MOFDA_FULL',   'Wharf100DWT_EMOSFOA_FULL'}, ...
        'Nparam',  {maxiterMOFDA, MaxItMOSFOA}, ...
        'FEperIter', {Np*(4+1), Np} ); % MOFDA: Np*(beta+1)=250/iter; MOSFOA: Np/iter

    combined = table();
    curves = struct();

    for a = 1:numel(algos)
        A = algos(a);
        GDv = nan(Nruns,1); IGDv = nan(Nruns,1); HVv = nan(Nruns,1);
        RepSize = nan(Nruns,1); ExactMatch = nan(Nruns,1);
        nIter = A.Nparam + 1;
        IGDcurve = nan(Nruns, nIter);
        HVcurve  = nan(Nruns, nIter);
        FEgrid = (0:A.Nparam) * A.FEperIter + Np; % CumulativeFEs(1)=Np, roi +FEperIter moi vong

        for r = 1:Nruns
            tag = sprintf('run%02d', r);
            fpath = fullfile(resultsDir, sprintf('%s_Np%d_Maxit%d_%s_FINAL.mat', A.prefix, Np, A.Nparam, tag));
            if ~isfile(fpath)
                warning('analyze_mofda_vs_mosfoa:MissingFile', '%s khong ton tai -- bo qua.', fpath);
                continue;
            end
            R = load(fpath, 'REP', 'History');
            fRun = R.REP.pos_fit;
            RepSize(r) = size(fRun,1);

            fRunNorm = normalize(fRun)';
            GDv(r)  = generational_distance(fRunNorm, RefFrontNorm);
            IGDv(r) = generational_distance(RefFrontNorm, fRunNorm);
            HVv(r)  = hypervolume(fRun', W);

            matchCount = 0;
            for i = 1:size(fRun,1)
                if any(all(abs(RefFront - fRun(i,:)) < 1e-6, 2))
                    matchCount = matchCount + 1;
                end
            end
            ExactMatch(r) = matchCount;

            % --- duong cong hoi tu theo FE (dung LAI W co dinh cho HV,
            % KHONG dung History.Hypervolume da luu (W thich ung tung
            % vong) -- de HV so sanh duoc doc theo FE giua 2 thuat toan) ---
            nH = numel(R.History.ArchiveFitness);
            for it = 1:min(nH, nIter)
                fArch = R.History.ArchiveFitness{it};
                if isempty(fArch); continue; end
                fArchNorm = normalize(fArch)';
                IGDcurve(r,it) = generational_distance(RefFrontNorm, fArchNorm);
                HVcurve(r,it)  = hypervolume(fArch', W);
            end
        end

        validIdx = ~isnan(GDv);
        Talgo = table(repmat({A.name}, sum(validIdx),1), find(validIdx), ...
            GDv(validIdx), IGDv(validIdx), HVv(validIdx), RepSize(validIdx), ExactMatch(validIdx), ...
            'VariableNames', {'Algorithm','Run','GD','IGD','HV','RepositorySize','NumExactMatch'});
        combined = [combined; Talgo]; %#ok<AGROW>

        curves.(A.name).FE = FEgrid;
        curves.(A.name).IGD_mean = mean(IGDcurve, 1, 'omitnan');
        curves.(A.name).IGD_std  = std(IGDcurve, 0, 1, 'omitnan');
        curves.(A.name).HV_mean  = mean(HVcurve, 1, 'omitnan');
        curves.(A.name).HV_std   = std(HVcurve, 0, 1, 'omitnan');
        curves.(A.name).IGDcurve = IGDcurve;
        curves.(A.name).HVcurve  = HVcurve;

        fprintf('\n=== %s (%d/%d lan hop le) ===\n', A.label, sum(validIdx), Nruns);
        fprintf('GD  : mean=%.6f std=%.6f\n', mean(GDv(validIdx)), std(GDv(validIdx)));
        fprintf('IGD : mean=%.6f std=%.6f\n', mean(IGDv(validIdx)), std(IGDv(validIdx)));
        fprintf('HV  : mean=%.6f std=%.6f (W=[%.4f,%.6f])\n', mean(HVv(validIdx)), std(HVv(validIdx)), W(1), W(2));
        fprintf('RepSize: mean=%.2f\n', mean(RepSize(validIdx)));
        fprintf('ExactMatch (/%d nghiem RefFront, repo size=%.0f): mean=%.2f std=%.2f\n', ...
            size(RefFront,1), mean(RepSize(validIdx)), mean(ExactMatch(validIdx)), std(ExactMatch(validIdx)));
    end

    writetable(combined, fullfile(outDir, 'combined_run_stats.csv'));
    save(fullfile(outDir, 'combined_run_stats.mat'), 'combined', 'curves', 'RefFront', 'RefX', 'W', '-v7.3');

    % --- (1) Wilcoxon rank-sum MOFDA vs MOSFOA cho tung chi so ---
    gMOFDA = combined(strcmp(combined.Algorithm,'MOFDA'),:);
    gMOSFOA = combined(strcmp(combined.Algorithm,'EMOSFOA'),:);
    metrics = {'GD','IGD','HV','NumExactMatch'};
    wilcox = table();
    fprintf('\n=== Wilcoxon rank-sum MOFDA vs MOSFOA (30 vs 30) ===\n');
    for m = 1:numel(metrics)
        met = metrics{m};
        x = gMOFDA.(met); y = gMOSFOA.(met);
        try
            [p, h, stats] = ranksum(x, y);
            zval = NaN; if isfield(stats,'zval'); zval = stats.zval; end
        catch ME
            warning('analyze_mofda_vs_mosfoa:RanksumFailed', ...
                'ranksum khong dung duoc (%s) -- can Statistics and Machine Learning Toolbox.', ME.message);
            p = NaN; h = NaN; zval = NaN;
        end
        row = table({met}, mean(x), std(x), mean(y), std(y), p, h, zval, ...
            'VariableNames', {'Metric','MOFDA_mean','MOFDA_std','MOSFOA_mean','MOSFOA_std','p_value','h_reject0p05','zval'});
        wilcox = [wilcox; row]; %#ok<AGROW>
        fprintf('%-14s MOFDA=%.6f±%.6f  MOSFOA=%.6f±%.6f  p=%.4g  %s\n', met, mean(x), std(x), mean(y), std(y), p, ...
            ternary(h==1, '(khac biet co y nghia, alpha=0.05)', '(khong khac biet co y nghia)'));
    end
    writetable(wilcox, fullfile(outDir, 'wilcoxon_mofda_vs_mosfoa.csv'));

    % --- (2) Xuat duong cong hoi tu ra CSV (de ve hinh Muc 6.4) ---
    exportCurveCSV(fullfile(outDir, 'convergence_curve_MOFDA.csv'), curves.MOFDA);
    exportCurveCSV(fullfile(outDir, 'convergence_curve_MOSFOA.csv'), curves.EMOSFOA);
    plotConvergenceCurves(curves, outDir);

    % --- (3) Kiem chung "don bien" tren mat Pareto tham chieu CHINH THUC ---
    checkBoundaryClustering(RefX, bounds, outDir);

    fprintf('\nDa luu toan bo ket qua phan tich vao: %s\n', outDir);
end

function out = ternary(cond, a, b)
    if cond; out = a; else; out = b; end
end

function exportCurveCSV(fpath, C)
    T = table(C.FE(:), C.IGD_mean(:), C.IGD_std(:), C.HV_mean(:), C.HV_std(:), ...
        'VariableNames', {'FE','IGD_mean','IGD_std','HV_mean','HV_std'});
    writetable(T, fpath);
end

function plotConvergenceCurves(curves, outDir)
    f = figure('Visible','off','Position',[100 100 1000 800]);

    subplot(2,1,1); hold on; box on; grid on;
    h1 = plotBand(curves.MOFDA.FE, curves.MOFDA.IGD_mean, curves.MOFDA.IGD_std, [0.85 0.33 0.10], true);
    h2 = plotBand(curves.EMOSFOA.FE, curves.EMOSFOA.IGD_mean, curves.EMOSFOA.IGD_std, [0.00 0.45 0.74], true);
    xlabel('So lan danh gia FEM (FE)'); ylabel('IGD (chuan hoa)');
    title('Duong cong hoi tu IGD theo FE');
    legend([h1 h2], {'MOFDA','MOSFOA (E-MOSFOA)'}, 'Location','northeast');
    set(gca,'YScale','log');

    subplot(2,1,2); hold on; box on; grid on;
    h1 = plotBand(curves.MOFDA.FE, curves.MOFDA.HV_mean, curves.MOFDA.HV_std, [0.85 0.33 0.10], false);
    h2 = plotBand(curves.EMOSFOA.FE, curves.EMOSFOA.HV_mean, curves.EMOSFOA.HV_std, [0.00 0.45 0.74], false);
    xlabel('So lan danh gia FEM (FE)'); ylabel('Hypervolume (W co dinh)');
    title('Duong cong hoi tu HV theo FE');
    legend([h1 h2], {'MOFDA','MOSFOA (E-MOSFOA)'}, 'Location','southeast');

    saveas(f, fullfile(outDir, 'convergence_IGD_HV_vs_FE.png'));
    close(f);
end

function hLine = plotBand(x, ymean, ystd, col, clampPositive)
    x = x(:)'; ymean = ymean(:)'; ystd = ystd(:)';
    valid = ~isnan(ymean);
    x = x(valid); ymean = ymean(valid); ystd = ystd(valid);
    lo = ymean - ystd; hi = ymean + ystd;
    if clampPositive
        % truc log (IGD) khong nhan gia tri <=0 -- ghim day bang o mot
        % epsilon nho thay vi de MATLAB tu bo qua "negative data"
        lo = max(lo, max(ymean,eps) * 1e-6);
    end
    fill([x, fliplr(x)], [lo, fliplr(hi)], col, 'FaceAlpha', 0.15, 'EdgeColor','none', 'HandleVisibility','off');
    hLine = plot(x, ymean, '-', 'Color', col, 'LineWidth', 1.8);
end

function checkBoundaryClustering(RefX, bounds, outDir)
    % RefX cols: [CatIdx_BTCT, D_thep, t_thep], bounds.lb/ub tuong ung
    names = bounds.names; lb = bounds.lb; ub = bounds.ub;
    N = size(RefX,1);
    fprintf('\n=== Kiem chung hien tuong "don bien" tren %d nghiem Pareto tham chieu ===\n', N);
    T = table();
    for j = 1:numel(names)
        col = RefX(:,j);
        atLB = sum(abs(col - lb(j)) < 1e-9);
        atUB = sum(abs(col - ub(j)) < 1e-9);
        nearUBfrac = 0.05 * (ub(j)-lb(j)); % trong 5% khoang gan bien tren
        nearLBfrac = nearUBfrac;
        nearLB = sum(col <= lb(j) + nearLBfrac);
        nearUB = sum(col >= ub(j) - nearUBfrac);
        fprintf('%-14s lb=%.4f ub=%.4f | tai LB: %d/%d (%.1f%%) | tai UB: %d/%d (%.1f%%) | gan LB(5%%): %d | gan UB(5%%): %d\n', ...
            names{j}, lb(j), ub(j), atLB, N, 100*atLB/N, atUB, N, 100*atUB/N, nearLB, nearUB);
        row = table(names(j), lb(j), ub(j), atLB, atUB, N, nearLB, nearUB, ...
            'VariableNames', {'Variable','LB','UB','CountAtLB','CountAtUB','TotalN','CountNear5pctLB','CountNear5pctUB'});
        T = [T; row]; %#ok<AGROW>
    end
    writetable(T, fullfile(outDir, 'boundary_clustering_reference_pareto.csv'));
end
