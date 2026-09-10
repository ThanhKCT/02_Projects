function method = method_guide(show_guide)
% INPUT_METHOD - Hiển thị hướng dẫn chọn phương pháp thi công, rồi nhập method
%   show_guide: true/false (1/0). Nếu true, sẽ hiện hướng dẫn chọn method.
%   Trả về method (chuỗi: 'default', 'underwater', 'hard_concrete')

if nargin < 1
    show_guide = true;
end

if show_guide
    fprintf('\n--- Chọn phương pháp thi công (method) ---\n');
    fprintf('1. default        - Không có nước (phương pháp khô)\n');
    fprintf('2. underwater     - Dưới nước hoặc dùng vữa sét\n');
    fprintf('3. hard_concrete  - Dùng bê tông cứng, đầm sâu\n');
    fprintf('------------------------------------------\n');
end

method_code = input('Nhập số phương pháp (1-3): ');
method_list = {'default', 'underwater', 'hard_concrete'};

if ~isscalar(method_code) || method_code < 1 || method_code > 3
    error('Giá trị method phải là số nguyên từ 1 đến 3!');
end

method = method_list{method_code};
end
