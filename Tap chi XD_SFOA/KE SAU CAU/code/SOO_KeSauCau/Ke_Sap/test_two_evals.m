%% test_two_evals.m -- run 2 VERY different X in the SAME SAP2000 session
% (mirroring the SFOA driver's own session-reuse pattern) and log raw
% PF3 (pile reaction) and U1 (wall-top displacement) values for each, to
% isolate whether PileMaxRatio/LateralDisp_mm being IDENTICAL across
% different X in the pilot run is a stale-SAP2000-result-cache issue or a
% bug in Sap_KeSauCau.m's own aggregation.
scriptDir = fileparts(mfilename('fullpath'));
sdbPath = fullfile(scriptDir,'..','..','..','Sap','ke pd 10.sdb');
logPath = fullfile(scriptDir,'two_evals_log.txt');

open_Sap2000(1); pause(2); SM.Hide;
ret = SM.File.OpenFile(sdbPath);
fid=fopen(logPath,'a'); fprintf(fid,'OpenFile ret=%d\n',ret); fclose(fid);
SM.SetPresentUnits(SM.eUnits.Ton_m_C);
SM.Analyze.SetRunCaseFlag('MODAL', false);

Xlist = {[0.30 0.30 0.43 0.78 1.30 0.60], [0.20 0.20 0.25 0.90 0.70 0.30]};
for e = 1:2
    X = Xlist{e};
    [fitTest, diagTest] = Sap_KeSauCau(X);

    % ALSO grab raw PF3/U1 AND raw AreaForceShell (TUONGM78) directly here
    [~,~,Obj,~,~,~,~,~,~,PF3,~,~,~] = SM.Results.JointReact('Piles', SM.eItemTypeElm.GroupElm);
    [~,~,~,~,~,~,~,U1,~,~,~,~,~] = SM.Results.JointDisplAbs('WallTop', SM.eItemTypeElm.GroupElm);
    [~,~,~,~,~,~,~,~,~,~,~,~,~,~,~,M11c,M22c,~,~,~,~,V13c,V23c,~,~] = SM.Results.AreaForceShell('TUONGM78', SM.eItemTypeElm.GroupElm);

    fid=fopen(logPath,'a');
    fprintf(fid,'--- eval %d, X=%s ---\n', e, mat2str(X));
    fprintf(fid,'  Sap_KeSauCau: Vconcrete=%.4f PileMaxRatio=%.6f LateralDisp=%.6f CrackViol=%.6f\n', ...
        diagTest(1), diagTest(3), diagTest(4), diagTest(8));
    fprintf(fid,'  RAW right here: sum(|PF3|)=%.6f max(|PF3|)=%.6f nPF3=%d max(|U1|)=%.6f nU1=%d\n', ...
        sum(abs(PF3)), max(abs(PF3)), numel(PF3), max(abs(U1)), numel(U1));
    fprintf(fid,'  RAW TUONGM78: max|M11|=%.6f max|M22|=%.6f max|V13|=%.6f max|V23|=%.6f nRows=%d\n', ...
        max(abs(M11c)), max(abs(M22c)), max(abs(V13c)), max(abs(V23c)), numel(M11c));
    fclose(fid);
end
fid=fopen(logPath,'a'); fprintf(fid,'DONE OK\n'); fclose(fid);
try; SM.ApplicationExit(false); catch; end
