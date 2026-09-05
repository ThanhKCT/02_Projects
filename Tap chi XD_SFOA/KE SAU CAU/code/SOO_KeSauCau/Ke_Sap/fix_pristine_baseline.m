%% fix_pristine_baseline.m -- 2026-09-04
% One-time maintenance: opens Sap\ke pd 10.PRISTINE_BASELINE.sdb in a
% SEPARATE SAP2000 instance (independent of any campaign currently running
% against the working copy Sap\ke pd 10.sdb) to clear the "recent analysis
% results are not flagged as compatible with this model" prompt that was
% observed on 2026-09-04 when watchdog_run.ps1 restored this exact
% baseline and OpenFile'd it -- that prompt is a native modal dialog that
% blocks unattended automation (watchdog cannot answer it), so if it
% happens again on some future watchdog restart with nobody at the
% machine, the run would hang until MaxAttemptSeconds. This script:
%   1. Opens the baseline in a fresh, independent SAP2000 COM instance.
%   2. An external watcher (fix_pristine_baseline_watch.ps1, launched
%      alongside this) answers "No" (delete the stale results) on the
%      dialog if/when it appears -- OpenFile blocks until it's answered.
%   3. Unlocks the model, deletes any lingering analysis results
%      explicitly, and re-saves the file in place -- so it reopens clean
%      (no stale results flag) on every future watchdog restore.
% Does NOT touch the live Sap\ke pd 10.sdb the running campaign is using.
scriptDir = fileparts(mfilename('fullpath'));
addpath('D:\ResearchLab\02_Projects\02_Projects\Tap chi XD_SFOA\CAU TAU HAI LINH\code\Functions');
logPath = fullfile(scriptDir,'fix_pristine_baseline_log.txt');
if isfile(logPath); delete(logPath); end

baselinePath = 'D:\ResearchLab\02_Projects\02_Projects\Tap chi XD_SFOA\KE SAU CAU\Sap\ke pd 10.PRISTINE_BASELINE.sdb';

try
    fid=fopen(logPath,'a'); fprintf(fid,'[%s] starting fresh independent SAP2000 instance...\n', datestr(now,'HH:MM:SS')); fclose(fid);
    open_Sap2000(1); pause(2); SM.Hide;
    fid=fopen(logPath,'a'); fprintf(fid,'[%s] instance ready, about to OpenFile on baseline (may block on the incompatible-results dialog -- watcher script should answer it)...\n', datestr(now,'HH:MM:SS')); fclose(fid);

    ret = SM.File.OpenFile(baselinePath);
    fid=fopen(logPath,'a'); fprintf(fid,'[%s] OpenFile returned ret=%d\n', datestr(now,'HH:MM:SS'), ret); fclose(fid);
    if ret ~= 0
        fid=fopen(logPath,'a'); fprintf(fid,'[%s] OpenFile FAILED -- aborting, baseline left untouched.\n', datestr(now,'HH:MM:SS')); fclose(fid);
        error('fix_pristine_baseline:OpenFileFailed','OpenFile ret=%d', ret);
    end

    SM.SetPresentUnits(SM.eUnits.Ton_m_C);
    retUnlock = SM.SetModelIsLocked(false);
    fid=fopen(logPath,'a'); fprintf(fid,'[%s] SetModelIsLocked(false) ret=%s\n', datestr(now,'HH:MM:SS'), mat2str(retUnlock)); fclose(fid);

    % Explicitly delete any analysis results so the file has NOTHING
    % stale to flag as incompatible on the next open, regardless of what
    % answering "No" on the dialog already did internally.
    try
        retDel = SM.Analyze.DeleteResults('');
        fid=fopen(logPath,'a'); fprintf(fid,'[%s] DeleteResults ret=%s\n', datestr(now,'HH:MM:SS'), mat2str(retDel)); fclose(fid);
    catch ME2
        fid=fopen(logPath,'a'); fprintf(fid,'[%s] DeleteResults threw (non-fatal, continuing): %s\n', datestr(now,'HH:MM:SS'), ME2.message); fclose(fid);
    end

    retSave = SM.File.Save(baselinePath);
    fid=fopen(logPath,'a'); fprintf(fid,'[%s] Save ret=%s\n', datestr(now,'HH:MM:SS'), mat2str(retSave)); fclose(fid);
    if ~isequal(retSave,0)
        fid=fopen(logPath,'a'); fprintf(fid,'[%s] WARNING: Save did not return 0 -- baseline may not be fixed, check manually.\n', datestr(now,'HH:MM:SS')); fclose(fid);
    end

    SM.ApplicationExit(false);
    fid=fopen(logPath,'a'); fprintf(fid,'[%s] DONE OK\n', datestr(now,'HH:MM:SS')); fclose(fid);
catch ME
    fid=fopen(logPath,'a'); fprintf(fid,'[%s] CAUGHT ERROR: %s\n', datestr(now,'HH:MM:SS'), ME.message); fclose(fid);
    try; SM.ApplicationExit(false); catch; end
    rethrow(ME);
end
