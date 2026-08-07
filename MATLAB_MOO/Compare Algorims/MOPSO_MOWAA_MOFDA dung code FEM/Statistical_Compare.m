% =========================================================================
% KỊCH BẢN CHẠY THỐNG KÊ 10 LẦN SO SÁNH THỜI GIAN: MOPSO - MOWAA - MOFDA
%
% CÔNG BẰNG: dùng CÙNG ngân sách NFE (số lần gọi hàm mục tiêu) cho cả 3
% thuật toán (hiệu chỉnh MaxIt qua CalibrateMaxIt), giống hệt cách làm
% trong Compare_MOPSO_MOWAA_MOFDA.m.
% =========================================================================

clc;

RootDir = fileparts(mfilename('fullpath'));

rng('default'); % Ai chạy kịch bản này cũng ra kết quả có thể tái lập

nPop = 100; nRep = 100;
NFE_Target = 30000;
MaxIt_Calib = [3 8];

disp('====================================================');
disp('HIỆU CHỈNH MaxIt THEO NGÂN SÁCH NFE DÙNG CHUNG...');
disp('====================================================');
addpath(fullfile(RootDir,'MOPSO'));
MaxIt_mopso = CalibrateMaxIt(@(it) MOPSO_Steel(it, nPop, nRep), MaxIt_Calib, NFE_Target);
rmpath(fullfile(RootDir,'MOPSO'));

addpath(fullfile(RootDir,'MOWAA'));
MaxIt_mowaa = CalibrateMaxIt(@(it) MOWAA_Steel(it, nRep, nPop), MaxIt_Calib, NFE_Target);
rmpath(fullfile(RootDir,'MOWAA'));

addpath(fullfile(RootDir,'MOFDA'));
MaxIt_mofda = CalibrateMaxIt(@(it) MOFDA_Steel(it, nRep, nPop), MaxIt_Calib, NFE_Target);
rmpath(fullfile(RootDir,'MOFDA'));

fprintf('>> Ngân sách NFE dùng chung: %d | MaxIt - MOPSO: %d, MOWAA: %d, MOFDA: %d\n\n', ...
    NFE_Target, MaxIt_mopso, MaxIt_mowaa, MaxIt_mofda);

nRuns = 10; % Số lần chạy độc lập (đã cân bằng NFE nên 10 lần đủ ổn định cho bài toán kỹ thuật cụ thể này)

time_mopso = zeros(1, nRuns);
time_mowaa = zeros(1, nRuns);
time_mofda = zeros(1, nRuns);

disp('====================================================');
fprintf('BẮT ĐẦU CHẠY THỐNG KÊ %d LẦN (mỗi thuật toán cùng ngân sách NFE)...\n', nRuns);
disp('Vui lòng kiên nhẫn, quá trình này có thể mất vài chục phút.');
disp('====================================================');

for run = 1:nRuns
    fprintf('>> Đang xử lý lần chạy thứ %d / %d...\n', run, nRuns);

    addpath(fullfile(RootDir,'MOPSO'));
    tic;
    rep = MOPSO_Steel(MaxIt_mopso, nPop, nRep); %#ok<NASGU>
    time_mopso(run) = toc;
    rmpath(fullfile(RootDir,'MOPSO'));
    clear rep;

    addpath(fullfile(RootDir,'MOWAA'));
    tic;
    archive_mowaa = MOWAA_Steel(MaxIt_mowaa, nRep, nPop); %#ok<NASGU>
    time_mowaa(run) = toc;
    rmpath(fullfile(RootDir,'MOWAA'));
    clear archive_mowaa;

    addpath(fullfile(RootDir,'MOFDA'));
    tic;
    archive_mofda = MOFDA_Steel(MaxIt_mofda, nRep, nPop); %#ok<NASGU>
    time_mofda(run) = toc;
    rmpath(fullfile(RootDir,'MOFDA'));
    clear archive_mofda;
end

%% =========================================================================
% TÍNH TOÁN THỐNG KÊ VÀ IN KẾT QUẢ
% =========================================================================
mean_mopso = mean(time_mopso); std_mopso = std(time_mopso);
mean_mowaa = mean(time_mowaa); std_mowaa = std(time_mowaa);
mean_mofda = mean(time_mofda); std_mofda = std(time_mofda);

disp(' ');
disp('================================================================');
disp('          BẢNG TỔNG HỢP THỐNG KÊ THỜI GIAN (SAU 10 LẦN CHẠY)    ');
disp('          (Cùng ngân sách NFE cho cả 3 thuật toán)              ');
disp('================================================================');
fprintf('Thuật toán | MaxIt | Thời gian TB (s) | Độ lệch chuẩn (s) | Nhanh nhất (s) | Chậm nhất (s)\n');
disp('----------------------------------------------------------------');
fprintf('MOPSO      | %5d | %16.2f | %17.2f | %14.2f | %13.2f\n', MaxIt_mopso, mean_mopso, std_mopso, min(time_mopso), max(time_mopso));
fprintf('MOWAA      | %5d | %16.2f | %17.2f | %14.2f | %13.2f\n', MaxIt_mowaa, mean_mowaa, std_mowaa, min(time_mowaa), max(time_mowaa));
fprintf('MOFDA      | %5d | %16.2f | %17.2f | %14.2f | %13.2f\n', MaxIt_mofda, mean_mofda, std_mofda, min(time_mofda), max(time_mofda));
disp('================================================================');
disp('Lưu ý: Độ lệch chuẩn càng nhỏ chứng tỏ thuật toán chạy càng ổn định!');
disp('Lưu ý: MaxIt khác nhau vì đã cân bằng theo NFE - xem NFE_Target ở trên.');

%% =========================================================================
% XUẤT KẾT QUẢ THỐNG KÊ SANG FILE EXCEL
% =========================================================================
Algorithms = {'MOPSO'; 'MOWAA'; 'MOFDA'};
MaxIt_Used = [MaxIt_mopso; MaxIt_mowaa; MaxIt_mofda];
Mean_Time  = [mean_mopso; mean_mowaa; mean_mofda];
Std_Time   = [std_mopso; std_mowaa; std_mofda];
Min_Time   = [min(time_mopso); min(time_mowaa); min(time_mofda)];
Max_Time   = [max(time_mopso); max(time_mowaa); max(time_mofda)];

T = table(Algorithms, MaxIt_Used, Mean_Time, Std_Time, Min_Time, Max_Time, ...
    'VariableNames', {'ThuatToan', 'MaxIt_CanBang_NFE', 'TrungBinh_s', 'DoLechChuan_s', 'NhanhNhat_s', 'ChamNhat_s'});

filename = fullfile(RootDir, 'KetQuaThongKe_ThuatToan.xlsx');
if exist(filename, 'file') == 2
    try delete(filename); catch, disp('LỖI: Hãy đóng file Excel cũ trước khi chạy lại!'); return; end
end
writetable(T, filename);

disp(' ');
disp(['>> Đã xuất kết quả thành công sang file: ', filename]);


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
