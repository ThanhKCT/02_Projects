function [pop, grid] = CreateGrid_PESA2(pop, nGrid, InflationFactor)

    if isempty(pop)
        grid = [];
        return;
    end

    z = [pop.Cost]';
    zmin = min(z, [], 1);
    zmax = max(z, [], 1);
    
    dz = zmax - zmin;
    alpha = InflationFactor / 2;
    zmin = zmin - alpha * dz;
    zmax = zmax + alpha * dz;
    
    nObj = numel(zmin);
    
    C = zeros(nObj, nGrid+3);
    for j = 1:nObj
        C(j, :) = [-inf, linspace(zmin(j), zmax(j), nGrid+1), inf];
    end
    
    empty_grid.LB = [];
    empty_grid.UB = [];
    empty_grid.Index = [];
    empty_grid.SubIndex = [];
    empty_grid.N = 0;
    empty_grid.Members = [];
    
    nG = (nGrid+2)^nObj;
    GridSize = (nGrid+2) * ones(1, nObj);
    
    grid = repmat(empty_grid, nG, 1);
    for k = 1:nG
        SubIndex = cell(1, nObj);
        [SubIndex{:}] = ind2sub(GridSize, k);
        SubIndex = cell2mat(SubIndex);

        grid(k).Index = k;
        grid(k).SubIndex = SubIndex;
        
        grid(k).LB = zeros(nObj, 1);
        grid(k).UB = zeros(nObj, 1);
        for j = 1:nObj
            grid(k).LB(j) = C(j, SubIndex(j));
            grid(k).UB(j) = C(j, SubIndex(j)+1);
        end
    end

    % --- THUẬT TOÁN XÁC ĐỊNH VỊ TRÍ TRONG LƯỚI TÍNH TRỰC TIẾP (THAY THẾ FINDPOSITIONINGRID) ---
    for i = 1:numel(pop)
        pop(i).GridSubIndex = zeros(1, nObj);
        for j = 1:nObj
            pop(i).GridSubIndex(j) = find(pop(i).Cost(j) < C(j, :), 1, 'first') - 1;
        end
        
        % Tính GridIndex độc lập theo cấu trúc ô lưới PESA-II
        pop(i).GridIndex = pop(i).GridSubIndex(1);
        for j = 2:nObj
            pop(i).GridIndex = pop(i).GridIndex - 1;
            pop(i).GridIndex = (nGrid+2) * pop(i).GridIndex;
            pop(i).GridIndex = pop(i).GridIndex + pop(i).GridSubIndex(j);
        end
        
        % Cập nhật thông tin thành viên vào Grid
        g = pop(i).GridIndex;
        grid(g).N = grid(g).N + 1;
        grid(g).Members = [grid(g).Members; i];
    end
end