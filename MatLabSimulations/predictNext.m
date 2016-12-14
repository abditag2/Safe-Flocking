function [a, c] = predictNext(x,setpt,currentcmd, flag, next_update_period)

currenta = currentcmd(1);
currentc = currentcmd(2);

[T, Y] = ode45(@(t,y)dynamics(t,y,currenta,currentc,flag), [0 next_update_period] ,x);
xnext = Y(end,:);
[a, c] = controlinput(xnext,setpt);

return 