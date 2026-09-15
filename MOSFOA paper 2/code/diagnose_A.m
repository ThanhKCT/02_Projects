% DIAGNOSE_A  Chan doan f2=0.0000m cho cong trinh A (x=1 vet can). Nghi ngo
% chinh: cfg.combo_governing_disp = '"BAO KT"' co dau ngoac kep NHUNG VAO
% CHUOI - neu ten combo THAT trong SAP2000 KHONG co dau ngoac kep (dau
% ngoac chi la ky tu bao chuoi trong file .s2k luc truoc trich xuat, khong
% phai 1 phan ten that), SetComboSelectedForOutput se khong khop duoc ten
% nao ca -> JointDispl tra ve 0 ket qua -> U_max luon = 0 (loi cung dang
% voi B, nhung nguyen nhan gia thuyet khac).

clear; clc;
addpath(fileparts(mfilename('fullpath')));
cfg = project_config('A');
cat = pile_catalogue_AMACCAO();

system('taskkill /F /IM SAP2000.exe');
pause(2);
open_Sap2000_v2(cfg.sdb_path, true);

fprintf('--- 0) Danh sach TEN COMBO THAT dang ky trong SAP2000 (RespCombo) ---\n');
[~, NumberCombos, AllComboNames] = SM.RespCombo.GetNameList();
AllComboNames2 = local_diag_tocellstr(AllComboNames);
fprintf('Tong so combo: %d\n', NumberCombos);
for i = 1:NumberCombos
    fprintf('  combo %2d: [%s]\n', i, AllComboNames2{i});
end
fprintf('\ncfg.combo_governing_disp = [%s]\n', cfg.combo_governing_disp);
if any(strcmp(AllComboNames2, cfg.combo_governing_disp))
    fprintf('=> KHOP CHINH XAC voi 1 combo that.\n');
else
    fprintf('=> KHONG KHOP CHINH XAC! Kiem tra ten gan giong (bo dau ngoac/khoang trang):\n');
    target = strrep(strrep(cfg.combo_governing_disp, '"', ''), ' ', '');
    for i = 1:NumberCombos
        cand = strrep(strrep(AllComboNames2{i}, '"', ''), ' ', '');
        if strcmpi(cand, target)
            fprintf('   -> UNG VIEN KHOP (sau khi bo dau ngoac/khoang trang): combo that = [%s]\n', AllComboNames2{i});
        end
    end
end

fprintf('\n--- 1) Dem frame theo section, doi chieu cfg.pile_section_name=[%s] ---\n', cfg.pile_section_name);
[~, NumberNames, AllFrameNames] = SM.FrameObj.GetNameList();
AllFrameNames2 = local_diag_tocellstr(AllFrameNames);
secCount = containers.Map('KeyType','char','ValueType','double');
for i = 1:NumberNames
    [~, secName] = SM.FrameObj.GetSection(AllFrameNames2{i});
    secName = char(secName);
    if isKey(secCount, secName), secCount(secName) = secCount(secName)+1; else, secCount(secName) = 1; end
end
ks = keys(secCount);
for i = 1:numel(ks)
    fprintf('  section [%s] : %d frame\n', ks{i}, secCount(ks{i}));
end
if isKey(secCount, cfg.pile_section_name)
    fprintf('=> KHOP: %d frame.\n', secCount(cfg.pile_section_name));
else
    fprintf('=> KHONG KHOP TEN SECTION!\n');
end

fprintf('\n--- 2) Phan bo cao do Z, doi chieu cfg.deck_top_Z=%.4f ---\n', cfg.deck_top_Z);
[~, NumberPoints, AllPointNames] = SM.PointObj.GetNameList();
AllPointNames2 = local_diag_tocellstr(AllPointNames);
zvals = zeros(NumberPoints,1);
for i = 1:NumberPoints
    [~, ~, ~, z] = SM.PointObj.GetCoordCartesian(AllPointNames2{i});
    zvals(i) = z;
end
fprintf('Z min=%.4f max=%.4f ; So nut |Z-deck_top_Z|<1e-3: %d\n', min(zvals), max(zvals), nnz(abs(zvals-cfg.deck_top_Z)<1e-3));

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
