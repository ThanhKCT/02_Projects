%% dump_pilot_curve.m -- print convergence curve + timing from the PILOT run
scriptDir = fileparts(mfilename('fullpath'));
pilotFile = fullfile(scriptDir,'..','results_SAP','KeSauCau_SOO_WallVolume_SAP_run01_PILOT.mat');
smokeFile = fullfile(scriptDir,'..','results_SAP','KeSauCau_SOO_WallVolume_SAP_run01_SMOKE.mat');
convFile  = fullfile(scriptDir,'..','results_SAP','KeSauCau_SOO_WallVolume_SAP_run01_CONVPILOT.mat');
outLog = fullfile(scriptDir,'dump_pilot_curve_log.txt');
fid = fopen(outLog,'w');

for f = {convFile, pilotFile, smokeFile}
    fp = f{1};
    if isfile(fp)
        S = load(fp);
        R = S.RunResult;
        fprintf(fid, '=== %s ===\n', fp);
        fprintf(fid, 'Npop=%d Max_it=%d FEcount=%d ElapsedSeconds=%.1f (%.2fs/FE)\n', ...
            R.Npop, R.MaxIt, R.FEcount, R.ElapsedSeconds, R.ElapsedSeconds/R.FEcount);
        fprintf(fid, 'BestPenalized=%.6f BestRaw(Vconcrete)=%.6f\n', R.BestPenalized, R.BestRaw);
        fprintf(fid, 'BestX=%s\n', mat2str(R.BestX));
        fprintf(fid, 'Curve (best-so-far penalized fitness per iter)=%s\n', mat2str(R.Curve,6));
        fprintf(fid, 'RawCurve (best-so-far raw Vconcrete per iter)=%s\n', mat2str(R.RawCurve,6));
        fprintf(fid, '\n');
    else
        fprintf(fid, '=== %s NOT FOUND ===\n\n', fp);
    end
end
fclose(fid);
fprintf('DONE OK\n');
