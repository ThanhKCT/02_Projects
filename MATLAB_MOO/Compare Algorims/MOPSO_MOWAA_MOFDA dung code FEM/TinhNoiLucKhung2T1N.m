function [U, NoiLuc, DoVong, TrongLuong] = TinhNoiLucKhung2T1N(x)
    % =========================================================================
    % CHUAN HOA HINH HOC KHUNG (dung nhat quan trong toan bo pipeline):
    %   - Khung thep phang 2 TANG, 1 NHIP, khong giang (sway)
    %   - 2 cot, moi cot cao 4m/tang x 2 tang = 8m/cot -> tong dai cot = 16m
    %     (ca 4 doan cot DUNG CHUNG 1 tiet diện: bc,hc,twc,tfc)
    %   - 2 dam, moi dam nhip 10m -> tong dai dam = 20m
    %     (ca 2 dam DUNG CHUNG 1 tiet diện: bd,hd,twd,tfd)
    %   - Ngam chan cot, lien ket CUNG dam-cot
    % =========================================================================
    % 1. KÍCH THƯỚC TIẾT DIỆN (Biến quyết định từ thuật toán tối ưu)
    bc=x(1); hc=x(2); twc=x(3); tfc=x(4); % Cột (dùng chung cho cả 4 đoạn cột)
    bd=x(5); hd=x(6); twd=x(7); tfd=x(8); % Dầm (dùng chung cho cả 2 dầm)

    % 2. KHAI BÁO VẬT LIỆU & HÌNH HỌC
    E = 21000000; % T/m2
    G = 8076923.08; % T/m2
    gamma = 7.85; % T/m3
    L = 10; h1 = 4; h2 = 4; % nhịp dầm 10m; mỗi đoạn cột cao 4m/tầng (2 tầng)

    Ac = 2*bc*tfc + (hc - 2*tfc)*twc;
    Ad = 2*bd*tfd + (hd - 2*tfd)*twd;
    Ic = (bc*hc^3)/12 - ((bc-twc)*(hc-2*tfc)^3)/12;
    Id = (bd*hd^3)/12 - ((bd-twd)*(hd-2*tfd)^3)/12;
    Asc = hc * twc; Asd = hd * twd;

    % Khối lượng tính ra Tấn: 16 = 2 cột x 8m/cột (2 tầng x 4m); 20 = 2 dầm x 10m/dầm
    TrongLuong = 16 * Ac * gamma + 20 * Ad * gamma;

    k_c1 = K_Beam_Timo(Ac, Ic, Asc, h1, E, G);
    k_c2 = K_Beam_Timo(Ac, Ic, Asc, h2, E, G);
    k_d  = K_Beam_Timo(Ad, Id, Asd, L, E, G);

    T_90 = Get_T(90);
    k_c1g = T_90' * k_c1 * T_90; k_c2g = T_90' * k_c2 * T_90;

    K = zeros(18,18);
    id1=1:3; id2=4:6; id3=7:9; id4=10:12; id5=13:15; id6=16:18;

    K(id1,id1)=K(id1,id1)+k_c1g(1:3,1:3); K(id1,id2)=K(id1,id2)+k_c1g(1:3,4:6);
    K(id2,id1)=K(id2,id1)+k_c1g(4:6,1:3); K(id2,id2)=K(id2,id2)+k_c1g(4:6,4:6);
    K(id2,id2)=K(id2,id2)+k_c2g(1:3,1:3); K(id2,id3)=K(id2,id3)+k_c2g(1:3,4:6);
    K(id3,id2)=K(id3,id2)+k_c2g(4:6,1:3); K(id3,id3)=K(id3,id3)+k_c2g(4:6,4:6);
    K(id4,id4)=K(id4,id4)+k_c1g(1:3,1:3); K(id4,id5)=K(id4,id5)+k_c1g(1:3,4:6);
    K(id5,id4)=K(id5,id4)+k_c1g(4:6,1:3); K(id5,id5)=K(id5,id5)+k_c1g(4:6,4:6);
    K(id5,id5)=K(id5,id5)+k_c2g(1:3,1:3); K(id5,id6)=K(id5,id6)+k_c2g(1:3,4:6);
    K(id6,id5)=K(id6,id5)+k_c2g(4:6,1:3); K(id6,id6)=K(id6,id6)+k_c2g(4:6,4:6);

    K(id2,id2)=K(id2,id2)+k_d(1:3,1:3); K(id2,id5)=K(id2,id5)+k_d(1:3,4:6);
    K(id5,id2)=K(id5,id2)+k_d(4:6,1:3); K(id5,id5)=K(id5,id5)+k_d(4:6,4:6);
    K(id3,id3)=K(id3,id3)+k_d(1:3,1:3); K(id3,id6)=K(id3,id6)+k_d(1:3,4:6);
    K(id6,id3)=K(id6,id3)+k_d(4:6,1:3); K(id6,id6)=K(id6,id6)+k_d(4:6,4:6);

    P = zeros(18,1); q_c = Ac * gamma; q_d = Ad * gamma;

    P(4)=1.5; P(5)=-7.5; P(7)=3.0; P(8)=-7.5; P(13)=1.0; P(14)=-7.5; P(16)=2.0; P(17)=-7.5;  
    P(5)=P(5)-q_c*h1/2-q_c*h2/2; P(8)=P(8)-q_c*h2/2;
    P(14)=P(14)-q_c*h1/2-q_c*h2/2; P(17)=P(17)-q_c*h2/2;

    V_end = q_d * L / 2 + 22.5;         
    M_end = q_d * L^2 / 12 + 46.875; 
    f_d = [0; -V_end; -M_end; 0; -V_end; M_end];

    P(id2)=P(id2)+f_d(1:3); P(id5)=P(id5)+f_d(4:6);
    P(id3)=P(id3)+f_d(1:3); P(id6)=P(id6)+f_d(4:6);

    FreeDOF = [4:9, 13:18]; 
    U = zeros(18,1);
    U(FreeDOF) = K(FreeDOF, FreeDOF) \ P(FreeDOF);

    F_Dam1 = k_d * [U(id2); U(id5)] - f_d;
    F_Dam2 = k_d * [U(id3); U(id6)] - f_d;
    F_Cot1 = k_c1 * (T_90 * [U(id1); U(id2)]); % Cot trai, doan duoi (chan - tang 1)
    F_Cot2 = k_c2 * (T_90 * [U(id2); U(id3)]); % Cot trai, doan tren (tang 1 - mai)
    F_Cot3 = k_c1 * (T_90 * [U(id4); U(id5)]); % Cot phai, doan duoi (chan - tang 1)
    F_Cot4 = k_c2 * (T_90 * [U(id5); U(id6)]); % Cot phai, doan tren (tang 1 - mai)

    TachNL = @(F) struct('M_i', -F(3), 'M_j', F(6), 'N_i', -F(1), 'N_j', F(4), 'Q_i', F(2), 'Q_j', -F(5));
    NoiLuc.Dam1 = TachNL(F_Dam1); NoiLuc.Dam2 = TachNL(F_Dam2);
    NoiLuc.Cot1 = TachNL(F_Cot1); NoiLuc.Cot2 = TachNL(F_Cot2);
    NoiLuc.Cot3 = TachNL(F_Cot3); NoiLuc.Cot4 = TachNL(F_Cot4);

    w_geom_1 = 0.5*(U(5)+U(14)) + (L/8)*(U(6)-U(15));
    w_geom_2 = 0.5*(U(8)+U(17)) + (L/8)*(U(9)-U(18)); 
    % Số hạng thứ 2: võng cục bộ do 3 tải tập trung P=15T tại L/4, L/2, 3L/4
    % (dầm 2 đầu ngàm) = 2*(P*L^3)/192, kiểm chứng bằng virtual work
    w_bend = (q_d * L^4)/(384 * E * Id) + (30 * L^3)/(192 * E * Id);
    w_shear = (q_d * L^2)/(8 * G * Asd) + (15 * L)/(2 * G * Asd);
    w_local = w_bend + w_shear;
    
    DoVong.Dam1_mid = abs(w_geom_1 - w_local);
    DoVong.Dam2_mid = abs(w_geom_2 - w_local);

    function K = K_Beam_Timo(A, I, As, L, E, G)
        Phi = (12 * E * I) / (G * As * L^2);
        K = zeros(6,6);
        K(1,1) = E*A/L; K(1,4) = -E*A/L; K(4,1) = -E*A/L; K(4,4) = E*A/L;
        K(2,2) = 12*E*I / (L^3 * (1+Phi)); K(2,3) = 6*E*I / (L^2 * (1+Phi));
        K(2,5) = -12*E*I / (L^3 * (1+Phi)); K(2,6) = 6*E*I / (L^2 * (1+Phi));
        K(3,2) = K(2,3); K(3,3) = (4+Phi)*E*I / (L * (1+Phi));
        K(3,5) = -K(2,3); K(3,6) = (2-Phi)*E*I / (L * (1+Phi));
        K(5,2) = K(2,5); K(5,3) = K(3,5); K(5,5) = 12*E*I / (L^3 * (1+Phi)); K(5,6) = -6*E*I / (L^2 * (1+Phi));
        K(6,2) = K(2,6); K(6,3) = K(3,6); K(6,5) = K(5,6); K(6,6) = (4+Phi)*E*I / (L * (1+Phi));
    end
    function T = Get_T(th), T=[cosd(th) sind(th) 0 0 0 0; -sind(th) cosd(th) 0 0 0 0; 0 0 1 0 0 0; 0 0 0 cosd(th) sind(th) 0; 0 0 0 -sind(th) cosd(th) 0; 0 0 0 0 0 1]; end
end