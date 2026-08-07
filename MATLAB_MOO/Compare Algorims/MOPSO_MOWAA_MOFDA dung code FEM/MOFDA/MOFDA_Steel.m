function Archive = MOFDA_Steel(MaxIt, ArchiveSize, nPop)
% =========================================================================
% Multi-Objective Flow Direction Algorithm (MOFDA) - Nima Khodadadi (Univ.
% of Miami), chuyển thể cho bài toán khung thép 2 tầng 1 nhịp
% (TinhNoiLucKhung2T1N.m / HamMucTieuToiUu.m / Check_TCVN5575.m).
% Đã thay phần đọc bài toán benchmark gốc (Ptest.m/xboundaryP.m, method==3)
% bằng CostFunction/nVar/VarMin/VarMax của bài toán khung thép. Cơ chế
% thuật toán (di chuyển theo hướng dốc, archive lưới hypercube) giữ nguyên
% như bản gốc.
% =========================================================================
    if nargin < 1, MaxIt = 200; end
    if nargin < 2, ArchiveSize = 100; end
    if nargin < 3, nPop = 100; end

    CostFunction = @(x) HamMucTieuToiUu(x);
    nVar = 8;
    VarMin = [0.20, 0.30, 0.006, 0.008, 0.15, 0.25, 0.005, 0.006]; % Cận dưới (m)
    VarMax = [0.50, 0.80, 0.018, 0.022, 0.40, 0.60, 0.012, 0.016]; % Cận trên (m)

    lb = VarMin; ub = VarMax; dim = nVar; alpha = nPop;
    fhd = @(xcol) CostFunction(xcol); % MOFDA gọi fhd(Position'); CostFunction không phân biệt hàng/cột

    Alpha_grid = 0.1; % Grid Inflation Parameter
    nGrid = 10;       % Number of Grids per each Dimension
    Beta  = 4;        % Leader Selection Pressure Parameter
    gam   = 2;        % Extra Repository Member Selection Pressure

    beta = dim;
    maxiter = MaxIt;

    fprintf('--- Tham so MOFDA: MaxIt=%d, nPop(alpha)=%d, ArchiveSize=%d, nGrid=%d, Alpha(grid)=%.2f, Beta(leader)=%d, gamma(delete)=%d, so lang gieng/hat/vong lap(beta=dim)=%d ---\n', ...
        MaxIt, alpha, ArchiveSize, nGrid, Alpha_grid, Beta, gam, beta);

    flow_x = CreateEmptyParticle(alpha);

    %% Khởi tạo
    for i = 1:alpha
        flow_x(i).Velocity = 0;
        flow_x(i).Position = zeros(1,dim);
        flow_x(i,:).Position = lb + rand(1,dim).*(ub-lb);
        flow_x(i).Cost = fhd(flow_x(i,:).Position');
        flow_x(i).Best.Position = flow_x(i).Position;
        flow_x(i).Best.Cost = flow_x(i).Cost;
    end

    flow_x = DetermineDominations(flow_x);
    Archive = GetNonDominatedParticles(flow_x);

    Archive_costs = GetCosts(Archive);
    G = CreateHypercubes(Archive_costs, nGrid, Alpha_grid);

    for i = 1:numel(Archive)
        [Archive(i).GridIndex, Archive(i).GridSubIndex] = GetGridIndex(Archive(i), G);
    end

    Vmax = max(0.1*(ub-lb));
    Vmin = min(-0.1*(ub-lb));

    %% Vòng lặp chính
    for iter = 1:maxiter
        Leader = SelectLeader(Archive, Beta);
        delta = (((1-1*iter/maxiter+eps)^(2*randn)).*(rand(1,dim).*iter/maxiter).*rand(1,dim));

        for i = 1:alpha
            neighbor_x = CreateEmptyParticle(beta);
            Funeval = zeros(beta,1);
            for j = 1:beta
                Xrand = lb + rand(1,dim).*(ub-lb);
                neighbor_x(j,:).Position = flow_x(i,:).Position + randn(1,dim).*delta.*(rand*Xrand-rand*flow_x(i,:).Position).*norm(Leader.Position-flow_x(i,:).Position);
                neighbor_x(j,:).Position = max(neighbor_x(j,:).Position, lb);
                neighbor_x(j,:).Position = min(neighbor_x(j,:).Position, ub);
                neighbor_x(j).Cost = fhd(neighbor_x(j,:).Position');
                Funeval(j,:) = norm(neighbor_x(j).Cost);
            end
            [~,indx] = sort(Funeval);
            if neighbor_x(indx(1)).Cost < flow_x(i).Cost
                Sf = (neighbor_x(indx(1)).Cost-flow_x(i).Cost)./sqrt(norm(neighbor_x(indx(1),:).Position-flow_x(i,:).Position));
                V = randn.*(norm(Sf));
                if V<Vmin
                    V=-Vmin;
                elseif V>Vmax
                    V=-Vmax;
                end
                flow_x(i,:).Position = flow_x(i,:).Position+V.*(neighbor_x(indx(1),:).Position-flow_x(i,:).Position)./sqrt(norm(neighbor_x(indx(1),:).Position-flow_x(i,:).Position));
            else
                r = randi([1 alpha]);
                if flow_x(r).Cost<=flow_x(i).Cost
                    flow_x(i,:).Position = flow_x(i,:).Position+randn(1,dim).*(flow_x(r,:).Position-flow_x(i,:).Position);
                else
                    flow_x(i,:).Position = flow_x(i,:).Position+randn*(Leader.Position-flow_x(i,:).Position);
                end
            end
            flow_x(i,:).Position = max(flow_x(i,:).Position, lb);
            flow_x(i,:).Position = min(flow_x(i,:).Position, ub);
            flow_x(i).Cost = fhd(flow_x(i,:).Position');
        end

        flow_x = DetermineDominations(flow_x);
        non_dominated_flow_x = GetNonDominatedParticles(flow_x);

        Archive = [Archive; non_dominated_flow_x];
        Archive = DetermineDominations(Archive);
        Archive = GetNonDominatedParticles(Archive);

        for i = 1:numel(Archive)
            [Archive(i).GridIndex, Archive(i).GridSubIndex] = GetGridIndex(Archive(i), G);
        end

        if numel(Archive) > ArchiveSize
            EXTRA = numel(Archive) - ArchiveSize;
            Archive = DeleteFromRep(Archive, EXTRA, gam);

            Archive_costs = GetCosts(Archive);
            G = CreateHypercubes(Archive_costs, nGrid, Alpha_grid);
        end
    end
end
