% The Matlab source codes to generate the boudnaries of the test instances
%   for CEC 2009 Multiobjective Optimization Competition. 
% Please refer to the report for correct one if the source codes are not
%   consist with the report.
% History:
%   v1 Sept.05 2008

function range = xboundary(name,dim)

    range = ones(dim,2);
    
    switch name
        case {'UF1','UF2','UF5','UF6','UF7','CF2'}
            range(1,1)      =  0;
            range(2:dim,1)  = -1;
        case {'UF3','ZDT1','ZDT2','ZDT3','ZDT4','ZDT5','ZDT6'}
            range(:,1)      =  0;  
        case {'DTLZ1_3','DTLZ2_3','DTLZ3_3','DTLZ4_3','DTLZ5_3','DTLZ6_3','active_learning'}
            range(:,1)      =  0; 
        case {'GLT1','GLT2','GLT3','GLT4','GLT5','GLT6'}
            range(:,1)      =  0; 
        case {'UF4','CF3','CF4','CF5','CF6','CF7'}
            range(1,1)      =  0;
            range(2:dim,1)  = -2;
            range(2:dim,2)  =  2; 
        case {'UF8','UF9','UF10','CF9','CF10'}
            range(1:2,1)    =  0;
            range(3:dim,1)  = -2;
            range(3:dim,2)  =  2;   
        case 'CF1'
            range(:,1)      =  0; 
        case {'CF8'}
            range(1:2,1)    =  0;
            range(3:dim,1)  = -4;
            range(3:dim,2)  =  4;  
        case {'Self_define'}
            range(1,1)    =  110;range(1,2)    =  140;
            range(2,1)    =  22;range(2,2)    =  28;
            range(3,1)    =  0.3;range(3,2)    =  0.6;  	
        case {'Self_define2'}
            range(1:dim,1)    =  -0.5;
            range(1:dim,2)    =  0.5;
       case {'CONSTR'}
            range(1,1)  =0.1;
            range(2,1)  = 0;	
			range(2,2)  = 5;
		case {'BNH'}
            range(1:2,1)  =0;
			range(1,2)  = 5;
			range(2,2)  = 3;
        case {'SRN'}
            range(1:dim,1)  = -20;
            range(1:dim,2)  = 20;
        case {'OSY'}
            range(1:2,1)  =0;range(4,1)  =0;	
            range(3,1)  =1; range(5,1)  =1;range(6,1)  =0;	
			range(1:2,2)  =10; range(3,2)  =5;range(4,2)  =6;	
			range(5,2)  =5;range(6,2)  =10;	
		 case {'disk'}
            range(1,1)  =55;range(1,2)  =80;
			range(2,1)  =75;range(2,2)  =110;
            range(3,1)  =1000;  range(3,2)  =3000;			
			range(4,1)  =2;range(4,2)  =20;	
		case {'BAR4TRUSS'}	
		    range(1,1)  =1;range(1,2)  =3;
			range(2:3,1)  =1.4142;range(2:3,2)  =3;
            range(4,1)  =1;range(4,2)  =3;
    end
end