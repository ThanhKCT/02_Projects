function [fit]=Sap_MPJ(X,data)
% close all; clear all; clc
% open_Sap2000(0)
% Sap_name0 = 'MPJ.sdb';
% Sap_path0 = fullfile(pwd,'MPJ_Sap',Sap_name0);
% SM.File.OpenFile(Sap_path0);
load gamma.mat
% save test_MPJ.mat
load test_MPJ.mat
X=[17 18 4.2 4.5 0.7 1]
Mcr = data(X(:,1),4); L0=11; Price = data(X(:,1),8);
% TB_no=[];LB_no=[];BMC_no=[];

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

SM.SetPresentUnits(SM.eUnits.kN_m_C);
ret = SM.GroupDef.SetGroup('Piles');
ret = SM.GroupDef.SetGroup('Beams');
Restraint0=[true,true,false,true,true,true];
Restraint1=[false,false,true,false,false,false];
% Cho trước kích thước tấm
L = 20; % Chiều dài tấm (theo phương X)
B = 10;  % Chiều rộng tấm (theo phương Y)

% Tính toán tọa độ 4 điểm góc
C1 = [-L/2, -B/2, 0];  % Góc trái dưới
C2 = [L/2, -B/2, 0];   % Góc phải dưới
C3 = [L/2, B/2, 0];    % Góc phải trên
C4 = [-L/2, B/2, 0];   % Góc trái trên

for ix = 1:size(X,1)
    SM.SetModelIsLocked(false); % Mở khóa mô hình tính để thực hiện cập nhật lại thông số
    % Xóa hết các đối tượng để tái tạo mô hình mới
    [ret,AreNames,MyNameA]= SM.AreaObj.GetNameList();
    [ret,FrameNames,MyNameF]=SM.FrameObj.GetNameList();
    for jkl=1:FrameNames
        SM.FrameObj.Delete(MyNameF{jkl});
    end
    for jkl=1:AreNames
        SM.AreaObj.Delete(MyNameA{jkl});
    end
    ret = SM.View.RefreshView;
    % [ret,RebarName] = SM.PropMaterial.AddQuick(SM.eMatType.Rebar,'RebarType',SM.eMatTypeRebar.ASTM_A706);
    % SM.File.Save(Sap_path0);
    clear xyz1 xyz1_full xyz10 xyz11 xyz12 xyz2 xyz3 xyz4

    D_P = data(X(ix,1),1)/1000; t_P = data(X(ix,1),2)/1000;
    I       = calc_section_inertia('hollow_round', data(X(ix,1),1:2)/1000);
    bp      = get_equivalent_pile_width(data(X(ix,1),1)/1000);
    alpha_e = (bp.*kq/(gamma.c*E0*I)).^(1/5);
    lu = 2./alpha_e; % chiều dài chịu uốn tính từ mặt đất
    layer = find(lu <= cumsum(h), 1, 'first');
    lu = 2./alpha_e(layer);
    L_u = lu+L0; L_in_soil = X(ix,2)-L0;
    layer_tip = find(L_in_soil(1) <= cumsum(h), 1, 'first');
    itip = type_soil(layer_tip); htip_layer = h(layer_tip);
    % Tính sức chịu tải của cọc
    segment=1;f_r = ones(1,length(IL));t_r = 1;
    A_tip = (pi*(D_P)^2)/4; % diện tích mũi cọc
    C_p = pi*D_P; % Chu vi thân cọc
    [Nk_p, N_p,ILi] = pile_bearing_capacity(gamma,L_in_soil,A_tip,C_p,h,IL,segment,f_r,t_r,itip);

    if X(ix,2)>=L_u && ILi(end)<0.4 && htip_layer>=2 && (D_P+0.2)<=X(ix,6)
        [xyz1,xyz2,xyz3,xyz4,N,M,l_1,k_1] = createControlPoints2(L, B, X(ix,3), X(ix,4), 0,-3,-L_u,-X(ix,2));
        % 1-Vẽ dầm ngang
        xyz10 = mat2cell(xyz1,(N+1)*ones(1,M+1),3)';
        Total_LP=abs(sum(xyz4(:,3)-xyz1(:,3)))-abs(sum((xyz2(1:length(xyz10{1}),3))));
        edY1 = xyz10{1}-[0,k_1,0];
        edY2 = xyz10{end}+[0,k_1,0];
        xyz11 = [{edY1},xyz10,{edY2}];
        Noo_TB = {};
        for ii = 1:length(xyz11)
            if ii<length(xyz11)
                ji=ii+1;
                for ki=1:size(xyz11{1},1)
                    [ret,No_TB] = SM.FrameObj.AddByCoord(xyz11{ii}(ki,1), xyz11{ii}(ki,2), xyz11{ii}(ki,3),...
                                   xyz11{ji}(ki,1), xyz11{ji}(ki,2), xyz11{ji}(ki,3),'PropName','TB');%,'UserName','YBeam');
                    % Noo_TB = [Noo_TB; No_TB]
                    Noo_TB{end+1,1} = No_TB;
                end
            end
        end
        ret = SM.View.RefreshView;
        % 2-Vẽ dầm dọc
        for i=1:size(xyz11{1},1)
            xyz12{i} = cell2mat(cellfun(@(x) [x(i, :)]', xyz10, 'UniformOutput', false))';
        end
        edX1 = xyz12{1}-[l_1,0,0];
        edX2 = xyz12{end}+[l_1,0,0];
        xyz12 = [{edX1},xyz12,{edX2}];
        Noo_LB={};
        for ii = 1:length(xyz12)
            if ii<length(xyz12)
                ji=ii+1;
                for ki=1:size(xyz12{1},1)
                    [ret,No_LB] = SM.FrameObj.AddByCoord(xyz12{ii}(ki,1), xyz12{ii}(ki,2), xyz12{ii}(ki,3),...
                                   xyz12{ji}(ki,1), xyz12{ji}(ki,2), xyz12{ji}(ki,3),'PropName','LB');%,'UserName','XBeam');
                    Noo_LB{end+1,1} = No_LB;
                end
            end
        end
        ret = SM.View.RefreshView;
        % 3-Vẽ dầm mở rộng và cọc
        xyz2 = mat2cell(xyz2,(N+1)*ones(1,M+1),3)';
        xyz3 = mat2cell(xyz3,(N+1)*ones(1,M+1),3)';
        xyz4 = mat2cell(xyz4,(N+1)*ones(1,M+1),3)';
        Noo_EB = {};
        for ik=1:length(xyz10)
            if ik==1
                for jk=1:N+1
                    [ret,No_EB] = SM.FrameObj.AddByCoord(xyz10{ik}(jk,1), xyz10{ik}(jk,2), xyz10{ik}(jk,3),...
                                   xyz2{ik}(jk,1), xyz2{ik}(jk,2), xyz2{ik}(jk,3),'PropName','EB');%,'UserName','EXBeam');
                    % Noo_EB = [Noo_EB; No_EB];
                    Noo_EB{end+1,1} = No_EB;
                    ret = SM.FrameObj.SetLocalAxes(No_EB,90);
                    [ret,CC] = SM.FrameObj.AddByCoord(xyz2{ik}(jk,1), xyz2{ik}(jk,2), xyz2{ik}(jk,3),...
                                   xyz3{ik}(jk,1), xyz3{ik}(jk,2), xyz3{ik}(jk,3),'PropName','Piles');%,'UserName','Pile');
                    [ret,CC] = SM.FrameObj.AddByCoord(xyz3{ik}(jk,1), xyz3{ik}(jk,2), xyz3{ik}(jk,3),...
                                       xyz4{ik}(jk,1), xyz4{ik}(jk,2), xyz4{ik}(jk,3),'PropName','Piles');%,'UserName','Pile');
                    [ret,PointName1,PointName2]=SM.FrameObj.GetPoints(CC);
                    [ret]=SM.PointObj.SetRestraint(PointName1, Restraint0);
                    [ret]=SM.PointObj.SetRestraint(PointName2, Restraint1);
    
                end
            else
                for jk=1:size(xyz10{1},1)
                    ret = SM.FrameObj.AddByCoord(xyz10{ik}(jk,1), xyz10{ik}(jk,2), xyz10{ik}(jk,3),...
                                       xyz3{ik}(jk,1), xyz3{ik}(jk,2), xyz3{ik}(jk,3),'PropName','Piles');%,'UserName','Pile');
                    [ret,CC] = SM.FrameObj.AddByCoord(xyz3{ik}(jk,1), xyz3{ik}(jk,2), xyz3{ik}(jk,3),...
                                       xyz4{ik}(jk,1), xyz4{ik}(jk,2), xyz4{ik}(jk,3),'PropName','Piles');%,'UserName','Pile');
                    [ret,PointName1,PointName2]=SM.FrameObj.GetPoints(CC);
                    [ret]=SM.PointObj.SetRestraint(PointName1, Restraint0);
                    [ret]=SM.PointObj.SetRestraint(PointName2, Restraint1);
                end
            end
        end
        ret = SM.View.RefreshView;
        % 4-Vẽ dầm chặn gầm cầu
        Noo_EB1 = {};
        for i = 1:size(xyz2{1},1)
            if i<size(xyz2{1},1)
                j=i+1;
                [ret,No_EB1] = SM.FrameObj.AddByCoord(xyz2{1}(i,1), xyz2{1}(i,2), xyz2{1}(i,3),...
                                           xyz2{1}(j,1), xyz2{1}(j,2), xyz2{1}(j,3),'PropName','EB-1');
                % Noo_EB1 = [Noo_EB1; No_EB1];
                Noo_EB1{end+1,1} = No_EB1;
            end
        end
        % Thiết lập kích thước các phần tử kết cấu
        ret = SM.PropFrame.SetRectangle('TB', 'BTCT', X(ix,5), X(ix,6));
        ret = SM.PropFrame.SetRectangle('LB', 'BTCT', X(ix,5), X(ix,6));
        ret = SM.PropFrame.SetRectangle('EB', 'BTCT', max(1.2,D_P+2*0.1),X(ix,6));
        ret = SM.PropFrame.SetRectangle('EB-1', 'BTCT', X(ix,6),X(ix,6));
        SM.PropFrame.SetPipe('Piles', 'BTCTCOC', D_P, t_P);
        ret = SM.View.RefreshView; 
        ret = SM.PropFrame.SetRebarColumn('TB', 'A706', 'A706', 1, 0, 0.05, 0, 2, 2, '12d', '10d', 0.1, 2, 2, true);
        ret = SM.PropFrame.SetRebarColumn('LB', 'A706', 'A706', 1, 0, 0.05, 0, 2, 2, '12d', '10d', 0.1, 2, 2, true);
        ret = SM.PropFrame.SetRebarColumn('EB', 'A706', 'A706', 1, 0, 0.05, 0, 2, 2, '12d', '10d', 0.1, 2, 2, true);
        ret = SM.PropFrame.SetRebarColumn('EB-1', 'A706', 'A706', 1, 0, 0.05, 0, 2, 2, '12d', '10d', 0.1, 2, 2, true);
        % Vẽ bản mặt cầu
        lp=[C1; edX1; C4];
        rp=[C2; edX2; C3];
        for iii=1:length(xyz11)
           xyz1_full{iii}=[lp(iii,:); xyz11{iii}; rp(iii,:)];
        end
        for i1=1:length(xyz1_full)-1
            for i2=1:size(xyz1_full{1},1)-1
            P1 = xyz1_full{i1}(i2,:);
            P2 = xyz1_full{i1+1}(i2,:);
            P3 = xyz1_full{i1+1}(i2+1,:);
            P4 = xyz1_full{i1}(i2+1,:);
            [ret,No_Deck] = SM.AreaObj.AddByCoord(4, [P1(:,1) P2(:,1) P3(:,1) P4(:,1)],...
                                                  [P1(:,2) P2(:,2) P3(:,2) P4(:,2)], ...
                                                  [P1(:,3) P2(:,3) P3(:,3) P4(:,3)],'PropName','Deck');
            % BMC_no = [BMC_no,str2num(No_BMC)];
            ret = SM.AreaObj.SetLoadUniform(No_Deck, 'LL', 9.81, 10,'Replace',false);
            ret = SM.AreaObj.SetAutoMesh(No_Deck, 1,'n1',3,'n2',3);
            end
        end
        ret = SM.View.RefreshView;
        SM.Analyze.RunAnalysis;
        SM.Results.Setup.DeselectAllCasesAndCombosForOutput;
        SM.Results.Setup.SetComboSelectedForOutput('BAO');
        [ret,NumberResults,Obj,Elm,LoadCase,StepType,StepNum,U1,U2,U3,R1,R2,R3]=SM.Results.JointDisplAbs('ALL',SM.eItemTypeElm.GroupElm);
        U_max  = max(sqrt(U1.^2 + U2.^2 + U3.^2));
        [ret]=SM.SelectObj.PropertyFrame('Piles');
        [ret,NumberResults,Obj,ObjSta,Elm,ElmSta,LoadCase,StepType,StepNum,P,V2,V3,T,M2,M3]=SM.Results.FrameForce('eItemType',SM.eItemTypeElm.SelectionElm);
        [ret]=SM.SelectObj.ClearSelection();
        g1(ix,1) = max(max(abs(M2)) - Mcr(ix),0);
        g1(ix,2) = max(max(abs(M3)) - Mcr(ix),0);
        % Kiểm tra sức chịu tải cọc
        [ret]=SM.SelectObj.CoordinateRange(-L/2,L/2,-B/2,B/2,-X(ix,2),-X(ix,2));
        [ret,NumberResults,Obj,Elm,LoadCase,StepType,StepNum,F1s,F2s,F3s,M1,M2,M3]=SM.Results.JointReact('eItemType',SM.eItemTypeElm.SelectionElm);
        [ret]=SM.SelectObj.ClearSelection();
        g2(ix) = sum(max(abs(F3s)-N_p(1),0)); % Kiểm tra điều kiện sức chịu tải cọc của mỗi cọc
        ret = SM.DesignConcrete.StartDesign;
        [ret,NumberItems,n1,n2,MyName]= SM.DesignConcrete.VerifyPassed();
        [ret,NumberItems,MyName]=SM.DesignConcrete.VerifySections();
        ret = SM.SelectObj.PropertyFrame('TB');
        No_Beams = [Noo_TB; Noo_LB; Noo_EB; Noo_EB1]; clear Noo_TB Noo_EB1 Noo_EB Noo_LB No_LB No_TB No_EB No_EB1 
        Vs_B=0;Vc_B=0;
        for ik = 1: length(No_Beams)
            [ret,NumberItems,FrameName,MyOption,Location,PMMCombo,PMMArea,PMMRatio,VmajorCombo,AVmajor,VminorCombo,AVminor,ErrorSummary,WarningSummary]=SM.DesignConcrete.GetSummaryResultsColumn(No_Beams{ik});
            [ret,PropName,ObjType,Var,sVarRelStartLoc,sVarTotalLength]=SM.LineElm.GetProperty(sprintf([No_Beams{ik},'-1']));
            [ret,Area,As2,As3,Torsion,I22,I33,S22,S33,Z22,Z33,R22,R33]=SM.PropFrame.GetSectProps(PropName);
            Vs_B = Vs_B + Location(end)*PMMArea(end); % m3
            Vc_B = Vc_B + Location(end)*Area; % m3
        end
        W_B = Vc_B*46.25+Vs_B*7849*0.57; % dolars
        % Kiểm tra tính hợp lý kích thước dầm và cọc
        % g3(ix)=max(D_P+0.2-min(X(ix,5:6)),0);
        % Kiểm tra tính hợp lý kích thước đầu thừa
        % g4(ix)=max((0.25+D_P/2-min(l_1,k_1)),0);
        % Kiểm tra tính hợp lý khoảng cách giữa các cọc
        % g5(ix)= max(2.5*D_P-min(X(ix,3:4)),0);
        Cost_P = X(ix,2) * Price(ix) * (M+1)*(N+1)+W_B;
        penalty = 1e6 .* (sum(g1(ix,:)) + g2(ix));% + g3(ix)+g4(ix));
        fit(ix,1) = Cost_P + penalty;
        fit(ix,2) = U_max  + penalty;
    else
        fit(ix,:) = 1e9;
    end
    
end

end
