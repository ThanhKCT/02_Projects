% Auxiliary function to find local best
function idx = findLocalBest(Xpos, Fitness, current_idx)
    distances = sqrt(sum((Xpos - Xpos(current_idx,:)).^2,2));
    [~, sorted_indices] = sort(distances);
    local_group = sorted_indices(2:4);
    [~, min_idx] = min(Fitness(local_group,1));
    idx = local_group(min_idx);
end