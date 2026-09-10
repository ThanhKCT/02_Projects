function [fit, diagnostic]=Sap_BD_HL_v3(X,data)
% close all; clear all; clc
% open_Sap2000(0);
% Sap_name0 = 'BD.sdb';
% Sap_path0 = fullfile(pwd,'BD_Sap',Sap_name0);
% SM.File.OpenFile(Sap_path0);
load gamma.mat
Mcr = data(X(:,1),4); Price = data(X(:,1),8);

Pile_top = [0.9  0.9   -1;
            2.1  0.9   -1;
            4.2  0.9   -1;
            6.3  0.9   -1;
            7.5  0.9   -1;
            3.0  2.7    0;
            5.4  2.7    0;
            1.5  3.3    0;
            6.9  3.3    0;
            0.9  4.8    0;
            4.2  4.8    0;
            7.5  4.8    0;
            1.5  6.3    0;
            6.9  6.3    0;
            3.0  6.9    0;
            5.4  6.9    0;
            0.9  8.7    0;
            4.2  8.7    0;
            7.5  8.7    0];
N_coc = size(Pile_top,1);
L0 = ones(N_coc,1)*11 + Pile_top(:,3);
Incline_P = Inf(N_coc,1);
Angle_P = zeros(N_coc,1); Angle_P([2,4,15,16]) = pi/2;

h  = [4.8 5.3 9.6 1.7 4.9 2.3];
IL = [0.76 0.31 0.63 0.35 0.67 0.2];
type_soil = [1 1 1 1 1 2]; % 1: clay; 2: sand
k       = get_k_from_IL(IL);
kq      = get_equivalent_k_multi(h, k);
E0      = select_concrete_E_by_grade(400); % Concrete grade 400 (MPa)

g1 = zeros(size(X,1),2);   % biaxial moment violations
fit = zeros(size(X,1),2);  % [Cost_P, U_max]
g2 = zeros(size(X,1),1);   % pile bearing-capacity violation
g3 = zeros(size(X,1),1);   % pile uplift-capacity violation

diagnostic = nan(size(X,1),20);
penaltyCoefficient = 1e6;
hardPenalty = 1e9;

for ix = 1:size(X,1)
    SM.SetModelIsLocked(false);
    SM.SetPresentUnits(SM.eUnits.kN_m_C);

    I       = calc_section_inertia('hollow_round', data(X(ix,1),1:2)/1000);
    bp      = get_equivalent_pile_width(data(X(ix,1),1)/1000);
    alpha_e = (bp.*kq/(gamma.c*E0*I)).^(1/5);
    lu = 2./alpha_e;
    layer = find(lu <= cumsum(h), 1, 'first');
    lu = 2./alpha_e(layer);
    L_u = lu + L0;
    L_total = X(ix,3) + Pile_top(:,3);
    L_in_soil = L_total - L0;
    layer_tip = find(L_in_soil(1) <= cumsum(h), 1, 'first');
    itip = type_soil(layer_tip);
    htip_layer = h(layer_tip);

    D = zeros(N_coc,3); S = zeros(N_coc,3);
    Incline_P([2,4,6,7,8,9,13,14,15,16]) = X(ix,2);
    Angle_P([6,7,8,9,13,14]) = [3*pi/2, 3*pi/2, 4*pi/3, 5*pi/3, 2*pi/3, pi/3];
    D_P = data(X(ix,1),1)/1000;
    t_P = data(X(ix,1),2)/1000;

    segment = 1; f_r = ones(1,length(IL)); t_r = 1;
    A_tip = (pi*(D_P)^2)/4;
    C_p = pi*D_P;
    [Nk_p, N_p, ILi] = pile_bearing_capacity(gamma,L_in_soil(1),A_tip,C_p,h,IL,segment,f_r,t_r,itip);

    lengthConditionOK = L_total(1) >= L_u(1);
    tipSoilConditionOK = ILi(end) < 0.4;
    tipLayerThicknessOK = htip_layer >= 2;
    geometryFeasible = lengthConditionOK && tipSoilConditionOK && tipLayerThicknessOK;

    if geometryFeasible
        for i = 1:N_coc
            [D(i,:), ~] = pile_create(Pile_top(i,:),atan(1/Incline_P(i)),Angle_P(i),[0,L_u(i)],-1);
            [S(i,:), ~] = pile_create(Pile_top(i,:),atan(1/Incline_P(i)),Angle_P(i),[0,L_total(i)],-1);
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

        SM.PropFrame.SetPipe('COC', 'BTCTCOC', D_P, t_P);
        try; SM.Hide; catch; end
        SM.Analyze.RunAnalysis;
        try; SM.Hide; catch; end

        SM.Results.Setup.DeselectAllCasesAndCombosForOutput;
        SM.Results.Setup.SetComboSelectedForOutput('BAO');
        [ret,NumberResults,Obj,Elm,LoadCase,StepType,StepNum,U1,U2,U3,R1,R2,R3] = SM.Results.JointDisplAbs('Top_points', SM.eItemTypeElm.GroupElm);
        U_max  = max(sqrt(U1.^2 + U2.^2 + U3.^2));

        [ret,NumberResults,Obj,ObjSta,Elm,ElmSta,LoadCase,StepType,StepNum,P,V2,V3,T,M2,M3] = SM.Results.FrameForce('Piles',SM.eItemTypeElm.GroupElm);
        maxAbsM2 = max(abs(M2));
        maxAbsM3 = max(abs(M3));
        g1(ix,1) = max(maxAbsM2 - Mcr(ix),0);
        g1(ix,2) = max(maxAbsM3 - Mcr(ix),0);

        [ret,NumberResults,Obj,Elm,LoadCase,StepType,StepNum,F1,F2,F3s,M1,M2,M3] = SM.Results.JointReact('Restrains',SM.eItemTypeElm.GroupElm);
        maxAbsAxialReaction = max(abs(F3s));
        g2(ix) = sum(max(abs(F3s)-N_p(1),0));

        [ret,NumberItems,PointName,LoadPat,LCStep,CSys,F1,F2,F3a,M1,M2,M3] = SM.PointElm.GetLoadForce('Mooring','ItemTypeElm',SM.eItemTypeElm.GroupElm);
        Nk_p_total = Nk_p(1)*size(S,1);
        SM.Results.Setup.DeselectAllCasesAndCombosForOutput;
        SM.Results.Setup.SetComboSelectedForOutput('COMB1');
        [ret,NumberResults,Obj,Elm,LoadCase,StepType,StepNum,F1,F2,F3ss,M1,M2,M3] = SM.Results.JointReact('Restrains',SM.eItemTypeElm.GroupElm);
        upliftDemand = max(abs(F3a));
        upliftResistance = sum(F3ss) + Nk_p_total;
        g3(ix) = max(upliftDemand - upliftResistance,0);

        Cost_P = sum(L_total) * Price(ix);
        totalStructuralViolation = sum(g1(ix,:)) + g2(ix) + g3(ix);
        penalty = penaltyCoefficient .* totalStructuralViolation;

        fit(ix,1) = Cost_P + penalty;
        fit(ix,2) = U_max  + penalty;
        diagnostic(ix,:) = [Cost_P, U_max, maxAbsM2, maxAbsM3, Mcr(ix), ...
            maxAbsAxialReaction, N_p(1), g1(ix,1), g1(ix,2), g2(ix), ...
            upliftDemand, upliftResistance, g3(ix), totalStructuralViolation, ...
            penalty, lengthConditionOK, tipSoilConditionOK, tipLayerThicknessOK, ...
            1, totalStructuralViolation <= 1e-9];
    else
        fit(ix,:) = hardPenalty;
        diagnostic(ix,:) = [nan(1,7), nan(1,7), hardPenalty, ...
            lengthConditionOK, tipSoilConditionOK, tipLayerThicknessOK, 0, 0];
    end
end

end
