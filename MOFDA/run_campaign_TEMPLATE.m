function run_campaign_TEMPLATE(Num_work)
% =========================================================================
% BO DIEU PHOI CAMPAIGN CHUAN (brute-force + MOFDA validation ket hop).
% [SUA] doi ten ham/file + noi dung PROJECT_config()/PROJECT_evaluate()
% cho dung du an moi. Phan LOGIC QUYET DINH quy mo giu nguyen.
%
% Chien luoc:
%   1. Tinh N_total = tong so to hop roi rac kha di.
%   2. Neu N_total <= N_BRUTEFORCE_MAX -> chay brute-force TRUOC (cho
%      Pareto that 100%), roi chay THEM 1 MOFDA quy mo nho de doi chieu
%      (validate thuat toan), voi FE_MOFDA ~ FACTOR_VALIDATE x N_total.
%   3. Neu N_total qua lon -> BO QUA brute-force, dung MOFDA lam cong cu
%      tim kiem chinh, quy mo Np/Maxit chon theo ngan sach thoi gian do
%      duoc tu pilot (KHONG suy doan).
% =========================================================================
    if nargin < 1 || isempty(Num_work), Num_work = 8; end % [SUA neu khac]

    N_BRUTEFORCE_MAX = 5000;   % nguong "du nho de liet ke toan bo"
    FACTOR_VALIDATE  = 4;      % FE_MOFDA_validate ~ 4 x N_total (khoang 3-5x)
    beta = 4;                  % tham so MOFDA (giu mac dinh neu khong doi)

    scriptDir = fileparts(mfilename('fullpath'));
    addpath(fullfile(scriptDir, 'Functions'));            % [SUA duong dan]
    addpath(fullfile(scriptDir, 'MOFDA', 'Functions'));    % [SUA duong dan]

    cfg = PROJECT_config(); % [SUA]

    %% ---- Buoc 1: tinh N_total tu cfg.bounds ----
    nVar = numel(cfg.bounds.lb);
    counts = zeros(1, nVar);
    for k = 1:nVar
        counts(k) = numel(cfg.bounds.lb(k):cfg.bounds.roundStep(k):cfg.bounds.ub(k));
    end
    N_total = prod(counts);
    fprintf('[CAMPAIGN] Bien roi rac: %s -> N_total = %d\n', mat2str(counts), N_total);

    %% ---- Buoc 2: pilot do thoi gian/1 lan danh gia (BAT BUOC, khong suy doan) ----
    Xpilot = repmat(cfg.bounds.lb, 20, 1); % 20 diem bat ky trong mien hop le [SUA neu can da dang hoa]
    for r = 1:size(Xpilot,1)
        Xpilot(r,:) = cfg.bounds.lb + rand(1,nVar) .* (cfg.bounds.ub - cfg.bounds.lb);
    end
    tPilot = tic;
    open_Sap2000(cfg); %#ok<NASGU> % [SUA neu ham mo SAP khac ten]
    PROJECT_evaluate(Xpilot, cfg); % [SUA]
    secPerEval = toc(tPilot) / size(Xpilot,1);
    fprintf('[CAMPAIGN] Thoi gian trung binh / lan danh gia (serial, 1 SAP): %.2f s\n', secPerEval);

    %% ---- Buoc 3: quyet dinh chien luoc ----
    if N_total <= N_BRUTEFORCE_MAX
        fprintf('[CAMPAIGN] N_total=%d <= %d -> CHAY BRUTE-FORCE TRUOC.\n', N_total, N_BRUTEFORCE_MAX);
        estBruteMin = N_total * secPerEval / Num_work / 60;
        fprintf('[CAMPAIGN] Uoc luong brute-force: %.1f phut (%d worker)\n', estBruteMin, Num_work);

        run_bruteforce_PROJECT(Num_work); % [SUA ten ham, xem mau muc 4 file PHUONG_AN_...md]

        %% ---- Buoc 4: MOFDA quy mo nho de DOI CHIEU (khong phai tim kiem chinh) ----
        FE_target = FACTOR_VALIDATE * N_total;
        % FE = Np*(1+Maxit*(beta+1))  ->  chon Maxit truoc, giai ra Np
        Maxit = max(5, round(sqrt(FE_target / (beta+1))));      % kinh nghiem: can bang Np~Maxit
        Np    = max(5, round(FE_target / (1 + Maxit*(beta+1))));
        FE_actual = Np*(1+Maxit*(beta+1));
        estMofdaMin = FE_actual * secPerEval / Num_work / 60;
        fprintf(['[CAMPAIGN] MOFDA validation: Np=%d, Maxit=%d, beta=%d -> FE=%d ' ...
                 '(muc tieu %.0fx N_total). Uoc luong: %.1f phut (%d worker)\n'], ...
                 Np, Maxit, beta, FE_actual, FACTOR_VALIDATE, estMofdaMin, Num_work);

        run_mofda_PROJECT_parallel(Num_work, Np, Maxit); % [SUA ten ham]

        %% ---- Buoc 5: doi chieu ket qua (bao cao % trung khop) ----
        compare_mofda_vs_bruteforce(scriptDir); % [SUA hoac viet moi, xem vi du duoi]
    else
        fprintf('[CAMPAIGN] N_total=%d > %d -> KHONG brute-force. Dung MOFDA lam cong cu tim kiem chinh.\n', ...
            N_total, N_BRUTEFORCE_MAX);
        fprintf(['[CAMPAIGN] Chon Np/Maxit theo NGAN SACH THOI GIAN THUC TE cua ban ' ...
                 '(FE = Np*(1+Maxit*(beta+1)); thoi gian ~ FE*%.2fs/%d worker). ' ...
                 'Vi du: muon chay <=48h -> FE_max = 48*3600*%d/%.2f = %d\n'], ...
                 secPerEval, Num_work, Num_work, secPerEval, floor(48*3600*Num_work/secPerEval));
        % [SUA] goi truc tiep run_mofda_PROJECT_parallel(Num_work, Np, Maxit) voi Np/Maxit ban tu chon
    end
end

%% ========================================================================
function compare_mofda_vs_bruteforce(scriptDir)
    % [SUA] doi ten file .mat cho khop du an moi
    bf  = load(fullfile(scriptDir, 'results', 'PROJECT_BRUTEFORCE_FINAL.mat'), 'ParetoFit');
    mo  = load(fullfile(scriptDir, 'results', 'PROJECT_MOFDA_FINAL.mat'), 'REP');
    tol = 1e-6;
    nMatch = 0;
    for i = 1:size(mo.REP.pos_fit,1)
        d = min(vecnorm(bf.ParetoFit - mo.REP.pos_fit(i,:), 2, 2));
        if d < tol, nMatch = nMatch + 1; end
    end
    fprintf('[CAMPAIGN] Doi chieu: %d/%d nghiem MOFDA trung khop chinh xac voi Pareto brute-force that (%.1f%%)\n', ...
        nMatch, size(mo.REP.pos_fit,1), 100*nMatch/size(mo.REP.pos_fit,1));
end
