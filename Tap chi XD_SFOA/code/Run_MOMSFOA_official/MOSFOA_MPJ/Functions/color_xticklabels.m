function color_xticklabels(labels, colors, rotation)
    % color_xticklabels - Hiển thị nhãn màu ở trục X với góc xoay tùy chọn
    %
    % INPUT:
    %   labels    - cell array các chuỗi nhãn (vd: {'A','B','C'})
    %   colors    - cell array các màu tương ứng (vd: {[1 0 0],[0 0 1],...})
    %   rotation  - góc xoay của chữ (ví dụ: 0, 30, 45, hoặc 90)

    ax = gca;
    xtickpos = ax.XTick;
    ax.XTickLabel = [];  % Xóa nhãn mặc định

    % Điều chỉnh lại YLim để tạo khoảng trống bên dưới
    ylim = ax.YLim;
    yRange = diff(ylim);
    extraSpace = 0.08 * yRange;
    ax.YLim = [ylim(1) - extraSpace, ylim(2)];

    % Vị trí nhãn x thấp hơn một chút
    ymin = ax.YLim(1);
    offset = 0.037 * diff(ax.YLim);
    ytext = ymin - offset;

    % Hiển thị từng nhãn
    for i = 1:length(labels)
        text(xtickpos(i)-0.3, ytext, labels{i}, ...
            'Color', colors{i}, ...
            'HorizontalAlignment', 'center', ...
            'VerticalAlignment', 'top', ...
            'Rotation', rotation, ...
            'FontSize', 12, ...
            'FontWeight', 'bold');
    end
end
