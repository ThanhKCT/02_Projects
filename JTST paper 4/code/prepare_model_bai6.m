% PREPARE_MODEL_BAI6  Script MOT LAN, sua ban LAM VIEC (KHONG bao gio dung
% cfg.sdb_baseline_path - file goc trong "Mo hinh SAP" giu nguyen vinh vien):
% them ngam 6 bac tu do cho nut 1945 (bug da biet: 96 coc nhung chi 95 nut
% duoc ngam trong JOINT RESTRAINT ASSIGNMENTS goc - xem
% FEM_Ben70000DWT_ChanMay.md muc 7). Chay diagnose_bai6.m TRUOC va SAU script
% nay de xac nhan restraint da doi tu [false...] sang [true...].
%
% Chay bang: matlab -r "cd('...code'); prepare_model_bai6; exit;"

scriptDir = fileparts(mfilename('fullpath'));
addpath(scriptDir);
cfg = project_config_bai6();

if ~isfile(cfg.sdb_path)
    error('prepare_model_bai6: khong tim thay ban lam viec %s -- copy tu %s truoc khi chay script nay.', ...
        cfg.sdb_path, cfg.sdb_baseline_path);
end

[~, ~] = open_Sap2000_v2(cfg.sdb_path, true);
try
    SM.SetModelIsLocked(false);
catch
end

[ret, restraintBefore] = SM.PointObj.GetRestraint('1945');
fprintf('Truoc khi sua: restraint nut 1945 = %s (ret=%d)\n', mat2str(logical(restraintBefore)), ret);

ret = SM.PointObj.SetRestraint('1945', [true true true true true true]);
if ret ~= 0
    error('prepare_model_bai6: SetRestraint that bai (ret=%d) cho nut 1945.', ret);
end

[~, restraintAfter] = SM.PointObj.GetRestraint('1945');
fprintf('Sau khi sua: restraint nut 1945 = %s\n', mat2str(logical(restraintAfter)));

retSave = SM.File.Save('FileName', cfg.sdb_path);
if retSave ~= 0
    error('prepare_model_bai6: Save that bai (ret=%d).', retSave);
end
fprintf('Da luu ban lam viec da sua: %s\n', cfg.sdb_path);

try, SM.ApplicationExit(); catch, end
