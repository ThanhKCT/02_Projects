function [coordinates_z1,coordinates_z2,coordinates_z3,coordinates_z4,N,M,l_1,k_1] = createControlPoints2(L_ben, B_ben, l, k, Z_1, Z_2, Z_3,Z_4)
    % Hàm này tạo lưới các điểm khống chế trên bến với chiều cao Z nhập từ người dùng
    % Input:
    % L_ben: Chiều dài bến theo trục X (m)
    % B_ben: Chiều dài bến theo trục Y (m)
    % l: Chiều dài một nhịp theo trục X (m)
    % k: Chiều dài một nhịp theo trục Y (m)
    % Z_value: Chiều cao Z cho tất cả các điểm

    % Tính số nhịp N và M từ công thức L_ben và B_ben sao cho không vượt quá tổng chiều dài
    N = floor((L_ben) / l);  % Số nhịp theo trục X
    M = floor((B_ben) / k);  % Số nhịp theo trục Y

    % Tính chiều dài đoạn thừa l_1 và k_1
    l_1 = (L_ben - N * l) / 2;  % Đoạn tự do theo trục X
    k_1 = (B_ben - M * k) / 2;  % Đoạn tự do theo trục Y

    % Điều chỉnh tọa độ X và Y sao cho hệ tọa độ Oxy nằm giữa bến
    x_coords = linspace(-L_ben/2 + l_1, L_ben/2 - l_1, N + 1);  % Các điểm theo trục X
    y_coords = linspace(-B_ben/2 + k_1, B_ben/2 - k_1, M + 1);  % Các điểm theo trục Y
    coordinates_z1 = [];coordinates_z2 = [];coordinates_z3 = [];coordinates_z4 = [];
    % Bộ tọa độ cho các điểm trong lưới
    for i = 1:length(y_coords)
        for j = 1:length(x_coords)
            coordinates_z1 = [coordinates_z1; x_coords(j), y_coords(i), Z_1];  % Tọa độ (x, y, Z)
            coordinates_z2 = [coordinates_z2; x_coords(j), y_coords(i), Z_2];
            coordinates_z3 = [coordinates_z3; x_coords(j), y_coords(i), Z_3];
            coordinates_z4 = [coordinates_z4; x_coords(j), y_coords(i), Z_4];
        
        end
    end
    % xyz1 = mat2cell(coordinates_z1,(N+1)*ones(1,M+1),3)';
    % xyz2 = mat2cell(coordinates_z2,(N+1)*ones(1,M+1),3)';
    % xyz3 = mat2cell(coordinates_z3,(N+1)*ones(1,M+1),3)';
    % xyz4 = mat2cell(coordinates_z4,(N+1)*ones(1,M+1),3)';
    % 
    % edY1 = xyz1{1}-[0,k_1,0];
    % edY2 = xyz1{end}+[0,k_1,0];
    % edX1 = cell2mat(cellfun(@(x) [x(1, :)]', xyz1, 'UniformOutput', false))'-[l_1,0,0];
    % edX2 = cell2mat(cellfun(@(x) [x(end, :)]', xyz1, 'UniformOutput', false))'+[l_1,0,0];
    % 
    % xyz11 = [{edY1},xyz1,{edY2}];
    % 
    % figure; hold on
    % view(3);
    % for i=1:length(xyz1)
    %     scatter3(xyz1{i}(:,1),xyz1{i}(:,2),xyz1{i}(:,3))   
    % end
    % scatter3(edY1(:,1),edY1(:,2),edY1(:,3))
    % scatter3(edY2(:,1),edY2(:,2),edY2(:,3))
    % scatter3(edX1(:,1),edX1(:,2),edX1(:,3))
    % scatter3(edX2(:,1),edX2(:,2),edX2(:,3))
    % 
    % for i = 1:length(xyz11)
    %     if i<length(xyz11)
    %         j=i+1;
    %     end
    %     for k=1:length(xyz11{1})
    %         plot3([xyz11{i}(k,1), xyz11{j}(k,1)], ...
    %               [xyz11{i}(k,2), xyz11{j}(k,2)], ...
    %               [xyz11{i}(k,3), xyz11{j}(k,3)], 'k-', 'LineWidth', 1);
    %     end
    % end
    
    % Vẽ các thanh nối (nối các điểm theo chiều ngang và chiều dọc)
    % figure; hold on
    % view(3);
    % scatter3(coordinates_z1(:,1),coordinates_z1(:,2),coordinates_z1(:,3))
    % scatter3(xyz2{1}(:,1),xyz2{1}(:,2),xyz2{1}(:,3))
    % for i=1:length(xyz3)
    %     scatter3(xyz3{i}(:,1),xyz3{i}(:,2),xyz3{i}(:,3))
    %     scatter3(xyz4{i}(:,1),xyz4{i}(:,2),xyz4{i}(:,3))
    % end
    % 
    % for i = 1:size(ele, 1)
    %     plot3([coordinates_z1(ele(i,1),1), coordinates_z1(ele(i,2),1)], ...
    %           [coordinates_z1(ele(i,1),2), coordinates_z1(ele(i,2),2)], ...
    %           [coordinates_z1(ele(i,1),3), coordinates_z1(ele(i,2),3)], 'k-', 'LineWidth', 1);
    % end
    % for i = 1:length(xyz2{1})
    %     plot3([xyz2{1}(i,1), xyz1{1}(i,1)], ...
    %           [xyz2{1}(i,2), xyz1{1}(i,2)], ...
    %           [xyz2{1}(i,3), xyz1{1}(i,3)], 'k-', 'LineWidth', 1);
    % end
    % for i = 1:length(xyz2{1})
    %     if i<length(xyz2{1})
    %         j=i+1;
    %     end
    %     plot3([xyz2{1}(i,1), xyz2{1}(j,1)], ...
    %           [xyz2{1}(i,2), xyz2{1}(j,2)], ...
    %           [xyz2{1}(i,3), xyz2{1}(j,3)], 'k-', 'LineWidth', 1);
    % end
    % for i = 1:length(xyz2{1})
    %     plot3([xyz2{1}(i,1), xyz3{1}(i,1)], ...
    %           [xyz2{1}(i,2), xyz3{1}(i,2)], ...
    %           [xyz2{1}(i,3), xyz3{1}(i,3)], 'k-', 'LineWidth', 1);
    % end
    % 
    % for j=2:size(xyz1,2)
    %     for i = 1:length(xyz1{1})
    %         plot3([xyz1{j}(i,1), xyz3{j}(i,1)], ...
    %               [xyz1{j}(i,2), xyz3{j}(i,2)], ...
    %               [xyz1{j}(i,3), xyz3{j}(i,3)], 'k-', 'LineWidth', 1);
    %     end
    % end
    % 
    % for j=1:size(xyz3,2)
    %     for i = 1:length(xyz3{1})
    %         plot3([xyz3{j}(i,1), xyz4{j}(i,1)], ...
    %               [xyz3{j}(i,2), xyz4{j}(i,2)], ...
    %               [xyz3{j}(i,3), xyz4{j}(i,3)], 'k-', 'LineWidth', 1);
    %     end
    % end
end