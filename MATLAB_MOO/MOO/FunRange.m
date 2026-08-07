

function [Low,Up,Dim]=FunRange(FunIndex)

Dim=30;

switch FunIndex
    
    case 1       
        Low(1,1:Dim)  = 0;
        Up(1,1:Dim)  =  1;
        
        
    case 2      
        Low(1,1:Dim)  = 0;
        Up(1,1:Dim)  =  1;
        
        
    case 3        
        Low(1,1:Dim)  = 0;
        Up(1,1:Dim)  =  1;
        
        
    case 4
        Dim=10;
        Low(1,1)=0;
        Up(1,1)=1;
        Low(1,2:Dim)  = -10;
        Up(1,2:Dim)  =  10;
        
        
        
    otherwise
        Dim=10;
        Low(1,1:Dim)  = 0;
        Up(1,1:Dim)  =  1;
        
        
        
end

