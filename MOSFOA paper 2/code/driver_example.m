% DRIVER_EXAMPLE  Khung vi du chay 1 campaign MOSFOA cho 1 cong trinh.
%
% Day CHI la vi du minh hoa cach ghep evaluate_pile_design() vao vong lap
% toi uu - THAY THE phan "MOSFOA_step" bang ham MOSFOA that cua ban (khong
% viet lai thuat toan, dung theo dung tinh than Bai_2 - xem
% Yeu_cau_trien_khai_Bai_2.md muc 1).
%
% CHAY SMOKE TEST TRUOC (Npop nho, 1 vong lap) theo dung checklist trong
% "Cach ket noi_SAP2000_MATLAB_OPTIMIZATION.md" muc 8 - KHONG chay thang
% campaign day du.

clear; clc;
addpath(fileparts(mfilename('fullpath')));

proj = 'B';   % 'A' hoac 'B' - chay rieng tung cong trinh, KHONG gop model
              % (dieu khoan bat buoc, xem Danh_gia_kha_thi_Bai_2.md muc 2.1)

cfg = project_config(proj);
cat = pile_catalogue_AMACCAO();
K = numel(cat);
fprintf('Cong trinh %s: %d dong catalogue kha dung (x = 1..%d)\n', cfg.name, K, K);

% --- Mo SAP2000 MOT LAN duy nhat cho ca campaign (khong mo lai moi vong) ---
open_Sap2000(1);   % 1 = an hoan toan
global SM %#ok<GVMIS>  % neu SM.* dung bien global noi bo - dieu chinh theo toolkit that
SapModel = SM.SapModel();
ret = SapModel.File.OpenFile(cfg.sdb_path); %#ok<NASGU>

% --- Vi du: danh gia toan bo K phuong an (vet can, dung khi K nho) ---
% Phu hop yeu cau muc 6.3 de cuong: "neu khong gian du nho thi vet can de
% lam Pareto tham chieu".
results = struct('x', {}, 'fit', {}, 'diagnostic', {});
for x = 1:K
    [fit, diag] = evaluate_pile_design(x, proj, SapModel, cat, cfg);
    results(end+1) = struct('x', x, 'fit', fit, 'diagnostic', diag); %#ok<AGROW>
    fprintf('x=%2d  D=%4dmm Class=%s  f1=%.2fT  f2=%.4fm  feasible=%d\n', ...
        x, cat(x).D_mm, cat(x).Class, fit(1), fit(2), diag.feasible);
end

% --- Loc nghiem kha thi va tim Pareto front (vi du don gian, khong can
%     toolbox rieng cho khong gian nho 33 phuong an) ---
feas = results([results.diagnostic] & arrayfun(@(r) r.diagnostic.feasible, results));
F = reshape([feas.fit], 2, [])';
isParetoRow = true(size(F,1),1);
for i = 1:size(F,1)
    dominated = any(all(F <= F(i,:), 2) & any(F < F(i,:), 2));
    isParetoRow(i) = ~dominated;
end
paretoSet = feas(isParetoRow);
fprintf('\nSo nghiem kha thi: %d / %d.  So nghiem Pareto: %d\n', numel(feas), K, numel(paretoSet));

% --- Dong SAP2000 khi xong campaign ---
SM.ApplicationExit(false); %#ok<*UNRCH>

% ==========================================================================
% GHI CHU TICH HOP MOSFOA THAT (thay doan vet can o tren neu khong gian
% thiet ke lon hon, hoac muon chay MOSFOA de doi chieu voi Pareto vet can):
%
%   for gen = 1:MaxIt
%       for i = 1:Npop
%           x = MOSFOA_step(...);   % thuat toan cua ban, KHONG viet lai
%           [fit, diag] = evaluate_pile_design(round(x), proj, SapModel, cat, cfg);
%           ...cap nhat Pareto archive...
%       end
%       ...checkpoint moi K vong lap (xem huong dan muc 5)...
%   end
% ==========================================================================
