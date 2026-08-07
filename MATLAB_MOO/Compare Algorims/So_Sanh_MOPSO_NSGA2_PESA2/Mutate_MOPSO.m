%
% Copyright (c) 2015, Mostapha Kalami Heris & Yarpiz (www.yarpiz.com)
% All rights reserved. Please read the "LICENSE" file for license terms.
%
% Project Code: YPEA121
% Project Title: Multi-Objective Particle Swarm Optimization (MOPSO)
% Publisher: Yarpiz (www.yarpiz.com)
% 
% Developer: Mostapha Kalami Heris (Member of Yarpiz Team)
% 
% Cite as:
% Mostapha Kalami Heris, Multi-Objective PSO in MATLAB (URL: https://yarpiz.com/59/ypea121-mopso), Yarpiz, 2015.
% 
% Contact Info: sm.kalami@gmail.com, info@yarpiz.com
%

function xnew = Mutate_MOPSO(x, pm, VarMin, VarMax)

    nVar = numel(x);
    j = randi([1 nVar]);

    dx = pm*(VarMax(j)-VarMin(j));

    lb = x(j) - dx;
    if lb < VarMin(j)
        lb = VarMin(j);
    end

    ub = x(j) + dx;
    if ub > VarMax(j)
        ub = VarMax(j);
    end

    xnew = x;
    xnew(j) = lb + (ub - lb) * rand();

end