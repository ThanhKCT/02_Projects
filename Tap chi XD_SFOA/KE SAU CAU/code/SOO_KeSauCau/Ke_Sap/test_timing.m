%% test_timing.m -- single-evaluation smoke test + t_FE timing for Sap_KeSauCau.m
scriptDir = fileparts(mfilename('fullpath'));
sdbPath = fullfile(scriptDir,'..','..','..','Sap','ke pd 10.sdb');
logPath = fullfile(scriptDir,'test_timing_log.txt');

logmsg(logPath, sprintf('=== test_timing start %s ===', datestr(now)));

open_Sap2000(1); pause(2); SM.Hide;
ret = SM.File.OpenFile(sdbPath);
logmsg(logPath, sprintf('OpenFile ret=%d', ret));
SM.SetPresentUnits(SM.eUnits.Ton_m_C);
SM.Analyze.SetRunCaseFlag('MODAL', false);

% Use the as-built thicknesses as the test point (from the .s2k dump
% earlier this session): TUONGC30=0.30, TUONGM30=0.30, TUONGM43=0.43,
% TUONGM78=0.78, DAY130=1.30, DAY60=0.60
Xtest = [0.30 0.30 0.43 0.78 1.30 0.60];
tStart = tic;
[fitTest, diagTest] = Sap_KeSauCau(Xtest);
tFE = toc(tStart);
logmsg(logPath, sprintf('t_FE=%.2fs', tFE));
logmsg(logPath, sprintf('fit=%.6f', fitTest));
cols = {'Vconcrete_m3','PileBearingViolation_T','PileMaxRatio','LateralDisp_mm', ...
    'DisplacementLimit_mm','LateralViolation_mm','ShearViolation_Tm', ...
    'CrackViolation_mm','PunchingViolation_T','TotalStructuralViolation', ...
    'Penalty','SAPAnalysisExecuted','AllConstraintsSatisfied'};
for k = 1:numel(cols)
    logmsg(logPath, sprintf('  %s = %.6f', cols{k}, diagTest(k)));
end

logmsg(logPath, '=== test_timing DONE OK ===');
try; SM.ApplicationExit(false); catch; end

function logmsg(logPath, msg)
    fid = fopen(logPath, 'a');
    fprintf(fid, '[%s] %s\n', datestr(now,'HH:MM:SS'), msg);
    fclose(fid);
    fprintf('%s\n', msg);
end
