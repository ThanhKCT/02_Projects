function FEM = update_BD_model_SAP2000(X_actual)
% UPDATE_BD_MODEL_SAP2000  Cap nhat bien thiet ke vao mo hinh SAP2000 cua
% tru va (BD) qua giao dien OAPI, chay phan tich, va tra ve ket qua noi
% luc/chuyen vi lon nhat.
%
% *** DAY LA KHUNG MAU (TEMPLATE) - CAN DIEU CHINH THEO MO HINH SAP2000
%     THAT CUA ANH/CHI (ten frame, ten group cua coc, duong dan file .sdb,
%     phien ban SAP2000 dang dung: v20 hay v21+ co cu phap OAPI khac nhau
%     mot chut). ***
%
% INPUT:  X_actual = [Dp, tp, theta, Lp]  (da snap ve catalog o objective_function.m)
% OUTPUT: FEM.Rc_FEA, FEM.M_FEA, FEM.disp_max

    persistent SapObject SapModel ModelPath isOpen

    if isempty(isOpen) || ~isOpen
        % ---- Buoc 1: Ket noi SAP2000 (chi thuc hien 1 lan / hoac dinh ky reset) ----
        ModelPath = 'D:\ResearchLab\02_Projects\MOSFOA\SAP2000_models\BD_parametric.sdb'; % TODO: duong dan thuc te
        try
            SapObject = actxserver('CSI.SAP2000.API.SapObject'); % SAP2000 v21+
        catch
            SapObject = actxGetRunningServer('CSI.SAP2000.API.SapObject'); % fallback: dung instance dang mo
        end
        SapObject.ApplicationStart();
        SapModel = SapObject.SapModel;
        SapModel.File.OpenFile(ModelPath);
        isOpen = true;
    end

    Dp    = X_actual(1); % mm
    tp    = X_actual(2); % mm
    theta = X_actual(3); % do
    Lp    = X_actual(4); % m

    %% Buoc 2: Cap nhat tiet dien coc (ong thep/BTCT ung suat truoc, tiet dien tron rong)
    % TODO: thay 'PileSectionName' bang ten section thuc te trong model,
    % va ham SetPipe/SetTube phu hop voi loai tiet dien coc dang dung.
    SectionName = sprintf('PILE_D%d_T%d', round(Dp), round(tp));
    ret = SapModel.PropFrame.SetPipe(SectionName, 'CONC', Dp/1000, tp/1000); %#ok<NASGU>

    % Gan section moi cho toan bo cac frame thuoc group "PILES_BD"
    GroupName = 'PILES_BD'; % TODO: xac nhan dung ten group trong model
    SapModel.FrameObj.SetSection_1(GroupName, SectionName, 0, 1); % ItemType=1: Group

    %% Buoc 3: Cap nhat goc nghieng + chieu dai coc (toa do nut day coc)
    % Cach lam: coc xien duoc dinh nghia bang toa do nut dau (co dinh, tai
    % day dai coc) va nut cuoi (mui coc). Voi goc nghieng theta (ty le 6:1,
    % 7:1, 8:1...) va chieu dai Lp, tinh lai toa do nut mui coc theo tung
    % coc xien, roi goi SetCoordCartesian de cap nhat.
    %
    % TODO: THAY BANG LOGIC HINH HOC THUC TE CUA BO CUC 19 COC BD (9 coc
    % thang + 6 coc xien mat phang + 4 coc xien khong gian) - moi nhom coc
    % co cong thuc toa do khac nhau tuy huong nghieng.
    pile_node_names = get_pile_tip_node_names(); % TODO: ham tra ve danh sach ten nut mui coc
    for k = 1:numel(pile_node_names)
        [x0, y0, z0] = get_pile_head_coord(pile_node_names{k}); %#ok<ASGLU> % TODO
        [xt, yt, zt] = compute_tip_coord(x0, y0, z0, theta, Lp, pile_node_names{k}); % TODO
        SapModel.PointObj.SetCoordCartesian(pile_node_names{k}, xt, yt, zt);
    end

    %% Buoc 4: Chay phan tich
    SapModel.Analyze.RunAnalysis();

    %% Buoc 5: Trich xuat ket qua - luc doc truc va mo men lon nhat trong coc
    SapModel.Results.Setup.DeselectAllCasesAndCombosForOutput();
    SapModel.Results.Setup.SetComboSelectedForOutput('EV-COMB'); % TODO: xac nhan ten combo

    [~, ~, ~, ~, ~, ~, ~, ~, P, ~, M2, M3, ~] = SapModel.Results.FrameForce(...
        GroupName, 1, 0, [], [], [], [], [], [], [], [], [], [], []); %#ok<ASGLU>
    % Cu phap FrameForce chinh xac phu thuoc phien ban OAPI - can doi chieu
    % voi CSI OAPI Documentation (SAP2000 API Reference) khi trien khai thuc te.

    Rc_FEA = max(abs(P));
    M_FEA  = max(sqrt(M2.^2 + M3.^2));

    [~, ~, ~, ~, U1, U2, U3, ~] = SapModel.Results.JointDispl(...
        GroupName, 1, 0, [], [], [], [], [], []); %#ok<ASGLU>
    disp_max = max(sqrt(U1.^2 + U2.^2 + U3.^2));

    FEM.Rc_FEA = Rc_FEA;
    FEM.M_FEA = M_FEA;
    FEM.disp_max = disp_max;

    %% Buoc 6 (khuyen nghi): dong/mo lai SAP2000 dinh ky de tranh treo/memory leak
    % Xem run_SFOA_BD.m - bien dem so lan goi, goi close_SAP2000() sau moi ~200 lan.
end

function close_SAP2000()
    % Goi ham nay tu ben ngoai (run_SFOA_BD.m) de dong SAP2000 dinh ky.
    clear update_BD_model_SAP2000; % xoa persistent -> lan goi sau se mo lai model
end
