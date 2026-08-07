% =========================================================================
% TỆP ĐIỀU KHIỂN TRUNG TÂM: SO SÁNH 3 THUẬT TOÁN (MOPSO - MOWAA - MOFDA)
% =========================================================================
clc; clear; close all;

% --- SỬA: dùng hàm MasterVerbose() thay vì biến VERBOSE_MASTER thường.
% Lý do: mỗi file Main_*.m bắt đầu bằng lệnh "clear", chạy trong base
% workspace (vì gọi bằng run()), nên MỘT BIẾN thường sẽ bị xóa mất ngay
% sau lần run() đầu tiên -> gây lỗi "Unrecognized function or variable
% 'VERBOSE_MASTER'" ở các bước sau. Hàm thì không bị "clear" xóa mất. ---
if MasterVerbose()
    disp('======================================================');
    disp('  HỆ THỐNG TỰ ĐỘNG CHẠY SO SÁNH 3 THUẬT TOÁN');
    disp('======================================================');
end

% --- Không dùng anonymous function handle (Kill_SAP) ---
% Lý do: mỗi file Main_*.m bắt đầu bằng lệnh "clear", chạy trong base
% workspace (vì gọi bằng run()), nên biến Kill_SAP sẽ bị xóa mất sau lần
% run() đầu tiên -> gây lỗi "Undefined function or variable 'Kill_SAP'"
% ở các bước dọn dẹp tiếp theo. Thay vào đó gọi trực tiếp system(...) mỗi lần cần.

% Dọn dẹp trước khi bắt đầu để đảm bảo không có cửa sổ cũ nào đang mở
if MasterVerbose(), disp('>>> Đang kiểm tra và dọn dẹp các cửa sổ SAP2000 cũ...'); end
system('taskkill /F /IM SAP2000.exe /T >nul 2>&1');
pause(2);

% --- SỬA: Main_*_SAP2000.m giờ là HÀM (không phải script), nên gọi trực
% tiếp bằng tên hàm thay vì run('...') như trước. ---

% 1. Chạy MOPSO
if MasterVerbose(), disp('>>> [1/3] BẮT ĐẦU CHẠY MOPSO...'); end
Main_MOPSO_SAP2000();
if MasterVerbose(), disp('>>> Đang dọn dẹp SAP2000 để chuẩn bị cho thuật toán tiếp theo...'); end
system('taskkill /F /IM SAP2000.exe /T >nul 2>&1');
pause(3);

% 2. Chạy MOWAA
if MasterVerbose(), disp('>>> [2/3] BẮT ĐẦU CHẠY MOWAA...'); end
Main_MOWAA_SAP2000();
if MasterVerbose(), disp('>>> Đang dọn dẹp SAP2000 để chuẩn bị cho thuật toán tiếp theo...'); end
system('taskkill /F /IM SAP2000.exe /T >nul 2>&1');
pause(3);

% 3. Chạy MOFDA
if MasterVerbose(), disp('>>> [3/3] BẮT ĐẦU CHẠY MOFDA...'); end
Main_MOFDA_SAP2000();
if MasterVerbose(), disp('>>> Đang dọn dẹp SAP2000 bước cuối...'); end
system('taskkill /F /IM SAP2000.exe /T >nul 2>&1');
pause(2);

% --- Thông báo hoàn tất LUÔN hiện (dù MasterVerbose()=false) vì đây là
% mốc quan trọng duy nhất người dùng cần biết khi chạy ẩn trong nhiều giờ ---
disp('======================================================');
disp('  ĐÃ CHẠY XONG! ĐANG GỌI TỆP VẼ BIỂU ĐỒ TỔNG HỢP...');
disp('======================================================');

%% BƯỚC CUỐI: TÍCH HỢP TỆP VẼ BIỂU ĐỒ
% Lệnh này sẽ tự động tìm và nạp toàn bộ mã từ tệp Plot_Results.m
Plot_Results;
