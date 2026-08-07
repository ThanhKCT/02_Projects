function [PopSize, ArchiveSize, MaxNFE] = CommonAlgParams()
% =========================================================================
% THAM SỐ CHUNG CHO CẢ 3 THUẬT TOÁN (MOPSO - MOWAA - MOFDA)
% Mục đích: đảm bảo SO SÁNH CÔNG BẰNG, không thiên vị thuật toán nào.
%
% Nguyên tắc: chi phí tính toán thực sự của bài toán này là SỐ LẦN GỌI
% SAP2000 (NFE - Number of Function Evaluations), vì mỗi lần là 1 lượt
% phân tích kết cấu. Population size được giữ BẰNG NHAU (=50) để chất
% lượng/độ đa dạng của mặt trận Pareto tương đương nhau, còn số vòng lặp
% (MaxIt/max_iter) của từng thuật toán được TÍNH RA từ MaxNFE này (xem
% CommonAlgParams đang dùng ở Main_MOPSO/MOWAA/MOFDA_SAP2000.m) chứ không
% khai báo cứng riêng lẻ -> tránh vô tình cấp ngân sách khác nhau.
%
% --- SỬA: ArchiveSize tăng 50 -> 100 để mặt trận Pareto DÀY/MƯỢT hơn khi
% vẽ hình cho bài báo. Đây là thay đổi KHÔNG TỐN THÊM NFE (không tốn thêm
% 1 lần gọi SAP2000 nào) - chỉ là giữ lại nhiều nghiệm không bị trội hơn
% từ chính dữ liệu đã tính, nên không ảnh hưởng thời gian chạy. Áp dụng
% như nhau cho cả 3 thuật toán nên vẫn đảm bảo công bằng. ---
% =========================================================================
    PopSize = 50;
    ArchiveSize = 100;

    MaxIt_reference = 50;                      % Số vòng lặp tham chiếu (MOPSO/MOWAA: 1 NFE/cá thể/vòng)
    MaxNFE = PopSize * (MaxIt_reference + 1);  % Ngân sách NFE chung = 2550
end
