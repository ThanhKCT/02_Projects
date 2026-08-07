% =========================================================================
% KỊCH BẢN CHẠY THỐNG KÊ 30 LẦN SO SÁNH THỜI GIAN: MOPSO - NSGA-II - PESA-II
%
% CÔNG BẰNG: dùng CÙNG ngân sách NFE (số lần gọi hàm mục tiêu) cho cả 3
% thuật toán (hiệu chỉnh MaxIt qua CalibrateMaxIt), giống hệt cách làm
% trong Compare_Algorithms.m - nếu không, so sánh thời gian ở cùng MaxIt
% sẽ thiên vị thuật toán nào tốn ít lần gọi hàm/vòng lặp hơn.
% =========================================================================

clc;

% Đặt hạt giống ngẫu nhiên mặc định ở đầu để ai chạy kịch bản này cũng ra kết quả y hệt
rng('default');

nPop = 100; nRep = 100;
NFE_Target = 30000;
MaxIt_Calib = [3 8];

disp('====================================================');
disp('HIỆU CHỈNH MaxIt THEO NGÂN SÁCH NFE DÙNG CHUNG...');
disp('====================================================');
MaxIt_mopso = CalibrateMaxIt(@(it) mopso(it, nPop, nRep), MaxIt_Calib, NFE_Target);
MaxIt_nsga2 = CalibrateMaxIt(@(it) nsga2(it, nPop), MaxIt_Calib, NFE_Target);
MaxIt_pesa2 = CalibrateMaxIt(@(it) pesa2(it, nPop, nRep), MaxIt_Calib, NFE_Target);
fprintf('>> Ngân sách NFE dùng chung: %d | MaxIt - MOPSO: %d, NSGA-II: %d, PESA-II: %d\n\n', ...
    NFE_Target, MaxIt_mopso, MaxIt_nsga2, MaxIt_pesa2);

nRuns = 10; % Số lần chạy độc lập (đã cân bằng NFE nên 10 lần đủ ổn định cho bài toán kỹ thuật cụ thể này)

% Khởi tạo mảng trống để lưu thời gian của 30 lần chạy
time_mopso = zeros(1, nRuns);
time_nsga2 = zeros(1, nRuns);
time_pesa2 = zeros(1, nRuns);

disp('====================================================');
fprintf('BẮT ĐẦU CHẠY THỐNG KÊ %d LẦN (mỗi thuật toán cùng ngân sách NFE)...\n', nRuns);
disp('Vui lòng kiên nhẫn, quá trình này có thể mất vài phút.');
disp('====================================================');

% Vòng lặp chạy 30 lần
for run = 1:nRuns
    fprintf('>> Đang xử lý lần chạy thứ %d / %d...\n', run, nRuns);

    % --- 1. CHẠY MOPSO ---
    tic;
    rep = mopso(MaxIt_mopso, nPop, nRep); %#ok<NASGU>
    time_mopso(run) = toc;
    clear rep;

    % --- 2. CHẠY NSGA-II ---
    tic;
    F1 = nsga2(MaxIt_nsga2, nPop); %#ok<NASGU>
    time_nsga2(run) = toc;
    clear F1;

    % --- 3. CHẠY PESA-II ---
    tic;
    archive = pesa2(MaxIt_pesa2, nPop, nRep); %#ok<NASGU>
    time_pesa2(run) = toc;
    clear archive;
end

%% =========================================================================
% TÍNH TOÁN THỐNG KÊ VÀ IN KẾT QUẢ
% =========================================================================
mean_mopso = mean(time_mopso); std_mopso = std(time_mopso);
mean_nsga2 = mean(time_nsga2); std_nsga2 = std(time_nsga2);
mean_pesa2 = mean(time_pesa2); std_pesa2 = std(time_pesa2);

disp(' ');
disp('================================================================');
fprintf('          BẢNG TỔNG HỢP THỐNG KÊ THỜI GIAN (SAU %d LẦN CHẠY)    \n', nRuns);
disp('          (Cùng ngân sách NFE cho cả 3 thuật toán)              ');
disp('================================================================');
fprintf('Thuật toán | MaxIt | Thời gian TB (s) | Độ lệch chuẩn (s) | Nhanh nhất (s) | Chậm nhất (s)\n');
disp('----------------------------------------------------------------');
fprintf('MOPSO      | %5d | %16.2f | %17.2f | %14.2f | %13.2f\n', MaxIt_mopso, mean_mopso, std_mopso, min(time_mopso), max(time_mopso));
fprintf('NSGA-II    | %5d | %16.2f | %17.2f | %14.2f | %13.2f\n', MaxIt_nsga2, mean_nsga2, std_nsga2, min(time_nsga2), max(time_nsga2));
fprintf('PESA-II    | %5d | %16.2f | %17.2f | %14.2f | %13.2f\n', MaxIt_pesa2, mean_pesa2, std_pesa2, min(time_pesa2), max(time_pesa2));
disp('================================================================');
disp('Lưu ý: Độ lệch chuẩn càng nhỏ chứng tỏ thuật toán chạy càng ổn định!');
disp('Lưu ý: MaxIt khác nhau vì đã cân bằng theo NFE - xem NFE_Target ở trên.');

%% =========================================================================
% XUẤT KẾT QUẢ THỐNG KÊ SANG FILE EXCEL
% =========================================================================
Algorithms = {'MOPSO'; 'NSGA-II'; 'PESA-II'};
MaxIt_Used = [MaxIt_mopso; MaxIt_nsga2; MaxIt_pesa2];
Mean_Time  = [mean_mopso; mean_nsga2; mean_pesa2];
Std_Time   = [std_mopso; std_nsga2; std_pesa2];
Min_Time   = [min(time_mopso); min(time_nsga2); min(time_pesa2)];
Max_Time   = [max(time_mopso); max(time_nsga2); max(time_pesa2)];

T = table(Algorithms, MaxIt_Used, Mean_Time, Std_Time, Min_Time, Max_Time, ...
    'VariableNames', {'ThuatToan', 'MaxIt_CanBang_NFE', 'TrungBinh_s', 'DoLechChuan_s', 'NhanhNhat_s', 'ChamNhat_s'});

filename = 'KetQuaThongKe_ThuatToan.xlsx';
if exist(filename, 'file') == 2
    try delete(filename); catch, disp('LỖI: Hãy đóng file Excel cũ trước khi chạy lại!'); return; end
end
writetable(T, filename);

disp(' ');
disp(['>> Đã xuất kết quả thành công sang file: ', filename]);
disp('>> Bạn có thể tìm thấy file này trong thư mục hiện tại của MATLAB.');


%% ========================= HÀM PHỤ TRỢ =============================
function MaxIt = CalibrateMaxIt(algoFn, MaxIt_Calib, NFE_Target)
    HamMucTieuToiUu('reset');
    algoFn(MaxIt_Calib(1));
    nfe1 = HamMucTieuToiUu();

    HamMucTieuToiUu('reset');
    algoFn(MaxIt_Calib(2));
    nfe2 = HamMucTieuToiUu();

    slope = (nfe2 - nfe1) / (MaxIt_Calib(2) - MaxIt_Calib(1));
    intercept = nfe1 - slope*MaxIt_Calib(1);

    MaxIt = round((NFE_Target - intercept) / slope);
    MaxIt = max(MaxIt, 5);
end
