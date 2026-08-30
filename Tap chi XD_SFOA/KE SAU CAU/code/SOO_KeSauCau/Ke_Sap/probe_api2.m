%% probe_api2.m -- round 2: confirmed convention is [ret, count, data] for
% list-returning calls. This probes the remaining unknowns in one shot:
% AreaObj.GetProperty, AreaObj.GetPoints, PointObj.GetCoordCartesian,
% FrameObj.GetSection, GroupDef.SetGroup(_1), AreaObj/FrameObj.SetGroupAssign.
scriptDir = fileparts(mfilename('fullpath'));
sdbPath = fullfile(scriptDir,'..','..','..','Sap','ke pd 10.sdb');
assert(isfile(sdbPath), 'baseline sdb not found at %s', sdbPath);

open_Sap2000(1); pause(2); SM.Hide;
ret = SM.File.OpenFile(sdbPath);
fprintf('OpenFile ret=%d\n', ret);
SM.SetPresentUnits(SM.eUnits.Ton_m_C);

[ret, nArea, areaNames] = SM.AreaObj.GetNameList();
fprintf('nArea=%d ret=%d\n', nArea, ret);
sampleArea = areaNames{1};
fprintf('sampleArea=%s\n', sampleArea);

try
    [ret, propName] = SM.AreaObj.GetProperty(sampleArea);
    fprintf('AreaObj.GetProperty 2out: ret=%d propName=%s\n', ret, propName);
catch ME; fprintf('GetProperty 2out FAILED: %s\n', ME.message); end

try
    [ret, nPts, ptNames] = SM.AreaObj.GetPoints(sampleArea);
    fprintf('AreaObj.GetPoints 3out: ret=%d nPts=%d pts=%s\n', ret, nPts, strjoin(ptNames,','));
catch ME; fprintf('GetPoints 3out FAILED: %s\n', ME.message); ptNames = {}; end

if ~isempty(ptNames)
    try
        [ret,x,y,z] = SM.PointObj.GetCoordCartesian(ptNames{1});
        fprintf('PointObj.GetCoordCartesian 4out: ret=%d xyz=[%.4f %.4f %.4f]\n', ret,x,y,z);
    catch ME; fprintf('GetCoordCartesian 4out FAILED: %s\n', ME.message); end
end

[ret, nFrame, frameNames] = SM.FrameObj.GetNameList();
fprintf('nFrame=%d ret=%d\n', nFrame, ret);
sampleFrame = frameNames{1};
try
    [ret, secName] = SM.FrameObj.GetSection(sampleFrame);
    fprintf('FrameObj.GetSection 2out: ret=%d sec=%s\n', ret, secName);
catch ME
    fprintf('GetSection 2out FAILED: %s\n', ME.message);
    try
        [ret, secName, sAuto] = SM.FrameObj.GetSection(sampleFrame);
        fprintf('FrameObj.GetSection 3out: ret=%d sec=%s sAuto=%s\n', ret, secName, sAuto);
    catch ME2; fprintf('GetSection 3out FAILED: %s\n', ME2.message); end
end

% Group creation -- try both possible names
try
    ret = SM.GroupDef.SetGroup('ProbeTestGroup2');
    fprintf('GroupDef.SetGroup ret=%g\n', ret);
catch ME; fprintf('GroupDef.SetGroup FAILED: %s\n', ME.message); end

try
    ret = SM.AreaObj.SetGroupAssign(sampleArea, 'ProbeTestGroup2');
    fprintf('AreaObj.SetGroupAssign ret=%g\n', ret);
catch ME; fprintf('AreaObj.SetGroupAssign FAILED: %s\n', ME.message); end

try
    ret = SM.FrameObj.SetGroupAssign(sampleFrame, 'ProbeTestGroup2');
    fprintf('FrameObj.SetGroupAssign ret=%g\n', ret);
catch ME; fprintf('FrameObj.SetGroupAssign FAILED: %s\n', ME.message); end

% does GetNameList accept a group-name filter argument, for later reuse?
try
    [ret, nInGrp, namesInGrp] = SM.AreaObj.GetNameList('ProbeTestGroup2', 1); % (GroupName, SelectionOnly) guess
    fprintf('AreaObj.GetNameList(group) ret=%d nInGrp=%d\n', ret, nInGrp);
catch ME; fprintf('GetNameList(group) FAILED: %s\n', ME.message); end

fprintf('PROBE2 DONE OK\n');
try; SM.ApplicationExit(false); catch; end
