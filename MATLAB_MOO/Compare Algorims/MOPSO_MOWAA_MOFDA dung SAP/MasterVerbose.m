function tf = MasterVerbose()
% =========================================================================
% CỜ HIỂN THỊ LOG CÁC BƯỚC ĐIỀU KHIỂN CHÍNH (Master_Controller.m)
% Dùng HÀM thay vì biến thường: mỗi file Main_*.m luôn bắt đầu bằng lệnh
% "clear" và chạy trong base workspace (vì gọi bằng run()), nên một biến
% VERBOSE_MASTER thường sẽ bị xóa mất ngay sau lần run() đầu tiên, gây lỗi
% "Unrecognized function or variable 'VERBOSE_MASTER'" ở các bước sau.
% Hàm không bị ảnh hưởng bởi "clear" nên luôn giữ đúng giá trị.
% =========================================================================
    tf = false;  % --- SỬA: đặt true nếu muốn xem log các bước điều khiển chính
end
