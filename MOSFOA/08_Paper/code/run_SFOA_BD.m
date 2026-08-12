%% RUN_SFOA_BD.m
% Script chinh: chay SFOA va cac thuat toan doi chung (PSO/GWO/WOA/HHO)
% cho bai toan toi uu hoa chi phi ket cau tru va (BD).
%
% TRUOC KHI CHAY:
%   1) Dat file SFOA.m (tai tu MathWorks File Exchange #173735) vao path.
%   2) Dat code goc PSO/GWO/WOA/HHO (khuyen nghi tai tu MathWorks/trang
%      tac gia Seyedali Mirjalili) vao path - hoac dung ban rut gon neu can.
%   3) Dien day du du lieu vao 'catalog' va 'soil' o duoi.
%   4) Kiem tra lai update_BD_model_SAP2000.m dung voi model .sdb thuc te.

clear; clc;

%% 1. Khai bao catalog coc (TCVN 7888:2014) - *** DIEN DU LIEU THAT ***
% Vi du mau dua tren mot phan du lieu da co trong bai chinh (Table 9) -
% CAN BO SUNG DAY DU CAC MA COC KHAC THEO DANH MUC TCVN 7888:2014.
catalog.Dp    = [600, 700, 1100, 1200, 1200, 1200];  % mm
catalog.tp    = [ 90, 100,  140,  150,  150,  150];  % mm (vi du, CAN XAC NHAN)
catalog.Price = [42.99, 32.16, 80.30, 100.95, 132.05, 190.72]; % $/m
catalog.Mcr   = [NaN, NaN, NaN, NaN, NaN, NaN]; % *** CAN DIEN Mcr THEO TCVN 7888:2014 ***

%% 2. Khai bao thong so dia chat - *** DIEN DU LIEU THAT ***
soil.layers = struct( ...
    'thickness_m', {4.8, 5.3, 9.6, 1.7, 4.9, 2.3}, ...
    'fi_kPa',      {NaN, NaN, NaN, NaN, NaN, NaN});   % *** CAN DIEN fi THEO KHAO SAT DIA CHAT ***
soil.qb_at_tip = @(Lp) NaN;              % *** CAN HAM/BANG TRA qb THEO DO SAU ***
soil.IB_at_depth = @(Lp) NaN;             % *** CAN HAM TRA IB THEO DO SAU MUI COC ***
soil.bearing_layer_thickness = @(Lp) NaN; % *** CAN HAM TRA DO DAY LOP CHIU LUC ***

%% 3. Thiet lap bai toan toi uu hoa
dim = 4;
lb  = [min(catalog.Dp), min(catalog.tp), 6, 1];
ub  = [max(catalog.Dp), max(catalog.tp), 8, 40];

fobj = @(X) objective_function(X, catalog, soil);

%% 4. Thiet lap tham so thuat toan
N     = 30;   % kich thuoc quan the - TODO: dieu chinh sau khi test toc do
Tmax  = 100;  % so vong lap toi da - TODO: dieu chinh sau khi test toc do
nRuns = 20;   % so lan chay doc lap - khuyen nghi 20-30

algos = {'SFOA', 'PSO', 'GWO', 'WOA', 'HHO'};
results = struct();

for a = 1:numel(algos)
    name = algos{a};
    fprintf('=== Dang chay thuat toan: %s ===\n', name);
    best_scores = zeros(nRuns, 1);
    best_positions = cell(nRuns, 1);
    conv_curves = cell(nRuns, 1);

    for r = 1:nRuns
        fprintf('  Lan chay %d/%d...\n', r, nRuns);
        switch name
            case 'SFOA'
                [bs, bp, cc] = SFOA(N, Tmax, lb, ub, dim, fobj); %#ok<ASGLU>
            case 'PSO'
                [bs, bp, cc] = PSO(N, Tmax, lb, ub, dim, fobj); %#ok<ASGLU>
            case 'GWO'
                [bs, bp, cc] = GWO(N, Tmax, lb, ub, dim, fobj); %#ok<ASGLU>
            case 'WOA'
                [bs, bp, cc] = WOA(N, Tmax, lb, ub, dim, fobj); %#ok<ASGLU>
            case 'HHO'
                [bs, bp, cc] = HHO(N, Tmax, lb, ub, dim, fobj); %#ok<ASGLU>
        end
        best_scores(r) = bs;
        best_positions{r} = bp;
        conv_curves{r} = cc;
    end

    results.(name).best_scores = best_scores;
    results.(name).best_positions = best_positions;
    results.(name).conv_curves = conv_curves;
    results.(name).stats = [min(best_scores), mean(best_scores), max(best_scores), std(best_scores)];

    fprintf('  %s: Best=%.4f  Mean=%.4f  Worst=%.4f  STD=%.4f\n\n', name, ...
        results.(name).stats(1), results.(name).stats(2), ...
        results.(name).stats(3), results.(name).stats(4));
end

%% 5. Luu ket qua
save('BD_optimization_results.mat', 'results', 'catalog', 'soil', 'N', 'Tmax', 'nRuns');

%% 6. Xuat bang thong ke nhanh ra file .xlsx (Bang 4 trong ban thao)
algo_names = fieldnames(results);
T = table();
for a = 1:numel(algo_names)
    s = results.(algo_names{a}).stats;
    T = [T; {algo_names{a}, s(1), s(2), s(3), s(4)}]; %#ok<AGROW>
end
T.Properties.VariableNames = {'Algorithm', 'Best', 'Mean', 'Worst', 'STD'};
writetable(T, 'Bang4_KetQuaThongKe.xlsx');

disp('Hoan thanh. Xem file BD_optimization_results.mat va Bang4_KetQuaThongKe.xlsx');
