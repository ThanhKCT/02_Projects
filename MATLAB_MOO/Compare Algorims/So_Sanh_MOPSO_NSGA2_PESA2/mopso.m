function rep = mopso(MaxIt, nPop, nRep)
% =========================================================================
% MOPSO cho bài toán khung thép 2 tầng 1 nhịp. Chuyển từ dạng script sang
% dạng hàm (nhận MaxIt/nPop/nRep làm tham số) để hiệu chỉnh ngân sách NFE
% khi so sánh công bằng với NSGA-II/PESA-II trong Compare_Algorithms.m.
% =========================================================================
    if nargin < 1, MaxIt = 200; end
    if nargin < 2, nPop  = 100; end
    if nargin < 3, nRep  = 100; end

    %% Problem Definition (CẬP NHẬT 8 BIẾN TIẾT DIỆN CHỮ I THEO TCVN 5575:2024)
    CostFunction = @(x) HamMucTieuToiUu(x);   % Kết nối thẳng vào hàm mục tiêu chính 8 biến
    nVar = 8;                                 % Cập nhật lên 8 biến quyết định
    VarSize = [1 nVar];                       % Định dạng ma trận hàng [1 x 8]

    % Thứ tự biến: [bc,   hc,   twc,   tfc,   bd,   hd,   twd,   tfd]
    VarMin =       [0.20, 0.30, 0.006, 0.008, 0.15, 0.25, 0.005, 0.006]; % Cận dưới (m)
    VarMax =       [0.50, 0.80, 0.018, 0.022, 0.40, 0.60, 0.012, 0.016]; % Cận trên (m)

    %% MOPSO Parameters
    w = 0.9;              % Bắt đầu với quán tính lớn để bung ra khám phá
    wdamp = 0.995;        % wdamp lớn để quán tính giảm thật chậm
    c1 = 2.0;
    c2 = 2.0;

    % --- GIỚI HẠN VẬN TỐC (VELOCITY CLAMPING) ---
    VelMax = 0.15 * (VarMax - VarMin);
    VelMin = -VelMax;

    nGrid = 7;
    alpha = 0.1;

    beta = 2;
    gamma = 2;
    mu = 0.5;

    fprintf('--- Tham so MOPSO: MaxIt=%d, nPop=%d, nRep=%d, w=%.2f, wdamp=%.3f, c1=%.1f, c2=%.1f, nGrid=%d, alpha(grid)=%.2f, beta(leader)=%d, gamma(delete)=%d, mu(mut)=%.2f ---\n', ...
        MaxIt, nPop, nRep, w, wdamp, c1, c2, nGrid, alpha, beta, gamma, mu);

    %% Initialization
    empty_particle.Position = [];
    empty_particle.Velocity = [];
    empty_particle.Cost = [];
    empty_particle.Best.Position = [];
    empty_particle.Best.Cost = [];
    empty_particle.IsDominated = [];
    empty_particle.GridIndex = [];
    empty_particle.GridSubIndex = [];

    pop = repmat(empty_particle, nPop, 1);

    for i = 1:nPop
        pop(i).Position = VarMin + (VarMax - VarMin) .* rand(VarSize);
        pop(i).Velocity = zeros(VarSize);
        pop(i).Cost = CostFunction(pop(i).Position);

        % Update Personal Best
        pop(i).Best.Position = pop(i).Position;
        pop(i).Best.Cost = pop(i).Cost;
    end

    % Determine Domination
    pop = DetermineDomination(pop);
    rep = pop(~[pop.IsDominated]);
    Grid = CreateGrid(rep, nGrid, alpha);

    for i = 1:numel(rep)
        rep(i) = FindGridIndex(rep(i), Grid);
    end

    %% MOPSO Main Loop
    for it = 1:MaxIt
        for i = 1:nPop
            leader = SelectLeader(rep, beta);

            pop(i).Velocity = w*pop(i).Velocity ...
                +c1*rand(VarSize).*(pop(i).Best.Position-pop(i).Position) ...
                +c2*rand(VarSize).*(leader.Position-pop(i).Position);

            % --- ÉP VẬN TỐC KHÔNG BỊ "BÙNG NỔ" ---
            pop(i).Velocity = max(pop(i).Velocity, VelMin);
            pop(i).Velocity = min(pop(i).Velocity, VelMax);

            pop(i).Position = pop(i).Position + pop(i).Velocity;
            pop(i).Position = max(pop(i).Position, VarMin);
            pop(i).Position = min(pop(i).Position, VarMax);

            pop(i).Cost = CostFunction(pop(i).Position);

            % Apply Mutation
            pm = (1-(it-1)/(MaxIt-1))^(1/mu);
            if rand<pm
                NewSol.Position = Mutate_MOPSO(pop(i).Position, pm, VarMin, VarMax);
                NewSol.Cost = CostFunction(NewSol.Position);
                if Dominates(NewSol, pop(i))
                    pop(i).Position = NewSol.Position;
                    pop(i).Cost = NewSol.Cost;
                elseif Dominates(pop(i), NewSol)
                    % Do Nothing
                else
                    if rand<0.5
                        pop(i).Position = NewSol.Position;
                        pop(i).Cost = NewSol.Cost;
                    end
                end
            end

            if Dominates(pop(i), pop(i).Best)
                pop(i).Best.Position = pop(i).Position;
                pop(i).Best.Cost = pop(i).Cost;
            elseif Dominates(pop(i).Best, pop(i))
                % Do Nothing
            else
                if rand<0.5
                    pop(i).Best.Position = pop(i).Position;
                    pop(i).Best.Cost = pop(i).Cost;
                end
            end
        end

        % Add Non-Dominated Particles to REPOSITORY
        rep = [rep; pop(~[pop.IsDominated])]; %#ok

        % Determine Domination of New Resository Members
        rep = DetermineDomination(rep);

        % Keep only Non-Dominated Members in the Repository
        rep = rep(~[rep.IsDominated]);

        % Update Grid
        Grid = CreateGrid(rep, nGrid, alpha);

        % Update Grid Indices
        for i = 1:numel(rep)
            rep(i) = FindGridIndex(rep(i), Grid);
        end

        % Check if Repository is Full
        if numel(rep)>nRep
            Extra = numel(rep)-nRep;
            for e = 1:Extra
                rep = DeleteOneRepMemebr(rep, gamma);
            end
        end

        % Damping Inertia Weight
        w = w*wdamp;
    end
end
