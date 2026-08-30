function cfg = wharf100dwt_config()
% =========================================================================
% CẤU HÌNH BÀI TOÁN MOO — Tối ưu tiết diện cọc cầu tàu 100.000 DWT (MOFDA)
% Mọi con số/giả thiết ở đây đều dẫn nguồn tới
% DE_CUONG_BAI_BAO_MOFDA_CAU_TAU_100000DWT.md (đề cương bài báo) — sửa cả
% hai nơi nếu thay đổi bất kỳ giá trị nào.
% =========================================================================

%% --- Đường dẫn SAP2000 ---
cfg.sap.programPath = 'C:\Program Files\Computers and Structures\SAP2000 24\SAP2000.exe';
cfg.sap.apiDllPath  = 'C:\Program Files\Computers and Structures\SAP2000 24\SAP2000v1.dll';
cfg.sap.modelPath   = fullfile(fileparts(fileparts(mfilename('fullpath'))), 'Sap', 'Ben100kDWT_sensitivity.sdb');
% (fileparts(fileparts(...))) => .../MOFDA/Sap/Ben100kDWT_sensitivity.sdb
% Đơn vị làm việc của model gốc: Tonf, m, C (KHÔNG đổi units — giữ nguyên
% để không phải quy đổi lò xo nền/tải trọng đã gán trong .sdb).

%% --- Tổ hợp tải dùng cho f2 + toàn bộ ràng buộc (đã chốt) ---
% "BAO KT" = Envelope có sẵn trong model, bao 35/36 tổ hợp cơ bản (trừ
% "BAO (storm)"). Đã chốt dùng riêng combo này để tăng tốc — xem mục 5.4.1,
% 9.3 trong đề cương. *** BẮT BUỘC chạy wharf100dwt_fix_comb62.m 1 LẦN
% trước khi chạy campaign đầu tiên *** để sửa COMB6.2 (đang trùng COMB6.1
% trong hồ sơ gốc) thành BT+MT+Neo1+HH2 — nếu chưa chạy, "BAO KT" vẫn bao
% gồm COMB6.2 ở dạng CHƯA sửa (trùng lặp, thiếu tổ hợp Neo1+HH2). Xem
% README.md.
cfg.sap.comboEnvelope = 'BAO KT';

%% --- Tên tiết diện / vật liệu cọc trong SAP2000 (khớp .$2k đã đọc) ---
cfg.sections.btctName  = 'COCBTCT';
cfg.sections.matBTCT   = 'Be tong M800';
cfg.sections.thepName  = 'COCTHEP';
cfg.sections.matThep   = 'Coc thep';

%% --- Biến thiết kế — ĐÃ CHỐT LẠI (3 biến, cả 2 loại cọc đều RỜI RẠC) ---
% x = [CatIdx_BTCT, D_thep, t_thep]
%
% BIẾN 1 — CatIdx_BTCT: chỉ số hàng trong catalogue AMACCAO (mục 6.1a,
% wharf100dwt_catalogue_btct.m) — 3 lựa chọn: 1=D700(t110mm), 2=D800(t120mm),
% 3=D900(t130mm). D và t của BTCT KHÔNG còn là 2 biến độc lập — mỗi D trong
% catalogue đi kèm đúng 1 t cố định, không tự do tổ hợp. MOFDA đề xuất giá
% trị liên tục trong [1,3] rồi làm tròn về số nguyên gần nhất (round, không
% phải floor/ceil) để chọn dòng catalogue.
%
% BIẾN 2,3 — D_thep, t_thep: KHÔNG có catalogue thật cho cọc ống thép (bản
% vẽ hiện có chỉ có cọc BTCT DƯL) — rời rạc hoá bằng LƯỚI CỐ ĐỊNH (đã chốt
% với người dùng): D_thep bước 25mm, t_thep bước 1mm, trong dải TCVN
% 9245:2012/JIS A5525 tham chiếu (D 318,5-2000mm, t 6,9-25mm — miền nghiên
% cứu 0,90-1,10/0,012-0,020m nằm trọn trong dải này).
cfg.bounds.lb = [1,    0.90,  0.012];
cfg.bounds.ub = [3,    1.10,  0.020];
cfg.bounds.names = {'CatIdx_BTCT','D_thep','t_thep'};
cfg.bounds.roundStep = [1, 0.025, 0.001]; % [chi so nguyen, 25mm, 1mm]

%% --- Vật liệu / khối lượng riêng (T/m^3) ---
% ĐÃ KIỂM TRA TRỰC TIẾP bảng "MATERIAL PROPERTIES 02 - BASIC MECHANICAL
% PROPERTIES" trong Sap/Ben100kDWT_sensitivity.$2k:
%   Be tong M400: UnitWeight=2.5        Be tong M800: UnitWeight=0
%   Coc thep    : UnitWeight=0          A992Fy50/A615Gr60/A416Gr270: UnitWeight=7.849...
% => Bản thân model SAP KHÔNG có gamma dùng được cho "Be tong M800" và
% "Coc thep" (đều =0 -- khối tự trọng của CỌC không được tính trong tải BT
% của model gốc, có thể chủ đích vì cọc chủ yếu nằm trong đất/nước, không
% phải sai sót ta gây ra). Vì vậy KHÔNG lấy gamma từ model cho 2 vật liệu
% cọc -- dùng giá trị kỹ thuật tiêu chuẩn:
%   - gammaConcrete = 2,5 T/m^3: khối lượng riêng BTCT thông thường
%     (TCVN 2737:1995) KHÔNG phụ thuộc đáng kể vào mác bê tông (M400 hay
%     M800 cùng loại bê tông thường, chỉ khác hàm lượng xi măng/tỷ lệ N/X,
%     không phải bê tông nhẹ) -- khớp đúng giá trị M400 trong CHÍNH model
%     này, không phải "mượn tạm" mà là đặc tính vật lý chung của bê tông
%     thường bất kể mác. Đủ căn cứ để dùng, không cần coi là giả thiết yếu.
%   - gammaSteel = 7,85 T/m^3: khớp với UnitWeight=7,849... của các vật
%     liệu thép khác (A992Fy50...) trong CHÍNH model này -- xác nhận hợp lý.
cfg.material.gammaConcrete = 2.5;   % T/m^3 -- xem căn cứ ở trên
cfg.material.gammaSteel    = 7.85;  % T/m^3 -- khớp UnitWeight thép trong model

%% --- Fy thép cọc (đã chốt) ---
% 3.150 kG/cm^2 (theo bản vẽ/TCVN 9245:2012), KHÔNG dùng 2.531 kG/cm^2 của
% bảng vật liệu phi tuyến SAP. Quy đổi sang T/m^2 (đơn vị model):
% 1 kG/cm^2 = 10 T/m^2 (=> 1 kgf/cm^2 = 10^4 kgf/m^2 = 10 tonf/m^2)
cfg.material.Fy_thep_kGcm2 = 3150;
cfg.material.Fy_thep_Tm2   = cfg.material.Fy_thep_kGcm2 * 10; % = 31500 T/m^2
cfg.material.gammaM_thep   = 1.05; % hệ số an toàn vật liệu thép, TCVN 5575:2024 -- GIẢ THIẾT, cần đối chiếu lại

%% --- Sức kháng cọc BTCT: ĐÃ CHỐT LẠI — tra catalogue AMACCAO thật ---
% Thay cho cách quy đổi tỷ lệ từ neo D800-540 (bản cũ) — giờ dùng trực tiếp
% Mcr/Mu/Pvl thật của catalogue AMACCAO (Class A) qua CatIdx_BTCT, xem
% wharf100dwt_catalogue_btct.m và wharf100dwt_pile_capacity_btct.m.
% cfg.btctAnchor GIỮ LẠI CHỈ ĐỂ THAM KHẢO LỊCH SỬ (neo cũ từ thiết kế gốc
% D800-540, t=130mm, hồ sơ Lạch Huyện — KHÔNG dùng nữa trong evaluate()).
cfg.btctAnchor.D0    = 0.80;   % m -- KHONG CON DUNG, chi de tham khao
cfg.btctAnchor.t0    = 0.13;   % m
cfg.btctAnchor.Mcr0  = 67.4;   % T.m
cfg.btctAnchor.Mu0   = 134.8;  % T.m
cfg.btctAnchor.Pmax0 = 658;    % T

%% --- Giới hạn chuyển vị ngang cho phép (đã chốt) ---
% TCVN 11820-5:2021, Điều 8.9, Bảng 12: phương ngang, "đỉnh bến trên nền
% cọc" -> 1/300 chiều cao bến, không vượt quá 100mm. H = đỉnh bến(+5,50) -
% đáy bến hoàn thiện(-16,0) = 21,5 m (GIẢ THIẾT về định nghĩa "chiều cao
% bến" -- cần xác nhận lại định nghĩa chính thức trong TCVN, xem đề cương
% mục 18). H/300 = 71,7mm < trần 100mm => giá trị chi phối là 71,7mm.
cfg.limits.H_ben_m      = 5.50 - (-16.0); % = 21.5 m
cfg.limits.dU_allow_m   = min(cfg.limits.H_ben_m / 300, 0.100); % = 0.0717 m

%% --- Số lượng & chiều dài chế tạo cọc (cho f1 = khối lượng vật lý) ---
% Chiều dài CHẾ TẠO THỰC TẾ (không phải chiều dài mô hình SAP đến điểm ngàm
% ảo). "Bang toa do coc.xls" ĐÃ KIỂM TRA — chỉ chứa toạ độ mặt bằng (x,y),
% KHÔNG có chiều dài cọc, không dùng được.
%
% CỌC BTCT — ĐÃ XÁC NHẬN bằng bản vẽ chế tạo thật "01..09. Coc DUL.dxf"
% (đọc bằng ezdxf): có đúng 7 SHEET chi tiết ứng với 7 chiều dài chế tạo
% tiêu chuẩn CÓ THẬT của cọc D800-540: 28, 29, 30, 31, 32, 34, 37 m (không
% liên tục — không có 33/35/36m). Bản vẽ này CÒN xác nhận chéo (khớp
% chính xác 100%) 3 giá trị neo capacity đã dùng ở cfg.btctAnchor:
% Mcr=67,40 T.m, Mu=134,80 T.m, Pmax=658 T — tăng độ tin cậy cho cả 2 nơi
% dùng chung neo này. KHÔNG tìm thấy khối lượng riêng (gamma) bê tông M800
% trong bản vẽ này (vẫn dùng giả thiết 2,5 T/m^3 ở cfg.material).
%
% CỌC THÉP D1016 — CHƯA có bản vẽ chế tạo riêng (bản vẽ hiện có chỉ là cọc
% BTCT DƯL) — miền chiều dài chế tạo [28,32]m VẪN LÀ GIẢ THIẾT CHƯA XÁC
% NHẬN như trước, không phải dữ liệu thật.
%
% Cách tính (pile_length_table.csv đi kèm thư mục này): quy đổi TUYẾN TÍNH
% (affine) từ fem_length_m THẬT của từng cọc (132 BTCT + 60 thép, trích từ
% pile_master_table.csv — kết quả đã có của Paper 1, cùng mô hình FEM gốc)
% sao cho khớp đúng min/max của dải chiều dài chế tạo:
%   BTCT (đã xác nhận): fem_length in [20,23 ; 28,20] m -> Lfab in [28 ; 37] m
%   Thép (CHƯA xác nhận): fem_length in [24,78 ; 28,90] m -> Lfab in [28 ; 32] m
% Đây VẪN LÀ PHÉP NỘI SUY LIÊN TỤC (không snap về đúng 7 giá trị rời rạc
% của BTCT — thử snap rời rạc cho kết quả dồn cục bất thường tại 34m do
% khoảng cách không đều giữa các chiều dài tiêu chuẩn, kém tin cậy hơn nội
% suy liên tục) -- mỗi cọc vẫn nhận 1 giá trị xấp xỉ, không phải 1 trong 7
% giá trị thật. Cải thiện thật sự ở đây là ĐÃ SỬA đúng biên min/max của
% BTCT (37m, không phải 34m như trước — 34m từng bị hiểu nhầm là biên
% trên trong khi thực ra chỉ là 1 trong 7 chiều dài, không phải max thật).
cfg.pile.nBTCT = 132;
cfg.pile.nThep = 60;

pileLenCsv = fullfile(fileparts(mfilename('fullpath')), 'pile_length_table.csv');
if isfile(pileLenCsv)
    % SỬA: KHÔNG dùng readtable() -- đã kiểm chứng thật trên máy này rằng
    % readtable(...,'TextType','string') làm SẬP TOÀN BỘ tiến trình MATLAB
    % (crash cứng ở tầng engine, không phải lỗi bắt được bằng try/catch)
    % khi đọc đúng file CSV này trên bản MATLAB R2023b cài trên máy. Đã cô
    % lập bằng chẩn đoán từng bước (fopen/fprintf/fclose flush ngay) và xác
    % nhận: mọi bước trước readtable() đều chạy tốt, MATLAB biến mất ngay
    % tại dòng readtable(), không in được cả thông báo lỗi. Thay bằng vòng
    % lặp fopen/fgetl/strsplit thủ công -- đã CHẠY THỬ THẬT, cho đúng kết
    % quả (nBTCT=132 sumBTCT=4243,042 nThep=60 sumThep=1806,835).
    fid = fopen(pileLenCsv, 'r');
    fgetl(fid); % bo qua dong header
    sumBTCT = 0; sumThep = 0; nBTCT = 0; nThep = 0;
    while ~feof(fid)
        line = fgetl(fid);
        if ischar(line) && ~isempty(line)
            parts = strsplit(line, ',');
            ptype = parts{2};
            lfab = str2double(parts{4});
            if strcmp(ptype, 'BTCT_D800')
                sumBTCT = sumBTCT + lfab; nBTCT = nBTCT + 1;
            elseif strcmp(ptype, 'Steel_D1016')
                sumThep = sumThep + lfab; nThep = nThep + 1;
            end
        end
    end
    fclose(fid);
    cfg.pile.sumLfab_BTCT_m = sumBTCT;
    cfg.pile.sumLfab_Thep_m = sumThep;
    assert(nBTCT == cfg.pile.nBTCT, 'pile_length_table.csv: so coc BTCT khong khop cfg.pile.nBTCT');
    assert(nThep == cfg.pile.nThep, 'pile_length_table.csv: so coc thep khong khop cfg.pile.nThep');
else
    warning('wharf100dwt_config:MissingPileLengthTable', ...
        'Khong tim thay %s -- dung fallback trung binh dai (kem chinh xac hon).', pileLenCsv);
    cfg.pile.sumLfab_BTCT_m = cfg.pile.nBTCT * mean([28, 34]);
    cfg.pile.sumLfab_Thep_m = cfg.pile.nThep * mean([28, 32]);
end

%% --- Xử lý ràng buộc: penalty function nhân (đã chốt) ---
cfg.penalty.C_init = 10; % hiệu chỉnh qua pilot trước khi chạy campaign chính

%% --- Tham số MOFDA (điều chỉnh theo runMode ở script gọi) ---
cfg.algo.beta = 4;    % số hướng lân cận mỗi cá thể khám phá mỗi vòng lặp (đặc thù FDA)
cfg.algo.nGrid = 10;  % số lưới hypercube cho repository

end
