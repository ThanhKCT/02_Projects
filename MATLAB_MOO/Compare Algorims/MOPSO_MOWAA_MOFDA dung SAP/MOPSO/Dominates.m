function dom = Dominates(p1, p2)
    dom = all(p1.Cost <= p2.Cost) && any(p1.Cost < p2.Cost);
end