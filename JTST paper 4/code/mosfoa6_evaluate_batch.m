function [fitOut, feasibleOut] = mosfoa6_evaluate_batch(Xbatch, cfg)
% MOSFOA6_EVALUATE_BATCH  Bao (wrapper) dang batch cho evaluate_superstructure_design.m
% de dung trong vong lap MOSFOA (nhan Xbatch la Npop x 4, tra ve fitOut la
% Npop x 2). Gia dinh SAP2000 da mo san (open_Sap2000_v2/_worker_v2) tren
% worker/phien MATLAB hien tai truoc khi goi ham nay - giong het pattern
% mosfoa2_evaluate_batch.m cua Bai 2.
%
% feasibleOut (Npop x 1 logical) - THEM (2026-09-16, theo yeu cau ra soat
% truoc campaign): de run_mosfoa6_parallel.m dem duoc so nghiem kha
% thi/khong kha thi moi the he, phuc vu RunLog (khong chi luu gia tri
% fitness ma con biet duoc bao nhieu % quan the bi phat cung moi vong).

Npop = size(Xbatch,1);
fitOut = zeros(Npop,2);
feasibleOut = false(Npop,1);
for i = 1:Npop
    [fitOut(i,:), diagI] = evaluate_superstructure_design(Xbatch(i,:), cfg);
    feasibleOut(i) = diagI.feasible;
end

end
