function [fit,g]=Sap_MD_HL_v2(X,data)
% close all; clear all; clc
load gamma.mat
load test_BD_v1.mat
Mcr = data(X(:,1),4); L0=11; Price = data(X(:,1),8); 
           %X     Y    Z
Pile_top = [1.5  1.5  11;
            0    1.5  11;
           -1.5  1.5  11;
           -1.5  0    11;
           -1.5 -1.5  11;
            0   -1.5  11;
            1.5 -1.5  11;
            1.5  0    11;
            0    0    11];
h  = [4.8 5.3 9.6 1.7 4.9 2.3];
IL = [0.76 0.31 0.63 0.31 0.67 0.3];
k       = get_k_from_IL(IL);
kq      = get_equivalent_k_multi(h, k);
E0      = select_concrete_E_by_grade(400); % Chọn bê tông mác 300 (MPa)

g1 = zeros(size(X,1),2);   % lưu vi phạm moment 2 chiều
fit = zeros(size(X,1),2);  % [Cost_P, U_max]
g2 = zeros(size(X,1),1);   % lưu vi phạm sức chịu tải của cọc
g3 = zeros(size(X,1),1);   % lưu vi phạm sức chịu nhổ của cọc
g4 = zeros(size(X,1),1);   % lưu vi phạm sức chịu nhổ của cọc
g5 = zeros(size(X,1),1);   % lưu vi phạm sức chịu nhổ của cọc

for ix = 1:size(X,1)
    SM.SetModelIsLocked(false); % Mở khóa mô hình tính để thực hiện cập nhật lại thông số
    SM.SetPresentUnits(SM.eUnits.kN_m_C);
    I       = calc_section_inertia('hollow_round', data(X(ix,1),1:2)/1000);
    bp      = get_equivalent_pile_width(data(X(ix,1),1)/1000);
    alpha_e = (bp.*kq/(gamma.c*E0*I)).^(1/5);
    lu = 2./alpha_e; % chiều dài chịu uốn tính từ mặt đất
    layer = find(lu <= cumsum(h), 1, 'first');
    lu = 2./alpha_e(layer);
    L_u = lu+L0; L_in_soil = X(ix,7)-L0;
if X(ix,7)>=L_u
    D = zeros(9,3); S = zeros(9,3);
    for i = 1:4
        [D(i,:), ~]     = pile_create(Pile_top(i,:),     atan(1/X(ix,6)), X(ix,i+1),       [0,L_u],    -1);
        [D(i+4,:), ~]   = pile_create(Pile_top(i+4,:),   atan(1/X(ix,6)), X(ix,i+1)+pi,    [0,L_u],    -1);
        [S(i,:), ~]     = pile_create(Pile_top(i,:),     atan(1/X(ix,6)), X(ix,i+1),       [0,X(ix,7)],-1);
        [S(i+4,:), ~]   = pile_create(Pile_top(i+4,:),   atan(1/X(ix,6)), X(ix,i+1)+pi,    [0,X(ix,7)],-1);
    end
    [D(9,:), ~] = pile_create(Pile_top(9,:), atan(0), 0,[0,L_u],    -1);
    [S(9,:), ~] = pile_create(Pile_top(9,:), atan(0), 0,[0,X(ix,7)],-1);

    for n = 1:9
        nodeS = sprintf('S%d',n); nodeD = sprintf('D%d',n);
        SM.PointObj.SetSelected(nodeS,true); SM.EditPoint.Align(1,S(n,1));
        SM.PointObj.SetSelected(nodeS,true); SM.EditPoint.Align(2,S(n,2));
        SM.PointObj.SetSelected(nodeS,true); SM.EditPoint.Align(3,S(n,3));

        SM.PointObj.SetSelected(nodeD,true); SM.EditPoint.Align(1,D(n,1));
        SM.PointObj.SetSelected(nodeD,true); SM.EditPoint.Align(2,D(n,2));
        SM.PointObj.SetSelected(nodeD,true); SM.EditPoint.Align(3,D(n,3));
        SM.SelectObj.ClearSelection;
    end
    D_P=data(X(ix,1),1)/1000;
    SM.PropFrame.SetPipe('COC', 'BTCTCOC', D_P, data(X(ix,1),2)/1000);
    SM.Analyze.RunAnalysis;
    SM.Results.Setup.DeselectAllCasesAndCombosForOutput;
    SM.Results.Setup.SetComboSelectedForOutput('BAO');
    % [ret,NumberResults,Obj,Elm,LoadCase,StepType,StepNum,U1,U2,U3,R1,R2,R3]=SM.Results.JointDisplAbs('Nodes',SM.eItemTypeElm.GroupElm);
    [~,~,~,~,~,~,~,U1,U2,U3,~,~,~] = SM.Results.JointDisplAbs('Nodes', SM.eItemTypeElm.GroupElm);
    % [ret,NumberResults,Obj,ObjSta,Elm,ElmSta,LoadCase,StepType,StepNum,P,V2,V3,T,M2,M3]=SM.Results.FrameForce('Piles',SM.eItemTypeElm.GroupElm);
    [~,~,~,~,~,~,~,~,~,~,~,~,~,M2,M3]  = SM.Results.FrameForce('Piles',SM.eItemTypeElm.GroupElm);

    g1(ix,1) = max(max(abs(M2)) - Mcr(ix),0);
    g1(ix,2) = max(max(abs(M3)) - Mcr(ix),0);
    % Tính sức chịu tải của cọc
    segment=1;f_r = ones(1,length(IL));t_r = 1;itip = 1;
    A_tip = (pi*(data(X(ix,1),1)/1000)^2)/4; % diện tích mũi cọc
    C_p = pi*(data(X(ix,1),1)/1000); % Chu vi thân cọc
    [Nk_p, N_p] = pile_bearing_capacity(gamma,L_in_soil,A_tip,C_p,h,IL,segment,f_r,t_r,itip);
    % Kiểm tra sức chịu tải cọc
    % [ret,NumberResults,Obj,Elm,LoadCase,StepType,StepNum,F1s,F2s,F3s,M1,M2,M3]=SM.Results.JointReact('Supports',SM.eItemTypeElm.GroupElm);
    [~,~,~,~,~,~,~,~,~,F3s,~,~,~] = SM.Results.JointReact('Supports',SM.eItemTypeElm.GroupElm);
    g2(ix) = sum(max(abs(F3s)-N_p(1),0)); % Kiểm tra điều kiện sức chịu tải cọc của mỗi cọc
    % Tổng lực nhổ cọc
    % [ret,NumberItems,PointName,LoadPat,LCStep,CSys,F1a,F2a,F3a,M1,M2,M3] = SM.PointElm.GetLoadForce('Anchor','ItemTypeElm',SM.eItemTypeElm.GroupElm);
    [~,~,~,~,~,~,~,~,F3a,~,~,~] = SM.PointElm.GetLoadForce('Anchor','ItemTypeElm',SM.eItemTypeElm.GroupElm);
    % Tổng lực chống nhổ
    Nk_p_total = Nk_p(1)*size(S,1); % Tổng lực ma sát cọc
    % và tổng khối lượng kết cấu
    SM.Results.Setup.DeselectAllCasesAndCombosForOutput;
    SM.Results.Setup.SetComboSelectedForOutput('COMB1');
    % [ret,NumberResults,Obj,Elm,LoadCase,StepType,StepNum,F1ss,F2ss,F3ss,M1,M2,M3]=SM.Results.JointReact('Supports',SM.eItemTypeElm.GroupElm);
    [~,~,~,~,~,~,~,~,~,F3ss,~,~,~]=SM.Results.JointReact('Supports',SM.eItemTypeElm.GroupElm);
    g3(ix) = max(abs(F3a)-(sum(F3ss)+Nk_p_total),0);
    % Kiểm tra tính hợp lý khoảng cách giữa các cọc
    g4(ix) = max(2.5*D_P-1.5,0);
    % Kiểm tra khoảng cách mép đài với mép cọc ngoài cùng
    g5(ix) = max((D_P/2-0.5),0);
    
    % Hàm mục tiêu và penalty
    Cost_P = X(ix,7) * Price(ix) * 9;
    U_max  = max(sqrt(U1.^2 + U2.^2 + U3.^2));
    penalty = 1e6 .* (sum(g1(ix,:)) + g2(ix) + g3(ix)+ g4(ix)+ g5(ix));

    fit(ix,1) = Cost_P + penalty;
    fit(ix,2) = U_max  + penalty;
else
    fit(ix,:) = 1e9;
end
end
    g = [sum(g1,2), g2, g3, g4, g5];
end
