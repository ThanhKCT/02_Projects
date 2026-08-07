function [costs, Knee, elapsedSec] = Main_MOFDA_SAP2000(saveFileName)
% =========================================================================
% HÀM CHÍNH: Main_MOFDA_SAP2000
% Chạy 1 lần thuật toán MOFDA trên bài toán khung thép qua SAP2000.
%
% saveFileName (tùy chọn): tên file .mat lưu kết quả. Mặc định 'Data_MOFDA.mat'
% (giữ tương thích với Master_Controller.m / Plot_Results.m hiện có).
%
% --- SỬA: chuyển từ SCRIPT sang HÀM để có thể gọi lặp lại an toàn trong
% vòng lặp (VD: BatchRun_N.m chạy N lần độc lập) - xem giải thích chi tiết
% trong Main_MOPSO_SAP2000.m. ---
% =========================================================================
    if nargin < 1 || isempty(saveFileName)
        saveFileName = 'Data_MOFDA.mat';
    end
    tic;
    VERBOSE = false;  % --- SỬA: đặt true nếu muốn xem lại log tiến trình trên Command Window

    % --- LIÊN KẾT THƯ MỤC LÕI MOFDA ---
    % (Bạn đảm bảo các tệp con của MOFDA được đặt trong thư mục tên là 'MOFDA')
    addpath(fullfile(pwd, 'MOFDA'));
    if VERBOSE, disp('=> Đã liên kết thành công với thư mục lõi MOFDA.'); end

    %% 1. KHỞI ĐỘNG VÀ KẾT NỐI SAP2000
    [SapObject, Smdl] = SapStart(VERBOSE);

    %% 2. CẤU HÌNH THAM SỐ MOFDA
    [nVar, VarMin, VarMax] = ProblemDefinition();
    lb = VarMin; ub = VarMax;
    [~, Archive_size, MaxNFE] = CommonAlgParams();

    % beta_dim = số hướng lân cận mà mỗi cá thể khám phá mỗi vòng lặp (đặc thù
    % thuật toán FDA, không phải "tham số ngân sách" nên giữ cố định = 4).
    %
    % --- SỬA: GIỮ NGUYÊN max_iter = 50 (đúng nhịp gốc, khớp số vòng lặp của
    % MOPSO/MOWAA) vì nhịp thăm dò/khai thác của MOFDA (biến "delta" bên dưới)
    % phụ thuộc vào TỶ LỆ iter/max_iter, chứ không phải số vòng lặp tuyệt đối.
    % GIẢM SỐ CÁ THỂ (alpha_pop) để bù lại ngân sách NFE - vẫn đảm bảo công
    % bằng về tổng số lần gọi SAP2000, nhưng không phá vỡ lịch trình thăm dò
    % đặc trưng của thuật toán. ---
    beta_dim = 4;
    max_iter = 50;
    alpha_pop = round(MaxNFE / (1 + max_iter * (beta_dim + 1)));
    Alpha_Grid = 0.1; nGrid = 10; Beta_Leader = 4; gamma_del = 2;

    %% 3. KHỞI TẠO BẦY ĐÀN MOFDA
    if VERBOSE, disp('2. Đang khởi tạo bầy đàn MOFDA...'); end
    empty_flow.Position = [];
    empty_flow.Cost = [];
    empty_flow.Velocity = [];
    empty_flow.GridIndex = [];
    empty_flow.GridSubIndex = [];
    flow_x = repmat(empty_flow, alpha_pop, 1);

    for i = 1:alpha_pop
        flow_x(i).Velocity = 0;
        flow_x(i).Position = VarMin + rand(1, nVar) .* (VarMax - VarMin);
        flow_x(i).Cost = RunSapAnalysis(Smdl, flow_x(i).Position);
    end

    flow_x = DetermineDominations(flow_x);
    Archive = GetNonDominatedParticles(flow_x);
    Archive_costs = GetCosts(Archive);
    G = CreateHypercubes(Archive_costs, nGrid, Alpha_Grid);

    for i = 1:numel(Archive)
        [Archive(i).GridIndex, Archive(i).GridSubIndex] = GetGridIndex(Archive(i), G);
    end

    Vmax = max(0.1 * (VarMax - VarMin));
    Vmin = min(-0.1 * (VarMax - VarMin));

    costs = []; Knee = [];
    %% 4. VÒNG LẶP TIẾN HÓA MOFDA
    % --- SỬA: bọc toàn bộ vòng lặp trong try/catch để đảm bảo SAP2000 luôn
    % được đóng và giải phóng bộ nhớ, kể cả khi có lỗi giữa chừng (VD: RunSapAnalysis
    % ném lỗi không mong muốn, mất kết nối COM, v.v.) ---
    try
        if VERBOSE, disp('3. Bắt đầu quá trình tiến hóa MOFDA...'); end
        for iter = 1:max_iter
            Leader = SelectLeader(Archive, Beta_Leader);
            delta = (((1 - 1*iter/max_iter + eps)^(2*randn)) .* (rand(1, nVar) .* iter/max_iter) .* rand(1, nVar));

            for i = 1:alpha_pop
                neighbor_x = repmat(empty_flow, beta_dim, 1);
                Funeval = zeros(beta_dim, 1);

                for j = 1:beta_dim
                    Xrand = VarMin + rand(1, nVar) .* (VarMax - VarMin);
                    neighbor_x(j).Position = flow_x(i).Position + randn(1, nVar) .* delta .* (rand*Xrand - rand*flow_x(i).Position) .* norm(Leader.Position - flow_x(i).Position);

                    % Giới hạn biên
                    neighbor_x(j).Position = max(neighbor_x(j).Position, VarMin);
                    neighbor_x(j).Position = min(neighbor_x(j).Position, VarMax);

                    % Đánh giá hàng xóm
                    neighbor_x(j).Cost = RunSapAnalysis(Smdl, neighbor_x(j).Position);
                    Funeval(j) = norm(neighbor_x(j).Cost);
                end

                [~, indx] = sort(Funeval);

                % Chuyển hướng
                if norm(neighbor_x(indx(1)).Cost) < norm(flow_x(i).Cost)
                    Sf = (norm(neighbor_x(indx(1)).Cost) - norm(flow_x(i).Cost)) / sqrt(norm(neighbor_x(indx(1)).Position - flow_x(i).Position));
                    V = randn * (norm(Sf));
                    % --- SỬA: clamp vận tốc theo đúng biên (bản gốc gán V=-Vmin/-Vmax
                    % làm đảo dấu V khi vượt biên, không phải phép clamp chuẩn) ---
                    if V < Vmin
                        V = Vmin;
                    elseif V > Vmax
                        V = Vmax;
                    end

                    flow_x(i).Position = flow_x(i).Position + V .* (neighbor_x(indx(1)).Position - flow_x(i).Position) / sqrt(norm(neighbor_x(indx(1)).Position - flow_x(i).Position));
                else
                    r = randi([1 alpha_pop]);
                    if norm(flow_x(r).Cost) <= norm(flow_x(i).Cost)
                        flow_x(i).Position = flow_x(i).Position + randn(1, nVar) .* (flow_x(r).Position - flow_x(i).Position);
                    else
                        flow_x(i).Position = flow_x(i).Position + randn * (Leader.Position - flow_x(i).Position);
                    end
                end

                flow_x(i).Position = max(flow_x(i).Position, VarMin);
                flow_x(i).Position = min(flow_x(i).Position, VarMax);
                flow_x(i).Cost = RunSapAnalysis(Smdl, flow_x(i).Position);
            end

            % Cập nhật Archive
            flow_x = DetermineDominations(flow_x);
            non_dominated_flow_x = GetNonDominatedParticles(flow_x);
            Archive = [Archive; non_dominated_flow_x];
            Archive = DetermineDominations(Archive);
            Archive = GetNonDominatedParticles(Archive);

            for i = 1:numel(Archive)
                [Archive(i).GridIndex, Archive(i).GridSubIndex] = GetGridIndex(Archive(i), G);
            end

            if numel(Archive) > Archive_size
                EXTRA = numel(Archive) - Archive_size;
                Archive = DeleteFromRep(Archive, EXTRA, gamma_del);
                Archive_costs = GetCosts(Archive);
                G = CreateHypercubes(Archive_costs, nGrid, Alpha_Grid);
            end

            if VERBOSE, disp(['=> MOFDA Vòng ', num2str(iter), '/', num2str(max_iter), ' - Giải pháp Pareto: ', num2str(numel(Archive))]); end
        end

        %% 5. LƯU KẾT QUẢ
        costs_MOFDA = GetCosts(Archive)';
        Knee_MOFDA = ComputeKneePoint(costs_MOFDA);
        costs = costs_MOFDA; Knee = Knee_MOFDA;

        save(saveFileName, 'costs_MOFDA', 'Knee_MOFDA');

    catch ME_main
        disp(['=> LỖI trong quá trình tiến hóa MOFDA: ', ME_main.message]);
    end

    %% 6. ĐÓNG KẾT NỐI VÀ GIẢI PHÓNG BỘ NHỚ SAP2000 AN TOÀN
    % --- SỬA: khối này giờ luôn chạy dù bước 4-5 có lỗi hay không, nhờ nằm
    % ngoài try/catch phía trên (không phải trong try đó) ---
    SapStop(SapObject, VERBOSE);
    elapsedSec = toc;
    disp(['Hoàn thành MOFDA. Tổng thời gian: ', num2str(elapsedSec), 's.']);
end
