function obj=mo_test_function(x,M,fun)
global     dim  

% ZDT3
if strcmp(fun,'ZDT3')
    y=x(2:end);
    gx=1+9*sum(y)/(dim-1);
    obj(1)=x(1);
    obj(2)=gx*(1-sqrt(x(1)/gx)-x(1)/gx*sin(10*pi*x(1)));
end





