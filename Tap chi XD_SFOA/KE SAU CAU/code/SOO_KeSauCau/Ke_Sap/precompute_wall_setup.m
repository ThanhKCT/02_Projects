%% precompute_wall_setup.m
% One-time setup for the "Ke sau cau" wall-volume SFOA project. Opens the
% VERIFIED baseline (Sap\ke pd 10.sdb, ground-truth-checked 2026-08-28),
% creates SAP2000 Groups for the 6 design-variable zones + Piles (the model
% only has group "ALL"), computes each zone's plan/elevation area directly
% from area-object corner-point coordinates (NOT via AreaElm, since object
% count 1248 != mesh element count 1552 -- objects get auto-subdivided),
% identifies the wall-top joint set (for the lateral-displacement
% constraint) and maps each pile to the base-slab zone (DAY130/DAY60) it
% actually sits under (for the punching-shear constraint). Also groups
% the wall-top joints for the lateral-displacement constraint query.
%
% NOTE 2026-08-28 (correction): SM.File.Save(newPath) does NOT do a
% "Save As" the way a first read of the SAP2000 OAPI docs suggests -- it
% overwrote ke pd 10.sdb IN PLACE (confirmed: mtime/size changed on the
% original; no separate file was ever created despite ret=0 "success").
% Re-verified afterward (verify_grouped_model.m) that Joint Reaction sums
% per load case are UNCHANGED to within rounding vs the pre-group
% ground-truth export -- Groups are purely a selection label, no effect
% on stiffness/loads/results, so this is safe in substance even though it
% wasn't the intended save-as-new-file mechanics. Saving in place on
% purpose now (see SM.File.Save call below) -- the untouched 2016 original
% still exists at Sap\Sap ke pd 10\ke pd 10.sdb as a pristine fallback.
%
% Logging: every line is fopen('a')/fprintf/fclose'd individually so
% output survives even if this process has to be killed mid-run (SAP2000
% COM sessions on this model have been observed to take a long time on
% first enumeration -- see the probe_api*.m sessions this same day).
scriptDir = fileparts(mfilename('fullpath'));
sdbPath = fullfile(scriptDir,'..','..','..','Sap','ke pd 10.sdb');
newSdbPath = sdbPath; % see NOTE above -- SM.File.Save saves in place regardless
logPath = fullfile(scriptDir,'precompute_log.txt');
matOutPath = fullfile(scriptDir,'wall_setup_data.mat');
assert(isfile(sdbPath), 'baseline sdb not found at %s', sdbPath);

WALL_SECTIONS = {'TUONGC30','TUONGM30','TUONGM43','TUONGM78'};
DAY_SECTIONS  = {'DAY130','DAY60'};
ALL_ZONE_SECTIONS = [WALL_SECTIONS, DAY_SECTIONS];
PILE_SECTIONS = {'C400','C500'};

logmsg(logPath, sprintf('=== precompute_wall_setup start %s ===', datestr(now)));

open_Sap2000(1); pause(2); SM.Hide;
ret = SM.File.OpenFile(sdbPath);
logmsg(logPath, sprintf('OpenFile ret=%d', ret));
SM.SetPresentUnits(SM.eUnits.Ton_m_C);
SM.SetModelIsLocked(false);

[ret, nArea, areaNames] = SM.AreaObj.GetNameList();
logmsg(logPath, sprintf('AreaObj count=%d (ret=%d)', nArea, ret));
[ret, nFrame, frameNames] = SM.FrameObj.GetNameList();
logmsg(logPath, sprintf('FrameObj count=%d (ret=%d)', nFrame, ret));

%% --- Create the 8 groups (6 zones + Piles + WallTop) ---
for g = [ALL_ZONE_SECTIONS, {'Piles','WallTop'}]
    ret = SM.GroupDef.SetGroup(g{1});
    logmsg(logPath, sprintf('GroupDef.SetGroup(%s) ret=%d', g{1}, ret));
end

%% --- Pass 1: area objects -- section assignment, group assignment, corner
% points+coords (for polygon area + wall-top joint search), cached so we
% never re-query the same joint's coords twice. ---
pointCache = containers.Map('KeyType','char','ValueType','any'); % name -> [x y z]
zoneArea_m2 = struct();
for zi = 1:numel(ALL_ZONE_SECTIONS); zoneArea_m2.(ALL_ZONE_SECTIONS{zi}) = 0; end
zonePoints = struct(); % zone -> joint names seen (WALL zones: wall-top search; DAY zones: pile-proximity/punching search)
for zi = 1:numel(ALL_ZONE_SECTIONS); zonePoints.(ALL_ZONE_SECTIONS{zi}) = {}; end
areaObjSection = cell(nArea,1); % parallel to areaNames, for the pile->DAY-zone mapping pass
areaObjPoints  = cell(nArea,1);

tStart = tic;
for i = 1:nArea
    name = areaNames{i};
    [ret, propName] = SM.AreaObj.GetProperty(name);
    areaObjSection{i} = propName;
    isZone = any(strcmp(propName, ALL_ZONE_SECTIONS));
    if ~isZone
        continue % GIOCHANXE and anything else: leave ungrouped, not a design variable
    end
    ret = SM.AreaObj.SetGroupAssign(name, propName); %#ok<NASGU> % group name == section name, 1:1
    [ret, nPts, ptNames] = SM.AreaObj.GetPoints(name);
    areaObjPoints{i} = ptNames;
    xyz = zeros(nPts,3);
    for k = 1:nPts
        pn = ptNames{k};
        if isKey(pointCache, pn)
            xyz(k,:) = pointCache(pn);
        else
            [~, x, y, z] = SM.PointObj.GetCoordCartesian(pn);
            xyz(k,:) = [x y z];
            pointCache(pn) = [x y z]; %#ok<NASGU>
        end
    end
    % Planar polygon area via triangulated-fan cross product (works for
    % any planar polygon, not just rectangles; SAP2000 area objects here
    % are quads so nPts is almost always 4, but this handles 3+ generally).
    areaVal = 0;
    for k = 2:nPts-1
        v1 = xyz(k,:)   - xyz(1,:);
        v2 = xyz(k+1,:) - xyz(1,:);
        areaVal = areaVal + 0.5*norm(cross(v1,v2));
    end
    zoneArea_m2.(propName) = zoneArea_m2.(propName) + areaVal;
    zonePoints.(propName) = [zonePoints.(propName), reshape(ptNames,1,[])]; % ptNames orientation (row/col) not guaranteed
    if mod(i,200)==0 || i==nArea
        logmsg(logPath, sprintf('  area obj %d/%d done, elapsed=%.1fs', i, nArea, toc(tStart)));
    end
end
logmsg(logPath, 'Area pass complete. Zone areas (m2):');
for zi = 1:numel(ALL_ZONE_SECTIONS)
    z = ALL_ZONE_SECTIONS{zi};
    logmsg(logPath, sprintf('  %s: %.4f m2', z, zoneArea_m2.(z)));
end

%% --- Wall-top joints: among all joints touched by the 4 TUONG zones,
% those within 1mm of the max Z seen. ---
allWallPtNames = {};
for zi = 1:numel(WALL_SECTIONS); allWallPtNames = [allWallPtNames, zonePoints.(WALL_SECTIONS{zi})]; end %#ok<AGROW>
allWallPtNames = unique(allWallPtNames);
wallZ = nan(numel(allWallPtNames),1);
for k = 1:numel(allWallPtNames)
    xyz = pointCache(allWallPtNames{k});
    wallZ(k) = xyz(3);
end
maxZ = max(wallZ);
wallTopJointNames = allWallPtNames(wallZ >= maxZ - 0.001);
logmsg(logPath, sprintf('Wall-top: maxZ=%.4f, %d joints within 1mm of top (of %d total wall joints)', ...
    maxZ, numel(wallTopJointNames), numel(allWallPtNames)));
for k = 1:numel(wallTopJointNames)
    ret = SM.PointObj.SetGroupAssign(wallTopJointNames{k}, 'WallTop'); %#ok<NASGU>
end
logmsg(logPath, sprintf('Assigned %d joints to group WallTop', numel(wallTopJointNames)));

%% --- Per-zone base elevation (mục 6.11-style exclusion, but at the
% TUONG-zone-to-DAY-zone junction instead of a pile head): for EACH of the
% 4 wall zones independently, its own baseZ = min(Z) among ONLY that
% zone's own joints (zones may span different Z ranges, e.g. a stacked
% height-zoned wall, so this must be per-zone, not one global min). Saved
% so Sap_KeSauCau.m can exclude the shear (NOT moment -- a cantilever's
% true governing moment IS at its fixed base, that's real mechanics, not
% an FE artifact; only shear gets the standard "check h0 from the face of
% the support" treatment, same principle as the DAY-zone pile exclusion
% and as TCVN 4116:2023's own general shear-check convention) within h0
% of that zone's own base. Also save a joint->Z lookup for all wall joints
% (needed at eval time to locate each AreaForceShell result point). ---
wallZoneBaseZ = struct();
wallJointZ = containers.Map('KeyType','char','ValueType','double');
for zi = 1:numel(WALL_SECTIONS)
    zsec = WALL_SECTIONS{zi};
    pts = unique(zonePoints.(zsec));
    z = nan(numel(pts),1);
    for k = 1:numel(pts)
        xyz = pointCache(pts{k});
        z(k) = xyz(3);
        wallJointZ(pts{k}) = xyz(3); % last-write-wins if shared between zones; fine, same physical joint
    end
    wallZoneBaseZ.(zsec) = min(z);
    logmsg(logPath, sprintf('  %s: baseZ=%.4f topZ=%.4f (span %.4f) over %d joints', ...
        zsec, min(z), max(z), max(z)-min(z), numel(pts)));
end

%% --- Pass 2: frame objects (piles) -- section, group assign, top joint,
% map to whichever DAY zone area object shares that top joint. ---
pileInfo = struct('name',{},'section',{},'topJoint',{},'topXY',{},'bottomJoint',{},'dayZone',{});
for i = 1:nFrame
    name = frameNames{i};
    [ret, secName] = SM.FrameObj.GetSection(name);
    if ~any(strcmp(secName, PILE_SECTIONS))
        continue
    end
    ret = SM.FrameObj.SetGroupAssign(name, 'Piles'); %#ok<NASGU>
    [ret, pt1, pt2] = SM.FrameObj.GetPoints(name);
    % top joint = whichever endpoint has larger Z. Neither endpoint is
    % guaranteed to be in pointCache (that cache was only populated from
    % AREA object corners -- a pile's bottom/fixed joint almost certainly
    % isn't one), so fetch-and-cache both defensively rather than assuming.
    if isKey(pointCache, pt1); xyz1 = pointCache(pt1);
    else; [~,x1,y1,z1c] = SM.PointObj.GetCoordCartesian(pt1); xyz1 = [x1 y1 z1c]; pointCache(pt1) = xyz1; end
    if isKey(pointCache, pt2); xyz2 = pointCache(pt2);
    else; [~,x2,y2,z2c] = SM.PointObj.GetCoordCartesian(pt2); xyz2 = [x2 y2 z2c]; pointCache(pt2) = xyz2; end
    if xyz1(3) >= xyz2(3); topJoint = pt1; topXY = xyz1(1:2); bottomJoint = pt2; else; topJoint = pt2; topXY = xyz2(1:2); bottomJoint = pt1; end
    % JointReact is a JOINT-level result -- it needs the pile's fixed/
    % restrained BOTTOM joint in the "Piles" group, not the frame object
    % (SetGroupAssign on the frame object alone does not pull its joints
    % into the group). Assign that explicitly here.
    ret = SM.PointObj.SetGroupAssign(bottomJoint, 'Piles'); %#ok<NASGU>
    pileInfo(end+1) = struct('name',name,'section',secName,'topJoint',topJoint,'topXY',topXY,'bottomJoint',bottomJoint,'dayZone',''); %#ok<AGROW>
    % dayZone resolved in the standalone pass below (scans DAY-zone area
    % objects' corner points for a match) -- simpler than doing it inline here.
end
logmsg(logPath, sprintf('Found %d piles (C400/C500) among %d frame objects', numel(pileInfo), nFrame));

%% --- resolve each pile's DAY zone by scanning DAY-zone area objects for
% the pile's top joint among their corner points (done as its own pass,
% simpler than the inline attempt above) ---
dayZoneOfJoint = containers.Map('KeyType','char','ValueType','char');
for i = 1:nArea
    sec = areaObjSection{i};
    if isempty(sec) || ~any(strcmp(sec, DAY_SECTIONS)); continue; end
    pts = areaObjPoints{i};
    if isempty(pts); continue; end
    for k = 1:numel(pts)
        dayZoneOfJoint(pts{k}) = sec; % last-write-wins if a joint borders 2 day zones; rare/edge case
    end
end
for i = 1:numel(pileInfo)
    tj = pileInfo(i).topJoint;
    if isKey(dayZoneOfJoint, tj)
        pileInfo(i).dayZone = dayZoneOfJoint(tj);
    else
        pileInfo(i).dayZone = ''; % not directly under a DAY zone joint -- flag for manual review
    end
end
nUnmapped = sum(cellfun(@isempty, {pileInfo.dayZone}));
logmsg(logPath, sprintf('Pile->DAY-zone mapping: %d/%d unmapped (empty dayZone)', nUnmapped, numel(pileInfo)));

%% --- Pile-proximity precompute (mục 6.11-style shear exclusion near pile
% heads): for every joint touched by a DAY-zone area object, the
% horizontal distance to the nearest pile TOP joint and that pile's
% diameter (0.4 or 0.5m depending on C400/C500) -- so Sap_Ke.m can exclude
% the spurious FE peak directly over a pile head using the correct
% per-pile exclusion radius (this model has 2 pile diameters, unlike the
% single-diameter Ke project). Pure geometry, no more COM calls needed. ---
PILE_DIAM = containers.Map({'C400','C500'}, {0.4, 0.5});
pileXY = reshape([pileInfo.topXY], 2, [])'; % nPiles x 2
pileD  = cellfun(@(s) PILE_DIAM(s), {pileInfo.section})'; % nPiles x 1
dayJointNames = unique([zonePoints.(DAY_SECTIONS{1}), zonePoints.(DAY_SECTIONS{2})]);
nDayJ = numel(dayJointNames);
distToNearestPile = nan(nDayJ,1);
nearestPileDiam = nan(nDayJ,1);
for k = 1:nDayJ
    xy = pointCache(dayJointNames{k});
    xy = xy(1:2);
    d = sqrt(sum((pileXY - xy).^2, 2));
    [dmin, idx] = min(d);
    distToNearestPile(k) = dmin;
    nearestPileDiam(k) = pileD(idx);
end
logmsg(logPath, sprintf('Pile-proximity: computed for %d DAY-zone joints (min dist=%.4f, max dist=%.4f)', ...
    nDayJ, min(distToNearestPile), max(distToNearestPile)));

%% --- Save everything, save the grouped .sdb as a NEW file ---
wallJointNames_forSave = keys(wallJointZ);
wallJointZ_forSave = cell2mat(values(wallJointZ)); % containers.Map -> parallel arrays (simpler/safer to reload than a Map object)
save(matOutPath, 'zoneArea_m2', 'wallTopJointNames', 'pileInfo', 'maxZ', 'WALL_SECTIONS', 'DAY_SECTIONS', ...
    'dayJointNames', 'distToNearestPile', 'nearestPileDiam', 'wallZoneBaseZ', ...
    'wallJointNames_forSave', 'wallJointZ_forSave', '-v7.3');
logmsg(logPath, sprintf('Saved precompute data to %s', matOutPath));

ret = SM.File.Save(newSdbPath);
logmsg(logPath, sprintf('Saved grouped model to %s (ret=%d)', newSdbPath, ret));

logmsg(logPath, '=== precompute_wall_setup DONE OK ===');
try; SM.ApplicationExit(false); catch; end

function logmsg(logPath, msg)
    fid = fopen(logPath, 'a');
    fprintf(fid, '[%s] %s\n', datestr(now,'HH:MM:SS'), msg);
    fclose(fid);
    fprintf('%s\n', msg); % also to stdout, best-effort
end
