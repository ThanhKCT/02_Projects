function Obj = MMF8(Var)
% dim=2;
% lb=[-pi,0];
% ub=[pi,9];
% obj=2;    
Obj = zeros(2,1);
if Var(2)>4
   Var(2)=Var(2)-4;
end
Obj(1)    = sin(abs(Var(1)));             
Obj(2)    = sqrt(1.0 - (sin(abs(Var(1)))).^2) + 2.0*(Var(2)-(sin(abs(Var(1)))+abs(Var(1)))).^2;
end