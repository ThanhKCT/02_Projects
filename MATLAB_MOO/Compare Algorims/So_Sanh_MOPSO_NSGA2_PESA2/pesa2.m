function archive = pesa2(MaxIt, nPop, nArchive)
% =========================================================================
% PESA-II cho bài toán khung thép 2 tầng 1 nhịp. Chuyển từ dạng script
% sang dạng hàm (nhận MaxIt/nPop/nArchive làm tham số) để hiệu chỉnh ngân
% sách NFE khi so sánh công bằng với MOPSO/NSGA-II trong Compare_Algorithms.m.
% =========================================================================
    if nargin < 1, MaxIt = 200; end
    if nargin < 2, nPop  = 100; end
    if nargin < 3, nArchive = 100; end

    %% Problem Definition (CẬP NHẬT 8 BIẾN TIẾT DIỆN CHỮ I THEO TCVN 5575:2024)
    CostFunction = @(x) HamMucTieuToiUu(x);
    nVar = 8;
    VarSize = [1 nVar];

    % Thứ tự biến: [bc,   hc,   twc,   tfc,   bd,   hd,   twd,   tfd]
    VarMin =       [0.20, 0.30, 0.006, 0.008, 0.15, 0.25, 0.005, 0.006]; % Cận dưới (m)
    VarMax =       [0.50, 0.80, 0.018, 0.022, 0.40, 0.60, 0.012, 0.016]; % Cận trên (m)

    %% PESA-II Settings
    nGrid = 7;
    InflationFactor = 0.1;

    beta_deletion = 1;
    beta_selection = 2;

    pCrossover = 0.5;
    nCrossover = round(pCrossover*nPop/2)*2;

    pMutation = 1-pCrossover;
    nMutation = nPop-nCrossover;

    crossover_params.gamma = 0.15;
    crossover_params.VarMin = VarMin;
    crossover_params.VarMax = VarMax;

    mutation_params.h = 0.3;
    mutation_params.VarMin = VarMin;
    mutation_params.VarMax = VarMax;

    % Hàm vòng quay Roulette
    RwsSelect = @(P) find(rand <= cumsum(P), 1, 'first');

    fprintf('--- Tham so PESA-II: MaxIt=%d, nPop=%d, nArchive=%d, nGrid=%d, InflationFactor=%.2f, beta_deletion=%d, beta_selection=%d, pCrossover=%.2f (nCrossover=%d), pMutation=%.2f (nMutation=%d) ---\n', ...
        MaxIt, nPop, nArchive, nGrid, InflationFactor, beta_deletion, beta_selection, pCrossover, nCrossover, pMutation, nMutation);

    %% Initialization
    empty_individual.Position = [];
    empty_individual.Cost = [];
    empty_individual.IsDominated = [];
    empty_individual.GridIndex = [];
    empty_individual.GridSubIndex = [];

    pop = repmat(empty_individual, nPop, 1);

    for i = 1:nPop
        pop(i).Position = VarMin + (VarMax - VarMin) .* rand(VarSize);
        pop(i).Cost = CostFunction(pop(i).Position);
    end

    archive = [];

    %% Main Loop
    for it = 1:MaxIt

        pop = DetermineDomination(pop);
        ndpop = pop(~[pop.IsDominated]);

        archive = [archive; ndpop]; %#ok
        archive = DetermineDomination(archive);
        archive = archive(~[archive.IsDominated]);

        % Gọi hàm lưới của PESA-II
        [archive, grid] = CreateGrid_PESA2(archive, nGrid, InflationFactor);

        % Truncate Archive nếu tràn bộ nhớ lưu trữ
        if numel(archive) > nArchive
            E = numel(archive) - nArchive;
            for e = 1:E
                NonEmptyGridIndices = find([grid.N] > 0);
                Grid_N = [grid(NonEmptyGridIndices).N];
                Grid_P = exp(beta_deletion * Grid_N);
                Grid_P = Grid_P / sum(Grid_P);

                selected_grid_idx = NonEmptyGridIndices(RwsSelect(Grid_P));
                members = grid(selected_grid_idx).Members;

                forced_die_idx = members(randi([1 numel(members)]));
                archive(forced_die_idx) = [];

                [archive, grid] = CreateGrid_PESA2(archive, nGrid, InflationFactor);
            end
        end

        if it >= MaxIt
            break;
        end

        % Tạo thế hệ mới
        NonEmptyGridIndices = find([grid.N] > 0);
        Grid_N = [grid(NonEmptyGridIndices).N];
        Grid_P = exp(-beta_selection * Grid_N);
        Grid_P = Grid_P / sum(Grid_P);

        % --- Crossover ---
        popc = repmat(empty_individual, nCrossover/2, 2);
        for c = 1:nCrossover/2
            selected_grid_idx1 = NonEmptyGridIndices(RwsSelect(Grid_P));
            members1 = grid(selected_grid_idx1).Members;
            p1 = archive(members1(randi([1 numel(members1)])));

            selected_grid_idx2 = NonEmptyGridIndices(RwsSelect(Grid_P));
            members2 = grid(selected_grid_idx2).Members;
            p2 = archive(members2(randi([1 numel(members2)])));

            [popc(c, 1).Position, popc(c, 2).Position] = Crossover_PESA2(p1.Position, p2.Position, crossover_params);

            popc(c, 1).Cost = CostFunction(popc(c, 1).Position);
            popc(c, 2).Cost = CostFunction(popc(c, 2).Position);
        end
        popc = popc(:);

        % --- Mutation ---
        popm = repmat(empty_individual, nMutation, 1);
        for m = 1:nMutation
            selected_grid_idx = NonEmptyGridIndices(RwsSelect(Grid_P));
            members = grid(selected_grid_idx).Members;
            p = archive(members(randi([1 numel(members)])));

            popm(m).Position = Mutate_PESA2(p.Position, mutation_params);
            popm(m).Cost = CostFunction(popm(m).Position);
        end

        pop = [popc; popm];
    end
end
