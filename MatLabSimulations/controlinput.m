function [a, c] = controlinput(x,setpt)
%% control parameters
global para;
k1 = 0.25; k2 = 0.8;

%% vectors and forces
dir = [cos(x(4)) sin(x(4))];
nor = [cos(x(4)+pi/2) sin(x(4)+pi/2)];
F = k1 * (setpt-x(1:2)) - k2* x(3)* dir;
Fd = dot(dir, F);
Fn = dot(nor, F);
%% control
a = Fd;
if x(3) == 0
    v = 0.2;
else
    v = x(3);
end
c = 2.5* Fn/v^2;
%% in case of U turn
if dot(dir,setpt-x(1:2))<0 && norm(setpt-x(1:2))>= 1
    a = 0.5*norm(setpt-x(1:2));
    turn_sign = cross([dir 0], [setpt-x(1:2) 0]);
    c = sign(turn_sign(3))* para.cbnd(2);
end
    
%% bounds
if x(3)>=para.vbnd(2) && a>=0
    a= k1 * (para.vbnd(2) - x(3));
elseif x(3)<=para.vbnd(1) && a<=0
    a= -k1 * (para.vbnd(1) + x(3));
end

a = max(a,para.abnd(1));
a = min(a,para.abnd(2));
c = max(c,para.cbnd(1));
c = min(c,para.cbnd(2));

