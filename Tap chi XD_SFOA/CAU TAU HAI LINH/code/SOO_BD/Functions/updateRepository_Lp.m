% Function that updates the repository given a new population and its
% fitness
function REP = updateRepository_Lp(REP,POS,POS_fit,ngrid)
    % Domination between particles
    DOMINATED  = checkDomination(POS_fit);
    REP.Xpos    = [REP.Xpos; POS(~DOMINATED,:)];
    REP.Lp    = [REP.Lp; POS(~DOMINATED,:)];
    REP.Fitness= [REP.Fitness; POS_fit(~DOMINATED,:)];
    % Domination between nondominated particles and the last repository
    DOMINATED  = checkDomination(REP.Fitness);
    REP.Fitness= REP.Fitness(~DOMINATED,:);
    REP.Xpos    = REP.Xpos(~DOMINATED,:);
    REP.Lp    = REP.Lp(~DOMINATED,:);
    % Updating the grid
    REP        = updateGrid(REP,ngrid);
end