% =========================================================================
% CHẠY LẶP N LẦN ĐỘC LẬP CHO CẢ 3 THUẬT TOÁN (so sánh có ý nghĩa thống kê)
%
% Lý do cần chạy lặp: mỗi lần chạy 1 thuật toán là NGẪU NHIÊN (khởi tạo
% quần thể/vận động ngẫu nhiên), nên 1 lần chạy đơn lẻ có thể may/rủi.
% Chạy N lần độc lập rồi lấy trung bình +/- độ lệch chuẩn của các chỉ số
% hiệu năng (xem AnalyzeBatchResults.m) mới đủ tin cậy để đưa vào bài báo.
%
% --- SỬA: N = 10 (không phải 30) ---
% Vì mỗi lần đánh giá hàm mục tiêu tốn ~1s (gọi SAP2000 phân tích kết cấu
% thật), 1 lần chạy thuật toán mất ~40-45 phút. N=30 (30x3=90 lần chạy)
% sẽ tốn ~65-70 GIỜ (gần 3 ngày đêm liên tục) - không thực tế. N=10 (30
% lần chạy tổng) tốn ~22 GIỜ (qua đêm là xong) và VẪN LÀ CON SỐ ĐƯỢC CHẤP
% NHẬN PHỔ BIẾN trong các bài báo tối ưu hóa kết cấu ghép mô phỏng FE (SAP2000/
% ETABS...) vì chi phí đánh giá hàm mục tiêu đắt đỏ - khác với các bài báo
% thuật toán thuần túy trên hàm benchmark (chạy mili-giây/lần) thường đòi
% N=20-30. Có thể sửa N bên dưới nếu muốn nhiều/ít lần hơn.
%
% SCRIPT NÀY AN TOÀN ĐỂ DỪNG VÀ CHẠY LẠI: các lần đã chạy xong (file .mat
% đã tồn tại trong BatchResults/) sẽ được BỎ QUA, không chạy lại - giúp
% tiếp tục sau khi tắt máy/mất điện/MATLAB bị crash (đã từng gặp).
% =========================================================================
clc;
N = 10;   % --- SỬA: số lần chạy độc lập mỗi thuật toán ---

resultsDir = 'BatchResults';
if ~isfolder(resultsDir), mkdir(resultsDir); end

algorithms = {
    'MOPSO', @Main_MOPSO_SAP2000
    'MOWAA', @Main_MOWAA_SAP2000
    'MOFDA', @Main_MOFDA_SAP2000
};

totalRuns = N * size(algorithms,1);
runCounter = 0;
ticBatch = tic;

fprintf('Bắt đầu chạy batch: %d thuật toán x %d lần = %d lần chạy tổng.\n', size(algorithms,1), N, totalRuns);
fprintf('Ước tính thời gian: ~%.1f giờ (dựa trên ~45 phút/lần chạy).\n\n', totalRuns * 45 / 60);

for a = 1:size(algorithms,1)
    algName = algorithms{a,1};
    algFunc = algorithms{a,2};

    for r = 1:N
        runCounter = runCounter + 1;
        fileName = fullfile(resultsDir, sprintf('%s_run%02d.mat', algName, r));

        if isfile(fileName)
            fprintf('[%d/%d] %s lần %d: ĐÃ CÓ SẴN, bỏ qua.\n', runCounter, totalRuns, algName, r);
            continue;
        end

        fprintf('[%d/%d] Đang chạy %s lần %d/%d...\n', runCounter, totalRuns, algName, r, N);

        % Dọn dẹp SAP2000 trước mỗi lần chạy (đề phòng tiến trình treo từ lần trước)
        system('taskkill /F /IM SAP2000.exe /T >nul 2>&1');
        pause(2);

        try
            algFunc(fileName);
        catch ME
            fprintf('=> LỖI khi chạy %s lần %d: %s. Bỏ qua, chuyển lần tiếp theo.\n', algName, r, ME.message);
            system('taskkill /F /IM SAP2000.exe /T >nul 2>&1');
        end

        elapsedTotalH = toc(ticBatch) / 3600;
        fprintf('   => Đã xong %d/%d lần (tổng thời gian đã chạy: %.2f giờ)\n\n', runCounter, totalRuns, elapsedTotalH);
    end
end

disp('======================================================');
disp('  ĐÃ CHẠY XONG TOÀN BỘ BATCH! Dùng AnalyzeBatchResults.m để so sánh.');
disp('======================================================');
