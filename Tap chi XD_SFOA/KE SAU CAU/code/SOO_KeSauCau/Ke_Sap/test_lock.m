%% test_lock.m -- isolate whether SetModelIsLocked/SetShell_1 are actually
% succeeding (check return codes explicitly, which the real Sap_KeSauCau.m
% never did -- it just called them and assumed success).
scriptDir = fileparts(mfilename('fullpath'));
sdbPath = fullfile(scriptDir,'..','..','..','Sap','ke pd 10.sdb');
logPath = fullfile(scriptDir,'lock_log.txt');

open_Sap2000(1); pause(2); SM.Hide;
ret = SM.File.OpenFile(sdbPath);
fid=fopen(logPath,'a'); fprintf(fid,'OpenFile ret=%d\n',ret); fclose(fid);
SM.SetPresentUnits(SM.eUnits.Ton_m_C);

try
    lockedBefore = SM.GetModelIsLocked();
    fid=fopen(logPath,'a'); fprintf(fid,'GetModelIsLocked BEFORE unlock attempt: %s (class %s)\n', mat2str(lockedBefore), class(lockedBefore)); fclose(fid);
catch ME
    fid=fopen(logPath,'a'); fprintf(fid,'GetModelIsLocked FAILED: %s\n', ME.message); fclose(fid);
end

retUnlock = SM.SetModelIsLocked(false);
fid=fopen(logPath,'a'); fprintf(fid,'SetModelIsLocked(false) ret=%s (class %s)\n', mat2str(retUnlock), class(retUnlock)); fclose(fid);

try
    lockedAfter = SM.GetModelIsLocked();
    fid=fopen(logPath,'a'); fprintf(fid,'GetModelIsLocked AFTER unlock attempt: %s\n', mat2str(lockedAfter)); fclose(fid);
catch ME
    fid=fopen(logPath,'a'); fprintf(fid,'GetModelIsLocked AFTER FAILED: %s\n', ME.message); fclose(fid);
end

retSet = SM.PropArea.SetShell_1('TUONGM78', 1, false, 'M350', 0, 0.20, 0.20);
fid=fopen(logPath,'a'); fprintf(fid,'SetShell_1 ret=%s (class %s)\n', mat2str(retSet), class(retSet)); fclose(fid);

% try again with an explicit DeleteResults BEFORE unlocking, in case that's
% the missing prerequisite (some FEA tools require clearing results before
% a locked model with existing results can be unlocked at all)
try
    retDel = SM.Analyze.DeleteResults('', true);
    fid=fopen(logPath,'a'); fprintf(fid,'DeleteResults ret=%s\n', mat2str(retDel)); fclose(fid);
catch ME
    fid=fopen(logPath,'a'); fprintf(fid,'DeleteResults FAILED: %s\n', ME.message); fclose(fid);
end
retUnlock2 = SM.SetModelIsLocked(false);
fid=fopen(logPath,'a'); fprintf(fid,'SetModelIsLocked(false) AFTER DeleteResults, ret=%s\n', mat2str(retUnlock2)); fclose(fid);
retSet2 = SM.PropArea.SetShell_1('TUONGM78', 1, false, 'M350', 0, 0.15, 0.15);
fid=fopen(logPath,'a'); fprintf(fid,'SetShell_1(0.15) AFTER DeleteResults+unlock, ret=%s\n', mat2str(retSet2)); fclose(fid);

fid=fopen(logPath,'a'); fprintf(fid,'DONE OK\n'); fclose(fid);
try; SM.ApplicationExit(false); catch; end
