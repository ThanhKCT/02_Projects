function Final_Benchmark()
% =========================================================================
% BENCHMARK CUOI CUNG - 30 LAN CHAY DOC LAP, DUNG CHUNG NGAN SACH NFE
% Ban CO THE CHAY LAI (resumable): moi lan chay duoc luu ngay thanh 1 file
% rieng trong thu muc bench_results/ ngay khi xong, nen neu bi ngat ngang
% (VD phien MATLAB bi kill) thi chi can goi lai Final_Benchmark() - cac
% lan chay da xong se duoc BO QUA, chi chay tiep cac lan con thieu.
% =========================================================================
clc;

nPop = 100; nRep = 100;
NFE_Target = 30000;
MaxIt_Calib = [3 8];
nRuns = 30;

outDir = 'bench_results';
if ~exist(outDir, 'dir'), mkdir(outDir); end

rng('default');
disp('== HIEU CHINH MaxIt THEO NGAN SACH NFE CHUNG ==');
MaxIt_mopso = CalibrateMaxIt(@(it) mopso(it, nPop, nRep), MaxIt_Calib, NFE_Target);
MaxIt_nsga2 = CalibrateMaxIt(@(it) nsga2(it, nPop), MaxIt_Calib, NFE_Target);
MaxIt_pesa2 = CalibrateMaxIt(@(it) pesa2(it, nPop, nRep), MaxIt_Calib, NFE_Target);
fprintf('MaxIt - MOPSO:%d | NSGA-II:%d | PESA-II:%d (NFE_Target=%d)\n', ...
    MaxIt_mopso, MaxIt_nsga2, MaxIt_pesa2, NFE_Target);

% --- Xac dinh cac lan chay DA XONG (de resume) ---
todo = [];
for run = 1:nRuns
    fpath = fullfile(outDir, sprintf('run_%02d.mat', run));
    if ~exist(fpath, 'file')
        todo(end+1) = run; %#ok<AGROW>
    end
end
fprintf('>> Da xong: %d/%d lan chay. Con thieu: %d lan (%s)\n', ...
    nRuns-numel(todo), nRuns, numel(todo), mat2str(todo));

disp('== CHAY CAC LAN CON THIEU (parfor) ==');
parfor k = 1:numel(todo)
    run = todo(k);
    tic; rep = mopso(MaxIt_mopso, nPop, nRep); t1 = toc;
    tic; F1 = nsga2(MaxIt_nsga2, nPop); t2 = toc;
    tic; archive = pesa2(MaxIt_pesa2, nPop, nRep); t3 = toc;

    Costs_mopso = [rep.Cost]; Costs_nsga2 = [F1.Cost]; Costs_pesa2 = [archive.Cost];
    Pos_mopso = reshape([rep.Position], 8, [])';
    Pos_nsga2 = reshape([F1.Position], 8, [])';
    Pos_pesa2 = reshape([archive.Position], 8, [])';

    fpath = fullfile(outDir, sprintf('run_%02d.mat', run));
    parsave(fpath, t1, t2, t3, Costs_mopso, Costs_nsga2, Costs_pesa2, ...
        Pos_mopso, Pos_nsga2, Pos_pesa2);

    fprintf('>> Hoan thanh va DA LUU lan chay %d/%d\n', run, nRuns);
end

% --- GOP TAT CA CAC FILE run_XX.mat THANH 1 FILE TONG HOP ---
disp('== GOP KET QUA ==');
time_mopso = zeros(nRuns,1); time_nsga2 = zeros(nRuns,1); time_pesa2 = zeros(nRuns,1);
CostsCell_mopso = cell(nRuns,1); CostsCell_nsga2 = cell(nRuns,1); CostsCell_pesa2 = cell(nRuns,1);
PosCell_mopso = cell(nRuns,1); PosCell_nsga2 = cell(nRuns,1); PosCell_pesa2 = cell(nRuns,1);

allDone = true;
for run = 1:nRuns
    fpath = fullfile(outDir, sprintf('run_%02d.mat', run));
    if ~exist(fpath, 'file')
        allDone = false;
        fprintf('!! THIEU lan chay %d\n', run);
        continue;
    end
    S = load(fpath);
    time_mopso(run) = S.t1; time_nsga2(run) = S.t2; time_pesa2(run) = S.t3;
    CostsCell_mopso{run} = S.Costs_mopso; CostsCell_nsga2{run} = S.Costs_nsga2; CostsCell_pesa2{run} = S.Costs_pesa2;
    PosCell_mopso{run} = S.Pos_mopso; PosCell_nsga2{run} = S.Pos_nsga2; PosCell_pesa2{run} = S.Pos_pesa2;
end

if ~allDone
    disp('!! CHUA DU 30 LAN CHAY - hay goi lai Final_Benchmark() de chay tiep phan con thieu.');
    return;
end

save('Final_Benchmark_Results.mat', ...
    'time_mopso','time_nsga2','time_pesa2', ...
    'CostsCell_mopso','CostsCell_nsga2','CostsCell_pesa2', ...
    'PosCell_mopso','PosCell_nsga2','PosCell_pesa2', ...
    'MaxIt_mopso','MaxIt_nsga2','MaxIt_pesa2', ...
    'nRuns','nPop','nRep','NFE_Target');

disp('== HOAN TAT: DA LUU Final_Benchmark_Results.mat ==');
end

function parsave(fpath, t1, t2, t3, Costs_mopso, Costs_nsga2, Costs_pesa2, Pos_mopso, Pos_nsga2, Pos_pesa2)
    save(fpath, 't1','t2','t3','Costs_mopso','Costs_nsga2','Costs_pesa2', ...
        'Pos_mopso','Pos_nsga2','Pos_pesa2');
end

function MaxIt = CalibrateMaxIt(algoFn, MaxIt_Calib, NFE_Target)
    HamMucTieuToiUu('reset');
    algoFn(MaxIt_Calib(1));
    nfe1 = HamMucTieuToiUu();

    HamMucTieuToiUu('reset');
    algoFn(MaxIt_Calib(2));
    nfe2 = HamMucTieuToiUu();

    slope = (nfe2 - nfe1) / (MaxIt_Calib(2) - MaxIt_Calib(1));
    intercept = nfe1 - slope*MaxIt_Calib(1);

    MaxIt = round((NFE_Target - intercept) / slope);
    MaxIt = max(MaxIt, 5);
end
