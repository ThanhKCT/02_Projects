function d = dominates1(x,y)
    d = all(x<=y,2) & any(x<y,2);
end