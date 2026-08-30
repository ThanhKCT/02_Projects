%% run_paper.m -- official campaign run (Npop=50, Max_it=50, Nrun=1,
% 2550 FEs total), same pattern as run_pilot.m/run_convpilot.m.
% Nrun=1 is a deliberate final decision (2026-08-29): this is an application
% paper (SFOA used as a design-optimization tool for one real structure),
% not an algorithm-comparison/development paper, so multi-run mean/std
% statistics are not needed. Npop/Max_it sized above the convergence
% evidence from the 'convpilot' run -- see SOO_KeSauCau_run_SAP.m's 'paper'
% case comment for the justification.
scriptDir = fileparts(mfilename('fullpath'));
logPath = fullfile(scriptDir,'run_paper_log.txt');
fid = fopen(logPath,'a'); fprintf(fid,'[%s] run_paper start\n', datestr(now,'HH:MM:SS')); fclose(fid);

runMode = 'paper'; Nrun = 1; runIdOffset = 0; %#ok<NASGU>
run(fullfile(scriptDir,'..','SOO_KeSauCau_run_SAP.m'));

fid = fopen(logPath,'a'); fprintf(fid,'[%s] run_paper DONE OK\n', datestr(now,'HH:MM:SS')); fclose(fid);
