function run_mofda_stats_wharf100dwt(Nruns, Num_work, Np, maxiter)
% =========================================================================
% NGAY 2 (theo gop y phan bien JMST V4 -> V5, muc II.2 va III cua bao cao):
% chay MOFDA DOC LAP Nruns lan (mac dinh 20) voi Np=50, maxiter=50, moi
% lan mot RunTag rieng ('run01'..'runNN') de khong ghi de len nhau (xem
% tham so RunTag moi them o run_mofda_wharf100dwt_parallel.m).
%
% DIEU KIEN TIEN QUYET: file Wharf100DWT_BRUTEFORCE_FINAL.mat (vet can
% 4.080 to hop Ngay 1) phai TON TAI va co du bien Xall/fit/diagnostic --
% neu khong, wharf100dwt_evaluate() se KHONG tim thay cache va MOI lan
% goi se chay SAP2000 that (rat cham, mat het loi ich cua Buoc A). Ham
% nay KIEM TRA dieu kien nay truoc khi chay, dung ngay neu chua co.
%
% Vi cache tu Ngay 1 phu 100% luoi thiet ke, cac worker se hau nhu KHONG
% goi SAP2000 that trong Ngay 2 -- nen van mo SAP2000 cho tung worker (ham
% wharf100dwt_evaluate goi SM.* khi cache MISS, vd geometry vo ly) nhung
% Num_work co the giam (vd 4) ma khong anh huong toc do dang ke.
%
% Sau khi ca Nruns lan chay xong, tinh GD/IGD cho tung lan (chuan hoa theo
% min-max cua mat Pareto that -- KHONG so sanh truc tiep f1 (~1000-4000
% tan) voi f2 (~0,01-0,03 m) neu khong chuan hoa) va luu bang thong ke
% tong hop (results/Wharf100DWT_MOFDA_STATS_SUMMARY.csv +.mat).
% =========================================================================
    if nargin < 1 || isempty(Nruns), Nruns = 20; end
    if nargin < 2 || isempty(Num_work), Num_work = 8; end
    if nargin < 3 || isempty(Np), Np = 50; end
    if nargin < 4 || isempty(maxiter), maxiter = 50; end

    scriptDir = fileparts(mfilename('fullpath'));
    addpath(fullfile(scriptDir, 'Functions'));
    addpath(fullfile(fileparts(scriptDir), 'MOFDA', 'Functions'));
    resultsDir = fullfile(scriptDir, 'results');

    bruteforceFile = fullfile(resultsDir, 'Wharf100DWT_BRUTEFORCE_FINAL.mat');
    if ~isfile(bruteforceFile)
        error('run_mofda_stats_wharf100dwt:MissingBruteforce', ...
            ['%s chua ton tai -- phai chay xong run_bruteforce_wharf100dwt() ' ...
             '(vet can Ngay 1, 4.080 to hop) TRUOC KHI chay ham nay, neu khong ' ...
             'se mat toan bo loi ich cache va MOFDA se rat cham.'], bruteforceFile);
    end
    S = load(bruteforceFile, 'Xall', 'fit', 'diagnostic', 'ParetoFit');
    if ~isfield(S, 'diagnostic')
        error('run_mofda_stats_wharf100dwt:OldBruteforceFile', ...
            '%s la file cu (chua co bien diagnostic) -- chay lai brute-force voi code moi truoc.', bruteforceFile);
    end
    fprintf('Da xac nhan cache Ngay 1: %s (%d to hop, %d nghiem Pareto that).\n', ...
        bruteforceFile, size(S.Xall,1), size(S.ParetoFit,1));

    % --- Chay Nruns lan MOFDA doc lap (idempotent -- lan da xong se tu BO QUA) ---
    for r = 1:Nruns
        tag = sprintf('run%02d', r);
        fprintf('=== MOFDA doc lap lan %d/%d (RunTag=%s) ===\n', r, Nruns, tag);
        run_mofda_wharf100dwt_parallel(Num_work, Np, maxiter, tag);
    end

    % --- Tong hop GD/IGD cho tung lan chay ---
    RefFront = S.ParetoFit; % (16 hoac nhieu hon x 2) mat Pareto that Ngay 1
    fMin = min(RefFront, [], 1); fMax = max(RefFront, [], 1);
    fRange = fMax - fMin; fRange(fRange == 0) = 1; % tranh chia 0

    normalize = @(F) (F - fMin) ./ fRange;
    RefFrontNorm = normalize(RefFront)'; % obj x N, dung cho generational_distance/IGD

    GDvals = nan(Nruns,1); IGDvals = nan(Nruns,1);
    RepSize = nan(Nruns,1); NumExactMatch = nan(Nruns,1);

    for r = 1:Nruns
        tag = sprintf('run%02d', r);
        finalFile = fullfile(resultsDir, sprintf('Wharf100DWT_MOFDA_FULL_Np%d_Maxit%d_%s_FINAL.mat', Np, maxiter, tag));
        if ~isfile(finalFile)
            warning('run_mofda_stats_wharf100dwt:MissingRunFile', '%s khong ton tai -- BO QUA lan chay nay trong thong ke.', finalFile);
            continue;
        end
        R = load(finalFile, 'REP');
        fRun = R.REP.pos_fit;
        RepSize(r) = size(fRun,1);

        fRunNorm = normalize(fRun)';
        GDvals(r)  = generational_distance(fRunNorm, RefFrontNorm);
        IGDvals(r) = generational_distance(RefFrontNorm, fRunNorm); % IGD = GD tinh nguoc (RefFront -> fRun)

        % Dem so nghiem TRUNG KHOP CHINH XAC voi mat Pareto that (lam tron 6 chu so thap phan)
        matchCount = 0;
        for i = 1:size(fRun,1)
            if any(all(abs(RefFront - fRun(i,:)) < 1e-6, 2))
                matchCount = matchCount + 1;
            end
        end
        NumExactMatch(r) = matchCount;
    end

    validIdx = ~isnan(GDvals);
    fprintf('\n=== TONG HOP THONG KE (%d/%d lan chay hop le) ===\n', sum(validIdx), Nruns);
    fprintf('GD  : mean=%.5f std=%.5f min=%.5f max=%.5f\n', mean(GDvals(validIdx)), std(GDvals(validIdx)), min(GDvals(validIdx)), max(GDvals(validIdx)));
    fprintf('IGD : mean=%.5f std=%.5f min=%.5f max=%.5f\n', mean(IGDvals(validIdx)), std(IGDvals(validIdx)), min(IGDvals(validIdx)), max(IGDvals(validIdx)));
    fprintf('Repository size: mean=%.2f std=%.2f\n', mean(RepSize(validIdx)), std(RepSize(validIdx)));
    fprintf('So nghiem trung khop chinh xac mat Pareto that (/%d): mean=%.2f std=%.2f\n', size(RefFront,1), mean(NumExactMatch(validIdx)), std(NumExactMatch(validIdx)));

    summaryFile = fullfile(resultsDir, 'Wharf100DWT_MOFDA_STATS_SUMMARY.mat');
    save(summaryFile, 'GDvals', 'IGDvals', 'RepSize', 'NumExactMatch', 'Np', 'maxiter', 'Nruns', 'RefFront', '-v7.3');

    csvFile = fullfile(resultsDir, 'Wharf100DWT_MOFDA_STATS_SUMMARY.csv');
    fid = fopen(csvFile, 'w');
    fprintf(fid, 'run,GD,IGD,RepositorySize,NumExactMatch\n');
    for r = 1:Nruns
        fprintf(fid, '%d,%.6f,%.6f,%d,%d\n', r, GDvals(r), IGDvals(r), RepSize(r), NumExactMatch(r));
    end
    fclose(fid);
    fprintf('Da luu: %s va %s\n', summaryFile, csvFile);
end
