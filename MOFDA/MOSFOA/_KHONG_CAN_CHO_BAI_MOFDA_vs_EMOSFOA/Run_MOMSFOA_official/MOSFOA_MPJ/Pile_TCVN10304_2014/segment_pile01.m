function [zi_bed,zi_mi,ILi,rss,f_rise,gamma_cf]=segment_pile01(Ss,Ks,LP,ILs,seg,frise,gamma_c)
% Ss = 3; % Number of soil layers
% Ks = [3.2 4.4 5.1]; % Soil thickness of each layers
% LP = 8.8; % Length of pile in soil
% seg = 1; % Maximum length of each soil segment
% ILs = [0.4 0.35 0.3]; % IL of each soil layers

Nss = floor(Ks / seg); % Number of segments of each soil layer 
rls = mod(Ks, seg); % The remaining of the end segment of each soil layer
rss = []; % The real segment length of each soil layer
for is = 1:size(Nss,2) 
    rss =[rss [repmat(seg, 1, Nss(is)), rls(is)]];
end


zi_bed = cumsum(rss); % The depth (z) of each soil layer 
zi_bed(find(zi_bed >= LP, 1, 'first')+1:end)=[]; % Remove the depth lager than pile depth
zi_bed(find(zi_bed >= LP, 1, 'first'))=LP; % Sync the depth of segments for pile in soil

rss(find(zi_bed >= LP, 1, 'first')+1:end)=[];
rss(end) = zi_bed(end) - zi_bed(end-1);

rsPs = repelem(rss / 2, 2);
zi_mi=cumsum(rsPs);
zi_mi = zi_mi(1:2:end);

for i=1:length(zi_mi)
    layer_idx = find(zi_mi(i) <= cumsum(Ks), 1, 'first');
    ILi(i) = ILs(layer_idx);
    f_rise(i) = frise(layer_idx);
    gamma_cf(i) = gamma_c(layer_idx);
end

end
