function [g_geo, geotechChecked, Rc_d, Rt_d, N_max] = wharf100dwt_geotech_capacity_tcvn10304(D, t, maxCompression, maxTension, pileType, cfg) %#ok<INUSD>
% =========================================================================
% RÀNG BUỘC SỨC CHỊU TẢI ĐỊA KỸ THUẬT — TCVN 10304:2025 (Xuất bản lần 2),
% Điều 7.1.6 và 7.2 (thay thế wharf100dwt_geotech_capacity_stub.m,
% 08/09/2026; SỬA 08/09/2026 từ bản dựa TCVN 10304:2014 sang 2025 theo
% yêu cầu người dùng -- người dùng cung cấp file PDF chính thức
% "TCVN 10304_2025.pdf", KHÔNG dùng bản tóm tắt/blog).
%
% NGUỒN SỐ LIỆU (đã đọc trực tiếp bản PDF chính thức 124 trang, VSQI 2025,
% không suy đoán, không dùng bản tóm tắt thứ cấp):
%   - Công thức (9) [Điều 7.2.2.1] = Rk cho cọc ma sát (đóng/ép, hạ không
%     moi đất) -- tương đương công thức (10) của bản 2014, ĐỔI SỐ nhưng
%     CÙNG DẠNG: Rk = γc(γR,R·qb·A + u·ΣγR,f·fi·hi).
%   - Công thức (5)/(6) [Điều 7.2.1.1] = Rk cho cọc chống (kể cả cọc
%     đóng/ép tựa lên đá hoặc đất biến dạng nhỏ): Rk=Rk,b=γc·qb·A.
%   - Công thức (7) [Điều 7.2.1, Ld<0,5m] = qb=Rm=Rc,m,n/γg,
%     Rc,m,n=Rc,n·Ks (nêu trong văn xuôi, không đánh số riêng như bản
%     2014); Công thức (8) [Ld≥0,5m] = qb=Rm(1+0,4·Ld/df), hệ số
%     (1+0,4Ld/df) ≤ 3,0.
%   - Bảng 1 (Ks theo mức độ nứt nẻ/RQD), Bảng 2 (qb theo độ sâu & IL,
%     ĐÃ MỞ RỘNG tới 40m so với 35m của bản 2014 -- SỐ LIỆU CÁC Ô GIỐNG
%     HỆT bản 2014, đã đối chiếu từng số), Bảng 3 (fi, giống hệt bản
%     2014), Bảng 4 (γR,R, γR,f -- tương đương γcq/γcf bản 2014, số
%     giống hệt).
%   - Công thức (2) [Điều 7.1.6.1] = γn·Nd ≤ Rd = Rk/γk -- THAY THẾ cặp
%     hệ số γo×γn của bản 2014 bằng MỘT hệ số γn duy nhất (1,0/1,15/1,20
%     theo cấp hậu quả công trình C1/C2/C3); γk nay CHỈ phụ thuộc PHƯƠNG
%     PHÁP xác định (không phụ thuộc số lượng cọc, trừ công trình thuỷ
%     lợi/cọc chịu kéo -- KHÔNG áp dụng cho bến cảng container).
%   - Điều 7.2.5 (Cọc-ống thép, MỤC MỚI so với 2014): các hệ số giảm
%     γR,R=0,5 / γR,f=0,43-0,52 CHỈ áp dụng cho cọc-ống thép MŨI HỞ --
%     KHÔNG áp dụng cho cọc mũi KÍN (đã chốt dùng mũi kín) -- mũi kín
%     dùng công thức (9) chung với hệ số Bảng 4 bình thường (γR,R=γR,f=1,0).
%   - Địa tầng tại mặt cắt cọc thật: "Cau tau Lach Huyen/07..15. Mat cat
%     ngang.dxf" (mặt cắt ngang 6-6) -- toạ độ cao độ ranh giới lớp đọc
%     trực tiếp từ text entity trong DXF (không suy đoán).
%   - Chỉ tiêu cơ lý (γ, IL, C, φ) từng lớp: "Thuyet minh 06.12.doc",
%     bảng "Bảng tổng hợp chỉ tiêu cơ lý các lớp" (ảnh scan, đã đọc trực
%     quan qua Read tool).
%
% GIẢ THIẾT ĐÃ CHỐT VỚI NGƯỜI DÙNG (08/09/2026):
%   1. Chiều dài ngàm cọc GIỮ CỐ ĐỊNH theo đúng thiết kế gốc khi D thay
%      đổi (BTCT D(80-54) L=29m, thép D1016 L=30m) -- chỉ đường kính/
%      chiều dày thay đổi, cao độ mũi cọc KHÔNG đổi theo phương án.
%   2. Mũi cọc BTCT (tip -23,50m) nằm trong Lớp 10 (sét pha cứng/đá sét
%      kết phong hoá hoàn toàn, IL=-0,13) -> dùng công thức (9) + Bảng 2
%      (phương pháp đất dính theo IL). Mũi cọc thép (tip -24,50m) nằm
%      trong Lớp 11 (đá phong hoá mạnh, nứt nẻ) -> dùng công thức (5)/(6)
%      + (7)/(8) (phương pháp cọc chống tựa đá).
%   3. Cọc BỊT KÍN MŨI (đã chốt) -> A = diện tích đặc (gross), không trừ
%      lõi rỗng, cho cả 2 loại cọc; hệ số Bảng 4 bình thường (không áp
%      dụng hệ số giảm riêng cho cọc-ống thép mũi hở, Điều 7.2.5).
%   4. Tính từng cọc đơn lẻ, KHÔNG xét hiệu ứng nhóm cọc (đơn giản hoá đã
%      chốt, ghi rõ là giới hạn của nghiên cứu).
%   5. γk = 1,4 (Điều 7.1.6.1 -- "xác định bằng tính toán theo các bảng
%      tra trong tiêu chuẩn này", đúng phương pháp Bảng 2/3 đang dùng ở
%      đây) -- SỐ LIỆU TỪ TIÊU CHUẨN, không phải giả thiết tự do.
%   6. γn = 1,15 (Điều 7.1.6.1, cấp hậu quả C2 -- GIẢ THIẾT cảng
%      container 100.000 DWT là công trình cấp C2, tương đương cấp II cũ
%      -- CẦN XÁC NHẬN LẠI cấp công trình chính thức nếu có hồ sơ phân cấp).
%   7. Ks (Bảng 1) cho Lớp 11 = 0,32 (cận dưới "Nứt nẻ mạnh", RQD 50-75%)
%      -- GIẢ THIẾT vì KHÔNG có số liệu RQD thật, chỉ có mô tả định tính
%      "phong hoá mạnh, nứt nẻ" trong thuyết minh -- khớp trực tiếp với
%      tên gọi hạng mục "Nứt nẻ mạnh" của Bảng 1, lấy cận dưới (thận
%      trọng). Rc,n (cường độ nén 1 trục bão hoà nước, Lớp 11) = 92
%      kG/cm² = 9,02 MPa -- ĐÃ ĐỌC TRỰC TIẾP từ bảng chỉ tiêu cơ lý gốc
%      (hàng "Kháng nén khi bão hoà Rbh"), không suy đoán.
%
% ĐỊA TẦNG TẠI MẶT CẮT CỌC (đọc từ DXF mặt cắt ngang 6-6, cao độ so với
% Hải đồ; đáy bến sau nạo vét -16,00m -- theo Điều 7.2.2.1 (tương đương
% 7.2.2.1 bản 2014), CHỈ tính sức kháng của đất TỪ cao độ đáy nạo vét trở
% xuống, bỏ qua đất phía trên do đã bị đào bỏ):
%   -16,00 -> -17,20 : ranh giới không rõ ràng giữa Lớp 7/Lớp 9 trên bản
%                       vẽ (nhãn số lớp và ranh giới lệch nhau trên DXF,
%                       KHÔNG xác định chắc chắn được) -- gán vào Lớp 9
%                       (IL=0,87) làm GIẢ THIẾT THẬN TRỌNG (đoạn 1,2m,
%                       ảnh hưởng nhỏ tới tổng ma sát bên).
%   -17,20 -> -21,91 : Lớp 9 (sét xám xanh, dẻo chảy, IL=0,87)
%   -21,91 -> -23,91 : Lớp 10 (sét pha cứng/đá sét kết phong hoá hoàn
%                       toàn, IL=-0,13 -- CAP về IL=0,0 khi tra Bảng 2/3
%                       vì -0,13 nằm ngoài miền bảng liệt kê, lấy giá trị
%                       CHẶT NHẤT bảng có, không ngoại suy xa hơn)
%   -23,91 -> -26,41 : Lớp 11 (đá phong hoá mạnh, nứt nẻ) -- CHỈ mũi cọc
%                       thép (tip -24,50m) chạm tới lớp này.
% Mũi cọc BTCT (L=29m, đỉnh bến +5,50 -> mũi tại cao độ -23,50m) nằm
% TRONG Lớp 10. Mũi cọc thép (L=30m -> mũi tại -24,50m) nằm TRONG Lớp 11,
% ngàm sâu 0,59m vào lớp đá này (≥0,5m -> dùng công thức (8)).
%
% ĐẦU VÀO:
%   D, t       : đường kính ngoài, chiều dày cọc (m) -- ĐÃ làm tròn theo
%                lưới rời rạc/catalogue ở wharf100dwt_evaluate.m.
%   maxCompression : lực dọc NÉN lớn nhất trong cọc (T, luôn >=0 -- lay
%                     tu wharf100dwt_evaluate.m theo dung dau SAP2000).
%   maxTension     : lực dọc KÉO (nhổ) lớn nhất trong cọc (T, luôn >=0).
%   pileType   : 'BTCT' hoặc 'THEP' -- quyết định chiều dài ngàm/địa tầng
%                mũi cọc dùng (xem hằng số cfgGeo bên dưới).
%
% ĐẦU RA:
%   g_geo          : TỔNG vi phạm chuẩn hoá nén + kéo, max(0,Nc/Rc_d-1) +
%                    max(0,Nt/Rt_d-1), dùng trực tiếp trong g_total.
%   geotechChecked : true -- ràng buộc đã tính THẬT (khác stub cũ).
%   Rc_d           : sức chịu tải tính toán khi NÉN (T, công thức (9)+(2)).
%   Rt_d           : sức chịu tải tính toán khi KÉO/NHỔ (T, công thức
%                    (11)+(2) -- CHỈ ma sát thân, KHÔNG có mũi, γc RIÊNG
%                    cho kéo -- xem SUA LOI 08/09/2026 duoi day).
%   N_max          : giữ lại = maxCompression, tương thích ngược khi log.
%
% SỬA LỖI (08/09/2026, phát hiện khi rà soát trước campaign chính thức):
% Bản trước CHỈ kiểm tra NÉN bằng abs(luc doc), bo qua kha nang coc bi
% KEO (nho). Da kiem tra THAT bang SAP2000 (mo hinh voi CatIdx=3,
% D_thep=1,10, t_thep=0,020): TOAN BO 792 coc BTCT deu NEN, nhung
% 18/360 coc THEP bi KEO (toi da ~31,3T) duoi to hop bao "BAO KT" --
% XAC NHAN keo la hien tuong THAT, khong the bo qua. Da bo sung cong
% thuc (11) Dieu 7.2.2.4 (suc chiu tai keo/nho) rieng cho ca 2 loai coc.
% =========================================================================

    %% --- Hang so dia tang + tham so tieu chuan (xem tai lieu dan o tren) ---
    persistent geoConst
    if isempty(geoConst)
        geoConst = buildGeoConstants();
    end

    if strcmpi(pileType, 'BTCT')
        seg = geoConst.btct; % cac doan lop dat tu day nao vet den mui coc BTCT
        tipMode = 'soil';    % mui coc trong Lop 10 -> tra Bang 2 (dat dinh), cong thuc (9)
    elseif strcmpi(pileType, 'THEP')
        seg = geoConst.thep; % cac doan lop dat tu day nao vet den mui coc thep (KHONG gom doan trong da)
        tipMode = 'rock';    % mui coc trong Lop 11 (da) -> cong thuc (5)/(6)+(7)/(8)
    else
        error('wharf100dwt_geotech_capacity_tcvn10304:BadPileType', 'pileType phai la ''BTCT'' hoac ''THEP''.');
    end

    %% --- Chu vi va dien tich mui coc (bit kin -> gross, da chot) ---
    u  = pi * D;           % m
    Ab = pi/4 * D^2;       % m^2 (gross, bit kin mui)

    %% --- Suc khang than coc: tong fi*li*u tren tung doan lop qua Bang 3 ---
    % (Ap dung cho ca 2 loai coc -- coc thep chi cong doan tu day nao vet
    % den truoc Lop 11, doan trong da khong tinh ma sat ben rieng vi
    % Bang 3 khong ap dung cho da nut ne -- GIA THIET THAN TRONG, bo qua
    % dong gop nho nay tu doan 0,59m trong da.)
    sumFrictionKPa_m = 0; % kPa.m (se nhan voi u sau)
    for k = 1:numel(seg.layers)
        L  = seg.layers(k);
        li = L.thickness;
        zMid = L.depthMid; % chieu sau trung binh doan (m), tinh tu mat dat tu nhien -- xem buildGeoConstants()
        fi = lookupFi(zMid, L.IL); % kPa
        sumFrictionKPa_m = sumFrictionKPa_m + fi * li;
    end
    frictionForce_kN = geoConst.gamma_Rf * u * sumFrictionKPa_m; % kPa*m*m = kN

    %% --- Suc khang mui coc ---
    if strcmp(tipMode, 'soil')
        % Cong thuc (9), Dieu 7.2.2.1 -- coc ma sat, mui trong dat dinh (Lop 10)
        qb = lookupQb(seg.tipDepth, seg.tipIL_capped); % kPa, Bang 2
        gammaR_R_tip = geoConst.gamma_RR;
    else % 'rock' -- coc chong tua/ngam vao da (Lop 11), Dieu 7.2.1, cong thuc (5)/(6)+(7)/(8)
        Rc_n_kPa = geoConst.rock.Rc_n_kPa;      % cuong do nen 1 truc bao hoa nuoc, Lop 11 (doc truc tiep, xem ghi chu tren)
        Ks       = geoConst.rock.Ks;            % Bang 1, GIA THIET "Nut ne manh" can duoi (xem ghi chu tren)
        gamma_g  = geoConst.rock.gamma_g;       % = 1,4 (Dieu 7.2.1)
        Rc_m_n = Rc_n_kPa * Ks;                 % kPa
        Rm     = Rc_m_n / gamma_g;              % kPa, cong thuc (7)
        Ld = geoConst.rock.Ld_thep;             % chieu sau ngam vao da (m)
        df = D;                                 % duong kinh ngoai phan ngam da = D coc (bien thiet ke)
        ampFactor = min(1 + 0.4 * Ld / df, 3.0); % cong thuc (8), gioi han <=3,0
        if Ld < 0.5
            qb = Rm; % cong thuc (7), Ld<0,5m
        else
            qb = Rm * ampFactor; % cong thuc (8), Ld>=0,5m
        end
        qb = min(qb, 20000); % gioi han chung qb <= 20.000 kPa (Dieu 7.2.1.2)
        gammaR_R_tip = geoConst.gamma_c; % cong thuc (6): Rk,b = gamma_c * qb * A (khong co gamma_R,R rieng cho coc chong)
    end
    tipForce_kN = gammaR_R_tip * qb * Ab; % kPa*m^2 = kN

    %% --- Tong hop Rk -> Rd (cong thuc (9) hoac (6) cong voi (9) phan ma
    % sat than -- LUU Y: coc chong (cong thuc (6)) VE NGUYEN TAC khong
    % cong them ma sat than theo dinh nghia "coc chong" thuan tuy, nhung
    % vi coc thep o day la coc VUA co doan dai trong dat (Lop 9/10) VUA
    % ngam vao da (Lop 11) -- ap dung cong thuc (9) TONG QUAT (dat dinh +
    % mui, voi qb cua mui lay theo phuong phap da khi mui trong da) la
    % each tiep can hop ly, thuc hanh pho bien khi coc xuyen qua nhieu
    % lop truoc khi tua vao da -- GIA THIET, ghi ro o day. ---
    Rk_kN = geoConst.gamma_c * (tipForce_kN + frictionForce_kN); % cong thuc (9) dang tong quat
    Rd_kN = Rk_kN / (geoConst.gamma_n * geoConst.gamma_k); % cong thuc (2), Dieu 7.1.6.1
    Rc_d = Rd_kN / 9.80665; % kN -> T (1 kN = 1/9,80665 tonf)

    %% --- Suc chiu tai khi KEO/NHO (cong thuc (11), Dieu 7.2.2.4) ---
    % CHI ma sat than (khong co mui), gamma_c RIENG cho keo (0,6 neu chieu
    % sau ha coc <4m; 0,8 neu >=4m -- ca 2 loai coc o day deu ngam >4m).
    embedDepth = sum([seg.layers.thickness]); % m, tong chieu day cac doan tu day nao vet -- xap xi chieu sau ha coc
    if embedDepth < 4
        gamma_c_uplift = 0.6;
    else
        gamma_c_uplift = 0.8;
    end
    Rtk_kN = gamma_c_uplift * frictionForce_kN; % cong thuc (11)
    % gamma_k cho KEO: Dieu 7.1.6.1 (trang 26-27) quy dinh RIENG cho "coc
    % ma sat va coc chong chiu tai trong keo" -- gamma_k phu thuoc SO
    % LUONG COC TRONG MONG (khong phai theo "phuong phap xac dinh" nhu
    % nen): >=21 coc -> 1,4; 11-20 -> 1,55; 6-10 -> 1,65; 1-5 -> 1,75
    % (gia tri ngoai ngoac, ap dung khi KHONG thu tai tinh -- dung
    % phuong phap tinh toan theo bang tra nhu o day). Cong trinh nay co
    % 132+60=192 coc/phan doan (>=21) -> gamma_k_uplift = 1,4 -- TRUNG SO
    % VOI gamma_k nen (1,4) nhung là DO SO LUONG COC >=21, KHONG PHAI vi
    % "dung chung cong thuc voi nen" -- ghi ro de tranh nham lan neu sau
    % nay so luong coc/phan doan thay doi (khi do PHAI doi lai gamma_k
    % nay theo bang so luong coc, KHONG con la 1,4 mac dinh).
    gamma_k_uplift = geoConst.gamma_k; % = 1,4, dung cho truong hop >=21 coc/mong (192 coc o day)
    Rtd_kN = Rtk_kN / (geoConst.gamma_n * gamma_k_uplift); % cong thuc (2)/(3)
    Rt_d = Rtd_kN / 9.80665; % kN -> T

    %% --- Kiem tra CA NEN va KEO ---
    N_max = maxCompression; % T (giu ten bien cu de tuong thich khi log)
    g_geo_compression = max(0, maxCompression / Rc_d - 1);
    g_geo_uplift      = max(0, maxTension / Rt_d - 1);
    g_geo = g_geo_compression + g_geo_uplift;
    geotechChecked = true;
end

%% ========================================================================
function geoConst = buildGeoConstants()
% Hang so dia tang + tieu chuan (TCVN 10304:2025) -- xem chu thich day du o dau file.
    geoConst.gamma_c   = 1.0;  % Dieu 7.2.2.1 / 7.2.1.1
    geoConst.gamma_RR  = 1.0;  % Bang 4, dong/ep coc dac va coc ong bit kin mui bang bua
    geoConst.gamma_Rf  = 1.0;  % Bang 4, nt
    geoConst.gamma_n   = 1.15; % Dieu 7.1.6.1, cap hau qua C2 (GIA THIET, can xac nhan)
    geoConst.gamma_k   = 1.4;  % Dieu 7.1.6.1, "tinh toan theo cac bang tra trong tieu chuan nay"

    geoConst.rock.Rc_n_kPa = 9.02 * 1000; % Rbh Lop 11 = 92 kG/cm^2 = 9,02 MPa (doc truc tiep)
    geoConst.rock.Ks       = 0.32; % Bang 1, "Nut ne manh" can duoi (GIA THIET, khong co RQD that)
    geoConst.rock.gamma_g  = 1.4;  % Dieu 7.2.1
    geoConst.rock.Ld_thep  = 0.59; % m, doan ngam mui coc thep vao Lop 11 (-24,50 - (-23,91))

    % Cao do (m, so voi Hai do): day nao vet -16,00; day cac lop tu do
    % xuong. Nguon: DXF "07..15. Mat cat ngang.dxf", mat cat 6-6.
    % IL: doc truc tiep tu "Thuyet minh 06.12.doc" (Bang tong hop chi tieu
    % co ly). depthMid tinh TU MAT DAT TU NHIEN (-1,41m, quy uoc Bang 2/3
    % TCVN -- "chieu sau mui coc/lop dat" tinh tu cao do dia hinh tu
    % nhien, KHONG phai tu day nao vet) -- xem chu thich Bang 2 muc 3
    % (2025) / muc 2 (2014).
    zGround = -1.41;

    % Cac doan lop TU DAY NAO VET den mui coc BTCT (-23,50m):
    btctLayers = struct('top', {-16.00, -17.20, -21.91}, ...
                         'bot', {-17.20, -21.91, -23.50}, ...
                         'IL',  {0.87,   0.87,   0.0}); % Lop10 IL that=-0,13, cap ve 0,0 (thap nhat bang)
    geoConst.btct.layers = buildSegments(btctLayers, zGround);
    geoConst.btct.tipDepth    = zGround - (-23.50); % chieu sau mui coc tu mat dat tu nhien (m)
    geoConst.btct.tipIL_capped = 0.0; % Lop 10, cap tu -0,13

    % Cac doan lop TU DAY NAO VET den TRUOC Lop 11 (mui coc thep -24,50m
    % nam TRONG da -- doan ma sat ben CHI tinh den -23,91, phan con lai
    % 0,59m trong da xu ly rieng qua qb cong thuc (7)/(8), KHONG cong vao
    % day):
    thepLayers = struct('top', {-16.00, -17.20, -21.91}, ...
                         'bot', {-17.20, -21.91, -23.91}, ...
                         'IL',  {0.87,   0.87,   0.0});
    geoConst.thep.layers = buildSegments(thepLayers, zGround);
    geoConst.thep.tipDepth     = NaN; % khong dung (tipMode='rock', xem ham chinh)
    geoConst.thep.tipIL_capped = NaN;
end

function segs = buildSegments(layerSpec, zGround)
    segs = struct('thickness', {}, 'depthMid', {}, 'IL', {});
    for k = 1:numel(layerSpec)
        top = layerSpec(k).top; bot = layerSpec(k).bot;
        thickness = top - bot; % duong vi top > bot (cao do am, top it am hon)
        zMidElev = (top + bot) / 2;
        depthMid = zGround - zMidElev; % chieu sau tu mat dat tu nhien (m, duong)
        segs(end+1) = struct('thickness', thickness, 'depthMid', depthMid, 'IL', layerSpec(k).IL); %#ok<AGROW>
    end
end

%% ========================================================================
function fi = lookupFi(depth_m, IL)
% Bang 3 TCVN 10304:2025 -- Cuong do suc khang tren than coc dong/ep fi
% (kPa), cot "Dat dinh ung voi chi so set IL". SO LIEU GIONG HET Bang 3
% TCVN 10304:2014 (da doi chieu tung o) -- doc truc tiep tu anh trang 33
% ban PDF chinh thuc "TCVN 10304_2025.pdf" (VSQI, 124 trang).
    depthGrid = [1 2 3 4 5 6 8 10 15 20 25 30 35];
    ILgrid    = [0.2 0.3 0.4 0.5 0.6 0.7 0.8 0.9 1.0]; % cot "<=0,2" dung cho moi IL<=0,2
    % Hang = do sau, cot = IL (kPa)
    fiTable = [ ...
        35 23 15 12  8  4 4 3 2; ...
        42 30 21 17 12  7 5 4 4; ...
        48 35 25 20 14  8 7 6 5; ...
        53 38 27 22 16  9 8 7 5; ...
        56 40 29 24 17 10 8 7 6; ...
        58 42 31 25 18 10 8 7 6; ...
        62 44 33 26 19 10 8 7 6; ...
        65 46 34 27 19 10 8 7 6; ...
        72 51 38 28 20 11 8 7 6; ...
        79 56 41 30 20 12 8 7 6; ...
        86 61 44 32 20 12 8 7 6; ...
        93 66 47 34 21 12 9 8 6; ...
        100 70 50 36 22 13 9 8 NaN]; % o (35, IL=1.0) khong co so lieu trong bang goc
    ILc = min(max(IL, 0.2), 1.0); % cap trong mien bang (IL<=0,2 dung cot dau)
    depthC = min(max(depth_m, depthGrid(1)), depthGrid(end));
    fi = interp2Table(depthGrid, ILgrid, fiTable, depthC, ILc);
end

function qb = lookupQb(depth_m, IL)
% Bang 2 TCVN 10304:2025 -- Cuong do suc khang duoi mui coc dong/ep qb
% (kPa), cot "Dat dinh ung voi chi so set IL".
%
% SUA LOI (08/09/2026): ban truoc bi LECH 1 COT o cac hang do sau
% 20/25/30/35/40m (doc nham tu anh scan "Bang 2 (tiep)" -- thieu gia tri
% THAT o cot IL=0,0 va day lui cac cot con lai, mat gia tri cot cuoi
% IL=0,6). Da SUA lai bang cach doi chieu voi bang da so hoa SAN CO trong
% code B-MOSFOA/E-MOSFOA cua nguoi dung
% ("MOSFOA/Run_MOMSFOA_official/MOSFOA_BD/Pile_TCVN10304_2014/Table_Fi_tip.mat",
% bien F_tip{1} = nhanh "dat dinh") -- khop tung o voi ban PDF 2025 cho
% cac hang do sau 3-15m (khong doi), sua dung gia tri that cho cac hang
% 20-35m theo file .mat nay, va doi chieu lai truc quan hang 40m tu chinh
% anh PDF 2025 (khong con suy doan). Cot IL=0,0 hoa ra la gia tri THAT
% dung chung cho ca 2 nhanh cat/dat dinh (khong phai "khong co so lieu"
% nhu hieu lam truoc -- da bo doan qbTable(:,1)=qbTable(:,2) sai truoc day).
    depthGrid = [3 4 5 7 10 15 20 25 30 35 40];
    ILgrid    = [0.0 0.1 0.2 0.3 0.4 0.5 0.6];
    qbTable = [ ...
        7500  4000 3000 2000 1200 1100  600; ...
        8300  5100 3800 2500 1600 1250  700; ...
        8800  6200 4000 2800 2000 1300  800; ...
        9700  6900 4300 3300 2200 1400  850; ...
        10500 7300 5000 3500 2400 1500  900; ...
        11700 7500 5600 4000 2900 1650 1000; ...
        12600 8500 6200 4500 3200 1800 1100; ...
        13400 9000 6800 5200 3500 1950 1200; ...
        14200 9500 7400 5600 3800 2100 1300; ...
        15000 10000 8000 6000 4100 2250 1400; ...
        15800 10500 8600 6400 4400 2400 1500];
    ILc = min(max(IL, 0.0), 0.6); % Lop10 IL cap ve 0,0 (thap nhat bang -- gia tri that, khong con la can tren gia dinh)
    depthC = min(max(depth_m, depthGrid(1)), depthGrid(end));
    qb = interp2Table(depthGrid, ILgrid, qbTable, depthC, ILc);
end

function v = interp2Table(xGrid, yGrid, table, x, y)
% Noi suy song tuyen tinh don gian tren luoi (xGrid = hang/do sau, yGrid =
% cot/IL). xGrid, yGrid PHAI tang dan.
    ix = find(xGrid <= x, 1, 'last'); if isempty(ix), ix = 1; end
    ix2 = min(ix+1, numel(xGrid));
    iy = find(yGrid <= y, 1, 'last'); if isempty(iy), iy = 1; end
    iy2 = min(iy+1, numel(yGrid));

    tx = 0; if xGrid(ix2) > xGrid(ix), tx = (x - xGrid(ix)) / (xGrid(ix2) - xGrid(ix)); end
    ty = 0; if yGrid(iy2) > yGrid(iy), ty = (y - yGrid(iy)) / (yGrid(iy2) - yGrid(iy)); end

    v11 = table(ix, iy); v12 = table(ix, iy2);
    v21 = table(ix2, iy); v22 = table(ix2, iy2);
    v1 = v11 + ty * (v12 - v11);
    v2 = v21 + ty * (v22 - v21);
    v = v1 + tx * (v2 - v1);
end
