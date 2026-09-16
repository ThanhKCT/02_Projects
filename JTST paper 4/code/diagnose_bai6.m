% DIAGNOSE_BAI6  Script chan doan DOC (khong RunAnalysis, khong sua model) -
% BAT BUOC chay dau tien truoc khi tin bat ky ket qua vet can/campaign nao
% (bai hoc Kinh nghiem MOSFOA Paper 2.md muc 1.4). In RAW ten section/combo/
% so nut that, doi chieu bang tay voi FEM_Ben70000DWT_ChanMay.md, va do cac
% hang so hinh hoc (L_DN/L_DD/L_DCT/A_BMC) luu vao geom_constants_bai6.mat.
%
% Chay bang: matlab -r "cd('...code'); diagnose_bai6; exit;"  (BAT BUOC -r,
% KHONG -batch, xem sap2000-matlab-optimization-lessons).

scriptDir = fileparts(mfilename('fullpath'));
addpath(scriptDir);
cfg = project_config_bai6();

fprintf('=== DIAGNOSE BAI 6 ===\n');
fprintf('sdb_path (lam viec) = %s\n', cfg.sdb_path);
if ~isfile(cfg.sdb_path)
    error('diagnose_bai6: KHONG tim thay file .sdb lam viec: %s -- copy tu %s truoc.', cfg.sdb_path, cfg.sdb_baseline_path);
end

[~, ~] = open_Sap2000_v2(cfg.sdb_path, true);

% --- 1) Section assignments: dem so frame/area gan dung tung ten section ---
[~, nFrame, AllFrameNames] = SM.FrameObj.GetNameList();
AllFrameNames = cellstr(AllFrameNames);
countBySec = containers.Map();
for i = 1:nFrame
    [~, secName] = SM.FrameObj.GetSection(AllFrameNames{i});
    if isKey(countBySec, secName)
        countBySec(secName) = countBySec(secName) + 1;
    else
        countBySec(secName) = 1;
    end
end
fprintf('\n--- Frame section assignments (tong %d frame) ---\n', nFrame);
ks = keys(countBySec);
for i = 1:numel(ks)
    fprintf('  %-10s : %d phan tu\n', ks{i}, countBySec(ks{i}));
end
fprintf('  (Doi chieu FEM_Ben70000DWT_ChanMay.md muc 4: Coc1=96, DN=282, DD=210, DCT=140, MR=18, khong gan=1)\n');

[~, nArea, AllAreaNames] = SM.AreaObj.GetNameList();
AllAreaNames = cellstr(AllAreaNames);
fprintf('\n--- Area: tong %d phan tu (ky vong 1750, toan bo BMC theo muc 5) ---\n', nArea);

% --- 2) Ten to hop that (RespCombo.GetNameList) ---
[~, nCombo, AllComboNames] = SM.RespCombo.GetNameList();
AllComboNames = cellstr(AllComboNames);
fprintf('\n--- To hop tai trong: tong %d (ky vong 410: 388 ULSB+20 SLSDH+2 bao) ---\n', nCombo);
hasULSB  = any(strcmpi(AllComboNames, cfg.combo_ULSB));
hasSLSDH = any(strcmpi(AllComboNames, cfg.combo_SLSDH));
fprintf('  "%s" ton tai? %d\n', cfg.combo_ULSB, hasULSB);
fprintf('  "%s" ton tai? %d\n', cfg.combo_SLSDH, hasSLSDH);
if ~hasULSB || ~hasSLSDH
    warning('diagnose_bai6: TEN COMBO KHONG KHOP - in toan bo danh sach de doi chieu tay:');
    disp(AllComboNames);
end

% --- 3) Kiem tra nut 1945 (bug da biet - 96 coc nhung chi 95 nut ngam) ---
[~, nRestraint, RestraintNames] = SM.PointObj.GetNameList(); %#ok<ASGLU>
try
    [~, restraint] = SM.PointObj.GetRestraint('1945');
    fprintf('\n--- Nut 1945 (bug da biet, xem FEM_Ben70000DWT_ChanMay.md muc 7) ---\n');
    fprintf('  Restraint hien tai [U1 U2 U3 R1 R2 R3] = %s\n', mat2str(logical(restraint)));
    fprintf('  Neu toan bo false -> CHUA fix, chay prepare_model_bai6.m truoc khi toi uu.\n');
catch ME
    warning('diagnose_bai6: khong doc duoc restraint nut 1945: %s', ME.message);
end

% --- 4) Do hang so hinh hoc (L_DN/L_DD/L_DCT/A_BMC) ---
fprintf('\n--- Do hinh hoc (L_DN/L_DD/L_DCT/A_BMC) ---\n');
geom.L_DN_total_m  = local_total_frame_length(AllFrameNames, cfg.sec.DN_name);
geom.L_DD_total_m  = local_total_frame_length(AllFrameNames, cfg.sec.DD_name);
geom.L_DCT_total_m = local_total_frame_length(AllFrameNames, cfg.sec.DCT_name);
geom.A_BMC_total_m2 = local_total_area(AllAreaNames, cfg.sec.BMC_name);
fprintf('  L_DN_total  = %.3f m\n', geom.L_DN_total_m);
fprintf('  L_DD_total  = %.3f m\n', geom.L_DD_total_m);
fprintf('  L_DCT_total = %.3f m\n', geom.L_DCT_total_m);
fprintf('  A_BMC_total = %.3f m2 (ky vong ~ 24m x 60m = 1440 m2 theo hinh hoc mo hinh muc 2)\n', geom.A_BMC_total_m2);

modelDir = fullfile(scriptDir, 'model');
save(fullfile(modelDir, 'geom_constants_bai6.mat'), 'geom');
fprintf('\nDa luu geom_constants_bai6.mat -- project_config_bai6.m se tu dong nap lai tu lan sau.\n');

try, SM.ApplicationExit(); catch, end

% =========================================================================
function Ltot = local_total_frame_length(AllFrameNames, sectionName)
Ltot = 0;
for i = 1:numel(AllFrameNames)
    [~, secName] = SM.FrameObj.GetSection(AllFrameNames{i});
    if ~strcmpi(secName, sectionName)
        continue;
    end
    [~, pt1, pt2] = SM.FrameObj.GetPoints(AllFrameNames{i});
    [~, x1,y1,z1] = SM.PointObj.GetCoordCartesian(pt1); %#ok<ASGLU>
    [~, x2,y2,z2] = SM.PointObj.GetCoordCartesian(pt2); %#ok<ASGLU>
    Ltot = Ltot + sqrt((x2-x1)^2+(y2-y1)^2+(z2-z1)^2);
end
end

function Atot = local_total_area(AllAreaNames, sectionName)
Atot = 0;
for i = 1:numel(AllAreaNames)
    [~, secName] = SM.AreaObj.GetProperty(AllAreaNames{i}); %#ok<ASGLU>
    if ~strcmpi(secName, sectionName)
        continue;
    end
    [~, nPts, PtNames] = SM.AreaObj.GetPoints(AllAreaNames{i});
    PtNames = cellstr(PtNames);
    xs = zeros(nPts,1); ys = zeros(nPts,1); zs = zeros(nPts,1);
    for k = 1:nPts
        [~, xs(k), ys(k), zs(k)] = SM.PointObj.GetCoordCartesian(PtNames{k});
    end
    % Dien tich da giac phang bat ky trong 3D (Newell's method)
    nx=0; ny=0; nz=0;
    for k = 1:nPts
        k2 = mod(k, nPts) + 1;
        nx = nx + (ys(k)-ys(k2))*(zs(k)+zs(k2));
        ny = ny + (zs(k)-zs(k2))*(xs(k)+xs(k2));
        nz = nz + (xs(k)-xs(k2))*(ys(k)+ys(k2));
    end
    Atot = Atot + 0.5*sqrt(nx^2+ny^2+nz^2);
end
end
