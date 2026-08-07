%--------------------------------------------------------------------------%
% Multi-Objective artificial hummingbird algorithm (MOAHA)                 %
% Source codes demo version 1.0                                            %
% The code is based on the following paper:                                %
% W. Zhao, Z. Zhang, S. Mirjalili, L. Wang, N. Khodadadi, S. M. Mirjalili£¬% 
% An effective multi-objective artificial hummingbird algorithm with       %
% dynamic elimination-based crowding distance for solving engineering      %
% design problems, Computer  Methods in Applied Mechanics and Engineering, % 
% (2022), 115223, https://doi.org/10.1016/j.cma.2022.115223 (in press).    %
%--------------------------------------------------------------------------%
%  FunIndex = 1: ZDT1
%  FunIndex = 2: ZDT2
%  FunIndex = 3: ZDT3
%  FunIndex = 4: ZDT4
%  FunIndex = 5: ZDT6
 

clc;
clear;
 
MaxIt=300;
nPop=100;
Dim=30;
ArchiveSize=100;

 FunIndex=1;% ZDT1

    [ArchiveFit]=MOAHA(FunIndex,MaxIt,nPop,ArchiveSize);
    
    figure;
    plot(ArchiveFit(1,:),ArchiveFit(2,:),'r.');
    if FunIndex==5
        title(['ZDT',num2str(FunIndex+1)]);
    else
        title(['ZDT',num2str(FunIndex)]);
    end
    xlabel('f1');
    ylabel('f2');
    box on
    legend('PF');
  




