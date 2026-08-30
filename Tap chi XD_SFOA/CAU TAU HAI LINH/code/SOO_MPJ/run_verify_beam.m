scriptDir = 'D:\ResearchLab\02_Projects\Tap chi XD_SFOA\code\SOO_MPJ';
cd(scriptDir);
addpath(fullfile(scriptDir,'Functions'));
addpath(fullfile(scriptDir,'MPJ_Sap'));
addpath(fullfile(scriptDir,'Pile_TCVN10304_2014'));

load('X1_X2.mat');   % load bien `data` (danh muc coc)

open_Sap2000(1); pause(2); SM.Hide;
verifyFolder = fullfile(scriptDir,'MPJ_Sap','VerifyBeam_tmp');
if ~exist(verifyFolder,'dir'); mkdir(verifyFolder); end
SM.File.OpenFile(fullfile(scriptDir,'MPJ_Sap','MPJ.sdb'));
SM.File.Save('FileName', fullfile(verifyFolder,'MPJ_verify.sdb'));
try; SM.Hide; catch; end

X = [ 1, 37.8, 5.3, 5.6, 0.5, 0.5;    % MJP-C (cost-optimal)
     44, 16.8, 3.0, 3.0, 1.4, 2.0];   % MJP-D (displacement-optimal)
[fit, diagnostic, beamVerify] = Sap_MPJ_VerifyBeam(X, data);

fprintf('\n=== FIT (Cost_P, U_max) ===\n');
fprintf('MJP-C: Cost=%.4f  Disp=%.8f  (ky vong ~5291.86 / ~0.00102)\n', fit(1,1), fit(1,2));
fprintf('MJP-D: Cost=%.4f  Disp=%.8f  (ky vong ~139831.48 / ~0.0000388)\n', fit(2,1), fit(2,2));
fprintf('\n=== BEAM VERIFY [VP_NumberItems VP_N1(pass) VP_N2(fail) VS_NumberItems VS_NumNotAdequate] ===\n');
disp(beamVerify);

try
    SM.ApplicationExit(false);
catch
end

save(fullfile(scriptDir,'verify_beam_result.mat'), 'fit', 'diagnostic', 'beamVerify');
fprintf('\nDA LUU KET QUA VAO verify_beam_result.mat\n');
