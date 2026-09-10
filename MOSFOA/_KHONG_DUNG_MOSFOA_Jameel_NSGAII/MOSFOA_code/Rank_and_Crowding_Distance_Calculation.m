function pop = Rank_and_Crowding_Distance_Calculation(pop, nobj, ncon, nreal, nbin)
global INF
N = size(pop,1);
P = [pop (1:N)'];
obj_max = max(pop(:,1:nobj));
obj_min = min(pop(:,1:nobj));
r = 1;
while N ~= 0
    % NON-DOMINATION SORTING
    p = simple_sort(N,P,nobj,ncon,nreal,nbin);
    n_p = size(p,2);
    globID = P(p,end);
    % ASSIGN THE RANKS OF INDIVIDUALS
    pop(globID,nobj+ncon+nreal+nbin+2) = r;
    % COMPUTE THE CROWDING DISTANCE
    if n_p == 1
        pop(globID,end) = INF;
    elseif n_p == 2
        pop(globID(1),end) = INF;
        pop(globID(2),end) = INF;
    else
        d = zeros(n_p,1);
        for i=1:nobj
            [~, m_ID] = sort(pop(globID,i));
            m_ID = globID(m_ID);
            d(1) = INF; d(end) = INF;
            for j=2:n_p-1
                d(j,1) = d(j,1) + abs((pop(m_ID(j+1),i)-pop(m_ID(j-1),i))) / (obj_max(1,i)-obj_min(1,i));
            end
        end
        pop(m_ID,end) = d;
    end
    r = r+1;
    N = N - n_p;
    P(p,:) = [];
end
%--------------------------------------------------------------------------------------------
function p = simple_sort(N,P,nobj,ncon,nreal,nbin)
p = [];
j_dom_i = 0;
for i=1:N
    for j=1:N
        if j ~= i
            j_dom_i = DominanceChecking(P(j,:), P(i,:), nobj, ncon, nreal, nbin); 
            % 1: j dominates i; -1: i dominates j; 0: both are non-dominated.
            if j_dom_i == 1
                break
            end
        end
    end
    if j_dom_i ~= 1
        p=[p i];
    end
    j_dom_i = 0;
end
