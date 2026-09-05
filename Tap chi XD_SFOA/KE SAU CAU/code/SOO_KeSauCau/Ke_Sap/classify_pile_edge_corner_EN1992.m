%% classify_pile_edge_corner_EN1992.m -- refine the EN 1992-1-1 punching
% check (verify_punching_EN1992.m) by classifying each of the 142 piles as
% INTERIOR / EDGE / CORNER relative to the base slab's own OUTER (free)
% boundary, per EN 1992-1-1 6.4.3's beta = 1.15/1.4/1.5 approximate values
% -- addresses the limitation flagged in verify_punching_EN1992.m's header
% (uniform beta=1.15 applied to all piles, edge/corner piles not
% classified). User-requested follow-up, 2026-09-03.
%
% METHOD (pure geometry, read from the actual SAP2000 model -- NOT
% assumed/guessed):
%   1. Read every AreaObj whose section is DAY130 or DAY60 (the 2 base-
%      slab zones, treated TOGETHER as one physical slab -- they are just
%      2 thickness sub-zones of the same monolithic bản đáy, so their
%      SHARED internal boundary is NOT a free edge).
%   2. For each area object's 4 corner points, form its 4 edges as
%      (name_i, name_i+1) pairs, and tally how many times each edge
%      (compared by the SORTED point-name pair, so shared edges between
%      adjacent objects collapse to the same key regardless of winding)
%      occurs across ALL DAY-zone objects. An edge occurring exactly ONCE
%      is a boundary edge of the union polygon (it borders no other
%      DAY-zone object on its other side) -- an edge occurring TWICE is an
%      internal edge shared between 2 adjacent objects (interior of the
%      slab, or the DAY130/DAY60 internal interface) and is excluded.
%   3. For each pile (topXY from wall_setup_data.mat's pileInfo), find all
%      boundary-edge segments within R_crit = Dp/2 + 2*d of the pile
%      center (D=pile diameter, d=h0 of ITS OWN dayZone -- same h0 used in
%      verify_punching_EN1992.m). If none: INTERIOR (beta=1.15). If one or
%      more, but all with nearly the same direction (within 30 deg, mod
%      180 deg -- i.e. a single straight run of boundary, common for a
%      mesh-subdivided edge split into several collinear segments): EDGE
%      (beta=1.4). If segments spanning 2+ significantly different
%      directions (>30 deg apart) are within R_crit: CORNER (beta=1.5).
%   4. Re-run the EN 1992-1-1 6.4.4 stress check with the PER-PILE beta
%      (fck, rho_l unchanged from verify_punching_EN1992.m -- reusing the
%      Nd_T/h0_m/section/dayZone already computed and saved in
%      verify_punching_EN1992_per_pile.csv, so this script does NOT need
%      to re-run SAP2000 analysis, only re-read the model's GEOMETRY,
%      much faster than a full RunAnalysis pass).
%
% Does not alter the optimization result, Sap_KeSauCau.m, or any
% results_SAP/*.mat -- pure read-only geometric classification + a
% re-derived EN1992 ratio column.
clear; clc;
scriptDir = fileparts(mfilename('fullpath'));
outLog = fullfile(scriptDir, 'classify_pile_edge_corner_log.txt');
outCsv = fullfile(scriptDir, 'verify_punching_EN1992_per_pile_beta_classified.csv');
prevCsv = fullfile(scriptDir, 'verify_punching_EN1992_per_pile.csv');
fid = fopen(outLog, 'w');
fprintf(fid, '=== classify_pile_edge_corner start %s ===\n', datestr(now));
fclose(fid);

try
    assert(isfile(prevCsv), 'Run verify_punching_EN1992.m first -- %s not found.', prevCsv);

    %% --- Open SAP2000, open the model -- GEOMETRY ONLY, no thickness
    % change, no RunAnalysis needed (area object corner points don't
    % depend on shell thickness or analysis results). ---
    logmsg(outLog, 'Opening SAP2000 (inline open_Sap2000 logic)...');
    SM.App('sap');
    SM.Ver('24');
    ProgramPath = 'C:\Program Files\Computers and Structures\SAP2000 24\SAP2000.exe';
    APIDLLPath  = 'C:\Program Files\Computers and Structures\SAP2000 24\SAP2000v1.dll';
    [Sobj] = SM.Helper.CreateObject(ProgramPath, APIDLLPath); %#ok<NASGU,ASGLU>
    [Smdl] = SM.SapModel(); %#ok<NASGU>
    SM.ApplicationStart('Visible', false);
    SM.Hide;
    pause(2);

    sdbPath = fullfile(scriptDir, '..', '..', '..', 'Sap', 'ke pd 10.sdb');
    assert(isfile(sdbPath), 'sdb not found at %s', sdbPath);
    ret = SM.File.OpenFile(sdbPath);
    logmsg(outLog, sprintf('OpenFile ret=%d', ret));
    if ret ~= 0; error('OpenFile failed, ret=%d', ret); end
    SM.SetPresentUnits(SM.eUnits.Ton_m_C);

    DAY_SECTIONS = {'DAY130','DAY60'};

    %% --- Pass: DAY-zone area objects -- corner points + XY coords ---
    [ret, nArea, areaNames] = SM.AreaObj.GetNameList(); %#ok<ASGLU>
    logmsg(outLog, sprintf('AreaObj total=%d', nArea));
    pointCache = containers.Map('KeyType','char','ValueType','any');
    edgeCount  = containers.Map('KeyType','char','ValueType','double');
    edgeCoord  = containers.Map('KeyType','char','ValueType','any'); % key -> [x1 y1 x2 y2]
    nDayObj = 0;
    for i = 1:nArea
        name = areaNames{i};
        [~, propName] = SM.AreaObj.GetProperty(name);
        if ~any(strcmp(propName, DAY_SECTIONS)); continue; end
        nDayObj = nDayObj + 1;
        [~, nPts, ptNames] = SM.AreaObj.GetPoints(name);
        xy = zeros(nPts,2);
        for k = 1:nPts
            pn = ptNames{k};
            if isKey(pointCache, pn)
                c = pointCache(pn);
            else
                [~, x, y, ~] = SM.PointObj.GetCoordCartesian(pn);
                c = [x y]; pointCache(pn) = c; %#ok<NASGU>
            end
            xy(k,:) = c;
        end
        for k = 1:nPts
            k2 = mod(k, nPts) + 1;
            n1 = ptNames{k}; n2 = ptNames{k2};
            if strcmp(n1,n2); continue; end % degenerate zero-length edge, shouldn't happen
            names2 = sort({n1, n2});
            key = [names2{1} '||' names2{2}];
            if isKey(edgeCount, key)
                edgeCount(key) = edgeCount(key) + 1;
            else
                edgeCount(key) = 1;
                edgeCoord(key) = [xy(k,1) xy(k,2) xy(k2,1) xy(k2,2)];
            end
        end
    end
    logmsg(outLog, sprintf('DAY-zone area objects found: %d', nDayObj));

    keysAll = keys(edgeCount);
    isBoundary = false(numel(keysAll),1);
    for i = 1:numel(keysAll)
        isBoundary(i) = edgeCount(keysAll{i}) == 1;
    end
    boundaryKeys = keysAll(isBoundary);
    nBoundary = numel(boundaryKeys);
    logmsg(outLog, sprintf('Total distinct DAY-zone edges=%d, boundary (count==1) edges=%d, internal (count==2) edges=%d', ...
        numel(keysAll), nBoundary, sum(~isBoundary)));
    segXY = zeros(nBoundary,4);
    for i = 1:nBoundary
        segXY(i,:) = edgeCoord(boundaryKeys{i});
    end

    %% --- Load pile geometry + previous per-pile results ---
    S = load(fullfile(scriptDir, 'wall_setup_data.mat'));
    T = readtable(prevCsv);
    % Pile names in the CSV are all-numeric strings ("74","75",...) --
    % readtable auto-infers that column as numeric (double), which would
    % silently break a strcmp() lookup against pileInfo's char names.
    % Force a text form on BOTH sides for every lookup below.
    T.PileNameStr = string(T.PileName);
    concreteCover = 0.05; d_bar_mm = 20;
    PileDiam_m = containers.Map({'C400','C500'}, {0.4, 0.5});
    fck_MPa = 20.0; gammaC_EN = 1.5; CRd_c = 0.18/gammaC_EN;

    nPiles = numel(S.pileInfo);
    pileName = cell(nPiles,1); classif = cell(nPiles,1); betaUsed = nan(nPiles,1);
    minDistToBoundary = nan(nPiles,1); nSegWithin = zeros(nPiles,1);
    ratio_EN_new = nan(nPiles,1); vEd_new = nan(nPiles,1); vRdc_new = nan(nPiles,1);

    for i = 1:nPiles
        pn = S.pileInfo(i).name;
        row = T(strcmp(T.PileNameStr, string(pn)), :);
        if isempty(row); continue; end % shouldn't happen -- 142/142 matched in the prior script
        pileName{i} = pn;
        sec = S.pileInfo(i).section;
        Dp = PileDiam_m(sec);
        h0 = row.h0_m(1);
        Rcrit = Dp/2 + 2*h0;
        xy = S.pileInfo(i).topXY;

        % distance from point to each boundary segment (proper point-to-
        % segment, not point-to-infinite-line)
        d = nan(nBoundary,1);
        for s = 1:nBoundary
            x1=segXY(s,1); y1=segXY(s,2); x2=segXY(s,3); y2=segXY(s,4);
            vx=x2-x1; vy=y2-y1; L2 = vx^2+vy^2;
            if L2 < 1e-12; t = 0; else; t = max(0,min(1, ((xy(1)-x1)*vx+(xy(2)-y1)*vy)/L2)); end
            px = x1+t*vx; py = y1+t*vy;
            d(s) = hypot(xy(1)-px, xy(2)-py);
        end
        [dmin, ~] = min(d);
        minDistToBoundary(i) = dmin;
        within = find(d <= Rcrit);
        nSegWithin(i) = numel(within);

        if isempty(within)
            classif{i} = 'INTERIOR'; betaUsed(i) = 1.15;
        else
            % direction (mod 180deg) of each nearby segment
            ang = nan(numel(within),1);
            for jj = 1:numel(within)
                s = within(jj);
                vx = segXY(s,3)-segXY(s,1); vy = segXY(s,4)-segXY(s,2);
                a = atan2d(vy,vx); if a < 0; a = a + 180; end % fold to [0,180)
                ang(jj) = a;
            end
            % max pairwise angular spread, accounting for the 180deg wrap
            spread = 0;
            for a1 = 1:numel(ang)
                for a2 = a1+1:numel(ang)
                    dd = abs(ang(a1)-ang(a2));
                    dd = min(dd, 180-dd);
                    spread = max(spread, dd);
                end
            end
            if numel(ang) == 1 || spread <= 30
                classif{i} = 'EDGE'; betaUsed(i) = 1.4;
            else
                classif{i} = 'CORNER'; betaUsed(i) = 1.5;
            end
        end

        u1_m = pi*(Dp + 4*h0);
        % rho_l: recompute the same way verify_punching_EN1992.m did,
        % keyed off dayZone (mu is per-zone, not per-pile, so this is
        % exact, not an approximation of an approximation). mu values
        % copied verbatim from that script's own log (2026-09-05 lb-v2
        % re-run, BestX=[0.15 0.23 0.25 0.27 0.69 0.59]): DAY130=0.002153,
        % DAY60=0.002097 (was DAY130=0.002031/DAY60=0.002028 for the
        % archived lb-v1 solution).
        dz = char(row.DayZone(1));
        if strcmp(dz,'DAY130'); rho_l = 0.002153; else; rho_l = 0.002097; end
        d_mm = h0*1000;
        k_EN = min(1 + sqrt(200/d_mm), 2.0);
        vRdc = max(CRd_c*k_EN*(100*rho_l*fck_MPa)^(1/3), 0.035*k_EN^1.5*sqrt(fck_MPa));
        VEd_kN = row.Nd_T(1) * 9.80665;
        vEd = betaUsed(i) * VEd_kN / (u1_m*h0) / 1000;
        vEd_new(i) = vEd; vRdc_new(i) = vRdc; ratio_EN_new(i) = vEd/vRdc;
    end

    %% --- Write CSV ---
    fidc = fopen(outCsv, 'w');
    fprintf(fidc, 'PileName,Section,DayZone,Nd_T,h0_m,MinDistToSlabBoundary_m,NearbyBoundarySegments,Classification,Beta,vEd_MPa,vRdc_MPa,EN1992_ratio\n');
    for i = 1:nPiles
        row = T(strcmp(T.PileNameStr, string(pileName{i})), :);
        fprintf(fidc, '%s,%s,%s,%.4f,%.4f,%.4f,%d,%s,%.2f,%.4f,%.4f,%.4f\n', ...
            pileName{i}, S.pileInfo(i).section, S.pileInfo(i).dayZone, row.Nd_T(1), row.h0_m(1), ...
            minDistToBoundary(i), nSegWithin(i), classif{i}, betaUsed(i), vEd_new(i), vRdc_new(i), ratio_EN_new(i));
    end
    fclose(fidc);
    logmsg(outLog, sprintf('CSV written: %s', outCsv));

    %% --- Summary ---
    nInterior = sum(strcmp(classif,'INTERIOR'));
    nEdge     = sum(strcmp(classif,'EDGE'));
    nCorner   = sum(strcmp(classif,'CORNER'));
    logmsg(outLog, sprintf('Classification: INTERIOR=%d EDGE=%d CORNER=%d (total=%d)', nInterior, nEdge, nCorner, nPiles));
    nFail = sum(ratio_EN_new > 1);
    [maxR, iMax] = max(ratio_EN_new);
    logmsg(outLog, sprintf('EN1992 (per-pile beta) FAIL: %d/%d. Max ratio=%.4f at pile %s (%s, beta=%.2f).', ...
        nFail, nPiles, maxR, pileName{iMax}, classif{iMax}, betaUsed(iMax)));
    if nFail > 0
        idxFail = find(ratio_EN_new > 1);
        for ii = idxFail(:)'
            logmsg(outLog, sprintf('  FAIL: %s %s beta=%.2f ratio=%.4f', pileName{ii}, classif{ii}, betaUsed(ii), ratio_EN_new(ii)));
        end
    end
    % Also report max ratio broken down by classification, for the paper text
    for c = {'INTERIOR','EDGE','CORNER'}
        idxc = strcmp(classif, c{1});
        if any(idxc)
            logmsg(outLog, sprintf('  %s: n=%d, max ratio=%.4f', c{1}, sum(idxc), max(ratio_EN_new(idxc))));
        end
    end
    logmsg(outLog, '=== classify_pile_edge_corner DONE OK ===');

    try; SM.ApplicationExit(false); catch; end
    system('taskkill /F /IM SAP2000.exe');
catch ME
    logmsg(outLog, sprintf('CAUGHT ERROR: %s', ME.message));
    for kk = 1:numel(ME.stack)
        logmsg(outLog, sprintf('  at %s line %d', ME.stack(kk).name, ME.stack(kk).line));
    end
    try; system('taskkill /F /IM SAP2000.exe'); catch; end
    rethrow(ME);
end

function logmsg(p, msg)
    fid = fopen(p, 'a'); fprintf(fid, '[%s] %s\n', datestr(now,'HH:MM:SS'), msg); fclose(fid);
    fprintf('%s\n', msg);
end
