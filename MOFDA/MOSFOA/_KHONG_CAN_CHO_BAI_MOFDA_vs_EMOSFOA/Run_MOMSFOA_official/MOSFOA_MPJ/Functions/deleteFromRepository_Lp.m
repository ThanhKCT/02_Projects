% Function that deletes an excess of particles inside the repository using
% crowding distances
function REP = deleteFromRepository_Lp(REP,n_extra,ngrid)
    % Compute the crowding distances
    crowding = zeros(size(REP.Xpos,1),1);
    for m = 1:1:size(REP.Fitness,2)
        [m_fit,idx] = sort(REP.Fitness(:,m),'ascend');
        m_up     = [m_fit(2:end); Inf];
        m_down   = [Inf; m_fit(1:end-1)];
        distance = (m_up-m_down)./(max(m_fit)-min(m_fit));
        [~,idx]  = sort(idx,'ascend');
        crowding = crowding + distance(idx);
    end
    crowding(isnan(crowding)) = Inf;
    
    % Delete the extra particles with the smallest crowding distances
    [~,del_idx] = sort(crowding,'ascend');
    del_idx = del_idx(1:n_extra);
    REP.Xpos(del_idx,:) = [];
    REP.Lp(del_idx,:) = [];
    REP.Fitness(del_idx,:) = [];
    REP = updateGrid(REP,ngrid); 
end