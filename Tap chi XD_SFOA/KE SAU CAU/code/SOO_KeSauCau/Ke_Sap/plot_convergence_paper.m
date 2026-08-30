%% plot_convergence_paper.m -- render Hinh 1 (convergence curve) for the paper
scriptDir = fileparts(mfilename('fullpath'));
finalFile = fullfile(scriptDir,'..','results_SAP','KeSauCau_SOO_WallVolume_SAP_run01_PAPER.mat');
S = load(finalFile);
R = S.RunResult;

f = figure('Visible','off','Position',[100 100 700 450],'Color','w');
plot(1:numel(R.Curve), R.Curve, '-o', 'LineWidth', 1.5, 'MarkerSize', 3, ...
    'Color', [0 0.4470 0.7410], 'MarkerFaceColor', [0 0.4470 0.7410]);
grid on; box on;
xlabel('Vòng lặp', 'FontSize', 12);
ylabel('Khối lượng bê tông tốt nhất tích lũy V (m^3)', 'FontSize', 12);
xlim([1 numel(R.Curve)]);
set(gca, 'FontSize', 11);

outPath = fullfile(scriptDir,'..','..','..','paper','Hinh1_hoi_tu_SFOA.png');
exportgraphics(f, outPath, 'Resolution', 200);
fprintf('Saved figure to %s\n', outPath);
fprintf('DONE OK\n');
