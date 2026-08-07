function [nVar, VarMin, VarMax] = ProblemDefinition()
% =========================================================================
% ĐỊNH NGHĨA BÀI TOÁN TỐI ƯU (DÙNG CHUNG CHO CẢ 3 THUẬT TOÁN)
% Mục đích: đảm bảo MOPSO, MOWAA, MOFDA luôn tối ưu trên đúng cùng một
% không gian biến thiết kế -> so sánh hiệu suất công bằng, tránh lệch dữ
% liệu do sửa 1 file mà quên đồng bộ 2 file còn lại.
% =========================================================================
    nVar = 8;
    VarMin = [ 0.2, 0.1, 0.006, 0.005, 0.2, 0.1, 0.006, 0.005 ];
    VarMax = [ 0.8, 0.4, 0.030, 0.020, 0.8, 0.4, 0.030, 0.020 ];
end
