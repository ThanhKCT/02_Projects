function [SapObject, Smdl] = SapStart(VERBOSE)
% =========================================================================
% KHỞI ĐỘNG SAP2000 VÀ MỞ MÔ HÌNH DÙNG CHUNG (Frame2D.sdb)
% Dùng chung cho MOPSO, MOWAA, MOFDA để đảm bảo cả 3 thuật toán luôn chạy
% trên đúng cùng một mô hình/cấu hình combo, và để tăng tốc (SAP2000 luôn
% khởi động ẩn cửa sổ - Visible=false).
% =========================================================================
    if nargin < 1, VERBOSE = false; end

    if VERBOSE, disp('1. Đang khởi động phần mềm SAP2000 qua COM API...'); end
    SapObject = actxserver('CSI.SAP2000.API.SapObject');
    % Units=4 (kN_m_C) chỉ là đơn vị khởi tạo ban đầu, file .sdb mở sau đó
    % (OpenFile) sẽ dùng đơn vị đã lưu sẵn trong file (đã xác nhận là kN, m).
    SapObject.ApplicationStart(4, false, '');
    Smdl = SapObject.SapModel;

    modelPath = fullfile(pwd, 'SAP_Model', 'Frame2D.sdb');
    if VERBOSE, disp(['=> Đường dẫn mô hình: ', modelPath]); end

    ret = Smdl.File.OpenFile(modelPath);
    if ret ~= 0, error('Lỗi: SAP2000 không thể mở tệp.'); end

    % Chỉ xuất kết quả cho tổ hợp COMB1
    Smdl.Results.Setup.DeselectAllCasesAndCombosForOutput();
    Smdl.Results.Setup.SetComboSelectedForOutput('COMB1', true);
end
