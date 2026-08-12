% function idx = hybridSelectLeader(REP)
%     n = size(REP.pos, 1);
%     if n == 1
%         idx = 1;
%         return;
%     end
%     % Nếu không có density thì mặc định = 0
%     if ~isfield(REP, 'density') || isempty(REP.quality)
%         REP.quality = zeros(1, n);
%     end
% 
%     % Nếu không có gridIndex thì mặc định = 0
%     if ~isfield(REP, 'gridIndex') || isempty(REP.grid_idx)
%         REP.grid_idx = zeros(1, n);
%     end
% 
%     % Tính điểm ưu tiên dựa trên grid và mật độ
%     scores = REP.grid_idx + rand(1, n) ./ (1 + REP.quality(:,2));
%     [~, idx] = min(scores);
% end

function idx = hybridSelectLeader(REP)
    n = size(REP.pos, 1);
    if n == 1
        idx = 1;
        return;
    end

    % Nếu không có quality hoặc grid_idx thì gán mặc định
    if ~isfield(REP, 'quality') || isempty(REP.quality)
        REP.quality = zeros(n, 2); % mặc định quality = 0
    end
    if ~isfield(REP, 'grid_idx') || isempty(REP.grid_idx)
        REP.grid_idx = zeros(n, 1); % mặc định index = 0
    end

    % Ánh xạ grid_idx sang quality
    density_score = zeros(n, 1);
    for i = 1:n
        grid_id = REP.grid_idx(i);
        q_idx = find(REP.quality(:,1) == grid_id, 1);
        if ~isempty(q_idx)
            density_score(i) = REP.quality(q_idx, 2); % lấy giá trị quality từ REP.quality
        else
            density_score(i) = 1; % nếu không tìm thấy, giả sử chất lượng trung bình
        end
    end

    % Hybrid score: nhỏ hơn thì ưu tiên hơn
    scores = REP.grid_idx(:)' + rand(1, n) ./ (1 + density_score(:)');
    [~, idx] = min(scores);
end
