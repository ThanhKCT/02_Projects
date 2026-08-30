function [g_geotech, geotechChecked] = wharf100dwt_geotech_capacity_stub(D, t, maxAbsAxialForce, cfg) %#ok<INUSD>
% =========================================================================
% STUB -- Ràng buộc sức chịu tải địa kỹ thuật của cọc (TCVN 10304:2025).
%
% ĐÃ CHỐT đưa ràng buộc này vào bài toán ngay từ đầu (xem đề cương mục
% 6.3), nhưng CHƯA CÓ dữ liệu địa chất đủ để tính (chỉ 5/12 lớp đất đã đối
% chiếu chắc chắn -- mục 14 FEM_PhanDoan_TieuChuan_100000DWT.md -- và
% thiếu chỉ số sệt IL từng lớp cần cho phương pháp TCVN 10304).
%
% Có sẵn MODULE TÁI SỬ DỤNG ĐƯỢC từ dự án MPJ (đã chạy thật, cùng phương
% pháp TCVN 10304):
%   D:\ResearchLab\02_Projects\02_Projects\Tap chi XD_SFOA\code\
%     Run_MOMSFOA_official\MOSFOA_MPJ\Pile_TCVN10304_2014\pile_bearing_capacity.m
%   (+ get_k_from_IL.m, Table_Fi_friction.mat, Table_Fi_tip.mat...)
%
% VIỆC CẦN LÀM để thay stub này bằng ràng buộc thật:
%   1. Lấy "Bảng 1: Bảng tổng hợp chỉ tiêu cơ lý các lớp đất" đầy đủ (12
%      lớp) từ thuyết minh gốc (Thuyet minh 06.12.doc).
%   2. Suy ra/đối chiếu chỉ số sệt IL từng lớp (không có sẵn trong dữ liệu
%      đã trích - mục 8 FEM_PhanDoan...md chỉ có gamma, delta, e, C, phi).
%   3. Gọi pile_bearing_capacity.m (hoặc viết lại tương đương) với đúng bộ
%      lớp đất của Cầu tàu Lạch Huyện thay vì bộ lớp đất mẫu của dự án MPJ.
%
% HIỆN TẠI: trả về KHÔNG VI PHẠM (g=0) và cờ geotechChecked=false để mọi
% nơi dùng kết quả (diagnostic, bài báo) biết ràng buộc này CHƯA thực sự
% được kiểm tra -- KHÔNG được báo cáo "đã ràng buộc đủ theo TCVN 10304"
% trong bài cho đến khi geotechChecked=true.
% =========================================================================
    g_geotech = 0;
    geotechChecked = false;
end
