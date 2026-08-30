%______________________________________________________________________________________
%  Multi-Objective Multi-Verse Optimization (MOMVO) algorithm source codes version 1.0
%
%  Developed in MATLAB R2016a
%
%  Author and programmer: Seyedali Mirjalili
%
%         e-Mail: ali.mirjalili@gmail.com
%                 seyedali.mirjalili@griffithuni.edu.au
%
%       Homepage: http://www.alimirjalili.com
%
%   Main paper:
%   S. Mirjalili, P. Jangir, S. Z. Mirjalili, S. Saremi, and I. N. Trivedi
%   Optimization of problems with multiple objectives using the multi-verse optimization algorithm, 
%   Knowledge-based Systems, 2017, DOI: http://dx.doi.org/10.1016/j.knosys.2017.07.018
%______________________________________________________________________________________

function generalizedspread = GeneralizedSpread_matlab(PF, truePF)
% PF=PF.pos_fit;
%STEP 1. Obtain the maximum and minimum values of the Pareto front
m1 = size(PF, 1);
m = size(truePF, 1);
maxVals = max(truePF);
minVals = min(truePF);

%STEP 2. Get the normalized front
normalizedPF = (PF - repmat(minVals, m1, 1)) ./ repmat(maxVals - minVals, m1, 1);
normalizedTruePF = (truePF - repmat(minVals, m, 1)) ./ repmat(maxVals - minVals, m, 1);

%STEP 3. find extrmal values
[~, I] = max(normalizedTruePF);
extremValues = normalizedTruePF(I, :);

%STEP 4. Sort normalizedFront and normalizedParetoFront;
normalizedPF = sortrows(normalizedPF);

%STEP 5. Calculate the metric value. The value is 1.0 by default
diff = normalizedPF(1, :) - normalizedPF(m1-1, :);
dist = sqrt(sum(diff.^2, 2));
if dist == 0.0
    generalizedspread = 1.0;
else
    %STEP 6. Calculate the mean distance between each point and its nearest neighbor
    distance_near = zeros(m1, 1);
    for i = 1:m1
        diff = repmat(normalizedPF(i,:), m1, 1) - normalizedPF;
        dist = sqrt(sum(diff.^2, 2));
        dist(i) = realmax; %maximum value in double
        distance_near(i) = min(dist);
    end
    dmean = mean(distance_near);
    % STEP 7. Calculate the distance to extremal values
    dExtrems = 0;
    for i = 1:size(extremValues, 1)
        diff = repmat(extremValues(i,:), m1, 1) - normalizedPF;
        dist = sqrt(sum(diff.^2, 2));
        dExtrems = dExtrems + min(dist);
    end
    %STEP 8. Computing the value of the metric
    sumVal = sum(abs(distance_near - repmat(dmean, m1, 1)));
    generalizedspread = (dExtrems + sumVal) / (dExtrems + m1 * dmean);
end

end