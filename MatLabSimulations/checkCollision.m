function [flag,index] = checkCollision(state)
global para;
flag = false; index = [];
for i=1:para.N-1
    for j = i+1: para.N
        dist = norm(state(i,1:2)-state(j,1:2),2);
        if dist < para.sep
            flag = true;
            index = [index; i j];
        end
    end
end

return