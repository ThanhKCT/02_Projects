function [Sobj, Smdl] = open_Sap2000_worker_v2(sdbPath, workerIdx)
% OPEN_SAP2000_WORKER_V2  Mo 1 SAP2000 RIENG cho worker nay (dung trong
% spmd), luu ra 1 file .sdb RIENG trong thu muc con rieng (W01, W02, ...) -
% KHONG bao gio de 2 worker cung mo/ghi 1 file .sdb (kinh nghiem
% Cach ket noi_SAP2000_MATLAB_OPTIMIZATION.md muc 1).
%
% Copy nguyen mau tu MOFDA/Wharf100DWT/Functions/open_Sap2000_worker.m
% (Bai 1, da chay that on dinh), chi tong quat hoa tham so sdbPath.

[Sobj, Smdl] = open_Sap2000_v2(sdbPath, true);

workerFolder = fullfile(fileparts(sdbPath), sprintf('W%02d', workerIdx));
if ~exist(workerFolder, 'dir'), mkdir(workerFolder); end
[~, baseName, ~] = fileparts(sdbPath);
savePath = fullfile(workerFolder, [baseName '.sdb']);
try
    SM.File.Save('FileName', savePath);
    try, SM.Hide; catch, end
catch
    warning('open_Sap2000_worker_v2:SaveFailed', ...
        'Khong luu duoc ban sao .sdb cho worker %d - van tiep tuc voi model dang mo trong bo nho.', workerIdx);
end

end
