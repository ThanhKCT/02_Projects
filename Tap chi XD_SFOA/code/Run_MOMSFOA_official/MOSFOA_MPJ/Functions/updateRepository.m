% Function that updates the repository given a new population and its
% fitness
function REP = updateRepository(REP,POS,POS_fit,ngrid)
    % Domination between particles
    DOMINATED  = checkDomination(POS_fit);
    REP.Xpos    = [REP.Xpos; POS(~DOMINATED,:)];
    REP.Fitness= [REP.Fitness; POS_fit(~DOMINATED,:)];
    % Domination between nondominated particles and the last repository
    DOMINATED  = checkDomination(REP.Fitness);
    REP.Fitness= REP.Fitness(~DOMINATED,:);
    REP.Xpos    = REP.Xpos(~DOMINATED,:);
    % Updating the grid
    REP        = updateGrid(REP,ngrid);
end