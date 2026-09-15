% DIAGNOSE_B  Script chan doan nhanh: tai sao f2 (chuyen vi) tra ve 0.0000m
% cho x=1 (D300) o lan chay vet can dau tien. KHONG chay lai toan bo
% evaluate_pile_design - chi kiem tra tung buoc trich xuat ket qua truc
% tiep tren model B da mo san.

clear; clc;
addpath(fileparts(mfilename('fullpath')));
cfg = project_config('B');
cat = pile_catalogue_AMACCAO();

system('taskkill /F /IM SAP2000.exe');
pause(2);
open_Sap2000_v2(cfg.sdb_path, true);

fprintf('--- 1) Danh sach ten tiet dien frame (mau 20 dong dau + dem theo section) ---\n');
[~, NumberNames, AllFrameNames] = SM.FrameObj.GetNameList();
AllFrameNames2 = local_diag_tocellstr(AllFrameNames);
fprintf('Tong so frame: %d\n', NumberNames);
secCount = containers.Map('KeyType','char','ValueType','double');
sampleShown = 0;
for i = 1:NumberNames
    [~, secName] = SM.FrameObj.GetSection(AllFrameNames2{i});
    secName = char(secName);
    if isKey(secCount, secName)
        secCount(secName) = secCount(secName) + 1;
    else
        secCount(secName) = 1;
    end
    if sampleShown < 20
        fprintf('  frame %-10s -> section [%s]\n', AllFrameNames2{i}, secName);
        sampleShown = sampleShown + 1;
    end
end
ks = keys(secCount);
fprintf('--- Bang dem so frame theo section (tat ca) ---\n');
for i = 1:numel(ks)
    fprintf('  section [%s] : %d frame\n', ks{i}, secCount(ks{i}));
end
fprintf('cfg.pile_section_name = [%s]\n', cfg.pile_section_name);
if isKey(secCount, cfg.pile_section_name)
    fprintf('=> KHOP: %d frame dung dung section nay.\n', secCount(cfg.pile_section_name));
else
    fprintf('=> KHONG KHOP TEN SECTION! Day rat co the la nguyen nhan loi (0 frame duoc loc ra).\n');
end

fprintf('\n--- 2) Danh sach nut (Joint) va phan bo cao do Z (mau) ---\n');
[~, NumberPoints, AllPointNames] = SM.PointObj.GetNameList();
AllPointNames2 = local_diag_tocellstr(AllPointNames);
fprintf('Tong so nut: %d\n', NumberPoints);
zvals = zeros(NumberPoints,1);
for i = 1:NumberPoints
    [~, ~, ~, z] = SM.PointObj.GetCoordCartesian(AllPointNames2{i});
    zvals(i) = z;
end
fprintf('Z min=%.4f  max=%.4f  (cfg.deck_top_Z=%.4f)\n', min(zvals), max(zvals), cfg.deck_top_Z);
nearTop = abs(zvals - cfg.deck_top_Z) < 1e-3;
fprintf('So nut co |Z-deck_top_Z|<1e-3: %d\n', nnz(nearTop));
% Thu long tolerance neu qua it
if nnz(nearTop) < 1
    for tol = [0.01 0.05 0.1 0.5 1.0]
        n = nnz(abs(zvals - cfg.deck_top_Z) < tol);
        fprintf('  (thu tolerance %.2f -> %d nut)\n', tol, n);
    end
end

fprintf('\n--- 2b) Chay RunAnalysis that (giong dung flow cua evaluate_pile_design.m) ---\n');
row1 = cat(1);
SM.SetModelIsLocked(false);
retPipe = SM.PropFrame.SetPipe(cfg.pile_section_name, cfg.material_name, row1.D_mm/1000, row1.t_mm/1000);
fprintf('SetPipe(x=1, D=%dmm t=%dmm) ret=%d\n', row1.D_mm, row1.t_mm, retPipe);
SM.Analyze.SetRunCaseFlag('', true, true);
tRA = tic;
retRA = SM.Analyze.RunAnalysis();
fprintf('RunAnalysis ret=%d (%.1fs)\n', retRA, toc(tRA));

fprintf('\n--- 3) Trich JointDispl truc tiep cho to hop khong che %s ---\n', cfg.combo_governing_disp);
SM.Results.Setup.DeselectAllCasesAndCombosForOutput();
retSel = SM.Results.Setup.SetComboSelectedForOutput(cfg.combo_governing_disp, true);
fprintf('SetComboSelectedForOutput ret=%d\n', retSel);
[retJ, NumberResults, ObjJ, ~, ~, ~, ~, U1, ~, ~, ~, ~, ~] = SM.Results.JointDispl('ALL', SM.eItemTypeElm.GroupElm);
fprintf('JointDispl ret=%d NumberResults=%d\n', retJ, NumberResults);
if NumberResults > 0
    U1v = double(U1); U1v = U1v(:);
    fprintf('class(U1) truoc convert = %s ; sau double(): numel=%d min=%.6f max=%.6f\n', class(U1), numel(U1v), min(U1v), max(U1v));
    [maxAbsU, iMax] = max(abs(U1v));
    ObjJ2 = local_diag_tocellstr(ObjJ);
    fprintf('max|U1| toan bo model = %.4f mm tai nut %s\n', maxAbsU*1000, ObjJ2{iMax});
else
    fprintf('=> JointDispl KHONG tra ve ket qua nao (NumberResults=0). Model co the CHUA duoc RunAnalysis.\n');
end

fprintf('\n--- 4) Kiem tra FrameForce cho 1 frame coc mau, toan bo combo_list_for_axial ---\n');
SM.Results.Setup.DeselectAllCasesAndCombosForOutput();
for k = 1:numel(cfg.combo_list_for_axial)
    SM.Results.Setup.SetComboSelectedForOutput(cfg.combo_list_for_axial{k}, true);
end
sampleFrame = AllFrameNames2{1}; % frame dau tien, da xac nhan section=Coc o buoc 1
[retFF, nFF, ~, ~, ~, ~, ~, ~, P, ~, ~, M2, M3, ~, ~] = SM.Results.FrameForce(sampleFrame, SM.eItemTypeElm.ObjectElm);
fprintf('FrameForce(%s) ret=%d NumberResults=%d\n', sampleFrame, retFF, nFF);
if nFF > 0
    Pv = double(P); M2v = double(M2); M3v = double(M3);
    fprintf('  P range: [%.3f, %.3f] T ; max|M| approx: %.3f T.m\n', min(Pv), max(Pv), max(sqrt(M2v(:).^2+M3v(:).^2)));
else
    fprintf('  => FrameForce KHONG tra ve ket qua nao.\n');
end

try, SM.ApplicationExit(false); catch, end

function out = local_diag_tocellstr(x)
if iscellstr(x) %#ok<ISCLSTR>
    out = x;
elseif isstring(x) || ischar(x)
    out = cellstr(x);
else
    try
        out = cellstr(x);
    catch
        out = arrayfun(@char, x, 'UniformOutput', false);
    end
end
end
