function pile_type = pile_type_guide(show_guide)
% INPUT_PILE_TYPE - Hiển thị hướng dẫn chọn loại cọc nếu muốn, rồi nhập pile_type
%   show_guide: true/false (1/0). Nếu true, sẽ hiện hướng dẫn chọn loại cọc.
%   Trả về pile_type (số thứ tự loại cọc theo bảng tiêu chuẩn).

if nargin < 1
    show_guide = true; % Mặc định luôn hiện hướng dẫn nếu chưa truyền đối số
end

if show_guide
    fprintf('\n--- Chọn loại cọc (pile_type) theo Bảng 5 ---\n');
    fprintf('1. Cọc đóng hoặc ép nhồi theo điểm 6.4a, hạ ống vách có tấm đế, hoặc nút bê tông\n');
    fprintf('2. Cọc nhồi dạng ép chấn động\n');
    fprintf('3. Cọc khoan nhồi trong đó có mở rộng mũi, đổ bê tông:\n');
    fprintf('   - 3a. Không có nước (phương pháp khô)\n');
    fprintf('   - 3b. Dưới nước, vữa sét\n');
    fprintf('   - 3c. Dùng bê tông cứng, đầm sâu (phương pháp khô)\n');
    fprintf('4. Cọc barrette\n');
    fprintf('5. Cọc ống hạ bằng phương pháp rung, kết hợp đào moi đất\n');
    fprintf('6. Cọc trụ\n');
    fprintf('7. Cọc khoan phun nhồi, cọc khoan phun vữa, v.v.\n');
    fprintf('---------------------------------------------\n');
end

pile_type = input('Nhập số loại cọc (1-7): ');
if ~isscalar(pile_type) || pile_type < 1 || pile_type > 7
    error('Giá trị loại cọc phải là số nguyên từ 1 đến 7!');
end
end
