function F1 = nsga2(MaxIt, nPop)
% =========================================================================
% NSGA-II cho bài toán khung thép 2 tầng 1 nhịp. Chuyển từ dạng script
% sang dạng hàm (nhận MaxIt/nPop làm tham số) để hiệu chỉnh ngân sách NFE
% khi so sánh công bằng với MOPSO/PESA-II trong Compare_Algorithms.m.
% =========================================================================
    if nargin < 1, MaxIt = 200; end
    if nargin < 2, nPop  = 100; end

    %% Problem Definition (CẬP NHẬT 8 BIẾN TIẾT DIỆN CHỮ I THEO TCVN 5575:2024)
    CostFunction = @(x) HamMucTieuToiUu(x);
    nVar = 8;
    VarSize = [1 nVar];

    % Thứ tự biến: [bc,   hc,   twc,   tfc,   bd,   hd,   twd,   tfd]
    VarMin =       [0.20, 0.30, 0.006, 0.008, 0.15, 0.25, 0.005, 0.006]; % Cận dưới (m)
    VarMax =       [0.50, 0.80, 0.018, 0.022, 0.40, 0.60, 0.012, 0.016]; % Cận trên (m)

    %% NSGA-II Parameters
    pCrossover = 0.7;                         % Crossover Percentage
    nCrossover = 2*round(pCrossover*nPop/2);  % Number of Parents (Offsprings)

    pMutation = 0.3;                          % Mutation Percentage
    nMutation = round(pMutation*nPop);        % Number of Mutants

    mu = 0.02;                    % Mutation Rate
    sigma = 0.1*(VarMax-VarMin);  % Mutation Step Size (Tự động nhận kích cỡ 1x8)

    fprintf('--- Tham so NSGA-II: MaxIt=%d, nPop=%d, pCrossover=%.2f (nCrossover=%d), pMutation=%.2f (nMutation=%d), mu(rate)=%.3f ---\n', ...
        MaxIt, nPop, pCrossover, nCrossover, pMutation, nMutation, mu);

    %% Initialization
    empty_individual.Position = [];
    empty_individual.Cost = [];
    empty_individual.Rank = [];
    empty_individual.DominationSet = [];
    empty_individual.DominatedCount = [];
    empty_individual.CrowdingDistance = [];

    pop = repmat(empty_individual, nPop, 1);

    for i = 1:nPop
        pop(i).Position = VarMin + (VarMax - VarMin) .* rand(VarSize);
        pop(i).Cost = CostFunction(pop(i).Position);
    end

    % Non-Dominated Sorting
    [pop, F] = NonDominatedSorting(pop);

    % Calculate Crowding Distance
    pop = CalcCrowdingDistance(pop, F);

    % Sort Population
    [pop, F] = SortPopulation(pop);

    %% NSGA-II Main Loop
    for it = 1:MaxIt

        % Crossover
        popc = repmat(empty_individual, nCrossover/2, 2);
        for k = 1:nCrossover/2
            i1 = randi([1 nPop]); p1 = pop(i1);
            i2 = randi([1 nPop]); p2 = pop(i2);

            [popc(k, 1).Position, popc(k, 2).Position] = Crossover(p1.Position, p2.Position);

            % Chèn ép biên an toàn
            popc(k, 1).Position = max(popc(k, 1).Position, VarMin);
            popc(k, 1).Position = min(popc(k, 1).Position, VarMax);
            popc(k, 2).Position = max(popc(k, 2).Position, VarMin);
            popc(k, 2).Position = min(popc(k, 2).Position, VarMax);

            popc(k, 1).Cost = CostFunction(popc(k, 1).Position);
            popc(k, 2).Cost = CostFunction(popc(k, 2).Position);
        end
        popc = popc(:);

        % Mutation (Đột biến)
        popm = repmat(empty_individual, nMutation, 1);
        for k = 1:nMutation
            i = randi([1 nPop]); p = pop(i);

            popm(k).Position = Mutate_NSGA2(p.Position, mu, sigma, VarMin, VarMax);

            popm(k).Position = max(popm(k).Position, VarMin);
            popm(k).Position = min(popm(k).Position, VarMax);

            popm(k).Cost = CostFunction(popm(k).Position);
        end

        % Merge
        pop = [pop; popc; popm]; %#ok

        % Non-Dominated Sorting
        [pop, F] = NonDominatedSorting(pop);

        % Calculate Crowding Distance
        pop = CalcCrowdingDistance(pop, F);

        % Sort Population
        pop = SortPopulation(pop);

        % Truncate
        pop = pop(1:nPop);

        % Non-Dominated Sorting
        [pop, F] = NonDominatedSorting(pop);

        % Calculate Crowding Distance
        pop = CalcCrowdingDistance(pop, F);

        % Sort Population
        [pop, F] = SortPopulation(pop);

        % Store F1
        F1 = pop(F{1});
    end
end
