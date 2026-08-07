
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


function particle=CreateEmptyParticle(n)
    
    if nargin<1
        n=1;
    end

    empty_particle.Position=[];
    empty_particle.Velocity=[];
    empty_particle.Cost=[];
    empty_particle.Dominated=false;
    empty_particle.Best.Position=[];
    empty_particle.Best.Cost=[];
    empty_particle.GridIndex=[];
    empty_particle.GridSubIndex=[];
    
    particle=repmat(empty_particle,n,1);
    
end