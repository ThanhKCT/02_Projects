% TEST_STALE_RESULTS  Kiem tra khong co "stale results": trong CUNG 1 phien
% SAP2000 dang mo (dung nhu vong lap toi uu that), danh gia Design A, ghi
% lai 1 response dac trung, doi sang Design B khac han, danh gia lai, xac
% nhan response THAY DOI dung theo Design B (khong bi giu lai gia tri cu
% cua A). Theo yeu cau ra soat muc 11 - BAT BUOC truoc campaign.
scriptDir = fileparts(mfilename('fullpath'));
addpath(scriptDir);
cfg = project_config_bai6();
[~, ~] = open_Sap2000_v2(cfg.sdb_path, true);

% Design A: h_DCT nho nhat (X3=1), cac bien khac o baseline
xA = [10 10 1 3];
[fitA, diagA] = evaluate_superstructure_design(xA, cfg);
fprintf('Design A: x=%s -> h_DCT=%.2f M_DCT=%.2f Mu_DCT=%.2f eta_DCT=%.4f f1=%.2f f2=%.4f\n', ...
    mat2str(xA), diagA.h_DCT, diagA.M_DCT_kNm, diagA.Mu_DCT_kNm, diagA.eta_DCT, fitA(1), fitA(2));

% Design B: h_DCT lon nhat (X3=23), giong het cac bien khac Design A
xB = [10 10 23 3];
[fitB, diagB] = evaluate_superstructure_design(xB, cfg);
fprintf('Design B: x=%s -> h_DCT=%.2f M_DCT=%.2f Mu_DCT=%.2f eta_DCT=%.4f f1=%.2f f2=%.4f\n', ...
    mat2str(xB), diagB.h_DCT, diagB.M_DCT_kNm, diagB.Mu_DCT_kNm, diagB.eta_DCT, fitB(1), fitB(2));

% Quay lai Design A LAN NUA (sau khi da chay B) - kiem tra co tra ve DUNG
% gia tri cu cua A (khong bi "ket dinh" theo B) hay khong.
[fitA2, diagA2] = evaluate_superstructure_design(xA, cfg);
fprintf('Design A (lap lai sau B): M_DCT=%.2f Mu_DCT=%.2f eta_DCT=%.4f f1=%.2f f2=%.4f\n', ...
    diagA2.M_DCT_kNm, diagA2.Mu_DCT_kNm, diagA2.eta_DCT, fitA2(1), fitA2(2));

fprintf('\n=== KET LUAN ===\n');
if abs(diagA.Mu_DCT_kNm - diagB.Mu_DCT_kNm) < 1e-6
    fprintf('CANH BAO: Mu_DCT KHONG doi giua A va B (h_DCT khac nhau ro ret) -> NGHI NGO stale/loi tinh Mu!\n');
else
    fprintf('OK: Mu_DCT thay doi dung theo h_DCT (A=%.2f, B=%.2f) - khong stale.\n', diagA.Mu_DCT_kNm, diagB.Mu_DCT_kNm);
end
if abs(fitA(1) - fitA2(1)) < 1e-6 && abs(fitA(2) - fitA2(2)) < 1e-6
    fprintf('OK: Danh gia lai DUNG Design A cho DUNG ket qua cu (tai lap duoc, khong bi "dinh" theo B).\n');
else
    fprintf('CANH BAO: Danh gia lai Design A cho KET QUA KHAC LAN DAU (f1: %.4f vs %.4f, f2: %.4f vs %.4f) -> can dieu tra (co the do RunAnalysis khong hoi tu on dinh, hoac loi trang thai model).\n', ...
        fitA(1), fitA2(1), fitA(2), fitA2(2));
end

try, SM.ApplicationExit(); catch, end
