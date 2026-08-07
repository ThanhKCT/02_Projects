function rep = MOPSO_Steel(MaxIt, nPop, nRep)
% =========================================================================
% MOPSO cho bài toán khung thép 2 tầng 1 nhịp (TinhNoiLucKhung2T1N.m /
% HamMucTieuToiUu.m / Check_TCVN5575.m). Chuyển thể từ mopso.m gốc của dự
% án (đã kiểm chứng khớp SAP2000) sang dạng hàm để dùng trong kịch bản so
% sánh MOPSO - MOWAA - MOFDA.
% =========================================================================
    if nargin < 1, MaxIt = 200; end
    if nargin < 2, nPop  = 100; end
    if nargin < 3, nRep  = 100; end

    %% Problem Definition
    CostFunction = @(x) HamMucTieuToiUu(x);
    nVar = 8;
    VarSize = [1 nVar];

    % Thứ tự biến: [bc,   hc,   twc,   tfc,   bd,   hd,   twd,   tfd]
    VarMin = [0.20, 0.30, 0.006, 0.008, 0.15, 0.25, 0.005, 0.006]; % Cận dưới (m)
    VarMax = [0.50, 0.80, 0.018, 0.022, 0.40, 0.60, 0.012, 0.016]; % Cận trên (m)

    %% MOPSO Parameters
    w = 0.9; wdamp = 0.995; c1 = 2.0; c2 = 2.0;

    VelMax = 0.15 * (VarMax - VarMin);
    VelMin = -VelMax;

    nGrid = 7; alpha = 0.1; beta = 2; gamma = 2; mu = 0.5;

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
        pop(i).Best.Position = pop(i).Position;
        pop(i).Best.Cost = pop(i).Cost;
    end

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

            pop(i).Velocity = max(pop(i).Velocity, VelMin);
            pop(i).Velocity = min(pop(i).Velocity, VelMax);

            pop(i).Position = pop(i).Position + pop(i).Velocity;
            pop(i).Position = max(pop(i).Position, VarMin);
            pop(i).Position = min(pop(i).Position, VarMax);

            pop(i).Cost = CostFunction(pop(i).Position);

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

        rep = [rep; pop(~[pop.IsDominated])]; %#ok
        rep = DetermineDomination(rep);
        rep = rep(~[rep.IsDominated]);
        Grid = CreateGrid(rep, nGrid, alpha);

        for i = 1:numel(rep)
            rep(i) = FindGridIndex(rep(i), Grid);
        end

        if numel(rep)>nRep
            Extra = numel(rep)-nRep;
            for e = 1:Extra
                rep = DeleteOneRepMemebr(rep, gamma);
            end
        end

        w = w*wdamp;
    end
end
