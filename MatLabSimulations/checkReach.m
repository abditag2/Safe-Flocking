function flag = checkReach(state,dest)
flag = false;
dif = state(:,1:2) - dest;
if norm(dif,inf)<=0.2
    flag = true;
end

end