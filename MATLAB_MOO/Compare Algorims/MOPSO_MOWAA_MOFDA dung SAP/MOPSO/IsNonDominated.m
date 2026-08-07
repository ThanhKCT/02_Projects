function status = IsNonDominated(p, Archive)
    status = true;
    for k = 1:numel(Archive)
        if Dominates(Archive(k), p)
            status = false;
            break;
        end
    end
end