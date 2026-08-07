function [costs, Knee, elapsedSec] = Main_MOWAA_SAP2000(saveFileName)
% =========================================================================
% HÀM CHÍNH: Main_MOWAA_SAP2000
% Chạy 1 lần thuật toán MOWAA trên bài toán khung thép qua SAP2000.
%
% saveFileName (tùy chọn): tên file .mat lưu kết quả. Mặc định 'Data_MOWAA.mat'
% (giữ tương thích với Master_Controller.m / Plot_Results.m hiện có).
%
% --- SỬA: chuyển từ SCRIPT sang HÀM để có thể gọi lặp lại an toàn trong
% vòng lặp (VD: BatchRun_N.m chạy N lần độc lập) - xem giải thích chi tiết
% trong Main_MOPSO_SAP2000.m. ---
% =========================================================================
    if nargin < 1 || isempty(saveFileName)
        saveFileName = 'Data_MOWAA.mat';
    end
    tic;
    VERBOSE = false;  % --- SỬA: đặt true nếu muốn xem lại log tiến trình trên Command Window

    % --- LIÊN KẾT THƯ MỤC LÕI MOWAA ---
    addpath(fullfile(pwd, 'MOWAA'));
    if VERBOSE, disp('=> Đã liên kết thành công với thư mục lõi MOWAA.'); end

    %% 1. KHỞI ĐỘNG VÀ KẾT NỐI SAP2000
    [SapObject, Smdl] = SapStart(VERBOSE);

    %% 2. CẤU HÌNH THAM SỐ MOWAA
    [nVar, VarMin, VarMax] = ProblemDefinition();
    lb = VarMin; ub = VarMax;
    [Population_num, Archive_size, MaxNFE] = CommonAlgParams();
    MaxIt = round(MaxNFE / Population_num) - 1;    % Ngân sách NFE chung cho cả 3 thuật toán (xem CommonAlgParams.m)
    alpha = 0.1; nGrid = 10; beta = 4; gamma1 = 2;

    %% 3. KHỞI TẠO BẦY ĐÀN MOWAA
    if VERBOSE, disp('2. Đang khởi tạo bầy đàn MOWAA...'); end
    Population = CreateEmptyParticle(Population_num);
    Population_personalbest = CreateEmptyParticle(Population_num);
    for i = 1:Population_num
        Population(i).Velocity = 0;
        Population(i).Position = VarMin + rand(1, nVar) .* (VarMax - VarMin);
        Population(i).Cost = RunSapAnalysis(Smdl, Population(i).Position);
        Population(i).Best.Position = Population(i).Position;
        Population(i).Best.Cost = Population(i).Cost;
    end
    Population = DetermineDomination(Population); Archive = GetNonDominatedParticles(Population);
    Archive_costs = GetCosts(Archive); Population_costs = GetCosts(Population);
    G = CreateHypercubes(Archive_costs, nGrid, alpha);
    for i = 1:numel(Archive), [Archive(i).GridIndex, Archive(i).GridSubIndex] = GetGridIndex(Archive(i), G); end

    costs = []; Knee = [];
    % --- SỬA: bọc toàn bộ vòng lặp chính trong try/catch để đảm bảo SAP2000
    % luôn được đóng dù có lỗi giữa chừng ---
    try
        %% 4. VÒNG LẶP CHÍNH MOWAA
        if VERBOSE, disp('3. Bắt đầu quá trình tiến hóa MOWAA...'); end
        for it = 1:MaxIt
            % --- SỬA: reset các biến tích lũy Cost/Cost2/max_Cost/min_Cost mỗi
            % vòng lặp "it". Bản gốc không clear nên nếu kích thước Population
            % thay đổi hoặc n thay đổi giữa các vòng, dữ liệu cũ có thể còn sót lại. ---
            clear Cost Cost2 max_Cost min_Cost Population_tem_Position Best_X

            for i1 = 1:numel(Population), Cost(i1,:) = Population_costs(:, i1); end
            for i2 = 1:min(size(Cost)), max_Cost(i2) = max(Cost(:, i2)); min_Cost(i2) = min(Cost(:, i2)); end

            % --- SỬA: ép n thành số nguyên hợp lệ (round + giới hạn trong [1, numel(Population)]) ---
            n = round((numel(Population)-4) * (it-1) / (1-MaxIt) + numel(Population));
            n = max(1, min(n, numel(Population)));

            for i3 = 1:n
                for i2 = 1:min(size(Cost)), Cost2(i3,i2) = (Cost(i3,i2) - min_Cost(1,i2)) / (max_Cost(1,i2) - min_Cost(1,i2) + eps); end
            end
            Cost3 = sum(Cost2, 2); miu = zeros(1, nVar); sum_Cost = sum(Cost3);
            for i = 1:n, miu(1,:) = miu(1,:) + Population(i).Position * (sum_Cost - Cost3(i)) / (sum_Cost * (n - 1) + eps); end

            for i = 1:Population_num
                Best_X(1,:) = SelectLeader(Archive, beta);
                k1 = (10*rand-1) * sin(pi*it/MaxIt); k2 = randi([1,3], 1, 1); k3 = rand;
               if k1 < 0.5
                    switch k2
                        case 1
                           for j = 1:nVar
                               beta_levy = 1.5 + rand*0.5;
                               sigma1 = (gamma(1+beta_levy)*sin(pi*beta_levy/2) / ...
                                        (beta_levy*gamma(0.5+0.5*beta_levy)*2^(0.5*beta_levy-0.5)))^(1/beta_levy);

                               % --- SỬA LỖI TẠI ĐÂY: Dùng randn() thay vì normrnd() để tương thích mọi máy ---
                               numerator = sigma1 * randn();
                               denominator = abs(randn());
                               levy = numerator / (denominator^(1/beta_levy));

                               Population_tem_Position(1,j) = Best_X.Position(1,j) + levy;
                           end
                           Population(i).Position = Population_tem_Position;
                        case 2
                           % --- SỬA: Archive là mảng cột (Nx1) nên phải dùng size(Archive,1)
                           % cho cả parent1 và parent2. Bản gốc dùng size(Archive,2) cho parent1
                           % (luôn = 1) khiến parent1 luôn là phần tử đầu tiên, mất tính ngẫu nhiên. ---
                           parent1 = Archive(randi([1, size(Archive, 1)])).Position; parent2 = Archive(randi([1, size(Archive, 1)])).Position;
                           crossoverPoint = randi([1, numel(parent1)]); Population(i).Position = [parent1(1:crossoverPoint), parent2(crossoverPoint+1:end)];
                        case 3
                          parent = Archive(randi([1, size(Archive, 1)])).Position; Population(i).Position = parent + rand(1, numel(parent)) * 0.1;
                    end
                else
                    switch k2
                      case 1, Population(i).Position = rand*(miu(1,:) - Best_X(1,:).Position) + rand*(miu(1,:) - Population(i).Best.Position) + rand*miu(1,:);
                      case 2, Population(i).Position = rand*(miu(1,:) - Best_X(1,:).Position) + rand*Best_X(1,:).Position;
                      case 3, Population(i).Position = rand*(miu(1,:) - Population(i).Best.Position) + rand*Population(i).Best.Position;
                    end
                end
                Population(i).Position = min(max(Population(i).Position, lb), ub);
                Population(i).Cost = RunSapAnalysis(Smdl, Population(i).Position);
                if (sum(dominates1(Population(i).Cost, Population(i).Best.Cost)) >= 1)
                    Population(i).Best.Position = Population(i).Position; Population(i).Best.Cost = Population(i).Cost;
                end
            end

            for i = 1:Population_num
              Population_personalbest(i).Position = Population(i).Best.Position;
              Population_personalbest(i).Cost = Population(i).Best.Cost; Population_personalbest(i).Velocity = 0;
            end
            non_dominated_wolves1 = GetNonDominatedParticles(DetermineDomination(Population_personalbest));
            non_dominated_wolves = GetNonDominatedParticles(DetermineDomination(Population));
            Archive = GetNonDominatedParticles(DetermineDomination([Archive(:); non_dominated_wolves(:); non_dominated_wolves1(:)].'));
            for i = 1:numel(Archive), [Archive(i).GridIndex, Archive(i).GridSubIndex] = GetGridIndex(Archive(i), G); end
            if numel(Archive) > Archive_size
                Archive = DeleteFromRep(Archive, numel(Archive) - Archive_size, gamma1);
                G = CreateHypercubes(GetCosts(Archive), nGrid, alpha);
            end
            if VERBOSE, disp(['=> MOWAA Vòng ', num2str(it), '/', num2str(MaxIt), ' - Giải pháp Pareto: ' num2str(numel(Archive))]); end
            Population_costs = GetCosts(Population);
        end

        %% 5. LƯU KẾT QUẢ
        costs_MOWAA = GetCosts(Archive)';
        Knee_MOWAA = ComputeKneePoint(costs_MOWAA);
        costs = costs_MOWAA; Knee = Knee_MOWAA;

        save(saveFileName, 'costs_MOWAA', 'Knee_MOWAA');

    catch ME_main
        disp(['=> LỖI trong quá trình tiến hóa MOWAA: ', ME_main.message]);
    end

    %% 6. ĐÓNG KẾT NỐI VÀ GIẢI PHÓNG BỘ NHỚ SAP2000 AN TOÀN
    SapStop(SapObject, VERBOSE);
    elapsedSec = toc;
    disp(['Hoàn thành MOWAA. Tổng thời gian: ', num2str(elapsedSec), 's.']);
end
