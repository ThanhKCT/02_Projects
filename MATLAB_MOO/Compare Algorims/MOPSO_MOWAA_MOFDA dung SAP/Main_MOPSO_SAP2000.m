function [costs, Knee, elapsedSec] = Main_MOPSO_SAP2000(saveFileName)
% =========================================================================
% HÀM CHÍNH: Main_MOPSO_SAP2000
% Chạy 1 lần thuật toán MOPSO trên bài toán khung thép qua SAP2000.
%
% saveFileName (tùy chọn): tên file .mat lưu kết quả. Mặc định 'Data_MOPSO.mat'
% (giữ tương thích với Master_Controller.m / Plot_Results.m hiện có).
%
% --- SỬA: chuyển từ SCRIPT sang HÀM để có thể gọi lặp lại an toàn trong
% vòng lặp (VD: BatchRun_N.m chạy N lần độc lập) - workspace của hàm luôn
% độc lập với nơi gọi nó, không còn rủi ro "clear" xóa mất biến của vòng
% lặp bên ngoài như khi dùng run() với script (đã từng gây lỗi
% "Unrecognized variable 'VERBOSE_MASTER'" ở Master_Controller.m). ---
% =========================================================================
    if nargin < 1 || isempty(saveFileName)
        saveFileName = 'Data_MOPSO.mat';
    end
    tic;
    VERBOSE = false;  % --- SỬA: đặt true nếu muốn xem lại log tiến trình trên Command Window

    % --- LIÊN KẾT THƯ MỤC LÕI MOPSO ---
    addpath(fullfile(pwd, 'MOPSO'));
    if VERBOSE, disp('=> Đã liên kết thành công với thư mục lõi MOPSO.'); end

    %% 1. KHỞI ĐỘNG VÀ KẾT NỐI SAP2000
    [SapObject, Smdl] = SapStart(VERBOSE);

    %% 2. CẤU HÌNH THAM SỐ MOPSO
    [nVar, VarMin, VarMax] = ProblemDefinition();
    [nPop, nArchive, MaxNFE] = CommonAlgParams();
    MaxIt = round(MaxNFE / nPop) - 1;    % Ngân sách NFE chung cho cả 3 thuật toán (xem CommonAlgParams.m)
    w = 0.4; c1 = 1.5; c2 = 1.5;

    %% 3. KHỞI TẠO BẦY ĐÀN
    empty_particle.Position = []; empty_particle.Velocity = [];
    empty_particle.Cost = []; empty_particle.Best.Position = []; empty_particle.Best.Cost = [];
    particle = repmat(empty_particle, nPop, 1);
    Archive = [];

    if VERBOSE, disp('2. Đang tính toán khởi tạo bầy đàn MOPSO...'); end
    for i = 1:nPop
        particle(i).Position = VarMin + rand(1, nVar) .* (VarMax - VarMin);
        particle(i).Velocity = zeros(1, nVar);
        particle(i).Cost = RunSapAnalysis(Smdl, particle(i).Position);
        particle(i).Best.Position = particle(i).Position;
        particle(i).Best.Cost = particle(i).Cost;
        if IsNonDominated(particle(i), Archive)
            Archive = [Archive; particle(i)]; %#ok<AGROW>
        end
    end
    Archive = FilterArchive(Archive);

    costs = []; Knee = [];
    % --- bọc toàn bộ vòng lặp tiến hóa trong try/catch để đảm bảo khối
    % đóng SAP2000 ở cuối luôn được thực thi, kể cả khi có lỗi ---
    try
        %% 4. VÒNG LẶP TIẾN HÓA
        if VERBOSE, disp('3. Bắt đầu tiến hóa MOPSO...'); end
        for it = 1:MaxIt
            for i = 1:nPop
                % --- SỬA: bảo vệ trường hợp Archive rỗng (tránh randi(0) lỗi) ---
                if isempty(Archive)
                    gBest = particle(i).Best;
                else
                    leader_idx = randi(numel(Archive)); gBest = Archive(leader_idx);
                end
                particle(i).Velocity = w * particle(i).Velocity + c1 * rand(1, nVar) .* (particle(i).Best.Position - particle(i).Position) + c2 * rand(1, nVar) .* (gBest.Position - particle(i).Position);
                particle(i).Position = min(max(particle(i).Position + particle(i).Velocity, VarMin), VarMax);
                particle(i).Cost = RunSapAnalysis(Smdl, particle(i).Position);

                if Dominates(particle(i), particle(i).Best)
                    particle(i).Best.Position = particle(i).Position; particle(i).Best.Cost = particle(i).Cost;
                elseif ~Dominates(particle(i).Best, particle(i)) && rand < 0.5
                    particle(i).Best.Position = particle(i).Position; particle(i).Best.Cost = particle(i).Cost;
                end
                if IsNonDominated(particle(i), Archive)
                    Archive = [Archive; particle(i)]; %#ok<AGROW>
                end
            end
            Archive = FilterArchive(Archive);
            if numel(Archive) > nArchive, Archive = Archive(1:nArchive); end
            if VERBOSE, disp(['=> MOPSO Vòng ', num2str(it), '/', num2str(MaxIt), ' - Giải pháp Pareto: ', num2str(numel(Archive))]); end
        end

        %% 5. LƯU KẾT QUẢ
        costs_MOPSO = cat(1, Archive.Cost);
        Knee_MOPSO = ComputeKneePoint(costs_MOPSO);
        costs = costs_MOPSO; Knee = Knee_MOPSO;

        save(saveFileName, 'costs_MOPSO', 'Knee_MOPSO');

    catch ME_main
        disp(['=> LỖI trong quá trình tiến hóa MOPSO: ', ME_main.message]);
    end

    %% 6. ĐÓNG KẾT NỐI VÀ GIẢI PHÓNG BỘ NHỚ SAP2000 AN TOÀN
    SapStop(SapObject, VERBOSE);
    elapsedSec = toc;
    disp(['Hoàn thành MOPSO. Tổng thời gian: ', num2str(elapsedSec), 's.']);
end
