%% dump_final_paper_result.m -- print full final PAPER campaign result
scriptDir = fileparts(mfilename('fullpath'));
finalFile = fullfile(scriptDir,'..','results_SAP','KeSauCau_SOO_WallVolume_SAP_run01_PAPER.mat');
outLog = fullfile(scriptDir,'dump_final_paper_result_log.txt');
fid = fopen(outLog,'w');

S = load(finalFile);
R = S.RunResult;
fprintf(fid, '=== %s ===\n', finalFile);
fprintf(fid, 'Npop=%d Max_it=%d FEcount=%d ElapsedSeconds=%.1f (%.2fs/FE)\n', ...
    R.Npop, R.MaxIt, R.FEcount, R.ElapsedSeconds, R.ElapsedSeconds/R.FEcount);
fprintf(fid, 'Timestamp=%s\n', R.Timestamp);
fprintf(fid, 'BestPenalized=%.6f BestRaw(Vconcrete)=%.6f\n', R.BestPenalized, R.BestRaw);
fprintf(fid, 'BestX (TUONGC30 TUONGM30 TUONGM43 TUONGM78 DAY130 DAY60) = %s\n', mat2str(R.BestX,6));
fprintf(fid, '\nDiagnosticColumns + BestDiagnostics:\n');
for k = 1:numel(R.DiagnosticColumns)
    fprintf(fid, '  %s = %.6f\n', R.DiagnosticColumns{k}, R.BestDiagnostics(k));
end
fprintf(fid, '\nCurve (best-so-far penalized fitness per iter)=%s\n', mat2str(R.Curve,6));
fprintf(fid, '\nRawCurve (best-so-far raw Vconcrete per iter)=%s\n', mat2str(R.RawCurve,6));
fclose(fid);
fprintf('DONE OK\n');
