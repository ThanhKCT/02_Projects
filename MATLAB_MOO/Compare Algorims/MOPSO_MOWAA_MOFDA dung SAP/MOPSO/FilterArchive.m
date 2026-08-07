function CleanArchive = FilterArchive(Archive)
    if isempty(Archive)
        CleanArchive = []; return;
    end
    n = numel(Archive); keep = true(n, 1);
    for i = 1:n
        for j = 1:n
            if i ~= j && Dominates(Archive(j), Archive(i))
                keep(i) = false; break;
            end
        end
    end
    CleanArchive = Archive(keep);
end