function [Sobj, Smdl] = open_Sap2000_worker(cfg, workerIdx)
% =========================================================================
% Mở 1 SAP2000 RIÊNG cho worker này (dùng trong spmd), lưu ra 1 file .sdb
% RIÊNG trong thư mục con riêng — KHÔNG bao giờ để 2 worker cùng mở/ghi 1
% file .sdb (kinh nghiệm Cach ket noi_SAP2000_MATLAB_OPTIMIZATION.md mục 1).
% Tách thành file riêng (không phải local function) để đảm bảo mỗi worker
% trong spmd/parpool giải quyết được tên hàm này một cách tường minh —
% theo đúng cấu trúc đã chạy thật ở BMOSFOA_MPJ_v1.m.
% =========================================================================
    [Sobj, Smdl] = open_Sap2000(cfg, true);

    workerFolder = fullfile(fileparts(cfg.sap.modelPath), sprintf('W%02d', workerIdx));
    if ~exist(workerFolder, 'dir'), mkdir(workerFolder); end
    [~, baseName, ~] = fileparts(cfg.sap.modelPath);
    savePath = fullfile(workerFolder, [baseName '.sdb']);
    try
        SM.File.Save('FileName', savePath); % cu phap dung theo dung mau BMOSFOA_MPJ_v1.m
        try, SM.Hide; catch, end
    catch
        % Neu Save loi (vd quyen ghi thu muc), van tiep tuc dung ban dang
        % mo trong bo nho -- khong anh huong ket qua tinh toan, chi anh
        % huong viec co ban sao .sdb rieng de kiem tra sau.
        warning('open_Sap2000_worker:SaveFailed', 'Khong luu duoc ban sao .sdb cho worker %d -- van tiep tuc voi model dang mo trong bo nho.', workerIdx);
    end
end
