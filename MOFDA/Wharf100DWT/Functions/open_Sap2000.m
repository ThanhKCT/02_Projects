function [Sobj, Smdl] = open_Sap2000(cfg, headless)
% =========================================================================
% MỞ SAP2000 (headless theo mặc định) VÀ MỞ MÔ HÌNH Wharf100DWT
% Mẫu theo kinh nghiệm dự án SFOA/MPJ đã chạy thật trên máy này -- xem
% Cach ket noi_SAP2000_MATLAB_OPTIMIZATION.md và
% Tap chi XD_SFOA/code/Run_MOMSFOA_official/MOSFOA_MPJ/Functions/open_Sap2000.m
%
% headless = true (mặc định): SM.ApplicationStart('Visible', false) + SM.Hide
% headless = false: mở có giao diện (chỉ dùng khi cần xem trực quan/debug)
% =========================================================================
    if nargin < 2, headless = true; end

    SM.App('sap');
    SM.Ver('24');
    [~]   = SM.Helper.CreateObject(cfg.sap.programPath, cfg.sap.apiDllPath);
    Sobj  = [];             % SM giữ nội bộ handle ứng dụng, không cần trả ra ngoài
    if headless
        SM.ApplicationStart('Visible', false);
        SM.Hide;
    else
        SM.ApplicationStart;
    end
    Smdl = SM.SapModel();

    ret = SM.File.OpenFile(cfg.sap.modelPath);
    if ret ~= 0
        error('open_Sap2000:OpenFailed', 'Không mở được model: %s', cfg.sap.modelPath);
    end
    try, SM.Hide; catch, end %#ok<CTCH>

    % Chỉ xuất kết quả cho tổ hợp Envelope "BAO KT" (đã chốt, xem cfg)
    SM.Results.Setup.DeselectAllCasesAndCombosForOutput();
    SM.Results.Setup.SetComboSelectedForOutput(cfg.sap.comboEnvelope);
end
