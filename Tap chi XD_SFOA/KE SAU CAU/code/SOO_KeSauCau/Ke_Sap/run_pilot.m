%% run_pilot.m -- pilot mode (Npop=10, Max_it=5, 60 FEs total) wrapper,
% same pattern as run_smoke.m.
scriptDir = fileparts(mfilename('fullpath'));
logPath = fullfile(scriptDir,'run_pilot_log.txt');
fid = fopen(logPath,'a'); fprintf(fid,'[%s] run_pilot start\n', datestr(now,'HH:MM:SS')); fclose(fid);

runMode = 'pilot'; Nrun = 1; runIdOffset = 0; %#ok<NASGU>
run(fullfile(scriptDir,'..','SOO_KeSauCau_run_SAP.m'));

fid = fopen(logPath,'a'); fprintf(fid,'[%s] run_pilot DONE OK\n', datestr(now,'HH:MM:SS')); fclose(fid);
