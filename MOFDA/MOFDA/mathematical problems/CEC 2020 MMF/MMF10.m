function y=MMF10(x)
% dim=2;
% lb=[0.1,0.1];
% ub=[1.1,1.1];
% obj=2;    
% 1global PS and 1 local PS 
y=zeros(2,1);
g=2-exp(-((x(2)-0.2)/0.004).^2)-0.8*exp(-((x(2)-0.6)/0.4).^2);
y(1)=x(1);
y(2)=g/x(1);
end

