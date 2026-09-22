% DRAW_FLOWCHART  Ve so do khoi quy trinh MOSFOA-MATLAB-SAP2000 don gian
% (khong phu thuoc du lieu campaign) bang cac hinh chu nhat + mui ten.
resultsDir = 'D:\ResearchLab\02_Projects\02_Projects\JTST paper 4\code\results';
f = figure('Visible','off','Position',[100 100 500 900]);
axis off; hold on;
xlim([0 10]); ylim([0 20]);

boxes = {
    'Bien thiet ke X1-X4'
    'MOSFOA (MATLAB)'
    'Cap nhat tiet dien SAP2000\n(SetRectangle / SetShell\_1)'
    'RunAnalysis'
    'Trich M/N/U (combo BAO-ULSB, BAO-SLSDH)'
    'Tinh f1, f2 + kiem tra rang buoc'
    'Fitness -> MOSFOA'
};
n = numel(boxes);
ys = linspace(18, 2, n);
for i = 1:n
    rectangle('Position', [1.5, ys(i)-0.8, 7, 1.6], 'Curvature', 0.1, 'FaceColor', [0.85 0.92 1], 'EdgeColor', [0.2 0.3 0.5], 'LineWidth', 1.2);
    text(5, ys(i), boxes{i}, 'HorizontalAlignment', 'center', 'FontSize', 9, 'Interpreter', 'none');
    if i < n
        annotation_x = 5/10; % normalized approx, use arrow via plot instead
        plot([5 5], [ys(i)-0.8, ys(i+1)+0.8], 'k-', 'LineWidth', 1.2);
        plot(5, ys(i+1)+0.8, 'k', 'Marker', 'v', 'MarkerFaceColor','k', 'MarkerSize', 6);
    end
end
% mui ten quay lai tu box cuoi len box 2 (vong lap)
plot([8.5 9.3 9.3 8.5], [ys(n) ys(n) ys(2) ys(2)], 'r--', 'LineWidth', 1);
plot(8.5, ys(2), 'r', 'Marker', '<', 'MarkerFaceColor','r', 'MarkerSize', 6);
text(9.5, (ys(n)+ys(2))/2, 'lap lai', 'Rotation', 90, 'Color', 'r', 'FontSize', 8, 'HorizontalAlignment','center');

title('So do quy trinh MOSFOA - MATLAB - SAP2000');
saveas(f, fullfile(resultsDir, 'Hinh_sodoquytrinh.png'));
close(f);
fprintf('Da luu Hinh_sodoquytrinh.png\n');
