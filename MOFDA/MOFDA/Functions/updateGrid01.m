% Function that updates the hypercube grid, the hypercube where belongs
% each particle and its quality based on the number of particles inside it
function REP_nei = updateGrid01(REP_nei,ngrid)
    % Computing the limits of each hypercube
    ndim = size(REP_nei.pos_fit,2);
    REP_nei.hypercube_limits = zeros(ngrid+1,ndim);
    for dim = 1:1:ndim
        REP_nei.hypercube_limits(:,dim) = linspace(min(REP_nei.pos_fit(:,dim)),max(REP_nei.pos_fit(:,dim)),ngrid+1)';
    end
    
    % Computing where belongs each particle
    npar = size(REP_nei.pos_fit,1);
    REP_nei.grid_idx = zeros(npar,1);
    REP_nei.grid_subidx = zeros(npar,ndim);
    for n = 1:1:npar
        idnames = [];
        for d = 1:1:ndim
            REP_nei.grid_subidx(n,d) = find(REP_nei.pos_fit(n,d)<=REP_nei.hypercube_limits(:,d)',1,'first')-1;
            if(REP_nei.grid_subidx(n,d)==0), REP_nei.grid_subidx(n,d) = 1; end
            idnames = [idnames ',' num2str(REP_nei.grid_subidx(n,d))];
        end
        REP_nei.grid_idx(n) = eval(['sub2ind(ngrid.*ones(1,ndim)' idnames ');']);
    end
    
    % Quality based on the number of particles in each hypercube
    REP_nei.quality = zeros(ngrid,2);
    ids = unique(REP_nei.grid_idx);
    for i = 1:length(ids)
        REP_nei.quality(i,1) = ids(i);  % First, the hypercube's identifier
        REP_nei.quality(i,2) = 10/sum(REP_nei.grid_idx==ids(i)); % Next, its quality
    end
end
