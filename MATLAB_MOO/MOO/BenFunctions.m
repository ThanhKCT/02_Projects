
function Fit=BenFunctions(X,FunIndex,Dim)




switch FunIndex
    
    %ZDT1
    case 1
        Fit = [0; 0];
        g = 1 + 9*sum(X(2:Dim))/(Dim-1);
        Fit(1) = X(1);
        Fit(2) = g*(1-sqrt(X(1)/g));
     
        %ZDT2
    case 2
        Fit = [0; 0];
        g = 1 + 9*sum(X(2:Dim))/(Dim-1);
        Fit(1) = X(1);
        Fit(2) = g * ( 1-(X(1)/g)^2);
        
        %ZDT3
    case 3
        Fit=[0; 0];
        g = 1 + 9*sum(X(2:Dim))/(Dim-1);
        Fit(1) = X(1);
        Fit(2) = g * ( 1-sqrt(X(1)/g) - X(1)/g*sin(10*pi*X(1)) );
        
        %ZDT4
    case 4
        Dim=10;
        Fit = [0; 0];
        g = 1 + 10*(10-1);
        for i = 2:10
            g = g + X(i)^2 - 10* cos(4*pi*X(i));
        end
        Fit(1) = X(1);
        Fit(2) = g * (1-sqrt(X(1)/g));
       
        %ZDT6
    otherwise
        Dim=10;
        Fit = [0; 0]; 
        g = 1 + 9 * (sum(X(2:Dim))/(Dim-1))^0.25;        
        Fit(1) = 1 - exp(-4*X(1)) * sin(6*pi*X(1))^6;
        Fit(2) = g * (1 - (Fit(1)/g)^2);
        
        
end

 
