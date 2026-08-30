# Phương án chạy campaign MOFDA↔SAP2000 — tài liệu tái sử dụng cho dự án mới

> Đúc kết từ dự án Wharf100DWT (cầu tàu 100.000 DWT). Copy nguyên file này vào dự án mới, sửa các chỗ đánh dấu `[SỬA]`. Đọc kèm `Cach ket noi_SAP2000_MATLAB_OPTIMIZATION.md` (kinh nghiệm gốc từ dự án SFOA) — file này bổ sung riêng phần MOFDA + quyết định brute-force-hay-metaheuristic.

## 0. Sơ đồ quyết định — LÀM TRƯỚC KHI CODE BẤT CỨ GÌ

```text
Xác định biến thiết kế + miền giá trị
        ↓
Rời rạc hoá theo catalogue thật (nếu có) hoặc lưới cố định
        ↓
Tính TỔNG SỐ TỔ HỢP KHẢ DĨ = tích số lựa chọn từng biến
        ↓
   Số tổ hợp ≤ vài nghìn?  ──── CÓ ───→ LIỆT KÊ TOÀN BỘ (brute-force)
        │                                 trước, cho mặt Pareto THẬT
        KHÔNG                             (đúng 100%, nhanh hơn hẳn)
        ↓
Không gian liên tục/quá lớn để liệt kê
        ↓
Dùng MOFDA (hoặc metaheuristic khác) làm công cụ TÌM KIẾM chính
        ↓
(Tuỳ chọn, nếu không gian đủ nhỏ để brute-force được) chạy thêm MOFDA
quy mô nhỏ để ĐỐI CHIẾU/KIỂM CHỨNG thuật toán — không bắt buộc, nhưng
là bằng chứng validation tốt cho bài báo nếu mục tiêu là ứng dụng thuật toán.
```

**Bài học đắt giá nhất của dự án này:** ban đầu định chạy MOFDA Np=50×Maxit=100 (~25.000 lần đánh giá, ước tính ~4,6 ngày) trước khi nhận ra không gian rời rạc thực tế chỉ có **243 tổ hợp** — brute-force giải xong trong **71 phút**. **Luôn tính số tổ hợp khả dĩ TRƯỚC khi chọn quy mô thuật toán/cam kết thời gian chạy.**

## 1. Cấu trúc file (đã dùng, khuyến nghị giữ nguyên tên hàm khi copy)

| File | Vai trò | Có cần sửa khi dùng cho dự án mới? |
|---|---|---|
| `wharf100dwt_config.m` | Toàn bộ tham số: đường dẫn SAP, biến thiết kế, vật liệu, giới hạn, penalty | **CÓ** — sửa toàn bộ nội dung cho đúng bài toán mới |
| `Functions/open_Sap2000.m` | Mở 1 SAP2000 headless qua `SM.*`, mở model, set combo output | Không cần sửa (chỉ cần đúng `cfg.sap.*`) |
| `Functions/open_Sap2000_worker.m` | Mở 1 SAP2000 riêng cho 1 worker trong `spmd`, lưu 1 bản `.sdb` riêng | Không cần sửa |
| `wharf100dwt_evaluate.m` | Hàm mục tiêu: X → [fit, diagnostic], gọi SAP2000 OAPI | **CÓ** — logic tính f1/f2/ràng buộc là đặc thù bài toán |
| `run_bruteforce_wharf100dwt.m` | Liệt kê toàn bộ lưới rời rạc, chạy song song, tìm Pareto thật | Chỉ cần sửa cách sinh lưới (`ndgrid`) nếu số biến/miền khác |
| `run_mofda_wharf100dwt_parallel.m` | MOFDA song song, có checkpoint/resume/atomic-save | Không cần sửa (đã tổng quát hoá theo `cfg`) |

## 2. `wharf100dwt_config.m` — khung mẫu (đã tổng quát hoá)

```matlab
function cfg = PROJECT_config()  % [SUA] doi ten ham + file cho khop du an moi
    %% Duong dan SAP2000 (giu nguyen neu cung may)
    cfg.sap.programPath = 'C:\Program Files\Computers and Structures\SAP2000 24\SAP2000.exe';
    cfg.sap.apiDllPath  = 'C:\Program Files\Computers and Structures\SAP2000 24\SAP2000v1.dll';
    cfg.sap.modelPath   = fullfile(fileparts(mfilename('fullpath')), 'Sap', 'MODEL_NAME.sdb'); % [SUA]

    %% To hop tai dung cho f2 + rang buoc -- uu tien dung Envelope co san
    %% trong model (neu co) de giam so lan goi OAPI, thay vi tu dung
    %% envelope tu nhieu combo rieng le.
    cfg.sap.comboEnvelope = 'TEN_COMBO_ENVELOPE'; % [SUA]

    %% Ten tiet dien / vat lieu trong SAP2000 (doi khop file .$2k that)
    cfg.sections.name1 = 'SECTION_NAME_1'; % [SUA]
    cfg.sections.mat1  = 'MATERIAL_NAME_1'; % [SUA]

    %% BIEN THIET KE -- QUYET DINH QUAN TRONG NHAT:
    %% - Neu co catalogue thuong mai that (nha san xuat) -> dung 1 bien
    %%   CHI SO DONG catalogue (khong tach D,t thanh 2 bien doc lap, vi
    %%   catalogue that luon rang buoc D voi 1 t co dinh).
    %% - Neu KHONG co catalogue -> roi rac hoa theo luoi co dinh (buoc kt
    %%   vua du chinh xac che tao, KHONG dung bien lien tuc neu muon
    %%   brute-force duoc -- lien tuc = khong gian vo han, khong liet ke
    %%   toan bo duoc).
    cfg.bounds.lb = [1,    LB2,   LB3];   % [SUA]
    cfg.bounds.ub = [N,    UB2,   UB3];   % [SUA] N = so dong catalogue
    cfg.bounds.roundStep = [1, STEP2, STEP3]; % [SUA]

    %% Vat lieu, gioi han, penalty... (dac thu du an)
    cfg.penalty.C_init = 10; % hieu chinh qua pilot neu dung MOFDA that

    %% Tham so MOFDA (chi dung neu KHONG brute-force duoc)
    cfg.algo.beta = 4;
    cfg.algo.nGrid = 10;
end
```

## 3. `wharf100dwt_evaluate.m` — khung mẫu

```matlab
function [fit, diagnostic] = PROJECT_evaluate(X, cfg)
    % X (Npop x nVar) -> fit (Npop x 2) = [f1, f2] da ap penalty
    % Gia dinh: SAP2000 da mo san qua open_Sap2000(cfg) trong PHIEN HIEN
    % TAI (dung SM.* toan cuc -- KHONG tu mo lai SAP2000 trong ham nay).
    Npop = size(X,1);
    HARD_PENALTY = [1e6, 1e6];
    fit = zeros(Npop,2);
    diagnostic = nan(Npop, N_DIAG_COLS); % [SUA]

    for ix = 1:Npop
        % 1. Giai ma bien X(ix,:) -> gia tri thiet ke thuc (D,t,...)
        %    [SUA] logic tra catalogue / lam tron luoi

        % 2. Rang buoc hinh hoc so bo (khong can SAP) -> neu vo ly, phat
        %    cung va continue, KHONG chay FEM (tiet kiem thoi gian)

        try
            SM.SetModelIsLocked(false);
            % [SUA] SM.PropFrame.SetPipe(...) / SetRectangle(...) v.v.

            retA = SM.Analyze.RunAnalysis();
            if retA ~= 0, fit(ix,:) = HARD_PENALTY; continue; end

            % [SUA] trich xuat ket qua qua SM.Results.* tren cfg.sap.comboEnvelope

            % [SUA] tinh f1_raw, f2_raw, g_j(x) rang buoc chuan hoa
            g_total = ...; % tong cac max(0, vi_pham)
            penMult = 1 + cfg.penalty.C_init * g_total;
            fit(ix,1) = f1_raw * penMult;
            fit(ix,2) = f2_raw * penMult;
        catch ME
            disp(['loi SAP API - ', ME.message]);
            fit(ix,:) = HARD_PENALTY;
        end
    end
end
```

## 4. Brute-force (dùng khi không gian đủ nhỏ — LUÔN THỬ TRƯỚC)

```matlab
function run_bruteforce_PROJECT(Num_work)
    if nargin < 1, Num_work = 8; end % [SUA neu do license/CPU khac]
    cfg = PROJECT_config();
    finalFile = fullfile('results','PROJECT_BRUTEFORCE_FINAL.mat');
    if isfile(finalFile), return; end % idempotent

    % [SUA] Sinh luoi day du bang ndgrid() tu cfg.bounds, vd 3 bien:
    v1 = cfg.bounds.lb(1):cfg.bounds.roundStep(1):cfg.bounds.ub(1);
    v2 = cfg.bounds.lb(2):cfg.bounds.roundStep(2):cfg.bounds.ub(2);
    v3 = cfg.bounds.lb(3):cfg.bounds.roundStep(3):cfg.bounds.ub(3);
    [A,B,C] = ndgrid(v1,v2,v3);
    Xall = [A(:),B(:),C(:)];
    fprintf('Tong so to hop: %d\n', size(Xall,1));

    system('taskkill /F /IM SAP2000.exe'); pause(2);
    p = gcp('nocreate'); if isempty(p)||p.NumWorkers~=Num_work, delete(p); parpool('local',Num_work); end
    spmd(Num_work), maxNumCompThreads(1); open_Sap2000_worker(cfg, spmdIndex); end

    fit = batchEvaluateParallel(Xall, cfg, Num_work); % xem ham chung muc 6
    DOM = checkDomination(fit); % can MOFDA/Functions/checkDomination.m
    ParetoX = Xall(~DOM,:); ParetoFit = fit(~DOM,:);
    save(finalFile, 'Xall','fit','ParetoX','ParetoFit','-v7.3');
    spmd(Num_work), try, SM.ApplicationExit(); catch, end, end
end
```

## 5. MOFDA song song (chỉ khi brute-force KHÔNG khả thi, hoặc muốn đối chiếu)

Giữ nguyên cấu trúc `run_mofda_wharf100dwt_parallel.m` đã viết — copy nguyên file, chỉ đổi:
- `Np`, `maxiter`, `Nr` cho quy mô mới (tính FE = `Np*(1+maxiter*(beta+1))`, ước lượng thời gian bằng thông lượng đo được từ 1 pilot nhỏ **trước khi cam kết**, KHÔNG suy đoán).
- Tên file cfg/evaluate tương ứng dự án mới.
- Cơ chế checkpoint mỗi vòng lặp + ghi atomic (`.tmp` rồi `movefile`) + idempotent-skip nếu file cuối đã tồn tại — **giữ nguyên, đây là 3 cơ chế bắt buộc** cho job chạy nhiều giờ/ngày (xem `Cach ket noi_SAP2000_MATLAB_OPTIMIZATION.md` mục 5).

## 6. Hàm dùng chung — batch song song

```matlab
function fitOut = batchEvaluateParallel(Xbatch, cfg, Num_work)
    N = size(Xbatch,1);
    idx = mod(0:N-1, Num_work) + 1;
    spmd(Num_work)
        Xpart = Xbatch(idx==spmdIndex,:);
        fitLoc = ~isempty(Xpart) * 0; %#ok  % placeholder tranh loi rong
        if ~isempty(Xpart), fitLoc = PROJECT_evaluate(Xpart, cfg); else, fitLoc = zeros(0,2); end
    end
    fitOut = zeros(N,2);
    for w = 1:Num_work, fitOut(idx==w,:) = fitLoc{w}; end
end
```

## 7. Checklist trước khi chạy campaign thật (không được bỏ qua)

- [ ] Đã tính tổng số tổ hợp khả dĩ — nếu ≤ vài nghìn, brute-force TRƯỚC.
- [ ] Đã chạy `wharf100dwt_fix_comb62.m`-kiểu (nếu hồ sơ gốc có lỗi tổ hợp tải) và xác nhận trong SAP2000 GUI.
- [ ] Chạy MATLAB bằng **`-r`, KHÔNG `-batch`** — `-batch` gây crash không ổn định với mọi COM automation (`SM.*`, `actxserver`).
- [ ] KHÔNG dùng `readtable(...)` cho file cấu hình quan trọng nếu chưa kiểm chứng ổn định trên máy đích — ưu tiên `fopen`/`fgetl` thủ công.
- [ ] Đo số worker tối ưu bằng 1 test nhỏ thật (không giả định) — tăng worker không tuyến tính với license/CPU.
- [ ] Smoke test (Np/tổ hợp rất nhỏ) → đo thời gian thật → mới quyết định quy mô cuối.
- [ ] Có đủ 3 cơ chế: idempotent-skip, checkpoint mỗi vòng, ghi atomic — trước khi chạy nhiều giờ.
- [ ] Khởi chạy bằng `Start-Process -WindowStyle Hidden` (PowerShell), tách khỏi phiên chat/agent.

## 8. Tham khảo thêm

- `Cach ket noi_SAP2000_MATLAB_OPTIMIZATION.md` — kinh nghiệm gốc (mục 6.6, 6.7 mới bổ sung: lỗi `-batch`, lỗi `readtable`).
- `Wharf100DWT/README.md` — nhật ký đầy đủ của dự án này, gồm cả số liệu thông lượng thật đã đo (8 vs 10 worker).
