clear; clc;
S = load(fullfile(fileparts(mfilename('fullpath')), 'results', 'Bruteforce_B_FINAL.mat'));
for x = [1 16 21 33]
    d = S.diagAll{x};
    fprintf('x=%2d N_max=%.2fT M_max=%.3fTm nFrames=%d Rd=%.2fT feasible=%d\n', ...
        x, d.N_max_T, d.M_max_Tm, d.n_pile_frames_found, d.Rd_T, d.feasible);
end
