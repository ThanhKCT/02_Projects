function [fit, diagAll] = mosfoa2_evaluate_batch(X, proj, cat, cfg)
% MOSFOA2_EVALUATE_BATCH  Bao (wrapper) dang batch cho evaluate_pile_design.m
% de dung duoc trong vong lap MOSFOA (nhan X la Npop x 1, tra ve fit la
% Npop x 2) - KHONG viet lai cong thuc/rang buoc, chi goi lai nguyen ham
% evaluate_pile_design da duoc kiem chung tung phuong an 1 (driver_example.m).
%
% X(:,1)  - chi so catalogue DANG LIEN TUC (MOSFOA tim kiem lien tuc trong
%           [1,K] roi lam tron o day, giong dung cach MOFDA/E-MOSFOA da lam
%           o Bai 1 - dam bao cong bang phuong phap tim kiem, xem
%           run_emosfoa_wharf100dwt_parallel.m dong 13-16).
% proj    - 'A' hoac 'B'
% cat     - pile_catalogue_AMACCAO()
% cfg     - project_config(proj)
%
% Gia dinh: SAP2000 da duoc mo san (open_Sap2000_v2/open_Sap2000_worker_v2)
% trong phien MATLAB/worker hien tai truoc khi goi ham nay.

K = numel(cat);
Npop = size(X,1);
fit = zeros(Npop,2);
diagAll = cell(Npop,1);

for i = 1:Npop
    xi = round(X(i,1));
    xi = max(1, min(K, xi));   % kep trong catalogue [1,K]
    [fit(i,:), diagAll{i}] = evaluate_pile_design(xi, proj, [], cat, cfg);
    diagAll{i}.x_rounded = xi;
end

end
