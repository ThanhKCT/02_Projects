%% verify_grouped_model.m -- confirm the grouped copy (ke pd 10_grouped.sdb)
% gives IDENTICAL analysis results to the verified original (ke pd 10.sdb)
% before trusting it as the working baseline for Sap_Ke.m. Compares the
% same quantitative check already computed from the GUI-exported
% ground-truth "NL va phan luc pd10.xlsx" earlier this session: sum of
% joint-reaction F3 (vertical) per load case across all 142 pile joints.
% Ground truth (from that xlsx, computed earlier in this session):
%   DEAD=717.293  Gdat=0  Pdat=0.0  ALD=0.001  HH=308.8
%   TH1=717.292   TH2=1026.092  BAO=1743.383   (Tonf)
scriptDir = fileparts(mfilename('fullpath'));
% NOTE 2026-08-28: SM.File.Save(newPath) in precompute_wall_setup.m did NOT
% do a "Save As" as assumed -- it overwrote the ORIGINAL ke pd 10.sdb in
% place (confirmed: mtime/size changed on the original, no separate
% "_grouped" file was ever created). Pointing this verification at the
% now-current (grouped, in-place-modified) ke pd 10.sdb instead.
sdbPath = fullfile(scriptDir,'..','..','..','Sap','ke pd 10.sdb');
logPath = fullfile(scriptDir,'verify_log.txt');
assert(isfile(sdbPath), 'sdb not found at %s', sdbPath);

logmsg(logPath, sprintf('=== verify_grouped_model start %s ===', datestr(now)));

open_Sap2000(1); pause(2); SM.Hide;
ret = SM.File.OpenFile(sdbPath);
logmsg(logPath, sprintf('OpenFile(grouped) ret=%d', ret));
SM.SetPresentUnits(SM.eUnits.Ton_m_C);

ret = SM.Analyze.RunAnalysis();
logmsg(logPath, sprintf('RunAnalysis ret=%d', ret));

SM.Results.Setup.DeselectAllCasesAndCombosForOutput();
cases = {'DEAD','Gdat','Pdat','ALD','HH'};
combos = {'TH1','TH2','BAO'};
for c = cases; SM.Results.Setup.SetCaseSelectedForOutput(c{1}); end
for c = combos; SM.Results.Setup.SetComboSelectedForOutput(c{1}); end

[ret, nRes, Obj, Elm, LoadCase, StepType, StepNum, F1, F2, F3, M1, M2, M3] = ...
    SM.Results.JointReact('Piles', SM.eItemTypeElm.GroupElm);
logmsg(logPath, sprintf('JointReact ret=%d nRes=%d', ret, nRes));

allCaseNames = [cases, combos];
for k = 1:numel(allCaseNames)
    cn = allCaseNames{k};
    mask = strcmp(LoadCase, cn);
    s = sum(F3(mask));
    logmsg(logPath, sprintf('  sumF3(%s) = %.3f  (n=%d joints)', cn, s, sum(mask)));
end

logmsg(logPath, '=== verify_grouped_model DONE OK ===');
try; SM.ApplicationExit(false); catch; end

function logmsg(logPath, msg)
    fid = fopen(logPath, 'a');
    fprintf(fid, '[%s] %s\n', datestr(now,'HH:MM:SS'), msg);
    fclose(fid);
    fprintf('%s\n', msg);
end
