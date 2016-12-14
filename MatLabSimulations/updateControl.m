function [control] = updateControl(state,dest)
%% Update Control Periodically
global para
control = zeros(para.N,2);
for i = 1:para.N
    [control(i,1), control(i,2)] = controlinput(state(i,:),dest(i,:));
end
return