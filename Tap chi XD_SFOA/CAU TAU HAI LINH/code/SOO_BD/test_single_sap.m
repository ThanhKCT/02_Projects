%% test_single_sap.m
% Diagnostic-only script: opens ONE SAP2000 COM instance (no spmd/parpool),
% loads BD.sdb, runs a single evaluation via Sap_BD_HL_v3, and prints
% step-by-step timing so any hang/failure point is visible in stdout.
% Not part of the paper pipeline -- delete after diagnosis.

scriptDir = fileparts(mfilename('fullpath'));
cd(scriptDir);
addpath(fullfile(scriptDir,'Functions'));
addpath(fullfile(scriptDir,'BD_Sap'));
addpath(fullfile(scriptDir,'Pile_TCVN10304_2014'));

fprintf('[TEST %s] Step 0: load X1_X2.mat (pile catalogue)...\n', datestr(now,'HH:MM:SS'));
load('X1_X2.mat'); % loads: data
fprintf('[TEST %s]   OK. size(data)=[%d %d]\n', datestr(now,'HH:MM:SS'), size(data,1), size(data,2));

fprintf('[TEST %s] Step 1: taskkill any stray SAP2000.exe...\n', datestr(now,'HH:MM:SS'));
system('taskkill /F /IM SAP2000.exe');
pause(2);

fprintf('[TEST %s] Step 2: open_Sap2000(1) (hidden)...\n', datestr(now,'HH:MM:SS'));
t0 = tic;
try
    open_Sap2000(1);
    fprintf('[TEST %s]   OK, open_Sap2000 done in %.1fs\n', datestr(now,'HH:MM:SS'), toc(t0));
catch ME
    fprintf(2, '[TEST %s]   FAILED at open_Sap2000: %s\n', datestr(now,'HH:MM:SS'), ME.message);
    rethrow(ME);
end

pause(2);
try; SM.Hide; catch ME2; fprintf(2,'[TEST] SM.Hide warning: %s\n', ME2.message); end

Sap_path0 = fullfile(pwd,'BD_Sap','BD.sdb');
fprintf('[TEST %s] Step 3: SM.File.OpenFile(%s)...\n', datestr(now,'HH:MM:SS'), Sap_path0);
t1 = tic;
try
    SM.File.OpenFile(Sap_path0);
    fprintf('[TEST %s]   OK, OpenFile done in %.1fs\n', datestr(now,'HH:MM:SS'), toc(t1));
catch ME
    fprintf(2, '[TEST %s]   FAILED at OpenFile: %s\n', datestr(now,'HH:MM:SS'), ME.message);
    rethrow(ME);
end
try; SM.Hide; catch; end

maxNumCompThreads(1);

fprintf('[TEST %s] Step 4: single evaluation via Sap_BD_HL_v3 (mid-range candidate)...\n', datestr(now,'HH:MM:SS'));
X1 = [25, 6, 37.5]; % known-feasible candidate reused from BD_SOO_Cost_run01_SMOKE.mat (BestRaw=32940.13)
t2 = tic;
try
    [fit, diag] = Sap_BD_HL_v3(X1, data);
    elapsed = toc(t2);
    fprintf('[TEST %s]   OK, single FE done in %.2fs. fit=[Cost=%.2f, Disp=%.4f]\n', ...
        datestr(now,'HH:MM:SS'), elapsed, fit(1), fit(2));
catch ME
    fprintf(2, '[TEST %s]   FAILED at Sap_BD_HL_v3: %s\n', datestr(now,'HH:MM:SS'), ME.message);
    for k = 1:numel(ME.stack)
        fprintf(2, '       at %s (line %d)\n', ME.stack(k).name, ME.stack(k).line);
    end
    system('taskkill /F /IM SAP2000.exe');
    rethrow(ME);
end

fprintf('[TEST %s] Step 5: cleanup (taskkill SAP2000.exe)...\n', datestr(now,'HH:MM:SS'));
system('taskkill /F /IM SAP2000.exe');
fprintf('[TEST %s] ALL STEPS OK.\n', datestr(now,'HH:MM:SS'));
