S = load('D:\ResearchLab\02_Projects\02_Projects\MOFDA\Wharf100DWT\results\Wharf100DWT_BRUTEFORCE_FINAL.mat');
disp('--- top fields ---'); disp(fieldnames(S));
disp('--- cfg fields ---'); disp(fieldnames(S.cfg));
disp('--- Xall size ---'); disp(size(S.Xall));
disp('--- ParetoFit size ---'); disp(size(S.ParetoFit));
disp('--- ParetoX size ---'); disp(size(S.ParetoX));
disp('--- sample Xall row 1 ---'); disp(S.Xall(1,:));
disp('--- sample ParetoX row 1 ---'); disp(S.ParetoX(1,:));
if isfield(S.cfg,'D_list'); disp('D_list:'); disp(S.cfg.D_list); end
if isfield(S.cfg,'t_list'); disp('t_list:'); disp(S.cfg.t_list); end
disp('--- all cfg content ---');
disp(S.cfg);
