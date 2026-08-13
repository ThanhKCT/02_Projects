function gamman = get_gamma_n()
% GET_GAMMAN - Hệ số tin cậy về tầm quan trọng (gamman)
fprintf('\n--- Hướng dẫn xác định cấp tầm quan trọng công trình (Phụ lục F) ---\n');
fprintf('1. Cấp I: Các loại nhà và công trình mà sự hư hỏng có thể mang lại hậu quả nghiêm trọng về kinh tế, xã hội, sinh thái (bể chứa dầu, bể sản phẩm từ dầu dung tích >= 10000 m3, đường ống dẫn chính, nhà sản xuất cột buồm >100m, nhà có yêu cầu đặc biệt...)\n');
fprintf('2. Cấp II: Nhà và công trình lớn, nhà ở, nhà công cộng, nhà sản xuất, nhà và công trình nông nghiệp.\n');
fprintf('3. Cấp III: Công trình tạm thời (nhà tạm, kho nhỏ, công trình tương tự...)\n');
fprintf('-----------------------------------------------------------\n');
imp_level = input('Nhập cấp (1-3): ');
if imp_level == 1
    gamman = 1.2;
elseif imp_level == 2
    gamman = 1.15;
elseif imp_level == 3
    gamman = 1.1;
else
    error('Cấp tầm quan trọng không hợp lệ.');
end
end
