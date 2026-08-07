function SapStop(SapObject, VERBOSE)
% =========================================================================
% ĐÓNG KẾT NỐI VÀ GIẢI PHÓNG BỘ NHỚ SAP2000 AN TOÀN
% Lưu ý: KHÔNG gọi Smdl.File.Save() vì mô hình luôn được mở lại từ đầu ở
% lần chạy sau (không cần lưu), và việc lưu sẽ ghi đè tệp gốc Frame2D.sdb
% bằng tiết diện ngẫu nhiên cuối cùng được thử trong quá trình tối ưu ->
% vừa tốn thời gian I/O thừa, vừa làm bẩn tệp mô hình gốc.
% =========================================================================
    if nargin < 2, VERBOSE = false; end
    try
        SapObject.ApplicationExit();
        delete(SapObject);
        if VERBOSE, disp('=> Đã ngắt kết nối và đóng SAP2000 thành công.'); end
    catch
        disp('=> Cảnh báo: SAP2000 đã được đóng trước đó.');
    end
end
