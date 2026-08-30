function wharf100dwt_fix_comb62()
% =========================================================================
% CHẠY 1 LẦN DUY NHẤT, TRƯỚC KHI CHẠY run_mofda_wharf100dwt.m LẦN ĐẦU.
%
% Sửa COMB6.2 trong Sap/Ben100kDWT_sensitivity.sdb từ (BT+MT+Neo1+HH1 --
% TRÙNG với COMB6.1, lỗi hồ sơ gốc, xem đề cương mục 5.4.1) thành đúng
% (BT+MT+Neo1+HH2) để nhóm Neo1 đối xứng đủ HH1-HH6 như nhóm Neo2.
%
% *** CHƯA ĐƯỢC CHẠY THỬ THẬT (không có phiên MATLAB+SAP2000 sống để kiểm
% chứng trong lúc soạn code này) — kiểm tra lại bằng SAP2000 GUI (Define >
% Load Combinations > COMB6.2) sau khi chạy, trước khi tin tưởng kết quả. ***
% =========================================================================
    scriptDir = fileparts(mfilename('fullpath'));
    addpath(fullfile(scriptDir, 'Functions'));
    cfg = wharf100dwt_config();

    open_Sap2000(cfg, false); % mở CÓ giao diện để dễ kiểm tra trực quan lần đầu

    SM.SetModelIsLocked(false);

    % eCNameType: 0 = LoadCase, 1 = LoadCombo (quy ước OAPI chuẩn CSI)
    LOADCASE = 0;

    % Xoá case HH1 khỏi COMB6.2 (đang trùng COMB6.1), thêm HH2 với ScaleFactor=1
    retDel = SM.RespCombo.DeleteCase('COMB6.2', LOADCASE, 'HH1');
    retAdd = SM.RespCombo.SetCaseList('COMB6.2', LOADCASE, 'HH2', 1);

    if retDel ~= 0 || retAdd ~= 0
        warning('wharf100dwt_fix_comb62:ApiReturnNonZero', ...
            'DeleteCase/SetCaseList tra ve ma khac 0 (retDel=%d, retAdd=%d) - KIEM TRA LAI THU CONG trong SAP2000 GUI truoc khi dung.', retDel, retAdd);
    else
        fprintf('Da sua COMB6.2 -> BT+MT+Neo1+HH2. Kiem tra lai trong SAP2000 GUI (Define > Load Combinations) roi luu file.\n');
    end

    fprintf('Nho luu file (File > Save) trong SAP2000 GUI truoc khi dong, de thay doi duoc ghi vao .sdb.\n');
    % Cố ý KHÔNG tự động SM.File.Save ở đây -- để người dùng tự kiểm tra
    % trực quan đúng rồi mới lưu, tránh ghi đè sai lên .sdb gốc.
end
