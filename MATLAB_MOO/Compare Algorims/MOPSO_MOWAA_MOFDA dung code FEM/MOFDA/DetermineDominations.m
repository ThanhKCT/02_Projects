
%__________________________________________________________________     %
%        Multi-Objective Flow Direction Algorithm  (MOFDA)              %
%                                                                       %
%                                                                       %
%                  Developed in MATLAB R2024b (MacOs)                   %
%                                                                       %
%                      Author and programmer                            %
%                ---------------------------------                      %
%                Nima Khodadadi (ʘ‿ʘ)   University of Miami             %
%                             e-Mail                                    %
%                ---------------------------------                      %
%                      Nima.khodadadi@miami.edu                         %
%                                                                       %
%                                                                       %
%                            Homepage                                   %
%                ---------------------------------                      %
%                    https://nimakhodadadi.com                          %
%                                                                       %
%                                                                       %
%                                                                       %
%                                                                       %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


% ----------------------------------------------------------------------- %


function pop=DetermineDominations(pop)

    npop=numel(pop);
    
    for i=1:npop
        pop(i).Dominated=false;
        for j=1:i-1
            if ~pop(j).Dominated
                if Dominates(pop(i),pop(j))
                    pop(j).Dominated=true;
                elseif Dominates(pop(j),pop(i))
                    pop(i).Dominated=true;
                    break;
                end
            end
        end
    end

end