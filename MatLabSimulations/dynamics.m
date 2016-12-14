function dxdt = dynamics(t,x,a,c,flag)
global para;
dxdt = zeros(4,1);
if ~flag
    dxdt(1) = x(3)*cos(x(4));   % x 
    dxdt(2) = x(3)*sin(x(4));   % y
    dxdt(3) = a;                % v
    dxdt(4) = x(3)*c;           % theta 
else
    dxdt(1) = x(3)*cos(x(4));                       % x 
    dxdt(2) = x(3)*sin(x(4));                       % y
    dxdt(3) = max(-5*x(3),para.abnd(1));                                % v
    dxdt(4) = 0;                                    % theta 
end
if(x(3)>para.vbnd(2))
    dxdt(3) = para.abnd(1);
elseif(x(3)<para.vbnd(1))
    dxdt(3) = para.abnd(2);
end
