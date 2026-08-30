%% test_setshell.m -- verify SetShell_1 actually changes the section's
% thickness by reading it back immediately, and also check whether
% RunAnalysis's return code / CaseStatus indicates it actually re-solved.
scriptDir = fileparts(mfilename('fullpath'));
sdbPath = fullfile(scriptDir,'..','..','..','Sap','ke pd 10.sdb');
logPath = fullfile(scriptDir,'setshell_log.txt');

open_Sap2000(1); pause(2); SM.Hide;
ret = SM.File.OpenFile(sdbPath);
fid=fopen(logPath,'a'); fprintf(fid,'OpenFile ret=%d\n',ret); fclose(fid);
SM.SetPresentUnits(SM.eUnits.Ton_m_C);
SM.Analyze.SetRunCaseFlag('MODAL', false);

% --- read back the CURRENT thickness of TUONGM78 before changing anything ---
[ret1, propOut] = SM.PropArea.GetShell('TUONGM78');
fid=fopen(logPath,'a'); fprintf(fid,'GetShell BEFORE change: ret=%d propOut(class)=%s\n', ret1, class(propOut)); fclose(fid);
% dump every field/output we can -- try common alt signatures defensively
try
    [ret2, matProp, matAng, thk1, thk2] = SM.PropArea.GetShell('TUONGM78');
    fid=fopen(logPath,'a'); fprintf(fid,'GetShell(5out) ret=%d matProp=%s matAng=%g thk1=%g thk2=%g\n', ret2, matProp, matAng, thk1, thk2); fclose(fid);
catch ME
    fid=fopen(logPath,'a'); fprintf(fid,'GetShell(5out) FAILED: %s\n', ME.message); fclose(fid);
end

% --- now SET it to something very different (0.20) and read back ---
SM.SetModelIsLocked(false);
retSet = SM.PropArea.SetShell_1('TUONGM78', 1, false, 'M350', 0, 0.20, 0.20);
fid=fopen(logPath,'a'); fprintf(fid,'SetShell_1 to 0.20 ret=%d\n', retSet); fclose(fid);

try
    [ret3, matProp3, matAng3, thk1_3, thk2_3] = SM.PropArea.GetShell('TUONGM78');
    fid=fopen(logPath,'a'); fprintf(fid,'GetShell AFTER set-to-0.20: ret=%d matProp=%s thk1=%g thk2=%g\n', ret3, matProp3, thk1_3, thk2_3); fclose(fid);
catch ME
    fid=fopen(logPath,'a'); fprintf(fid,'GetShell AFTER FAILED: %s\n', ME.message); fclose(fid);
end

% --- run analysis, check CaseStatus for BAO/TH1 before and after ---
try
    [retCS1, statusBefore] = SM.Analyze.GetCaseStatus('BAO');
    fid=fopen(logPath,'a'); fprintf(fid,'GetCaseStatus(BAO) BEFORE RunAnalysis: ret=%d status=%g\n', retCS1, statusBefore); fclose(fid);
catch ME
    fid=fopen(logPath,'a'); fprintf(fid,'GetCaseStatus BEFORE FAILED: %s\n', ME.message); fclose(fid);
end

retDel = -999;
try; retDel = SM.Analyze.DeleteResults('', true); catch ME; fid=fopen(logPath,'a'); fprintf(fid,'DeleteResults FAILED: %s\n', ME.message); fclose(fid); end
fid=fopen(logPath,'a'); fprintf(fid,'DeleteResults ret=%d\n', retDel); fclose(fid);

retRA = SM.Analyze.RunAnalysis;
fid=fopen(logPath,'a'); fprintf(fid,'RunAnalysis ret=%g\n', retRA); fclose(fid);

try
    [retCS2, statusAfter] = SM.Analyze.GetCaseStatus('BAO');
    fid=fopen(logPath,'a'); fprintf(fid,'GetCaseStatus(BAO) AFTER RunAnalysis: ret=%d status=%g\n', retCS2, statusAfter); fclose(fid);
catch ME
    fid=fopen(logPath,'a'); fprintf(fid,'GetCaseStatus AFTER FAILED: %s\n', ME.message); fclose(fid);
end

% --- read the actual force result now ---
SM.Results.Setup.DeselectAllCasesAndCombosForOutput;
SM.Results.Setup.SetComboSelectedForOutput('BAO');
[~,~,~,~,~,~,~,~,~,~,~,~,~,~,~,M11c,M22c,~,~,~,~,V13c,V23c,~,~] = SM.Results.AreaForceShell('TUONGM78', SM.eItemTypeElm.GroupElm);
fid=fopen(logPath,'a'); fprintf(fid,'AFTER set-to-0.20 + reanalysis: max|M22|=%.6f max|V23|=%.6f\n', max(abs(M22c)), max(abs(V23c))); fclose(fid);

fid=fopen(logPath,'a'); fprintf(fid,'DONE OK\n'); fclose(fid);
try; SM.ApplicationExit(false); catch; end
