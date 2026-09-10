function [fit, diagnostic] = wharf100dwt_evaluate(X, cfg)
% =========================================================================
% HÀM MỤC TIÊU: X (Npop x 3) -> fit (Npop x 2) = [F1_khoiluong, F2_chuyenvi]
% (đã áp penalty function). Giả định SAP2000 đã mở sẵn model qua
% open_Sap2000(cfg) trong phiên MATLAB hiện tại (dùng SM.* toàn cục).
%
% Cột X (ĐÃ CHỐT LẠI — 3 biến, không phải 4): [CatIdx_BTCT, D_thep, t_thep]
% CatIdx_BTCT: chỉ số dòng catalogue AMACCAO (mở rộng 07/09/2026 -- 1=D600,
% 2=D700, 3=D800, 4=D900, 5=D1000, Class A) -- D_BTCT/t_BTCT/A/Mcr/Mu/Pmax
% tra trực tiếp, KHÔNG còn là biến độc lập.
%
% diagnostic (Npop x 13) — theo thứ tự:
%   1 f1_raw  2 f2_raw(U_max,m)  3 maxAbsM_btct(T.m)  4 Mu_btct(T.m)
%   5 maxAbsP_btct(T)  6 Pmax_btct(T)  7 sigma_thep(T/m2)  8 sigma_allow(T/m2)
%   9 g_total(vi pham chuan hoa)  10 penalty_multiplier  11 SAPAnalysisOK
%   12 geotechChecked  13 CatIdx_BTCT_da_lam_tron
%
% Ràng buộc N-M cọc BTCT (ĐÃ SỬA 28/08/2026): dùng đúng công thức tương tác
% N/Nmax + M/Mu <= 1.0 do chính catalogue AMACCAO khuyến nghị (Cataloge coc
% ly tam.md, mục 5.1) -- KHÔNG còn kiểm tra N và M riêng lẻ, cộng dồn 2 vi
% phạm độc lập như bản trước.
% =========================================================================
    Npop = size(X,1);
    HARD_PENALTY = [1e6, 1e6]; % geometry vô lý hoặc SAP lỗi -> không chạy FEM

    fit = zeros(Npop,2);
    diagnostic = nan(Npop,13);

    cacheMap = loadEvaluateCache(); % xem ham loadEvaluateCache() ben duoi -- Buoc A cache

    for ix = 1:Npop
        % --- Bien 1: chi so catalogue BTCT (lam tron ve so nguyen 1..N) ---
        [D_BTCT, t_BTCT, ~, Mu_btct, Pmax_btct, catIdxRounded] = resolveBtctCatalogue(X(ix,1), cfg); %#ok<ASGLU>

        % --- Bien 2,3: cọc thep, roi rac hoa theo luoi co dinh (10mm/1mm) ---
        D_thep = round(X(ix,2)/cfg.bounds.roundStep(2))*cfg.bounds.roundStep(2);
        t_thep = round(X(ix,3)/cfg.bounds.roundStep(3))*cfg.bounds.roundStep(3);

        % Rang buoc hinh hoc so bo cho coc thep (BTCT lay tu catalogue, da hop le)
        if t_thep >= D_thep/2
            fit(ix,:) = HARD_PENALTY;
            diagnostic(ix,:) = [nan(1,11), 0, catIdxRounded];
            continue;
        end

        % --- Buoc A (cache): neu to hop nay da co trong ket qua vet can
        % Ngay 1 (Wharf100DWT_BRUTEFORCE_FINAL.mat), lay lai fit/diagnostic
        % da tinh, KHONG goi lai SAP2000. Chi dung khi cache duoc nap that
        % (isKey), khong suy doan/noi suy. ---
        if ~isempty(cacheMap)
            cacheKey = evaluateCacheKey(catIdxRounded, D_thep, t_thep);
            if isKey(cacheMap, cacheKey)
                cached = cacheMap(cacheKey);
                fit(ix,:) = cached.fit;
                diagnostic(ix,:) = cached.diagnostic;
                continue;
            end
        end

        try
            SM.SetModelIsLocked(false);
            SM.PropFrame.SetPipe(cfg.sections.btctName, cfg.sections.matBTCT, D_BTCT, t_BTCT);
            SM.PropFrame.SetPipe(cfg.sections.thepName, cfg.sections.matThep, D_thep, t_thep);

            retA = SM.Analyze.RunAnalysis();
            if retA ~= 0
                fit(ix,:) = HARD_PENALTY;
                diagnostic(ix,:) = [nan(1,11), 0, catIdxRounded];
                continue;
            end

            % --- Chuyển vị ngang lớn nhất trên "BAO KT" (đã set output ở open_Sap2000) ---
            [retJ,~,~,~,~,~,~,U1,U2,~,~,~,~] = SM.Results.JointDisplAbs('ALL', SM.eItemTypeElm.GroupElm);
            if retJ ~= 0 || isempty(U1)
                fit(ix,:) = HARD_PENALTY;
                diagnostic(ix,:) = [nan(1,11), 0, catIdxRounded];
                continue;
            end
            Uhoriz = sqrt(double(U1).^2 + double(U2).^2);
            U_max = max(Uhoriz);

            % --- Nội lực cọc BTCT ---
            SM.SelectObj.PropertyFrame(cfg.sections.btctName);
            [retFB,nFB,~,~,~,~,~,~,~,P_b,~,~,~,M2_b,M3_b] = SM.Results.FrameForce('eItemType', SM.eItemTypeElm.SelectionElm);
            SM.SelectObj.ClearSelection();

            % --- Nội lực cọc thép ---
            SM.SelectObj.PropertyFrame(cfg.sections.thepName);
            [retFS,nFS,~,~,~,~,~,~,~,P_s,~,~,~,M2_s,M3_s] = SM.Results.FrameForce('eItemType', SM.eItemTypeElm.SelectionElm);
            SM.SelectObj.ClearSelection();

            if retFB ~= 0 || retFS ~= 0 || nFB == 0 || nFS == 0
                fit(ix,:) = HARD_PENALTY;
                diagnostic(ix,:) = [nan(1,11), 0, catIdxRounded];
                continue;
            end

            % --- Tach NEN/KEO theo dung quy uoc dau cua SAP2000 (P>0=keo,
            % P<0=nen) -- SUA 08/09/2026: ban truoc dung abs(), gop chung
            % nen/keo, bo sot rang buoc chong nho coc (xem canh bao trong
            % wharf100dwt_geotech_capacity_tcvn10304.m). Da kiem tra THAT
            % bang SAP2000: co coc thep bi keo toi ~31T duoi to hop bao. ---
            Pb_raw = double(P_b); Ps_raw = double(P_s);
            maxComp_btct = max(0, -min(Pb_raw));  % T, lon nhat khi NEN (P am)
            maxTens_btct = max(0, max(Pb_raw));   % T, lon nhat khi KEO (P duong)
            maxComp_thep = max(0, -min(Ps_raw));
            maxTens_thep = max(0, max(Ps_raw));
            maxAbsP_btct = maxComp_btct; % giu ten bien cu cho g_NM (chi xet nen, dung quy uoc cu)
            maxAbsM_btct = max(sqrt(double(M2_b).^2 + double(M3_b).^2));
            maxAbsP_thep = max(maxComp_thep, maxTens_thep); % giu cho sigma_thep (ung suat, khong phan biet dau)
            maxAbsM_thep = max(sqrt(double(M2_s).^2 + double(M3_s).^2));

            % --- Ứng suất cọc thép (nén/kéo dọc trục + uốn 2 phương, gần đúng) ---
            A_thep = annulusArea(D_thep, t_thep);
            S_thep = annulusSectionModulus(D_thep, t_thep);
            sigma_thep  = maxAbsP_thep / A_thep + maxAbsM_thep / S_thep; % T/m^2
            sigma_allow = cfg.material.Fy_thep_Tm2 / cfg.material.gammaM_thep;

            % --- Ràng buộc địa kỹ thuật (TCVN 10304:2025) — NÉN + KÉO/NHỔ ---
            % Kiểm tra CẢ 2 loại cọc (BTCT và thép), CẢ nén lẫn kéo (SUA
            % 08/09/2026 -- xem canh bao trong wharf100dwt_geotech_capacity_tcvn10304.m).
            [g_geo_btct, geotechChecked_btct] = wharf100dwt_geotech_capacity_tcvn10304(D_BTCT, t_BTCT, maxComp_btct, maxTens_btct, 'BTCT', cfg);
            [g_geo_thep, geotechChecked_thep] = wharf100dwt_geotech_capacity_tcvn10304(D_thep, t_thep, maxComp_thep, maxTens_thep, 'THEP', cfg);
            g_geo = g_geo_btct + g_geo_thep;
            geotechChecked = geotechChecked_btct && geotechChecked_thep;

            % --- Tổng vi phạm chuẩn hoá + penalty nhân (ĐÃ SỬA LẠI 28/08/2026) ---
            % Ràng buộc N-M cọc BTCT: dùng ĐÚNG công thức tương tác do chính
            % catalogue AMACCAO khuyến nghị (Cataloge coc ly tam.md, mục 5.1):
            %   N/Nmax + M/Mu <= 1.0
            % (bản trước kiểm tra N và M riêng lẻ, cộng dồn 2 vi phạm độc lập
            % -- không đúng công thức tương tác của tài liệu nguồn).
            g_NM     = max(0, maxAbsP_btct/Pmax_btct + maxAbsM_btct/Mu_btct - 1);
            g_stress = max(0, sigma_thep/sigma_allow - 1);
            g_disp   = max(0, U_max/cfg.limits.dU_allow_m - 1);
            g_total  = g_NM + g_stress + g_disp + g_geo;

            f1_raw = wharf100dwt_material_tonnage(D_BTCT, t_BTCT, D_thep, t_thep, cfg);
            f2_raw = U_max;

            penMult = 1 + cfg.penalty.C_init * g_total;
            fit(ix,1) = f1_raw * penMult;
            fit(ix,2) = f2_raw * penMult;

            diagnostic(ix,:) = [f1_raw, f2_raw, maxAbsM_btct, Mu_btct, maxAbsP_btct, ...
                Pmax_btct, sigma_thep, sigma_allow, g_total, penMult, 1, geotechChecked, catIdxRounded];

        catch ME
            disp(['wharf100dwt_evaluate: loi SAP API - ', ME.message]);
            fit(ix,:) = HARD_PENALTY;
            diagnostic(ix,:) = [nan(1,11), 0, catIdxRounded];
        end
    end
end

function cacheMap = loadEvaluateCache()
% =========================================================================
% BUOC A (cache) -- them 07/09/2026 theo gop y phan bien JMST V4 -> V5.
% Nap 1 LAN duy nhat moi worker (bien persistent) tu file ket qua vet can
% Ngay 1 (results/Wharf100DWT_BRUTEFORCE_FINAL.mat) neu da ton tai. Vi
% Ngay 1 liet ke DAY DU luoi thiet ke, MOFDA (Ngay 2) lam tron ve bat ky
% diem luoi nao cung se TRUNG KHOP cache -- ty le trung du kien 100%,
% khong can goi lai SAP2000 cho campaign MOFDA sau khi da co file nay.
% Neu chua co file (vd dang chay chinh vet can Ngay 1), tra ve map RONG
% -- moi loi goi wharf100dwt_evaluate se chay SAP2000 that nhu binh
% thuong, KHONG anh huong ket qua vet can.
% =========================================================================
    persistent cacheMapPersist cacheLoadedPersist
    if isempty(cacheLoadedPersist)
        cacheMapPersist = containers.Map('KeyType', 'char', 'ValueType', 'any');
        cacheFile = fullfile(fileparts(mfilename('fullpath')), 'results', 'Wharf100DWT_BRUTEFORCE_FINAL.mat');
        if isfile(cacheFile)
            try
                S = load(cacheFile, 'Xall', 'fit', 'diagnostic');
                if isfield(S, 'Xall') && isfield(S, 'fit') && isfield(S, 'diagnostic')
                    for k = 1:size(S.Xall, 1)
                        key = evaluateCacheKey(round(S.Xall(k,1)), S.Xall(k,2), S.Xall(k,3));
                        entry.fit = S.fit(k,:);
                        entry.diagnostic = S.diagnostic(k,:);
                        cacheMapPersist(key) = entry; %#ok<NASGU>
                    end
                    fprintf('wharf100dwt_evaluate: da nap cache tu %s (%d to hop).\n', cacheFile, size(S.Xall,1));
                else
                    warning('wharf100dwt_evaluate:CacheMissingFields', ...
                        '%s thieu bien Xall/fit/diagnostic (file cu, chua co diagnostic) -- BO QUA cache.', cacheFile);
                end
            catch ME
                warning('wharf100dwt_evaluate:CacheLoadFailed', 'Loi nap cache %s: %s -- BO QUA cache.', cacheFile, ME.message);
            end
        end
        cacheLoadedPersist = true;
    end
    cacheMap = cacheMapPersist;
end

function key = evaluateCacheKey(catIdxRounded, D_thep, t_thep)
% Chuoi khoa co dinh chu so thap phan -- tranh sai lech dau phay dong (vd
% 0.019999999998 vs 0.02) khi so sanh khoa giua lan luu (Ngay 1) va lan
% doc (Ngay 2), du 2 gia tri deu xuat phat tu CUNG 1 luoi roundStep.
    key = sprintf('%d_%.4f_%.4f', round(catIdxRounded), D_thep, t_thep);
end

function [D_BTCT, t_BTCT, A_BTCT, Mu_btct, Pmax_btct, catIdxRounded] = resolveBtctCatalogue(catIdxRaw, cfg)
    [D_BTCT, t_BTCT, A_BTCT, ~, Mu_btct, Pmax_btct] = wharf100dwt_pile_capacity_btct(catIdxRaw, cfg);
    catIdxRounded = round(catIdxRaw);
end

function A = annulusArea(D, t)
    Din = D - 2*t;
    A = pi/4 * (D^2 - Din^2);
end

function S = annulusSectionModulus(D, t)
    Din = D - 2*t;
    I = pi/64 * (D^4 - Din^4);
    S = I / (D/2);
end
