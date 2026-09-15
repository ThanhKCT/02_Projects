function run_mosfoa2_campaign(proj, Nrun, Num_work, Npop, Max_it)
% RUN_MOSFOA2_CAMPAIGN  Chay Nrun lan doc lap MOSFOA cho 1 cong trinh,
% goi lap lai run_mosfoa2_parallel.m - dung theo muc 6.2 de cuong ("thuc
% hien nhieu lan chay doc lap moi case de danh gia tinh on dinh").
%
% Cau hinh da CHOT (nguoi dung, 10/09/2026): Npop=8, Max_it=20, Nrun=20 -
% phu hop khong gian thiet ke nho (1 bien, K=33 catalogue), khac Bai 1
% (3 bien lien tuc, Npop=50/Max_it=250) - KHONG dung lai nguyen cau hinh
% Bai 1 vi khong gian qua nho so voi ngan sach do.
%
%   run_mosfoa2_campaign('B', 20, 8, 8, 20)   % chay B truoc (nhe hon)
%   run_mosfoa2_campaign('A', 20, 8, 8, 20)

if nargin < 2 || isempty(Nrun), Nrun = 20; end
if nargin < 3 || isempty(Num_work), Num_work = 8; end
if nargin < 4 || isempty(Npop), Npop = 8; end
if nargin < 5 || isempty(Max_it), Max_it = 20; end

for r = 1:Nrun
    RunTag = sprintf('run%02d', r);
    fprintf('\n========== CONG TRINH %s - %s (%d/%d) ==========\n', upper(proj), RunTag, r, Nrun);
    run_mosfoa2_parallel(proj, RunTag, Num_work, Npop, Max_it);
end

fprintf('\n=== HOAN THANH CAMPAIGN %d LAN CHAY CHO CONG TRINH %s ===\n', Nrun, upper(proj));
end
