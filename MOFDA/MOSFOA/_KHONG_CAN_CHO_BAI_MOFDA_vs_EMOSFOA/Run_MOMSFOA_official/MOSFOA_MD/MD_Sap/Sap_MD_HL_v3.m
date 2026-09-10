function [fit, diagnostic]=Sap_MD_HL_v3(X,data)
% close all; clear all; clc
% open_Sap2000(0);
% Sap_name0 = 'MD_v3.sdb';
% Sap_path0 = fullfile(pwd,'MD_Sap',Sap_name0);
% SM.File.OpenFile(Sap_path0);
load gamma.mat
Mcr = data(X(:,1),4); L0 = 11; Price = data(X(:,1),8);

Pile_top = [1.5  1.5  11;
            0    1.5  11;
           -1.5  1.5  11;
           -1.5  0    11;
           -1.5 -1.5  11;
            0   -1.5  11;
            1.5 -1.5  11;
            1.5  0    11;
            0    0    11];
N_coc = size(Pile_top,1);
Incline_P = Inf(N_coc,1);
Angle_P = zeros(N_coc,1);

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
    L_in_soil = X(ix,3) - L0;
    layer_tip = find(L_in_soil(1) <= cumsum(h), 1, 'first');
    itip = type_soil(layer_tip);
    htip_layer = h(layer_tip);

    D = zeros(N_coc,3); S = zeros(N_coc,3);
    Incline_P(1:8) = X(ix,2);
    Angle_P(1:8) = [pi/4, pi/2, 3*pi/4, pi, 5*pi/4, 3*pi/2, 7*pi/4, 2*pi];
    D_P = data(X(ix,1),1)/1000;
    t_P = data(X(ix,1),2)/1000;

    segment = 1; f_r = ones(1,length(IL)); t_r = 1;
    A_tip = (pi*(D_P)^2)/4;
    C_p = pi*D_P;
    [Nk_p, N_p, ILi] = pile_bearing_capacity(gamma,L_in_soil(1),A_tip,C_p,h,IL,segment,f_r,t_r,itip);

    lengthConditionOK = X(ix,3) >= L_u;
    tipSoilConditionOK = ILi(end) < 0.4;
    tipLayerThicknessOK = htip_layer >= 2;
    geometryFeasible = lengthConditionOK && tipSoilConditionOK && tipLayerThicknessOK;

    if geometryFeasible
        for i = 1:N_coc
            [D(i,:), ~] = pile_create(Pile_top(i,:),atan(1/Incline_P(i)),Angle_P(i),[0,L_u],-1);
            [S(i,:), ~] = pile_create(Pile_top(i,:),atan(1/Incline_P(i)),Angle_P(i),[0,X(ix,3)],-1);
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
        [ret,NumberResults,Obj,Elm,LoadCase,StepType,StepNum,U1,U2,U3,R1,R2,R3] = SM.Results.JointDisplAbs('Nodes', SM.eItemTypeElm.GroupElm);
        U_max  = max(sqrt(U1.^2 + U2.^2 + U3.^2));

        [ret,NumberResults,Obj,ObjSta,Elm,ElmSta,LoadCase,StepType,StepNum,P,V2,V3,T,M2,M3] = SM.Results.FrameForce('Piles',SM.eItemTypeElm.GroupElm);
        maxAbsM2 = max(abs(M2));
        maxAbsM3 = max(abs(M3));
        g1(ix,1) = max(maxAbsM2 - Mcr(ix),0);
        g1(ix,2) = max(maxAbsM3 - Mcr(ix),0);

        [ret,NumberResults,Obj,Elm,LoadCase,StepType,StepNum,F1s,F2s,F3s,M1,M2,M3] = SM.Results.JointReact('Supports',SM.eItemTypeElm.GroupElm);
        maxAbsAxialReaction = max(abs(F3s));
        g2(ix) = sum(max(abs(F3s)-N_p(1),0));

        [ret,NumberItems,PointName,LoadPat,LCStep,CSys,F1a,F2a,F3a,M1,M2,M3] = SM.PointElm.GetLoadForce('Anchor','ItemTypeElm',SM.eItemTypeElm.GroupElm);
        Nk_p_total = Nk_p(1)*size(S,1);
        SM.Results.Setup.DeselectAllCasesAndCombosForOutput;
        SM.Results.Setup.SetComboSelectedForOutput('COMB1');
        [ret,NumberResults,Obj,Elm,LoadCase,StepType,StepNum,F1ss,F2ss,F3ss,M1,M2,M3] = SM.Results.JointReact('Supports',SM.eItemTypeElm.GroupElm);
        upliftDemand = max(abs(F3a));
        upliftResistance = sum(F3ss) + Nk_p_total;
        g3(ix) = max(upliftDemand - upliftResistance,0);

        Cost_P = X(ix,3) * Price(ix) * N_coc;
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
