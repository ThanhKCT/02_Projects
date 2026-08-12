function y=MMF12(x)
% dim=2;
% lb=[0,0];
% ub=[1,1];
% obj=2;    
% Discontinuous PF
q=4;%
Alfa=2;%
y=zeros(2,1);
y(1)=x(1);%
%  g=1+10*x(2);%
%  g=2-exp(-((x(2)-0.2)/0.004).^2)-0.8*exp(-((x(2)-0.6)/0.4).^2);
num_of_peak=2;
g=2-((sin(num_of_peak*pi.*x(2))).^6)*(exp(-2*log10(2).*((x(2)-0.1)/0.8).^2));
h=1-(y(1)/g)^Alfa-(y(1)/g)*sin(2*pi*q*y(1));
y(2)=g*h;
end
