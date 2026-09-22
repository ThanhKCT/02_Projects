% SELECT_REPRESENTATIVE_SOLUTIONS  Doc mat Pareto tong the (90 nghiem, CSV
% da xuat), chon 3 nghiem dai dien theo dung bang de xuat muc 13.5 de cuong:
% A = nhe nhat (min f1), C = dap ung tot nhat (min f2), B = can bang (knee
% point, khoang cach chuan hoa nho nhat toi diem ly tuong [0,0]).
T = readtable('D:\ResearchLab\02_Projects\02_Projects\JTST paper 4\code\results\campaign_pareto_tongthe_20runs.csv');
f1 = T.f1_khoiluong_Tan; f2 = T.f2_eta_max;

[~, iA] = min(f1);
[~, iC] = min(f2);
f1n = (f1 - min(f1)) / (max(f1) - min(f1));
f2n = (f2 - min(f2)) / (max(f2) - min(f2));
dist = sqrt(f1n.^2 + f2n.^2);
[~, iB] = min(dist);

fprintf('=== 3 NGHIEM DAI DIEN (muc 13.5 de cuong) ===\n');
labels = {'A (nhe nhat)','B (can bang/knee)','C (dap ung tot nhat)'};
idxs = [iA, iB, iC];
for k = 1:3
    i = idxs(k);
    fprintf('%s: h_DN=%.2f h_DD=%.2f h_DCT=%.2f t_BMC=%.2f | f1=%.2f Tan | f2(eta_max)=%.4f\n', ...
        labels{k}, T.h_DN_m(i), T.h_DD_m(i), T.h_DCT_m(i), T.t_BMC_m(i), f1(i), f2(i));
end

save('D:\ResearchLab\02_Projects\02_Projects\JTST paper 4\code\results\representative_solutions.mat', 'T', 'iA', 'iB', 'iC', 'labels');
