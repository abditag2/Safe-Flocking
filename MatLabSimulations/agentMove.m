function [newstate] = agentMove(state,control,stopping_flag)
global para;
%% Agents Move
newstate = zeros(para.N,4);
for i = 1:para.N
    x0 = state(i,:);
    a = control(i,1);
    c = control(i,2);
    flag = stopping_flag(i);
    [T, Y] = ode45(@(t,y)dynamics(t,y,a,c,flag),para.tspan,x0);
    newstate(i,:) = Y(end,:);
end
return
