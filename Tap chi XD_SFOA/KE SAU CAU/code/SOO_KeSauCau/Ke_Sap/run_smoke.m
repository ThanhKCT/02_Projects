%% run_smoke.m -- thin wrapper so watchdog_run.ps1 (which addpaths this
% Ke_Sap folder) can launch the smoke-test mode of SOO_KeSauCau_run_SAP.m
% (one level up) with a single bare script name, and so the watchdog has
% a clear success marker to poll for (the driver itself only fprintf's to
% stdout, no dedicated small log file with an unambiguous DONE marker).
scriptDir = fileparts(mfilename('fullpath'));
logPath = fullfile(scriptDir,'run_smoke_log.txt');
fid = fopen(logPath,'a'); fprintf(fid,'[%s] run_smoke start\n', datestr(now,'HH:MM:SS')); fclose(fid);

runMode = 'smoke'; Nrun = 1; runIdOffset = 0; %#ok<NASGU>
run(fullfile(scriptDir,'..','SOO_KeSauCau_run_SAP.m'));

fid = fopen(logPath,'a'); fprintf(fid,'[%s] run_smoke DONE OK\n', datestr(now,'HH:MM:SS')); fclose(fid);
