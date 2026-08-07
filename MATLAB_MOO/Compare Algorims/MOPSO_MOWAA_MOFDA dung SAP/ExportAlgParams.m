% =========================================================================
% XUẤT BẢNG THAM SỐ CỦA 3 THUẬT TOÁN (MOPSO - MOWAA - MOFDA)
% Mục đích: liệt kê tường minh các tham số đang dùng để so sánh (dùng cho
% phần "Parameter settings" của bài báo), và tính lại NFE (số lần gọi
% SAP2000) thực tế của mỗi thuật toán để xác nhận đã cân bằng ngân sách
% tính toán trước khi so sánh hiệu năng.
% =========================================================================
clc;

[nVar, VarMin, VarMax] = ProblemDefinition();
[PopSize, ArchiveSize, MaxNFE] = CommonAlgParams();

% --- MOPSO ---
MOPSO_nPop    = PopSize;
MOPSO_MaxIt   = round(MaxNFE / MOPSO_nPop) - 1;
MOPSO_Archive = ArchiveSize;
MOPSO_w = 0.4; MOPSO_c1 = 1.5; MOPSO_c2 = 1.5;
MOPSO_NFE = MOPSO_nPop * (MOPSO_MaxIt + 1);

% --- MOWAA ---
MOWAA_nPop    = PopSize;
MOWAA_MaxIt   = round(MaxNFE / MOWAA_nPop) - 1;
MOWAA_Archive = ArchiveSize;
MOWAA_alpha = 0.1; MOWAA_nGrid = 10; MOWAA_beta = 4; MOWAA_gamma1 = 2;
MOWAA_NFE = MOWAA_nPop * (MOWAA_MaxIt + 1);

% --- MOFDA ---
MOFDA_beta_dim   = 4;
MOFDA_MaxIt      = 50;
MOFDA_nPop       = round(MaxNFE / (1 + MOFDA_MaxIt * (MOFDA_beta_dim + 1)));
MOFDA_Archive    = ArchiveSize;
MOFDA_Alpha_Grid = 0.1; MOFDA_nGrid = 10; MOFDA_Beta_Leader = 4; MOFDA_gamma_del = 2;
MOFDA_NFE = MOFDA_nPop * (1 + MOFDA_MaxIt * (MOFDA_beta_dim + 1));

disp('=== KHÔNG GIAN BIẾN THIẾT KẾ (chung cho cả 3 thuật toán) ===');
fprintf('  Số biến thiết kế (nVar) = %d\n', nVar);
disp('  Cận dưới (VarMin):'); disp(VarMin);
disp('  Cận trên (VarMax):'); disp(VarMax);
disp(' ');

Name           = {'MOPSO'; 'MOWAA'; 'MOFDA'};
PopulationSize = [MOPSO_nPop; MOWAA_nPop; MOFDA_nPop];
Iterations     = [MOPSO_MaxIt; MOWAA_MaxIt; MOFDA_MaxIt];
ArchiveCap     = [MOPSO_Archive; MOWAA_Archive; MOFDA_Archive];
NFE            = [MOPSO_NFE; MOWAA_NFE; MOFDA_NFE];
HyperparamStr  = {
    sprintf('w=%.2f, c1=%.2f, c2=%.2f', MOPSO_w, MOPSO_c1, MOPSO_c2)
    sprintf('alpha=%.2f, nGrid=%d, beta=%d, gamma1=%d', MOWAA_alpha, MOWAA_nGrid, MOWAA_beta, MOWAA_gamma1)
    sprintf('beta_dim=%d, Alpha_Grid=%.2f, nGrid=%d, Beta_Leader=%d, gamma_del=%d', MOFDA_beta_dim, MOFDA_Alpha_Grid, MOFDA_nGrid, MOFDA_Beta_Leader, MOFDA_gamma_del)
};

T = table(Name, PopulationSize, Iterations, ArchiveCap, NFE, HyperparamStr);

disp('=== BẢNG THAM SỐ 3 THUẬT TOÁN (đã cân bằng NFE) ===');
disp(T);

writetable(T, 'ThamSo_3ThuatToan.csv');
disp('=> Đã xuất bảng tham số ra ThamSo_3ThuatToan.csv');

if numel(unique(NFE)) > 1 && (max(NFE) - min(NFE)) / min(NFE) > 0.05
    warning('NFE giữa các thuật toán lệch nhau > 5%% - kiểm tra lại tham số trước khi so sánh.');
else
    fprintf('\n=> Đã xác nhận NFE cân bằng giữa 3 thuật toán (chênh lệch <= 5%%).\n');
end
