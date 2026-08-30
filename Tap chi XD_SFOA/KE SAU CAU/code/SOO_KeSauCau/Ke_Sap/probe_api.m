%% probe_api.m -- one-off exploratory script to confirm exact SAP2000 OAPI
% call signatures/behavior before writing the real precompute script.
% Opens the VERIFIED baseline read-only (never saves), prints results, exits.
% DEFENSIVE VERSION: each call wrapped in try/catch + raw class/value dump
% so one wrong output-order guess doesn't blow up the whole (slow) probe run.
scriptDir = fileparts(mfilename('fullpath'));
sdbPath = fullfile(scriptDir,'..','..','..','Sap','ke pd 10.sdb');
assert(isfile(sdbPath), 'baseline sdb not found at %s', sdbPath);

open_Sap2000(1); pause(2); SM.Hide;
ret = SM.File.OpenFile(sdbPath);
fprintf('OpenFile ret=%d\n', ret);
SM.SetPresentUnits(SM.eUnits.Ton_m_C);

try
    [o1,o2,o3] = SM.AreaObj.GetNameList();
    dump('AreaObj.GetNameList (3out)', o1,o2,o3);
catch ME
    fprintf('AreaObj.GetNameList 3out FAILED: %s\n', ME.message);
end

areaNames = {};
try
    [o1,o2] = SM.AreaObj.GetNameList();
    dump('AreaObj.GetNameList (2out)', o1,o2);
    if iscell(o1); areaNames = o1; elseif iscell(o2); areaNames = o2; end
catch ME
    fprintf('AreaObj.GetNameList 2out FAILED: %s\n', ME.message);
end

if ~isempty(areaNames)
    sampleArea = areaNames{1};
    fprintf('sampleArea = %s\n', sampleArea);
    try
        [o1,o2] = SM.AreaObj.GetProperty(sampleArea);
        dump('AreaObj.GetProperty (2out)', o1,o2);
    catch ME
        fprintf('AreaObj.GetProperty FAILED: %s\n', ME.message);
    end
    try
        [o1,o2,o3] = SM.AreaObj.GetPoints(sampleArea);
        dump('AreaObj.GetPoints (3out)', o1,o2,o3);
    catch ME
        fprintf('AreaObj.GetPoints FAILED: %s\n', ME.message);
    end
    try
        [o1,o2] = SM.AreaElm.GetArea(sampleArea);
        dump('AreaElm.GetArea (2out)', o1,o2);
    catch ME
        fprintf('AreaElm.GetArea FAILED: %s\n', ME.message);
    end
end

try
    [o1,o2] = SM.FrameObj.GetNameList();
    dump('FrameObj.GetNameList (2out)', o1,o2);
    frameNames = {}; if iscell(o1); frameNames = o1; elseif iscell(o2); frameNames = o2; end
    if ~isempty(frameNames)
        sampleFrame = frameNames{1};
        fprintf('sampleFrame = %s\n', sampleFrame);
        [p1,p2] = SM.FrameObj.GetSection(sampleFrame);
        dump('FrameObj.GetSection (2out)', p1,p2);
    end
catch ME
    fprintf('FrameObj probe FAILED: %s\n', ME.message);
end

if ~isempty(areaNames)
    try
        [o1,o2,o3] = SM.AreaObj.GetPoints(areaNames{1});
        ptNames = {}; if iscell(o1); ptNames = o1; elseif iscell(o2); ptNames = o2; elseif iscell(o3); ptNames = o3; end
        if ~isempty(ptNames)
            [x,y,z,r] = SM.PointObj.GetCoordCartesian(ptNames{1});
            dump('PointObj.GetCoordCartesian (4out)', x,y,z,r);
        end
    catch ME
        fprintf('PointObj probe FAILED: %s\n', ME.message);
    end
end

try
    ret = SM.GroupDef.SetGroup_1('ProbeTestGroup');
    fprintf('GroupDef.SetGroup_1 ret=%g\n', ret);
    if ~isempty(areaNames)
        ret2 = SM.AreaObj.SetGroupAssign(areaNames{1}, 'ProbeTestGroup');
        fprintf('AreaObj.SetGroupAssign ret=%g\n', ret2);
    end
catch ME
    fprintf('GroupDef probe FAILED: %s\n', ME.message);
end

fprintf('PROBE DONE OK\n');
try; SM.ApplicationExit(false); catch; end

function dump(label, varargin)
    fprintf('--- %s: %d outputs ---\n', label, numel(varargin));
    for i = 1:numel(varargin)
        v = varargin{i};
        fprintf('  out%d class=%s ', i, class(v));
        if iscell(v)
            fprintf('numel=%d sample=%s\n', numel(v), mat2str(string(v(1:min(3,numel(v))))));
        elseif isnumeric(v) && isscalar(v)
            fprintf('value=%g\n', v);
        elseif isnumeric(v)
            fprintf('size=%s sample=%s\n', mat2str(size(v)), mat2str(v(1:min(3,numel(v)))));
        elseif ischar(v) || isstring(v)
            fprintf('value=%s\n', v);
        else
            fprintf('(other)\n');
        end
    end
end
