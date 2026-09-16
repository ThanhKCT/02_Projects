function [Sobj, Smdl] = open_Sap2000_v2(sdbPath, headless)
% OPEN_SAP2000_V2  Mo SAP2000 (mac dinh an) va mo model tai sdbPath.
%
% Copy nguyen mau da CHAY THAT va KIEM CHUNG on dinh nhieu gio lien tuc o
% du an MOFDA/Wharf100DWT/Functions/open_Sap2000.m (Bai 1) - chi tong quat
% hoa tham so duong dan model (sdbPath) thay vi doc tu 1 cfg co dinh, de
% dung chung duoc cho ca 2 cong trinh A/B cua Bai 2.
%
%   open_Sap2000_v2(cfg.sdb_path)        % mo an (headless mac dinh)
%   open_Sap2000_v2(cfg.sdb_path, false) % mo hien cua so (debug)

if nargin < 2, headless = true; end

SM.App('sap');
SM.Ver('24');
ProgramPath = 'C:\Program Files\Computers and Structures\SAP2000 24\SAP2000.exe';
APIDLLPath  = 'C:\Program Files\Computers and Structures\SAP2000 24\SAP2000v1.dll';
[~] = SM.Helper.CreateObject(ProgramPath, APIDLLPath);
Sobj = [];
if headless
    SM.ApplicationStart('Visible', false);
    SM.Hide;
else
    SM.ApplicationStart;
end
Smdl = SM.SapModel();

ret = SM.File.OpenFile(sdbPath);
if ret ~= 0
    error('open_Sap2000_v2:OpenFailed', 'Khong mo duoc model: %s (ret=%d)', sdbPath, ret);
end
try, SM.Hide; catch, end %#ok<CTCH>

end
