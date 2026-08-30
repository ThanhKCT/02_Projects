function [fit, diagnostic] = wharf100dwt_evaluate(X, cfg)
% =========================================================================
% HÀM MỤC TIÊU: X (Npop x 3) -> fit (Npop x 2) = [F1_khoiluong, F2_chuyenvi]
% (đã áp penalty function). Giả định SAP2000 đã mở sẵn model qua
% open_Sap2000(cfg) trong phiên MATLAB hiện tại (dùng SM.* toàn cục).
%
% Cột X (ĐÃ CHỐT LẠI — 3 biến, không phải 4): [CatIdx_BTCT, D_thep, t_thep]
% CatIdx_BTCT: chỉ số dòng catalogue AMACCAO (1=D700,2=D800,3=D900, Class A)
% -- D_BTCT/t_BTCT/A/Mcr/Mu/Pmax tra trực tiếp, KHÔNG còn là biến độc lập.
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

    for ix = 1:Npop
        % --- Bien 1: chi so catalogue BTCT (lam tron ve so nguyen 1..3) ---
        [D_BTCT, t_BTCT, ~, Mu_btct, Pmax_btct, catIdxRounded] = resolveBtctCatalogue(X(ix,1), cfg); %#ok<ASGLU>

        % --- Bien 2,3: cọc thep, roi rac hoa theo luoi co dinh (25mm/1mm) ---
        D_thep = round(X(ix,2)/cfg.bounds.roundStep(2))*cfg.bounds.roundStep(2);
        t_thep = round(X(ix,3)/cfg.bounds.roundStep(3))*cfg.bounds.roundStep(3);

        % Rang buoc hinh hoc so bo cho coc thep (BTCT lay tu catalogue, da hop le)
        if t_thep >= D_thep/2
            fit(ix,:) = HARD_PENALTY;
            diagnostic(ix,:) = [nan(1,11), 0, catIdxRounded];
            continue;
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

            maxAbsP_btct = max(abs(double(P_b)));
            maxAbsM_btct = max(sqrt(double(M2_b).^2 + double(M3_b).^2));
            maxAbsP_thep = max(abs(double(P_s)));
            maxAbsM_thep = max(sqrt(double(M2_s).^2 + double(M3_s).^2));

            % --- Ứng suất cọc thép (nén/kéo dọc trục + uốn 2 phương, gần đúng) ---
            A_thep = annulusArea(D_thep, t_thep);
            S_thep = annulusSectionModulus(D_thep, t_thep);
            sigma_thep  = maxAbsP_thep / A_thep + maxAbsM_thep / S_thep; % T/m^2
            sigma_allow = cfg.material.Fy_thep_Tm2 / cfg.material.gammaM_thep;

            % --- Ràng buộc địa kỹ thuật (STUB — xem cảnh báo trong file) ---
            [g_geo, geotechChecked] = wharf100dwt_geotech_capacity_stub(D_BTCT, t_BTCT, maxAbsP_btct, cfg);

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
