function soil_type = soil_type_guide(show_guide)
% INPUT_SOIL_TYPE - Hiển thị hướng dẫn chọn loại đất nếu muốn, rồi nhập soil_type
%   show_guide: true/false (1/0). Nếu true, sẽ hiện hướng dẫn chọn loại đất.
%   Trả về soil_type (chuỗi: 'cat', 'catpha', 'setpha', 'set').

if nargin < 1
    show_guide = true;
end

if show_guide
    fprintf('\n--- Chọn loại đất (soil_type) ---\n');
    fprintf('1. cat     - Cát\n');
    fprintf('2. catpha  - Cát pha\n');
    fprintf('3. setpha  - Sét pha\n');
    fprintf('4. set     - Sét\n');
    fprintf('-------------------------------\n');
end

soil_code = input('Nhập số loại đất (1-4): ');
soil_list = {'cat','catpha','setpha','set'};

if ~isscalar(soil_code) || soil_code < 1 || soil_code > 4
    error('Giá trị loại đất phải là số nguyên từ 1 đến 4!');
end

soil_type = soil_list{soil_code};
end
