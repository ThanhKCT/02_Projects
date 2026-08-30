%% run_convpilot.m -- convergence-diagnostic pilot (Npop=15, Max_it=40,
% ~615 FEs total) wrapper, same pattern as run_pilot.m/run_smoke.m.
% Purpose: the 'pilot' run (Max_it=5) showed NO plateau in its Curve --
% still improving at the last iteration -- so this single longer run (at
% the Npop intended for the real 'paper' campaign) is purely to observe
% where the convergence curve actually flattens, before locking Max_it/Nrun
% for the campaign. See dump_pilot_curve.m to inspect the resulting Curve.
scriptDir = fileparts(mfilename('fullpath'));
logPath = fullfile(scriptDir,'run_convpilot_log.txt');
fid = fopen(logPath,'a'); fprintf(fid,'[%s] run_convpilot start\n', datestr(now,'HH:MM:SS')); fclose(fid);

runMode = 'convpilot'; Nrun = 1; runIdOffset = 0; %#ok<NASGU>
run(fullfile(scriptDir,'..','SOO_KeSauCau_run_SAP.m'));

fid = fopen(logPath,'a'); fprintf(fid,'[%s] run_convpilot DONE OK\n', datestr(now,'HH:MM:SS')); fclose(fid);
