S = load('D:\ResearchLab\02_Projects\02_Projects\MOFDA\Wharf100DWT\results\Wharf100DWT_BRUTEFORCE_FINAL.mat');
disp('--- diagnostic size/class/unique ---');
disp(size(S.diagnostic)); disp(class(S.diagnostic)); disp(unique(S.diagnostic(:))');
disp('--- fit size ---'); disp(size(S.fit));
feasMask = S.diagnostic == 0 | S.diagnostic == 1; % just to see
disp('--- fit range ALL ---'); disp([min(S.fit,[],1); max(S.fit,[],1)]);
% Try common feasible flag conventions
for v = unique(S.diagnostic(:))'
    fprintf('diagnostic==%g : n=%d\n', v, sum(S.diagnostic==v));
end
disp('--- ParetoFit range ---'); disp([min(S.ParetoFit,[],1); max(S.ParetoFit,[],1)]);
disp('--- ParetoX all rows ---'); disp(S.ParetoX);
