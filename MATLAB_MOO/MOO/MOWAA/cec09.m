% cec09.m
% 
% The Matlab version of the test instances for CEC 2009 Multiobjective
%   Optimization Competition.
% 
% Usage: fobj = cec09(problem_name), the handle of the function will be
%   with fobj
% 
% Please refer to the report for correct one if the source codes are not
%   consist with the report.
% History:
%   v1 Sept.08 2008
%   v2 Nov.18  2008
%   v3 Nov.26  2008

function fobj = cec09(name)

    switch name
        case 'UF1'
            fobj = @UF1;
        case 'UF2'
            fobj = @UF2; 
        case 'UF3'
            fobj = @UF3;  
        case 'UF4'
            fobj = @UF4;
        case 'UF5'
            fobj = @UF5; 
        case 'UF6'
            fobj = @UF6;
        case 'UF7'
            fobj = @UF7;
        case 'UF8'
            fobj = @UF8; 
        case 'UF9'
            fobj = @UF9; 
        case 'UF10'
            fobj = @UF10;
        case 'CF1'
            fobj = @CF1;
        case 'CF2'
            fobj = @CF2; 
        case 'CF3'
            fobj = @CF3;  
        case 'CF4'
            fobj = @CF4;
        case 'CF5'
            fobj = @CF5; 
        case 'CF6'
            fobj = @CF6;
        case 'CF7'
            fobj = @CF7;
        case 'CF8'
            fobj = @CF8; 
        case 'CF9'
            fobj = @CF9; 
        case 'CF10'
            fobj = @CF10;   
        case 'ZDT1'
            fobj = @ZDT1;
		case 'ZDT2'
            fobj = @ZDT2;
		case 'ZDT3'
            fobj = @ZDT3;
		case 'ZDT4'
            fobj = @ZDT4;
		case 'ZDT5'
            fobj = @ZDT5;
		case 'ZDT6'
            fobj = @ZDT6;
        case 'GLT1'
            fobj = @GLT1;
		case 'GLT2'
            fobj = @GLT2;
		case 'GLT3'
            fobj = @GLT3;
		case 'GLT4'
            fobj = @GLT4;
		case 'GLT5'
            fobj = @GLT5;
		case 'GLT6'
            fobj = @GLT6;
        case 'DTLZ1_3'
            fobj = @DTLZ1;
		case 'DTLZ2_3'
            fobj = @DTLZ2;
		case 'DTLZ3_3'
            fobj = @DTLZ3;
		case 'DTLZ4_3'
            fobj = @DTLZ4;
		case 'DTLZ5_3'
            fobj = @DTLZ5;
		case 'DTLZ6_3'
            fobj = @DTLZ6;
		case 'CONSTR'
            fobj = @CONSTR;
        case 'BNH'
            fobj = @BNH;	
        case 'SRN'
            fobj = @SRN;
        case 'OSY'
            fobj = @OSY;	
         case 'disk'
            fobj = @disk;
        case 'BAR4TRUSS'
            fobj = @BAR4TRUSS;	
        otherwise
            fobj = @UF1;
    end
end

%% UF1
% x and y are columnwise, the imput x must be inside the search space and
% it could be a matrix
function y = UF1(x)
    [dim, num]  = size(x);
    tmp         = zeros(dim,num);
    tmp(2:dim,:)= (x(2:dim,:) - sin(6.0*pi*repmat(x(1,:),[dim-1,1]) + pi/dim*repmat((2:dim)',[1,num]))).^2;
    tmp1        = sum(tmp(3:2:dim,:));  % odd index
    tmp2        = sum(tmp(2:2:dim,:));  % even index
    y(1,:)      = x(1,:)             + 2.0*tmp1/size(3:2:dim,2);
    y(2,:)      = 1.0 - sqrt(x(1,:)) + 2.0*tmp2/size(2:2:dim,2);
    clear tmp;
end

%% UF2
% x and y are columnwise, the imput x must be inside the search space and
% it could be a matrix
function y = UF2(x)
    [dim, num]  = size(x);
    X1          = repmat(x(1,:),[dim-1,1]);
    A           = 6*pi*X1 + pi/dim*repmat((2:dim)',[1,num]);
    tmp         = zeros(dim,num);    
    tmp(2:dim,:)= (x(2:dim,:) - 0.3*X1.*(X1.*cos(4.0*A)+2.0).*cos(A)).^2;
    tmp1        = sum(tmp(3:2:dim,:));  % odd index
    tmp(2:dim,:)= (x(2:dim,:) - 0.3*X1.*(X1.*cos(4.0*A)+2.0).*sin(A)).^2;
    tmp2        = sum(tmp(2:2:dim,:));  % even index
    y(1,:)      = x(1,:)             + 2.0*tmp1/size(3:2:dim,2);
    y(2,:)      = 1.0 - sqrt(x(1,:)) + 2.0*tmp2/size(2:2:dim,2);
    clear X1 A tmp;
end

%% UF3
% x and y are columnwise, the imput x must be inside the search space and
% it could be a matrix
function y = UF3(x)
    [dim, num]   = size(x);
    Y            = zeros(dim,num);
    Y(2:dim,:)   = x(2:dim,:) - repmat(x(1,:),[dim-1,1]).^(0.5+1.5*(repmat((2:dim)',[1,num])-2.0)/(dim-2.0));
    tmp1         = zeros(dim,num);
    tmp1(2:dim,:)= Y(2:dim,:).^2;
    tmp2         = zeros(dim,num);
    tmp2(2:dim,:)= cos(20.0*pi*Y(2:dim,:)./sqrt(repmat((2:dim)',[1,num])));
    tmp11        = 4.0*sum(tmp1(3:2:dim,:)) - 2.0*prod(tmp2(3:2:dim,:)) + 2.0;  % odd index
    tmp21        = 4.0*sum(tmp1(2:2:dim,:)) - 2.0*prod(tmp2(2:2:dim,:)) + 2.0;  % even index
    y(1,:)       = x(1,:)             + 2.0*tmp11/size(3:2:dim,2);
    y(2,:)       = 1.0 - sqrt(x(1,:)) + 2.0*tmp21/size(2:2:dim,2);
    clear Y tmp1 tmp2;
end

%% UF4
% x and y are columnwise, the imput x must be inside the search space and
% it could be a matrix
function y = UF4(x)
    [dim, num]  = size(x);
    Y           = zeros(dim,num);
    Y(2:dim,:)  = x(2:dim,:) - sin(6.0*pi*repmat(x(1,:),[dim-1,1]) + pi/dim*repmat((2:dim)',[1,num]));
    H           = zeros(dim,num);
    H(2:dim,:)  = abs(Y(2:dim,:))./(1.0+exp(2.0*abs(Y(2:dim,:))));
    tmp1        = sum(H(3:2:dim,:));  % odd index
    tmp2        = sum(H(2:2:dim,:));  % even index
    y(1,:)      = x(1,:)          + 2.0*tmp1/size(3:2:dim,2);
    y(2,:)      = 1.0 - x(1,:).^2 + 2.0*tmp2/size(2:2:dim,2);
    clear Y H;
end

%% UF5
% x and y are columnwise, the imput x must be inside the search space and
% it could be a matrix
function y = UF5(x)
    N           = 10.0;
    E           = 0.1;
    [dim, num]  = size(x);
    Y           = zeros(dim,num);
    Y(2:dim,:)  = x(2:dim,:) - sin(6.0*pi*repmat(x(1,:),[dim-1,1]) + pi/dim*repmat((2:dim)',[1,num]));
    H           = zeros(dim,num);
    H(2:dim,:)  = 2.0*Y(2:dim,:).^2 - cos(4.0*pi*Y(2:dim,:)) + 1.0;
    tmp1        = sum(H(3:2:dim,:));  % odd index
    tmp2        = sum(H(2:2:dim,:));  % even index
    tmp         = (0.5/N+E)*abs(sin(2.0*N*pi*x(1,:)));
    y(1,:)      = x(1,:)      + tmp + 2.0*tmp1/size(3:2:dim,2);
    y(2,:)      = 1.0 - x(1,:)+ tmp + 2.0*tmp2/size(2:2:dim,2);
    clear Y H;
end

%% UF6
% x and y are columnwise, the imput x must be inside the search space and
% it could be a matrix
function y = UF6(x)
    N            = 2.0;
    E            = 0.1;
    [dim, num]   = size(x);
    Y            = zeros(dim,num);
    Y(2:dim,:)  = x(2:dim,:) - sin(6.0*pi*repmat(x(1,:),[dim-1,1]) + pi/dim*repmat((2:dim)',[1,num]));
    tmp1         = zeros(dim,num);
    tmp1(2:dim,:)= Y(2:dim,:).^2;
    tmp2         = zeros(dim,num);
    tmp2(2:dim,:)= cos(20.0*pi*Y(2:dim,:)./sqrt(repmat((2:dim)',[1,num])));
    tmp11        = 4.0*sum(tmp1(3:2:dim,:)) - 2.0*prod(tmp2(3:2:dim,:)) + 2.0;  % odd index
    tmp21        = 4.0*sum(tmp1(2:2:dim,:)) - 2.0*prod(tmp2(2:2:dim,:)) + 2.0;  % even index
    tmp          = max(0,(1.0/N+2.0*E)*sin(2.0*N*pi*x(1,:)));
    y(1,:)       = x(1,:)       + tmp + 2.0*tmp11/size(3:2:dim,2);
    y(2,:)       = 1.0 - x(1,:) + tmp + 2.0*tmp21/size(2:2:dim,2);
    clear Y tmp1 tmp2;
end

%% UF7
% x and y are columnwise, the imput x must be inside the search space and
% it could be a matrix
function y = UF7(x)
    [dim, num]  = size(x);
    Y           = zeros(dim,num);
    Y(2:dim,:)  = (x(2:dim,:) - sin(6.0*pi*repmat(x(1,:),[dim-1,1]) + pi/dim*repmat((2:dim)',[1,num]))).^2;
    tmp1        = sum(Y(3:2:dim,:));  % odd index
    tmp2        = sum(Y(2:2:dim,:));  % even index
    tmp         = (x(1,:)).^0.2;
    y(1,:)      = tmp       + 2.0*tmp1/size(3:2:dim,2);
    y(2,:)      = 1.0 - tmp + 2.0*tmp2/size(2:2:dim,2);
    clear Y;
end

%% UF8
% x and y are columnwise, the imput x must be inside the search space and
% it could be a matrix
function y = UF8(x)
    [dim, num]  = size(x);
    Y           = zeros(dim,num);
    Y(3:dim,:)  = (x(3:dim,:) - 2.0*repmat(x(2,:),[dim-2,1]).*sin(2.0*pi*repmat(x(1,:),[dim-2,1]) + pi/dim*repmat((3:dim)',[1,num]))).^2;
    tmp1        = sum(Y(4:3:dim,:));  % j-1 = 3*k
    tmp2        = sum(Y(5:3:dim,:));  % j-2 = 3*k
    tmp3        = sum(Y(3:3:dim,:));  % j-0 = 3*k
    y(1,:)      = cos(0.5*pi*x(1,:)).*cos(0.5*pi*x(2,:)) + 2.0*tmp1/size(4:3:dim,2);
    y(2,:)      = cos(0.5*pi*x(1,:)).*sin(0.5*pi*x(2,:)) + 2.0*tmp2/size(5:3:dim,2);
    y(3,:)      = sin(0.5*pi*x(1,:))                     + 2.0*tmp3/size(3:3:dim,2);
    clear Y;
end

%% UF9
% x and y are columnwise, the imput x must be inside the search space and
% it could be a matrix
function y = UF9(x)
    E           = 0.1;
    [dim, num]  = size(x);
    Y           = zeros(dim,num);
    Y(3:dim,:)  = (x(3:dim,:) - 2.0*repmat(x(2,:),[dim-2,1]).*sin(2.0*pi*repmat(x(1,:),[dim-2,1]) + pi/dim*repmat((3:dim)',[1,num]))).^2;
    tmp1        = sum(Y(4:3:dim,:));  % j-1 = 3*k
    tmp2        = sum(Y(5:3:dim,:));  % j-2 = 3*k
    tmp3        = sum(Y(3:3:dim,:));  % j-0 = 3*k
    tmp         = max(0,(1.0+E)*(1-4.0*(2.0*x(1,:)-1).^2));
    y(1,:)      = 0.5*(tmp+2*x(1,:)).*x(2,:)     + 2.0*tmp1/size(4:3:dim,2);
    y(2,:)      = 0.5*(tmp-2*x(1,:)+2.0).*x(2,:) + 2.0*tmp2/size(5:3:dim,2);
    y(3,:)      = 1-x(2,:)                       + 2.0*tmp3/size(3:3:dim,2);
    clear Y;
end

%% UF10
% x and y are columnwise, the imput x must be inside the search space and
% it could be a matrix
function y = UF10(x)
    [dim, num]  = size(x);
    Y           = zeros(dim,num);
    Y(3:dim,:)  = x(3:dim,:) - 2.0*repmat(x(2,:),[dim-2,1]).*sin(2.0*pi*repmat(x(1,:),[dim-2,1]) + pi/dim*repmat((3:dim)',[1,num]));
    H           = zeros(dim,num);
    H(3:dim,:)  = 4.0*Y(3:dim,:).^2 - cos(8.0*pi*Y(3:dim,:)) + 1.0;
    tmp1        = sum(H(4:3:dim,:));  % j-1 = 3*k
    tmp2        = sum(H(5:3:dim,:));  % j-2 = 3*k
    tmp3        = sum(H(3:3:dim,:));  % j-0 = 3*k
    y(1,:)      = cos(0.5*pi*x(1,:)).*cos(0.5*pi*x(2,:)) + 2.0*tmp1/size(4:3:dim,2);
    y(2,:)      = cos(0.5*pi*x(1,:)).*sin(0.5*pi*x(2,:)) + 2.0*tmp2/size(5:3:dim,2);
    y(3,:)      = sin(0.5*pi*x(1,:))                     + 2.0*tmp3/size(3:3:dim,2);
    clear Y H;
end

%% CF1
% x and y are columnwise, the imput x must be inside the search space and
% it could be a matrix
function [y,c] = CF1(x)
    a            = 1.0;
    N            = 10.0;
    [dim, num]   = size(x);
    Y            = zeros(dim,num);
    Y(2:dim,:)   = (x(2:dim,:) - repmat(x(1,:),[dim-1,1]).^(0.5+1.5*(repmat((2:dim)',[1,num])-2.0)/(dim-2.0))).^2;
    tmp1         = sum(Y(3:2:dim,:));% odd index
    tmp2         = sum(Y(2:2:dim,:));% even index 
    y(1,:)       = x(1,:)       + 2.0*tmp1/size(3:2:dim,2);
    y(2,:)       = 1.0 - x(1,:) + 2.0*tmp2/size(2:2:dim,2);
    c(1,:)       = y(1,:) + y(2,:) - a*abs(sin(N*pi*(y(1,:)-y(2,:)+1.0))) - 1.0;
    clear Y;
end

%% CF2
% x and y are columnwise, the imput x must be inside the search space and
% it could be a matrix
function [y,c] = CF2(x)
    a           = 1.0;
    N           = 2.0;
    [dim, num]  = size(x);
    tmp         = zeros(dim,num);
    tmp(2:dim,:)= (x(2:dim,:) - sin(6.0*pi*repmat(x(1,:),[dim-1,1]) + pi/dim*repmat((2:dim)',[1,num]))).^2;
    tmp1        = sum(tmp(3:2:dim,:));  % odd index
    tmp(2:dim,:)= (x(2:dim,:) - cos(6.0*pi*repmat(x(1,:),[dim-1,1]) + pi/dim*repmat((2:dim)',[1,num]))).^2;
    tmp2        = sum(tmp(2:2:dim,:));  % even index
    y(1,:)      = x(1,:)             + 2.0*tmp1/size(3:2:dim,2);
    y(2,:)      = 1.0 - sqrt(x(1,:)) + 2.0*tmp2/size(2:2:dim,2);
    t           = y(2,:) + sqrt(y(1,:)) - a*sin(N*pi*(sqrt(y(1,:))-y(2,:)+1.0)) - 1.0;
    c(1,:)      = sign(t).*abs(t)./(1.0+exp(4.0*abs(t)));
    clear tmp;
end

%% CF3
% x and y are columnwise, the imput x must be inside the search space and
% it could be a matrix
function [y,c] = CF3(x)
    a            = 1.0;
    N            = 2.0;
    [dim, num]   = size(x);
    Y            = zeros(dim,num);
    Y(2:dim,:)   = x(2:dim,:) - sin(6.0*pi*repmat(x(1,:),[dim-1,1]) + pi/dim*repmat((2:dim)',[1,num]));
    tmp1         = zeros(dim,num);
    tmp1(2:dim,:)= Y(2:dim,:).^2;
    tmp2         = zeros(dim,num);
    tmp2(2:dim,:)= cos(20.0*pi*Y(2:dim,:)./sqrt(repmat((2:dim)',[1,num])));
    tmp11        = 4.0*sum(tmp1(3:2:dim,:)) - 2.0*prod(tmp2(3:2:dim,:)) + 2.0;  % odd index
    tmp21        = 4.0*sum(tmp1(2:2:dim,:)) - 2.0*prod(tmp2(2:2:dim,:)) + 2.0;  % even index
    y(1,:)       = x(1,:)          + 2.0*tmp11/size(3:2:dim,2);
    y(2,:)       = 1.0 - x(1,:).^2 + 2.0*tmp21/size(2:2:dim,2);
    c(1,:)       = y(2,:) + y(1,:).^2 - a*sin(N*pi*(y(1,:).^2-y(2,:)+1.0)) - 1.0;   
    clear Y tmp1 tmp2;
end

%% CF4
% x and y are columnwise, the imput x must be inside the search space and
% it could be a matrix
function [y,c] = CF4(x)
    [dim, num]  = size(x);
    tmp         = zeros(dim,num);
    tmp(2:dim,:)= x(2:dim,:) - sin(6.0*pi*repmat(x(1,:),[dim-1,1]) + pi/dim*repmat((2:dim)',[1,num]));
    tmp1        = sum(tmp(3:2:dim,:).^2);  % odd index
    tmp2        = sum(tmp(4:2:dim,:).^2);  % even index
    index1      = tmp(2,:) < (1.5-0.75*sqrt(2.0));
    index2      = tmp(2,:)>= (1.5-0.75*sqrt(2.0));
    tmp(2,index1) = abs(tmp(2,index1));
    tmp(2,index2) = 0.125 + (tmp(2,index2)-1.0).^2;
    y(1,:)      = x(1,:)                  + tmp1;
    y(2,:)      = 1.0 - x(1,:) + tmp(2,:) + tmp2;
    t           = x(2,:) - sin(6.0*pi*x(1,:)+2.0*pi/dim) - 0.5*x(1,:) + 0.25;
    c(1,:)      = sign(t).*abs(t)./(1.0+exp(4.0*abs(t)));
    clear tmp index1 index2;
end

%% CF5
% x and y are columnwise, the imput x must be inside the search space and
% it could be a matrix
function [y,c] = CF5(x)
    [dim, num]  = size(x);
    tmp         = zeros(dim,num);
    tmp(2:dim,:)= x(2:dim,:) - 0.8*repmat(x(1,:),[dim-1,1]).*cos(6.0*pi*repmat(x(1,:),[dim-1,1]) + pi/dim*repmat((2:dim)',[1,num]));
    tmp1        = sum(2.0*tmp(3:2:dim,:).^2-cos(4.0*pi*tmp(3:2:dim,:))+1.0);  % odd index
    tmp(2:dim,:)= x(2:dim,:) - 0.8*repmat(x(1,:),[dim-1,1]).*sin(6.0*pi*repmat(x(1,:),[dim-1,1]) + pi/dim*repmat((2:dim)',[1,num]));    
    tmp2        = sum(2.0*tmp(4:2:dim,:).^2-cos(4.0*pi*tmp(4:2:dim,:))+1.0);  % even index
    index1      = tmp(2,:) < (1.5-0.75*sqrt(2.0));
    index2      = tmp(2,:)>= (1.5-0.75*sqrt(2.0));
    tmp(2,index1) = abs(tmp(2,index1));
    tmp(2,index2) = 0.125 + (tmp(2,index2)-1.0).^2;
    y(1,:)      = x(1,:)                  + tmp1;
    y(2,:)      = 1.0 - x(1,:) + tmp(2,:) + tmp2;
    c(1,:)      = x(2,:) - 0.8*x(1,:).*sin(6.0*pi*x(1,:)+2.0*pi/dim) - 0.5*x(1,:) + 0.25;
    clear tmp;
end

%% CF6
% x and y are columnwise, the imput x must be inside the search space and
% it could be a matrix
function [y,c] = CF6(x)
    [dim, num]  = size(x);
    tmp         = zeros(dim,num);
    tmp(2:dim,:)= x(2:dim,:) - 0.8*repmat(x(1,:),[dim-1,1]).*cos(6.0*pi*repmat(x(1,:),[dim-1,1]) + pi/dim*repmat((2:dim)',[1,num]));
    tmp1        = sum(tmp(3:2:dim,:).^2);  % odd index
    tmp(2:dim,:)= x(2:dim,:) - 0.8*repmat(x(1,:),[dim-1,1]).*sin(6.0*pi*repmat(x(1,:),[dim-1,1]) + pi/dim*repmat((2:dim)',[1,num]));    
    tmp2        = sum(tmp(2:2:dim,:).^2);  % even index
    y(1,:)      = x(1,:)            + tmp1;
    y(2,:)      = (1.0 - x(1,:)).^2 + tmp2;
    tmp         = 0.5*(1-x(1,:))-(1-x(1,:)).^2;
    c(1,:)      = x(2,:) - 0.8*x(1,:).*sin(6.0*pi*x(1,:)+2*pi/dim) - sign(tmp).*sqrt(abs(tmp));
    tmp         = 0.25*sqrt(1-x(1,:))-0.5*(1-x(1,:));
    c(2,:)      = x(4,:) - 0.8*x(1,:).*sin(6.0*pi*x(1,:)+4*pi/dim) - sign(tmp).*sqrt(abs(tmp));    
    clear tmp;
end

%% CF7
% x and y are columnwise, the imput x must be inside the search space and
% it could be a matrix
function [y,c] = CF7(x)
    [dim, num]  = size(x);
    tmp         = zeros(dim,num);
    tmp(2:dim,:)= x(2:dim,:) - cos(6.0*pi*repmat(x(1,:),[dim-1,1]) + pi/dim*repmat((2:dim)',[1,num]));
    tmp1        = sum(2.0*tmp(3:2:dim,:).^2-cos(4.0*pi*tmp(3:2:dim,:))+1.0);  % odd index
    tmp(2:dim,:)= x(2:dim,:) - sin(6.0*pi*repmat(x(1,:),[dim-1,1]) + pi/dim*repmat((2:dim)',[1,num]));
    tmp2        = sum(2.0*tmp(6:2:dim,:).^2-cos(4.0*pi*tmp(6:2:dim,:))+1.0);  % even index
    tmp(2,:)    = tmp(2,:).^2;
    tmp(4,:)    = tmp(4,:).^2;
    y(1,:)      = x(1,:)                                  + tmp1;
    y(2,:)      = (1.0 - x(1,:)).^2 + tmp(2,:) + tmp(4,:) + tmp2;
    tmp         = 0.5*(1-x(1,:))-(1-x(1,:)).^2;
    c(1,:)      = x(2,:) - sin(6.0*pi*x(1,:)+2*pi/dim) - sign(tmp).*sqrt(abs(tmp));
    tmp         = 0.25*sqrt(1-x(1,:))-0.5*(1-x(1,:));
    c(2,:)      = x(4,:) - sin(6.0*pi*x(1,:)+4*pi/dim) - sign(tmp).*sqrt(abs(tmp));    
    clear tmp;
end

%% CF8
% x and y are columnwise, the imput x must be inside the search space and
% it could be a matrix
function [y,c] = CF8(x)
    N           = 2.0;
    a           = 4.0;
    [dim, num]  = size(x);
    Y           = zeros(dim,num);
    Y(3:dim,:)  = (x(3:dim,:) - 2.0*repmat(x(2,:),[dim-2,1]).*sin(2.0*pi*repmat(x(1,:),[dim-2,1]) + pi/dim*repmat((3:dim)',[1,num]))).^2;
    tmp1        = sum(Y(4:3:dim,:));  % j-1 = 3*k
    tmp2        = sum(Y(5:3:dim,:));  % j-2 = 3*k
    tmp3        = sum(Y(3:3:dim,:));  % j-0 = 3*k
    y(1,:)      = cos(0.5*pi*x(1,:)).*cos(0.5*pi*x(2,:)) + 2.0*tmp1/size(4:3:dim,2);
    y(2,:)      = cos(0.5*pi*x(1,:)).*sin(0.5*pi*x(2,:)) + 2.0*tmp2/size(5:3:dim,2);
    y(3,:)      = sin(0.5*pi*x(1,:))                     + 2.0*tmp3/size(3:3:dim,2);
    c(1,:)      = (y(1,:).^2+y(2,:).^2)./(1.0-y(3,:).^2) - a*abs(sin(N*pi*((y(1,:).^2-y(2,:).^2)./(1.0-y(3,:).^2)+1.0))) - 1.0;
    clear Y;
end

%% CF9
% x and y are columnwise, the imput x must be inside the search space and
% it could be a matrix
function [y,c] = CF9(x)
    N           = 2.0;
    a           = 3.0;
    [dim, num]  = size(x);
    Y           = zeros(dim,num);
    Y(3:dim,:)  = (x(3:dim,:) - 2.0*repmat(x(2,:),[dim-2,1]).*sin(2.0*pi*repmat(x(1,:),[dim-2,1]) + pi/dim*repmat((3:dim)',[1,num]))).^2;
    tmp1        = sum(Y(4:3:dim,:));  % j-1 = 3*k
    tmp2        = sum(Y(5:3:dim,:));  % j-2 = 3*k
    tmp3        = sum(Y(3:3:dim,:));  % j-0 = 3*k
    y(1,:)      = cos(0.5*pi*x(1,:)).*cos(0.5*pi*x(2,:)) + 2.0*tmp1/size(4:3:dim,2);
    y(2,:)      = cos(0.5*pi*x(1,:)).*sin(0.5*pi*x(2,:)) + 2.0*tmp2/size(5:3:dim,2);
    y(3,:)      = sin(0.5*pi*x(1,:))                     + 2.0*tmp3/size(3:3:dim,2);
    c(1,:)      = (y(1,:).^2+y(2,:).^2)./(1.0-y(3,:).^2) - a*sin(N*pi*((y(1,:).^2-y(2,:).^2)./(1.0-y(3,:).^2)+1.0)) - 1.0;
    clear Y;
end

%% CF10
% x and y are columnwise, the imput x must be inside the search space and
% it could be a matrix
function [y,c] = CF10(x)
    a           = 1.0;
    N           = 2.0;
    [dim, num]  = size(x);
    Y           = zeros(dim,num);
    Y(3:dim,:)  = x(3:dim,:) - 2.0*repmat(x(2,:),[dim-2,1]).*sin(2.0*pi*repmat(x(1,:),[dim-2,1]) + pi/dim*repmat((3:dim)',[1,num]));
    H           = zeros(dim,num);
    H(3:dim,:)  = 4.0*Y(3:dim,:).^2 - cos(8.0*pi*Y(3:dim,:)) + 1.0;
    tmp1        = sum(H(4:3:dim,:));  % j-1 = 3*k
    tmp2        = sum(H(5:3:dim,:));  % j-2 = 3*k
    tmp3        = sum(H(3:3:dim,:));  % j-0 = 3*k
    y(1,:)      = cos(0.5*pi*x(1,:)).*cos(0.5*pi*x(2,:)) + 2.0*tmp1/size(4:3:dim,2);
    y(2,:)      = cos(0.5*pi*x(1,:)).*sin(0.5*pi*x(2,:)) + 2.0*tmp2/size(5:3:dim,2);
    y(3,:)      = sin(0.5*pi*x(1,:))                     + 2.0*tmp3/size(3:3:dim,2);
    c(1,:)      = (y(1,:).^2+y(2,:).^2)./(1.0-y(3,:).^2) - a*sin(N*pi*((y(1,:).^2-y(2,:).^2)./(1.0-y(3,:).^2)+1.0)) - 1.0;
    clear Y H;
end

function [Fit] = ZDT1(X)
     Dim=30;
     Fit = [0; 0];
     g = 1 + 9*sum(X(2:Dim))/(Dim-1);
     Fit(1) = X(1);
     Fit(2) = g*(1-sqrt(X(1)/g));
end

function [Fit] = ZDT2(X)
      Dim=30;
      Fit = [0; 0];
      g = 1 + 9*sum(X(2:Dim))/(Dim-1);
      Fit(1) = X(1);
      Fit(2) = g * ( 1-(X(1)/g)^2);
end

function [Fit] = ZDT3(X)
       Dim=30;
       Fit=[0; 0];
       g = 1 + 9/29*sum(X(2:Dim));%/(Dim-1)
       Fit(1) = X(1);
       Fit(2) = g * ( 1-sqrt(X(1)/g) - X(1)/g*sin(10*pi*X(1)) );
end

function [Fit] = ZDT4(X)
        Fit = [0; 0];
        g = 1 + 10*(10-1);
        for i = 2:10
            g = g + X(i)^2 - 10* cos(4*pi*X(i));
        end
        Fit(1) = X(1);
        Fit(2) = g * (1-sqrt(X(1)/g));
        
%          Dim=30;
%          Fit = [0; 0];
%          g = 1 + 9*sum(X(2:Dim))/(Dim-1);
%          Fit(1) = X(1);
%          Fit(2) = g*(1-sqrt(X(1)/g));
end

function [Fit] = ZDT5(X) % same with ZDT5, maybe wrong or not
%         Dim=30;
%         Fit = [0; 0]; 
%         g = 1 + 9 * (sum(X(2:Dim))/(Dim-1))^0.25;        
%         Fit(1) = 1 - exp(-4*X(1)) * sin(6*pi*X(1))^6;
%         Fit(2) = g * (1 - (Fit(1)/g)^2);
        
         Dim=30;
         Fit = [0; 0; 0];
         g = 1 + 9*sum(X(3:Dim))/(Dim-1);
         Fit(1) = X(1);
         Fit(2) = X(2);
         Fit(3) = g*(1-(X(1)/g)^2)*(1-(X(2)/g)^2);
        
end

function [Fit] = ZDT6(X)
        Dim=30;
        Fit = [0; 0]; 
        g = 1 + 9 * (sum(X(2:Dim))/(Dim-1))^0.25;        
        Fit(1) = 1 - exp(-4*X(1)) * sin(6*pi*X(1))^6;
        Fit(2) = g * (1 - (Fit(1)/g)^2);      
end


%%GLT function:
function [Fit] = GLT1(X)
        Fit = [0; 0]; 
		g=0;
        for i=2:numel(X)
	         g=g+(X(i)-sin(2*pi*X(1)+i/numel(X)*pi))^2;
	    end
	    Fit(1) =(1+g)*X(1);
        Fit(2) =(1+g)*	(2-X(1)-sign(cos(2*pi*X(1))));
end

function [Fit] = GLT2(X)
        Fit = [0; 0]; 
		g=0;
        for i=2:numel(X)
	         g=g+(X(i)-sin(2*pi*X(1)+i/numel(X)*pi))^2;
	    end
	    Fit(1) =(1+g)*(1-cos(X(1)*0.5*pi));
        Fit(2) =(1+g)*	10*(1-sin(X(1)*0.5*pi));
end

function [Fit] = GLT3(X)
        Fit = [0; 0]; 
		g=0;
        for i=2:numel(X)
	         g=g+(X(i)-sin(2*pi*X(1)+i/numel(X)*pi))^2;
	    end
	    Fit(1) =(1+g)*X(1);
        if X(1)<0.05
		   Fit(2) =(1+g)*	(1-19*X(1));
		else
		   Fit(2) =(1+g)*	(1-X(1))/19;
		end
end

function [Fit] = GLT4(X)
        Fit = [0; 0]; 
		g=0;
        for i=2:numel(X)
	         g=g+(X(i)-sin(2*pi*X(1)+i/numel(X)*pi))^2;
	    end
	    Fit(1) =(1+g)*X(1);
        Fit(2) =(1+g)*	(2-2*X(1)^0.5*cos(3*pi*X(1)^2)^2);
end

function [Fit] = GLT5(X)
        Fit = [0; 0]; 
		g=0;
        for i=3:numel(X)
	         g=g+(X(i)+sin(2*pi*X(1)+i/numel(X)*pi))^2;
	    end
	    Fit(1) =(1+g)*(1-cos(0.5*X(1)*pi))*(1-cos(0.5*X(2)*pi));
        Fit(2) =(1+g)*	(1-cos(0.5*X(1)*pi))*(1-sin(0.5*X(2)*pi));
		Fit(2) =(1+g)*(1-sin(0.5*X(1)*pi));
end

function [Fit] = GLT6(X)
        Fit = [0; 0]; 
		g=0;
        for i=3:numel(X)
	         g=g+(X(i)+sin(2*pi*X(1)+i/numel(X)*pi))^2;
	    end
	    Fit(1) =(1+g)*(1-cos(0.5*X(1)*pi))*(1-cos(0.5*X(2)*pi));
        Fit(2) =(1+g)*	(1-cos(0.5*X(1)*pi))*(1-sin(0.5*X(2)*pi));
		Fit(2) =(1+g)*(2-sin(0.5*X(1)*pi)-sign(cos(4*X(1)*pi)));
end

%DTLZ function
 %#1       % shorten values and get the value of k for g(x_M)
function [Fit] = DTLZ1(X)
        n = 7;
        M = 3;
        k = n - M + 1;
        % find g(x_M)
        g = 100*(k + sum((X(1:k)-0.5).^2 - cos(20*pi*(X(1:k)-0.5)))); 
        Fit(1) =0.5*X(1)*X(2)*(1+g);
		Fit(2) =0.5*X(1)*(1-X(2))*(1+g);
		Fit(3) =0.5*(1-X(1))*(1+g);
end

%#2		 % shorten values and get the value of k for g(x_M)
function [Fit] = DTLZ2(X)
        n = 12;
        M = 3;
        k = n - M + 1;

        % find g(x_M)
        g = sum((X(M:n)-0.5)).^2; %sum((X(1:k)-0.5)).^2; 
        Fit(1) =cos(0.5*pi*X(1))*cos(0.5*pi*X(2))*(1+g);
		Fit(2) =cos(0.5*pi*X(1))*sin(0.5*pi*X(2))*(1+g);
		Fit(3) =sin(0.5*pi*X(2))*(1+g);
end		
%#3		% shorten values and get the value of k for g(x_M)
function [Fit] = DTLZ3(X)
        n = 12;
        M = 3;
        k = n - M + 1;

        % find g(x_M)
        g = 100*(k + sum((X(1:k)-0.5).^2 - cos(20*pi*(X(1:k)-0.5)))); 
        Fit(1) =cos(0.5*pi*X(1))*cos(0.5*pi*X(2))*(1+g);
		Fit(2) =cos(0.5*pi*X(1))*sin(0.5*pi*X(2))*(1+g);
		Fit(3) =sin(0.5*pi*X(2))*(1+g);
end		
%#4		% shorten values and get the value of k for g(x_M)
function [Fit] = DTLZ4(X)
        n = 12;
        M = 3;
        k = n - M + 1;
        X = X.^100;

        % find g(x_M)
        g = sum((X(M:n)-0.5)).^2; %sum((X(1:k)-0.5)).^2; 
        Fit(1) =cos(0.5*pi*X(1))*cos(0.5*pi*X(2))*(1+g);
		Fit(2) =cos(0.5*pi*X(1))*sin(0.5*pi*X(2))*(1+g);
		Fit(3) =sin(0.5*pi*X(2))*(1+g);
		
end		
%#5		% shorten values and get the value of k for g(x_M)
function [Fit] = DTLZ5(X)
        n = 12;
        M = 3;
        k = n - M + 1;

        % find g(x_M)
        g = sum(X(1:k).^0.1);
        Fit(1) =cos(0.5*pi*X(1))*cos(0.5*pi*X(2))*(1+g);
		Fit(2) =cos(0.5*pi*X(1))*sin(0.5*pi*X(2))*(1+g);
		Fit(3) =sin(0.5*pi*X(2))*(1+g);		
		
end		
 %#6
 function [Fit] = DTLZ6(X)
		n = 22;
        M = 3;
        k = n - M + 1;

        % find g(x_M)
        g = 1 + (9/k)*sum(X(1:k));
		
		Fit(1) =X(1);
		Fit(2) =X(2);
		h=3-X(1)/(1+g)*(1+sin(3*pi*X(1)))-X(2)/(1+g)*(1+sin(3*pi*X(2)));
		Fit(3) =h*(1+g);
end


 function [Fit] = CONSTR(X)
		g1=6-(X(2)+9*X(1));
		g2=1+(X(2)-9*X(1));
        PCONST=10^1;
		penalty=PCONST*max(0,g1)^2+PCONST*max(0,g2)^2;
		Fit(1) =X(1)+penalty;
		Fit(2) =(1+X(2))/X(1)+penalty;

end

 function [Fit] = SRN(X)
		g1=X(1)^2+X(2)^2-255;
		g2=X(1)-3*X(2)+10;
        PCONST=10^10;
		penalty=PCONST*max(0,g1)^2+PCONST*max(0,g2)^2;
		Fit(1) =2+(X(1)-2)^2+(X(2)-1)^2+penalty;
		Fit(2) =9*X(1)-(X(2)-1)^2+penalty;

end

 function [Fit] = BNH(X)
		g1=(X(1)-5)^2+X(2)^2-25;
		g2=7.7-(X(1)-8)^2-(X(2)+3)^2;
        PCONST=10^10;
		penalty=PCONST*max(0,g1)^2+PCONST*max(0,g2)^2;
		
		Fit(1) =4*X(1)^2+4*X(2)^2+penalty;
		Fit(2) =(X(1)-5)^2+(X(2)-5)^2+penalty;

end

function [Fit] = OSY(X)
		g1=2-X(1)-X(2);
		g2=-6+X(1)+X(2);
		g3=-2-X(1)+X(2);
		g4=-2+X(1)-3*X(2);
		g5=-4+X(4)+(X(3)-3)^2;
		g6=4-X(6)-(X(5)-3)^2;
        PCONST=10^10;
		penalty=PCONST*max(0,g1)^2+PCONST*max(0,g2)^2+PCONST*max(0,g3)^2+PCONST*max(0,g4)^2+PCONST*max(0,g5)^2+PCONST*max(0,g6)^2;
		Fit(1) =X(1)^2+X(2)^2+X(3)^2+X(4)^2+X(5)^2+X(6)^2+penalty;
		Fit(2) =-(25*(X(1)-2)^2+(X(2)-2)^2+(X(3)-2)^2+(X(4)-2)^2+(X(5)-2)^2)  +penalty;

end

function [Fit] = BAR4TRUSS(X)
		Fit(1) =200*(2*X(1)+sqrt(2*X(2))+sqrt(X(3))+X(4));
		Fit(2) =0.01*(2/X(1)+2*sqrt(2)/X(2)-2*sqrt(2)/X(3)+2/X(4));

end


function [Fit] = disk(X)

		g1=20+X(1)-X(2);
		g2=2.5+X(4)+1-30;
		g3=X(3)/(3.14*(X(2)^2-X(1)^2)^2)-0.4;
		g4=(2.22*10^(-3)*X(3)*(X(2)^3-X(1)^3))/(X(2)^2-X(1)^2)^2-1;
        g5=900-(2.66*10^(-2)*X(3)*X(4)*(X(2)^3-X(1)^3))/(X(2)^2-X(1)^2)^2;
		PCONST=10^1;
		penalty=PCONST*max(0,g1)^2+PCONST*max(0,g2)^2+PCONST*max(0,g3)^2+PCONST*max(0,g4)^2+PCONST*max(0,g5)^2;
		Fit(1) =4.9*10^(-5)*(X(2)^2-X(1)^2)*(X(4)-1)+penalty;
		Fit(2) =9.82*10^6*(X(2)^2-X(1)^2)/((X(2)^3-X(1)^3)*X(4)*X(3))+penalty;

end

