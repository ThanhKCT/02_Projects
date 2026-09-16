% DIAGNOSE_AREAFORCESHELL  Xac dinh CHINH XAC so luong output cua
% SM.Results.AreaForceShell tren may nay (co mau thuan giua 2 nguon kinh
% nghiem: "Kinh nghiem MOSFOA Paper 2.md" gia dinh ~21+ret, "Kinh nghiem
% SFOA.md" muc 1.3 lai ghi "AreaForceShell co dung 25 output" - phai kiem
% tra LIVE, khong doan).
scriptDir = fileparts(mfilename('fullpath'));
addpath(scriptDir);
cfg = project_config_bai6();
[~, ~] = open_Sap2000_v2(cfg.sdb_path, true);

[~, nArea, AllAreaNames] = SM.AreaObj.GetNameList();
AllAreaNames = cellstr(AllAreaNames);
bmcName = '';
for i = 1:nArea
    [~, secName] = SM.AreaObj.GetProperty(AllAreaNames{i});
    if strcmpi(secName, cfg.sec.BMC_name)
        bmcName = AllAreaNames{i};
        break;
    end
end
fprintf('Dung phan tu BMC mau: %s\n', bmcName);

SM.Results.Setup.DeselectAllCasesAndCombosForOutput();
SM.Results.Setup.SetComboSelectedForOutput(cfg.combo_ULSB, true);

for N = 30:-1:15
    try
        outc = cell(1,N);
        [outc{1:N}] = SM.Results.AreaForceShell(bmcName, SM.eItemTypeElm.ObjectElm);
        fprintf('N=%d THANH CONG (khong loi "too many output arguments")\n', N);
        % In tung phan tu cua lan goi THANH CONG DAU TIEN (N lon nhat hoat
        % dong) de doi chieu ten field bang tay.
        for k = 1:N
            v = outc{k};
            if isnumeric(v) && numel(v) <= 5
                fprintf('  out{%d} = %s\n', k, mat2str(v));
            elseif isnumeric(v)
                fprintf('  out{%d} = [%dx%d numeric], first=%s\n', k, size(v,1), size(v,2), mat2str(v(1)));
            else
                fprintf('  out{%d} = (class %s)\n', k, class(v));
            end
        end
        break;
    catch ME
        fprintf('N=%d LOI: %s\n', N, ME.message);
    end
end

try, SM.ApplicationExit(); catch, end
