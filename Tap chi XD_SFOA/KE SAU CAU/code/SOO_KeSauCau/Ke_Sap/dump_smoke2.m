S = load(fullfile(fileparts(mfilename('fullpath')),'..','results_SAP','KeSauCau_SOO_WallVolume_SAP_run01_SMOKE.mat'));
R = S.RunResult;
fprintf('BestPenalized=%.4f BestRaw(Vconcrete)=%.4f\n', R.BestPenalized, R.BestRaw);
fprintf('BestX = %s\n', mat2str(R.BestX,6));
fprintf('Elapsed=%.1fs FEcount=%d\n', R.ElapsedSeconds, R.FEcount);
for k = 1:numel(R.DiagnosticColumns)
    fprintf('  %s = %.6f\n', R.DiagnosticColumns{k}, R.BestDiagnostics(k));
end
