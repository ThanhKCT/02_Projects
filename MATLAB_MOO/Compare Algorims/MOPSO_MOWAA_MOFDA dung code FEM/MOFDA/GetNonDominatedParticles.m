
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


function nd_pop=GetNonDominatedParticles(pop)

    ND=~[pop.Dominated];
    
    nd_pop=pop(ND);

end