S = load('D:\ResearchLab\02_Projects\02_Projects\MOFDA\Wharf100DWT\results\Wharf100DWT_BRUTEFORCE_FINAL.mat', 'ParetoFit', 'ParetoX', 'fit', 'diagnostic');
RefFront = S.ParetoFit; % [f1(tan), f2(m)]
hardMask = S.fit(:,1) >= 1e6 | S.fit(:,2) >= 1e6;
gTotal = S.diagnostic(:,9);
% Chi lay to hop KHA THI THUC SU (g_total==0, khong bi phat) lam nen --
% cac to hop bi phat mem co fit DA NHAN he so phat, gia tri bi thoi
% phong rat lon (f1 toi ~67.000 tan), ve chung se nhan chim mat Pareto
% that vao 1 goc nho khong nhin duoc gi ca.
strictFeasMask = ~hardMask & gTotal == 0;
feasFit = S.fit(strictFeasMask, :);
fprintf('So to hop kha thi thuc su (khong bi phat): %d\n', sum(strictFeasMask));

outDir = 'D:\ResearchLab\02_Projects\02_Projects\MOFDA\Wharf100DWT\results\analysis';
if ~isfolder(outDir); mkdir(outDir); end

f = figure('Visible','off','Position',[100 100 850 650]);
hold on; box on; grid on;

% Toan bo to hop kha thi (nen, xam nhat) de cho thay Pareto that "noi" len
scatter(feasFit(:,1), feasFit(:,2)*1000, 14, [0.65 0.65 0.65], 'filled', ...
    'MarkerFaceAlpha', 0.5, 'DisplayName', sprintf('To hop kha thi khong bi phat (%d)', sum(strictFeasMask)));

% Mat Pareto tham chieu, sap theo f1 de noi lien mach dung thu tu
[~, ord] = sort(RefFront(:,1));
plot(RefFront(ord,1), RefFront(ord,2)*1000, '-o', 'Color', [0.85 0.10 0.10], ...
    'MarkerFaceColor', [0.85 0.10 0.10], 'MarkerSize', 5, 'LineWidth', 1.5, ...
    'DisplayName', 'Mat Pareto tham chieu (59 nghiem)');

xlabel('f_1 - Khoi luong vat lieu (tan)');
ylabel('f_2 - Chuyen vi ngang lon nhat (mm)');
title('Mat Pareto tham chieu (vet can 4.080 to hop)');
legend('Location','northeast');

saveas(f, fullfile(outDir, 'reference_pareto_front.png'));
close(f);
fprintf('Da luu: %s\n', fullfile(outDir, 'reference_pareto_front.png'));
