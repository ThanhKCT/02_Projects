function Cost = RunSapAnalysis(Smdl, X)
% =========================================================================
% TỆP GIAO TIẾP VỚI SAP2000
% Mục đích: Mở mô hình, gán tiết diện, chạy phân tích và trích xuất dữ liệu thô
% =========================================================================
    Default_Penalty = [999.0, 999.0];
    VERBOSE_LOCAL = false;  % --- SỬA: đặt true nếu muốn xem lại cảnh báo/lỗi trên Command Window
    
    % Ràng buộc hình học sơ bộ (Cánh không được dày quá nửa chiều cao)
    if (X(3) >= X(2)/2) || (X(4) >= X(1)/2) || (X(7) >= X(6)/2) || (X(8) >= X(5)/2)
        Cost = Default_Penalty;
        return; 
    end
    
    try
        % 1. Mở khóa mô hình và gán tiết diện mới
        Smdl.SetModelIsLocked(false); 
        Smdl.PropFrame.SetISection('Cot2D', 'Steel', X(1), X(2), X(3), X(4), X(2), X(3));
        Smdl.PropFrame.SetISection('Dam2D', 'Steel', X(5), X(6), X(7), X(8), X(6), X(7));
        
        % 2. Chạy phân tích kết cấu trong SAP2000
        % --- SỬA: kiểm tra mã trả về của RunAnalysis, tránh đọc kết quả cũ/rỗng khi solver lỗi ---
        retAnalyze = Smdl.Analyze.RunAnalysis();
        if retAnalyze ~= 0
            if VERBOSE_LOCAL, disp('Cảnh báo: RunAnalysis() trả về lỗi (retAnalyze ~= 0). Bỏ qua phương án này.'); end
            Cost = Default_Penalty;
            return;
        end
        % --- SỬA: BỎ pause(0.5) - RunAnalysis() là lệnh ĐỒNG BỘ (blocking), SAP2000
        % đã giải xong hoàn toàn khi dòng lệnh trên trả về, nên pause ở đây chỉ lãng phí
        % thời gian (0.5s x hàng chục nghìn lần gọi = có thể tới vài giờ). Nếu sau khi bỏ
        % pause mà thấy kết quả JointDispl/FrameForce đôi khi rỗng/lỗi (rất hiếm, có thể do
        % COM chưa kịp đồng bộ trên một số máy), hãy thêm lại "pause(0.05)" (không phải 0.5).
        
        % 3. Trích xuất Chuyển vị đỉnh nút '2'
        NumResJD = 0;
        Obj_jd = NET.createArray('System.String', 0); Elm_jd = NET.createArray('System.String', 0);
        LoadCase_jd = NET.createArray('System.String', 0); StepType_jd = NET.createArray('System.String', 0);
        StepNum_jd = NET.createArray('System.Double', 0); U1_jd = NET.createArray('System.Double', 0);
        U2_jd = NET.createArray('System.Double', 0); U3_jd = NET.createArray('System.Double', 0);
        R1_jd = NET.createArray('System.Double', 0); R2_jd = NET.createArray('System.Double', 0); R3_jd = NET.createArray('System.Double', 0);
        
        [ret, ~, ~, ~, ~, ~, ~, U1, ~, ~, ~, ~, ~] = ...
            Smdl.Results.JointDispl('2', 0, NumResJD, Obj_jd, Elm_jd, LoadCase_jd, StepType_jd, StepNum_jd, U1_jd, U2_jd, U3_jd, R1_jd, R2_jd, R3_jd);
        
        if ret == 0 && ~isempty(U1)
            Real_Drift = abs(double(U1(1)));
            if isnan(Real_Drift) || isinf(Real_Drift), Real_Drift = 999; end
        else
            Real_Drift = 999; 
        end
        
        % 4. Trích xuất Nội lực Nhóm Cột (GROUP_COT)
        NumResFF = 0;
        Obj_ff = NET.createArray('System.String', 0); ObjSta = NET.createArray('System.Double', 0);
        Elm_ff = NET.createArray('System.String', 0); ElmSta = NET.createArray('System.Double', 0);
        LoadCase_ff = NET.createArray('System.String', 0); StepType_ff = NET.createArray('System.String', 0);
        StepNum_ff = NET.createArray('System.Double', 0); P_ff = NET.createArray('System.Double', 0);
        V2_ff = NET.createArray('System.Double', 0); V3_ff = NET.createArray('System.Double', 0);
        T_ff = NET.createArray('System.Double', 0); M2_ff = NET.createArray('System.Double', 0); M3_ff = NET.createArray('System.Double', 0);

        [retC, NumResC, ~, ~, ~, ~, ~, ~, ~, P_c, V2_c, ~, ~, ~, M3_c] = ...
            Smdl.Results.FrameForce('GROUP_COT', 2, NumResFF, Obj_ff, ObjSta, Elm_ff, ElmSta, LoadCase_ff, StepType_ff, StepNum_ff, P_ff, V2_ff, V3_ff, T_ff, M2_ff, M3_ff);
        
        % 5. Trích xuất Nội lực Nhóm Dầm (GROUP_DAM)
        [retD, NumResD, ~, ~, ~, ~, ~, ~, ~, P_d, V2_d, ~, ~, ~, M3_d] = ...
            Smdl.Results.FrameForce('GROUP_DAM', 2, NumResFF, Obj_ff, ObjSta, Elm_ff, ElmSta, LoadCase_ff, StepType_ff, StepNum_ff, P_ff, V2_ff, V3_ff, T_ff, M2_ff, M3_ff);
        
        % --- SỬA: nếu trích xuất nội lực thất bại (retC hoặc retD ~= 0) thì phạt thay vì đưa dữ liệu rỗng/cũ vào Check_TCVN5575 ---
        if retC ~= 0 || retD ~= 0 || NumResC == 0 || NumResD == 0
            if VERBOSE_LOCAL, disp('Cảnh báo: Không trích xuất được đầy đủ nội lực FrameForce. Bỏ qua phương án này.'); end
            Cost = Default_Penalty;
            return;
        end
            
        % 6. CHUYỂN TOÀN BỘ DỮ LIỆU SANG FILE TIÊU CHUẨN Check_TCVN5575 ĐỂ TÍNH TOÁN
        Cost = Check_TCVN5575(X, P_c, V2_c, M3_c, NumResC, P_d, V2_d, M3_d, NumResD, Real_Drift);
        
    catch ME
        disp(['Lỗi hệ thống tại SAP API: ', ME.message]);
        Cost = Default_Penalty;
    end
end
