function Archive = MOWAA_Steel(MaxIt, ArchiveSize, nPop)
% =========================================================================
% MOWAA (bản mở rộng của MOGWO - Multi-Objective Grey Wolf Optimizer, thêm
% Levy flight + lai ghép + đột biến + vị trí trung bình có trọng số) -
% chuyển thể cho bài toán khung thép 2 tầng 1 nhịp (TinhNoiLucKhung2T1N.m
% / HamMucTieuToiUu.m / Check_TCVN5575.m).
% Đã thay phần đọc bài toán benchmark gốc (cec09.m/xboundary.m, CEC09 UF10)
% bằng CostFunction/nVar/VarMin/VarMax của bài toán khung thép, và bỏ phần
% so sánh với Pareto front chuẩn (IGD/GD/Spread/MS/Spacing/Hypervolume) vì
% bài toán khung thép không có Pareto front chuẩn để đối chiếu.
% LƯU Ý: giữ nguyên 2 điểm "lạ" trong code gốc của tác giả (không sửa, để
% trung thực với thuật toán công bố):
%   - Biến "beta" (áp lực chọn Leader) bị GHI ĐÈ bởi tham số Levy flight
%     (case k2==1) sau lần đầu kích hoạt, làm thay đổi áp lực chọn Leader
%     về sau trong toàn bộ quá trình chạy.
%   - Trong case k2==2 (lai ghép), "parent_index1" dùng size(Archive,2)
%     (luôn =1 vì Archive là mảng cột) nên hầu như luôn chọn phần tử đầu
%     tiên của Archive làm cha thứ nhất.
% =========================================================================
    if nargin < 1, MaxIt = 200; end
    if nargin < 2, ArchiveSize = 100; end
    if nargin < 3, nPop = 100; end

    CostFunction = @(x) HamMucTieuToiUu(x);
    nVar = 8;
    VarMin = [0.20, 0.30, 0.006, 0.008, 0.15, 0.25, 0.005, 0.006]; % Cận dưới (m)
    VarMax = [0.50, 0.80, 0.018, 0.022, 0.40, 0.60, 0.012, 0.016]; % Cận trên (m)

    fobj = @(xcol) CostFunction(xcol)'; % giữ đúng quy ước hàng của MOWAA gốc (fobj(x')')
    lb = VarMin; ub = VarMax;

    Population_num = nPop;
    Archive_size = ArchiveSize;

    alpha_grid = 0.1; % Grid Inflation Parameter
    nGrid = 10;        % Number of Grids per each Dimension
    beta  = 4;         % Leader Selection Pressure Parameter (bị ghi đè về sau, xem lưu ý trên)
    gam1  = 2;         % Extra (to be deleted) Repository Member Selection Pressure

    fprintf('--- Tham so MOWAA: MaxIt=%d, nPop=%d, ArchiveSize=%d, nGrid=%d, alpha(grid)=%.2f, beta(leader, ban dau)=%d, gamma(delete)=%d ---\n', ...
        MaxIt, Population_num, Archive_size, nGrid, alpha_grid, beta, gam1);

    %% Khởi tạo
    Population = CreateEmptyParticle(Population_num);

    for i = 1:Population_num
        Population(i).Velocity = 0;
        Population(i).Position = zeros(1,nVar);
        for j = 1:nVar
            Population(i).Position(1,j) = lb(j) + (ub(j)-lb(j))*rand(); % unifrnd (khong can Statistics Toolbox)
        end
        Population(i).Cost = fobj(Population(i).Position')';
        Population(i).Best.Position = Population(i).Position;
        Population(i).Best.Cost = Population(i).Cost;
    end

    Population = DetermineDomination(Population);
    Archive = GetNonDominatedParticles(Population);

    Archive_costs = GetCosts(Archive);
    Population_costs = GetCosts(Population);

    G = CreateHypercubes(Archive_costs, nGrid, alpha_grid);

    for i = 1:numel(Archive)
        [Archive(i).GridIndex, Archive(i).GridSubIndex] = GetGridIndex(Archive(i), G);
    end

    %% Vòng lặp chính
    for it = 1:MaxIt
        clear Cost Cost2 Cost3 min_Cost max_Cost
        for i1 = 1:numel(Population)
            Cost(i1,:) = Population_costs(:,i1);
        end

        for i2 = 1:min(size(Cost))
            max_Cost(i2) = max(Cost(:,i2));
            min_Cost(i2) = min(Cost(:,i2));
        end
        n = (numel(Population)-4)*(it-1)/(1-MaxIt)+numel(Population);
        for i3 = 1:n
            for i2 = 1:min(size(Cost))
                Cost2(i3,i2) = (Cost(i3,i2)-min_Cost(1,i2))/(max_Cost(1,i2)-min_Cost(1,i2));
            end
        end
        Cost3 = sum(Cost2, 2);
        miu = zeros(1,nVar);
        sum_Cost = sum(Cost3);
        for i = 1:n
            miu(1,:) = miu(1,:)+Population(i).Position*(sum_Cost-Cost3(i))/(sum_Cost*(n-1));
        end

        for i = 1:Population_num
            clear rep2 rep3

            Best_X(1,:) = SelectLeader(Archive,beta);

            k1 = (10*rand-1)*sin(pi*it/MaxIt);
            k2 = randi([1,3],1,1);

            if k1<0.5
                switch k2
                    case 1
                        Best_X_Position = Best_X.Position;
                        for j = 1:nVar
                            beta = 1.5+rand*0.5; %#ok<FXSET> % giữ nguyên hành vi gốc (xem lưu ý đầu file)
                            sigma1 = gamma(1+beta)*sin(pi*beta/2)/(beta*gamma(0.5+0.5*beta)*2^(0.5*beta-0.5));
                            levy(j) = (sigma1^2*randn())/abs(randn())^(-beta); % normrnd (khong can Statistics Toolbox)
                            Population_tem_Position(1,j) = Best_X_Position(1,j)+levy(j);
                        end
                        Population(i).Position = Population_tem_Position;
                    case 2
                        parent_index1 = randi([1,size(Archive, 2)]); % giữ nguyên hành vi gốc (xem lưu ý đầu file)
                        parent1 = Archive(parent_index1).Position;
                        parent_index2 = randi([1,size(Archive, 1)]);
                        parent2 = Archive(parent_index2).Position;
                        crossoverPoint = randi([1, numel(parent1)]);
                        Population(i).Position = [parent1(1:crossoverPoint), parent2(crossoverPoint+1:end)];
                    case 3
                        mutation_rate = 0.1;
                        parent_index = randi([1,size(Archive, 1)]);
                        parent = Archive(parent_index).Position;
                        Population(i).Position = parent + rand(1,numel(parent)).* mutation_rate;
                end
            else
                switch k2
                    case 1
                        Population(i).Position = rand*(miu(1,:)-Best_X(1,:).Position)+rand*(miu(1,:)-Population(i).Best.Position)+rand*miu(1,:);
                    case 2
                        Population(i).Position = rand*(miu(1,:)-Best_X(1,:).Position)+rand*Best_X(1,:).Position;
                    case 3
                        Population(i).Position = rand*(miu(1,:)-Population(i).Best.Position)+rand*Population(i).Best.Position;
                end
            end

            Population(i).Position = min(max(Population(i).Position,lb),ub);
            Population(i).Cost = fobj(Population(i).Position')';

            pos_best = dominates1(Population(i).Cost, Population(i).Best.Cost);
            if(sum(pos_best)>=1)
                Population(i).Best.Position = Population(i).Position;
                Population(i).Best.Cost = Population(i).Cost;
            end
        end

        Population_personalbest = CreateEmptyParticle(Population_num);
        for i = 1:Population_num
            Population_personalbest(i).Position = Population(i).Best.Position;
            Population_personalbest(i).Cost = Population(i).Best.Cost;
            Population_personalbest(i).Velocity = 0;
        end
        Population_personalbest = DetermineDomination(Population_personalbest);
        non_dominated_wolves1 = GetNonDominatedParticles(Population_personalbest);

        Population = DetermineDomination(Population);
        non_dominated_wolves = GetNonDominatedParticles(Population);

        Archive = [Archive(:); non_dominated_wolves(:); non_dominated_wolves1(:)];

        Archive = DetermineDomination(Archive);
        Archive = GetNonDominatedParticles(Archive);

        for i = 1:numel(Archive)
            [Archive(i).GridIndex, Archive(i).GridSubIndex] = GetGridIndex(Archive(i), G);
        end

        if numel(Archive) > Archive_size
            EXTRA = numel(Archive) - Archive_size;
            Archive = DeleteFromRep(Archive, EXTRA, gam1);

            Archive_costs = GetCosts(Archive);
            G = CreateHypercubes(Archive_costs, nGrid, alpha_grid);
        end

        Archive = DetermineDomination(Archive);
        Archive = GetNonDominatedParticles(Archive);

        Population_costs = GetCosts(Population);
    end
end
