function [zi_bed,zi_mi]=segment_pile(SLs,SKs,LP_in_soil,ILs,segment)
% SLs = 3; % Number of soil layers
% SKs = [3.2 4.4 5.1]; % Soil thickness of each layers
% LP_in_soil = 8.8; % Length of pile in soil
for i=1:size(SKs,2)
    cumsum_SKs = cumsum(SKs);
    Check_LP_in_SLs = LP_in_soil - cumsum_SKs(i);
    if Check_LP_in_SLs>=0;
        LP_per_SLs(i) = SKs(i);
    else
        LP_per_SLs(i) = LP_in_soil - sum(SKs(1:i-1));
    end
end
% segment = 1;
zi_bed(1) = segment;
zi_mi(1)  = segment/2;
ILi(1)    = ILs(1);
it=1;
for i =1:size(SKs,2);
    while max(zi_mi)<=cumsum_SKs(i) & max(zi_mi)<=LP_in_soil
        it=it+1;
        zi_mi(it)   = zi_mi(it-1) + segment;
        zi_bed(it)  = zi_bed(it-1) + segment;
        ILi(it)     = ILs(i)
    end
    zi_mi(it) = zi_mi(it-1)+0.5*(min(cumsum_SKs(i),LP_in_soil)-zi_mi(it-1));
    zi_bed(it) = min(cumsum_SKs(i),LP_in_soil);
    
end
tks = diff(zi_bed);
end
