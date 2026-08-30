function [fit,g]=Sap_BD_HL_v3(X,data)
% close all; clear all; clc
% open_Sap2000(0);
% Sap_name0 = 'BD.sdb';
% Sap_path0 = fullfile(pwd,'BD_Sap',Sap_name0);
% SM.File.OpenFile(Sap_path0);
load gamma.mat
% load test_BD_v3.mat
% load BD_curent_design.mat
% X=[22 6 39];
Mcr = data(X(:,1),4); Price = data(X(:,1),8); 
           %X     Y    Z
Pile_top = [0.9  0.9   -1; %D1-S1-thẳng
            2.1  0.9   -1; %D2-S2-xiên 
            4.2  0.9   -1; %D3-S3-thẳng 
            6.3  0.9   -1; %D4-S4-xiên
            7.5  0.9   -1; %D5-S5-thẳng
            3.0  2.7    0; %D6-S6-xiên
            5.4  2.7    0; %D7-S7-xiên
            1.5  3.3    0; %D8-S8-xiên
            6.9  3.3    0; %D9-S9-xiên
            0.9  4.8    0; %D10-S10-thẳng
            4.2  4.8    0; %D11-S11-thẳng
            7.5  4.8    0; %D12-S12-thẳng
            1.5  6.3    0; %D13-S13-xiên
            6.9  6.3    0; %D14-S14-xiên
            3.0  6.9    0; %D15-S15-xiên
            5.4  6.9    0; %D16-S16-xien
            0.9  8.7    0; %D17-S17-thẳng
            4.2  8.7    0; %D18-S18-thẳng
            7.5  8.7    0];%D19-S19-thẳng
N_coc = size(Pile_top,1);
L0=ones(N_coc,1)*11+Pile_top(:,3); 
Incline_P = Inf(N_coc,1); 
Angle_P = zeros(N_coc,1); Angle_P([2,4,15,16])=pi/2;
h  = [4.8 5.3 9.6 1.7 4.9 2.3];
IL = [0.76 0.31 0.63 0.35 0.67 0.2];
type_soil = [1 1 1 1 1 2]; % 1 là sét; 2 là cát 
k       = get_k_from_IL(IL);
kq      = get_equivalent_k_multi(h, k);
E0      = select_concrete_E_by_grade(400); % Chọn bê tông mác 300 (MPa)

g1 = zeros(size(X,1),2);   % lưu vi phạm moment 2 chiều
fit = zeros(size(X,1),2);  % [Cost_P, U_max]
g2 = zeros(size(X,1),1);   % lưu vi phạm sức chịu tải của cọc
g3 = zeros(size(X,1),1);   % lưu vi phạm sức chịu nhổ của cọc
% g4 = zeros(size(X,1),1);   % lưu vi phạm sức chịu nhổ của cọc
% g5 = zeros(size(X,1),1);   % lưu vi phạm sức chịu nhổ của cọc

for ix = 1:size(X,1)
    ret=SM.SetModelIsLocked(false); % Mở khóa mô hình tính để thực hiện cập nhật lại thông số
    ret=SM.SetPresentUnits(SM.eUnits.kN_m_C);
    I       = calc_section_inertia('hollow_round', data(X(ix,1),1:2)/1000);
    bp      = get_equivalent_pile_width(data(X(ix,1),1)/1000);
    alpha_e = (bp.*kq/(gamma.c*E0*I)).^(1/5);
    lu = 2./alpha_e; % chiều dài chịu uốn tính từ mặt đất
    layer = find(lu <= cumsum(h), 1, 'first');
    lu = 2./alpha_e(layer);
    L_u = lu+L0; L_total = X(ix,3)+Pile_top(:,3); L_in_soil = L_total-L0;
    layer_tip = find(L_in_soil(1) <= cumsum(h), 1, 'first');
    itip = type_soil(layer_tip);
    D = zeros(N_coc,3); S = zeros(N_coc,3);
    Incline_P([2,4,6,7,8,9,13,14,15,16]) = X(ix,2);
    Angle_P([6,7,8,9,13,14])=[3*pi/2, 3*pi/2, 4*pi/3, 5*pi/3, 2*pi/3, pi/3];
    D_P=data(X(ix,1),1)/1000; t_P=data(X(ix,1),2)/1000;
    % Tính sức chịu tải của cọc
    segment=1;f_r = ones(1,length(IL));t_r = 1;
    A_tip = (pi*(D_P)^2)/4; % diện tích mũi cọc
    C_p = pi*D_P; % Chu vi thân cọc
    [Nk_p, N_p,ILi] = pile_bearing_capacity(gamma,L_in_soil(1),A_tip,C_p,h,IL,segment,f_r,t_r,itip);
    if L_total>=L_u & ILi(end)<0.4
        for i=1:N_coc
            [D(i,:), ~]     = pile_create(Pile_top(i,:),atan(1/Incline_P(i)),Angle_P(i),[0,L_u(i)],-1);
            [S(i,:), ~]     = pile_create(Pile_top(i,:),atan(1/Incline_P(i)),Angle_P(i),[0,L_total(i)],-1);
        end
    
        for n = 1:N_coc
            nodeS = sprintf('S%d',n); nodeD = sprintf('D%d',n);
            SM.PointObj.SetSelected(nodeS,true); SM.EditPoint.Align(1,S(n,1));
            SM.PointObj.SetSelected(nodeS,true); SM.EditPoint.Align(2,S(n,2));
            SM.PointObj.SetSelected(nodeS,true); SM.EditPoint.Align(3,S(n,3));
    
            SM.PointObj.SetSelected(nodeD,true); SM.EditPoint.Align(1,D(n,1));
            SM.PointObj.SetSelected(nodeD,true); SM.EditPoint.Align(2,D(n,2));
            SM.PointObj.SetSelected(nodeD,true); SM.EditPoint.Align(3,D(n,3));
            SM.SelectObj.ClearSelection;
        end
            ret=SM.PropFrame.SetPipe('COC', 'BTCTCOC', D_P, t_P);
            SM.Analyze.RunAnalysis;
            SM.Results.Setup.DeselectAllCasesAndCombosForOutput;
            SM.Results.Setup.SetComboSelectedForOutput('BAO');
            [ret,NumberResults,Obj,Elm,LoadCase,StepType,StepNum,U1,U2,U3,R1,R2,R3] = SM.Results.JointDisplAbs('Top_points', SM.eItemTypeElm.GroupElm);
            U_max  = max(sqrt(U1.^2 + U2.^2 + U3.^2));
            [ret,NumberResults,Obj,ObjSta,Elm,ElmSta,LoadCase,StepType,StepNum,P,V2,V3,T,M2,M3]  = SM.Results.FrameForce('Piles',SM.eItemTypeElm.GroupElm);
            g1(ix,1) = max(max(abs(M2)) - Mcr(ix),0);
            g1(ix,2) = max(max(abs(M3)) - Mcr(ix),0);
            % Kiểm tra sức chịu tải cọc
            [ret,NumberResults,Obj,Elm,LoadCase,StepType,StepNum,F1,F2,F3s,M1,M2,M3] = SM.Results.JointReact('Restrains',SM.eItemTypeElm.GroupElm);
            g2(ix) = sum(max(abs(F3s)-N_p(1),0)); % Kiểm tra điều kiện sức chịu tải cọc của mỗi cọc
            % Tổng lực nhổ cọc
            [ret,NumberItems,PointName,LoadPat,LCStep,CSys,F1,F2,F3a,M1,M2,M3] = SM.PointElm.GetLoadForce('Mooring','ItemTypeElm',SM.eItemTypeElm.GroupElm);
            % Tổng lực chống nhổ
            Nk_p_total = Nk_p(1)*size(S,1); % Tổng lực ma sát cọc
            % và tổng khối lượng kết cấu
            SM.Results.Setup.DeselectAllCasesAndCombosForOutput;
            SM.Results.Setup.SetComboSelectedForOutput('COMB1');
            [ret,NumberResults,Obj,Elm,LoadCase,StepType,StepNum,F1,F2,F3ss,M1,M2,M3]=SM.Results.JointReact('Restrains',SM.eItemTypeElm.GroupElm);
            g3(ix) = max(abs(F3a)-(sum(F3ss)+Nk_p_total),0);
            % Kiểm tra tính hợp lý khoảng cách giữa các cọc
            % g4(ix) = max(D_P-1.2,0);
            % Kiểm tra khoảng cách mép đài với mép cọc ngoài cùng
            % g5(ix) = abs(min((0.65-D_P/2),0));
            
            % Hàm mục tiêu và penalty
            Cost_P = sum(L_total) * Price(ix);
            
            penalty = 1e6 .* (sum(g1(ix,:)) + g2(ix) + g3(ix));%+ g4(ix));%+ g5(ix));
        
            fit(ix,1) = Cost_P + penalty;
            fit(ix,2) = U_max  + penalty;
    else
        fit(ix,:) = 1e9;
    end
end
    g = [sum(g1,2), g2, g3];%, g4];%, g5];
end
