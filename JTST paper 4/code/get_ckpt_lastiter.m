function get_ckpt_lastiter(ckptPath)
% GET_CKPT_LASTITER  In ra man hinh gia tri lastIter cua 1 file checkpoint
% MOSFOA2 (hoac -1 neu khong doc duoc) - dung boi watchdog_campaign.ps1 de
% kiem tra tien do giua cac lan restart (khong dung SM.*/COM, chi doc file
% .mat thuan tuy nen `matlab -batch` la an toan o day).
try
    S = load(ckptPath, 'lastIter');
    fprintf('%d\n', S.lastIter);
catch
    fprintf('-1\n');
end
end
